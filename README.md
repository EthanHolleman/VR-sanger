# VR-sanger

Snakemake workflow to generate reports on VR insert verification from sanger sequencing data .

## Usage

Configure `run.sh` for your system and run the workflow from the outermost workflow directory with `./run.sh`. 

### Input data

Primary input data is Sanger sequening runs completed by Quintara BioSciences.
Runs are returned as a directory of `fasta` and `abi` formatted files along 
with one fasta file called `all_text.fas` which contains fasta sequences
of all runs. It is currently critical `all_text.fas` is present.

