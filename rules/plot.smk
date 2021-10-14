
rule make_blast_heatmap:
    conda:
        '../envs/R.yml'
    input:
        'output/blast-results/{run_name}.{seq_file}.tsv'
    output:
        'output/plots/blast-heatmaps/{run_name}/{seq_file}/{run_name}-{seq_file}-heatmap.png'
    params:
        query_samples=lambda wildcards: sample_names_dict[wildcards.run_name],
    script:'../scripts/plotting/blastHeatmap.R'


rule make_read_length_table:
    conda:
        '../envs/Py.yml'
    input:
        'runs/{run_name}/all_text.fas'
    output:
        'output/plots/data/{run_name}/{run_name}-read-lengths.tsv'
    script:'../scripts/read_length.py'


rule make_read_length_plot:
    conda:
        '../envs/R.yml'
    input:
        'output/plots/data/{run_name}/{run_name}-read-lengths.tsv'
    output:
        'output/plots/read-length-plots/{run_name}/{run_name}-read-lengths.png'
    script:
        '../scripts/plotting/readLengths.R'


rule make_alignment_plot:
    conda:
        '../envs/R.yml'
    input:
        'output/blast-results/{run_name}.{seq_file}.tsv'
    output:
        'output/plots/alignment-plots/{run_name}/{seq_file}/{run_name}-{seq_file}-alignment.png'
    script:
        '../scripts/plotting/alignmentViewer.R'

