library(shiny)

shinyServer(function(input, output) {
          
        datasetInput <- reactive({
                inFile <- input$file1
                
                if (is.null(inFile))
                        return(NULL)
                data <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                                 quote=input$quote)
                candidate <- as.character(data$recipient_name)
                date <- as.character(data$date)
                date <- as.Date(date, format= "%m/%d/%y")
                year <- (as.POSIXlt(date)$year + 1900)
                
                amount <- data$amount
                
                report <- data.frame(year, amount, candidate)
                
                years <- unique(year)
                d <- data.frame()
                
                for (i in 1:length(years)) {
                        report2 <- report[(report$year == years[i]),]
                        test <- aggregate(report2$amount, by= list(candidate = report2$candidate), FUN = sum)
                        final <- cbind(rep(years[i],nrow(test)), test)
                        colnames(final)<- c("Year", "Candidate", "Amount")
                        d <- rbind(d, final)
                        d<- data.frame(d$Year,d$Amount, d$Candidate)
                        colnames(d) <- c("Year", "Amount", "Candidate")
                }
                d[(order(d$Year, d$Amount, decreasing = TRUE)),]   
                
                
})
        output$contents <- renderTable({
                datasetInput()
        })        
        output$downloadData <- downloadHandler(
                filename = function() { paste('final', '.csv', sep='') },
                content = function(filename) {
                        write.csv(datasetInput(), filename)
        }
)

})
