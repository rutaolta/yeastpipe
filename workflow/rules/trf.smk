import os

ruleorder: split_fasta > trf > trf_gff

checkpoint split_fasta:
    input:
        samples_dir_path / "{sample}.fasta"
    output:
        directory(samples_splitted_dir_path / "{sample}")
    log:
        std=log_dir_path / "{sample}.split_fasta.log",
        cluster_log=cluster_log_dir_path / "{sample}.split_fasta.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.split_fasta.cluster.err"
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

rule trf:
    input:
        samples_splitted_dir_path / "{sample}/{scaffold}.fasta"
    output:
        out_trf_dir_path / "{sample}/{scaffold}.dat"
    log:
        std=log_dir_path / "{sample}/{scaffold}.trf.log",
        cluster_log=cluster_log_dir_path / "{sample}/{scaffold}.trf.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}/{scaffold}.trf.cluster.err"
    # conda:
    #    "../envs/conda.yaml"
    resources:
        cpus=config["trf_threads"],
        time=config["trf_time"],
        mem=config["trf_mem_mb"]
    threads:
        config["trf_threads"]
    shell:
        "mkdir -p {out_trf_dir_path}/{wildcards.sample}; cd {out_trf_dir_path}/{wildcards.sample}; "
        "trf ../../splitted/{wildcards.sample}/{wildcards.scaffold}.fasta 2 7 7 80 10 50 2000 -l 10 -d -h; "
        "mv {wildcards.scaffold}.fasta.2.7.7.80.10.50.2000.dat {wildcards.scaffold}.dat"

def trf_gff_input(wildcards):
    checkpoint_output = checkpoints.split_fasta.get(**wildcards).output[0]
    return expand(out_trf_dir_path / "{sample}/{scaffold}.dat",
           sample=wildcards.sample,
           scaffold=glob_wildcards(os.path.join(checkpoint_output, "{scaffold}.fasta")).scaffold)

rule trf_gff:
    input:
        trf_gff_input
    output:
        out_gff_trf_dir_path / "{sample}.gff"
    log:
        std=log_dir_path / "{sample}.trf_gff.log",
        cluster_log=cluster_log_dir_path / "{sample}.trf_gff.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.trf_gff.cluster.err"
    # conda:
    #     "../envs/conda.yaml"
    resources:
        cpus=config["trf_gff_threads"],
        time=config["trf_gff_time"],
        mem=config["trf_gff_mem_mb"]
    threads:
        config["trf_gff_threads"]
    shell:
        "python workflow/scripts/trf_to_gff.py -i {input} -o {output} 2>&1"
