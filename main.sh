#!/bin/bash
#
# main.sh
# ~~~~~~~
# Single entry script for the complete Sarek WES training pipeline.
# For 30-minute practical: students run this ONE command.
#
# Usage:
#   bash main.sh
#
# Expected runtime: ~15 minutes (with conda on test data)

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Sarek WES Training — 30-Minute Practical Exercise          ║"
echo "║  Complete pipeline: FASTQ → Aligned BAM → Variant VCF        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check Nextflow
if ! command -v nextflow &> /dev/null; then
    echo "❌ ERROR: Nextflow not found."
    echo "   Install with: curl -fsSL https://get.nextflow.io | bash"
    exit 1
fi

echo "✓ Nextflow found: $(nextflow -version 2>&1 | head -1)"
echo ""

# Activate conda environment if it exists
if [ -f "$CONDA_PREFIX/etc/profile.d/conda.sh" ]; then
    source "$CONDA_PREFIX/etc/profile.d/conda.sh"
    conda activate sarek-wes 2>/dev/null || true
    echo "✓ Conda environment activated"
fi

echo ""
echo "⏱️  Running Sarek WES pipeline (test data, ~15 minutes)..."
echo ""
echo "Stages:"
echo "  1. FASTP: Quality control on raw FASTQ files"
echo "  2. BWA-MEM: Align reads to GRCh38 reference genome"
echo "  3. MarkDuplicates: Remove PCR duplicates"
echo "  4. Strelka: Variant calling (germline & somatic)"
echo "  5. VEP: Variant annotation with functional predictions"
echo "  6. MultiQC: Aggregate QC metrics"
echo ""

# Run Sarek WES pipeline
nextflow run nf-core/sarek \
  -profile conda,test_wes \
  --input "$REPO_ROOT/data/samplesheet.csv" \
  --outdir "$REPO_ROOT/results" \
  --tools strelka,vep \
  --skip_tools baserecalibrator \
  -resume

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "✅ Pipeline complete!"
echo ""
echo "📊 Results locations:"
echo "   • Aligned BAMs:       results/bam/"
echo "   • Variant calls:      results/variant_calling/strelka/"
echo "   • Annotated VCFs:     results/annotation/vep/"
echo "   • QC report:          results/multiqc/multiqc_report.html"
echo ""
echo "📖 Next steps:"
echo "   1. Open results/multiqc/multiqc_report.html in your browser"
echo "   2. Inspect VCF files for detected variants"
echo "   3. Read the REFERENCE.md for Nextflow + Sarek concepts"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
