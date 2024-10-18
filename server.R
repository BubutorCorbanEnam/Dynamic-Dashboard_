# Define the server logic
server <- function(input, output) {

  # Function to load dataset based on file type
  load_dataset <- function(file) {
    ext <- tools::file_ext(file$name)  # Get file extension
    switch(ext,
           "csv" = read.csv(file$datapath),
           "txt" = read.delim(file$datapath),
           "xlsx" = read_excel(file$datapath),
           stop("Unsupported file format"))
  }

  # Reactive expression to load and read the training dataset
  dataset <- reactive({
    req(input$file_input)  # Ensure the file is uploaded
    load_dataset(input$file_input)
  })

  # Filter to get only numeric columns
  numeric_columns <- reactive({
    df <- dataset()
    df[sapply(df, is.numeric)]  # Only return numeric columns
  })

  # Dynamically generate UI elements for selecting predictors and outcome (numeric only)
  output$variable_selector <- renderUI({
    df <- numeric_columns()
    colnames <- names(df)

    # Select input for the outcome variable and predictors (numeric only)
    tagList(
      selectInput("outcome_var", "Select Numeric Outcome Variable:", choices = colnames),
      checkboxGroupInput("predictor_vars", "Select Numeric Predictor Variables:", choices = colnames)
    )
  })

  # Render the dataframe as a DataTable (training dataset)
  output$data_table <- renderDT({
    datatable(dataset())
  })

  # Reactive expression to create the linear regression model
  model <- reactive({
    req(input$outcome_var, input$predictor_vars)  # Ensure outcome and predictors are selected
    df <- numeric_columns()  # Use only numeric columns
    formula <- as.formula(paste(input$outcome_var, "~", paste(input$predictor_vars, collapse = "+")))
    lm(formula, data = df)
  })

  # Display the summary of the linear regression
  output$regression_summary <- renderPrint({
    req(model())
    summary(model())
  })

  # Reactive expression to load the predictor dataset
  predictor_data <- reactive({
    req(input$predictor_file)  # Ensure the file is uploaded
    new_data <- load_dataset(input$predictor_file)

    # Check if the predictor dataset has the required columns
    req(all(input$predictor_vars %in% colnames(new_data)))  # Check column match
    new_data[input$predictor_vars]  # Return only the relevant predictor columns
  })

  # Predict the outcome based on the uploaded prediction dataset
  output$predicted_table <- renderDT({
    req(model(), predictor_data())

    # Make predictions using the uploaded predictor dataset
    predictions <- predict(model(), newdata = predictor_data())

    # Combine the predictions with the original predictor data for display
    predicted_df <- cbind(predictor_data(), Predicted_Value = round(predictions, 2))

    datatable(predicted_df)
  })

  # Plot the regression line with ggplot2 (if there are only 2 predictors)
  output$regression_plot <- renderPlot({
    req(input$predictor_vars, length(input$predictor_vars) == 1)  # Only plot if 1 predictor is selected
    df <- numeric_columns()
    ggplot(df, aes_string(x = input$predictor_vars[1], y = input$outcome_var)) +
      geom_point() +  # Scatter plot
      geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Add regression line
      labs(title = paste("Regression of", input$outcome_var, "on", input$predictor_vars[1]),
           x = input$predictor_vars[1],
           y = input$outcome_var) +
      theme_minimal()
  })
}
