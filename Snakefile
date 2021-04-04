from pathlib import Path

out_dir_path = Path(config["out_dir"])
trf_dir_path = out_dir_path / config["trf_dir"]
sample_dir_path = Path(config["sample_dir"])
log_dir_path = Path(config["log_dir"])

if "sample_list" not in config:
    config["sample_list"] = [d.name for d in sample_dir_path.iterdir() if d.is_dir()]

include: "workflow/rules/trf/trf.smk"