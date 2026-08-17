# =============================================================================
# clarkii_PC1_response_curve.R
#
# Simplified figure: habitat-suitability response curve for P. clarkii vs PC1
# only. No other species, no other PCs, no loading-arrow panels, no legend.
#
# Outputs:
#   - Vector PDF for publication-quality text and lines
#   - 600-dpi PNG
#
# Required packages:
# install.packages(c("ggplot2", "rms", "cowplot"))
# =============================================================================

library(ggplot2)
library(rms)      # required for lrm()
library(cowplot)  # required to stack the response curve and loading panel
library(grid)

# -----------------------------------------------------------------------------
# 1. LOAD DATA AND FIT MODEL (P. clarkii only)
# -----------------------------------------------------------------------------

clarkii_data <- read.csv("PCNM_results clarkii w pca.csv")

full.model.PCNM.c <- lrm(
  presence ~ PCNM1 + PCNM2 + PCNM3 +
    pca_1 + pca_2 + pca_3 + pca_4 + pca_5,
  data = clarkii_data
)

# -----------------------------------------------------------------------------
# 2. SETTINGS
# -----------------------------------------------------------------------------

OUT_BASENAME <- "clarkii_PC1_response_curve"
OUT_WIDTH_CM <- 10
OUT_HEIGHT_CM <- 10
OUT_DPI <- 600

N_CURVE_POINTS <- 300

clarkii_colour <- "#E03112"

# Label-layout settings for the loading-arrow panel
MAX_LABELS_PER_COLUMN <- 5
LOADING_TEXT_SIZE <- 2.35
ARROW_LINEWIDTH <- 0.55
ARROW_HEAD_LENGTH_PT <- 5.5
LOADING_PANEL_REL_HEIGHT <- 0.66
LOADING_LABEL_ROW_STEP <- 0.072

# -----------------------------------------------------------------------------
# VARIABLES THAT LOAD POSITIVELY OR NEGATIVELY ON PC1
# -----------------------------------------------------------------------------

NEG_LABELS_PC1 <- c(
  "slope of flowline",
  "slope length",
  "catchment area",
  "mean diurnal range"
)

POS_LABELS_PC1 <- c(
  "minimum temperature of the warmest month",
  "annual precipitation",
  "precipitation of the wettest month",
  "precipitation of the driest month",
  "precipitation of the wettest quarter",
  "precipitation of the driest quarter",
  "precipitation of the coldest quarter"
)

# -----------------------------------------------------------------------------
# 3. SHARED PUBLICATION THEME
# -----------------------------------------------------------------------------

theme_publication <- function(base_size = 10) {
  theme_classic(base_size = base_size) +
    theme(
      axis.line = element_line(colour = "black", linewidth = 0.45),
      axis.ticks = element_line(colour = "black", linewidth = 0.35),
      axis.ticks.length = unit(2, "pt"),
      axis.text = element_text(colour = "black", size = base_size - 1),
      axis.title = element_text(
        colour = "black",
        size = base_size,
        face = "bold"
      ),
      panel.background = element_rect(fill = "white", colour = NA),
      panel.border = element_rect(
        fill = NA,
        colour = "black",
        linewidth = 0.45
      ),
      panel.grid.major = element_line(colour = "grey92", linewidth = 0.25),
      panel.grid.minor = element_blank(),
      plot.margin = margin(5, 6, 5, 5, "pt")
    )
}

# -----------------------------------------------------------------------------
# 4. HELPER FUNCTIONS FOR ROBUST PREDICTION DATA
# -----------------------------------------------------------------------------

representative_value <- function(x) {
  if (is.numeric(x) || is.integer(x)) {
    return(stats::median(x, na.rm = TRUE))
  }

  if (is.factor(x)) {
    return(factor(levels(x)[1], levels = levels(x)))
  }

  if (is.logical(x)) {
    return(FALSE)
  }

  if (is.character(x)) {
    non_missing <- x[!is.na(x)]
    return(if (length(non_missing) > 0) non_missing[1] else "")
  }

  stop("Unsupported predictor type: ", class(x)[1])
}

make_reference_row <- function(model, data) {
  predictor_names <- all.vars(delete.response(terms(model)))

  missing_predictors <- setdiff(predictor_names, names(data))

  if (length(missing_predictors) > 0) {
    stop(
      "The following predictors required by the model are missing from the ",
      "data frame: ",
      paste(missing_predictors, collapse = ", ")
    )
  }

  values <- lapply(data[predictor_names], representative_value)
  as.data.frame(values, stringsAsFactors = FALSE)
}

# -----------------------------------------------------------------------------
# 5. BUILD THE PC1 RESPONSE CURVE (P. clarkii only)
# -----------------------------------------------------------------------------

pc_name <- "pca_1"
pc_range <- range(clarkii_data[[pc_name]], na.rm = TRUE)

reference_row <- make_reference_row(full.model.PCNM.c, clarkii_data)
new_data <- reference_row[rep(1, N_CURVE_POINTS), , drop = FALSE]
new_data[[pc_name]] <- seq(pc_range[1], pc_range[2], length.out = N_CURVE_POINTS)

predicted <- predict(full.model.PCNM.c, newdata = new_data, type = "fitted")

curve_df <- data.frame(
  pc_value = new_data[[pc_name]],
  predicted_suitability = as.numeric(predicted)
)

observed_predicted <- predict(full.model.PCNM.c, newdata = clarkii_data, type = "fitted")

point_df <- data.frame(
  pc_value = clarkii_data[[pc_name]],
  predicted_suitability = as.numeric(observed_predicted)
)

# -----------------------------------------------------------------------------
# 6. PLOT
# -----------------------------------------------------------------------------

