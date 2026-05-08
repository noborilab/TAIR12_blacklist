#!/bin/bash
#SBATCH -p tsl-medium
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH -N 1
#SBATCH -J bwa_tair12
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=Benjamin.Tremblay@tsl.ac.uk
#SBATCH --output=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/bwa.LOG.txt
#SBATCH --error=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/bwa.ERR.txt

set -exuo pipefail

BDIR=/hpc-home/gok24jef/arabidopsis/tair12/blacklist/bams
BWAIMG=/hpc-home/gok24jef/containers/bwa-0.7.19.img
SAMIMG=/hpc-home/gok24jef/containers/samtools-1.21.img
FQDIR=/tsl/data/externalData/tnobori/ben/GreenscreenProject
GENOME=/hpc-home/gok24jef/arabidopsis/tair12/genome.fa

mkdir -p $BDIR

cd $FQDIR
if [ ! -f SRR722461X.fastq.gz ]; then
  zcat SRR7224610.fastq.gz SRR7224611.fastq.gz SRR7224612.fastq.gz \
  | pigz -p 14 > SRR722461X.fastq.gz
  rm SRR7224610.fastq.gz SRR7224611.fastq.gz SRR7224612.fastq.gz
fi

cd $BDIR
for i in $FQDIR/*.fastq.gz ; do
    SNAME=`basename $i`
    if [ ! -f $BDIR/${SNAME}.bam.csi ] ; then
      singularity exec $BWAIMG bwa mem -t 14 $GENOME $i \
      | singularity exec $SAMIMG samtools view -bu \
      | singularity exec $SAMIMG samtools sort -@ 1 --write-index -T $BDIR/tmp -o $BDIR/${SNAME}.bam
    fi
done


