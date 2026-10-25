local _, ns = ...

local members = {}
local pendingChunks = {}

function ns.SetMemberAddOns(name, addons)
    members[name] = addons
    ns.RefreshUI()
end

function ns.AddMemberChunk(key, name, index, total, list)
    if index == 1 then
        pendingChunks[key] = {}
    end
    local parts = pendingChunks[key]
    if not parts then
        return
    end
    parts[index] = list
    if index < total then
        return
    end
    pendingChunks[key] = nil
    ns.SetMemberAddOns(name, { strsplit(",", table.concat(parts, ",")) })
end

function ns.GetMemberAddOns(name)
    return members[name]
end

function ns.GetKnownNames()
    local names = {}
    for name in pairs(members) do
        table.insert(names, name)
    end
    return names
end
