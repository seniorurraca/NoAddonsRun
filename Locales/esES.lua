local _, ns = ...

local locale = GetLocale()
if locale ~= "esES" and locale ~= "esMX" then
    return
end

local L = ns.L
L.PROOF_CLEAN = "JUGANDO SIN ADDONS"
L.PROOF_CLEAN_DETAIL = "%s no tiene otros addons cargados."
L.PROOF_DIRTY = "INCUMPLES LA REGLA"
L.PROOF_DIRTY_DETAIL = "Desactiva estos addons: %s"
L.MEMBER_UNKNOWN = "%s - sin NoAddonsRun (desconocido)"
L.MEMBER_CLEAN = "%s - limpio"
L.MEMBER_BREAKS = "%s - incumple la regla:"
L.SECTION_GROUP = "Grupo"
L.SECTION_GUILD = "Hermandad conectada"
L.SECTION_SEEN = "Otros vistos"
L.NO_CHANNEL_HINT = "Únete a una hermandad o grupo para mostrar tu comprobante a otros jugadores."
L.CHECK_BUTTON = "Comprobar de nuevo"
L.MINIMAP_YOU_CLEAN = "Tú: jugando sin addons"
L.MINIMAP_YOU_DIRTY = "Tú: addons cargados"
L.MINIMAP_BREAKERS = "Incumplen la regla: %d"
L.MINIMAP_HINT = "Click para abrir. Arrastra para mover."
L.UNIT_CLEAN = "NoAddonsRun: jugando sin addons"
L.UNIT_DIRTY = "NoAddonsRun: addons cargados (%d)"
