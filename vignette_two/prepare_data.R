# load libraries
library(dplyr)

# read in collected data, and marketIds (for selectionNames)
arslei <- readRDS("arslei.RDS")
cittot <- readRDS("cittot.RDS")
winner <- readRDS("winner.RDS")
markets <- readRDS("marketIds.RDS")

arslei <- plyr::ldply(arslei, .fun = function(i) {
    x <- plyr::ldply(i$runners, .fun = function(j) {
        j$basic
    })
    x$collectedAt <- i$collectedAt
    return(x)
})

cittot <- plyr::ldply(cittot, .fun = function(i) {
    x <- plyr::ldply(i$runners, .fun = function(j) {
        j$basic
    })
    x$collectedAt <- i$collectedAt
    return(x)
})

winner <- plyr::ldply(winner, .fun = function(i) {
    x <- plyr::ldply(i$runners, .fun = function(j) {
        j$basic
    })
    x$collectedAt <- i$collectedAt
    return(x)
})
