rule trf:
    input:
        sample_dir_path / "{sample_id}.txt",
    output:
        directory(trf_dir_path / "{sample_id}")
    log:
        std=log_dir_path / "{sample_id}/trf.log"
    conda:
        "../../../%s" % config["conda_config"]
    resources:
        cpus=config["trf_threads"],
        time=config["trf_time"],
        mem=config["trf_mem_mb"]
    threads:
        config["trf_threads"]
    shell:
        "trf {input} 2 7 7 80 10 50 500 -f -d -m"