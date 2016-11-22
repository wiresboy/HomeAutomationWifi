print "mult = 55"
print "dim = 0-128"

print "dofile(\"zcd.lc\")"

tmr.delay(3000)

function toggle()
    if (a==1) then 
		  gpio.write(7,gpio.HIGH) 
			a=0 
    else 
		  gpio.write(7,gpio.LOW) 
			a=1
    end
    tmr.wdclr()
end

a=0
gpio.mode(7,gpio.OUTPUT)

tmr.alarm(0, 2500, 1, function() toggle() end)	