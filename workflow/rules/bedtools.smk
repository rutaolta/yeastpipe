rule bedtools_sort:
    input:
        out_gff_merged_dir_path / "{sample}.gff"
    output:
        out_gff_merged_dir_path / "{sample}.gff"
    log:
        std=log_dir_path / "{sample}.bedtools_sort.log",
        cluster_log=cluster_log_dir_path / "{sample}.bedtools_sort.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.bedtools_sort.cluster.err"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "bedtools sort -i {input} 2>&1"

rule bedtools:
    input:
        samples=samples_dir_path / "{sample}.fasta",
        gff=out_gff_merged_dir_path / "{sample}.gff"
    output:
        out_bedtools_dir_path / "{sample}.fasta"
    log:
        std=log_dir_path / "{sample}.bedtools.log",
        cluster_log=cluster_log_dir_path / "{sample}.bedtools.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.bedtools.cluster.err"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "bedtools maskfasta -fi {input.samples} -bed {input.gff} -fo {output} -soft 2>&1"
