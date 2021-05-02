import re
import dataclasses
import os
import sys
import shutil

# logging
sys.stderr = open(snakemake.log[0], "w")

input = os.path.dirname(snakemake.input[0])
output = os.path.dirname(snakemake.output[0])

# input = 'results/windowmasker/'
# output = 'results/gff/windowmasker/'

for root, dirs, files in os.walk(input):
  for file in files:
    if re.match('.*.windowmasker$', file):
      scaffold = re.search(r"^(.*?)\..*", file).group(1)
      pos_seqs = open(input + "/" + file).read().split("\n")

      with open(output + "/" + f'{scaffold}.gff', 'a') as f:
          for ps in pos_seqs[1:-1]:
              data = re.search(r'(.*) - (.*)', ps)
              f.write(f'{scaffold}\twindowmasker\trepeat\t{data.group(1)}\t{data.group(2)}\t.\t.\t.\t.\n')
