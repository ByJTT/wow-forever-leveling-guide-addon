local ADDON_NAME, ns = ...

ns.ADDON_NAME = ADDON_NAME
ns.VERSION = "0.1.0"
ns.SCHEMA = 1
ns.PREFIX = "|cff4dd0ffForeverLevelingGuide|r"
ns.BYLINE = "by ByJTT"
ns.REPO = "https://github.com/ByJTT/wow-forever-leveling-guide-addon"

local defaults = {
    char = {
        guideKey = nil,
        stepIndex = 1,
        completed = {},
        skipped = {},
    },
    profile = {
        locked = false,
        showArrow = true,
        autoAdvance = true,
        announce = true,
        ui = {
            point = "LEFT",
            relPoint = "LEFT",
            x = 40,
            y = 0,
            width = 380,
            height = 260,
            shown = true,
        },
    },
}

local function DeepCopyDefaults(src, dst)
    if type(src) ~= "table" or type(dst) ~= "table" then return end
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            DeepCopyDefaults(v, dst[k])
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

local function GetPlayerKey()
    local playerName = (UnitName and UnitName("player")) or "Unknown"
    local realmName = (GetRealmName and GetRealmName()) or "Realm"
    return tostring(playerName) .. "-" .. tostring(realmName)
end

local function ToBool(v, fallback)
    if v == nil then return fallback end
    return v and true or false
end

function ns:Print(msg)
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage(self.PREFIX .. ": " .. tostring(msg or ""))
    end
end

function ns:Announce(msg)
    if self.profile and self.profile.announce ~= false then
        self:Print(msg)
    end
end

function ns:GetDB()
    if type(ForeverLevelingGuideDB) ~= "table" then
        ForeverLevelingGuideDB = {}
    end
    local db = ForeverLevelingGuideDB

    if db._schema == nil then db._schema = self.SCHEMA end
    db._version = self.VERSION

    if type(db.chars) ~= "table" then db.chars = {} end
    local charKey = GetPlayerKey()
    if type(db.chars[charKey]) ~= "table" then db.chars[charKey] = {} end
    local charDB = db.chars[charKey]
    DeepCopyDefaults(defaults.char, charDB)
    if type(charDB.completed) ~= "table" then charDB.completed = {} end
    if type(charDB.skipped) ~= "table" then charDB.skipped = {} end
    if type(charDB.stepIndex) ~= "number" or charDB.stepIndex < 1 then charDB.stepIndex = 1 end

    if type(db.profile) ~= "table" then db.profile = {} end
    DeepCopyDefaults(defaults.profile, db.profile)
    if type(db.profile.ui) ~= "table" then
        db.profile.ui = {}
        DeepCopyDefaults(defaults.profile.ui, db.profile.ui)
    end
    db.profile.locked = ToBool(db.profile.locked, defaults.profile.locked)
    db.profile.showArrow = ToBool(db.profile.showArrow, defaults.profile.showArrow)
    db.profile.autoAdvance = ToBool(db.profile.autoAdvance, defaults.profile.autoAdvance)
    db.profile.announce = ToBool(db.profile.announce, defaults.profile.announce)

    self.db = db
    self.charDB = charDB
    self.profile = db.profile
    return db
end

function ns:GetGuide(key)
    if type(key) ~= "string" or type(self.Guides) ~= "table" then return nil end
    return self.Guides[key]
end

function ns:GetCurrentGuide()
    if not self.charDB then return nil, nil end
    local key = self.charDB.guideKey
    local guide = self:GetGuide(key)
    if guide then return guide, key end
    return nil, key
end

