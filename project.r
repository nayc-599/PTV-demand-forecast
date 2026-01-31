library(httr)
library(jsonlite)
library(dplyr)
library(DBI)
library(RPostgres)
library(forecast)

resource_id <- "2606a765-88f0-41c9-9b7c-76d3f2626a67"
res <- GET("https://discover.data.vic.gov.au/api/3/action/datastore_search",
           query = list(resource_id = resource_id, limit = 10000))

data_raw <- fromJSON(content(res, "text"), flatten = TRUE)
df <- data_raw$result$records


df <- df %>%
  mutate(
    Year = as.integer(Year),
    Day_of_week = factor(Day_of_week, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")),
    Month = as.integer((Month)),
    Day_type = factor(Day_type),
    Mode = factor(Mode),
    Pax_daily = as.numeric(Pax_daily)
  )


make_ts <- function(df, type){
    mode_data <- filter(df, Mode == type)

    monthly_mode_data <- summarise(
    group_by(mode_data, Year, Month),
    Pax = mean(Pax_daily)
    )

    monthly_mode_data <- ungroup(monthly_mode_data)

    ts_mode_data <- ts(monthly_mode_data$Pax, start = c(2018, 1), frequency = 12)

    plot(ts_mode_data, xlab="Time", ylab="Average Patronage Per Month")

    return(list(
    data = monthly_mode_data,
    ts = ts_mode_data
  ))
}



outlier <- ifelse((monthly_metrobus$Year == 2019 &
                   monthly_metrobus$Month >= 11) |
                   monthly_metrobus$Year  %in% 2020:2021 |
                   (monthly_metrobus$Year == 2022 &
                      monthly_metrobus$Month <= 7),
                 1, 0)


metrobus <- make_ts(df, "MetroBus")


monthly_metrobus <- metrobus$data
ts_metrobus <- metrobus$ts


ts_full <- ts(monthly_metrobus$Pax, start = c(2018,1), frequency = 12)
outlier_full <- outlier 

train <- window(ts_full, end = c(2023, 9))
test <- window(ts_full, start = c(2023, 10))

outlier_train <- outlier_full[1:length(train)]
outlier_test <- outlier_full[(length(train)+1):length(ts_full)]


fit_train <- auto.arima(train, xreg = outlier_train, stepwise = FALSE, p = 3,)
checkresiduals(fit_train)





fc <- forecast(fit_train, xreg = outlier_test, h = length(test))
lines(test, col = "red")

ts_clean <- tsclean(ts_full)

idk.r



