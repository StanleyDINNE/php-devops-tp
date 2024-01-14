
// Add the VSCode extension "Typst" to edit this file easily!


#import "Typst/Template_default.typ": set_config
#import "Typst/Constants.typ": document_data
#import "Typst/Util.typ": file_folder, import_csv_filter_categories, insert_code-snippet, insert_figure, to_string, todo, transpose


#show: document => set_config(
	title: [Configuration d'un Pipeline CI/CD\ pour une Application Web PHP],
	title_prefix: "TP: ",
	authors: (document_data.author.reb, document_data.author.stan, document_data.author.raf).join("\n"),
	context: "Security & Privacy 3.0",
	date: datetime.today().display(),
	image_banner: align(center, image("Typst/logo_Polytech_Nice_X_UCA.png", width: 60%)),
	header_logo: align(center, image("Typst/logo_Polytech_Nice_X_UCA.png", width: 40%)),
)[#document]
