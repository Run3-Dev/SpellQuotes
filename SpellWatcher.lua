local addonName, ns = ...

ns.SpellWatcher = {}

local SpellWatcher = ns.SpellWatcher

local frame = CreateFrame("Frame")

local function IsSecret(value)
    return type(issecretvalue) == "function"
        and issecretvalue(value)
end

local function Roll(chance)
    if chance <= 0 then
        return false
    end

    if chance >= 100 then
        return true
    end

    return math.random(100) <= chance
end

local function GetRandomQuote(quotes)
    if not quotes or #quotes == 0 then
        return nil
    end

    return quotes[math.random(#quotes)]
end

function SpellWatcher:HandleSpell(spellID)
    if not ns.Database:IsEnabled() then
        return
    end

    if spellID == nil then
        return
    end

    if IsSecret(spellID) then
        return
    end

    if type(spellID) ~= "number" then
        return
    end

    local data = ns.Database:GetSpell(spellID)

    if not data then
        return
    end

    if not Roll(data.chance or 0) then
        return
    end

    local quote = GetRandomQuote(data.quotes)

    if not quote or quote == "" then
        return
    end

    SendChatMessage(quote, "SAY")
end

frame:SetScript("OnEvent", function(self, event, unit, castGUID, spellID)
    if event ~= "UNIT_SPELLCAST_SUCCEEDED" then
        return
    end

    if unit ~= "player" then
        return
    end

    SpellWatcher:HandleSpell(spellID)
end)

function SpellWatcher:Initialize()
    frame:RegisterUnitEvent(
        "UNIT_SPELLCAST_SUCCEEDED",
        "player"
    )
end