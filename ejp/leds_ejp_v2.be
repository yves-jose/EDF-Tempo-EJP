var aujourd_hui, demain, seconde
var Vleds, ejpj, ejpj1, mem_ejp
var relais_HC = gpio.pin(gpio.REL1,0) # Heures Creuses
var relais_HP_EJP = gpio.pin(gpio.REL1,1) # Heures pleines EJP

def couleur_leds()
  if ejpj  == 'EJP'
    aujourd_hui = 0xFF0000 # Rouge
  end
  if ejpj  == 'Non EJP'
    aujourd_hui = 0x00FF00 # Vert
  end
  if ejpj  == 'Non defini'
    if seconde % 2 == 1
      aujourd_hui = 0xFF7F00 # Orange
    else
      aujourd_hui = 0x000000 # Eteint
    end
  end
  if ejpj1  == 'EJP'
    demain = 0xFF0000 # Rouge 
  end
  if ejpj1  == 'Non EJP'
    demain = 0x00FF00 # Vert
  end
  if ejpj1  == 'Non defini'
    if seconde % 2 == 1
      demain = 0xFF7F00 # Orange
    else
      demain = 0x000000 # Eteint
    end
  end
end

def relais()
  if ejpj == 'EJP'
    mem_ejp = 1
  end
  if h_actuel >= h_epoch('01:00:00') && h_actuel < h_epoch('07:00:00')
	mem_ejp = 0
	gpio.digital_write(relais_HC,0) # en reserve	
  end
  if mem_ejp == 1
    gpio.digital_write(relais_HP_EJP,0)
    gpio.digital_write(relais_HC,1) # en reserve
  else
    gpio.digital_write(relais_HP_EJP,1)
  end	
end

class MyLeds
  def init()
    ejpj  = 'Non defini'
    ejpj1  = 'Non defini'
    Vleds = Leds(2, 33)
    every_30minutes()
  end
  def every_second()
    h_actuel = tasmota.rtc()['local']
    datej = string.split(tasmota.time_str(h_actuel),'T')[0]
    seconde = tasmota.time_dump(tasmota.rtc()['local'])['sec']
    couleur_leds()
    Vleds.set_pixel_color(0, demain,50) Vleds.set_pixel_color(1, aujourd_hui,50) Vleds.show()
    relais()
  end
end

d2 = MyLeds()
tasmota.add_driver(d2)