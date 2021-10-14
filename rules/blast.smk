from pathlib import Path

rule make_blast_db:
    conda:
        '../envs/blast.yml'
    input:
        seqs='align/{seq_file}.fa',
    output:
        expand(
            'output/blast-dbs/{seq_file}/{seq_file}.{blast_suffi}', 
            allow_missing=True, blast_suffi=BLAST_SUFFI
            )
    params:
        db_dir=lambda wildcards: f'output/blast-dbs/{wildcards.seq_file}',
        db_name=lambda wildcards: f'output/blast-dbs/{wildcards.seq_file}/{wildcards.seq_file}',
        seq_file_name = lambda wildcards: wildcards.seq_file
    shell:'''
    mkdir -p {params.db_dir}
    makeblastdb -in {input.seqs} -parse_seqids -title "{params.seq_file_name}" -dbtype nucl -out {params.db_name}
    '''


rule run_blast:
    conda:
        '../envs/blast.yml'
    input:
        db=expand(
            'output/blast-dbs/{seq_file}/{seq_file}.{blast_suffi}', 
            allow_missing=True, blast_suffi=BLAST_SUFFI
            ),
        seqs='runs/{run_name}/all_text.fas'
    params:
        db_path=lambda wildcards: f'output/blast-dbs/{wildcards.seq_file}/{wildcards.seq_file}',
        output_dir='output/blast-results'
    output:
        'output/blast-results/{run_name}.{seq_file}.tsv'
    shell:'''
    mkdir -p {params.output_dir}
    cat {input.seqs} | blastn -db {params.db_path} -perc_identity 0 -outfmt 6 > {output}
    '''

