## =========================
## MAKE ENVIRONMENTAL VARIABLE TABLE
## WITH UNITS AND SOURCES
##
## Outputs:
##   1) .tex fragment
##   2) full .tex file
##   3) intermediate LaTeX PDF
##   4) final PNG
##   5) final PDF made from PNG
## =========================

library(dplyr)
library(tibble)
library(kableExtra)
library(tinytex)
library(magick)

## =========================
## OUTPUT FILES
## =========================

out_tex_fragment <- "environmental_variable_table_fragment.tex"
out_tex_full     <- "environmental_variable_table_full.tex"
out_pdf_latex    <- "environmental_variable_table_latex.pdf"
out_png          <- "environmental_variable_table.png"
out_pdf_final    <- "environmental_variable_table.pdf"

## =========================
## TABLE DATA
## =========================

tab <- tribble(
  ~`Environmental Variable Name`, ~`Environmental Metric`, ~Units, ~Source,
  
  "Bio1",   "Annual Mean Temperature",                         "Degrees Celsius",                          "WorldClim",
  "Bio2",   "Mean Diurnal Range",                               "Degrees Celsius",                          "WorldClim",
  "Bio3",   "Isothermality",                                    "Percent",                                  "WorldClim",
  "Bio4",   "Temperature Seasonality",                          "Standard deviation × 100",                 "WorldClim",
  "Bio5",   "Max Temperature of Warmest Month",                 "Degrees Celsius",                          "WorldClim",
  "Bio6",   "Min Temperature of Coldest Month",                 "Degrees Celsius",                          "WorldClim",
  "Bio7",   "Temperature Annual Range",                         "Degrees Celsius",                          "WorldClim",
  "Bio8",   "Mean Temperature of Wettest Quarter",              "Degrees Celsius",                          "WorldClim",
  "Bio10",  "Mean Temperature of Warmest Quarter",              "Degrees Celsius",                          "WorldClim",
  "Bio11",  "Mean Temperature of Coldest Quarter",              "Degrees Celsius",                          "WorldClim",
  "Bio12",  "Annual Precipitation",                             "Millimeters",                              "WorldClim",
  "Bio13",  "Precipitation of Wettest Month",                   "Millimeters",                              "WorldClim",
  "Bio14",  "Precipitation of Driest Month",                    "Millimeters",                              "WorldClim",
  "Bio15",  "Precipitation Seasonality",                        "Coefficient of variation",                 "WorldClim",
  "Bio16",  "Precipitation of Wettest Quarter",                 "Millimeters",                              "WorldClim",
  "Bio17",  "Precipitation of Driest Quarter",                  "Millimeters",                              "WorldClim",
  "Bio18",  "Precipitation of Warmest Quarter",                 "Millimeters",                              "WorldClim",
  "Bio19",  "Precipitation of Coldest Quarter",                 "Millimeters",                              "WorldClim",
  
  "Soil1",  "Available Water Capacity, 0 to 200 cm",            "Centimeters of water",                     "SSURGO",
  "Soil2",  "Available Water Supply, 0 to 25 cm",               "Centimeters of water",                     "SSURGO",
  "Soil3",  "Available Water Supply, 0 to 50 cm",               "Centimeters of water",                     "SSURGO",
  "Soil4",  "Available Water Supply, 0 to 100 cm",              "Centimeters of water",                     "SSURGO",
  "Soil5",  "Available Water Supply, 0 to 150 cm",              "Centimeters of water",                     "SSURGO",
  "Soil6",  "Base-flow index",                                  "Unitless index / proportion of streamflow attributed to groundwater discharge",                                  "USGS, Wolock 2003",
  "Soil7",  "Gypsum content",                                   "Percent, weighted average",                "SSURGO",
  "Soil9",  "K Factor Whole Soil",                              "Tons per acre per year",                   "SSURGO",
  "Soil11", "Percent Silt",                                     "Percentage by weight",                     "SSURGO",
  "Soil13", "Water Content at 15 bar",                          "Volumetric percentage of the whole soil",  "SSURGO",
  
  "Hydro1", "Total Upstream Cumulative Drainage Area",          "Square kilometers",                        "EPA (NHDPlus)",
  "Hydro3", "Minimum Elevation",                                "Centimeters",                              "EPA (NHDPlus)",
  "Hydro4", "Slope of Flowline",                                "Smoothed meters / smoothed meters",        "EPA (NHDPlus)",
  "Hydro5", "Slope Length",                                     "Kilometers",                               "EPA (NHDPlus)",
  "Hydro6", "Catchment Area",                                   "Square kilometers",                        "EPA (NHDPlus)"
)

## =========================
## MAKE LATEX TABLE
## =========================

latex_table <- tab %>%
  kbl(
    format = "latex",
    booktabs = TRUE,
    longtable = FALSE,
    escape = TRUE,
    align = c("l", "l", "l", "l"),
    linesep = "",
    col.names = c(
      "Environmental Variable Name",
      "Environmental Metric",
      "Units",
      "Source"
    )
  ) %>%
  kable_styling(
    latex_options = c("hold_position"),
    font_size = 9,
    full_width = FALSE,
    position = "center"
  ) %>%
  row_spec(0, bold = TRUE) %>%
  column_spec(1, width = "3.4cm") %>%
  column_spec(2, width = "6.0cm") %>%
  column_spec(3, width = "3.1cm") %>%
  column_spec(4, width = "2.8cm")

writeLines(latex_table, out_tex_fragment)

## =========================
## FULL LATEX DOCUMENT
## =========================

