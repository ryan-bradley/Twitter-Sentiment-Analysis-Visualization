shinyServer(function(input, output, session) {
  data <- reactiveValues(table = load_data())
  
  autoInvalidateGraph <- reactiveTimer(30000) # 30 seconds
  autoInvalidateCount <- reactiveTimer(500) # 0.5 seconds
  
  observe({
    autoInvalidateGraph()
    data$table_top = suppressMessages((isolate(data$table) %>% top_n(20))[1:20, ])
  })
  
  observe({
    autoInvalidateCount()
    data$table = load_data()
    
  })
  
  
  output$test <- DT::renderDataTable({
    data$table
  })
  
  output$number_of_tweets <- renderText({
    
    total = tryCatch({
      sum(data$table$Total)
    }, error = function(e) {
      0
    })
    
    paste("Todays Count:", total)
  })
  
  output$view <- renderGvis({ 
    gvisColumnChart(data$table_top, xvar="Main_Dimension", 
                         yvar=c("Negative", "Positive"),
                         options=list(isStacked=TRUE, 
                                      # gvis.editor="Change Chart Type",
                                      title="Popular Accounts",
                                      titleTextStyle="{fontSize:24}",
                                      legend="right",
                                      vAxis="{title:'No Of Tweets'}",
                                      hAxis="{title:'Account'}", 
                                      colors="['red','green']",
                                      focusTarget = 'category',
                                      theme='maximized',
                                      axisTitlesPosition = "out",
                                      height=400))
  }) 
  
})
