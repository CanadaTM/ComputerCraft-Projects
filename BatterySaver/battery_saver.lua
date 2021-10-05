local function defineGlobals()
    BlockBreaker = ""
    BlockPlacer = ""
    PlayerDetector = ""
    RedstoneIntegrator = ""

    local periphs = peripheral.getNames()

    for _, value in ipairs(periphs) do
        local periph_type = peripheral.getType(value)

        if periph_type == "industrialforegoing:block_breaker" then
            BlockBreaker = value
        elseif periph_type == "industrialforegoing:block_placer" then
            BlockPlacer = value
        elseif periph_type == "playerDetector" then
            PlayerDetector = value
        elseif periph_type == "redstoneIntegrator" then
            RedstoneIntegrator = value
        end
    end
end

local function has_value (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function main()
    defineGlobals()

    -- local breaker = peripheral.wrap(BlockBreaker)
    -- local placer = peripheral.wrap(BlockPlacer)
    local detector = peripheral.wrap(PlayerDetector)
    local integrator = peripheral.wrap(RedstoneIntegrator)

    while has_value(detector.getOnlinePlayers(), "Canada_TM") or has_value(detector.getOnlinePlayers(), "HarveyTheKat") do
        integrator.setOutput("left", false)
        integrator.setOutput("right", true)
    end

    integrator.setOutput("left", true)
    integrator.setOutput("right", false)
end

main()