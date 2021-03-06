#This R file has codes for both Question 1 and Question 2

#Question 1 - Linear Regression and Principal Components Analysis

library(readxl)
library(Hmisc)
library(leaps)

set.seed(42)
setwd("C:/Users/Aditya Murali/Desktop")

#Verify that the working directory has been changed
getwd()

#read data from the csv file
mydata <- read.csv("mortality.csv", header=TRUE)

#print first few lines of mortality dataset
head(mydata)

#Drop City variable from the dataset as it is an identifier for which we cannot perform statistical operations
mydata$City <- NULL

#Verify that City variable has been dropped
head(mydata)

mortalitymodel1 <- lm(Mortality~. , data = mydata)
summary(mortalitymodel1)
plot(mortalitymodel1)

#From the plots we can see that the residuals almost follow a normal distribution and are homoscedastic

#We need to check if there are outliers in the data of independant variables.

#look for outliers in Jan Temp
outliers_JanTemp <- boxplot.stats(mydata$JanTemp)$out  # outlier values.
outliers_JanTemp <- sort(outliers_JanTemp)
boxplot(mydata$JanTemp, main="Jan Temp", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_JanTemp, collapse=", ")), cex=0.8)

#look for outliers in July Temp
outliers_JulyTemp <- boxplot.stats(mydata$JulyTemp)$out  # outlier values.
outliers_JulyTemp <- sort(outliers_JulyTemp)
boxplot(mydata$JulyTemp, main="July Temp", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_JulyTemp, collapse=", ")), cex=0.8)

#look for outliers in Relative Humidity
outliers_RelHum <- boxplot.stats(mydata$RelHum)$out  # outlier values.
outliers_RelHum <- sort(outliers_RelHum)
boxplot(mydata$RelHum, main="Relative Humidity", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_RelHum, collapse=", ")), cex=0.8)

#look for outliers in Rain
outliers_Rain <- boxplot.stats(mydata$Rain)$out  # outlier values.
outliers_Rain <- sort(outliers_Rain)
boxplot(mydata$Rain, main="Rain", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_Rain, collapse=", ")), cex=0.8)

#look for outliers in Education
outliers_Education <- boxplot.stats(mydata$Education)$out  # outlier values.
outliers_Education <- sort(outliers_Education)
boxplot(mydata$Education, main="Education", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_Education, collapse=", ")), cex=0.8)

#look for outliers in Population Density
outliers_PopDen <- boxplot.stats(mydata$PopDensity)$out  # outlier values.
outliers_PopDen <- sort(outliers_PopDen)
boxplot(mydata$PopDensity, main="Population Density", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_PopDen, collapse=", ")), cex=0.8)

#look for outliers in Non Whites
outliers_NW <- boxplot.stats(mydata$NW)$out  # outlier values.
outliers_NW <- sort(outliers_NW)
boxplot(mydata$NW, main="Non Whites", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_NW, collapse=", ")), cex=0.8)

#look for outliers in White Collar workers
outliers_WC <- boxplot.stats(mydata$WC)$out  # outlier values.
outliers_WC <- sort(outliers_WC)
boxplot(mydata$WC, main="White Collar workers", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_WC, collapse=", ")), cex=0.8)

#look for outliers in Population
outliers_Pop <- boxplot.stats(mydata$pop)$out  # outlier values.
outliers_Pop <- sort(outliers_Pop)
boxplot(mydata$pop, main="Population", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_Pop, collapse=", ")), cex=0.8)

#look for outliers in Household Size
outliers_HHSize <- boxplot.stats(mydata$HHSiz)$out  # outlier values.
outliers_HHSize <- sort(outliers_HHSize)
boxplot(mydata$HHSiz, main="Household Size", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_HHSize, collapse=", ")), cex=0.8)

#look for outliers in Income
outliers_Income <- boxplot.stats(mydata$income)$out  # outlier values.
outliers_Income <- sort(outliers_Income)
boxplot(mydata$income, main="Income", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_Income, collapse=", ")), cex=0.8)

#look for outliers in HC Pollution Potential
outliers_HC <- boxplot.stats(mydata$HCPot)$out  # outlier values.
outliers_HC <- sort(outliers_HC)
boxplot(mydata$HCPot, main="HCPot", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_HC, collapse=", ")), cex=0.8)

