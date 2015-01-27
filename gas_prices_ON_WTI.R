# Ontario Gas Price & WTI Analysis
# Myles Harrison
# http://www.everydayanaltics.ca
# Jan 2015

library(ts)
library(forecast)

# Read in the Ontario Gas Price Data
data <- read.csv(file="ONTREG_merged.csv", header=T, sep=",")

# Read in the WTI oil price data
WTI_data <- read.csv(file='DCOILWTICO.csv',header=F, col.names=c("Date", "Value"))

# Create a time series object for the WTI and Ontario Avg
WTI <- ts(data=WTI_data$Value, frequency=12, start=c(1990,1), end=c(2014,12))
ON <- ts(data=data$ON.Avg, frequency=12, start=c(1990,1), end=c(2014,12))

# Plot and compare
combined <- cbind(WTI, ON)
plot(combined)

# Plot against each other
plot(ON ~ WTI, data=combined, pch=16, cex=0.3)
# Log-log
plot(log(ON) ~ log(WTI), data=combined, pch=16, cex=0.3)

# Create linear models (normal and log-log)
l1 <- lm(ON ~ WTI, data=combined)
l2 <- lm(log(ON) ~ log(WTI), data=combined)

# Compare relative performance
summary(l1)
summary(l2)
plot(l1)
plot(l2)

# Plot
plot(ON ~ WTI, data=combined, pch=16, cex=0.3)
abline(l1)
plot(log(ON) ~ log(WTI), data=combined, pch=16, cex=0.3)
abline(l2)

# Read in WTI forecast data
WTI_forecast <- read.csv(file="WTI_forecast.csv", header=F, sep=",", col.names=c("Date", "Value"))

# Forecast Ontario Gas Price
fit <- forecast(l2, newdata=data.frame(WTI=WTI_forecast$Value))

# Unlog
fit$mean <- exp(fit$mean)
fit$lower <- exp(fit$lower)
fit$upper <- exp(fit$upper)
fit$x <- exp(fit$x)

# Plot
plot(fit, ylab='Ontario Average Gas Price (cents/L)')
