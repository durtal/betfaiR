#' check response is valid
#'
#' @description check for any errors in the response from \link{betfair_POST}
#'
#' @param res response object
#' @param method the method the response object came from, see methods section on
#' \link{betfair} page, or \link{base_request}.
#'
#' @details errors may be invalid JSON, missing parameters, or if the response contains
#' zero results, otherwise return the results with a class that corresponds to
#' the method (see \link{betfair}) that can then be parsed into a dataframe by
#' \link{betfair_parse}.
#'
#' @export
betfair_check <- function(res, method = "competitions") {

    errors <- list("-32700" = "Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text.",
                   "-32601" = "Method not found",
                   "-32602" = "Problem parsing the parameters, or a mandatory parameter was not found",
                   "-32603" = "Internal JSON-RPC error")

    if(!is.null(res$error)) {
        if(res$error$code %in% names(errors)) {
            stop("ERROR: ", res$error$code, " - ", errors[[as.character(res$error$code)]])
        } else {
            stop("ERROR: Unknown.")
        }
    } else if(length(res$result) == 0) {
        res$result <- "NO RESULTS RETURNED FROM QUERY."
    } else {
        class(res) <- c(class(res), method)
        return(res)
    }
}
