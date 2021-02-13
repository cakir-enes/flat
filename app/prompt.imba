import store from './store'
let query = "asd"

export tag RefPrompt
	css 
		.container p:4px bd:2px solid $darkest rd:6px bg:$darkest
		
		ol 
			of:auto max-height:600px list-style:none p:0 m:16px fs:14px mr:0px
			scrollbar-color: $light $darkest
		li 
			bg@hover:$light bg@focus:$light c@focus:$darkest
			p:4px bd:1px rd:4px mr:4px
		input w:100% mt:12px fs:24px c:white outline: none
		h2
			m:2px
		
	
	
	focusItem = -1
	filteredResults = []
	
	def search
		filteredResults = store.query query

	def focused? i
		focusItem is i

	get resCount
		filteredResults.length

	res = {}
	def memoized fn, arg
		res[arg] ||= fn arg

	def focusDown
		focusItem += focusItem < resCount - 1  ? 1 : 0
		let e = memoized (do document.getElementById $1), "item{focusItem}"
		e.focus!

	def focusUp
		focusItem += focusItem > 0 ? -1 : 0
		let e = memoized (do document.getElementById $1), "item{focusItem}"
		e.focus!

	def mount
		$inp.focus!	

	def focusFirst
		let e = document.getElementById "item0"
		e.focus!

	def cancelPrompt e
		emit('cancel')
	
	def select {id, title}
		emit 'select', {id, title}
		emit 'cancel'
	

	<self.container
		tabindex=-1
		autorender=true
		@keydown.esc=cancelPrompt 
		@keydown.up.prevent=focusUp
		@keydown.down.prevent=focusDown>		
		<div.container.shadow>
			<input$inp.inp 
				autofocus 
				type="text" 
				bind=query 
				@input.throttle=search
				@keydown.down.prevent=focusFirst 
				placeholder="Search">
			<ol tabIndex=0> for r, i in filteredResults
				<li id="item{i}" @click=select(r) @keydown.enter.prevent=select(r) tabIndex=-1> 
					<h2> r.title


export def promptRef
	return new Promise do |res, rej|
		let frag = document.getElementById "overlay"
		frag.style.display = "block"
		let cancel = do
			frag.style.display = "none"
			document.getElementById("prompt").remove!
			res({ok: false})

		frag.appendChild <RefPrompt#prompt @cancel.stop=cancel @select.stop=(do res({ok: true, id: $1.detail.id, title: $1.detail.title})) />
	
	
