# load libraries
library(dplyr)
library(ggplot2)

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
arslei <- arslei %>%
    left_join(markets$arslei[[1]]$runners)

cittot <- plyr::ldply(cittot, .fun = function(i) {
    x <- plyr::ldply(i$runners, .fun = function(j) {
        j$basic
    })
    x$collectedAt <- i$collectedAt
    return(x)
})
cittot <- cittot %>%
    left_join(markets$cittot[[1]]$runners)

winner <- plyr::ldply(winner, .fun = function(i) {
    x <- plyr::ldply(i$runners, .fun = function(j) {
        j$basic
    })
    x$collectedAt <- i$collectedAt
    return(x)
})
winner <- winner %>%
    left_join(markets$winner[[1]]$runners)
