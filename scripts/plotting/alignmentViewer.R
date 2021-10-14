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


alignment.plot <- function(blast.df){


    blast.df$xmin=seq(from = 0.25, to = nrow(blast.df), length.out = nrow(blast.df))
    blast.df$xmax = blast.df$xmin + 1
    g <- ggplot(blast.df, aes(ymin=qstart, ymax=qend, xmin=xmin, xmax=xmax,fill=sseqid)) +
     geom_rect(stat='identity', color='black') + facet_wrap(~qseqid) + 
     theme_pubr() + coord_flip() + theme(axis.text.y = element_blank()) +
     scale_fill_viridis(discrete=TRUE)
    
    g
}

main <- function(){

    blast.df <- read.outfmt.six(
        as.character(snakemake@input)
    )
    plot <- alignment.plot(blast.df)
    ggsave(
        as.character(snakemake@output), plot, dpi=500, width=14, height=10
    )

}

if (!interactive()){

    main()

}

