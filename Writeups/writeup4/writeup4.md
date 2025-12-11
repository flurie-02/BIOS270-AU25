# Write-up 4: Pipeline

**Name:** Franklin Lurie 
**Student ID:** flurie  
**Date:** 12/10/2025

---
## SLURM pipeline
Like we'd discussed in class, if we want to add a DESeq2 stemp to the `rnaseq_pipeline_array_depend.sh` script such that it runs only after all the `salmon`jobs are completed, we wuold need to create a list of the salmon jobs that are running and keep track of their Job IDs as dependencies so that DESeq2 only runs after all of these `salmon` jobs have finished. I ouwld do this using the `--parsable` and `--dependency` keywords, like is done in the `rnaseq_pipeline_array_depend.sh` script for the `salmon` job submissions!

---

## Nextflow pipeline
I did my best to complete this exercise, but I think I am still a bit confused about how to do all of the steps in here correctly...

I started by adding a new `SALMON_INDEX` process to the `salmon.nf` file, using the guidelines in the Nextflow documentation here: https://www.nextflow.io/docs/latest/process.html#output-files-path, as follows:
cd
```bash
process SALMON_INDEX {
    input:
      path transcriptome

    output:
      path ('salmon_index_outs/quant.sf')

    script:
    """
    salmon index -t "${transcriptome.fa}"
                -i "${salmon_outs}"
    """
```

Then, I tried modifying the rnaseq.nf pipeline file to try to run either `SALMON` or `SALMON_INDEX` depending on the params.yaml file. I was not sure of the proper syntax, so I tried to explain what I wanted to do my writing pseudocode instead, as follows:

```bash
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
"""
```

## Running Nextdlow pipeline
1. I edited my `nextflow.config` setup to be the following:
```bash
singularity {
	  enabled = true
	  autoMounts = true
    runOptions = "-B /farmshare/user_data/flurie" # modified to my directory
    cacheDir = '/farmshare/user_data/flurie/repos/BIOS270-AU25/Pipeline/rnaseq_nf/envs/containers
}
```

2. I then modified the output directory path in `rnaseq_nf/configs/params.yaml`as follows:
```bash
samplesheet: "/farmshare/home/classes/bios/270/data/samplesheet.csv"
index: '/farmshare/home/classes/bios/270/data/indexes/ecoli_transcripts_index'
outdir: '/farmshare/user_data/flurie/repos/BIOS270-AU25/Data/processed_data/SRP628437_nf'
run_deseq: true
```

3. I tried running the provided code in this step to make sure the scripts were executable, and got this error message I didn't really understand, as my `bin` directory very much exists...

4. I then tried to run the `nextflow` pipeline, but got another error I didn't understand. I wonder if I installed Nextflow in the wrong directoy? Eiether way, because I was unsure of the syntax / did only attempted to make the modifications to the pipeline outlined in this Write-up, I think the pipline would have failed anyways.

---

## Acknowledgement
Collaborator: Ginny Paparcen, Khoa Hoang, Leslie Chan's bug fix for running the container (shared with my by Khoa)
