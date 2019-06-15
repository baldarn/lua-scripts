-- node.compile("ds18b20.lua")
-- node.compile("tm1640.lua")
-- node.compile("netmodule.lua")
-- node.compile("effect.lua")

local matrix = require("tm1640")
local net = require("netmodule")
local efx = require("effect")
local ds18b20 = require("ds18b20")

local dev_ID = "TEST" -- HOSTNAME
local meas_temp = 25
local mqtt_callbacks = {}
local mqtt_client


print("=== Main ===")
dev_ID = "Node_"..string.sub(string.gsub(wifi.sta.getmac(), ":",""), 7)
print("- devId: "..dev_ID)
matrix.init(7, 5)
efx.init(matrix)
efx.on_start()

local function readout(temp)
  for addr, temp in pairs(temp) do
    meas_temp = temp
    print(string.format("Sensor %s: %s°C", ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(addr:byte(1,8)), temp))
  end
end

function cmdfunc(client, data)
    print("Cmd: "..data)
    if mqtt_callbacks[data] then
      mqtt_callbacks[data]()
    end
end

function showfunc(client, data)
    local d = {0, 0, 0, 0, 0, 0, 0, 0}
    if (data) then
        local j = 8
        for i=1,#data,2 do
            d[j] = tonumber(data:sub(i, i+1), 16)
            j = j - 1
            print(j)
        end
        if (d) then
          efx.show(d)
        end
    end
end

mqtt_callbacks["/radiolog/cmd"] = cmdfunc
mqtt_callbacks["/radiolog/show"] = showfunc
mqtt_callbacks["demo"] = efx.demo



function dispatch(client, topic, data)
    print("mqtt msg: " .. topic .. " " .. data)

    if string.find(topic, dev_ID) ~= nil then
      print("For me..".. dev_ID)
      topic = "/radiolog/cmd"
      if string.find(topic, "show") ~= nil then
        topic = "/radiolog/show"
      end
    end
    print(mqtt_callbacks[topic])
    if data~=nil and mqtt_callbacks[topic] then
        mqtt_callbacks[topic](client, data)
    end
end

function handle_mqtt_error(client, reason)
  tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function handle_mqtt_connect(client)
    print("MQTT client connected")
    client:publish("/radiolog/"..dev_ID.."/status", "Hello!", 0, 0)

    client:subscribe("/radiolog/show/#", 0, function(client)
      print("Subscribe [/radiolog/show/#] to topic with success")
    end)

    client:subscribe("/radiolog/cmd/#", 0, function(client)
      print("Subscribe [/radiolog/cmd/#] to topic with success")
    end)

    tmr.create():alarm(30 * 1000, tmr.ALARM_AUTO, function()
      if mqtt_client ~= nil then
        mqtt_client:publish("/radiolog/"..dev_ID.."/uptime", tmr.time(), 0, 0)
      end
    end)

    tmr.create():alarm(20 * 1000, tmr.ALARM_AUTO, function()
      if mqtt_client ~= nil then
        mqtt_client:publish("/radiolog/"..dev_ID.."/temp", meas_temp, 0, 0)
      end
    end)
end

function do_mqtt_connect()
  if mqtt_client ~= nil then
    mqtt_client:connect('mqtt.asterix.cloud', 1883, handle_mqtt_connect, handle_mqtt_error)
  end
end

function on_networt_connect(T)
  print("Wifi connection is ready! "..T.IP)
  efx.connect_ok()
  mqtt_client = mqtt.Client("Node-"..dev_ID, 60)

  mqtt_client:on("message", dispatch)
  mqtt_client:on("connect", function(client) print ("MQTT connected") end)
  mqtt_client:on("offline", function(client) print("MQTT Offline") end)
  mqtt_client:on("overflow", function(client, topic, data)
      print(topic .. " partial overflowed message: " .. data)
  end)
  do_mqtt_connect()
end

net.init(nil, on_networt_connect, nil)

tmr.create():alarm(15 * 1000, tmr.ALARM_AUTO, function()
  ds18b20:read_temp(readout, 2, ds18b20.C)
end)



