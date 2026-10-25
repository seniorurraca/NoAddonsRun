local _, ns = ...

ns.RequestGuildRoster = C_GuildInfo and C_GuildInfo.GuildRoster or GuildRoster

local RANK_VIOLATOR, RANK_UNKNOWN, RANK_CLEAN = 1, 2, 3

function ns.IsViolator(addons)
    return addons ~= nil and #addons > 0
end

local function rank(member)
    if ns.IsViolator(member.addons) then
        return RANK_VIOLATOR
    end
    return member.addons and RANK_CLEAN or RANK_UNKNOWN
end

local function byRankThenName(a, b)
    if rank(a) ~= rank(b) then
        return rank(a) < rank(b)
    end
    return a.name < b.name
end

function ns.GetGuildStatus()
    local status = {}
    for index = 1, GetNumGuildMembers() do
        local fullName, _, _, _, _, _, _, _, online = GetGuildRosterInfo(index)
        local name = fullName and Ambiguate(fullName, "none")
        if online and name ~= ns.playerName then
            table.insert(status, { name = name, addons = ns.GetMemberAddOns(name) })
        end
    end
    table.sort(status, byRankThenName)
    return status
end

function ns.CountViolators(status)
    local count = 0
    for _, member in ipairs(status) do
        if ns.IsViolator(member.addons) then
            count = count + 1
        end
    end
    return count
end
