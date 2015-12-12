library(betfaiR)
context("Helper functions")

test_that("test that bf_helpers$prepare returns a list", {

    # make sure errors are sent if marketId and selectionId aren't present
    expect_error(bf_helpers$prepare())
    expect_error(bf_helpers$prepare(marketId = "1.1111111"))

    # make sure elements of output are as expected
    prep <- bf_helpers$prepare(marketId = "1.1111111", selectionId = "2222222")
    expect_is(prep, "list")
    expect_is(prep$instructions, "data.frame")

})

test_that("test that order helpers return lists", {

    expect_is(bf_helpers$limitOrder(), "list")
    expect_is(bf_helpers$limitOnCloseOrder(), "list")

})

test_that("test that cancel helper returns list with multiple elements", {

    expect_is(bf_helpers$cancel(), "list")
    # make sure errors are sent if marketId aren't present
    expect_error(bf_helpers$cancel(bf_helpers$cancel_inst(betId = 10, )))
    # check list length
    can <- bf_helpers$cancel(bf_helpers$cancel_inst(betId = 1,
                                                    size = 1),
                             bf_helpers$cancel_inst(betId = 2,
                                                    size = 2),
                             marketId = "1111111")
    expect_equal(length(can), 2)
    expect_match(can$marketId, "1111111")
})

test_that("test that the five helper functions with order instructions return lists", {

    expect_is(bf_helpers$limitOrder(), "list")
    expect_is(bf_helpers$limitOnCloseOrder(), "list")

    expect_is(bf_helpers$cancel_inst(), "list")
    expect_is(bf_helpers$replace_inst(), "list")
    expect_is(bf_helpers$update_inst(), "list")

})

test_that("test that current helper function correctly formats lists", {

    expect_equal(bf_helpers$current()$betId, NULL)
    expect_match(bf_helpers$current(from = "2015-01-01")$dateRange$from, "2015-01-01T00:00:00Z")

    expect_is(bf_helpers$current(marketId = "111111"), "list")

})
