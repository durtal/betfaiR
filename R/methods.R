#' competitions method
#'
#' @description competitions (ie. World Cup 2014) associated with the markets
#' selected by the \code{filter} parameter.
#'
#' @name competitions
#'
#' @param filter list to select desired markets, see \link{marketFilter},
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#' competitions (ie. World Cup 2014) associated with the
#' markets selected by the \code{filter} parameter, with the following variables:
#' \itemize{
#'      \item{\code{competition_id} competition id}
#'      \item{\code{competition_name} competition name}
#'      \item{\code{marketCount} number of markets associated with this competition}
#'      \item{\code{competitionRegion} region in which this competition is happening}
#' }
#'
#' @examples
#' \dontrun{
#'
#' # after logging in
#' bf <- betfair(usr = "username", pwd = "password", key = "API_key)
#'
#' # return all competitions
#' bf$competitions()
#'
#' # filter just football competitions
#' bf$competitions(filter = list("eventTypeIds" = 1))
#'
#' # or
#' bf$competitions(filter = marketFilter(eventTypeIds = 1))
#' }
NULL

#' countries method
#'
#' @description countries associated with markets
#'
#' @name countries
#'
#' @param filter list to select desired markets, see \link{marketFilter},
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#'
#' @return a dataframe of countries with markets selected by the \code{filter}
#' parameter, with the following variables:
#' \itemize{
#'      \item{\code{countryCode} the ISO-2 code for the event, ISO-2 codes are
#'      available on \href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}{wiki}}
#'      \item{\code{marketCount} number of markets associated with this competition}
#' }
NULL

#' eventTypes method
#'
#' @description event types associated with markets
#'
#' @name eventTypes
#'
#' @param filter list to select desired markets, see \link{marketFilter},
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#'
#' @return a dataframe of event types associated with markets selected by the
#' \code{filter} parameter, with the following variables:
#' \itemize{
#'      \item{\code{eventType_id} eventType id}
#'      \item{\code{eventType_name} eventType name}
#'      \item{\code{marketCount} number of markets associated with this competition}
#' }
NULL

#' events method
#'
#' @description events associated with markets
#'
#' @name events
#'
#' @param filter list to select desired markets, see \link{marketFilter},
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#'
#' @return a dataframe of events (ie. Manchester United vs Arsenal) associated
#' with markets selected by the \code{filter} parameter, with the following variables:
#' \itemize{
#'      \item{\code{event_id} event id}
#'      \item{\code{event_name} event name}
#'      \item{\code{event_countryCode} ISO-2 country code for the event}
#'      \item{\code{event_timezone} the timezone in which the event is taking place}
#'      \item{\code{event_venue} the event venue (if applicable)}
#'      \item{\code{event_openDate} the scheduled start Date of rhe event}
#'      \item{\code{marketCount} number of markets associated with this competition}
#' }
#'
#' @examples
#' \dontrun{
#'
#' # login
#' bf <- betfair(usr = "username", pwd = "password", key = "API_key")
#'
#' # return all events, probably best to store as dataframe, likely exceed 1000 rows
#' events_df <- bf$events()
#'
#' # return football events
#' # using eventType id learned by using bf$eventTypes()
#' football <- bf$events(filter = marketFilter(eventTypeIds = 1))
#' }
NULL

#' venues method
#'
#' @description venues associated with markets
#'
#' @name venues
#'
#' @param filter list to select desired markets, see \link{marketFilter},
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#'
#' @return a dataframe of venues (ie. Cheltenham, Ascot) associated with markets
#' selected by the \code{filter} parameter, only Horse Racing markets are
#' associated with a venue.
NULL

#' marketBook method
#'
#' @description dynamic data about markets. Data includes prices, the status of the
#' market, the status of selections, the traded volume, and the status of any orders
#' you have placed in the market.
#'
#' @name marketBook
#'
#' @param marketIds (string) one or more market Ids. The number of markets returned
#' depends on the amount of data you request via the price projection.
#' @param priceProjection the projection of price data you want to receive in the
#' response, see section
#' \strong{PriceProjection} in \link{bettingEnums}.
#' @param orderProjection the orders you want to receive in the response, see
#' section \strong{OrderProjection} in \link{BettingEnums}.
#' @param matchProjection if you ask for orders, specifies the representation of
#' matches, see section \strong{MatchProjection} in \link{BettingEnums}.
#'
#' @details  Seperate requests should be made for ACTIVE and CLOSED markets.
#' Requests that include both ACTIVE and CLOSED markets will only return those
#' markets that are active.
#'
#' Data request limits apply to requests using \code{marketBook} that include price
#' or order projections. Calls to \code{marketBook} should be made up to a maximum of
#' 5 times per second to a single marketId.
#'
#' \strong{BEST PRACTICE}: those seeking to use \code{marketBook} to obtain price,
#' volume, unmatched orders and matched position in a single operation should
#' provide an \code{orderProjection} of \strong{EXECUTABLE} in their \code{marketBook}
#' request and receive all unmatched orders and the aggregated matched volume from
#' all orders.  The level of matched volume aggregation (\code{matchProjection})
#' should be \strong{ROLLED_UP_BY_AVG_PRICE} or \strong{ROLLED_UP_BY_PRICE}, the
#' former being preferred. This provides a single call in which you can track prices,
#' traded volume, unmatched orders, and your evolving matched position with a reasonably
#' fixed, minimally sized response.
NULL

#' marketTypes method
#'
#' @description marketTypes associated with markets
#'
#' @name marketTypes
#'
#' @param filter list to select desired markets, see \link{marketFilter},
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#'
#' @return a dataframe of market types (ie. MATCH_ODDS, NEXT_GOAL) associated
#' with markets selected by the \code{filter} parameter, with the following variables:
#' \itemize{
#'      \item{\code{marketType} the market type}
#'      \item{\code{marketCount} number of markets associated with this competition}
#' }
NULL

