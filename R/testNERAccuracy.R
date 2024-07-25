####################################
# This is the file for  the data extraction methods
# testNERAccuracy.R
# Created: Monday July 8 5:33 PM MST
# Last updated: Thursday July 25 4:33 PM MST 
####################################

# Load in the methods created----
source("./DataExplorationMethods.R")
source("./DataPreProcessingMethods.R")
source("./DataExtractionMethods.R")

# Read in the medical dataset----
med <- read.csv("../Data/medical_data.csv") # 744

# Look at the first 20 observations----
tempmed <- med[1:20,]

## Extract just the Past Medical History Section----
tempmed$PMH <- sapply(tempmed$TEXT, structuredExtract,
                            label = "Past Medical History",
                            resultEndChar = "\\n\\n",
                            separator = ":")

## Run the NER----
bigList <- lapply(tempmed$PMH, myNER)

## Manually view the data to check for accuracy
View(bigList[[1]])

# Diagnoses of interest that I trained into the model----
# AICD
# A-fib
# CAD
# CABG
# CHF
# HTN / hypertension
# Fracture
# bradycardia
# arrhythmia
# cancer
# myositis
# anemia
# osteoarthritis
# carcinoma
# hyperlipidemia
# tachycardia
# Bipolar
# Depression
# Insomnia
# GERD
# Asthma
# Hypothyroid / thyroid
# dementia
# EMD
# pneumonia
# plantar fasciitis
# stroke

