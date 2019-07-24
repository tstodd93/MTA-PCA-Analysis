library(shiny)
server <- function(input, output) {
  
    .theme<- theme(
      axis.line = element_line(colour = 'gray', size = .75),
      panel.background = element_blank(),
      plot.background = element_blank()
    )
  
  output$date_range<- renderText({
    dates = format(as.Date(input$dates), "%A, %d-%b. %Y")
    paste("Selected Date Range is: ", 
          paste(as.character(dates), collapse = " to ")
    )
  })
  
#Create a reactive expression that filters for dates AND bus data variables
    total_dates <-reactive({
      #filter for the dates
      tmp_dates = total[total$Period >= input$dates[1] & total$Period <= input$dates[2],]
    })
    
    #Create a reactive expression that filters for dates AND bs data variables
    total_new <-reactive({
      #filter for the dates
      if (is.null(input$checkGroup)){return(7)}
      # only keep columns that have been checked
      # This should have NULL values when a column isn't checked in the Shiny application
      total_tmp = total[total$Period >= ymd(input$dates[1]) & total$Period <= ymd(input$dates[2]),]
      total_new = total_tmp[,as.numeric(input$checkGroup)]
    })
    
    output$explore_chart <- renderPlot({
      expl_dates = total_dates()
        ggplot(expl_dates, aes(x = expl_dates[,1], y = expl_dates[,5])) + 
        geom_point(color = 'steelblue4', alpha = .8) + 
        # fit linear conditional means line to plot
        geom_smooth(method = 'lm') + 
        ylab('Monthly Ridership - Buses (millions)') +
        xlab('Date Range')+
        ggtitle('Monthly Ridership Over Selected Date Range')+
        theme(plot.title = element_text(hjust = 0.5))
    })
    
    output$mytable = DT::renderDataTable({
      tmp = total_new()
      #mean center the data
      tmp = data.frame(apply(tmp[,1:length(tmp)], 2, function(y) y - mean(y)))
      #compute the pcas
      pca = prcomp(tmp, center=T, scale.=T)
      round(pca$sdev^2, 2)
      #determine the covariance
      cov = round(pca$sdev^2/sum(pca$sdev^2)*100, 2)
      cov = data.frame(c(1:length(tmp)),cov)
      names(cov)[1] = 'PCs'
      names(cov)[2] = 'Variance'
      #render the table of the principle components and their covariance
      cov
    })
  
  output$pca_pareto <- renderPlot({
    tmp = total_new()
    pca = prcomp(tmp, center=T, scale.=T)
    PCA = pca$sdev^2
    qcc::pareto.chart(PCA)
  })
  
      output$plot_pca <- renderPlot({
      tmp = total_new()
      pca = prcomp(tmp, center=T, scale.=T)
      tmp_dates = total_dates()
      year_label = as.data.frame(format(as.Date(tmp_dates$Period, format="%d/%m/%Y"),"%Y"))
      year_label = setNames(year_label, "Year_label")
      total_new = cbind(tmp_dates, year_label)
      
      ggbiplot(pca, choices = c(as.double(input$pca_one), as.double(input$pca_two)), obs.scale = 1, var.scale = 1, groups = total_new[,9], ellipse = T, circle = T)

    })
}
