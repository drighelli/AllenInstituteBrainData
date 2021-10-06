
.initCache <-
    function(path=tools::R_user_dir("AllenInstituteBrainData", "cache"),
        verbose=FALSE)
{
    bfc <- BiocFileCache::BiocFileCache(cache=path, ask=FALSE)
    options("AIBDCache"=bfc@cache)
    invisible(bfc)
}

.rmCache <- function(ask=TRUE)
{
    cache <- getOption("AIBDCache")
    BiocFileCache::removebfc(BiocFileCache::BiocFileCache(cache), ask=ask)
}

.getCache <- function()
{
    cache <- getOption("AIBDCache")
    return (BiocFileCache::BiocFileCache(cache))
}

.addResource <- function(mtd.dt, verbose=TRUE)
{
    sub.mtd <- .getMetadataDataType(mtd.dt)
    urls <- file.path(sub.mtd$Location_Prefix, sub.mtd$RDataPath)
    cache <- .getCache()
    ladds <- lapply(seq_along(urls), function(i)
    {
        rnamei <- gsub(" ", "_", sub.mtd[["Title"]][i])
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

.checkCacheEntry <- function(rname, filename)
{
    cache <- .getCache()
    df <- BiocFileCache::bfcinfo(cache)
    if ( rname %in% df$rname )
    {
        if ( length(grep(basename(filename), basename(df$rpath))) != 0 )
            return(TRUE)
    }
    return(FALSE)
}

.getResource <- function(mtd.dt)
{
    cache <- .getCache()
    sub.mtd <- .getMetadataDataType(mtd.dt)
    if ( length(grep(sub.mtd, bfcinfo(cache)$rname)) == 0 )
    {
        .addResource(mtd.dt=mtd.dt)
    }
    ladds <- lapply(seq_along(url), function(i)
    {
        rnamei <- gsub(" ", "_", sub.mtd[["Title"]][i])
        res <- BiocFileCache::bfcquery(cache, rnamei)
    })
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
