rule wm_counts:
    input:
        samples_dir_path / "{sample}.fasta"
    output:
        temp(out_wm_dir_path / "counts/{sample}.counts")
    # log:
    #     log_dir_path / "windowmasker.{sample}.log"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "windowmasker -mk_counts -in {samples_dir_path}/{wildcards.sample}.fasta -out {out_wm_dir_path}/counts/{wildcards.sample}.counts -infmt fasta -sformat obinary 2>&1"

rule wm_windowmasker:
    input:
        samples=samples_dir_path / "{sample}.fasta",
        counts=out_wm_dir_path / "counts/{sample}.counts"
    output:
        temp(out_wm_dir_path / "{sample}.windowmasker")
    # log:
    #     log_dir_path / "windowmasker.log"
#    conda:
#        "workflow/envs/conda.yaml"
    shell:
        "windowmasker -ustat {out_wm_dir_path}/counts/{wildcards.sample}.counts -in {samples_dir_path}/{wildcards.sample}.fasta -out {out_wm_dir_path}/{wildcards.sample}.windowmasker -infmt fasta -outfmt interval 2>&1"

rule wm_gff:
    input:
        out_wm_dir_path / "{sample}.windowmasker"
    output:
        out_gff_wm_dir_path / "{sample}.gff"
    params:
        inpdir = out_wm_dir_path,
        outdir = out_gff_wm_dir_path
    # log:
    #     log_dir_path / "windowmasker.log"
    # conda:
    #     "../envs/conda.yaml"
    script:
        "../scripts/wm_to_gff.py -i {params.inpdir}/{wildcards.sample}.windowmasker -o {params.outdir}/{wildcards.sample}.gff" #-sm {wildcards.sample}
