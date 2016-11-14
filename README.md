[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![Travis-CI Build Status](https://travis-ci.org/drknexus/naptime.svg?branch=master)](https://travis-ci.org/drknexus/naptime) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/naptime)](https://cran.r-project.org/package=naptime) [![codecov.io](https://codecov.io/github/drknexus/naptime/coverage.svg?branch=master)](https://codecov.io/github/drknexus/naptime?branch=master)

Why should I use it?
--------------------

naptime makes delaying code execution in R more flexible and robust. It makes delaying code execution more flexible by supporting more data types than `base::Sys.sleep()`. It makes delaying code more robust by allowing errors in the delay specification to throw warnings instead of errors. Most notably, because naptime supports more input data types, you can use package:lubridate functions in conjunction with naptime to yield human readable time delays and intervals.

Consider the case of waiting one hour:

    Sys.sleep(3600)

    # versus

    naptime(lubridate::hours(1))

Consider the case of wanting to start processing every hour for a job of an indeterminate duration:

    repeat{
      start_time <- lubridate::now()
      # Do processing
      sleep_duration <- 3600 - as.numeric(lubridate::now() - start_time)
      if (sleep_duration > 0) {
        Sys.sleep(sleep_duration)
      }
    }

    # versus

    repeat{
      start_time <- lubridate::now()
      # Do processing
      naptime(start_time + hours(1))
    }

How do I use it?
----------------

Because `naptime()` has nearly identicial arguments and behavior as `base::Sys.sleep()` in response to numeric inputs, it can be nearly used as a drop-in replacement for `base::Sys.sleep()`.

There are two notable differences in the behavior of Sys.sleep() and naptime():

-   For the input value of `Inf` `base::Sys.sleep()` will sleep indefiniately. In contrast, `naptime::naptime()` will produce an error (or if `naptime.permissive = TRUE` is set pause the default duration).
-   For a negative input value `base::Sys.sleep()` will produce an error. In contrast, `naptime::naptime()` will assume that the period of delay has already elapsed and move forward without further delay.

### Options

All options are set via `base::options()`.

-   `naptime.default_delay`. If left unchanged, the default delay is `.1` seconds.
-   `naptime.warnings`. If left unchanged, the default is `TRUE`, to show warnings.
-   `naptime.permissive`. If left unchanged, the default is `FALSE`, to trigger errors on inputs that couldn't be converted into something sensible. If set TRUE, inputs that couldn't be converted into something sensible will result in a default delay.

### Polymorphic inputs

naptime() accepts a wide variety of inputs.

Polymorphism for:

-   numeric: time in seconds to nap

``` r
naptime(1)
#> NULL
```

-   POSIXct: time at which the nap should stop (timezone is respected)

``` r
naptime(lubridate::now(tzone = "UTC")+lubridate::seconds(1))
#> NULL
```

-   Period: time from now at which the nap should stop

``` r
naptime(lubridate::seconds(1))
#> NULL
```

-   character: A single character string formatted YYYY-MM-DD HH:MM:SS at which the nap should stop. The time zone is assumed to be device local. The hour, minute, and second do not need to be specified.

``` r
naptime(as.character(lubridate::now() + lubridate::seconds(1)))
#> NULL
```

-   difftime: difference in time to nap

``` r
naptime(difftime(lubridate::now() + lubridate::seconds(1), lubridate::now()))
#> NULL
```

-   logical: nap for default duration if TRUE, skip nap if FALSE

``` r
naptime(TRUE)
#> NULL
```

-   NULL; meaning no delay

``` r
naptime(NULL)
#> NULL
```

-   generic: By default this produces an error, however, you can set `naptime.permissive` as an option (or argument) that will cause this to nap for default duration instead.

``` r
naptime(glm(rnorm(5) ~ runif(5)), permissive = TRUE)
#> Warning: The time paramater was not scalar (length equal to 1)
#> Warning: unhandled input for naptime(): Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'naptime' for signature '"list"'
#> NULL
options(naptime.permissive = TRUE)
naptime(glm(rnorm(5) ~ runif(5)))
#> Warning: The time paramater was not scalar (length equal to 1)

#> Warning: unhandled input for naptime(): Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'naptime' for signature '"list"'
#> NULL
```

If you find a reasonable input-type for which `naptime::naptime()` doesn't have a reasonable response, please file [an issue](https://github.com/drknexus/naptime/issues) or PR in which you resolve the shortcoming.

How do I get it?
----------------

The current version is on CRAN, but you can fetch an early release of the upcoming build directly from github:

    library(devtools)
    install_github("drknexus/naptime")
    library(naptime)

Author's Note
-------------

The initial draft of this code was written by Timothy Gann under a spec drafted by Russell Pierce. Many improvements and bug fixes to the original code, all packaging, and all tests were written by Russell Pierce. Russell Pierce is the current maintainer and responsible party for this package.
