# Write-up 2: Environment

**Name:** Franklin Lurie
**Student ID:** flurie
**Date:** 11/13/2025  

---

## 1. Micromamba
I created and activated the micromamba environment:
![Activated micromamba environment](<activated environment.png>)

I found and ran both test scripts (the pyton one did not produce a command-line output for me):
![Test scripts run](<ran test scripts.png>)

`python_example.py`output plot:
![python example output](python_example_plot.png)

`r_example.R` output plot:
![R example output](r_example_plot.png)

I successfully installed `rpy2` and exported the new environment:
![Updated environment](<install rpy2 and export new environment.png>)

Compared to the original environment, the main new change I notice from the above is that rpy2 is now installed!
![Updated and original environments](<updated vs original environment.png>)

Micromamba helpful commands:
- List all created environments:
```bash
micromamba env list
# or
micromamba info --envs
```

- List all packages installed in a specific environment
```bash
micromamba list -n bioinfo_example
#or, if the environment is already activated:
micromamba list
```

- Remove a package
```bash
remove package_name
```

- Install a package from a specific channel
```bash
micromamba install -c channel_name package_name
```

- Remove an environment
```bash
micromamba env remove -n bioinfo_example
```

- What are all the `r-base` and `Bioconductor` packages that were installed in the `bioinfo_example` environment? (Hint: You may want to use one of the commands from your answers to the above questions, and combine it with the grep command.)
Using the command `micromamba list | grep " r-"` (the grep command `"^r-"` fails because `list` uses whitespaces), I get the following list of 204 items:
![r-base packages](<r-base packages.png>)

Using the command `micromamba list | grep "bioconductor-"`, I get the following list of 18 items:
![bioconductor packages](<bioconductor packages.png>)

---

## 2. Container

1. I logged in to Docker in my terminal:
![Docker login](<docker login.png>)

and to Stanford GitLab through Farmshare:
![GitLab login](<GitLab login.png>)
(I had to create a new token first, but I did this successfully!):
![Token](token.png)

2. 

3. 

4. 

5. I successfully pulled this more advanced container from Stanford GitLab:
![New container](<pulled container.png>)

6. Run code-server through SSH tunneling:
I did this in OH with Khoa on 11/20/2025! Here is my SSH login and running code-server:
![SSH tunneling](<ssh tunnel.png>)
![Code-Server](code-server.png)
---

## Acknowledgement
Collaborator: Ginny Paparcen
