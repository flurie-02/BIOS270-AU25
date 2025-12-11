// RNA-seq QC → Trim Galore → Salmon + DESeq2 (from CSV samplesheet)
// Expect a CSV with columns: sample,read1,read2,condition
// No intermediate samples.csv is generated; DESeq2 infers quant.sf paths
// from --outdir/<sample>/salmon_outs/quant.sf
nextflow.enable.dsl=2

include { FASTQC } from './modules/qc/fastqc.nf'
include { TRIMGALORE } from './modules/qc/trimgalore.nf'
include { SALMON } from './modules/pseudoalign/salmon.nf'
include { DESEQ2 } from './modules/diffexp/deseq2.nf'

// -------------------- Channels --------------------
def samplesheet_ch = Channel
  .fromPath(params.samplesheet)
  .ifEmpty { error "Missing --samplesheet file: ${params.samplesheet}" }

samples_ch = samplesheet_ch.splitCsv(header:true).map { row ->
    tuple(row.sample.trim(), file(row.read1.trim(), absolute: true), file(row.read2.trim(), absolute:true), row.condition.trim())
}


// -------------------- Workflow --------------------

workflow {
    FASTQC(samples_ch)
    trimmed_ch = TRIMGALORE(samples_ch)
    
// I could not figure our the specific syntax of how to do this, but here is my pseudo-code instead:
""" if( params.yaml contains index ) {
        quant_ch   = SALMON(trimmed_ch, params.index)
            
        if( params.run_deseq ) {
        // Collect all Salmon outputs into a map {sample: quant_path}

        quant_paths_ch = quant_ch
            .map { sample, quant, cond -> "${sample},${quant}" }
            .collectFile(
                name: "quant_paths.csv", 
                newLine: true, 
                seed: "sample,quant_path"  // This adds the header as the first line
            )
        DESEQ2(quant_paths_ch, samplesheet_ch)
        }
    }

    else if ( params.yaml contains transcriptome ) {
        index_path = SALMON_INDEX(transcriptome)         // run SALMON_INDEX to generate the index from the transcriptome path and store the directory output
     
        quant_ch   = SALMON(trimmed_ch, index_path)    // access the newly-generated index file, and run SALMON
        
        quant_paths_ch = quant_ch
            .map { sample, quant, cond -> "${sample},${quant}" }
            .collectFile(
                name: "quant_paths.csv", 
                newLine: true, 
                seed: "sample,quant_path"  // This adds the header as the first line
            )
        DESEQ2(quant_paths_ch, samplesheet_ch)
        }
    }

    else:
        print("Either an index file or transcriptome file path must be provided to run this pipeline. Pipeline terminated early and error added to log directory.")
        log.error "Neither index nor transcriptome file path provided. Pipeline terminated early."
    }
}
workflow.onComplete {
    log.info "Pipeline finished. Results in: ${params.outdir}"
}