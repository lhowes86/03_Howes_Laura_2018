#'----------------------
#'
#' Homework week 03
#' 
#' @Date 2018-09-28
#' 
#' @author Laura Howes
#' 
#' ---------------------
#' 
#---
# Problem 1
#---

library(dplyr)
library(ggplot2)
library(forcats)

#
#1 question 10a

setwd("C:/Users/Laura/Dropbox/Grad school/BIOL 607 Biostats/Homework/data")
getwd()

Gene_data <- read.csv("./04q11NumberGenesRegulated.csv")
Gene_data
str(Gene_data)

Mean_Gene_data <- mean(Gene_data$ngenes)
SD_Gene_data <- sd(Gene_data$ngenes)
#n = 109
SE_Gene_data <- (SD_Gene_data/sqrt(109))
CI_Gene <- (2*SE_Gene_data)
CI_Lower_Gene <- Mean_Gene_data-(CI_Gene)
CI_Lower_Gene
CI_Upper_Gene <- Mean_Gene_data+(CI_Gene)
CI_Upper_Gene

#The confidence interval is 12.71 < Mean_Gene_Data < 16.29, or you could write it as
#14.5 +or- 1.79

#1 question 10b

#This confidence interval from 12.71 to 16.29 shows that in 95% of samples of the sample
#population will contain the true mean of the population (within that range).


#1 question 17

#This the correct interpretation, as 0.9 < mean < 3.1 as a confidence interval states
#95% of samples will contain the true population mean, and the remaining 5% of samples
#(2.5% each) could fall above 0.9 or 3.1.


#1 question 18a-f

beetles_per_night <- c(51,45,61,76,11,117,7,132,52,149)

#18a
beetles_per_night_mean <- mean(beetles_per_night)
beetles_per_night_mean
#mean is 70.1

beetles_per_night_sd <- sd(beetles_per_night)
beetles_per_night_sd
#SD is 48.50074

#18b
beetles_per_night_SE <- beetles_per_night_sd/sqrt(length(beetles_per_night))
beetles_per_night_SE
#SE is 15.33728

#18c
CI_beetles <- 2*beetles_per_night_SE
CI_beetles
#CI = 30.67456

CI_lower <- beetles_per_night_mean - (2*CI_beetles)
CI_lower
#CI lower = 8.750872
CI_upper <- beetles_per_night_mean + (2*CI_beetles)
CI_upper
#CI upper = 131.4491

#18d If I had 25 points instead of 10, would the Mean be greater, less, or the same? 
#The mean would be about the same no matter what sample size

#18e If I had 25 points instead of 10, would the SD be greater, less, or the same? 
#The SD would be about the same as well, as it's a measure of population like the mean

#18f If I had 25 points instead of 10, would the SE be greater, less, or the same? 
#The standard error would probably be smaller, since more data would help with precision
#and you would be dividing by a larger value (since you're taking the sqaure root of a 
#bigger number)

#---
# Problem 2
#---

#2.1 Load the data using readr and make the Month_Names column into a factor 
#whose levels are in order of month using  forcats::fct_inorder. Use levels() - 
#a function that takes a factor vector and returns the unique levels - on the 
#column. Are they in the right order?

library(readr)
sea_ice_data_readr <- read.csv("./NH_seaice_extent_monthly_1978_2016.csv")

sea_ice_data_readr <- sea_ice_data_readr %>% 
  mutate(Month_Name = factor(Month_Name)) %>%
  mutate(Month_Name = fct_inorder(Month_Name)) 

levels(sea_ice_data_readr$Month_Name)

#They are not in the right order, just the ordered they were listed in the data
#"Nov" "Dec" "Feb" "Mar" "Jun" "Jul" "Sep" "Oct" "Jan" "Apr" "May" "Aug"

#2.2 Try fct_rev() on ice$Month_Name (I called my data frame ice when I made this). 
#What is the order of factor levels that results? Try out  fct_relevel(), and last, 
#fct_recode() as well. Look at the help files to learn more, and in particular try 
#out the examples. Use these to guide how you try each functino out. After trying 
#each of these, mutate month name to get the months in the right order, from January
#to December. Show that it worked with levels()

