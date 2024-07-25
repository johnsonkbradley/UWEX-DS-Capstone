####################################
# This is the file for  the data extraction methods
# DataExtractionMethods.R
# Created: Saturday June 29 4:00 PM MST
# Last updated: Saturday June 29 4:00 PM MST 
####################################

# Load in the libraries----
library(dplyr)
library(tidyverse)
library(tidytext)
library(tm)
library(spacyr)
library(udpipe)

# Data Extraction methods/function----
## Structured Entry Data Retreival----
# DESCRIPTION: This function will extract data that is stored in a structured manner
#       as long as you know the label name, separator, and end character of you result
# INPUTS: text - the text string you want to extract data from
#         label - the label text before the separator
#         resultEndChar - the ending character of the result
#         separator - the character that separates the label and the result
# OUTPUTS: 
structuredExtract <- function(text, label, resultEndChar, separator) {
  sol <- gregexpr(label, text)[[1]]
  eor <- gregexpr(resultEndChar, text)[[1]]
  sep <- gregexpr(separator, text)[[1]]
  
  start <- sep[sep > sol][1]
  stop <- eor[eor > sol][1]
  
  if (resultEndChar == "\\n") {
    stop <- stop - 1
  }
  result <- substr(text, start + 1, stop) %>% 
    str_trim(side = "left")
  return(result)
}

# Examples----
# testText <- med$TEXT[1]
#structuredExtract(testText, "Discharge Date", "\\]", ":")
#structuredExtract(testText, "Sex", "\\n", ":")
#structuredExtract(testText, "Service", "\\n", ":")
# For multiple entries
# tempmed <- med[1:5,]
# tempmed$AdmitDate <- sapply(tempmed$TEXT, structuredExtract,
#                             label = "Admission Date",
#                             resultEndChar = "\\]",
#                             separator = ":")
# tempmed$AdmitDate <- as.Date(gsub("\\[|\\]|\\*", "", tempmed$AdmitDate))

# Keyword extraction method----
keywordExtraction <- function(text) {
  # Check in case the text has no words then return nothing
  if (text == "") {
    return(NULL)
  }
  
  spacy_initialize(model = "en_core_web_md")
  parsed_text <- spacy_parse(text, entity = TRUE)
  spacy_finalize()
  keywords <- keywords_rake(x = parsed_text, term = "lemma", group = "doc_id", 
                            relevant = parsed_text$pos %in% c("NOUN", "PROPN"),
                            n_min = 1)
  
  keywords_02 <- keywords %>% 
    filter(rake > 0)
  return(keywords_02)
}

# Examples
# med_clean <- myCleaning(data = med,
#                         textVar = "TEXT",
#                         idCol = "SUBJECT_ID",
#                         removeStopwords = T,
#                         removePunct = T,
#                         otherRemovals = "",
#                         lemmatize = F,
#                         tokenize = F)
# t_kwe <- keywordExtraction(med_clean$text[1])
# 
# t_kwe_l <- lapply(med_clean$text[1:5], keywordExtraction)
# From here you would need to loop through all lists of notes to extract what
# you think is relevant. This could also work nicely as an exploratory measure

# Names Entity Recognition method----
# DESCRIPTION: 
# INPUTS: 
# OUTPUTS:
myNER <- function(text) {
  spacy_initialize(model = "../Python/output/model-best")
  parsed_text <- spacy_parse(text, entity = TRUE)
  spacy_finalize()
  return(parsed_text)
}

# Examples
# tempmed <- med[1:5,]
# tempmed$PMH <- sapply(tempmed$TEXT, structuredExtract,
#                       label = "Past Medical History",
#                       resultEndChar = "\\n\\n",
#                       separator = ":")
# 
# temp1 <- myNER(tempmed$PMH[1])
# temp1_diag <- temp1 %>%
#   filter(entity != "")
# Can search from here to see if diag of interest is the data and repeat over
# all entries of interest however you want to



