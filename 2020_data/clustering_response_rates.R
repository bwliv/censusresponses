library(tidyverse)
library(ggplot2)
library(ggfortify)

county_df <- read_csv("https://newscounts.appspot.com/api/response_rates/county?FORMAT=CSV")

time_series <- county_df %>% 
  filter(state_short=="NY") %>%
  filter(county_name != 'Hamilton') %>%
  select(c("county_name","RESP_DATE","DRRALL")) %>% 
  spread(RESP_DATE,DRRALL)

counties <- time_series$county_name

time_series <- time_series[-c(1:1)]

max <-   apply(time_series, 1, max)
min <-   apply(time_series, 1, min)

scaled_ts <- (time_series -min )/(max - min)

"
distances = dist(time_series)
distances_scaled <- dist(scaled_ts)

autoplot(prcomp(time_series),
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 2,main='unscaled')

autoplot(prcomp(scaled_ts),
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 2,main='scaled')

"

pr <- prcomp(time_series, rank=3)
pr_scaled <- prcomp(scaled_ts,rank=3)

pr_1 = t(as.matrix(pr$rotation[,1])) %*% t(as.matrix(time_series))
pr_2 = t(as.matrix(pr$rotation[,2])) %*% t(as.matrix(time_series))
pr_3 = t(as.matrix(pr$rotation[,3])) %*% t(as.matrix(time_series))
pr_df = t(rbind(pr_1,pr_2,pr_3))
pairs(pr_df,labels=c('PC1','PC2','PC3'),main='unscaled')


pr_scaled_1 = t(as.matrix(pr_scaled$rotation[,1])) %*% t(as.matrix(scaled_ts))
pr_scaled_2 = t(as.matrix(pr_scaled$rotation[,2])) %*% t(as.matrix(scaled_ts))
pr_scaled_3 = t(as.matrix(pr_scaled$rotation[,3])) %*% t(as.matrix(scaled_ts))
pr_scaled_df = t(rbind(pr_scaled_1,pr_scaled_2,pr_scaled_3))


pdf(file="scaled.pdf",height=20,width=20)
pairs(pr_scaled_df,labels=c('PC1','PC2','PC3'),main='scaled',cex=0.001,
      panel=function(x, y, ...) { points(x, y, ...); 
        text(x, y, counties,cex=0.7) })
dev.off()

pdf(file="unscaled.pdf",height=20,width=20)
pairs(pr_df,labels=c('PC1','PC2','PC3'),main='unscaled',cex=0.001,
      panel=function(x, y, ...) { points(x, y, ...); 
        text(x, y, counties,cex=0.7) })
dev.off()
"
pr_for_plotting = data.frame(pr$rotation)
pr_for_plotting$date = as.Date(rownames(pr_for_plotting))
pr_for_plotting = gather(pr_for_plotting,key='component',value='loading',-'date')

ggplot(pr_for_plotting) + 
  geom_line(aes(x=date,y=loading,color=component)) +
  ggtitle('Unscaled')

pr_scaled_for_plotting = data.frame(pr_scaled$rotation)
pr_scaled_for_plotting$date = as.Date(rownames(pr_scaled_for_plotting))
pr_scaled_for_plotting = gather(pr_scaled_for_plotting,key='component',value='loading',-'date')

ggplot(pr_scaled_for_plotting) + 
  geom_line(aes(x=date,y=loading,color=component)) +
  ggtitle('Scaled')

pairs(data.frame(pr$rotation),main='unscaled')
pairs(data.frame(pr_scaled$rotation),main='scaled')


plot(pr$rotation[,1],pr$rotation[,2],main='unscaled')
plot(pr_scaled$rotation[,1],pr_scaled$rotation[,2],main='scaled')
"
