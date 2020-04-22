-- distance HC-SR04
--
-- pulse trigger 10ms
-- mark time on echo rise
-- mark time on echo fall
-- initialize global variables

-- configure pins
TRIG_PIN = 1
ECHO_PIN = 5
gpio.mode(TRIG_PIN, gpio.OUTPUT)
gpio.mode(ECHO_PIN, gpio.INT)

-- trig interval in microseconds (minimun is 10, see HC-SR04 documentation)
TRIG_INTERVAL = 10

-- maximum distance in meters
MAXIMUM_DISTANCE = 10

--READING_INTERVAL = math.ceil(((MAXIMUM_DISTANCE * 2 / 340 * 1000) + TRIG_INTERVAL) * 1.2)
READING_INTERVAL = 5000 -- use 5 seconds for demo
print(READNG_INTERVAL)

time_start = 0
time_stop = 0
distance = 0

--LED setup
lighton = 0
led1 = 0
gpio.mode(led1,  gpio.OUTPUT)
gpio.write(led1, gpio.HIGH)

function calculate(start, stop)
    -- echo time (or high level time) in seconds
    local echo_time = (time_stop - time_start) / 1000000
    distance = echo_time * 340 /2
    print("distance: " .. distance .. "m")
    end
    
-- echo callback function called on both rising and falling edges
function echo_callback(level, timestamp)
    if level == 1 then
        -- rising edge (low to high)
        time_start = timestamp
        --print("echo start")
    else
        -- falling edge (high to low)
        time_stop = timestamp
        calculate(time_start, time_stop)
    end
end

-- send trigger signal
function trigger()
    gpio.write(TRIG_PIN, gpio.HIGH)
    gpio.write(led1, gpio.LOW)
    tmr.delay(TRIG_INTERVAL * 1000)
    gpio.write(TRIG_PIN, gpio.LOW)
    gpio.write(led1, gpio.HIGH)
 
end

-- trigger timer
trigger_timer = tmr.create()
trigger_timer:alarm(READING_INTERVAL, tmr.ALARM_AUTO, trigger)

-- set callback function to be called both on rising and falling edges
gpio.trig(ECHO_PIN, "both", echo_callback)

print("Starting measurements")