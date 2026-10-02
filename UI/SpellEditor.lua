local addonName, ns = ...

ns.UI = ns.UI or {}
ns.UI.SpellEditor = {}

local SpellEditor = ns.UI.SpellEditor

local editor
local quoteBoxes = {}


-- -------------------------------------------------------
-- Helpers
-- -------------------------------------------------------

local function CreateEditBox(
    parent,
    width
)
    local box =
        CreateFrame(
            "EditBox",
            nil,
            parent,
            "InputBoxTemplate"
        )

    box:SetSize(
        width,
        24
    )

    box:SetAutoFocus(false)

    return box
end


local function Trim(text)
    if not text then
        return ""
    end

    return text:match(
        "^%s*(.-)%s*$"
    )
end


local function ResetQuoteBoxes()
    for _, box in ipairs(quoteBoxes) do
        box:Hide()
        box:SetText("")
    end
end


local function AddQuoteBox(text)
    local index =
        #quoteBoxes + 1

    local box =
        CreateEditBox(
            editor.quoteContainer,
            430
        )

    box:SetPoint(
        "TOPLEFT",
        0,
        -((index - 1) * 30)
    )

    box:SetText(
        text or ""
    )

    quoteBoxes[index] = box

    return box
end


local function GetAvailableQuoteBox()
    for _, box in ipairs(quoteBoxes) do
        if not box:IsShown() then
            return box
        end
    end

    return nil
end


local function ShowQuoteBox(text)
    local box =
        GetAvailableQuoteBox()

    if box then
        box:SetText(
            text or ""
        )

        box:Show()

        return box
    end

    return AddQuoteBox(text)
end


local function CollectQuotes()
    local quotes = {}

    for _, box in ipairs(quoteBoxes) do
        if box:IsShown() then
            local text =
                Trim(box:GetText())

            if text ~= "" then
                table.insert(
                    quotes,
                    text
                )
            end
        end
    end

    return quotes
end


local function ShowError(message)
    UIErrorsFrame:AddMessage(
        message,
        1,
        0.2,
        0.2
    )
end


-- -------------------------------------------------------
-- Create
-- -------------------------------------------------------

