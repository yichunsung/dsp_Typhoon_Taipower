# data input
inputData <- read.csv("data/finial_train.csv")
inputData <- inputData[-1]
# resethpsh
train <- data.frame(
  household = inputData$household,
  maxWind = inputData$maxWind,
  gust = inputData$gust,
  life_period = inputData$life_period,
  center_lowest_pa = inputData$center_lowest_pa,
  center_stronger_wind = inputData$center_stronger_wind,
  strom_7_R = inputData$strom_7_R,
  strom_10_R = inputData$strom_10_R,
  warming_times = inputData$warming_times,
  typhoon_1_size = inputData$typhoon_1_size,
  typhoon_2_size = inputData$typhoon_2_size,
  power_failure = inputData$power_failure
)

# mlm
mlm <- lm(power_failure ~
            household+maxWind+gust+life_period+center_lowest_pa+center_stronger_wind+strom_7_R+strom_10_R+
            warming_times+typhoon_1_size+typhoon_2_size, data = train)

# NH
input_NH <- read.csv("data/NesatAndHaitang_submit.csv")
test_NH <- data.frame(
  household = input_NH$household,
  maxWind = input_NH$maxWind,
  gust = input_NH$gust,
  life_period = input_NH$life_period,
  center_lowest_pa = input_NH$center_lowest_pa,
  center_stronger_wind = input_NH$center_stronger_wind,
  strom_7_R = input_NH$strom_7_R,
  strom_10_R = input_NH$strom_10_R,
  warming_times = input_NH$warming_times,
  typhoon_1_size = input_NH$typhoon_1_size,
  typhoon_2_size = input_NH$typhoon_2_size
)
result_NH <- predict(mlm, newdata = test_NH)
result_NH

# Megi
input_MG <- read.csv("data/Megi_submit.csv")
test_MG <- data.frame(
  household = input_MG$household,
  maxWind = input_MG$maxWind,
  gust = input_MG$gust,
  life_period = input_MG$life_period,
  center_lowest_pa = input_MG$center_lowest_pa,
  center_stronger_wind = input_MG$center_stronger_wind,
  strom_7_R = input_MG$strom_7_R,
  strom_10_R = input_MG$strom_10_R,
  warming_times = input_MG$warming_times,
  typhoon_1_size = input_MG$typhoon_1_size,
  typhoon_2_size = input_MG$typhoon_2_size
)
result_MG <- predict(mlm, newdata = test_MG)
result_MG

resulit <- data.frame(result_MG, result_NH)
write.csv(resulit, "result/result.csv")
