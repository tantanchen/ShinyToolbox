library(shiny)
source("Optymyze Functions.R")

options(shiny.maxRequestSize = -1)
shinyServer(function(input, output, session) {
    values <- reactiveValues()
    output$options1 <- renderUI({
        if(input$fileType1 == "Excel"){
            fluidRow(
                column(6, numericInput("sheetIndex", label = "Sheet number", value = 1, min = 1)),
                column(6, numericInput("startCol", label = "Start Column", value = 1, min = 1)),
                column(6, numericInput("endCol", label = "End Column", value = 0, min = 0)),
                column(6, helpText("End Column = 0 will read all columns"))
            )
        }
        else{
            fluidRow(
                numericInput("skip", label = "Start line", value = 1, min = 1, step = 1),
                numericInput("nrows", label = "Number of lines to read", value = -1, min = -1, step = 1),
                helpText("-1 will read all rows"),
                checkboxInput("header", label = "Header", value = TRUE),
                selectInput("separator", label = "Choose a deliminator", selected = ",",
                            choices = c("Tab"= "\t",
                                        "Comma"= ",",
                                        "Pipe"= "|",
                                        "Space"=" ",
                                        "Semicolon" =";")))
        }
    })
    output$options2 <- renderUI({
        if(input$fileType2 == "Excel"){
            fluidRow(
                column(6, numericInput("sheetIndex2", label = "Sheet number", value = 1, min = 1)),
                column(6, numericInput("startCol2", label = "Start Column", value = 1, min = 1)),
                column(6, numericInput("endCol2", label = "End Column", value = 0, min = 0)),
                column(6, helpText("End Column = 0 will read all columns"))
            )
        }
        else{
            fluidRow(
                numericInput("skip2", label = "Start line", value = 1, min = 1, step = 1),
                numericInput("nrows2", label = "Number of lines to read", value = -1, min = -1, step = 1),
                helpText("-1 will read all rows"),
                checkboxInput("header2", label = "Header", value = TRUE),
                selectInput("separator2", label = "Choose a deliminator", selected = ",",
                            choices = c("Tab"= "\t",
                                        "Comma"= ",",
                                        "Pipe"= "|",
                                        "Space"=" ",
                                        "Semicolon" =";")))
        }
    })
    output$preview1 <- renderDataTable({
        if(is.null(input$file1$datapath)){
            stop("No table to display. Upload your file using the left hand pane")
        }
        if(input$fileType1 == "Excel"){
            if(input$endCol == 0){
                dataTable1 <<- read.xlsx2(input$file1$datapath, sheetIndex = input$sheetIndex, colClasses = NA)
            }
            else{
                dataTable1 <<- read.xlsx2(input$file1$datapath, sheetIndex = input$sheetIndex, colClasses = NA, colIndex = input$startCol:input$endCol)
            }
        }
        else{
            dataTable1 <<- read.delim(input$file1$datapath, sep = input$separator, skip = input$skip-1, 
                                      nrows = input$nrows, header = input$header)
        }
        numericColumns <- sapply(dataTable1, is.numeric)
        updateSelectInput(session = session, "ColNames", choices = names(numericColumns[numericColumns]))
        dataTable1
    }, searchDelay = 0, # Changing the default delay from 500 milliseconds to 0
    options = list(pageLength = 10)
    )
    output$preview2 <- renderDataTable({
        if(is.null(input$file2$datapath)){
            stop("No table to display. Upload your file using the left hand pane")
        }
        if(input$fileType2 == "Excel"){
            if(input$endCol2 == 0){
                dataTable2 <<- read.xlsx2(input$file2$datapath, sheetIndex = input$sheetIndex2, colClasses = NA)
            }
            else{
                dataTable2 <<- read.xlsx2(input$file2$datapath, sheetIndex = input$sheetIndex2, colClasses = NA, colIndex = input$startCol2:input$endCol2)
            }
        }
        else{
            dataTable2 <<- read.delim(input$file2$datapath, sep = input$separator2, skip = input$skip2-1, 
                                      nrows = input$nrows2, header = input$header2)
        }
        dataTable2
    }, searchDelay = 0, # Changing the default delay from 500 milliseconds to 0
    options = list(pageLength = 10)
    )
    output$Extra1 <- renderDataTable({
        if(is.null(dataTable1)){
            stop("No table to display. Go to the Input View tab to upload your files")
        }
        dataTable1[!CheckMatchingRecords(dataTable1, dataTable2, match = "first"),]
        
    }, searchDelay = 0, # Changing the default delay from 500 milliseconds to 0
    options = list(pageLength = 10)
    )
    output$Extra2 <- renderDataTable({
        if(is.null(dataTable1)){
            stop("No table to display. Go to the Input View tab to upload your files")
        }
        dataTable2[!CheckMatchingRecords(dataTable2, dataTable1, match = "first"),]
        
    }, searchDelay = 0, # Changing the default delay from 500 milliseconds to 0
    options = list(pageLength = 10)
    )
    output$ColComparison <- renderDataTable({
        if(is.null(dataTable1)){
            stop("No table to merge. Go to the Input View tab to upload your files")
        }
        TableOfDifferences(dataTable1, dataTable2, input$ColNames)
    }, searchDelay = 0, # Changing the default delay from 500 milliseconds to 0
    options = list(pageLength = 10)
    )
})
