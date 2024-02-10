# Catalog Scoring 

[![Documentation Status](https://readthedocs.org/projects/pgsc-calc/badge/?version=latest)](https://pgsc-calc.readthedocs.io/en/latest/?badge=latest)
[![pgscatalog/pgsc_calc CI](https://github.com/PGScatalog/pgsc_calc/actions/workflows/ci.yml/badge.svg)](https://github.com/PGScatalog/pgsc_calc/actions/workflows/ci.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5970794.svg)](https://doi.org/10.5281/zenodo.5970794)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-≥22.10.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)

## Introduction

`pgsc_calc` is a bioinformatics best-practice analysis pipeline for calculating
polygenic [risk] scores on samples with imputed genotypes using existing scoring
files from the [Polygenic Score (PGS) Catalog](https://www.pgscatalog.org/)
and/or user-defined PGS/PRS.

## Pipeline summary

<p align="center">
  <img width="80%" src="https://github.com/PGScatalog/pgsc_calc/assets/11425618/f766b28c-0f75-4344-abf3-3463946e36cc">
</p>

The workflow performs the following steps:

* Downloading scoring files using the PGS Catalog API in a specified genome build (GRCh37 and GRCh38).
* Reading custom scoring files (and performing a liftover if genotyping data is in a different build).
* Automatically combines and creates scoring files for efficient parallel computation of multiple PGS
    - Matching variants in the scoring files against variants in the target dataset (in plink bfile/pfile or VCF format)
* Calculates PGS for all samples (linear sum of weights and dosages)
* Creates a summary report to visualize score distributions and pipeline metadata (variant matching QC)

And optionally:

- Genetic Ancestry: calculate similarity of target samples to populations in a
  reference dataset ([1000 Genomes (1000G)](http://www.nature.com/nature/journal/v526/n7571/full/nature15393.html)), using principal components analysis (PCA)
- PGS Normalization: Using reference population data and/or PCA projections to report
  individual-level PGS predictions (e.g. percentiles, z-scores) that account for genetic ancestry

See documentation for a list of planned [features under development](https://pgsc-calc.readthedocs.io/en/latest/index.html#Features-under-development).

## Quick start

1. Install
[`Nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation)
(`>=22.10.0`)

2. Install [`Docker`](https://docs.docker.com/engine/installation/) or
[`Singularity (v3.8.3 minimum)`](https://www.sylabs.io/guides/3.0/user-guide/)
(please only use [`Conda`](https://conda.io/miniconda.html) as a last resort)

3. Download the pipeline and test it on a minimal dataset with a single command:

    ```console
    nextflow run pgscatalog/pgsc_calc -profile test,<docker/singularity/conda>
    ```

4. Start running your own analysis!

    ```console
    nextflow run pgscatalog/pgsc_calc -profile <docker/singularity/conda> --input samplesheet.csv --pgs_id PGS001229
    ```

See [getting
started](https://pgsc-calc.readthedocs.io/en/latest/getting-started.html) for more
details.

