library(tidyverse)
#install.packages('data.table')
library(data.table)
library(magrittr)
# 載入颱風停電戶資料
#train <- read.csv("./data/train.csv", encoding = "UTF-8")
train <- fread("./data/train.csv", encoding = "UTF-8")
submit <- fread("./data/submit.csv", encoding = "UTF-8")

# 加入人口戶數資料
# 資料來源為政府資料開放平臺(https://data.gov.tw/dataset/32973#r0)
#family <- read.csv("./data/opendata10603M030.csv")
family <- fread("./data/opendata10603M030.csv", encoding = "UTF-8")
family <- family[-1, c(2,4)]
family$site_id <- gsub(x = family$site_id, pattern = "臺", replacement = "台")
family$site_id <- gsub(x = family$site_id, pattern = "台東", replacement = "臺東")
family$site_id <- gsub(x = family$site_id, pattern = "　", replacement = "")
names(family)[1] <- "縣市行政區"
family$household_no <- as.character(family$household_no) %>% as.numeric()
family <- group_by(family, 縣市行政區) %>% 
  summarise(household = mean(household_no)) 
train <- left_join(train, family, by = "縣市行政區")
# 屏東縣霧臺鄉有1049戶
train$household[train$縣市行政區 == "屏東縣霧臺鄉"] <- rep(1049, 6)
# 雲林縣臺西鄉有8727戶
train$household[train$縣市行政區 == "雲林縣臺西鄉"] <- rep(8727, 15)
# 高雄市三民區有134958戶
train$household[train$縣市行政區 == "高雄市三民區"] <- rep(134958, 86)
# 高雄市鳳山區有134958戶
train$household[train$縣市行政區 == "高雄市鳳山區"] <- rep(138016, 76)

submit <- left_join(submit, train[, c(3, 14:24)], by = "VilCode")


# 加入特各颱風風力資料
# 資料來源為颱風資料庫(http://rdc28.cwb.gov.tw/)

gust <- read.csv("./data/gust.csv")
names(gust)[1] <- "CityName" 
typeOfCity <- unique(train$CityName) #%>% length() %>% as.numeric()

TrainMergeGust <- merge(train, gust, all.x = T, by = "CityName", sort = F)

soudelor <- TrainMergeGust[c(1:4, 8, 13:16)] %>% cbind(., TYname = rep("soudelor", nrow(TrainMergeGust)))  %>% as.matrix()
dujuan <- TrainMergeGust[c(1:4, 7, 13:14, 17, 18)] %>% cbind(., TYname = rep("dujuan", nrow(TrainMergeGust))) %>% as.matrix()
matmo <- TrainMergeGust[c(1:4, 10, 13:14, 21, 22)] %>% cbind(., TYname = rep("matmo", nrow(TrainMergeGust))) %>% as.matrix()
nepartak <- TrainMergeGust[c(1:4, 11, 13:14, 23, 24)] %>% cbind(., TYname = rep("nepartak", nrow(TrainMergeGust))) %>% as.matrix()
meranti <- TrainMergeGust[c(1:4, 12, 13:14, 25, 26)] %>% cbind(., TYname = rep("meranti&Mal", nrow(TrainMergeGust))) %>% as.matrix()

new_train <- rbind(soudelor, dujuan, matmo, nepartak, meranti) %>% as.data.frame()

names(new_train)[5] <- "power_failure"
names(new_train)[8:9] <- c("maxWind", "gust")
write.csv(new_train, "c://dsp_Typhoon_Taipower/data/newTrain.csv")
# submit dataset
NesatAndHaitang_submit <- submit[1:5] %>% cbind(., 
                                                縣市行政區 = TrainMergeGust$縣市行政區, 
                                                household = TrainMergeGust$household, 
                                                maxWind =TrainMergeGust$nesat_maxWind, 
                                                gust = TrainMergeGust$nesat_gust)

Megi_submit <- submit[c(1:4, 6)] %>% cbind(., 
                                           縣市行政區 = TrainMergeGust$縣市行政區, 
                                           household = TrainMergeGust$household,
                                           maxWind =TrainMergeGust$megi_maxWind, 
                                           gust = TrainMergeGust$megi_gust)
write.csv(NesatAndHaitang_submit, "c://dsp_Typhoon_Taipower/data/NesatAndHaitang_submit.csv")
write.csv(Megi_submit, "c://dsp_Typhoon_Taipower/data/Megi_submit.csv")

