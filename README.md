# EDF-Tempo-EJP
Détection des différents couleurs Tempo et EJP
Gestion des alertes changement de tarifs pour le contrat "Tempo" et "EJP" 
Les infos sont récupérées sur le site EDF "https://particulier.edf.fr/services/"
Pour Tempo :
nbj() : recupère le nombre de jours restants pour les 3 tarifs Bleu, Blanc et Rouge
{'PARAM_NB_J_BLEU': 224, 'PARAM_NB_J_BLANC': 43, 'PARAM_NB_J_ROUGE': 22}
Jours Restant : Bleu = 224 - Blanc = 43 - Rouge = 22

couleurj() : recupère les infos couleurs du jour et du lendemain
{'couleurJourJ': 'TEMPO_BLEU', 'couleurJourJ1': 'TEMPO_BLEU'}
Aujourd hui : TEMPO_BLEU - Demain : TEMPO_BLEU

Pour EJP :
ejp() : récupère les infos EJP du jour et du lendemain ainsi que le nombre de jours restants
reste à faire comparaison date du jour avec les 2 dernières dates fournies 
1700131071 : 1678316400 | 1678834800  
2023-11-16T10:37:51 : 2023-03-08T23:00:00 | 2023-03-14T23:00:00
 Nombre jours restants : 22
