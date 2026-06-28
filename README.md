# sarek-wes-training

WES (Whole Exome Sequencing) variant analysis with Sarek — **30-minute practical hands-on exercise** for STaiMIC Nextflow training.

---

## What is this?

A simplified teaching repository that runs the **nf-core/Sarek WES pipeline** in just **~15 minutes** using lightweight nf-core test data. Designed as the practical component of a 90-minute instructor training:

- **0–60 min:** Slides (Nextflow concepts + Sarek pipeline overview)
- **60–90 min:** **Hands-on practical** (this repo)
  - 0–5 min: Setup
  - 5–10 min: Run lesson 1 (understand samplesheet)
  - 10–20 min: Run full pipeline (`bash main.sh`)
  - 20–30 min: Explore results + Q&A

---

## The biological story

Four WES samples from two patients:

| Sample | Patient | Type | Goal |
|--------|---------|------|------|
| NA12878_1 | Patient1 | Germline | Detect inherited variants |
| NA12878_2 | Patient1 | Germline (replicate) | Reproducibility check |
| tumor_sample | Patient2 | Somatic | Cancer-specific mutations |
| normal_sample | Patient2 | Somatic control | Background filtering |

---

## The pipeline

```
Input: FASTQ (WES reads)
    ↓
[FASTP]         → Trim adapters, quality filter
    ↓
[BWA-mem]       → Align to GRCh38 reference
    ↓
[MarkDuplicates] → Remove PCR duplicates
    ↓
[Strelka]       → Variant calling (germline/somatic)
    ↓
[VEP]           → Functional annotation
    ↓
[MultiQC]       → QC aggregation
    ↓
Output: VCF + HTML report
```

---

## Quick start (30-minute practical)

### Step 1: Open GitHub Codespaces (5 min)

1. Click **Code → Codespaces → Create codespace on main**
2. Wait for environment setup (~2 min)
3. Terminal will show: `✓ Setup complete!`

### Step 2: Understand the samplesheet (2–3 min)

```bash
nextflow run course/01_samplesheet.nf
```

Shows how Nextflow reads WES sample metadata from CSV.

### Step 3: Run the full Sarek WES pipeline (10–15 min)

```bash
bash main.sh
```

Runs the complete Sarek pipeline on test data.

**While it runs (~15 min):**
- Explain variant calling output
- Show how to interpret VCF files
- Discuss QC metrics

### Step 4: Explore results (5–8 min)

```bash
# View results
ls -la results/

# Open QC report (download and open in browser)
results/multiqc/multiqc_report.html

# Peek at variant calls
zcat results/variant_calling/strelka/*/germline.vcf.gz | head -50
```

---

## Repository layout

```
sarek-wes-training/
├── README.md                      (this file)
├── GETTING_STARTED.md             Setup instructions
├── main.sh                        ← Students run THIS
├── nextflow.config                Sarek + conda config
├── data/
│   └── samplesheet.csv            4 WES samples (nf-core test data URLs)
├── course/
│   ├── 01_samplesheet.nf          Quick lesson (instant)
│   └── REFERENCE.md               Syntax quick-ref
├── .devcontainer/
│   ├── devcontainer.json          Codespaces config
│   └── post-install.sh            Auto-setup script
├── .gitignore
└── LICENSE                        MIT
```

---

## 30-Minute Practical Timeline

| Time | Activity | Command | Duration |
|------|----------|---------|----------|
| **0–5 min** | Setup Codespace | Auto-setup | 5 min |
| **5–8 min** | Samplesheet lesson | `nextflow run course/01_samplesheet.nf` | 3 min |
| **8–25 min** | Full Sarek pipeline | `bash main.sh` | ~15 min |
| **25–30 min** | Explore results + Q&A | Open HTML report, inspect VCFs | 5 min |

---

## Test data

All data points to **official nf-core test datasets** (lightweight URLs in `data/samplesheet.csv`):
- ~10 MB FASTQ files per sample
- Pre-built GRCh38 reference
- Runs in ~15 minutes on conda
- No large files in Git ✓

---

## Instructor notes for 30-minute practical

### Before class (5 min prep)

1. Create a Codespace in advance to test setup time
2. Pre-download and cache nf-core test data (optional, speeds up runs)
3. Have `results/multiqc/multiqc_report.html` ready to show

### During practical (30 min)

**Min 0–5:** Let Codespaces auto-setup
```
"Setup is happening automatically. While we wait, let's look at the samplesheet structure..."
```

**Min 5–8:** Run lesson 1
```bash
nextflow run course/01_samplesheet.nf
```
**Say:** "Notice how Nextflow reads the CSV and creates metadata. Each patient can have multiple samples—this is scalable to 100+ samples!"

**Min 8–10:** Start full pipeline
```bash
bash main.sh
```
**Say:** "This runs the COMPLETE Sarek pipeline end-to-end. Watch the task progress in real-time."

**Min 10–25:** While running (~15 min)...
- Explain each stage on slides:
  - Alignment (BWA-mem creates BAM files)
  - Variant calling (Strelka finds SNVs/indels)
  - Annotation (VEP adds gene impact predictions)
  - QC (MultiQC aggregates all metrics)
- Point out task count:
  - 4 FASTP (per sample QC)
  - 4 BWA (alignment)
  - 4 MarkDuplicates (dedup)
  - 2 Strelka (germline + somatic)
  - 2 VEP (annotation)
  - 1 MultiQC (aggregation)
  - **Total: ~17 tasks**

**Min 25–30:** Explore results
```bash
ls -la results/
ls results/variant_calling/strelka/
zcat results/variant_calling/strelka/patient1/germline.vcf.gz | head -20
```
**Say:** "Here are the actual variants detected. The VCF file shows chromosome, position, what changed (REF→ALT), and quality score. VEP added the gene name and consequence (e.g., missense, frameshift)."

**Open MultiQC report** (download and open in browser):
- Show sequencing depth (~100x for WES)
- Alignment quality
- Variant statistics

---

## References

| Tool | Citation |
|------|----------|
| Sarek | [García et al., F1000Research 2020](https://doi.org/10.12688/f1000research.16665.2) |
| Nextflow | [Di Tommaso et al., Nat. Biotechnol. 2017](https://doi.org/10.1038/nbt.3820) |
| nf-core | [Ewels et al., Nat. Biotechnol. 2020](https://doi.org/10.1038/s41587-020-0439-x) |

---

## License

MIT

---

## Questions?

See **[GETTING_STARTED.md](GETTING_STARTED.md)** or refer to [nf-core/sarek docs](https://nf-co.re/sarek/).
