#' @export
print.marketCatalogue_simple <- function(x) {

    cat("\nMarket ID:\t\t", x$market$marketId)
    cat("\nMarket Name:\t\t", x$market$marketName)
    cat("\nMatched:\t\t", x$market$totalMatched)

    w <- options()$width
    cat("\n", rep("-", w/2))

}


#' @export
summary.marketCatalogue_simple <- function(x) {

    id <- paste0("\nMarket ID:\t\t", x$market$marketId)
    name <- paste0("\nMarket Name:\t\t", x$market$marketName)
    matched <- paste0("\nMatched:\t\t", x$market$totalMatched)

    if(!is.null(x$event)) {

        id <- paste0(id, "\nEvent ID:\t\t", x$event$id)
        name <- paste0(name, "\nEvent Name:\t\t", x$event$name)
    }

    cat(id, name, matched)

    if(!is.null(x$runners)) {
        cat("\n\nRunners:\t", nrow(x$runners), "\n")
        print(head(x$runners), row.names = FALSE)
    }

    w <- options()$width
    cat("\n", rep("-", w/2))
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

#' @export
print.marketBook_simple <- function(x) {

    marketId <- paste0("\nMarket ID:\t\t", x$market$marketId)
    totalMatched <- paste0("\nMatched:\t\t", x$market$totalMatched)
    totalAvailable <- paste0("\nAvailable:\t\t", x$market$totalAvailable)

    cat(marketId, totalMatched, totalAvailable)

    w <- options()$width
    cat("\n", rep("-", w/2))

}

#' @export
summary.marketBook_simple <- function(x) {

    marketId <- paste0("\nMarket ID:\t\t", x$market$marketId)
    totalMatched <- paste0("\nMatched:\t\t", x$market$totalMatched)
    totalAvailable <- paste0("\nAvailable:\t\t", x$market$totalAvailable)

    cat(marketId, totalMatched, totalAvailable)

    if(!is.null(x$runners)) {
        runners_basic <- plyr::ldply(x$runners, .fun = function(x) {
            x$basic
        })
        cat("\nRunners:\n")
        print(runners_basic, row.names = FALSE)
    }

}

#' @export
print.marketBook_list <- function(x) {

    plyr::l_ply(x, .fun = function(i) {

        print(i)

    })
}


#' @export
summary.marketBook_list <- function(x) {

    plyr::l_ply(x, .fun = function(i) {

        summary(i)

    })
}
