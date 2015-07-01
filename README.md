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
* domainPrep.sh: prepare fasta files for analysis and run RepeatMasker
* RT.sh: runs RPS-BLAST against RTV_1, RTV_2, RT_nLTR_like, extracts fasta, clusters results
* INT.sh: runs RPS-BLAST against rve, extracts fasta, clusters results
* domainTree.sh: align with mafft, build tree wiht RAxML

**Domains of interest**
* RVT_2 (PF07727) - reverse transcriptase core domain that picks up Copia (and thus Sireviruses as well)
* RVT_1 (PF00078) - reverse transcriptase core domain that picks up Gypsy
* rve (PF00665) - the integrase core domain that works for both Copia/Gypsy
