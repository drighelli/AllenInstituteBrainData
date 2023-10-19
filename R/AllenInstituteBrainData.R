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
#' se <- AllenInstituteBrainData("Allen_Mouse_2020")
#' se
#'
AllenInstituteBrainData <- function(dataset=c("Allen_Mouse_2020", "Allen_Mouse_2021"),
    verbose=TRUE, DataClass=c("SingleCellExperiment", "SummarizedExperiment"))
{
    dataset <- match.arg(dataset)
    # hub <- ExperimentHub()

    if (verbose) message("Retrieving ", dataset, " data...")
    ress <- .getResource(dataset)
    if (verbose) message("Processing retrieved data ...")

    sceH5Array <- .createSCE(ress, dataset)
    return(sceH5Array)
}

.createSCE <- function(ress, dataset)
{

    for (i in seq_len(nrow(ress)))
    {
        if ( length(grep(pattern="annotation", ress[i, "rname"])) !=0 )
        {
            annofn <- .getAnnoFn(ress[i, "rpath"], dataset)
            anno <- read.csv(annofn, row.names=1)
        } else {
            h5p <- file.path(ress[i, "rpath"])
            cnts <- HDF5Array::HDF5Array(h5p, name="data/counts")
            genes <- HDF5Array::HDF5Array(h5p, name="data/gene")
            smpls <- HDF5Array::HDF5Array(h5p, name="data/samples")
            cnts <- t(cnts)
        }
    }
    idxs <- match(as.vector(smpls), anno$sample_name)
    anno <- anno[idxs,]
    sceH5Array <- SingleCellExperiment::SingleCellExperiment(
        assays=S4Vectors::SimpleList(counts=cnts), rowData=genes,
        colData=anno)
    return(sceH5Array)
}

.getAnnoFn <- function(respath, dataset)
{
    switch (dataset,
            "Allen_Mouse_2020" = {
                tt <- utils::untar(tarfile=as.character(respath),
                                   exdir=.getCachePath())
                annofn <- file.path(.getCachePath(), "CTX_Hip_anno_10x",
                                    "CTX_Hip_anno_10x.csv")
            },
            "Allen_Mouse_2021" = {
                annofn <- as.character(respath)
            }
    )
    return(annofn)
}
