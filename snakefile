import pandas as pd
from pathlib import Path

RUN_DIR = 'runs'
ALIGN_DIR = 'align'

BLAST_SUFFI = [
    'ndb'
]

def gather_run_names(*args, **kwargs):
    target_dir = Path(RUN_DIR)
    return [str(d.stem) for d in target_dir.iterdir()]


def gather_alignment_files(*args, **kwargs):
    return [str(f.stem) for f in Path(ALIGN_DIR).iterdir()]


def get_sample_names_dict(run_names, *args, **kwargs):
    sn_dict = {}
    for each_run in run_names:
        # get path to each sanger run
        run_dir = Path(RUN_DIR).joinpath(each_run)
        # Quintara adds "__" and then date of seq run to each file that is
        # is returned. However fasta headers only contain text that occurs
        # before the "__". Splitting on "__" and taking first value then
        # gives fasta headers.
        headers = set([str(f.stem).split('__')[0] + '_' for f in run_dir.iterdir()])
        if 'all_text_' in headers:
            headers.remove('all_text_')
        sn_dict[each_run] = list(headers)

    return sn_dict

run_names = gather_run_names()
align_files = gather_alignment_files()
sample_names_dict = get_sample_names_dict(run_names)



include: 'rules/blast.smk'
include: 'rules/plot.smk'
include: 'rules/tex.smk'


rule all:
    input:
        'output/report/completeReport.pdf'

