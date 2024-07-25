####################################
# This is the file for testing times to perform the NLP techniques
# Chapter4CaseStudy.R
# Created: Thursday July 25 4:34 PM MST 
# Last updated: Thursday July 25 4:34 PM MST 
####################################

# Load in the methods created----
source("./DataExplorationMethods.R")
source("./DataPreProcessingMethods.R")
source("./DataExtractionMethods.R")

# Load in any other libraries needed----
library(ggplot2)
library(gridExtra)

# Read in the medical dataset----
med <- read.csv("../Data/medical_data.csv")

## Manually look at the structure of some of the notes

# Run the Term Frequency Document framework to explore the data----
medTop20 <- myTermFreqTopN(med, "TEXT", 20)

ggplot(data = medTop20, aes(x = reorder(word, -n), y = n)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count") 

# Clean the data and run again----
# Removing stopwords, punctuation, and numbers
med_clean <- myCleaning(data = med,
                        textVar = "TEXT",
                        idCol = "SUBJECT_ID",
                        removeStopwords = T,
                        removePunct = T,
                        otherRemovals = c(0:9), # This removes the numbers
                        lemmatize = F,
                        tokenize = F)

medCleanTop20 <- myTermFreqTopN(med_clean, "text", 20)

ggplot(data = medCleanTop20, aes(x = reorder(word, -n), y = n)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count") 

# Run the term-document matrix framework----
medTop5Per <- myTopNPerNote(med_clean$text, n = 5, includeStopwords = F)

p1a <- ggplot(data = medTop5Per[1:20,], aes(x = reorder(Word, -NumRows), y = NumRows)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Number of Notes") 

p2a <- ggplot(data = medTop5Per[1:20,], aes(x = reorder(Word, -NumRows), y = Count)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count")

grid.arrange(p1a, p2a, ncol = 2)

# Now extract the data needed based on the results gained from above----
## Structured extraction----
# Admit Date
med$AdmitDate <- sapply(med$TEXT, structuredExtract,
                        label = "Admission Date",
                        resultEndChar = "\\]",
                        separator = ":")
med$AdmitDate <- as.Date(gsub("\\[|\\]|\\*", "", med$AdmitDate))
# Discharge Date
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

## NER----
med$PMH <- sapply(med$TEXT, structuredExtract,
                  label = "Past Medical History",
                  resultEndChar = "\\n\\n",
                  separator = ":")

bigListNEW <- lapply(med$PMH, myNER)

## Keyword Extraction----
bigListKWE <- lapply(med$PMH, keywordExtraction)


