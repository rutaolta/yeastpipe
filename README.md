# yeastpipe

source .bashrc

conda activate snakemake

snakemake -j --cores 8 --configfile config/default.yaml --forceall --use-conda
