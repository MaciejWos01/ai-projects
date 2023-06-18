#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(ggplot2)
library(data.table)
library(tidyr)
library(dplyr)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
  output$artistsTable <- DT::renderDataTable({
    artistsTableY <- artistsTableX[(artistsTableX$followers >= input$followersRange[1] & artistsTableX$followers <= input$followersRange[2]) & 
                                     (artistsTableX$popularity >= input$popularityRange[1] & artistsTableX$popularity <= input$popularityRange[2]),]})
  
  
  output$tracksTable <- DT::renderDataTable({
    tracksTableY <- tracksTableTop[(tracksTableTop$popularity >= input$tracksPopularityRange[1] & tracksTableTop$popularity <= input$tracksPopularityRange[2]) &
                                   (tracksTableTop$duration_ms >= input$tracksDurationTime[1] & tracksTableTop$duration_ms <= input$tracksDurationTime[2]) &
                                   (tracksTableTop$explicit <= input$explicit),]})
  
  output$comparePlot <- renderPlot({
    ggplot(tracksTableTopPlot, mapping = aes_string(x=input$xaxis, y=input$yaxis, color=input$coloraxis)) +
      geom_point(size = 3)
  }, height = 800) 
  
  whichPlot <- reactive({input$mostsongs})
    
  output$songsPlot <- renderPlot({
    if(whichPlot() == "NumberOfSongs")
      tracksTableTopPlot %>%
      group_by(author) %>%
      summarize(NumberOfSongs = n_distinct(name)) %>%
      arrange(desc(NumberOfSongs)) %>%
      ggplot(aes(x= author, y= NumberOfSongs, color= author)) +
      geom_segment(aes(x= author, xend= author, y= 0, yend= NumberOfSongs), size = 2) +
      labs(title = "How many songs do they have?") +
      xlab("") +
      ylab("Songs") +
      coord_flip()
    else if(whichPlot() == "TotalDuration")
      tracksTableTopPlot %>%
      group_by(author) %>%
      summarize(duration = sum(duration_ms/3600000)) %>%
      arrange(desc(duration)) %>%
      ggplot(aes(x= author, y= duration, color= author)) +
      geom_segment(aes(x= author, xend= author, y= 0, yend= duration), size = 2) +
      labs(title = "How long are their songs in total?") +
      xlab("") +
      ylab("Hours") +
      coord_flip()
    else if(whichPlot() == "AverageDuration")
      tracksTableTopPlot %>%
      group_by(author) %>%
      summarize(avgdur = (sum(duration_ms/60000))/n_distinct(id)) %>%
      arrange(desc(avgdur)) %>%
      ggplot(aes(x= author, y= avgdur, color= author)) +
      geom_segment(aes(x= author, xend= author, y= 0, yend= avgdur), size = 2) +
      labs(title = "How long are their songs on average?") +
      xlab("") +
      ylab("Minutes/song") +
      coord_flip()
  }, height = 600)
  
  whichRecord <- reactive({input$recordcat})
  
  output$recordsPlot <- renderPlot({
    if(whichRecord() == "duration_ms")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(duration_ms)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -duration_ms), y= duration_ms/1000, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90)) +
      labs(title = "Duration") +
      xlab("Song") +
      ylab("Seconds")
    else if(whichRecord() == "danceability")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(danceability)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -danceability), y= danceability, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Danceability") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "energy")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(energy)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -energy), y= energy, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Energy") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "loudness")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(loudness) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -loudness), y= loudness, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Loudness") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "speechiness")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(speechiness)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -speechiness), y= speechiness, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Speechiness") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "acousticness")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(acousticness)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -acousticness), y= acousticness, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Acousticness") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "liveness")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(liveness)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -liveness), y= liveness, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Liveness") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "valence")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(valence)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -valence), y= valence, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Valence") +
      xlab("Song") +
      ylab("")
    else if(whichRecord() == "tempo")
      tracksTableTopPlot %>%
      group_by(author) %>%
      arrange(desc(tempo)) %>%
      slice(1:1) %>%
      ggplot(aes(x= reorder(name, -tempo), y= tempo, fill = author)) +
      geom_col() +
      scale_fill_brewer(palette = "Set3") +
      theme(axis.text.x = element_text(angle=90), ) +
      labs(title = "Tempo") +
      xlab("Song") +
      ylab("")
  }, height = 800)
  
  
  tPR1 <- reactive({input$popularityRange2[1]})
  tPR2 <- reactive({input$popularityRange2[2]})
  
  output$lastPlot <- renderPlot({
     tracksTableTopPlot %>%
      filter(popularity >= tPR1() & popularity <= tPR2()) %>%
      group_by(author) %>%
      summarize(NumInPop = n_distinct(name)) %>%
      arrange(desc(NumInPop)) %>%
      ggplot(aes(x= author, y= NumInPop, color= author)) +
      geom_segment(aes(x= author, xend= author, y= 0, yend= NumInPop), size = 2) +
      labs(title = "How many songs do they have in this interval of popularity?") +
      xlab("") +
      ylab("Songs") +
      coord_flip()
  }, height = 600)
  
  
  
})
