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



# tag Item
# 	prop id
	
# 	def mount
# 		console.log "ID {id}"

# 	<self[bg:gray3 c:black m:8px] @click.emit("close", {id: id})>
# 		<div$c innerHTML="<div>{id}</div>">

# tag App
# 	itemz = []


# 	def cloze id
# 		console.log id
# 		itemz = itemz.filter do $1 isnt id
# 		# itemz.splice i, 1
# 		console.log "ITEMZ AFTER {itemz}"

# 	def render
# 		<self[d:hflex bg:black] @close=(do cloze $1.detail.id)  >
# 			<button[fls:1] @click=(do itemz.push("item-{itemz.length}"))> "OPEN"
# 			for id in itemz
# 				<Item id=id $key=id>


tag App
	
	css .editor bg:$pavion-bg c:black ml:4

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
		<self.bg-pavion[of:auto d:flex h:100%] 
			@keydown.esc.prevent=cancelEdit 
			@close-editor=cancelEdit
			@edit=(do 
				threadId = $1.detail.id
				editor = "thread")
			@close=(do closeThread $1.detail.id)
			@open=(do openThread $1.detail.id)>
		
			<div[d:hflex jc:center flg:1  m:20px]>
				<div[d:flex pos:relative]>
					<div#overlay.overlay[d:none]>
					<svg[fill:black w:50px] src="./icons/cloudz.svg">
					switch editor
						when "thread"
							<thread-editor.editor threadId=threadId>
						when "merge"
							<merge-editor.editor items=Array.from(mergingItems)>
						else
							stream = <stream-view
								contentFilters=[todoFilter, questionFilter]
								@merge=(do 
									mergingItems = $1.detail
									editor = "merge")>
							stream

				<div[flg:1  mb:4 d:hflex gap:12px of:auto ml:16px]> for id in openThreads
					<Thread $key=id id=id>
			<div>



imba.mount <App>