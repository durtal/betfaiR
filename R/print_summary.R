#' @export
print.marketCatalogue_simple <- function(x, ...) {

    cat("\nMarket ID:     \t", x$market$marketId)
    cat("\nMarket Name:   \t", x$market$marketName)
    cat("\nMatched:       \t", x$market$totalMatched)

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))

}


#' @export
summary.marketCatalogue_simple <- function(object, ...) {

    x <- object
    id <- paste0("\nMarket ID:     \t", x$market$marketId)
    name <- paste0("\nMarket Name:   \t", x$market$marketName)
    matched <- paste0("\nMatched:       \t", x$market$totalMatched)

    if(!is.null(x$event)) {

        id <- paste0(id, "\nEvent ID:      \t", x$event$id)
        name <- paste0(name, "\nEvent Name:    \t", x$event$name)
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
print.marketCatalogue_list <- function(x, ...) {

    plyr::l_ply(x, .fun = function(i) {
        print(i)
    })
}


#' @export
summary.marketCatalogue_list <- function(object, ...) {

    x <- object
    plyr::l_ply(x, .fun = function(i) {

        summary(i)

    })
}

#' @export
print.marketBook_simple <- function(x, ...) {

    marketId <- paste0("\nMarket ID:     \t", x$market$marketId)
    totalMatched <- paste0("\nMatched:       \t", x$market$totalMatched)
    totalAvailable <- paste0("\nAvailable:     \t", x$market$totalAvailable)

    cat(marketId, totalMatched, totalAvailable)

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))

}

#' @export
summary.marketBook_simple <- function(object, ...) {

    x <- object
    marketId <- paste0("\nMarket ID:     \t", x$market$marketId)
    totalMatched <- paste0("\nMatched:       \t", x$market$totalMatched)
    totalAvailable <- paste0("\nAvailable:     \t", x$market$totalAvailable)

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
print.marketBook_list <- function(x, ...) {

    plyr::l_ply(x, .fun = function(i) {
        print(i)
    })
}


#' @export
summary.marketBook_list <- function(object, ...) {

    x <- object
    plyr::l_ply(x, .fun = function(i) {

        summary(i)

    })
}

#' @export
print.betfair_orders <- function(x, ...) {

    status <- paste0("\nStatus:        \t", x$status, "\n")
    market <- paste0("MarketId:      \t", x$marketId, "\n")

    cat(status)
    cat(market)
}

#' @export
summary.betfair_orders <- function(object, ...) {

    x <- object
    status <- paste0("\nStatus:        \t", x$status, "\n")
    market <- paste0("MarketId:      \t", x$marketId, "\n\nOrder:\n")

    cat(status)
    cat(market)

    print(x$order, row.names = FALSE, ...)
    cat("\nInstructions:\n")
    print(x$orderInstruction, row.names = FALSE)
}

#' @export
print.bf_cancel_orders <- function(x, ...) {
    cat("\nStatus:\t", x$status)
}

#' @export
summary.bf_cancel_orders <- function(object, ...) {

    x <- object
    cat("\nStatus:\t", x$status)
    if(length(x$instructions) > 0) {
        cat("\n\nOrders:\n")
        tmp <- plyr::ldply(x$instructions)
        print(tmp, row.names = FALSE)
    }
}

#' @export
print.bf_replace_orders <- function(x, ...) {
    cat("\nStatus:       \t", x$status)
    cat("\nCancel Status:\t", x$cancel$status)
    cat("\n              \t", x$cancel$selectionId)
    cat("\nPlace Status: \t", x$place$status)
    cat("\n              \t", x$place$selectionId)
}

#' @export
summary.bf_replace_orders <- function(object, ...) {

    x <- object
    cat("\nStatus:       \t", x$status)
    cat("\nCancel Status:\t", x$cancel$status)
    cat("\n              \t", x$cancel$selectionId)
    cat("\nPlace Status: \t", x$place$status, "\nInstructions:\n")
    print(x$place, row.names = FALSE)
}

#' @export
print.market_PnL <- function(x, ...) {
    cat("\nMarketId:\t", x$marketId, "\nRunners:\n")
    print(x$PnL, row.names = FALSE)

}

#' @export
print.marketPnL_list <- function(x, ...) {

    plyr::l_ply(x, .fun = function(i) {
        print(i)
    })
}

#' @export
summary.market_PnL <- function(object, ...) {

    x <- object
    cat("\nMarketId:\t", x$marketId, "\nRunners:\n")
    print(x$PnL, row.names = FALSE)
}

#' @export
summary.marketPnL_list <- function(object, ...) {

    x <- object
    plyr::l_ply(x, .fun = function(i) {
        summary(i)
    })
}

#' @export
print.currentOrders <- function(x, ...) {
    cat("Current Orders:\n\n")
    cat("Returned:     ", length(x$current), "records\n")
}

#' @export
summary.currentOrders <- function(object, ...) {

    x <- object
    cat("Current Orders:\n\n")
    cat("Returned:     ", length(x$current), "records\n")
    plyr::l_ply(x$current, function(i) {
        tmp <- data.frame(betId = i$betId,
                          marketId = i$marketId,
                          side = i$side,
                          price = i$price,
                          size = i$size)
        print(tmp, row.names = FALSE)
        cat("\n")
    })
}

#' @export
print.clearedOrders <- function(x, ...) {
    cat("Cleared Orders:\n\n")
    cat("Returned:      ", length(x$cleared), "records\n")
}

#' @export
summary.clearedOrders <- function(object, ...) {

    x <- object
    cat("Cleared Orders:\n\n")
    cat("Returned:      ", length(x$cleared), "records\n")
    plyr::l_ply(x$cleared, function(i) {
        tmp <- data.frame(betId = i$betId,
                          marketId = i$marketId,
                          side = i$side,
                          price = i$priceMatched,
                          size = i$size,
                          outcome = i$betOutcome,
                          profit = i$profit)
        print(tmp, row.names = FALSE)
        cat("\n")
    })
}

#' @export
print.bf_transaction <- function(x, ...) {

    cat("\nDate:            \t", x$basic$itemDate, "\n")
    cat("Amount:          \t", x$basic$amount, "\n")
    cat("Balance:         \t", x$basic$balance, "\n")

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))
}

