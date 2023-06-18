#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#boxplot dla popularity danego artysty zeby sprawdzic czy wszystkie sa popularne czy tylko jedna


library(shiny)
library(DT)
library(ggplot2)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("cyborg"),
  navbarPage(
    "Spotify analysis",
    tabPanel("About",
             sidebarPanel(
               helpText("Welcome!"),
               helpText("This dashboard shows information about top 10 artists on Spotify and their songs")
             ),
             mainPanel(
               tags$img(src="logospotify.jpg")
             )
             ),
    tabPanel("Artists",
             sidebarPanel(
              sliderInput("followersRange", 
                           label = "Followers:",
                           min = 0, max = 80000000,
                           value = c(0, 80000000)),
              sliderInput("popularityRange", 
                         label = "Popularity [%]:",
                         min = 0, max = 100,
                         value = c(0, 100)),
             ),
            mainPanel(
              dataTableOutput("artistsTable")
             )
        ),
    tabPanel("Tracks",
             sidebarPanel(
               sliderInput("tracksPopularityRange",
                           label = "Popularity [%]:",
                           min = 0, max = 100,
                           value = c(0, 100)),
               sliderInput("tracksDurationTime",
                           label = "Duration time [ms]:",
                           min = 0, max = 5620000,
                           value = c(0, 5620000)),
               checkboxInput("explicit",
                             label = "Explicit",
                             value = TRUE),
               
             ),
             mainPanel(
               dataTableOutput("tracksTable")
             )
        ),
    tabPanel("Compare",
             sidebarPanel(
               selectInput("xaxis",
                           label = "X-axis",
                           c("danceability",
                             "energy",
                             "loudness",
                             "speechiness",
                             "acousticness",
                             "liveness",
                             "valence",
                             "tempo")),
               selectInput("yaxis",
                           label = "Y-axis",
                           c("danceability",
                             "energy",
                             "loudness",
                             "speechiness",
                             "acousticness",
                             "liveness",
                             "valence",
                             "tempo"),
                           selected = "energy"),
               selectInput("coloraxis",
                           label = "Color",
                           c("author",
                             "popularity",
                             "duration_ms",
                             "explicit")),
             ),
             mainPanel(
               plotOutput("comparePlot")
             )),
    tabPanel("Most Songs",
             sidebarPanel(
               selectInput("mostsongs",
                           label = "Number/Duration",
                           c("NumberOfSongs",
                             "TotalDuration",
                             "AverageDuration")),
             ),
             mainPanel(
               plotOutput("songsPlot")
             )
          ),
    tabPanel("Records",
             sidebarPanel(
               selectInput("recordcat",
                           label = "Category",
                           c("duration_ms",
                             "danceability",
                             "energy",
                             "loudness",
                             "speechiness",
                             "acousticness",
                             "liveness",
                             "valence",
                             "tempo")),
             ),
             mainPanel(
               plotOutput("recordsPlot")
             )
      ),
    tabPanel("Popular songs",
             sidebarPanel(
               sliderInput("popularityRange2", 
                           label = "Popularity [%]:",
                           min = 0, max = 100,
                           value = c(0, 100)),
             ),
             mainPanel(
               plotOutput("lastPlot")
             )
      )
    )
  )
)
