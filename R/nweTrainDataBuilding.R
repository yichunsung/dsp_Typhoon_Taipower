#
library(tidyverse)
library(data.table)
library(magrittr)
setwd("c://comp/dsp_Typhoon_Taipower")
trainset <- read.csv("data/newTrain.csv")
trainset <- trainset[-1]
names(trainset)[6] <- "area"
tyList <- read.csv('data/new_cwb_database.csv')
event_df <- read.csv('data/events_imfor.csv')
event_df <- event_df[c(3:4, 6:8), c(1:6, 10)]
event_df$typhoon_1_size <- c(10, 10, 5, 10, 10)
event_df$typhoon_2_size <- c(0, 0, 0, 0, 5)
event_name <-  c("dujuan", "soudelor", "matmo", "nepartak",  "meranti&Mal")
event_df$Event<- event_name
# unique(trainset$TYname)
event_ty <- c("DUJUAN", "SOUDELOR", "MATMO", "NEPARTAK", 'MERANTI')

typhoon_list <- data.frame()
for(i in 1:5){
  typhoon_df <- subset(tyList, tyList$name == event_ty[[i]] & tyList$year == event_df$year[[i]])
  typhoon_df$name <- event_name[i]
  typhoon_df <- typhoon_df %>% as.matrix()
  typhoon_list <- rbind(typhoon_list, typhoon_df)
}

typhoon_list <- typhoon_list[-1:-4]
names(typhoon_list)[1] <- "Event"
f_typhoonList <- merge(typhoon_list, event_df, all.x = TRUE, all.y = TRUE, by = "Event", sort = FALSE)
names(trainset)[10] <- "Event"
new_trainSet <- merge(trainset, f_typhoonList, all.x = TRUE, all.y = TRUE, by = "Event", sort = FALSE)

write.csv(new_trainSet, "data/finial_train.csv")
