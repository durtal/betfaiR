library(betfaiR)

files <- list.files()
if(!("login.RDS" %in% files)) {
    bf <- betfair(usr = Sys.getenv("BETFAIR_USR"),
                  pwd = Sys.getenv("BETFAIR_PWD"),
                  key = Sys.getenv("BETFAIR_KEY"))
    saveRDS(bf, "login.RDS")
} else {
    bf <- readRDS("login.RDS")
}

if(!("marketIds.RDS" %in% files)) {
    cittot <- bf$marketCatalogue(filter = marketFilter(competitionIds = 31,
                                                       textQuery = "Tottenham",
                                                       to = "2016-02-15",
                                                       marketTypeCodes = "MATCH_ODDS"),
                                 maxResults = 10)
    arslei <- bf$marketCatalogue(filter = marketFilter(competitionIds = 31,
                                                       textQuery = "Arsenal",
                                                       to = "2016-02-15",
                                                       marketTypeCodes = "MATCH_ODDS"),
                                 maxResults = 10)
    winner <- bf$marketCatalogue(filter = marketFilter(competitionIds = 31,
                                                       marketTypeCodes = "WINNER"))
    marketIds <- list(cittot = cittot, arslei = arslei, winner = winner)
    saveRDS(marketIds, "marketIds.RDS")
} else {
    marketIds <- readRDS("marketIds.RDS")
}
