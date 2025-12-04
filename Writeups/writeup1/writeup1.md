# Write-up 1: Setup

**Name:** Franklin Lurie 
**Student ID:** flurie  
**Date:** 11/11/2025  

---

## Overview
This is my write-up for the *Setup* content of the course.

---

## Set up ~/.bashrc profile
I set up my ~/.bashrc profile as follows, using Khoa's template
![Bash Profile Setup](<images/bash profile.png>)

## Set up and test micromamba
I correctly installed micromamba and confirmed that it works by using --version, as follows:
![Micromamba Version Check](<images/Part 1.png>)

## Install Docker Desktop
I installed Docker Desktop, and created a new project on Stanford GitLab called "containers":
![Stanford GitLab Setup](<images/Stanford GitLab setup.png>)

I created a DockerHub account:
![Docker Hub setup](<images/Part 2.png>)

I created a Google Cloud account using my personal email:
![Google Cloud setup](<images/Google Cloud.png>)

I installed Nextflow on Farmshare:
![Nextflow install](<images/Nextflow.png>)

I tried to use the Vertex AI workbench, but this did not work for me. Instead, I got set up with Google Colab:
![Google Colab setup](<images/Google Colab.png>)

Finally, I created a Weights & Biases account:
![Weights & Biases setup](<images/Weights & Biases.png>)

---
## SLURM warm-up questions:
1. Only **one** SLURM array job will submitted, but this array job will create **3 separate tasks** indexed with 0, 1, and 2 through the `#SBATCH --array=0-2` line.
2. The purpose of the `if` statement is to divide the `data.txt` file between the three parallel SLURM tasks created in the array job. It does this by selecting lines of `data.txt` using the modulo (%) operator and comparing them with the SLURM_ARRAY_TASK_ID. For example, the first line (line 0) of `data.txt`will be selected for processing in Task 0 through this `if` statement because it meets this condition.
3. The expected output in each `*.out` file would be the following:

warmup_1_0.out
```
0: 12
3: 8
```

warmup_1_1.out
```
1: 7
4: 27
```

warmup_1_2.out
```
2: 91
5: 30
```

## Acknowledgement
Collaborator: Ginny Paparcen