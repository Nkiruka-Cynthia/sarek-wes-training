# Getting Started

## Step 1 — Open Codespace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Nkiruka-Cynthia/sarek-wes-training)

Or: **Code → Codespaces → Create codespace on main**

Wait ~3 minutes. Setup is automatic. You will see:
✅ Setup complete! You are ready to run: bash main.sh

---

## Step 2 — Run the Lessons (optional, instant)

nextflow run course/01_samplesheet.nf      # Understand the samplesheet
nextflow run course/02_fastp_qc.nf         # QC concepts
nextflow run course/03_alignment.nf        # Alignment concepts
nextflow run course/04_variant_calling.nf  # Variant calling concepts

---

## Step 3 — Run the Full Pipeline

bash main.sh

Expected runtime: ~20 minutes. Pipeline completed successfully = done.

---

## Step 4 — Explore Results

# QC report — open in browser
results/multiqc/multiqc_report.html

# Variant calls
zcat results/variant_calling/strelka/NA12878_1/NA12878_1.variants.vcf.gz | grep -v "^#" | head -20

# VEP annotation example
cat examples/annotated_example.vcf

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| nextflow: command not found | Run: bash .devcontainer/post-install.sh |
| Cannot find ~/sarek-39 | Run: bash .devcontainer/post-install.sh |
| Samplesheet validation failed | Run: bash .devcontainer/post-install.sh |
| Pipeline fails mid-run | Re-run bash main.sh — -resume restarts where it stopped |
| Out of memory | Upgrade Codespace to 4-core in GitHub settings |

---

## Further Reading

- nf-core/sarek docs: https://nf-co.re/sarek
- Nextflow docs: https://www.nextflow.io/docs/latest/
- Syntax quick-ref: course/REFERENCE.md