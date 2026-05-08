#!/bin/bash
# Submit a TAIR12 blacklist pipeline step to SLURM.
#
# Usage:
#   ./submit.sh bwa
#   ./submit.sh umap
#   ./submit.sh blacklist
#
# Sources config.sh, validates that prerequisites exist, then sbatch-submits
# the matching script in scripts/ with user-specific overrides.
#
# init_script.sh is run interactively per the README and is not handled here.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${REPO_DIR}/config.sh"

usage() {
    echo "Usage: $0 {bwa|umap|blacklist}" >&2
    exit 2
}

[[ $# -eq 1 ]] || usage
STEP="$1"

require_var() {
    local name="$1" value="$2"
    if [[ -z "$value" || "$value" == *CHANGEME* ]]; then
        echo "ERROR: $name is not set in config.sh (current: '$value')." >&2
        exit 1
    fi
}

require_path() {
    local label="$1" path="$2"
    if [[ ! -e "$path" ]]; then
        echo "ERROR: $label not found: $path" >&2
        exit 1
    fi
}

require_var WORK_BASE     "$WORK_BASE"
require_var CONTAINER_DIR "$CONTAINER_DIR"
require_var EMAIL         "$EMAIL"

mkdir -p "$WORK_BASE"

case "$STEP" in
    bwa)
        require_path "FASTQ_SOURCE"          "$FASTQ_SOURCE"
        require_path "GENOME_PATH"           "$GENOME_PATH"
        require_path "bwa container"         "${CONTAINER_DIR}/bwa-0.7.19.img"
        require_path "samtools container"    "${CONTAINER_DIR}/samtools-1.21.img"
        SCRIPT="${REPO_DIR}/scripts/bwa.sh"
        PARTITION="$SLURM_PARTITION_MEDIUM"
        LOG_PREFIX="${WORK_BASE}/bwa"
        ;;
    umap)
        require_path "umap working dir"      "${WORK_BASE}/umap"
        require_path "umap container"        "${CONTAINER_DIR}/umap-1.1.1.img"
        require_path "umap genome.fa"        "${WORK_BASE}/umap/genome/genome.fa"
        require_path "chrsize.tsv"           "${WORK_BASE}/umap/chrsize.tsv"
        SCRIPT="${REPO_DIR}/scripts/umap_script_manual.sh"
        PARTITION="$SLURM_PARTITION_LONG"
        LOG_PREFIX="${WORK_BASE}/umap/umap"
        ;;
    blacklist)
        require_path "BAM directory"         "${WORK_BASE}/bams"
        require_path "umap mappability dir"  "${WORK_BASE}/umap/kmers/globalmap_k36tok150"
        require_path "blacklist container"   "${CONTAINER_DIR}/blacklist.img"
        require_path "samtools container"    "${CONTAINER_DIR}/samtools-1.21.img"
        SCRIPT="${REPO_DIR}/scripts/blacklist.sh"
        PARTITION="$SLURM_PARTITION_MEDIUM"
        LOG_PREFIX="${WORK_BASE}/blacklist"
        ;;
    *)
        usage
        ;;
esac

mkdir -p "$(dirname "$LOG_PREFIX")"

exec sbatch \
    --export=ALL \
    --mail-user="$EMAIL" \
    --output="${LOG_PREFIX}.LOG.txt" \
    --error="${LOG_PREFIX}.ERR.txt" \
    -p "$PARTITION" \
    "$SCRIPT"
