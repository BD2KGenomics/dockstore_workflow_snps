# dockstore_workflow_snps

This repository contains CWL files needed to run four SNP callers in a single workflow, named snp_callers_workflow.cwl  
This workflow is available on [Dockstore](https://dockstore.org) as `dockstore_workflow_snps`

## Inputs

Input to the workflow is a JSON format file (see `example.json`) with paths to the following:

- A genome in fasta format with a samtools index (`.fai`) _and_ a GATK `.dict` file (see below) in the same directory
- A tumor sample in bam format with a samtools index (`.bai`) in the same directory
- A normal sample _from the same patient_ in bam format with a samtools index (`.bai`) in the same directory
- A bed format file with the centromere locations of the genome. `hg38.centromere.bed` contains centromeres for hg38/GRCh38
- A [Cosmic](https://cancer.sanger.ac.uk/cosmic/) vcf format file with known cancer mutations, with a tabix index (`.tbi`), see below
- A dbSNP vcf format file, with a tabix index. See for example ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/common_all_20170710.vcf.gz
- The outputfile, which will be in `.tgz` format

### .dict
To create a `.dict` file, install [picard-tools](https://broadinstitute.github.io/picard/) and run
```
java -jar picard.jar CreateSequenceDictionary REFERENCE=<my_genome>.fa OUTPUT=<my_genome>.dict
```
**Note** that while `.fai` and `.bai` extensions are appended to the original filename (`normal.bam.bai`), the `.dict` extension _replaces_ the `.fa` extension.  
**Warning** make sure you do not have other periods in the genome filename, the workflow currently cannot find the `.dict` file if you do.

### .tbi
To create `.tbi` files, first use `bgzip` to compress your file (you may have to `gunzip` first), then run
```
tabix -p vcf cosmic.vcf.gz
```
**Note** that you can download a `.tbi` file directly from the NCBI ftp site for the dbSNP vcf file.

## Outputs

Output will be tarred, gzipped, and copied to the path you listed in your JSON file. It will unpack into the following files:
`muse.filtered.vcf`  
`mutect.vcf`  
`somatic_sniper.vcf`  
`pindel.vcf`

## Run

Providing you have dockstore and docker installed on your system, run
```
dockstore workflow launch --entry github.com/BD2KGenomics/dockstore_workflow_snps:master --json my.json
```
**NOTE**: This may take more than a day. Use as many processors as possible to speed up the run, and avoid having unnecessary sequences in your genome fasta (chrUn, chr_random).

## Details

The workflow calls docker containers maintained by [opengenomics](https://github.com/OpenGenomics) and hosted on [Dockerhub](https://hub.docker.com/).  
More information about the individual tools can be found by clicking on these links:  
[MuSE](http://bioinformatics.mdanderson.org/Software/MuSE/)  
[MuTect](http://archive.broadinstitute.org/cancer/cga/mutect)  
[SomaticSniper](http://gmt.genome.wustl.edu/packages/somatic-sniper/)  
[Pindel](https://github.com/genome/pindel)
