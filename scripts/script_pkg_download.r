#' Get package dependencies
#'
#' @param packs A string vector of package names
#'
#' @return A string vector with packs plus the names of any dependencies
rm(list = ls())
library(here)

getDependencies <- function(packs){
  dependencyNames <- unlist(
    tools::package_dependencies(packages = packs, db = available.packages(), 
                                which = c("Depends", "Imports"),
                                recursive = TRUE))
  packageNames <- union(packs, dependencyNames)
  packageNames
}
# Calculate dependencies
list_pkg <- c("ggpubr", "ggthemes", "ggtext")

packages <- getDependencies(list_pkg)

# Download the packages to the working directory.
# Package names and filenames are returned in a matrix.

pkgInfo <- download.packages(pkgs = packages, destdir = here("packages"), type = "win.binary")
# Save just the package file names (basename() strips off the full paths leaving just the filename)
write.csv(file = here("packages", "pkgFilenames.csv"), basename(pkgInfo[, 2]), row.names = FALSE)



# Set working directory to the location of the package files
setwd(here("packages"))

# Read the package filenames and install
pkgFilenames <- read.csv("pkgFilenames.csv", stringsAsFactors = FALSE)[, 1]
install.packages(pkgFilenames, repos = NULL, type = "win.binary")

