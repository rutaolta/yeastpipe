from pathlib import Path

reference_path = Path(config["reference_dir"])
sample_dir_path = Path(config["sample_dir"])
out_dir_path = Path(config["out_dir"])
out_trf_dir_path = Path(config["out_trf_dir"])
log_dir_path = Path(config["log_dir"])

if "sample_list" not in config:
    config["sample_list"] = [d.name for d in sample_dir_path.iterdir() if d.is_dir()]

rule all:
    input:
        reference_path,
        sample_dir_path,
        out_dir_path,
        out_trf_dir_path,
        log_dir_path

include: "workflow/rules/trf/trf.smk"