#' BettingEnums
#'
#' @name BettingEnums
#'
#' @section MarketProjection:
#' \itemize{
#'      \item \strong{COMPETITION} If not selected then the competition will not
#'      be returned with marketCatalogue.
#'      \item \strong{EVENT} If not selected then the event will not be returned
#'      with marketCatalogue.
#'      \item \strong{EVENT_TYPE} If not selected then the eventType will not be
#'      returned with marketCatalogue.
#'      \item \strong{MARKET_START_TIME} If not selected then the start time will
#'      not be returned with marketCatalogue.
#'      \item \strong{MARKET_DESCRIPTION} If not selected then the description
#'      will not be returned with marketCatalogue.
#'      \item \strong{RUNNER_DESCRIPTION} If not selected then the runners will
#'      not be returned with marketCatalogue.
#'      \item \strong{RUNNER_METADATA} If not selected then the runner metadata
#'      will not be returned with marketCatalogue. If selected then RUNNER_DESCRIPTION
#'      will also be returned regardless of whether it is included as a market
#'      projection.
#' }
#'
#' @section PriceData:
#' \itemize{
#'      \item \strong{SP_AVAILABLE} Amount available for the BSP auction.
#'      \item \strong{SP_TRADED} Amount traded in the BSP auction.
#'      \item \strong{EX_BEST_OFFERS} Only the best prices available for each
#'      runner, to requested price depth.
#'      \item \strong{EX_ALL_OFFERS} EX_ALL_OFFERS trumps EX_BEST_OFFERS if both
#'      settings are present.
#'      \item \strong{EX_TRADED} Amount traded on the exchange.
#' }
#'
#' @section MatchProjection:
#' \itemize{
#'      \item \strong{NO_ROLLUP} No rollup, return raw fragments.
#'      \item \strong{ROLLED_UP_BY_PRICE} Rollup matched amounts by distinct
#'      matched prices per side.
#'      \item \strong{ROLLED_UP_BY_AVG_PRICE} Rollup matched amounts by average
#'      matched price per side
#' }
#'
#' @section OrderProjection:
#' \itemize{
#'      \item \strong{ALL} EXECUTABLE and EXECUTION_COMPLETE orders.
#'      \item \strong{EXECUTABLE} An order that has a remaining unmatched portion.
#'      \item \strong{EXECUTION_COMPLETE} An order that does not have any remaining
#'      unmatched portion.
#' }
#'
#' @section MarketStatus:
#' \itemize{
#'      \item \strong{INACTIVE} The market has been created but isn't yet available.
#'      \item \strong{OPEN} The market is open for betting.
#'      \item \strong{SUSPENDED} The market is suspended and not available for betting.
#'      \item \strong{CLOSED} The market has been settled and is no longer available
#'      for betting.
#' }
#'
#' @section RunnerStatus:
#' \itemize{
#'      \item \strong{ACTIVE} ACTIVE
#'      \item \strong{WINNER} WINNER
#'      \item \strong{LOSER} LOSER
#'      \item \strong{REMOVED_VACANT} REMOVED_VACANT applies to Greyhounds. Greyhound
#'      markets always return a fixed number of runners (traps). If a dog has been
#'      removed, the trap is shown as vacant.
#'      \item \strong{REMOVED} REMOVED
#'      \item \strong{HIDDEN} The selection is hidden from the market.  This occurs
#'      in Horse Racing markets were runners is hidden when it is doesn’t hold an
#'      official entry following an entry stage. This could be because the horse
#'      was never entered or because they have been scratched from a race at a
#'      declaration stage. All matched customer bet prices are set to 1.0 even
#'      if there are later supplementary stages. Should it appear likely that a
#'      specific runner may actually be supplemented into the race this runner will
#'      be reinstated with all matched customer bets set back to the original prices.
#' }
#'
#' @section TimeGranularity:
#' \itemize{
#'      \item \strong{DAYS}
#'      \item \strong{HOURS}
#'      \item \strong{MINUTES}
#' }
#'
#' @section Side:
#' \itemize{
#'      \item \strong{BACK} To back a team, horse or outcome is to bet on the
#'      selection to win.
#'      \item \strong{LAY} To lay a team, horse, or outcome is to bet on the
#'      selection to lose.
#' }
#'
#' @section OrderStatus:
#' \itemize{
#'      \item \strong{EXECUTION_COMPLETE} An order that does not have any remaining
#'      unmatched portion.
#'      \item \strong{EXECUTABLE} An order that has a remaining unmatched portion.
#' }
#'
#' @section OrderBy:
#' \itemize{
#'      \item \strong{BY_BET} \strong{Deprecated} Use BY_PLACE_TIME instead. Order
#'      by placed time, then bet id.
#'      \item \strong{BY_MARKET} Order by market id, then placed time, then bet id.
#'      \item \strong{BY_MATCH_TIME} Order by time of last matched fragment (if any),
#'      then placed time, then bet id. Filters out orders which have no matched date.
#'      The dateRange filter (if specified) is applied to the matched date.
#'      \item \strong{BY_PLACE_TIME} Order by placed time, then bet id. This is an
#'      alias of to be deprecated BY_BET. The dateRange filter (if specified) is
#'      applied to the placed date.
#'      \item \strong{BY_SETTLED_TIME} Order by time of last settled fragment
#'      (if any due to partial market settlement), then by last match time, then
#'      placed time, then bet id. Filters out orders which have not been settled.
#'      The dateRange filter (if specified) is applied to the settled date.
#'      \item \strong{BY_VOID_TIME} Order by time of last voided fragment (if any),
#'      then by last match time, then placed time, then bet id. Filters out orders
#'      which have not been voided. The dateRange filter (if specified) is applied
#'      to the voided date.
#' }
#'
#' @section SortDir:
#' \itemize{
#'      \item \strong{EARLIEST_TO_LATEST} Order from earliest value to latest e.g.
#'      lowest betId is first in the results.
#'      \item \strong{LATEST_TO_EARLIEST} Order from the latest value to the earliest
#'      e.g. highest betId is first in the results.
#' }
#'
#' @section OrderType:
#' \itemize{
#'      \item \strong{LIMIT} A normal exchange limit order for immediate execution.
#'      \item \strong{LIMIT_ON_CLOSE} Limit order for the auction (SP).
#'      \item \strong{MARKET_ON_CLOSE} Market order for the auction (SP).
#' }
#'
#' @section MarketSort:
#' \itemize{
#'      \item \strong{MINIMUM_TRADED} Minimum traded volume
#'      \item \strong{MAXIMUM_TRADED} Maximum traded volume
#'      \item \strong{MINIMUM_AVAILABLE} Minimum available to match
#'      \item \strong{MAXIMUM_AVAILABLE} Maximum available to match
#'      \item \strong{FIRST_TO_START} The closest markets based on their expected
#'      start time.
#'      \item \strong{LAST_TO_START} The most distant markets based on their expected
#'      start time.
#' }
#'
#' @section MarketBettingType:
#' \itemize{
#'      \item \strong{ODDS} Odds Market
#'      \item \strong{LINE} Line Market
#'      \item \strong{RANGE} Range Market
#'      \item \strong{ASIAN_HANDICAP_DOUBLE_LINE} Asian Handicap Market
#'      \item \strong{ASIAN_HANDICAP_SINGLE_LINE} Asian Single Line Market
#'      \item \strong{FIXED_ODDS} Sportsbook Odds Market. This type is deprecated
#'      and will be removed in future releases, when Sportsbook markets will be
#'      represented as ODDS market but with a different product type.
#' }
#'
#' @section ExecutionReportStatus:
#' \itemize{
#'      \item \strong{SUCCESS} Order processed successfully
#'      \item \strong{FAILURE} Order failed.
#'      \item \strong{PROCESSED_WITH_ERRORS} The order itself has been accepted,
#'      but at least one (possibly all) actions have generated errors. This error
#'      only occurs for replaceOrders, cancelOrders and updateOrders operations.
#'      The placeOrders operation will not return PROCESSED_WITH_ERRORS status as
#'      it is an atomic operation.
#'      \item \strong{TIMEOUT} Order timed out.
#' }
#'
#' @section ExecutionReportErrorCode:
#' \itemize{
#'      \item \strong{ERROR_IN_MATCHER} The matcher is not healthy
#'      \item \strong{PROCESSED_WITH_ERRORS} The order itself has been accepted,
#'      but at least one (possibly all) actions have generated errors
#'      \item \strong{BET_ACTION_ERROR} There is an error with an action that has
#'      caused the entire order to be rejected. Check the instructionReports
#'      errorCode for the reason for the rejection of the order.
#'      \item \strong{INVALID_ACCOUNT_STATE} Order rejected due to the account's
#'      status (suspended, inactive, dup cards)
#'      \item \strong{INVALID_WALLET_STATUS} Order rejected due to the account's
#'      wallet's status
#'      \item \strong{INSUFFICIENT_FUNDS} Account has exceeded its exposure limit
#'      or available to bet limit
#'      \item \strong{LOSS_LIMIT_EXCEEDED} The account has exceed the self imposed
#'      loss limit
#'      \item \strong{MARKET_SUSPENDED} Market is suspended
#'      \item \strong{MARKET_NOT_OPEN_FOR_BETTING} Market is not open for betting.
#'      It is either not yet active, suspended or closed awaiting settlement.
#'      \item \strong{DUPLICATE_TRANSACTION} Duplicate customer reference data
#'      submitted - Please note: There is a time window associated with the
#'      de-duplication of duplicate submissions which is 60 second
#'      \item \strong{INVALID_ORDER} Order cannot be accepted by the matcher due
#'      to the combination of actions. For example, bets being edited are not on
#'      the same market, or order includes both edits and placement
#'      \item \strong{INVALID_MARKET_ID} Market doesn't exist
#'      \item \strong{PERMISSION_DENIED} Business rules do not allow order to be
#'      placed. You are either attempting to place the order using a Delayed
#'      Application Key or from a restricted jurisdiction (i.e. USA)
#'      \item \strong{DUPLICATE_BETIDS} duplicate bet ids found
#'      \item \strong{NO_ACTION_REQUIRED} Order hasn't been passed to matcher as
#'      system detected there will be no state change
#'      \item \strong{SERVICE_UNAVAILABLE} The requested service is unavailable
#'      \item \strong{REJECTED_BY_REGULATOR} The regulator rejected the order. On
#'      the Italian Exchange this error will occur if more than 50 bets are sent
#'      in a single placeOrders request.
#' }
#'
#' @section PersistenceType:
#' \itemize{
#'      \item \strong{LAPSE} Lapse the order when the market is turned in-play
#'      \item \strong{PERSIST} Persist the order to in-play. The bet will be place
#'      automatically into the in-play market at the start of the event.
#'      \item \strong{MARKET_ON_CLOSE} Put the order into the auction (SP) at
#'      turn-in-play
#' }
#'
#' @section InstructionReportStatus:
#' \itemize{
#'      \item \strong{SUCCESS}
#'      \item \strong{FAILURE}
#'      \item \strong{TIMEOUT}
#' }
#'
#' @section InstructionReportErrorCode:
#' \itemize{
#'      \item \strong{INVALID_BET_SIZE} bet size is invalid for your currency
#'      or your regulator
#'      \item \strong{INVALID_RUNNER} Runner does not exist, includes vacant
#'      traps in greyhound racing
#'      \item \strong{BET_TAKEN_OR_LAPSED} Bet cannot be cancelled or modified
#'      as it has already been taken or has lapsed Includes attempts to cancel/modify
#'      market on close BSP bets and cancelling limit on close BSP bets
#'      \item \strong{BET_IN_PROGRESS} No result was received from the matcher
#'      in a timeout configured for the system
#'      \item \strong{RUNNER_REMOVED} Runner has been removed from the event
#'      \item \strong{MARKET_NOT_OPEN_FOR_BETTING} Attempt to edit a bet on a
#'      market that has closed.
#'      \item \strong{LOSS_LIMIT_EXCEEDED} The action has caused the account to
#'      exceed the self imposed loss limit
#'      \item \strong{MARKET_NOT_OPEN_FOR_BSP_BETTING} Market now closed to bsp
#'      betting. Turned in-play or has been reconciled
#'      \item \strong{INVALID_PRICE_EDIT} Attempt to edit down the price of a bsp
#'      limit on close lay bet, or edit up the price of a limit on close back bet
#'      \item \strong{INVALID_ODDS} Odds not on price ladder - either edit or placement
#'      \item \strong{INSUFFICIENT_FUNDS} Insufficient funds available to cover the
#'      bet action. Either the exposure limit or available to bet limit would be
#'      exceeded
#'      \item \strong{INVALID_PERSISTENCE_TYPE} Invalid persistence type for this
#'      market, e.g. KEEP for a non bsp market
#'      \item \strong{ERROR_IN_MATCHER} A problem with the matcher prevented this
#'      action completing successfully
#'      \item \strong{INVALID_BACK_LAY_COMBINATION} The order contains a back and
#'      a lay for the same runner at overlapping prices. This would guarantee a self
#'      match. This also applies to BSP limit on close bets
#'      \item \strong{ERROR_IN_ORDER} The action failed because the parent order failed
#'      \item \strong{INVALID_BID_TYPE} Bid type is mandatory
#'      \item \strong{INVALID_BET_ID} Bet for id supplied has not been found
#'      \item \strong{CANCELLED_NOT_PLACED} Bet cancelled but replacement bet was not placed
#'      \item \strong{RELATED_ACTION_FAILED} Action failed due to the failure of
#'      a action on which this action is dependent
#'      \item \strong{NO_ACTION_REQUIRED} the action does not result in any state
#'      change. eg changing a persistence to it's current value
#' }
#'
#' @section RollupModel:
#' \itemize{
#'      \item \strong{STAKE} The volumes will be rolled up to the minimum value
#'      which is >= rollupLimit.
#'      \item \strong{PAYOUT} The volumes will be rolled up to the minimum value
#'      where the payout( price * volume ) is >= rollupLimit.
#'      \item \strong{MANAGED_LIABILITY} The volumes will be rolled up to the
#'      minimum value which is >= rollupLimit, until a lay price threshold.
#'      There after, the volumes will be rolled up to the minimum value such
#'      that the liability >= a minimum liability. Not supported as yet.
#'      \item \strong{NONE} No rollup will be applied. However the volumes will
#'      be filtered by currency specific minimum stake unless overridden specifically
#'      for the channel.
#' }
#'
#' @section GroupBy:
#' \itemize{
#'      \item \strong{EVENT_TYPE} A roll up of settled P&L, commission paid and
#'      number of bet orders, on a specified event type
#'      \item \strong{EVENT} A roll up of settled P&L, commission paid and number
#'      of bet orders, on a specified event
#'      \item \strong{MARKET} A roll up of settled P&L, commission paid and number
#'      of bet orders, on a specified market
#'      \item \strong{SIDE} An averaged roll up of settled P&L, and number of
#'      bets, on the specified side of a specified selection within a specified
#'      market, that are either settled or voided
#'      \item \strong{BET} The P&L, commission paid, side and regulatory information
#'      etc, about each individual bet order
#' }
#'
#' @section BetStatus:
#' \itemize{
#'      \item \strong{SETTLED} A matched bet that was settled normally
#'      \item \strong{VOIDED} A matched bet that was subsequently voided by Betfair,
#'      before, during or after settlement
#'      \item \strong{LAPSED} Unmatched bet that was cancelled by Betfair (for
#'      example at turn in play).
#'      \item \strong{CANCELLED} Unmatched bet that was cancelled by an explicit
#'      customer action.
#' }
NULL
