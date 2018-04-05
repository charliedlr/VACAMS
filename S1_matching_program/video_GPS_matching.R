####################################################################################
##  This script combines camera data (manually entered into datasheet.csv) and GPS data (downloaded as GPX, converted to TXT with GPSBabel, then cleaned up with regular expressions in Sublime Text.  
## Charlie de la Rosa and Katie Gostic -- August 2015 -- Alamos, Sonora, Mexico
#####################################################################################
rm(list = ls())
require('chron')

# upload video and GPS data
videos = read.csv('~/File/Source/video_datasheet.csv', stringsAsFactors = FALSE, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE) # import video master data sheet.  

gps.tracks = read.delim('~/File/Source/gps_data.csv', header = TRUE, sep = "\t", stringsAsFactors = FALSE) # import GPS data as a tab delimited file

## TIME CONVERSION 
vid.times = as.POSIXlt(paste(videos$Date, videos$Time, sep = ' '))
gps.times = as.POSIXlt(paste(gps.tracks$Date, gps.tracks$Time, sep = ' '))

# for Mountain Standard Time, i-GotU gps time stamps were offset by 7 hours (25200 seconds). Correction:
gps.times = gps.times - 25200

# initialze data frame for for loop output
# 5 columns pulled out of gps_data: latitude, longitude, elevation, speed (between points), number of satellites. time.gps and time.dif are the GPS point time data, and the difference between the minimum GPS and video date-and-time data.
lat = vector()
lon = vector()
elev = vector()
spd = vector()
sat = vector()
time.gps = vector()
time.dif = vector()

# For loop with matching algorithm
for (ii in 1:length(vid.times)){
  use.this.gps.row = which.min(abs(vid.times[ii] - gps.times)) # this gives the row number of the minimum value after subtracting all gps time values from a given video time; that is, the gps point closest in time to the video time stamp  
  time.gps[ii] = strftime(gps.times[use.this.gps.row], format = "%Y-%m-%d %H:%M:%S") # strftime specifies that it's time and sets format.
  lat[ii] = gps.tracks[use.this.gps.row, 2]
  lon[ii] = gps.tracks[use.this.gps.row, 3]
  alt[ii] = gps.tracks[use.this.gps.row, 4]
  spd[ii] = gps.tracks[use.this.gps.row, 5]
  sat[ii] = gps.tracks[use.this.gps.row, 6]
  time.dif[ii] = difftime(vid.times[ii], gps.times[use.this.gps.row], units = 'sec') # difftime allows you to figure out differences between time stamps and outputs in the units you want, here seconds.
} 

gps.info = data.frame(latitude = lat, longitude = lon, elevation = elev, speed.km.h = spd, sats = sat, vid.times = vid.times, nearest.time.gps = time.gps, time.dif.secs = time.dif) # data frame of all the objects together
#sats = sat,

videos = data.frame(videos, gps.info) # attach gps info to the videos master file

## Write a new file (change name each time)
write.csv(videos, file = '~/File/Source/video_with_GPS_data.csv')

###########################################################

