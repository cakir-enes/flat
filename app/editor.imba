import store from './store'
import {start} from './pmeditor/pmeditor'
import {promptRef} from "./prompt"
import close from "./icons/close.svg"
import check from "./icons/check.svg"

def toElement content
	document.createRange().createContextualFragment content

tag inline-block-editor
	prop blockId
	css * m:0

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

	
	def finishEditing
		store.editBlock {id: blockId, content: editor.contentHtml!}
		emit 'close-editor'

	def insertRef
		let {ok, id, title} = await promptRef $parent
		if ok
			editor.insertRef {id, label: title}
		editor.view.focus!

	<self @keydown.shift.enter=finishEditing @prompt.stop=insertRef>
		<div$parent[pos:relative]>
			<div$editor[h:100% bd:0 bg:none of:auto]>
	

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
	
	<self[d:vflex jc:flex-start mb:0 ml:0 width:65ch] @prompt.stop=insertRef @keydown.shift.enter=merge>
		<div[d:hflex]>
			<input.heading[p:4 w:100% of:auto flg:1] placeholder="What's this all about?" type="text" bind=title>
			<button[d:hflex ai:center h:min-content mt:4]> 
				<svg[w:24px h:24px] @click=merge src=check>
				"Merge"
			<button[w:36px h:36px mt:2 d:hflex ai:center]> <svg[c:$red2] @click.emit-close-editor src=close>
		<div$contentEditor[of:auto]>



tag thread-editor
	prop threadId
	
	editor

	get thread
		store.getItem threadId

	def mount
		let cbs = {
			onRefTrigger: do emit('prompt')
			onFocus: do(),
			onRefClick: do emit('open', {id: $1})
		}
		let content = toElement thread.content
		editor = start {mount: $editor}, content, cbs
		editor.view.focus!
		$title.value = thread.title
		
	
	def unmount
		editor.view.destroy!

	
	def finishEditing
		await store.updateThread {id: threadId, title: $title.value, content: editor.contentHtml!, refs: editor.refs}
		emit 'cancel'

	def insertRef
		let {ok, id, title} = await promptRef $parent
		if ok
			editor.insertRef {id, label: title}
		editor.view.focus!


	<self[d:vflex jc:flex-start mb:0 bd:0] 
		@keydown.esc.stop.emit-cancel 
		@keydown.shift.enter=finishEditing 
		@prompt.stop=insertRef>
		<div[d:hflex]>	
			<input$title.heading[flg:1 w:100% bd:0 of:auto ml:4px]>
			<svg.icon @click=finishEditing src="./icons/check.svg">
			<svg.icon @click.emit-cancel src=close>
		<div$parent[pos:relative flg:1 m:0]>
			<div$editor[h:100% bd:0 bg:none m:0]>
		
			
