local addonName, ns = ...

ns.UI = ns.UI or {}
ns.UI.SpellList = {}

local SpellList = ns.UI.SpellList

local rows = {}

local function GetSpellName(spellID)
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(spellID)

        if info then
            return info.name
        end
    end

    return nil
end

local function ClearRows()
    for _, row in ipairs(rows) do
        row:Hide()
    end
end

local function CreateRow(parent, index)
    local row = CreateFrame(
        "Button",
        nil,
        parent,
        "BackdropTemplate"
    )

    row:SetHeight(42)

    row:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
    })

    row:SetBackdropColor(0.08, 0.08, 0.08, 0.5)

    row.name = row:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    row.name:SetPoint("LEFT", 10, 7)

    row.details = row:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontDisableSmall"
    )

    row.details:SetPoint("LEFT", 10, -9)

    row:SetScript("OnClick", function(self)
        if self.spellID then
            ns.UI.SpellEditor:Open(self.spellID)
        end
    end)

    rows[index] = row

    return row
end

function SpellList:Initialize()
    local parent = ns.UI.MainFrame:GetContentFrame()

    if not parent then
        return
    end

    self.parent = parent
end

function SpellList:Refresh()
    if not self.parent then
        return
    end

    ClearRows()

    local spells = ns.Database:GetSpells()

    local spellIDs = {}

    for spellID in pairs(spells) do
        table.insert(spellIDs, spellID)
    end

    table.sort(spellIDs)

    if #spellIDs == 0 then
        if not self.emptyText then
            self.emptyText = self.parent:CreateFontString(
                nil,
                "OVERLAY",
                "GameFontDisable"
            )

            self.emptyText:SetPoint("CENTER")
        end

        self.emptyText:SetText(ns.L.NO_SPELLS)
        self.emptyText:Show()

        return
    end

    if self.emptyText then
        self.emptyText:Hide()
    end

    for index, spellID in ipairs(spellIDs) do
        local row = rows[index]

        if not row then
            row = CreateRow(self.parent, index)
        end

        row:ClearAllPoints()

        row:SetPoint(
            "TOPLEFT",
            0,
            -((index - 1) * 46)
        )

        row:SetPoint(
            "TOPRIGHT",
            0,
            -((index - 1) * 46)
        )

        local data = spells[spellID]

        local spellName = GetSpellName(spellID)

        if spellName then
            row.name:SetText(
                spellName .. "  [" .. spellID .. "]"
            )
        else
            row.name:SetText(
                "Spell " .. spellID
            )
        end

        row.details:SetText(
            tostring(data.chance or 0)
            .. "% · "
            .. tostring(#(data.quotes or {}))
            .. " Quotes"
        )

        row.spellID = spellID

        row:Show()
    end
end