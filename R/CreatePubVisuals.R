####################################
# This is the file for creatine publication visuals and tables
# CreatePubVisuals.R
# Created: Saturday July 6 1:16 PM MST
# Last updated: Thursday July 25 4:27 PM MST
####################################

# Load in the methods created----
source("./DataExplorationMethods.R")
source("./DataPreProcessingMethods.R")
source("./DataExtractionMethods.R")

# Load in any other libraries needed----
library(ggplot2)
library(gridExtra)

# Load in the data----
med <- read.csv("../Data/medical_data.csv") # 744
glauc <- read.csv("../Data/glaucoma_notes.csv") # 483

# Chapter 3 Figures----
## Figure 1----
glaucTop20 <- myTermFreqTopN(glauc, "text", 20)

ggplot(data = glaucTop20, aes(x = reorder(word, -n), y = n)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count") #+
  #ggtitle("Top 20 words in the Glaucoma Clinical Notes")
  
## Figure 2----
glaucTop5Per <- myTopNPerNote(glauc$text, n = 5, includeStopwords = F)
glaucTop5Per_02 <- glaucTop5Per %>% 
  filter(!grepl("[[:punct:]]", Word)) 

p1 <- ggplot(data = glaucTop5Per_02[1:20,], aes(x = reorder(Word, -NumRows), y = NumRows)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Number of Notes") #+
  #ggtitle("Top 20 words in the Glaucoma Clinical Notes: Top 5 words in Each Note")

p2 <- ggplot(data = glaucTop5Per_02[1:20,], aes(x = reorder(Word, -NumRows), y = Count)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count") #+
  #ggtitle("Top 20 words in the Glaucoma Clinical Notes: Top 5 words in Each Note")

grid.arrange(p1, p2, ncol = 2)

###########################
# Chapter 4: Analysis----
## Med dataset
## Figure 3----
medTop20 <- myTermFreqTopN(med, "TEXT", 20)

ggplot(data = medTop20, aes(x = reorder(word, -n), y = n)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count") 

## Figure 4----
med_clean <- myCleaning(data = med,
                        textVar = "TEXT",
                        idCol = "SUBJECT_ID",
                        removeStopwords = T,
                        removePunct = T,
                        otherRemovals = c(0:9),
                        lemmatize = F,
                        tokenize = F)

medCleanTop20 <- myTermFreqTopN(med_clean, "text", 20)

ggplot(data = medCleanTop20, aes(x = reorder(word, -n), y = n)) +
  geom_col(fill = 'darkgrey', col = 'black') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Word") +
  ylab("Count") 

## Final option for Figure 5----
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







