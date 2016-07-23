## Test environments
* local OS X install, R 3.3.0
* travis-ci
 * R version 3.3.1 (2016-06-21)
 * and R version 3.2.5 (2016-04-14)
 * and R Under development (unstable) (2016-07-22 r70959)
 * Platform: x86_64-pc-linux-gnu (64-bit)
 * Running under: Ubuntu precise (12.04.5 LTS)
* win-builder (devel and release)

## R CMD check results
0 errors | 0 warnings | 0 notes
R CMD check succeeded

## Other Issues
The timing tests are deliberately loose to accommodate Windows machines.  The underlying sleep code is entirely base::Sys.sleep.  Any remaining issues would be related to the option for default sleep duration which are not adequately tested at this time, but are generally expected to be a low value feature.

## Downstream dependencies
New submission.  There are no downstream dependencies.