#look for outliers in Nitrous Oxide Pollution Potential
outliers_NO <- boxplot.stats(mydata$NOxPot)$out  # outlier values.
outliers_NO <- sort(outliers_NO)
boxplot(mydata$NOxPot, main="WC", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_NO, collapse=", ")), cex=0.8)

#look for outliers in Sulphur Dioxide Pollution Potential
outliers_SO <- boxplot.stats(mydata$S02Pot)$out  # outlier values.
outliers_SO <- sort(outliers_SO)
boxplot(mydata$S02Pot, main="S02Pot", boxwex=1)
mtext(paste("Outliers: ", paste(outliers_SO, collapse=", ")), cex=0.8)

#cap outlier values using Winsorization

val1 <- mydata$JanTemp
qnt <- quantile(val1, probs=c(.25, .75), na.rm = T)
caps <- quantile(val1, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val1, na.rm = T)
val1[val1 < (qnt[1] - H)] <- caps[1]
val1[val1 > (qnt[2] + H)] <- caps[2]

val2 <- mydata$JulyTemp
qnt <- quantile(val2, probs=c(.25, .75), na.rm = T)
caps <- quantile(val2, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val2, na.rm = T)
val2[val2 < (qnt[1] - H)] <- caps[1]
val2[val2 > (qnt[2] + H)] <- caps[2]

val3 <- mydata$RelHum
qnt <- quantile(val3, probs=c(.25, .75), na.rm = T)
caps <- quantile(val3, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val3, na.rm = T)
val3[val3 < (qnt[1] - H)] <- caps[1]
val3[val3 > (qnt[2] + H)] <- caps[2]

val4 <- mydata$Rain
qnt <- quantile(val4, probs=c(.25, .75), na.rm = T)
caps <- quantile(val4, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val4, na.rm = T)
val4[val4 < (qnt[1] - H)] <- caps[1]
val4[val4 > (qnt[2] + H)] <- caps[2]

val5 <- mydata$Education
qnt <- quantile(val5, probs=c(.25, .75), na.rm = T)
caps <- quantile(val5, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val5, na.rm = T)
val5[val5 < (qnt[1] - H)] <- caps[1]
val5[val5 > (qnt[2] + H)] <- caps[2]

val6 <- mydata$PopDensity
qnt <- quantile(val6, probs=c(.25, .75), na.rm = T)
caps <- quantile(val6, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val6, na.rm = T)
val6[val6 < (qnt[1] - H)] <- caps[1]
val6[val6 > (qnt[2] + H)] <- caps[2]

val7 <- mydata$NW
qnt <- quantile(val7, probs=c(.25, .75), na.rm = T)
caps <- quantile(val7, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val7, na.rm = T)
val7[val7 < (qnt[1] - H)] <- caps[1]
val7[val7 > (qnt[2] + H)] <- caps[2]

val8 <- mydata$WC
qnt <- quantile(val8, probs=c(.25, .75), na.rm = T)
caps <- quantile(val8, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val8, na.rm = T)
val8[val8 < (qnt[1] - H)] <- caps[1]
val8[val8 > (qnt[2] + H)] <- caps[2]

val9 <- mydata$pop
qnt <- quantile(val9, probs=c(.25, .75), na.rm = T)
caps <- quantile(val9, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val9, na.rm = T)
val9[val9 < (qnt[1] - H)] <- caps[1]
val9[val9 > (qnt[2] + H)] <- caps[2]

val10 <- mydata$HHSiz
qnt <- quantile(val10, probs=c(.25, .75), na.rm = T)
caps <- quantile(val10, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val10, na.rm = T)
val10[val10 < (qnt[1] - H)] <- caps[1]
val10[val10 > (qnt[2] + H)] <- caps[2]

val11 <- mydata$income
qnt <- quantile(val11, probs=c(.25, .75), na.rm = T)
caps <- quantile(val11, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val11, na.rm = T)
val11[val11 < (qnt[1] - H)] <- caps[1]
val11[val11 > (qnt[2] + H)] <- caps[2]

val12 <- mydata$HCPot
qnt <- quantile(val12, probs=c(.25, .75), na.rm = T)
caps <- quantile(val12, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val12, na.rm = T)
val12[val12 < (qnt[1] - H)] <- caps[1]
val12[val12 > (qnt[2] + H)] <- caps[2]

