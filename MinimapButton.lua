local _, ns = ...

local RADIUS = 80
local ICON = "Interface\\Icons\\INV_Misc_Spyglass_02"

local button = CreateFrame("Button", "NoAddonsRunMinimapButton", Minimap)
button:SetSize(31, 31)
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
button:RegisterForClicks("LeftButtonUp")
button:RegisterForDrag("LeftButton")

local icon = button:CreateTexture(nil, "BACKGROUND")
icon:SetSize(20, 20)
icon:SetPoint("TOPLEFT", 7, -5)
icon:SetTexture(ICON)

local border = button:CreateTexture(nil, "OVERLAY")
border:SetSize(53, 53)
border:SetPoint("TOPLEFT")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

local function placeAtAngle(angle)
    local radians = math.rad(angle)
    button:SetPoint("CENTER", Minimap, "CENTER", math.cos(radians) * RADIUS, math.sin(radians) * RADIUS)
end

local function cursorAngle()
    local centerX, centerY = Minimap:GetCenter()
    local cursorX, cursorY = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    return math.deg(math.atan2(cursorY / scale - centerY, cursorX / scale - centerX))
end

local function followCursor()
    NoAddonsRunDB.minimapAngle = cursorAngle()
    placeAtAngle(NoAddonsRunDB.minimapAngle)
end

local function showTooltip(self)
    local violators = ns.CountViolators(ns.GetGuildStatus())
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("NoAddonsRun")
    if ns.IsPlayerClean() then
        GameTooltip:AddLine("You: playing without addons", 0.33, 1, 0.33)
    else
        GameTooltip:AddLine("You: addons loaded", 1, 0.33, 0.33)
    end
    if IsInGuild() then
        GameTooltip:AddLine(("Online rule breakers: %d"):format(violators), 1, 1, 1)
    end
    GameTooltip:AddLine("Click to open. Drag to move.", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

button:SetScript("OnClick", ns.ToggleWindow)
button:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", followCursor) end)
button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
button:SetScript("OnEnter", showTooltip)
button:SetScript("OnLeave", GameTooltip_Hide)

function ns.InitMinimapButton()
    placeAtAngle(NoAddonsRunDB.minimapAngle)
end

function ns.UpdateMinimapIcon(status)
    if not ns.IsPlayerClean() or ns.CountViolators(status) > 0 then
        icon:SetVertexColor(1, 0.3, 0.3)
    else
        icon:SetVertexColor(1, 1, 1)
    end
end
