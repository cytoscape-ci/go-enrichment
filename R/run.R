library("clusterProfiler")
library("DOSE")

data(geneList)
gene <- names(geneList)[abs(geneList) > 2]
ggo <- groupGO(gene     = gene,
               organism = "human",
               ont      = "BP",
               level    = 3,
               readable = TRUE)
class(ggo)
ggo$result
barplot(ggo, drop=TRUE, showCategory=12)
