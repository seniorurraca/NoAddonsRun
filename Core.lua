local addonName, ns = ...

ns.ADDON_NAME = addonName
ns.PREFIX = "NoAddonsRun"

local frame = CreateFrame("Frame")
local handlers = {}

function ns.On(event, handler)
    handlers[event] = handler
    frame:RegisterEvent(event)
end

frame:SetScript("OnEvent", function(_, event, ...)
    handlers[event](...)
end)
