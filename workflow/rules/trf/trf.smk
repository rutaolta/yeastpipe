rule trf:
    input:
        reference=reference_path / "S288C_reference_2015.fasta"
    output:
    	out_trf_dir_path / "S288C_reference_2015.fasta.2.7.7.80.10.50.2000.dat"
    log:
        log_dir_path / "trf.log"
    conda:
        "../../../%s" % config["conda_config"]
    shell:
        "trf {input.reference} 2 7 7 80 10 50 2000 -l 10 -d -h"