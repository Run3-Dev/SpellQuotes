local addonName, ns = ...

if GetLocale() ~= "deDE" then
    return
end

local L = ns.L

L.TITLE = "SpellQuotes"
L.SUBTITLE = "Zufällige Sprüche beim Einsatz deiner Fähigkeiten"

L.ADD_SPELL = "Spell hinzufügen"
L.EDIT_SPELL = "Spell bearbeiten"
L.DELETE = "Löschen"
L.SAVE = "Speichern"
L.CANCEL = "Abbrechen"

L.SPELL_ID = "Spell-ID"
L.CHANCE = "Chance (%)"
L.QUOTES = "Sprüche"
L.ADD_QUOTE = "Spruch hinzufügen"

L.NO_SPELLS = "Keine Spells konfiguriert."
L.INVALID_SPELL_ID = "Bitte gib eine gültige Spell-ID ein."
L.INVALID_CHANCE = "Die Chance muss zwischen 0 und 100 liegen."
L.NO_QUOTES = "Bitte füge mindestens einen Spruch hinzu."

L.DELETE_CONFIRM = "Diesen Spell löschen?"

L.ENABLED = "Aktiviert"
L.DISABLED = "Deaktiviert"

L.QUOTE_COUNT = "Sprüche"
L.UNKNOWN_SPELL = "Unbekannter Spell"

L.COMMUNICATION_ERROR = "SpellQuotes-Nachricht konnte nicht gesendet werden."