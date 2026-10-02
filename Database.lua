local addonName, ns = ...

ns.Database = {}

local Database = ns.Database

local DEFAULTS = {
    enabled = true,
    spells = {},
}


-- -------------------------------------------------------
-- Defaults
-- -------------------------------------------------------

local function CopyDefaults(source, target)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end

            CopyDefaults(value, target[key])

        elseif target[key] == nil then
            target[key] = value
        end
    end
end


-- -------------------------------------------------------
-- Initialization
-- -------------------------------------------------------

function Database:Initialize()
    SpellQuotesDB = SpellQuotesDB or {}

    CopyDefaults(
        DEFAULTS,
        SpellQuotesDB
    )

    ns.db = SpellQuotesDB
end


-- -------------------------------------------------------
-- Global settings
-- -------------------------------------------------------

function Database:IsEnabled()
    return ns.db
        and ns.db.enabled == true
end


function Database:SetEnabled(enabled)
    if not ns.db then
        return
    end

    ns.db.enabled = enabled == true
end


-- -------------------------------------------------------
-- Spells
-- -------------------------------------------------------

function Database:GetSpells()
    if not ns.db then
        return {}
    end

    return ns.db.spells
end


function Database:GetSpell(spellID)
    if not ns.db then
        return nil
    end

    return ns.db.spells[spellID]
end


function Database:SaveSpell(
    spellID,
    chance,
    quotes
)
    if not ns.db then
        return
    end

    ns.db.spells[spellID] = {
        chance = chance,
        quotes = quotes,
    }
end


function Database:DeleteSpell(spellID)
    if not ns.db then
        return
    end

    ns.db.spells[spellID] = nil
end