

#let __constants_toml = toml("__private_tools/constants.toml")


#let add_title(content, bold: true, size: 17pt, small_capitals: false) = {

	content = if small_capitals { smallcaps[#content] } else { content }

	content = text(
		size,
		hyphenate: false,
		weight: if bold { "bold" } else { "regular" }
	)[#content]

	content = par(justify: false)[#content]

	content = align(center, content)

	content
}


#let phantom_title_ref(arg) = {
	[#heading(bookmarked: false, outlined: false, supplement: none, numbering: none)[#text(0pt, white)[.]] #label(arg)]
}
#let phantom_ref(arg) = {
	[#text(0pt, white)[.] #label(arg)]
}



#let file_folder(data) = {
	text(fill: rgb(__constants_toml.color.file_folder))[#raw(data)]
}


#let import_csv_filter_categories(path, categories, display_size: 11pt) = {
	transpose(csv(path))
		.filter(
			category => categories.contains(category.first())
		)
		.sorted(key:
			category => categories.position(
				item => item == category.first()
			)
		)
		.map(category => {
			let t = category.first()
			(text[*#t*],) + category.slice(1)
		})
		.map(
			category => category.map(cell => text(size: display_size)[#cell])
		)
}


#let part_included(folder: "") = {
	if (folder != "") and (not folder.ends-with("/")) {
		folder += "/"
	}
	return (file) => folder + file
}



#let insert_code-snippet(
	title: "",
	code,
	border: true,
) = {
	let code_snippet = par(justify: false)[#text(size: 8pt)[#code]]
	figure(
		kind: "Code snippet", supplement: "Code snippet",
		caption: [#title],
		if border { rect[#code_snippet] }
		else { code_snippet },
	)
}

#let insert_figure(
	title,
	folder: __constants_toml.figures_folder,
	width: 100%,
	border: true,
) = {
	let img = image(folder + "/" + title + ".png", width: width)
	figure(
		caption: [#title],
		if border { rect[#img] }
		else { img },
	)
}


// Taken from https://github.com/typst/typst/issues/2196#issuecomment-1728135476
#let to_string(content) = {
	if content.has("text") {
		content.text
	} else if content.has("children") {
		content.children.map(to_string).join("")
	} else if content.has("body") {
		to_string(content.body)
	} else if content == [ ] {
		" "
	}
}

#let insert_acronym(
	acronym
) = {
	let _type = "acronym"
	[
		#figure(
			kind: _type, supplement: upper("*"), caption: none, acronym
		) #label(
			_type + "_" + to_string(acronym).replace(regex("[^0-9A-Za-z_\-]"), "_")
		)
	]
}


#let todo(data) = {
	text(16pt, red)[TO\[] + " " + emph(text(12pt, black)[#data]) + text(16pt, red)[\]DO <todo>]
}


#let transpose(arr) = {
	array.zip(..arr)
}
