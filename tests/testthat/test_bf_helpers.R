library(betfaiR)
context("Helper functions")

test_that("test that bf_helpers$prepare returns a list", {

    # make sure errors are sent if marketId and selectionId aren't present
    expect_error(betfaiR:::prepare())
    expect_error(betfaiR:::prepare(marketId = "1.1111111"))

    # make sure elements of output are as expected
    prep <- betfaiR:::prepare(marketId = "1.1111111", selectionId = "2222222")
    expect_is(prep, "list")
    expect_is(prep$instructions, "data.frame")

})

test_that("test that order helpers return lists", {

    expect_is(limitOrder(), "list")
    expect_is(limitOnCloseOrder(), "list")

})

test_that("test that cancel helper returns list with multiple elements", {

    expect_is(betfaiR:::cancel(), "list")
    # make sure errors are sent if marketId aren't present
    expect_error(betfaiR:::cancel(cancel_inst(betId = 10, )))
    # check list length
    can <- betfaiR:::cancel(cancel_inst(betId = 1,
                                        size = 1),
                            cancel_inst(betId = 2,
                                        size = 2),
                            marketId = "1111111")
    expect_equal(length(can), 2)
    expect_match(can$marketId, "1111111")
})

test_that("test that the five helper functions with order instructions return lists", {

    expect_is(limitOrder(), "list")
    expect_is(limitOnCloseOrder(), "list")

    expect_is(cancel_inst(), "list")
    expect_is(replace_inst(), "list")
    expect_is(update_inst(), "list")

})

test_that("test that current helper function correctly formats lists", {

    expect_equal(betfaiR:::current()$betId, NULL)
    expect_match(betfaiR:::current(from = "2015-01-01")$dateRange$from, "2015-01-01T00:00:00Z")

    expect_is(betfaiR:::current(marketId = "111111"), "list")

})
