####################################
# This is the file for  the data pre-processing methods
# DataPreProcessingMethods.R
# Created: Thursday July 4 12:54 PM MST
# Last updated: Thursday July 4 12:54 PM MST
####################################

# Load in the libraries----
library(dplyr)
library(tidyverse)
library(tidytext)
library(tm)
library(arsenal)

# Data pre-processing methods/functions----
## Data cleaning methods----
# DESCRIPTION: This function will perform data cleaning/preprocessing on text
#              data in a dataset given a textVar column and an ID column.
#              This function can remove stopwords, punction, or other custom words,
#              perform lemmatization, and tokenize the words.
# INPUTS: data - the data set of interest
#         textVar - string of the textVariable name
#         idCol - string of the idCol name (subject_id, clinic_number, etc.)
#         removeStopwords - T/F do you want to remove stopwords
#         removePunct - T/F do you want to remove punctuation
#         otherRemovals - string vector of any other words you want removed
#         lemmatize -T/F do you want to lemmatize the words
#         tokenize - T/F do you want to tokenize the words (F=leave as one text string)
# OUTPUTS: If tokenize is F: this will return a dataframe with the id variables
#          and a string of the preprocessed words for each ID. 
#.         If tokenize is T: this will return a dataframe where each tokenized
#          word and ID combinations is its own row in the dataframe.
myCleaning <- function(data,
                       textVar,
                       idCol,
                       removeStopwords = TRUE,
                       removePunct = TRUE,
                       otherRemovals = "",
                       lemmatize = TRUE,
                       tokenize = FALSE) {
  
  # Remove Stopwords, Punctuation, and other removals
  if (removeStopwords) {
    en_stopwords = data.frame(word = stopwords("en"))
    
    data <- data %>% 
      unnest_tokens(word, textVar, strip_punct = removePunct) %>% 
      anti_join(en_stopwords) %>% 
      filter(word %nin% tolower(otherRemovals)) %>% 
      group_by(!!sym(idCol)) %>% 
      summarise(text = paste0(word, collapse = " "))
  } # Else we still perform this but don't remvove stopwords
  else {
    data <- data %>% 
      unnest_tokens(word, textVar, strip_punct = removePunct) %>% 
      filter(word %nin% tolower(otherRemovals)) %>%
      group_by(!!sym(idCol)) %>% 
      summarise(text = paste0(word, collapse = " "))
  }
  
  # If we want to lemmatize the data
  if (lemmatize) {
    data <- data %>% 
      unnest_tokens(word, text) %>% 
      mutate(word = textstem::lemmatize_words(word)) %>% 
      group_by(!!sym(idCol)) %>% 
      summarise(text = paste0(word, collapse = " "))
  }
  
  # If we want tokenized, output a tokenized data frame
  if (tokenize) {
    data <- data %>% 
      unnest_tokens(word, text)
  }
  
  return(data)
}

##############################
# Examples----
# Test example
# test<- data.frame(words = c("hello there:, everyone",
#                             "the most amazing planet",
#                             "Diagnosis of the first PATTERN"),
#                   id = 1:3)
# 
# # Can interchange any of the arguments to test different functionality
# test_clean <- myCleaning(data = test,
#                          textVar = "words", 
#                          idCol = "id", 
#                          removeStopwords = T, 
#                          removePunct = F,
#                          otherRemovals = "",
#                          lemmatize = F, 
#                          tokenize = F)
# 
# # Shorted med test example
# testMed <- med[1:5,]
# 
# testMed_clean <- myCleaning(data = testMed,
#                             textVar = "TEXT",
#                             idCol = "SUBJECT_ID",
#                             removeStopwords = T,
#                             removePunct = T,
#                             otherRemovals = "",
#                             lemmatize = F,
#                             tokenize = F)

