-- This function will define some global variables to
--  be used later and allow for quick changing of
--  things that may change at a later date.
local function defineGlobals()
    -- The pastebin code for the `Git` API
    GitAPI = "X81AVB9t"

    -- The info required to locate my Github repository
    GitInfo = {
        repoPref = "CanadaTM",
        repoName = "ComputerCraft-Projects",
        repoBranch = "main"
    }

    if fs.exists("config.txt") then
        local file = io.open("config.txt", "r")
        -- this is the program we want to automatically
        --  run if we set that the last time the
        --  startup was run.
        ChosenProgram = file:read("a")
        file:close()
    else
        ChosenProgram = nil
    end
end

-- This will pull the files from my Github repository
--  using the `Git` API developed by Thorsten Schmitt.
local function grab_updated_repo()
    -- Try to load the api
    Git = assert(loadfile("git.lua")())

    -- Show debug information
    Git:showOutput(true)

    -- pull the repo from github
    Git:setProvider("github")

    -- Set the repository information
    Git:setRepository(
        GitInfo.repoPref,
        GitInfo.repoName,
        GitInfo.repoBranch
    )

    -- clone the repo to a fresh directory
    if fs.exists("repo/") then
        fs.delete("repo/")
    end
    Git:cloneTo("repo/")
end

-- The main function of the program
local function main()
    -- Define the global variables
    defineGlobals()

    -- Pull the `Git` API if it's not already there,
    if not fs.exists("git.lua") then
        shell.run(
            "pastebin get " .. GitAPI .. " git.lua"
        )
    end

    -- If the repo already exists on the computer,
    --  see if the user wants to update the repo.
    --  If the repo isn't there, just pull it.
    local pulled = false
    if fs.exists("repo/") then
        print(
            "Do you want to update the repository? "
            .. "[y/N]\n"
        )
        local choice = read()
        if (
            choice:lower() == "y"
            or choice:lower() == "yes"
        ) then
            grab_updated_repo()
            pulled = true
        end
    else
        grab_updated_repo()
        pulled = true
    end

    -- Get a list of programs I've made in my repo
    --  and add their directory to this `programs`
    --  table.
    local programs = {}
    for _, value in ipairs(fs.list("repo/")) do
        if fs.isDir("repo/" .. value) then
            table.insert(
                programs, "repo/" .. value .. "/"
            )
        end
    end

    -- clear the terminal and ask the user which
    --  program in my repo they would like to use.
    term.clear()
    term.setCursorPos(1, 1)
    if pulled then
        print("Repo pulled successfully!\n")
    end

    -- Skip over asking if we already have saved a
    --  program location
    local chosen_program = ""
    if not ChosenProgram then
        print(
            "Which program would you like to run on "
            .. "this computer?\n"
        )
        for index, value in ipairs(programs) do
            print(index .. ". " .. value)
        end
        local choice = tonumber(read())

        -- run the program that the user selected in
        --  the background.
        if not choice or choice > #programs then
            error("Invalid Selection")
        end

        -- Run the selected program
        shell.run(
            "bg ".. programs[choice] .. "startup.lua"
        )
        chosen_program = programs[choice]
    else
        --run the saved program
        shell.run("bg ".. ChosenProgram)
    end

    -- See if the user would like to save this choice
    --  for faster future startups
    term.clear()
    term.setCursorPos(1, 1)
    if not ChosenProgram then
        print(
            "Would you like to save this decision for "
            .. "future startups? [y/N]\n"
        )
        local save_choice = read()
        if (
            save_choice:lower() == "y"
            or save_choice:lower() == "yes"
        ) then
            local file = io.open("config.txt", "w")
            file:write(chosen_program .. "startup.lua")
            file:close()
        end
    else
        print(
            "Would you like change the saved decision on "
            .. "next startup? [y/N]\n"
        )
        local save_choice = read()
        if (
            save_choice:lower() == "y"
            or save_choice:lower() == "yes"
        ) then
            fs.delete("config.txt")
        end
    end

    -- Clear the terminal
    term.clear()
    term.setCursorPos(1, 1)
end

main()