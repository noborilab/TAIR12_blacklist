#!/bin/bash
#SBATCH -p tsl-long
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -N 1
#SBATCH -J umap_tair12
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=Benjamin.Tremblay@tsl.ac.uk
#SBATCH --output=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/umap.LOG.txt
#SBATCH --error=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap/umap.ERR.txt

set -exuo pipefail

MAINDIR=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/umap
IMG=/hpc-home/gok24jef/containers/umap-1.1.1.img
SE() { singularity exec "$IMG" "$@"; }

# Directory containing the bowtie executable inside the container.
# Verify with: singularity exec $IMG which bowtie
BOWTIE_DIR=/usr/local/bin

KMERS=(36 50 100 150)
N_CHUNKS=145    # data rows in chrsize_index.tsv (5 chromosomes, 1 Mb chunks)
N_CHROMS=5      # chr1..chr5

for K in "${KMERS[@]}"; do
  mkdir -p "$MAINDIR/kmers/k${K}/TEMPs"
done

# 1. Bowtie index
SE bowtie-build \
    "$MAINDIR/genome/genome.fa" \
    "$MAINDIR/genome/Umap_bowtie.ind"

# 2-5. Per-kmer pipeline
for K in "${KMERS[@]}"; do
    KDIR="$MAINDIR/kmers/k${K}"

    # 2. get_kmers — per chunk
    for J in $(seq 1 "$N_CHUNKS"); do
        export SGE_TASK_ID=$J
        SE get_kmers.py \
            "$MAINDIR/chrsize.tsv" \
            "$KDIR" \
            "$MAINDIR/chrs" \
            "$MAINDIR/chrsize_index.tsv" \
            --kmer "k${K}"
    done

    # 3. run_bowtie — per chunk
    for J in $(seq 1 "$N_CHUNKS"); do
        export SGE_TASK_ID=$J
        SE run_bowtie.py \
            "$KDIR" \
            "$BOWTIE_DIR" \
            "$MAINDIR/genome" \
            Umap_bowtie.ind
    done

    # 4. unify_bowtie — per chromosome
    for J in $(seq 1 "$N_CHROMS"); do
        export SGE_TASK_ID=$J
        SE unify_bowtie.py \
            "$KDIR" \
            "$MAINDIR/chrsize.tsv"
    done

    # 5. Move intermediates out of the way before combine_umaps
    mv "$KDIR"/*kmer*   "$KDIR/TEMPs/" || true
    mv "$KDIR"/*bowtie* "$KDIR/TEMPs/" || true
done

# 6. combine_umaps — per chromosome (iterates all kmer subdirs internally)
for J in $(seq 1 "$N_CHROMS"); do
    export SGE_TASK_ID=$J
    SE combine_umaps.py \
        "$MAINDIR/kmers" \
        "$MAINDIR/chrsize.tsv"
done

echo "umap pipeline complete"
