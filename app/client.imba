import "./stream"
import "./plugins/index"
import store from "./store"
import {Thread} from "./thread"
import {RefPrompt} from "./prompt"

def todoFilter {txt, blockId}
	switch txt.slice(-2)
		when "!d"
			store.addTodo {id: blockId, due: "day"}
			true
		when "!w"
			store.addTodo {id: blockId, due: "week"}
			true
		when "!m"
			store.addTodo {id: blockId, due: "month"}
			true
		when "!!"
			store.addTodo {id: blockId, due: "year"}
			true
		else
			false

def questionFilter {txt, blockId}
	if txt.endsWith("?")
		store.addQuestion blockId
		return true
	false



tag App
	editor = ""
	mergingItems = []
	threadId = ""
	openThreads = []
	stream = null

	def cancelEdit
		editor = ""
		store.selectedItems.clear!
		store.editor.view.focus!
		stream.scrollBottom!

	
	def openThread id
		if !openThreads.includes id
			openThreads.push id

	def closeThread id
		openThreads = openThreads.filter do $1 isnt id


	

	def render
		<self[of:auto] 
			@keydown.esc.prevent=cancelEdit 
			@close-editor=cancelEdit
			@edit=(do 
				threadId = $1.detail.id
				editor = "thread")
			@close=(do closeThread $1.detail.id)
			@open=(do openThread $1.detail.id)>
		
			<div.bg-pavion[d:hflex jc:center h:100%]>
				# <plugins-view[flg:1] 
				# 	@questionDelete=(do store.deleteQuestion($1.detail.id))>
				
				<div[pos:relative mt:4 mb:4]>
					switch editor
						when "thread"
							<thread-editor.overlay threadId=threadId>
						when "merge"
							<merge-editor.overlay items=Array.from(mergingItems)>

					<div#overlay.overlay[d:none]>
					stream = <stream-view
						contentFilters=[todoFilter, questionFilter]
						@merge=(do 
							mergingItems = $1.detail
							editor = "merge")>

				<div[flg:1 mt:4 mb:4 d:hflex gap:12px of:auto ml:16px]> for id in openThreads
					<Thread $key=id id=id>



imba.mount <App>