tmr.create():alarm(10 * 1000, tmr.ALARM_AUTO, function()
  pin = 3
  status, temp, humi = dht.read(pin)
  if status == dht.OK then
       print("In DHT Temperature:"..temp..";".."Humidity:"..humi)
       last_temperature = temp
       last_humidity = humi
   elseif status == dht.ERROR_CHECKSUM then
      print( "In DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
      print( "In DHT timed out." )
  end
end)
