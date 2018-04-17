shinyUI(fluidPage(
  googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
  ),
  
  # Application title
  titlePanel("What's Happening in Michigan Right Now!"),
  h3(textOutput("number_of_tweets"), align="center", style="margin: 5px;"),
  div(style="margin: 20px;",
      htmlOutput("view"))
  # ,
  # DT::dataTableOutput("test")
  
))