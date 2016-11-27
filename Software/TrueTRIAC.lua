
outpin=7										-- Select Triac Command pin - GPIO13 
gpio.mode(outpin,gpio.OUTPUT)
gpio.write(outpin,gpio.LOW)						-- Triac OFF
inpin=6											-- Zero crossing detector input - GPIO12  
gpio.mode(inpin,gpio.INT,gpio.FLOAT)			-- attach interrupt to ZCD

function zero_cross()
	if(dim > 0)
	then
		tmr.delay(6001-55*dim)					-- Firing delay time calculated above 
		gpio.write(outpin,gpio.HIGH)				-- Triac ON - Zero cross detected
		tmr.delay(100)								-- Triac ON - Propagation time  
		gpio.write(outpin,gpio.LOW)					-- Triac OFF - let's be sure it's OFF before next cycle :)
		tmr.wdclr()
		--return stat
	end
end

dim = 0											-- Dimmer level - smaller value is brighter
gpio.trig(inpin,"high",zero_cross)				-- ZCD interrupt attached - trigger on falling edge
