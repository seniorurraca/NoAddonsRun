local _, ns = ...

local GetNumAddOns = C_AddOns and C_AddOns.GetNumAddOns or GetNumAddOns
local GetAddOnInfo = C_AddOns and C_AddOns.GetAddOnInfo or GetAddOnInfo
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded

local function isForbidden(name)
    return name ~= ns.ADDON_NAME and not name:find("^Blizzard_")
end

function ns.GetLoadedAddOns()
    local loaded = {}
    for index = 1, GetNumAddOns() do
        local name = GetAddOnInfo(index)
        if IsAddOnLoaded(index) and isForbidden(name) then
            table.insert(loaded, name)
        end
    end
    table.sort(loaded)
    return loaded
end
