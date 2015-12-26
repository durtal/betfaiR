#' post a request to Betfair
#'
#' @description POST request to Betfair's Exchange API, requires users to prepare
#' a request using \link{base_request}, \link{bf_request} and to have login
#' credentials from \link{bf_login}.
#'
#' @param body request body, json object containing data about the method and
#' params
#' @param headers headers, list object containing session token and api key
#'
#' @export
bf_post <- function(body, headers) {

    url <- "https://api.betfair.com/exchange/betting/json-rpc/v1"
    if(grepl("AccountAPING", body)) url <- "https://api.betfair.com/exchange/account/json-rpc/v1"
    headers <- httr::add_headers(unlist(headers))
    res <- httr::POST(url = url,
                      body = body,
                      headers)
    return(res)
}
