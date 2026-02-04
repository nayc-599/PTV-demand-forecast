# PTV Demand Forecast Dashboard
Project Status: On-hold

## Brief Description
An end-to-end forecasting pipeline for PTV demand using API integration, automated best-model selection and dyanmic data visualisations built in R to support data-driven resource allocations.

## Purpose
The purpose of this project is to support transport planners in making data-driven resource utilisation and capacity planning across both metropolitan and regional PTV networks as motivated by persistent overcrowding and unsustainable resource allocation. By identifying recurring peak periods and low-demand intervals, the forecasts enable targeted interventions — adjusting timetables, adding services ahead high-demand periods or reducing service frequency when demand is low. This enables more efficient utilisation of rolling stock, fleet, and operational resources, helping to minimise unnecessary service costs while maintaining service quality. Ultimately, the project aims to reduce overcrowding, optimise resource and cost utilisation, and improve the overall public transport experience for commuters.

## Features
- Forecastig Across Models: Predicts passenger demand specific to each mode — train, tram, and bus — over multi-year horizon.
- Seasonality and Trend Analysis: Identifies recurring peak periods and low-demand intervals to guide proactive planning.
- Automated Model Selection: Selects best model between ETS and TBATS time series models based on RMSE values for reliable forcasts.
- Interactive Dashboard: Dynamic visualisations allow planners to explore historical trends, forecast scenarios, and capacity planning.
