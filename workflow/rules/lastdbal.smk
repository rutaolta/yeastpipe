rule lastdb:
    input:
        out_bedtools_dir_path / "{sample}.fasta"
    output:
        temp(out_lastdbal_dir_path / "{sample}.YASS.R11.soft")
    log:
        std=log_dir_path / "{sample}.lastdb.log",
        cluster_log=cluster_log_dir_path / "{sample}.lastdb.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.lastdb.cluster.err"
#    conda:
#        "workflow/envs/conda.yaml"
    threads: 16
    shell:
        "lastdb -c -R11 -P {threads} -u YASS {output} {input} 2>&1"

rule lastal:
    input:
        lastdb=out_lastdbal_dir_path / "{sample}.YASS.R11.soft"
    output:
        maf=out_lastdbal_dir_path / "{sample}.R11.maf",
        tab=out_lastdbal_dir_path / "{sample}.R11.tab"
    params:
        ref=config["reference"]
    log:
        std=log_dir_path / "{sample}.lastal.log",
        cluster_log=cluster_log_dir_path / "{sample}.lastal.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.lastal.cluster.err"
#    conda:
#        "workflow/envs/conda.yaml"
    threads: 16
    shell:
        "lastal -P {threads} -R11 -f MAF -i 4G {input.lastdb} {params.ref} | tee {output.maf} | maf-convert tab > {output.tab} 2>&1"
