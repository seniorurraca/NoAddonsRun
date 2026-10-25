local _, ns = ...

local STARTUP_DELAY = 5
local DEFAULTS = { minimapAngle = 225 }

local ready = false
local announcedChannels = {}

function ns.RefreshUI()
    local sections = ns.GetSections()
    ns.RenderWindow(sections)
    ns.UpdateMinimapIcon(sections)
end

local function announceToNewChannels()
    if not ready then
        return
    end
    local current = {}
    for _, channel in ipairs(ns.GetChannels()) do
        current[channel] = true
        if not announcedChannels[channel] then
            ns.AnnounceTo(channel)
        end
    end
    announcedChannels = current
end

local function onRosterChanged()
    announceToNewChannels()
    ns.RefreshUI()
end

ns.On("PLAYER_LOGIN", function()
    ns.playerName = UnitName("player")
    NoAddonsRunDB = NoAddonsRunDB or CopyTable(DEFAULTS)
    ns.InitMinimapButton()
    C_Timer.After(STARTUP_DELAY, function()
        ready = true
        onRosterChanged()
    end)
end)

ns.On("GUILD_ROSTER_UPDATE", onRosterChanged)
ns.On("GROUP_ROSTER_UPDATE", onRosterChanged)

SLASH_NOADDONSRUN1 = "/noaddons"
SLASH_NOADDONSRUN2 = "/nar"
SlashCmdList.NOADDONSRUN = ns.ToggleWindow
