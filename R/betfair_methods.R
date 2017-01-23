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
#'      \item{\code{account(pwd)}}{ Return environment with methods for accessing data
#'      about your account}
#'      \item{\code{competitions(filter = marketFilter())}}{ Retrieve data about the
#'      different competitions with current markets, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{countries(filter = marketFilter())}}{ Retrieve data about the different countries
#'      hosting events, see \link{countries}, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{events(filter = marketFilter())}}{ Retrieve data about the different events, see
#'      \link{events}, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{eventTypes(filter = marketFilter())}}{ Retrieve data about the different event types,
#'      ie. sports, see \link{eventTypes}, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{venues(filter = marketFilter())}}{ Retrieve data about the venues hosting racing,
#'      see \link{venues}, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{login(usr, pwd, key)}}{ Login in, a session token will be
#'      returned, over-writing the previous token when \code{betfair(usr, pwd, key)}
#'      was used.}
#'      \item{\code{session()}}{ Print details about the session, including login
#'      in details and session token.}
#'      \item{\code{marketBook(marketIds = list(), priceProjection = "EX_BEST_OFFERS",
#'      orderProjection = "EXECUTABLE", matchProjection = "NO_ROLLUP", getRunners = NULL)}}{ Retrieve dynamic
#'      data about markets, data includes, prices, status of the market, status of
#'      selections, the traded volume, and the status of any orders in the market,
#'      see \link{marketBook}}
#'      \item{\code{marketCatalogue(filter = marketFilter(), marketProjection = "EVENT",
#'      sort = NULL, maxResults = 1, keepRules = FALSE)}}{ Retrieve data about the
#'      different types of markets, see \link{marketCatalogue}, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{marketPnL(marketIds, settled = NULL, bsp = NULL, NET = NULL)}}{ Retrieve
#'      data about the current profit/loss for markets you may have existing orders in'}
#'      \item{\code{marketTypes(filter = marketFilter())}}{ Retrieve data about the different types of
#'      markets, see \link{marketTypes}, see \link{competitions}, see
#'      \link{marketFilter} for filtering data.}
#'      \item{\code{cancelOrders(..., marketId = NA)}}{ Cancel existing orders, leave function blank
#'      to cancel all existing orders, see \link{cancelOrders}.  You can use a combination of marketId
#'      and ... to target specific orders, see \link{cancel_inst} to target specific order}
#'      \item{\code{clearedOrders(betStatus = "SETTLED", eventTypeIds = NULL, eventIds = NULL,
#'      marketIds = NULL, runnerIds = NULL, betIds = NULL, side = "BACK", from = NULL, to = NULL)}}{
#'      Retrieve data about cleared orders, which are orders that have been settled, see
#'      \link{clearedOrders}, use the various params to help filter bets}
#'      \item{\code{currentOrders(betId = NULL, marketId = NULL, orderProjection = "ALL",
#'      from = NULL, to = NULL, orderBy = "BY_BET", sort = "EARLIEST_TO_LATEST", fromRecord = NULL,
#'      count = NULL)}}{ Retrieve existing unsettled orders, leave function blank to retreive
#'      all orders, see \link{currentOrders}, use the various params too help filter
#'      bets}
#'      \item{\code{placeOrders(marketId, selectionId, orderType = "LIMIT", handicap = NULL,
#'      side = "BACK", order = limitOrder())}}{ Place an order, see \link{placeOrders}, requires a marketId and selectionId (see
#'      \link{marketCatalogue} and \link{marketBook} for details on these params), make use of
#'      various helper functions (\link{limitOrder} or \link{limitOnCloseOrder}) depending
#'      on the type of order}
#'      \item{\code{replaceOrders(..., marketId)}}{ Replace existing orders, requires marketIds and
#'      unique betIds with new prices, use \link{replace_inst} to target specific bets}
#'      \item{\code{updateOrders(..., marketId)}}{ Update existing orders with new
#'      instructions for what to do when the market goes in play, use \link{update_inst} to target
#'      specific bets}
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
    ssoid <- bf_login(usr = usr, pwd = pwd, key = key)

    self <- local({

        account <- function(pwd) {
            if(pwd == ssoid$usr$pwd) {
                acc <- bf_account(usr = ssoid$usr$usr,
                                  pwd = ssoid$usr$pwd,
                                  key = ssoid$usr$key)
                return(acc)
            } else {
                stop("pass != previously entered password")
            }
        }

        competitions <- function(filter = marketFilter()) {
            # build request object
            req <- bf_basic_req(filter, "competitions")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "competitions")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        countries <- function(filter = marketFilter()) {
            # build request object
            req <- bf_basic_req(filter, "countries")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "countries")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        events <- function(filter = marketFilter()) {
            # build request object
            req <- bf_basic_req(filter, "events")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "events")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        eventTypes <- function(filter = marketFilter()) {
            # build request object
            req <- bf_basic_req(filter, "eventTypes")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "eventTypes")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        venues <- function(filter = marketFilter()) {
            # build request object
            req <- bf_basic_req(filter, "venues")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "venues")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        login <- function(usr, pwd, key) {
            ssoid <<- bf_login(usr = usr, pwd = pwd, key = key)
        }

        session <- function() {
            cat("Session Token:\t", ssoid$resp$token)
        }

        marketBook <- function(marketIds = list(),
                               priceProjection = "EX_BEST_OFFERS",
                               orderProjection = "EXECUTABLE",
                               matchProjection = "NO_ROLLUP",
                               getRunners = NULL) {

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
            req <- bf_basic_req(filter = list(), method = "marketBook")
            req <- bf_request(req, marketIds = marketIds,
                                   priceProjection = priceProjection,
                                   orderProjection = orderProjection,
                                   matchProjection = matchProjection)
            # post request
            res <- bf_post(body = req, headers = ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "marketBook")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }
            # getRunners
            if(!is.null(getRunners)) {

                getRunners <- intersect(toupper(getRunners), c("RUNNER_DESCRIPTION",
                                                               "RUNNER_METADATA"))
                if(length(getRunners) == 0) {
                    getRunners <- "RUNNER_DESCRIPTION"
                }
                req1 <- bf_basic_req(filter = marketFilter(marketIds = marketIds), method = "marketCatalogue")
                req1 <- bf_request(req1, marketProjection = getRunners, maxResults = length(marketIds))
                res1 <- bf_post(body = req1, headers = ssoid$ssoid)
                res1 <- httr::content(res1)
                res1 <- bf_check(res1, method = "marketCatalogue")
                if(is.list(res1)) {
                    res1 <- bf_parse(res1)
                    res <- mBook_mCat_join(res, res1, getRunners)
                }
            }

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
            if(!is.null(sort)) {
                sort <- intersect(toupper(sort), c("MINIMUM_TRADED",
                                                   "MAXIMUM_TRADED",
                                                   "MINIMUM_AVAILABLE",
                                                   "MAXIMUM_TRADED",
                                                   "FIRST_TO_START",
                                                   "LAST_TO_START"))
            } else {
                sort <- NULL
            }
            # build request object
            req <- bf_basic_req(filter, "marketCatalogue")
            req <- bf_request(x = req, marketProjection = marketProjection,
                              sort = sort, maxResults = maxResults)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "marketCatalogue")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res, keepRules = keepRules)
            }

            return(res)
        }

        marketPnL <- function(marketIds, settled = NULL,
                              bsp = NULL, NET = NULL) {
            # build request object
            req <- bf_basic_req(method = "marketProfitAndLoss")
            params <- list(marketIds = marketIds,
                           settled = settled,
                           bsp = bsp, NET = NET)
            req <- bf_request(x = req, params = params)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "marketProfitAndLoss")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        marketTypes <- function(filter = marketFilter()) {
            # build request object
            req <- bf_basic_req(filter, "marketTypes")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "marketTypes")
            # parse response
            if(is.list(res)) {
                res <- bf_parse(res)
            }

            return(res)
        }

        cancelOrders <- function(..., marketId = NA) {
            # build request object
            req <- bf_basic_req(method = "cancelOrders")
            cancel <- bf_cancel(marketId = marketId, ...)
            req <- bf_request(req, instructions = cancel)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "cancelOrders")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        clearedOrders <- function(betStatus = "SETTLED", eventTypeIds = NULL, eventIds = NULL,
                                  marketIds = NULL, runnerIds = NULL, betIds = NULL,
                                  side = "BACK", from = NULL, to = NULL) {

            betStatus <- intersect(toupper(betStatus), c("SETTLED",
                                                         "VOIDED",
                                                         "LAPSED",
                                                         "CANCELLED"))

            # build request object
            req <- bf_basic_req(method = "clearedOrders")
            params <- bf_cleared(betStatus = betStatus, eventTypeIds = eventTypeIds,
                                 eventIds = eventIds, marketIds = marketIds,
                                 runnerIds = runnerIds, betIds = betIds,
                                 side = side, from = from, to = to)
            req <- bf_request(req, params = params)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "clearedOrders")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        currentOrders <- function(betId = NULL, marketId = NULL, orderProjection = "ALL",
                                  from = NULL, to = NULL, orderBy = "BY_BET",
                                  sort = "EARLIEST_TO_LATEST", fromRecord = NULL,
                                  count = NULL) {

            sort <- intersect(toupper(sort), c("EARLIEST_TO_LATEST", "LATEST_TO_EARLIEST"))
            orderBy <- intersect(toupper(orderBy), c("BY_BET",
                                                     "BY_MARKET",
                                                     "BY_MATCH_TIME",
                                                     "BY_PLACE_TIME",
                                                     "BY_SETTLED_TIME",
                                                     "BY_VOID_TIME"))
            # build request object
            req <- bf_basic_req(method = "currentOrders")
            params <- bf_current(betId = betId, marketId = marketId, orderProjection = orderProjection,
                                 from = from, to = to, orderBy = orderBy, sort = sort,
                                 fromRecord = fromRecord, count = count)
            req <- bf_request(req, params = params)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "currentOrders")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        placeOrders <- function(marketId, selectionId, orderType = "LIMIT",
                                handicap = NULL, side = "BACK", order = limitOrder()) {
            # build request object
            req <- bf_basic_req(method = "placeOrders")
            betOrder <- bf_prepare(marketId = marketId, orderType = orderType,
                                selectionId = selectionId, side = side,
                                order = order)
            req <- bf_request(req, order = betOrder)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "placeOrders")
            # parse response
            res <- bf_parse(res)
            return(res)
        }

        replaceOrders <- function(..., marketId) {
            # build request object
            req <- bf_basic_req(method = "replaceOrders")
            replace <- bf_cancel(marketId = marketId, ...)
            req <- bf_request(req, instructions = replace)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "replaceOrders")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        updateOrders <- function(..., marketId) {
            # build request object
            req <- bf_basic_req(method = "updateOrders")
            update <- bf_cancel(marketId = marketId, ...)
            req <- bf_request(req, instructions = update)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "cancelOrders")
            # parse response
            res <- bf_parse(res)

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
