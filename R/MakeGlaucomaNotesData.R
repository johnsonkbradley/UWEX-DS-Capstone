# This file is meant to read in the text files cotaining clinical notes for the
# glaucoma dataset from GitHub. The files will them be combined into one dataset
# which will then be exported to an csv file to perform manual chart review
# that will act as a baseline / key for the information retrieval process

# Created: 6/16/2024 1:06 MST
# Last updated: 6/16/2024 1:06 MST

# Load in any packages----
library(dplyr)
library(readtext)

# Set working directory----
# setwd("~/DataScienceMasters/DS785/R")

# Read in the data from the txt files----
glauc <- readtext(file = "../Data/Glaucoma_Med_Dataset-main/Deidentified_Notes") # 480

# Export the data----
# write.csv(glauc, file = "../Data/glaucoma_notes.csv")
