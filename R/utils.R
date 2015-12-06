#' prepare bet for Betfair
#'
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
prepare_order <- function(marketId, selectionId, orderType = "LIMIT",
                          handicap = "0", side = "BACK", limitOrder = limitOrder(),
                          limitOnCloseOrder = limitOnCloseOrder(),
                          marketOnCloseOrder = list()) {

    orderList <- list("marketId" = as.character(marketId),
                      "instructions" = data.frame("selectionId" = as.character(selectionId),
                                                  "orderType" = as.character(orderType),
                                                  "side" = as.character(side)))
    if(!is.null(handicap)) {
        orderList$instructions$handicap <- as.character(handicap)
    }
    if(orderType == "LIMIT") {
        orderList$instructions$limitOrder = list(limitOrder)
    }
    if(orderType == "LIMIT_ON_CLOSE") {
        orderList$instructions$limitOnCloseOrder <- list(limitOnCloseOrder)
    }
    if(orderType == "MARKET_ON_CLOSE") {
        orderList$instructions$marketOnCloseOrder <- list(marketOnCloseOrder)
    }
    return(orderList)
}

#' limitOrder
#'
#' @description helper function to prepare a bet, used in conjunction with \link{prepare_order}
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
#'
#' @export
limitOrder <- function(size = 2, price, persistenceType = "LAPSE") {
    return(list(size = size,
                price = price,
                persistenceType = persistenceType))
}

#' limitOnCloseOrder
#'
#' @description helper function to prepare a bet, used in conjunction with \link{prepare_order}
#'
#' @param size the size of the bet. \strong{Note:} for a market type of EACH_WAY,
#' the total stake is 2*size.
#' @param price the limit price
#'
#' @return list with bet order
#'
#' @export
limitOnCloseOrder <- function(size = 2, price) {
    return(list(size = size,
                price = price))
}

#' cancel_orders
#'
#' @description cancel orders function
#'
#' @param ... multiple cancel orders instructions, use \link{cancelInstruction}
#' @param marketId market id
#'
#' @return list
cancel_orders <- function(..., marketId = NA) {

    inst <- as.list(environment())
    inst <- inst[!sapply(inst, is.na)]

    orders <- list(...)

    if(length(orders) > 0) {
        inst$instructions <- orders
        if(is.na(marketId)) stop("If instructions are entered, a marketId is required")
    }

    return(inst)
}

#' cancelInstruction
#'
#' @description cancel individual orders using betIds
#'
#' @param betId unique betId
#' @param size reduction size
#'
#' @export
cancelInstruction <- function(betId = NA, size = NA) {
    inst <- as.list(environment())
    return(inst)
}

#' replaceInstructions
#'
#' @description replace individual orders using betIds
#'
#' @param betId unique betId (required)
#' @param newPrice new price to strike bet (required)
#'
#' @export
replaceInstructions <- function(betId, newPrice) {
    inst <- list(betId = betId,
              newPrice = newPrice)
    return(inst)
}
