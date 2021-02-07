import TodoPlugin from "./TodoPlugin"
import QuestionsPlugin from "./QuestionsPlugin"

tag plugins-view
	css .plugin p:12px m:10px rd:6px fs:13px


	<self>
		<div[d:vflex]>
			# <TodoPlugin.plugin>
			<QuestionsPlugin.plugin>
