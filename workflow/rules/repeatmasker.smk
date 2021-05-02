rule repeatmasker:
    input:
        expand(reference_splitted_dir_path / "{id}.fasta", id=IDS)
    output:
        temp(expand(out_rm_dir_path / "{id}.fasta.cat", id=IDS)),
        temp(expand(out_rm_dir_path / "{id}.fasta.masked", id=IDS)),
        temp(expand(out_rm_dir_path / "{id}.fasta.out", id=IDS)),
        temp(expand(out_rm_dir_path / "{id}.fasta.tbl", id=IDS)),
        expand(out_gff_rm_dir_path / "{id}.gff", id=IDS)
    log:
        log_dir_path / "repeatmasker.log"
    # conda:
    #    "../envs/conda.yaml"
    run:
        for f in IDS:
            shell("RepeatMasker -pa 8 -species 'Saccharomyces cerevisiae' -dir {out_rm_dir_path} {reference_splitted_dir_path}/{f}.fasta -gff > {log} 2>&1")
            shell("ex -sc '1d3|x' {out_rm_dir_path}/{f}.fasta.out.gff")
            shell("mv {out_rm_dir_path}/{f}.fasta.out.gff {out_gff_rm_dir_path}/{f}.gff")
