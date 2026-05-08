#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -N 1
#SBATCH -J bl_tair12
#SBATCH --mail-type=end,fail

set -exuo pipefail

# shellcheck source=../config.sh
source "$(dirname "${BASH_SOURCE[0]}")/../config.sh"

BIMG="${CONTAINER_DIR}/blacklist.img"
SIMG="${CONTAINER_DIR}/samtools-1.21.img"
cd "$WORK_BASE"

mkdir -p mappability
mkdir -p input

for i in 1 2 3 4 5 ; do
    gunzip -c "umap/kmers/globalmap_k36tok150/chr${i}.uint8.unique.gz" \
    > "mappability/chr${i}.uint8.unique"
done

for f in "${WORK_BASE}/bams/"*.bam ; do
    singularity exec "$SIMG" samtools index -b "$f"
    ln -s "$f"     "input/$(basename "$f")"
    ln -s "$f.bai" "input/$(basename "$f").bai"
done

mkdir -p blacklist_bed
for i in 1 2 3 4 5 ; do
  singularity exec "$BIMG" Blacklist "chr${i}" > "blacklist_bed/chr${i}.bed"
done

cat blacklist_bed/*.bed > tair12_bl_ucsc.bed
sed 's/chr//g' tair12_bl_ucsc.bed > tair12_bl_ens.bed
