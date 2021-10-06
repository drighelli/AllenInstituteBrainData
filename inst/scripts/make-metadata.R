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


b.data <- data.frame(
    DataType="test",
    Title = c("test1", "test2"),
    Description = c(
        "Single-cell RNA-seq data for mouse brain annotation 2020"
    ),
    Location_Prefix= "https://www.dundeecity.gov.uk/" ,
    RDataPath = c("sites/default/files/publications/civic_renewal_forms.zip"),
    BiocVersion="3.13",
    Genome="mm10",
    SourceType=c("TEXT"),
    SourceUrl="mine",
    SourceVersion="1.0.0",
    Species="Mus musculus",
    TaxonomyId="10090",
    Coordinate_1_based=TRUE,
    DataProvider="Allen Institue for Brain Science",
    Maintainer="Dario Righelli <dario.righelli@gmail.com>",
    RDataClass=c("no"),
    DispatchClass=c("TEXT")
)

 # write.csv(file="inst/extdata/metadata.csv", rbind(main.data,b.data), row.names=FALSE)
