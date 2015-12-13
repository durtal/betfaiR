#' betfair helper functions
#'
#' @name bf_helpers
#'
#' @description a environment with collection of helper functions that are used
#' in conjunction with the various methods available.
#'
#' @section Helpers:
#' \describe{
#'      \item{\code{prepare(marketId, selectionId, orderType = "LIMIT",
#'      handicap = "0", side = "BACK",limitOrder = bf_helpers$limitOrder(),
#'      limitOnCloseOrder = bf_helpers$limitOnCloseOrder(),
#'      marketOnCloseOrder = list())}}{ function used inside \link{prepareOrders}
#'      method to help construct an order, uses other helper functions \code{limitOrder}
#'      or \code{limitOnCloseOrder}, see \link{prepare}}
#'      \item{\code{limitOrder(size = 2, price = NULL, persistenceType = "LAPSE")}}{
#'      helper function used in conjunction with \code{prepare} when an orderType is
#'      \strong{LIMIT}, see \link{limitOrder}}
#'      \item{\code{limitOnCloseOrder(size = 2, price = NULL)}}{ helper function
#'      used in conjunction with \code{prepare}, when an orderType is \strong{LIMIT_ON_CLOSE},
#'      see \link{limitOnCloseOrder}}
#'      \item{\code{cancel(..., marketId = NA)}}{ helper function used by the
#'      the \link{cancelOrders} method to cancel all bets if no params are entered,
#'      or by using \code{cancel_inst} to target individual bets, or target markets
#'      via the marketId param, see \link{cancel}}
#'      \item{\code{cancel_inst(betId = NA, size = NA)}}{ helper function used with
#'      \code{cancel} to cancel individual bets, can be used multiple times inside
#'      \code{cancel}, see \link{cancel_inst}}
#'      \item{\code{replace_inst(betId, newPrice)}}{ helper function used by the
#'      \link{replaceOrders} method, betId and newPrice are required, see \link{replace_inst}}
#'      \item{\code{update_inst(betId, persistenceType)}}{ helper function used by
#'      the \link{updateOrders} method, betId and persistenceType are required}
#'      \item{\code{current(betId, marketId, orderProjection, from, to, orderBy
#'      sort, fromRecord, recordCount)}}{ helper function used by the \link{currentOrders}
#'      method to filter current unsettled orders.}
#' }
#'
#' @export
bf_helpers <- local({

    prepare <- function(marketId, selectionId, orderType = "LIMIT",
                        handicap = "0", side = "BACK",
                        limitOrder = bf_helpers$limitOrder(),
                        limitOnCloseOrder = bf_helpers$limitOnCloseOrder(),
                        marketOnCloseOrder = list()) {

        orderList <- list(marketId = as.character(marketId),
                          instructions = data.frame(selectionId = as.character(selectionId),
                                                    orderType = as.character(orderType),
                                                    side = as.character(side),
                                                    stringsAsFactors = FALSE))

        if(!is.null(handicap)) orderList$instructions$handicap <- as.character(handicap)

        if(orderType == "LIMIT") {
            orderList$instructions$limitOrder <- list(limitOrder)
        }
        if(orderType == "LIMIT_ON_CLOSE") {
            orderList$instructions$limitOnCloseOrder <- list(limitOnCloseOrder)
        }
        if(orderType == "MARKET_ON_CLOSE") {
            orderList$instructions$marketOnCloseOrder <- list(marketOnCloseOrder)
        }

        return(orderList)
    }

    limitOrder <- function(size = 2, price = NULL, persistenceType = "LAPSE") {
        ord <- as.list(environment())
        return(ord)
    }

    limitOnCloseOrder <- function(size = 2, price = NULL) {
        ord <- as.list(environment())
        return(ord)
    }

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

    cancel_inst <- function(betId = NA, size = NA) {
        inst <- as.list(environment())
        return(inst)
    }

    replace_inst <- function(betId, newPrice) {
        inst <- as.list(environment())
        return(inst)
    }

    update_inst <- function(betId, persistenceType) {
        inst <- as.list(environment())
        return(inst)
    }

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

    # cleared <- function(betStatus = "SETTLED", eventTypeIds = NULL, eventIds = NULL,
    #                     marketIds = NULL, runnerIds = NULL, betIds = NULL,
    #                     side = "BACK", to = NULL, from = NULL) {
    #
    #     orderList <- as.list(environment())
    #
    #     if(!is.null(from)) {
    #         orderList$from <- NULL
    #         orderlist$dateRange$from <- format(as.POSIXct(from), "%Y-%m-%dT%TZ")
    #     }
    #     if(!is.null(to)) {
    #         orderList$to <- NULL
    #         orderList$dateRange$from <-format(as.POSIXct(to), "%Y-%m-%dT%TZ")
    #     }
    #
    #     orderList <- orderList[!sapply(orderList, is.null)]
    #
    #     return(orderList)
    # }

    environment()
})

