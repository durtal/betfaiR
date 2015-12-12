#' bf_parse
#'
#' @description convert response from the various \link{betfair} methods, tries
#' to convert response into useful format, ie. dataframes with zero nested elements
#'
#' @details due to the various methods returning different responses varying in
#' detail and complexity (testing all combinations is tricky), so this function
#' may not be that reliable at the moment
#'
#' @param res response to be parsed into dataframes
#'
#' @export
bf_parse <- function(res, ...) {
    UseMethod(generic = "bf_parse", object = res)
}

#' @export
bf_parse.competitions <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
bf_parse.countries <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
bf_parse.events <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
bf_parse.eventTypes <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
bf_parse.marketBook <- function(res) {

    out <- lapply(res$result, function(x) {

        out <- structure(list(), class = c("list", "marketBook_simple"))
        out$raw <- x
        out$market <- data.frame(x[!sapply(x, is.list)],
                                 stringsAsFactors = FALSE)
        if("runners" %in% names(x)) {
            runners <- lapply(x$runners, function(rnr) {
                basic <- !sapply(rnr, is.list)
                rnr_out <- structure(list(), class = c("list", "marketBook_runner"))
                rnr_out$basic <- data.frame(rnr[basic],
                                            stringsAsFactors = FALSE)
                if("sp" %in% names(rnr) & length(rnr$sp) > 0) {
                    rnr_out$sp <- structure(list(), class = c("list", "matchBook_runner_sp"))
                    if(length(rnr$sp$nearPrice) > 0) {
                        rnr_out$sp$nearPrice <- rnr$sp$nearPrice
                    }
                    if(length(rnr$sp$farPrice) > 0) {
                        rnr_out$sp$farPrice <- rnr$sp$farPrice
                    }
                    if(length(rnr$sp$layLiabilityTaken) > 0) {
                        layTaken <- plyr::ldply(rnr$sp$layLiabilityTaken, data.frame, stringsAsFactors = FALSE)
                        names(layTaken) <- c("spLayPrice", "spLaySize")
                        rnr_out$sp$layTaken <- layTaken
                    }
                    if(length(rnr$sp$backStakeTaken) > 0) {
                        layTaken <- plyr::ldply(rnr$sp$backStakeTaken, data.frame, stringsAsFactors = FALSE)
                        names(layTaken) <- c("spLayPrice", "spLaySize")
                        rnr_out$sp$layTaken <- layTaken
                    }
                }
                if("ex" %in% names(rnr)) {
                    ex <- structure(list(), class = c("list", "marketBook_runner_ex"))
                    if("availableToBack" %in% names(rnr$ex) & length(rnr$ex$availableToBack) > 0) {
                        ex_back <- plyr::ldply(rnr$ex$availableToBack, data.frame, stringsAsFactors = FALSE)
                        names(ex_back) <- c("backPrice", "backSize")
                        ex$back <- ex_back
                    }
                    if("availableToLay" %in% names(rnr$ex) & length(rnr$ex$availableToLay) > 0) {
                        ex_lay <- plyr::ldply(rnr$ex$availableToLay, data.frame, stringsAsFactors = FALSE)
                        names(ex_lay) <- c("layPrice", "laySize")
                        ex$lay <- ex_lay
                    }
                    if("tradedVolume" %in% names(rnr$ex) & length(rnr$ex$tradedVolume) > 0) {
                        traded <- plyr::ldply(rnr$ex$tradedVolume, data.frame, stringsAsFactors = FALSE)
                        names(traded) <- c("tradedPrice", "tradedSize")
                        ex$traded <- traded
                    }
                    rnr_out$ex <- ex
                    if(length(rnr_out$ex) == 0) {
                        rnr_out$ex <- NULL
                    }
                }
                return(rnr_out)
            })
            class(runners) <- "marketBook_runners"
            out$runners <- runners
            names(out$runners) <- sapply(out$runners, function(x) x$basic$selectionId)
        }
        return(out)
    })
    class(out) <- c("list", "marketBook_list")
    return(out)
}



