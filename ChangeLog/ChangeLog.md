# Changelog

All notable changes to **SpellQuotes (by run3_)** will be documented in this file.

---

## [0.3.0] - 2026-10-02

### Added

- Initial release of **SpellQuotes**.
- Added support for **World of Warcraft: Forever**.
- Added compatibility structure for **Retail / Mainline**.
- Added automatic detection of successful player spell casts.
- Added configurable quotes for individual Spell IDs.
- Added configurable trigger chance from **0% to 100%** for each spell.
- Added support for multiple quotes per spell with random selection.
- Added an in-game configuration interface.
- Added the ability to:
  - Add new spells.
  - Edit existing spells.
  - Delete configured spells.
  - Add multiple quotes to a spell.
  - Enable or disable SpellQuotes globally.
- Added persistent configuration using SavedVariables.
- Added automatic spell name lookup using the modern `C_Spell` API.
- Added Spell ID information to spell tooltips.
- Added German and English localization with English fallback.
- Added automatic SpellQuotes communication between addon users:
  - Solo players use a self-whisper addon message.
  - Party members use the `PARTY` addon channel.
  - Raid members use the `RAID` addon channel.
- Added local chat display for received SpellQuotes messages.
- Added `/spellquotes` and `/sq` commands to open the configuration interface.

### Technical

- Built around the modern World of Warcraft API.
- Uses `UNIT_SPELLCAST_SUCCEEDED` for player spell detection.
- Uses `C_ChatInfo.SendAddonMessage()` for quote distribution.
- Uses `CHAT_MSG_ADDON` for receiving SpellQuotes messages.
- Uses `TooltipDataProcessor` for Spell ID tooltip integration.
- Avoids Combat Log dependencies.
- Includes Secret Value handling for compatibility with the restricted Forever addon environment.
- Modular architecture separating:
  - Database
  - Spell detection
  - Addon communication
  - Tooltip handling
  - User interface
  - Localization