fct_rev(sea_ice_data_readr$Month_Name)
#They are in reverse order from the levels function
#Aug May Apr Jan Oct Sep Jul Jun Mar Feb Dec Nov

?fct_relevel
sea_ice_relevel <- fct_relevel(sea_ice_data_readr$Month_Name,"Jan","Feb","Mar","Apr","May",
                               "Jun","Jul","Aug","Sep","Oct","Nov","Dec")
sea_ice_relevel

?fct_recode
sea_ice_recode <- fct_recode(sea_ice_data_readr$Month_Name,"Jan","Feb","Mar","Apr","May","Jun",
                                         "Jul","Aug","Sep","Oct","Nov","Dec")
sea_ice_recode

sea_ice_mutated <- sea_ice_data_readr %>%
  mutate(Month_Name = fct_relevel(Month_Name,"Jan","Feb","Mar","Apr","May",
                                  "Jun","Jul","Aug","Sep","Oct","Nov","Dec"))
sea_ice_mutated

levels(sea_ice_mutated$Month_Name)

#2.3 Now, using what you have just learned about forcats, make a column called Season 
#that is a copy of Month_Name. Use the function  fct_recode to turn it into a factor 
#vector with the levels Winter, Spring, Summer, Fall in that order. Use levels() on 
#ice$Season to show that it worked.

sea_ice_mutated <- sea_ice_mutated %>%
  mutate(Season = Month_Name) %>%
  mutate(Season = fct_recode(Season, Winter = "Jan", Winter = "Feb", Spring = "Mar",
                             Spring = "Apr", Spring = "May", Summer = "Jun", 
                             Summer = "Jul", Summer = "Aug", Fall = "Sep", Fall ="Oct",
                             Fall= "Nov", Winter = "Dec"))

sea_ice_mutated

levels(sea_ice_mutated$Season)

#2.4a Make a boxplot showing the variability in sea ice extent every month.

Sea_ice_extent <- ggplot(data = sea_ice_mutated,
                         mapping = aes(x = Month_Name, y = Extent))

Sea_ice_extent +
  geom_boxplot()

#2.4b Use dplyr to get the annual minimum sea ice extent. Plot minimum ice 
#by year, and add a trendline (either a smooth spline or a straight line).

Sea_ice_ann_min <- sea_ice_mutated %>%
  group_by(Year) %>%
  summarize(min_ice = min(Extent))

ggplot(data = Sea_ice_ann_min,
       mapping = aes(x = Year, y = min_ice)) +
       geom_point() +
       stat_smooth(method = "auto")

#2.5 With the original data, plot sea ice by year, with different lines 
#for different months. Then, use facet_wrap and cut_interval(Month, n=4) to 
#split the plot into seasons.

Sea_ice_by_year <- ggplot(data = sea_ice_mutated, 
                          mapping = aes(x = Year, y = Extent,
                                        group = Month, color = Month))

Sea_ice_by_year_plot <- Sea_ice_by_year +
  geom_line() +
  scale_color_gradientn(colors = rainbow(12)) +
  facet_wrap(~Season)

Sea_ice_by_year_plot

#2.6 Last, make a line plot of sea ice by month with different lines as 
#different years. Gussy it up with colors by year, a different theme, 
#and whatever other annotations, changes to axes, etc., you think best show 
#the story of this data. For ideas, see the lab.

library(viridisLite)
library(viridis)

Line_plot_Sea_Ice_Year <- ggplot(data = sea_ice_mutated,
                                 mapping = aes(x = Month_Name, y = Extent,
                                               group = Year, color = Year))

Line_plot_Sea_Ice_Year +
  geom_line() +
  scale_color_viridis(option = "A") +
  ggtitle("Sea Ice by Year")


#2.7 I couldn't get gganimate to install for me :(

#2.8 something new

Sea_ice_by_year_jitter <-ggplot(data = sea_ice_mutated,
                                mapping = aes(x = Year, y = Extent, 
                                              group = Month, color = Month))
  
Sea_ice_by_year_jitter +
  geom_jitter()
  scale_color_gradient(low = "blue", high = "red")



#EC attempt to install gganimate:

install.packages('devtools')
devtools::install_github('thomasp85/gganimate')

devtools::install_github("thomasp85/tweenr")
devtools::install_github("thomasp85/transformr")
