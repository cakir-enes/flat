export def toElement content
	document.createRange().createContextualFragment content
