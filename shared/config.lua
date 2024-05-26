Config = {}

Config.Debug = {
    messages = true
}

Config.Permissions = { 
    stretchermenu = false, 
    stretcher = false, 
    delstretcher = false, 
    mdstretcher = false, 
}

Config.Keys = {
    menu = 74, -- [H] 74 
    doors = 38, -- [E] 38 (This key must be held down)
    take = 73, -- [X] 73
    load = 183, -- [G] 183
}

Config.Stretcher = {
    modelHash = "strykerpro",
}
                    
Config.Vehicles = { 

    -- BASE VEHICLES

        -- TRUCK
        {modelHash = "ambulance", dist = 8.0, xOffset = 0.0, yOffset = -2.6, zOffset = -0.165, rotOffset = 0.0, doors = {"BLD", "BRD"}, powerload = false},
        {modelHash = "brigham", dist = 5.5, xOffset = 0.34, yOffset = -1.9, zOffset = 0.0, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},

        -- BOAT
        {modelHash = "dinghy2", dist = 8.0, xOffset = 0.0, yOffset = -1.7, zOffset = 0.23, rotOffset = -135.0, doors = {}, powerload = false},
        {modelHash = "predator", dist = 8.0, xOffset = 0.35, yOffset = -2.4, zOffset = -0.3, rotOffset = 0.0, doors = {}, powerload = false},

        -- AIRCRAFT
        {modelHash = "annihilator", dist = 8.0, xOffset = 0.0, yOffset = 0.35, zOffset = -0.1, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "annihilator2", dist = 8.0, xOffset = 0.0, yOffset = -0.15, zOffset = -0.1, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "buzzard", dist = 8.0, xOffset = 0.0, yOffset = 0.085, zOffset = 0.0, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "buzzard2", dist = 8.0, xOffset = 0.0, yOffset = 0.085, zOffset = 0.0, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "cargobob", dist = 8.0, xOffset = 0.65, yOffset = 0.085, zOffset = -0.8, rotOffset = 0.0, doors = {"BLD"}, powerload = false},
        {modelHash = "cargobob2", dist = 8.0, xOffset = 0.65, yOffset = 0.085, zOffset = -0.8, rotOffset = 0.0, doors = {"BLD"}, powerload = false},
        {modelHash = "cargobob3", dist = 8.0, xOffset = 0.65, yOffset = 0.085, zOffset = -0.8, rotOffset = 0.0, doors = {"BLD"}, powerload = false},
        {modelHash = "cargobob4", dist = 8.0, xOffset = 0.65, yOffset = 0.085, zOffset = -0.8, rotOffset = 0.0, doors = {"BLD"}, powerload = false},
        {modelHash = "conada", dist = 8.0, xOffset = -0.05, yOffset = -0.2, zOffset = -0.175, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "maverick", dist = 8.0, xOffset = 0.0, yOffset = 0.1, zOffset = -0.28, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "polmav", dist = 8.0, xOffset = 0.0, yOffset = 1.2, zOffset = -0.7, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "savage", dist = 8.0, xOffset = 0.0, yOffset = 1.5, zOffset = -0.06, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "swift", dist = 8.0, xOffset = 0.0, yOffset = 1.85, zOffset = -0.27, rotOffset = -90.0, doors = {"BLD", "BRD"}, powerload = false},
        {modelHash = "valkyrie", dist = 8.0, xOffset = 0.0, yOffset = 1.075, zOffset = -0.65, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "valkyrie2", dist = 8.0, xOffset = 0.0, yOffset = 1.075, zOffset = -0.65, rotOffset = -90.0, doors = {}, powerload = false},
        {modelHash = "avenger", dist = 8.0, xOffset = 1.0, yOffset = 2.2, zOffset = -1.67, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},
        {modelHash = "avenger2", dist = 8.0, xOffset = 1.0, yOffset = 2.2, zOffset = -1.67, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},
        {modelHash = "avenger3", dist = 8.0, xOffset = 1.0, yOffset = 2.2, zOffset = -1.67, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},
        {modelHash = "avenger4", dist = 8.0, xOffset = 1.0, yOffset = 2.2, zOffset = -1.67, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},
        {modelHash = "bombushka", dist = 13.0, xOffset = 1.3, yOffset = -2.2, zOffset = -0.58, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},
        {modelHash = "streamer216", dist = 8.0, xOffset = 0.0, yOffset = -1.8, zOffset = -1.24, rotOffset = -180.0, doors = {"BLD"}, powerload = false},
        {modelHash = "titan", dist = 13.0, xOffset = 0.0, yOffset = -2.2, zOffset = -0.58, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false},

    -- ADDON VEHICLES

        -- AIRCRAFT
        {modelHash = "ec145med", dist = 8.0, xOffset = -0.27, yOffset = -0.85, zOffset = -0.829, rotOffset = 0.0, doors = {"BLD", "BRD"}, powerload = false}, -- EC145
        {modelHash = "aw109", dist = 8.0, xOffset = -0.27, yOffset = 0.65, zOffset = 0.0, rotOffset = 0.0, doors = {"BLD", "BRD"}, powerload = false}, -- AW109
        {modelHash = "c3aw139", dist = 8.0, xOffset = 0.0, yOffset = 0.13, zOffset = -0.215, rotOffset = -90.0, doors = {"BLD", "BRD"}, powerload = false}, -- AW139
        {modelHash = "gsd11bell", dist = 8.0, xOffset = -0.27, yOffset = 0.47, zOffset = -0.70, rotOffset = 0.0, doors = {"BLD", "BRD"}, powerload = false}, -- BELL 206
        {modelHash = "as365", dist = 8.0, xOffset = 0.0, yOffset = 0.65, zOffset = -0.9, rotOffset = -90.0, doors = {"BLD", "BRD"}, powerload = false}, -- AS365

        -- REDNECK MODIFICATIONS
        {modelHash = "f450ambo", dist = 8.0, xOffset = 0.0, yOffset = -1.5, zOffset = -0.025, rotOffset = 0.0, doors = {"TRUNK", "HOOD"}, powerload = true}, -- 2018 FORD F450
        {modelHash = "e450ambo", dist = 8.0, xOffset = 0.0, yOffset = -1.5, zOffset = -0.025, rotOffset = 0.0, doors = {"TRUNK", "HOOD"}, powerload = true}, -- 2019 FORD E450
        {modelHash = "20ramambo", dist = 8.0, xOffset = 0.0, yOffset = -1.5, zOffset = -0.025, rotOffset = 0.0, doors = {"TRUNK", "HOOD"}, powerload = true}, -- 2020 DODGE RAM 5500

        -- RIPPLE MODIFICATIONS
        {modelHash = "fordambo", dist = 8.0, xOffset = 0.0, yOffset = -3.85, zOffset = 0.34, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false}, -- 2019 FORD F550
        {modelHash = "rambulance", dist = 8.0, xOffset = 0.0, yOffset = -2.8, zOffset = 0.135, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false}, -- 2016 DODGE RAM 5500 

        -- PAUL MODIFICATIONS
        {modelHash = "amrexpress", dist = 5.5, xOffset = -0.15, yOffset = -1.7, zOffset = -0.3, rotOffset = 0.0, doors = {"BLD", "BRD", "TRUNK"}, powerload = false}, -- 2016 CHEVROLET EXPRESS
        {modelHash = "cambo", dist = 8.0, xOffset = -0.062, yOffset = -2.5, zOffset = 0.08, rotOffset = 0.0, doors = {"TRUNK", "BRD"}, powerload = false}, -- 2020 CHEVROLET 3500

        -- POKEY DEVELOPMENT
        {modelHash = "f550ambo", dist = 8.0, xOffset = 0.0, yOffset = -3.175, zOffset = 0.445, rotOffset = 0.0, doors = {"BLD", "BRD"}, powerload = false}, -- 2020 FORD F550
        {modelHash = "f550ambocc", dist = 9.0, xOffset = 0.0, yOffset = -4.085, zOffset = 0.445, rotOffset = 0.0, doors = {"TRUNK", "HOOD"}, powerload = false}, -- 2020 FORD F550 CREW CAB

        -- FREEMODE DESIGNS
        {modelHash = "medic12", dist = 8.0, xOffset = 0.0, yOffset = -3.10, zOffset = 0.22, rotOffset = 0.0, doors = {"BRD", "BLD", "HOOD"}, powerload = false}, -- 2016 FORD F250
        {modelHash = "medic22", dist = 8.0, xOffset = 0.0, yOffset = -3.3, zOffset = -0.15, rotOffset = 0.0, doors = {"BRD", "BLD"}, powerload = false}, -- 2019 CHEVROLET 3500

        -- SHADOW MODIFICATIONS
        {modelHash = "shadowf450ambo", dist = 8.0, xOffset = 0.0, yOffset = -2.8, zOffset = 0.382, rotOffset = 0.0, doors = {"TRUNK"}, powerload = false}, -- 2020 FORD F450 

        -- REDSAINT MODIFICATIONS
        {modelHash = "redsaintfordambo", dist = 8.0, xOffset = 0.0, yOffset = -3.10, zOffset = 0.46, rotOffset = 0.0, doors = {"BRD", "BLD"}, powerload = false}, -- 2021 FORD F450

        -- ZEAKOR MODIFICATIONS
        {modelHash = "f450", dist = 7.0, xOffset = 0.0, yOffset = -2.5, zOffset = 0.465, rotOffset = 0.0, doors = {"BRD", "BLD"}, powerload = false}, -- 2018 FORD F450
}




