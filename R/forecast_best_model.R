remove_outliers <- function(mode){
  monthly_data <- mode$data
  ts_full <- ts(monthly_data$Pax, start = c(2018, 1), frequency = 12)

  outlier_full <- ifelse(
    (monthly_data$Year == 2019 & monthly_data$Month >= 11) |
      monthly_data$Year %in% 2020:2021 |
      (monthly_data$Year == 2022 & monthly_data$Month <= 7),
    1, 0
  )

  ts_clean <- ts_full
  ts_clean[outlier_full == 1] <- NA

  return (ts_clean)
}

train_models <- function(train) {
  fit_ets <- ets(train, model = "ZZZ")
  
  fit_tbats <- tbats(train)

  return (list(
    ETS = fit_ets, TBATS = fit_tbats
  ))
}

evaluate_models <- function(models, test) {
  fc_ets <- forecast(models$ETS, h=length(test))
  rmse_ets <- accuracy(fc_ets, test)[2, "RMSE"]

  fc_tbats <- forecast(models$TBATS, h = length(test))
  rmse_tbats <- accuracy(fc_tbats, test)[2, "RMSE"]
  
  return(c(ETS = rmse_ets, TBATS = rmse_tbats))
}

best_model <- function(rmse_values) {
  best <- names(rmse_values)[which.min(rmse_values)]
  return (best)
}

forecast_best_model <- function(mode, h){
  ts_clean <- remove_outliers(mode)

  train <- window(ts_clean, end = c(2023, 9))
  test <- window(ts_clean, start = c(2023, 10))

  models <- train_models(train)
  rmse_vals <- evaluate_models(models, test)

  best <- best_model(rmse_vals)

  best_fit_full <- switch(best,
                            ETS = ets(ts_clean),
                            TBATS = tbats(ts_clean))
  fc_best <- forecast(best_fit_full, h = h)
  fc_test <- forecast(models[[best]], h = length(test))
  acc <- accuracy(fc_test, test)

  return(list(forecast = fc_best, best_model = best, ts_full = ts_full,
                accuracy = acc))

}

