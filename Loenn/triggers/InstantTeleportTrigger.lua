local vivUtil = require("mods").requireFromPlugin("libraries.vivUtil")
local state = require("loaded_state")
local vh_tag = require("mods").requireFromPlugin("ui.forms.fields.vh_tag")

local oldFieldOrder = { 
    "x","y","width","height",
    "newPosX","newPosY",
    "WarpRoom","TransitionType",
    "AddTriggerOffset","ResetDashes",
    "TimeBeforeTeleport","ZFlagsData",
    "ExitVelocityX", "ExitVelocityY",
    "ExitVelocityS","Dreaming", "ForceNormalState",
    "VelocityModifier","RotationType", "RotationActor"
}

local oldFieldInfo = {
    newPosX = { fieldType = "integer", minimumValue = -1 },
    newPosY = { fieldType = "integer", minimumValue = -1 },
    WarpRoom = { fieldType = "VivHelper.room_names" },
    TransitionType = { fieldType = "string", options = {{"None", "None"},{"Lightning", "Lightning"},{"Glitch", "GlitchEffect"},{"Color Flash", "ColorFlash"}}, editable = false}
}

local function oldTextFunction(room, item) return "Instant Teleport [VivHelper]\n"..item.WarpRoom or "" .. "\n(" .. item.newPosX .. "," .. item.newPosY .. ")" end

local ittOB = { name = "VivHelper/BasicInstantTeleportTrigger",
    fieldInformation = oldFieldInfo,
    fieldOrder = oldFieldOrder,
    _vivh_textOverride = oldTextFunction,
    _vivh_finalizePlacement = function(room, layer, item) item.WarpRoom = room.name end
}
ittOB.placements = {
    name = "main",
    data = {
        newPosX = -1,
        newPosY = -1,
        WarpRoom = "", TransitionType="None",
        AddTriggerOffset=false, ResetDashes=false
    }
}
local ittOM = { name = "VivHelper/MainInstantTeleportTrigger", fieldInformation = oldFieldInfo, fieldOrder = oldFieldOrder, _vivh_replaceDrawTextFunc = oldTextFunction, _vivh_finalizePlacement = function(room, layer, item) item.WarpRoom = room.name end }
ittOM.placements = {
    name = "main",
    data = {
        newPosX = -1,
        newPosY = -1,
        WarpRoom = "", TransitionType="None",
        AddTriggerOffset=false, ResetDashes=false,
        ExitVelocityX=0.0,ExitVelocityY=0.0,VelocityModifier=false,
        TimeBeforeTeleport=0.0,ForceNormalState=false
    }
}
local ittOC = { name = "VivHelper/CustomInstantTeleportTrigger",
fieldInformation = oldFieldInfo,
fieldOrder = oldFieldOrder,
_vivh_replaceDrawTextFunc = oldTextFunction,
_vivh_finalizePlacement = function(room, layer, item) item.WarpRoom = room.name end }
ittOC.placements = {
    name = "main",
    data = {
        newPosX = -1,
        newPosY = -1,
        WarpRoom = "", TransitionType="None",
        AddTriggerOffset=false, ResetDashes=false,
        ExitVelocityX=0.0,ExitVelocityY=0.0,ExitVelocityS=0.0,VelocityModifier=false,
        TimeBeforeTeleport=0.0,ForceNormalState=false,
        RotationType=false,RotationActor=0.0,
        TimeSlowDown=0.0
    }
}

local Target = { name = "VivHelper/TeleportTarget", placements = {
        name = "main",
        data = {
            TargetID="Target", AddTriggerOffset=false, SetState="-1"
        }
    }
}
vh_tag.addTagControlToHandler(Target, "TargetID", "teleporttarget", true)

