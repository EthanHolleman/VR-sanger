
# Get table of read lengths to pass to R script for plotting

from Bio import SeqIO
import pandas as pd


def len_table(records):
    lengths = []
    for each_record in records:
        attrs = {
            'record': str(each_record.description),
            'length': len(each_record)
        }
        lengths.append(attrs)
    return pd.DataFrame(lengths)


def main():
    
    
    records = SeqIO.parse(str(snakemake.input), 'fasta')
    table = len_table(records)
    table.to_csv(str(snakemake.output), sep='\t')

if __name__ == '__main__':
    main()


