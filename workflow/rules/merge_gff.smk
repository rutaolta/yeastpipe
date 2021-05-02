rule merge_gff:
    input:
        expand(out_gff_trf_dir_path / "{id}.gff", id=IDS),
        expand(out_gff_wm_dir_path / "{id}.gff", id=IDS),
        expand(out_gff_rm_dir_path / "{id}.gff", id=IDS)
    output:
        expand(out_gff_merged_dir_path / "{id}.gff", id=IDS)
    log:
        log_dir_path / "merged.log"
    # conda:
    #    "../envs/conda.yaml"
    run:
        for f in IDS:
            shell("cat {out_gff_trf_dir_path}/{f}.gff {out_gff_wm_dir_path}/{f}.gff {out_gff_rm_dir_path}/{f}.gff > {out_gff_merged_dir_path}/{f}.gff")
