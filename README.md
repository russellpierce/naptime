
<!-- README.md is generated from README.Rmd. Please edit that file -->
naptime: A Robust Flexible Sys.sleep() Replacement
==================================================

[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![Travis-CI Build Status](https://travis-ci.org/drknexus/naptime.svg?branch=master)](https://travis-ci.org/drknexus/naptime) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/naptime)](https://cran.r-project.org/package=naptime) [![codecov.io](https://codecov.io/github/drknexus/naptime/coverage.svg?branch=master)](https://codecov.io/github/drknexus/naptime?branch=master)

Why should I use it?
====================

The premise of naptime is two fold.

1.  Delays in R code should never result in an error.
2.  Functions should accept multiple inputs types, but result in a single output type.

In response to these considerations `naptime::naptime()` either sleeps for the specified duration, or passes forward with a warning. It has the same argument name as `base::Sys.sleep()` and a nearly identical behavior in response to numeric inputs. As such, it can be nearly used as a drop-in replacement for `base::Sys.sleep()`.

The one notable exception to identical behavior is the input value of `Inf`. `base::Sys.sleep()` will sleep indefiniately in reponse to `Inf`. In contrast, `naptime::naptime()` will sleep the default duration.

How do I use it?
================

Options
-------

All options are set via `base::options()`.

-   `naptime.default_delay`. If left unchanged, the default delay is `.1` seconds.
-   `naptime.warnings`. If left unchanged, the default is `TRUE`, to show warnings.

Polymorphic inputs
==================

naptime() accepts a wide variety of inputs.

Polymorphism for: \* numeric: time in seconds to nap

``` r
naptime(1)
```

-   NULL

``` r
naptime(NULL)
#> Warning in nap_warn("NULL passed to naptime(), sleeping for .Options
#> $naptime.default_delay seconds."): NULL passed to naptime(), sleeping
#> for .Options$naptime.default_delay seconds.
#> [1] 0.1
```

-   POSIXct: time at which the nap should stop (timezone is respected)

``` r
naptime(lubridate::now()+lubridate::seconds(1))
```

-   Period: time from now at which the nap should stop

``` r
naptime(lubridate::seconds(1))
```

-   character: ymd\_hms at which nap should stop, time zone is assumed to be UTC

``` r
 naptime(as.character(lubridate::now(tzone = "UTC") + lubridate::seconds(1)))
```

-   difftime: difference in time to nap

``` r
 naptime(difftime(lubridate::now() + seconds(1), lubridate::now()))
```

-   logical: nap for default duration

``` r
naptime(TRUE)
#> Warning in nap_warn("Logical passed to naptime(), sleeping for 0
#> seconds."): Logical passed to naptime(), sleeping for 0 seconds.
#> [1] 0.1
```

-   generic: nap for default duration

``` r
naptime(glm(rnorm(5) ~ rnorm(5)))
#> Warning in model.matrix.default(mt, mf, contrasts): the response appeared
#> on the right-hand side and was dropped
#> Warning in model.matrix.default(mt, mf, contrasts): problem with term 1 in
#> model.matrix: no columns are assigned
#> Warning in nap_warn("unhandled input for naptime: ", as.character(e), "; sleeping for default duration"): unhandled input for naptime: Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'naptime' for signature '"glm"'
#> ; sleeping for default duration
#> [1] 0.1
```

If you find a reasonable input-type for which `naptime::naptime()` doesn't have a reasonable response, please file [an issue](https://github.com/drknexus/naptime/issues).

In addition, naptime will handle some specific errors:

-   All negative intervals will be converted to a delay of 0
-   All non-finite intervals will be converted to a default delay
-   All inputs that produce an error will be converted to a default delay

How do I get it?
================

    library(devtools)
    install_github("drknexus/naptime")
    library(naptime)

Author's Note
=============

The initial draft of this code was written by Timothy Gann under a spec drafted by Russell Pierce. Many improvements and bug fixes to the original code, all packaging, and all tests were written by Russell Pierce. Russell Pierce is the current maintainer and responsible party for this package.
