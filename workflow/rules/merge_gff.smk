rule merge_gff:
    input:
        out_gff_trf_dir_path / "{sample}.gff",
        out_gff_wm_dir_path / "{sample}.gff",
        out_gff_rm_dir_path / "{sample}.gff"
    output:
        out_gff_merged_dir_path / "{sample}.gff"
    # log:
    #     log_dir_path / "merged.log"
    # conda:
    #    "../envs/conda.yaml"
    shell:
        "cat {out_gff_trf_dir_path}/{wildcards.sample}.gff {out_gff_wm_dir_path}/{wildcards.sample}.gff {out_gff_rm_dir_path}/{wildcards.sample}.gff > {out_gff_merged_dir_path}/{wildcards.sample}.gff"

# https://snakemake.readthedocs.io/en/stable/project_info/faq.html#can-the-output-of-a-rule-be-a-symlink