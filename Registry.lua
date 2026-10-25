local _, ns = ...

local members = {}
local pendingChunks = {}

function ns.SetMemberAddOns(name, addons)
    members[name] = addons
    ns.RefreshUI()
end

function ns.AddMemberChunk(name, index, total, list)
    if index == 1 then
        pendingChunks[name] = {}
    end
    local parts = pendingChunks[name]
    if not parts then
        return
    end
    parts[index] = list
    if index < total then
        return
    end
    pendingChunks[name] = nil
    ns.SetMemberAddOns(name, { strsplit(",", table.concat(parts, ",")) })
end

function ns.GetMemberAddOns(name)
    return members[name]
end
