# Write-up 6: Project 2: Machine Learning

**Name:** Franklin Lurie 
**Student ID:** flurie  
**Date:** 12/11/2025

## Project Proposal

### 1. Project Overview

- **Overarching goal**  
  The goal of my proposed project is to identify the core proteins involved in fungal metabolism that are broadly conserved across a range of species. In doing so, I hope to elucidate patterns in nutrient assimilation across fungal species, and better understand how specific pathways are conserved between fungal organisms.

- **Rationale**  
  Fungi are critical organisms responsible for nutrient cycling in diverse ecosystems, however, the specific metabolism underlying these processes remains poorly understood. Compared to other kingdoms of life, we know little about fungi and their varied lifestyles. It is estimated that there are (conservatively) at least 1.5 million different fungal species, yet only ~155,000 have been described to date, and far fewer have been sequenced and even remotely studied [Source](https://www.sciencedirect.com/science/article/pii/S0960982225001162). 

  Because of their unique biology and promise as robust biomanufacturing hosts, a key challenge in selecting organisms for functional characterization and engineering is understading which metabolic pathways are conserved across various lineages, versus those that are merely specialized adaptations. For example, white-rot fungi are the only known organisms capable of degrading lignin, the second-most abundant yet highly recalcitrant plant biopolymer. However, the specific pathways and enzymes involved in lignin decomposition and assimilation remain poorly characterized, and it is unclear whether these mechanisms are conserved across different white-rot fungi species. ([Source](https://pmc.ncbi.nlm.nih.gov/articles/PMC2698378/), [Source](https://www.nature.com/articles/s42003-025-07640-9)).

  This project aims to address these gaps by identifying core metabolic proteins and pathways conserved across taxonomically diverse fungal species, and elucidate patterns in nutrient assimilation between different types of fungi. In doing so, this analysis will yield insights into which components of fungal metabolism are broadly conserved, or are lineage-specific adaptations for specific biological functions. Finally, this data will help guide the selection of biomanufacturing host organisms with desired metabolic pathways for specialized functions (e.g., lignin degradation).

- **Specific aims**

  - **Aim 1:** Identify and label core proteins conserved across 2000 taxonomically-diverse fungal species.
    - **Expected outcomes** I hope to identify the set of essential proteins require for core fungal metabolic processes across a taxonomically-diverse set of organisms.
    - **Potential challenges** Comparative analysis across 2000 fungal genomes (~50Mbp each [Source](https://en.wikipedia.org/wiki/Fungal_genome)) seems like a very computationally-intensive task, so this aim may need to be scaled-back accordingly. I also know that the annotation quality of the different genomes available in the dataset I plan to use will be variable. I will use protein embedding-based clustering to assess conservation (>30% structural identity, as suggested by Khoa) of poorly-annotated proteins that may be metabolically important. Finally, I will also need to define what "core" means for these proteins -- I think a starting threshold of ~90% conservation across my taxonomically-diverse dataset is a good starting point, but which may need to be adjusted.

  - **Aim 2:** Perform deeper analysis of specific nutrient assimilation pathways (e.g., lignin decomposition) and whether they are conserved across 100 different white-rot fungi species.
    - **Expected outcomes** I hope to catalog the proteins involved in lignin decomposition, and map this full pathway to better understand variations in its architecture between species.
    - **Potential challenges** Because white-rot fungi are a small subset of the limited number of fungi sequenced to date, I am not sure whether there are 100 different species for me to analyze -- I will need assess this further by looking at the database in more detail. Also, the specific enzymes involved in lignin decomposition are not well-understood, and some may still be "hypothetical proteins" with unknown function in these pathways. I will use protein embeddings to identify protein homologs that match the few experimentally-verified proteins involved in these pathways. Otherwise, additinal transcriptomic data may need to be generated to address this challenge.

### 2. Data

- **Dataset description** The dataset I plan to work with is the Department of Energy Joint Genome Institute's (JGI) [Mycocosm portal](https://link.springer.com/protocol/10.1007/978-1-0716-2871-3_14#Sec17), which contains the genomes of >2000 fungal species and functional annotations from a range of databases (e.g., GO, KEGG, Pfam, etc.). I plan to leverage these existing annotations, and use protein embeddings to detect remote homologs that may not be captured by the JGI's (presumably) sequence-based annotation pipeline.
  - **Source** This is a publicly-accessible tool!
  - **Size** I could not find the total size of the database, but each genome and associated annotations seems to be around ~0.1-1GB of files. For 2000 genomes, this is ~200GB-2TB of raw data across 2000 "samples".
  - **Format** The database contains genome sequence (.fasta) and annotation (.gff) files, as well as the associated function / pathway annotation (e.g. Pfam, KEGG, etc.) files.

- **Data suitability**
  - While I have all the files I need for my pipeline, I think it would make sense to combine all of the files into a master database to accelerate querying and analysis through my pipeline. Like we looked at in class, I think I would want to build an SQL database that stores the all the proteins, their sequences, and associated annotations for each of my 2000 genomes.
  - Other than doing this initial database contruction, I think that I do not need to do any additional pre-processing for my pipeline.

- **Storage and data management**
  - Because my database will be quite large (~200GB-2Tb), it does not make sense to store this on a local machine. Instead, I will store my SQL database on Google Cloud Storage, as it has relatively low costs, and allows for large datasets like mine to be stored and easily shared between collaborators. Also, it can be coupled with Google's BigQuery tools for large-scale data analysis, which may also be useful in my project!
  - I think that Google Cloud Storage automatically backs up the data I store there, so I will not need to do any additional backup steps...
  - I can add other people to the Google Cloud Storage / BigQuery project through their UIs, allowing collabortators to access the same data I am using!

### 3. Environment

- **Coding environment**
  - Because I will be handling large datasets and computationally-heavy tasks, I think it would make the most sense to use HPC on a remote server. 
  - To code my project, I think using a code-server setup like we have done in class will allow for easier editing, debugging, and visulization of the file structure of my project.

- **Dependencies**
  - The key tools I will need for my analysis are:
    - the entire Biopython package! --> for handling .fasta and .gff files easily [Source](https://github.com/biopython/biopython/blob/master/README.rst)
    - NumPy --> dependency for Biopython
    - rclone --> for interfacing with Google Cloud Storage / BiqQuery
    - MMSeqs2 --> for rapidly searching and clustering proteins [Source](https://github.com/soedinglab/MMseqs2)
    - ESM-2 --> for generating protein embeddings [Source](https://github.com/facebookresearch/esm?tab=readme-ov-file)
    - seqhub --> another way of deteting remote homolgs using .fasta files, as suggested by Khoa
    - matplotlib / seaborn --> for any visualizations I might want to make!

- **Reproducibility**
  - I will ensure that my work is reproducible by using GitHub to manage and track changes I (or collaborators) make to the pipeline I propose building for this project.
  - To prevent conflicts between packages, I also think it would be prudent to containerize my work so that it can be run by anyone else on their own HPC system.
  - Finally, I will include an environment.yaml file that lists all of the specific packages and dependencies for my pipeline, allowing for easy resporudibility and debugging.

### 4. Pipeline

- **Algorithms and methods**  
  After building my SQL database (see preprocesing, above), my pipeline would be the following:

  1. To identify "core" proteins conserved across fungal species (Aim 1):
    - Query the database and group proteins by their KOG annotation.
    - For proteins with low-quality annotations, or no KOG annotations, I would use a layered approach as discussed with Khoa:
        - I would first try to compare the Pfam domains of the proteins, to see if the poorly-annotated protein could be matched to one that is well-annotated  based on functionality instead of sequence.
        - If this fails, then I would move on to an embedding-based comparison to see if remote homologs could be matched this way.
    - After identifying the KOGs conserved across 90% of species in my database and make visualizations to present this data.
  
  2. To perform deeper analysis of specific nutrient assimilation pathways (Aim 2):
    - Query the database to select the 100 white-rot fungi species I want to look at (I would probably need a list of species to query the database with)
    - Using the proteins identified in [this paper](https://www.nature.com/articles/s42003-025-07640-9) and other relevant lignin degradation literature, I will aggregate their sequences and annotations
    - I will then query the white-rot fungi species subset of my database to search for homologs using the Pfam, KEGG, and CAZyme annotations in my database. 
        - If this fails because of poor annotations or only "hypothetical proteins" being available, I will again use an embedding-based comparison to see if remote homologs could be matched this way instead.
    - I will generate a visualization of the main lignin decomposition pathway architecture (if present), and highlight taxonomic differences between white-rot species (as applicable).
  
  The main dependency I can think of in the pipeline described here is that I will first need to build protein embeddings before I can try to match a poorly-annotated protein to a well-annotated one. However, I likely want to avoid building protein embeddings for EVERY protein in my dataset, so I might need to manually run this part of the pipeline after evaluating whether the KOG/Pfam/KEGG annotation matches are any good with the specific proteins that I am struggling to match.

- **Scalability and efficiency** 
  - By using SQL queries and accelerations (e.g., indexing and chunking, as we'd discussed in class) wherever possible, I will ensure that my pipeline runs efficiently on a large dataset!

### 5. Machine Learning

- **Task definition**  
  An unsupervised learning task I can think of doing on my dataset to expand Aim 2 would be to cluster all proteins from white-rot fungi using protein embeddings to identify functionally related protein families that are specifically enriched in white-rot species compared to other fungi. This could help identify new gene clusters involved in lignin degradation that are as of yet unknown, or other metabolic processes that are unique to these organisms!

- **Feature representation**  
  I would convert the raw protein sequence data into a numerical form suitable for ML modeling by using protein embeddings, which are numerical vectors that encode 3D protein structures.

- **Model selection**  
  I would use the [Foldseek](https://github.com/steineggerlab/foldseek) tool for generating the embeddings and doing clustering at the same time! (Recommended to me by Khoa for this type of task). As described earlier, clustering based on embeddings is better for detecting remote homologs, and will likely yield better results than sequence-based approaches here.

- **Generalization strategy** (for supervised learning)  
  N/A (this is an unsupervized task).

- **Evaluation metrics**  
  Because this is a clustering task, the specific evaluation metrics I would need to use are the **Silhouette Score** or **Davies-Bouldin Index** [Source](https://www.geeksforgeeks.org/machine-learning/clustering-metrics/)[Source](https://scikit-learn.org/stable/modules/clustering.html#davies-bouldin-index). The silhouette score essentially measures how dense and well-separated clusters are, while the Davies-Bouldin index measures how close clusters to each other relative to their sizes. Both of these metrics evaluate how well the clustering algorithm has worked by assessing a combination of how tightly the data is clustered, and whether clusters are overlapping or well-separated. These metrics would give me an indication whether my clustering has been successful, or if my model is overfitting the data!

---
## Acknowledgement
Khoa Hoang