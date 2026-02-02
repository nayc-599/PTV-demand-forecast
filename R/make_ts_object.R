make_ts <- function(df, mode) {
  mode_data <- filter(df, Mode == mode)

  monthly_data <- summarise(
    group_by(mode_data, Year, Month),
    Pax = mean(Pax_daily)
  )

  monthly_data <- ungroup(monthly_data) # failsafe
  ts_mode <- ts(monthly_data$Pax, start = c(2018, 1), frequency = 12)

  plot(ts_mode, xlab = "Time", ylab = "Passengers")

  return(list(
    data = monthly_data,
    ts = ts_mode
  ))
}