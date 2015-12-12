#' create list to be used as filter in various methods
#'
#' @description build a market filter object given the parameters available, this
#' object can be used in the following methods \link{competitions}, \link{countries},
#' \link{events}, \link{eventTypes}, \link{marketCatalogue}, and \link{marketTypes}
#'
#' @name marketFilter
#'
#' @param bspOnly \code{(boolean)} Restrict to BSP (Betfair Starting Price)
#' markets only, TRUE, or non-BSP markets, FALSE. If not specified then returns
#' both BSP and non-BSP markets.
#' @param competitionIds \code{(string)} Restrict markets by the competitions
#' associated with the market.
#' @param eventIds \code{(string)} Restrict markets by the event Id associated
#' with the market.
#' @param eventTypeIds \code{(numeric)} Restrict markets by event type associated
#' with the market, ie. Football, Hockey, etc.
#' @param exchangeIds \code{(numeric)} Restrict markets by the Exchange where the
#' market operates. As of Jun 11, 2015, \strong{not available}.
#' @param inPlayOnly \code{boolean} Restrict to markets that are currently in
#' play, TRUE, or not currently in play, FALSE. If not specified returns both.
#' @param marketBettingTypes see section \strong{MarketBettingType} in \link{BettingEnums}
#' or \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#MarketBettingType}{developer.betfair.com}
#' Restrict to markets that match the betting type of the market, ie. Odds,
#' Asian Handicap Singles, Asian Handicap Doubles.
#' @param marketCountries \code{string} Restrict to markets that are in the
#' specified country or countries.
#' @param marketIds \code{numeric} Restrict markets by the market Id associated
#' with the market.
#' @param from \code{string} start time after specified date, format date as "YYYY-MM-DD"
#' or with a time "YYYY-MM-DD 00:00:00".
#' @param to \code{string} start time before specified date, format date as "YYYY-MM-DD"
#' or with a time "YYYY-MM-DD 00:00:00".
#' @param marketTypeCodes \code{numeric} Restrict to markets that match the type
#' of the market, ie. MATCH_ODDS, HALF_TIME_SCORE. You should use this instead
#' of relying on the market name as the market type codes are the same in all
#' locales.
#' @param textQuery \code{string} Restrict markets by any text associated with
#' the market such as Name, Event, Competition, etc. You can include a wildcard
#' (*) character, as long as it is not the first character.
#' @param turnInPlayEnabled \code{boolean} Restrict to markets that will turn in
#' play, TRUE, or will not turn in play, FALSE. If not specified returns both.
#' @param venues \code{string} Restrict markets by the venue associated with the
#' market. Currently, as of Jun 11, 2015, only Horse Racing markets have venues.
#' @param withOrders see section \strong{OrderStatus} in \link{BettingEnums}
#' or \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#OrderStatus}{developer.betfair.com}
#' Restrict to markets that I have one or more orders in these status.
#'
#' @export
marketFilter <- function(bspOnly = NULL, competitionIds = NULL, eventIds = NULL,
                         eventTypeIds = NULL, exchangeIds = NULL, inPlayOnly = NULL,
                         marketBettingTypes = NULL, marketCountries = NULL,
                         marketIds = NULL, from = NULL, to = NULL,
                         marketTypeCodes = NULL, textQuery = NULL,
                         turnInPlayEnabled = NULL, venues = NULL, withOrders = NULL, ...) {


    tmp <- as.list(environment())
    tmp <- tmp[!sapply(tmp, is.null)]
    if(!is.null(from) & !is.null(to)) {
        tmp$from <- NULL
        tmp$to <- NULL
        tmp$marketStartTime <- list("from" = format(as.POSIXct(from), "%Y-%m-%dT%TZ"),
                                    "to" = format(as.POSIXct(to), "%Y-%m-%dT%TZ"))
    } else if(!is.null(from) & is.null(to)) {
        tmp$from <- NULL
        tmp$marketStartTime <- list("from" = format(as.POSIXct(from), "%Y-%m-%dT%TZ"))
    } else if(is.null(from) & !is.null(to)) {
        tmp$to <- NULL
        tmp$marketStartTime <- list("to" = format(as.POSIXct(to), "%Y-%m-%dT%TZ"))
    }

    return(tmp)
}
