import { Schema, DOMParser, DOMSerializer } from 'prosemirror-model'
import { findWrapping } from 'prosemirror-transform'
import { toggleMark, baseKeymap, chainCommands, newlineInCode, liftEmptyBlock, splitBlock } from 'prosemirror-commands'
import { keymap } from 'prosemirror-keymap'
import { EditorView } from 'prosemirror-view'
import { history, undo, redo } from 'prosemirror-history'
import { EditorState, AllSelection } from 'prosemirror-state'
import {refPlugin} from './refPlugin'
import {schema} from './schema'


const histKeymap = keymap { 'Mod-z': undo, 'Mod-y': redo }

const shortcuts = keymap {
	"Mod-b": toggleMark(schema.marks.strong),
	"Mod-e": toggleLink,
	"Ctrl-.": do(s, d) 
		_insertRef s, d, {label: "LABEL", id: "IDD"}
}

let remHardBreakAndInsertParag = do |state, dispatch|
	let {$from} = state.selection
	if $from.parent.type isnt schema.nodes.paragraph
		return false
	if $from.nodeBefore..type isnt schema.nodes.hard_break
		return false
	if dispatch
		dispatch(state.tr
			.delete($from.pos - $from.nodeBefore..nodeSize ?? 0, $from.pos)
			.replaceSelectionWith(schema.nodes.paragraph.create!)
			.scrollIntoView!)
		
	return true

let insertHardBreak = do |state, dispatch|
	let {$from} = state.selection
	if $from.parent.type isnt schema.nodes.paragraph
		return false
	if dispatch
		dispatch state.tr.replaceSelectionWith(schema.nodes.hard_break.create!).scrollIntoView!
	return true

baseKeymap["Enter"] = chainCommands(newlineInCode, remHardBreakAndInsertParag, insertHardBreak, liftEmptyBlock)
const base = keymap(baseKeymap)


def _insertRef state, dispatch, {label, id}
	let type = schema.nodes.ref
	let {$from} = state.selection
	
	if !$from.parent.canReplaceWith($from.index!, $from.index!, type)
		return false

	let node = type.create {label, id}

	dispatch state.tr.replaceSelectionWith(node)
	return true

def toggleLink state, dispatch
	let {doc, selection} = state
	if selection.empty
		return false
	let attrs = null
	if !doc.rangeHasMark(selection.from, selection.to, schema.marks.link)
		attrs = {href: prompt("Link to where?", "")}
		if !attrs.href
			return false
	return toggleMark(schema.marks.link, attrs)(state, dispatch)
	

def filterRefs node, refs
	if node..type..name is "ref"
		refs.push node.attrs.id
	node.forEach do(child)
		filterRefs child, refs
			

export def start place, content, { onRefTrigger, onFocus, onRefClick }
	let doc = DOMParser.fromSchema(schema).parse content
	let view = new EditorView(place, {
		handleDOMEvents: {
			focus: do(view, e)
						onFocus(view, e)
						return true
		},
		state: EditorState.create({
			schema,
			doc,
			plugins: [histKeymap, base, shortcuts, history(), refPlugin({triggered: onRefTrigger, refClick: onRefClick})]
		})
	})
		
	let contentHtml = do
		const div = document.createElement('div')
		const fragment = DOMSerializer.fromSchema(schema).serializeFragment(view.state.doc.content)
		div.appendChild(fragment)
		return div.innerHTML

	let loadHtml = do |content|
		let domParser = DOMParser.fromSchema(schema)
		let doc = domParser.parse(content)
		let newState = EditorState.create({schema: view.state.schema, doc, plugins: view.state.plugins})
		view.updateState newState
		
	return {
		view
		contentHtml
		loadHtml
		get refs
			let r = []
			filterRefs view.state.doc, r
			return r
				
		insertRef: do(opts)
			_insertRef view.state, view.dispatch, opts
	}
