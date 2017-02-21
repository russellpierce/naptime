## Naptime 1.3.0 Release

The previous version of package:naptime, 1.2.2 was [failing](https://cran.r-project.org/web/checks/check_results_naptime.html) in Europe/London due to a bug in an upstream package.  As urged by Prof. Ripley, the upstream package has been replaced.  I've verified that at least the MacOS Euripe/London locale should have its bug resolved as a consequence.  In addition, in response to feedback from Kurt Hornik some faulty code has been replaced.

## Test environments
* local OS X install
 * R 3.3.2
* travis-ci
 * Platform: x86_64-pc-linux-gnu (64-bit) / Ubuntu precise (12.04.5 LTS)
 * and R version 3.3.2 (2016-10-31)
 * and R version 3.2.5 (2016-04-14)
 * and R Under development (unstable) (2017-02-20 r72220)
* win-builder
 * R version 3.3.2 (2016-10-31)
 * R Under development (unstable) (2017-02-20 r72220)

## R CMD check results
R CMD check results
0 errors | 0 warnings | 0 notes

However, develop builds of R provide the following warning:
```
Files in the 'vignettes' directory but no files in 'inst/doc':
  ‘naptime.Rmd’
```
If I build the vignette and place it in that directory, then the current R version likewise complains.  Reading through the documenation on CRAN it appears that leaving inst/doc empty, with vignettes in /vignettes is the prefered way to structure the package.  So, that is what I have used for this submission.  If this is mistaken, I look forward to your further guidance.

## Downstream dependencies
There are no downstream dependencies at this time.
