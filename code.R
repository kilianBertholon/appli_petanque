library(readODS)
library(dplyr)

chemin_fichier <- "dataset/nom.ods"

donnees <- read_ods(chemin_fichier)

chemin_base <- "dataset/base_donnee.ods"
base <- read_ods(chemin_base)

###Tableau de résultat 
classement <- data.frame(
  MJ = table(base$Nom)
)

colnames(classement) <- c("Nom", "MJ")

victoires <- base %>%
  group_by(Nom) %>%
  summarise(Victoire = sum(victoire))

# Compter le nombre de défaites par joueur
defaites <- base %>%
  group_by(Nom) %>%
  summarise(Defaite = sum(defaite))

difference <- base |> 
  group_by(Nom) |>
  summarise(Difference = sum(difference))

# Joindre les données dans le dataframe 'classement'
classement <- classement %>%
  left_join(victoires, by = "Nom") %>%
  left_join(defaites, by = "Nom") |>
  left_join(difference, by = "Nom")

print(classement)
