library(betfaiR)
context("Request Objects")

test_that("test that bf_basic_req returns a list with different class", {

    req <- bf_basic_req(filter = list(), method = "countries")
    expect_is(req, "countries")

    req <- bf_basic_req(filter = marketFilter(), method = "placeOrders")
    expect_is(req, "placeOrders")

})

test_that("test that bf_request returns a json object", {

    req <- bf_basic_req(filter = marketFilter(eventTypeIds = 7), method = "marketCatalogue")
    req <- bf_request(req)
    expect_is(req, "json")

})

test_that("test that json returned by bf_request contains correct method", {

    req <- bf_basic_req(filter = marketFilter(), method = "marketCatalogue")
    req <- bf_request(req)
    reqchar <- as.character(req)
    expect_match(reqchar, "marketCatalogue", ignore.case = TRUE)

})

test_that("test that betfaiR helper functions help", {

    req <- betfaiR:::standard_request(method = "listCompetitions")
    expect_is(req, "list")
    expect_match(req$method, "SportsAPING/v1.0/listCompetitions", ignore.case = TRUE)

    req <- betfaiR:::standard_request(method = "listMarketBook")
    expect_match(req$method, "SportsAPING/v1.0/listMarketBook", ignore.case = TRUE)

})

test_that("test that betfaiR:::build_request correctly formats request", {

    req <- betfaiR:::build_request(req = marketFilter())
    expect_equal(length(req), 0)

    # test that non-empty request object is a list, and contains names of entered params
    req1 <- betfaiR:::build_request(req = marketFilter(eventTypeIds = 7,
                                                       marketCountries = "GB"))
    expect_equal(length(req1), 2)
    expect_match(names(req1), "eventTypeIds|marketCountries", ignore.case = TRUE)
    expect_is(req1$marketCountries, "list")

    # test textQuery field is character, so jsonlite::toJSON correctly formats
    req2 <- betfaiR:::build_request(req = marketFilter(textQuery = "HELLO WORLD",
                                                       eventTypeIds = 1))
    expect_is(req2$eventTypeIds, "list")
    expect_is(req2$textQuery, "character")

    # test that from|to params are a converted into a list called marketStartTime
    req3 <- betfaiR:::build_request(req = marketFilter(from = "2015-01-01"))
    expect_is(req3$marketStartTime, "list")
    expect_equal(req3$marketStartTime$from, "2015-01-01T00:00:00Z")
    
})
