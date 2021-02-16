import './styles'
import store from './store'
import './editor'
import {start} from './pmeditor/pmeditor'
import {DOMSerializer} from 'prosemirror-model'
import {promptRef} from './prompt'
import {toElement} from "./helper"
import clouds from './icons/cloudz.svg'

const icons = {
	edit: import("./icons/edit.svg"),
}


tag ControlBar
	prop id

	<self>
		<div[d:hflex g:8px]>
			<svg[w:19px h:19px p:4px rd:full] [bg@hover:white] @click=emit("delete", {id}) src=icons.edit> 
			<svg[w:19px h:19px p:4px rd:full] @click=emit("edit", {id}) src=icons.edit> 

tag Block
	prop content
	prop createdAt
	prop selected

	css * m:0

	def mount
		let frag = toElement content, do(name, detail) emit(name, detail)
		$c.replaceWith(frag)

	def render
		<self.text[d:hflex jc:space-between]>
			<div$c[m:0]>
			# <ControlBar>


tag Thread
	prop title
	prop content
	prop id

	hover = false

	css .title  rd:4px p:2px flg:1 cursor:pointer
		.thread d:hflex p:40px jc:space-between
		
	def mount
		$title.replaceWith toElement title, emit 
		
	
	<self[d:hflex jc:space-between cursor:pointer] @click=emit("open", {id: id})>
		<div.heading>
			<div$title>
		# <ControlBar id=id>


tag Edit
	prop content\string

	def mount
		$box.focus!

	def render
		<self>
			<textarea$box bind=content> 


tag stream-view
	// Array of filter runs them by order until one of them return true
	prop contentFilters

	css .center d:grid place-items:center
		.stream d:vflex w:512px pos:relative of:auto
		.editor h:13rem max-height:12rem fls:0 bg:$darkest mb:2 c:$light rd:6px of:auto
			
	newBlock = ''
	focusedItemMeta = null
	editingItem = null
	editor = ''
	editing? = false

	get mergeable?
		store.selectedItems.size > 0
	
	get editable?
		focusedItem

	get focused
		if focusedItemMeta..id
			store.getItem focusedItemMeta.id

	def consumedByContentFilters txtContent, id
		for cf in contentFilters ?? []
			if cf {txt: txtContent, blockId: id }
				return true
		return false
		

	def add
		let content = store.editor.view.state.doc.textContent
		if content is "" 
			return
		let id = await store.appendBlock {content: store.editor.contentHtml!, refs: store.editor.refs}
		if consumedByContentFilters content, id
			imba.commit!
			
		store.editor.loadHtml <>
		setTimeout(&, 80) do
			document.getElementById(id).scrollIntoView {behavior: "smooth", block: "end", inline: "nearest"}

	def isFocused id
		focusedItemMeta..id is id
		
	def scrollToFocused alsoFocus = true
		if alsoFocus
			document.getElementById(focusedItemMeta..id).focus!

	def changeFocus e, down?
		if editing?
			return
		e.preventDefault!

		if down?
			let i = focusedItemMeta..i ?? -2
			if i is -2 and store.fleeting.byTime.length > 0
				i = -1
			if i isnt -2 and i < store.fleeting.byTime.length - 1
				focusedItemMeta = {i: i + 1, id: store.fleeting.byTime[i + 1]}
				document.getElementById(focusedItemMeta.id).focus!
				scrollToFocused!
		else
			let i = focusedItemMeta..i ?? -1 
			if i > 0
				focusedItemMeta = {i: i - 1, id: store.fleeting.byTime[i - 1]}
				document.getElementById(focusedItemMeta.id).focus!
				scrollToFocused!

	def focusTo id, i
		if editing?
			return
		focusedItemMeta = {id, i} 

	def focusDown e
		changeFocus e, true

	def focusUp e
		changeFocus e, false
	
	def scrollBottom
		$strim.scrollTop = $strim.scrollHeight
	
	def focusLast
		focusedItemMeta = store.lastFleetingInfo
		
			
	def toggleFocused
		let id = focusedItemMeta..id
		if id..startsWith "F#"
			if store.selectedItems.has id
				store.selectedItems.delete id
			else
				store.selectedItems.add id
				console.log "HERE ", store.selectedItems
			
			
	def cancelEditing
		if !editing?
			return
		delete focusedItem.editing
		
		store.selectedItems.clear!
		editing? = false
		editor = ''
		$strim.focus!
	
	def onEnter
		if mergeable?
			emit("merge", store.selectedItems)
		elif editable? and focusedItem.kind is "thread"
			emit("edit", {id: focusedItem.id})
		elif editable? and focusedItem.kind is "block"
			focusedItem.editing = true
			editing? = true


	def insertRef
		console.log store.editor.refs
		let {ok, id, title} = await promptRef $strim 
		if ok
			store.editor.insertRef {id, label: title}
		store.editor.view.focus!


	def mount
		let cbs = {
			onRefTrigger: do insertRef!
			onFocus: do(view, e)
				focusLast!
				scrollToFocused false
			onRefClick: do
				console.log "REF CLICK" + $1
		}
		store.editor = start {mount: $noteEditor}, <>, cbs

	
	def unmount
		store.editor.view.destroy!
			
	
	<self.center @keydown.esc.prevent=cancelEditing>
		<div[d:hflex m:4 h:100%]>
			<div.stream[bg:$pavion-bg pl:4 pr:4 rd:2]>
				<div$strim[flg:1 h:300px ofy:auto ofx:hidden mb:10px] 
					tabIndex=1 
					@keydown.down=focusDown
					@keydown.up=focusUp
					@keydown.enter.prevent=onEnter
					@keydown.space.prevent=toggleFocused> for id, i in store.fleeting.byTime
						<ItemView$item#{id} @click=(focusTo id, i) item=(store.getItem id) selected=(store.selectedItems.has id) i=i isFocused=isFocused(id)>
				<div[d:hflex]>
					<div$noteEditor.editor[pl:10px flg:1 bdr:0 rdr:0 max-width:460px of:auto] @focus=(do focusLast) @keydown.shift.enter=add>
					<div[d:vflex bg:$pavion-bg w:40px mb:2 rdr:2  box-sizing:border-box g:4px]>
						<div[flg:1]>
						<button[bg:none] @click=onEnter disabled=!mergeable?> <svg[c:$darkest] [c:gray7]=!mergeable? src="./icons/merge.svg">
						<button[bg:none] @click=insertRef> <svg[c:$darkest] src="./icons/plus.svg">
						<button[bg:none]> <svg[c:$darkest] src="./icons/qmark.svg">
						<button[bg:none mb:8px] @click=add> <svg[c:$darkest] src="./icons/send.svg">


tag ItemView < div
	prop item
	prop i
	prop selected
	prop isFocused

	css .item p:12px of:auto rd:4px pl:6px pr:6px m:4px bg:none @hover:#001514 c:$darkest @hover:$light
		* m:0		
	
	def render
		<self.item [bg:$light c:$darkest]=selected tabIndex=(isFocused ? 0 : -1)>
			if item._id.startsWith "T#"
				<Thread title=item.title content=item.content id=item._id>
			else
				if item.editing
					<inline-block-editor blockId=item._id>
				else
					<Block content=item.content>
