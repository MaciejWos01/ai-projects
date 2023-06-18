library(shiny)
library(DT)
library(ggplot2)
library(data.table)
library(tidyr)
library(dplyr)
library(shinythemes)

artistsTableTopX <- read.csv("artists.csv", header = TRUE)
artistsTableTop <- na.omit(artistsTableTopX, "followers")
artistsTableX <- artistsTableTop[!artistsTableTop$followers == "null",][order(-rank(artistsTableTop$followers)),][1:10,1:5]

tracksTableX <- read.csv("tracks.csv", header = TRUE)[ ,c(2:6, 8)]
tracksTableZ <- read.csv("tracks.csv", header = TRUE)

listTop <- artistsTableX[[1]]
listTop2 <- artistsTableX[[4]]

tracksTableTopPlot <- tracksTableZ[sapply(strsplit(tracksTableZ$id_artists, split="'"), `[`,2) %chin% listTop,]
tracksTableTopPlot$author = as.character(lapply(strsplit(as.character(tracksTableTopPlot$artists), split="'"), "[", 2))
tracksTableTop <- tracksTableTopPlot[, c(2:6, 8, 21)]

