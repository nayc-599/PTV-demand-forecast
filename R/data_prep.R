library(httr)
library(jsonlite)
library(dplyr)
library(forecast)
library(shiny)
library(bslib)
library(styler)

load_data <- function() {
  resource_id <- "2606a765-88f0-41c9-9b7c-76d3f2626a67"
  res <- GET("https://discover.data.vic.gov.au/api/3/action/datastore_search",
    query = list(resource_id = resource_id, limit = 10000)
  )

  data_raw <- fromJSON(content(res, "text"), flatten = TRUE)
  df <- data_raw$result$records

  df <- df %>% mutate(
    Year = as.integer(Year),
    Day_of_week = factor(Day_of_week,
      levels = c(
        "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
      )
    ),
    Month = as.integer(Month),
    Day_type = factor(Day_type),
    Mode = factor(Mode),
    Pax_daily = as.integer(Pax_daily)
  )
  return(df)
}
