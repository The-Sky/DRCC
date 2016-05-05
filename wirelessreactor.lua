local increment = 10000 -- The amount incremented every tick
local threshold = 300000000 -- ??

local reactor
local mon

--monitor size
local monX
local monY

term.clear()
-------------------FORMATTING-------------------------------
function clear()
  mon.setBackgroundColor(colors.black)
  mon.clear()
  mon.setCursorPos(1,1)
end

--display text text on monitor, "mon" peripheral
function draw_text(x, y, text, text_color, bg_color)
  mon.setBackgroundColor(bg_color)
  mon.setTextColor(text_color)
  mon.setCursorPos(x,y)
  mon.write(text)
end

--display text on computer's terminal screen
function draw_text_term(x, y, text, text_color, bg_color)
  term.setTextColor(text_color)
  term.setBackgroundColor(bg_color)
  term.setCursorPos(x,y)
  write(text)
end

--draw line on computer terminal
function draw_line(x, y, length, color)
    mon.setBackgroundColor(color)
    mon.setCursorPos(x,y)
    mon.write(string.rep(" ", length))
end

function menu_bar()
  draw_line(1, 1, monX, colors.blue)
  draw_text(2, 1, "  Draconic Reactor Control", colors.white, colors.blue)
end

--draw line on computer terminal
function draw_line_term(x, y, length, color)
    term.setBackgroundColor(color)
    term.setCursorPos(x,y)
    term.write(string.rep(" ", length))
end

--create progress bar
--draws two overlapping lines
--background line of bg_color 
--main line of bar_color as a percentage of minVal/maxVal
function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color)
  draw_line(x, y, length, bg_color) --backgoround bar
  local barSize = math.floor((minVal/maxVal) * length) 
  draw_line(x, y, barSize, bar_color) --progress so far
end

--same as above but on the computer terminal
function progress_bar_term(x, y, length, minVal, maxVal, bar_color, bg_color)
  draw_line_term(x, y, length, bg_color) --backgoround bar
  local barSize = math.floor((minVal/maxVal) * length) 
  draw_line_term(x, y, barSize, bar_color)  --progress so far
end

function homepage()
	while true do
		clear()
		menu_bar()
		tbl = reactor.getReactorInfo()
		for k, v in pairs (tbl) do
			--print(k,v)
			if k == "temperature" then
				reactor_temperature= v
			end
			if k == "energySaturation" then
				energySaturation = v
			end
			if k == "fieldStrength" then
				fieldStrength	 = v
			end
			if k == "generationRate" then
				generationRate = v
			end
			if k == "fuelConversion" then
				fuelConversion = v
			end
			if k == "fuelConversionRate" then
				fuelConversionRate = v
			end
			if k == "status" then
				active = v
			end
		end

		---------Power Status----------
		draw_text(2,3, "Power:", colors.yellow, colors.black)
		if active == "online" then
			draw_text(10, 3, "ONLINE", colors.lime, colors.black)
		else
			draw_text(10, 3, "OFFLINE", colors.red, colors.black)
		end

		-------Fuel Level---------
		draw_text(2, 5, "Fuel Level:", colors.yellow, colors.black)

		fuel = fuelConversion / 10368
		fuelpercentage = math.floor(100-(fuel*100))
		draw_text(15, 5, fuelpercentage.."%", colors.white, colors.black)

			if fuel < 25 then
			progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.red, colors.gray)
		else if fuel < 50 then
			progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.orange, colors.gray)
		else if fuel < 75 then 
			progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.yellow, colors.gray)
		else if fuel <= 100 then
			progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.lime, colors.gray)
		end
		end
		end
		end

		-----------Reactor Temperature---------------
		draw_text(2, 8, "Reactor Temp:", colors.yellow, colors.black)
		maxVal = 11000
		minVal = math.floor(reactor_temperature)

		if minVal < 5000 then
		progress_bar(2, 9, monX-2, minVal, maxVal, colors.lime, colors.gray)
		else if minVal < 7000 then
		progress_bar(2, 9, monX-2, minVal, maxVal, colors.yellow, colors.gray)
		else if minVal < 9000 then  
		progress_bar(2, 9, monX-2, minVal, maxVal, colors.orange, colors.gray)
		else if minVal < 11000 then
		progress_bar(2, 9, monX-2, 11000, maxVal, colors.red, colors.gray)
		end
		end
		end
		end		
		draw_text(16, 8, math.floor(minVal).."/"..maxVal, colors.white, colors.black)

		-----------Field Strength---------------
		draw_text(2, 11, "Field Strength: ", colors.yellow, colors.black)
		conc_fieldStrength = string.sub(fieldStrength, 0, 5)
		fieldStrength_percentage = conc_fieldStrength	 * 10
		conc_fieldStrength_percentage = math.floor(fieldStrength_percentage)

		maxVal = 100
		minVal = conc_fieldStrength_percentage
		if minVal < 80 then
		progress_bar(2, 12, monX-2, minVal, maxVal, colors.lime, colors.gray)
		else if minVal < 60 then
		progress_bar(2, 12, monX-2, minVal, maxVal, colors.yellow, colors.gray)
		else if minVal < 40 then  
		progress_bar(2, 12, monX-2, minVal, maxVal, colors.orange, colors.gray)
		else if minVal < 20 then
		progress_bar(2, 12, monX-2, minVal, maxVal, colors.red, colors.gray)
		end
		end
		end
		end
		draw_text(18, 11, fieldStrength_percentage.."%", colors.white, colors.black)

		-----------Energy Saturation---------------
		draw_text(2, 14, "Energy Saturation:", colors.yellow, colors.black)
		energySat = energySaturation * 0.0000001
		energySat_percentage = math.floor(energySat)

		maxVal = 100
		minVal = energySat_percentage
		if minVal < 30 then
		progress_bar(2, 15, monX-2, minVal, maxVal, colors.lime, colors.gray)
		else if minVal < 60 then
		progress_bar(2, 15, monX-2, minVal, maxVal, colors.yellow, colors.gray)
		else if minVal < 40 then  
		progress_bar(2, 15, monX-2, minVal, maxVal, colors.orange, colors.gray)
		else if minVal < 20 then
		progress_bar(2, 15, monX-2, minVal, maxVal, colors.red, colors.gray)
		end
		end
		end
		end
		draw_text(21, 14, energySat_percentage.."%", colors.white, colors.black)

		draw_text(2, 17, "RF/tick:", colors.yellow, colors.black)
		rft = math.floor(generationRate)
		draw_text(13, 17, rft.." RF/t", colors.white, colors.black)


		-----------Automated Reactor Control-----------

		fluxLowFlow = flux_gate.getSignalLowFlow()

		if energySaturation > threshold then
			if fluxLowFlow	>= 690000 then
				fluxLowFlow	 = 690000
			end
			fluxLowFlow	= fluxLowFlow + increment
			-- print("FluxGate set to =", fluxLowFlow)
			flux_gate.setSignalLowFlow(fluxLowFlow)
		end
		if energySaturation	< threshold then
			if fluxLowFlow <= 10000 then
				fluxLowFlow	= 10000
			end
			fluxLowFlow	= fluxLowFlow - increment
			--print("FluxGate set to =", fluxLowFlow)
			flux_gate.setSignalLowFlow(fluxLowFlow)
		end

		draw_text(2, 18, "FluxGate: ", colors.yellow, colors.black)
		draw_text(13, 18, fluxLowFlow.."RF/t", colors.white, colors.black)

		tab = {
			["status"] = active,
			["reactor_temperature"] = math.floor(reactor_temperature),
			["energySat_percentage"] = energySat_percentage,
			["fieldStrength_percentage"] = fieldStrength_percentage,
			["generationRate"] = math.floor(generationRate),
			["fluxLowFlow"] = fluxLowFlow,
			["fuelpercentage"] = fuelpercentage,

		}

		modem.transmit(1, 2, tab)

		sleep(0.5)
	end
