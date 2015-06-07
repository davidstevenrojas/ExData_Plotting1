##This script handles all the information for you, no need to download or unzip 
##any content. Important: In case you want to delete all data, so please delete 
##the "./data" folder entirely and that's it. It attempts to download the data 
##if it´s not been downloaded already. If data was already downloaded, it 
##attempts to unzip if it's not been unzipped already: It applies for when the 
##script is executed multiple times, in order to avoid unnecessary downloads and
##unzip operations.

##It requires the 'sqldf' package

##define constants for later use across code
urlEnergyUseData <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFileName <- "energy_data.zip"
unzippedFileNameFolder <- "energy_data"
dataSubFolder <- "./data"
extractedFileName <- "household_power_consumption.txt"

##it checks existence of "./data" folder.
if(!file.exists(dataSubFolder)){
        dir.create(dataSubFolder)
}
##it checks existence of "./data/energy_data" folder.
if(!file.exists(paste(dataSubFolder,"/",unzippedFileNameFolder, sep = ""))){
        if(!file.exists(paste(dataSubFolder,"/",zipFileName, sep = ""))){
                download.file(urlEnergyUseData,destfile = paste(dataSubFolder,"/", zipFileName, sep = ""), method = "curl")   
        }
        unzip(zipfile = paste(dataSubFolder,"/", zipFileName,sep = ""),exdir = paste(dataSubFolder,"/",unzippedFileNameFolder, sep = ""))
}

##using sqldf to filter content out by select * from file where Date in ('1/2/2007','2/2/2007')
library(sqldf)
tmp <- read.csv2.sql(file = paste(dataSubFolder,"/",unzippedFileNameFolder,"/",extractedFileName, sep=""), sql = "select * from file where Date in ('1/2/2007','2/2/2007')" )
closeAllConnections()

##Adding Datetime column 
tmp$Date <- as.Date(tmp$Date, format = "%d/%m/%Y")
datetime <- paste(as.Date(tmp$Date), tmp$Time)
tmp$Datetime <- as.POSIXct(datetime)

png("plot3.png",height = 480, width = 480)

##Plot #3

with(tmp, {
        plot(tmp$Sub_metering_1 ~ tmp$Datetime, type = "l" , ylab = "Energy sub metering", xlab = "")
        lines(tmp$Sub_metering_2 ~ tmp$Datetime, col = "red")
        lines(tmp$Sub_metering_3 ~ tmp$Datetime, col = "blue")
})

legend("topright", col=c("black", "red", "blue"), lty=1, lwd=1, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()