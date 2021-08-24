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
	clay = {
		bar_color = colors.brown,
		text_color = colors.white,
		name = "Clay",
		bar_name = "balls"
	},
	glass = {
		bar_color = colors.lightBlue,
		text_color = colors.black,
		name = "Glass",
		bar_name = "blocks"
	},
	obsidian = {
		bar_color = colors.gray,
		text_color = colors.white,
		name = "blocks",
		bar_name = ""
	},
	ender = {
		bar_color = colors.green,
		text_color = colors.white,
		name = "Ender",
		bar_name = "pearls"
	},
	emerald = {
		bar_color = colors.lime,
		text_color = colors.black,
		name = "Emerald",
		bar_name = "gems"
	},
	quartz = {
		bar_color = colors.lightGray,
		text_color = colors.black,
		name = "Quartz",
		bar_name = "shards"
	},
	diamond = {
		bar_color = colors.cyan,
		text_color = colors.white,
		name = "Diamond",
		bar_name = "gems"
	},
	debris = {
		bar_color = colors.brown,
		text_color = colors.white,
		name = "Ancient Debris",
		bar_name = "shards"
	},
	iron = {
		bar_color = colors.red,
		text_color = colors.black,
		name = "Iron",
		bar_name = "bars"
	},
	gold = {
		bar_color = colors.yellow,
		text_color = colors.black,
		name = "Butter",
		bar_name = "bars"
	},
	copper = {
		bar_color = colors.orange,
		text_color = colors.black,
		name = "Copper",
		bar_name = "bars"
	},
	cobalt = {
		bar_color = colors.blue,
		text_color = colors.white,
		name = "Cobalt",
		bar_name = "bars"
	},
	slime_steel = {
		bar_color = colors.lightBlue,
		text_color = colors.black,
		name = "Slime Steel",
		bar_name = "bars"
	},
	tinkers_bronze = {
		bar_color = colors.orange,
		text_color = colors.black,
		name = "Tinker's Bronze",
		bar_name = "bars"
	},
	rose_gold = {
		bar_color = colors.pink,
		text_color = colors.black,
		name = "Rose Gold",
		bar_name = "bars"
	},
	pig_iron = {
		bar_color = colors.magenta,
		text_color = colors.black,
		name = "Pig Iron",
		bar_name = "bars"
	},
	manyullyn = {
		bar_color = colors.purple,
		text_color = colors.white,
		name = "Manyullyn",
		bar_name = "bars"
	},
	hepatizon = {
		bar_color = colors.purple,
		text_color = colors.white,
		name = "Hepatitis",
		bar_name = "bars"
	},
	queens_slime = {
		bar_color = colors.green,
		text_color = colors.white,
		name = "Queen's Slime",
		bar_name = "bars"
	},
	netherite = {
		bar_color = colors.gray,
		text_color = colors.white,
		name = "Netherite",
		bar_name = "bars"
	},
	tin = {
		bar_color = colors.lightGray,
		text_color = colors.black,
		name = "Tin",
		bar_name = "bars"
	},
	aluminum = {
		bar_color = colors.lightGray,
		text_color = colors.black,
		name = "Aluminum",
		bar_name = "bars"
	},
	lead = {
		bar_color = colors.gray,
		text_color = colors.white,
		name = "Lead",
		bar_name = "bars"
	},
	silver = {
		bar_color = colors.lightGray,
		text_color = colors.black,
		name = "Silver",
		bar_name = "bars"
	},
	nickel = {
		bar_color = colors.yellow,
		text_color = colors.black,
		name = "Nickel",
		bar_name = "bars"
	},
	zinc = {
		bar_color = colors.lightGray,
		text_color = colors.black,
		name = "Zinc",
		bar_name = "bars"
	},
	osmium = {
		bar_color = colors.lightBlue,
		text_color = colors.black,
		name = "Osmium",
		bar_name = "bars"
	},
	uranium = {
		bar_color = colors.green,
		text_color = colors.white,
		name = "Uranium",
		bar_name = "bars"
	},
	bronze = {
		bar_color = colors.orange,
		text_color = colors.black,
		name = "Bronze",
		bar_name = "bars"
	},
	brass = {
		bar_color = colors.yellow,
		text_color = colors.black,
		name = "Brass",
		bar_name = "bars"
	},
	electrum = {
		bar_color = colors.yellow,
		text_color = colors.black,
		name = "Electrum",
		bar_name = "bars"
	},
	invar = {
		bar_color = colors.lightGray,
		text_color = colors.black,
		name = "Invar",
		bar_name = "bars"
	},
	constantan = {
		bar_color = colors.orange,
		text_color = colors.black,
		name = "Constantan",
		bar_name = "bars"
	},
	pewter = {
		bar_color = colors.yellow,
		text_color = colors.black,
		name = "Pewter",
		bar_name = "bars"
	},
	steel = {
		bar_color = colors.gray,
		text_color = colors.white,
		name = "Steel",
		bar_name = "bars"
	}
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
	paintutils.drawPixel(
		width,
		math.ceil(height - (0.25 * tank_height) - 1),
		colors.green
	)
	paintutils.drawPixel(
		math.floor(width / 2),
		math.ceil(height - (0.25 * tank_height) - 1),
		colors.green
	)

	--1/2
	paintutils.drawPixel(
		width,
		math.ceil(height - (0.5 * tank_height) - 1),
		colors.orange
	)
	paintutils.drawPixel(
		math.floor(width / 2),
		math.ceil(height - (0.5 * tank_height) - 1),
		colors.orange
	)

	--3/4
	paintutils.drawPixel(
		width,
		math.ceil(height - (0.75 * tank_height) - 1),
		colors.red
	)
	paintutils.drawPixel(
		math.floor(width / 2),
		math.ceil(height - (0.75 * tank_height) - 1),
		colors.red
	)
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
		local max_string_lenght = math.ceil(width / 2)

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
		for _, value in ipairs(smeltery_contents) do

			--[[
			extract the ore name for use in
				determining the color we render the
				bar in, as well as getting the
				amount of the current metal there
				is.
			]]
			local ore = string.sub(value.name, 19)
			local metal_amount = value.amount
			local percentage_taken_up =
				metal_amount / max_fluids

			if percentage_taken_up > 1 / tank_height then
				percentage_taken_up = percentage_taken_up + ((1 / tank_height) / 2)
				percentage_taken_up = percentage_taken_up - (percentage_taken_up % (1 / tank_height))
			end

			-- add to the total liquid count.
			total_liquids =
				total_liquids + value.amount

			-- draw an appropriately sized box with
			--  respect to the size of the tank.
			paintutils.drawFilledBox(
				width - 1,
				next_y,
				(width / 2) + 1,
				next_y - (percentage_taken_up * tank_height) + 1,
				Ore_Colors[ore].bar_color or colors.lightGray
			)

			-- display the name of the ore overtop the bar
			local detailed_string =
				(Ore_Colors[ore].name or "Unknown")
				.. ", " .. string.format("%.2f", metal_amount / 144)
				.. " " .. (Ore_Colors[ore].bar_name or "units")

			if string.len(detailed_string) < max_string_lenght then
				term.setCursorPos(
					math.ceil(width / 2)
					+ ((math.ceil(width / 2)
					- string.len(detailed_string)) / 2),
					next_y
				)
				term.setTextColor(Ore_Colors[ore].text_color or colors.black)
				print(detailed_string)
			else
				term.setCursorPos(
					math.ceil(width / 2)
					+ ((math.ceil(width / 2)
					- string.len(Ore_Colors[ore].name or "Unknown")) / 2),
					next_y
				)
				term.setTextColor(Ore_Colors[ore].text_color or colors.black)
				print(Ore_Colors[ore].name or "Unknown")
			end


			-- incriment the next y value to be
			--  above the previous one.
			if percentage_taken_up == 0 then
				next_y = (next_y - (1 / tank_height) * tank_height)
			else
				next_y = (next_y - (percentage_taken_up * tank_height))
			end
			sleep(1)
		end

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

	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[
	This is where the test data will be stored for
		my own debugging when I'm not able to be in
		Minecraft to test the program ingame.

	The goal of this data will be that I can
		quickly just comment or uncomment it and
		it'll start reading live minecraft data.
	]]
	smeltery = {}
	duct = {}
	lava_tank = {}
	smeltery.size = function()
		return 18
	end

	duct.tanks = function()
		return {
			[1] = {
				amount = 5000,
				name = "tconstruct:molten_iron"
			},
			[2] = {
				amount = 2500,
				name = "tconstruct:molten_debris"
			},
			[3] = {
				amount = 15 * 144,
				name = "tconstruct:molten_ender"
			},
			[4] = {
				amount = 25 * 144,
				name = "tconstruct:molter_netherite"
			}
		}
	end

	lava_tank.tanks = function()
		return {
			{
				amount = 4000,
				name = "minecraft:lava"
			}
		}
	end
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
	local max_string_lenght = width / 2

	-- print the current fill percentage with 3
	-- 	significant digits.
	print("Smeltery Details:\n")
	print(
		"Fill Amount: " .. string.format(
			"%.3f%%", current_fill_level * 100
		) .. "\n"
	)

	-- construct the string that represents the total
	-- 	ingot capacity.
	local ingot_capacity_string =
		"Ingot Capacity: "
		.. string.format("%.2f", ingot_capacity - (current_fill_level * ingot_capacity))
		.. " free of "
		.. ingot_capacity
		.. " Total ingots."

	-- check it's length and if it's too long, print it
	-- 	on two lines.
	if (
		string.len(ingot_capacity_string)
		< max_string_lenght
	) then
		print(ingot_capacity_string)
	elseif (
		string.len(
			"\t"
			.. string.format("%.2f", ingot_capacity - (current_fill_level * ingot_capacity))
			.. " free of "
			.. ingot_capacity
			.. " Total ingots.\n"
		) < max_string_lenght
	) then
		print(
			"Ingot Capacity: \n\t"
			.. string.format("%.2f", ingot_capacity - (current_fill_level * ingot_capacity))
			.. " free of "
			.. ingot_capacity
			.. " Total ingots.\n"
		)
	else
		print(
			"Ingot Capacity: \n\t"
			.. string.format("%.2f", ingot_capacity - (current_fill_level * ingot_capacity))
			.. " free of "
			.. ingot_capacity
			.. " max.\n"
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
	Monitor.setTextScale(1)

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