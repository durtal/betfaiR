# collect_data <- function(bf,
#                          marketIds,
#                          maxResults = 10,
#                          priceProjection = c("EX_ALL_OFFERS", "EX_TRADED")) {
#
#     files <- list.files()
#     # ascertain which markets are still live
#     available_markets <- bf$marketCatalogue(filter = marketFilter(marketIds = marketIds),
#                                             maxResults = maxResults)
#     available_markets <- sapply(available_markets, function(i) i$market$marketId)
#     test <- marketIds %in% available_markets
#     marketIds <- marketIds[test]
#
#     # save current time, to add to retrieved data
#     currentTime <- Sys.time()
#     # loop through each market and retrieve data, adding currentTime to enable comparison across markets
#     plyr::l_ply(marketIds, .fun = function(i, bf, files) {
#
#         filename <- paste0("market_", i, ".RDS")
#         if(filename %in% files) {
#             previous_data <- readRDS(filename)
#         } else {
#             previous_data <- list()
#         }
#         # retrieve data from market
#         current_data <- bf$marketBook(marketIds = i,
#                                       priceProjection = priceProjection)
#         # add collectedAt element to data returned
#         current_data[[1]]$collectedAt <- currentTime
#         # append new current_data to previous_data (which is either empty or previously collected data)
#         previous_data <- append(previous_data, current_data)
#         # save new data
#         saveRDS(previous_data, filename)
#     }, bf = bf,
#        files = files,
#        currentTime = currentTime)
#
# }
