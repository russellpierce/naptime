# naptime 1.3.0

## Breaking Change
* Date parsing is again performed by lubridate.  The limitation with this change is that character date input is again limited to only the yyyy-mm-dd hh:mm:ss format.

## Other Notes
* Removed naptime's dependency on anytime.  Anytime was failing checks [in some locales](https://github.com/eddelbuettel/anytime/issues/51) because of a bug in the underlying Boost library.  Those failed checks reflected an issue that would cause naptime to underestimate the required nap duration by 1 hour on entry of character dates.  

# naptime 1.2.3

* Kurt Hornik of CRAN reported problems with naptime 1.2.2 in some locales. This appears to be related to an issue in anytime that I am debugging in this non-CRAN development release.  
* I have also refactored the handling of Period class objects.  It appears an eval(parse()) antipattern had leaked into the code.  This is now resolved.

# naptime 1.2.2

Character arguments for naptime are now parsed by package:anytime rather than lubridate::ymd_hms.  This allows for greater flexibility in character nap specification.  The previously supported truncated YYYY-MM-DD HH:MM:SS formats should parse the same as they did previously.  So, this change is considered minor.

# naptime 1.2.0

Formatting changes for CRAN deploy. Refer to naptime 1.1.0 NEWS for changes since the last CRAN version.

## Behavior changes

* lubridate parse warnings squelched

# naptime 1.1.0

## Behavior changes

* Per [request](https://github.com/drknexus/naptime/issues/6) naptime is now quite a bit more discerning by default.  If the argument provided isn't interpretable, naptime will throw as an error.  The old permissive behavior that produces warnings and default delays can be more or less restored by setting the option `naptime.permissive` to TRUE or setting the permissive parameter as TRUE on any given naptime call (parameter overrides the option)
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
 
