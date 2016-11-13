nap_default <- function() naptime(getOption("naptime.default_delay", 0.1))
nap_warn <- function(...) {
  if (getOption("naptime.warnings", TRUE)) {
    warning(..., call. = FALSE)
  }
}
nap_error <- function(...) {
 if (getOption("naptime.permissive", FALSE)) {
   nap_warn(...)
 } else {
   stop(..., call. = FALSE)
 }
}
