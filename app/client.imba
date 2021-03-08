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


def syncError e
	console.error "ERROR{e}"

let db = null
let todos = []

def sync()
	# syncDom.setAttribute('data-sync-state', 'syncing');
	console.log "SYNCING"
	# let opts = {live: true};
	# db.replicate.to(remote, opts, syncError);
	# db.replicate.from(remote, opts, syncError);

def allDocs dbx
	dbx.allDocs({include_docs: true, descending: true}, do(err, doc) todos =  doc.rows)


def addTodo dbx, text
	let todo = 
		_id: new Date().toISOString(),
		title: text,
		completed: false
	dbx.put(todo, do(err, result) 
		if (!err)
			console.log('Successfully posted a todo!'))


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
		<self[of:auto d:flex h:100% bg:$dark-gray1] 
			@keydown.esc.prevent=cancelEdit 
			@close-editor=cancelEdit
			@edit=(do 
				threadId = $1.detail.id
				editor = "thread")
			@close=(do closeThread $1.detail.id)
			@open=(do openThread $1.detail.id)>
			# <thread-joystick>
			<div[d:hflex jc:center flg:1  m:20px] route=''>
				<div[d:flex pos:relative]>
					<div#overlay.overlay[d:none]>
					# <svg[fill:$light-gray1 w:50px] src="./icons/cloudz.svg">
					switch editor
						when "thread"
							<thread-editor.editor threadId=threadId>
						when "merge"
							<merge-editor.editor[pos:absolute bg:$light-gray1 t:0 h:100% zi:2] items=Array.from(mergingItems)>
						else
							stream = <stream-view
								contentFilters=[todoFilter, questionFilter]
								@merge=(do 
									mergingItems = $1.detail
									editor = "merge")>

				<div[mb:4 d:hflex gap:12px of:auto ml:16px]> for id in openThreads
					<Thread $key=id id=id>
			<div route='/settings'> "VIIIIIIII"
			<div>



imba.mount <App>