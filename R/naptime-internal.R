permissive_default <- FALSE
nap_default <- function() naptime(getOption("naptime.default_delay", 0.1))
nap_warn <- function(...) {
  if (getOption("naptime.warnings", TRUE)) {
    warning(..., call. = FALSE)
  }
}
nap_error <- function(..., permissive = getOption("naptime.permissive", permissive_default)) {
 if (permissive) {
   nap_warn(...)
 } else {
   stop(..., call. = FALSE)
 }
}