latex_doc <- paste0(
  "\\documentclass[11pt]{article}
\\usepackage[paperwidth=8.5in,paperheight=14in,margin=0.45in]{geometry}
\\usepackage{booktabs}
\\usepackage{array}
\\usepackage{graphicx}
\\usepackage{caption}
\\usepackage{makecell}
\\usepackage{float}
\\pagestyle{empty}
\\renewcommand{\\arraystretch}{1.05}
\\setlength{\\tabcolsep}{4pt}

\\begin{document}

\\begin{center}
",
  latex_table,
  "
\\end{center}

\\end{document}
"
)

writeLines(latex_doc, out_tex_full)

## =========================
## COMPILE LATEX TO INTERMEDIATE PDF
## =========================

tinytex::latexmk(out_tex_full)

compiled_pdf <- sub("\\.tex$", ".pdf", out_tex_full)
file.copy(compiled_pdf, out_pdf_latex, overwrite = TRUE)

## =========================
## MAKE PNG FROM INTERMEDIATE LATEX PDF
## =========================

img <- magick::image_read_pdf(out_pdf_latex, density = 600)

if (length(img) > 1) {
  img <- image_append(img, stack = TRUE)
}

img <- image_trim(img)
img <- image_border(img, color = "white", geometry = "40x40")

image_write(img, path = out_png, format = "png")

## =========================
## MAKE FINAL PDF FROM THE PNG
## =========================

img_png <- image_read(out_png)
image_write(img_png, path = out_pdf_final, format = "pdf")

## =========================
## DONE
## =========================

message("Wrote: ", out_tex_fragment)
message("Wrote: ", out_tex_full)
message("Wrote intermediate LaTeX PDF: ", out_pdf_latex)
message("Wrote final PNG: ", out_png)
message("Wrote final PDF from PNG: ", out_pdf_final)

## =========================
## MAKE SECOND VERSION WITHOUT COLUMN 1
## This makes the same table but removes
## Environmental Variable Name
## =========================

out_tex_fragment_no_col1 <- "environmental_variable_table_no_variable_names_fragment.tex"
out_tex_full_no_col1     <- "environmental_variable_table_no_variable_names_full.tex"
out_pdf_latex_no_col1    <- "environmental_variable_table_no_variable_names_latex.pdf"
out_png_no_col1          <- "environmental_variable_table_no_variable_names.png"
out_pdf_final_no_col1    <- "environmental_variable_table_no_variable_names.pdf"

## Remove first column
tab_no_col1 <- tab %>%
  select(-`Environmental Variable Name`)

## =========================
## MAKE LATEX TABLE WITHOUT COLUMN 1
## =========================

latex_table_no_col1 <- tab_no_col1 %>%
  kbl(
    format = "latex",
    booktabs = TRUE,
    longtable = FALSE,
    escape = TRUE,
    align = c("l", "l", "l"),
    linesep = "",
    col.names = c(
      "Environmental Metric",
      "Units",
      "Source"
    )
  ) %>%
  kable_styling(
    latex_options = c("hold_position"),
    font_size = 9,
    full_width = FALSE,
    position = "center"
  ) %>%
  row_spec(0, bold = TRUE) %>%
  column_spec(1, width = "7.2cm") %>%
  column_spec(2, width = "4.8cm") %>%
  column_spec(3, width = "3.0cm")

writeLines(latex_table_no_col1, out_tex_fragment_no_col1)

## =========================
## FULL LATEX DOCUMENT WITHOUT COLUMN 1
## =========================

latex_doc_no_col1 <- paste0(
  "\\documentclass[11pt]{article}
\\usepackage[paperwidth=8.5in,paperheight=14in,margin=0.45in]{geometry}
\\usepackage{booktabs}
\\usepackage{array}
\\usepackage{graphicx}
\\usepackage{caption}
\\usepackage{makecell}
\\usepackage{float}
\\pagestyle{empty}
\\renewcommand{\\arraystretch}{1.05}
\\setlength{\\tabcolsep}{4pt}

\\begin{document}

\\begin{center}
",
  latex_table_no_col1,
  "
\\end{center}

\\end{document}
"
)

writeLines(latex_doc_no_col1, out_tex_full_no_col1)

## =========================
## COMPILE LATEX TO INTERMEDIATE PDF
## WITHOUT COLUMN 1
## =========================

tinytex::latexmk(out_tex_full_no_col1)

compiled_pdf_no_col1 <- sub("\\.tex$", ".pdf", out_tex_full_no_col1)
file.copy(compiled_pdf_no_col1, out_pdf_latex_no_col1, overwrite = TRUE)

## =========================
## MAKE PNG FROM INTERMEDIATE LATEX PDF
## WITHOUT COLUMN 1
## =========================

img_no_col1 <- magick::image_read_pdf(out_pdf_latex_no_col1, density = 600)

if (length(img_no_col1) > 1) {
  img_no_col1 <- image_append(img_no_col1, stack = TRUE)
}

img_no_col1 <- image_trim(img_no_col1)
img_no_col1 <- image_border(img_no_col1, color = "white", geometry = "40x40")

image_write(img_no_col1, path = out_png_no_col1, format = "png")

## =========================
## MAKE FINAL PDF FROM THE PNG
## WITHOUT COLUMN 1
## =========================

img_png_no_col1 <- image_read(out_png_no_col1)
image_write(img_png_no_col1, path = out_pdf_final_no_col1, format = "pdf")

## =========================
## DONE WITH SECOND VERSION
## =========================

message("Wrote: ", out_tex_fragment_no_col1)
message("Wrote: ", out_tex_full_no_col1)
message("Wrote intermediate LaTeX PDF: ", out_pdf_latex_no_col1)
message("Wrote final PNG: ", out_png_no_col1)
message("Wrote final PDF from PNG: ", out_pdf_final_no_col1)