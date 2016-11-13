# naptime 1.1.0

## New Features

* naptime can take incompletely specified date times for delays in the future by leveraging lubridate::ymd_hms()'s truncated parameter.  We now allow for three truncated formats.

## Major Bug Fixes
* naptime actually pauses for the default duration under error conditions rather than returning it as a variable
* naptime no longer sometimes returns non-NULL values

# naptime 1.0.0

* Initial CRAN Submission
* 100% Code Coverage
* Polymorphism for:
 * numeric
 * NULL
 * POSIXct
 * Period
 * character
 * difftime
 * logical
 
