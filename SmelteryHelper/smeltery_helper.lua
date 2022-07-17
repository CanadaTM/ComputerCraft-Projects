--[[
This program will be used to read a Tinkers'
	Construct smeltery, and be able to perform some
	automated tasks relating to the smeltery.

	VSCode max col = 52
]]

local function initialize_globals()
	--[[
	This function will construct all the global
		variables that the program will need like
		the list of all attached peripherals that
		are important to the program, and a list of
		all ores, their names, and colors.
	]]

	-- some basic global variables, including the
	-- 	massive ore table.
	Graphics_Mode = false
	Offset = 1
	Ingot_Size = 90
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
		},
		fairy = {
			bar_color = colors.orange,
			text_color = colors.black,
			name = "Fairy",
			bar_name = "bars"
		},
		shadow_steel = {
			bar_color = colors.gray,
			text_color = colors.white,
			name = "Shadow Steel",
			bar_name = "bars"
		},
		arcane_gold = {
			bar_color = colors.orange,
			text_color = colors.white,
			name = "Arcane Gold",
			bar_name = "bars"
		},
		neptunium = {
			bar_color = colors.cyan,
			text_color = colors.white,
			name = "Neptunium",
			bar_name = "bars"
		},
		starmetal = {
			bar_color = colors.blue,
			text_color = colors.white,
			name = "Starmetal",
			bar_name = "bars"
		},
		pink_slime = {
			bar_color = colors.pink,
			text_color = colors.black,
			name = "Pink Slime Alloy",
			bar_name = "bars"
		},
		cloggrum = {
			bar_color = colors.brown,
			text_color = colors.white,
			name = "Cloggrum",
			bar_name = "bars"
		},
		froststeel = {
			bar_color = colors.blue,
			text_color = colors.white,
			name = "Froststeel",
			bar_name = "bars"
		},
		utherium = {
			bar_color = colors.orange,
			text_color = colors.white,
			name = "Utherium",
			bar_name = "bars"
		},
		forgotten_metal = {
			bar_color = colors.lightGray,
			text_color = colors.black,
			name = "Forgotten Metal",
			bar_name = "bars"
		},
		regalium = {
			bar_color = colors.yellow,
			text_color = colors.black,
			name = "Regalium",
			bar_name = "bars"
		},
		refined_obsidian = {
			bar_color = colors.purple,
			text_color = colors.white,
			name = "Refined Obsidian",
			bar_name = "bars"
		},
		refined_glowstone = {
			bar_color = colors.yellow,
			text_color = colors.black,
			name = "Refined Glowstone",
			bar_name = "bars"
		},
		iesnium = {
			bar_color = colors.lightBlue,
			text_color = colors.white,
			name = "Iesnium",
			bar_name = "bars"
		}
	}

	--[[
	partially pre-construct the main table that
		will hold all the needed smeltery
		peripheral strings.
	]]
	Peripherals = {
		tanks = {},
		storages = {}
	}

	--[[
	check to see if we're ingame or in a CraftOS-PC
		by calling a function exclusive to CraftOS
		and seeing if it errors.
	]]
	if pcall(term.setGraphicsMode, true) then
		term.setGraphicsMode(false)
		INGAME = false
	else
		INGAME = true
	end

	--[[
	Grab a list of strings containing the string
		names of all peripherals attached to the
		computer, if we're not ingame, return some
		fake data.
	]]
	local pulled_periphs = {}
	local monitors = {}
	if INGAME then
		pulled_periphs = peripheral.getNames()
	else
		pulled_periphs = {
			"back",
			"tconstruct:smeltery_4",
			"tconstruct:tank_1",
			"tconstruct:basin_1",
			"tconstruct:table_3",
			"tconstruct:duct_0",
			"tconstruct:drain_1",
			"left",
			"right",
			"top",
			"bottom",
			"front"
		}
	end

	-- loop through all the pulled peripherals
	for _, value in ipairs(pulled_periphs) do

		--[[
		If there's a colon in the string, that
			means it's not a computercraft
			peripheral so we do some intelligent
			searching.
		]]
		if string.find(value, ":") then

			--[[
			Find where the peripheral starts after
				the colon and assign the string
				after it to a variable.
			]]
			local _, semicolon = string.find(
				value, ":"
			)
			local periph_after_mod = string.sub(
				value, semicolon + 1
			)

			-- Look for specific smeltery components
			if (
				string.find(
					periph_after_mod, "smeltery"
				)
					or string.find(
						periph_after_mod, "foundry"
					)
					or string.find(
						periph_after_mod, "basin"
					)
					or string.find(
						periph_after_mod, "table"
					)
					or string.find(
						periph_after_mod, "drain"
					)
					or string.find(
						periph_after_mod, "duct"
					)
				) then

				--[[
				Find the end of the name of the
					actual name of the peripheral
					minus the number at the end.
				]]
				local _, name_end = string.find(
					periph_after_mod, "_"
				)

				--[[
				If the peripheral we're looking at
					is a tank, add it to the tank
					table in the master peripheral
					table.
				]]
				if (
					string.find(
						periph_after_mod, "tank"
					)
					) then
					table.insert(Peripherals.tanks, value)

					--[[
				If it's anything other than a tank,
					we just add it to the master
					Peripheral table at the index
					of the peripheral's name.
				]]
				else
					Peripherals[
						string.sub(
							periph_after_mod,
							0,
							name_end - 1
						)
						] = value
				end

				--[[
			if the peripheral is an inventory, we just
				put it straight into the `storages`
				table in the Peripherals master table.
			]]
			elseif (
				string.find(value, "chest")
					or string.find(value, "barrel")
				) then
				table.insert(Peripherals["storages"], value)
			end

			--[[
		Now we do some thorough checking to see if
			the current peripheral in the loop is
			a monitor or the name of a side that
			has a monitor type. and add it to the
			monitors list.
		]]
		elseif (
			string.find(value, "monitor")
				or string.find(value, "left")
				and peripheral.getType("left") == "monitor"
				or string.find(value, "right")
				and peripheral.getType("right") == "monitor"
				or string.find(value, "up")
				and peripheral.getType("up") == "monitor"
				or string.find(value, "down")
				and peripheral.getType("down") == "monitor"
				or string.find(value, "back")
				and peripheral.getType("back") == "monitor"
				or string.find(value, "front")
				and peripheral.getType("front") == "monitor"
			) then
			table.insert(monitors, value)
		end
	end

	-- If there's more than 1 monitor,
	if #monitors > 1 then

		--[[
		print out a warning to the user that there
			are more than 1 monitors attached to the
			computer, ask which they'd like to use
			to display this program's information,
			and list the names of all attached
			monitors.
		]]
		print(
			"It looks like there are "
			.. #monitors
			.. " monitors found.\n"
			.. "From the list of monitors below, "
			.. "which is the one you'd like to "
			.. "display the smeltery information on"
			.. "?"
		)
		for index, monitor in ipairs(monitors) do
			print(index .. ". " .. monitor)
		end

		--[[
		Read for user input and if it's a number,
			and it's less than or equal to the total
			number of monitors, set the global
			Monitor variable to be the selected
			monitor.
		If it's not within those parameters, we'll
			throw an error.
		]]
		local answer = read()
		if (
			tonumber(answer)
				and tonumber(answer) <= #monitors
			) then
			Monitor = peripheral.wrap(monitors[
				tonumber(answer)
				])
		else
			error("Invalid Monitor Selection")
		end

		--[[
	If there's only 1 monitor, we just set the global
		Monitor variable to that one monitor.
	]]
	else
		Monitor = peripheral.wrap(monitors[1])
	end

	-- clear the terminal.
	term.clear()
