import store from './store'
import {start} from './pmeditor/pmeditor'
import {promptRef} from "./prompt"


tag inline-block-editor
	prop blockId

	content = ''

	get block
		store.items.byId[blockId]


	def render
		<self>
			<p> "Inline editor" 
				<span$textEditor>
			<div>
				<div$textContent> "Such as this sentence"
			# <textarea$box bind=block.content> 
		

def toElement content
	document.createRange().createContextualFragment content
	
tag merge-editor
	prop items
	
	contentEditor
	titleEditor
	title = ""

	def mount
		let cbs = {
			onRefTrigger: do emit('prompt')
			onFocus: do(),
			onRefClick: do console.log $1
		}

		items = items.map do store.getItem $1

		let content = document.createDocumentFragment()
		
		items
			.map(do toElement $1.content)
			.forEach(do content.append $1)
			
		
		# for item, i in items
		# 	if item.kind is 'block'
		# 		content.append toElement item.content
		# 		# content.insertAdjacentElement "afterend", toElement item.content
		# 	elif item.kind is 'thread'
		# 		let frag = <div[bg:red]> (toElement item.title)
		# 		let f = <ref.ref contenteditable=false> "hole"
		# 		f.setAttribute "ref-id", "vii"
		# 		f.setAttribute "ref-label", "buu"
		# 		content.append f
				
				
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
	
	<self[bg:black] @prompt.stop=insertRef @keydown.shift.enter=merge>
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
		<self[bg:yellow3 zi:2 w:512px h:1024px]>
			<textarea$title>
			for id in thread.content
				<inline-block-editor blockId=id>
