port = 80

print("Starting http server on port " .. port)
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)
        resp = "{ 'temperature': " .. last_temperature .. ", 'humidity': " .. last_humidity .. " } "
        sck:send(resp)
    end)
    conn:on("sent", function(sck) sck:close() end)
end)

print("Http server started on port " .. port)
