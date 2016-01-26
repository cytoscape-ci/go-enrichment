library("clusterProfiler")
library("DOSE")
library("KEGG.db")

count.go <- function(genes, ontology, species, level=3) {
    go <- groupGO(gene = genes, organism = species,
                    ont=ontology,level=level,readable=TRUE)
    return(go)
}

enrich.go <- function(genes, ontology, species) {
    ego <- enrichGO(gene=genes,
                universe=names(geneList),
                organism=species,
                ont=ontology,
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.01,
                qvalueCutoff  = 0.05,
                readable      = TRUE)
    return(ego)
}

#data(geneList)
#genes <- names(geneList)[abs(geneList) > 2]

geneTable <- read.table(file="gene_result.txt", header=TRUE, sep="\t", fill=TRUE)
genes_all <- geneTable$GeneID

genes_original <- genes_all[1:30]
genes_original

genes <- as.character(genes_original)
genes


# Compute
goMF <- count.go(genes, ontology="MF", species="human")
goCC <- count.go(genes, ontology="CC", species="human")
goBP <- count.go(genes, ontology="BP", species="human")

egoMF <- enrich.go(genes, ontology="MF", species="human")
egoCC <- enrich.go(genes, ontology="CC", species="human")
egoBP <- enrich.go(genes, ontology="BP", species="human")


# Write results
write.csv(attr(goMF, "result"), file = "go-MF.csv")
write.csv(attr(goCC, "result"), file = "go-CC.csv")
write.csv(attr(goBP, "result"), file = "go-BP.csv")

write.csv(attr(egoMF, "result"), file = "go-egoMF.csv")
write.csv(attr(egoCC, "result"), file = "go-egoCC.csv")
write.csv(attr(egoBP, "result"), file = "go-egoBP.csv")

barplot(goMF,  font.size = 6, drop=TRUE, showCategory=10, order=TRUE, title="GO MF Term Distribution")
barplot(goCC,  font.size = 6, drop=TRUE, showCategory=10, order=TRUE, title="GO CC Term Distribution")
barplot(goBP,  font.size = 6, drop=TRUE, showCategory=10, order=TRUE, title="GO BP Term Distribution")

barplot(egoMF, drop=TRUE, showCategory=10, title="Over-represented GO MF Terms")
barplot(egoCC, drop=TRUE, showCategory=10, title="Over-represented GO CC Terms")
barplot(egoBP, drop=TRUE, showCategory=10, title="Over-represented GO BP Terms")

cnetplot(egoBP, categorySize="pvalue", foldChange=geneList)

# KEGG
kk <- enrichKEGG(gene         = genes,
                 organism     = "human",
                 pvalueCutoff = 0.05,
                 readable     = TRUE,
                 use_internal_data = TRUE)
head(summary(kk))
write.csv(attr(kk, "result"), file = "kegg.csv")

barplot(kk, drop=TRUE, showCategory=10, title="Over-represented KEGG Pathways")

# Disease Ontology
do <- enrichDO(gene=genes,
              ont           = "DO",
              pvalueCutoff  = 0.05,
              pAdjustMethod = "BH",
              universe      = names(geneList),
              minGSSize     = 5,
              qvalueCutoff  = 0.05,
              readable      = TRUE)

write.csv(attr(do, "result"), file = "disease.csv")
barplot(do, drop=TRUE, showCategory=10, title="Over-represented Disease Ontology Terms")
