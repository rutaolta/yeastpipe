rule wm_windowmasker:
    input:
        reference=expand(reference_splitted_dir_path / "{id}.fasta", id=IDS),
        counts=expand(out_wm_counts_dir_path / "{id}.counts", id=IDS)
    output:
        windowmasker=expand(out_wm_dir_path / "{id}.windowmasker", id=IDS)
    log:
        windowmasker=log_dir_path / "wm_windowmasker.log"
#    conda:
#        "workflow/envs/conda.yaml"
    run:
        for f in IDS:
            shell("windowmasker -ustat {out_wm_counts_dir_path}/{f}.counts -in {reference_splitted_dir_path}/{f}.fasta -out {out_wm_dir_path}/{f}.windowmasker -infmt fasta -outfmt interval > {log.windowmasker} 2>&1")