#' marketCatalogue method
#'
#' @description marketCatalogue associated with markets, you use \code{marketCatalogue}
#' to retrieve the id of a market, the names of selections and other information about
#' the market
#'
#' @name marketCatalogue
#'
#' @param filter list to select desired markets, see \strong{marketFilter} section below
#' or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
#' for the different options.
#' @param marketProjection the type and amount of data returned about the market, default of \strong{EVENT}, see
#' section \strong{marketProjection} in \link{BettingEnums}, or visit
#' \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketProjection}{developer.betfair.com}
#' @param sort the order of results, see section \strong{sort} in \link{BettingEnums}, or
#' visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketSort}{developer.betfair.com}
#' @param maxResults limit on the number of results returned, default of 1
#' @param keepRules when \strong{MARKET_DESCRIPTION} is entered into the \strong{marketProjection}
#' parameter, it returns a large amount of text containing the rules of the market, by default these
#' are discarded, change \code{keepRules = TRUE} to keep.
#'
#' @details You use \code{marketCatalogue} to retrieve the name of the market, the
#' names of selections and other information about markets.  Market Data Request
#' Limits apply to requests.
#'
#' @return a dataframe of markets that does not change (or changes very rarely), will
#' contain data about the market ids, selections and other info, with a selection
#' of the following variables:
NULL

#' placeOrders method
#'
#' @description \code{placeOrders} function allows bets to be placed.
#'
#' @name placeOrders
#'
#' @param marketId market id into which the bet will be placed
#' @param selectionId selection id, the unique id for selection in the market, this
#' will be a horse, a team, etc, these ids can be found using the \link{marketCatalogue}
#' and \link{marketBook} functions
#' @param orderType the type of order, \strong{LIMIT} a normal exchange order for
#' immediate execution, \strong{LIMIT_ON_CLOSE} limit order for the auction (SP bet)
#' \strong{MARKET_ON_CLOSE} market order for the auction (SP)
#' @param handicap
#' @param side \strong{BACK} or \strong{LAY}
#' @param orderthe type of order, this can be three types and inputs depend on
#' parameter \strong{orderType}.  If orderType is \strong{LIMIT} then use the
#' \link{limitOrder} function to construct order.  If orderType is \strong{LIMIT_ON_CLOSE}
#' use the \link{limitOnCloseOrder} function to construct the order.  If orderType is
#' \strong{MARKET_ON_CLOSE} then a simple list consisting of one element called
#' \strong{liability} should be supplied
#'
#' @return list with details about the bet, the market the bet was made in, the prices
#' attained, whether it was successful or failed
NULL

#' cancelOrders method
#'
#' @description \code{cancelOrders} function cancels all or specific bets waiting to
#' be matched
#'
#' @name cancelOrders
#'
#' @param ... target specific bets to cancel, use \link{cancel_inst} to enter
#' one or more bets, \code{cancel_inst} requires \strong{betId}, and \strong{size}
#' can be used to cancel part of an order
#' @param marketId target bets in a specific market
#'
#' @return list with details about the cancel bets, whether the cancellation was successful
NULL

#' replaceOrders method
#'
#' @description \code{replaceOrders} function replaces specific bets that are waiting to
#' be matched
#'
#' @name replaceOrders
#'
#' @param ... target specific bets to cancel, use \link{replace_inst} to enter
#' one or more bets, \code{replace_inst} requires \strong{betId}, and
#' \strong{newPrice}
#' @param marketId target bets in a specific market
#'
#' @return list with details about the replaced bets, whether operation was successful
NULL

#' marketPnL method
#'
#' @description \code{marketPnL} function returns data about the specified market
#' and the current profit and/or loss for each of the selections in that market
#'
#' @name marketPnL
#'
#' @param marketId target bets in a specific market
#' @param settled include settled bets
#' @param bsp include bets that will be made at BSP
#' @param NET include commission
#'
#' @return list with data about the market and any profit and loss for selections
NULL

#' updateOrders method
#'
#' @description \code{updateOrders} function updates instructions for specific bets
#' and how they are handled when the market goes in play
#'
#' @name updateOrders
#'
#' @param ... target specific bets to update, use \link{update_inst} to enter one
#' or more bets, \code{update_inst} requires \strong{betId} and
#' \strong{persistenceType}
#' @param marketId target bets in a specific market
#'
#' @return list with details about the updated bets
NULL

#' currentOrders method
#'
#' @description \code{currentOrders} function allows users to retrieve data about
#' any unsettled bets they have open.  Use the parameters to filter to specific
#' markets, or leave the function empty to return \strong{all} open positions
#'
#' @name currentOrders
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
#' @return list with data about individual orders
NULL

#' clearedOrders method
#'
#' @description \code{clearedOrders} function allows users to retrieve data about
#' settled/voided/lapsed/cancelled bets.  These can be filtered by various parameters
#'
#' @name clearedOrders
#'
#' @param betStatus filter based on how the bet was settled, one of \strong{SETTLED},
#' \strong{VOIDED}, \strong{LAPSED}, or \strong{CANCELLED}
#' @param eventTypeIds retrieve bets based on sport
#' @param eventIds retrieve bets based on event
#' @param marketIds retrieve bets based on markets
#' @param runnerIds retrieve bets on specific runners
#' @param betIds unique bets
#' @param side \strong{BACK} or \strong{LAY} orders
#' @param from filter according to date, format should be yyyy-mm-dd
#' @param to filter according to date, format should be yyyy-mm-dd
#'
#' @return list with parameters to filter cleared bets
NULL
