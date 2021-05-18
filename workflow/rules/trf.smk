# SCAFFOLDS = get_scaffolds(samples_splitted_dir_path)
# print(SCAFFOLDS)

SCAFFOLDS = get_scaffolds(samples_splitted_dir_path)

rule trf:
    input:
        samples_splitted_dir_path / "{scaffold}.fasta"
    output:
        out_trf_dir_path / "{scaffold}.dat"
    log:
        std=log_dir_path / "{scaffold}.trf.log",
        cluster_log=cluster_log_dir_path / "{scaffold}.trf.cluster.log",
        cluster_err=cluster_log_dir_path / "{scaffold}.trf.cluster.err"
    # conda:
    #    "../envs/conda.yaml"
    resources:
        cpus=config["trf_threads"],
        time=config["trf_time"],
        mem=config["trf_mem_mb"]
    threads: 
        config["trf_threads"]
    shell:
        "cd {out_trf_dir_path}/; "
        "trf ../splitted/{wildcards.scaffold}.fasta 2 7 7 80 10 50 2000 -l 10 -d -h; "
        "mv {wildcards.scaffold}.fasta.2.7.7.80.10.50.2000.dat {wildcards.scaffold}.dat"

rule trf_gff:
    input:
        # rules.trf.output
        expand(out_trf_dir_path / "{scaffold}.dat", scaffold=SCAFFOLDS)
    output:
        expand(out_gff_trf_dir_path / "{sample}.gff", sample=SAMPLES)
    log:
        std=log_dir_path / "trf_gff.log",
        cluster_log=cluster_log_dir_path / "trf_gff.cluster.log",
        cluster_err=cluster_log_dir_path / "trf_gff.cluster.err"
    # conda:
    #     "../envs/conda.yaml"
    params:
        samples = SAMPLES,
        scaffolds = SCAFFOLDS,
        inpdir = out_trf_dir_path,
        outdir = out_gff_trf_dir_path
    resources:
        cpus=config["trf_gff_threads"],
        time=config["trf_gff_time"],
        mem=config["trf_gff_mem_mb"]
    threads:
        config["trf_gff_threads"]
    shell:
        "python workflow/scripts/trf_to_gff.py -i {params.inpdir} -o {params.outdir} -sm {params.samples} -sc {params.scaffolds} 2>&1"
    # script:
    #     "../scripts/trf_to_gff.py"
