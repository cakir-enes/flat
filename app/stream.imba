import './styles'
import store from './store'
import './editor'
import {start} from './pmeditor/pmeditor'
import {DOMSerializer} from 'prosemirror-model'
import {promptRef} from './prompt'
import {toElement} from "./helper"
import clouds from './icons/cloudz.svg'
import {formatDistance, parseISO} from "date-fns"
import { createPopper } from '@popperjs/core'

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
		<self.text[d:vflex jc:space-between cursor:pointer]>
			<div$c[m:0]>
			<span[ml:auto c:$dark-gray5 fs:sm]> createdAt
			# <ControlBar>


tag Thread < div
	prop title
	prop content
	prop id
	prop createdAt

	hover = false

	css .title  rd:4px p:2px flg:1 cursor:pointer
		.thread d:hflex p:40px jc:space-between
		
	def mount
		$title.replaceWith toElement title, emit 
		
	
	<self[d:vflex jc:space-between cursor:pointer] @click=emit("open", {id: id})>
		<span.heading.link.underline[w:min-content]> <div$title>
		<span[ml:auto c:$dark-gray5 fs:sm]> createdAt


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
		.stream d:vflex w:65ch pos:relative of:auto
		.editor fls:0 bg:none max-height:16rem mb:2 c:$white of:auto bd:none bdt:3px solid $white bdr:0
			flg:1 of:auto max-width:100% o:0.7 @focus:1
		button
			cursor:pointer
			scale@hover:1.1
			
	newBlock = ''
	focusedItemMeta = null
	editingItem = null
	editor = ''
	editing? = false
	showSettings = false

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
	
	def toggle id
		if id..startsWith "F#"
			if store.selectedItems.has id
				store.selectedItems.delete id
			else
				store.selectedItems.add id
		
	def toggleFocused
		let id = focusedItemMeta..id
		if id..startsWith "F#"
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
			<div.stream>
				if showSettings
					<Settings @close.stop=(do showSettings = false)>
				else
					<div$strim[flg:1 h:3px ofy:auto ofx:hidden mb:10px] 
						tabIndex=1 
						@keydown.down=focusDown
						@keydown.up=focusUp
						@keydown.enter.prevent=onEnter
						@keydown.space=toggleFocused> for id, i in store.fleeting.byTime
							<ItemView$item#{id} @click=(do toggle id) item=(store.getItem id) selected=(store.selectedItems.has id) i=i isFocused=isFocused(id)>

				<div[d:vflex flg:2] [h:24px of:hidden]=showSettings>
					<div$noteEditor.editor[flg:0] @focus=(do focusLast) @keydown.shift.enter=add>
					<div[d:hflex fls:0 bg:none mb:2 rdr:2 g:4px]>
						<button> '[Settings]'
						# <button$set[bg:none mt:4px h:16px] @click=(do showSettings = !showSettings)> <svg[c:$light-gray1] src="./icons/cog.svg">
						# <button[h:16px] @click=onEnter disabled=!mergeable?> <svg[c:$light-gray2] [c:gray7]=!mergeable? src="./icons/merge.svg">
						# <button[h:16px] @click=insertRef> <svg[c:$light-gray2] src="./icons/plus.svg">
						# <button[h:16px]> <svg[c:$light-gray2] src="./icons/qmark.svg">
						# <button[h:16px] @click=add> <svg[c:$light-gray2] src="./icons/send.svg">


tag ItemView < div
	prop item
	prop i
	prop selected
	prop isFocused

	css .item of:auto rd:4px pl:6px o:0.6 @focus:1 @hover:1 pr:6px lh:1.4 mt:1.4rem c:$light-gray1 @hover:$light-gray4 @focus:$white
		# bdb:1px solid $dark-gray5 rd:0

	now = new Date()
	
	def render
		<self.item [bg:$light-gray3 c:$black]=selected tabIndex=(isFocused ? 0 : -1)>
			if item._id.startsWith "T#"
				<Thread createdAt=formatDistance(item.createdAt, now) title=item.title content=item.content id=item._id>
			else
				if item.editing
					<inline-block-editor blockId=item._id>
				else
					<Block createdAt=formatDistance(item.createdAt, now) content=item.content>


tag Settings

	url = window.localStorage.getItem "couchdb"

	def save
		window.localStorage.setItem "couchdb", $url.value
		emit('close')
		console.log window.localStorage.getItem "couchdb"

	

	<self[d:vflex flg:1]>
		<h2[fs:3xl fw:bold]> "Settings"
		<div[w:100% h:2px bg:white mb:14px]>
		<h4> "CouchDB URL"
		<input$url[bd: 1px solid $dark-gray5 h:24px c:$white p:14px mt:4px] bind=url type='text' placeholder="https://...">
		<div[flg:1]>
		<button[m:4px rd:4px ml:auto p:4px pl:14px pr:14px bg:$green4] 
			@click=save
			[scale@hover: 1.1 cursor:pointer]> "SAVE"

		