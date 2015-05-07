# Download data from solar panel
#
# Copyright (C) 2015 Simon Crase
#
# simon@greenweaves.nz
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

rm(list=ls())

if (!require(data.table)) {
  install.packages("data.table")
  library(data.table)
}

if (!require(chron)) {
  install.packages("chron")
  library(chron)
}

if(!file.exists("data"))
  dir.create("data")


download.daily<-function(url="http://192.168.1.2") {
  download.file(file.path(url,"log_daily.csv"),destfile="data/log_daily.csv",mode="wb")
  data=as.data.table(read.csv("data/log_daily.csv",skip=3,header=FALSE,sep="\t", skipNul=TRUE,strip.white=TRUE))
  data$Date<-as.Date(data$V1)
  data$V1=NULL
  setcolorder(data, c("Date", "V2", "V3"))
  setnames(data,names(data),c("Date","Power","Duration"))
  data
}

download.5min<-function(url="http://192.168.1.2") {
  download.file(file.path(url,"log_5min.csv"),destfile="data/log_5min.csv",mode="wb")
  data=as.data.table(read.csv("data/log_5min.csv",skip=3,header=FALSE,sep="\t", skipNul=TRUE,strip.white=TRUE))
  dtimes<-as.character(data$V1)
  dtparts <- t(as.data.frame(strsplit(dtimes,' ')))
  thetimes <- chron(dates=dtparts[,1],times=dtparts[,2],format=c('y-m-d','h:m:s'))
  data$Time <- thetimes
  data$V1=NULL
  setcolorder(data, c("Time", "V2"))
  setnames(data,names(data),c("Time","Power"))
  data
}

daily1<-download.daily()
daily1$Date<-as.character(daily1$Date)
tidy_file<-file.path("./data","tidied_daily_data.txt")

if (file.exists(tidy_file)) {
  daily2=data.table(read.table(tidy_file,header=TRUE))
  daily2$Date<-as.character(daily2$Date)
  write.table(unique(rbind(daily1,daily2)),tidy_file,row.names=FALSE)
} else
  write.table(daily1,tidy_file,row.names=FALSE)



detail1<-download.5min()
detail1$Time<-as.character(detail1$Time)
tidy_file<-file.path("./data","tidied_5min_data.txt")

if (file.exists(tidy_file)) {
  detail2<-data.table(read.table(tidy_file,header=TRUE))
  write.table(unique(rbind(detail1,detail2)),tidy_file,quote=TRUE,row.names=FALSE)
} else 
  write.table(detail1,tidy_file,quote=TRUE,row.names=FALSE)

