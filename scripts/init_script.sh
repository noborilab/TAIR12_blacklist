#!/bin/bash
# Run interactively (e.g. inside a `srun --pty bash` session). Generates the
# umap working directory tree under $WORK_BASE/umap. The auto-generated
# umap_script.sh produced as a side effect is SGE-style and unused — run
# umap_script_manual.sh via ./submit.sh umap instead.

set -ex

# shellcheck source=../config.sh
source "$(dirname "${BASH_SOURCE[0]}")/../config.sh"

singularity exec "${CONTAINER_DIR}/umap-1.1.1.img" ubismap.py \
    "${GENOME_PATH}" \
    "${CHROM_SIZES}" \
    "${WORK_BASE}/umap" \
    tair12bl bowtie-build \
    --kmers 36 50 100 150 -write_script "${WORK_BASE}/umap_script.sh"
