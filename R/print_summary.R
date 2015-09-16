#' @export
print.marketCatalogue_list <- function(x) {

    plyr::l_ply(x, .fun = function(i) {
        cat("\nMarket ID:\t\t", i$market$marketId)
        cat("\nMarket Name:\t\t", i$market$marketName)
        cat("\ntotalMatched:\t\t", i$market$totalMatched)

        w <- options()$width
        cat("\n\n", rep("*", w/2), "\n")
    })
}


#' @export
summary.marketCatalogue_list <- function(x) {

    plyr::l_ply(x, .fun = function(i) {
        cat("\nMarket ID:\t\t", i$market$marketId)
        cat("\nMarket Name:\t\t", i$market$marketName)
        cat("\nMatched:\t\t", i$market$totalMatched)

        if(!is.null(i$event)) {
            cat("\n\nEvent ID:\t\t", i$event$id)
            cat("\nEvent Name:\t\t", i$event$name)
            cat("\n")
        }

        if(!is.null(i$runners)) {
            cat("\nRunners:\t", nrow(i$runners), "\n")
            print(head(i$runners), row.names = FALSE)
        }
        w <- options()$width
        cat("\n", rep("*", w/2), "\n")
    })
}