function SpellEditor:Create()
    if editor then
        return editor
    end

    editor =
        CreateFrame(
            "Frame",
            "SpellQuotesSpellEditor",
            UIParent,
            "BackdropTemplate"
        )

    editor:SetSize(
        520,
        500
    )

    editor:SetPoint(
        "CENTER"
    )

    editor:SetFrameStrata(
        "DIALOG"
    )

    editor:SetClampedToScreen(
        true
    )

    editor:SetBackdrop({
        bgFile =
            "Interface\\DialogFrame\\UI-DialogBox-Background",

        edgeFile =
            "Interface\\DialogFrame\\UI-DialogBox-Border",

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


    -- ---------------------------------------------------
    -- Title
    -- ---------------------------------------------------

    editor.title =
        editor:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightLarge"
        )

    editor.title:SetPoint(
        "TOPLEFT",
        20,
        -20
    )


    -- ---------------------------------------------------
    -- Spell ID
    -- ---------------------------------------------------

    local spellLabel =
        editor:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormal"
        )

    spellLabel:SetPoint(
        "TOPLEFT",
        20,
        -65
    )

    spellLabel:SetText(
        ns.L.SPELL_ID
    )


    editor.spellID =
        CreateEditBox(
            editor,
            120
        )

    editor.spellID:SetPoint(
        "TOPLEFT",
        20,
        -85
    )

    editor.spellID:SetNumeric(
        true
    )


    -- ---------------------------------------------------
    -- Chance
    -- ---------------------------------------------------

    local chanceLabel =
        editor:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormal"
        )

    chanceLabel:SetPoint(
        "TOPLEFT",
        180,
        -65
    )

    chanceLabel:SetText(
        ns.L.CHANCE
    )


    editor.chance =
        CreateEditBox(
            editor,
            80
        )

    editor.chance:SetPoint(
        "TOPLEFT",
        180,
        -85
    )

    editor.chance:SetNumeric(
        true
    )


    -- ---------------------------------------------------
    -- Quotes
    -- ---------------------------------------------------

    local quotesLabel =
        editor:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormal"
        )

    quotesLabel:SetPoint(
        "TOPLEFT",
        20,
        -135
    )

    quotesLabel:SetText(
        ns.L.QUOTES
    )


    editor.quoteContainer =
        CreateFrame(
            "Frame",
            nil,
            editor
        )

    editor.quoteContainer:SetPoint(
        "TOPLEFT",
        20,
        -160
    )

    editor.quoteContainer:SetSize(
        450,
        230
    )


    -- ---------------------------------------------------
    -- Add Quote
    -- ---------------------------------------------------

    local addQuote =
        CreateFrame(
            "Button",
            nil,
            editor,
            "UIPanelButtonTemplate"
        )

    addQuote:SetSize(
        140,
        24
    )

    addQuote:SetPoint(
        "BOTTOMLEFT",
        20,
        65
    )

    addQuote:SetText(
        ns.L.ADD_QUOTE
    )

    addQuote:SetScript(
        "OnClick",
        function()
            ShowQuoteBox("")
        end
    )


    -- ---------------------------------------------------
    -- Save
    -- ---------------------------------------------------

    local save =
        CreateFrame(
            "Button",
            nil,
            editor,
            "UIPanelButtonTemplate"
        )

    save:SetSize(
        100,
        25
    )

    save:SetPoint(
        "BOTTOMRIGHT",
        -20,
        20
    )

    save:SetText(
        ns.L.SAVE
    )

    save:SetScript(
        "OnClick",
        function()
            local spellID =
                tonumber(
                    editor.spellID:GetText()
                )

            local chance =
                tonumber(
                    editor.chance:GetText()
                )

            if not spellID
                or spellID <= 0
            then
                ShowError(
                    ns.L.INVALID_SPELL_ID
                )

                return
            end

            if not chance
                or chance < 0
                or chance > 100
            then
                ShowError(
                    ns.L.INVALID_CHANCE
                )

                return
            end

            local quotes =
                CollectQuotes()

            if #quotes == 0 then
                ShowError(
                    ns.L.NO_QUOTES
                )

                return
            end


            -- Spell ID changed while editing
            if editor.originalSpellID
                and editor.originalSpellID
                    ~= spellID
            then
                ns.Database:DeleteSpell(
                    editor.originalSpellID
                )
            end


            ns.Database:SaveSpell(
                spellID,
                chance,
                quotes
            )

            editor:Hide()

            ns.UI.SpellList:Refresh()
        end
    )


    -- ---------------------------------------------------
    -- Cancel
    -- ---------------------------------------------------

    local cancel =
        CreateFrame(
            "Button",
            nil,
            editor,
            "UIPanelButtonTemplate"
        )

    cancel:SetSize(
        100,
        25
    )

    cancel:SetPoint(
        "RIGHT",
        save,
        "LEFT",
        -10,
        0
    )

    cancel:SetText(
        ns.L.CANCEL
    )

    cancel:SetScript(
        "OnClick",
        function()
            editor:Hide()
        end
    )


    -- ---------------------------------------------------
    -- Delete
    -- ---------------------------------------------------

    editor.delete =
        CreateFrame(
            "Button",
            nil,
            editor,
            "UIPanelButtonTemplate"
        )

    editor.delete:SetSize(
        100,
        25
    )

    editor.delete:SetPoint(
        "BOTTOMLEFT",
        20,
        20
    )

    editor.delete:SetText(
        ns.L.DELETE
    )

    editor.delete:SetScript(
        "OnClick",
        function()
            if not editor.originalSpellID then
                return
            end

            ns.Database:DeleteSpell(
                editor.originalSpellID
            )

            editor:Hide()

            ns.UI.SpellList:Refresh()
        end
    )

    editor:Hide()

    return editor
end


-- -------------------------------------------------------
-- Open
-- -------------------------------------------------------

function SpellEditor:Open(spellID)
    if not editor then
        self:Create()
    end

    ResetQuoteBoxes()

    editor.originalSpellID =
        spellID


    -- Edit existing spell
    if spellID then
        local data =
            ns.Database:GetSpell(
                spellID
            )

        if not data then
            return
        end

        editor.title:SetText(
            ns.L.EDIT_SPELL
        )

        editor.spellID:SetText(
            tostring(spellID)
        )

        editor.chance:SetText(
            tostring(
                data.chance or 5
            )
        )

        for _, quote in ipairs(
            data.quotes or {}
        ) do
            ShowQuoteBox(
                quote
            )
        end

        editor.delete:Show()


    -- New spell
    else
        editor.title:SetText(
            ns.L.ADD_SPELL
        )

        editor.spellID:SetText("")
        editor.chance:SetText("5")

        ShowQuoteBox("")

        editor.delete:Hide()
    end

    editor:Show()
end