end

local function check_needed_peripherals()
	if not Peripherals.smeltery or not Peripherals.foundry then
		print(
			"!!WARNING!! I cannot detect a smeltery or"
			.. " a foundry, it's likely because the"
			.. " other does exist, but this is just a"
			.. " warning.")
	end

	if (
		not Peripherals.basin
			or not Peripherals.drain
			or not Peripherals.duct
			or not Peripherals.table
			or not Peripherals.storages
		) then
		error(
			"I am missing a key peripheral!"
			.. "\n\tHere's a list of the peripherals"
			.. " I need and what I already see:"
			.. "\n\t\t Casting Basin:"
			.. Peripherals.basin
			.. "\n\t\t Casting Table:"
			.. Peripherals.table
			.. "\n\t\t Foundry/Smeltery Drain"
			.. Peripherals.drain
			.. "\n\t\t Foundry/Smeltery Duct"
			.. Peripherals.duct
			.. "\n\t\t Inventories"
			.. texutils.serialize(Peripherals.storages)
		)
	end
end

local function draw_box_from_center(
    center_x,
    center_y,
    width,
    height,
    color,
    filled,
    fancy
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
	fancy = fancy or false

	--[[
	Calculate two corners of the rectangle as that's
		what paintutils wants
	]]
	local top_left_x = math.floor(center_x - (width / 2))
	local top_left_y = math.floor(center_y - (height / 2))
	local bottom_right_x = math.floor(center_x + (width / 2))
	local bottom_right_y = math.floor(center_y + (height / 2))

	--[[
	Check if we want the box filled. For either, we
		calculate the top left and bottom right points.
	]]
	if filled then
		paintutils.drawFilledBox(
			top_left_x,
			top_left_y,
			bottom_right_x,
			bottom_right_y,
			color
		)
	else
		paintutils.drawBox(
			top_left_x,
			top_left_y,
			bottom_right_x,
			bottom_right_y,
			color
		)
	end

	--[[
	Check if we want the box to be fancy. If we do,
		we draw some grayscale highlights around
		the edges.

	FIXME: This does not look good for colored
		buttons but I can't currently figure out
		how I'd do it for color with such a
		limited palette.
	]]
	if fancy then
		-- corner highlight
		paintutils.drawPixel(
			top_left_x,
			top_left_y,
			colors.white
		)

		-- corner shadow
		paintutils.drawPixel(
			bottom_right_x,
			bottom_right_y,
			colors.black
		)

		-- left vertical line
		paintutils.drawLine(
			top_left_x,
			top_left_y + 1,
			top_left_x,
			bottom_right_y,
			colors.lightGray
		)

		-- right vertical line
		paintutils.drawLine(
			bottom_right_x,
			top_left_y + 1,
			bottom_right_x,
			bottom_right_y - 1,
			colors.gray
		)

		-- top horizontal line
		paintutils.drawLine(
			top_left_x + 1,
			top_left_y,
			bottom_right_x,
			top_left_y,
			colors.lightGray
		)

		-- bottom horizontal line
		paintutils.drawLine(
			top_left_x + 1,
			bottom_right_y,
			bottom_right_x - 1,
			bottom_right_y,
			colors.gray
		)
	end

	-- Return some key coordinates for use elsewhere.
	return {
		top_left = {
			x = top_left_x,
			y = top_left_y
		},
		bottom_right = {
			x = bottom_right_x,
			y = bottom_right_y
		}
	}
end

local function draw_static_gui(width, height)
	--[[
	This function handles drawing the title of the
		program at the top of the monitor as well
		as all the buttons that actually do stuff.
	]]

	--[[
	Start by setting up a table that will be used to
		hold all the locations of the buttons for
		reference when we see if a user touched the
		button.
	]]
	local button_locations = {}

	-- completely clear and reset the terminal.
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorPos(1, 1)

	-- Print the title in the center of the monitor.
	local title = "Smeltery Automated Tools"
	term.setCursorPos(
		math.ceil((
			width - string.len(title)
			) / 2),
		1
	)
	term.setBackgroundColor(colors.black)
	print(title)

	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[
	This is the section where we draw the "EZ Empty"
		button.
	]]
	local label_ez_empty = "EZ Empty"
	local locations = draw_box_from_center(
		math.floor(0.25 * width),
		2 / 3 * height,
		string.len(label_ez_empty) + 1,
		2,
		colors.lightGray,
		true,
		true
	)
	button_locations[label_ez_empty] = {
		top_left = {
			x = locations.top_left.x,
			y = locations.top_left.y
		},
		bottom_right = {
			x = locations.bottom_right.x,
			y = locations.bottom_right.y
		}
	}

	term.setBackgroundColor(colors.lightGray)
	term.setTextColor(colors.black)
	term.setCursorPos(
		(0.25 * width)
		- (string.len(label_ez_empty) / 2),
		2 / 3 * height
	)
	print(label_ez_empty)
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


	return button_locations
