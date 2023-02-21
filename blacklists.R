# Generates special feature lists.

library(AnnotationHub)
ahub <- AnnotationHub()

species <- list(
    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Mus musculus", ahub$title)]
    `10090` = c(
       "AH64944",
       "AH67971",
       "AH69210",
       "AH73905",
       "AH75036",
       "AH78811",
       "AH79718",
       "AH83247",
       "AH89211",
       "AH89457",
       "AH95775", 
       "AH98078",
       "AH100674",
       "AH104895",
       "AH109367"
    ),

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Homo sapiens", ahub$title)]
    `9606` = c(
        "AH64923",
        "AH67950",
        "AH69187",
        "AH73881",
        "AH73986",
        "AH75011",
        "AH78783", 
        "AH79689",
        "AH83216",
        "AH89180",
        "AH89426",
        "AH95744",
        "AH98047",
        "AH100643",
        "AH104864",
        "AH109336"
    ),

    # ahub$title[grepl("Ensembl.*EnsDb.*Caenorhabditis elegans", ahub$title)]
    `6239` = c(
        "AH64890",
        "AH67916",
        "AH69148",
        "AH73839",
        "AH74964",
        "AH78732",
        "AH79632",
        "AH83155",
        "AH89119",
        "AH89365",
        "AH95683",
        "AH97986",
        "AH100582",
        "AH104803",
        "AH109275"
    )
)

for (spec in names(species)) {
    ids <- species[[spec]]
    blacklists <- list(
        mito = list(ensembl = character(0), symbol = character(0), entrez = character(0)),
        ribo = list(ensembl = character(0), symbol = character(0), entrez = character(0)),
        vdj = list(ensembl = character(0), symbol = character(0), entrez = character(0))
    )

    for (i in ids) {
        ens <- ahub[[i]]
        info <- select(ens, keys=keys(ens), keytype="GENEID", columns=c("GENEID", "SYMBOL", "SEQNAME", "GENEBIOTYPE", "ENTREZID"))

        is.mito <- info$SEQNAME %in% c("MT", "M", "chrM", "chrMT", "MtDNA")
        blacklists$mito$ensembl <- union(blacklists$mito$ensembl, info$GENEID[is.mito])
        blacklists$mito$symbol <- union(blacklists$mito$symbol, info$SYMBOL[is.mito])

        is.ribo <- grepl("^Rp[ls][0-9]", info$SYMBOL, ignore.case=TRUE) 
        blacklists$ribo$ensembl <- union(blacklists$ribo$ensembl, info$GENEID[is.ribo])
        blacklists$ribo$symbol <- union(blacklists$ribo$symbol, info$SYMBOL[is.ribo])

        is.vdj <- grepl("^TR_", info$GENEBIOTYPE) | grepl("^IG_", info$GENEBIOTYPE)
        blacklists$vdj$ensembl <- union(blacklists$vdj$ensembl, info$GENEID[is.vdj])
        blacklists$vdj$symbol <- union(blacklists$vdj$symbol, info$SYMBOL[is.vdj])
    }

    for (type in names(blacklists)) {
        for (x in names(blacklists[[type]])) {
            writeLines(file=paste0(spec, "-", type, "-", x, ".txt"), blacklists[[type]][[x]])
        }
    }
}
