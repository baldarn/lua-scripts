local display = nil
local efx = {}

local all_on = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff}
local all_off = {0, 0, 0, 0, 0, 0, 0, 0}
local dataset = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff}

function wave_effect()
  for i = 1,2 do
    display.brightness(7)
    display.write(all_on)
    tmr.delay(3000)

    local lum = 7
    for cont = 1,8 do
      for x = 1,7 do
        tmr.delay(500)
        dataset[cont] = 0
        display.write(dataset)
      end
      display.brightness(lum)
      lum = lum-1
    end

    tmr.delay(3000)
    display.brightness(7)
    display.write(all_off)
    tmr.delay(3000)

    for cont = 8,1,-1 do
      for x = 1,7 do
        tmr.delay(500)
        dataset[cont] = 0xff
        display.write(dataset)
      end
      display.brightness(cont)
    end
  end
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
