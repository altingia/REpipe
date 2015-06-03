REpipe: A workflow for assessing TEs from low-coverage genomic sequence data
=====

* low-coverage, anonymous, next-generation Illumina data using local desktop and [Stampede](https://portal.tacc.utexas.edu/home).

Description of files:
* `dataTransfer/`: reminders for data transfer to/from Stampede
* `qc/`: taxon and data specific customized scripts for quality control of onion sequences
* `masurca.slurm`: runs assembly for all taxa in `taxa.lst` in sequential order
* `launchRepipe.slurm`: batch file for running `REpipeline.slurm` for scripts described in `REscripts`
* `troubleshooting/`: separate scripts for REpipeline and masurca for different parameter settings (prelim analyses; not necessary to run now)
* `table.sh`: pulls files from Stampede to local desktop, sets up file structure for parsing results from analyses
* `joinplot.R`: join individual species files, summarize data, plot results

**Workflow**

From raw reads:
* FastQC
* Trim and filter
* FastQC

From filtered reads:
* Assemble with brute-force algorithm (MaSuRCA, VELVET, other?)
* Assemble with TE-specific method
* graph-based quantification (RepeatExplorer)

From assemblies (genomes or transcriptomes):
* mineprep.sh: prepare fasta files for analysis and run RepeatMasker
* mineREPEAT.sh: parse results by repeat type (SINE, LINE, copia, gypsy), filter for length (SINE 100, all others 2000), extract sequences, put in correct orientation
* mineRT.sh: runs RPS-BLAST against RTV_1, RTV_2, RT_nLTR_like, extracts results for each, creates fasta file with sequences in correct orientation
* mineINT.sh: runs RPS-BLAST against rve, creates fasta file with sequences in correct orientation
* cdhitest.sh: cluster each species individually, then pool: maintain maximum diversity in each taxon
* compile selected sequences from multiple species, translate to protein, align to muscle
* minetree.sh: combine sequences of same type from different species, align with mafft, build tree wiht RAxML

**Domains of interest**
* RVT_2 (PF07727) - reverse transcriptase core domain that picks up Copia (and thus Sireviruses as well)
* RVT_1 (PF00078) - reverse transcriptase core domain that picks up Gypsy
* rve (PF00665) - the integrase core domain that works for both Copia/Gypsy

**All domains**
CDD PSSM_ID annotation

RT
* pfam07727 gnl|CDD|219537 RVT_2
* pfam00078 gnl|CDD|215698 RVT_1
* cd00304 gnl|CDD|238185 RT_like
* cd01647 gnl|CDD|238825 RT-LTR
* cd01650 gnl|CDD|238827 RT_nLTR_like

INT
* pfam00665 gnl|CDD|216050 rve

Tase

GAG

RH
* cd00304
	* cd01647
	* cd06150
	
* cl06662
	* pfam07727
	
* pfam00078 (no assigned taxonomy)
