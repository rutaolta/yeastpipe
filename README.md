# yeastpipe

source .bashrc

conda activate snakemake

snakemake --cores 1 --configfile config/default.yaml --use-conda