end

local function get_smeltery_contents()
	--[[
	This function handles reading the smeltery's
		current liquid contents and returns it as
		a table.
	]]
	if INGAME then
		return (
			peripheral.wrap(Peripherals.duct).tanks()
			)
	else
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
				name = "tconstruct:molten_netherite"
			},
			[5] = {
				amount = 20 * 144,
				name = "fakemod:molten_unobtanium"
			}
		}
	end
end

local function easy_empty()
	--[[
	This function is what is run when the user
		presses the "EZ Empty" button.

	It reads the smeltery contents and determines
		what in the smeltery is easily drainable
		into blocks and ingots and then drains
		that out.
	]]

	-- get the current contents of the smeltery
	local smeltery_contents = get_smeltery_contents()

	-- set up a list that will hold all the drainable
	-- 	liquids
	local drainable = {}

	--[[
	Loop through all the liquids currently in the
		smeltery, if after deviding them by 144,
		?(that's the amount of liquid for 1 ingot)
		if it's greater than 1, ew add it to the
		drainable list.
	]]
	for _, value in ipairs(smeltery_contents) do
		if value.amount / Ingot_Size >= 1 then
			table.insert(drainable, value)
		end
	end

	--[[
	Check to see if there were any storages attached
		to the computer and if there is, use the
		first inventory in the list, otherwise, error
		out and inform the user.
	]]
	local storage
	if #Peripherals.storages > 0 then
		storage = Peripherals.storages[1]
		print(
			"I am using "
			.. storage
			.. " for output items."
		)
	else
		error("No inventory found!")
	end

	-- if there are drainable liquids,
	if #drainable > 0 then

		-- print how many liquids are drainable.
		print(
			"\nI found "
			.. #drainable
			.. " fluids I can drain, "
			.. "draining now..."
		)

		-- loop through all the drainable liquids
		for _, value in ipairs(drainable) do

			-- calculate how many blocks and ingots
			-- 	we need to drain
			local drainable_ingots = math.floor(
				value.amount / Ingot_Size
			)
			local drainable_blocks = 0
			if drainable_ingots >= 9 then
				drainable_blocks = math.floor(
					drainable_ingots / 9
				)
				drainable_ingots = (
					drainable_ingots % 9
					)
			end

			-- find the start of the name of the ore
			local _, name_start = string.find(
				value.name, "molten_"
			)

			--[[
			Try to grab the ore name using the ore
				name end we calculated and use it
				to pull a value out of the Ore_Colors
				global table.
			If the index returns nil, we set ore to
				be a default values, if the index
				returns something other than nil,
				set the ore variable to be the
				value we returned from the index.
			]]
			local ore
			if (
				pcall(function()
					if (
						Ore_Colors[
							string.sub(
								value.name,
								name_start + 1
							)
							]
						) then return true
					else error() end
				end
				)
				) then
				ore = Ore_Colors[
					string.sub(
						value.name, name_start + 1
					)
					]
			else
				ore = {
					bar_color = colors.lightGray,
					text_color = colors.black,
					name = "Unknown",
					bar_name = "bars"
				}
			end

			-- inform the user what and how much
			-- 	we're draining.
			print(
				"Draining "
				.. drainable_blocks
				.. " blocks and "
				.. drainable_ingots
				.. " " .. ore.bar_name .. " of "
				.. ore.name
			)

			-- if we're ingame
			if INGAME then

				-- setup the necessary peripherals.
				local drain = peripheral.wrap(
					Peripherals.drain
				)
				local casting_basin = (
					peripheral.wrap(
						Peripherals.basin
					)
					)
				local casting_table = (
					peripheral.wrap(
						Peripherals.table
					)
					)

				-- loop through the drainable blocks.
				for i = 1, drainable_blocks do

					-- push a blocks worth of fluid
					-- 	to the basin.
					drain.pushFluid(
						Peripherals.basin,
						9 * 144,
						value.name
					)

					-- try to pull the block item
					-- 	out of the basin, looping
					-- 	until it succeeds.
					while casting_basin.pushItems(
						storage, 2
					) == 0 do
					end
				end

				-- loop through the drainable ingots
				--[[
				FIXME: this will not see if the cast
					in the table will actually cast
					an ingot or gem or whatever else.
				]]
				for i = 1, drainable_ingots do

					-- push an ingots worth of fluid
					-- 	to the table.
					drain.pushFluid(
						Peripherals.table,
						9 * 144,
						value.name
					)

					-- try to pull the ingot item
					-- 	out of the table, looping
					-- 	until it succeeds.
					while casting_table.pushItems(
						storage, 2
					) == 0 do
					end
				end

				-- if we're not ingame
			else
				--[[
				TODO: This is supposed to be where
					I simulate draining the smeltery
					of it's drainable amounts of
					fluids. but currently I can't
					figure out how I want to do it.
				]]
				for i = 1, drainable_blocks do
					for j = 1, #smeltery_contents do
						if (
							value.name
								== smeltery_contents[j].name
							) then
							smeltery_contents[j].amount = (
								smeltery_contents[j].amount
									- (9 * 144)
								)
							break
						end
						sleep(2)
					end
				end

				for i = 1, drainable_ingots do
					for j = 1, #smeltery_contents do
						if (
							value.name
								== smeltery_contents[j].name
							) then
							smeltery_contents[j].amount = (
								smeltery_contents[j].amount
									- 144
								)
							break
						end
						sleep(2)
					end
				end
			end
		end
	else
		print(
			"There are no easily drainable "
			.. "liquids in the smeltery"
		)
		sleep(2)
		term.clear()
		return
	end
	print("Done draining!")
	sleep(2)
	term.clear()
end

local function main()

	initialize_globals()
	check_needed_peripherals()

	local oldterm = term.redirect(Monitor)
	--! Now all term.* calls will go to the monitor
	--!   instead

	Monitor.setTextScale(0.75)

	-- get the width and height of the monitor
	local width, height = term.getSize(
		Graphics_Mode
	)

	-- draw the GUI and record the button locations.
	local button_locations = draw_static_gui(
		width, height
	)

	-- set the background color and text color to
	-- 	their default values.
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)

	--[[
	TODO: possible feature to take in a chest of
		items and intelligently melt them down so
		as to not create alloys, or if the
		peripheral is found to be a foundry, just
		melt everything down to liquid form
	]]

	-- program main loop
	while true do

		-- move the cursor to be under the title
		term.setCursorPos(1, 3)

		-- setup a variable for a touch location
		local xPos, yPos

		-- pull a touch or click event from the
		-- 	monitor.
		if INGAME then
			_, _, xPos, yPos = os.pullEvent(
				"monitor_touch"
			)
		else
			_, _, xPos, yPos = os.pullEvent(
				"mouse_click"
			)
		end

		-- if we clicked the EZ Empty button.
		if (
			xPos >= button_locations[
				"EZ Empty"
				].top_left.x
				and xPos <= button_locations[
				"EZ Empty"
				].bottom_right.x
				and yPos >= button_locations[
				"EZ Empty"
				].top_left.y
				and yPos <= button_locations[
				"EZ Empty"
				].bottom_right.y
			) then

			-- ensure the text is in it's default
			-- 	state
			term.setBackgroundColor(colors.black)
			term.setTextColor(colors.white)

			-- place the startup notification text
			-- 	centrally on the screen.
			local confirmation = (
				"Beginning intelligently emptying "
					.. "the smeltery..."
				)
			term.setCursorPos(
				(math.ceil(
					width - string.len(confirmation)
				) / 2) + 1,
				3
			)
			print(confirmation)

			-- drain the smeltery and re-draw the
			-- 	gui
			easy_empty()
			draw_static_gui(width, height)
		end
	end


	term.redirect(oldterm)
	--! Now the term.* calls will draw on the
	--!   terminal again
end

main()
