# Manifesto.R, cwj, 11/3/2016
# demo on how to do Manifesto Analysis
# based on http://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining
# to be done in recitation
#
# load in the text mining package
library(tm)
#
# connect to the directory
setwd("~/Data mining")
#
# load in the pdf files that hold the Manifestos
# (we did this manually, but see if you can find
#  an automatic method using R!)
#
files <- list.files(pattern="pdf$")
files
#
# defining Reader for pdf files
Rpdf <- readPDF(control = list(text = "-layout"))
Rpdf
#
# prepare to say we are in Accra for time zone purposes
Sys.setenv(TZ="GMT")
#
# read in all the Manifestos at a go
Manifestos <- Corpus(URISource(files),
                    readerControl = list(reader = Rpdf))
#
# create the TDM
Manifestos.tdm <- TermDocumentMatrix(Manifestos, control = list(
   removePunctuation = TRUE,
   stopwords = TRUE,
   tolower = TRUE,
   stemming = FALSE,
   removeNumbers = TRUE,
   bounds = list(global = c(3, Inf))))
#
# preview the top ten terms across the Manifestos
inspect(Manifestos.tdm[1:10,])
#
# find the top ten most frequent words across the Manifestos
findFreqTerms(Manifestos.tdm, lowfreq=100, highfreq=Inf)
#
# load wordcloud package to draw wordcloud
library(wordcloud)
#
# put together wordcloud of whole corpus
wordcloud(Manifestos, max.words=30)

