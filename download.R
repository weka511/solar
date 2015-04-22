# Download ASX historical data
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

library(data.table)

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

download.5min<-function() {
  download.file("http://192.168.1.2/log_5min.csv",destfile="data/log_5min.csv",mode="wb")
  data=as.data.table(read.csv("data/log_5min.csv",skip=3,header=FALSE,sep="\t", skipNul=TRUE,strip.white=TRUE))
  data$Date<-as.Date(data$V1)
  setnames(data,names(data),c("DT","Power"))
  data
}
