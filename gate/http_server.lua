port = 80
correction_factor = 25

print("Starting http server on port " .. port)
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)

        init = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n"
        resp = init
        -- get url called
        i,j = string.find(payload, '/gate')
        open_gate = i ~= nil and true or false

        if open_gate
        then
            gpio.write(gate_pin, gpio.LOW)
            tmr.create():alarm(500, tmr.ALARM_SINGLE, function()
                gpio.write(gate_pin, gpio.HIGH)    
            end)
            resp = resp .. "{\"gate\":\"open\"}"
        end

        i,j = string.find(payload, '/temp')
        get_temp = i ~= nil and true or false

        if get_temp
        then
            -- correct values
            last_temp_correct = last_temperature > 200 and last_temperature/correction_factor or last_temperature
            last_humi_correct = last_humidity > 200 and last_humidity/correction_factor or last_humidity


            resp = resp ..
                "{ \"temperature\": " .. last_temp_correct .. 
                ", \"humidity\": " .. last_humi_correct .. 
                " }"
        end
        
        sck:send(resp)
    end)
    conn:on("sent", function(sck) sck:close() end)
end)

print("Http server started on port " .. port)

