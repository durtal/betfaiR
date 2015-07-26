#' betfair_POST
#'
#' @description POST request to Betfair's Exchange API, requires users to prepare
#' a request using \link{base_request}, \link{betfair_request} and to have login in
#' credentials from \link{loginBetfair}.
#'
#' @param body request body, json object containing data about the method and
#' params
#' @param headers headers, list object containing session token and api key
#'
#' @export
betfair_POST <- function(body, headers) {

    headers <- httr::add_headers(unlist(headers))
    res <- httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
                      body = body,
                      headers)
    return(res)
}
