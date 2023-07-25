library(dplyr)
##Fichier de code utilisés
source("code.R")
source("function.R")



server <- function(input, output, session) {
###############################################################################
###############################################################################
####                        Page importation des données                  #####
###############################################################################
###############################################################################
  ### Sélection du sport 
  observeEvent(input$sport, {
    sport <- input$sport
    message("Sport sélectionné :", sport)
    # Ajoute ici les actions à effectuer en fonction du sport sélectionné
  })
  observeEvent(input$ajouter_resultats, {
    list_E1 <- input$joueurs_equipe1
    list_E2 <- input$joueurs_equipe2
    score_E1 <- input$score_E1
    score_E2 <- input$score_E2
    sport <- input$sport
    date <- input$datePicker
    
    
    resultat <- generate_resultat(list_E1, list_E2, score_E1, score_E2, sport, date)
    
    # Lire le fichier ODS existant
    existing_data <- read_ods("dataset/base_donnee.ods")
    # Combiner les données existantes avec les nouvelles données
    updated_data <- rbind(existing_data, resultat)  # On enlève la première ligne avec [-1, ]
    # Écrire le fichier ODS mis à jour
    write_ods(updated_data, "dataset/base_donnee.ods")
    print(updated_data)
    
    
  })

  #Afficher le tableau des joueurs
  output$tableau_output <- renderDataTable({
    classement_tri
  })
  output$tableau_result <- renderDataTable({
    base
  })
  





}