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

## Make x,y plot x = time, y = Global active power
with(power, plot(datetime,Global_active_power,pch="", cex.axis=0.75,cex.lab=0.75, xlab = "", ylab = "Global Active Power (kilowatts)"))
with(power, lines(datetime,Global_active_power))

## COPYING THE PLOT TO PNG GRAPHIC DEVICE
dev.copy(png, file = "plot2.png")
dev.off()

