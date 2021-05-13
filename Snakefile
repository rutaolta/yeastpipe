import pandas as pd
from snakemake.utils import validate, min_version
from pathlib import Path
from os import walk
from os.path import splitext

##### set minimum snakemake version #####
min_version("5.24.1")

##### setup config #####
configfile: "config/default.yaml"

reference_dir_path = Path(config["reference_dir"])
samples_dir_path = Path(config["samples_dir"])
samples_splitted_dir_path = Path(config["samples_splitted_dir"])

out_trf_dir_path = Path(config["out_trf_dir"])
out_wm_dir_path = Path(config["out_wm_dir"])
out_rm_dir_path = Path(config["out_rm_dir"])

out_gff_trf_dir_path = Path(config["out_gff_trf_dir"])
out_gff_wm_dir_path = Path(config["out_gff_wm_dir"])
out_gff_rm_dir_path = Path(config["out_gff_rm_dir"])
out_gff_merged_dir_path = Path(config["out_gff_merged_dir"])
out_bedtools_dir_path = Path(config["out_bedtools_dir"])
out_lastdbal_dir_path = Path(config["out_lastdbal_dir"])

log_dir_path = Path(config["log_dir"])
scripts_dir_path = str(config["scripts_dir"])

def get_scaffolds(mypath):
    _, _, filenames = next(walk(mypath))
    return [splitext(filename)[0] for filename in filenames if filename.endswith('.fasta')]

# if "sample_list" not in config:
#    config["sample_list"] = [d.name for d in sample_dir_path.iterdir() if d.is_dir()]

# reference id links
# RIDS, = glob_wildcards(samples_dir_path / "{rid}.fasta").rid

# scaffold id links
# IDS, = glob_wildcards(reference_splitted_dir_path / "{rid}/{id}.fasta").id
# IDS = ['chrI', 'chrmt']

SAMPLES = get_scaffolds(samples_dir_path)
# print(SAMPLES)

##### target rules #####
# localrules: all

rule all:
    input:
        log_dir_path,
        samples_splitted_dir_path / "scaffold_list.txt",
        expand(out_gff_trf_dir_path / "{sample}.gff", sample=SAMPLES)
        dynamic(expand(samples_splitted_dir_path / "{sample}.{scaffold}.fasta", sample=SAMPLES))
        expand(out_gff_wm_dir_path / "{sample}.gff", sample=SAMPLES),
        expand(out_gff_rm_dir_path / "{sample}.gff", sample=SAMPLES),
        expand(out_gff_merged_dir_path / "{sample}.gff", sample=SAMPLES),
        expand(out_bedtools_dir_path / "{sample}.fasta", sample=SAMPLES),
        expand(out_lastdbal_dir_path / "{sample}.R11.maf", sample=SAMPLES),
        expand(out_lastdbal_dir_path / "{sample}.R11.tab", sample=SAMPLES)

#### load rules #####
include: "workflow/rules/split_fasta.smk"
include: "workflow/rules/trf.smk"
include: "workflow/rules/windowmasker.smk"
include: "workflow/rules/repeatmasker.smk"
include: "workflow/rules/merge_gff.smk"
include: "workflow/rules/bedtools.smk"
include: "workflow/rules/lastdbal.smk"