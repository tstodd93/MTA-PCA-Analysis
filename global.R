
library(RCurl)
library(knitr)
library(plyr)
library(ggbiplot)
library(rCharts)
library(qcc)
library(threejs)
library(rgl)
library(pca3d)
library(gridExtra)
library(RCurl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(plotly)
library(data.table)
library(reshape2)
library(DT)
library(kableExtra)
library(shinythemes)


# read in datasets 
Perf_MTA <- read_csv('https://www.dropbox.com/s/smksar0o0hofcn7/metropolitan-transportation-authority-mta-performance-indicators-per-agency-beginning-2008.csv?dl=1') 
# Add 1st day of month to period to yield a date variable
Perf_MTA$Period = paste(Perf_MTA$Period, '-01', sep = '')

Perf_MTA$Period <- Perf_MTA$Period %>% 
  ymd()

# Filter out to only include NYC transit data
Perf_MTA <- Perf_MTA %>%
  dplyr::filter(Perf_MTA$`Agency Name` == "NYC Transit") %>%
  group_by(Period)

# Put the data in the correct format to do the PCA analysis
#Filter out only the bus variables
selectedRows <- Perf_MTA[grep("NYCT Bus",Perf_MTA$`Indicator Name`), ]

NYCT_Bus_data <- selectedRows[,c(4,16,17)]
indicator_names = unique(NYCT_Bus_data$`Indicator Name`)

total = data.frame(matrix(NA, nrow = 109,ncol = 8))
temp_filter = data.frame()

#Filter data by indicator name and format the data frame into the correct format for PCA analysis
for (i in 1:length(indicator_names)) {
  temp_filter = filter(NYCT_Bus_data,`Indicator Name` == indicator_names[[i]])
  temp_filter[order(temp_filter$Period, decreasing = TRUE),]
  temp_filter = temp_filter[,c(3,2)]
  temp_filter = temp_filter[temp_filter$Period >= "2008-12-01" & temp_filter$Period <= "2017-12-01", ]
  
  if (i <=1 ){
    total[,1:2] <- temp_filter
  }
  else if (i > 1) {
    total[,i+1] <- temp_filter[,2]
  }
}

# Set the correct names of the columns
total = setNames(total, c("Period", indicator_names))
