rule trf:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS),
        dir=out_repeatmasker_dir_path
    output:
        out_repeatmasker_dir_path / "file_list.txt"
    log:
        log_dir_path / "repeatmasker.log"
    # conda:
    #    "../envs/conda.yaml"
    run:
        for f in IDS:
            shell("RepeatMasker -pa 8 -species 'Saccharomyces cerevisiae' -dir {input.dir} {reference_splitted_dir_path}/{f}.fasta > {log} 2>&1")
