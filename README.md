# EDF-Tempo-EJP

Attention : DEVELOPPEMENT EN COURS

Détection des différentes couleurs Tempo et EJP<br>
Avec ESP32 sous tasmota en Berry scripting<br>
Pré-requis :<br>

Matériel :<br>
 - 1 ESP32-WROOM-32
 - 2 Leds WS2812 (leds addressables)<br>
 
Logiciel :<br>
 - Flashage de l'ESP32 avec tasmota
 - Avoir accès à internet via wifi

<br>
Gestion des alertes changement de tarifs pour le contrat "Tempo" et "EJP"<br>
Les infos sont récupérées sur le site EDF "https://particulier.edf.fr/services/"<br>
<br>
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

Le schéma de raccordement des leds WS2812 et platine 2 relais :

![Schema_leds_relais](https://github.com/yves-jose/EDF-Tempo-EJP/assets/35004084/b1175d5a-1297-4329-9e6a-9628e009dc6c)

- Led 1 info demain
- Led 2 info aujourd'hui
- Relais 1 Heures Creuses
- Relais 2 Heures Pleine rouges


Installation de Tasmota sur L'ESP32 suivre ce lien :

https://tasmota.github.io/install/

<br>
Prendre le .bin correspondant a votre ESP32
<br>
Configuration pour la platine 2 relais<br>
{"NAME":"Wemos Tempo","GPIO":[1,1,1,1,1,1,1,1,0,224,225,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,1,1,1,1,1,1,1,1],"FLAG":0,"BASE":1}<br>
<br>
![param_relais](https://github.com/yves-jose/EDF-Tempo-EJP/assets/35004084/0176d690-885c-4172-89eb-a12e4911af96)
<br>
Uploader les 2 fichiers .be correspondant à votre besoin<br>
Et créer une "rule" pour demmarrer les scripts, j'ai choisi cette solution pour être sur que la liaison ethernet est opérationnelle.<br>
pour tempo (tempo.be & leds_tempo.be)<br>
sous console : Rule1 ON Time#Initialized DO Backlog Br load("tempo.be"); Br load("leds_tempo.be") ENDON<br>

pour EJP (ejp.be & leds_ejp.be)<br>
sous console : Rule1 ON Time#Initialized DO Backlog Br load("ejp.be"); Br load("leds_ejp.be") ENDON<br>
<br>
L'affichage sur l'interface Web Ui de tasmota :<br>

![Tempo_Esp32](https://github.com/yves-jose/EDF-Tempo-EJP/assets/35004084/b95595db-d62b-4162-81fb-ad4eacb151f0)




