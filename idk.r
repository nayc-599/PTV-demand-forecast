library(httr)
library(jsonlite)
library(dplyr)
library(forecast)
library(shiny)

# Fetch data
resource_id <- "2606a765-88f0-41c9-9b7c-76d3f2626a67"
res <- GET("https://discover.data.vic.gov.au/api/3/action/datastore_search",
           query = list(resource_id = resource_id, limit = 10000))

data_raw <- fromJSON(content(res, "text"), flatten = TRUE)
df <- data_raw$result$records

df <- df %>% mutate(
  Year = as.integer(Year),
  Month = as.integer(Month),
  Day_type = factor(Day_type),
  Mode = factor(Mode),
  Pax_daily = as.integer(Pax_daily)
)

# Convert daily to monthly series
make_ts <- function(df, mode_name){
  mode_data <- df %>% filter(Mode == mode_name) %>%
    group_by(Year, Month) %>%
    summarise(Pax = mean(Pax_daily), Day_type = first(Day_type)) %>%
    ungroup()
  
  ts_mode <- ts(mode_data$Pax, start=c(2018,1), frequency=12)
  return(list(data=mode_data, ts=ts_mode))
}

# ETS forecast + accuracy
forecast_ets <- function(ts_data, h){
  # Define outliers (manually, same as your previous code)
  outlier_full <- ifelse(
    (time(ts_data) >= c(2019 + 10/12)) | 
    (time(ts_data) >= 2020 & time(ts_data) <= 2021 + 12/12) |
    (time(ts_data) <= 2022 + 7/12 & time(ts_data) >= 2022)
    , 1, 0)
  
  ts_clean <- ts_data
  ts_clean[outlier_full == 1] <- NA
  
  # Split train/test for accuracy
  train <- window(ts_clean, end=c(2023,9))
  test <- window(ts_clean, start=c(2023,10))
  
  fit <- ets(train, model="ZZZ")
  fc <- forecast(fit, h=length(test) + h)
  
  # Compute stats on test period
  test_vals <- window(ts_data, start=c(2023,10))
  stats <- accuracy(fc, test_vals)
  
  return(list(fit=fit, forecast=fc, stats=stats))
}

# Shiny UI
ui <- fluidPage(
  titlePanel("Public Transport Forecast (ETS)"),
  sidebarLayout(
    sidebarPanel(
      selectInput("mode", "Choose Transport Mode", choices=levels(df$Mode)),
      sliderInput("h", "Forecast horizon (months):", min=1, max=36, value=24)
    ),
    mainPanel(
      plotOutput("forecastPlot"),
      br(),
      tableOutput("modelStats")
    )
  )
)

# Shiny server
server <- function(input, output, session){
  
  forecast_result <- reactive({
    ts_mode <- make_ts(df, input$mode)$ts
    forecast_ets(ts_mode, input$h)
  })
  
  output$forecastPlot <- renderPlot({
    res <- forecast_result()
    plot(res$forecast, main=paste("ETS Forecast for", input$mode))
    lines(res$forecast$x, col="black")  # Original series
  })
  
  output$modelStats <- renderTable({
    res <- forecast_result()
    # Show relevant columns only
    stats <- res$stats[,c("ME","RMSE","MAE","MAPE")]
    stats
  })
}

shinyApp(ui, server)