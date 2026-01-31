library(httr)
library(jsonlite)
library(dplyr)
library(DBI)
library(forecast)
library(shiny)
library(bslib)

resource_id <- "2606a765-88f0-41c9-9b7c-76d3f2626a67"
res <- GET("https://discover.data.vic.gov.au/api/3/action/datastore_search",
           query = list(resource_id = resource_id, limit = 10000))

data_raw <- fromJSON(content(res, "text"), flatten = TRUE)
df <- data_raw$result$records

df <- df %>% mutate(
    Year = as.integer(Year),
    Day_of_week = factor(Day_of_week, levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")),
    Month = as.integer(Month),
    Day_type = factor(Day_type),
    Mode = factor(Mode),
    Pax_daily = as.integer(Pax_daily)
)

make_ts <- function(df, mode){
    mode_data <- filter(df, Mode == mode) 

    monthly_data <- summarise( 
        group_by(mode_data, Year, Month),
        Pax = mean(Pax_daily)
    )

    monthly_data <- ungroup(monthly_data) # failsafe
    ts_mode <- ts(monthly_data$Pax, start = c(2018,1), frequency = 12)

    plot(ts_mode, xlab = "Time", ylab = "Passengers")

    return(list(
    data = monthly_data,
    ts = ts_mode
    ))
}


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

plot_ets <- function(fc, mode_name, ts_full){
      
  plot(fc, xlab="Year", ylab="Passengers")
  lines(ts_full, col="black")
  
    last_index <- length(ts_full)

    last_x <- time(ts_full)[last_index]
    last_y <- ts_full[last_index]

    first_x <- time(fc$mean)[1]
    first_y <- fc$mean[1]

    segments(last_x, last_y, first_x, first_y,
            col="blue", lwd=2, lty=2)

  segments(last_x, last_y, first_x, first_y)
}

ui <- fluidPage(
  theme = bs_theme(version = 5),
  
  tags$head(
    tags$style(HTML("
      .app-title {
        padding: 20px;
        font-weight: bold;
        font-size: 32px;
        color: #004080;
        background-color: #e6f2ff;
        text-align: center;
        border-radius: 10px;
        margin-bottom: 20px;
      }
    "))
  ),
  
  tags$div("Victorian Public Transport Forecast", class = "app-title"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("mode", "Choose Transport Mode", choices = levels(df$Mode)),
      sliderInput("h", "Forecast horizon (months):", min = 1, max = 36, value = 24)
    ),
    mainPanel(
      uiOutput("forecastTitle"), 
      card(title = "Forecast Plot", plotOutput("forecastPlot")),
      h5("Model Statistics"),
      card(title = "Model Statistics", tableOutput("modelStats"))
    )
  )
)

server <- function(input, output, session) {
  
  forecast_result <- reactive({
    ts_mode <- make_ts(df, input$mode)
    forecast_final_ets(ts_mode, input$mode, input$h)
  })
  
  output$forecastTitle <- renderUI({
    h5(paste("Forecast for", input$mode))
  })
  
  output$forecastPlot <- renderPlot({
    res <- forecast_result()
    plot_ets(res$forecast, input$mode, res$ts_full)
  })
  
  output$modelStats <- renderTable({
    res <- forecast_result()
    res$accuracy[, c("ME","RMSE","MAE","MAPE")]
  })
}

shinyApp(ui, server)
