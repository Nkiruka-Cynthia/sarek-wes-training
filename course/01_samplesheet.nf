#!/usr/bin/env nextflow
/*
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LESSON 1: Understanding the WES Samplesheet (2–3 min)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Quick lesson teaching:
    - CSV samplesheet format for Sarek
    - How Nextflow parses metadata
    - Channel operations on tabular data

    Run:
        nextflow run course/01_samplesheet.nf

    Expected output: 4 samples printed instantly (~3 seconds)
*/

nextflow.enable.dsl = 2

params.input = "${projectDir}/data/samplesheet.csv"

workflow {
    println("""
        ╔════════════════════════════════════════════════════════════════╗
        ║  LESSON 1: WES Samplesheet Structure (2–3 min)                ║
        ║                                                                ║
        ║  How does Nextflow read multi-sample WES data?               ║
        ║  → Answer: From a simple CSV file!                            ║
        ╚════════════════════════════════════════════════════════════════╝
    """)

    println("\n📄 Reading samplesheet: ${params.input}\n")

    // Load and parse the CSV
    ch_samples = channel
        .fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def meta = [
                patient: row.patient,
                sample: row.sample,
                lane: row.lane,
                status: row.status ?: '0'
            ]
            [
                meta,
                file(row.fastq_1, checkIfExists: false),
                file(row.fastq_2, checkIfExists: false)
            ]
        }

    // Display samples
    ch_samples.view { meta, r1, r2 ->
        "✓ [${meta.patient}, ${meta.sample}, ${r1.name}, ${r2.name}, status=${meta.status}]"
    }

    // Summary
    ch_samples
        .collect()
        .view { samples ->
            "\n📊 Total samples: ${samples.size()}\n"
        }

    println("""
        📖 Key columns in samplesheet.csv:
        • patient:  Groups samples from same individual
        • sample:   Unique sample identifier
        • lane:     Sequencing lane
        • fastq_1:  Forward reads (R1)
        • fastq_2:  Reverse reads (R2)
        • status:   0=normal, 1=tumor (for somatic variant calling)

        💡 This CSV structure allows Sarek to:
        • Handle multiple patients
        • Process multiple samples per patient
        • Compare tumor vs. normal pairs for somatic calling
        • Scale to 100+ samples with no code changes!
    """)
}
