plot_ets <- function(fc, mode_name, ts_full) {
  plot(fc, xlab = "Year", ylab = "Passengers")
  lines(ts_full, col = "black")

  last_index <- length(ts_full)

  last_x <- time(ts_full)[last_index]
  last_y <- ts_full[last_index]

  first_x <- time(fc$mean)[1]
  first_y <- fc$mean[1]

  segments(last_x, last_y, first_x, first_y,
    col = "blue", lwd = 2, lty = 2
  )

  segments(last_x, last_y, first_x, first_y)
}
