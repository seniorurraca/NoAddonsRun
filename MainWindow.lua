local _, ns = ...

local WIDTH, HEIGHT = 360, 420
local TEXT_WIDTH = WIDTH - 50

local function formatMember(name, addons)
    if addons == nil then
        return ("|cff999999%s - no NoAddonsRun (unknown)|r"):format(name)
    end
    if #addons == 0 then
        return ("|cff55ff55%s - clean|r"):format(name)
    end
    return ("|cffff5555%s - breaks the rule:|r %s"):format(name, table.concat(addons, ", "))
end

local window = CreateFrame("Frame", "NoAddonsRunWindow", UIParent, "BasicFrameTemplateWithInset")
window:SetSize(WIDTH, HEIGHT)
window:SetPoint("CENTER")
window:SetMovable(true)
window:EnableMouse(true)
window:RegisterForDrag("LeftButton")
window:SetScript("OnDragStart", window.StartMoving)
window:SetScript("OnDragStop", window.StopMovingOrSizing)
window:Hide()
table.insert(UISpecialFrames, window:GetName())

local title = window:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("TOP", 0, -5)
title:SetText("NoAddonsRun")

local scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 12, -32)
scroll:SetPoint("BOTTOMRIGHT", -32, 44)

local content = CreateFrame("Frame", nil, scroll)
content:SetSize(TEXT_WIDTH, 1)
scroll:SetScrollChild(content)

local list = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
list:SetPoint("TOPLEFT")
list:SetWidth(TEXT_WIDTH)
list:SetJustifyH("LEFT")
list:SetSpacing(4)

local checkButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
checkButton:SetSize(120, 22)
checkButton:SetPoint("BOTTOM", 0, 14)
checkButton:SetText("Check guild")
checkButton:SetScript("OnClick", ns.SendQuery)

local function buildLines(status)
    local lines = { formatMember("You", ns.GetLoadedAddOns()), " " }
    if not IsInGuild() then
        table.insert(lines, "You are not in a guild.")
    end
    for _, member in ipairs(status) do
        table.insert(lines, formatMember(member.name, member.addons))
    end
    return lines
end

function ns.RenderWindow(status)
    if not window:IsShown() then
        return
    end
    list:SetText(table.concat(buildLines(status), "\n"))
    content:SetHeight(list:GetStringHeight())
end

function ns.ToggleWindow()
    window:SetShown(not window:IsShown())
end

window:SetScript("OnShow", function()
    ns.RequestGuildRoster()
    ns.RefreshUI()
end)