#' @export
summary.bf_transaction <- function(object, ...) {

    x <- object
    cat("\nDate:            \t", x$basic$itemDate, "\n")
    cat("Amount:          \t", x$basic$amount, "\n")
    cat("Balance:         \t", x$basic$balance, "\n")

    cat("\nFull Market Name:\t", x$transaction$fullMarketName, "\n")
    cat("Avg Price:       \t", x$transaction$avgPrice, "\n")
    cat("Bet Size:        \t", x$transaction$betSize, "\n")
    cat("Win/Lose:       \t", x$transaction$winLose, "\n")

    w <- options()$width
    cat("\n", paste0(rep("-", w), collapse = ""))
}

#' @export
print.account_statement <- function(x, ...) {
    plyr::l_ply(x, .fun = function(i) {
        print(i)
    })
}

#' @export
summary.account_statement <- function(object, ...) {

    x <- object
    plyr::l_ply(x, .fun = function(i) {
        summary(i)
    })
}

#' @export
plot.account_statement <- function(x, ...) {
    df <- lapply(x, function(i) {
        i$basic
    })
    df <- plyr::ldply(df)
    df$itemDate <- strptime(df$itemDate, "%Y-%m-%dT%H:%M:%S")
    startDate <- strptime(min(df$itemDate), "%Y-%m-%d")
    endDate <- strptime(max(df$itemDate), "%Y-%m-%d")
    title <- "Betfair Balance - Profit/Loss"
    subtitle <- paste0(startDate, " to ", endDate)
    p <- ggplot2::ggplot(data = df) +
        ggplot2::geom_path(ggplot2::aes(x = df$itemDate,
                                        y = df$balance),
                           col = "#D9220F",
                           size = 1.1)
    p <- p +
        ggplot2::labs(x = "Date",
                      y = "Balance",
                      title = title)
    p <- p +
        betfair_theme()
    p <- p +
        ggplot2::ggtitle(bquote(atop(bold(.(title)), atop(.(subtitle)))))
    p
}
