#!/bin/bash
#SBATCH -p tsl-medium
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -N 1
#SBATCH -J bl_tair12
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=Benjamin.Tremblay@tsl.ac.uk
#SBATCH --output=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/blacklist.LOG.txt
#SBATCH --error=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/blacklist.ERR.txt

set -exuo pipefail

BIMG=/hpc-home/gok24jef/containers/blacklist.img
SIMG=/hpc-home/gok24jef/containers/samtools-1.21.img
cd /hpc-home/gok24jef/arabidopsis/tair12/blacklist

mkdir -p mappability
mkdir -p input

for i in 1 2 3 4 5 ; do
    gunzip -c umap/kmers/globalmap_k36tok150/chr${i}.uint8.unique.gz \
    > mappability/chr${i}.uint8.unique
done

for f in /hpc-home/gok24jef/arabidopsis/tair12/blacklist/bams/*.bam ; do
    singularity exec $SIMG samtools index -b $f
    ln -s "$f"     "input/$(basename "$f")"
    ln -s "$f.bai" "input/$(basename "$f").bai"
done

mkdir -p blacklist_bed
for i in 1 2 3 4 5 ; do
  singularity exec $BIMG Blacklist chr${i} > blacklist_bed/chr${i}.bed
done

cat blacklist_bed/*.bed > tair12_bl_ucsc.bed
sed 's/chr//g' tair12_bl_ucsc.bed > tair12_bl_ens.bed

