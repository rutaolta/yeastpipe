import re
import sys
import os

# logging
sys.stderr = open(snakemake.log[0], "w")

file=open(snakemake.input[0]).read()
sequences = file.split(">")

with open(snakemake.output[0], 'a') as fres:
    pattern = r"^chr[IVXmt]+"
    for seq in sequences[1:]:
        chr = re.search(pattern, seq).group()
        filename = os.path.dirname(snakemake.output[0]) + "/" + f'{chr}.fasta'
        with open(filename, 'a') as f:
            f.write(f'>{seq}')
            fres.write(f'{filename}\n')
