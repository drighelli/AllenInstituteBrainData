context("metadata validity")

test_that("metadata is valid",
{
    metadata <- system.file("extdata", "metadata.csv",
        package="AllenInstituteBrainData")
    # expect_true(testExperimentHubMetadata("AllenInstituteDemo", metadata))
    expect_true(ExperimentHubData::makeExperimentHubMetadata(
        "AllenInstituteBrainData", metadata))
})
