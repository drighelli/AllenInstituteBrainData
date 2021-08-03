context("metadata validity")

test_that("metadata is valid",
{
    metadata <- system.file("extdata", "metadata.csv", package = "AllenInstituteDemo")
    expect_true(testExperimentHubMetadata("AllenInstituteDemo", metadata))
})
