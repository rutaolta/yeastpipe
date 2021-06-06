rule plot_last_tab:
    input:
        wga_tab_file=out_lastdbal_dir_path / "{sample}.R11.tab.gz",
        query_genome_whitelist=samples_dir_path / "{sample}.whitelist.txt"
    output:
        "{sample}.txt"
    params:
        target_genome_whitelist=reference_dir_path / "ref.whitelist.txt"
    log:
        std=log_dir_path / "{sample}.plot_last_tab.log",
        cluster_log=cluster_log_dir_path / "{sample}.plot_last_tab.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}.plot_last_tab.cluster.err"
    # conda:
    #     "../envs/conda.yaml"
    resources:
        cpus=config["plot_last_tab_threads"],
        time=config["plot_last_tab_time"],
        mem=config["plot_last_tab_mem_mb"]
    threads:
        config["plot_last_tab_threads"]
    shell:
        # "python RouToolPa/setup.py install; "
        "python MAVR/scripts/wga/dotplot_from_last_tab.py "
        "-i {input.wga_tab_file} "
        "-o {wildcards.sample} "
        "-w {params.target_genome_whitelist} "
        "-x {input.query_genome_whitelist} "
        # "-s <query_syn_file> 2>&1"
        "; touch {output} "
