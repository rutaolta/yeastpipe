rule wm_counts:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS)
    output:
        expand(out_wm_counts_dir_path / "{id}.counts", id=IDS)
    log:
        log_dir_path / "wm_counts.log"
#    conda:
#        "workflow/envs/conda.yaml"
    run:
        for f in IDS:
            shell("windowmasker -in {reference_splitted_dir_path}/{f}.fasta -out {out_wm_counts_dir_path}/{f}.counts -mk_counts -infmt fasta -sformat obinary > {log} 2>&1")
