source("R/make_ts_object.R")
source("R/forecast_ets.R")
source("R/plot_forecast.R")
source("R/data_prep.R")

df <- load_data()

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
    res$accuracy[, c("ME", "RMSE", "MAE", "MAPE")]
  })
}
