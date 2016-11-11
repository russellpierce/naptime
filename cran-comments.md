## Test environments
* local OS X install
 * R 3.3.0
 * R 3.3.1
 * R 3.3.2
* travis-ci
 * Platform: x86_64-pc-linux-gnu (64-bit) / Ubuntu precise (12.04.5 LTS)
 * R version 3.3.1 (2016-06-21)
 * and R version 3.3.2 (2016-10-31)
 * and R version 3.2.5 (2016-04-14)
 * and R Under development (unstable) (2016-11-10 r71645)
* win-builder
 * R version 3.3.2 (2016-10-31)
 * R Under development (unstable) (2016-11-09 r71642)

## R CMD check results

### Local
0 errors | 0 warnings | 0 notes
R CMD check succeeded

### Win-builder
`Possibly mis-spelled words in DESCRIPTION:
  Sys (3:26)` referring to a function referenced in the description. Not an issue.
  
### CRAN Check
A note because README.md references https://cran.r-project.org/package=naptime which isn't a valid URL yet.

## Downstream dependencies
New submission.  There are no downstream dependencies.
