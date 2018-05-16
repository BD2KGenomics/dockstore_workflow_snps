cwlVersion: v1.0
class: CommandLineTool
label: MuTect
baseCommand: ["python", "/opt/mutect.py", "--workdir", "."]
requirements:
  - class: DockerRequirement
    dockerPull: opengenomics/mutect:latest
inputs:
  - id: tumor
    type: File
    inputBinding:
      prefix: --input_file:tumor
    secondaryFiles:
      - .bai
  - id: normal
    type: File
    inputBinding:
      prefix: --input_file:normal
    secondaryFiles:
      - .bai
  - id: reference
    type: File
    inputBinding:
      prefix: --reference_sequence
    secondaryFiles:
      - .fai
      - ^.dict
  - id: cosmic
    type: File
    inputBinding:
      prefix: --cosmic
    secondaryFiles: 
      - .tbi
  - id: dbsnp
    type: File
    inputBinding:
      prefix: --dbsnp
    secondaryFiles:
      - .tbi
  - id: tumor_lod
    type: float
    default: 6.3
    inputBinding:
      prefix: --tumor_lod
  - id: initial_tumor_lod
    type: float
    default: 4.0
    inputBinding:
      prefix: --initial_tumor_lod
  - id: out
    type: string
    default: mutect_call_stats.txt
    inputBinding:
      prefix: --out
  - id: coverage_file
    type: string
    default: mutect_coverage.wig.txt
    inputBinding:
      prefix: --coverage_file
  - id: vcf
    type: string
    default: mutect.vcf
    inputBinding:
      prefix: --vcf
  - id: ncpus
    type: int
    default: 8
    inputBinding:
      prefix: "--ncpus"

outputs:
  - id: coverage
    type: File
    outputBinding:
      glob: $(inputs.coverage_file)
  - id: call_stats
    type: File
    outputBinding:
      glob: $(inputs.out)
  - id: mutations
    type: File
    outputBinding:
      glob: $(inputs.vcf)
