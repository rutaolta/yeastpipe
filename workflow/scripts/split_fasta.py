import sys
from os.path import basename, splitext, dirname
from os import mkdir
import argparse

""" 
function splits given input fasta into separate files by scaffolds.
returns the output file with resulting scaffolds list in format <{sample} : {scaffold}>
and splitted .fasta files
"""
def split_fasta(input, output):
    output_dir = dirname(output)
    sample_name = splitext(basename(input))[0]

    file=open(input).read()
    try:
        mkdir(output_dir)
    except FileExistsError:
        pass

    seq_iter = map(lambda seq: seq.split("\n", 1), file.split(">"))
    next(seq_iter)

    with open(output, 'a') as res:
        while True:
            try:
                seq = next(seq_iter)
                scaffold = seq[0].split(" ", 1)[0]
                filename = f'{output_dir}/{sample_name}.{scaffold}.fasta'
                with open(filename, 'a') as f:
                    f.write(f'>{scaffold}\n{seq[1]}')
                    res.write(f'{sample_name} : {scaffold}\n')
            except StopIteration:
                break

# logging
# sys.stderr = open(snakemake.log[0], "w")

# parsing args
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", nargs='+', required=True, help="Sample file .fasta")
parser.add_argument("-o", "--output", required=True, help="File with list of scaffold names .txt")

args = parser.parse_args()

infilepath = args.input
outfilepath = args.output

# call spliting function for given input fasta-files
for input in infilepath:
    split_fasta(input, outfilepath)


# /mnt/tank/scratch/ayakupova/miniconda3/bin/python /nfs/home/ayakupova/yeastpipe/workflow/scripts/split_fasta.py -i samples/japonicus.fasta samples/cerevisiae.fasta samples/octosporus.fasta -o samples/splitted/scaffold_list.txt