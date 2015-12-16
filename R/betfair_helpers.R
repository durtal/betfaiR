# helper function for constructing request for preparing orders
#
# @name prepare
# @description prepare a bet for \link{placeOrders} method
#
# @param marketId the unique market id, starts with \code{1.} for UK exchange,
# and \code{2.} for Aus exchange
# @param selectionId the selection (runner) unique id
# @param orderType type of order, \strong{LIMIT} (default) for immediate execution,
# \strong{LIMIT_ON_CLOSE} limit order for the auction (SP), \strong{MARKET_ON_CLOSE}
# market order for the auction (SP)
# @param handicap the handicap associated with the runner (\code{selectionId}) in
# case of Asian Handicap markets
# @param side "BACK" (default) or "LAY"
# @param order the type of order, this can be three types and inputs depend on
# parameter \strong{orderType}.  If orderType is \strong{LIMIT} then use the
# \link{limitOrder} function to construct order.  If orderType is \strong{LIMIT_ON_CLOSE}
# use the \link{limitOnCloseOrder} function to construct the order.  If orderType is
# \strong{MARKET_ON_CLOSE} then a simple list consisting of one element called
# \strong{liability} should be supplied
#
# @return returns a list with an order for Betfair
prepare <- function(marketId, selectionId, orderType = "LIMIT",
                    handicap = "0", side = "BACK",
                    order = NULL) {

    orderList <- list("marketId" = as.character(marketId),
                      "instructions" = data.frame("selectionId" = as.character(selectionId),
                                                  "orderType" = as.character(orderType),
                                                  "side" = as.character(side),
                                                  "stringsAsFactors" = FALSE))

    if(!is.null(handicap)) orderList$instructions$handicap <- as.character(handicap)

    if(orderType == "LIMIT") {
        orderList$instructions$limitOrder <- list(order)
    }
    if(orderType == "LIMIT_ON_CLOSE") {
        orderList$instructions$limitOnCloseOrder <- list(order)
    }
    if(orderType == "MARKET_ON_CLOSE") {
        orderList$instructions$marketOnCloseOrder <- list(order)
    }

    return(orderList)
}

#' limitOrder
#'
#' @name limitOrder
#'
#' @description helper function to prepare a bet, used in conjunction with \link{placeOrders}
#'
#' @param size the size of the bet. \strong{Note:} for a market type of EACH_WAY,
#' the total stake is 2*size.
#' @param price the limit price
#' @param persistenceType what to do with the order at turn in-play, three choices,
#'      \strong{LAPSE} - lapse the order when the market goes in play,
#'      \strong{PERSIST} - persist the order in-play, the bet will be placed
#'      automatically into the in-play market at the start of the event,
#'      \strong{MARKET_ON_CLOSE} - put the order into the auction (SP) at turn
#'      in-play.
#'
#' @export
#'
#' @return list with bet order
limitOrder <- function(size = 2, price = NULL, persistenceType = "LAPSE") {
    ord <- as.list(environment())
    return(ord)
}

#' limitOnCloseOrder
#'
#' @name limitOnCloseOrder
#'
#' @description helper function to prepare a bet, used in conjunction with \link{placeOrders}
#'
#' @param size the size of the bet. \strong{Note:} for a market type of EACH_WAY,
#' the total stake is 2*size.
#' @param price the limit price
#'
#' @export
#'
#' @return list with bet order
limitOnCloseOrder <- function(size = 2, price = NULL) {
    ord <- as.list(environment())
    return(ord)
}

# helper function for constructing request for canceling orders
#
# @name cancel
#
# @description cancel orders function
#
# @param ... multiple cancel orders instructions, use \link{cancel_inst}
# @param marketId market id
#
# @return list
cancel <- function(..., marketId = NA) {
    inst <- as.list(environment())
    inst <- inst[!sapply(inst, is.na)]

    orders <- list(...)

    if(length(orders) > 0) {
        inst$instructions <- orders
        if(is.na(marketId)) stop("If instructions are provided a marketId is required")
    }
    return(inst)
}

#' cancel bet instructions
#'
#' @name cancel_inst
#'
#' @description cancel individual orders using betIds
#'
#' @param betId unique betId
#' @param size reduction size
#'
#' @export
#'
#' @return list with cancel instructions
cancel_inst <- function(betId = NA, size = NA) {
    inst <- as.list(environment())
    return(inst)
}

#' replace bet instructions
#'
#' @name replace_inst
#'
#' @description replace individual orders using betIds
#'
#' @param betId unique betId (required)
#' @param newPrice new price to strike bet (required)
#'
#' @export
#'
#' @return list with replace instructions
replace_inst <- function(betId, newPrice) {
    inst <- as.list(environment())
    return(inst)
}

