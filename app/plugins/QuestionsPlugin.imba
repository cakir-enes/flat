import store from "../store"
import {toElement} from "../helper"

tag Question
	prop id

	def frag
		toElement(store.getItem(id).content)

	def mount
		let frag = toElement(store.getItem(id).content)
		$r.replaceWith frag

	<self[d:hflex ac:space-between]>
		<div[flg:1 ta:start c:red4 cursor:pointer mr:14px] @click=emit("questionDelete", {id: id}) role="button"> "x"
		<div$r>
		

const pos = {x: 0, y:0}
export default tag QuestionsPlugin
	
	css ul p:0
	

	<self.shadow[bg:$darkest pos:absolute t:0 l:0 zi:4 x:{pos.x} y:{pos.y} d:vflex ac:flex-end ta:end max-width:420px as:flex-end] @touch.sync(pos)>
		<div[h:6px rd:2 o:0.8 cursor:pointer w:100% bg:blue3]>
		<ul[of:auto]> for {id} in store.questions
			<Question id=id>

