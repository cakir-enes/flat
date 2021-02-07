import store from "./store"
import {toElement} from "./helper"

export tag Thread
	prop id

	css button bg:none @hover:black ff:mono rd:6

	# def mount
	# 	let item = store.getItem id
	# 	console.log "{item} ID: {id}"
	# 	let contentFrag = toElement item.content
	# 	$c.replaceWith contentFrag
	# 	let titleFrag = toElement item.title
	# 	$t.replaceWith titleFrag

	<self[d:vflex bg:$darkest min-width:400px p:14px m:6px rd:6px]>
		<div[flg:1]>
			<div[d:hflex ai:center c:blue4 fs:1.5em]>
				<div$t>
				<div[flg:1]>
				<button @click=emit("edit", {id: id})> "e"
				<button @click=emit("close", {id: id})> "x"
			<div$c>
		<div>			
			<h2> "Backlinks"
			<ol> for b in store.getBacklinks(id) ?? []
				<li @click=emit('open', {id: b})> <h3> store.titleOf b

		
