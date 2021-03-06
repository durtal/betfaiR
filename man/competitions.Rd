% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{competitions}
\alias{competitions}
\title{competitions method}
\arguments{
\item{filter}{list to select desired markets, see \link{marketFilter},
or visit \href{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketFilter}{developer.betfair.com},
for the different options.}
}
\value{
competitions (ie. World Cup 2014) associated with the markets selected
by the \code{filter} parameter, with the following variables:
\itemize{
     \item{\code{competition_id} competition id}
     \item{\code{competition_name} competition name}
     \item{\code{marketCount} number of markets associated with this competition}
     \item{\code{competitionRegion} region in which this competition is happening}
}
}
\description{
competitions (ie. World Cup 2014) associated with the markets
selected by the \code{filter} parameter.
}
