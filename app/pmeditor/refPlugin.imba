import{ Plugin, PluginKey } from 'prosemirror-state';
import { Decoration, DecorationSet } from 'prosemirror-view';



export def refPlugin { key = "[", triggered, refClick }
	let plugKey = new PluginKey('refplug')
	new Plugin {
		
		key: plugKey,
		
		appendTransaction: do(trs, oldState, newState)
		
			let s = plugKey.getState newState
			if s.counter isnt 0 && s.counter % 2 is 0
				const $cursor = newState.selection.$cursor
				triggered!
				s.counter = 0
				newState.tr.delete($cursor.pos - 2, $cursor.pos)
				
			else
				null

		props: {
			handleDOMEvents: {
				
				click: do |view, e|
					if e.target.tagName is "REF"
						refClick e.target.getAttribute("ref-id")
					
			}
			handleKeyDown: do(view, e)
				let s = plugKey.getState view.state
			
				if e.key is "["
					s.counter += 1
				else
					s.counter = 0
				
				return false
		},
		state: {
			init: do {
				counter: 0
			},
			apply: do(tr, val, oldState, newState) val
		}
	}


# let plugKey = new PluginKey('suggestions')
# export def refPlugin
# 	let trigger = triggerCharacter('#')
# 	new Plugin {
# 		key: plugKey,
# 		view: do {
# 			update: do(view, prevState)
# 				const prev = plugKey.getState prevState
# 				const next = plugKey.getState view.state

# 				const moved = prev.active && next.active && prev.range.from !== next.range.from;
# 				const started = !prev.active && next.active;
# 				const stopped = prev.active && !next.active;
# 				const changed = !started && !stopped && prev.text !== next.text;
# 				if next.active
# 					console.log "AHA"
# 					console.log next
# 					# view.dispatch view.state.tr.delete(next.range.to - 2, next.range.to - 1)

# 					# console.log view.dispatch
# 				# tr.delete match.range.to - 2, match.range.to
# 				return false
# 				// Trigger the hooks when necessary
# 				# if (stopped || moved) 
# 				# 	onExit({ view, range: prev.range, text: prev.text });
# 				# if (changed && !moved) 
# 				# 	onChange({ view, range: next.range, text: next.text });
# 				# if (started || moved) 
# 				# 	onEnter({ view, range: next.range, text: next.text });
# 			},
# 		state: {
# 			init: do {
# 				active: false
# 				range: {},
# 				text: null
# 			},

# 			apply: do(tr, prev)
# 				const { selection } = tr
# 				const next = Object.assign {}, prev

# 				let reset = do 
# 					next.range = {}
# 					next.text = null

# 				if selection.from isnt selection.to
# 					next.active = false
# 					reset!
# 					return next

# 				if selection.from < prev.range.from || selection.from > prev.range.to
# 					next.active = false

# 				const $pos = selection.$from
# 				const match = trigger($pos)

# 				if match
# 					next.active = true
# 					next.range = match.range
# 					next.text = match.text
# 				else
# 					next.active = false
# 					reset!
				
# 				return next
# 		},

# 		props: {
# 			handleKeyDown: do |view, event| 
# 				const {active} = this.getState view.state
# 				if !active
# 					return false
# 				return false
			
			
# 			decorations: do |editorState|
# 				const {active, range} = this.getState editorState
# 				if !active
# 					return null
# 				DecorationSet.create(editorState.doc, [
# 					Decoration.inline(range.from, range.to, {
# 						nodeName: "reference",
# 						class: "REFERENCE",
# 						style: 'background rgba(0, 0, 255, 0.05); color: blue; border: 2px solid blue'
# 					})
# 				])
# 		}
# 	}



# def triggerCharacter(char)
# 	let canMatch = false
# 	let tok = null
# 	return do($position) 
# 		let allowSpaces = true
# 		// Matching expressions used for later
# 		const suffix = new RegExp(`\\s${char}$`)
# 		let regexp = allowSpaces ? new RegExp(`{char}.*?(?=\\s{char}|$)`, 'g') : new RegExp(`(?:^)?{char}[^\\s{char}]*`, 'g')
# 		// Lookup the boundaries of the current node
# 		const textFrom = $position.before()
# 		const textTo = $position.end()	
# 		const text = $position.doc.textBetween(textFrom, textTo, '\0', '\0')
# 		let match = null
		
# 		while ((match = regexp.exec(text))) 
# 			// Javascript doesn't have lookbehinds; this hacks a check that first character is " " or the line beginning
# 			const prefix = match.input.slice(Math.max(0, match.index - 1), match.index)
# 			if (!/^[\s\0]?$/.test(prefix)) 
# 				continue
			
# 			// The absolute position of the match in the document
# 			const from = match.index + $position.start()
# 			let to = from + match[0].length
# 			// Edge case handling; if spaces are allowed and we're directly in between two triggers
# 			if (allowSpaces && suffix.test(text.slice(to - 1, to + 1)))
# 				match[0] += ' '
# 				to++
# 			// If the $position is located within the matched substring, return that range
			
# 			if (from < $position.pos && to >= $position.pos)
# 				if canMatch
# 					console.log "MATCH!!!"
# 					return { range: { from, to }, text: match[0] }
# 				console.log "NEXT TIME"
# 				canMatch = true
# 				tok = setTimeout(&, 500) do
# 					canMatch = false
# 				return null


# 		return null
