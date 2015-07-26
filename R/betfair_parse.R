#' betfair_parse
#'
#' @description convert response
#'
#'
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
betfair_parse.marketCatalogue <- function(res, keepRules = FALSE) {

    res <- lapply(res$result, function(x) {

        responseList <- list()

        basic <- data.frame(marketId = x$marketId,
                            marketName = x$marketName,
                            totalMatched = x$totalMatched, stringsAsFactors = FALSE)
        responseList$basic <- basic
        if(!is.null(x$marketStartTime)){
            responseList$basic$marketStartTime <- x$marketStartTime
        }
        if(!is.null(x$description)) {
            description <- data.frame(x$description, stringsAsFactors = FALSE)
            if(!keepRules) description$rules <- NULL
            responseList$description <- description
        }
        if(!is.null(x$competition)) {
            competition <- data.frame(x$competition, stringsAsFactors = FALSE)
            responseList$competition <- competition
        }
        if(!is.null(x$eventType)) {
            eventType <- data.frame(x$eventType, stringsAsFactors = FALSE)
            responseList$eventType <- eventType
        }
        if(!is.null(x$event)) {
            event <- data.frame(x$event, stringsAsFactors = FALSE)
            responseList$event <- event
        }
        if(!is.null(x$runners)) {
            runners <- lapply(x$runners, function(rnr) {
                tmp <- rnr
                if(!is.null(rnr$metadata)) {
                    tmp$metadata <- NULL
                    basic <- data.frame(tmp, stringsAsFactors = FALSE)
                    meta <- data.frame(rnr$metadata[!sapply(rnr$metadata, is.null)], stringsAsFactors = FALSE)
                    basic <- cbind(basic, meta)
                    return(basic)
                } else {
                    basic <- data.frame(rnr[!sapply(rnr, is.null)], stringsAsFactors = FALSE)
                    return(basic)
                }
            })
            runners <- do.call(plyr::rbind.fill, runners)
            responseList$runners <- runners
        }
        return(responseList)
    })
#     res <- do.call(plyr::rbind.fill, res)
#     names(res) <- tolower(names(res))
    return(res)
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
