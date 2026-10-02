local addonName, ns = ...

ns.Tooltip = {}

local Tooltip = ns.Tooltip


-- -------------------------------------------------------
-- Tooltip handling
-- -------------------------------------------------------

local function AddSpellID(tooltip, spellID)
    if not tooltip or not spellID then
        return
    end

    if type(spellID) ~= "number" then
        return
    end

    tooltip:AddLine(" ")

    tooltip:AddDoubleLine(
        "Spell ID",
        tostring(spellID),
        0.7, 0.7, 0.7,
        1, 0.82, 0
    )
end


-- -------------------------------------------------------
-- Initialization
-- -------------------------------------------------------

function Tooltip:Initialize()
    if not TooltipDataProcessor
        or not Enum
        or not Enum.TooltipDataType
    then
        return
    end

    TooltipDataProcessor.AddTooltipPostCall(
        Enum.TooltipDataType.Spell,
        function(tooltip, data)
            if not data then
                return
            end

            local spellID = data.id

            if not spellID then
                return
            end

            AddSpellID(
                tooltip,
                spellID
            )
        end
    )
end