# A script to make the metadata.csv file located in inst/extdata of the package.
# See ?AnnotationHubData::makeAnnotationHubMetadata for a description of the
# metadata.csv file, expected fields and data types. This
# AnnotationHubData::makeAnnotationHubMetadata() function can be used to
# validate the metadata.csv file before submitting the package.


main.data <- data.frame(
    DataType="Allen_Mouse_2020",
    Title = c("Brain Mouse 2020 assay",
              "Brain Mouse 2020 annotation"),
    Description = c(
        "Single-cell RNA-seq data for mouse brain annotation 2020",
        "Single-cell RNA-seq data for mouse brain annotation 2020"
    ),
    Location_Prefix= "http://data.nemoarchive.org/" ,
    RDataPath = c("biccn/grant/u19_zeng/zeng/transcriptome/scell/10x_v2/mouse/processed/YaoHippo2020/CTX_Hip_counts_10x.h5",
                  "biccn/grant/u19_zeng/zeng/transcriptome/scell/10x_v2/mouse/processed/YaoHippo2020/CTX_Hip_anno_10x.csv.tar"),
    BiocVersion="3.13",
    Genome="mm10",
    SourceType=c("HDF5", "tar.gz"),
    SourceUrl="http://data.nemoarchive.org/",
    SourceVersion="1.0.0",
    Species="Mus musculus",
    TaxonomyId="10090",
    Coordinate_1_based=TRUE,
    DataProvider="Allen Institue for Brain Science",
    Maintainer="Dario Righelli <dario.righelli@gmail.com>",
    RDataClass=c("HDF5Array", "SummarizedExperiment"),
    DispatchClass=c("H5File", "Rds")
)


main.data21 <- data.frame(
    DataType="Allen_Mouse_2021",
    Title = c("Brain Mouse 2021 assay",
              "Brain Mouse 2021 annotation"),
    Description = c(
        "Single-cell RNA-seq data for mouse brain annotation 2021",
        "Single-cell RNA-seq data for mouse brain annotation 2021"
    ),

    Location_Prefix= "https://idk-etl-prod-download-bucket.s3.amazonaws.com/" ,
    RDataPath = c("aibs_mouse_ctx-hpf_10x/expression_matrix.hdf5",
                  "aibs_mouse_ctx-hpf_10x/metadata.csv"),
    BiocVersion="3.13",
    Genome="mm10",
    SourceType=c("HDF5", "tar.gz"),
    SourceUrl="http://portal.brain-map.org/",
    SourceVersion="1.0.0",
    Species="Mus musculus",
    TaxonomyId="10090",
    Coordinate_1_based=TRUE,
    DataProvider="Allen Institue for Brain Science",
    Maintainer="Dario Righelli <dario.righelli@gmail.com>",
    RDataClass=c("HDF5Array", "SummarizedExperiment"),
    DispatchClass=c("H5File", "Rds")
)
write.csv(file="inst/extdata/metadata.csv", rbind(main.data,main.data21), row.names=FALSE)



al <- read.csv("/Users/inzirio/Downloads/CTX_Hip_anno_SSv4/CTX_Hip_anno_SSv4.csv")

library(HDF5Array)
h5smrt <- HDF5Array::


table(al$subclass_label)

mtd <- read.csv("")

load("~/Downloads/dend.RData")















