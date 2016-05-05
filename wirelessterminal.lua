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

--display text on computer's terminal screen
function draw_text_term(x, y, text, text_color, bg_color)
  term.setTextColor(text_color)
  term.setBackgroundColor(bg_color)
  term.setCursorPos(x,y)
  write(text)
end

--header and footer bars on monitor
function menu_bar()
  draw_line(1, 1, monX, colors.blue)
  draw_text(2, 1, "  Draconic Reactor Control", colors.white, colors.blue)
end

--display text text on monitor, "mon" peripheral
function draw_text(x, y, text, text_color, bg_color)
  mon.setBackgroundColor(bg_color)
  mon.setTextColor(text_color)
  mon.setCursorPos(x,y)
  mon.write(text)
end

--draw line on computer terminal
function draw_line(x, y, length, color)
    mon.setBackgroundColor(color)
    mon.setCursorPos(x,y)
    mon.write(string.rep(" ", length))
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
	local modem = peripheral.wrap("top")
	modem.open(1)
	local messageArguments = {os.pullEvent("modem_message")}
	for i, v in pairs(messageArguments) do
		if i == 5 then
			for x, y in pairs(v) do
				if x == "status" then
					active = y
				else if x == "energySat_percentage" then
					energySat_percentage = y
				else if x == "fluxLowFlow" then
					fluxLowFlow = y
				else if x == "reactor_temperature" then
					reactor_temperature = y
				else if x == "generationRate" then
					generationRate = y
				else if x == "fuelpercentage" then
					fuelpercentage = y
				else if x == "fieldStrength_percentage" then
					fieldStrength_percentage = y
				end
				end
				end
				end
				end
				end
				end
			end
		end
	end
	display()
end


function display()
	clear()
	menu_bar()

	---------Power Status----------
	draw_text(2,3, "Power:", colors.yellow, colors.black)
	if active == "online" then
		draw_text(10, 3, "ONLINE", colors.lime, colors.black)
	else
		draw_text(10, 3, "OFFLINE", colors.red, colors.black)
	end

	-------Fuel Level---------
	draw_text(2, 5, "Fuel Level:", colors.yellow, colors.black)
	draw_text(15, 5, fuelpercentage.."%", colors.white, colors.black)

		if fuelpercentage < 25 then
		progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.red, colors.gray)
	else if fuelpercentage < 50 then
		progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.orange, colors.gray)
	else if fuelpercentage < 75 then 
		progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.yellow, colors.gray)
	else if fuelpercentage <= 100 then
		progress_bar(2, 6, monX-2, fuelpercentage, 100, colors.lime, colors.gray)
	end
	end
	end
	end

	-----------Reactor Temperature---------------
	draw_text(2, 8, "Reactor Temp:", colors.yellow, colors.black)
	maxVal = 10000
	minVal = reactor_temperature

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
	rft = generationRate
	draw_text(13, 17, rft.." RF/t", colors.white, colors.black)

	draw_text(2, 18, "FluxGate: ", colors.yellow, colors.black)
	draw_text(13, 18, fluxLowFlow.."RF/t", colors.white, colors.black)
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

mon = monitorSearch()
monX, monY = mon.getSize()

while true do
	homepage()
end

