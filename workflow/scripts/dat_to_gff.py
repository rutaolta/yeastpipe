import re
import dataclasses
import os
import sys
import shutil

# logging
sys.stderr = open(snakemake.log[0], "w")

for root, dirs, files in os.walk(snakemake.input.datdir):
  for file in files:
    if re.match('chr.*.dat$', file):
        chr = re.search(r"^(.*?)\..*", file).group(1)
        pos_seqs = open(file).read().split("Parameters: ")[1].split("\n")

        with open(os.path.dirname(snakemake.output[0]) + "/" + f'{chr}.gff', 'a') as f:
            for ps in pos_seqs[3:-1]:
                data = ps.split(" ")
                f.write(f'{chr}\ttrf\trepeat\t{data[0]}\t{data[1]}\t.\t.\t.\t{pos_seqs[0]}; period={data[2]}; num_copies={data[3]}; align_score={data[7]}; cons_seq={data[13]}\n')
