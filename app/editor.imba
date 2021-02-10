import store from './store'
import {start} from './pmeditor/pmeditor'
import {promptRef} from "./prompt"


def toElement content
	document.createRange().createContextualFragment content

tag inline-block-editor < div
	prop blockId

	editor

	get block
		store.items.byId[blockId]

	def mount
		let cbs = {
			onRefTrigger: do emit('prompt')
			onFocus: do(),
			onRefClick: do emit('open', {id: $1})
		}
		let content = toElement block.content
		editor = start {mount: $editor}, content, cbs
		editor.view.focus!

	def unmount
		editor.view.destroy!

		
	def render
		<self>
			<div>
				<div$editor>
		

tag merge-editor
	prop items
	
	contentEditor
	titleEditor
	title = ""

	def mount
		let cbs = {
			onRefTrigger: do emit('prompt')
			onFocus: do(),
			onRefClick: do emit('open', {id: $1})
		}

		items = items.map do store.getItem $1

		let content = document.createDocumentFragment()
		
		items
			.map(do toElement $1.content)
			.forEach(do content.append $1)
				
		contentEditor = start {mount: $contentEditor}, content, cbs
		contentEditor.view.focus!
		imba.commit!

	
	def merge
		let t = {title: title, content: contentEditor.contentHtml!, refs: []}
		store.appendThread t
		emit 'close-editor'

	def insertRef
		let {ok, id, title} = await promptRef!
		if ok
			contentEditor.insertRef {id, label: title}
		contentEditor.view.focus!

		
	def unmount
		contentEditor..view.destroy!
		titleEditor..view.destroy!
	
	<self[d:vflex jc:flex-start w:512px mb:0] @prompt.stop=insertRef @keydown.shift.enter=merge>
		<div>
			<input[bg:gray] type="text" bind=title>
			<div$contentEditor>



tag thread-editor
	prop threadId

	get thread
		store.items.byId[threadId]

	def mount
		$title.value = thread.title
		

	def render
		<self[zi:2]>
			<textarea$title>
			<inline-block-editor blockId=threadId>
