local addonName, ns = ...

local frame =
    CreateFrame("Frame")


-- -------------------------------------------------------
-- Initialization
-- -------------------------------------------------------

local function Initialize()
    -- Data
    ns.Database:Initialize()

    -- Communication
    ns.Communication:Initialize()

    -- Tooltips
    ns.Tooltip:Initialize()

    -- UI
    ns.UI.MainFrame:Create()
    ns.UI.SpellList:Initialize()
    ns.UI.SpellEditor:Create()

    -- Spell detection
    ns.SpellWatcher:Initialize()
end


-- -------------------------------------------------------
-- Addon loading
-- -------------------------------------------------------

frame:RegisterEvent(
    "ADDON_LOADED"
)

frame:SetScript(
    "OnEvent",
    function(self, event, loadedAddon)
        if event ~= "ADDON_LOADED" then
            return
        end

        if loadedAddon ~= addonName then
            return
        end

        Initialize()

        self:UnregisterEvent(
            "ADDON_LOADED"
        )
    end
)


-- -------------------------------------------------------
-- Slash command
-- -------------------------------------------------------

SLASH_SPELLQUOTES1 =
    "/spellquotes"

SLASH_SPELLQUOTES2 =
    "/sq"

SlashCmdList.SPELLQUOTES =
    function()
        ns.UI.MainFrame:Toggle()
    end