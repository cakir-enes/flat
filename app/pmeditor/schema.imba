import {Schema} from "prosemirror-model"

const pDOM = ["p", 0] 
const blockquoteDOM = ["blockquote", 0]
const hrDOM = ["hr"]
const preDOM = ["pre", ["code", 0]]
const brDOM = ["br"]

export const nodes = {
	doc: {
	content: "block+"
	},

	ref: {
		attrs: {
			id: {},
			label: {},
		}
		group: "inline",
		inline: true,
		selectable: false,
		atom: true,

		toDOM: do(node) [
			"ref",
			{
				class: "ref",
				'ref-id': node.attrs.id,
				'ref-label': node.attrs.label
			},
			`#{node.attrs.label}`
		]

		parseDOM: [
			{
				tag: 'ref[ref-id][ref-label]',
				getAttrs: do(dom)
					const id = dom.getAttribute 'ref-id'
					const label = dom.getAttribute 'ref-label'
					{ id, label }
			}
		]
	},
	// :: NodeSpec A plain paragraph textblock. Represented in the DOM
	// as a `<p>` element.
	paragraph: {
	content: "inline*",
	group: "block",
	parseDOM: [{tag: "p"}],
	toDOM: do 
		pDOM
	},

	// :: NodeSpec A blockquote (`<blockquote>`) wrapping one or more blocks.
	blockquote: {
		content: "block+",
		group: "block",
		defining: true,
		parseDOM: [{tag: "blockquote"}],
		toDOM: do 
			blockquoteDOM
	},

	// :: NodeSpec A horizontal rule (`<hr>`).
	horizontal_rule: {
	group: "block",
	parseDOM: [{tag: "hr"}],
	toDOM: do 
		hrDOM
	},

	// :: NodeSpec A heading textblock, with a `level` attribute that
	// should hold the number 1 to 6. Parsed and serialized as `<h1>` to
	// `<h6>` elements.
	heading: {
	attrs: {level: {default: 1}},
	content: "inline*",
	group: "block",
	defining: true,
	parseDOM: [
		{tag: "h1", attrs: {level: 1}},
		{tag: "h2", attrs: {level: 2}},
		{tag: "h3", attrs: {level: 3}},
		{tag: "h4", attrs: {level: 4}},
		{tag: "h5", attrs: {level: 5}},
		{tag: "h6", attrs: {level: 6}}
	],
	toDOM: do(node) 
		return ["h" + node.attrs.level, 0]
	},

	// :: NodeSpec A code listing. Disallows marks or non-text inline
	// nodes by default. Represented as a `<pre>` element with a
	// `<code>` element inside of it.
	code_block: {
	content: "text*",
	marks: "",
	group: "block",
	code: true,
	defining: true,
	parseDOM: [{tag: "pre", preserveWhitespace: "full"}],
	toDOM: do 
		preDOM
	},

	// :: NodeSpec The text node.
	text: {
	group: "inline"
	},

	// :: NodeSpec An inline image (`<img>`) node. Supports `src`,
	// `alt`, and `href` attributes. The latter two default to the empty
	// string.
	image: {
	inline: true,
	attrs: {
		src: {},
		alt: {default: null},
		title: {default: null}
	},
	group: "inline",
	draggable: true,
	parseDOM: [{tag: "img[src]", getAttrs: do(dom) 
		{
			src: dom.getAttribute("src"),
			title: dom.getAttribute("title"),
			alt: dom.getAttribute("alt")
		}
	}],
	toDOM: do(node) 
		let {src, alt, title} = node.attrs
		return ["img", {src, alt, title}]
	},

	// :: NodeSpec A hard line break, represented in the DOM as `<br>`.
	hard_break: {
	inline: true,
	group: "inline",
	selectable: false,
	parseDOM: [{tag: "br"}],
	toDOM: do  brDOM
	}
}

const emDOM = ["em", 0] 
const strongDOM = ["strong", 0]
const codeDOM = ["code", 0]


export const marks = {
	// :: MarkSpec A link. Has `href` and `title` attributes. `title`
	// defaults to the empty string. Rendered and parsed as an `<a>`
	// element.
	link: {
	attrs: {
		href: {},
		title: {default: null}
	},
	inclusive: false,
	parseDOM: [{tag: "a[href]", getAttrs: do(dom) 
		{href: dom.getAttribute("href"), title: dom.getAttribute("title")}
	}],
	toDOM: do(node) 
		let {href, title} = node.attrs 
		return ["a", {href, title}, 0]
	},

	em: {
		parseDOM: [{tag: "i"}, {tag: "em"}, {style: "font-style=italic"}],
		toDOM: do 
			emDOM
	},

	// :: MarkSpec A strong mark. Rendered as `<strong>`, parse rules
	// also match `<b>` and `font-weight: bold`.
	strong: {
		parseDOM: [{tag: "strong"},
				{tag: "b", getAttrs: do(node) node.style.fontWeight != "normal" && null},
				{style: "font-weight", getAttrs: do(value) /^(bold(er)?|[5-9]\d{2,})$/.test(value) && null}],
		toDOM: do 
			strongDOM
	},

	// :: MarkSpec Code font mark. Represented as a `<code>` element.
	code: {
		parseDOM: [{tag: "code"}],
		toDOM: do  codeDOM
	}
}

export const schema = new Schema({nodes, marks})
