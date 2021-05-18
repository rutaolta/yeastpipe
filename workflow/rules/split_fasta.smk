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
    resources:
        cpus=config["split_fasta_threads"],
        time=config["split_fasta_time"],
        mem=config["split_fasta_mem_mb"]
    threads: 
        config["split_fasta_threads"]
    shell:
        "python workflow/scripts/split_fasta.py -i {input} -o {output} 2>&1"