function ns:GetSortedGuideKeys()
    local keys = {}
    if type(self.Guides) ~= "table" then return keys end
    for k, g in pairs(self.Guides) do
        if type(k) == "string" and type(g) == "table" then
            keys[#keys + 1] = k
        end
    end
    table.sort(keys, function(a, b)
        local ga = self.Guides[a] or {}
        local gb = self.Guides[b] or {}
        local fa = tostring(ga.faction or "ZZZ")
        local fb = tostring(gb.faction or "ZZZ")
        if fa ~= fb then return fa < fb end
        local la = tonumber(ga.minLevel) or 999
        local lb = tonumber(gb.minLevel) or 999
        if la ~= lb then return la < lb end
        local ta = tostring(ga.title or a)
        local tb = tostring(gb.title or b)
        if ta ~= tb then return ta < tb end
        return tostring(a) < tostring(b)
    end)
    return keys
end

function ns:RefreshUI()
    if self.UI and self.UI.Refresh then self.UI:Refresh() end
    if self.Arrow and self.Arrow.Update then self.Arrow:Update() end
end

function ns:SetGuide(key, opts)
    opts = opts or {}
    if type(key) ~= "string" or key == "" then
        self:Print("Usage: /flg load <key> (see /flg list)")
        return false
    end

    local resolvedKey = key
    local guide = self:GetGuide(resolvedKey)
    if not guide then
        local lower = key:lower()
        if self:GetGuide(lower) then
            resolvedKey = lower
            guide = self:GetGuide(resolvedKey)
        end
    end
    if not guide then
        self:Print("Unknown guide: " .. tostring(key) .. ". Use /flg list.")
        return false
    end
    if not self.charDB then self:GetDB() end

    self.charDB.guideKey = resolvedKey
    if not opts.keepProgress then
        self.charDB.stepIndex = 1
        self.charDB.completed = {}
        self.charDB.skipped = {}
    end

    self:Print("Loaded guide: " .. (guide.title or resolvedKey))
    if self.Engine and self.Engine.Initialize then self.Engine:Initialize() end
    self:RefreshUI()
    return true
end

function ns:PrintGuideList()
    local keys = self:GetSortedGuideKeys()
    if #keys == 0 then
        self:Print("No guides available. Add Data/*.lua routes and include them in the TOC.")
        return
    end
    self:Print("Available guides (" .. #keys .. "):")
    local current = self.charDB and self.charDB.guideKey
    for _, k in ipairs(keys) do
        local g = self.Guides[k]
        local marker = (k == current) and "|cff88ff88*|r" or "-"
        local title = (g and g.title) or k
        local meta = {}
        if g and g.faction then meta[#meta + 1] = tostring(g.faction) end
        if g and g.minLevel and g.maxLevel then
            meta[#meta + 1] = tostring(g.minLevel) .. "-" .. tostring(g.maxLevel)
        elseif g and g.minLevel then
            meta[#meta + 1] = tostring(g.minLevel) .. "+"
        end
        if g and g.scaffold then meta[#meta + 1] = "scaffold" end
        local stepsCount = (g and type(g.steps) == "table" and #g.steps) or 0
        if stepsCount > 0 then meta[#meta + 1] = stepsCount .. " steps" end
        local suffix = (#meta > 0) and (" |cff888888(" .. table.concat(meta, ", ") .. ")|r") or ""
        if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("  %s %s |cff666666[%s]|r%s", marker, title, k, suffix))
        end
    end
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage("  Use: /flg load <key>")
    end
end

function ns:AutoSelectGuide()
    local faction
    if UnitFactionGroup then
        faction = select(1, UnitFactionGroup("player"))
    end
    local level = (UnitLevel and tonumber(UnitLevel("player"))) or 1

    -- Prefer exact 1-10 starter for low-level characters when available.
    if level <= 10 then
        if faction == "Horde" and self:GetGuide("horde_01_10_durotar") then
            return self:SetGuide("horde_01_10_durotar")
        elseif faction == "Alliance" and self:GetGuide("alliance_01_10_elwynn") then
            return self:SetGuide("alliance_01_10_elwynn")
        end
    end

    local keys = self:GetSortedGuideKeys()
    local bestKey, bestScore
    for _, k in ipairs(keys) do
        local g = self.Guides[k]
        if type(g) == "table" then
            local gf = tostring(g.faction or "Neutral")
            local factionOk = (gf == "Neutral") or (faction == nil) or (gf == faction)
            if factionOk then
                local minL = tonumber(g.minLevel) or 1
                local maxL = tonumber(g.maxLevel) or 999
                local inRange = (level >= minL and level <= maxL)
                local center = (minL + maxL) / 2
                local score = 0
                if inRange then score = score + 100 end
                if not g.scaffold then score = score + 15 end
                score = score - math.abs(level - center)
                if (bestScore == nil) or score > bestScore then
                    bestScore = score
                    bestKey = k
                end
            end
        end
    end

    if bestKey then
        return self:SetGuide(bestKey)
    end
    if #keys == 1 then
        return self:SetGuide(keys[1])
    end
    return false
end

function ns:GetSuggestedGuideKey()
    local guide, currentKey = self:GetCurrentGuide()
    local faction = guide and guide.faction
    if not faction and UnitFactionGroup then
        faction = select(1, UnitFactionGroup("player"))
    end
    local level = (UnitLevel and tonumber(UnitLevel("player"))) or 1
    local guideMax = guide and tonumber(guide.maxLevel) or level
    local target = math.max(level, guideMax)

    local keys = self:GetSortedGuideKeys()
    local bestKey, bestScore
    for _, k in ipairs(keys) do
        if k ~= currentKey then
            local g = self.Guides[k]
            if type(g) == "table" then
                local gf = tostring(g.faction or "Neutral")
                local factionOk = (gf == "Neutral") or (faction == nil) or (gf == faction)
                if factionOk then
                    local minL = tonumber(g.minLevel) or 1
                    local maxL = tonumber(g.maxLevel) or 999
                    local inRange = (target >= minL and target <= maxL)
                    local startsNear = math.abs(minL - target)
                    local score = 0
                    if inRange then score = score + 100 end
                    -- Prefer the next bracket/continuation when out of range.
                    if (not inRange) and minL >= target then score = score + 60 - math.min(startsNear, 60) end
                    if not g.scaffold then score = score + 10 end
                    score = score - (startsNear * 0.25)
                    if (bestScore == nil) or score > bestScore then
                        bestScore = score
                        bestKey = k
                    end
                end
            end
        end
    end
    return bestKey
end

function ns:PrintSuggestedGuide(prefix)
    local key = self:GetSuggestedGuideKey()
    if not key then return false end
    local g = self:GetGuide(key)
    local title = (g and g.title) or key
    local msg = "Suggested next: " .. title .. " |cff666666[" .. key .. "]|r"
    if g and g.scaffold then msg = msg .. " |cff888888(scaffold/WIP)|r" end
    if prefix and prefix ~= "" then msg = tostring(prefix) .. " " .. msg end
    self:Print(msg .. "  Use: /flg load " .. key)
    return true
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        ns:GetDB()
        if ns.OnInit then ns:OnInit() end
    elseif event == "PLAYER_LOGIN" then
        if ns.OnLogin then ns:OnLogin() end
    end
end)

SLASH_FOREVERLEVELINGGUIDE1 = "/flg"
SLASH_FOREVERLEVELINGGUIDE2 = "/levelguide"
SLASH_FOREVERLEVELINGGUIDE3 = "/journey"
SLASH_FOREVERLEVELINGGUIDE4 = "/jf"

SlashCmdList.FOREVERLEVELINGGUIDE = function(msg)
    msg = tostring(msg or "")
    msg = msg:gsub("^%s+", ""):gsub("%s+$", "")
    local cmd, rest = msg:match("^(%S+)%s*(.-)%s*$")
    cmd = (cmd or ""):lower()
    rest = tostring(rest or "")

    if not ns.db then ns:GetDB() end
    if not ns.charDB or not ns.profile then ns:GetDB() end

    if cmd == "" or cmd == "show" or cmd == "config" or cmd == "open" then
        if ns.UI and ns.UI.Show then ns.UI:Show() end
    elseif cmd == "hide" or cmd == "close" then
        if ns.UI and ns.UI.Hide then ns.UI:Hide() end
    elseif cmd == "toggle" then
        if ns.UI and ns.UI.Toggle then ns.UI:Toggle() end
    elseif cmd == "next" or cmd == "n" then
        if ns.Engine and ns.Engine.NextStep then ns.Engine:NextStep("manual") end
    elseif cmd == "prev" or cmd == "previous" or cmd == "back" or cmd == "p" then
        if ns.Engine and ns.Engine.PrevStep then ns.Engine:PrevStep() end
    elseif cmd == "skip" then
        if ns.Engine and ns.Engine.SkipStep then ns.Engine:SkipStep() end
    elseif cmd == "reset" then
        if ns.Engine and ns.Engine.ResetProgress then ns.Engine:ResetProgress() end
    elseif cmd == "list" or cmd == "guides" then
        ns:PrintGuideList()
    elseif cmd == "load" or cmd == "set" then
        if rest == "" then
            ns:Print("Usage: /flg load <key> (see /flg list)")
        else
            ns:SetGuide(rest)
        end
    elseif cmd == "arrow" then
        ns.profile.showArrow = not ns.profile.showArrow
        ns:Print("Navigation arrow: " .. (ns.profile.showArrow and "|cff88ff88ON|r" or "|cffff8888OFF|r"))
        if ns.Arrow and ns.Arrow.Update then ns.Arrow:Update() end
    elseif cmd == "auto" or cmd == "autoadvance" then
        ns.profile.autoAdvance = not ns.profile.autoAdvance
        ns:Print("Auto-advance: " .. (ns.profile.autoAdvance and "|cff88ff88ON|r" or "|cffff8888OFF|r"))
        if ns.profile.autoAdvance and ns.Engine and ns.Engine.EvaluateCurrent then
            ns.Engine:EvaluateCurrent("toggle")
        end
    elseif cmd == "announce" then
        ns.profile.announce = not ns.profile.announce
        ns:Print("Chat announcements: " .. (ns.profile.announce and "|cff88ff88ON|r" or "|cffff8888OFF|r"))
    elseif cmd == "where" or cmd == "status" or cmd == "current" then
        if ns.UI and ns.UI.PrintStatus then ns.UI:PrintStatus() end
    elseif cmd == "suggest" or cmd == "nextguide" then
        if not ns:PrintSuggestedGuide() then
            ns:Print("No suggested next guide found. Use /flg list.")
        end
    elseif cmd == "debug" then
        local guide, key = ns:GetCurrentGuide()
        local total = (guide and type(guide.steps) == "table" and #guide.steps) or 0
        local idx = (ns.charDB and tonumber(ns.charDB.stepIndex)) or 1
        local step = (guide and type(guide.steps) == "table") and guide.steps[idx] or nil
        local stepType = "n/a"
        if type(step) == "table" then
            stepType = tostring(step.type or step.kind or "note")
        elseif idx > total and total > 0 then
            stepType = "complete"
        end
        local playerLevel = (UnitLevel and tonumber(UnitLevel("player"))) or "?"
        local faction = "?"
        if UnitFactionGroup then faction = select(1, UnitFactionGroup("player")) or "?" end
        ns:Print("Debug - " .. tostring(ns.ADDON_NAME) .. " v" .. tostring(ns.VERSION) .. " (schema " .. tostring(ns.SCHEMA) .. ")")
        ns:Print("Player: " .. tostring(faction) .. " level " .. tostring(playerLevel))
        ns:Print("Guide: " .. tostring(key or "none") .. " | step " .. tostring(idx) .. "/" .. tostring(total) .. " | type: " .. stepType)
        ns:Print("Settings: arrow=" .. tostring(ns.profile.showArrow) .. " auto=" .. tostring(ns.profile.autoAdvance) .. " announce=" .. tostring(ns.profile.announce) .. " locked=" .. tostring(ns.profile.locked))
        ns:Print("Guides loaded: " .. tostring(#ns:GetSortedGuideKeys()))
        if guide and guide.title then ns:Print("Current title: " .. tostring(guide.title)) end
        if guide and guide.scaffold then ns:Print("Note: this is an original scaffold route (WIP). Verify and expand steps for your WoW Forever build.") end
        local suggested = ns:GetSuggestedGuideKey()
        if suggested then ns:Print("Suggested next: " .. tostring(suggested)) end
    elseif cmd == "help" or cmd == "?" then
        ns:Print("ForeverLevelingGuide " .. ns.BYLINE .. " (v" .. ns.VERSION .. ")")
        ns:Print("Commands:")
        ns:Print("  /flg               - show guide panel")
        ns:Print("  /flg show|hide|toggle - panel visibility")
        ns:Print("  /flg list          - list available guides")
        ns:Print("  /flg load <key>    - load a guide")
        ns:Print("  /flg next|prev|skip|reset - step controls")
        ns:Print("  /flg arrow         - toggle navigation arrow")
        ns:Print("  /flg auto          - toggle auto-advance")
        ns:Print("  /flg announce      - toggle chat announcements")
        ns:Print("  /flg where         - print current guide/step")
        ns:Print("  /flg suggest       - suggest a next guide for your level/faction")
        ns:Print("  /flg debug         - diagnostics")
        ns:Print("Aliases: /levelguide, /journey, /jf")
    else
        ns:Print("Unknown command: " .. tostring(cmd) .. ". Try /flg help")
    end
end

function ns:OnInit()
    self.Guides = self.Guides or {}
    if self.RegisterBundledGuides then self:RegisterBundledGuides() end
end

function ns:OnLogin()
    if not self.db then self:GetDB() end

    if self.charDB and self.charDB.guideKey and not self:GetGuide(self.charDB.guideKey) then
        self.charDB.guideKey = nil
        self.charDB.stepIndex = 1
        self.charDB.completed = {}
        self.charDB.skipped = {}
    end

    if self.charDB and not self.charDB.guideKey then
        local loaded = self:AutoSelectGuide()
        if not loaded then
            self:Print("No guide loaded. Use /flg list then /flg load <key>.")
        end
    end

    if self.Engine and self.Engine.Initialize then self.Engine:Initialize() end
    if self.Tracker and self.Tracker.Initialize then self.Tracker:Initialize() end
    if self.UI and self.UI.Initialize then self.UI:Initialize() end
    if self.Arrow and self.Arrow.Initialize then self.Arrow:Initialize() end

    self:Print("Loaded v" .. self.VERSION .. " " .. self.BYLINE .. ". Type /flg for help.")
end
