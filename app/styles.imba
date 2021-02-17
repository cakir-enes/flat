# including some global styles here
import cloudz from "./icons/cloudz.svg"

global css 
	@root
		# --primary:linear-gradient(178.28deg, #424242 1.39%, #303134 98.5%)
		# --pavion-bg:rgba(13, 13, 13, 0.19)
		# --primary:#0f1212
		# --primary2:red
		# --accent:#50566A
		# --light:#e9e9e9
		# --darkest:#222429
		# --cyan:#94dae0
		$black: #10161a

		$dark-gray1: #182026
		$dark-gray2: #202b33
		$dark-gray3: #293742
		$dark-gray4: #30404d
		$dark-gray5: #394b59

		$gray1: #5c7080
		$gray2: #738694
		$gray3: #8a9ba8
		$gray4: #a7b6c2
		$gray5: #bfccd6

		$light-gray1: #ced9e0
		$light-gray2: #d8e1e8
		$light-gray3: #e1e8ed
		$light-gray4: #ebf1f5
		$light-gray5: #f5f8fa

		$white: #ffffff

		$blue1: #0e5a8a
		$blue2: #106ba3
		$blue3: #137cbd
		$blue4: #2b95d6
		$blue5: #48aff0

		$green1: #0a6640
		$green2: #0d8050
		$green3: #0f9960
		$green4: #15b371
		$green5: #3dcc91

		$orange1: #a66321
		$orange2: #bf7326
		$orange3: #d9822b
		$orange4: #f29d49
		$orange5: #ffb366

		$red1: #a82a2a
		$red2: #c23030
		$red3: #db3737
		$red4: #f55656
		$red5: #ff7373

		$vermilion1: #9e2b0e
		$vermilion2: #b83211
		$vermilion3: #d13913
		$vermilion4: #eb532d
		$vermilion5: #ff6e4a

		$rose1: #a82255
		$rose2: #c22762
		$rose3: #db2c6f
		$rose4: #f5498b
		$rose5: #ff66a1

		$violet1: #5c255c
		$violet2: #752f75
		$violet3: #8f398f
		$violet4: #a854a8
		$violet5: #c274c2

		$indigo1: #5642a6
		$indigo2: #634dbf
		$indigo3: #7157d9
		$indigo4: #9179f2
		$indigo5: #ad99ff

		$cobalt1: #1f4b99
		$cobalt2: #2458b3
		$cobalt3: #2965cc
		$cobalt4: #4580e6
		$cobalt5: #669eff

		$turquoise1: #008075
		$turquoise2: #00998c
		$turquoise3: #00b3a4
		$turquoise4: #14ccbd
		$turquoise5: #2ee6d6

		$forest1: #1d7324
		$forest2: #238c2c
		$forest3: #29a634
		$forest4: #43bf4d
		$forest5: #62d96b

		$lime1: #728c23
		$lime2: #87a629
		$lime3: #9bbf30
		$lime4: #b6d94c
		$lime5: #d1f26d

		$gold1: #a67908
		$gold2: #bf8c0a
		$gold3: #d99e0b
		$gold4: #f2b824
		$gold5: #ffc940

		$sepia1: #63411e
		$sepia2: #7d5125
		$sepia3: #96622d
		$sepia4: #b07b46
		$sepia5: #c99765


	
	body w:100% h:100% m:0

	* scrollbar-width: thin scrollbar-color: rgba(12,12,12,0.4) rgba(12,12,12,0.0)

	input, select, textarea, button 
		font-family: inherit
		bg: inherit
		bd:0

	p m:0
	
	.bg-pavion
		# bg: radial-gradient(42.48% 50.06% at 93.85% 91.46%, #941652 0%, rgba(179, 51, 51, 0.13) 100%), radial-gradient(75.98% 149.48% at 79.38% 18.7%, #58CEC7 0%, rgba(62, 141, 235, 0.246391) 51.71%, rgba(244, 156, 53, 0) 100%, rgba(234, 234, 234, 0) 100%), radial-gradient(75.98% 149.48% at 79.38% 18.7%, #CE9858 0%, rgba(235, 155, 62, 0.246391) 51.71%)
		bg: radial-gradient(42.48% 50.06% at 93.85% 91.46%, #787878 0%, rgba(89, 89, 89, 0.36) 100%), radial-gradient(75.98% 149.48% at 79.38% 18.7%, #CE9858 0%, rgba(235, 155, 62, 0.246391) 51.71%, rgba(244, 156, 53, 0) 100%)


	.overlay 
			pos:absolute m:auto l:0 r:0 zi:2 w:500px h:100% d:grid place-content:center
	
	.heading
		ff: 'Zilla Slab Highlight', cursive
		fw:bold
		fs:1.5em
	
	.text
		ff: 'Work Sans', sans-serif
		fw:500

	.icon
		w:24px h:24px cursor:pointer bg@hover:black c@hover:white p:4px rd:4

	.ref
		ff:'Zilla Slab Highlight' cursor:pointer
	.shadow
		box-shadow: rgba(0, 0, 0, 0.4) 0px 0px 0px 2px, rgba(0, 0, 0, 0.65) 0px 4px 6px -1px, rgba(255, 255, 255, 0.08) 0px 1px 0px inset;
	.box-shadow
		box-shadow: rgba(240, 46, 170, 0.4) 5px 5px, rgba(240, 46, 170, 0.3) 10px 10px, rgba(240, 46, 170, 0.2) 15px 15px, rgba(240, 46, 170, 0.1) 20px 20px, rgba(240, 46, 170, 0.05) 25px 25px;

	html
		w:100% h:100% m:0 ff:'Work Sans' c:white

	.editor > p
		m:0
	

	

	# button -webkit-appearance: none
	# 	bg:blue5 @hover:blue6
	# 	fs:sm c:white
	# 	d:flex ja:center
	# 	px:4 py:2 rd:sm bd:0px
	# 	mx:2 fl:0 0 auto

	# header
	# 	flex: 0 0 auto
	# 	display: hflex
	# 	justify-content: flex-start
	# 	align-items: stretch
	# 	padding: 10px 6px
	# 	background: #e8e8e8

	# input d:block px:4 bg:transparent
	# 	bd:none fs:inherit w:50px
	# 	fl:1 1 auto
