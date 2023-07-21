# Charger les fichiers UI et serveur
source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)
