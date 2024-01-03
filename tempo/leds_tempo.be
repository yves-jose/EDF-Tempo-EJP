var aujourd_hui, demain, seconde
var Vleds
var tempocj, tempocj1
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
class MyLeds
  def init()
    tempocj1 = 'NON_DEFINI'
    tempocj = 'NON_DEFINI'
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
