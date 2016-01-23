#' bf_account - Betfair Account Environment w/ methods
#'
#' @description Supply valid credentials, username, password and API key (see \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys}{developer.betfair.com}),
#' returning an environment with methods (see Methods section below) for returning data
#' about your account
#'
#' @name bf_account
#'
#' @param usr Betfair username
#' @param pwd Betfair password
#' @param key Betfair API key see \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys}{developer.betfair.com}
#'
#' @return returns environment with functions for various methods available for Betfair's
#' Account API
#'
#' @section Methods:
#' \describe{
#'      \item{\code{funds()}}{ Retrieve available funds, see \link{funds}}
#'      \item{\code{details()}}{ Retreive account details, see \link{details}}
#'      \item{\code{statement(after = NULL, before = NULL, n = NULL, wallet = NULL,
#'      include = "ALL")}}{ Return account statement with all transactions, including
#'      bets, deposits, withdrawals, and transfers, see \link{statement}}
#'      \item{\code{transfer(from = "uk", to = "aus", amount = 2)}}{ Transfer funds from one wallet
#'      to another, see \link{transfer}}
#' }
#' @export
bf_account <- function(usr, pwd, key) {

    # login for session token
    ssoid <- bf_login(usr = usr, pwd = pwd, key = key)

    self <- local({

        funds <- function() {
            # build request object
            req <- bf_basic_req(list(), method = "acc_funds")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "acc_details")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        details <- function() {
            # build request object
            req <- bf_basic_req(list(), method = "acc_details")
            req <- bf_request(req)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "acc_details")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        statement <- function(after = NULL, before = NULL, n = NULL, wallet = NULL,
                              include = "ALL") {
            # build request object
            req <- bf_basic_req(list(), method = "acc_statement")
            params <- bf_statement(after = after, before = before, n = n, wallet = wallet,
                                   include = include)
            req <- bf_request(req, params)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "acc_statement")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        transfer <- function(from = "UK", to = "AUSTRALIAN", amount = 2) {
            # build request object
            req <- bf_basic_req(list(), method = "acc_transfer")
            req <- bf_request(req, from = from, to = to, amount = amount)
            # post request
            res <- bf_post(body = req, ssoid$ssoid)
            # convert response
            res <- httr::content(res)
            # handle errors
            res <- bf_check(res, method = "acc_transfer")
            # parse response
            res <- bf_parse(res)

            return(res)
        }

        environment()
    })
    lockEnvironment(self, TRUE)
    structure(self, class = c("betfaiR", class(self)))
}

#' funds
#'
#' @description get available funds in your account
#'
#' @name funds
#'
#' @return dataframe with the following variables, \code{availableToBetBalance},
#' \code{exposure}, \code{retainedCommission}, \code{exposureLimit}, \code{discountRate},
#' \code{pointsBalance} and \code{wallet}
NULL

#' details
#'
#' @description get data about the account you have signed into
#'
#' @name details
#'
#' @return dataframe with the following variables, \code{currencyCode}, \code{firstName},
#' \code{lastName}, \code{localeCode}, \code{region}, \code{timezone}, \code{discountRate},
#' \code{pointsBalance}, \code{countryCode}
NULL

#' transfer
#'
#' @description transfer funds between UK and Australian wallets
#'
#' @name transfer
#'
#' @param from wallet, "UK" (default) or "AUSTRALIAN"
#' @param to wallet, "UK" (default) or "AUSTRALIAN"
#' @param amount amount to transfer, minimum of 2 (default)
#'
#' @return transaction id
NULL

#' statement
#'
#' @description return account statement with all or filtered transactions,
#' including deposits, withdrawals, bets, transfers, etc
#'
#' @name statement
#'
#' @param after filter records after this date, date should be in YYYY-MM-DD format
#' @param before filter records before this date, date should be in YYYY-MM-DD format
#' @param n number of records
#' @param wallet filter according to wallet, default returns both, enter "UK" or
#' "AUSTRALIAN"
#' @param include filter according to transaction type
#'
#' @return list of transactions, one element per transaction, this list can be
#' passed to \code{print}, \code{summary} or \code{plot}
NULL
