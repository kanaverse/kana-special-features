# Special feature blacklists for kana

This repository defines a set of special features that can be used in **kana**.
The most obvious motivation is to identify mitochondrial genes for quality control,
but we could also remove ribosomal proteins and immune repertoire gene fragments prior to downstream analysis.

The [`blacklists.R`](blacklists.R) script will go through all available Ensembl releases on Bioconductor's [AnnotationHub](https://bioconductor.org/packages/AnnotationHub),
pulling out "special" features for a bunch of different species.
It will then generate a set of files that are available via the [Releases](https://github.com/kanaverse/kana-special-features/releases).
