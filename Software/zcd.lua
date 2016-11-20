outpin=7										-- Select Triac Command pin - GPIO13 
gpio.mode(outpin,gpio.OUTPUT)
gpio.write(outpin,gpio.LOW)						-- Triac OFF
inpin=6											-- Zero crossing detector input - GPIO12  
gpio.mode(inpin,gpio.INT,gpio.PULLUP)			-- attach interrupt to ZCD
mult = 55 -- 63

function zero_cross()
    gpio.write(outpin,gpio.HIGH)				-- Triac ON - Zero cross detected
    tmr.delay(mult*dim+1) 						-- Firing delay time 
    --tmr.delay(10)								-- Triac ON - Propagation time  
    gpio.write(outpin,gpio.LOW)					-- Triac OFF - let's be sure it's OFF before next cycle :)
    tmr.wdclr()
    return 1--stat
end

dim = 64										-- Dimmer level - smaller value is brighter
dim_up=0        								-- Fading direction - for test  run
gpio.trig(inpin,"up",zero_cross)				-- ZCD interrupt attached - trigger on falling edge