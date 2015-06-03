##PLOTTING RESULTS FROM MULTIPLE SPECIES (on JeanLuc)

setwd("~/Copy/TAXON/results/combine")

table <- read.csv(file="REpipeResults.csv")

#create total read column
rawdata <- transform(rawdata, totalreads = mappedreads + unmappedreads)
#create nuclear reads column (remove organellar)
rawdata <- transform(rawdata, nucreads = totalreads - orgreads)

#plotting
attach(table)
plot(totalreads, contigs)
plot(totalreads, repeatreads)
