--[[
This program will be used to read a Tinkers'
	Construct smeltery, and be able to perform some
	automated tasks relating to the smeltery.

	VSCode max col = 52
]]
local function initialize_globals()
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
	Peripherals = {
		tanks = {}
	}

	if pcall(term.setGraphicsMode, true) then
		term.setGraphicsMode(false)
		INGAME = false
	else
		INGAME = true
	end

	local pulled_periphs = {}
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
			"left",
			"right",
			"top",
			"bottom",
			"front"
		}
	end

	local monitors = {}
	for _, value in ipairs(pulled_periphs) do
		if string.find(value, "tconstruct:") then
			local smeltery_periphs = string.sub(value, 12)
			if (
				string.find(smeltery_periphs, "smeltery")
				or string.find(smeltery_periphs, "basin")
				or string.find(smeltery_periphs, "table")
				or string.find(smeltery_periphs, "duct")
			) then
				local _, name_end = string.find(smeltery_periphs, "_")
				if string.sub(smeltery_periphs, 0, name_end - 1) == "tank" then
					table.insert(Peripherals.tanks, value)
				else
					Peripherals[string.sub(smeltery_periphs, 0, name_end - 1)] = value
				end
			end
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

	if table.getn(monitors) > 1 then
		local monitor_count = table.getn(monitors)
		print(
			"It looks like there are "
			.. table.getn(monitors)
			.. " monitors found.\n"
			.. "From the list of monitors below, "
			.. "which is the one you'd like to display "
			.. "the smeltery information on?"
		)
		for index, monitor in ipairs(monitors) do
			print(index .. ". " .. monitor)
		end

		local answer = read()
		if tonumber(answer) and tonumber(answer) <= monitor_count then
			Monitor = peripheral.wrap(monitors[tonumber(answer)])
		else
			error("Invalid Monitor Selection")
		end
	else
		Monitor = peripheral.wrap(monitors[1])
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
end

local function draw_static_gui(width, height)

	term.setBackgroundColor(colours.black)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)

	local title = "Smeltery Automated Tools"
	term.setCursorPos(
		math.ceil((
			width - string.len(title)
		) / 2),
		1
	)
	term.setBackgroundColor(colors.black)
	print(title)

	local label_ez_empty = "EZ Empty"
	draw_box_from_center(
		math.floor(0.25 * width),
		2/3 * height,
		string.len(label_ez_empty) + 1,
		2,
		colors.lightGray,
		true,
		true
	)

	term.setBackgroundColor(colors.lightGray)
	term.setTextColor(colors.black)
	term.setCursorPos((0.25 * width) - (string.len(label_ez_empty) / 2), 2/3 * height)
	print(label_ez_empty)
end

local function get_smeltery_contents()
	if INGAME then
		return peripheral.wrap(Peripherals.duct).tanks()
	else
		return {
			[3] = {
				amount = 5000,
				name = "tconstruct:molten_iron"
			},
			[4] = {
				amount = 2500,
				name = "tconstruct:molten_debris"
			},
			[2] = {
				amount = 15 * 144,
				name = "tconstruct:molten_ender"
			},
			[1] = {
				amount = 25 * 144,
				name = "tconstruct:molten_netherite"
			}
		}
	end
end

local function easy_empty()
	local smeltery_contents = get_smeltery_contents()

	local drainable = {}

	for _, value in ipairs(smeltery_contents) do
		if value.amount / 144 > 1 then table.insert(drainable, value) end
	end

	if #drainable > 0 then
		print("\nI found " .. #drainable .. " fluids I can drain, draining now...")

		for _, value in ipairs(drainable) do

			local drainable_ingots = math.floor(value.amount / 144)
			local drainable_blocks
			if drainable_ingots > 9 then
				drainable_blocks = math.floor(drainable_ingots / 9)
				drainable_ingots = drainable_ingots % 9
			end

			print(
				"Draining "
				.. drainable_blocks
				.. " blocks and "
				.. drainable_ingots
				.. " ingots of "
				.. Ore_Colors[string.sub(value.name, 19)].name
			)

			if INGAME then
				--do stuff
			else
				
			end
		end
	else
		print("There are no easily drainable liquids in the smeltery")
	end
end

local function main()

	initialize_globals()

	local oldterm = term.redirect(Monitor)
	--! Now all term.* calls will go to the monitor
	--!   instead

	Monitor.setTextScale(0.75)

	-- get the width and height of the monitor
	local width, height = term.getSize(
		Graphics_Mode
	)

	draw_static_gui(width, height)

	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- Button Corners:

	-- EZ Empty:
	-- 	top left: 7, 11
	-- 	top right: 16, 11
	-- 	bottom left: 7, 13
	--  bottom right: 16 13
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	while true do
		term.setCursorPos(1, 3)
		local xPos, yPos
		if INGAME then
			_, _, xPos, yPos = os.pullEvent("monitor_touch")
		else
			_, _, xPos, yPos = os.pullEvent("mouse_click")
		end

		-- if we clicked the EZ Empty button.
		if xPos >= 7 and xPos <= 16 and yPos >= 11 and yPos <= 13 then
			term.setBackgroundColor(colours.black)
			term.setTextColor(colors.white)

			local confirmation = "Beginning intelligently emptying the smeltery..."
			term.setCursorPos(
				(math.ceil(
					width - string.len(confirmation)
				) / 2) + 1,
				3
			)
			print(confirmation)

			easy_empty()
		end
	end


	term.redirect(oldterm)
	--! Now the term.* calls will draw on the
	--!   terminal again
end

main()