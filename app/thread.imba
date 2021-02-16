import store from "./store"
import {toElement} from "./helper"
import close from "./icons/close.svg"
import edit from "./icons/edit.svg"
import {addRefClickHandlers, filterRefs} from "./helper"
import cloudzrot from "./icons/cloudz-rot.svg"
import "./thread-joystick"

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

		
	<self[d:hflex h:min-content c:black] @edit.stop=(do edit? = true)>
		
		if edit?						
			<thread-editor.editor[min-width:400px rd:3px] @cancel=(do edit? = false) threadId=id>
		else 
			<div[d:vflex width:400px rd:3px jc:space-between p:4px]>
				<div[flg:0]>
					<div.heading[d:hflex ai:center]>
						<div> item..title
						<div[flg:1]>
						<svg.icon @click.emit-edit({id}) src=edit>
						<svg.icon @click.emit-close({id}) src=close>
					<div$c innerHTML=item.content>
				<div[mt:8px]>
					<div[d:hflex ta:end ai:baseline]>
						<div[h:1.5em w:50px pr:4px]>
							<svg[fill:black] src="./icons/cloudz.svg">
						<h2[m:0]> "Backlinks"
						<div[h:1.5em ml:2]>
							<svg[fill:black] src="./icons/cloudz.svg">
					<ol[m:0]> for b in item.backlinks ?? []
						<li @click=emit('open', {id: b})> <h3> store.titleOf b
