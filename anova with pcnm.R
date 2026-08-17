## =========================
## MAKE PUBLICATION TABLE
## PCNM renamed to MEM
## Outputs: .tex, .pdf, .png
## =========================

library(dplyr)
library(kableExtra)
library(tinytex)
library(magick)

## =========================
## OUTPUT FILES
## =========================

out_tex_fragment <- "MEM_lrm_summary_table_fragment.tex"
out_tex_full     <- "MEM_lrm_summary_table_full.tex"
out_pdf          <- "MEM_lrm_summary_table.pdf"
out_png          <- "MEM_lrm_summary_table.png"

## =========================
## TABLE DATA
## =========================

tab <- tibble::tribble(
  ~Source, ~clarkii_dev, ~clarkii_p, ~simulans_dev, ~simulans_p,
  "MEM1",  "1.74",  "0.188", "0.99", "0.321", 
  "MEM2",  "4.56", "0.033*", "0.74", "0.390", 
  "MEM3",  "3.51", "0.061", "1.58", "0.208",
  "PC1",   "6.02", "0.014*", "0.22", "0.640", 
  "PC2",   "3.14", "0.077", "0.58", "0.445", 
  "PC3",   "0.12", "0.725", "3.09", "0.079", 
  "PC4",   "0.03", "0.854", "2.61", "0.106",
  "PC5",   "1.02", "0.313", "0.98", "0.323"
)

## =========================
## COLUMN NAMES
## =========================

colnames(tab) <- c(
  "Source",
  "Chi-Square", "P-value",
  "Chi-Square", "P-value"
  
)

## =========================
## MAKE LATEX TABLE
## Species headers use math mode instead of \textit{}
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
      "$P.\\ simulans$" = 2
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