local addonName, ns = ...

ns.Communication = {}

local Communication = ns.Communication

local PREFIX = "SpellQuotes"

local frame = CreateFrame("Frame")


-- -------------------------------------------------------
-- Player name
-- -------------------------------------------------------

local function GetPlayerName()
    local name, realm = UnitFullName("player")

    if not name then
        return nil
    end

    if realm and realm ~= "" then
        return name .. "-" .. realm
    end

    return name
end


-- -------------------------------------------------------
-- Distribution
-- -------------------------------------------------------

local function GetDistribution()
    if IsInRaid() then
        return "RAID", nil
    end

    if IsInGroup() then
        return "PARTY", nil
    end

    -- Solo mode:
    -- Send the addon message back to ourselves.
    return "WHISPER", GetPlayerName()
end


-- -------------------------------------------------------
-- Display
-- -------------------------------------------------------

function Communication:DisplayQuote(
    sender,
    message
)
    if not sender
        or not message
        or message == ""
    then
        return
    end

    DEFAULT_CHAT_FRAME:AddMessage(
        "|cffb6ff2e[SpellQuotes]|r "
        .. "|cffffd100"
        .. sender
        .. ":|r "
        .. message
    )
end


-- -------------------------------------------------------
-- Sending
-- -------------------------------------------------------

function Communication:SendQuote(quote)
    if not quote or quote == "" then
        return
    end

    local distribution, target =
        GetDistribution()

    local success =
        C_ChatInfo.SendAddonMessage(
            PREFIX,
            quote,
            distribution,
            target
        )

    if success == false then
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffff4040SpellQuotes:|r "
            .. ns.L.COMMUNICATION_ERROR
        )
    end
end


-- -------------------------------------------------------
-- Receiving
-- -------------------------------------------------------

function Communication:HandleMessage(
    prefix,
    message,
    distribution,
    sender
)
    if prefix ~= PREFIX then
        return
    end

    if not message or message == "" then
        return
    end

    self:DisplayQuote(
        sender,
        message
    )
end


-- -------------------------------------------------------
-- Events
-- -------------------------------------------------------

frame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if event ~= "CHAT_MSG_ADDON" then
            return
        end

        local prefix,
            message,
            distribution,
            sender = ...

        Communication:HandleMessage(
            prefix,
            message,
            distribution,
            sender
        )
    end
)


-- -------------------------------------------------------
-- Initialization
-- -------------------------------------------------------

function Communication:Initialize()
    C_ChatInfo.RegisterAddonMessagePrefix(
        PREFIX
    )

    frame:RegisterEvent(
        "CHAT_MSG_ADDON"
    )
end