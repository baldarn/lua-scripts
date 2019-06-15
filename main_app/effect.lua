local display = nil
local efx = {}

local dataset = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff}

function wave_effect()
  for i = 1,2 do
    display.brightness(7)
    display.write({0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff})
    tmr.delay(3000)

    local lum = 7
    for cont = 1,8 do
      tmr.delay(10000)
      dataset[cont] = 0
      display.write(dataset)
      display.brightness(lum)
      lum = lum-1
    end

    tmr.delay(3000)
    display.brightness(7)
    display.write({0, 0, 0, 0, 0, 0, 0, 0})
    tmr.delay(3000)

    for cont = 8,1,-1 do
      tmr.delay(10000)
      dataset[cont] = 0xff
      display.write(dataset)
      display.brightness(cont)
    end
    display.brightness(0)
  end
end

function efx.demo()
  wave_effect()
end

function efx.connect_ok()
  -- show smile
  display.write({0x3c, 0x42, 0xa5, 0x81, 0xa5, 0x99, 0x42, 0x3c})
end

function efx.connect_fail()
  -- show cross
  display.write({ 0x81, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x81})
end

function efx.show(bits)
  display.write(bits)
end

function efx.on_start()
  wave_effect()
end

function efx.init(d)
  display = d
  print("Init efx module")
end

return efx
