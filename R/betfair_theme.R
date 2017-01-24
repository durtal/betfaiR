#' betfair_theme
#'
#' @description ggplot2 theme for betfaiR package plots, theme is used to plot the
#' output of the \link{statement} method
#'
#' @param base_size font size
#' @param base_family font family
#'
#' @export
betfair_theme <- function(base_size = 10, base_family = "") {
    ggplot2::theme(
        line = ggplot2::element_line(colour = "#E1E1D0",
                                     linetype = 1,
                                     lineend = "butt"),
        rect = ggplot2::element_rect(fill = "#FFFFFF",
                                     colour = "#E1E1D0",
                                     size = 1,
                                     linetype = 1),
        text = ggplot2::element_text(family = base_family,
                                     face = "plain",
                                     size = base_size,
                                     colour = "#000000"),
        panel.background = ggplot2::element_rect(fill = "#FFFFFF"),
        plot.background = ggplot2::element_rect(fill = "#FFFFFF"),
        axis.text = ggplot2::element_text(size = ggplot2::rel(0.80)),
        axis.title = ggplot2::element_text(size = ggplot2::rel(0.90),
                                           colour = "#000000",
                                           face = "bold"),
        plot.title = ggplot2::element_text(size = ggplot2::rel(1.05),
                                           face = "bold",
                                           hjust = 0),
        panel.grid.major = ggplot2::element_line(colour = "#E1E1D0"),
        axis.ticks = ggplot2::element_line(colour = "#E1E1D0")
    )
}
