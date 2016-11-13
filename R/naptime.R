#' Safe sleep function
#'
#' Acceptable inputs:
#' \itemize{
#'  \item numeric: time in seconds to nap
#'  \item POSIXct: time at which the nap should stop  (timezone is respected)
#'  \item Period: time from now at which the nap should stop
#'  \item character: yyyy-mm-dd hh:mm:ss at which nap should stop, time zone is assumed to be Sys.timezone() and hh:mm:ss is optional as three formats may be missing, cf. lubridate::ymd_hms().
#'  \item difftime: difference in time to nap
#'  \item logical: nap for default duration
#'  \item NULL: nap for default duration
#'  \item generic: nap for default duration
#' }
#' @param time Time to sleep, polymorphic type inputs, leaning towards units as 'seconds'
#' @rdname naptime
#'
#' @return NULL; A side effect of a pause in program execution
#' @importFrom lubridate period_to_seconds ymd_hms ymd seconds now tz
#' @importFrom methods new
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
             return(NULL)
           })

#' @rdname naptime
setMethod("naptime", signature("numeric"),
          function(time)
          {
            if (is.finite(time) && time >= 0)
              Sys.sleep(time)
            else {
              nap_warn('Non-finite or negative time passed to naptime(), sleeping for default duration')
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
            t <- as.numeric(time) - as.numeric(lubridate::now(tzone = lubridate::tz(time)))
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
            nap_warn('Logical passed to naptime(), sleeping for default duration')
            nap_default()
          })

#' @rdname naptime
setMethod("naptime", signature("NULL"),
          function(time)
          {
            nap_warn('NULL passed to naptime(), sleeping for default duration')
            nap_default()
          })

#' @rdname naptime
setMethod("naptime", signature("character"),
          function(time)
          {
            time_zone <- ifelse(is.na(Sys.timezone()), "UTC", Sys.timezone())
            if (nchar(time) >= 8) {
              time_parsed <- try(lubridate::ymd_hms(time, tz = time_zone, truncated = 3), silent = TRUE)
            } else {
              # Times that aren't at least 8 characters long do not have a reasonable chance of being parsable
              time_parsed <- NA
            }
            if ("try-error" %in% class(time_parsed) || is.na(time_parsed)) {
              nap_warn("Could not parse ", time, " as time, sleeping for default duration.")
              nap_default()
            } else {
              t <- time_parsed - lubridate::now(tzone = lubridate::tz(time_parsed))
              naptime(t)
            }
          })
