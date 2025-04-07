## Naptime 1.3.1 Release

I received a notice about an issue with the URL field in DESCRIPTION.  I can see from the tarball on offer that the error is present in that file.  However, the [check results](https://cran.rstudio.com//web/checks/check_results_naptime.html) appeared clean.  I've been unable to replicate the issue with DESCRIPTION with my current build tooling. All the same, I am submitting a new tarball for which I've manually verified the URL field.

[Test Environments](https://github.com/russellpierce/naptime/actions/runs/14316597177):
* 1 🖥  linux          R-* (any version)              ubuntu-latest on GitHub
* 3 🖥  macos          R-* (any version)              macos-13 on GitHub
* 4 🖥  macos-arm64    R-* (any version)              macos-latest on GitHub
* 5 🖥  windows        R-* (any version)              windows-latest on GitHub
* 27 🐋 ubuntu-gcc12   R-devel (2025-04-06 r88113)    Ubuntu 22.04.5 LTS
* 28 🐋 ubuntu-next    R-4.5.0 RC (2025-04-04 r88112) Ubuntu 22.04.5 LTS

There is no compiled code in this package.  So, I believe these environments will suffice.

### R CMD check results
R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

### Downstream dependencies
There are no downstream dependencies at this time.
