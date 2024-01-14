
#import "Util.typ": to_string, add_title, insert_code-snippet

#let __constants_toml = toml("__private_tools/constants.toml")


#let __local_placeholder_constants = (
	title: "Title",
	authors: "",
	context: none,
	date: datetime.today().display(),
	header_logo: none,
)




#let set_config_header_footer(
	title:		__local_placeholder_constants.title,
	authors:	__local_placeholder_constants.authors,
	context:	__local_placeholder_constants.context,
	date:		__local_placeholder_constants.date,
	header_logo:__local_placeholder_constants.header_logo,
	document_
) = {
	let h_f_content(
		side, content,
		color: rgb(__constants_toml.color.header_footer_grey)
	) = align(side,
		text(
			weight: "thin",
			size: __constants_toml.size.foot_head * 1pt,
			fill: color
		)[#content]
	)

	set page(
		header: grid(
			columns: (15%, 70%, 15%),
			h_f_content(left + horizon, date),
			h_f_content(center + horizon, header_logo),
			h_f_content(right, [by #authors]),
		),
		footer: grid(
			columns: (20%, 60%, 20%),
			h_f_content(left 	+ horizon, par(justify: false)[#text(hyphenate: false)[#context]]),
			h_f_content(center	+ horizon, par(justify: false)[#text(hyphenate: false)[#title]]),
			h_f_content(right	+ horizon, counter(page).display("1/1", both: true), color: black),
		)
	)

	document_
}


#let set_config_document_style(document_) = {
	// set heading(numbering: "1.1 " + str.from-unicode(__constants_toml.char.em-dash))
	set heading(numbering: (..nums) => {
		nums.pos().map(str).join(".") + " " + str.from-unicode(__constants_toml.char.em-dash)
	})

	set par(
		first-line-indent: 2em,
		justify: true
	)

	set text(lang: "fr")

	show link: underline

	// Thx to https://github.com/typst/typst/discussions/2812#discussioncomment-7721649
	show heading: h => pad(left: 1em * (h.level - 1), h) + text(0pt, white)[.]

	document_
}



#let set_config(
	title:	__local_placeholder_constants.title,
	title_prefix: "Homework #?: ",
	authors:__local_placeholder_constants.authors,
	context:__local_placeholder_constants.context,
	date:	__local_placeholder_constants.date,
	image_banner: none,
	header_logo: none,
	document_,
) = {
	set document(title: to_string[#title], author: authors)

	document_ = [
		#image_banner

		#add_title[#title_prefix#title]

		#document_
	]

	document_ = set_config_document_style[#document_]
	document_ = set_config_header_footer(
		title: title,
		authors: authors,
		context: context,
		date: date,
		header_logo: header_logo,
	)[#document_]

	document_
}
