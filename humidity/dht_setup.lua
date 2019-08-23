tmr.create():alarm(10 * 1000, tmr.ALARM_AUTO, function()
  pin = 3
  status, temp, humi = dht.read(pin)
  if status == dht.OK then
       print("In DHT Temperature:"..temp..";".."Humidity:"..humi)
       last_temperature_in = temp
       last_humidity_in = humi
   elseif status == dht.ERROR_CHECKSUM then
      print( "In DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
      print( "In DHT timed out." )
  end
end)

tmr.create():alarm(10 * 1000, tmr.ALARM_AUTO, function()
  pin = 4
  status, temp, humi = dht.read(pin)
  if status == dht.OK then
       print("Out DHT Temperature:"..temp..";".."Humidity:"..humi)
       last_temperature_out = temp
       last_humidity_out = humi
   elseif status == dht.ERROR_CHECKSUM then
      print( "Out DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
      print( "Out DHT timed out." )
  end
end)