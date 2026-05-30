# TAIR12 Blacklist

This repository contains a blacklist for the TAIR12 assembly of _Arabidopsis thaliana_, along with the code used to generate it. The pipeline is meant to reproduce (as closely as I could manage) the TAIR10 blacklist of Klasfeld et al. (2022) on the newer assembly.

There are two files, `tair12_bl_ens.bed` and `tair12_bl_ucsc.bed`. They contain exactly the same blacklist, and the only difference is the chromosome naming, which is either in UCSC style (`chr1`, `chr2`, and so on) or Ensembl style (`1`, `2`, ...).

## Citation

If you find this blacklist useful in your research, please cite it using the Zenodo DOI:

Tremblay, B.J.M. and Nobori, T. (2026). TAIR12 blacklist. _Zenodo_, DOI: [10.5281/zenodo.20084760](https://doi.org/10.5281/zenodo.20084759).

## TAIR10 versus TAIR12

Here is a quick visualization of how the TAIR10 and TAIR12 blacklist coverage compare across the five chromosomes (not to scale):

<img src="TAIR10_vs_TAIR12.jpg" width="100%" />

## Reproducing the blacklist

These steps are written with members of The Sainsbury Laboratory (TSL) on the NBI HPC in mind, though other sites should be able to adapt the same flow by editing `config.sh` and the partition names. Do keep in mind that the two BED files in the repo root are the published artifact tied to the Zenodo DOI, so there is usually no need to regenerate them; the steps below are really only for verifying the pipeline or moving to a new TAIR assembly.

### Step 1: Edit `config.sh`

`config.sh` at the repo root is the single source of truth for the site- and user-specific paths. At a minimum you will want to set:

- `WORK_BASE`, your per-user working tree (e.g. `/hpc-home/$USER/arabidopsis/tair12/blacklist`)
- `CONTAINER_DIR`, wherever you keep your Singularity `.img` files
- `EMAIL`, your TSL email (used for the SLURM `--mail-type` notifications)

The defaults for `FASTQ_SOURCE`, `GENOME_PATH`, `CHROM_SIZES`, and the two SLURM partitions are set inline, and you can override any of them either by editing the file directly or by exporting the variable before you invoke `submit.sh`.

### Step 2: Build Singularity containers

For each definition in `defs/`, build on the `software` node of the HPC into `$CONTAINER_DIR`:

```
sudo singularity build $CONTAINER_DIR/container.img defs/container.def
```

You will need all four images (`bwa-0.7.19.img`, `samtools-1.21.img`, `umap-1.1.1.img`, and `blacklist.img`).

### Step 3: Stage inputs

- **FASTQs.** Run `bash scripts/import_raw_fasta_inputs.sh` to download the ChIP-seq inputs (from Klasfeld et al. 2022) into `$FASTQ_SOURCE` and gzip them. The script `cd`s into `$FASTQ_SOURCE` itself, so you will need [SRA Toolkit](https://github.com/ncbi/sra-tools) (`fastq-dump`) and `pigz` on your `PATH`. The default `FASTQ_SOURCE` points at `/tsl/data/externalData/tnobori/ben/GreenscreenProject`. One thing to watch out for: `bwa.sh` merges `SRR7224610/11/12` into `SRR722461X.fastq.gz` inside `$FASTQ_SOURCE` and then removes the originals, so you do need write access there (or you can override `FASTQ_SOURCE` to point at a personal copy).
- **Genome.** Download the TAIR12 assembly from the [TAIR website](https://www.arabidopsis.org), rename the chromosomes to UCSC style (`chr1`–`chr5`; the pipeline does require this), and place it at `$GENOME_PATH` (default `$WORK_BASE/genome.fa`). You will also want a `chrom.sizes` file at `$CHROM_SIZES`, which you can produce with `samtools faidx`.

### Step 4: Run the pipeline

```
./submit.sh bwa                       # align inputs to TAIR12
srun --pty bash                       # interactive session for init
  ./scripts/init_script.sh            # generates the umap working tree
  exit
./submit.sh umap                      # build mappability tracks
./submit.sh blacklist                 # produce tair12_bl_ucsc.bed and tair12_bl_ens.bed
```

`submit.sh` sources `config.sh`, checks that the prerequisites exist, and then calls `sbatch` with the correct partition, mail, and log paths. The `init_script.sh` step is run interactively because it is just a single quick call to `ubismap.py`. One detail worth flagging: the Blacklist program is built (in `defs/Blacklist.def`) with the Klasfeld et al. (2022) modification that allows blacklist ranges up to 5 Kbp apart to be merged, so if you ever rebuild that container you will want to keep the patch in place.

Final outputs land at `$WORK_BASE/tair12_bl_ucsc.bed` and `$WORK_BASE/tair12_bl_ens.bed`.

## References

Klasfeld, S., Roulé, T. and Wagner, D. (2022). Greenscreen: A simple method to remove artifactual signals and enrich for true peaks in genomic datasets using ChIP-seq data. _Plant Cell_ **34**, 4795-4815.

