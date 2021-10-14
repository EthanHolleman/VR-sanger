library(ggplot2)
library(ggpubr)
library(viridis)
library(gridExtra)
library(RColorBrewer)
library(grid)

read.lengths.table <- function(tsv.path){

    as.data.frame(
        read.table(file = tsv.path, sep = '\t', header = TRUE)
    )

}

make.lengths.plot <- function(df){

    colors <- colorRampPalette(brewer.pal(8, "Dark2"))(nrow(df))
    bars <- ggplot(df, aes(x=record, y=length, fill=record)) + 
            geom_bar(stat='identity', color='black', size=1) +
            theme_pubr() + scale_fill_manual(values=colors) +
            theme(legend.position = "none") + 
            labs(x='Read name', y='Read length') +
            theme(axis.text.x = element_text(angle = 45, hjust=1))
    bars

}


main <- function(){

    df <- read.lengths.table(as.character(snakemake@input))
    bars <- make.lengths.plot(df)
    ggsave(
        as.character(snakemake@output),
        bars, dpi=500,  width=12, height=12
        )

}

if (!interactive()){

    main()

}