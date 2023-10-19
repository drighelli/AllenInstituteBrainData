# A script describing the steps involved in making the data object(s). This
# includes where the original data were downloaded from, pre-processing, and
# how the final R object was made. Include a description of any steps performed
# outside of R with third party software. Output of the script should be files
# on disk ready to be pushed to S3. If data are to be hosted on a personal web
# site instead of S3, this file should explain any manipulation of the data
# prior to hosting on the web site. For data hosted on a public web site with
# no prior manipulation this file is not needed.

# Data are downloaded from Allen Brain portal at
# https://portal.brain-map.org/atlases-and-data/rnaseq both for Human and Mouse
# 2019 and 2020 both with `wget` program.
# Downloaded files are `Table of cell metadata` and `Gene Expression Matrix`
# both in `csv` format.
# Once available on a local machine the following steps have been performed.

# Splitting original matrix.csv in smaller csv files

ngenes=31053 # cols without sample names # check
ncells=1093036 # (NO genes names) # check

j <- 1
for (i in seq(2, ngenes, by=100))
{
    if(j < 10)
    {
        jchr <- paste0("00",j)
    } else if (j < 100) {
        jchr <- paste0("0",j)
    } else {
        jchr <- paste0(j)
    }

    if( i==31002 ) { endcol=ngenes } else { endcol=(i+99) }

    cmd <- paste0("cut -d , -f", i, "-",
                  endcol, " matrix.csv > splitmat/", jchr,"_matrix_", i, "_", endcol, ".csv")
    print(cmd)
    system(cmd)
    j <- j+1
}

# Creating HDF5 Array
library(HDF5Array)
csvs <- list.files("splitmat", patter="csv$", full.names=TRUE)
dest_path <- "splitmat/Allen_Mouse_2020_1/Allen_Brain_2020.h5"
dest_name <- "Allen"

system("head -q -n 1 matrix.csv > genes.csv")
system("cut -d , -f1 matrix.csv > cells.csv")
genes <- rownames(t(read.csv("genes.csv")))[-1] ####### check
sampnames <- read.csv("sample_names.csv") ####### check

sink <- HDF5RealizationSink(
    dim=as.integer(c(ngenes, ncells)),
    type="integer",
    filepath=dest_path,
    name=dest_name,
    chunkdim=as.integer(c(100, 100)))

sink_grid <- rowAutoGrid(sink, nrow=100)
nblock <- length(sink_grid)
for (bid in sort(seq_len(nblock), decreasing=TRUE)) {
    message("Loading ", csvs[[bid]])
    # block <- h5mread(hdf5s[[bid]], "Allen")
    block <- t(read.csv(csvs[[bid]]))
    message("Writing it to ", dest_path)
    viewport <- sink_grid[[bid]]
    message("viewport dim: ", dim(viewport), " block dim: ", dim(block))
    write_block(sink, viewport, block)
}

AMM <- as(sink, "HDF5Array")

rownames(AMM) <- genes
colnames(AMM) <- sampnames

saveHDF5SummarizedExperiment(x=AMM, dir="Allen_Mouse_Brain_2020",
                             prefix="Allen_mmu_20")


######################################################

mtd <- read.csv("~/Downloads/metadata.csv")
genes <- HDF5Array("~/Downloads/expression_matrix.hdf5", "data/gene")
samples <- HDF5Array("~/Downloads/expression_matrix.hdf5", "data/samples")
mtx <- HDF5Array("~/Downloads/expression_matrix.hdf5", name="data/counts")
mtx <- t(mtx)

samples <- as.vector(samples)
colnames(mtx) <- samples
genes <- as.vector(genes)
rownames(mtx) <- genes
idxs <- which(samples %in% mtd$sample_name)
samples1 <- samples[idxs]
mtx <- mtx[,idxs]
length(samples1)
dim(mtx)
idxs <- match(mtd$sample_name, samples1)

samples1 <- samples1[idxs]
mtx <- mtx[, idxs]
head(samples1)
head(mtd$sample_name)
head(colnames(mtx))
se <- SummarizedExperiment(assays=mtx, rowData=genes, colData=mtd)
saveHDF5SummarizedExperiment(x=se, dir="/mnt/callisto/Allen_Ref_SE/Allen_Mouse_Brain_2021/", prefix="Allen_mm_21")


#####################################################


# library(HDF5Array)
library(rhdf5)
h5ls("~/Downloads/smrt.h5")

mtd <- read.csv("~/Downloads/CTX_Hip_anno_SSv4 2/CTX_Hip_anno_SSv4.csv")


table(mtd$subclass_label)


mtd <- read.csv("~/Downloads/metadata.csv")
(tb <- table(mtd$cluster_label))
length(tb)

mtdca1do <- mtd[grep("CA1-do", mtd$cluster_label),]

mtdpros <- mtd[grep("CA1-ProS", mtd$subclass_label),]

table(mtdpros$cluster_label)
table(mtd$subclass_label)



anno21 <- read.csv("/Users/inzirio/Downloads/CTX_Hip_anno_SSv4 2/CTX_Hip_anno_SSv4.csv")

anno20 <- read.csv("~/Downloads/CTX_Hip_anno_10x/CTX_Hip_anno_10x.csv")
dim(anno20)
dim(mtd)


