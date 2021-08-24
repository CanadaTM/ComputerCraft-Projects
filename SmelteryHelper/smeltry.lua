--[[
This programe will be used to read a Tinkers'
	Construct smeltery, display some data about it,
	and be able to perform some automated tasks
	relating to the smeltery.

	VSCode max col = 52
]]

Monitor = peripheral.wrap("top")
Graphics_Mode = false
Offset = 1
Ore_Colors = {
	clay = colors.brown,
	glass = colors.lightBlue,
	obsidian = colors.gray,
	ender = colors.green,
	emerald = colors.lime,
	quartz = colors.lightGray,
	diamond = colors.cyan,
	debris = colors.brown,
	iron = colors.orange,
	gold = colors.yellow,
	copper = colors.orange,
	cobalt = colors.blue,
	slime_steel = colors.lightBlue,
	tinkers_bronze = colors.orange,
	rose_gold = colors.pink,
	pig_iron = colors.magenta,
	manyullyn = colors.purple,
	hepatizon = colors.purple,
	queens_slime = colors.green,
	netherite = colors.gray,
	tin = colors.lightGray,
	aluminum = colors.lightGray,
	lead = colors.gray,
	silver = colors.lightGray,
	nickel = colors.yellow,
	zinc = colors.lightGray,
	osmium = colors.lightBlue,
	uranium = colors.green,
	bronze = colors.orange,
	brass = colors.yellow,
	electrum = colors.yellow,
	invar = colors.lightGray,
	constantan = colors.orange,
	pewter = colors.yellow,
	steel = colors.gray
}

local function draw_box_from_center(
	center_x,
	center_y,
	width,
	height,
	color,
	filled
)
	--[[
	This function behaves similarly to the builtin
		`paintutils.drawBox` but instead of needing a
		start corner and end corner, it takes in a center
		point and a width and height.
	]]

	-- defaults
	color = color or colors.white
	filled = filled or false

	--[[
	Check if we want the box filled. For either, we
		calculate the top left and bottom right points.
	]]
	if filled then
		paintutils.drawFilledBox(
			math.floor(center_x - (width / 2)),
			math.floor(center_y - (height / 2)),
			math.floor(center_x + (width / 2)),
			math.floor(center_y + (height / 2)),
			color
		)
	else
		paintutils.drawBox(
			math.floor(center_x - (width / 2)),
			math.floor(center_y - (height / 2)),
			math.floor(center_x + (width / 2)),
			math.floor(center_y + (height / 2)),
			color
		)
	end
end

local function draw_tank_graduations(
	width, height, tank_height
)
	--[[
	This function handles drawing the graduations
		on the gui representation of the smeltry
		tank.
	]]

	-- 1/4
	paintutils.drawLine(
		width-1,
		math.ceil(height-(0.25 * tank_height) - 1),
		width-4,
		math.ceil(height-(0.25 * tank_height) - 1),
		colors.green)

	--1/2
	paintutils.drawLine(
		width-1,
		math.ceil(height-(0.5 * tank_height) - 1),
		width-4,
		math.ceil(height-(0.5 * tank_height) - 1),
		colors.yellow)

	--3/4
	paintutils.drawLine(
		width-1,
		math.ceil(height-(0.75 * tank_height) - 1),
		width-4,
		math.ceil(height-(0.75 * tank_height) - 1),
		colors.red)
end

local function draw_smeltry_tank(width, height)
	--[[
	This function handles drawing the gui
		representation of the smeltery tank.
	]]

	-- calculate the height of the gui tank (in
	--     characters)
	local tank_height = height - (2 * Offset)

	-- make the gray color a bit darker.
	term.setPaletteColour(colors.gray, 0x303030)

	-- outline minus the top
	draw_box_from_center(
		0.75 * width,
		(height / 2) + Offset,
		width / 2,
		tank_height
	)
	paintutils.drawLine(
		1 + (width / 2),
		Offset * 2,
		width - 1,
		Offset * 2,
		colors.gray
	)

	--graduations
	draw_tank_graduations(
		width, height, tank_height
	)
	return tank_height
end

