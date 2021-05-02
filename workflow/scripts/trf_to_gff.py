import re
import dataclasses
import os
import sys
import shutil

# logging
sys.stderr = open(snakemake.log[0], "w")

input = os.path.dirname(snakemake.input[0])
output = os.path.dirname(snakemake.output[0])

# input = 'results/trf/'
# output = 'results/gff/trf/'

for root, dirs, files in os.walk(input):
  for file in files:
    print(file)
    if re.match('.*.dat$', file):
      scaffold = re.search(r"^(.*?)\..*", file).group(1)
      pos_seqs = open(input + "/" + file).read().split("Parameters: ")[1].split("\n")

      with open(output + "/" + f'{scaffold}.gff', 'a') as f:
          for ps in pos_seqs[3:-1]:
              data = ps.split(" ")
              f.write(f'{scaffold}\ttrf\trepeat\t{data[0]}\t{data[1]}\t.\t.\t.\t{pos_seqs[0]}; period={data[2]}; num_copies={data[3]}; align_score={data[7]}; cons_seq={data[13]}\n')
