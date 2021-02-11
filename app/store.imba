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

export default new class
	

	constructor
		# window.localStorage.clear!
		items = storeGet("items") ?? {
			byId: {},
			byTime: []
		}
		questions = storeGet("questions") ?? []
		backlinks = storeGet("backlinks") ?? {}
		selectedItems = new Set()
		todos = storeGet("todos") ?? {today: [], week: [], year: [], month: []}
		streams = {}
		fixTodosByDue!
	

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

	def appendBlock content
		let newId = "block{items.byTime.length}"
		let ca = new Date()
		let newBlock = { id: newId, createdAt: new Date(), kind: "block", content }
		items.byId[newId] = newBlock
		items.byTime.push newId
		storeSet "items", items
		newId
	
	def appendThread {title, content, refs}
		let newId = "thread{items.byTime.length}"

		for r in refs
			let b = backlinks[r] ?? []
			b.push(newId)
			backlinks[r] = b

		let t = { id: newId, createdAt: "23", refs, title, kind: "thread", content }
		
		items.byTime.push newId
		items.byId[newId] = t
		storeSet "items", items
		storeSet "backlinks", backlinks
		newId

	def editBlock {id, content}
		items.byId[id].content = content
		imba.commit!

	def deleteQuestion id
		console.log "DELET QUESTION {id}"

	def titleOf id
		items.byId[id].title
	
	def getBacklinks id
		backlinks[id]

	def getItem id
		items.byId[id]
	
	def query q
		if q is ""
			return []
		let l = Object.values(items.byId).filter(do $1.kind is 'thread' and $1.title.includes(q))
		console.log l
		return l

