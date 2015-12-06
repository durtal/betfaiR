#' betfair - Betfair Environment w/ methods
#'
#' @description Supply valid credentials, username, password and API key (see \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys}{developer.betfair.com}),
#' returning a environment with methods (see Methods section below) for returning data from
#' Betfair's API.
#'
#' @name betfair
#'
#' @param usr Betfair username
#' @param pwd Betfair password
#' @param key Betfair API key see \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys}{developer.betfair.com}
#'
#' @return returns environment with functions for the various methods available for
#' Betfair's API
#'
#' @details filters can be used in a number of available methods, these filters are
#' to be supplied as a list, the \link{marketFilter} function provides assistance in
#' building the list.
#'
#' @section Methods:
#' \describe{
#'      \item{\code{competitions(filter = marketFilter())}}{ Retrieve data about the
#'      different competitions with current markets, see \link{competitions}.}
#'      \item{\code{countries(filter = marketFilter())}}{ Retrieve data about the different countries
#'      hosting events, see \link{countries}.}
#'      \item{\code{events(filter = marketFilter())}}{ Retrieve data about the different events, see
#'      \link{events}.}
#'      \item{\code{eventTypes(filter = marketFilter())}}{ Retrieve data about the different event types,
#'      ie. sports, see \link{eventTypes}.}
#'      \item{\code{venues(filter = marketFilter())}}{ Retrieve data about the venues hosting racing,
#'      see \link{venues}.}
#'      \item{\code{login(usr, pwd, key)}}{ Login in, a session token will be
#'      returned, over-writing the previous token when \code{betfair(usr, pwd, key)}
#'      was used.}
#'      \item{\code{session()}}{ Print details about the session, including login
#'      in details and session token.}
#'      \item{\code{marketBook(marketIds = list(), priceProjection = NULL, orderProjection = NULL,
#'      matchProjection = NULL)}}{ Retrieve dynamic data about markets. Data includes
#'      prices, the status of the market, the status of the selections, the traded
#'      volume, and the status of any orders you have in the market.}
#'      \item{\code{marketCatalogue(filter = list(), marketProjection = "EVENT", sort = NULL,
#'      maxResults = 50, keepRules = FALSE)}}{ Retrieve data about the different types
#'      of markets, see \link{marketCatalogue}.}
#'      \item{\code{marketTypes(filter = marketFilter())}}{ Retrieve data about the different types of
#'      markets, see \link{marketTypes}.}
#'      \item{\code{cancelOrders(..., marketId = NA)}}{ Cancel existing orders, leave function blank
#'      to cancel all existing orders, or use combination or marketId and ... to target specific orders,
#'      see \link{cancelInstruction} to target specific order}
#'      \item{\code{placeOrders(marketId, selectionId, orderType = "LIMIT",
#'      handicap = NULL, side = "BACK", limitOrder = limitOrder(), limitOnCloseOrder = limitOnCloseOrder(),
#'      marketOnCloseOrder = NULL)}}{ Place a bet, requires a marketId (see \link{marketCatalogue})
#'      and selectionId (see \link{marketBook}),}
#'      \item{\code{replaceOrders(..., marketId)}}{ Replace existing orders, requires marketIds and
#'      unique betIds with new prices, use \link{replaceInstructions} to target specific bets}
#' }
#'
#' @examples
#' \dontrun{
#' bf <- betfair(usr = "username", pwd = "password", key = "API_key")
#'
#' # to view available methods simply print the bf
#' bf
#'
#' # to use a method, for example competitions
#' bf$competitions(filter = list())
#'
#' # to use a method with a filter to retrieve just football
#' bf$competitions(filter = marketFilter(eventTypeIds = 1))
#' }
#' @export
betfair <- function(usr, pwd, key) {

    # login for session token
    ssoid <- betfair_login(usr = usr, pwd = pwd, key = key)

    self <- local({

        competitions <- function(filter = marketFilter()) {
            # build request object
            req <- base_request(filter, "competitions")
            req <- betfair_request(req)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "competitions")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res)
            }

            return(res)
        }

        countries <- function(filter = marketFilter()) {
            # build request object
            req <- base_request(filter, "countries")
            req <- betfair_request(req)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "countries")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res)
            }

            return(res)
        }

        events <- function(filter = marketFilter()) {
            # build request object
            req <- base_request(filter, "events")
            req <- betfair_request(req)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "events")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res)
            }

            return(res)
        }

        eventTypes <- function(filter = marketFilter()) {
            # build request object
            req <- base_request(filter, "eventTypes")
            req <- betfair_request(req)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "eventTypes")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res)
            }

            return(res)
        }

        venues <- function(filter = marketFilter()) {
            # build request object
            req <- base_request(filter, "venues")
            req <- betfair_request(req)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "venues")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res)
            }

            return(res)
        }

        login <- function(usr, pwd, key) {
            ssoid <<- loginBetfair(usr = usr, pwd = pwd, key = key)
        }

        session <- function() {
            cat("Session Token:\t", ssoid$resp$token)
        }

        marketBook <- function(marketIds = list(),
                               priceProjection = "EX_BEST_OFFERS",
                               orderProjection = "EXECUTABLE",
                               matchProjection = "NO_ROLLUP") {

            priceProjection <- intersect(toupper(priceProjection), c("SP_AVAILABLE",
                                                                     "SP_TRADED",
                                                                     "EX_BEST_OFFERS",
                                                                     "EX_ALL_OFFERS",
                                                                     "EX_TRADED"))
            orderProjection <- intersect(toupper(orderProjection), c("ALL",
                                                                     "EXECUTABLE",
                                                                     "EXECUTION_COMPLETE"))
            matchProjection <- intersect(toupper(matchProjection), c("NO_ROLLUP",
                                                                     "ROLLED_UP_BY_PRICE",
                                                                     "ROLLED_UP_BY_AVG_PRICE"))
            # build request object
            req <- base_request(filter = list(), method = "marketBook")
            req <- betfair_request(req, marketIds = marketIds,
                                   priceProjection = priceProjection,
                                   orderProjection = orderProjection,
                                   matchProjection = matchProjection)
            # post request
            res <- betfair_POST(body = req, headers = ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "marketBook")
            # parse response
            res <- betfair_parse(res)

            return(res)
        }

        marketCatalogue <- function(filter = marketFilter(),
                                    marketProjection = "EVENT",
                                    sort = NULL, maxResults = 1,
                                    keepRules = FALSE) {

            marketProjection <- intersect(toupper(marketProjection), c("COMPETITION",
                                                                       "EVENT",
                                                                       "EVENT_TYPE",
                                                                       "MARKET_START_TIME",
                                                                       "MARKET_DESCRIPTION",
                                                                       "RUNNER_DESCRIPTION",
                                                                       "RUNNER_METADATA"))
            # build request object
            req <- base_request(filter, "marketCatalogue")
            req <- betfair_request(x = req, marketProjection = marketProjection,
                                   sort = sort, maxResults = maxResults)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "marketCatalogue")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res, marketProjection = marketProjection,
                                     keepRules = keepRules)
            }

            return(res)
        }

        marketPnL <- function(marketIds, settled = NULL,
                              bsp = NULL, NET = NULL) {
            # build request object
            req <- base_request(method = "marketProfitAndLoss")
            params <- list(marketIds = marketIds,
                           settled = settled,
                           bsp = bsp, NET = NET)
            req <- betfair_request(x = req, params = params)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "marketProfitAndLoss")
            # parse response
            res <- betfair_parse(res)

            return(res)
        }

        marketTypes <- function(filter = marketFilter()) {
            # build request object
            req <- base_request(filter, "marketTypes")
            req <- betfair_request(req)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "marketTypes")
            # parse response
            if(is.list(res)) {
                res <- betfair_parse(res)
            }

            return(res)
        }

        cancelOrders <- function(..., marketId = NA) {
            # build request object
            req <- base_request(method = "cancelOrders")
            cancel <- cancel_orders(marketId = marketId, ...)
            req <- betfair_request(req, instructions = cancel)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "cancelOrders")
            # parse response
            res <- betfair_parse(res)

            return(res)
        }

        placeOrders <- function(marketId, selectionId, orderType = "LIMIT",
                                handicap = NULL, side = "BACK", limitOrder = limitOrder(),
                                limitOnCloseOrder = limitOnCloseOrder(), marketOnCloseOrder = NULL) {
            # build request object
            req <- base_request(method = "placeOrders")
            betOrder <- prepare_order(marketId = marketId, orderType = orderType,
                                      selectionId = selectionId, side = side,
                                      limitOrder = limitOrder, limitOnCloseOrder = limitOnCloseOrder,
                                      marketOnCloseOrder = marketOnCloseOrder)
            req <- betfair_request(req, order = betOrder)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "placeOrders")
            # parse response
            res <- betfair_parse(res)
            return(res)
        }

        replaceOrders <- function(..., marketId) {
            # build request object
            req <- base_request(method = "replaceOrders")
            replace <- cancel_orders(marketId = marketId, ...)
            req <- betfair_request(req, instructions = replace)
            # post request
            res <- betfair_POST(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- betfair_check(res, method = "cancelOrders")
            # parse response
            res <- betfair_parse(res)

            return(res)
        }

        environment()
    })
    lockEnvironment(self, TRUE)
    structure(self, class = c("betfaiR", class(self)))
}

#' @export
print.betfaiR <- function(x, ...) {
    ns <- ls(x)
    title <- paste0("<", class(x)[1], " API>\nMethods available:")
    cat(title, "\n")
    lapply(ns, function(fn) {
        if(is.function(x[[fn]])) {
            cat(format_function(x[[fn]], fn), sep = "\n")
        }
    })
    invisible()
}
# borrowed from the excellent mongolite package
format_function <- function(fun, name = deparse(substitute(fun))) {
    header <- utils::head(deparse(args(fun), 100L), -1)
    header <- sub("^[ ]*", "   ", header)
    header[1] <- sub("^[ ]*function ?", paste0("    $", name, ""), header[1])
    header
}
