--Variables

local length_of_mines = 0  --How long the Mines are
local travel_forward = 0  --Counter for moving
local travel_backwards = 0  --Counter for moving
local direction_of_mines = 0  --Left = 0, Right = 1
local space_between_mines = 0  --number of Blocks between Mines (min. 0)
local travel_between_mines = 0  --counter for moving
local num_of_mines = 0  --number of mines
local num_of_mines_counter = 0  --counter for moving
local darkness = 0  --used to determine torch placement

local fuel_item = 0  --number of fuel 
local chest_item = 0  --number of chests
local torch_item = 0  --number of torches
local needFuel = 0  --if turtle needs fuel (0 = no need for fuel, 1 = need for fuel)
local Error = 0  --Used for checking if Turtle has fuel, chests and torches (No Error = 0, Error = 1)
local Correction = 0  --Used for item input correction time
local CorrectionAns = 0  --Used for item input correction answer from user



--Check if all needed items are in the slots
local function Check()
	term.setBackgroundColor(colors.gray)
	term.clear()
	term.setCursorPos(1,1)
	print("       TJs awesome Turtle Mines")
	print(" ")
	
	if fuel_item == 0 then
		print("There is no fuel in the first slot!")
		Error = 1
	elseif fuel_item < 20 then
		print("You only put", fuel_item, "fuel items in! The turtle might run out of fuel early.")
		Correction = 1
	else
		print("Fuel is in the first slot.")
	end
	
	print(" ")
	
	if chest_item == 0 then
		print("There is no chests in the second slot!")
		Error = 1
	elseif chest_item < 10 then
		print("You only put", chest_item, "chests in! The turtle might run out of room early.")
		Correction = 1
	else
		print("Chests are in the second slot.")
	end
	
	print(" ")
		
	if torch_item == 0 then
		print("There is no torches in the third slot!")
		Error = 1
	elseif torch_item < 20 then
		print("You only put", torch_item, "torches in! The turtle might run out of light early.")
		Correction = 1
	else
		print("Torches are in the third slot.")
	end
		
end


-- check item count 
local function UpdateInventory()
	fuel_item = turtle.getItemCount(1)
	chest_item = turtle.getItemCount(2)
	torch_item = turtle.getItemCount(3)
	Error = 0
end


-- code to mine forward
local function MineForward()
	print("This is where MineForward beginns")
	
	repeat
		if turtle.detect() then
			turtle.dig()
		end
		if turtle.forward() then
			travel_forward = travel_forward - 1
			darkness = darkness + 1
		end
		if turtle.detectUp() then
			turtle.digUp()
		end
		turtle.select(4)
		turtle.placeDown()
		
		if darkness == 8 then -- Every 10 Block turtle place torch
			if torch_item > 0 then
				turtle.turnLeft()
				turtle.turnLeft()
				turtle.select(3)
				turtle.place()
				turtle.turnLeft()
				turtle.turnLeft()
				torch_item = torch_item - 1
				darkness = 0
			else
				print("Turtle ran out of torches!")
				print("Not going to place any more torches!")
			end
		end
		
		repeat
		
			if fuel_item == 0 then
				print("Turtle run out of fuel!")
				--os.shutdown()
				
			elseif turtle.getFuelLevel() < 100 then
				turtle.select(1)
				turtle.refuel(1)
				needFuel = 1
				fuel_item = fuel_item - 1
				
			elseif needFuel == 1 then
				needFuel = 0
			end
			
		until needFuel == 0
		
		if turtle.getItemCount(16)>0 then
			if chest_item > 0 then
				turtle.select(2)
				turtle.digDown()
				turtle.placeDown()
				chest_item = chest_item - 1
				for slot = 5, 16 do
					turtle.select(slot)
					turtle.dropDown()
					sleep(1.5)
				end
				turtle.select(5)
			else
				print("Turtle ran out of chests!")
				--os.shutdown()
			end
		end
	until travel_forward == 0
end


--code to turn around at the end of the mine
local function TurnAround()
	print("This is where TurnAround beginns")
	
	turtle.turnLeft()
	turtle.turnLeft()
	turtle.up()
end


--code to walk back up the mine
local function WalkBack()
	print("This is where WalkBack beginns")
	
	repeat
		if turtle.forward() then -- sometimes sand and gravel and block and mix-up distance
			travel_backwards = travel_backwards - 1
		end
		if turtle.detect() then -- Sometimes sand and gravel can happen and this will fix it
			if travel_backwards ~= 0 then
				turtle.dig()
			end
		end
	until travel_backwards == 0
