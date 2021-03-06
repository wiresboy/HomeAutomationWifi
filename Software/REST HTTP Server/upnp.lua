net.multicastJoin(wifi.sta.getip(), "239.255.255.250")

local ssdp_notify = "NOTIFY * HTTP/1.1\r\n"..
"HOST: 239.255.255.250:1900\r\n"..
"CACHE-CONTROL: max-age=100\r\n"..
"NT: urn:schemas-upnp-org:device:ZonePlayer:1\r\n"..
"USN: uuid:c5baf4a1-0c8e-44da-9714-ef"..string.format("%x",node.chipid()).."::urn:schemas-upnp-org:device:ZonePlayer:1\r\n"..
"NTS: ssdp:alive\r\n"..
"SERVER: NodeMCU/20161126 UPnP/1.1 ovoi/0.1\r\n"..
"Location: http://"..wifi.sta.getip()..":80/HomeAuto.xml\r\n\r\n"


local ssdp_response = "HTTP/1.1 200 OK\r\n"..
"Cache-Control: max-age=100\r\n"..
"EXT:\r\n"..
"SERVER: NodeMCU/20150415 UPnP/1.1 ovoi/0.1\r\n"..
"ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n"..
"USN: uuid:c5baf4a1-0c8e-44da-9714-ef"..string.format("%x",node.chipid()).."\r\n"..
"Location: http://"..wifi.sta.getip()..":80/HomeAuto.xml\r\n\r\n"

notifyCount = 0

local function notify()
    notifyCount = notifyCount + 1
    if notifyCount == 3 then
        tmr.stop(3)
        notifyCount = nil
        ssdp_notify = nil
        collectgarbage()
    else
        UPnP = net.createConnection(net.UDP)
        UPnP:connect(1900,"239.255.255.250")
        UPnP:send(ssdp_notify)
        print("Sending notify")
        UPnP:close()
        UPnP = nil
        notify = nil
        collectgarbage()
    end


end

local function response(connection, payLoad)
        if string.match(payLoad,"M-SEARCH") then
            connection:send(ssdp_response)
            --print("sent "..node.heap())
			--print(payLoad)
        end
end


tmr.alarm(3, 10000, 1, notify)

UPnPd=net.createServer(net.UDP) 

UPnPd:on("receive", response )

UPnPd:listen(1900,"239.255.255.250")