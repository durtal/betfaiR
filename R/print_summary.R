#' @export
print.marketCatalogue_simple <- function(x) {

    cat("\nMarket ID:\t", x$market$marketId)
    cat("\nMarket Name:\t", x$market$marketName)
    cat("\nMatched:\t", x$market$totalMatched)

    w <- options()$width
    cat("\n\n", rep("*", w/2))

}


#' @export
summary.marketCatalogue_simple <- function(x) {

    id <- paste0("\nMarketID:\t", x$market$marketId)
    name <- paste0("\nMarket Name:\t", x$market$marketName)
    matched <- paste0("\nMatched:\t", x$market$totalMatched)

    if(!is.null(x$event)) {

        id <- paste0(id, "\tEvent ID:\t", x$event$id)
        name <- paste0(name, "\tEvent Name:\t", x$event$name)
    }

    cat(id, name, matched)

    if(!is.null(x$runners)) {
        cat("\nRunners:\t", nrow(x$runners), "\n")
        print(head(x$runners), row.names = FALSE)
    }

    w <- options()$width
    cat("\n", rep("*", w/2))
}

#' @export
print.marketCatalogue_list <- function(x) {

    plyr::l_ply(x, .fun = function(i) {

        print(i)

    })
}


#' @export
summary.marketCatalogue_list <- function(x) {

    plyr::l_ply(x, .fun = function(i) {

        summary(i)

    })
}
