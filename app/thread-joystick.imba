tag thread-joystick < div
	prop openThreads

	<self[d:hflex pos:fixed b:10 r:10]>
		<button @click.emit-focusPrev> "<"
		<div[pos:relative d:vflex]>
			<div[pos:relative b:0 l:0 bg:white w:100% h:50px]>
			<button> "."
		<button @click.emit-focusNext> ">"

