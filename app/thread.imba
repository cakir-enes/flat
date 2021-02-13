import store from "./store"
import {toElement} from "./helper"
import close from "./icons/close.svg"
import edit from "./icons/edit.svg"
import {addRefClickHandlers, filterRefs} from "./helper"

export tag Thread < div
	prop id

	css button bg:none @hover:black rd:6

	edit? = false

	get item
		store.getItem id
	
	def rendered
		addRefClickHandlers filterRefs($c), do(name, data) emit(name, data)
	
	def showEditor
		edit? = true

		
	<self[d:hflex h:min-content c:black] @edit.stop=(do edit? = true) @close=(do edit? = false)>
		<div[w:50px mr:2]>
			<svg[fill:black] src="./icons/cloudz.svg">
		if edit?						
			<thread-editor.editor[min-width:400px rd:3px ] threadId=id>
		else 
			<div[d:vflex min-width:400px rd:3px jc:space-between]>
				<div[flg:0]>
					<div.heading[d:hflex ai:center]>
						<div> item..title
						<div[flg:1]>
						<svg.icon @click.emit-edit({id}) src=edit>
						<svg.icon @click.emit-close({id}) src=close>
					<div$c innerHTML=item.content>
				<div>			
					<h2[m:0]> "Backlinks"
					<ol[m:0]> for b in store.getBacklinks(id) ?? []
						<li @click=emit('open', {id: b})> <h3> store.titleOf b
