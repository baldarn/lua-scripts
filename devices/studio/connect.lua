open_spaceopen_spacelocal wifi_connect = false
local dev_ID = "gate" -- HOSTNAME
SSID = ''
PASSWORD = ''
IP = "192.168.1.21"
NETMASK = "255.255.255.0"
GATEWAY = "192.168.1.1"

print("- devId: "..dev_ID)

local M = {
    hostname = "",
    ip = "",
    connect = false
}

dofile('credential.lua')

wifi_got_ip_event = function(T)
    -- Note: Having an IP address does not mean there is internet access!
    -- Internet connectivity can be determined with net.dns.resolve().
    print("Wifi connection is ready! "..T.IP)
    M.ip = T.IP
    M.connect = true
end


wifi_connect_event = function(T)
    print("Connection to AP("..T.SSID..") established!")
    print("Waiting for IP address...")
    if disconnect_ct ~= nil then disconnect_ct = nil end
end

  wifi_disconnect_event = function(T)
    if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
      --the station has disassociated from a previously connected AP
      return
    end
    print("\nWiFi connection to AP("..T.SSID..") has failed!")
  
    --There are many possible disconnect reasons, the following iterates through
    --the list and returns the string corresponding to the disconnect reason.
    for key,val in pairs(wifi.eventmon.reason) do
      if val == T.reason then
        print("Disconnect reason: "..val.."("..key..")")
        break
      end
    end
  
    if disconnect_ct == nil then
      disconnect_ct = 1
    else
      disconnect_ct = disconnect_ct + 1
    end

    print("Retrying connection...(attempt "..(disconnect_ct+1)..")")
  end

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)
M.hostname = "Node-"..string.sub(string.gsub(wifi.sta.getmac(), ":",""), 7)

print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATION)
wifi.sta.sethostname(M.hostname)
wifi.sta.setip({ ip = IP, netmask = NETMASK, gateway = GATEWAY })
wifi.sta.config({ ssid=SSID, pwd=PASSWORD })