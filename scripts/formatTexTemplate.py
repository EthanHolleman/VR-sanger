
from pathlib import Path

# Tex templates
IMAGE_TEMPLATE = '''
    \\begin{{figure}}[!h]
        \\includegraphics[width=10cm]{{{}}}
        \\centering
    \\end{{figure}}
'''

def heatmap_tex(heatmap_image_paths):

    return '\n'.join([IMAGE_TEMPLATE.format(str(Path(path).resolve())) for path in heatmap_image_paths])

def complete_document(output_path, *items):
    content = '\n'.join(items)

    with open(output_path, 'w') as handle:
        handle.write(content)


def main():

    # Tex snippets
    section = f"\\section{{{snakemake.params['run_name']}}}".replace('_', '\\_')
    section_descrip = f"""
    Sanger sequencing run completed on {snakemake.params['run_date']}
    including a total of {snakemake.params['num_runs']} sequencing
    run(s).
    """
    pagebreak = '\\pagebreak'
    
    output_path = snakemake.output[0]
    heatmaps = heatmap_tex(snakemake.input['blast_heatmaps'])
    complete_document(
        output_path, section, section_descrip, heatmaps, pagebreak)


if __name__ == '__main__':
    main()





