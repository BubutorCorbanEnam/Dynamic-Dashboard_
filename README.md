# Dynamic Linear Regression Shiny App
This is A dynamic dashboard created using R programing language mainly for linear regression analysis to help improve efficiency in prediction. 
This Shiny app allows users to perform linear regression analysis using their own datasets. The application supports uploading datasets in various formats (CSV, TXT, XLSX), selecting numeric variables for regression, and predicting outcomes based on a new dataset. Additionally, it can visualize the regression line for models with one predictor.

Features
File Upload: Supports uploading datasets in CSV, TXT, and XLSX formats.
Variable Selection: Allows dynamic selection of numeric variables for the outcome and predictors.
Linear Regression Modeling: Fits a linear regression model using selected numeric predictors and displays the model summary.
Prediction on New Data: Predicts outcomes using a new dataset and displays the results.
Data Visualization: Plots a regression line if the model has a single predictor.
Prerequisites
To run this app locally, you need to have the following installed:

R (version 3.6 or higher)
RStudio (optional, but recommended)
The following R packages:
shiny
DT
ggplot2
readxl (for reading XLSX files)
