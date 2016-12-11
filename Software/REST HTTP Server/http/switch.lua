return function (connection, req, args)
  dofile("httpserver-header.lc")(connection, 200, 'xml')
  
  if (args ~= nil) and (args.state ~= nil)
  then
    dim = tonumber(args.state)
	print("Set dimmer to " .. dim)
  end
  
  connection:send("<dimmer>"..dim.."</dimmer>")
  
  gpio.mode(1,gpio.OUTPUT)
  if (dim==0)
  then
	gpio.write(1,gpio.LOW)
  else
    gpio.write(1,gpio.HIGH)
  end
end

