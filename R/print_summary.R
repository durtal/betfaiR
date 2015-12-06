#' @export
print.marketCatalogue_simple <- function(x) {

    cat("\nMarket ID:  \t", x$market$marketId)
    cat("\nMarket Name:\t", x$market$marketName)
    cat("\nMatched:    \t", x$market$totalMatched)

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))

}


#' @export
summary.marketCatalogue_simple <- function(x) {

    id <- paste0("\nMarket ID:  \t", x$market$marketId)
    name <- paste0("\nMarket Name:\t", x$market$marketName)
    matched <- paste0("\nMatched:     \t", x$market$totalMatched)

    if(!is.null(x$event)) {

        id <- paste0(id, "\nEvent ID:  \t", x$event$id)
        name <- paste0(name, "\nEvent Name:\t", x$event$name)
    }

    cat(id, name, matched)

    if(!is.null(x$runners)) {
        cat("\n\nRunners:\t", nrow(x$runners), "\n")
        print(head(x$runners), row.names = FALSE)
    }

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))
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

    marketId <- paste0("\nMarket ID:\t", x$market$marketId)
    totalMatched <- paste0("\nMatched:  \t", x$market$totalMatched)
    totalAvailable <- paste0("\nAvailable:\t", x$market$totalAvailable)

    cat(marketId, totalMatched, totalAvailable)

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))

}

#' @export
summary.marketBook_simple <- function(x) {

    marketId <- paste0("\nMarket ID:\t", x$market$marketId)
    totalMatched <- paste0("\nMatched:  \t", x$market$totalMatched)
    totalAvailable <- paste0("\nAvailable:\t", x$market$totalAvailable)

    cat(marketId, totalMatched, totalAvailable)

    if(!is.null(x$runners)) {
        runners_basic <- plyr::ldply(x$runners, .fun = function(x) {
            x$basic
        })
        active <- table(runners_basic$status)
        if(length(active)>1) {
            active <- paste0(active[[1]], " (", active[[2]], " removed)")
        } else if(length(active) == 1) {
            active <- active[[1]]
        } else {
            active <- ""
        }
        cat("\n\nRunners:\t", active, "\n")
        print(head(runners_basic), row.names = FALSE)
    }

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))
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

#' @export
print.betfair_orders <- function(x) {

    status <- paste0("\nStatus:  \t", x$status, "\n")
    market <- paste0("MarketId:\t", x$marketId, "\n")

    cat(status)
    cat(market)
}

#' @export
summary.betfair_orders <- function(x) {

    status <- paste0("\nStatus:  \t", x$status, "\n")
    market <- paste0("MarketId:\t", x$marketId, "\n\nOrder:\n")

    cat(status)
    cat(market)

    print(x$order, row.names = FALSE)
    cat("\nInstructions:\n")
    print(x$orderInstruction, row.names = FALSE)
}

#' @export
print.bf_cancel_orders <- function(x) {
    cat("\nStatus:\t", x$status)
}

#' @export
summary.bf_cancel_orders <- function(x) {
    cat("\nStatus:\t", x$status)
    if(length(x$instructions) > 0) {
        cat("\n\nOrders:\n")
        tmp <- plyr::ldply(x$instructions)
        print(tmp, row.names = FALSE)
    }
}
