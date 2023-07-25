library(readODS)
library(dplyr)

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









