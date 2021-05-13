# rule repeatmasker_splitted:
#     input:
#         expand(reference_splitted_dir_path / "{id}.fasta", id=IDS)
#     output:
#         temp(expand(out_rm_dir_path / "{id}.fasta.cat", id=IDS)),
#         temp(expand(out_rm_dir_path / "{id}.fasta.masked", id=IDS)),
#         temp(expand(out_rm_dir_path / "{id}.fasta.out", id=IDS)),
#         temp(expand(out_rm_dir_path / "{id}.fasta.tbl", id=IDS)),
#         expand(out_gff_rm_dir_path / "{id}.gff", id=IDS)
#     log:
#         log_dir_path / "repeatmasker.log"
#     # conda:
#     #    "../envs/conda.yaml"
#     run:
#         for f in IDS:
#             shell("RepeatMasker -pa 8 -species 'Saccharomyces cerevisiae' -dir {out_rm_dir_path} {reference_splitted_dir_path}/{f}.fasta -gff -xsmall > {log} 2>&1")
#             shell("ex -sc '1d3|x' {out_rm_dir_path}/{f}.fasta.out.gff")
#             shell("mv {out_rm_dir_path}/{f}.fasta.out.gff {out_gff_rm_dir_path}/{f}.gff")

rule repeatmasker_threads:
    input:
        samples_dir_path / "{sample}.fasta"
    output:
        out_gff_rm_dir_path / "{sample}.gff"
    # log:
    #     log_dir_path / "repeatmasker.log"
    threads: 8
    # conda:
    #    "../envs/conda.yaml"
    shell:
        "RepeatMasker -pa 4 -species 'Saccharomyces cerevisiae' -dir {out_rm_dir_path} {samples_dir_path}/{wildcards.sample}.fasta -parallel 4 -gff -xsmall 2>&1; "
        "ex -sc '1d3|x' {out_rm_dir_path}/{wildcards.sample}.fasta.out.gff; "
        "mv {out_rm_dir_path}/{wildcards.sample}.fasta.out.gff {out_gff_rm_dir_path}/{wildcards.sample}.gff"