# naptime 1.2.0

Formatting changes for CRAN deploy. Refer to naptime 1.1.0 NEWS for changes since the last CRAN version.

# naptime 1.1.0

## Behavior changes

* Per [request](https://github.com/drknexus/naptime/issues/6) naptime is now quite a bit more discerning by default.  If the argument provided isn't interpretable, it will thrown as an error.  The old permissive behavior that produces warnings and default delays can be more or less restored by setting the option `naptime.permissive` to TRUE or setting the permissive parameter as TRUE on any given naptime call (parameter overrides the option)
* Logicals no longer produce a warning.  Logical FALSE is interpreted as meaning 'no delay' and TRUE is interpreted as meaning default delay.
* Calling naptime with a NULL no longer produces a delay or warning as this is interpreted as meaning 'no delay'.

## New Features

* naptime can take incompletely specified date times for delays in the future by leveraging lubridate::ymd_hms()'s truncated parameter.  We now allow for three truncated formats.

## Major Bug Fixes

* naptime actually pauses for the default duration under error conditions rather than returning it as a variable
* naptime no longer sometimes returns non-NULL values
* naptime should now delay appropriately for long duration difftimes

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
 
