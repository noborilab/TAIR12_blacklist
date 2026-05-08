#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH -N 1
#SBATCH -J bwa_tair12
#SBATCH --mail-type=end,fail

set -exuo pipefail

# shellcheck source=../config.sh
source "$(dirname "${BASH_SOURCE[0]}")/../config.sh"

BDIR="${WORK_BASE}/bams"
BWAIMG="${CONTAINER_DIR}/bwa-0.7.19.img"
SAMIMG="${CONTAINER_DIR}/samtools-1.21.img"
FQDIR="${FASTQ_SOURCE}"
GENOME="${GENOME_PATH}"

mkdir -p "$BDIR"

cd "$FQDIR"
if [ ! -f SRR722461X.fastq.gz ]; then
  zcat SRR7224610.fastq.gz SRR7224611.fastq.gz SRR7224612.fastq.gz \
  | pigz -p 14 > SRR722461X.fastq.gz
  rm SRR7224610.fastq.gz SRR7224611.fastq.gz SRR7224612.fastq.gz
fi

cd "$BDIR"
for i in "$FQDIR"/*.fastq.gz ; do
    SNAME=$(basename "$i")
    if [ ! -f "$BDIR/${SNAME}.bam.csi" ] ; then
      singularity exec "$BWAIMG" bwa mem -t 14 "$GENOME" "$i" \
      | singularity exec "$SAMIMG" samtools view -bu \
      | singularity exec "$SAMIMG" samtools sort -@ 1 --write-index -T "$BDIR/tmp" -o "$BDIR/${SNAME}.bam"
    fi
done
