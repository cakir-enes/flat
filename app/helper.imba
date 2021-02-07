
def filterRefs node
	let r = []
	_filterRefs node, r
	return r

def _filterRefs node, refs = []
	for n in node.childNodes
		if n.tagName is "REF"
			refs.push n
		if n.hasChildNodes!
			_filterRefs n, refs
	

def addRefClickHandlers refs, emitter
	for r in refs
		let id = r.getAttribute "ref-id"
		r.addEventListener 'click', do emitter("open", {id})

export def toElement content, emitter
	let f = document.createRange().createContextualFragment content
	addRefClickHandlers filterRefs(f), emitter
	f