#' @export
bf_parse.marketCatalogue <- function(res, marketProjection = NULL,
                                          keepRules = FALSE) {

    out <- lapply(res$result, function(x) {

        out <- structure(list(), class = c("list", "marketCatalogue_simple"))
        out$raw <- x
        out$market <- data.frame(marketId = x$marketId,
                                 marketName = x$marketName,
                                 totalMatched = x$totalMatched,
                                 stringsAsFactors = FALSE)
        if("marketStartTime" %in% names(x)) {
            out$market$startTime <- x$marketStartTime
        }
        if("description" %in% names(x)) {
            tmp <- x$description
            tmp <- tmp[!sapply(tmp, is.na)]
            if(keepRules) {
                out$rules <- tidyRules(tmp$rules)
            } else {
                tmp$rules <- NULL
            }
            out$description <- data.frame(tmp, stringsAsFactors = FALSE)
        }
        if("eventType" %in% names(x)) {
            out$market$eventTypeId <- x$eventType$id
            out$market$eventTypeName <- x$eventType$name
        }
        if("competition" %in% names(x)) {
            out$event <- x$competition
            out$event <- data.frame(out$event, stringsAsFactors = FALSE)
        }
        if("event" %in% names(x)) {
            out$event <- x$event
            out$event <- data.frame(out$event, stringsAsFactors = FALSE)
        }
        if("runners" %in% names(x)) {
            runners <- lapply(x$runners, function(i) {
                runner <- list(summary = data.frame(i[!sapply(i, is.list)],
                                                    stringsAsFactors = FALSE))
                if("metadata" %in% names(i)) {
                    metadata <- i$metadata
                    metadata <- metadata[!sapply(metadata, is.null)]
                    metadata <- data.frame(metadata, stringsAsFactors = FALSE)
                    names(metadata) <- tolower(names(metadata))
                    runner$metadata <- metadata
                }
                return(runner)
            })
            out$runners <- plyr::ldply(runners, .fun = function(i) i$summary)
            out$metadata <- plyr::ldply(runners, .fun = function(i) i$metadata)
        }
        return(out)
    })

    class(out) <- c("list", "marketCatalogue_list")
    return(out)
}

#' @export
bf_parse.marketProfitAndLoss <- function(res) {

    out <- lapply(res$result, function(x) {
        out <- structure(list(), class = "market_PnL")
        out$marketId <- x$marketId
        out$PnL <- plyr::ldply(x$profitAndLosses, data.frame, stringsAsFactors = FALSE)
        return(out)
    })
    class(out) <- c("list", "marketPnL_list")
    return(out)
}

#' @export
bf_parse.marketTypes <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
bf_parse.placeOrders <- function(res) {

    out <- structure(list(), class = "betfair_orders")
    out$status <- res$result$status
    out$marketId <- res$result$marketId
    if("errorCode" %in% res$result) {
        out$errorCode <- res$result$errorCode
    }
    out$order <- data.frame(res$result$instructionReports[[1]][!sapply(res$result$instructionReports[[1]], is.list)])
    out$orderInstruction <- data.frame(res$result$instructionReports[[1]]$instruction)
    names(out$orderInstruction) <- gsub("[[:alpha:]]+\\.", "", names(out$orderInstruction))

    return(out)
}

#' @export
bf_parse.cancelOrders <- function(res) {
    out <- structure(list(), class = "bf_cancel_orders")
    out$status <- res$result$status
    if(length(res$result$marketId) > 0) out$marketId
    out$instructions <- lapply(res$result$instructionReports, function(i) {
        data.frame(i, stringsAsFactors = FALSE)
    })
    return(out)
}

#' @export
bf_parse.currentOrders <- function(res) {

    out <- structure(list(), class = c("list", "currentOrders"))
    out$current <- lapply(res$result$currentOrders, function(i) {
        tmp <- data.frame(i[!sapply(i, is.null)], stringsAsFactors = FALSE)
        names(tmp) <- gsub("priceSize.", "", names(tmp))
        return(tmp)
    })
    out$moreAvailable <- res$result$moreAvailable
    return(out)
}

#' @export
bf_parse.venues <- function(res) {

    res <- basic_parse(res)

    return(res)
}

basic_parse <- function(res) {

    if(is.list(res$result)) {
        res <- lapply(res$result, data.frame, stringsAsFactors = FALSE)
        res <- do.call(plyr::rbind.fill, res)

        names(res) <- gsub(pattern = "\\.", replacement = "_", x = names(res))
    } else {
        res <- res$result
    }
    return(res)
}

tidyRules <- function(rules) {

    rules <- stringr::str_replace_all(rules, "<br>", "\n")
    rules <- stringr::str_replace_all(rules, "<b>|</b>", "")
    rules <- stringr::str_replace_all(rules, "<(.*?)>", "")
    rules <- stringr::str_replace_all(rules, "\n\n\n\n", "\n\n")
    return(rules)
}
