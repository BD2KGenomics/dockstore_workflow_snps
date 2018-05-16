#!/usr/bin/env cwl-runner
#
# Author: jeltje.van.baren@gmail.com

class: Workflow

cwlVersion: "v1.0"

doc: |
    A workflow for running MuSe, MuTect, SomaticSniper, and Pindel. See [the github repository](https://github.com/BD2KGenomics/dockstore_workflow_snps) for details.

requirements:
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement


inputs: 

  - id: NORMAL_BAM
    type: File
    secondaryFiles:
      - .bai
  - id: TUMOR_BAM
    type: File
    secondaryFiles:
      - .bai
  - id: COSMIC_VCF
    type: File
    secondaryFiles:
      - .tbi
  - id: DBSNP_VCF
    type: File
    secondaryFiles:
      - .tbi
  - id: CENTROMERE_BED
    type: File
  - id: CPUS
    type: int
  - id: MODE 
    type: string
  - id: GENO_FA
    type: File
    secondaryFiles:
      - .fai
      - ^.dict
    
outputs:

  OUTPUT:
    type: File
    outputSource: tar/tarredfile


steps:

  muse:
    run: ./muse.cwl
    in:
      mode: MODE
      reference: GENO_FA
      normal: NORMAL_BAM
      tumor: TUMOR_BAM
      known: DBSNP_VCF
      ncpus: CPUS
    out: [mutations]

  muse_filter:
    run: ./muse_filter.cwl
    in:
      vcf: muse/mutations
    out: [output_vcf]

  mutect:
    run: ./mutect.cwl
    in:
      reference: GENO_FA
      normal: NORMAL_BAM
      tumor: TUMOR_BAM
      dbsnp: DBSNP_VCF
      cosmic: COSMIC_VCF
      ncpus: CPUS
    out: [mutations]

  pindel:
    run: ./pindel.cwl
    in:
      reference: GENO_FA
      normal: NORMAL_BAM
      tumor: TUMOR_BAM
      procs: CPUS
      centromere: CENTROMERE_BED
    out: [somatic_vcf]

  somaticsniper:
    run: ./somatic_sniper.cwl
    in:
      reference: GENO_FA
      normal: NORMAL_BAM
      tumor: TUMOR_BAM
      procs: CPUS
    out: [mutations]

  tar:
    run: tar.cwl
    in:
      muse: muse_filter/output_vcf
      mutect: mutect/mutations
      pindel: pindel/somatic_vcf
      somsni: somaticsniper/mutations
      tarfile: 
        valueFrom: $('vcfs.tgz')
    out: [tarredfile]

