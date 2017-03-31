#' Date Breaks
#'
#' This function gets the unqiue months and returns the middle of the month (the 15 th) to use as the date breaks
#' @param dateField Field with dates
#' @keywords date_breaks
#' @export list of unique dates
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
#' @export 
#' @examples
#' month_startdate()

month_startdate <- function(date){
  d <- as.Date(date)
  start_month <- cut(d, "month") # first day of the month with no time
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
#' @param formating ggplot formating options to alter plot appearance
#' @keywords plot, heatplot
#' @export 
#' @examples
#' ## Make a heatplot
#' p <- heatplot(ex_data, "date_time", "m_value", "temp", "Example Reach Temperature", heatplot.format.default)

heatplot <- function(df, dateField, distanceField, wqVariable, title, formating=heatplot.format.default){
  # convert date_time to a date on the 1st of the mont
  df[,dateField] <- as.Date(month_startdate(df[,dateField]))
  
  # get unique dates to use as label breaks
  date_breaks <- unique(df[,dateField])
  
  # plot using ggplot with geom_tile
  p <- ggplot(df, aes_string(x=dateField, y=distanceField, color=wqVariable)) +
    geom_point(pch=15, cex=3)+
    scale_color_gradientn(colours=c("blue","green","yellow","orange","red")) + # set color gradient
    ggtitle(title) +
    ylab("km")+
    scale_y_continuous(labels = axis_units) +
    scale_x_date(breaks=date_breaks, date_labels="%b - %Y") # format of x axis dates Mon - YEAR
  pf <- formating(p) 
}


#' Default Format for Heatplot
#'
#' The defualt formating options for the heatplot
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