local function draw_static_gui(monitor)
	--[[
	This function handles drawing all of the
		elements of the GUI that are static.
	]]

	local oldterm = term.redirect(monitor)
	--! Now all term.* calls will go to the monitor
	--!   instead

	-- set the monitor to graphics mode and get
	--  the width and height
	local width, height = term.getSize(
		Graphics_Mode
	)

	-- fully clear the monitor's view and set the
	--  cursor to position 1, 1
	term.setBackgroundColor(colours.black)
	term.clear()
	term.setCursorPos(1,1)

	-- draw the smeltry tank
	local tank_height = draw_smeltry_tank(
		width, height
	)

	-- print the title text, centered above the
	--  left half of the screen
	local title = "Smelt.io"
	term.setCursorPos(
		(
			math.floor(width / 2)
			- string.len(title)
		) / 2,
		1
	)
	term.setBackgroundColor(colors.black)
	print(title)

	--print the smeltery tank label text, centered
	--  above the right half of the screen
	local tank_title = "Smeltery Contents:"
	term.setCursorPos(
		math.ceil(width / 2)
		+ ((math.ceil(width / 2)
		- string.len(tank_title)) / 2),
		1
	)
	term.setBackgroundColor(colors.black)
	print(tank_title)

	term.redirect(oldterm)
	--! Now the term.* calls will draw on the
	--!   terminal again
	return tank_height
end

local function fill_gui_tank(
	smeltery_contents,
	max_fluids,
	width,
	height,
	tank_height
)
	--[[
	This function takes in a table containing the
		current contents of the smeltery, and draws
		a GUI representation of the contents on the
		screen.
	]]

	local function fill_box()
		--[[
		handles drawing all the boxes for making
			the GUI accurate.
		]]

		--TODO: Put ore text, centered, over spots in gui

		-- clear tank contents
		draw_box_from_center(
			0.75 * width, (height / 2) + Offset,
			(width / 2) - 2,
			tank_height - 2,
			colors.black,
			true
		)

		-- draw fluids
		-- setup a next y so we can place the next
		--  fluid above the previous
		local next_y = height - 1

		-- keep a running total of the current
		--  fluid total (in mb)
		local total_liquids = 0

		--loop through every liquid in the smeltery
		for _, value in (
			ipairs(smeltery_contents)
		) do

			--[[
			extract the ore name for use in
				determining the color we render the
				bar in, as well as getting the
				amount of the current metal there
				is.
			]]
			local ore = string.sub(value.name, 19)
			local metal_amount = value.amount

			-- add to the total liquid count.
			total_liquids =
				total_liquids + value.amount

			-- draw an appropriately sized box with
			--  respect to the size of the tank.
			paintutils.drawFilledBox(
				width - 1,
				next_y,
				(width / 2) + 1,
				(
					next_y
					- (
						(metal_amount / max_fluids)
						* tank_height
					)
				),
				Ore_Colors[ore] or colors.lightGray
			)

			-- incriment the next y value to be
			--  above the previous one.
				next_y =
					next_y - (
						(
							(
								metal_amount
								/ max_fluids
							)
							* tank_height
						) * 0.8
					) - 1
		end

		-- redraw graduations
		draw_tank_graduations(
			width, height, tank_height
		)

		-- return the total amount (in mb) of
		--  liquid we have in the smeltery.
		return total_liquids
	end

	-- draw each metal's fill level in the GUI
	local total_liquids = fill_box()

	-- return the current fill percentage as a
	--  value between 0 and 1.
	return total_liquids / max_fluids
end

local function read_smeltery()
	--[[
	This function handles all the data collection from
		the connected smeltery.
	]]

	-- wrap the key elements of the smeltery that
	--  we need to read from.
	local smeltery = peripheral.wrap(
		"tconstruct:smeltery_0"
	)
	local duct = peripheral.wrap(
		"tconstruct:duct_0"
	)
	local lava_tank = peripheral.wrap(
		"tconstruct:tank_0"
	)

	--[[
	grab the maximum amount of items that can
		fit into the smeltery and use it to
		calculate the total molten ingot capacity,
		and the total fluid capacity.
	]]
	local item_capacity = smeltery.size()
	local ingot_capacity = item_capacity * 8
	local fluid_capacity = ingot_capacity * 144

	-- pull the current molten contents of the
	--  smeltery
	local contents = duct.tanks()

	--[[
	get the content of the fuel tank(s), setup a
		variable to hold the current fuel level,
		and calculate the maximum fuel capacity.
	]]
	local fuel_contents = lava_tank.tanks()
	local fuel_level = 0
	local fuel_capacity = table.getn(
		fuel_contents
	) * 4000

	-- add up the contents of all fuel tanks.
	for _, value in ipairs(fuel_contents) do
		fuel_level = fuel_level + value.amount
	end

	-- return a table containing all the information
	-- 	we pulled from the smeltery.
	return {
		max_ingots = ingot_capacity,
		max_fluids = fluid_capacity,
		smeltery_contents = contents,
		max_fuel = fuel_capacity,
		fuel_fill_level = fuel_level / fuel_capacity
	}

