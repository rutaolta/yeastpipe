rule split_fasta:
    input:
        reference_dir_path / "S288C_reference_2015.fasta"
    output:
        reference_splitted_dir_path / "file_list.txt"
    log:
        log_dir_path / "split_fasta.log"
    # conda:
    #     "../envs/conda.yaml"
    script:
        "../scripts/split_fasta.py"