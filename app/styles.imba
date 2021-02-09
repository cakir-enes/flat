# including some global styles here
import cloudz from "./icons/cloudz.svg"

global css 
	@root
		# --primary:linear-gradient(178.28deg, #424242 1.39%, #303134 98.5%)
		--pavion-bg:rgba(13, 13, 13, 0.19)
		--primary:#0f1212
		--primary2:red
		--accent:#50566A
		--light:#e9e9e9
		--darkest:#222429
		--cyan:#94dae0
	
	.bg-pavion
		# bg: radial-gradient(42.48% 50.06% at 93.85% 91.46%, #941652 0%, rgba(179, 51, 51, 0.13) 100%), radial-gradient(75.98% 149.48% at 79.38% 18.7%, #58CEC7 0%, rgba(62, 141, 235, 0.246391) 51.71%, rgba(244, 156, 53, 0) 100%, rgba(234, 234, 234, 0) 100%), radial-gradient(75.98% 149.48% at 79.38% 18.7%, #CE9858 0%, rgba(235, 155, 62, 0.246391) 51.71%)
		bg: radial-gradient(42.48% 50.06% at 93.85% 91.46%, #787878 0%, rgba(89, 89, 89, 0.36) 100%), radial-gradient(75.98% 149.48% at 79.38% 18.7%, #CE9858 0%, rgba(235, 155, 62, 0.246391) 51.71%, rgba(244, 156, 53, 0) 100%)


	.overlay 
			pos:absolute m:auto l:0 r:0 zi:2 w:500px h:100% d:grid place-content:center
	
	.heading
		ff: 'Zilla Slab Highlight', cursive
		fw:bold
	
	.text
		ff: 'Work Sans', sans-serif
		fw:500

	.ref
		ff:'Zilla Slab Highlight' cursor:pointer
	.shadow
		box-shadow: rgba(0, 0, 0, 0.4) 0px 0px 0px 2px, rgba(0, 0, 0, 0.65) 0px 4px 6px -1px, rgba(255, 255, 255, 0.08) 0px 1px 0px inset;
	.box-shadow
		box-shadow: rgba(240, 46, 170, 0.4) 5px 5px, rgba(240, 46, 170, 0.3) 10px 10px, rgba(240, 46, 170, 0.2) 15px 15px, rgba(240, 46, 170, 0.1) 20px 20px, rgba(240, 46, 170, 0.05) 25px 25px;

	html
		w:100% h:100% m:0 ff:'Work Sans' c:white
	
	.repeat
		bgs:7vw
		background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 28' width='56' height='28'%3E%3Cpath fill='white' d='M56 26v2h-7.75c2.3-1.27 4.94-2 7.75-2zm-26 2a2 2 0 1 0-4 0h-4.09A25.98 25.98 0 0 0 0 16v-2c.67 0 1.34.02 2 .07V14a2 2 0 0 0-2-2v-2a4 4 0 0 1 3.98 3.6 28.09 28.09 0 0 1 2.8-3.86A8 8 0 0 0 0 6V4a9.99 9.99 0 0 1 8.17 4.23c.94-.95 1.96-1.83 3.03-2.63A13.98 13.98 0 0 0 0 0h7.75c2 1.1 3.73 2.63 5.1 4.45 1.12-.72 2.3-1.37 3.53-1.93A20.1 20.1 0 0 0 14.28 0h2.7c.45.56.88 1.14 1.29 1.74 1.3-.48 2.63-.87 4-1.15-.11-.2-.23-.4-.36-.59H26v.07a28.4 28.4 0 0 1 4 0V0h4.09l-.37.59c1.38.28 2.72.67 4.01 1.15.4-.6.84-1.18 1.3-1.74h2.69a20.1 20.1 0 0 0-2.1 2.52c1.23.56 2.41 1.2 3.54 1.93A16.08 16.08 0 0 1 48.25 0H56c-4.58 0-8.65 2.2-11.2 5.6 1.07.8 2.09 1.68 3.03 2.63A9.99 9.99 0 0 1 56 4v2a8 8 0 0 0-6.77 3.74c1.03 1.2 1.97 2.5 2.79 3.86A4 4 0 0 1 56 10v2a2 2 0 0 0-2 2.07 28.4 28.4 0 0 1 2-.07v2c-9.2 0-17.3 4.78-21.91 12H30zM7.75 28H0v-2c2.81 0 5.46.73 7.75 2zM56 20v2c-5.6 0-10.65 2.3-14.28 6h-2.7c4.04-4.89 10.15-8 16.98-8zm-39.03 8h-2.69C10.65 24.3 5.6 22 0 22v-2c6.83 0 12.94 3.11 16.97 8zm15.01-.4a28.09 28.09 0 0 1 2.8-3.86 8 8 0 0 0-13.55 0c1.03 1.2 1.97 2.5 2.79 3.86a4 4 0 0 1 7.96 0zm14.29-11.86c1.3-.48 2.63-.87 4-1.15a25.99 25.99 0 0 0-44.55 0c1.38.28 2.72.67 4.01 1.15a21.98 21.98 0 0 1 36.54 0zm-5.43 2.71c1.13-.72 2.3-1.37 3.54-1.93a19.98 19.98 0 0 0-32.76 0c1.23.56 2.41 1.2 3.54 1.93a15.98 15.98 0 0 1 25.68 0zm-4.67 3.78c.94-.95 1.96-1.83 3.03-2.63a13.98 13.98 0 0 0-22.4 0c1.07.8 2.09 1.68 3.03 2.63a9.99 9.99 0 0 1 16.34 0z'%3E%3C/path%3E%3C/svg%3E");
	p
		m:0

	body w:100% h:100% m:0

	* scrollbar-width: thin scrollbar-color: rgba(12,12,12,0.4) rgba(12,12,12,0.0)

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
