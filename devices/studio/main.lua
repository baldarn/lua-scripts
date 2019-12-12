local dht = require("dht")

print("=== Main ===")

-- connect to wifi

dofile('connect.lua')

-- register humidity console event
last_temperature = 0 
last_humidity = 0

dofile('dht_setup.lua')

-- startup http server

-- gate
gate_pin = 4
gpio.mode(gate_pin, gpio.OUTPUT)
gpio.write(gate_pin, gpio.HIGH)

dofile('http_server.lua')
