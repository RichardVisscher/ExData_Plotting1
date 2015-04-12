## change to your working directory, where you stored the household_power_consumption.txt file you unzipped
## commands to change working directory dependent on your computers file tree structure

## Load required libraries an set locale to english to display weekdays in english
library(lubridate)
library(dplyr)
Sys.setlocale("LC_TIME", "English")

#read the data into R
power <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", dec = ".")

## CONVERTING DATA AND CREATING DATETIME VARIABLE
## convert Date from factors to date
power$Date <- as.Date(power$Date,"%d/%m/%Y")

## select data for 1 and 2 februari 2007
power <- filter(power, year(power$Date) ==  2007)
power <- filter(power, month(power$Date) == 2)
power <- filter(power, day(power$Date)<= 2)

## convert Date and Time to character strings
power$Date <- as.character(power$Date)
power$Time <- as.character(power$Time)

## Create a new variable datetime by pasting date and time strings
power <- mutate(power, datetime = paste(Date,Time,sep=" "))

##convert datetime to the POSIXlt format
power$datetime <- as.POSIXlt(strptime(power$datetime, "%Y-%m-%d %H:%M:%S"))

## convert remaining factors to numerics
power$Global_active_power <- as.numeric(as.character(power$Global_active_power))
power$Global_reactive_power <- as.numeric(as.character(power$Global_reactive_power))
power$Voltage <- as.numeric(as.character(power$Voltage))
power$Global_intensity <- as.numeric(as.character(power$Global_intensity))
power$Sub_metering_1 <- as.numeric(as.character(power$Sub_metering_1))
power$Sub_metering_2 <- as.numeric(as.character(power$Sub_metering_2))
str(power)

## PLOTTING THE DATA
## Make 4 plots
par(mfrow = c(2, 2))
with(power, {
        plot(datetime, Global_active_power,pch="",cex.axis=0.75,cex.lab=0.75, xlab = "", ylab = "Global Active Power")
        lines(datetime, Global_active_power)
        plot(datetime, Voltage,pch="", cex.axis=0.75, cex.lab=0.75)
        lines(datetime, Voltage)
        plot(datetime,Sub_metering_1,pch="",cex.axis=0.75,cex.lab=0.75, xlab="", ylab = "Energy sub metering")
        legend("topright", lty = 1, lwd =1, cex=0.75,bty = "n", pch = "",  col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        points(datetime,Sub_metering_3,pch="")
        points(datetime,Sub_metering_2,pch="")
        lines(datetime,Sub_metering_1, col = "black")
        lines(datetime,Sub_metering_2,col = "red")
        lines(datetime,Sub_metering_3,col = "blue")
        plot(datetime, Global_reactive_power,pch="",cex.axis=0.75,cex.lab=0.75)
        lines(datetime, Global_reactive_power)
})

## COPYING THE PLOT TO PNG GRAPHIC DEVICE
dev.copy(png, file = "plot4.png")
dev.off()

