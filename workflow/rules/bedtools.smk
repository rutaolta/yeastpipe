rule bedtools_sort:
    input:
        out_gff_merged_dir_path / "{sample}.gff"
    output:
        out_gff_merged_dir_path / "{sample}.gff"
    # log:
    #     log_dir_path / "bedtools.log"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "bedtools sort -i {out_gff_merged_dir_path}/{wildcards.sample}.gff 2>&1"

rule bedtools:
    input:
        samples_dir_path / "{sample}.fasta",
        out_gff_merged_dir_path / "{sample}.gff"
    output:
        out_bedtools_dir_path / "{sample}.fasta"
    # log:
    #     log_dir_path / "bedtools.log"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "bedtools maskfasta -fi {samples_dir_path}/{wildcards.sample}.fasta -bed {out_gff_merged_dir_path}/{wildcards.sample}.gff -fo {out_bedtools_dir_path}/{wildcards.sample}.fasta -soft 2>&1"
