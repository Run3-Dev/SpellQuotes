local addonName, ns = ...

ns.UI = ns.UI or {}
ns.UI.QuotePopup = {}

local QuotePopup = ns.UI.QuotePopup

local frame
local currentQuote

local function GetSpellInfo(spellID)
    if not spellID then
        return nil, nil
    end

    if not C_Spell or not C_Spell.GetSpellInfo then
        return nil, nil
    end

    local info = C_Spell.GetSpellInfo(spellID)

    if not info then
        return nil, nil
    end

    return info.name, info.iconID
end

function QuotePopup:Create()
    if frame then
        return frame
    end

    frame = CreateFrame(
        "Frame",
        "SpellQuotesQuotePopup",
        UIParent,
        "BackdropTemplate"
    )

    frame:SetSize(360, 105)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, -180)

    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {
            left = 8,
            right = 8,
            top = 8,
            bottom = 8,
        },
    })

    -- Spell icon
    frame.icon = frame:CreateTexture(
        nil,
        "ARTWORK"
    )

    frame.icon:SetSize(36, 36)
    frame.icon:SetPoint("TOPLEFT", 18, -18)

    -- Spell name
    frame.spellName = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    frame.spellName:SetPoint(
        "TOPLEFT",
        frame.icon,
        "TOPRIGHT",
        10,
        -1
    )

    frame.spellName:SetPoint(
        "RIGHT",
        frame,
        "RIGHT",
        -20,
        0
    )

    frame.spellName:SetJustifyH("LEFT")

    -- Quote
    frame.quote = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlight"
    )

    frame.quote:SetPoint(
        "TOPLEFT",
        frame.icon,
        "TOPRIGHT",
        10,
        -19
    )

    frame.quote:SetPoint(
        "RIGHT",
        frame,
        "RIGHT",
        -20,
        0
    )

    frame.quote:SetJustifyH("LEFT")
    frame.quote:SetWordWrap(true)

    -- Say button
    frame.sayButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    frame.sayButton:SetSize(100, 24)

    frame.sayButton:SetPoint(
        "BOTTOMRIGHT",
        frame,
        "BOTTOMRIGHT",
        -18,
        14
    )

    frame.sayButton:SetText("Sagen")

    frame.sayButton:SetScript("OnClick", function()
        if not currentQuote or currentQuote == "" then
            return
        end

        -- This now originates from an actual hardware click.
        SendChatMessage(
            currentQuote,
            "SAY"
        )

        currentQuote = nil

        frame:Hide()
    end)

    -- Dismiss button
    frame.dismissButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    frame.dismissButton:SetSize(100, 24)

    frame.dismissButton:SetPoint(
        "RIGHT",
        frame.sayButton,
        "LEFT",
        -8,
        0
    )

    frame.dismissButton:SetText("Verwerfen")

    frame.dismissButton:SetScript("OnClick", function()
        currentQuote = nil

        frame:Hide()
    end)

    frame:Hide()

    self.frame = frame

    return frame
end

function QuotePopup:ShowQuote(quote, spellID)
    if not frame then
        self:Create()
    end

    if not quote or quote == "" then
        return
    end

    currentQuote = quote

    local spellName, iconID =
        GetSpellInfo(spellID)

    if spellName then
        frame.spellName:SetText(spellName)
    else
        frame.spellName:SetText(
            "Spell " .. tostring(spellID)
        )
    end

    if iconID then
        frame.icon:SetTexture(iconID)
        frame.icon:Show()
    else
        frame.icon:SetTexture(
            "Interface\\Icons\\INV_Misc_QuestionMark"
        )
        frame.icon:Show()
    end

    frame.quote:SetText(
        "\"" .. quote .. "\""
    )

    frame:Show()
end

function QuotePopup:Hide()
    if not frame then
        return
    end

    currentQuote = nil

    frame:Hide()
end