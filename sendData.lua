
alti=14 -- Set your altitude in meters

sda=4	-- GPIO2 connect to SDA BMP180
scl=3	-- GPIO0 connect to SCL BMP180
temp=0  -- Temperature
pres=0 	-- Pressure
oss=0   -- Over sampling setting

HOST = "192.168.0.x"
API = "youJeedomApiKey"

function ReadBMP()
	bmp180 = require("bmp180")
	bmp180.init(sda, scl)
	bmp180.read(oss)
	temp = bmp180.getTemperature()/10
	pres = bmp180.getPressure()/100+alti/8.43
	print("Pressure:    "..string.format("%.1f",pres).." hPa")
	print("Temperature: "..string.format("%.1f",temp).." C")
	print(" ")

    -- Release bmp180 module
	bmp180 = nil
	package.loaded["bmp180"]=nil

    -- HTTP request to Jeedom - Send temperature value
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print(payload) end )
    conn:connect(80,HOST)
    conn:send("GET /core/api/jeeApi.php?apikey="..API.."&type=virtual&id=535&value="..string.format("%.1f",temp).."HTTP/1.1\r\n")
    conn:send("Host: localhost\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
    conn:send("\r\n")
    
    -- HTTP request to Jeedom - Send pression value
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print(payload) end )
    conn:connect(80,HOST)
    conn:send("GET /core/api/jeeApi.php?apikey="..API.."&type=virtual&id=536&value="..string.format("%.1f",pres).."HTTP/1.1\r\n")
    conn:send("Host: localhost\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
    conn:send("\r\n")
end

-- First reading data
ReadBMP()

-- Periodic reading of the sensor
tmr.alarm(1,15000,1, function()ReadBMP()end)