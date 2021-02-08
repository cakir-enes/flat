import store from "./store"
import {toElement} from "./helper"

export tag Thread
	prop id

	css button bg:none @hover:black ff:mono rd:6

	get item
		store.getItem id

	def mount
		let contentFrag = toElement item.content
		$c.replaceWith contentFrag

	<self[d:hflex h:min-content]>
		<div[w:60px mr:2]>
			<svg[fill:black] src="./icons/cloudz.svg">
		<div[d:vflex bg:$pavion-bg min-width:400px p:14px rd:3px]>
			<div[flg:0]>
				<div[d:hflex ai:center c:blue4 fs:1.5em]>
					<div> item..title
					<div[flg:1]>
					<button @click=emit("edit", {id: id})> "e"
					<button @click=emit("close", {id: id})> "x"
				<div$c>
			<div>			
				<h2> "Backlinks"
				<ol> for b in store.getBacklinks(id) ?? []
					<li @click=emit('open', {id: b})> <h3> store.titleOf b

		
