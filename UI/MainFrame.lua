local addonName, ns = ...

ns.UI = ns.UI or {}
ns.UI.MainFrame = {}

local MainFrame = ns.UI.MainFrame

local frame

function MainFrame:Create()
    if frame then
        return frame
    end

    frame = CreateFrame(
        "Frame",
        nil,
        UIParent,
        "BackdropTemplate"
    )

    frame:SetSize(620, 500)
    frame:SetPoint("CENTER")

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

    local title = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlightLarge"
    )

    title:SetPoint("TOPLEFT", 20, -18)
    title:SetText(ns.L.TITLE)

    local subtitle = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    subtitle:SetText(ns.L.SUBTITLE)

    local closeButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelCloseButton"
    )

    closeButton:SetPoint("TOPRIGHT", -5, -5)

    local enabled = CreateFrame(
        "CheckButton",
        nil,
        frame,
        "UICheckButtonTemplate"
    )

    enabled:SetPoint("TOPRIGHT", -55, -48)

    enabled.text = enabled:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    enabled.text:SetPoint("RIGHT", enabled, "LEFT", -4, 0)
    enabled.text:SetText(ns.L.ENABLED)

    enabled:SetScript("OnClick", function(self)
        ns.Database:SetEnabled(self:GetChecked())
    end)

    frame:SetScript("OnShow", function()
        enabled:SetChecked(ns.Database:IsEnabled())

        if ns.UI.SpellList then
            ns.UI.SpellList:Refresh()
        end
    end)

    local addButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    addButton:SetSize(140, 25)
    addButton:SetPoint("BOTTOMRIGHT", -20, 20)
    addButton:SetText(ns.L.ADD_SPELL)

    addButton:SetScript("OnClick", function()
        ns.UI.SpellEditor:Open()
    end)

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 20, -80)
    frame.content:SetPoint("BOTTOMRIGHT", -20, 60)

    frame:Hide()

    self.frame = frame

    return frame
end

function MainFrame:Toggle()
    if not frame then
        self:Create()
    end

    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

function MainFrame:GetContentFrame()
    return frame and frame.content
end