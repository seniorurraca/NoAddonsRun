local _, ns = ...

local MSG_QUERY = "Q"
local MSG_CLEAN = "C"
local MSG_ADDONS = "A"
local MAX_CHUNK_LENGTH = 200
local MAX_REPLY_DELAY = 5
local SUPPORTED_CHANNELS = { GUILD = true, PARTY = true, RAID = true }

local replyScheduled = {}

function ns.GetGroupChannel()
    if IsInRaid() then
        return "RAID"
    end
    return IsInGroup() and "PARTY" or nil
end

function ns.GetChannels()
    local channels = {}
    if IsInGuild() then
        table.insert(channels, "GUILD")
    end
    local groupChannel = ns.GetGroupChannel()
    if groupChannel then
        table.insert(channels, groupChannel)
    end
    return channels
end

local function send(channel, message)
    C_ChatInfo.SendAddonMessage(ns.PREFIX, message, channel)
end

local function splitIntoChunks(names)
    local chunks, current = {}, ""
    for _, name in ipairs(names) do
        local candidate = current == "" and name or current .. "," .. name
        if #candidate > MAX_CHUNK_LENGTH and current ~= "" then
            table.insert(chunks, current)
            current = name
        else
            current = candidate
        end
    end
    table.insert(chunks, current)
    return chunks
end

function ns.SendReportTo(channel)
    replyScheduled[channel] = nil
    local addons = ns.GetLoadedAddOns()
    if #addons == 0 then
        send(channel, MSG_CLEAN)
        return
    end
    local chunks = splitIntoChunks(addons)
    for index, chunk in ipairs(chunks) do
        send(channel, ("%s:%d:%d:%s"):format(MSG_ADDONS, index, #chunks, chunk))
    end
end

function ns.AnnounceTo(channel)
    ns.SendReportTo(channel)
    send(channel, MSG_QUERY)
end

function ns.AnnounceToAll()
    for _, channel in ipairs(ns.GetChannels()) do
        ns.AnnounceTo(channel)
    end
end

local function scheduleReply(channel)
    if replyScheduled[channel] then
        return
    end
    replyScheduled[channel] = true
    C_Timer.After(math.random(1, MAX_REPLY_DELAY), function() ns.SendReportTo(channel) end)
end

local function onAddonMessage(prefix, message, channel, sender)
    if prefix ~= ns.PREFIX or not SUPPORTED_CHANNELS[channel] then
        return
    end
    local name = Ambiguate(sender, "none")
    if name == ns.playerName then
        return
    end
    local kind = message:sub(1, 1)
    if kind == MSG_QUERY then
        scheduleReply(channel)
    elseif kind == MSG_CLEAN then
        ns.SetMemberAddOns(name, {})
    elseif kind == MSG_ADDONS then
        local index, total, list = message:match("^A:(%d+):(%d+):(.+)$")
        if index then
            ns.AddMemberChunk(name .. channel, name, tonumber(index), tonumber(total), list)
        end
    end
end

C_ChatInfo.RegisterAddonMessagePrefix(ns.PREFIX)
ns.On("CHAT_MSG_ADDON", onAddonMessage)
