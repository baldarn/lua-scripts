port = 80
correction_factor = 25

print("Starting http server on port " .. port)
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)

        -- correcto values
        last_temp_correct = last_temperature > 200 and last_temperature/correction_factor or last_temperature
        last_humi_correct = last_humidity > 200 and last_humidity/correction_factor or last_humidity


        init = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n"
        resp = init ..
            "{ \"temperature_in\": " .. last_temp_correct .. 
            ", \"humidity_in\": " .. last_humi_correct .. 
            " } "
        sck:send(resp)
    end)
    conn:on("sent", function(sck) sck:close() end)
end)

print("Http server started on port " .. port)

