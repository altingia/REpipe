#!/bin/bash

##Agave project QC and prep for analysis
#dependencies:
#	FastQC
#	prinseq-lite.pl

AGAVE=~/Copy/Agave/agave_data

#initial fastqc run
cd $AGAVE
#for x in `cat ~/GitHub/AgaveTE/agaveGSS.lst`
#	do
#		cd $x
#		fastqc *.fastq.gz
#		cd ..
#done

#Anemarrhena_asphodeloides
echo Anemarrhena_asphodeloides
cd Anemarrhena_asphodeloides
gzip -dc EL02-090922.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL02-090922.log -trim_left 4 -trim_qual_right 20 -min_len 30 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL02-090922trim.fastq.gz

gzip -dc EL03-090922.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL03-090922.log -trim_left 4 -trim_qual_right 20 -min_len 30 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL03-090922trim.fastq.gz

gzip -dc EL03-100511.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL03-100511.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL03-100511trim.fastq.gz

for x in *trim.fastq.gz
	do
		fastqc $x
done
cd ..

#Behnia_reticulata
echo Behnia_reticulata
cd Behnia_reticulata
gzip -dc EL113-100913.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL113-100913.log -trim_left 4 -trim_qual_right 20 -min_len 90 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL113-100913trim.fastq.gz
fastqc *trim.fastq.gz
cd ..

#Camassia_scilloides
echo Camassia_scilloides
cd Camassia_scilloides
gzip -dc EL05-090922.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL05-090922.log -trim_left 4 -trim_qual_right 20 -min_len 30 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL05-090922trim.fastq.gz

gzip -dc EL05-091102.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL05-091102.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL05-091102trim.fastq.gz

gzip -dc EL05-100511.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL05-100511.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL05-100511trim.fastq.gz

for x in *trim.fastq.gz
	do
		fastqc $x
done
cd ..

#Echeandia_sp
echo Echeandia_sp
cd Echeandia_sp
gzip -dc EL67-100302.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL67-100302.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL67-100302trim.fastq.gz
fastqc *trim.fastq.gz
cd ..

#Hosta_ventricosa
echo Hosta_ventricosa
cd Hosta_ventricosa
gzip -dc EL01-090922.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL01-090922.log -trim_left 4 -trim_qual_right 20 -min_len 30 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL01-090922trim.fastq.gz

gzip -dc EL01-100511.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL01-100511.log -trim_left 4 -trim_qual_right 20 -min_len 30 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL01-100511trim.fastq.gz

for x in *trim.fastq.gz
	do
		fastqc $x
done
cd ..

#Manfreda_virginica
echo Manfreda_virginica
cd Manfreda_virginica
gzip -dc EL69-100302.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL69-100302.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL69-100302trim.fastq.gz
fastqc *trim.fastq.gz
cd ..

#Polianthes_sp
echo Polianthes_sp
cd Polianthes_sp
gzip -dc EL34-100205.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL34-100205.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL34-100205trim.fastq.gz

gzip -dc EL34-100330.fastq.gz | prinseq-lite.pl -fastq stdin -phred64 -log EL34-100330.log -trim_left 4 -trim_qual_right 20 -min_len 60 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > EL34-100330trim.fastq.gz

for x in *trim.fastq.gz
	do
		fastqc $x
done
cd ..

#Schoenolirion_croceum
echo Schoenolirion_croceum
cd Schoenolirion_croceum
gzip -dc Schoenolirion_1a_ATCACG_L002_R1_001.fastq.gz | prinseq-lite.pl -fastq stdin -log Schoenolirion_1a.log -trim_left 4 -trim_qual_right 20 -min_len 80 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > Schoenolirion_1atrim.fastq.gz
fastqc *trim.fastq.gz
cd ..

#Yucca_brevifolia
echo Yucca_brevifolia
cd Yucca_brevifolia
gzip -dc Yuccabrevifolia_2_CGATGT_L002_R1_001.fastq.gz | prinseq-lite.pl -fastq stdin -log Yuccabrevifolia_2.log -trim_left 4 -trim_qual_right 20 -min_len 80 -min_qual_mean 20 -ns_max_n 3 -out_good stdout -out_bad null | gzip > Yuccabrevifolia_2trim.fastq.gz
fastqc *trim.fastq.gz
cd ..