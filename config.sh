# shellcheck shell=bash
# Pipeline configuration for TSL HPC users.
#
# EDIT BEFORE FIRST RUN:
#   - WORK_BASE     : your per-user working tree
#   - CONTAINER_DIR : where your Singularity .img files live
#   - EMAIL         : your TSL email (used for SLURM mail-user)
#
# Everything else has a sensible default for the NBI/TSL HPC. Override any
# variable by exporting it before sourcing this file or before invoking
# ./submit.sh, e.g.:
#
#     EMAIL=alice@tsl.ac.uk ./submit.sh bwa
#
# This file is sourced by submit.sh and by each script in scripts/. It must
# remain a valid bash file with no executable side effects.

: "${WORK_BASE:=/hpc-home/CHANGEME/arabidopsis/tair12/blacklist}"
: "${CONTAINER_DIR:=/hpc-home/CHANGEME/containers}"
: "${EMAIL:=CHANGEME@tsl.ac.uk}"

: "${FASTQ_SOURCE:=/tsl/data/externalData/tnobori/ben/GreenscreenProject}"
: "${GENOME_PATH:=${WORK_BASE}/genome.fa}"
: "${CHROM_SIZES:=${WORK_BASE}/chrom.sizes}"

: "${SLURM_PARTITION_MEDIUM:=tsl-medium}"
: "${SLURM_PARTITION_LONG:=tsl-long}"

export WORK_BASE CONTAINER_DIR EMAIL
export FASTQ_SOURCE GENOME_PATH CHROM_SIZES
export SLURM_PARTITION_MEDIUM SLURM_PARTITION_LONG