#' prepare bet for Betfair
#'
#' @name prepare
#' @description prepare a bet for \link{placeOrders} method
#'
#' @param marketId the unique market id, starts with \code{1.} for UK exchange,
#' and \code{2.} for Aus exchange
#' @param selectionId the selection (runner) unique id
#' @param orderType type of order, \strong{LIMIT} (default) for immediate execution,
#' \strong{LIMIT_ON_CLOSE} limit order for the auction (SP), \strong{MARKET_ON_CLOSE}
#' market order for the auction (SP)
#' @param handicap the handicap associated with the runner (\code{selectionId}) in
#' case of Asian Handicap markets
#' @param side "BACK" (default) or "LAY"
#' @param limitOrder a simple exchange bet for immediate execution, a list consisting of
#' \itemize{
#'      \item \strong{size} the size of the bet. \strong{Note:} for a market type
#'      of EACH_WAY, the total stake is 2*size.
#'      \item \strong{price} the limit price
#'      \item \strong{persistenceType} what to do with the order at turn in-play,
#'      three choices, \strong{LAPSE} - lapse the order when the market goes in play,
#'      \strong{PERSIST} - persist the order in-play, the bet will be placed automatically
#'      into the in-play market at the start of the event, \strong{MARKET_ON_CLOSE} -
#'      put the order into the auction (SP) at turn in-play.
#' }
#' @param limitOnCloseOrder bets are matched if, and only if, the returned starting
#' price is better than a specified price, a list consisting of
#' \itemize{
#'      \item \strong{liability} the size of the bet
#'      \item \strong{price} the limit price of the bet
#' }
#' @param marketOnCloseOrder Bets remain unmatched until the market is reconciled,
#' hey are matched and settled at a price that is representative of the market at
#' the point the market is turned in-play, a list consisting of
#' \itemize{
#'      \item \strong{liability} the size of the bet
#' }
#'
#' @return returns a list with an order for Betfair
NULL

#' limitOrder
#'
#' @name limitOrder
#'
#' @description helper function to prepare a bet, used in conjunction with \link{prepare}
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
#' @return list with bet order
NULL

#' limitOnCloseOrder
#'
#' @name limitOnCloseOrder
#'
#' @description helper function to prepare a bet, used in conjunction with \link{prepare}
#'
#' @param size the size of the bet. \strong{Note:} for a market type of EACH_WAY,
#' the total stake is 2*size.
#' @param price the limit price
#'
#' @return list with bet order
NULL

#' cancel
#'
#' @name cancel
#'
#' @description cancel orders function
#'
#' @param ... multiple cancel orders instructions, use \link{cancel_inst}
#' @param marketId market id
#'
#' @return list
NULL

#' cancel bet instructions
#'
#' @name cancel_inst
#'
#' @description cancel individual orders using betIds
#'
#' @param betId unique betId
#' @param size reduction size
NULL

#' replace bet instructions
#'
#' @name replace_inst
#'
#' @description replace individual orders using betIds
#'
#' @param betId unique betId (required)
#' @param newPrice new price to strike bet (required)
NULL

#' update bet instructions
#'
#' @name update_inst
#'
#' @description update individual orders with new instructions for what to do when
#' the market goes in play
#'
#' @param betId unique betId (required)
#' @param persistenceType new instructions for what to do with order at in play
NULL

#' current
#'
#' @name current
#'
#' @description helper function used by the \link{currentOrders} method to build
#' request object for finding current unsettled bets
#'
#' @param betId unique bet Id
#' @param marketId unique market Id
#' @param orderProjection default of \strong{ALL} returns all unsettled positions,
#' matched or partially matched, change to \strong{EXECUTABLE} to filter for orders
#' with a portion remaining, or \strong{EXECUTION_COMPLETE} for orders which have
#' been filled, see orderProjection section in \link{bettingEnums} for more details
#' @param from date filter, string in yyyy-mm-dd format
#' @param to date filter, string in yyyy-mm-dd format
#' @param orderBy how to order orders, default orders by when they were placed, see
#' orderBy section in \link{bettingEnums} for more details
#' @param sort how to sort results, see sortDir section in \link{bettingEnums} for
#' more details
#' @param fromRecord specifies the first record to be returned, records start at
#' index zero (not one)
#' @param count specifies how many records are returned from the index position set
#' by \code{fromRecord}, there is a limit of 1000.
#'
#' @return list with parameters to filter currently unsettled bets
NULL
