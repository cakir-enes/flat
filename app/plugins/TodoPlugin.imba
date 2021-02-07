import store from "../store"
import {toElement} from "../helper"


tag TodoItem
	prop id

	def mount
		let frag = toElement store.getItem(id).content
		$r.replaceWith frag

	<self>
		<div$r>


tag TodoSection
	prop title
	prop itemIds

	<self>
		<div[d:vflex]>
			<h5> title
			<ul> for id in itemIds
				<TodoItem id=id>


export default tag TodoPlugin
	
	<self[bg:$darkest d:hflex flw:wrap as:flex-end]>
		<TodoSection title="day" itemIds=store.todos.today.map(do $1.id)>
		<TodoSection title="day" itemIds=store.todos.today.map(do $1.id)>
		<TodoSection title="day" itemIds=store.todos.today.map(do $1.id)>
		<TodoSection title="day" itemIds=store.todos.today.map(do $1.id)>
	