require('config')

alti=14 -- Set your altitude in meters
sda=4	-- GPIO2 connect to SDA BMP180
scl=3	-- GPIO0 connect to SCL BMP180
temp=0  -- Temperature
pres=0 	-- Pressure
oss=0   -- Over sampling setting

function readBMP()
    result = {}
	bmp180 = require("bmp180")
	bmp180.init(sda, scl)
	bmp180.read(oss)
	result["temp"] = bmp180.getTemperature()/10
	result["pres"] = bmp180.getPressure()/100+alti/8.43   
    -- Release bmp180 module
	bmp180 = nil
	package.loaded["bmp180"]=nil
    return result
end

-- HTTP server 
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)    
        local response = "HTTP/1.1 200 OK\r\n\r\nOK"
        if(string.find(request, "/temp") ~= nil) then
            response = readBMP().temp
        end
        if(string.find(request, "/pres") ~= nil) then
            response = readBMP().pres
        end
        if(string.find(request, "/reset") ~= nil) then
            node.restart()
        end
        -- Send response
        print(response)
        conn:send(response, function()
            conn:close()
        end)
        collectgarbage();
    end)
end)