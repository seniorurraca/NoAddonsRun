local _, ns = ...

local STARTUP_DELAY = 5
local DEFAULTS = { minimapAngle = 225 }

function ns.RefreshUI()
    local status = ns.GetGuildStatus()
    ns.RenderWindow(status)
    ns.UpdateMinimapIcon(status)
end

local function announce()
    ns.SendReport()
    ns.SendQuery()
end

ns.On("PLAYER_LOGIN", function()
    ns.playerName = UnitName("player")
    NoAddonsRunDB = NoAddonsRunDB or CopyTable(DEFAULTS)
    ns.InitMinimapButton()
    C_Timer.After(STARTUP_DELAY, announce)
end)

ns.On("GUILD_ROSTER_UPDATE", ns.RefreshUI)

SLASH_NOADDONSRUN1 = "/noaddons"
SLASH_NOADDONSRUN2 = "/nar"
SlashCmdList.NOADDONSRUN = ns.ToggleWindow
