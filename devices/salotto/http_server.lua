port = 80
correction_factor = 25

print("Starting http server on port " .. port)
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)

        -- correcto values
        last_temp_in_correct = last_temperature_in > 200 and last_temperature_in/correction_factor or last_temperature_in
        last_temp_out_correct = last_temperature_out > 200 and last_temperature_out/correction_factor or last_temperature_out
        last_humi_in_correct = last_humidity_in > 200 and last_humidity_in/correction_factor or last_humidity_in
        last_humi_out_correct = last_humidity_out > 200 and last_humidity_out/correction_factor or last_humidity_out

        i,j = string.find(payload, '/data')
        data = i ~= nil and true or false

        if data
        then
            init = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n"
            resp = init ..
                "{ \"temperature_in\": " .. last_temp_in_correct .. 
                ", \"humidity_in\": " .. last_humi_in_correct .. 
                ", \"temperature_out\": " .. last_temp_out_correct ..
                ", \"humidity_out\": " .. last_humi_out_correct ..
                " } "
        end

        i,j = string.find(payload, '/metrics')
        metrics = i ~= nil and true or false
        
        if metrics
        then
            resp = init ..
                "temperature " .. last_temp_in_correct .. "\n" ..
                "humidity " .. last_humi_in_correct .. "\n" ..
                "temperature_out " .. last_temp_out_correct .. "\n" ..
                "humidity_out " .. last_humi_out_correct .. "\n"
        end
        
        sck:send(resp)
    end)
    conn:on("sent", function(sck) sck:close() end)
end)

print("Http server started on port " .. port)

