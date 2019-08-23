local dht = require("dht")

print("=== Main ===")

-- connect to wifi

dofile('connect.lua')

-- register humidity console event
last_temperature_in = 0 
last_humidity_in = 0
last_temperature_out = 0
last_humidity_out = 0

dofile('dht_setup.lua')

-- startup http server

dofile('http_server.lua')