local Teleporter = { name = "VivHelper/ITPT1Way", 
    placements = {{
        name = "main",
        data = {
            TargetID="Target", ExitDirection=15, RoomName = "",
            RequiredFlags="", FlagsOnTeleport="",
            ResetDashes=false,
            BringHoldableThrough=false,
            IgnoreNoSpawnpoints=false,
            Persistence="None",
            EndCutsceneOnWarp=false,
            customDelay=0.0,
            TransitionType = "None"
        }
    }, {
        name = "flash",
        data = {
            TargetID="Target", ExitDirection=15, RoomName = "",
            RequiredFlags="", FlagsOnTeleport="",
            ResetDashes=false,
            BringHoldableThrough=false,
            IgnoreNoSpawnpoints=false,
            Persistence="None",
            EndCutsceneOnWarp=false,
            customDelay=0.0,
            TransitionType = "Flash",
            FlashColor = "ffffff",
            FlashAlpha = 1.0
        }
    }, {
        name = "lightning",
        data = {
            TargetID="Target", ExitDirection=15, RoomName = "",
            RequiredFlags="", FlagsOnTeleport="",
            ResetDashes=false,
            BringHoldableThrough=false,
            IgnoreNoSpawnpoints=false,
            Persistence="None",
            EndCutsceneOnWarp=false,
            TransitionType = "Lightning",
            LightningCount = 2,
            LightningOffsetRange = "-130,130",
            LightningDelay = 0.0,
            LightningMaxDelay = 0.25,
            Flash = true,
            Shake = true
        }
    }, {
        name = "glitch",
        data = {
            TargetID="Target", ExitDirection=15, RoomName = "",
            RequiredFlags="", FlagsOnTeleport="",
            ResetDashes=false,
            BringHoldableThrough=false,
            IgnoreNoSpawnpoints=false,
            Persistence="None",
            EndCutsceneOnWarp=false,
            TransitionType = "Glitch",
            GlitchStrength = 0.5,
            StartingGlitchEase = "Linear",
            StartingGlitchDuration = 0.3,
            EndingGlitchEase = "Linear",
            EndingGlitchDuration = 0.3,
            freezeOnTeleport = true
        }
    }, {
        name = "wipe",
        data = {
            TargetID="Target", ExitDirection=15, RoomName = "",
            RequiredFlags="", FlagsOnTeleport="",
            ResetDashes=false,
            BringHoldableThrough=false,
            IgnoreNoSpawnpoints=false,
            Persistence="None",
            EndCutsceneOnWarp=false,
            TransitionType = "Wipe",
            freezeOnTeleport = true,
            wipeOnLeave = true,
            wipeOnEnter = true
        }
    }},
    fieldOrder = { "x", "y", "width", "height", "TargetID", "RoomName", "Persistence", "ExitDirection",
        "RequiredFlags", "FlagsOnTeleport", "TransitionType", "ResetDashes", "AddTriggerOffset", "BringHoldableThrough", "IgnoreNoSpawnpoints", 
        "FlashColor", "FlashAlpha",
        "LightningCount", "LightningOffsetRange", "LightningDelay", "LightningMaxDelay", "Flash", "Shake",
        "GlitchStrength", "StartingGlitchDuration", "EndingGlitchDuration", "StartingGlitchEase", "EndingGlitchEase", 
        "freezeOnTeleport",
        "wipeOnEnter", "wipeOnLeave"
    },
    ignoredFields = function(entity) 
        local tt = entity.TransitionType
        if tt == "Flash" then return {"_id","_name","TransitionType","LightningCount","LightningOffsetRange", "LightningDelay", "LightningMaxDelay", "Flash", "Shake",
            "GlitchStrength", "StartingGlitchDuration", "EndingGlitchDuration", "StartingGlitchEase", "EndingGlitchEase", "freezeOnTeleport", "wipeOnEnter","wipeOnLeave"}
        elseif tt == "Lightning" then return {"_id","_name","TransitionType", "FlashColor","FlashAlpha",
            "GlitchStrength", "StartingGlitchDuration", "EndingGlitchDuration", "StartingGlitchEase", "EndingGlitchEase", "freezeOnTeleport", "wipeOnEnter","wipeOnLeave"}
        elseif tt == "Glitch" then return {"_id","_name","TransitionType", "FlashColor","FlashAlpha",
            "LightningCount","LightningOffsetRange", "LightningDelay", "LightningMaxDelay", "Flash", "Shake", "wipeOnEnter","wipeOnLeave"}
        elseif tt == "Wipe" then return {"TransitionType", "FlashColor","FlashAlpha",
            "LightningCount","LightningOffsetRange", "LightningDelay", "LightningMaxDelay", "Flash", "Shake",
            "GlitchStrength", "StartingGlitchDuration", "EndingGlitchDuration", "StartingGlitchEase", "EndingGlitchEase"}
        else return {"_id","_name","TransitionType", "FlashColor","FlashAlpha",
            "LightningCount","LightningOffsetRange", "LightningDelay", "LightningMaxDelay", "Flash", "Shake",
            "GlitchStrength", "StartingGlitchDuration", "EndingGlitchDuration", "StartingGlitchEase", "EndingGlitchEase", "freezeOnTeleport",
            "wipeOnEnter","wipeOnLeave"}
        end
    end
}

