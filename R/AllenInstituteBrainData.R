#' AllenInstituteBrainData
#'
#' @param dataset the identifier of the Allen brain dataset to retrieve
#'
#' @return
#' @importFrom HDF5Array loadHDF5SummarizedExperiment
#' @export
#'
#' @examples
#' se <- AllenInstituteBrainData("Allen_Human_2020")
#' se
#'
AllenInstituteBrainData <- function(dataset=c("Allen_Mouse_2020"))
{
    dataset <- match.arg(dataset)
    # hub <- ExperimentHub()


    tt <- untar("~/Downloads/CTX_Hip_anno_10x.csv.tar",
        exdir=tools::R_user_dir("ExperimentHub", which="cache"))
    anno <- read.csv(file.path(tools::R_user_dir("ExperimentHub",
        which="cache"), "CTX_Hip_anno_10x", "CTX_Hip_anno_10x.csv"), row.names=1)

    aa <- HDF5Array("~/Downloads/CTX_Hip_counts_10x.h5", name="data/counts") ## This works!!!!
    gg <- HDF5Array("~/Downloads/CTX_Hip_counts_10x.h5", name="data/gene") ## This works!!!!
    ss <- HDF5Array("~/Downloads/CTX_Hip_counts_10x.h5", name="data/samples") ## This works!!!!

    aa <- t(aa)
    idxs <- match(as.vector(ss), anno$sample_name)
    anno <- anno[idxs,]

    # umaptar <- untar("~/Downloads/CTX_Hip_umap_10x.csv.tar", exdir=tools::R_user_dir("ExperimentHub", which="cache"))
    # umap <- read.csv(file.path(tools::R_user_dir("ExperimentHub",
    #                 which="cache"), "CTX_Hip_umap_10x", "CTX_Hip_umap_10x.csv"), row.names=2)
    #
    # umap <- umap[,-1]
    #
    # which

    # seH5Array <- SummarizedExperiment::SummarizedExperiment(assays=SimpleList(counts=aa), rowData=gg, colData=anno)
    sceH5Array <- SingleCellExperiment::SingleCellExperiment(assays=SimpleList(counts=aa), rowData=gg, colData=anno)
        # assays=SimpleList(counts=aa), rowData=gg, colData=anno)
    # sceH5Array <- SingleCellExperiment::SingleCellExperiment(assays=SimpleList(counts=aa), rowData=gg, colData=anno)
    # SingleCellExperiment::reducedDim(sceH5Array) <- umap
    return(sceH5Array)
}
