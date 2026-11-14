local ADDON_NAME, ns = ...

ns.ADDON_NAME = ADDON_NAME
ns.VERSION = "0.2.0"
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
        manualWaypoint = nil, -- { mapID, x, y, title, zone, source }
    },
    profile = {
        locked = false,
        showArrow = true,
        autoAdvance = true,
        announce = true,
        updateNotify = true,
        ui = {
            point = "LEFT",
            relPoint = "LEFT",
            x = 40,
            y = 0,
            width = 380,
            height = 260,
            shown = true,
        },
        minimap = {
            hide = false,
            angle = 220,
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
    if type(db.profile.minimap) ~= "table" then
        db.profile.minimap = {}
        DeepCopyDefaults(defaults.profile.minimap, db.profile.minimap)
    end
    db.profile.locked = ToBool(db.profile.locked, defaults.profile.locked)
    db.profile.showArrow = ToBool(db.profile.showArrow, defaults.profile.showArrow)
    db.profile.autoAdvance = ToBool(db.profile.autoAdvance, defaults.profile.autoAdvance)
    db.profile.announce = ToBool(db.profile.announce, defaults.profile.announce)
    if type(db.profile.updateNotify) ~= "boolean" then db.profile.updateNotify = defaults.profile.updateNotify end
    if type(db.profile.minimap.hide) ~= "boolean" then db.profile.minimap.hide = defaults.profile.minimap.hide end
    db.profile.minimap.angle = tonumber(db.profile.minimap.angle) or defaults.profile.minimap.angle

    if charDB.manualWaypoint ~= nil and type(charDB.manualWaypoint) ~= "table" then
        charDB.manualWaypoint = nil
    end

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

function ns:GetNextGuideKey()
    local guide, currentKey = self:GetCurrentGuide()
    if type(guide) ~= "table" then return nil end
    local nextKey = guide.next or guide.nextGuide or guide.nextKey
    if type(nextKey) ~= "string" or nextKey == "" or nextKey == currentKey then return nil end

    local resolved = nextKey
    local nextGuide = self:GetGuide(resolved)
    if not nextGuide then
        local lower = nextKey:lower()
        if self:GetGuide(lower) then
            resolved = lower
            nextGuide = self:GetGuide(resolved)
        end
    end
    if type(nextGuide) ~= "table" then return nil end

    local pfaction
    if UnitFactionGroup then pfaction = select(1, UnitFactionGroup("player")) end
    local gf = tostring(nextGuide.faction or "Neutral")
    if not ((gf == "Neutral") or (pfaction == nil) or (gf == pfaction)) then
        return nil
    end
    return resolved
end

function ns:GetSuggestedGuideKey()
    local chained = self:GetNextGuideKey()
    if chained then return chained end

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
    local guide, _ = self:GetCurrentGuide()
    local chained = guide and (guide.next == key or guide.nextGuide == key or guide.nextKey == key)
    local label = chained and "Next guide" or "Suggested next"
    local msg = label .. ": " .. title .. " |cff666666[" .. key .. "]|r"
    if g and g.scaffold then msg = msg .. " |cff888888(scaffold/WIP)|r" end
    if prefix and prefix ~= "" then msg = tostring(prefix) .. " " .. msg end
    self:Print(msg .. "  Use: /flg continue (or /flg load " .. key .. ")")
    return true
end

local function SafeToString(v)
    if v == nil then return "nil" end
    local t = type(v)
    if t == "string" or t == "number" or t == "boolean" then return tostring(v) end
    local ok, s = pcall(tostring, v)
    if ok and s then return s end
    return "<" .. t .. ">"
end

local function SafePCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if ok then return a, b, c, d end
    return nil
end

--------------------------------------------------------------------------------
-- Update notifier (peer version check via addon comms; no internet/self-update)
-- Best-effort: broadcasts this addon's version to group/raid/instance/guild and
-- notifies once per session if a peer reports a newer version. Does not check
-- CurseForge/GitHub directly and cannot auto-update; use CurseForge/WowUp/Wago
-- (when released) or the repo page for actual updates.
--------------------------------------------------------------------------------
ns.UPDATE_COMM_PREFIX = "BYJTTVER"
ns.UPDATE_ADDON_KEY = ns.ADDON_NAME or ADDON_NAME or "ForeverLevelingGuide"

local function UP_GetTime()
    if type(GetTime) == "function" then
        local t = SafePCall(GetTime)
        if type(t) == "number" then return t end
    end
    return 0
end

local function UP_ParseVersion(v)
    local t = {}
    if type(v) ~= "string" then v = tostring(v or "") end
    for n in v:gmatch("(%d+)") do
        t[#t + 1] = tonumber(n) or 0
    end
    if #t == 0 then t[1] = 0 end
    return t
end

function ns:IsVersionNewer(remote, localv)
    local r, l = UP_ParseVersion(remote), UP_ParseVersion(localv or self.VERSION)
    local n = math.max(#r, #l)
    for i = 1, n do
        local rv, lv = r[i] or 0, l[i] or 0
        if rv > lv then return true end
        if rv < lv then return false end
    end
    return false
end

local function UP_PlayerName()
    if type(UnitName) ~= "function" then return nil end
    local name = SafePCall(UnitName, "player")
    if type(name) ~= "string" or name == "" then return nil end
    return name
end

local function UP_IsSelfSender(sender)
    if type(sender) ~= "string" or sender == "" then return false end
    local me = UP_PlayerName()
    if not me then return false end
    if sender == me then return true end
    local sshort = sender:match("^([^%-]+)") or sender
    if sshort == me then return true end
    if type(Ambiguate) == "function" then
        local a = SafePCall(Ambiguate, sender, "short")
        if a == me then return true end
    end
    return false
end

function ns:RegisterUpdatePrefix()
    if self._updatePrefixRegistered then return true end
    local prefix = self.UPDATE_COMM_PREFIX
    local ok = false
    if C_ChatInfo and type(C_ChatInfo.RegisterAddonMessagePrefix) == "function" then
        ok = SafePCall(C_ChatInfo.RegisterAddonMessagePrefix, prefix) ~= nil or true
        if C_ChatInfo.IsAddonMessagePrefixRegistered then
            local reg = SafePCall(C_ChatInfo.IsAddonMessagePrefixRegistered, prefix)
            if reg ~= nil then ok = reg and true or ok end
        end
    elseif type(RegisterAddonMessagePrefix) == "function" then
        ok = SafePCall(RegisterAddonMessagePrefix, prefix) ~= nil or true
    end
    self._updatePrefixRegistered = ok and true or false
    return self._updatePrefixRegistered
end

local function UP_CanChatSend()
    local inInstance = false
    if type(IsInGroup) == "function" and type(LE_PARTY_CATEGORY_INSTANCE) == "number" then
        inInstance = SafePCall(IsInGroup, LE_PARTY_CATEGORY_INSTANCE) and true or false
    elseif type(IsInInstance) == "function" then
        local _, it = SafePCall(IsInInstance)
        inInstance = (it == "party" or it == "raid" or it == "scenario" or it == "pvp" or it == "arena")
    end
    local inRaid = type(IsInRaid) == "function" and SafePCall(IsInRaid) and true or false
    local inParty = type(IsInGroup) == "function" and SafePCall(IsInGroup) and true or false
    local inGuild = type(IsInGuild) == "function" and SafePCall(IsInGuild) and true or false
    if type(GetNumGroupMembers) == "function" then
        local n = SafePCall(GetNumGroupMembers) or 0
        if n <= 1 then inRaid, inParty = false, false end
    elseif type(GetNumRaidMembers) == "function" or type(GetNumPartyMembers) == "function" then
        local rn = (type(GetNumRaidMembers) == "function" and SafePCall(GetNumRaidMembers)) or 0
        local pn = (type(GetNumPartyMembers) == "function" and SafePCall(GetNumPartyMembers)) or 0
        if rn <= 0 then inRaid = false end
        if pn <= 0 and rn <= 0 then inParty = false end
    end
    return inInstance, inRaid, inParty, inGuild
end

function ns:BroadcastVersionUpdate(force)
    if self.profile and self.profile.updateNotify == false then return false end
    self:RegisterUpdatePrefix()
    local now = UP_GetTime()
    local last = tonumber(self._updateLastSend) or 0
    local minGap = 60
    if not force and (now - last) < minGap then return false end

    local prefix = self.UPDATE_COMM_PREFIX
    local msg = tostring(self.UPDATE_ADDON_KEY or self.ADDON_NAME or "Addon") .. ":" .. tostring(self.VERSION or "0")
    local sentAny = false

    local function send(chatType)
        if not chatType then return false end
        if C_ChatInfo and type(C_ChatInfo.SendAddonMessage) == "function" then
            local ok = pcall(C_ChatInfo.SendAddonMessage, prefix, msg, chatType)
            return ok and true or false
        elseif type(SendAddonMessage) == "function" then
            local ok = pcall(SendAddonMessage, prefix, msg, chatType)
            return ok and true or false
        end
        return false
    end

    local inInstance, inRaid, inParty, inGuild = UP_CanChatSend()
    if inInstance then sentAny = send("INSTANCE_CHAT") or sentAny end
    if inRaid then sentAny = send("RAID") or sentAny end
    if inParty and not inRaid then sentAny = send("PARTY") or sentAny end
    if inGuild then sentAny = send("GUILD") or sentAny end

    self._updateLastSend = now
    if sentAny then self._updateLastSentAny = true end
    self._updateReady = true
    return sentAny
end

function ns:ScheduleVersionBroadcast(delay, force)
    if self.profile and self.profile.updateNotify == false then return end
    local d = tonumber(delay) or 8
    local function run()
        if not self.profile or self.profile.updateNotify == false then return end
        self:BroadcastVersionUpdate(force and true or false)
    end
    if C_Timer and type(C_Timer.After) == "function" then
        SafePCall(C_Timer.After, d, run)
    else
        local f = self._updateDelayFrame
        if not f and type(CreateFrame) == "function" then
            f = CreateFrame("Frame")
            self._updateDelayFrame = f
        end
        if f then
            f._t = 0
            f._d = d
            f:SetScript("OnUpdate", function(fr, elapsed)
                fr._t = (fr._t or 0) + (elapsed or 0)
                if fr._t >= (fr._d or 0) then
                    fr:SetScript("OnUpdate", nil)
                    run()
                end
            end)
        else
            run()
        end
    end
end

function ns:HandleVersionAddonMessage(prefix, message, channel, sender)
    if prefix ~= self.UPDATE_COMM_PREFIX then return end
    if type(message) ~= "string" or message == "" then return end
    if UP_IsSelfSender(sender) then return end
    local key, ver = message:match("^([^:]+):(.+)$")
    if not key or not ver then return end
    local myKey = tostring(self.UPDATE_ADDON_KEY or self.ADDON_NAME or "")
    if key ~= myKey then return end

    local mine = tostring(self.VERSION or "0")
    if self:IsVersionNewer(ver, mine) then
        self._updateNewest = ver
        if self.profile and self.profile.updateNotify ~= false and self._updateNotified ~= ver then
            self._updateNotified = ver
            local name = tostring(self.ADDON_NAME or "ForeverLevelingGuide")
            local repo = tostring(self.REPO or "https://github.com/ByJTT/wow-forever-leveling-guide-addon")
            self:Print("|cff88ddffUpdate available:|r " .. name .. " v" .. tostring(ver) .. " (you have v" .. mine .. "). Update via CurseForge/WowUp/Wago when released, or: " .. repo)
        end
    end
end

local function NormalizeCoord01(v)
    local n = tonumber(v)
    if n == nil then return nil end
    if n > 1 then n = n / 100 end
    return n
end

local function ToNumber(v)
    local n = tonumber(v)
    if n == nil then return nil end
    return n
end
ns.ToNumber = ToNumber

function ns:GetManualWaypoint()
    local mw = self.charDB and self.charDB.manualWaypoint
    if type(mw) ~= "table" then return nil, nil, nil, nil, nil end
    local mapID = tonumber(mw.mapID)
    local x = NormalizeCoord01(mw.x)
    local y = NormalizeCoord01(mw.y)
    if not mapID or not x or not y then return nil, nil, nil, nil, nil end
    local title = tostring(mw.title or "Manual waypoint")
    local zone = mw.zone and tostring(mw.zone) or nil
    return mapID, x, y, title, zone
end

function ns:GetPlayerLocationDebug()
    local info = {
        mapID = nil,
        x = nil,
        y = nil,
        zone = (GetZoneText and SafePCall(GetZoneText)) or nil,
        subZone = (GetSubZoneText and SafePCall(GetSubZoneText)) or nil,
        minimapZone = (GetMinimapZoneText and SafePCall(GetMinimapZoneText)) or nil,
        realZone = (GetRealZoneText and SafePCall(GetRealZoneText)) or nil,
    }

    if C_Map and type(C_Map.GetBestMapForUnit) == "function" then
        local mapID = SafePCall(C_Map.GetBestMapForUnit, "player")
        if tonumber(mapID) then info.mapID = tonumber(mapID) end
    end

    if info.mapID and C_Map and type(C_Map.GetPlayerMapPosition) == "function" then
        local pos = SafePCall(C_Map.GetPlayerMapPosition, info.mapID, "player")
        if pos then
            local x, y = pos.x, pos.y
            if (x == nil or y == nil) and type(pos.GetXY) == "function" then
                local ax, ay = SafePCall(pos.GetXY, pos)
                x, y = ax, ay
            end
            if type(x) == "number" then info.x = x end
            if type(y) == "number" then info.y = y end
        end
    end

    return info
end

function ns:BuildDebugReport()
    local lines = {}
    local function add(s) lines[#lines + 1] = SafeToString(s) end

    add("ForeverLevelingGuide debug export")
    add("Addon: " .. SafeToString(self.ADDON_NAME) .. " v" .. SafeToString(self.VERSION) .. " (schema " .. SafeToString(self.SCHEMA) .. ")")
    add("By: " .. SafeToString(self.BYLINE) .. "  Repo: " .. SafeToString(self.REPO))
    add("Generated: " .. SafeToString(date and date("%Y-%m-%d %H:%M:%S") or "n/a"))

    local buildVersion, buildNumber, buildDate, interfaceVersion
    if type(GetBuildInfo) == "function" then
        buildVersion, buildNumber, buildDate, interfaceVersion = SafePCall(GetBuildInfo)
        if buildVersion == nil then
            buildVersion, buildNumber, buildDate, interfaceVersion = GetBuildInfo()
        end
    end
    if buildVersion or interfaceVersion then
        add("Client: version=" .. SafeToString(buildVersion) .. " build=" .. SafeToString(buildNumber) .. " date=" .. SafeToString(buildDate) .. " interface=" .. SafeToString(interfaceVersion))
    end
    add("Locale: " .. SafeToString((GetLocale and SafePCall(GetLocale)) or "n/a"))

    local faction = "?"
    if UnitFactionGroup then faction = select(1, UnitFactionGroup("player")) or "?" end
    local race = (UnitRace and select(1, UnitRace("player"))) or "?"
    local className = (UnitClass and select(1, UnitClass("player"))) or "?"
    local level = (UnitLevel and SafePCall(UnitLevel, "player")) or "?"
    add("")
    add("[Player]")
    add("Faction: " .. SafeToString(faction) .. "  Race: " .. SafeToString(race) .. "  Class: " .. SafeToString(className) .. "  Level: " .. SafeToString(level))

    local loc = self:GetPlayerLocationDebug() or {}
    local function fmt01(v)
        if type(v) ~= "number" then return "n/a" end
        return string.format("%.4f (%.1f%%)", v, v * 100)
    end
    add("Zone: " .. SafeToString(loc.zone) .. " / " .. SafeToString(loc.subZone) .. " / " .. SafeToString(loc.minimapZone) .. " / " .. SafeToString(loc.realZone))
    add("Map: " .. SafeToString(loc.mapID) .. "  X: " .. fmt01(loc.x) .. "  Y: " .. fmt01(loc.y))

    local db = self.db
    local charDB = self.charDB
    local profile = self.profile
    local keys = (self.GetSortedGuideKeys and self:GetSortedGuideKeys()) or {}
    local guide, key = self:GetCurrentGuide()
    local total = (guide and type(guide.steps) == "table" and #guide.steps) or 0
    local idx = (charDB and tonumber(charDB.stepIndex)) or 1

    add("")
    add("[State]")
    add("DB schema: " .. SafeToString(db and db._schema) .. "  DB version: " .. SafeToString(db and db._version))
    add("Guides loaded: " .. SafeToString(#keys))
    add("Current guide key: " .. SafeToString(key))
    add("Step index: " .. SafeToString(idx) .. " / " .. SafeToString(total))
    add("Settings: arrow=" .. SafeToString(profile and profile.showArrow) .. " autoAdvance=" .. SafeToString(profile and profile.autoAdvance) .. " announce=" .. SafeToString(profile and profile.announce) .. " updateNotify=" .. SafeToString(profile and profile.updateNotify) .. " locked=" .. SafeToString(profile and profile.locked))
    if profile and profile.minimap then
        add("Minimap: hide=" .. SafeToString(profile.minimap.hide) .. " angle=" .. SafeToString(profile.minimap.angle))
    end
    if profile and profile.ui then
        add("UI: shown=" .. SafeToString(profile.ui.shown) .. " point=" .. SafeToString(profile.ui.point) .. " relPoint=" .. SafeToString(profile.ui.relPoint) .. " x=" .. SafeToString(profile.ui.x) .. " y=" .. SafeToString(profile.ui.y) .. " w=" .. SafeToString(profile.ui.width) .. " h=" .. SafeToString(profile.ui.height))
    end

    if guide then
        add("")
        add("[Guide]")
        add("Title: " .. SafeToString(guide.title or key))
        add("Faction: " .. SafeToString(guide.faction) .. "  Range: " .. SafeToString(guide.minLevel) .. "-" .. SafeToString(guide.maxLevel) .. "  Scaffold: " .. SafeToString(guide.scaffold))
        add("Chain next: " .. SafeToString(guide.next or guide.nextGuide or guide.nextKey))
        add("Resolved next: " .. SafeToString(self.GetNextGuideKey and self:GetNextGuideKey() or nil))
        add("Suggested: " .. SafeToString(self.GetSuggestedGuideKey and self:GetSuggestedGuideKey() or nil))
    end

    local step = nil
    if guide and type(guide.steps) == "table" and idx >= 1 and idx <= total then
        step = guide.steps[idx]
    end
    add("")
    add("[Current Step]")
    if not guide then
        add("No guide loaded.")
    elseif idx > total and total > 0 then
        add("Guide complete (index past last step).")
    elseif type(step) ~= "table" then
        add("No active step.")
    else
        local stype = SafeToString(step.type or step.kind or "note")
        local title = "Step"
        if self.Engine and self.Engine.GetStepTitle then
            title = self.Engine:GetStepTitle(step, idx)
        else
            title = step.title or step.name or step.text or step.desc or title
        end
        add("Index: " .. SafeToString(idx) .. "  Type: " .. stype .. "  Title: " .. SafeToString(title))
        add("Quest: " .. SafeToString(step.quest or step.questID or step.questId or step.id))
        add("Item: " .. SafeToString(step.item or step.itemID or step.itemId or step.itemName) .. "  Count: " .. SafeToString(step.count or step.amount or step.quantity or step.qty or step.need or step.required))
        add("Level target: " .. SafeToString(step.level or step.toLevel or step.value or step.at or step.required))
        add("NPC/Target: " .. SafeToString(step.npc or step.target or step.object or step.unit))
        add("Zone: " .. SafeToString(step.zone or step.area or step.subzone))

        local c = step.coords
        if type(c) == "table" then
            local mapID = c.mapID or c.mapId or c.map or c.uiMapID
            local cx = c.x or c.X
            local cy = c.y or c.Y
            local nx = NormalizeCoord01(cx)
            local ny = NormalizeCoord01(cy)
            add("Coords: mapID=" .. SafeToString(mapID) .. " x=" .. SafeToString(cx) .. " y=" .. SafeToString(cy) .. " (normalized x=" .. SafeToString(nx) .. " y=" .. SafeToString(ny) .. ")")
            add("Radius: " .. SafeToString(step.radius))
            if self.Engine and self.Engine.IsPlayerNear then
                local near = self.Engine:IsPlayerNear(step, step.radius or 0.03)
                add("IsPlayerNear: " .. SafeToString(near))
            end
            if tonumber(mapID) and type(nx) == "number" and type(ny) == "number" and type(loc.mapID) == "number" and tonumber(mapID) ~= loc.mapID then
                add("Note: step mapID differs from player's current mapID (arrival/arrow may be unavailable).")
            end
        else
            add("Coords: none")
        end

        local note = step.note or step.desc or step.description
        if note and note ~= "" then add("Note: " .. SafeToString(note)) end
        local tip = step.tip
        if tip and tip ~= "" then add("Tip: " .. SafeToString(tip)) end

        if self.Engine and self.Engine.StepSatisfied then
            local sat = self.Engine:StepSatisfied(step)
            add("StepSatisfied (engine): " .. SafeToString(sat))
        end
        local completed = (charDB and type(charDB.completed) == "table" and charDB.completed[idx] == true) or false
        local skipped = (charDB and type(charDB.skipped) == "table" and charDB.skipped[idx] == true) or false
        add("Marked completed: " .. SafeToString(completed) .. "  Skipped: " .. SafeToString(skipped))
    end

    add("")
    add("[Arrow]")
    if self.Arrow then
        local a = self.Arrow
        add("Arrow enabled: " .. SafeToString(a.enabled) .. "  profile.showArrow: " .. SafeToString(profile and profile.showArrow))
        if a.target then
            add("Target: mapID=" .. SafeToString(a.target.mapID) .. " x=" .. SafeToString(a.target.x) .. " y=" .. SafeToString(a.target.y) .. " title=" .. SafeToString(a.target.title) .. " zone=" .. SafeToString(a.target.zone))
        else
            add("Target: none")
        end
        add("TomTom waypoint uid: " .. SafeToString(a._tomtomUid))
    else
        add("Arrow module not available.")
    end

    add("")
    add("[Manual Waypoint]")
    local mw = self.charDB and self.charDB.manualWaypoint
    if type(mw) == "table" then
        add("mapID=" .. SafeToString(mw.mapID) .. " x=" .. SafeToString(mw.x) .. " y=" .. SafeToString(mw.y) .. " title=" .. SafeToString(mw.title) .. " zone=" .. SafeToString(mw.zone) .. " source=" .. SafeToString(mw.source))
    else
        add("none")
    end

    add("")
    add("[Update Notifier]")
    add("Peer check only (no internet/self-update). Use CurseForge/WowUp/Wago when released or repo for actual updates.")
    add("updateNotify=" .. SafeToString(profile and profile.updateNotify) .. " prefix=" .. SafeToString(self.UPDATE_COMM_PREFIX) .. " key=" .. SafeToString(self.UPDATE_ADDON_KEY) .. " prefixRegistered=" .. SafeToString(self._updatePrefixRegistered) .. " lastSentAny=" .. SafeToString(self._updateLastSentAny))
    add("newestSeen=" .. SafeToString(self._updateNewest) .. " notified=" .. SafeToString(self._updateNotified))

    add("")
    add("Hints: compare route flow relatively (pacing/zone order) to established leveling guides, but keep all step text/structure original and verify quest IDs/mapIDs/coords in-game on WoW Forever. Use /flg list, /flg continue, /flg suggest, /flg goto, /flg way, and /reload after data changes.")

    return table.concat(lines, "\n")
end

function ns:ShowDebugExport(text)
    text = tostring(text or "")
    self._lastDebugExport = text
    if self.UI and self.UI.ShowExportDialog then
        local ok = self.UI:ShowExportDialog(text, "ForeverLevelingGuide - Debug Export")
        if ok then return true end
    end
    self:Print("Debug export prepared. UI dialog unavailable; text stored in addon memory (ns._lastDebugExport).")
    return false
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2, arg3, arg4)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        ns:GetDB()
        if ns.OnInit then ns:OnInit() end
    elseif event == "PLAYER_LOGIN" then
        if ns.OnLogin then ns:OnLogin() end
    elseif event == "CHAT_MSG_ADDON" then
        if ns.HandleVersionAddonMessage then ns:HandleVersionAddonMessage(arg1, arg2, arg3, arg4) end
    elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        if ns.ScheduleVersionBroadcast then ns:ScheduleVersionBroadcast(12, false) end
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

    local function ParseCoordToken(tok)
        if tok == nil then return nil end
        tok = tostring(tok):gsub(",", ""):gsub("%%", ""):gsub("^%s+", ""):gsub("%s+$", "")
        local n = tonumber(tok)
        if n == nil then return nil end
        if n > 1 then n = n / 100 end
        return n
    end

    local function RefreshNav()
        if ns.UI and ns.UI.Refresh then ns.UI:Refresh() end
        if ns.Arrow and ns.Arrow.Update then ns.Arrow:Update() end
    end

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
    elseif cmd == "goto" or cmd == "step" or cmd == "jump" then
        local n = tonumber(rest:match("^(%-?%d+)"))
        if not n then
            ns:Print("Usage: /flg goto <stepNumber>")
        elseif ns.Engine and ns.Engine.GoToStep then
            local idx = ns.Engine:GoToStep(n, "goto-step")
            if idx then ns:Print("Jumped to step " .. tostring(idx) .. ".") else ns:Print("Could not jump to that step (no guide loaded?).") end
        end
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
    elseif cmd == "lock" then
        ns.profile.locked = not ns.profile.locked
        ns:Print("Panel lock: " .. (ns.profile.locked and "|cff88ff88ON|r" or "|cffff8888OFF|r"))
        RefreshNav()
    elseif cmd == "minimap" then
        if type(ns.profile.minimap) ~= "table" then ns.profile.minimap = { hide = false, angle = 220 } end
        ns.profile.minimap.hide = not ns.profile.minimap.hide
        if ns.UI and ns.UI.UpdateMinimapButton then ns.UI:UpdateMinimapButton() end
        ns:Print("Minimap button: " .. (ns.profile.minimap.hide and "|cffff8888HIDDEN|r" or "|cff88ff88ON|r"))
    elseif cmd == "way" or cmd == "waypoint" then
        local sub, args = rest:match("^(%S+)%s*(.-)%s*$")
        sub = (sub or ""):lower()
        if sub == "" then
            local mw = ns.charDB and ns.charDB.manualWaypoint
            if type(mw) == "table" then
                local xTxt = (type(mw.x) == "number") and string.format("%.1f", mw.x * 100) or "?"
                local yTxt = (type(mw.y) == "number") and string.format("%.1f", mw.y * 100) or "?"
                ns:Print("Manual waypoint: " .. tostring(mw.title or "waypoint") .. " (map " .. tostring(mw.mapID) .. ", " .. xTxt .. ", " .. yTxt .. "). Use /flg way clear to remove.")
            else
                ns:Print("No manual waypoint set. Usage: /flg way here | /flg way clear | /flg way <x> <y> | /flg way <mapID> <x> <y>")
            end
        elseif sub == "clear" or sub == "off" or sub == "remove" then
            ns.charDB.manualWaypoint = nil
            ns:Print("Manual waypoint cleared. Arrow will follow the current guide step when available.")
            RefreshNav()
        elseif sub == "here" or sub == "me" or sub == "player" then
            local loc = ns:GetPlayerLocationDebug() or {}
            local mx, my = loc.x, loc.y
            if type(mx) == "number" then mx = mx > 1 and (mx / 100) or mx end
            if type(my) == "number" then my = my > 1 and (my / 100) or my end
            if loc.mapID and mx and my then
                ns.charDB.manualWaypoint = { mapID = loc.mapID, x = mx, y = my, title = (loc.zone and ("Waypoint: " .. tostring(loc.zone))) or "Manual waypoint", zone = loc.zone, source = "player" }
                ns:Print(string.format("Manual waypoint set to your location (map %s, %.1f, %.1f). Use /flg way clear to remove.", tostring(loc.mapID), mx * 100, my * 100))
            else
                ns:Print("Could not read your current map position (client/API limitation). Try /flg way <mapID> <x> <y>.")
            end
            RefreshNav()
        else
            local parts = {}
            for token in tostring(rest):gmatch("%S+") do table.insert(parts, token) end
            local mapID, xTok, yTok
            if #parts >= 3 and tonumber(parts[1]) and tonumber(parts[1]) > 10 then
                mapID = tonumber(parts[1]); xTok = parts[2]; yTok = parts[3]
            elseif #parts >= 2 then
                local loc = ns:GetPlayerLocationDebug() or {}
                mapID = loc.mapID
                xTok = parts[1]; yTok = parts[2]
            end
            local x = ParseCoordToken(xTok)
            local y = ParseCoordToken(yTok)
            if not mapID or not x or not y then
                ns:Print("Usage: /flg way here | /flg way clear | /flg way <x> <y> | /flg way <mapID> <x> <y>")
            else
                ns.charDB.manualWaypoint = { mapID = tonumber(mapID) or mapID, x = x, y = y, title = "Manual waypoint", source = "slash" }
                ns:Print(string.format("Manual waypoint set (map %s, %.1f, %.1f). Use /flg way clear to return to step guidance.", tostring(mapID), x * 100, y * 100))
                RefreshNav()
            end
        end
    elseif cmd == "auto" or cmd == "autoadvance" then
        ns.profile.autoAdvance = not ns.profile.autoAdvance
        ns:Print("Auto-advance: " .. (ns.profile.autoAdvance and "|cff88ff88ON|r" or "|cffff8888OFF|r"))
        if ns.profile.autoAdvance and ns.Engine and ns.Engine.EvaluateCurrent then
            ns.Engine:EvaluateCurrent("toggle")
        end
    elseif cmd == "announce" then
        ns.profile.announce = not ns.profile.announce
        ns:Print("Chat announcements: " .. (ns.profile.announce and "|cff88ff88ON|r" or "|cffff8888OFF|r"))
    elseif cmd == "update" or cmd == "updates" or cmd == "updatenotify" or cmd == "notify" then
        ns.profile.updateNotify = not ns.profile.updateNotify
        ns:Print("Update notifications (peer, no internet): " .. (ns.profile.updateNotify and "|cff88ff88ON|r" or "|cffff8888OFF|r") .. ". Checks group/guild/instance peers; get updates via CurseForge/WowUp/Wago when released or repo.")
        if ns.profile.updateNotify and ns.BroadcastVersionUpdate then ns:BroadcastVersionUpdate(true) end
    elseif cmd == "where" or cmd == "status" or cmd == "current" then
        if ns.UI and ns.UI.PrintStatus then ns.UI:PrintStatus() end
    elseif cmd == "suggest" then
        if not ns:PrintSuggestedGuide() then
            ns:Print("No suggested next guide found. Use /flg list.")
        end
    elseif cmd == "continue" or cmd == "cont" or cmd == "nextguide" then
        local nextKey = (ns.GetNextGuideKey and ns:GetNextGuideKey()) or (ns.GetSuggestedGuideKey and ns:GetSuggestedGuideKey()) or nil
        if nextKey then
            ns:SetGuide(nextKey)
        else
            ns:Print("No next guide available. Use /flg list.")
        end
    elseif cmd == "debug" then
        local sub = tostring(rest or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
        local wantExport = (sub == "export" or sub == "copy" or sub == "full" or sub == "dump" or sub == "report")

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
        local mm = (ns.profile and ns.profile.minimap and not ns.profile.minimap.hide) and "on" or "hidden"
        ns:Print("Settings: arrow=" .. tostring(ns.profile.showArrow) .. " auto=" .. tostring(ns.profile.autoAdvance) .. " announce=" .. tostring(ns.profile.announce) .. " update=" .. tostring(ns.profile.updateNotify) .. " locked=" .. tostring(ns.profile.locked) .. " minimap=" .. mm)
        if ns._updateNewest and ns._updateNewest ~= "" then
            ns:Print("Update (peer): newer version seen v" .. tostring(ns._updateNewest) .. " (you have v" .. tostring(ns.VERSION) .. ")")
        end
        ns:Print("Guides loaded: " .. tostring(#ns:GetSortedGuideKeys()))
        if guide and guide.title then ns:Print("Current title: " .. tostring(guide.title)) end
        if guide and guide.scaffold then ns:Print("Note: this is an original scaffold route (WIP). Verify and expand steps for your WoW Forever build.") end

        local nextKey = ns.GetNextGuideKey and ns:GetNextGuideKey() or nil
        local suggested = ns:GetSuggestedGuideKey and ns:GetSuggestedGuideKey() or nil
        if guide and guide.next then ns:Print("Guide chain next: " .. tostring(guide.next)) end
        if nextKey then ns:Print("Resolved next: " .. tostring(nextKey)) end
        if suggested and suggested ~= nextKey then ns:Print("Suggested: " .. tostring(suggested)) end

        if ns.GetPlayerLocationDebug then
            local loc = ns:GetPlayerLocationDebug()
            if loc then
                local xTxt = (type(loc.x) == "number") and string.format("%.1f%%", loc.x * 100) or "n/a"
                local yTxt = (type(loc.y) == "number") and string.format("%.1f%%", loc.y * 100) or "n/a"
                ns:Print("Location: map=" .. tostring(loc.mapID) .. " x=" .. xTxt .. " y=" .. yTxt .. " zone=" .. tostring(loc.zone or "n/a"))
            end
        end

        if type(step) == "table" and ns.Engine then
            local coords = step.coords
            local satisfied = (ns.Engine.StepSatisfied and ns.Engine:StepSatisfied(step)) and true or false
            local near = false
            if type(coords) == "table" and ns.Engine.IsPlayerNear then
                near = ns.Engine:IsPlayerNear(step, step.radius or 0.03) and true or false
            end
            ns:Print("Step state: satisfied=" .. tostring(satisfied) .. " near=" .. tostring(near))
            if type(coords) == "table" then
                ns:Print("Step coords: mapID=" .. tostring(coords.mapID or coords.mapId or coords.map or coords.uiMapID) .. " x=" .. tostring(coords.x or coords.X) .. " y=" .. tostring(coords.y or coords.Y) .. " radius=" .. tostring(step.radius or "default"))
            end
        end
        if ns.charDB and type(ns.charDB.manualWaypoint) == "table" then
            local mw = ns.charDB.manualWaypoint
            ns:Print("Manual waypoint: map=" .. tostring(mw.mapID) .. " x=" .. tostring(mw.x) .. " y=" .. tostring(mw.y) .. " (" .. tostring(mw.title or "waypoint") .. ") - /flg way clear to return to guide")
        end

        if wantExport and ns.BuildDebugReport then
            local report = ns:BuildDebugReport()
            if ns.ShowDebugExport then
                ns:ShowDebugExport(report)
                ns:Print("Debug export: copyable report opened (or stored if UI unavailable). Use it to speed up in-game verification/tuning on WoW Forever.")
            else
                ns._lastDebugExport = report
                ns:Print("Debug export prepared in ns._lastDebugExport.")
            end
        else
            ns:Print("Tip: /flg debug export - open a copyable full report for WoW Forever verification/tuning.")
        end
    elseif cmd == "help" or cmd == "?" then
        ns:Print("ForeverLevelingGuide " .. ns.BYLINE .. " (v" .. ns.VERSION .. ")")
        ns:Print("Commands:")
        ns:Print("  /flg               - show guide panel")
        ns:Print("  /flg show|hide|toggle - panel visibility")
        ns:Print("  /flg list          - list available guides")
        ns:Print("  /flg load <key>    - load a guide")
        ns:Print("  /flg next|prev|skip|reset - step controls")
        ns:Print("  /flg goto <n>      - jump to step number")
        ns:Print("  /flg arrow         - toggle navigation arrow")
        ns:Print("  /flg auto          - toggle auto-advance")
        ns:Print("  /flg announce      - toggle chat announcements")
        ns:Print("  /flg update        - toggle peer update notifications (no internet)")
        ns:Print("  /flg lock          - toggle panel lock")
        ns:Print("  /flg minimap       - toggle minimap button")
        ns:Print("  /flg where         - print current guide/step status (alias: /flg status)")
        ns:Print("  /flg suggest       - suggest a next guide for your level/faction")
        ns:Print("  /flg continue      - load the next/suggested guide")
        ns:Print("  /flg way           - set/clear manual waypoint (here|clear|x y|mapID x y)")
        ns:Print("  /flg debug         - diagnostics summary")
        ns:Print("  /flg debug export  - copyable full debug report (verification/tuning)")
        ns:Print("Aliases: /levelguide, /journey, /jf")
    else
        ns:Print("Unknown command: " .. tostring(cmd) .. ". Try /flg help")
    end
end

function ns:OnInit()
    self.Guides = self.Guides or {}
    if self.RegisterBundledGuides then self:RegisterBundledGuides() end
    if self.RegisterUpdatePrefix then self:RegisterUpdatePrefix() end
end

function ns:OnLogin()
    if not self.db then self:GetDB() end
    if self.RegisterUpdatePrefix then self:RegisterUpdatePrefix() end

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

    self:Print("Loaded v" .. self.VERSION .. " " .. self.BYLINE .. " (ByJTT, original open routes). Type /flg for help.")
    if self.ScheduleVersionBroadcast then self:ScheduleVersionBroadcast(10, true) end
end
