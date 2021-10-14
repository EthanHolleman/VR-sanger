# Visualze the results of BLAST alignments
library(ggplot2)
library(ggpubr)
library(viridis)
library(gridExtra)
library(RColorBrewer)
library(grid)

read.outfmt.six <- function(file.path){

    file.path <- as.character(file.path)
    fmt.six.headers <- c(
        "qseqid","sseqid","pident","length","mismatch","gapopen",
        "qstart","qend","sstart","send","evalue","bitscore"
        )

    info <- file.info(file.path)
    empty <- rownames(info[info$size == 0, ])
    if (!(identical(empty, character(0))) && (empty == file.path)){
        blast.df <- data.frame(matrix(ncol=length(fmt.six.headers), nrow=0))
    }else{
        blast.df <- as.data.frame(read.table(file.path, sep='\t', header=FALSE))
    }   

    colnames(blast.df) <- fmt.six.headers

    return(blast.df)
    
}


make.heatmap <- function(blast.df, align.to){

    blast.df$aligment.length.ident <- (as.numeric(blast.df$pident)/100) * as.numeric(blast.df$length)
    ggplot(blast.df, aes_string(x="qseqid", y="sseqid", fill='aligment.length.ident')) +
            geom_tile(color='black', size=1) + theme_pubr() + 
            labs(x='Reference seqs',y='Sanger sequences', fill='Al*PI', title=align.to) +
            theme(axis.text.x = element_text(angle = 45, hjust=1)) +
            scale_fill_viridis() +
            theme(legend.key.size = unit(3, 'cm'))


}

check.for.alignment <- function(sample.names, blast.df){
    aligned <- sample.names %in% unique(blast.df$qseqid)
    align.df <- data.frame(sample=sample.names, aligned=aligned)
    ggplot(align.df, aes(y=sample.names, x=aligned, fill=aligned)) + 
    geom_tile(color='black', size=1) + theme_pubr() + 
    scale_color_brewer(palette='Dark2') + labs(x='Alignment status', y='') +
    theme(legend.position = "none")

}

arrange.plots <- function(heatmap, table){


    ggarrange(heatmap, table, nrow=1, ncol=2)

}


main <- function(){

    blast.df <- read.outfmt.six(as.character(snakemake@input))
    align.to <- basename(as.character(snakemake@input))
    heatmap <- make.heatmap(blast.df, align.to)
    table <- check.for.alignment(as.vector(snakemake@params[['query_samples']]), blast.df)
    num.samples <- length(snakemake@params[['query_samples']])
    plot <- arrange.plots(heatmap, table)
    ggsave(as.character(snakemake@output), plot, width=12, height=12, dpi=500)

}

if (!interactive()){
    main()
}