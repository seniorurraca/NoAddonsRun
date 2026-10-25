local _, ns = ...

local function getPlayerAddOns(unit)
    if UnitIsUnit(unit, "player") then
        return ns.GetLoadedAddOns()
    end
    return ns.GetMemberAddOns(GetUnitName(unit, true))
end

local function addStatusLine(tooltip)
    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then
        return
    end
    local addons = getPlayerAddOns(unit)
    if addons == nil then
        return
    end
    if #addons == 0 then
        tooltip:AddLine(ns.L.UNIT_CLEAN, 0.33, 1, 0.33)
    else
        tooltip:AddLine(ns.L.UNIT_DIRTY:format(#addons), 1, 0.33, 0.33)
    end
end

if TooltipDataProcessor and Enum.TooltipDataType then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
        if tooltip == GameTooltip then
            addStatusLine(tooltip)
        end
    end)
else
    GameTooltip:HookScript("OnTooltipSetUnit", addStatusLine)
end
