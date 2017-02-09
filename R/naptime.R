#' Safe sleep function
#'
#' Acceptable inputs:
#' \itemize{
#'  \item numeric: time in seconds to nap
#'  \item POSIXct: time at which the nap should stop  (timezone is respected)
#'  \item character: Date or date time at which nap should stop. This string is parsed by package:anytime's anytime(). The timezone will therefore default to the system local timezone, but this can be \href{https://github.com/eddelbuettel/anytime/issues/32}{overriden with an environmental variable} prior to the loading of naptime and anytime.
#'  \item Period: time from now at which the nap should stop
#'  \item difftime: difference in time to nap
#'  \item logical: If TRUE, nap for default duration, otherwise don't nap.
#'  \item NULL: don't nap
#'  \item generic: error or nap for default duration depending on the option naptime.permissive
#' }
#'
#' The default duration is set with a numeric for the option \code{naptime.default_delay} in seconds (default: 0.1)
#' Whether a generic input is accepted is determined by the option \code{naptime.permissive} (default: FALSE)
#'
#' @param time Time to sleep, polymorphic type inputs, leaning towards units as 'seconds'
#' @param permissive An optional argument to override the \code{naptime.permissive option} for this call of the naptime function
#' @rdname naptime
#'
#' @return NULL; A side effect of a pause in program execution
#' @importFrom lubridate period_to_seconds ymd_hms ymd seconds now tz
#' @importFrom methods new
#' @importFrom anytime anytime
#' @export
#' @examples
#' \dontrun{
#' naptime(1)
#' naptime(difftime("2016-01-01 00:00:01", "2016-01-01 00:00:00"))
#' }

setGeneric("naptime",
           function(time, permissive = getOption("naptime.permissive", permissive_default))
           {
             if (missing(time)) {
               nap_default()
             } else if (!is.null(time) && length(time) != 1L) {
               nap_error("The time paramater was not scalar (length equal to 1)", permissive = permissive)
               if (length(time) > 0) {
                 naptime(time[1], permissive = permissive)
               } else {
                 naptime(permissive = permissive)
               }
             } else {
               tryCatch(
                 standardGeneric("naptime")
                 , error = function(e) {
                   nap_error("unhandled input for naptime(): ", as.character(e), permissive = permissive)
                   nap_default()
                 }
               )
             }
             return(NULL)
           })

#' @rdname naptime
setMethod("naptime", signature("numeric"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            if (is.finite(time) && time >= 0) {
              Sys.sleep(time)
            } else if (!is.finite(time) && time > 0) {
              nap_error("naptime() provided with a time that was positive and non-finite", permissive = permissive)
              nap_default()
            } else {
              nap_warn("naptime() provided with a time that was negative or in the past, skipping delay")
            }
          })

#' @rdname naptime
setMethod("naptime", signature("Period"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            naptime(lubridate::period_to_seconds(time), permissive = permissive)
          })

#' @rdname naptime
setMethod("naptime", signature("POSIXct"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            t <- as.numeric(time) - as.numeric(lubridate::now(tzone = lubridate::tz(time)))
            naptime(t, permissive = permissive)
          })

#' @rdname naptime
setMethod("naptime", signature("difftime"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            #Use the units of difftime to construct a Period
            secs <- lubridate::seconds
            naptime(
              eval(
                parse(
                  text=paste0(attr(time, "units"), "(", as.numeric(time), ")")
                  )
                )
            , permissive = permissive)
          })

#' @rdname naptime
setMethod("naptime", signature("logical"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            if (isTRUE(time)) {
              nap_default()
            } else {
              if (isTRUE(!time)) {
                NULL
              } else {
                nap_error("Logical provided to naptime() is not TRUE or FALSE.", permissive = permissive)
                nap_default()
              }
            }
          })

#' @rdname naptime
setMethod("naptime", signature("NULL"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            NULL
          })

#' @rdname naptime
setMethod("naptime", signature("character"),
          function(time, permissive = getOption("naptime.permissive", permissive_default))
          {
            time_parsed <- try(anytime::anytime(time))
            if ("try-error" %in% class(time_parsed) || is.na(time_parsed)) {
              nap_error("Could not parse '", time, "' as time", permissive = permissive)
              nap_default()
            } else {
              t <- time_parsed - lubridate::now(tzone = lubridate::tz(time_parsed))
              naptime(t, permissive = permissive)
            }
          })
