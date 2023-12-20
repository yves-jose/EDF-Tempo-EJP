![WS2812-ESP32-Circuit-Diagram](https://github.com/yves-jose/EDF-Tempo-EJP/assets/35004084/bf91e4a6-82d2-4287-82a5-317d421d2b8b)
# EDF-Tempo-EJP
Détection des différentes couleurs Tempo et EJP<br>
Avec ESP32 sous tasmota en Berry scripting<br>
Gestion des alertes changement de tarifs pour le contrat "Tempo" et "EJP"<br>
Les infos sont récupérées sur le site EDF "https://particulier.edf.fr/services/"<br>
Pour Tempo :<br>
nbj() : récupère le nombre de jours restants pour les 3 tarifs Bleu, Blanc et Rouge<br>
{'PARAM_NB_J_BLEU': 224, 'PARAM_NB_J_BLANC': 43, 'PARAM_NB_J_ROUGE': 22}<br>
Jours Restant : Bleu = 224 - Blanc = 43 - Rouge = 22<br>
<br>
couleurj() : récupère les infos couleurs du jour et du lendemain<br>
{'couleurJourJ': 'TEMPO_BLEU', 'couleurJourJ1': 'TEMPO_BLEU'}<br>
Aujourd hui : TEMPO_BLEU - Demain : TEMPO_BLEU<br>
<br>
Pour EJP :<br>
ejp() : récupère les infos EJP du jour et du lendemain ainsi que le nombre de jours restants<br>
reste à faire comparaison date du jour avec les 2 dernières dates fournies<br>
1700131071 : 1678316400 | 1678834800<br>
2023-11-16T10:37:51 : 2023-03-08T23:00:00 | 2023-03-14T23:00:00<br>
 Nombre jours restants : 22<br>
