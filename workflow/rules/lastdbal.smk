rule lastdb:
    input:
        out_bedtools_dir_path / "{sample}.fasta"
    output:
        temp(directory(out_lastdbal_dir_path / "{sample}"))
    log:
        std=log_dir_path / "{sample}.lastdb.log",
        cluster_log=cluster_log_dir_path / "{sample}.lastdb.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.lastdb.cluster.err"
#    conda:
#        "workflow/envs/conda.yaml"
    params:
        prefix="YASS.R11.soft"
    resources:
        cpus=config["lastdb_threads"],
        time=config["lastdb_time"],
        mem=config["lastdb_mem_mb"]
    threads: 
        config["lastdb_threads"]
    shell:
        "mkdir {output}; lastdb -c -R11 -P {threads} -u YASS {output}/{params.prefix} {input} 2>&1"

rule lastal:
    input:
        lastdb=directory(out_lastdbal_dir_path / "{sample}")
    output:
        maf=temp(out_lastdbal_dir_path / "{sample}.R11.maf"),
        tab=temp(out_lastdbal_dir_path / "{sample}.R11.tab")
    params:
        ref=config["reference"],
        prefix="YASS.R11.soft"
    log:
        std=log_dir_path / "{sample}.lastal.log",
        cluster_log=cluster_log_dir_path / "{sample}.lastal.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.lastal.cluster.err"
#    conda:
#        "workflow/envs/conda.yaml"
    resources:
        cpus=config["lastal_threads"],
        time=config["lastal_time"],
        mem=config["lastal_mem_mb"]
    threads: 
        config["lastal_threads"]
    shell:
        "lastal -P {threads} -R11 -f MAF -i 4G {input.lastdb}/{params.prefix} {params.ref} | tee {output.maf} | maf-convert tab > {output.tab} 2>&1"

rule last_tar:
    input:
        maf=out_lastdbal_dir_path / "{sample}.R11.maf",
        tab=out_lastdbal_dir_path / "{sample}.R11.tab"
    output:
        maf_tar=out_lastdbal_dir_path / "{sample}.R11.maf.tar.gz",
        tab_tar=out_lastdbal_dir_path / "{sample}.R11.tab.tar.gz"
    resources:
        cpus=config["last_tar_threads"],
        time=config["last_tar_time"],
        mem=config["last_tar_mem_mb"]
    threads: 
        config["last_tar_threads"]
    shell:
        "tar -czvf {output.maf_tar} {input.maf} && rm {input.maf}; "
        "tar -czvf {output.tab_tar} {input.tab} && rm {input.tab}"