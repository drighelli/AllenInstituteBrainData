#' @importFrom tools R_user_dir
#' @importFrom BiocFileCache BiocFileCache
.initCache <-
    function(path=tools::R_user_dir("AllenInstituteBrainData", "cache"),
        verbose=FALSE)
{
    bfc <- BiocFileCache::BiocFileCache(cache=path, ask=FALSE)
    options("AIBDCache"=bfc@cache)
    invisible(bfc)
}

#' @importFrom BiocFileCache BiocFileCache removebfc
.rmCache <- function(ask=TRUE)
{
    cache <- getOption("AIBDCache")
    BiocFileCache::removebfc(BiocFileCache::BiocFileCache(cache), ask=ask)
}

#' @importFrom BiocFileCache BiocFileCache
.getCache <- function()
{
    cache <- getOption("AIBDCache")
    return (BiocFileCache::BiocFileCache(cache))
}

#' @importFrom BiocFileCache bfccache
.getCachePath <- function()
{
    return(BiocFileCache::bfccache(.getCache()))
}

.createRName <- function(single.mtd)
{
    paste0(single.mtd[["DataType"]], "_", gsub(" ", "_", single.mtd[["Title"]]))
}

#' @importFrom BiocFileCache bfcadd
.addResource <- function(mtd.dt, verbose=TRUE)
{
    sub.mtd <- .getMetadataDataType(mtd.dt)
    urls <- file.path(sub.mtd$Location_Prefix, sub.mtd$RDataPath)
    cache <- .getCache()
    ladds <- lapply(seq_along(urls), function(i)
    {
        rnamei <- .createRName(sub.mtd[i,])
        if ( !.checkCacheEntry(rnamei, basename(urls[i])) )
        {
            if(verbose) message("Adding \"", rnamei, "\" to cache.\n",
                "This process may require some time.")
            BiocFileCache::bfcadd(x=cache, rname=rnamei, fpath=urls[i])
        } else {
            warning("Cache entry \"", rnamei,
                "\" already exists, not overwriting it.\n",
                "Use .owResource function to overwrite.")
            return()
        }
    })
    return(ladds)
}

#' @importFrom BiocFileCache bfcinfo
.checkCacheEntry <- function(rname, filename)
{
    cache <- .getCache()
    df <- BiocFileCache::bfcinfo(cache)
    if ( rname %in% df$rname )
    {
        # if ( length(grep(basename(filename), basename(df$rpath))) != 0 )
            return(TRUE)
    }
    return(FALSE)
}

#' @importFrom BiocFileCache bfcinfo bfcquery
.getResource <- function(mtd.dt)
{
    cache <- .getCache()
    sub.mtd <- .getMetadataDataType(mtd.dt)

    if ( length(grep(mtd.dt, BiocFileCache::bfcinfo(cache)$rname)) == 0 )
    {
        .addResource(mtd.dt=mtd.dt)
    }

    ladds <- lapply(seq_len(nrow(sub.mtd)), function(i)
    {
        rnamei <- .createRName(sub.mtd[i,])
        res <- BiocFileCache::bfcquery(cache, rnamei)
    })
    ladds <- do.call(rbind, ladds)
    return(ladds)
}

.readMetadata <- function()
{
    # filepath <- system.file("extdata/metadata.csv",
    #     package="AllenInstituteBrainData")
    filepath <- "inst/extdata/metadata.csv"
    mtd <- read.csv(file=filepath, header=TRUE)
    return(mtd)
}

.getMetadataDataType <- function(mtd.dt)
{
    mtd <- .readMetadata()
    sub.mtd <- mtd[mtd[["DataType"]] == mtd.dt,]
    if ( dim(sub.mtd)[1] == 0 )
        stop(paste0("The requested \"", mtd.dt,
            "\" DataType is not present in the metadata file" ))
    return(sub.mtd)
}
