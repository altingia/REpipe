#!/bin/bash

## counts shared clusters
## usage: ./clusterSummary.sh TAXON CLUSTER.LST

RESULTS=~/Copy/$1/results
SCRIPTS=~/GitHub/REpipe

cd $RESULTS

## set up output file
echo -n > comparisons.lst
for y in `cat $2`
			do
				for z in `cat $2`
					do
						echo "$y $z" >> comparisons.lst
				done
		done

## summarize cluster data
for x in */*.combine.clust.out.clstr
	do
		echo -n > $x.count
		awk '{print $1" "$3}' $x | sed 's/\..*$//g' | cut -d " " -f 2 | uniq | sed s/\>// > $x.temp
		awk '{if ($0 =="") print ""; else printf "%s ",$0}END{print "";}' $x.temp > $x.temp2 
		for y in `cat $2`
			do
				for z in `cat $2`
					do
						echo "$y $z" >> $x.count
						grep -c -E "$y.*$z" $x.temp2 >> $x.count
				done
		done
		cat $x.count | paste -d " " - - | cut -d " " -f 3 > $x.lst
		paste comparisons.lst $x.lst > temp
		cp temp comparisons.lst
		rm $x.count $x.temp* temp
done

## finalize table
sed s/\ /,/ comparisons.lst | tr "\t" "," > domains/combineDomains.csv
