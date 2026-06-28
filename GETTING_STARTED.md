# Getting Started

---

## GitHub Codespaces (Recommended for 30-min practical)

### Opening a Codespace (5 min)

1. Click the green **Code** button on the repository page
2. Select the **Codespaces** tab
3. Click **Create codespace on main**
4. Wait ~2 minutes for environment to build
5. Terminal will show `✓ Setup complete!`

### Confirm everything works

```bash
nextflow -version
# Should show: Nextflow 25.x or later
```

### Run Lesson 1 (Samplesheet) — 3 min

```bash
nextflow run course/01_samplesheet.nf
```

**Expected output:** 4 samples printed instantly
```
✓ [patient1, NA12878_1, ...]
✓ [patient1, NA12878_2, ...]
✓ [patient2, tumor_sample, ...]
✓ [patient2, normal_sample, ...]
```

### Run Full Pipeline — ~15 min

```bash
bash main.sh
```

**What it does:**
- Calls nf-core/sarek with `-profile conda,test_wes`
- Runs 4 samples through: alignment → variant calling → annotation
- Generates results in `results/`

**Watch for:**
- Task progress: `Submitted task ... > Running task ... > Completed`
- Final message: `✓ Pipeline complete!`
- Results location: `results/bam/`, `results/variant_calling/`, etc.

---

## Local Setup (if not using Codespaces)

### Requirements

- **Nextflow 25+** (`nextflow -version`)
- **Conda or Mamba** (`conda --version`)
- **Git** (`git --version`)
- **~5 GB free disk space**

### Install Nextflow

```bash
curl -fsSL https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/
nextflow -version   # should show 25.x or later
```

### Clone and setup

```bash
git clone https://github.com/Nkiruka-Cynthia/sarek-wes-training
cd sarek-wes-training
bash .devcontainer/post-install.sh
```

This creates a conda environment `sarek-wes` with all tools.

### Run the practical

```bash
conda activate sarek-wes
nextflow run course/01_samplesheet.nf
bash main.sh
```

---

## Troubleshooting (30-min practical)

| Problem | Fix |
|---------|-----|
| Codespace setup takes >5 min | Pre-create a codespace before class |
| `nextflow: command not found` | Restart Codespace or run `bash .devcontainer/post-install.sh` |
| Pipeline fails downloading data | Check internet connection; retry with `-resume` |
| Out of memory | Reduce threads: `--cpus 1` in `main.sh` |
| Want to resume after interruption | Run: `bash main.sh` (automatically resumes) |

---

## Exploring Results (5 min)

### List outputs

```bash
ls -la results/
```

You should see:
```
results/
├── bam/                 # Aligned reads
├── variant_calling/     # VCF files (Strelka)
├── annotation/          # Annotated VCF (VEP)
└── multiqc/             # QC report
```

### View variant calls

```bash
# Peek at germline variants (patient1)
zcat results/variant_calling/strelka/patient1/germline.vcf.gz | head -30

# Count variants
zcat results/variant_calling/strelka/patient1/germline.vcf.gz | grep -v '^#' | wc -l
```

### Open MultiQC report

```bash
# In Codespaces: Download the file
results/multiqc/multiqc_report.html

# View locally:
open results/multiqc/multiqc_report.html    # macOS
xdg-open results/multiqc/multiqc_report.html # Linux
start results/multiqc/multiqc_report.html    # Windows
```

The HTML report shows:
- Sequencing depth per sample
- Alignment quality metrics
- Variant call counts
- QC status (pass/fail)

---

## Next Steps (After 30-min practical)

### For students

- Explore the **REFERENCE.md** (Nextflow + Sarek syntax)
- Try modifying `data/samplesheet.csv` with your own WES data
- Run individual lessons again for deeper understanding

### For instructors

- Create a "teaching instance" Codespace beforehand (faster startup)
- Have `results/` pre-computed to show what success looks like
- Keep terminal visible during full pipeline run to show task progress

---

## Questions?

Refer to:
- [nf-core/sarek documentation](https://nf-co.re/sarek/)
- [Nextflow docs](https://www.nextflow.io/docs/latest/)
- [course/REFERENCE.md](course/REFERENCE.md) — Quick syntax card
