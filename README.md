# PTV Demand Forecast Dashboard
Project Status: On-hold

## Brief Description
An end-to-end forecasting pipeline for PTV demand using API integration, automated best-model selection and dyanmic data visualisations built in R to support data-driven resource allocations.

**Live Demo:** [Try it out here!](https://nayc-599.shinyapps.io/dashboard/)

## Purpose
This project supports transport planners in making data-driven resource utilisation and capacity planning across both metropolitan and regional PTV networks, motivated by persistent overcrowding and unsustainable resource allocation. 

By identifying recurring peak periods and low-demand intervals, the forecasts enable targeted interventions such as:
- Adjusting timetables
- Adding services ahead high-demand periods
- Reducing service frequency when demand is low

This enables more efficient utilisation of rolling **stock, fleet, and operational resources**, helping to minimise unnecessary service costs while maintaining service quality. Ultimately, the project aims to reduce overcrowding, optimise resource and cost utilisation, and improve the overall public transport experience for commuters.

## Features
- **Forecastig Across Models**: Predicts passenger demand specific to each mode — train, tram, and bus — over multi-year horizon.
- **Seasonality and Trend Analysis**: Identifies recurring peak periods and low-demand intervals to guide proactive planning.
- **Automated Model Selection**: Selects best model between ETS and TBATS time series models based on RMSE values for reliable forcasts.
- **Interactive Dashboard**: Dynamic visualisations allow planners to explore historical trends, forecast scenarios, and capacity planning.

## Tech Stack
- R: Data wrangling, feature engineering and model development
- Shiny: Interactive web application/dashboard

## Installation
1. Clone the repository:

   ```bash
   git clone https://github.com/nayc-599/PTV-demand-forecast.git
   ```
2. Open an R session in the project root (PTV-demand-forecast):
3. Install required packages:

   ```bash
   install.packages(c(
  "httr",
  "jsonlite",
  "dplyr",
  "forecast",
  "shiny",
  "bslib"
))```
4. Run the Shiny App:

   `shiny::runApp("dashboard")`

## Dataset
**Size**: 4,216 ridership records

### Predictors
- **Temporal**: Month, Year
- **Operational**: Mode of transport
- **External** Factors: Covid-19

### Target Variable
- **Continuous**: Daily passenger demand
- **Distribution**: Varies by mode and day type

## Dashboard Screenshot
<img width="1501" height="811" alt="img1" src="https://github.com/user-attachments/assets/1aa89be7-7aa3-44b4-a494-e2fca6f8e9a4" />

## Acknowledgement
- Monthly average patronage by day type and mode, provided by Public Transport Victoria: https://discover.data.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode￼
