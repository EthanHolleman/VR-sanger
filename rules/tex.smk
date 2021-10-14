
rule format_run_template:
    input:
        blast_heatmaps=expand(
            'output/plots/blast-heatmaps/{run_name}/{seq_file}/{run_name}-{seq_file}-heatmap.png',
            allow_missing=True, seq_file=align_files
        ),
        read_length_plot='output/plots/read-length-plots/{run_name}/{run_name}-read-lengths.png',
        # alignment_plots=expand(
        #     'output/plots/alignment-plots/{run_name}/{seq_file}/{run_name}-{seq_file}-alignment.png',
        #     allow_missing=True, seq_file=align_files
        # )
    params:
        run_name=lambda wildcards: wildcards.run_name,
        run_date=lambda wildcards: wildcards.run_name.split('_')[0].strip(),
        num_runs=lambda wildcards: len(sample_names_dict[wildcards.run_name])
    output:
        'output/tex/{run_name}.tex'
    script:'../scripts/formatTexTemplate.py'


rule main_document:
    input:
        expand(
            'output/tex/{run_name}.tex', run_name=run_names
        )
    output:
        'output/tex/completeReport.tex'
    script:'../scripts/generateMainTex.py'


rule render_pdf:
    conda:
        '../envs/tex.yml'
    input:
        'output/tex/completeReport.tex'
    output:
        'output/report/completeReport.pdf'
    params:
        output_dir='output/report'
    shell:'''
    mkdir -p {params.output_dir}
    /usr/bin/pdflatex -interaction nonstopmode -output-directory {params.output_dir} -output-format pdf {input}
    '''


