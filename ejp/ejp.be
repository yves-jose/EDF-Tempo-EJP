import string
import json
import math 
var datej, timej, date_time
var h_actuel
var ejpnbjr, lg
var ejpj='Non defini', ejpj1='Non defini'
var jour = 1, jour1 = 2 , djour=0 , avdjour = 0
var every_30minutes

cl = webclient()
cl.set_useragent("Wget/1.20.3 (linux-gnu)")

def t_ejp()
  print("Timer EJP")
  every_30minutes()
end

def h_epoch(hhmmss)
  return tasmota.strptime(datej .. ' ' .. hhmmss, "%Y-%m-%d %H:%M:%S")['epoch']
end

def ejp()
    var adresse3 = "https://particulier.edf.fr/services/rest/referentiel/historicEJPStore?searchType=ejp"
    cl.begin(adresse3)
    var rejp = cl.GET()
	if result1 == 200
      var sejp = cl.get_string()
      lg = int(40 + (math.ceil((size(sejp) - 1173.0)/49)*2))
      print("Longeur = " .. size(sejp) .. " - " .. lg)
      jour = tasmota.strptime(datej, "%Y-%m-%d")['epoch']
      var tz = number(tasmota.rtc()['timezone'])*60
      jour1 = jour + 86400 
      avdjour = number(string.split(string.split(string.split(sejp,",")[lg],":")[1],10)[0])+tz
      djour = number(string.split(string.split(string.split(sejp,",")[lg+2],":")[1],10)[0])+tz
      ejpnbjr = string.split(string.split(sejp,",")[lg+4],":")[1]
      print(str(jour) .. " : " .. str(avdjour) .. " | " .. str(djour))
      print(tasmota.time_str(jour) .. " : " .. tasmota.time_str(avdjour) .. " | " .. tasmota.time_str(djour))
      print(" Nombre jours restants : " .. ejpnbjr)
	  else
	    tasmota.set_timer(250000, t_ejp)
    end
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
    if h_actuel > h_epoch('15:35:00') && h_actuel < h_epoch('23:59:00') && ejpj1 == 'Non EJP'
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

import webserver # import webserver class
class MyEJP
  #- display sensor value in the web UI -#
  def web_sensor()
    # import string
    var msg = string.format(
        "{s} ------ EJP ------{m}%s{e}"..
        "{s}Auhourd\'hui : {m}%s{e}"..
        "{s}Demain : {m}%s{e}"..
        "{s}Nbj Restant : {m}%s{e}",
        timej, ejpj, ejpj1 , ejpnbjr)
	tasmota.web_send(msg)
  end
end
#- trigger a read every 30 Minutes -#
def every_30minutes()
    h_actuel = tasmota.rtc()['local']
    date_time = tasmota.time_str(h_actuel)
    datej = string.split(date_time,'T')[0]
    timej = string.split(date_time,'T')[1]
    ejp()
end
d1 = MyEJP()
tasmota.add_driver(d1)
tasmota.add_cron("0 5,35 * * * *",every_30minutes,"settrigger")