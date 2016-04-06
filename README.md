betfaiR v0.6.1
=======

`betfaiR` is an R package which provides access to Betfair's API, and allows users to retrieve data (in various amounts of detail) from available markets, to place a bet in those markets, cancel bets, replace bets, etc.  The package possibly needs a little work (it's hard to test a package like this, unless someone has suggestions), so please proceed with caution when placing any bets, and provide feedback with any issues you encounter, or features you want added.

Installation instructions are below, the usage section walks through the primary function in the package and the various API methods available (which I believe is all of them).

#### Installation

```R
# install devtools
devtools::install_github("durtal/betfaiR")
```

#### Help

There are help pages available [here](http://durtal.github.io/betfaiR/), issues can be filed [here](https://github.com/durtal/betfaiR/issues)..

There are a few vignettes and I'll try to add more:

vignette | title | details
---------|-------|---------------------------------------------------------------
[vignette one](http://durtal.github.io/betfaiR/vignette_one.html) | place a bet | walks through login, find a market, place a bet, replace the bet and cancel the bet]
[vignette two](http://durtal.github.io/betfaiR/vignette_two.html) | cron jobs w/ betfaiR | shows how to use `betfaiR` and scheduled tasks to periodically collect betfair data
[vignette three](http://durtal.github.io/betfaiR/vignette_three.html) | betfair super sunday - 14/02/16 | some simple analysis of the data returned by the code walked through in vignette two

Help with the package would be welcome, or suggestions on how best to parse the responses from Betfair, what format would _you_ like data to be in when returned from the Exchange, dataframes, lists of dataframes, environments (maybe?) or the raw unparsed response.

#### Usage

The primary function in **betfaiR** is `betfair`, which takes three arguments, your username, your password, and an application key (see [here](https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys) on how to get a key).

```R
bf <- betfair(usr = "USERNAME",
              pwd = "PASSWORD",
              key = "API_KEY")
```

The `betfair` function returns an environment with various methods, you can inspect your session token (required by Betfair for all methods) via the following:

```R
bf$session()
## Session Token: "some_session_token"
```

There is a login in method available in `bf`, allowing users to login in again if something went wrong initially, this function stores the new details in an hidden object within the environment, and updates the session token.

```R
bf$login(usr = "USERNAME2", pwd = "PASSWORD", key = "API_KEY")
```

To view the available methods, simply print the environment `bf`

```R
<betfaiR API>
Methods available:
    $account(pwd)
    $cancelOrders(..., marketId = NA)
    $clearedOrders(betStatus = "SETTLED", eventTypeIds = NULL, eventIds = NULL, marketIds = NULL, runnerIds = NULL,
   betIds = NULL, side = "BACK", from = NULL, to = NULL)
    $competitions(filter = marketFilter())
    $countries(filter = marketFilter())
    $currentOrders(betId = NULL, marketId = NULL, orderProjection = "ALL", from = NULL, to = NULL, orderBy = "BY_BET",
   sort = "EARLIEST_TO_LATEST", fromRecord = NULL, count = NULL)
    $events(filter = marketFilter())
    $eventTypes(filter = marketFilter())
    $login(usr, pwd, key)
    $marketBook(marketIds = list(), priceProjection = "EX_BEST_OFFERS", orderProjection = "EXECUTABLE", matchProjection = "NO_ROLLUP")
    $marketCatalogue(filter = marketFilter(), marketProjection = "EVENT", sort = NULL, maxResults = 1, keepRules = FALSE)
    $marketPnL(marketIds, settled = NULL, bsp = NULL, NET = NULL)
    $marketTypes(filter = marketFilter())
    $placeOrders(marketId, selectionId, orderType = "LIMIT", handicap = NULL, side = "BACK", order = limitOrder())
    $replaceOrders(..., marketId)
    $session()
    $updateOrders(..., marketId)
    $venues(filter = marketFilter())
```

So, if you are familiar with Betfair's API, that will help, the Betfair API documentation can be found [here](https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/API+Overview).  Each of the available methods has its own help page, so to view the help page of the events method, after loading the library type `?events` into the console.

Each of the methods typically returns a data.frame or a list (usually of data.frames), these responses can usually be passed to `print` or `summary` for a neater display of the data returned.  `marketBook` returns data which is often heavily nested, so the response might not be in the easiest format to print neatly, but `marketBook` does include the raw response if required, as an element in a list.

Some of the available methods have a `filter` parameter, which can be used to filter data, this is then added into the body of the request sent to Betfair.  The `marketFilter` function helps you build a filter object, providing all the available parameters that can be filtered by (this hasn't been tested exhaustively but should work).  For example to find horse racing events:

```R
racing <- bf$events(filter = marketFilter(eventTypeIds = 7))
```

The `racing` object is now a dataframe of horse racing events, providing data that includes the event Id, event name, countryCode, timezone, venue, date, and the number of markets.

The `account` method returns an environment with 4 methods for accessing data about your account, it requires your password, which will be checked against the password you entered when using `betfair`.  You can also use the `bf_account` function which requires your username, password and api key (and will return the same environment as the `account` method via `betfair`).  The `account` method can return your account statement, which can be passed to `plot`, showing profit/loss over a set time period, see the help pages about restricting a time period.

### PASSWORD and KEY

The appendix **_API key best practices_** in the [api packages vignette](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html) from the [httr](https://github.com/hadley/httr) package provides some pertinent advice for the storing of you PASSWORD and KEY.

The advice is to store your PASSWORD and KEY, or any other variables that should be kept safe, in an environment variable, this is to prevent accidentally sharing your credentials, either by sharing an .Rhistory file, or sharing a workspace.

### example plots with data collected via betfair

A plot of data from the Premier League outright market on 14/2/2016.
![](https://raw.githubusercontent.com/durtal/betfaiR/gh-pages/vignette_three_files/figure-html/prem-outright-early-ko-1.png)

A plot of Match Odds data from Premier League match between the then top two in the table Arsenal and Leicester City, Leicester City went 1-0 up, then had a man sent off, Arsenal equalised and won the game late
![](https://raw.githubusercontent.com/durtal/betfaiR/gh-pages/vignette_three_files/figure-html/ars-lei-price-1.png)

### things to work on

* additional S3 methods to convert the lists returned by the various methods to dataframes
* parameter in `marketBook` to collect data about runners found in `marketCatalogue`
* plot method for other lists/responses
* continue work on `collect_data` function to help collect data over a period of time, to be used in conjunction with a task scheduler
