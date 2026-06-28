# Nextflow + Sarek Quick Reference

## Nextflow Basics (30-second recap)

### Channels: Data streams

```groovy
// Load from CSV samplesheet
channel
    .fromPath('samplesheet.csv')
    .splitCsv(header: true)
    .map { row -> [row.patient, row.sample, file(row.fastq_1)] }
```

### Process: A task (aligned with tool)

```groovy
process ALIGN_READS {
    input:
    tuple val(sample), path(fastq)
    
    output:
    tuple val(sample), path('*.bam')
    
    script:
    """bwa mem -t ${task.cpus} ref.fa ${fastq} | samtools sort -o ${sample}.bam"""
}
```

### Workflow: Orchestrates processes

```groovy
workflow {
    ch_reads = channel.fromPath('*.fastq.gz')
    ALIGN_READS(ch_reads)
    VARIANT_CALLING(ALIGN_READS.out)
}
```

---

## Sarek WES Pipeline (30-second recap)

```
FASTQ
  ↓
FASTP ──→ Quality control & adapter trimming
  ↓
BWA-MEM ──→ Align reads to reference genome
  ↓
MarkDuplicates ──→ Remove PCR duplicates
  ↓
Strelka ──→ Call germline & somatic variants
  ↓
VEP ──→ Annotate with functional predictions
  ↓
MultiQC ──→ Aggregate QC metrics
  ↓
VCF + HTML report
```

---

## Key Concepts for 30-min Practical

### WES vs. WGS

| Feature | WES (today's lesson) | WGS |
|---------|------|-----|
| Coverage | ~100-200x (exons only) | ~30x (whole genome) |
| Cost | Lower ✓ | Higher |
| Speed | Faster | Slower |
| Data size | ~10-50 GB | ~100-200 GB |

### Samplesheet Columns (Sarek)

```csv
patient,sample,lane,fastq_1,fastq_2,status
patient1,NA12878_1,L001,sample_R1.fastq.gz,sample_R2.fastq.gz,0
```

- `patient`: Groups samples from same individual
- `sample`: Unique sample ID
- `status`: 0=normal, 1=tumor (enables somatic calling)

### Variant Types

- **SNV**: Single nucleotide variant (A→G)
- **Indel**: Insertion/deletion (ATG→A)
- **Germline**: Inherited, all cells
- **Somatic**: Acquired, cancer cells only

---

## Running Commands for 30-min Practical

### Lesson 1: Samplesheet (instant)

```bash
nextflow run course/01_samplesheet.nf
```

### Full Pipeline (~15 min)

```bash
bash main.sh
```

Equivalent to:
```bash
nextflow run nf-core/sarek \
  -profile conda,test_wes \
  --input data/samplesheet.csv \
  --outdir results \
  --tools strelka,vep \
  --skip_tools baserecalibrator \
  -resume
```

---

## VCF File Format (Quick peek)

### Header (lines starting with ##)

```
##fileformat=VCFv4.2
##reference=file:///path/to/reference.fa
```

### Column headers (#CHROM...)

```
#CHROM  POS     ID    REF  ALT   QUAL  FILTER  INFO
```

### Data row

```
chr1    100001  .     A    G     .     PASS    DP=50;AF=0.5
chr1    100100  .     AT   A     .     PASS    DP=40;AF=0.75
```

- **#CHROM**: Chromosome
- **POS**: Position (1-based)
- **REF**: Reference allele (A)
- **ALT**: Alternate allele (G)
- **QUAL**: Phred-scaled quality (higher=better)
- **FILTER**: PASS or reason for filtering
- **INFO**: Variant annotations (DP=depth, AF=allele frequency)

### After VEP Annotation

CSQ field added with predictions:
```
CSQ=frameshift|HIGH|TP53|ENSG000031|deleterious|probably_damaging|25.3
    └─Consequence    └─Impact  └─Gene  └─Protein  └─SIFT  └─PolyPhen  └─CADD score
```

---

## Key Files in Results

```
results/
├── bam/
│   ├── patient1/NA12878_1.bam      ← Aligned reads
│   └── patient2/tumor_sample.bam
├── variant_calling/strelka/
│   ├── patient1/germline.vcf.gz    ← Germline variants (patient1)
│   ├── patient2/somatic.vcf.gz     ← Somatic variants (patient2)
│   └── patient2/normal.vcf.gz      ← Normal sample variants
├── annotation/vep/
│   ├── patient1/germline.vep.vcf.gz    ← Annotated variants
│   └── patient2/somatic.vep.vcf.gz
└── multiqc/
    └── multiqc_report.html         ← Open in browser for QC dashboard
```

---

## Troubleshooting for 30-min Practical

### Setup taking too long
- Pre-create Codespace before class
- Or use local conda environment

### Pipeline stuck
- Check `cat .nextflow.log` for errors
- Re-run with `-resume` to continue from last task

### Want to see variant calls while running
```bash
tail -f .nextflow.log
```

### View results before pipeline finishes
```bash
ls results/bam/patient1/
zcat results/variant_calling/strelka/patient1/*.vcf.gz | head -30
```

---

## Cheatsheet: 30-min timeline

| Time | What to do | Command |
|------|-----------|----------|
| 0–5 min | Setup Codespace | Wait, terminal shows `✓ Setup complete!` |
| 5–8 min | Run samplesheet lesson | `nextflow run course/01_samplesheet.nf` |
| 8–25 min | Run full pipeline | `bash main.sh` (watch task progress) |
| 25–30 min | Explore results | `ls results/`, open `multiqc_report.html` |

---

## Resources for deeper learning (after class)

- [nf-core/sarek docs](https://nf-co.re/sarek/)
- [Nextflow tutorial](https://www.nextflow.io/docs/latest/)
- [VCF specification](https://samtools.github.io/hts-specs/VCFv4.2.pdf)
- [Ensembl VEP](https://www.ensembl.org/info/docs/tools/vep/index.html)
