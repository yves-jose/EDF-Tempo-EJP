var aujourd_hui, demain, seconde
var Vleds, ejpj, ejpj1
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
    aujourd_hui = 0x00FF00 # Vert
  end
  if ejpj1  == 'Non defini'
    if seconde % 2 == 1
      demain = 0xFF7F00 # Orange
    else
      demain = 0x000000 # Eteint
    end
  end
end
class MyLeds
  def init()
    ejpj  = 'Non defini'
    ejpj1  = 'Non defini'
    Vleds = Leds(2, gpio.pin(gpio.WS2812,0))
    every_30minutes()
  end
  def every_second()
    seconde = tasmota.time_dump(tasmota.rtc()['local'])['sec']
    couleur_leds()
    Vleds.set_pixel_color(0, demain,50) Vleds.set_pixel_color(1, aujourd_hui,50) Vleds.show()
  end
end

d2 = MyLeds()
tasmota.add_driver(d2)
