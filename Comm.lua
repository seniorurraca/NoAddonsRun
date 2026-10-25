local _, ns = ...

local MSG_QUERY = "Q"
local MSG_CLEAN = "C"
local MSG_ADDONS = "A"
local MAX_CHUNK_LENGTH = 200
local MAX_REPLY_DELAY = 5

local replyScheduled = false

local function send(message)
    if IsInGuild() then
        C_ChatInfo.SendAddonMessage(ns.PREFIX, message, "GUILD")
    end
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

function ns.SendReport()
    replyScheduled = false
    local addons = ns.GetLoadedAddOns()
    if #addons == 0 then
        send(MSG_CLEAN)
        return
    end
    local chunks = splitIntoChunks(addons)
    for index, chunk in ipairs(chunks) do
        send(("%s:%d:%d:%s"):format(MSG_ADDONS, index, #chunks, chunk))
    end
end

function ns.SendQuery()
    send(MSG_QUERY)
end

local function scheduleReply()
    if replyScheduled then
        return
    end
    replyScheduled = true
    C_Timer.After(math.random(1, MAX_REPLY_DELAY), ns.SendReport)
end

local function onAddonMessage(prefix, message, channel, sender)
    if prefix ~= ns.PREFIX or channel ~= "GUILD" then
        return
    end
    local name = Ambiguate(sender, "none")
    if name == ns.playerName then
        return
    end
    local kind = message:sub(1, 1)
    if kind == MSG_QUERY then
        scheduleReply()
    elseif kind == MSG_CLEAN then
        ns.SetMemberAddOns(name, {})
    elseif kind == MSG_ADDONS then
        local index, total, list = message:match("^A:(%d+):(%d+):(.+)$")
        if index then
            ns.AddMemberChunk(name, tonumber(index), tonumber(total), list)
        end
    end
end

C_ChatInfo.RegisterAddonMessagePrefix(ns.PREFIX)
ns.On("CHAT_MSG_ADDON", onAddonMessage)
