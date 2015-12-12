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

test_that("test that betfaiR helper functions", {

    req <- betfaiR:::standard_request(method = "listCompetitions")
    expect_is(req, "list")
    expect_match(req$method, "SportsAPING/v1.0/listCompetitions", ignore.case = TRUE)

    req <- betfaiR:::standard_request(method = "listMarketBook")
    expect_match(req$method, "SportsAPING/v1.0/listMarketBook", ignore.case = TRUE)

})
