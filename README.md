# PTV Demand Forecast Dashboard
![Status](https://img.shields.io/badge/Status-Complete-success)
![R](https://img.shields.io/badge/R-4.3+-blue)
![Shiny](https://img.shields.io/badge/Shiny-1.9+-red)
![License](https://img.shields.io/badge/License-MIT-green)

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
- **Interactive Dashboard**: Dynamic visualisations with mode selection and model performance table.

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

   `
   install.packages(c(
  "httr",
  "jsonlite",
  "dplyr",
  "forecast",
  "shiny",
  "bslib"
))`
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

## Project Structure
 ```
    ├── dashboard
    │   └── wrapper
    │      ├── data_prep.R
    │      ├── forecast_best_model.R
    │      ├── make_ts_object.R
    │      └── plot_forecast.R
    │   └── app.R
    ├── data
    │   └── monthly_average_patronage_by_day_type_and_by_mode.csv
    ├── screenshots
    │   ├── img1.png
    │   └── img2.png
    ├── README.md
    └── .gitignore
 ```

## Dashboard Screenshot
<img width="1501" height="811" alt="img1" src="https://github.com/user-attachments/assets/1aa89be7-7aa3-44b4-a494-e2fca6f8e9a4" />
<img width="1501" height="827" alt="img2" src="https://github.com/user-attachments/assets/0c588a6c-45d7-4e5c-bb81-6cd1dba333da" />

## Future Improvements
- Experiment with more models (Prophet, VAR, XGBoost)
- Add a page for real VS model prediction
- Experiment with deep leaning models
- Experiment best-model selection with CV scores

## Contributing
Contributions, issues and features requests are welcome!

### How to contribute
1. Fork the repository.
2. Create feature branch.
   ```bash
   git checkout -b feature/SomeFeature
   ```
3. Commit changes.
    ```bash
    git commit -m 'Add some feature'
    ```
    
4. Push to branch.
    ```bash
    git push feature/SomeFeature
    ```
   
5. Open a Pull Request.
  
## Licence
MIT

## Author
- GitHub: [@nayc-599](https://github.com/nayc-599)
- Email: naychi1301@gmail.com


## Acknowledgement
- Monthly average patronage by day type and mode, provided by Public Transport Victoria: https://discover.data.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode￼