end

--test if the entered monitor and reactor can be wrapped
function test_configs()
  term.clear()

  draw_line_term(1, 1, 55, colors.blue)
  draw_text_term(10, 1, "Draconic Reactor Controls", colors.white, colors.blue)
  
  draw_line_term(1, 19, 55, colors.blue)
  draw_text_term(10, 19, "by Ralyks", colors.white, colors.blue)

  draw_text_term(1, 3, "Searching for a peripherals...", colors.white, colors.black)
  sleep(1)

  reactor = reactorSearch()
  mon = monitorSearch()
  flux_gate = fluxgateSearch()
  
  draw_text_term(2, 5, "Connecting to reactor...", colors.white, colors.black)
  sleep(0.5)
  if reactor == null then
      draw_text_term(1, 8, "Error:", colors.red, colors.black)
      draw_text_term(1, 9, "Could not connect to reactor", colors.red, colors.black)
      draw_text_term(1, 10, "Reactor must be connected with networking cable", colors.white, colors.black)
      draw_text_term(1, 11, "and modems or the computer is directly beside", colors.white, colors.black)
       draw_text_term(1, 12,"the reactors computer port.", colors.white, colors.black)
      draw_text_term(1, 14, "Press Enter to continue...", colors.gray, colors.black)
      wait = read()
      setup_wizard()
  else
      draw_text_term(27, 5, "success", colors.lime, colors.black)
      sleep(0.5)
  end
  
  draw_text_term(2, 6, "Connecting to monitor...", colors.white, colors.black)
  sleep(0.5)
  if mon == null then
      draw_text_term(1, 7, "Error:", colors.red, colors.black)
      draw_text_term(1, 8, "Could not connect to a monitor. Place a 3x3 advanced monitor", colors.red, colors.black)
      draw_text_term(1, 11, "Press Enter to continue...", colors.gray, colors.black)
      wait = read()
      setup_wizard()
  else
      monX, monY = mon.getSize()
      draw_text_term(27, 6, "success", colors.lime, colors.black)
      sleep(0.5)
  end

    draw_text_term(2, 7, "saving configuration...", colors.white, colors.black)  

    sleep(0.1)
    draw_text_term(1, 9, "Setup Complete!", colors.lime, colors.black) 
    sleep(1)

    modem = peripheral.wrap("top")


    auto = auto_string == "true"
    call_homepage() 
end

--run both homepage() and stop() until one returns
function call_homepage()
	homepage()
end

function reactorSearch()
   local names = peripheral.getNames()
   local i, name
   for i, name in pairs(names) do
      if peripheral.getType(name) == "draconic_reactor" then
         return peripheral.wrap(name)
      else
         --return null
      end
   end
end

function monitorSearch()
   local names = peripheral.getNames()
   local i, name
   for i, name in pairs(names) do
      if peripheral.getType(name) == "monitor" then
        test = name
         return peripheral.wrap(name)
      else
         --return null
      end
   end
end

function fluxgateSearch()
   local names = peripheral.getNames()
   local i, name
   for i, name in pairs(names) do
      if peripheral.getType(name) == "flux_gate" then
        test = name
         return peripheral.wrap(name)
      else
         --return null
      end
   end
end

function stop()
	while true do
    return
  end 
end

function start()
    test_configs()
end

start()
