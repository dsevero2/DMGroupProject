library(dplyr) #Functions for editing data frames.
library(haven) #Lets R recognize other datafile types besides csv.
library(mosaic) # #Functions for common statistical tasks.
library(fastDummies) #Adds a function for making dummy variables.
library(FNN) #Functions for k Nearest Neighbor algorithms.
library(ggplot2)
library(ggthemes)

proj_vs_in_need$Country = tolower(proj_vs_in_need$Country)

newdata<-proj_vs_in_need %>% group_by(Country) %>%
  summarize(helped_coeffecient = (sum(People_Served)/mean(people_wo_basic_raw))) %>%
  arrange(-helped_coeffecient)

newdata<- newdata %>% filter(helped_coeffecient<1)                                                         
mean(newdata$helped_coeffecient)          
newdata<-newdata %>%
  mutate(percent_help= helped_coeffecient*100)
library(ggplot2)
# Basic barplot
p<-ggplot(data=newdata, aes(x=reorder(Country, -percent_help), y=percent_help)) +
  geom_bar(stat="identity",fill="lightblue")
p
p + coord_flip() + ggtitle("Countries Help Provided vs. Help Needed") +
  xlab("Country") + ylab("Percentage of People Without Basic Water Helped") + theme_hc()
