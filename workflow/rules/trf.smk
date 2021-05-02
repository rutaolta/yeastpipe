rule trf:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS)
    output:
        temp(expand(out_trf_dir_path / "{id}.dat", id=IDS))
    log:
        log_dir_path / "trf.log"
    # conda:
    #    "../envs/conda.yaml"
    run:
        for f in IDS:
            shell("cd {out_trf_dir_path}/; trf ../../{reference_splitted_dir_path}/{f}.fasta 2 7 7 80 10 50 2000 -l 10 -d -h > ../../{log} 2>&1")
            shell("cd {out_trf_dir_path}/; mv {f}.fasta.2.7.7.80.10.50.2000.dat {f}.dat")

rule trf_gff:
    input:
        expand(out_trf_dir_path / "{id}.dat", id=IDS)
    output:
        expand(out_gff_trf_dir_path / "{id}.gff", id=IDS)
    log:
        log_dir_path / "trf.log"
    # conda:
    #     "../envs/conda.yaml"
    script:
        "../scripts/trf_to_gff.py"