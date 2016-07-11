# naptime: A Robust Flexible Sys.sleep Replacement
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)
[![Travis-CI Build Status](https://travis-ci.org/zapier/naptime.svg?branch=master)](https://travis-ci.org/drknexus/naptime)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/naptime)](http://cran.r-project.org/package=naptime)
[![codecov.io](https://codecov.io/github/jimhester/covr/coverage.svg?branch=master)](https://codecov.io/github/drknexus/naptime?branch=master)

The premise of naptime is two fold.  

1. Delays in R code should never result in an error.
2. Functions should accept multiple inputs types, but result in a single output type.  

In response to these considerations `naptime::naptime()` either sleeps for the specified duration, or passes forward with a warning.  It has the same argument name as `base::Sys.sleep()` and a nearly identical behavior in response to numeric inputs.  As such, it can be nearly used as a drop-in replacement for `base::Sys.sleep()`.  

The one notable exception to identical behavior is the input value of `Inf`.  `base::Sys.sleep()` will sleep indefiniately in reponse to `Inf`.  In contrast, `naptime::naptime()` will sleep the default duration.

# Options
All options are set via base::options().

* `naptime.default_delay`.  If left unchanged, the default delay is `.1` seconds.
* `naptime.warnings`.  **This feature not yet available**.  If left unchanged, the default is `TRUE, to show warnings.

# Polymorphic inputs
naptime() accepts a wide variety of inputs.  If you find a reasonable input-type for which `naptime::naptime()` doesn't have a reasonable response, please file (an issue)[https://github.com/drknexus/naptime/issues].

* `numeric` Time in seconds


```r
naptime(1)
```

* `Period` Any positive time difference regardless of units
* `character` A time in the format of yyyy-mm-dd hh:mm:ss UTC.

In addition, naptime will handle some specific errors:
* All negative intervals will be converted to a delay of 0
* All non-finite intervals will be converted to a default delay
* All inputs that produce an error will be converted to a default delay
