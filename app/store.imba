window.global = window;
window.process = {};
window.process.nextTick = setTimeout;
let PouchDB = require('pouchdb-browser')

def storeGet key
		let o = window.localStorage.getItem key
		if o
			return JSON.parse o
		return null

def storeSet key, o
	window.localStorage.setItem key, JSON.stringify o


def getISOWeekInMonth(date) 
	let d = new Date(+date)
	if (isNaN(d))
		return
	d.setDate(d.getDate() - d.getDay() + 1)
	return {month: +d.getMonth()+1, week: Math.ceil(d.getDate()/7)}


def diff old = [], new_ = []
	{
		added: new_.filter do !old.includes($1)
		deleted: old.filter do !new_.includes($1)
	}
	
	

export default new class
	

	constructor
		# window.localStorage.clear!
		db = {local: null, remote: null}
		items =  {
			byId: {},
			byTime: []
		}
		fleeting = {
			byId: {},
			byTime: []
		}
		threads = {
			byId: {},
			byTime: []
		}
		questions =  []
		backlinks =  {}
		selectedItems = new Set()
		todos =  {today: [], week: [], year: [], month: []}
		streams = {}
		fixTodosByDue!
		initDB!

	
	get lastFleetingInfo
		let s = fleeting.byTime.length - 1
		if s > -1
			{ i: s, id: fleeting.byTime[s] } 
		else
			null

	def fixTodosByDue 
		let date = new Date()
		let {month, week} = getISOWeekInMonth date
		let year = date.getFullYear!

		let yearTodos= todos.year.filter do $1.due is year
		let monthTodos = []
		todos.month.forEach do(t)
			if t.due > month
				yearTodos.push {id: t.id, due: year}
			else
				monthTodos.push t
		
		let weekTodos = []
		todos.week.forEach do(t)
			if t.due > week
				monthTodos.push {id: t.id, due: week}
			else
				weekTodos.push t
		
		let dayTodos = []
		todos.today.forEach do(t)
			if t.due > date.getDay!
				weekTodos.push {id: t.id, due: date.getDay!}
			else
				dayTodos.push t

		todos.today = dayTodos
		todos.week = weekTodos
		todos.year = yearTodos
		storeSet "todos", todos
			
	def initDB
		db.local = new PouchDB('flat')
		
		let getDocsDesc = do(startkey)
			let d = await db.local.allDocs {include_docs: true, descending: true, endkey: startkey, startkey: "{startkey}\uffff"}
			return d.rows
		
		let getDocsAsc = do(startkey) 
			let d = await db.local.allDocs {include_docs: true,  endkey: "{startkey}\uffff", startkey}
			return d.rows

		for {doc: t} in await getDocsDesc "T#"
			threads.byId[t._id] = t
			threads.byTime.push t._id
		
		for {doc: f} in await getDocsAsc "F#"
			fleeting.byId[f._id] = f
			fleeting.byTime.push f._id

		fleeting.byTime = fleeting.byTime.concat(threads.byTime).sort(do $1.createdAt > $2.createdAt)
		imba.commit!
			
	def addTodo {id, due}
		let date = new Date()
		let {month, week} = getISOWeekInMonth date
		switch due
			when "day"
				todos.today.push {id, due: date.getDay!}
			when "week"
				todos.week.push {id, due: week}
			when "month"
				todos.year.push {id, due: month}
			when "year"
				todos.year.push {id, due: date.getFullYear!}
		storeSet "todos", todos
		console.log "NEW TODO!"
		console.log storeGet "todos"


	def addQuestion id
		questions.push {id, createdAt: new Date()}
		storeSet "questions", questions

	def appendBlock {content, refs}
		let now = new Date()
		let newId = "F#{now.toISOString!}"
		let f = { _id: newId, createdAt: now, content, refs }

		try 
			await db.local.put f
			fleeting.byId[newId] = f
			fleeting.byTime.push newId
			console.log "ENW FELEETING"
			console.log fleeting
			return newId
		catch e
			console.error "Err while appending block {e}"

	
	def appendThread {title, content, refs}
		let now = new Date()
		let newId = "T#{now.toISOString!}"
		let toWrite = []
		
		for r in refs
			let b = threads.byId[r]
			b.backlinks.push(newId)
			toWrite.push b

		let t = { _id: newId, refs, title, content, backlinks: [] }
		toWrite.push t

		try 
			await db.local.bulkDocs toWrite
			threads.byId[newId] = t
			threads.byTime.push newId
			fleeting.byTime.push newId
			return newId
		catch e
			console.error "Err while appending thread {e}"
	
	def updateThread {id, title, content, refs} 

		let thread = getItem id
		let {added, deleted} = diff thread.refs, refs
		let toWrite = []
		
		for r in added
			let t = getItem r
			t.backlinks.push id
			toWrite.push t
		
		for r in deleted
			let t = getItem r
			t.backlinks.splice t.backlinks.indexOf(r), 1
			toWrite.push t
		
		thread.title = title
		thread.content = content
		thread.refs = refs

		toWrite.push thread

		try
			await db.local.bulkDocs toWrite
			# Yeah we are doing dis
			document.querySelectorAll("ref[ref-id='{id}']").forEach do
				$1.innerText = "#{title}"
			document.querySelectorAll("div[id='{id}'].heading").forEach do
				$1.innerText = "#{title}"

		catch e
			console.error "Err while editing thread {e}"

	def editBlock {id, content}
		items.byId[id].content = content
		imba.commit!

	def deleteQuestion id
		console.log "DELET QUESTION {id}"

	def titleOf id
		getItem(id).title
	
	def getBacklinks id
		backlinks[id]

	def getItem id
		if id.startsWith "T#"
			threads.byId[id]
		elif id.startsWith "F#"
			fleeting.byId[id]
		else
			console.error "Can't fetch {id}"
			null
	
	def query q
		if q is ""
			return []
		let l = Object.values(threads.byId).filter(do $1.title.includes(q))
		return l

