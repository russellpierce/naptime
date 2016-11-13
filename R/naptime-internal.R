nap_default <- function() naptime(getOption("naptime.default_delay", 0.1))
nap_warn <- function(...) {
  if (getOption("naptime.warnings", TRUE)) {
    warning(...)
  }
}
