#!/usr/bin/Rscript

##CLEANING AND JOINING REpipeline.sh RESULTS FROM MULTIPLE SPECIES (on JeanLuc)

setwd("~/Copy/TAXON/results/combine")

#import species list
species <- read.csv(file="taxa.lst", header=FALSE)

#import all parsed REpipeline  files
filelist <- list.files(path=".", pattern=".table")
for (i in 1:length(filelist)){
  assign(filelist[i], 
         read.csv(paste(filelist[i]), , sep='', header=FALSE, row.names=1)
  )}

#merge files together
rawdata <- do.call(cbind, mget(filelist, envir=.GlobalEnv))
#add column names
colnames(rawdata) <- sort(species$V1, method = "shell")
#reorient
rawdata <- as.data.frame(t(rawdata))
write.csv(rawdata, file="REpipeResults.csv")