end


--code to setup the next mine
local function SetupNextMine()
	print("This is where SetupNextMine beginns")
	
	if direction_of_mines == 1 then
		turtle.down()		
		turtle.turnLeft()
	else
		turtle.down()
		turtle.turnRight()
	end
	
	repeat
		if turtle.detect() then
			turtle.dig()
		end
		if turtle.forward() then
			travel_between_mines = travel_between_mines - 1
		end
		if turtle.detectUp() then
			turtle.digUp()
		end
		turtle.select(4)
		turtle.placeDown()
	until travel_between_mines == 0
	
	if direction_of_mines == 1 then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	if num_of_mines_counter == 0 then
		print("Turtle is done")
	else
		num_of_mines_counter = num_of_mines_counter - 1
	end
	
	travel_forward = length_of_mines
	travel_backwards = length_of_mines
	travel_between_mines = space_between_mines
	darkness = 0
	
end


--code to return the turtle to the position it was placed on
local function ReturnToStart()
	print("This is where ReturnToStart beginns")
	
	if direction_of_mines == 1 then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	
	for i = 1, num_of_mines*space_between_mines do
		if turtle.detect() then
			turtle.dig()
		end
		
		turtle.forward()
		
		if turtle.detectUp() then
			turtle.digUp()
		end
	end
	
end


local function Start()
	print("This is where start beginns")
	
	repeat
		MineForward()
		TurnAround()
		WalkBack()
		SetupNextMine()
	until num_of_mines_counter == 0
	
	ReturnToStart()
	
	term.setBackgroundColor(colors.black)
	term.setBackgroundColor(colors.gray)
	term.clear()
	term.setCursorPos(1,1)
	print("       TJs awesome Turtle Mines")
	print(" ")
	print("All done :)")
	print(" ")
	print(" ")
	print(" ")
	print(" ")
	
end

--SplashScreen

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")

print("How long should the Mines be?")
input = io.read()
length_of_mines = tonumber(input)
travel_forward = length_of_mines
travel_backwards = length_of_mines

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")

print("In what direction? Left = 0   Right = 1")
input2 = io.read()
direction_of_mines = tonumber(input2)

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")

print("How many Blocks between Mines?")
input3 = io.read()
space_between_mines = tonumber(input3 + 1)
travel_between_mines = space_between_mines

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")

print("How many Mines should there be?")
input4 = io.read()
num_of_mines = tonumber(input4)
num_of_mines_counter = num_of_mines

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")

print("Please put fuel in the first slot.")
print("Please put chests in the second slot.")
print("Please put torches in the third slot.")
print(" ")
print("You can put building blocks in the forth slot.")
print("Otherwise the first mined block in that slot is used.")
print(" ")
print("Input 1 when you are done.")
input5 = tonumber(io.read())

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")

UpdateInventory()
Check()

if Error == 1 then
	repeat
		sleep(2)
		term.setBackgroundColor(colors.gray)
		term.clear()
		term.setCursorPos(1,1)
		print("       TJs awesome Turtle Mines")
		print(" ")
		sleep(1)
		
		UpdateInventory()
		Check()
				
	until Error == 0

elseif Correction == 1 then
	print("To continue input 1")
	input7 = tonumber(io.read())
	
	UpdateInventory()
	Check()
	
end

term.setBackgroundColor(colors.gray)
term.clear()
term.setCursorPos(1,1)
print("       TJs awesome Turtle Mines")
print(" ")
print("All done!")
print("Do you want to start the mine?")
print(" ")
print("Type 1 for yes, type 2 to abort the programm")
input6 = tonumber(io.read())

if input6 == 1 then
	repeat
		if turtle.getFuelLevel() < 100 then
			turtle.select(1)
			turtle.refuel(1)
			fuel_item = fuel_item - 1
			needFuel = 1
			
		elseif needFuel == 1 then
			needFuel = 0
		end
	until needFuel == 0
	
	Start()
	
elseif input6 == 2 then
	term.setBackgroundColor(colors.gray)
	term.clear()
	term.setCursorPos(1,1)
	
	print(" ")
	print("Shutting down programm")
	sleep(1)
	print(".")
	sleep(1)
	print(".")
	sleep(1)
	print(".")
	sleep(2)
	
	term.setBackgroundColor(colors.black)
	term.clear()
	term.setCursorPos(1,1)
	
	os.reboot()
end