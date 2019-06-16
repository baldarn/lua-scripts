local ds18b20 = require("ds18b20")


print("=== Main ===")

local function readout(temp)
  if ds18b20.sens then
  print("Total number of DS18B20 sensors: ".. #ds18b20.sens)
  for i, s in ipairs(ds18b20.sens) do
    print(string.format("Sensor #%d address: %s%s",  i, ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(s:byte(1,8)), s:byte(9) == 1 and " (parasite)" or ""))
    end
  end
  for addr, temp in pairs(temp) do
    print(string.format("Sensor %s: %s °C", ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(addr:byte(1,8)), temp))
  end
end

tmr.create():alarm(15 * 1000, tmr.ALARM_AUTO, function()
  ds18b20:read_temp(readout, 2, ds18b20.C)
end)



