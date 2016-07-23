#' Safe sleep function
#'
#' Acceptable inputs:
#' \itemize{
#'  \item \code{numeric} Time in seconds
#'  \item \code{Period} Any positive time difference, converts dynamically to seconds
#' }
#' @param time Time to sleep, polymorphic type inputs, leaning towards units as 'seconds'
#' @rdname naptime
#'
#' @return NULL; A side effect of a pause in program execution
#' @export
#' @examples
#' \dontrun{
#' naptime(1)
#' naptime(difftime("2016-01-01 00:00:01", "2016-01-01 00:00:00"))
#' }

setGeneric("naptime",
           function(time)
           {
             if (missing(time)) {
               time <- getOption("naptime.default_delay", 0.1)
             }
             tryCatch(
              standardGeneric("naptime")
              , error = function(e) {
                nap_warn("unhandled input for naptime: ", as.character(e), "; sleeping for default duration")
                nap_default()
              }
             )
           })

#' @rdname naptime
setMethod("naptime", signature("numeric"),
          function(time)
          {
            if (is.finite(time) && time >= 0)
              Sys.sleep(time)
            else {
              nap_warn('Non-finite or negative time passed to naptime(), sleeping for .Options$naptime.default_delay seconds.')
              nap_default()
            }
          })

#' @rdname naptime
setMethod("naptime", signature("Period"),
          function(time)
          {
            t <- lubridate::period_to_seconds(time)
            if (t < 0) {
              nap_warn('Time interval is less than zero, sleeping for .Options$naptime.default_delay seconds.')
              t <- getOption("naptime.default_delay")
            }
            Sys.sleep(t)
          })

#' @rdname naptime
setMethod("naptime", signature("POSIXct"),
          function(time)
          {
            t <- as.numeric(time) - as.numeric(lubridate::now(lubridate::tz(time)))
            naptime(t)
          })

#' @rdname naptime
setMethod("naptime", signature("difftime"),
          function(time)
          {
            t <- as.numeric(time)
            if (t < 0) {
              nap_warn('Time interval is less than zero.')
              t <- 0
            }
            Sys.sleep(t)
          })

#' @rdname naptime
setMethod("naptime", signature("logical"),
          function(time)
          {
            nap_warn('Logical passed to naptime(), sleeping for 0 seconds.')
            nap_default()
          })

#' @rdname naptime
setMethod("naptime", signature("NULL"),
          function(time)
          {
            nap_warn('NULL passed to naptime(), sleeping for .Options$naptime.default_delay seconds.')
            nap_default()
          })

#' @rdname naptime
setMethod("naptime", signature("character"),
          function(time)
          {
            if (nchar(time) >= 19) {
              time_parsed <- try(lubridate::ymd_hms(time), silent = TRUE)
            } else {
              #undocumented functionality
              time_parsed <- suppressWarnings(try(as.POSIXlt(lubridate::ymd(time)), silent = TRUE))
            }
            if ("try-error" %in% class(time_parsed) || is.na(time_parsed)) {
              nap_warn("Could not parse ", time, " as time, sleeping for .Options$naptime.default_delay seconds.")
              t <- nap_default()
            } else {
              # we don't actually respect timezones in the current version, everything is assumed to be in UTC
              t <- time_parsed - lubridate::now(tzone = lubridate::tz(time_parsed))
            }
            naptime(t)
          })
