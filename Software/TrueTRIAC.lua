
outpin=7										-- Select Triac Command pin - GPIO13 
gpio.mode(outpin,gpio.OUTPUT)
gpio.write(outpin,gpio.LOW)						-- Triac OFF
inpin=6											-- Zero crossing detector input - GPIO12  
gpio.mode(inpin,gpio.INT,gpio.PULLUP)			-- attach interrupt to ZCD

function zero_cross()
    dt = 76*dim
    stat = "ON" 
    tmr.delay(dt)								-- Firing delay time calculated above 
    gpio.write(outpin,gpio.HIGH)				-- Triac ON - Zero cross detected
    tmr.delay(100)								-- Triac ON - Propagation time  
    gpio.write(outpin,gpio.LOW)					-- Triac OFF - let's be sure it's OFF before next cycle :)
    tmr.wdclr()
    return stat
end

function fading()
    if(dim_up==1) then dim=dim+2 
    else dim=dim-2
    end
    if(dim < 10) then dim_up=1 dim=10
         else if (dim > 120 ) then dim_up=0 dim=120
    end
    end  
    print("Dimmer level : " .. dim)
    tmr.wdclr()
end

dim = 120                                                          -- Dimmer level - smaller value is brighter
dim_up=0 										-- Fading direction - for test  run
gpio.trig(inpin,"up",zero_cross)				-- ZCD interrupt attached - trigger on falling edge
tmr.alarm(0, 150, 1, function() fading() end)	--timer for testing mode