p <- ggplot() +
  geom_vline(
    xintercept = 0,
    linetype = "dotted",
    colour = "grey60",
    linewidth = 0.45
  ) +
  geom_point(
    data = point_df,
    aes(x = pc_value, y = predicted_suitability),
    colour = clarkii_colour,
    shape = 16,
    size = 1.5,
    alpha = 0.55,
    stroke = 0.3,
    na.rm = TRUE
  ) +
  geom_line(
    data = curve_df,
    aes(x = pc_value, y = predicted_suitability),
    colour = clarkii_colour,
    linewidth = 0.9,
    na.rm = TRUE
  ) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, by = 0.25),
    expand = expansion(mult = c(0, 0.03))
  ) +
  labs(
    x = bquote(bold(PC[1])),
    y = "Habitat Suitability"
  ) +
  theme_publication(base_size = 10)

# -----------------------------------------------------------------------------
# 7. LOADING-DIRECTION PANEL (PC1 only)
#
# Draws a separate panel beneath the response curve showing which
# environmental variables load positively / negatively on PC1.
# -----------------------------------------------------------------------------

split_into_columns <- function(labels, max_per_column = MAX_LABELS_PER_COLUMN) {
  labels <- labels[nzchar(labels)]

  if (length(labels) == 0) {
    return(data.frame())
  }

  column_number <- ceiling(seq_along(labels) / max_per_column)
  row_number <- ave(seq_along(labels), column_number, FUN = seq_along)

  data.frame(
    label = labels,
    column = column_number,
    row = row_number,
    stringsAsFactors = FALSE
  )
}

add_arrow_group <- function(
    plot_object,
    labels,
    direction = c("positive", "negative"),
    arrow_y,
    first_label_y,
    row_step = LOADING_LABEL_ROW_STEP
) {
  direction <- match.arg(direction)
  label_df <- split_into_columns(labels)

  if (nrow(label_df) == 0) {
    return(plot_object)
  }

  n_columns <- max(label_df$column)

  # Keep labels within each half-width panel while allowing multiple columns.
  if (n_columns == 1) {
    x_starts <- 0.04
  } else {
    x_starts <- seq(0.04, 0.54, length.out = n_columns)
  }

  label_df$x <- x_starts[label_df$column]

  # Use a fixed decrement for every line so spacing stays consistent.
  label_df$y <- first_label_y - (label_df$row - 1) * row_step

  if (direction == "positive") {
    x_start <- 0.04
    x_end <- 0.96
  } else {
    x_start <- 0.96
    x_end <- 0.04
  }

  plot_object +
    annotate(
      "segment",
      x = x_start,
      xend = x_end,
      y = arrow_y,
      yend = arrow_y,
      linewidth = ARROW_LINEWIDTH,
      arrow = arrow(
        length = unit(ARROW_HEAD_LENGTH_PT, "pt"),
        type = "closed"
      )
    ) +
    geom_text(
      data = label_df,
      aes(x = x, y = y, label = label),
      hjust = 0,
      vjust = 1,
      size = LOADING_TEXT_SIZE,
      lineheight = 0.9
    )
}

make_loading_panel <- function(positive_labels, negative_labels) {
  positive_labels <- positive_labels[!is.na(positive_labels) & nzchar(positive_labels)]
  negative_labels <- negative_labels[!is.na(negative_labels) & nzchar(negative_labels)]

  has_positive <- length(positive_labels) > 0
  has_negative <- length(negative_labels) > 0

  loading_p <- ggplot() +
    scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
    scale_y_continuous(limits = c(0, 1), expand = c(0, 0)) +
    coord_cartesian(clip = "off") +
    theme_void() +
    theme(plot.margin = margin(1, 5, 2, 5, "pt"))

  if (has_positive && has_negative) {
    loading_p <- add_arrow_group(
      loading_p,
      labels = positive_labels,
      direction = "positive",
      arrow_y = 0.94,
      first_label_y = 0.84
    )

    loading_p <- add_arrow_group(
      loading_p,
      labels = negative_labels,
      direction = "negative",
      arrow_y = 0.45,
      first_label_y = 0.34
    )
  }

  if (has_positive && !has_negative) {
    loading_p <- add_arrow_group(
      loading_p,
      labels = positive_labels,
      direction = "positive",
      arrow_y = 0.90,
      first_label_y = 0.76
    )
  }

  if (!has_positive && has_negative) {
    loading_p <- add_arrow_group(
      loading_p,
      labels = negative_labels,
      direction = "negative",
      arrow_y = 0.90,
      first_label_y = 0.76
    )
  }

  loading_p
}

loading_panel <- make_loading_panel(POS_LABELS_PC1, NEG_LABELS_PC1)

# -----------------------------------------------------------------------------
# 8. COMBINE RESPONSE CURVE + LOADING PANEL
# -----------------------------------------------------------------------------

figure_final <- plot_grid(
  p,
  loading_panel,
  ncol = 1,
  rel_heights = c(1, LOADING_PANEL_REL_HEIGHT)
)

# -----------------------------------------------------------------------------
# 9. SAVE
# -----------------------------------------------------------------------------

ggsave(
  filename = paste0(OUT_BASENAME, ".pdf"),
  plot = figure_final,
  width = OUT_WIDTH_CM,
  height = OUT_HEIGHT_CM,
  units = "cm",
  device = cairo_pdf
)

ggsave(
  filename = paste0(OUT_BASENAME, ".png"),
  plot = figure_final,
  width = OUT_WIDTH_CM,
  height = OUT_HEIGHT_CM,
  units = "cm",
  dpi = OUT_DPI,
  bg = "white"
)

message("Done. Saved ", OUT_BASENAME, ".pdf and .png")
