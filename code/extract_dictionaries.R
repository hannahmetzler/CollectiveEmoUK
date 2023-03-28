#dictionary LIWC 2022 English, formatting for a Brandwatch query

# useful websites, tutorials: 
#https://regex101.com/
# https://stringr.tidyverse.org/articles/regular-expressions.html

library(tidyverse)
library(data.table)

#directory with the dictionary files
dirdictionaries <- '~/Documents/dictionaries/LIWC2022/'

#function to transform list of words into queries: adjusting for special characters, stemming, add brackets and OR ####
#the below function was tested for anger

list2queryspecial <- function(words){
  
  #for debugging
  # words = liwcdict[emo_pos == "X", DicTerm]
  
  #delete double asterisks
  words[str_detect(words, "\\* \\*")] = str_replace_all(str_subset(words, "\\* \\*"),"\\* \\*", "\\*")
  
  #smileys into quotation marks
  words[str_detect(words, ":|;|=")] = paste0('"', str_subset(words, ":|;|="), '"')
  
  #words with asterisk at start: delete asterisks and put into quotes
  words[str_detect(words, "^\\*")] <- paste0('"', str_replace(str_subset(words, "^\\*"), "\\*", ""), '"')
  
  #words with spaces \\s, but no asterisk: \\b word boundary, \\s white space [a-zA-Z0-9_]* all word characters and numbers, as many as there are, $ at end of string -   #repeat for up to 3 words to exclude e.g. piss* me off
  words[str_detect(words, "\\b\\s\\b[a-zA-Z0-9_]*\\b\\s\\b[a-zA-Z0-9_]*$")] <- paste0('"', str_subset(words, "\\b\\s\\b[a-zA-Z0-9_]*\\b\\s\\b[a-zA-Z0-9_]*$"), '"')
  
  #now the same for only 2 word strings
  words[str_detect(words, "^[a-zA-Z0-9_]*\\b\\s\\b[a-zA-Z0-9_]*$")] <- paste0('"', str_subset(words, "^[a-zA-Z0-9_]*\\b\\s\\b[a-zA-Z0-9_]*$"), '"')

  #for prosocial only: an asterisk in the  middle of 2 spaces - let space for a word in between
  words[str_detect(words, "held \\* hands")] = str_replace(str_subset(words, "held \\* hands"), "held \\* hands", "(held NEAR/1 hands)")
  
  # add NEAR/1 in strings with spaces and asterisks: space (\\s) AND (?=) an asterisk (\\*), any characters before and after (.*)
  words[str_detect(words, "(?=.*\\s)(?=^.*\\*)")]  <-  paste0("(", str_replace_all(str_subset(words, "(?=.*\\s)(?=^.*\\*)"), " ", " NEAR/1 "), ")")

  #3 word terms that had an asterisk: If there are now 2 instances of NEAR/1, insert a bracket after the first one, and at the end: (piss* NEAR/1 me NEAR/1 off)=> (piss* NEAR/1 (me NEAR/1 off))
  words[str_detect(words, "NEAR/1.*NEAR/1")] <-paste0(str_replace(str_subset(words, "NEAR/1.*NEAR/1"), "NEAR/1 ", "NEAR/1 ("), ")")

  # add OR after every word but the last
  words[-length(words)] <- paste0(words[-length(words)], " OR ")
  #all words into one string, and brackets at start and end
  wordsbracket <- paste0("(", str_c(append(words, ")"), sep="", collapse = ""))
  return(wordsbracket)
  
    # positive: strings around words that have a ' like he'd like OR he'd love 
}


#Notes - regular expressions that were not used
# in all words with *\", delete the quotes - now only words with asterisks in the middle of the string are still to be changed manually
# words[str_detect(words, '\\*\"')] <- str_replace_all(str_subset(words, '\\*\"'), '\"', "")
# str_subset(words, "^[\\w]{1,}\\b\\s\\b[\\w]{1,}$")
#terms with more 2 words (\\b is a word boundary) or more (2 spaces \\s) and no asterisks (i.e., more than 2 letters before the space [a-z]):
# str_subset(words, "^[a-z]{2,}.*\\b\\s\\b[a-z]{2,}\\b\\s")


# LIWC: we want the classes: posemo, anx, anger, sad, prosocial
#read dictionary ####

liwcdict <- data.table(read.csv(paste0(dirdictionaries, "2022-01-27_liwc-22.internal.dict.final.build.csv")))

emo_pos = liwcdict[emo_pos == "X", DicTerm]
emo_neg = liwcdict[emo_neg == "X", DicTerm]
emo_anx = liwcdict[emo_anx == "X", DicTerm]
emo_anger = liwcdict[emo_anger == "X", DicTerm]
emo_sad = liwcdict[emo_sad == "X", DicTerm]
prosocial = liwcdict[prosocial == "X", DicTerm]

#write queries for crimson hexagon to text files

#working already
write.table(list2queryspecial(emo_anger), file="Brandwatch_queries/english2022_emo_angerR.txt",  quote=F, row.names=F, col.names = F)
write.table(list2queryspecial(emo_anx), file="Brandwatch_queries/english2022_emo_anxR.txt",  quote=F, row.names=F, col.names = F)
write.table(list2queryspecial(emo_sad), file="Brandwatch_queries/english2022_emo_sadR.txt",  quote=F, row.names=F, col.names = F)
write.table(list2queryspecial(prosocial), file="Brandwatch_queries/english2022_prosocialR.txt",  quote=F, row.names=F, col.names = F)
write.table(list2queryspecial(emo_pos), file="Brandwatch_queries/english2022_emo_posR.txt",  quote=F, row.names=F, col.names = F)
