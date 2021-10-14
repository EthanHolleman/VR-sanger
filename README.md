# VR-sanger

Snakemake workflow to generate reports on VR insert verification from sanger sequencing data .

## Usage

Configure `run.sh` for your system and run the workflow from the outermost workflow directory with `./run.sh`. 

### Input data

Primary input data is Sanger sequening runs completed by Quintara BioSciences.
Runs are returned as a directory of `fasta` and `abi` formatted files along 
with one fasta file called `all_text.fas` which contains fasta sequences
of all runs. It is currently critical `all_text.fas` is present. Sequencing
runs are incorporated into the analysis by dropping them into the `runs` directory.

### Sequence alignment

Primary purpose of Sanger runs here are to verify the successful insertion
of VR inserts into specific vectors (see [plasmid-VR-design](https://github.com/EthanHolleman/plasmid-VR-design) and [VR-cloning-protocol](https://github.com/EthanHolleman/VR-cloning-protocol) for more details on this). To do this,
all Sanger sequences are aligned against all VR insert reference sequences
using BLAST. Plasmids sent for sequencing that contain a successful insertion
should show strong alignment to one VR insert.

## Output

Currently the primary output is a tex report containing visualizations of
sequences to VR insert reference sequences. Currently working on getting
`pdflatex` working via conda. Once that is up and running final output
will be pdf version of tex document.



