# 1. Download the libraries needed
library(tidyverse)
library(skimr)
library(janitor)
library(lubridate)

#2. Reading data sets and compare column names prior joining data sets.

> jan <- read.csv("C:/Users/Gnauh/Desktop/New folder/202112-divvy-tripdata.csv")
> feb <- read.csv("C:/Users/Gnauh/Desktop/New folder/202201-divvy-tripdata.csv")
> mar <- read.csv("C:/Users/Gnauh/Desktop/New folder/202202-divvy-tripdata.csv")
> apr <- read.csv("C:/Users/Gnauh/Desktop/New folder/202203-divvy-tripdata.csv")
> may <- read.csv("C:/Users/Gnauh/Desktop/New folder/202204-divvy-tripdata.csv")
> jun <- read.csv("C:/Users/Gnauh/Desktop/New folder/202205-divvy-tripdata.csv")
> jul <- read.csv("C:/Users/Gnauh/Desktop/New folder/202206-divvy-tripdata.csv")
> aug <- read.csv("C:/Users/Gnauh/Desktop/New folder/202207-divvy-tripdata.csv")
> sep <- read.csv("C:/Users/Gnauh/Desktop/New folder/202208-divvy-tripdata.csv")
> oct <- read.csv("C:/Users/Gnauh/Desktop/New folder/202209-divvy-publictripdata.csv")
> nov <- read.csv("C:/Users/Gnauh/Desktop/New folder/202210-divvy-tripdata.csv")
> dec <- read.csv("C:/Users/Gnauh/Desktop/New folder/202211-divvy-tripdata.csv")

> colnames(jan)
> colnames(feb)
> colnames(mar)
> colnames(apr)
> colnames(may)
> colnames(jun)
> colnames(jul)
> colnames(aug)
> colnames(sep)
> colnames(oct)
> colnames(nov)
> colnames(dec)

#3. Making sure that the the columns have the same type

> compare_df_cols(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec,return = "mismatch")

#4. Combining Data sets

> bike_rides_2022 <- rbind(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)
> dim(bike_rides_2022)

#5. Removing empty rows and columns then check if any was removed

> bike_rides_2022 <- remove_empty(bike_rides_2022,which = "rows")
> bike_rides_2022 <- remove_empty(bike_rides_2022,which = "cols")
> dim(bike_rides_2022)

#6. Summary of the data frame

> skim_without_charts(bike_rides_2022)

#7. Processing datetime, and creating start and end hour fields

> bike_rides_2022 <- bike_rides_2022 %>% mutate(started_at_datetime = ymd_hms(started_at), ended_at_datetime = ymd_hms(ended_at))
> bike_rides_2022 <- bike_rides_2022 %>% mutate(started_hour = hour(started_at), ended_hour = hour(ended_at))


#8. Creating ride_length field

> bike_rides_2022 <- bike_rides_2022 %>% mutate(ride_length_hours = as.numeric(difftime(ended_at, started_at, units = "hours")))
> bike_rides_2022 <- bike_rides_2022 %>% mutate(ride_length_mins = as.numeric(difftime(ended_at, started_at, units = "mins")))

#9. Creating day_of_the_week fields

> bike_rides_2022 <- bike_rides_2022 %>% mutate(day_of_week_letter = wday(started_at, abbr = TRUE, label = TRUE))
> bike_rides_2022 <- bike_rides_2022 %>% mutate(day_of_week_number = wday(started_at))

#10. summary of data

> skim_without_charts(bike_rides_2022)

#11. Removing na and duplicate

> bike_rides_2022_no_na <- bike_rides_2022 %>% drop_na()
> bike_rides_2022_no_na <- distinct(bike_rides_2022_no_na)
> rm(bike_rides_2022)

#12. Removing negative ride length

> bike_rides_2022_done <- bike_rides_2022_no_na %>% filter(ride_length_mins>0)
> rm(bike_rides_2022_no_na)
> rm(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)

#13. summary of data

> skim_without_charts(bike_rides_2022_done)

## Save the finished process data into csv file.

> write.csv(bike_rides_2022_done,"bike_rides_2022.csv")
