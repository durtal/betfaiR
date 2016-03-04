# collect_data <- function(bf,
#                          marketIds,
#                          files,
#                          maxResults = 10,
#                          priceProjection = c("EX_ALL_OFFERS", "EX_TRADED")) {
#
#     available_markets <- bf$marketCatalogue(filter = marketFilter(marketIds = marketIds),
#                                             maxResults = maxResults)
#     available_markets <- sapply(available_markets, function(i) i$market$marketId)
#     test <- marketIds %in% available_markets
#     marketIds <- marketIds[test]
#
#     plyr::l_ply(marketIds, .fun = function(i, bf, files) {
#
#         filename <- paste0("market_", i, ".RDS")
#         if(filename %in% files) {
#             previous_data <- readRDS(filename)
#         } else {
#             previous_data <- list()
#         }
#         current_data <- bf$marketBook(marketIds = i,
#                                       priceProjection = priceProjection)
#
#     }, bf = bf, files = files)
#
# }
