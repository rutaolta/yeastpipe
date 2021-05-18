rule split_fasta:
    input:
        expand(samples_dir_path / "{sample}.fasta", sample=SAMPLES)
    output:
        samples_splitted_dir_path / "scaffold_list.txt"
    log:
        std=log_dir_path / "split_fasta.log",
        cluster_log=cluster_log_dir_path / "split_fasta.cluster.log",
        cluster_err=cluster_log_dir_path / "split_fasta.cluster.err"
    # conda:
    #     "../envs/conda.yaml"
    shell:
        "python workflow/scripts/split_fasta.py -i {input} -o {output} 2>&1"