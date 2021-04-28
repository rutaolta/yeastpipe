rule gff:
    input:
        datdir=out_trf_dir_path
    output:
        expand(out_gff_dir_path / "{id}.gff", id=IDS)
    log:
        log_dir_path / "split_fasta.log"
    # conda:
    #     "../envs/conda.yaml"
    script:
        "../scripts/dat_to_gff.py"