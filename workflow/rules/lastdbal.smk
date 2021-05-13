rule lastdb:
    input:
        out_bedtools_dir_path / "{sample}.fasta"
    output:
        temp(out_wm_dir_path / "counts/{sample}.counts")
    # log:
    #     log_dir_path / "windowmasker.{sample}.log"
#    conda:
#        "workflow/envs/conda.yaml"
    threads: 8
    shell:
        "lastdb -c -R11 -P {threads} -u YASS -R11 {wildcards.sample}.YASS.R11.soft {out_bedtools_dir_path}/{wildcards.sample}.fasta 2>&1"
        # lastdb -c -R11 -P 8 -u YASS -R11 results/bedtools/octosporus.fasta

rule lastal:
    input:
        out_bedtools_dir_path / "{sample}.fasta"
    output:
        out_lastdbal_dir_path / "{sample}.R11.maf",
        out_lastdbal_dir_path / "{sample}.R11.tab"
    # log:
    #     log_dir_path / "windowmasker.log"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "lastal -P 15 -R11 -f MAF -i 4G {wildcards.sample}.YASS.R11.soft {out_bedtools_dir_path}/{wildcards.sample}.fasta | tee {wildcards.sample}.R11.maf | maf-convert tab > {wildcards.sample}.R11.tab 2>&1"
