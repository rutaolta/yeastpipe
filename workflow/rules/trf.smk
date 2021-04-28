rule trf:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS)
    output:
        expand(out_trf_dir_path / "{id}.dat", id=IDS)
    log:
        log_dir_path / "trf.log"
    # conda:
    #    "../envs/conda.yaml"
    run:
        for f in IDS:
            shell("trf {reference_splitted_dir_path}/{f}.fasta 2 7 7 80 10 50 2000 -l 10 -d -h 1> {out_trf_dir_path}/{f}.dat 2> {log}")
