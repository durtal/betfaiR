# #' collect data
# #'
# #' @description helper function to be used within an R script that is part of a
# #' scheduled task.
# #'
# #' @details This function will take a \link{betfair} environment, a
# #' collection of marketIds and priceProjection parameters and retrieve data at
# #' intervals set up by the task, and keep appending new data returned by the
# #' \link{marketBook} method to any previous data returned.  The function will also
# #' add a new variable called \code{collectedAt} to each list, which means cross
# #' market comparisons are possible.  It is a good idea to also store/save data
# #' returned by the \link{marketCatalogue} method which will contain data about the
# #' runners in the markets you are collecting data from.
# #'
# #' @param bf betfair environment, returned from the \link{betfair} function
# #' @param marketIds ids of markets to retrieve data for
# #' @param marketIds_file filename for markets collecting data from
# #' @param priceProjection what data to return via the \link{marketBook} function
# #'
# #' @return the function saves data returned from the Betfair API into RDS files
# #' named after the market, for example market_1.121212121.RDS.
# #'
# #' @export
# collect_data <- function(bf,
#                          marketIds,
#                          marketIds_file = "marketIds",
#                          priceProjection = c("EX_ALL_OFFERS", "EX_TRADED")) {
#
#     # retrieve files from current working directory
#     files <- list.files()
#     today <- Sys.Date()
#     # create marketIds file name using marketIds_file param
#     marketIds_file <- paste0(today, "_", marketIds_file, ".RDS")
#     if(!(marketIds_file %in% files)) {
#         out <- bf$marketCatalogue(filter = marketFilter(marketIds = marketIds),
#                                   maxResults = length(marketIds),
#                                   marketProjection = c("EVENT", "RUNNER_DESCRIPTION"))
#         saveRDS(out, marketIds_file)
#     }
#     # ascertain which markets are still live
#     available_markets <- bf$marketCatalogue(filter = marketFilter(marketIds = marketIds),
#                                             maxResults = length(marketIds))
#     available_markets <- sapply(available_markets, function(i) i$market$marketId)
#     test <- marketIds %in% available_markets
#     marketIds <- marketIds[test]
#
#     # save current time, to add to retrieved data
#     currentTime <- Sys.time()
#     # loop through each market and retrieve data, adding currentTime to enable comparison across markets
#     plyr::l_ply(marketIds, .fun = function(i, bf, files, currentTime) {
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
#        currentTime = currentTime,
#        priceProjection = priceProjection)
#
#     return(invisible())
# }
