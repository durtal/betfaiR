#' login to Betfair
#'
#' @name bf_login
#'
#' @description login to Betfair to receive a session token
#'
#' @param usr Betfair username
#' @param pwd Betfair password
#' @param key Betfair API Key, see \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys}{developer.betfair.com}
#'
#' @details function is invoked when calling \link{betfair}
#'
#' @return list with class \code{bf_login} which contains the parameters
#' entered into the function, the response (includes a session token) and the
#' required headers for querying the API
#'
#' @export
bf_login <- function(usr, pwd, key) {

    # create payload
    cred <- paste0("username=", usr, "&password=", pwd)
    # POST request, expected response is json object with Session Token
    resp <- httr::POST(url = "https://identitysso.betfair.com/api/login",
                       query = cred,
                       httr::add_headers("Accept" = "application/json",
                                   "X-Application" = key))
    # construct list containing response
    ssoid <- list()
    class(ssoid) <- c(class(ssoid), "bf_login")
    ssoid$usr <- list(usr = usr,
                      pwd = pwd,
                      key = key)
    ssoid$resp <- httr::content(resp)
    if(ssoid$resp$status == "FAIL") {
        warnMessage <- paste0("Login failed:\t", ssoid$resp$error)
        warning(warnMessage)
    } else {
        message("Login successful")
    }
    ssoid$ssoid <- list("Accept" = "application/json",
                        "X-Application" = ssoid$resp$product,
                        "X-Authentication" = ssoid$resp$token,
                        "Content-Type" = "application/json")
    return(ssoid)
}

#' @export
print.bf_login <- function(x) {
    object <- x

    cat("Betfair Login Details:\n\tusr:\t",
        object$usr$usr,
        "\n\tpwd:\t", object$usr$pwd,
        "\n\tkey:\t", object$usr$key,
        "\n\nSession Token:\n\t",
        object$ssoid$'X-Authentication')
}
