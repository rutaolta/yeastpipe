import pandas as pd
from snakemake.utils import validate, min_version
from pathlib import Path

##### set minimum snakemake version #####
min_version("5.24.1")

config: "config/default.yaml"

reference_dir_path = Path(config["reference_dir"])
reference_splitted_dir_path = Path(config["reference_splitted_dir"])

out_trf_dir_path = Path(config["out_trf_dir"])
out_wm_dir_path = Path(config["out_wm_dir"])
out_rm_dir_path = Path(config["out_rm_dir"])

out_gff_trf_dir_path = Path(config["out_gff_trf_dir"])
out_gff_wm_dir_path = Path(config["out_gff_wm_dir"])
out_gff_rm_dir_path = Path(config["out_gff_rm_dir"])
out_gff_merged_dir_path = Path(config["out_gff_merged_dir"])
out_bedtools_dir_path = Path(config["out_bedtools_dir"])

log_dir_path = Path(config["log_dir"])
scripts_dir_path = str(config["scripts_dir"])

#if "sample_list" not in config:
#    config["sample_list"] = [d.name for d in sample_dir_path.iterdir() if d.is_dir()]

IDS, = glob_wildcards(reference_splitted_dir_path / "{id}.fasta")
# IDS = ['chrI', 'chrmt']

localrules: all

rule all:
    input:
        log_dir_path,
        reference_splitted_dir_path / "file_list.txt",
        expand(out_gff_trf_dir_path / "{id}.gff", id=IDS),
        expand(out_gff_wm_dir_path / "{id}.gff", id=IDS),
        expand(out_gff_rm_dir_path / "{id}.gff", id=IDS),
        expand(out_gff_merged_dir_path / "{id}.gff", id=IDS),
        expand(out_bedtools_dir_path / "{id}.fasta.out", id=IDS)

#### load rules #####

include: "workflow/rules/split_fasta.smk"
include: "workflow/rules/trf.smk"
include: "workflow/rules/windowmasker.smk"
include: "workflow/rules/repeatmasker.smk"
include: "workflow/rules/merge_gff.smk"
include: "workflow/rules/bedtools.smk"