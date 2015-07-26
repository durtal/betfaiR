#' create Betfair request
#'
#' @description convert and format request list into valid JSON object for Betfair's
#' API. Requires users to build a list first using \link{base_request}
#'
#' @name betfair_request
#'
#' @details to use this function, the object should have one of the following classes,
#' \strong{competitions}, \strong{countries}, \strong{events}, \strong{eventTypes},
#' \strong{marketCatalogue}, \strong{marketTypes} and \strong{venues}.
#'
#' @export
betfair_request <- function(x, ...) {
    UseMethod(generic = "betfair_request", object = x)
}

#' @export
betfair_request.competitions <- function(x) {

    req <- standard_request()

    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.countries <- function(x) {

    req <- standard_request(method = "listCountries")

    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.eventTypes <- function(x) {

    req <- standard_request(method = "listEventTypes")

    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.events <- function(x) {

    req <- standard_request(method = "listEvents")

    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.marketTypes <- function(x) {

    req <- standard_request(method = "listMarketTypes")

    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.marketCatalogue <- function(x, marketProjection = NULL, sort = NULL,
                                        maxResults = 1) {

    req <- standard_request(method = "listMarketCatalogue")

    req$params$maxResults <- as.character(maxResults)
    if(!is.null(marketProjection)) {
        marketProjection <- toupper(marketProjection)
        req$params$marketProjection <- as.list(marketProjection)
    }
    if(!is.null(sort)) {
        req$params$sort <- toupper(sort)

    }
    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.marketBook <- function(x, marketIds, priceProjection = NULL,
                                   orderProjection = NULL, matchProjection = NULL) {

    req <- standard_request(method = "listMarketBook")
    req$params$filter <- NULL

    tmp <- list("marketIds" = as.list(as.character(marketIds)))
    if(!is.null(priceProjection)) {
        tmp$priceProjection$priceData <- as.list(priceProjection)
    }
    if(!is.null(orderProjection)) {
        tmp$orderProjection <- orderProjection
    }
    if(!is.null(matchProjection)) {
        tmp$matchProjection <- matchProjection
    }
    req$params <- tmp

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.placeOrders <- function(x, order) {

    req <- standard_request(method = "placeOrders")
    req$params$filter <- NULL

    req$params <- order
    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
betfair_request.venues <- function(x) {

    req <- standard_request(method = "listVenues")

    req$params$filter <- build_request(req = x)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' build base request
#'
#' @description creates a list with a different class, according to the desired
#' API method the request will be sent to, the returned value will then be passed
#' to \link{betfair_request} to convert to valid JSON.
#'
#' @name base_request
#'
#' @param filter list of parameters to use as filters, see \link{marketFilter}
#' @param method Betfair API method, one of \code{competitions}, \code{countries},
#' \code{events}, \code{eventTypes}, \code{marketTypes}, \code{marketBook},
#' \code{marketCatalogue}, \code{venues}
#'
#' @export
base_request <- function(filter = list(), method = "competitions") {

    param <- match.arg(arg = method,
                       choices = c("competitions", "countries", "events",
                                   "eventTypes", "marketTypes", "marketBook",
                                   "marketCatalogue", "placeOrders", "venues"))
    tmp <- structure(filter, class = c("list", param))
    return(tmp)
}

standard_request <- function(method = "listCompetitions") {

    req <- list("jsonrpc" = "2.0",
                "method" = paste0("SportsAPING/v1.0/", method),
                "params" = list("filter" = list()),
                "id" = 1)
    return(req)
}

request_helper <- function(req) {

    if(is.logical(req)) {
        return(req)
    } else if(length(req) == 1) {
        if(is.numeric(req[[1]])) {
            return(as.list(req))
        } else if(is.list(req)) {
            return(as.list(req))
        } else if(is.character(req)) {
            return(as.list(req))
        } else {
            return(unlist(req))
        }
    } else {
        return(as.list(req))
    }
}

build_request <- function(req) {

    if(length(req) == 0) {
        return(setNames(list(), character(0)))
    } else {
        req <- lapply(req, request_helper)
        return(req)
    }
}