val13 <- mydata$NOxPot
qnt <- quantile(val13, probs=c(.25, .75), na.rm = T)
caps <- quantile(val13, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val13, na.rm = T)
val13[val13 < (qnt[1] - H)] <- caps[1]
val13[val13 > (qnt[2] + H)] <- caps[2]

val14 <- mydata$S02Pot
qnt <- quantile(val14, probs=c(.25, .75), na.rm = T)
caps <- quantile(val14, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(val14, na.rm = T)
val14[val14 < (qnt[1] - H)] <- caps[1]
val14[val14 > (qnt[2] + H)] <- caps[2]

tempdata <- mydata

#replace capped columns into original data set
mydata$JanTemp <- val1
mydata$JulyTemp <- val2
mydata$RelHum <- val3
mydata$Rain <- val4
mydata$Education <- val5
mydata$PopDensity <- val6
mydata$NW <- val7
mydata$WC <- val8
mydata$pop <- val9
mydata$HHSiz <- val10
mydata$income <- val11
mydata$HCPot <- val12
mydata$NOxPot <- val13
mydata$S02Pot <- val14

mortalitymodel2 <- lm(Mortality~. , data = mydata )
summary(mortalitymodel2)
plot(mortalitymodel2)

#Run the code to predict mortality using significant variables only

mortalitymodel3 <- lm(Mortality~ NW + JanTemp + NOxPot + HCPot + Rain , data = mydata )
summary(mortalitymodel3)
plot(mortalitymodel3)

#PCA
mydatanomissing <- na.omit(mydata)
pcadata <- mydatanomissing
pcadata$Mortality <- NULL
head(pcadata)
fit <- princomp(pcadata, cor = TRUE)
summary(fit)
fit$loadings
fit$scores
plot(fit, type="lines")


#how many principal components should be selected?
#8

mydatanomissing$pc1 <- fit$scores[, 1]
mydatanomissing$pc2 <- fit$scores[, 2]
mydatanomissing$pc3 <- fit$scores[, 3]
mydatanomissing$pc4 <- fit$scores[, 4]
mydatanomissing$pc5 <- fit$scores[, 5]
mydatanomissing$pc6 <- fit$scores[, 6]
mydatanomissing$pc7 <- fit$scores[, 7]
mydatanomissing$pc8 <- fit$scores[, 8]

head(mydatanomissing)

mortalitymodel4 <- lm(Mortality ~ pc1 + pc2 + pc3 + pc4 + pc5 + pc6 + pc7 + pc8, data = mydatanomissing)
summary(mortalitymodel4)

#remove insignificant pcs
mortalitymodel4a <- lm(Mortality ~ pc1 + pc2 + pc6 + pc3, data = mydatanomissing)
summary(mortalitymodel4a)

#remove insignificant pcs
mortalitymodel4b <- lm(Mortality ~ pc1 + pc2 + pc6, data = mydatanomissing)
summary(mortalitymodel4b)


#End of Question 1------------------ End of Question 1 ------------ End of Question 1

#Question 2 - Association Rule Mining

setwd("C:/Users/Aditya Murali/Desktop")
#Verify that the working directory has been changed
getwd()

#Install the packages arules and arulesViz to use association rule functions
#Call the libraries arules and arulesViz to use association rule functions
library(arules)
library(arulesViz)

#Load the transactions data
set.seed(42)
assocs <- read.transactions("transactions.csv", format = "single", sep = ",", cols = c(2,4), rm.duplicates = FALSE)

#Find out the number of transactions and the number of products in the transactions matrix
assocs

#Obtain summary statistics of transactions data
summary(assocs)

# Plot frequency of products
itemFrequencyPlot(assocs,type="absolute")

# Generate rules with support = 0.03 and confidence = 0.20 with a minimum length of 2
rules <- apriori(assocs, parameter = list(supp = 0.03, conf = 0.20, minlen = 2))

#Sort the rules in decreasing order by lift
rules <- sort(rules, by="lift", decreasing=TRUE)

# Limit output to 2 digits
options(digits=2)

# Show rules and their summary
inspect(rules)
summary(rules)

# Are there any redundant rules?
is.redundant(rules)
rules[is.redundant(rules)]
inspect(rules[is.redundant(rules)])

#End of Question 2 --------------- End of Question 2 -------------- End of Question 2