#' Date Breaks
#'
#' This function gets the unqiue months and returns the middle of the month (the 15 th) to use as the date breaks
#' @param dateField Field with dates
#' @keywords date_breaks
#' @return list of unique dates
#' @export
#' @examples
#' unique_date_breaks()

unique_date_breaks <- function(dateField){
  d <- as.Date(dateField)
  start_month <- cut(d, "month") # first day of the month with no time
  mid_month <- as.Date(start_month) + 14 # middle of the month (15th)
  unique_days <- unique(mid_month) # get list of unique dates to use as breaks
}


#' Start of month
#'
#' This function gets the first of the month for given date_time object
#' @param date Date Object
#' @keywords date start month
#' @return date object of the first of the month
#' @export 
#' @examples
#' month_startdate()

month_startdate <- function(date){
  d <- as.Date(date)
  start_month <- cut(d, "month") # first day of the month (without the time)
  date <- as.Date(start_month)
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


#' Heatplot 
#'
#' Plots month by river distance symbolized by water quality variable
#' @param df dataframe (from Export Heatplot data csv)
#' @param dateField field name with the data time information for the water quality point
#' @param distanceField field name with the distance information for the water quality point
#' @param wqVaariable field name for the water quality variable to symbolize
#' @param title the title for the plot
#' @param formatting ggplot formating options to alter plot appearance
#' @keywords plot, heatplot
#' @export 
#' @examples
#' ## Make a heatplot
#' p <- heatplot(data, "date_time", "m_value", "temp", "Example Reach Temperature", heatplot.format.default)

heatplot <- function(df, dateField, distanceField, wqVariable, title=NULL, formatting=heatplot.format.default){
  # convert date_time to a date on the 1st of the mont
  df[,dateField] <- as.Date(month_startdate(df[,dateField]))
  
  # plot using ggplot constructor
  date_breaks <- unique(df[[dateField]]) # get unique dates to use as label breaks
  p <- ggplot(df, aes_string(x=dateField, y=distanceField, z=wqVariable)) +
    stat_summary_2d(fun=mean, binwidth =c(31, 50), na.rm=TRUE) + # bin width is 31 day, height is 50m
    ylab("km")+
    ggtitle(title)+
    scale_y_continuous(labels = axis_units) +
    scale_x_date(breaks=date_breaks, date_labels="%b - %Y") # format of x axis dates Mon - YEAR
  
  # apply formatting
  pf <- formatting(p) + change_gradient_breaks()
}



#' Default Formatting for Heatplot
#'
#' The default formatting options for the heatplot
#' @keywords plot, heatplot
#' @export 

heatplot.format.default <- function(p){
  p2 <- p + theme_bw() +  # change theme simple with no axis or tick marks
    guides(fill = guide_colorbar(ticks = FALSE)) + # no tick marks
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.x = element_blank(),
          axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.25), # x labels horizontal
          legend.position="top", # position of legend
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(1.0, "cm") # size of legend
    )
  return(p2)
}


#' Modify Color Ramp and Breaks
#'
#' Modify default colors and breaks used in the heatplot. The list of the colors and the list of breaks values must be equal.
#' The default color ramp is blue-green-yellow-orange-red with breaks at 0%, 25%, 50%, 75%, 100% of the water quality variable.
#' The break values can either be percentages (make sure the break values start with zero and end with 1) or the actual values
#' of the variable. The actual values will be remapped internally to be between zero and one. 
#' @param new_colors vector of colors to apply to the heatplot fill
#' @param mapped_break_values vector of the break values to use for the specific colors (length of vector must match new_colors)
#' @keywords color, breaks
#' @export 

change_gradient_breaks <- function(new_colors=c("blue","green","yellow","orange","red"), mapped_break_values=c(0,0.25,0.5,0.75,1)){
  scale_fill_gradientn(colours=new_colors, values=rescale(mapped_break_values))
}

