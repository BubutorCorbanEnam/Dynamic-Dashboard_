library(shiny)
library(DT)        # For displaying the dataframe in a table
library(ggplot2)   # For plotting the regression line
library(readxl)    # For reading Excel files

# Define the UI
ui <-    fluidPage(
  titlePanel("Dynamic Linear Regression and Prediction Dashboard"),

  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      h4("Upload your training dataset and a separate prediction dataset."),

      # File input to upload the training dataset (allowing multiple file formats)
      fileInput("file_input", "Upload Training Dataset (CSV, Excel, or TXT):",
                accept = c(".csv", ".txt", ".xlsx")),

      # UI for choosing predictors and outcome variable dynamically
      uiOutput("variable_selector"),

      br(),
      h4("Upload CSV, Excel, or TXT for Prediction (must match predictor columns):"),
      fileInput("predictor_file", "Upload Prediction Dataset:",
                accept = c(".csv", ".txt", ".xlsx")),

      h4("Predicted Values:"),
      DTOutput("predicted_table"),  # Display predicted values

      h4("Linear Regression Results:"),
      verbatimTextOutput("regression_summary")  # Display regression summary
    ),

    # Main panel for displaying dataframe and plot
    mainPanel(
      DTOutput("data_table"),       # Data table output for the training dataset
      plotOutput("regression_plot")  # Plot output for regression
    )
  )
)
