rule wm_counts:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS)
    output:
        temp(expand(out_wm_dir_path / "counts/{id}.counts", id=IDS))
    log:
        log_dir_path / "windowmasker.log"
#    conda:
#        "workflow/envs/conda.yaml"
    run:
        for f in IDS:
            shell("windowmasker -in {reference_splitted_dir_path}/{f}.fasta -out {out_wm_dir_path}/counts/{f}.counts -mk_counts -infmt fasta -sformat obinary > {log} 2>&1")

rule wm_windowmasker:
    input:
        reference=expand(reference_splitted_dir_path / "{id}.fasta", id=IDS),
        counts=expand(out_wm_dir_path / "counts/{id}.counts", id=IDS)
    output:
        temp(expand(out_wm_dir_path / "{id}.windowmasker", id=IDS))
    log:
        log_dir_path / "windowmasker.log"
#    conda:
#        "workflow/envs/conda.yaml"
    run:
        for f in IDS:
            shell("windowmasker -ustat {out_wm_dir_path}/counts/{f}.counts -in {reference_splitted_dir_path}/{f}.fasta -out {out_wm_dir_path}/{f}.windowmasker -infmt fasta -outfmt interval > {log} 2>&1")

rule wm_gff:
    input:
        expand(out_wm_dir_path / "{id}.windowmasker", id=IDS)
    output:
        expand(out_gff_wm_dir_path / "{id}.gff", id=IDS)
    log:
        log_dir_path / "windowmasker.log"
    # conda:
    #     "../envs/conda.yaml"
    script:
        "../scripts/wm_to_gff.py"