#!/usr/bin/Rscript

##CLEANING AND JOINING RESULTS FROM MULTIPLE SPECIES (on JeanLuc)

#import species list
species <- read.csv(list.files(path = ".", pattern = ".lst"), header=FALSE)

#import all parsed files
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
write.csv(rawdata, file="temp.csv", quote = FALSE)

