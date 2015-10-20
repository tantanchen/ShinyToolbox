library(shiny)
library(xlsx)
shinyUI(navbarPage("",
    tabPanel("About",
        mainPanel(h3("File Comparison"),
              p("This app is designed for you to compare the records of two files with the same column names"),
              h4("File 1 & File 2"),
              p("These are the tabs where you can upload your files. Use the left-hand pane to select the file type and upload your two files. Verify your options and the data table will update accordingly."),
              h4("Extra records from file 1"),
              p("This tab displays the extra records that are in your first file as compared to your second file. It will match on every field, but it does not match the row position. e.g. If the first row in your first file is the last row of your second file, it will still idenitfy this record and match on it's respective fields. If there are duplicate records in your first file, but only one in your second, the extra records will show up here."),
              h4("Extra records from file 2"),
              p("This tab is similiar to the other one except it displays the extra records that are in your second file"),
              h4("Difference"),
              p("This tab will display a data table that merges your two files except for a field of your choice. Then it will display the absolute difference between the two. To see the difference of a different field, select it using the drop down. Only numeric fields can be selected"),
              h4("Contact"),
              p("Please contact Tan Chen with any questions or suggestions on this or other apps in the Shiny Toolbox.")
        )
    ),
    tabPanel("File 1",
        sidebarLayout(
            sidebarPanel(
                fileInput("file1", label = "Upload your first file"),
                selectInput("fileType1",label = "File Type", selected = "Excel", choices = c("Excel", "Text")),
                uiOutput("options1")
                ),
            mainPanel(
                dataTableOutput("preview1"))
            )
       ),
    tabPanel("File 2",
             sidebarLayout(
                 sidebarPanel(
                     fileInput("file2", label = "Upload your second file"),
                     selectInput("fileType2",label = "File Type", selected = "Excel", choices = c("Excel", "Text")),
                     uiOutput("options2")
                 ),
                 mainPanel(
                     dataTableOutput("preview2"))
             )
    ),
    tabPanel("Extra records from file 1",
       mainPanel(dataTableOutput("Extra1"))
        ),
    tabPanel("Extra records from file 2",
        mainPanel(dataTableOutput("Extra2"))
        ),
    tabPanel("Difference",
         sidebarLayout(
             sidebarPanel(
                 selectInput("ColNames", label = "Select the column you want to compare", choices = NULL)),
             mainPanel(
                 dataTableOutput("ColComparison"))
         )    
    )
))
