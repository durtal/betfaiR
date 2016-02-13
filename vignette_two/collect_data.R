library(betfaiR)
setwd("C:/Users/TomHeslop/Documents/Github/betfaiR/vignette_two/")
readRenviron("~/.Renviron") # slightly curious why I needed to do this?

# log in
bf <- betfair(usr = Sys.getenv("BETFAIR_USR"),
              pwd = Sys.getenv("BETFAIR_PWD"),
              key = Sys.getenv("BETFAIR_KEY"))

# return list of files to check whether marketIds have been collected before
files <- list.files()
# if marketIds are not available collect and save them, otherwise load them
if(!("marketIds.RDS" %in% files)) {
    cittot <- bf$marketCatalogue(filter = marketFilter(competitionIds = 31,
                                                       textQuery = "Tottenham",
                                                       to = "2016-02-15",
                                                       marketTypeCodes = "MATCH_ODDS"),
                                 maxResults = 10,
                                 marketProjection = c("EVENT", "RUNNER_DESCRIPTION"))
    arslei <- bf$marketCatalogue(filter = marketFilter(competitionIds = 31,
                                                       textQuery = "Arsenal",
                                                       to = "2016-02-15",
                                                       marketTypeCodes = "MATCH_ODDS"),
                                 maxResults = 10,
                                 marketProjection = c("EVENT", "RUNNER_DESCRIPTION"))
    winner <- bf$marketCatalogue(filter = marketFilter(competitionIds = 31,
                                                       marketTypeCodes = "WINNER"),
                                 marketProjection = c("EVENT", "RUNNER_DESCRIPTION"))
    markets <- list(cittot = cittot, arslei = arslei, winner = winner)
    saveRDS(markets, "marketIds.RDS")
} else {
    markets <- readRDS("marketIds.RDS")
}

# get current time, to allow comparison between each of the 3 markets
currentTime <- Sys.time()
# extract marketIds, and their names
marketIds <- sapply(markets, function(i) i[[1]]$market$marketId)
# use marketIds to see if markets are still available
available_markets <- bf$marketCatalogue(filter = marketFilter(marketIds = as.vector(marketIds)),
                                        maxResults = 3)
available_markets <- sapply(available_markets, function(i) i$market$marketId)
# build logical vector
test <- marketIds %in% available_markets
# return names of markets that are still available
available_markets <- names(marketIds[test])

# loop through each market and retrieve data, add currentTime to make comparison easier
plyr::l_ply(available_markets, function(i, files, currentTime, bf, markets) {

    filename <- paste0(i, ".RDS")
    if(filename %in% files) {
        tmp <- readRDS(filename)
    } else {
        tmp <- list()
    }
    cur <- markets[[i]]
    cur <- bf$marketBook(marketIds = cur,
                         priceProjection = c("EX_ALL_OFFERS", "EX_TRADED"))
    cur[[1]]$collectedAt <- currentTime

    tmp <- append(tmp, cur)

    saveRDS(tmp, filename)

}, files = files,
    currentTime = currentTime,
    bf = bf,
    markets = marketIds)
