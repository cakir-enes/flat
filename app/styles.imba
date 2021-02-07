# including some global styles here
global css 
	@root
		# --primary:linear-gradient(178.28deg, #424242 1.39%, #303134 98.5%)
		--primary:#0f1212
		--primary2:red
		--accent:#50566A
		--light:#e9e9e9
		--darkest:#222429
		--cyan:#94dae0
	
	.overlay 
			pos:absolute m:auto l:0 r:0 zi:2 w:500px h:100% d:grid place-content:center

	.ref
		ff:'Zilla Slab Highlight' bg:black c:$cyan cursor:pointer
	.shadow
		box-shadow: rgba(0, 0, 0, 0.4) 0px 0px 0px 2px, rgba(0, 0, 0, 0.65) 0px 4px 6px -1px, rgba(255, 255, 255, 0.08) 0px 1px 0px inset;
	.box-shadow
		box-shadow: rgba(240, 46, 170, 0.4) 5px 5px, rgba(240, 46, 170, 0.3) 10px 10px, rgba(240, 46, 170, 0.2) 15px 15px, rgba(240, 46, 170, 0.1) 20px 20px, rgba(240, 46, 170, 0.05) 25px 25px;

	html
		w:100% h:100% m:0 ff:sans c:white
	
	p
		m:0

	body w:100% h:100% m:0

	* scrollbar-width: thin scrollbar-color: $light $primary

	button -webkit-appearance: none
		bg:blue5 @hover:blue6
		fs:sm c:white
		d:flex ja:center
		px:4 py:2 rd:sm bd:0px
		mx:2 fl:0 0 auto

	header
		flex: 0 0 auto
		display: hflex
		justify-content: flex-start
		align-items: stretch
		padding: 10px 6px
		background: #e8e8e8

	input d:block px:4 bg:transparent
		bd:none fs:inherit w:50px
		fl:1 1 auto
