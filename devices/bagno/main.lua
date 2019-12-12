local dht = require("dht")

print("=== Main ===")

-- connect to wifi

dofile('connect.lua')

-- register humidity console event
last_temperature = 0 
last_humidity = 0

dofile('dht_setup.lua')

-- startup http server

dofile('http_server.lua')
