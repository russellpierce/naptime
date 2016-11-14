context("Naptime core functionality")

test_that("test of numeric dispatch", {
  test1 <- system.time(naptime(5))[["elapsed"]]
  expect_gte(test1, 2)
  expect_lte(test1, 7)
  test2 <- system.time(naptime(5L))[["elapsed"]]
  expect_gte(test2, 2)
  expect_lte(test2, 7)
  inf_test <- system.time(expect_error(naptime(Inf)))[["elapsed"]]
  inf_test <- system.time(expect_warning(naptime(Inf, permissive = TRUE)))[["elapsed"]]
  neg_test <- system.time(expect_warning(naptime(-10)))[["elapsed"]]
  expect_gte(inf_test, 0)
  expect_lte(inf_test, 2)
  expect_gte(neg_test, 0)
  expect_lte(neg_test, 2)
  expect_error(naptime(c(1,2)))
})

test_that("numeric dispatch warnings can be disabled", {
  # Disable warnings
  options(naptime.warnings = FALSE)
  expect_silent(naptime(Inf, permissive = TRUE))
  expect_silent(naptime(-10))
  options(naptime.warnings = TRUE)
})

test_that("test of difftime dispatch", {
  difftime_test <- system.time(naptime(difftime("2016-01-01 00:00:05", "2016-01-01 00:00:00")))[["elapsed"]]
  expect_gte(difftime_test, 3)
  expect_lte(difftime_test, 7)
})

test_that("test of POSIXct dispatch", {
  ct_test <- system.time(naptime(as.POSIXct(lubridate::now(tzone = "UTC")+lubridate::seconds(5))))[["elapsed"]]
  expect_gte(ct_test, 3)
  expect_lte(ct_test, 7)
})

test_that("test of difftime error conditions", {
  difftime_test <- system.time(expect_warning(naptime(difftime("2016-01-01 00:00:00", "2016-01-01 00:00:05"))))[["elapsed"]]
  expect_gte(difftime_test, 0)
  expect_lte(difftime_test, 3)
})

test_that("test of NULL dispatch", {
  null_test <- system.time(naptime(NULL))[["elapsed"]]
  expect_gte(null_test, 0)
  expect_lte(null_test, 3)
})

test_that("test of NA dispatch", {
  expect_error(naptime(NA, permissive = FALSE))
  na_test <- system.time(expect_warning(naptime(NA, permissive = TRUE)))[["elapsed"]]
  expect_gte(na_test, 0)
  expect_lte(na_test, 3)
  expect_error(naptime(NA_character_))
  expect_warning(naptime(NA_character_, permissive = TRUE))
})

test_that("test of logical dispatch", {
  true_test <- system.time(naptime(TRUE))[["elapsed"]]
  expect_gte(true_test, 0)
  expect_lte(true_test, 3)
  false_test <- system.time(naptime(FALSE))[["elapsed"]]
  expect_gte(false_test, 0)
  expect_lte(false_test, 3)
  expect_error(naptime(logical(0)))
  expect_warning(naptime(logical(0), permissive = TRUE))
})

test_that("test of no_arg dispatch", {
  no_arg_test <- system.time(naptime())[["elapsed"]]
  expect_gte(no_arg_test, 0)
  expect_lte(no_arg_test, 3)
})

test_that("non-time character produces warning, not an error", {
  testval <- "boo"
  expect_error(naptime(testval))
  expect_warning(naptime(testval, permissive = TRUE))

  testval <- "really long scary text string"
  expect_error(naptime(testval))
  expect_warning(naptime(testval, permissive = TRUE))
  non_time_test <- system.time(naptime(testval, permissive = TRUE))[["elapsed"]]
  expect_gte(non_time_test, 0)
  expect_lte(non_time_test, 3)
})

test_that("non-valid produces warning, not an error", {
  testval <- pi
  class(testval) <- "bad-class"
  expect_error(naptime(testval))
  expect_warning(naptime(testval, permissive = TRUE))
  non_class_test <- system.time(naptime(testval, permissive = TRUE))[["elapsed"]]
  expect_gte(non_class_test, 0)
  expect_lte(non_class_test, 3)
})

test_that("period dispatch", {
  period_test <- system.time(naptime(lubridate::seconds(5)))[["elapsed"]]
  expect_gte(period_test, 3)
  expect_lte(period_test, 7)
})

test_that("negative period handling", {
  neg_period_test <- system.time(naptime(lubridate::seconds(-1)))[["elapsed"]]
  expect_warning(neg_period_test <- system.time(naptime(lubridate::seconds(-1)))[["elapsed"]])
  expect_gte(neg_period_test, 0)
  expect_lte(neg_period_test, getOption("naptime.default_delay", 0.1) + 2)
})

test_that("character date handling: yyyy-mm-dd hh:mm:ss in past", {
  expect_warning(
  neg_period_test <- system.time(
      naptime(as.character(lubridate::now() + lubridate::seconds(-1)))
    )[["elapsed"]]
  )
  expect_gte(neg_period_test, 0)
  expect_lt(neg_period_test, getOption("naptime.default_delay", 0.1) + 3)
})

test_that("character date handling: yyyy-mm-dd hh:mm:ss in future", {
  pos_period_test <- system.time(
      naptime(as.character(lubridate::now() + lubridate::seconds(5)))
    )[["elapsed"]]
  expect_gte(pos_period_test, 3)
  expect_lte(pos_period_test, 7)
})

test_that("generic stop", {
  expect_error(naptime(glm(rnorm(5) ~ rnorm(5))))
})


test_that("generic warning if permissive", {
  options(naptime.permissive = FALSE)
  expect_error(naptime(glm(rnorm(5) ~ runif(5))))
  expect_warning(naptime(glm(rnorm(5) ~ runif(5)), permissive = TRUE))

  options(naptime.permissive = TRUE)
  expect_warning(naptime(glm(rnorm(5) ~ runif(5))))
  expect_error(naptime(glm(rnorm(5) ~ runif(5)), permissive = FALSE))
})

test_that("zero length custom class produces a warning", {
  boo <- integer(0)
  class(boo) <- "moo"
  expect_warning(naptime(boo))
})
