
local addonName, ns = ...

ns.UI = ns.UI or {}
ns.UI.SpellList = {}

local SpellList = ns.UI.SpellList

local ROW_HEIGHT = 42
local ROW_SPACING = 4
local ROW_STEP = ROW_HEIGHT + ROW_SPACING

local rows = {}

local scrollFrame
local scrollChild
local emptyText


-- -------------------------------------------------------
-- Spell information
-- -------------------------------------------------------

local function GetSpellName(spellID)
    if not C_Spell or not C_Spell.GetSpellInfo then
        return nil
    end

    local info = C_Spell.GetSpellInfo(spellID)

    return info and info.name or nil
end


-- -------------------------------------------------------
-- Rows
-- -------------------------------------------------------

local function CreateRow(parent, index)
    local row = CreateFrame(
        "Button",
        nil,
        parent,
        "BackdropTemplate"
    )

    row:SetHeight(ROW_HEIGHT)

    row:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
    })

    row:SetBackdropColor(0.08, 0.08, 0.08, 0.5)

    row.name = row:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    row.name:SetPoint("TOPLEFT", 10, -7)
    row.name:SetJustifyH("LEFT")

    row.details = row:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontDisableSmall"
    )

    row.details:SetPoint("BOTTOMLEFT", 10, 7)
    row.details:SetJustifyH("LEFT")

    row:SetScript("OnClick", function(self)
        if self.spellID then
            ns.UI.SpellEditor:Open(self.spellID)
        end
    end)

    rows[index] = row

    return row
end


local function ClearRows()
    for _, row in ipairs(rows) do
        row:Hide()
        row.spellID = nil
    end
end


-- -------------------------------------------------------
-- Scroll handling
-- -------------------------------------------------------

local function UpdateScrollRange()
    if not scrollFrame or not scrollChild then
        return
    end

    local contentHeight = scrollChild:GetHeight()
    local visibleHeight = scrollFrame:GetHeight()

    local maxScroll = math.max(
        0,
        contentHeight - visibleHeight
    )

    local currentScroll = scrollFrame:GetVerticalScroll()

    if currentScroll > maxScroll then
        scrollFrame:SetVerticalScroll(maxScroll)
    end

    if scrollFrame.ScrollBar then
        scrollFrame.ScrollBar:SetMinMaxValues(0, maxScroll)
        scrollFrame.ScrollBar:SetValue(
            scrollFrame:GetVerticalScroll()
        )
    end
end


-- -------------------------------------------------------
-- Initialization
-- -------------------------------------------------------

function SpellList:Initialize()
    local parent = ns.UI.MainFrame:GetContentFrame()

    if not parent then
        return
    end

    self.parent = parent

    -- ScrollFrame with Blizzard scrollbar
    scrollFrame = CreateFrame(
        "ScrollFrame",
        "SpellQuotesSpellScrollFrame",
        parent,
        "UIPanelScrollFrameTemplate"
    )

    scrollFrame:SetPoint("TOPLEFT", 0, 0)
    scrollFrame:SetPoint("BOTTOMRIGHT", -26, 0)

    -- Scrollable content
    scrollChild = CreateFrame(
        "Frame",
        nil,
        scrollFrame
    )

    scrollChild:SetWidth(
        math.max(1, parent:GetWidth() - 32)
    )

    scrollChild:SetHeight(1)

    scrollFrame:SetScrollChild(scrollChild)

    -- Keep content width synchronized
    scrollFrame:SetScript("OnSizeChanged", function(self, width)
        scrollChild:SetWidth(math.max(1, width))
    end)

    -- Mouse wheel support
    scrollFrame:EnableMouseWheel(true)

    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = math.max(
            0,
            scrollChild:GetHeight() - self:GetHeight()
        )

        local newScroll = self:GetVerticalScroll()
            - delta * ROW_STEP * 3

        newScroll = math.max(
            0,
            math.min(maxScroll, newScroll)
        )

        self:SetVerticalScroll(newScroll)

        if self.ScrollBar then
            self.ScrollBar:SetValue(newScroll)
        end
    end)

    -- Empty list message
    emptyText = parent:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontDisable"
    )

    emptyText:SetPoint("CENTER")
    emptyText:SetText(ns.L.NO_SPELLS)
    emptyText:Hide()

    self.scrollFrame = scrollFrame
    self.scrollChild = scrollChild
end


-- -------------------------------------------------------
-- Refresh
-- -------------------------------------------------------

function SpellList:Refresh()
    if not self.parent or not scrollFrame then
        return
    end

    ClearRows()

    local spells = ns.Database:GetSpells()
    local spellIDs = {}

    for spellID in pairs(spells) do
        table.insert(spellIDs, spellID)
    end

    table.sort(spellIDs)

    -- Empty state
    if #spellIDs == 0 then
        emptyText:SetText(ns.L.NO_SPELLS)
        emptyText:Show()

        scrollFrame:Hide()
        scrollChild:SetHeight(1)

        return
    end

    emptyText:Hide()
    scrollFrame:Show()

    -- Populate rows
    for index, spellID in ipairs(spellIDs) do
        local row = rows[index]

        if not row then
            row = CreateRow(scrollChild, index)
        end

        row:ClearAllPoints()

        row:SetPoint(
            "TOPLEFT",
            scrollChild,
            "TOPLEFT",
            0,
            -((index - 1) * ROW_STEP)
        )

        row:SetPoint(
            "RIGHT",
            scrollChild,
            "RIGHT",
            0,
            0
        )

        local data = spells[spellID]
        local spellName = GetSpellName(spellID)

        if spellName then
            row.name:SetText(
                spellName .. " [" .. spellID .. "]"
            )
        else
            row.name:SetText(
                ns.L.UNKNOWN_SPELL .. " [" .. spellID .. "]"
            )
        end

        row.details:SetText(
            tostring(data.chance or 0)
            .. "% · "
            .. tostring(#(data.quotes or {}))
            .. " "
            .. ns.L.QUOTE_COUNT
        )

        row.spellID = spellID
        row:Show()
    end

    -- Adjust scrollable content height
    local contentHeight = #spellIDs * ROW_STEP - ROW_SPACING

    scrollChild:SetHeight(
        math.max(1, contentHeight)
    )

    UpdateScrollRange()
end
