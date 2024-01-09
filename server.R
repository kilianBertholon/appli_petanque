library(dplyr)
library(ggplot2)
library(plotly)
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
  # Appliquer le style aux carrés dans la colonne "État de forme" de la table
  output$tableau_output <- renderDataTable({
    classement_tri
  })
  
  output$tableau_result <- renderDataTable({
    base
  })
  
  
  ##Afficher graph pts marqués 
  output$pts_mar_mean <- renderPlotly({
    graph_mean_pts_marq <- ggplot(data_pts_mar, aes(x = Nom, y = Pts_Mar_Moy, fill = Pts_Mar_Moy)) + 
      geom_bar(stat = "identity") + 
      scale_fill_gradientn(colors = couleurs(100), na.value = "white") +
      geom_hline(aes(yintercept = mediane, linetype = "Médiane"), color = "black", lwd = 0.3) +
      geom_hline(aes(yintercept = q25, linetype = "q25"), color = "green", lwd = 0.3) +
      geom_hline(aes(yintercept = q75, linetype = "q75"), color = "red", lwd = 0.3) +
      xlab("Nom") +
      ylab("Moyenne Pts marqués") +
      ggtitle("Classement des joueurs par points moyen marqués par partie") +
      scale_linetype_manual(values = c("Médiane" = "dashed", "q25" = "dashed", "q75" = "dashed")) +
      labs(linetype = "Statistiques")+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    
    
    graph_mean_pts_marq <- ggplotly(graph_mean_pts_marq)
    graph_mean_pts_marq <- layout(graph_mean_pts_marq, title = list(x = 0.5))
  })


  output$pts_enc_mean <- renderPlotly({
    graph_mean_pts_enc <- ggplot(data_pts_enc, aes(x = Nom, y = Pts_Enc_Moy, fill = Pts_Enc_Moy)) + 
      geom_bar(stat = "identity") + 
      scale_fill_gradientn(colors = couleur_e(100), na.value = "white") +
      geom_hline(aes(yintercept = mediane_e, linetype = "Médiane"), color = "black", lwd = 0.3) +
      geom_hline(aes(yintercept = q25_e, linetype = "q25"), color = "green", lwd = 0.3) +
      geom_hline(aes(yintercept = q75_e, linetype = "q75"), color = "red", lwd = 0.3) +
      xlab("Nom") +
      ylab("Moyenne Pts encaissés") +
      ggtitle("Classement des joueurs par points moyens encaissés par partie") +
      scale_linetype_manual(values = c("Médiane" = "dashed", "q25" = "dashed", "q75" = "dashed")) +
      labs(linetype = "Statistiques")+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    
    graph_mean_pts_enc <- ggplotly(graph_mean_pts_enc)
    graph_mean_pts_enc <- layout(graph_mean_pts_enc, title = list(x = 0.5))
  })


}