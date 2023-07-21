generate_resultat <- function(joueurs_equipe1, joueurs_equipe2, score_equipe1, score_equipe2, sport, date) {
  resultat <- data.frame(
    Nom = c(joueurs_equipe1, joueurs_equipe2),
    sport = rep(sport),
    date = NA,
    score = NA,
    score_adv = NA,
    difference = NA,
    victoire = NA,
    defaite = NA
  )
  
  resultat$score[resultat$Nom %in% joueurs_equipe1] <- score_equipe1
  resultat$score[resultat$Nom %in% joueurs_equipe2] <- score_equipe2
  resultat$score_adv[resultat$Nom %in% joueurs_equipe1] <- score_equipe2
  resultat$score_adv[resultat$Nom %in% joueurs_equipe2] <- score_equipe1
  
  resultat$victoire[resultat$score == 13] <- 1
  resultat$victoire[resultat$score != 13] <- 0
  resultat$defaite[resultat$score == 13] <- 0
  resultat$defaite[resultat$score != 13] <- 1
  
  resultat$difference <- resultat$score - resultat$score_adv
  resultat$date <- format(date, "%d/%m/%Y")
  
  return(resultat)
}


