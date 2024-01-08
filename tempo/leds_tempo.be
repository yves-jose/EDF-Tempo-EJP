var aujourd_hui, demain, seconde
var Vleds
var tempocj, tempocj1, h_actuel, datejour
var relais_HC = gpio.pin(gpio.REL1,0) # Heures Creuses
var relais_HP_Rouge = gpio.pin(gpio.REL1,1) # Heures pleines Rouges

def h_epoch(hhmmss)
  return tasmota.strptime(datejour .. ' ' .. hhmmss, "%Y-%m-%d %H:%M:%S")['epoch']
end

def couleur_leds()
  if tempocj == 'TEMPO_BLEU'
    aujourd_hui = 0x0000FF 
  end
  if tempocj == 'TEMPO_BLANC'
    aujourd_hui = 0xFFFFFF
  end
  if tempocj == 'TEMPO_ROUGE'
    aujourd_hui = 0xFF0000
  end
  if tempocj == 'NON_DEFINI'
    if seconde % 2 == 1
      aujourd_hui = 0x00FF00 # Vert
    else
      aujourd_hui = 0x000000 # Eteint
    end
  end
  if tempocj1 == 'TEMPO_BLEU'
    demain = 0x0000FF
  end
  if tempocj1 == 'TEMPO_BLANC'
    demain = 0xFFFFFF
  end
  if tempocj1 == 'TEMPO_ROUGE'
    demain = 0xFF0000
  end
  if tempocj1 == 'NON_DEFINI'
    if seconde % 2 == 1
      demain = 0x00FF00 # Vert
    else
      demain = 0x000000 # Eteint
    end
  end
end

def relais()
  if h_actuel >= h_epoch('06:00:00') && h_actuel < h_epoch('22:00:00') && tempocj == 'TEMPO_ROUGE'
    gpio.digital_write(relais_HP_Rouge,0)
  else
    gpio.digital_write(relais_HP_Rouge,1)
  end
  if h_actuel >= h_epoch('06:00:00') && h_actuel < h_epoch('22:00:00')
    gpio.digital_write(relais_HC,1)
  else
    gpio.digital_write(relais_HC,0)
  end
end

class MyLeds
  def init()
    tempocj1 = 'NON_DEFINI'
    tempocj = 'NON_DEFINI'
    Vleds = Leds(2, 13)
    every_30minutes()
  end
  def every_second()
  	h_actuel = tasmota.rtc()['local']
	# date_time = tasmota.time_str(h_actuel)
	datejour = string.split(tasmota.time_str(h_actuel),'T')[0]
    seconde = tasmota.time_dump(tasmota.rtc()['local'])['sec']
    couleur_leds()
    Vleds.set_pixel_color(0, demain,50) Vleds.set_pixel_color(1, aujourd_hui,50) Vleds.show()
    relais()
  end
end

d2 = MyLeds()
tasmota.add_driver(d2)
