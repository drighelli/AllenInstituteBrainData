#' AllenInstituteBrainData
#'
#' @param dataset the identifier of the Allen Brain dataset to retrieve
#'
#' @return
#' @importFrom HDF5Array HDF5Array
#' @importFrom SingleCellExperiment SingleCellExperiment
#' @importFrom S4Vectors SimpleList
#' @importFrom utils untar
#' @export
#'
#' @examples
#' se <- AllenInstituteBrainData("Allen_Human_2020")
#' se
#'
AllenInstituteBrainData <- function(dataset=c("Allen_Mouse_2020"),
    verbose=TRUE, DataClass=c("SingleCellExperiment", "SummarizedExperiment"))
{
    dataset <- match.arg(dataset)
    # hub <- ExperimentHub()

    if (verbose) message("Retrieving ", dataset, " data...")
    ress <- .getResource(dataset)
    if (verbose) message("Processing retrieved data ...")
    switch (dataset,
        "Allen_Mouse_2020" = {
            for (i in seq_len(nrow(ress)))
            {
                if ( length(grep(pattern="annotation", ress[i, "rname"])) !=0 )
                {
                    tt <- utils::untar(tarfile=as.character(ress[i, "rpath"]),
                        exdir=.getCachePath())
                    anno <- read.csv(file.path(.getCachePath(),
                        "CTX_Hip_anno_10x", "CTX_Hip_anno_10x.csv"),
                        row.names=1)
                    # return("anno"=anno)
                } else {
                    h5p <- file.path(ress[i, "rpath"])
                    cnts <- HDF5Array::HDF5Array(h5p, name="data/counts")
                    genes <- HDF5Array::HDF5Array(h5p, name="data/gene")
                    smpls <- HDF5Array::HDF5Array(h5p, name="data/samples")
                    cnts <- t(cnts)
                    # return(list=list("cnts"=cnts, "genes"=genes, "smpls"=smpls))
                }
            }
            # print(class(reslist))
            idxs <- match(as.vector(smpls), anno$sample_name)
            anno <- anno[idxs,]
            sceH5Array <- SingleCellExperiment::SingleCellExperiment(
                assays=S4Vectors::SimpleList(counts=cnts), rowData=genes,
                colData=anno)
        }
    )
    # # umaptar <- untar("~/Downloads/CTX_Hip_umap_10x.csv.tar", exdir=tools::R_user_dir("ExperimentHub", which="cache"))
    # # umap <- read.csv(file.path(tools::R_user_dir("ExperimentHub",
    # #                 which="cache"), "CTX_Hip_umap_10x", "CTX_Hip_umap_10x.csv"), row.names=2)
    # #
    # # umap <- umap[,-1]
    return(sceH5Array)
}