Teleporter.fieldInformation = function(entity)
    local tt = entity.TransitionType
    local ret = {ExitDirection = {fieldType = "integer", options = {
        ["Opposite Entry Only"] = -2,
        ["Any Side Not Entry"] = -1,
        ["Teleport On Entry"] = 0,
        ["Right Only"] = 1,
        ["Up Only"] = 2,
        ["Up or Right"] = 3,
        ["Left Only"] = 4,
        ["Horizontal (L/R)"] = 5,
        ["Left or Up"] = 6,
        ["Not Down (R/U/L)"] = 7,
        ["Down Only"] = 8,
        ["Down or Right"] = 9,
        ["Vertical (U/D)"] = 10,
        ["Not Left (R/U/D)"] = 11,
        ["Down or Left"] = 12,
        ["Not Up (R/L/D)"] = 13,
        ["Not Right (U/L/D)"] = 14,
        ["Any Exit (Default)"] = 15,
    }, editable = false },
    RoomName = {fieldType = "VivHelper.room_names"},
    Persistence = {options = {"None","OncePerRetry","OncePerMapPlay"}, editable = false} }

    if tt == "Flash" then 
        ret["FlashColor"] = {fieldType = "color", allowXNAColors = true}
        ret["FlashAlpha"] = {fieldType = "number", minimumValue = 0.0, maximumValue = 1.0 }
    elseif tt == "Lightning" then 
        ret["LightningOffsetRange"] = {fieldType = "string",
        validator = function(s)
            if not s or #s > 0 then return false end
            local _s = s:gmatch(",")
            return #_s ~= 2 and false or (tonumber(_s[1]:gsub("%s+", "")) ~= nil and tonumber(_s[2]:gsub("%s+", "")) ~= nil) 
        end
        }
        ret["LightningCount"] = {fieldType = "integer"}
        ret["LightningDelay"] = {fieldType = "number", minimumValue = 0.0 }
        ret["LightningMaxDelay"] = {fieldType = "number", minimumValue = 0.0 }
    elseif tt == "Glitch" then 
        ret["GlitchStrength"] = {fieldType = "number", minimumValue = 0.0, maximumValue = 1.0 }
        -- TODO : Easer control option on StartingGlitchEase and EndingGlitchEase
        ret["StartingGlitchDuration"] = {fieldType = "number", minimumValue = 0.0}
        ret["EndingGlitchDuration"] = {fieldType = "number", minimumValue = 0.0}
    end
    -- Flash, Shake
    
    -- freezeOnTeleport, wipeOnEnter, wipeOnLeave   
    return ret     
end
Teleporter._vivh_finalizePlacement = function(room,layer,item) item.RoomName = room.name end
Teleporter._vivh_replaceDrawTextFunc = function(room, item) 
    
end
vh_tag.addTagControlToHandler(Teleporter, "TargetID", "teleporttarget", false)



return { ittOB, ittOM, ittOC, Target, Teleporter }