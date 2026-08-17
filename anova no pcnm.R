## =========================
## MAKE PUBLICATION TABLE
## PC-only analysis of deviance table
## Outputs: .tex, .pdf, .png
## =========================

library(dplyr)
library(kableExtra)
library(tinytex)
library(magick)

## =========================
## OUTPUT FILES
## =========================

out_tex_fragment <- "PC_lrm_summary_table_fragment.tex"
out_tex_full     <- "PC_lrm_summary_table_full.tex"
out_pdf          <- "PC_lrm_summary_table.pdf"
out_png          <- "PC_lrm_summary_table.png"

## =========================
## TABLE DATA
## =========================

tab <- tibble::tribble(
  ~Source, ~clarkii_slope, ~clarkii_p, ~simulans_slope, ~simulans_p, # ~texanus_dev, ~texanus_p,
  "PC1", "2.43", "0.119",   "0.36", "0.546", #   "22.38", "$<0.001$",
  "PC2", "3.32", "0.069", "0.4", "0.525", #  "21.18", "0.289",
  "PC3", "0.1", "0.752",   "1.09", "0.147",  # "13.31", "$<0.01$",
  "PC4", "1.41", "0.235",   "2.23", "0.135",# "12.92", "0.529",
  "PC5", "0.3", "0.582",   "1.7", "0.191" #,   "$\\sim$ 0", "$<0.001$"
)

## =========================
## COLUMN NAMES
## =========================

colnames(tab) <- c(
  "Source",
  "Chi-Square", "P-value",
  "Chi-Square", "P-value" #,
 # "Residual Dev.", "P-value"
)

## =========================
## MAKE LATEX TABLE
## Species headers use math mode
## =========================

latex_table <- tab %>%
  kbl(
    format = "latex",
    booktabs = TRUE,
    escape = FALSE,
    align = c("l", "r", "r", "r", "r", "r", "r"),
    linesep = "",
    col.names = colnames(tab)
  ) %>%
  add_header_above(
    c(
      " " = 1,
      "$P.\\ clarkii$" = 2,
      "$P.\\ simulans$" = 2 #,
    #  "$P.\\ texanus$" = 2
    ),
    escape = FALSE,
    bold = TRUE
  ) %>%
  kable_styling(
    latex_options = c("hold_position"),
    font_size = 10,
    full_width = FALSE,
    position = "center"
  ) %>%
  row_spec(0, bold = TRUE) %>%
  column_spec(1, width = "1.7cm") %>%
  column_spec(2:7, width = "1.8cm")

writeLines(latex_table, out_tex_fragment)

## =========================
## FULL LATEX DOCUMENT
## =========================

latex_doc <- paste0(
  "\\documentclass[11pt]{article}
\\usepackage[margin=0.6in]{geometry}
\\usepackage{booktabs}
\\usepackage{array}
\\usepackage{float}
\\usepackage{graphicx}
\\usepackage{caption}
\\usepackage{makecell}
\\pagestyle{empty}
\\renewcommand{\\arraystretch}{1.15}
\\setlength{\\tabcolsep}{7pt}

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
## COMPILE PDF
## =========================

tinytex::latexmk(out_tex_full)

compiled_pdf <- sub("\\.tex$", ".pdf", out_tex_full)

file.copy(compiled_pdf, out_pdf, overwrite = TRUE)

## =========================
## CONVERT PDF TO PNG
## =========================

img <- magick::image_read_pdf(out_pdf, density = 600)
img <- magick::image_trim(img)
img <- magick::image_border(img, color = "white", geometry = "40x40")
magick::image_write(img, path = out_png, format = "png")

## =========================
## DONE
## =========================

message("Wrote: ", out_tex_fragment)
message("Wrote: ", out_tex_full)
message("Wrote: ", out_pdf)
message("Wrote: ", out_png)

tinytex::reinstall_tinytex(repository = "illinois")
