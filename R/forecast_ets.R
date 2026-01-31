
forecast_final_ets <- function(mode, mode_name, h) {
  
  monthly_data <- mode$data
  ts_full <- ts(monthly_data$Pax, start=c(2018,1), frequency=12)
    
    outlier_full <- ifelse(
    (monthly_data$Year == 2019 & monthly_data$Month >= 11) |
    monthly_data$Year %in% 2020:2021 |
    (monthly_data$Year == 2022 & monthly_data$Month <= 7),
    1, 0
  )
  
  ts_clean <- ts_full
  ts_clean[outlier_full == 1] <- NA
  
  fit <- ets(ts_clean, model="ZZZ")
  fc <- forecast(fit, h = h)
  
  train <- window(ts_clean, end=c(2023,9))
  test <- window(ts_clean, start=c(2023,10))

  fit_ets <- ets(train, model="ZZZ")
  fc_test <- forecast(fit_ets, h=length(test))
  acc <- accuracy(fc_test, test)

  return(list(fit = fit, forecast = fc, accuracy=acc, ts_full = ts_full))
}