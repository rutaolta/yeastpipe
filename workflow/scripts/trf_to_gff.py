import re
import sys
import argparse

# logging
# sys.stderr = open(snakemake.log[0], "w")

'''
function transforms TRF results in dat-format into gff-format and 
merges all scaffolds into one .gff-file for each sample.
'''
def trf_to_gff(input, output, samples, scaffolds):
    for _ in scaffolds:
        sample = re.findall(r"(?=("+'|'.join(samples)+r"))", _)[0]
        scaffold = _.replace(f'{sample}.', '')
        pos_seqs = open(f'{input}/{_}.dat').read().split(scaffold)[1].split("\n")
        
        with open(output + "/" + f'{sample}.gff', 'a') as f:
            for ps in pos_seqs[7:-1]:
                if ps == '':
                    break
                data = ps.split(" ")
                f.write(f'{scaffold}\ttrf\trepeat\t{data[0]}\t{data[1]}\t.\t.\t.\t{pos_seqs[4]}; period={data[2]}; num_copies={data[3]}; align_score={data[7]}; cons_seq={data[13]}\n')


# parsing args
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", required=True, help="dir for .dat files after TRF")
parser.add_argument("-o", "--output", required=True, help="output dir for .gff file")
parser.add_argument("-sm", "--samples", nargs='+', required=True, help="sample names")
parser.add_argument("-sc", "--scaffolds", nargs='+', required=True, help="scaffold names")

args = parser.parse_args()

infilepath = args.input
outfilepath = args.output
samples = args.samples
scaffolds = args.scaffolds

# call from .dat to .gff transormation function
trf_to_gff(infilepath, outfilepath, samples, scaffolds)