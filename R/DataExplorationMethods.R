####################################
# This is the file for  the data explorations methods
# DataExplorationMethods.R
# Created: Saturday June 29 6:30 AM MST
# Last updated: Saturday June 29 6:30 AM MST 
####################################

# Load in the libraries----
library(dplyr)
library(tidyverse)
library(tidytext)
library(tm)

# Data explortions methods/functions----
## Create a term frequency document----
# DESCRIPTION: Taking a dataframe and text column, this function will count
#         the number of times each word in the document is used (output in desc order)
# INPUTS: data - Dataframe of interest. 
#         textVar - variable containing the text
# OUTPUTS: a data frame of word and count for each word
myTermFreqDoc <- function(data, textVar) {
  en_stopwords = data.frame(word = stopwords("en"))
  new_df <- data %>% unnest_tokens(word, textVar) %>% anti_join(en_stopwords)
  frequency_dataframe = new_df %>% count(word) %>% arrange(desc(n))
  return(frequency_dataframe)
}

# Examples
#tf_med <- myTermFreqDoc(med, "TEXT")
#tf_glauc <- myTermFreqDoc(glauc, "text")

## Term Frequency Function----
# DESCRIPTION: Taking a dataframe and text column, this function will display
#             the top "n" most frequent words in your data (minus stopwords)
# INPUTS: data - Dataframe of interest. 
#         textVar - variable containing the text
#         n - the number of terms you wish to display (default 20)
# OUTPUTS: a data frame of word and count for each word, giving the top "n"
#         most used words within your dataframe text column
myTermFreqTopN <- function(data, textVar, n = 20) {
  frequency_dataframe <- myTermFreqDoc(data, textVar)
  head(frequency_dataframe, n)
}

# Examples
#myTermFreqTopN(med, "TEXT", 5)
#myTermFreqTopN(glauc, "text", 20)

## Search for words in the text and see how many times they are used----
# DESCRIPTION: Taking a dataframe, text column, and search word, this funciton
#       will return a data frame of the search word and the number of times it
#       was used in the text column of the dataframe
# INPUTS: data - Dataframe of interest. 
#         textVar - variable containing the text
#         searchWord - the word you are searching for
# OUTPUTS: a data frame containing the search word and the number of times
#       it was used in the document
mySearch <- function(data, textVar, searchWord) {
  frequency_dataframe <- myTermFreqDoc(data, textVar)
  search_df <- frequency_dataframe %>% 
    filter(word == tolower(searchWord))
  return(search_df)
}

# Examples
#mySearch(med, "TEXT", "admission")
#mySearch(glauc, "text", "eye")

## Create a true term document matrix for investigating the data----
# DESCRIPTION: This function will create a term-document matrix given a
#              vector containing the text you want to investigae.
# INPUTS: textField - a vector containing the text you want to investigate
# OUTPUTS: A term-document matrix of the text inputed
myTDM <- function(textField) {
  myCorpus <- Corpus(VectorSource(textField))
  tdm <- TermDocumentMatrix(myCorpus)
  return(tdm)
}

# Examples:
#tdm <- myTDM(med$TEXT)

## Create the top n words per note function----
# DESCRIPTION: This function will return the top n words per note (textField)
# INPUTS: textField - a vector containing the text you want to investigate
#         n - The number of words per note you want (default is 6)
#         includeStopwords - do you want to include stopwords in the resutls
#                            (default is FALSE)
# OUTPUTS: A data frame containing the word, number of times the word was used
#          in notes where it appeared in the top n, and the number of notes the
#          word appeared in the top n
myTopNPerNote <- function(textField, n = 6, includeStopwords = FALSE) {
  tdm <- myTDM(textField)
  t <- findMostFreqTerms(tdm, n = n)
  
  # Create a dataframe for easy use for tables or plotting
  tDF <- data.frame(Word = character(), Count = double(), NumRows = double())
  for (i in 1:length(t)) {
    # If there is no data then go to next
    if (length(t[[i]]) == 0) {
      next
    }
    for (j in 1:length(t[[i]])) {
      word = names(t[[i]][j])
      count = t[[i]][j]
      
      # If word is NA then go to the next()
      if (is.na(word)) {
        next
      }
      
      # If the word is already in the data frame
      if (word %in% tDF$Word) {
        tDF$Count[tDF$Word == word] <- tDF$Count[tDF$Word == word] + count
        tDF$NumRows[tDF$Word == word] <- tDF$NumRows[tDF$Word == word] + 1
      } 
      # If the word is not in the data frame
      else {
        tempdf <- data.frame(Word = word, Count = count, NumRows = 1)
        tDF <- rbind(tDF, tempdf)
      }
    }
  }
  
  row.names(tDF) <- NULL
  
  # Include stopwords or not
  if (includeStopwords) {
    return(tDF)
  } else {
    en_stopwords = data.frame(word = stopwords("en"))
    
    tDF2 <- tDF %>% 
      filter(Word %nin% en_stopwords$word) %>% 
      arrange(desc(NumRows))
    
    return(tDF2)
  }
}

# Examples
#medTop6Per <- myTopNPerNote(med$TEXT, n = 6, includeStopwords = F)

## Need to create the associate filter as well----







