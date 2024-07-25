####################################
# This is the file for testing times to perform the NLP techniques
# testTimes.R
# Created: Wednesday July 17 5:36 PM MST
# Last updated: Thursday July 25 4:34 PM MST 
####################################

# Load in the methods created----
source("./DataExplorationMethods.R")
source("./DataPreProcessingMethods.R")
source("./DataExtractionMethods.R")

# NLP techniques timing----
## NER extraction----
start <- Sys.time()
med <- read.csv("../Data/medical_data.csv")
med$PMH <- sapply(med$TEXT, structuredExtract,
                  label = "Past Medical History",
                  resultEndChar = "\\n\\n",
                  separator = ":")

bigList <- lapply(med$PMH, myNER)
end <- Sys.time()
tot_time <- end - start
tot_time # Time difference of 12.04893 mins

## Keyword Extraction----
start <- Sys.time()
med <- read.csv("../Data/medical_data.csv")
med$PMH <- sapply(med$TEXT, structuredExtract,
                  label = "Past Medical History",
                  resultEndChar = "\\n\\n",
                  separator = ":")

bigList <- lapply(med$PMH, keywordExtraction)
end <- Sys.time()
tot_time <- end - start
tot_time # Time difference of 27.43945 mins

## Structured extraction----
start <- Sys.time()
med <- read.csv("../Data/medical_data.csv")
# Admit
med$AdmitDate <- sapply(med$TEXT, structuredExtract,
                        label = "Admission Date",
                        resultEndChar = "\\]",
                        separator = ":")
med$AdmitDate <- as.Date(gsub("\\[|\\]|\\*", "", med$AdmitDate))
# Discharge
med$DischargeDate <- sapply(med$TEXT, structuredExtract,
                            label = "Discharge Date",
                            resultEndChar = "\\]",
                            separator = ":")
med$DischargeDate <- as.Date(gsub("\\[|\\]|\\*", "", med$DischargeDate))
# Birth date
med$BirthDate <- sapply(med$TEXT, structuredExtract,
                        label = "Date of Birth",
                        resultEndChar = "\\]",
                        separator = ":")
med$BirthDate[substr(med$BirthDate,1, 1) != "["] <- NA
med$BirthDate <- as.Date(gsub("\\[|\\]|\\*", "", med$BirthDate))
# Sex
med$Sex <- sapply(med$TEXT, structuredExtract,
                  label = "Sex",
                  resultEndChar = "\\n",
                  separator = ":")
med$Sex[!(med$Sex %in% c("M", "F"))] <- NA
# Service
med$Service <- sapply(med$TEXT, structuredExtract,
                      label = "Service",
                      resultEndChar = "\\n",
                  separator = ":")
end <- Sys.time()
tot_time <- end - start
tot_time # Time difference of 2.662986 secs

# Manual chart review times----
## Manual chart review of typing in the dates from structured extract----
start <- Sys.time()

med$TEXT[5]

# 2162-03-03
# 2162-03-25
# 2080-01-04
# M
# Medicine
# 
# 2150-02-25
# 2150-03-01
# 2086-12-19
# M
# NUEROSURGERY
# 
# 2101-10-25
# 2101-10-28
# 2064-10-2
# F
# Medicine
# 
# 2148-02-03
# 2148-02-07
# 2087-06-07
# F
# Surgery
# 
# 2174-05-29
# 2174-06-09
# 2093-11-27
# F
# Medicine

end <- Sys.time()
tot_time <- end - start
tot_time # 3.05318 mins

# So total if kept this pace (which is quick)
(3.05318 / 5) * 744 # 454.3132 minutes (7.571887 hours)

## Timing the Manual Chart review for the diagnoses for NER and KWE----
start <- Sys.time()

med$TEXT[5]

# CAD
# CABG
# CHF
# HTN
# AICD
# Afib
# Stroke
# 
# Cardiac Arrhythmia
# prostate cancer
# hypertension
# 
# Asthma
# GERD
# Insomnia
# Bipolar
# severe depression
# 
# hyperlipidemia
# BRCA1 carrier
# 
# PCA
# LMCA
# LAD
# lcx
# rca
# stenosis
# renal cell carcinoma
# CAD
# CHF
# hemodialysis
# osteoarthritis
# herpes
# anemia
# myositis
# cholelithiasis


end <- Sys.time()
tot_time <- end - start
tot_time # Time difference of 5.090502 mins

# So total if kept this pace (which is quick)
(5.090502 / 5) * 744 # 757.4667 minutes (12.62444 hours)

