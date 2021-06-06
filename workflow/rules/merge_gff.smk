# import trf, windowmasker, repeatmasker

rule merge_gff:
    input:
        trf=out_gff_trf_dir_path / "{sample}.gff",
        wm=out_gff_wm_dir_path / "{sample}.gff",
        rm=out_gff_rm_dir_path / "{sample}.gff"
        # trf=trf.rules.trf_gff.output,
        # wm=windowmasker.rules.wm_gff.output,
        # rm=repeatmasker.rules.rm_gff.output
    output:
        out_gff_merged_dir_path / "{sample}.gff"
    log:
        std=log_dir_path / "{sample}.merge_gff.log",
        cluster_log=cluster_log_dir_path / "{sample}.merge_gff.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.merge_gff.cluster.err"
    # conda:
    #    "../envs/conda.yaml"
    resources:
        cpus=config["merge_gff_threads"],
        time=config["merge_gff_time"],
        mem=config["merge_gff_mem_mb"]
    threads: 
        config["merge_gff_threads"]
    shell:
        "cat {input.trf} {input.wm} {input.rm} > {output}"
# https://snakemake.readthedocs.io/en/stable/project_info/faq.html#can-the-output-of-a-rule-be-a-symlink
