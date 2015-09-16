#' betfair_parse
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
betfair_parse <- function(res, ...) {
    UseMethod(generic = "betfair_parse", object = res)
}

#' check response is valid
#'
#' @description check for any errors in the response from \link{betfair_POST}
#'
#' @param res response object
#' @param method the method the response object came from, see methods section on
#' \link{betfair} page, or \link{base_request}.
#'
#' @details errors may be invalid JSON, missing parameters, or if the response contains
#' zero results, otherwise return the results with a class that corresponds to
#' the method (see \link{betfair}) that can then be parsed into a dataframe by
#' \link{betfair_parse}.
#'
#' @export
betfair_check <- function(res, method = "competitions") {

    errors <- list("-32700" = "Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text.",
                   "-32601" = "Method not found",
                   "-32602" = "Problem parsing the parameters, or a mandatory parameter was not found",
                   "-32603" = "Internal JSON-RPC error")

    if(!is.null(res$error)) {
        if(res$error$code %in% names(errors)) {
            stop("ERROR: ", res$error$code, " - ", errors[[as.character(res$error$code)]])
        } else {
            stop("ERROR: Unknown.")
        }
    } else if(length(res$result) == 0) {
        stop("NO RESULTS RETURNED FROM QUERY.")
    } else {
        class(res) <- c(class(res), method)
        return(res)
    }
}

#' @export
betfair_parse.competitions <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
betfair_parse.countries <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
betfair_parse.events <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
betfair_parse.eventTypes <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
betfair_parse.marketBook <- function(res) {

    res <- lapply(res$result, function(x) {

        tmp <- x
        tmp$runners <- NULL
        basic <- data.frame(tmp, stringsAsFactors = FALSE)
        test <- lapply(x$runners, function(rnr) {
            ex <- rnr$ex
            rnr$ex <- NULL
            basic <- data.frame(rnr, stringsAsFactors = FALSE)
            if(basic$status != "LOSER") {
                priceData <- lapply(ex, data.frame, stringsAsFactors = FALSE)
                priceData <- do.call(plyr::rbind.fill, priceData)
                priceData <- cbind(data.frame(bet = c("back", "lay")), priceData)
                basic <- cbind(basic, priceData)
            }
            return(basic)
        })
        runners <- do.call(plyr::rbind.fill, test)

        basic <- cbind(basic, runners)
        return(basic)
    })
    res <- do.call(plyr::rbind.fill, res)
    return(res)
}

#' @export
betfair_parse.marketCatalogue <- function(res, marketProjection = NULL,
                                          keepRules = FALSE) {

    out <- lapply(res$result, function(x) {

        out <- list()
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
            runners <- lapply(x$runners, data.frame, stringsAsFactors = FALSE)
            runners <- do.call(plyr::rbind.fill, runners)
            out$runners <- runners
        }
        class(out) <- c("list", "marketCatalogue")
        return(out)
    })

    class(out) <- c("list", "marketCatalogue_list")
    return(out)
}

#' @export
betfair_parse.marketTypes <- function(res) {

    res <- basic_parse(res)

    return(res)
}

#' @export
betfair_parse.venues <- function(res) {

    res <- basic_parse(res)

    return(res)
}

basic_parse <- function(res) {

    res <- lapply(res$result, data.frame, stringsAsFactors = FALSE)
    res <- do.call(plyr::rbind.fill, res)

    names(res) <- gsub(pattern = "\\.", replacement = "_", x = names(res))
    return(res)
}

tidyRules <- function(rules) {

    rules <- stringr::str_replace_all(rules, "<br>", "\n")
    rules <- stringr::str_replace_all(rules, "<b>|</b>", "")
    rules <- stringr::str_replace_all(rules, "<(.*?)>", "")
    rules <- stringr::str_replace_all(rules, "\n\n\n\n", "\n\n")
    return(rules)
}
