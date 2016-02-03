#' @export
bf_request.acc_funds <- function(x, ...) {

    req <- standard_acc_request(method = "getAccountFunds")
    req$params$filter <- NULL

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
bf_request.acc_details <- function(x, ...) {

    req <- standard_acc_request(method = "getAccountDetails")
    req$params$filter <- NULL

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
bf_request.acc_statement <- function(x, params, ...) {

    req <- standard_acc_request(method = "getAccountStatement")
    req$params$filter <- NULL
    req$params <- params

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

#' @export
bf_request.acc_transfer <- function(x, from, to, amount, ...) {

    req <- standard_acc_request(method = "transferFunds")
    req$params$filter <- NULL
    req$params <- list(from = from,
                       to = to,
                       amount = amount)

    req <- jsonlite::toJSON(req, auto_unbox = TRUE)
    return(req)
}

standard_acc_request <- function(method = "getAccountFunds") {

    req <- list("jsonrpc" = "2.0",
                "method" = paste0("AccountAPING/v1.0/", method),
                "params" = list("filter" = list()),
                "id" = 1)
    return(req)
}
