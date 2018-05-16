cwlVersion: v1.0
class: CommandLineTool


requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.muse)
      - $(inputs.mutect)
      - $(inputs.somsni)

baseCommand: [tar, 'zhcf']

inputs:
  tarfile:
    type: string
    inputBinding:
      position: 1
  mutect:
    type: File
    inputBinding:
      position: 2
      valueFrom: $(self.basename)
  muse:
    type: File
    inputBinding:
      position: 3
      valueFrom: $(self.basename)
  pindel:
    type: File
    inputBinding:
      position: 4
      valueFrom: $(self.basename)
  somsni:
    type: File
    inputBinding:
      position: 5
      valueFrom: $(self.basename)

outputs:
  tarredfile:
    type: File
    outputBinding:
      glob: $(inputs.tarfile)

