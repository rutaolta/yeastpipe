rule trf:
    input:
        ref=sample_dir_path / "S288C_reference_2015.fasta"
    log:
        log_dir_path / "trf.log"
    conda:
        "../../../%s" % config["conda_config"]
    shell:
        "trf {input.ref} 2 7 7 80 10 50 2000 -l 10"