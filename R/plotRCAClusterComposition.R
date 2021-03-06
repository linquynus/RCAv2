#' Plot bar plots showing the composition of RCA clusters
#'
#' @param rca.obj data matrix (genes x cells)
#' @param deepSplit provides the index of the clustering to use for different cuts in the hierarchical clustering (default is 1)
#' @param folderpath path to save heatmap to
#' @param filename file name of saved heatmap
#' @export
#'

plotRCAClusterComposition <- function(rca.obj, deepSplit=1, folderpath = ".", filename = "Cluster_Composition.pdf") {
    require(dplyr)    
    if (!(is.null(rca.obj$cell.Type.Estimate))){
    # Extract projection data and clustering result from RCA object
    heatmapIn = as.matrix(rca.obj$projection.data)
    cellTree = rca.obj$clustering.out$cellTree
    clusterColors = rca.obj$clustering.out$dynamicColorsList[[deepSplit]]
    
    # Compute the composition of each clust with respect to per cell cell type predictions
    enrichmentAll<-c()
    for(type in unique(clusterColors)){
	index=which(clusterColors==type)
        enrichmentAll<-rbind(enrichmentAll,(cbind(type,table(unlist(rca.obj$cell.Type.Estimate)[index]))))
    }
    enrichmentAll<-data.frame(cbind(row.names(enrichmentAll),enrichmentAll))
    colnames(enrichmentAll)<-c("CT","Cluster","Count")
    rownames(enrichmentAll)<-c(1:dim(enrichmentAll)[1])
    enrichmentAll$Count<-as.numeric(as.character(enrichmentAll$Count))
    totalCounts<-data.frame(count(enrichmentAll,wt=Count,Cluster))
    enrichmentAll<-left_join(enrichmentAll,totalCounts,by="Cluster")
    enrichmentAll<-cbind(enrichmentAll,enrichmentAll$Count/enrichmentAll$n*100)
    colnames(enrichmentAll)[5]<-"Ratio"
    enrichmentAll$Ratio<-as.numeric(as.character(enrichmentAll$Ratio))

    #Generate the cluster composition plots using the randomcolorR package if available
    if (require(randomcoloR)){
       dColors<-randomcoloR::distinctColorPalette(length(unique(enrichmentAll$CT)))
       nCols<-ceiling(length(unique(enrichmentAll$CT))/26)
       ratioPlot<-ggplot2::ggplot(enrichmentAll,aes(x=Cluster,y=Ratio,fill=CT))+geom_bar(stat="identity")+theme_bw(15)+ylab("Percentage")+coord_flip()+ggtitle("a)")+theme(legend.position = "none")+scale_fill_manual(values=dColors)
       countPlot<-ggplot2::ggplot(enrichmentAll,aes(x=Cluster,y=Count,fill=CT))+geom_bar(stat="identity")+theme_bw(15)+ylab("Count")+coord_flip()+ggtitle("b)")+scale_fill_manual(values=dColors)+labs(fill="Cell type")+guides(fill=guide_legend(ncol=nCols))
    }
    else{
       ratioPlot<-ggplot2::ggplot(enrichmentAll,aes(x=Cluster,y=Ratio,fill=CT))+geom_bar(stat="identity")+theme_bw(15)+ylab("Percentage")+coord_flip()+ggtitle("a)")+theme(legend.position = "none")
       countPlot<-ggplot2::ggplot(enrichmentAll,aes(x=Cluster,y=Count,fill=CT))+geom_bar(stat="identity")+theme_bw(15)+ylab("Count")+coord_flip()+ggtitle("b)")+labs(fill="Cell type")+guides(fill=guide_legend(ncol=nCols))
    }
   pdf(paste0(folderpath,"/Heatmap_Composition_",filename),width=15+(nCols-1),height=7)
   grid.arrange(ratioPlot,countPlot,widths=c(1,(1.4+(nCols-1)/10),nrow=1))
   dev.off()
}else{
	print("Cell specific estimates are not computed yet")
}}
