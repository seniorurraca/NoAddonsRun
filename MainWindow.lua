local _, ns = ...

local L = ns.L
local WIDTH, HEIGHT = 360, 420
local TEXT_WIDTH = WIDTH - 50

local function formatMember(name, addons)
    if addons == nil then
        return "|cff999999" .. L.MEMBER_UNKNOWN:format(name) .. "|r"
    end
    if #addons == 0 then
        return "|cff55ff55" .. L.MEMBER_CLEAN:format(name) .. "|r"
    end
    return "|cffff5555" .. L.MEMBER_BREAKS:format(name) .. "|r " .. table.concat(addons, ", ")
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

local proof = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
proof:SetPoint("TOP", 0, -36)
proof:SetWidth(TEXT_WIDTH)

local proofDetail = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
proofDetail:SetPoint("TOP", proof, "BOTTOM", 0, -4)
proofDetail:SetWidth(TEXT_WIDTH)

local scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 12, -90)
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
checkButton:SetSize(140, 22)
checkButton:SetPoint("BOTTOM", 0, 14)
checkButton:SetText(L.CHECK_BUTTON)
checkButton:SetScript("OnClick", ns.AnnounceToAll)

local function renderProof()
    local addons = ns.GetLoadedAddOns()
    if #addons == 0 then
        proof:SetText("|cff55ff55" .. L.PROOF_CLEAN .. "|r")
        proofDetail:SetText(L.PROOF_CLEAN_DETAIL:format(ns.playerName))
    else
        proof:SetText("|cffff5555" .. L.PROOF_DIRTY .. "|r")
        proofDetail:SetText(L.PROOF_DIRTY_DETAIL:format(table.concat(addons, ", ")))
    end
end

local function buildLines(sections)
    local lines = {}
    if #ns.GetChannels() == 0 then
        table.insert(lines, "|cff999999" .. L.NO_CHANNEL_HINT .. "|r")
    end
    for _, section in ipairs(sections) do
        table.insert(lines, section.title .. ":")
        for _, member in ipairs(section.members) do
            table.insert(lines, formatMember(member.name, member.addons))
        end
        table.insert(lines, " ")
    end
    return lines
end

function ns.RenderWindow(sections)
    if not window:IsShown() then
        return
    end
    renderProof()
    checkButton:SetShown(#ns.GetChannels() > 0)
    list:SetText(table.concat(buildLines(sections), "\n"))
    content:SetHeight(list:GetStringHeight())
end

function ns.ToggleWindow()
    window:SetShown(not window:IsShown())
end

window:SetScript("OnShow", function()
    ns.RequestGuildRoster()
    ns.RefreshUI()
end)
