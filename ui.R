library(shiny)
library(shinysurveys)
library(dplyr)

##Fichier de code utilisés
source("code.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(tags$style(HTML("styles.css"))),

  navbarPage(
  HTML('MiaSanMia'),
  tabPanel('Importation résultats',
           fluidRow(
             column(
               width = 12,
               h4("Sélectionner le sport :"),
               radioButtons(
                 inputId = "sport",
                 label = NULL,
                 choices = c("Pétanque", "Football", "Volleyball"),
                 selected = NULL
               ),
               dateInput("datePicker", "Sélectionner la date", format = "dd/mm/yyyy")
             ),
             conditionalPanel(
               condition = "input.sport == 'Pétanque'",
               fluidRow(
                 column(
                   width = 5,
                   h4("Équipe 1 - Sélectionner les joueurs :"),
                   selectizeInput(
                     inputId = "joueurs_equipe1",
                     label = NULL,
                     choices = unique(donnees$nom),
                     selected = NULL,
                     multiple = TRUE,
                     options = list(plugins = list("remove_button"),
                                    maxItems = 5)
                   )
                 ),
                 column(
                   width = 1,
                   h4(""),
                   numberInput(
                     "score_E1",
                     "Score E1",
                     value = NULL,
                     min = 0,
                     max = 13
                   )
                 ),
                 column(
                   width = 1,
                   h4(""),
                   numberInput(
                     "score_E2",
                     "Score E2",
                     value = NULL,
                     min = 0,
                     max = 13
                   )
                 ),
                 column(
                   width = 5,
                   h4("Équipe 2 - Sélectionner les joueurs :"),
                   selectizeInput(
                     inputId = "joueurs_equipe2",
                     label = NULL,
                     choices = unique(donnees$nom),
                     selected = NULL,
                     multiple = TRUE,
                     options = list(plugins = list("remove_button"),
                                    maxItems = 5)
                   )
                 ),
                 actionButton("ajouter_resultats", "Ajouter les résultats à la base de données", style =   "background-color: black; color: white;cursor: pointer;")
               )
             )
           )),
  # Autres éléments du menu),
  tabPanel('Résultats',
           dataTableOutput('tableau_result')),
  
  tabPanel("Classement",
           dataTableOutput('tableau_output'))
))
