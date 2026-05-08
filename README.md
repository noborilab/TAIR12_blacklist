# TAIR12 Blacklist

This repository contains a blacklist for the TAIR12 assembly of _Arabidopsis thaliana_, and corresponding code used to generate it. The pipeline is meant to match the TAIR10 blacklist created by Klasfed et al. (2022).

There are two files: `tair12_bl_ens.bed` and `tair12_bl_ucsc.bed`. These are the same TAIR12 blacklist BED, with the chromosome names either in UCSC style (chr1, chr2, etc) or ENSEMBL style (1, 2, etc).

## Citation

Please use the Zenodo DOI to cite this blacklist if you find it useful in your research:

Tremblay, B.J.M. and Nobori, T. (2026). TAIR12 blacklist. _Zenodo_, DOI: [10.5281/zenodo.20084760](https://doi.org/10.5281/zenodo.20084759).

## TAIR10 versus TAIR12

Here is a quick visualization of the TAIR10 versus TAIR12 blacklist coverage across the 5 chromosomes (not to scale):

<img src="TAIR10_vs_TAIR12.jpg" width="100%" />

## Reproducing the blacklist

These steps are targeted towards members of The Sainsbury Laboratory (TSL) using the NBI HPC. Other sites can adapt the same flow by editing `config.sh` and the partition names. The two BED files in the repo root are the published artifact tied to the Zenodo DOI; reproduce only when verifying or moving to a new TAIR assembly.

### Step 1: Edit `config.sh`

`config.sh` at the repo root is the single source of truth for site- and user-specific paths. At minimum, set:

- `WORK_BASE` — your per-user working tree (e.g. `/hpc-home/$USER/arabidopsis/tair12/blacklist`)
- `CONTAINER_DIR` — where you keep your Singularity `.img` files
- `EMAIL` — your TSL email, used for SLURM `--mail-type` notifications

Defaults for `FASTQ_SOURCE`, `GENOME_PATH`, `CHROM_SIZES`, and the two SLURM partitions are set inline; override any of them by editing the file or by exporting the variable before invoking `submit.sh`.

### Step 2: Build Singularity containers

For each definition in `defs/`, build on the `software` node of the HPC into `$CONTAINER_DIR`:

```
sudo singularity build $CONTAINER_DIR/container.img defs/container.def
```

You need all four: `bwa-0.7.19.img`, `samtools-1.21.img`, `umap-1.1.1.img`, `blacklist.img`.

### Step 3: Stage inputs

- **FASTQs** — download the ChIP-seq inputs listed in `scripts/import_raw_fasta_inputs.sh` (from Klasfeld et al. 2022) into `$FASTQ_SOURCE` using the [SRA Toolkit](https://github.com/ncbi/sra-tools). The default `FASTQ_SOURCE` points at `/tsl/data/externalData/tnobori/ben/GreenscreenProject`. **Note:** `bwa.sh` merges `SRR7224610/11/12` into `SRR722461X.fastq.gz` inside `$FASTQ_SOURCE` and removes the originals — you must have write access there, or override `FASTQ_SOURCE` to a personal copy.
- **Genome** — download the TAIR12 assembly from the [TAIR website](https://www.arabidopsis.org), rename chromosomes to UCSC style (`chr1`–`chr5`; the pipeline requires this), and place at `$GENOME_PATH` (default `$WORK_BASE/genome.fa`). Also produce a `chrom.sizes` file at `$CHROM_SIZES` (e.g. via `samtools faidx`).

### Step 4: Run the pipeline

```
./submit.sh bwa                       # align inputs to TAIR12
srun --pty bash                       # interactive session for init
  ./scripts/init_script.sh            # generates the umap working tree
  exit
./submit.sh umap                      # build mappability tracks
./submit.sh blacklist                 # produce tair12_bl_ucsc.bed and tair12_bl_ens.bed
```

`submit.sh` sources `config.sh`, validates that prerequisites exist, and calls `sbatch` with the correct partition, mail, and log paths. The `init_script.sh` step is run interactively because it's a single fast call to `ubismap.py`. The Blacklist program is built (in `defs/Blacklist.def`) with the Klasfeld et al. (2022) modification that allows merging of blacklist ranges 5 Kbp apart.

Final outputs land at `$WORK_BASE/tair12_bl_ucsc.bed` and `$WORK_BASE/tair12_bl_ens.bed`.

## References

Klasfeld, S., Roulé, T. and Wagner, D. (2022). Greenscreen: A simple method to remove artifactual signals and enrich for true peaks in genomic datasets using ChIP-seq data. _Plant Cell_ **34**, 4795-4815.

