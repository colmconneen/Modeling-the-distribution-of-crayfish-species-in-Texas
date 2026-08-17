# =============================================================================
# clarkii_simulans_occurrence_maps_sidebyside.R
#
# Combines the P. clarkii and P. simulans Texas presence/absence maps
# (originally two separate scripts, each producing its own PDF) into a
# single figure with the two maps side by side and one shared legend.
#
# Outputs:
#   - Texas_clarkii_simulans_occurrence_map.pdf
#   - Texas_clarkii_simulans_occurrence_map.png
#
# Required packages:
# install.packages(c("tigris", "dplyr", "sf", "ggplot2", "cowplot"))
# =============================================================================

library(tigris)
library(dplyr)
library(sf)
library(ggplot2)
library(cowplot)

options(tigris_use_cache = TRUE)
options(tigris_class = "sf")

# -----------------------------------------------------------------------------
# 1. TEXAS BASEMAP LAYER (downloaded once, shared by both panels)
#
# Only the county boundaries are used now -- the Texas state outline layer
# has been removed from the map.
# -----------------------------------------------------------------------------

tx_counties <- counties(state = "TX", cb = TRUE) %>%
  st_transform(crs = 4326)

# -----------------------------------------------------------------------------
# 2. LOAD OCCURRENCE DATA FOR EACH SPECIES
# -----------------------------------------------------------------------------

clarkii.pres.abs <- read.csv("PCNM_results clarkii w pca.csv")
simulans.pres.abs <- read.csv("PCNM_results simulans w pca.csv")

clarkii_sf <- st_as_sf(clarkii.pres.abs, coords = c("X", "Y"), crs = 4326)
clarkii_sf$presence <- factor(
  clarkii_sf$presence,
  levels = c(1, 0),
  labels = c("Presence", "Absence")
)

simulans_sf <- st_as_sf(simulans.pres.abs, coords = c("X", "Y"), crs = 4326)
simulans_sf$presence <- factor(
  simulans_sf$presence,
  levels = c(1, 0),
  labels = c("Presence", "Absence")
)

# -----------------------------------------------------------------------------
# 3. SELECT ONLY THE COUNTIES "SPANNED" BY EACH SPECIES' OCCURRENCE POINTS
#
# Rather than showing every TX county clipped to a bounding box, we only draw
# counties that either (a) contain an occurrence/absence point, or (b) lie
# along a straight-line transect between any two points for that species.
#
# Computational note: checking every pairwise transect between n points is
# O(n^2) line segments. Because a straight line between any two points inside
# a convex polygon lies entirely within that polygon, the union of *all*
# pairwise transects for a point set is exactly contained within the convex
# hull of that point set. So intersecting the counties layer with the convex
# hull of the points gives the same set of "spanned" counties as the
# brute-force pairwise-transect approach, in O(n) instead of O(n^2) -- it also
# automatically includes any county that directly contains a point.
# -----------------------------------------------------------------------------

get_spanned_counties <- function(points_sf, counties_sf) {
  hull <- st_convex_hull(st_union(points_sf))
  keep <- lengths(st_intersects(counties_sf, hull)) > 0
  counties_sf[keep, ]
}

clarkii_counties <- get_spanned_counties(clarkii_sf, tx_counties)
simulans_counties <- get_spanned_counties(simulans_sf, tx_counties)

# -----------------------------------------------------------------------------
# 4. MAP EXTENT PER SPECIES
#
# Each panel is buffered +/- 1 degree lat-long from that species' own most
# extreme occurrence points (not a shared/combined extent).
# -----------------------------------------------------------------------------

padding <- 1  # degrees buffer

get_extent <- function(points_sf, padding) {
  bbox <- st_bbox(points_sf)
  list(
    xlim = c(bbox$xmin - padding, bbox$xmax + padding),
    ylim = c(bbox$ymin - padding, bbox$ymax + padding)
  )
}

clarkii_extent <- get_extent(clarkii_sf, padding)
simulans_extent <- get_extent(simulans_sf, padding)

# -----------------------------------------------------------------------------
# 5. MAP-BUILDING FUNCTION
# -----------------------------------------------------------------------------

make_occurrence_map <- function(
    points_sf,
    counties_sf,
    extent,
    plot_title,
    include_legend = TRUE
) {
  p <- ggplot() +
    geom_sf(data = counties_sf, fill = NA, color = "grey60") +
    geom_sf(data = points_sf, aes(shape = presence), size = 1.7, color = "red") +
    scale_shape_manual(values = c("Presence" = 4, "Absence" = 1)) +
    coord_sf(xlim = extent$xlim, ylim = extent$ylim, expand = FALSE) +
    labs(title = plot_title, shape = "Observation") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  if (!include_legend) {
    p <- p + theme(legend.position = "none")
  }

  p
}

# -----------------------------------------------------------------------------
# 6. BUILD INDIVIDUAL PANELS
# -----------------------------------------------------------------------------

clarkii_map <- make_occurrence_map(
  clarkii_sf,
  clarkii_counties,
  clarkii_extent,
  plot_title = expression(italic("P. clarkii")~"Presence/Absence"),
  include_legend = FALSE
)

simulans_map <- make_occurrence_map(
  simulans_sf,
  simulans_counties,
  simulans_extent,
  plot_title = expression(italic("P. simulans")~"Presence/Absence"),
  include_legend = FALSE
)

# -----------------------------------------------------------------------------
# 7. SHARED LEGEND
# -----------------------------------------------------------------------------

legend_source <- make_occurrence_map(
  clarkii_sf,
  clarkii_counties,
  clarkii_extent,
  plot_title = "",
  include_legend = TRUE
)

shared_legend <- get_legend(
  legend_source + theme(legend.position = "right")
)

# -----------------------------------------------------------------------------
# 8. ASSEMBLE SIDE-BY-SIDE FIGURE
# -----------------------------------------------------------------------------

maps_row <- plot_grid(
  clarkii_map,
  simulans_map,
  nrow = 1,
  align = "hv",
  axis = "tblr",
  labels = c("(A)", "(B)")
)

figure_final <- plot_grid(
  maps_row,
  shared_legend,
  nrow = 1,
  rel_widths = c(1, 0.15)
)

# -----------------------------------------------------------------------------
# 9. SAVE
# -----------------------------------------------------------------------------

ggsave(
  filename = "Texas_clarkii_simulans_occurrence_map_county_extent.pdf",
  plot = figure_final,
  width = 14,
  height = 6,
  units = "in"
)

ggsave(
  filename = "Texas_clarkii_simulans_occurrence_map_county_extent.png",
  plot = figure_final,
  width = 14,
  height = 6,
  units = "in",
  dpi = 600,
  bg = "white"
)

message("Done. Saved Texas_clarkii_simulans_occurrence_map_county_extent.pdf and .png")
