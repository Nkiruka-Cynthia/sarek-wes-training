#!/bin/bash
#
# main.sh
# ~~~~~~~
# Single entry script for the complete Sarek WES training pipeline.
# Students run ONE command: bash main.sh
#
# Expected runtime: ~15-20 minutes on a 2-core/8GB GitHub Codespace

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Sarek WES Training - Practical Exercise                     ║"
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
echo "✓ Java found: $(java -version 2>&1 | head -1)"
echo "✓ Docker found: $(docker --version 2>&1)"

# Verify Docker daemon is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ ERROR: Docker daemon is not running."
    echo "   Please start Docker Desktop and try again."
    exit 1
fi
echo "✓ Docker daemon is running"
echo ""

echo "Running Sarek WES pipeline...
echo ""
echo "Stages that will run:
echo "  1. FASTP         → Quality control on raw FASTQ reads
echo "  2. BWA-MEM       → Align reads to reference genome
echo "  3. MarkDuplicates → Remove PCR duplicates from BAM
echo "  4. Strelka       → Variant calling (germline + somatic)
echo "  5. MultiQC       → Aggregate all QC metrics into one report
echo ""
echo "Note: Annotation (VEP) is shown via examples/annotated_example.vcf"
echo "      — it needs a large cache download unsuitable for live sessions."
echo ""

# Run Sarek using Docker
# Genome and resource limits are set in nextflow.config
nextflow run $HOME/sarek-39 \
  -profile docker \
  --input "$REPO_ROOT/data/samplesheet.csv" \
  --outdir "$REPO_ROOT/results" \
  --genome testdata.nf-core.sarek \
  --igenomes_base 'https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/' \
  --tools strelka \
  --skip_tools baserecalibrator \
  --wes \
  --disable_wave \
  -resume

echo ""
echo "════════════════════════════════════════════════════════════════
echo Pipeline complete!
echo ""
echo Results locations:
echo "   • Preprocessing:   results/preprocessing/
echo "   • Variant calls:   results/variant_calling/strelka/
echo "   • QC report:       results/multiqc/multiqc_report.html
echo "   • Pipeline info:   results/pipeline_info/
echo ""
echo Next steps:
echo "   1. Open results/multiqc/multiqc_report.html in your browser
echo "   2. Inspect VCF files:
echo "      # Germline samples:
echo "      zcat results/variant_calling/strelka/NA12878_1/*.vcf.gz | head -50
echo "      zcat results/variant_calling/strelka/NA12878_2/*.vcf.gz | head -50
echo "      # Somatic tumour vs normal:"
echo "      zcat results/variant_calling/strelka/tumor_sample_vs_normal_sample/*.vcf.gz | head -50
echo "   3. Compare with examples/annotated_example.vcf to see what
echo "      VEP annotation adds on top of these raw variant calls
echo "      cat examples/annotated_example.vcf | head -80
echo "   4. Read course/REFERENCE.md for Nextflow + Sarek concepts
echo ""
echo "════════════════════════════════════════════════════════════════
echo ""