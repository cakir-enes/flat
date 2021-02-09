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

	css .center d:grid place-items:center h:100%
		.stream d:vflex w:512px pos:relative h:100% of:auto
		.editor h:13rem max-height:12rem fls:0 bg:$darkest mb:2 c:$light rd:6px of:auto
		.cl background-color: #DFDBE5
			fill:white
			background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 28' width='56' height='28'%3E%3Cpath fill='%239C92AC' fill-opacity='0.4' d='M56 26v2h-7.75c2.3-1.27 4.94-2 7.75-2zm-26 2a2 2 0 1 0-4 0h-4.09A25.98 25.98 0 0 0 0 16v-2c.67 0 1.34.02 2 .07V14a2 2 0 0 0-2-2v-2a4 4 0 0 1 3.98 3.6 28.09 28.09 0 0 1 2.8-3.86A8 8 0 0 0 0 6V4a9.99 9.99 0 0 1 8.17 4.23c.94-.95 1.96-1.83 3.03-2.63A13.98 13.98 0 0 0 0 0h7.75c2 1.1 3.73 2.63 5.1 4.45 1.12-.72 2.3-1.37 3.53-1.93A20.1 20.1 0 0 0 14.28 0h2.7c.45.56.88 1.14 1.29 1.74 1.3-.48 2.63-.87 4-1.15-.11-.2-.23-.4-.36-.59H26v.07a28.4 28.4 0 0 1 4 0V0h4.09l-.37.59c1.38.28 2.72.67 4.01 1.15.4-.6.84-1.18 1.3-1.74h2.69a20.1 20.1 0 0 0-2.1 2.52c1.23.56 2.41 1.2 3.54 1.93A16.08 16.08 0 0 1 48.25 0H56c-4.58 0-8.65 2.2-11.2 5.6 1.07.8 2.09 1.68 3.03 2.63A9.99 9.99 0 0 1 56 4v2a8 8 0 0 0-6.77 3.74c1.03 1.2 1.97 2.5 2.79 3.86A4 4 0 0 1 56 10v2a2 2 0 0 0-2 2.07 28.4 28.4 0 0 1 2-.07v2c-9.2 0-17.3 4.78-21.91 12H30zM7.75 28H0v-2c2.81 0 5.46.73 7.75 2zM56 20v2c-5.6 0-10.65 2.3-14.28 6h-2.7c4.04-4.89 10.15-8 16.98-8zm-39.03 8h-2.69C10.65 24.3 5.6 22 0 22v-2c6.83 0 12.94 3.11 16.97 8zm15.01-.4a28.09 28.09 0 0 1 2.8-3.86 8 8 0 0 0-13.55 0c1.03 1.2 1.97 2.5 2.79 3.86a4 4 0 0 1 7.96 0zm14.29-11.86c1.3-.48 2.63-.87 4-1.15a25.99 25.99 0 0 0-44.55 0c1.38.28 2.72.67 4.01 1.15a21.98 21.98 0 0 1 36.54 0zm-5.43 2.71c1.13-.72 2.3-1.37 3.54-1.93a19.98 19.98 0 0 0-32.76 0c1.23.56 2.41 1.2 3.54 1.93a15.98 15.98 0 0 1 25.68 0zm-4.67 3.78c.94-.95 1.96-1.83 3.03-2.63a13.98 13.98 0 0 0-22.4 0c1.07.8 2.09 1.68 3.03 2.63a9.99 9.99 0 0 1 16.34 0z'%3E%3C/path%3E%3C/svg%3E")
		.other 
			bg: red
			bgi:{clouds.url}
			
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
		<div[d:hflex m:4 h:100%]>
			<div[h:100% w:60px mr:2]>
				<svg[fill:black] src="./icons/cloudz.svg">

			<div.stream[bg:$pavion-bg h:100% pl:4 pr:4 rd:2]>
				<div$strim[flg:1 h:300px ofy:auto ofx:hidden] 
					tabIndex=0 
					@keydown.down=focusDown
					@keydown.up=focusUp
					@keydown.enter.prevent=onEnter
					@keydown.space.prevent=toggleFocused> for id, i in store.items.byTime
						<ItemView$item#{id} @click=(focusTo id, i) item=(store.getItem id) selected=(store.selectedItems.has id) i=i isFocused=isFocused(id)>
				
				<div$noteEditor.editor.shadow @focus=(do focusLast) @keydown.shift.enter=add>


tag ItemView < div
	prop item
	prop i
	prop selected
	prop isFocused

	css .item p:12px of:auto rd:4px pl:6px pr:6px m:4px bg:none @hover:#001514 c:$darkest @hover:$light
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
