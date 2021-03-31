from pathlib import Path

out_dir_path = Path(config["out_dir"])
trf_dir_path = out_dir_path / config["trf_dir"]
sample_dir_path = Path(config["sample_dir"])
reference_path = Path(config["reference"])
reference_dir_path = reference_path.parent

if "sample_list" not in config:
    config["sample_list"] = [d.name for d in sample_dir_path.iterdir() if d.is_dir()]

rule all:
    input:
        expand(trf_dir_path / "{sample_id}.txt", sample_id=config["sample_list"] ),  

include: "workflow/rules/trf/trf.smk"