#import "Template_default.typ": set_config

#let __constants_toml = toml("__private_tools/constants.toml")

#let color = __constants_toml.color

#let document_data = (
	author: (
		reb: __constants_toml.author.reb,
		stan: __constants_toml.author.stan,
		raf: __constants_toml.author.raf,
	)
)

#let figures_folder = __constants_toml.figures_folder

#let line_separator = align(center, line(length: 50%))

#let size = (
	foot_head: __constants_toml.size.foot_head * 1pt,
)

#let char = (
	em-dash: str.from-unicode(__constants_toml.char.em-dash),
	tab: str.from-unicode(__constants_toml.char.tab),
	// no-indent-fake-paragraph: text(0pt, white)[.],
)
