betfaiR
=======

**coming soon** (hopefully)

This package isn't complete and only has a little functionality at the moment, primarily the easier things, and little to nothing that would enable a user to place a bet or analyse market data.  I will definitely add this functionality in time, but when I am unsure.

#### Installation

```R
# install devtools
devtools::install_github("durtal/betfaiR")
```

#### Usage

The primary function in **betfaiR** is `betfair`, which takes three arguments, your username, your password, and an application key (see [here](https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys) on how to get a key).

```R
bf <- betfair(usr = "USERNAME", pwd = "PASSWORD", key = "APP_KEY")
```

The `betfair` function returns an environment with various methods, you can inspect you session token (required by Betfair for all methods) via the following:

```R
bf$session()
## Session Token: "some_session_token"
```

There is a login in method returned into the `bf` environment, allowing users to login in again if something went wrong initially, this function stores the new details in an hidden object within the environment, and updates the session token.

```R
bf$login(usr = "USERNAME2", pwd = "PASSWORD", key = "APP_KEY")
```

The view the available methods, simply print the environment `bf`

```R
bf
## < betfaiR API>
## Methods available:
##    $competitions(filter = marketFilter())
##    $countries(filter = marketFilter())
##    $events(filter = marketFilter())
##    $eventTypes(filter = marketFilter())
##    $login(usr, pwd, key)
##    $marketTypes(filter = marketFilter())
##    $session()
##    $venues(filter = marketFilter())
```

So, if you are familiar with Betfair's API, you will realise the available methods at the moment are quite restricted, nothing about markets, or placing a bet.

Some of the available methods have a `filter` parameter, which can be used to filter data, this is then added into the body of the request sent to Betfair.  The `marketFilter` function helps you build a filter object, providing all the available parameters that can be filtered by (this hasn't been tested exhaustively but should work).  For example to find horse racing events:

```R
racing <- bf$events(filter = marketFilter(eventTypeIds = 7))
```

The `racing` object is now a dataframe of horse racing events, providing data that includes the event Id, event name, countryCode, timezone, venue, date, and the number of markets.
