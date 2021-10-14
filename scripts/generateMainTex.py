from pathlib import Path
from formatTexTemplate import complete_document


# Tex snippits
header = '''
\\batchmode
\\usepackage{float}
\\documentclass[11pt]{article}
\\usepackage[utf8]{inputenc}	% Para caracteres en español
\\usepackage[margin=3cm]{geometry}
\\usepackage{graphicx}
\\usepackage{hyperref}
\\hypersetup{
	colorlinks=true,
	linkcolor=blue,
	filecolor=magenta,      
	urlcolor=cyan,
}
'''

input_formatable = '\input{{{}}}'
document_body = '''
\\begin{{document}}
\\setcounter{{section}}{{0}}
\\title{{Sanger sequencing of VR inserts}}

\\maketitle
\\begin{{abstract}}

This document was automatically generated via Sanger sequencing pipeline blah.

\\end{{abstract}}

\\thispagestyle{{empty}}

{}

\\end{{document}}
'''

def add_sections(section_tex_files):

    return '\n'.join(
        [input_formatable.format(str(Path(tex_file).resolve())) for tex_file in section_tex_files]
    )


def write_document(content, output_path):
    with open(output_path, 'w') as handle:
        handle.write(content)


def main():
    
    sections = add_sections(snakemake.input)
    document_content = document_body.format(sections)
    complete_document(snakemake.output[0], header, document_content)


if __name__ == '__main__':
    main()