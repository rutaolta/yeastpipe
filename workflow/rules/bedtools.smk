rule bedtools_sort:
    input:
        expand(out_gff_merged_dir_path / "{id}.gff", id=IDS)
    output:
        expand(out_gff_merged_dir_path / "{id}.gff", id=IDS)
    log:
        log_dir_path / "bedtools.log"
#    conda:
#        "workflow/envs/conda.yaml"
    run:
        for f in IDS:
            shell("bedtools sort -i {out_gff_merged_dir_path}/{f}.gff > {log} 2>&1")

rule bedtools:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS),
        expand(out_gff_merged_dir_path / "{id}.gff", id=IDS)
    output:
        expand(out_bedtools_dir_path / "{id}.fasta.out", id=IDS)
    log:
        log_dir_path / "bedtools.log"
#    conda:
#        "workflow/envs/conda.yaml"
    run:
        for f in IDS:
            shell("bedtools maskfasta -fi {reference_splitted_dir_path}/{f}.fasta -bed {out_gff_merged_dir_path}/{f}.gff -fo {out_bedtools_dir_path}/{f}.fasta.out -soft > {log} 2>&1")