end

local function print_smeltery_details(
	width,
	current_fill_level,
	ingot_capacity,
	fluid_capacity,
	current_fuel_level,
	fuel_capacity
)
	--[[
	This function handles displaying all the pertinent
		information in a nice way on the left half of the
		monitor.
	]]

	-- set the cursor just below the left side's title,
	-- 	and make sure the background is black and the
	-- 	text is white
	term.setCursorPos(1, 3)
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)

	-- calculate the maximum lenght of a stirng that will
	-- 	fit nicely on the lefthand side.
	local max_string_lenght = math.floor(width / 2)

	-- print the current fill percentage with 3
	-- 	significant digits.
	print("Smeltery Details:\n")
	print(
		"Fill Ammount: " .. string.format(
			"%.3f%%", current_fill_level * 100
		) .. "\n"
	)

	-- construct the string that represents the total
	-- 	ingot capacity.
	local ingot_capacity_string =
		"Ingot Capacity: "
		.. ingot_capacity
		.. " Ingots"

	-- check it's length and if it's too long, print it
	-- 	on two lines.
	if (
		string.len(ingot_capacity_string)
		< max_string_lenght
	) then
		print(ingot_capacity_string)
	else
		print(
			"Ingot Capacity: \n\t"
			.. ingot_capacity
			.. " Ingots\n"
		)
	end

	-- construct the string that represents the total
	-- 	fluid capacity.
	local fluid_capacity_string =
		"Fluid Capacity: "
		.. fluid_capacity
		.. "mb\n"

	-- check it's length and if it's too long, print it
	-- 	on two lines.
	if (
		string.len(fluid_capacity_string)
		< max_string_lenght
	) then
		print(fluid_capacity_string)
	else
		print(
			"Fluid Capacity: \n\t"
			.. fluid_capacity
			.. "mb\n"
		)
	end

	-- construct the string that represents the current
	-- 	and total fuel capacity.
	local fuel_level_string =
	"Fuel Level: "
	.. string.format(
		"%.3f%%", current_fuel_level * 100
	)
	.. " of "
	.. fuel_capacity
	.. "mb"

	-- check it's length and if it's too long, print it
	-- 	on two lines.
	if (
		string.len(fuel_level_string)
		< max_string_lenght
	) then
		print(fuel_level_string)
	else
		print(
			"Fuel Level: \n\t"
			.. string.format(
				"%.3f%%", current_fuel_level * 100
			)
			.. " of "
			.. fuel_capacity
			.. "mb"
		)
	end
end

local function main()
	--[[
	the main function where evrything is done and where
		the main loop is.
	]]

	-- set the scale of the text on the monitor.
	Monitor.setTextScale(0.75)

	-- draw the static gui
	local tank_height = draw_static_gui(Monitor)

	local oldterm = term.redirect(Monitor)
	--! Now all term.* calls will go to the monitor
	--!   instead

	-- get the width and height of the monitor
	local width, height = term.getSize(
		Graphics_Mode
	)

	-- read the smeltery
	local read_data = read_smeltery()

	-- render the current contents of the smeltery
	local current_fill_level = fill_gui_tank(
		read_data["smeltery_contents"],
		read_data["max_fluids"],
		width,
		height,
		tank_height
	)

	-- print the current details of the smeltery.
	print_smeltery_details(
		width,
		current_fill_level,
		read_data["max_ingots"],
		read_data["max_fluids"],
		read_data["fuel_fill_level"],
		read_data["max_fuel"]
	)

	term.redirect(oldterm)
	--! Now the term.* calls will draw on the
	--!   terminal again
end

main()