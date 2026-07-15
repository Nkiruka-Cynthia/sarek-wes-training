# sarek-wes-training

<div align="center">

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Nkiruka-Cynthia/sarek-wes-training)
[![nf-core](https://img.shields.io/badge/nf--core-sarek%203.9.0-brightgreen)](https://nf-co.re/sarek)
[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A526.04-blue)](https://www.nextflow.io/)
[![Docker](https://img.shields.io/badge/container-Docker-2496ED)](https://www.docker.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**A hands-on WES somatic variant calling practical for the STaiMIC Nextflow Training Program**  
*From raw FASTQ to annotated variants - powered by nf-core/sarek 3.9.0*

---

[Open in Codespaces](#-quick-start) · [Biological Story](#-biological-story) · [Results Guide](#️-understanding-your-results) 

</div>

---

## What is this?

This repository is the **hands-on practical component** of the STaiMIC Nextflow Bioinformatics Training Program (Session 2, 15th July 2026). It runs the full [nf-core/sarek](https://nf-co.re/sarek) WES pipeline on lightweight test data — completing in ~20 minutes on a standard GitHub Codespace.

No local installation needed. No HPC required. One command runs everything.

```bash
bash main.sh
```

---

## Biological Story

We analyse **four WES samples from two patients** — a design that lets us demonstrate both germline and somatic variant calling in a single pipeline run.

| Sample | Patient | Status | Clinical Question |
|--------|---------|--------|-------------------|
| `NA12878_1` | Patient 1 | Germline (0) | What inherited variants does this patient carry? |
| `NA12878_2` | Patient 1 | Germline replicate (0) | Are our results reproducible across lanes? |
| `tumor_sample` | Patient 2 | Tumor (1) | Which somatic mutations drive this cancer? |
| `normal_sample` | Patient 2 | Normal control (0) | What is the patient's germline background? |

> **Why does this design matter?**  
> By pairing `status=1` (tumor) with `status=0` (normal) from the same patient, Sarek runs **somatic variant calling** — subtracting germline variants to find mutations that appeared only in the tumor. This is the standard approach in cancer genomics.

---

##  Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    nf-core/sarek 3.9.0                          │
│                  WES Somatic Variant Calling                     │
└─────────────────────────────────────────────────────────────────┘

  FASTQ reads (4 samples)
       │
       ▼
  ┌─────────┐
  │  FASTQC │  ──▶  Per-read quality metrics
  └─────────┘
       │
       ▼
  ┌──────────────┐
  │  BWA-MEM2    │  ──▶  Align reads to testdata.nf-core.sarek genome
  └──────────────┘        Output: sorted BAM files
       │
       ▼
  ┌──────────────────┐
  │  MarkDuplicates  │  ──▶  Flag PCR duplicates in BAM
  └──────────────────┘        Output: deduplicated CRAM files
       │
       ├──────────────────────────────────┐
       ▼                                  ▼
  ┌──────────────────┐        ┌───────────────────────┐
  │  STRELKA_SINGLE  │        │    STRELKA_SOMATIC     │
  │  (Patient 1)     │        │  (Patient 2: T vs N)   │
  │  Germline calls  │        │  Somatic-only calls    │
  └──────────────────┘        └───────────────────────┘
       │                                  │
       └──────────────┬───────────────────┘
                      ▼
              ┌──────────────┐
              │  BCFtools QC │  ──▶  VCF stats, Ti/Tv ratio, counts
              └──────────────┘
                      │
                      ▼
              ┌──────────────┐
              │   MultiQC    │  ──▶  Single HTML report aggregating ALL QC
              └──────────────┘

   Note: VEP annotation is demonstrated via examples/annotated_example.vcf
           (requires a 15GB cache — shown as pre-computed output instead)
```

---

## Quick Start

### Step 1 — Open in GitHub Codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Nkiruka-Cynthia/sarek-wes-training)

Click the badge above or navigate to:
```
Code → Codespaces → Create codespace on main
```

Wait ~3 minutes for the environment to set up automatically. You will see:
```
✅ Setup complete! You are ready to run: bash main.sh
```

### Step 2 — Understand the samplesheet (2–3 min)

```bash
nextflow run course/01_samplesheet.nf
```

### Step 3 — Explore pipeline concepts (optional, instant)

```bash
nextflow run course/02_fastp_qc.nf        # QC concepts
nextflow run course/03_alignment.nf        # Alignment concepts  
nextflow run course/04_variant_calling.nf  # Variant calling concepts
```

### Step 4 — Run the full pipeline (~20 min)

```bash
bash main.sh
```

### Step 5 — Explore results

```bash
# View all output directories
ls results/

# Inspect the germline VCFs
zcat results/variant_calling/strelka/NA12878_1/*.vcf.gz | head -50
zcat results/variant_calling/strelka/NA12878_2/*.vcf.gz | head -50

# Inspect the somatic VCF
zcat results/variant_calling/strelka/tumor_sample_vs_normal_sample/*.vcf.gz | head -50

# Compare with the annotated example
cat examples/annotated_example.vcf | head -80

# Open QC report (VS Code → right-click → Open with Live Server)
results/multiqc/multiqc_report.html
```

---

## Repository Structure

```
sarek-wes-training/
│
├──  README.md                    This file
├──  GETTING_STARTED.md           Detailed student setup guide
├──  main.sh                      ← STUDENTS RUN THIS
├──   nextflow.config              Pipeline configuration
│
├── data/
│   └── samplesheet.csv             4 WES samples (2 patients)
│
├── course/
│   ├── 01_samplesheet.nf           Lesson 1: samplesheet structure
│   ├── 02_fastp_qc.nf              Lesson 2: QC concepts
│   ├── 03_alignment.nf             Lesson 3: alignment concepts
│   ├── 04_variant_calling.nf       Lesson 4: variant calling concepts
│   └── REFERENCE.md                Nextflow + Sarek syntax quick-ref
│
├── examples/
│   └── annotated_example.vcf       Pre-computed VEP annotation example
│
└── .devcontainer/
    ├── devcontainer.json           Codespaces environment config
    └── post-install.sh             Auto-setup: Nextflow + Sarek + FASTQs
```

---

## Understanding Your Results

After `bash main.sh` completes, your `results/` folder will contain:

```
results/
├── multiqc/
│   └── multiqc_report.html          START HERE — single QC dashboard
│
├── preprocessing/
│   └── markduplicates/
│       ├── NA12878_1/              Deduplicated CRAM + index
│       ├── NA12878_2/
│       ├── tumor_sample/
│       └── normal_sample/
│
├── variant_calling/
│   └── strelka/
│       ├── NA12878_1/              Germline VCF (Patient 1)
│       ├── NA12878_2/              Germline VCF (replicate)
│       └── tumor_sample_vs_normal_sample/  Somatic VCF (Patient 2)
│
├── reports/
│   ├── fastqc/                     Per-sample FASTQC reports
│   ├── markduplicates/             Duplicate rate per sample
│   ├── mosdepth/                   Coverage depth statistics
│   ├── samtools/                   Alignment statistics
│   └── bcftools/                   VCF quality statistics
│
└── pipeline_info/
    ├── timeline.html               Task execution timeline
    ├── report.html                 Resource usage report
    └── trace.txt                   Per-task resource trace
```

---

##  30-Minute Practical Timeline

| Time | Activity | Command | What to watch |
|------|----------|---------|---------------|
| 0–3 min | Codespace setup | Auto | `✅ Setup complete!` message |
| 3–6 min | Samplesheet lesson | `nextflow run course/01_samplesheet.nf` | 4 samples printed |
| 6–8 min | Launch pipeline | `bash main.sh` | Task list appears |
| 8–25 min | Pipeline running | — | Tasks completing live |
| 25–30 min | Explore results + Q&A | `ls results/` | MultiQC report |

---

## Technical Configuration

| Parameter | Value | Reason |
|-----------|-------|--------|
| Sarek version | 3.9.0 | Compatible with Nextflow ≥26 |
| Genome | `testdata.nf-core.sarek` | Lightweight, fast (~MB not GB) |
| Profile | `docker` | Reliable container execution |
| Tools | `strelka` | Germline + somatic calling |
| Wave | disabled | Avoids registry DNS issues |
| BQSR | skipped | Saves ~5 minutes on test data |
| Resource limit | 2 CPU / 8GB RAM | Codespaces free tier safe |

---

## References

| Tool | Reference |
|------|-----------|
| **nf-core/sarek** | [García et al., F1000Research 2020](https://doi.org/10.12688/f1000research.16665.2) · [Hanssen et al., NAR Genomics 2024](https://doi.org/10.1093/nargab/lqae031) |
| **Nextflow** | [Di Tommaso et al., Nat. Biotechnol. 2017](https://doi.org/10.1038/nbt.3820) |
| **nf-core** | [Ewels et al., Nat. Biotechnol. 2020](https://doi.org/10.1038/s41587-020-0439-x) |
| **Strelka2** | [Kim et al., Nat. Methods 2018](https://doi.org/10.1038/s41592-018-0051-x) |
| **BWA-MEM2** | [Vasimuddin et al., IPDPS 2019](https://doi.org/10.1109/IPDPS.2019.00041) |

---


## Questions?

See **[GETTING_STARTED.md](GETTING_STARTED.md)** for detailed setup help or refer to the [nf-core/sarek documentation](https://nf-co.re/sarek).

---

<div align="center">

Built for the **STaiMIC Nextflow Training Program**  
by [Nkiruka Cynthia Efenji](https://github.com/Nkiruka-Cynthia) · Nextflow Ambassador · [@Seqera](https://seqera.io)

</div>
