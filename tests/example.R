# Example
source("R/heatplots.R")


ex_data <- read.csv("tests/example_data.csv", stringsAsFactors = FALSE)


a <- heatplot(ex_data, "date_time", "m_value", "temp", "t")
a