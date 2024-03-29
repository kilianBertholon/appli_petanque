library(readODS)
library(dplyr)

source("function.R")

chemin_fichier <- "dataset/nom.ods"

donnees <- read_ods(chemin_fichier)

chemin_base <- "dataset/base_donnee.ods"
base <- read_ods(chemin_base)


classement <- data.frame(MJ = table(base$Nom))

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

classement$RatioVictoire = classement$Victoire / classement$MJ
classement$RatioVictoire = round(classement$RatioVictoire, 3)

classement$DiffMoy = classement$Difference / classement$MJ
classement$DiffMoy = round(classement$DiffMoy, 3)

classement_tri <- classement[order(-classement$RatioVictoire, -classement$DiffMoy), ] 

classement_tri$Classement <- seq(nrow(classement_tri))

classement_tri <- classement_tri[, c("Classement", "Nom", "MJ", "Victoire", "Defaite", "Difference", "RatioVictoire", "DiffMoy")]


##Grpahe des joueurs qui marque le plus de points 

data_pts_mar <- base |>
  group_by(Nom) |>
  summarise(Pts_Mar_Moy = round(mean(score),2))

mediane <- median(data_pts_mar$Pts_Mar_Moy)
q25 <- quantile(data_pts_mar$Pts_Mar_Moy, 0.25)
q75 <- quantile(data_pts_mar$Pts_Mar_Moy, 0.75)
couleurs <- colorRampPalette(c("red", "yellow", "green"))


##Ceux qui encaisse le plus de points 
data_pts_enc <- base |>
  group_by(Nom) |>
  summarise(Pts_Enc_Moy = round(mean(score_adv), 2))

mediane_e <- median(data_pts_enc$Pts_Enc_Moy)
q25_e <- quantile(data_pts_enc$Pts_Enc_Moy, 0.25)
q75_e <- quantile(data_pts_enc$Pts_Enc_Moy, 0.75)
couleur_e <- colorRampPalette(c("green", "yellow", "red"))

