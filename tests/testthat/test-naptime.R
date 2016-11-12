context("Naptime core functionality")

test_that("test of numeric dispatch", {
  skip_on_os("windows")
  test1 <- system.time(naptime(5))[["elapsed"]]
  expect_gte(test1, 2)
  expect_lte(test1, 7)
  test2 <- system.time(naptime(5L))[["elapsed"]]
  expect_gte(test2, 2)
  expect_lte(test2, 7)
  expect_warning(naptime(Inf))
  expect_warning(naptime(-10))
  inf_test <- system.time(naptime(Inf))[["elapsed"]]
  neg_test <- system.time(naptime(-10))[["elapsed"]]
  expect_gte(inf_test, 0)
  expect_lte(inf_test, 2)
  expect_gte(neg_test, 0)
  expect_lte(neg_test, 2)
})

test_that("numeric dispatch warnings can be disabled", {
  # Disable warnings
  options(naptime.warnings = FALSE)
  expect_silent(naptime(Inf))
  expect_silent(naptime(-10))
  options(naptime.warnings = TRUE)
})

test_that("test of difftime dispatch", {
  difftime_test <- system.time(naptime(difftime("2016-01-01 00:00:05", "2016-01-01 00:00:00")))[["elapsed"]]
  expect_gte(difftime_test, 3)
  expect_lte(difftime_test, 7)
})

test_that("test of POSIXct dispatch", {
  ct_test <- system.time(naptime(as.POSIXct(lubridate::now()+lubridate::seconds(5))))[["elapsed"]]
  expect_gte(ct_test, 3)
  expect_lte(ct_test, 7)
})

test_that("test of difftime error conditions", {
  difftime_test <- system.time(naptime(difftime("2016-01-01 00:00:00", "2016-01-01 00:00:05")))[["elapsed"]]
  expect_gte(difftime_test, 0)
  expect_lte(difftime_test, 3)
})

test_that("test of NULL dispatch", {
  null_test <- system.time(naptime(NULL))[["elapsed"]]
  expect_gte(null_test, 0)
  expect_lte(null_test, 3)
})

test_that("test of NA dispatch", {
  na_test <- system.time(naptime(NA))[["elapsed"]]
  expect_gte(na_test, 0)
  expect_lte(na_test, 3)
})

test_that("test of logical dispatch", {
  true_test <- system.time(naptime(TRUE))[["elapsed"]]
  expect_gte(true_test, 0)
  expect_lte(true_test, 3)
  false_test <- system.time(naptime(FALSE))[["elapsed"]]
  expect_gte(false_test, 0)
  expect_lte(false_test, 3)
})

test_that("test of no_arg dispatch", {
  no_arg_test <- system.time(naptime())[["elapsed"]]
  expect_gte(no_arg_test, 0)
  expect_lte(no_arg_test, 3)
})

test_that("non-time character produces warning, not an error", {
  skip_on_os("windows")
  testval <- "boo"
  expect_warning(naptime(testval))
  non_time_test <- system.time(naptime(testval))[["elapsed"]]
  expect_gte(non_time_test, 0)
  expect_lte(non_time_test, 3)
})

test_that("non-valid produces warning, not an error", {
  skip_on_os("windows")
  testval <- pi
  class(testval) <- "bad-class"
  expect_warning(naptime(testval))
  non_class_test <- system.time(naptime(testval))[["elapsed"]]
  expect_gte(non_class_test, 0)
  expect_lte(non_class_test, 3)
})

test_that("period dispatch", {
  period_test <- system.time(naptime(lubridate::seconds(5)))[["elapsed"]]
  expect_gte(period_test, 3)
  expect_lte(period_test, 7)
})

test_that("negative period handling", {
  skip_on_os("windows")
  neg_period_test <- system.time(naptime(lubridate::seconds(-1)))[["elapsed"]]
  expect_warning(neg_period_test <- system.time(naptime(lubridate::seconds(-1)))[["elapsed"]])
  expect_gte(neg_period_test, 0)
  expect_lte(neg_period_test, getOption("naptime.default_delay", 0.1) + 2)
})

test_that("character date handling: yyyy-mm-dd hh:mm:ss in past", {
  expect_warning(
  neg_period_test <- system.time(
      naptime(as.character(lubridate::now(tzone = "UTC") + lubridate::seconds(-1)))
    )[["elapsed"]]
  )
  expect_gte(neg_period_test, 0)
  expect_lt(neg_period_test, getOption("naptime.default_delay", 0.1) + 3)
})

test_that("character date handling: yyyy-mm-dd hh:mm:ss in future", {
  pos_period_test <- system.time(
      naptime(as.character(lubridate::now(tzone = "UTC") + lubridate::seconds(5)))
    )[["elapsed"]]
  expect_gte(pos_period_test, 3)
  expect_lte(pos_period_test, 5)
})

test_that("generic warning", {
  expect_warning(naptime(glm(rnorm(5) ~ rnorm(5))))
})
