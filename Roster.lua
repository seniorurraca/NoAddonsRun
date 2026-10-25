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

local function getGroupNames()
    local names = {}
    local unitPrefix = IsInRaid() and "raid" or "party"
    for index = 1, GetNumGroupMembers() do
        local name = GetUnitName(unitPrefix .. index, true)
        if name then
            table.insert(names, name)
        end
    end
    return names
end

local function getOnlineGuildNames()
    local names = {}
    for index = 1, GetNumGuildMembers() do
        local fullName, _, _, _, _, _, _, _, online = GetGuildRosterInfo(index)
        if online and fullName then
            table.insert(names, Ambiguate(fullName, "none"))
        end
    end
    return names
end

local function buildSection(title, names, listed)
    local members = {}
    for _, name in ipairs(names) do
        if not listed[name] and name ~= ns.playerName then
            listed[name] = true
            table.insert(members, { name = name, addons = ns.GetMemberAddOns(name) })
        end
    end
    table.sort(members, byRankThenName)
    return { title = title, members = members }
end

function ns.GetSections()
    local L = ns.L
    local listed = {}
    local sections = {
        buildSection(L.SECTION_GROUP, getGroupNames(), listed),
        buildSection(L.SECTION_GUILD, getOnlineGuildNames(), listed),
        buildSection(L.SECTION_SEEN, ns.GetKnownNames(), listed),
    }
    local nonEmpty = {}
    for _, section in ipairs(sections) do
        if #section.members > 0 then
            table.insert(nonEmpty, section)
        end
    end
    return nonEmpty
end

function ns.CountViolators(sections)
    local count = 0
    for _, section in ipairs(sections) do
        for _, member in ipairs(section.members) do
            if ns.IsViolator(member.addons) then
                count = count + 1
            end
        end
    end
    return count
end
