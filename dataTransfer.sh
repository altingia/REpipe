##notes on data transfer to/from Stampede
#stampede as ssh alias
#specify taxon on which to operate as $1

DATA=~/Copy/$1/data

cd $DATA

#put fastq files in $WORK on Stampede
sftp stampede
put */*trim.fastq.gz /work/03177/hertweck/taxon_data

#pull tarball for each species from $HOME on Stampede
tar files on stampede (in home directory)
for x in `cat $1.lst`
	do
		tar -cvzf $x.tar.gz $x/
#done

scp stampede:~/*.tar.gz .

