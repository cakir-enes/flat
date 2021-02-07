import './styles'
import store from './store'
import './editor'
import {start} from './pmeditor/pmeditor'
import {DOMSerializer} from 'prosemirror-model'
import {promptRef} from './prompt'

def toElement content
	document.createRange().createContextualFragment content

const icons = {
	edit: import("./icons/edit.svg")
}


tag ControlBar
	prop id

	<self>
		<div[d:hflex]>
			<svg[stroke:red c:white w:24px h:24px] @click=emit("delete", {id}) src=icons.edit> 
			<svg[stroke:red c:white w:24px h:24px] @click=emit("edit", {id}) src=icons.edit> 

tag Block
	prop content
	prop createdAt
	prop selected

	css * m:0

	def mount
		const frag = document.createRange().createContextualFragment(content)
		$c.replaceWith(frag)

	def render
		<self[d:hflex jc:space-between]>
			<div$c[m:0]>
			<ControlBar>


tag Thread
	prop title
	prop content
	prop id

	hover = false

	css .title  c:$primary rd:4px p:2px c:$cyan flg:1 cursor:pointer
		.thread d:hflex p:40px jc:space-between
		
	def mount
		$title.replaceWith toElement title
		
	
	<self[d:hflex jc:space-between]>
		<div.title @click=emit("open", {id: id})>
			<div$title>
		<ControlBar id=id>


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

	css .center d:grid place-items:center h:100vh bg:$primary
		.stream d:vflex w:512px h:100vh pos:relative
		.editor h:13rem max-height:12rem fls:0 bg:$darkest 
			mb:4px c:$light
			bd:1px solid black rd:6px of:auto


	newBlock = ''
	focusedItemMeta = {i: null, id: null}
	editingItem = null
	editor = ''
	editing? = false

	get mergeable?
		store.selectedItems.size > 0
	
	get editable?
		focusedItem

	get focusedBlock
		store.items.byId[focusedItemMeta.id]

	get nextFocusableBlock
		let i = (focusedItemMeta..i + 1) ?? 0
		const len = store.items.byTime.length
		
		if i == len
			return focusedItemMeta
		
		while i < len
			let id = store.items.byTime[i]
			
			if store.getItem(id).kind is 'block'
				return {i, id}
			i += 1
		
		return focusedItemMeta

	get prevFocusableBlock
		let i = (focusedItemMeta..i - 1) ?? 0
		const len = store.items.byTime.length
		if i < 0
			return focusedBlock
		while i > -1
			let id = store.items.byTime[i]
			if store.getItem(id).kind is 'block'
				return {i, id}
			i -= 1
		return focusedBlock


	def consumedByContentFilters txtContent, id
		for cf in contentFilters ?? []
			if cf {txt: txtContent, blockId: id }
				return true
		return false
		

	def add
		let content = store.editor.view.state.doc.textContent
		if content is "" 
			return
		let id = store.appendBlock store.editor.contentHtml!
		
		if consumedByContentFilters content, id
			imba.commit!
			
		store.editor.loadHtml <>
		setTimeout(&, 80) do
			document.getElementById(id).scrollIntoView {behavior: "smooth", block: "end", inline: "nearest"}

	def isFocused id 
		focusedBlock && focusedBlock.id is id
		
	def scrollToFocused alsoFocus = true
		if !focusedBlock
			return
		if alsoFocus
			console.log "ACTUALLY FOCUSING {focusedBlock.id}"
			document.getElementById(focusedBlock.id).focus!

	def changeFocus e, down?
		if editing?
			return
		e.preventDefault!

		if down?
			let {i, id} = nextFocusableBlock
			focusedItemMeta = { i, id }
			document.getElementById(id).focus!
			scrollToFocused!
		else
			let {i, id} = prevFocusableBlock
			focusedItemMeta = { i, id }
			document.getElementById(id).focus!
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
		focusedItemMeta = {i: null, id: null}
		for i in [store.items.byTime.length - 1 .. 0]
			let id = store.items.byTime[i]
			if store.getItem(id).kind is "block"
				focusedItemMeta = {i, id}
				return
			
	def toggleFocused
		let {id} = focusedItemMeta
		
		if id is undefined or store.getItem(id).kind is 'thread'
			return
		if store.selectedItems.has id
			store.selectedItems.delete id
		else
			store.selectedItems.add id
			
	def cancelEditing
		if !editing?
			return
		delete focusedItem.editing
		
		store.selectedItems.clear!
		editing? = false
		editor = ''
		imba.commit!
		$strim.focus!
	
	def onEnter
		if mergeable?
			emit("merging", store.selectedItems)
		elif editable? and focusedItem.kind is "thread"
			emit("editing", focusedItem.id)
		elif editable? and focusedItem.kind is "block"
			focusedItem.editing = true
			editing? = true

	def mount
		let cbs = {
			onRefTrigger: do 
				let {ok, id, title} = await promptRef!
				if ok
					store.editor.insertRef {id, label: title}
				store.editor.view.focus!

			onFocus: do(view, e)
				focusLast!
				scrollToFocused false
			onRefClick: do
				console.log "REF CLICK" + $1
		}
		store.editor = start {mount: $noteEditor}, <>, cbs
			
	
	<self.center @keydown.esc.prevent=cancelEditing>
		<div.stream> 
			<div$strim[flg:1 ofy:scroll ofx:hidden bdl:2px solid black bdr:2px solid black] 
				tabIndex=0 
				@keydown.down=focusDown
				@keydown.up=focusUp
				@keydown.enter.prevent=onEnter
				@keydown.space.prevent=toggleFocused> for id, i in store.items.byTime
					<ItemView$item#{id} @click=(focusTo id, i) item=(store.getItem id) selected=(store.selectedItems.has id) i=i isFocused=isFocused(id)>
			
			<div$noteEditor.editor.shadow[mt:14px] @focus=(do focusLast) @keydown.shift.enter=add>


tag ItemView < div
	prop item
	prop i
	prop selected
	prop isFocused

	css .item p:12px of:auto bd: 1px solid black rd:4px pl:6px pr:6px m:4px bg:$darkest @hover:#001514
		* m:0
		
	
	def render
		<self.item [bg:$light c:$darkest]=selected tabIndex=(isFocused ? 0 : -1)>
			if item.kind is "thread" 
				<Thread title=item.title content=item.content id=item.id>
			else
				if item.editing
					<inline-block-editor blockId=item.id>
				else
					<Block content=item.content>
