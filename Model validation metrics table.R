## =========================
## MAKE PUBLICATION TABLE
## Evaluation Metrics Table
## Outputs: .tex, .pdf, .png
## =========================

library(dplyr)
library(kableExtra)
library(tinytex)
library(magick)

## =========================
## OUTPUT FILES
## =========================

out_tex_fragment <- "Evaluation_table_lrm_fragment.tex"
out_tex_full     <- "Evaluation_table_lrm_full.tex"
out_pdf          <- "Evaluation_table_lrm.pdf"
out_png          <- "Evaluation_table_lrm.png"

## =========================
## TABLE DATA
## =========================

tab <- tibble::tribble(
  ~Metric, ~clarkii, ~simulans, 
  
  "$\\mathrm{AUC}_{test}$",  "0.952", "0.775",
  "$\\mathrm{AUC}_{train}$", "0.940", "0.870",
  "$\\mathrm{AUC}_{diff}$",  "0.012", "0.095"
)
## =========================
## COLUMN NAMES (SAFE LATEX)
## =========================  

colnames(tab) <- c(
  "Metric",
  "$P. clarkii$",
  "$P. simulans$"
)

## =========================
## MAKE LATEX TABLE
## =========================

latex_table <- kable(
  tab,
  format = "latex",
  booktabs = TRUE,
  escape = FALSE,
  align = c("l", "c", "c")
) %>%
  kable_styling(
    latex_options = c("hold_position"),
    font_size = 10,
    full_width = FALSE,
    position = "center"
  ) %>%
  add_header_above(c("Evaluation Data" = 3)) %>%
  row_spec(0, bold = TRUE) %>%
  column_spec(1, width = "3cm") %>%
  column_spec(2:3, width = "2.2cm")

## save fragment safely
writeLines(as.character(latex_table), out_tex_fragment)

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
\\setlength{\\tabcolsep}{8pt}

\\begin{document}

\\begin{center}
",
  latex_table,
  "

\\end{center}

\\end{document}"
)

writeLines(latex_doc, out_tex_full)

## =========================
## COMPILE PDF
## =========================

tinytex::latexmk(out_tex_full)

compiled_pdf <- sub("\\.tex$", ".pdf", out_tex_full)

file.copy(compiled_pdf, out_pdf, overwrite = TRUE)

## =========================
## PDF → PNG
## =========================

img <- magick::image_read_pdf(out_pdf, density = 600)
img <- magick::image_trim(img)

img <- magick::image_border(
  img,
  color = "white",
  geometry = "40x40"
)

magick::image_write(
  img,
  path = out_png,
  format = "png"
)

## =========================
## DONE
## =========================

message("Wrote: ", out_tex_fragment)
message("Wrote: ", out_tex_full)
message("Wrote: ", out_pdf)
message("Wrote: ", out_png)