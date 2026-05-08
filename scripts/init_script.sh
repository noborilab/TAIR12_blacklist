set -ex

singularity exec ~/containers/umap-1.1.1.img ubismap.py \
    /hpc-home/gok24jef/arabidopsis/tair12/blacklist/genome.fa \
    /hpc-home/gok24jef/arabidopsis/tair12/blacklist/chrom.sizes \
    /hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap \
    tair12bl bowtie-build \
    --kmers 36 50 100 150 -write_script umap_script.sh

