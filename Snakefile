import pandas as pd
from snakemake.utils import validate, min_version
from pathlib import Path

##### set minimum snakemake version #####
min_version("5.24.1")

config: "config/default.yaml"

reference_dir_path = Path(config["reference_dir"])
reference_splitted_dir_path = Path(config["reference_splitted_dir"])
sample_dir_path = Path(config["sample_dir"])
out_dir_path = Path(config["out_dir"])
out_trf_dir_path = Path(config["out_trf_dir"])
out_gff_dir_path = Path(config["out_gff_dir"])
out_wm_dir_path = Path(config["out_wm_dir"])
out_wm_counts_dir_path = Path(config["out_wm_counts_dir"])
out_repeatmasker_dir_path = Path(config["out_repeatmasker_dir"])
log_dir_path = Path(config["log_dir"])
scripts_dir_path = str(config["scripts_dir"])

#if "sample_list" not in config:
#    config["sample_list"] = [d.name for d in sample_dir_path.iterdir() if d.is_dir()]

# localrules: all
IDS, = glob_wildcards(reference_splitted_dir_path / "{id}.fasta")

rule all:
    input:
        log_dir_path,
        reference_splitted_dir_path / "file_list.txt",
        expand(out_trf_dir_path / "{id}.dat", id=IDS),
        expand(out_gff_dir_path / "{id}.gff", id=IDS),
        expand(out_wm_counts_dir_path / "{id}.counts", id=IDS),
        expand(out_wm_dir_path / "{id}.windowmasker", id=IDS),
        out_repeatmasker_dir_path / "file_list.txt"

#### load rules #####

include: "workflow/rules/split_fasta.smk"
include: "workflow/rules/trf.smk"
include: "workflow/rules/gff.smk"
include: "workflow/rules/wm_counts.smk"
include: "workflow/rules/wm_windowmasker.smk"
include: "workflow/rules/repeatmasker.smk"