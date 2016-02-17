theme_betfair <- function(base_size = 10, base_family = "", ...) {

    ggplot2::theme(
        line =                  ggplot2::element_line(colour = "#000000", size = 0.5, linetype = 1, lineend = "butt"),
        rect =                  ggplot2::element_rect(fill = "#fcfcfc", colour = "#fcfcfc", size = 0.5, linetype = 1),
        text =                  ggplot2::element_text(family = base_family, face = "plain", colour = "#000000",
                                                      size = base_size, hjust = 0.5, vjust = 0.5, angle = 0,
                                                      lineheight = 0.9),
        axis.text =             ggplot2::element_text(size = ggplot2::rel(1), colour = "#000000"),
        strip.text =            ggplot2::element_text(size = ggplot2::rel(1)),
        axis.line =             ggplot2::element_blank(),
        axis.text.x =           ggplot2::element_text(vjust = 1, size = ggplot2::rel(0.9)),
        axis.text.y =           ggplot2::element_text(hjust = 1, size = ggplot2::rel(0.9)),
        axis.ticks =            ggplot2::element_blank(),
        axis.title.x =          ggplot2::element_text(size = ggplot2::rel(0.95)),
        axis.title.y =          ggplot2::element_text(size = ggplot2::rel(0.95), angle = 90),
        legend.background =     ggplot2::element_rect(color = "#fcfcfc"),
        legend.margin =         grid::unit(0.2, "cm"),
        legend.key =            ggplot2::element_rect(fill = "#fcfcfc", colour = "#d8d8d8"),
        legend.key.size =       grid::unit(1.2, "lines"),
        legend.key.height =     NULL,
        legend.key.width =      NULL,
        legend.text =           ggplot2::element_text(size = ggplot2::rel(0.95)),
        legend.text.align =     NULL,
        legend.title =          ggplot2::element_blank(),
        legend.position =       "bottom",
        legend.justification =  "center",
        legend.box =            NULL,
        panel.background =      ggplot2::element_rect(fill = "#fcfcfc", colour = NA),
        # panel.border =          ggplot2::element_rect(fill = NA, colour = "#fcfcfc"),
        panel.grid.major =      ggplot2::element_line(colour = "#d8d8d8"),
        panel.grid.minor =      ggplot2::element_line(colour = "#f2f2f2", size = 0.1),
        panel.margin =          grid::unit(0.25, "lines"),
        panel.margin.x =        NULL,
        panel.margin.y =        NULL,
        strip.background =      ggplot2::element_rect(fill = "#fcfcfc", colour = NA),
        strip.text.x =          ggplot2::element_text(),
        strip.text.y =          ggplot2::element_text(angle = -90),
        plot.background =       ggplot2::element_rect(fill = "#fcfcfc"),
        plot.title =            ggplot2::element_text(size = ggplot2::rel(1.2), colour = "#000000", hjust = 0),
        plot.margin =           grid::unit(c(1, 1, 0.5, 0.5), "lines")
    )
}

# function from Todd Schneider https://github.com/toddwschneider/nyc-citibike-data/blob/61c1855d8f95be108fb4f84ef218b9c808b50854/analysis/helpers.R#L28-L34
title_with_subtitle = function(title, subtitle = NA) {
  if (is.na(subtitle)) {
    ggtitle(bquote(bold(.(title))))
  } else {
    ggtitle(bquote(atop(bold(.(title)), atop(.(subtitle)))))
  }
}

betfair_palette <- c("Arsenal" = "#EF0107", "Leicester" = "#0053A0",
                     "The Draw" = "#CD9B9B",
                     "Man City" = "#5DBFEB", "Tottenham" = "#001C58")
