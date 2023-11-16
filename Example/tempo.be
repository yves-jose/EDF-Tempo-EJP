import string
import json
datej = string.split(tasmota.time_str(tasmota.rtc()['local']), 10)[0]
adresse1 = "https://particulier.edf.fr/services/rest/referentiel/getNbTempoDays?TypeAlerte=TEMPO"
adresse2 = string.format("https://particulier.edf.fr/services/rest/referentiel/searchTempoStore?dateRelevant=%s" , datej)
adresse3 = "https://particulier.edf.fr/services/rest/referentiel/historicEJPStore?searchType=ejp"

cl = webclient()
cl.set_useragent("Wget/1.20.3 (linux-gnu)")

def nbj()
cl.begin(adresse1)
var result1 = cl.GET()
var sresult1 = json.load(cl.get_string())
var nbjbleu = sresult1['PARAM_NB_J_BLEU']
var nbjblanc = sresult1['PARAM_NB_J_BLANC']
var nbjrouge = sresult1['PARAM_NB_J_ROUGE']
print(sresult1)
print("Jours Restant : Bleu = " .. nbjbleu .. " - Blanc = " .. nbjblanc .. " - Rouge = " .. nbjrouge)  
end

def couleurj()
cl.begin(adresse2)
var result2 = cl.GET()
var sresult2 = json.load(cl.get_string())
var jourj = sresult2['couleurJourJ']
var jourj1 = sresult2['couleurJourJ1']
print(sresult2)
print("Aujourd hui : " .. jourj .. " - Demain : " .. jourj1)
end

def ejp()
cl.begin(adresse3)
var rejp = cl.GET()
var sejp = cl.get_string()
var dj = tasmota.rtc()['local']
var avdjour = number(string.split(string.split(string.split(sejp,",")[40],":")[1],10)[0])
var djour = number(string.split(string.split(string.split(sejp,",")[42],":")[1],10)[0])
var nbejp = string.split(string.split(s,",")[44],":")[1]
print(str(dj) .. " : " .. str(avdjour) .. " | " .. str(djour))
print(tasmota.time_str(dj) .. " : " .. tasmota.time_str(avdjour) .. " | " .. tasmota.time_str(djour))
print(" Nombre jours restants : " .. nbejp) 
end
