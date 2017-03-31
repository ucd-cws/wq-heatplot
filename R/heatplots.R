#' Date Breaks
#'
#' This function gets the unqiue months and returns the middle of the month (the 15th) to use as the date breaks
#' @param dataframe R dataframe object with water quality data.
#' @param dateField Name of the field with dates
#' @keywords date_breaks
#' @export list of unique dates
#' @examples
#' unique_date_breaks()

unique_date_breaks <- function(dataframe, dateField){
  df <- dataframe
  df[,dateField] <- as.Date(df[,dateField])
  df[,dateField] <- cut(df[,dateField], "month")
  df[,dateField] <- as.Date(df[,dateField]) + 15 # middle of the month
  unique <- unique(df[,dateField]) # get list of unique dates to use as breaks
}


#' Change Axis Scale Units
#'
#' Divides the scale of the axis by 1,000 so units show up in kilometers instead of meters.
#' @param x value in meters
#' @keywords scale, axis
#' @export 
#' @examples
#' ## Convert 1,200 meters to 1.2 KM
#' scale_axis(1200)

axis_units <-function(x){
  x/1000
}