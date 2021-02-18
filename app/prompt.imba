import store from './store'


export tag RefPrompt
	css 
		.container p:4px rd:6px bg:$dark-gray1
		
		ol 
			of:auto max-height:600px list-style:none p:0 m:16px fs:14px mr:0px
			scrollbar-color: $white $black
		li 
			bg@hover:$light-gray2 bg@focus:$light-gray2
			p:4px bd:1px rd:4px mr:4px c:$light-gray2 @hover:$black @focus:$black
		input w:100% mt:12px fs:24px outline: none bd:0 pl:20px c:$white
		h2 m:2px
		
	
	query = ""
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
	
	def select {_id, title}
		emit 'select', {id: _id, title}
		emit 'cancel'
	

	<self.container
		tabindex=-1
		autorender=true
		@keydown.esc.stop=cancelPrompt 
		@keydown.up.stop.prevent=focusUp
		@keydown.down.stop.prevent=focusDown>		
		<div.container[bxs:lg]>
			<input$inp.inp 
				autofocus 
				type="text" 
				bind=query 
				@input.throttle=search
				@keydown.down.stop.prevent=focusFirst 
				placeholder="Search">
			<ol tabIndex=0> for r, i in filteredResults
				<li id="item{i}" @click=select(r) @keydown.enter.stop.prevent=select(r) tabIndex=-1> 
					<h2> r.title


export def promptRef parent
	css .prompt pos:absolute t:0 l:0 r:0 b:0 h:80%  w:75% m:auto
	return new Promise do |res, rej|
		
		let cancel = do
			let prompt = parent.querySelector ".prompt"
			prompt.remove!
			res({ok: false})
		
		parent.appendChild <RefPrompt.prompt @cancel.stop=cancel @select.stop=(do $1.detail..id && res({ok: true, id: $1.detail.id, title: $1.detail.title})) />
	
	
