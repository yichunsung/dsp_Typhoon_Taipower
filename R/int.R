# 來看這八個北七在幹嘛
setwd("c://comp/dsp_Typhoon_Taipower")
TY_df <- read.csv("data/train.csv")

# 哈吉貝

ty_Hagibis <- subset(TY_df, TY_df$Hagibis != 0)
# 昌鴻
ty_C <- subset(TY_df, TY_df$Chan.hom != 0)
# 杜鵑
ty_Dujuan <- subset(TY_df, TY_df$Dujuan != 0)
# 鳳凰
ty_F <- subset(TY_df, TY_df$Fung.wong != 0)


library(plotly)

plot_ly(data = TY_df,
        x = as.numeric(TY_df$Fung.wong),
        y = as.numeric(TY_df$Soudelor),
        type = "scatter",
        mode = "markers")

