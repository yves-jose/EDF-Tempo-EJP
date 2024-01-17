import string
import json
# import persist
var tempo = 1
var ejp = 0
var datej, timej, date_time
var tempocj, tempocj1
var nbjbleu, nbjblanc, nbjrouge
var every_30minutes

cl = webclient()
cl.set_useragent("Wget/1.20.3 (linux-gnu)")

def t_couleur()
  print("Timer Couleur")
  every_30minutes()
end

class Tempo
    def nbj()
       var adresse1 = "https://particulier.edf.fr/services/rest/referentiel/getNbTempoDays?TypeAlerte=TEMPO"
       cl.begin(adresse1)
       var result1 = cl.GET()
	   if result1 == 200
         var sresult1 = json.load(cl.get_string())
         nbjbleu = sresult1['PARAM_NB_J_BLEU']
         nbjblanc = sresult1['PARAM_NB_J_BLANC']
         nbjrouge = sresult1['PARAM_NB_J_ROUGE']
         print(sresult1)
         print("Jours Restant : Bleu = " .. nbjbleu .. " - Blanc = " .. nbjblanc .. " - Rouge = " .. nbjrouge)
	   end
    end
    def couleur()
       var adresse2 = string.format("https://particulier.edf.fr/services/rest/referentiel/searchTempoStore?dateRelevant=%s" , datej)
       cl.begin(adresse2)
       var result2 = cl.GET()
	   if result2 == 200
         var sresult2 = json.load(cl.get_string())
         tempocj = sresult2['couleurJourJ']
         tempocj1 = sresult2['couleurJourJ1']
         print(sresult2)
         print("Aujourd hui : " .. tempocj .. " - Demain : " .. tempocj1)
	   else
	     tasmota.set_timer(250000, t_couleur)
	   end 
    end
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
		"{s} Jours Restants : {e}"..
        "{s}Bleu : {m}%i{e}"..
		"{s}Blanc : {m}%i{e}"..
		"{s}Rouge : {m}%i{e}", 
        timej, tempocj, tempocj1, nbjbleu, nbjblanc, nbjrouge)
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
end
d1 = MyTempo()
tasmota.add_driver(d1)
tasmota.add_cron("0 5,35 * * * *",every_30minutes,"settrigger")