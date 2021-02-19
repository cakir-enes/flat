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
			<thread-editor.editor[min-width:400px rd:3px m:0] @cancel=(do edit? = false) threadId=id>
		else 
			<div[d:vflex width:400px rd:3px jc:space-between p:8px bg:$black c:$light-gray4]>
				<div[flg:0]>
					<div.heading[d:hflex ai:center]>
						<div> item..title
						<div[flg:1]>
						<svg.icon @click.emit-edit({id}) src=edit>
						<svg.icon @click.emit-close({id}) src=close>
					<div$c innerHTML=item.content>
				<div[mt:16px]>
					<div[d:hflex]>
						<div[h:1.5em w:50px pr:4px]>
							<svg[fill:$dark-gray2] src="./icons/cloudz.svg">
						<h2[fs:1.5rem fw:bold]> "Backlinks"
						<div[h:1.5em ml:2]>
							<svg[fill:black] src="./icons/cloudz.svg">
					<ol[m:0 mt:8px list-style:none]> for b in item.backlinks ?? []
						<li [c@hover:white bg@hover:$darkest cursor:pointer rd:2] @click=emit('open', {id: b})> <h3[p:2px]> store.titleOf b
