# Example
source("R/heatplots.R")
library(ggplot2)
library(scales)

ex_data <- read.csv("tests/example_data.csv", stringsAsFactors = FALSE)


#a <- heatplot(ex_data, "date_time", "m_value", "temp", "t")


df <- ex_data
dateField <- "date_time"
distanceField <- "m_value"
wqVariable <- "salinity"

# convert date_time to a date on the 1st of the mont
df[,dateField] <- as.Date(month_startdate(df[,dateField]))

# get unique dates to use as label breaks
date_breaks <- unique(df[,dateField])


# stat_sum2d
# using ggplot tile
s <- ggplot(df, aes_string(x=dateField, y=distanceField, z=wqVariable))
s <- s+stat_summary_2d(fun=mean, binwidth =c(31, 50), na.rm=TRUE)
s <- s + ylab("km")+
  scale_y_continuous(labels = axis_units) +
  scale_x_date(breaks=date_breaks, date_labels="%b - %Y")
s <- heatplot.format.default(s)
#s <- s + scale_fill_gradientn(colours=c("blue","green","yellow","orange","red"))
s <- s + scale_fill_gradientn(colours=c("blue","green","yellow","orange","red"), values=rescale(c(0.1,0.2,0.25,0.27,0.3)))
s



