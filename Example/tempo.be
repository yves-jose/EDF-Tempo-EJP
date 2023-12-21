import string
import json
import persist
var datej, timej, date_time
var tempocj, tempocj1
var nbjbleu, nbjblanc, nbjrouge
var ejpnbjr
var ejpj, ejpj1
cl = webclient()
cl.set_useragent("Wget/1.20.3 (linux-gnu)")

class Tempo
    def nbj()
       var adresse1 = "https://particulier.edf.fr/services/rest/referentiel/getNbTempoDays?TypeAlerte=TEMPO"
       cl.begin(adresse1)
       var result1 = cl.GET()
       var sresult1 = json.load(cl.get_string())
       nbjbleu = sresult1['PARAM_NB_J_BLEU']
       nbjblanc = sresult1['PARAM_NB_J_BLANC']
       nbjrouge = sresult1['PARAM_NB_J_ROUGE']
       print(sresult1)
       print("Jours Restant : Bleu = " .. nbjbleu .. " - Blanc = " .. nbjblanc .. " - Rouge = " .. nbjrouge)  
    end
    def couleur()
       var adresse2 = string.format("https://particulier.edf.fr/services/rest/referentiel/searchTempoStore?dateRelevant=%s" , datej)
       cl.begin(adresse2)
       var result2 = cl.GET()
       var sresult2 = json.load(cl.get_string())
       tempocj = sresult2['couleurJourJ']
       tempocj1 = sresult2['couleurJourJ1']
       print(sresult2)
       print("Aujourd hui : " .. tempocj .. " - Demain : " .. tempocj1)
    end
end

def ejp()
    var adresse3 = "https://particulier.edf.fr/services/rest/referentiel/historicEJPStore?searchType=ejp"
    cl.begin(adresse3)
    var rejp = cl.GET()
    var sejp = cl.get_string()
    var lg = 40 + (((size(sejp) - 1173)/49)*2)
    print("Longeur = " .. size(sejp) .. " - " .. lg)
    var jour = tasmota.strptime(datej, "%Y-%m-%d")['epoch']
    var tz = number(tasmota.rtc()['timezone'])*60
    var jour1 = jour + 86400 
    var avdjour = number(string.split(string.split(string.split(sejp,",")[lg],":")[1],10)[0])+tz
    var djour = number(string.split(string.split(string.split(sejp,",")[lg+2],":")[1],10)[0])+tz
    ejpnbjr = string.split(string.split(sejp,",")[lg+4],":")[1]
    print(str(jour) .. " : " .. str(avdjour) .. " | " .. str(djour))
    print(tasmota.time_str(jour) .. " : " .. tasmota.time_str(avdjour) .. " | " .. tasmota.time_str(djour))
    print(" Nombre jours restants : " .. ejpnbjr)
    print('Heure = ' .. persist.heure)
    if jour < djour
       ejpj  = 'Non EJP'
    end
    if jour > djour
       ejpj  = 'Non EJP'
       ejpj1 = 'Non EJP'
    end
    if jour == djour
       ejpj  = 'EJP'
       ejpj1 = 'Non EJP'
    end
    if persist.heure == 1 && ejpj1 == 'Non EJP'
       ejpj1 = 'Non EJP'
    else
       ejpj1 = 'Non defini'
    end
    if jour1 == djour
       ejpj1 = 'EJP'
    end
    if jour == avdjour
       ejpj  = 'EJP'
    end
end

def rule_timer(value,trigger)
   persist.heure = value
   print("Heure : " .. persist.heure)
   persist.save() # save to _persist.json 
end

import webserver # import webserver class
class MyTempo
  #- display sensor value in the web UI -#
  def web_sensor()
    # import string
    var msg = string.format(
	"{s} ---- TEMPO -----{m}%s{e}"..
	"{s}Auhourd\'hui : {m}%s{e}"..
        "{s}Demain : {m}%s{e}"..
        "{s}Be-Bc-Rg : {m}%i-%i-%i{e}"..
        "{s} ------ EJP ------{e}"..
        "{s}Auhourd\'hui : {m}%s{e}"..
        "{s}Demain : {m}%s{e}"..
        "{s}Nbj Restant : {m}%s{e}",
        timej, tempocj, tempocj1, nbjbleu, nbjblanc, nbjrouge, ejpj, ejpj1 , ejpnbjr)
		tasmota.web_send(msg)
  end
end
#- trigger a read every 30 Minutes -#
def every_30minutes()
    date_time = tasmota.time_str(tasmota.rtc()['local'])
    datej = string.split(date_time,'T')[0]
    timej = string.split(date_time,'T')[1]
    Tempo.nbj()
    Tempo.couleur()
    ejp()
end
d1 = MyTempo()
tasmota.add_driver(d1)
tasmota.add_rule("Clock#timer",rule_timer)
tasmota.add_cron("0 */30 * * * *",every_30minutes,"settrigger")