#' update bet instructions
#'
#' @name update_inst
#'
#' @description update individual orders with new instructions for what to do when
#' the market goes in play
#'
#' @param betId unique betId (required)
#' @param persistenceType new instructions for what to do with order at in play
#'
#' @export
#'
#' @return list with update instructions
update_inst <- function(betId, persistenceType) {
    inst <- as.list(environment())
    return(inst)
}

# helper function for constructing request for retrieving current orders
#
# @name current
#
# @description helper function used by the \link{currentOrders} method to build
# request object for finding current unsettled bets
#
# @param betId unique bet Id
# @param marketId unique market Id
# @param orderProjection default of \strong{ALL} returns all unsettled positions,
# matched or partially matched, change to \strong{EXECUTABLE} to filter for orders
# with a portion remaining, or \strong{EXECUTION_COMPLETE} for orders which have
# been filled, see orderProjection section in \link{bettingEnums} for more details
# @param from date filter, string in yyyy-mm-dd format
# @param to date filter, string in yyyy-mm-dd format
# @param orderBy how to order orders, default orders by when they were placed, see
# orderBy section in \link{bettingEnums} for more details
# @param sort how to sort results, see sortDir section in \link{bettingEnums} for
# more details
# @param fromRecord specifies the first record to be returned, records start at
# index zero (not one)
# @param count specifies how many records are returned from the index position set
# by \code{fromRecord}, there is a limit of 1000.
#
# @return list with parameters to filter currently unsettled bets
current <- function(betId = NULL, marketId = NULL, orderProjection = "ALL",
                    from = NULL, to = NULL, orderBy = "BY_BET",
                    sort = "EARLIEST_TO_LATEST", fromRecord = NULL,
                    count = NULL) {

    orderList <- as.list(environment())

    if(!is.null(from)) {
        orderList$from <- NULL
        orderList$dateRange$from <- format(as.POSIXct(from), "%Y-%m-%dT%TZ")
    }
    if(!is.null(to)) {
        orderList$to <- NULL
        orderList$dateRange$to <- format(as.POSIXct(to), "%Y-%m-%dT%TZ")
    }

    orderList <- orderList[!sapply(orderList, is.null)]

    if(!is.null(orderList$betId)) {
        orderList$betId <- as.list(orderList$betId)
    }
    if(!is.null(orderList$marketId)) {
        orderList$marketId <- as.list(orderList$marketId)
    }

    return(orderList)
}

# helper function for constructing request for retrieving cleared orders
#
# @name cleared
#
# @description helper function used by the \link{clearedOrders} method to build
# request object for finding settled orders
#
# @param betStatus filter based on how the bet was settled, one of \strong{SETTLED}
# (default), \strong{VOIDED}, \strong{LAPSED}, or \strong{CANCELLED}
# @param eventTypeIds retrieve bets based on sport
# @param eventIds retrieve bets based on event
# @param marketIds retrieve bets based on markets
# @param runnerIds retrieve bets on specific runners
# @param betIds unique bets
# @param side \strong{BACK} or \strong{LAY} orders
# @param from filter according to date, format should be yyyy-mm-dd
# @param to filter according to date, format should be yyyy-mm-dd
#
# @return list with parameters to filter cleared bets
cleared <- function(betStatus = "SETTLED", eventTypeIds = NULL, eventIds = NULL,
                    marketIds = NULL, runnerIds = NULL, betIds = NULL,
                    side = "BACK", to = NULL, from = NULL) {

    orderList <- as.list(environment())

    if(!is.null(from)) {
        orderList$from <- NULL
        orderList$dateRange$from <- format(as.POSIXct(from), "%Y-%m-%dT%TZ")
    }
    if(!is.null(to)) {
        orderList$to <- NULL
        orderList$dateRange$from <-format(as.POSIXct(to), "%Y-%m-%dT%TZ")
    }

    if(!is.null(orderList$eventTypeIds)) orderList$eventTypeIds <- as.list(orderList$eventTypeIds)
    if(!is.null(orderList$eventIds)) orderList$eventIds <- as.list(orderList$eventIds)
    if(!is.null(orderList$marketIds)) orderList$marketIds <- as.list(orderList$marketIds)
    if(!is.null(orderList$runnerIds)) orderList$runnerIds <- as.list(orderList$runnerIds)
    if(!is.null(orderList$betIds)) orderList$betIds <- as.list(orderList$betIds)

    orderList <- orderList[!sapply(orderList, is.null)]

    return(orderList)
}
