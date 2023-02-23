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

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Caenorhabditis elegans", ahub$title)]
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
    ),

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Rattus norvegicus", ahub$title)]
    `10116` = c(
        "AH64982",
        "AH68010",
        "AH69261",
        "AH73956",
        "AH75088",
        "AH78871",
        "AH79776",
        "AH83318",
        "AH89282",
        "AH89528",
        "AH95846",
        "AH98149",
        "AH100745",
        "AH104966",
        "AH109438"
    ),

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Macaca fascicularis", ahub$title)]
    `9541` = c(
        "AH64937",
        "AH67964",
        "AH69203",
        "AH73898",
        "AH75029",
        "AH78802",
        "AH79709",
        "AH83237",
        "AH89201",
        "AH89447",
        "AH95765",
        "AH98068",
        "AH100664",
        "AH104885",
        "AH109357"
    ),

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Drosophila melanogaster", ahub$title)]
    `7227` = c(
        "AH64903",
        "AH67929",
        "AH69165",
        "AH73857",
        "AH74985",
        "AH78755",
        "AH79659",
        "AH83185",
        "AH89149",
        "AH89395",
        "AH95713",
        "AH98016",
        "AH100612",
        "AH104833",
        "AH109306"
    ),

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Danio rerio", ahub$title)]
    `7955` = c(
        "AH64906",
        "AH67932",
        "AH69169",
        "AH73861",
        "AH74989",
        "AH78759",
        "AH79663",
        "AH83189",
        "AH89153",
        "AH89399",
        "AH95717",
        "AH98020",
        "AH100616",
        "AH104837",
        "AH109309"
    ),

    # ahub$ah_id[grepl("Ensembl.*EnsDb.*Pan troglodytes", ahub$title)]
    `9598` = c(
        "AH64979",
        "AH68007",
        "AH69257",
        "AH73952",
        "AH75084",
        "AH78866",
        "AH79771",
        "AH83313",
        "AH89277",
        "AH89523",
        "AH95841",
        "AH98144",
        "AH100740",
        "AH104961",
        "AH109433"
    )
)

#########################################################

ribo.profiles <- list(
    `9606` = "^RP[LS][0-9]",
    `10090` = "^Rp[ls][0-9]",
    `6239` = "^rp[ls]-[0-9]",
    `10116` = "^Rp[ls][0-9]",
    `9541` = "^RP[LS][0-9]",
    `7227` = "^Rp[LS][0-9]",
    `7955` = "^rp[ls][0-9]",
    `9598` = "^RP[LS][0-9]"
)

mito.names <- list(
    `9606` = "MT",
    `10090` = "MT",
    `6239` = "MtDNA",
    `10116` = "MT",
    `9541` = "MT",
    `7227` = "mitochondrion_genome",
    `7955` = "MT",
    `9598` = "MT"
)

vdj.present <- c(
    "9606", 
    "10090", 
    "10116", 
    "9541",
    "7955",
    "9598"
)

#########################################################

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

        is.mito <- info$SEQNAME %in% mito.names[[spec]]
        blacklists$mito$ensembl <- union(blacklists$mito$ensembl, info$GENEID[is.mito])
        blacklists$mito$symbol <- union(blacklists$mito$symbol, info$SYMBOL[is.mito])
        blacklists$mito$entrez <- union(blacklists$mito$entrez, info$ENTREZID[is.mito])

        is.ribo <- grepl(ribo.profiles[[spec]], info$SYMBOL)
        blacklists$ribo$ensembl <- union(blacklists$ribo$ensembl, info$GENEID[is.ribo])
        blacklists$ribo$symbol <- union(blacklists$ribo$symbol, info$SYMBOL[is.ribo])
        blacklists$ribo$entrez <- union(blacklists$ribo$entrez, info$ENTREZID[is.ribo])

        if (spec %in% vdj.present) {
            is.vdj <- grepl("^TR_", info$GENEBIOTYPE) | grepl("^IG_", info$GENEBIOTYPE)
            blacklists$vdj$ensembl <- union(blacklists$vdj$ensembl, info$GENEID[is.vdj])
            blacklists$vdj$symbol <- union(blacklists$vdj$symbol, info$SYMBOL[is.vdj])
            blacklists$vdj$entrez <- union(blacklists$vdj$entrez, info$ENTREZID[is.vdj])
        }
    }

    if (!(spec %in% vdj.present)) {
        blacklists$vdj <- NULL
    }

    for (type in names(blacklists)) {
        for (x in names(blacklists[[type]])) {
            path <- paste0(spec, "-", type, "-", x, ".txt.gz")
            con <- gzfile(path, open="wb")
            writeLines(con=con, setdiff(sort(blacklists[[type]][[x]]), ""))
            close(con)
        }
    }
}
