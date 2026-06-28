#!/bin/bash
#
# post-install.sh
# ~~~~~~~~~~~~~~~
# Codespace auto-setup for 30-minute practical.
# Creates conda environment + installs Nextflow.
#

set -e

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Sarek WES Training — Environment Setup (auto, <2 min)       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check conda
echo "✓ Conda: $(conda --version)"
echo ""

# Create conda environment
echo "📦 Creating conda environment: sarek-wes"
conda create -n sarek-wes -y -c bioconda -c conda-forge \
  nextflow=25.10.0 \
  bwa=0.7.17 \
  samtools=1.17 \
  bcftools=1.17 \
  gatk4=4.4.0.0 \
  mosdepth=0.3.6 \
  multiqc=1.14 \
  > /dev/null 2>&1

echo ""
echo "✓ Conda environment created"
echo ""

# Initialize conda
conda init bash 2>/dev/null || true

# Activate environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate sarek-wes

echo "✓ Nextflow: $(nextflow -version 2>&1 | head -1)"
echo "✓ BWA: $(bwa 2>&1 | grep -E 'Version|Sai' || echo 'installed')"
echo "✓ Samtools: $(samtools --version | head -1)"
echo ""

echo "════════════════════════════════════════════════════════════════"
echo ""
echo "✅ Setup complete! Ready for 30-minute practical."
echo ""
echo "📖 Quick start:"
echo ""
echo "  1. Understand samplesheet (instant):"
echo "     nextflow run course/01_samplesheet.nf"
echo ""
echo "  2. Run full pipeline (~15 min):"
echo "     bash main.sh"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
