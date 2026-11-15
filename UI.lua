local _, ns = ...

ns.UI = ns.UI or {}
local UI = ns.UI

local frame
local guidePicker
local exportFrame
local minimapButton

local function Clamp(n, minv, maxv)
    if n < minv then return minv end
    if n > maxv then return maxv end
    return n
end

local function ToNumber(v)
    local n = tonumber(v)
    if n == nil then return nil end
    return n
end

local function NormalizeType(step)
    if type(step) ~= "table" then return "note" end
    local t = tostring(step.type or step.kind or "note"):lower()
    t = t:gsub("[%s%-_]+", "")
    return t
end

local function TypeLabel(step)
    local t = NormalizeType(step)
    if t == "accept" or t == "pickup" or t == "take" or t == "start" then return "Accept" end
    if t == "turnin" or t == "handin" or t == "finish" or t == "deliver" or t == "submit" then return "Turn in" end
    if t == "complete" or t == "do" or t == "objective" or t == "objectives" or t == "progress" or t == "work" then return "Complete" end
    if t == "goto" or t == "travel" or t == "move" or t == "run" or t == "fly" or t == "taxi" or t == "discover" or t == "arrive" or t == "path" or t == "waypoint" then return "Travel" end
    if t == "level" or t == "grind" or t == "xp" or t == "ding" or t == "reach" then return "Level" end
    if t == "collect" or t == "item" or t == "getitem" or t == "get" or t == "loot" or t == "gather" or t == "acquire" or t == "purchase" then return "Collect" end
    if t == "buy" or t == "vendor" or t == "sell" or t == "repair" then return "Vendor" end
    if t == "train" or t == "learn" or t == "trainer" then return "Train" end
    if t == "hearth" or t == "hearthstone" then return "Hearth" end
    if t == "sethearth" or t == "inn" or t == "home" or t == "bind" then return "Set hearth" end
    if t == "use" then return "Use" end
    if t == "kill" or t == "grindmobs" then return "Kill" end
    if t == "class" or t == "profession" or t == "spell" then return "Class/Prof" end
    if t == "note" or t == "info" or t == "text" then return "Note" end
    return t:sub(1, 1):upper() .. t:sub(2)
end

local function CreateBackdrop(f)
    if not f then return end
    if f.SetBackdrop then
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        f:SetBackdropColor(0.05, 0.06, 0.08, 0.95)
        f:SetBackdropBorderColor(0.8, 0.65, 0.2, 1)
    else
        local bg = f:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(true)
        bg:SetColorTexture(0.05, 0.06, 0.08, 0.92)
        f.bg = bg
    end
end

local function SetButtonEnabled(btn, enabled)
    if not btn then return end
    if enabled then
        if btn.Enable then btn:Enable() end
    else
        if btn.Disable then btn:Disable() end
    end
end

local function SetSimpleTooltip(frameOrBtn, title, text)
    if not frameOrBtn or not GameTooltip then return end
    frameOrBtn:HookScript("OnEnter", function(selfObj)
        if not GameTooltip then return end
        GameTooltip:SetOwner(selfObj, "ANCHOR_RIGHT")
        if title and title ~= "" then
            GameTooltip:AddLine(tostring(title), 1, 0.82, 0)
        end
        if text and text ~= "" then
            GameTooltip:AddLine(tostring(text), 1, 1, 1, true)
        end
        GameTooltip:AddLine("|cff888888ByJTT Leveling Guide|r", 0.55, 0.55, 0.55)
        GameTooltip:Show()
    end)
    frameOrBtn:HookScript("OnLeave", function()
        if GameTooltip then GameTooltip:Hide() end
    end)
end

local function FormatCoords(coords)
    if type(coords) ~= "table" then return nil end
    local x = ToNumber(coords.x or coords.X)
    local y = ToNumber(coords.y or coords.Y)
    if not x or not y then return nil end
    if x <= 1 then x = x * 100 end
    if y <= 1 then y = y * 100 end
    local mapID = coords.mapID or coords.mapId or coords.map or coords.uiMapID
    local s = string.format("%.1f, %.1f", x, y)
    if mapID then s = s .. " (map " .. tostring(mapID) .. ")" end
    return s
end

local function StepToLines(step, idx, total)
    if type(step) ~= "table" then
        return "No active step."
    end

    local t = NormalizeType(step)
    local label = TypeLabel(step)
    local title = step.title or step.name or step.text or step.desc
    if not title or tostring(title) == "" then
        if ns.Engine and ns.Engine.GetStepTitle then
            title = ns.Engine:GetStepTitle(step, idx)
        else
            title = label
        end
    end

    local lines = {}
    if idx and total then
        lines[#lines + 1] = "|cff888888Step " .. tostring(idx) .. " of " .. tostring(total) .. " - " .. label .. "|r"
    end
    lines[#lines + 1] = "|cffffd100" .. tostring(title) .. "|r"

    local q = step.quest or step.questID or step.questId or step.id
    if q then
        lines[#lines + 1] = "Quest: " .. tostring(q)
    end

    local item = step.item or step.itemID or step.itemId or step.itemName
    if item ~= nil and item ~= "" then
        local count = ToNumber(step.count or step.amount or step.quantity or step.qty or step.need or step.required)
        if count and count > 0 then
            lines[#lines + 1] = "Item: " .. tostring(item) .. " x" .. tostring(count)
        else
            lines[#lines + 1] = "Item: " .. tostring(item)
        end
    end

    local lvl = ToNumber(step.level or step.toLevel or step.value or step.at or step.required)
    if (t == "level" or t == "grind" or t == "xp" or t == "ding" or t == "reach") and lvl then
        lines[#lines + 1] = "Target level: " .. tostring(lvl)
    end

    if step.npc or step.target or step.object or step.unit then
        lines[#lines + 1] = "NPC/Target: " .. tostring(step.npc or step.target or step.object or step.unit)
    end
    if step.zone or step.area or step.subzone then
        lines[#lines + 1] = "Zone: " .. tostring(step.zone or step.area or step.subzone)
    end

    local coordsText = FormatCoords(step.coords)
    if coordsText then
        lines[#lines + 1] = "Coords: " .. coordsText
        if t == "goto" or t == "travel" or t == "move" or t == "run" or t == "fly" or t == "taxi" or t == "discover" or t == "arrive" then
            local radius = ToNumber(step.radius)
            if radius and radius > 0 then
                lines[#lines + 1] = "Arrival radius: " .. tostring(radius)
            end
        end
    end

    local note = step.note or step.desc or step.description
    if note and tostring(note) ~= "" and tostring(note) ~= tostring(title) then
        lines[#lines + 1] = ""
        lines[#lines + 1] = tostring(note)
    end
    if step.tip and tostring(step.tip) ~= "" then
        lines[#lines + 1] = ""
        lines[#lines + 1] = "|cff88ff88Tip:|r " .. tostring(step.tip)
    end

    local isTravel = t == "goto" or t == "travel" or t == "move" or t == "run" or t == "fly" or t == "taxi"
        or t == "discover" or t == "arrive" or t == "path" or t == "waypoint"

    if isTravel then
        lines[#lines + 1] = ""
        if coordsText then
            lines[#lines + 1] = "|cff88cceeAuto-advance:|r completes on arrival when close (if on the same map, best-effort). Use Next/Skip if needed."
        else
            lines[#lines + 1] = "|cff88cceeManual step:|r travel as described, then use Next/Skip."
        end
    elseif t == "note" or t == "info" or t == "text" or t == "train" or t == "learn" or t == "trainer" or t == "buy" or t == "vendor" or t == "sell" or t == "repair" or t == "hearth" or t == "hearthstone" or t == "sethearth" or t == "inn" or t == "home" or t == "bind" or t == "use" or t == "talk" or t == "speak" or t == "class" or t == "profession" or t == "spell" then
        lines[#lines + 1] = ""
        lines[#lines + 1] = "|cffaaaaaaManual step:|r use Next when done (or Skip)."
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "|cffaaaaaa/flg prev - /flg next - /flg skip - /flg list|r"
    return table.concat(lines, "\n")
end

local function GetGuideKeysSorted()
    if ns and type(ns.GetSortedGuideKeys) == "function" then
        return ns:GetSortedGuideKeys()
    end
    local keys = {}
    if type(ns.Guides) == "table" then
        for k, g in pairs(ns.Guides) do
            if type(k) == "string" and type(g) == "table" then keys[#keys + 1] = k end
        end
    end
    table.sort(keys)
    return keys
end

local function HideGuidePicker()
    if guidePicker then guidePicker:Hide() end
end

local function ToggleGuidePicker(anchor)
    if not ns.SetGuide then return end
    if guidePicker and guidePicker:IsShown() then
        HideGuidePicker()
        return
    end

    if not guidePicker then
        local p = CreateFrame("Frame", "ForeverLevelingGuidePicker", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
        p:SetFrameStrata("DIALOG")
        p:SetClampedToScreen(true)
        p:SetSize(380, 240)
        p:EnableMouse(true)
        CreateBackdrop(p)

        local title = p:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOPLEFT", p, "TOPLEFT", 10, -8)
        title:SetPoint("TOPRIGHT", p, "TOPRIGHT", -28, -8)
        title:SetJustifyH("LEFT")
        title:SetText("Select a guide")

        local close = CreateFrame("Button", nil, p, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", p, "TOPRIGHT", 2, 2)
        close:SetScript("OnClick", HideGuidePicker)

        local scroll = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", p, "TOPLEFT", 10, -28)
        scroll:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -30, 10)
        local content = CreateFrame("Frame", nil, scroll)
        content:SetSize(1, 1)
        scroll:SetScrollChild(content)
        p.scroll = scroll
        p.content = content
        p.rows = {}

        guidePicker = p
    end

    local keys = GetGuideKeysSorted()
    local current = ns.charDB and ns.charDB.guideKey
    local y = -2
    local rowH = 22

    for i, key in ipairs(keys) do
        local row = guidePicker.rows[i]
        if not row then
            row = CreateFrame("Button", nil, guidePicker.content)
            row:SetHeight(rowH)
            local hl = row:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints(true)
            hl:SetColorTexture(1, 1, 1, 0.08)
            local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            fs:SetPoint("LEFT", row, "LEFT", 4, 0)
            fs:SetPoint("RIGHT", row, "RIGHT", -4, 0)
            fs:SetJustifyH("LEFT")
            row.text = fs
            guidePicker.rows[i] = row
        end

        local g = ns.Guides and ns.Guides[key] or {}
        local title = g.title or key
        local meta = {}
        if g.faction then meta[#meta + 1] = tostring(g.faction) end
        if g.minLevel and g.maxLevel then meta[#meta + 1] = tostring(g.minLevel) .. "-" .. tostring(g.maxLevel) end
        if g.scaffold then meta[#meta + 1] = "scaffold" end
        local stepsCount = (type(g.steps) == "table" and #g.steps) or 0
        if stepsCount > 0 then meta[#meta + 1] = stepsCount .. " steps" end
        local label = title
        if #meta > 0 then label = label .. " |cff888888(" .. table.concat(meta, ", ") .. ")|r" end
        if key == current then label = "|cff88ff88*|r " .. label else label = "  " .. label end

        row.text:SetText(label)
        row:SetPoint("TOPLEFT", guidePicker.content, "TOPLEFT", 0, y)
        row:SetPoint("TOPRIGHT", guidePicker.content, "TOPRIGHT", 0, y)
        row:SetScript("OnClick", function()
            ns:SetGuide(key)
            HideGuidePicker()
        end)
        row:Show()
        y = y - rowH
    end

    for i = #keys + 1, #guidePicker.rows do
        if guidePicker.rows[i] then guidePicker.rows[i]:Hide() end
    end

    local width = 350
    guidePicker.content:SetSize(width, math.max(1, (#keys * rowH) + 4))
    guidePicker:ClearAllPoints()
    if anchor and anchor.GetCenter then
        guidePicker:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 4)
    else
        guidePicker:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    if #keys == 0 then
        if not guidePicker.empty then
            guidePicker.empty = guidePicker.content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            guidePicker.empty:SetPoint("TOPLEFT", guidePicker.content, "TOPLEFT", 4, -4)
            guidePicker.empty:SetPoint("RIGHT", guidePicker.content, "RIGHT", -4, 0)
            guidePicker.empty:SetJustifyH("LEFT")
            guidePicker.empty:SetWordWrap(true)
            guidePicker.empty:SetText("No guides loaded. Add Data/*.lua route files, include them in the TOC, and /reload.")
        end
        guidePicker.empty:Show()
    elseif guidePicker.empty then
        guidePicker.empty:Hide()
    end

    guidePicker:Show()
end

function UI:Create()
    if frame then return end

    local profile = ns.profile or {}
    local ui = profile.ui or {}
    local w = Clamp(ToNumber(ui.width) or 380, 300, 700)
    local h = Clamp(ToNumber(ui.height) or 260, 180, 600)

    frame = CreateFrame("Frame", "ForeverLevelingGuideFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    frame:SetSize(w, h)
    frame:SetPoint(ui.point or "LEFT", UIParent, ui.relPoint or "LEFT", ui.x or 40, ui.y or 0)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    if frame.SetResizable then frame:SetResizable(true) end
    if frame.SetResizeBounds then
        frame:SetResizeBounds(300, 180, 700, 600)
    elseif frame.SetMinResize then
        frame:SetMinResize(300, 180)
        if frame.SetMaxResize then frame:SetMaxResize(700, 600) end
    end
    frame:RegisterForDrag("LeftButton")

    frame:SetScript("OnDragStart", function(self)
        if ns.profile and ns.profile.locked then return end
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        if not (ns.profile and ns.profile.ui) then return end
        local point, _, relPoint, x, y = self:GetPoint(1)
        ns.profile.ui.point = point or ns.profile.ui.point
        ns.profile.ui.relPoint = relPoint or ns.profile.ui.relPoint
        ns.profile.ui.x = x or ns.profile.ui.x
        ns.profile.ui.y = y or ns.profile.ui.y
        ns.profile.ui.width = math.floor(self:GetWidth() + 0.5)
        ns.profile.ui.height = math.floor(self:GetHeight() + 0.5)
    end)

    CreateBackdrop(frame)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -10)
    title:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -60, -10)
    title:SetJustifyH("LEFT")
    title:SetText("|cff4dd0ffForeverLevelingGuide|r |cff888888by ByJTT|r")
    frame.title = title

    local progress = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    progress:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -34, -12)
    progress:SetJustifyH("RIGHT")
    progress:SetText("")
    frame.progress = progress

    local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    subtitle:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -34, -28)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetText("")
    frame.subtitle = subtitle

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
    close:SetScript("OnClick", function() UI:Hide() end)

    local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -48)
    scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 44)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)

    local body = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
    body:SetJustifyH("LEFT")
    body:SetJustifyV("TOP")
    body:SetNonSpaceWrap(true)
    body:SetWordWrap(true)

    frame.body = body
    frame.content = content
    frame.scroll = scroll

    local function MakeButton(labelText, width, x, onClick)
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetSize(width, 22)
        b:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", x, 12)
        b:SetText(labelText)
        b:SetScript("OnClick", onClick)
        return b
    end

    frame.prevBtn = MakeButton("Prev", 52, 12, function() if ns.Engine and ns.Engine.PrevStep then ns.Engine:PrevStep() end end)
    frame.nextBtn = MakeButton("Next", 64, 68, function()
        local guide = ns:GetCurrentGuide()
        local steps = (guide and type(guide.steps) == "table") and guide.steps or {}
        local total = #steps
        local idx = (ns.charDB and tonumber(ns.charDB.stepIndex)) or 1
        if total > 0 and idx > total then
            local nk = (ns.GetNextGuideKey and ns:GetNextGuideKey()) or (ns.GetSuggestedGuideKey and ns:GetSuggestedGuideKey()) or nil
            if nk and ns.SetGuide then ns:SetGuide(nk) end
        else
            if ns.Engine and ns.Engine.NextStep then ns.Engine:NextStep("manual") end
        end
    end)
    frame.skipBtn = MakeButton("Skip", 52, 136, function() if ns.Engine and ns.Engine.SkipStep then ns.Engine:SkipStep() end end)
    frame.resetBtn = MakeButton("Reset", 52, 192, function() if ns.Engine and ns.Engine.ResetProgress then ns.Engine:ResetProgress() end end)
    frame.guidesBtn = MakeButton("Guides", 58, 248, function() ToggleGuidePicker(frame.guidesBtn) end)
    SetSimpleTooltip(frame.prevBtn, "Previous step", "Go back to an earlier step.")
    SetSimpleTooltip(frame.nextBtn, "Next step / Continue", "Complete this step, or continue to the next guide at the end.")
    SetSimpleTooltip(frame.skipBtn, "Skip step", "Skip this step and move on.")
    SetSimpleTooltip(frame.resetBtn, "Reset progress", "Restart this guide for your character.")
    SetSimpleTooltip(frame.guidesBtn, "Choose a guide", "Open the guide list to load a route.")

    local lock = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    lock:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 6)
    lock:SetSize(24, 24)
    local lockText = lock.Text or lock.text or (lock.GetFontString and lock:GetFontString())
    if lockText and lockText.SetText then lockText:SetText("Lock") end
    lock:SetScript("OnShow", function(selfBtn)
        selfBtn:SetChecked(ns.profile and ns.profile.locked or false)
    end)
    lock:SetScript("OnClick", function(selfBtn)
        if ns.profile then
            ns.profile.locked = selfBtn:GetChecked() and true or false
        end
    end)
    SetSimpleTooltip(lock, "Lock panel", "Prevent moving or resizing the guide window.")
    frame.lock = lock

    local resize = CreateFrame("Button", nil, frame)
    resize:SetSize(16, 16)
    resize:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    resize:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resize:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resize:SetScript("OnMouseDown", function()
        if ns.profile and ns.profile.locked then return end
        if frame.StartSizing then frame:StartSizing("BOTTOMRIGHT") end
    end)
    resize:SetScript("OnMouseUp", function()
        if frame.StopMovingOrSizing then frame:StopMovingOrSizing() end
        if ns.profile and ns.profile.ui then
            ns.profile.ui.width = math.floor(frame:GetWidth() + 0.5)
            ns.profile.ui.height = math.floor(frame:GetHeight() + 0.5)
        end
        UI:Refresh()
    end)

    frame:SetScript("OnSizeChanged", function()
        if not frame._refreshPending then
            frame._refreshPending = true
            local function doRefresh()
                if not frame then return end
                frame._refreshPending = nil
                UI:Refresh()
            end
            if C_Timer and type(C_Timer.After) == "function" then
                C_Timer.After(0, doRefresh)
            else
                doRefresh()
            end
        end
    end)

    if ui.shown == false then
        frame:Hide()
    end

    self.frame = frame
end

function UI:Refresh()
    if not frame then return end
    if not ns.charDB or not ns.profile then return end

    local guide, key = ns:GetCurrentGuide()
    local scrollWidth = (frame.scroll and frame.scroll:GetWidth()) or (frame:GetWidth() - 42)
    scrollWidth = Clamp(scrollWidth - 4, 120, 1000)

    if not guide then
        frame.subtitle:SetText("No guide loaded")
        frame.progress:SetText("")
        frame.body:SetWidth(scrollWidth)
        frame.body:SetText("No guide loaded.\n\nUse the |cffffd100Guides|r button below, |cffffd100/flg list|r, or |cffffd100/flg load <key>|r to load one.\n\nExamples:\n- /flg load horde_01_10_durotar\n- /flg load alliance_01_10_elwynn\n\nForeverLevelingGuide by ByJTT - free, open, and extensible.")
        frame.content:SetHeight(math.max(120, frame.body:GetStringHeight() + 12))
        if frame.nextBtn and frame.nextBtn.SetText then frame.nextBtn:SetText("Next") end
        SetButtonEnabled(frame.prevBtn, false)
        SetButtonEnabled(frame.nextBtn, false)
        SetButtonEnabled(frame.skipBtn, false)
        SetButtonEnabled(frame.resetBtn, false)
        SetButtonEnabled(frame.guidesBtn, true)
        return
    end

    local steps = (type(guide.steps) == "table") and guide.steps or {}
    local total = #steps
    local idx = ToNumber(ns.charDB.stepIndex) or 1
    if idx < 1 then idx = 1 end
    local atEnd = idx > total

    local shownIdx = atEnd and total or Clamp(idx, 1, math.max(total, 1))
    if total > 0 then
        local pct = math.floor((shownIdx / total) * 100 + 0.5)
        if atEnd then pct = 100 end
        if pct < 0 then pct = 0 elseif pct > 100 then pct = 100 end
        frame.progress:SetText(string.format("%d / %d (%d%%)", shownIdx, total, pct))
    else
        frame.progress:SetText("0 / 0")
    end

    local subtitle = guide.title or key or "Guide"
    local meta = {}
    if guide.faction then meta[#meta + 1] = tostring(guide.faction) end
    if guide.minLevel and guide.maxLevel then meta[#meta + 1] = tostring(guide.minLevel) .. "-" .. tostring(guide.maxLevel) end
    if guide.scaffold then meta[#meta + 1] = "scaffold/WIP" end
    if key then meta[#meta + 1] = tostring(key) end
    if #meta > 0 then subtitle = subtitle .. " |cff888888(" .. table.concat(meta, ", ") .. ")|r" end
    local hasManualWaypoint = type(ns.charDB and ns.charDB.manualWaypoint) == "table"
    if hasManualWaypoint then
        subtitle = subtitle .. "  |cff88ddff[Waypoint]|r"
    end
    frame.subtitle:SetText(subtitle)

    local continueKey = nil
    local text
    if total == 0 then
        text = "|cffffcc00This guide has no steps yet.|r\n\nAdd steps in its Data/*.lua file and /reload.\nSee README for the route format and scaffold examples."
    elseif atEnd then
        continueKey = (ns.GetNextGuideKey and ns:GetNextGuideKey()) or (ns.GetSuggestedGuideKey and ns:GetSuggestedGuideKey()) or nil
        local continueHint
        if continueKey then
            continueHint = "Use |cffffd100/flg continue|r or click |cffffd100Continue|r to load the next guide"
        else
            continueHint = "No next guide chained or suggested. Use |cffffd100Guides|r or |cffffd100/flg list|r to choose another guide"
        end
        local msg = "You reached the end of:\n|cffffd100" .. tostring(guide.title or key or "Guide") .. "|r\n\n" .. continueHint .. ", or |cffffd100/flg reset|r to replay this one."
        if continueKey then
            local sg = (ns.GetGuide and ns:GetGuide(continueKey)) or (ns.Guides and ns.Guides[continueKey]) or {}
            local sTitle = sg.title or continueKey
            local sMeta = {}
            if sg.minLevel and sg.maxLevel then sMeta[#sMeta + 1] = tostring(sg.minLevel) .. "-" .. tostring(sg.maxLevel) end
            if sg.scaffold then sMeta[#sMeta + 1] = "scaffold/WIP" end
            local suffix = (#sMeta > 0) and (" |cff888888(" .. table.concat(sMeta, ", ") .. ")|r") or ""
            local chained = guide and (guide.next == continueKey or guide.nextGuide == continueKey or guide.nextKey == continueKey)
            local label = chained and "Next guide" or "Suggested next"
            msg = msg .. "\n\n|cff4dd0ff" .. label .. ":|r " .. tostring(sTitle) .. suffix .. "\n|cff666666" .. tostring(continueKey) .. "|r\nUse: |cffffd100/flg continue|r or click |cffffd100Continue|r (or /flg load " .. tostring(continueKey) .. ")"
        end
        text = "|cff88ff88Guide complete!|r\n\n" .. msg
    else
        local step = steps[idx]
        text = StepToLines(step, idx, total)
    end

    if hasManualWaypoint then
        local mw = ns.charDB.manualWaypoint or {}
        local mwTitle = tostring(mw.title or "Manual waypoint")
        local mwLine = "|cff88ddffManual waypoint active:|r arrow follows |cffffd100" .. mwTitle .. "|r. Use |cffffd100/flg way clear|r to return to step guidance."
        if text and text ~= "" then
            text = mwLine .. "\n\n" .. text
        else
            text = mwLine
        end
    end

    frame.body:SetWidth(scrollWidth)
    frame.body:SetText(text)
    local textHeight = frame.body:GetStringHeight() or 100
    frame.content:SetWidth(scrollWidth)
    frame.content:SetHeight(math.max(100, textHeight + 14))

    if atEnd and total > 0 then
        if frame.nextBtn and frame.nextBtn.SetText then
            frame.nextBtn:SetText(continueKey and "Continue" or "Next")
        end
    else
        if frame.nextBtn and frame.nextBtn.SetText then frame.nextBtn:SetText("Next") end
    end

    SetButtonEnabled(frame.prevBtn, idx > 1)
    SetButtonEnabled(frame.nextBtn, (total > 0 and not atEnd) or (atEnd and continueKey ~= nil))
    SetButtonEnabled(frame.skipBtn, total > 0 and not atEnd)
    SetButtonEnabled(frame.resetBtn, total > 0)
    SetButtonEnabled(frame.guidesBtn, true)

    if frame.lock then
        frame.lock:SetChecked(ns.profile.locked and true or false)
    end
end

function UI:Show()
    self:Create()
    if not frame then return end
    frame:Show()
    if ns.profile and ns.profile.ui then ns.profile.ui.shown = true end
    self:Refresh()
    if ns.Arrow and ns.Arrow.Update then ns.Arrow:Update() end

    if ns.profile and not ns.profile.welcomeSeen and not ns.profile.welcomeDismissed and self.ShowWelcome then
        self:ShowWelcome(false)
    end
end

function UI:Hide()
    HideGuidePicker()
    if frame then frame:Hide() end
    if ns.profile and ns.profile.ui then ns.profile.ui.shown = false end
    if ns.Arrow and ns.Arrow.Update then ns.Arrow:Update() end
end

function UI:Toggle()
    self:Create()
    if frame and frame:IsShown() then self:Hide() else self:Show() end
end

function UI:PrintStatus()
    local guide, key = ns:GetCurrentGuide()
    if not guide then
        ns:Print("No guide loaded. Use /flg list, /flg load <key>, or /flg continue.")
        return
    end

    local steps = (type(guide.steps) == "table") and guide.steps or {}
    local total = #steps
    local idx = ToNumber(ns.charDB and ns.charDB.stepIndex) or 1
    if idx < 1 then idx = 1 end

    local shownIdx = (idx > total and total > 0) and total or Clamp(idx, 1, math.max(total, 1))
    local pct = 0
    if total > 0 then
        pct = math.floor((shownIdx / total) * 100 + 0.5)
        if idx > total then pct = 100 end
        if pct < 0 then pct = 0 elseif pct > 100 then pct = 100 end
    end
    local progress = (total > 0) and string.format("%d/%d (%d%%)", math.min(math.max(idx, 1), total), total, pct) or "0/0"

    local guideLabel = tostring(guide.title or key or "Guide")
    local extra = {}
    if guide.faction then extra[#extra + 1] = tostring(guide.faction) end
    if guide.minLevel and guide.maxLevel then extra[#extra + 1] = tostring(guide.minLevel) .. "-" .. tostring(guide.maxLevel) end
    if guide.scaffold then extra[#extra + 1] = "scaffold/WIP" end
    local extraText = (#extra > 0) and (" [" .. table.concat(extra, ", ") .. "]") or ""

    ns:Print(string.format("Guide: %s%s | key: %s | progress %s", guideLabel, extraText, tostring(key or "n/a"), progress))

    if idx > total then
        ns:Print("Current: Guide complete.")
        local nextKey = (ns.GetNextGuideKey and ns:GetNextGuideKey()) or (ns.GetSuggestedGuideKey and ns:GetSuggestedGuideKey()) or nil
        if nextKey then
            ns:Print("Next: " .. tostring(nextKey) .. " (use /flg continue)")
        end
    else
        local step = steps[idx]
        local title = "Step"
        local stype = "note"
        if step and ns.Engine and ns.Engine.GetStepTitle then
            title = ns.Engine:GetStepTitle(step, idx)
        elseif step then
            title = step.title or step.name or step.desc or step.type or "Step"
        end
        if step then
            stype = tostring(step.type or step.kind or "note")
        end
        ns:Print(string.format("Current: [%d/%d] (%s) %s", idx, total, stype, tostring(title)))
        if step and step.zone then
            ns:Print("Zone: " .. tostring(step.zone))
        end
    end

    local mw = ns.charDB and ns.charDB.manualWaypoint
    if type(mw) == "table" then
        ns:Print("Manual waypoint: " .. tostring(mw.title or "waypoint") .. " (map " .. tostring(mw.mapID) .. ", x " .. tostring(mw.x) .. ", y " .. tostring(mw.y) .. ") - /flg way clear to restore step guidance")
    end
end

function UI:ShowExportDialog(text, dialogTitle)
    self:Create()

    if not exportFrame then
        local f = CreateFrame("Frame", "ForeverLevelingGuideExportFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
        f:SetSize(560, 380)
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
        f:SetClampedToScreen(true)
        f:SetFrameStrata("DIALOG")
        f:SetMovable(true)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(selfFrame) selfFrame:StartMoving() end)
        f:SetScript("OnDragStop", function(selfFrame) selfFrame:StopMovingOrSizing() end)
        CreateBackdrop(f)

        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
        title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -34, -10)
        title:SetJustifyH("LEFT")
        f.title = title

        local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        hint:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -30)
        hint:SetJustifyH("LEFT")
        hint:SetWordWrap(true)
        hint:SetText("|cffaaaaaaPress Ctrl+A then Ctrl+C to copy. Use this report for in-game verification/tuning on WoW Forever (compare route flow relatively; keep routes original/clean-room).|r")
        f.hint = hint

        local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
        close:SetScript("OnClick", function() f:Hide() end)

        local scroll = CreateFrame("ScrollFrame", "ForeverLevelingGuideExportScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -46)
        scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 42)

        local edit = CreateFrame("EditBox", "ForeverLevelingGuideExportEditBox", scroll)
        edit:SetMultiLine(true)
        edit:SetAutoFocus(false)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(500)
        edit:SetHeight(300)
        edit:SetTextInsets(4, 4, 4, 4)
        edit:SetScript("OnEscapePressed", function() f:Hide() end)
        edit:SetScript("OnEditFocusGained", function(selfEdit)
            selfEdit:HighlightText()
        end)
        scroll:SetScrollChild(edit)
        f.editBox = edit
        f.scroll = scroll

        local selectBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        selectBtn:SetSize(90, 22)
        selectBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 12)
        selectBtn:SetText("Select All")
        selectBtn:SetScript("OnClick", function()
            if f.editBox then
                f.editBox:SetFocus()
                f.editBox:HighlightText()
            end
        end)

        local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        closeBtn:SetSize(80, 22)
        closeBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
        closeBtn:SetText("Close")
        closeBtn:SetScript("OnClick", function() f:Hide() end)

        f:SetScript("OnShow", function()
            if f.editBox then
                f.editBox:SetFocus()
                f.editBox:HighlightText()
            end
        end)

        exportFrame = f
    end

    exportFrame.title:SetText(tostring(dialogTitle or "Debug Export"))

    local textStr = tostring(text or "")
    local scrollWidth = (exportFrame.scroll and exportFrame.scroll:GetWidth()) or 500
    if scrollWidth < 100 then scrollWidth = 500 end
    exportFrame.editBox:SetWidth(scrollWidth)

    local _, lineHeight = exportFrame.editBox:GetFont()
    if type(lineHeight) ~= "number" or lineHeight <= 0 then lineHeight = 14 end
    local lineCount = 1
    for _ in textStr:gmatch("\n") do lineCount = lineCount + 1 end
    exportFrame.editBox:SetHeight(math.max(280, (lineCount * lineHeight) + 24))

    exportFrame.editBox:SetText(textStr)
    exportFrame.editBox:SetCursorPosition(0)
    exportFrame:Show()
    exportFrame.editBox:SetFocus()
    exportFrame.editBox:HighlightText()
    return true
end



local function PositionMinimapButton(btn, angleDeg)
    if not btn or not Minimap then return end
    local angle = math.rad(tonumber(angleDeg) or 220)
    local radius = 80
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    btn:ClearAllPoints()
    btn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function UI:UpdateMinimapButton()
    if not ns or not ns.profile then return end
    if type(ns.profile.minimap) ~= "table" then
        ns.profile.minimap = { hide = false, angle = 220 }
    end
    local cfg = ns.profile.minimap
    if cfg.hide == nil then cfg.hide = false end
    if tonumber(cfg.angle) == nil then cfg.angle = 220 end

    if not minimapButton then
        if not Minimap or not CreateFrame then return end
        local b = CreateFrame("Button", "ForeverLevelingGuideMinimapButton", Minimap)
        b:SetSize(31, 31)
        b:SetFrameStrata("MEDIUM")
        if Minimap.GetFrameLevel then
            b:SetFrameLevel((Minimap:GetFrameLevel() or 0) + 8)
        end
        b:SetClampedToScreen(true)
        b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        b:RegisterForDrag("LeftButton")

        local overlay = b:CreateTexture(nil, "OVERLAY")
        overlay:SetSize(53, 53)
        overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        overlay:SetPoint("TOPLEFT", 0, 0)

        local bg = b:CreateTexture(nil, "BACKGROUND")
        bg:SetSize(20, 20)
        bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
        bg:SetPoint("TOPLEFT", 7, -5)

        local icon = b:CreateTexture(nil, "ARTWORK")
        icon:SetSize(18, 18)
        icon:SetPoint("TOPLEFT", 7, -6)
        if not icon:SetTexture("Interface\\Icons\\INV_Misc_Map_01") then
            icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
        end
        b.icon = icon

        if b.SetHighlightTexture then
            b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        end

        b:SetScript("OnEnter", function(selfBtn)
            if not GameTooltip then return end
            GameTooltip:SetOwner(selfBtn, "ANCHOR_LEFT")
            GameTooltip:AddLine("|cff4dd0ffByJTT Leveling Guide|r", 1, 1, 1)
            GameTooltip:AddLine("Step-by-step leveling guidance (original open routes)", 0.8, 0.8, 0.8, true)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cffffd100Left Click:|r Show/Hide guide panel", 0.95, 0.95, 0.95)
            GameTooltip:AddLine("|cffffd100Right Click:|r Open Guides list", 0.95, 0.95, 0.95)
            GameTooltip:AddLine("|cffffd100Drag:|r Move this button", 0.95, 0.95, 0.95)
            GameTooltip:AddLine("|cff888888/flg config for settings - /flg help for commands|r", 0.65, 0.65, 0.65)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function()
            if GameTooltip then GameTooltip:Hide() end
        end)

        b:SetScript("OnClick", function(_, button)
            if button == "RightButton" then
                UI:Show()
                if frame and frame.guidesBtn then
                    ToggleGuidePicker(frame.guidesBtn)
                elseif frame then
                    ToggleGuidePicker(frame)
                end
            else
                UI:Toggle()
            end
        end)

        b:SetScript("OnDragStart", function(selfBtn)
            selfBtn:SetScript("OnUpdate", function()
                if not Minimap then return end
                local mx, my = Minimap:GetCenter()
                local px, py = GetCursorPosition()
                local scale = (Minimap:GetEffectiveScale() or (UIParent and UIParent:GetEffectiveScale()) or 1)
                px, py = px / scale, py / scale
                local angle = math.deg(math.atan2(py - my, px - mx))
                if ns.profile and ns.profile.minimap then
                    ns.profile.minimap.angle = angle
                end
                PositionMinimapButton(selfBtn, angle)
            end)
        end)
        b:SetScript("OnDragStop", function(selfBtn)
            selfBtn:SetScript("OnUpdate", nil)
        end)

        minimapButton = b
    end

    if cfg.hide then
        minimapButton:Hide()
    else
        PositionMinimapButton(minimapButton, cfg.angle or 220)
        minimapButton:Show()
    end
end


function UI:Initialize()
    self:Create()
    self:Refresh()
    self:UpdateMinimapButton()

    if ns.profile and not ns.profile.welcomeSeen and not ns.profile.welcomeDismissed and frame and frame:IsShown() and self.ShowWelcome then
        self:ShowWelcome(false)
    end
end

function UI:ApplyLayout()
    self:Create()
    if not frame then return end

    local profile = ns.profile or {}
    local ui = profile.ui or {}
    local w = Clamp(ToNumber(ui.width) or 380, 300, 700)
    local h = Clamp(ToNumber(ui.height) or 260, 180, 600)

    frame:ClearAllPoints()
    frame:SetSize(w, h)
    frame:SetPoint(ui.point or "LEFT", UIParent, ui.relPoint or "LEFT", ui.x or 40, ui.y or 0)

    if frame.lock then
        frame.lock:SetChecked(profile.locked and true or false)
    end

    if ui.shown == false then
        frame:Hide()
    else
        frame:Show()
    end

    self:Refresh()
end

local welcomeFrame
local optionsPanel

local function DismissWelcome(markDone)
    if not ns.profile then return end
    ns.profile.welcomeDismissed = true
    if markDone then
        ns.profile.welcomeSeen = true
    end
    if welcomeFrame and welcomeFrame.Hide then
        welcomeFrame:Hide()
    end
end

function UI:ShowWelcome(force)
    self:Create()
    if not ns.profile then return end
    if not force and (ns.profile.welcomeSeen or ns.profile.welcomeDismissed) then
        return
    end

    if not welcomeFrame then
        local wf = CreateFrame("Frame", "ForeverLevelingGuideWelcomeFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
        wf:SetSize(500, 320)
        wf:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
        wf:SetFrameStrata("DIALOG")
        wf:SetClampedToScreen(true)
        wf:EnableMouse(true)
        wf:SetMovable(true)
        wf:RegisterForDrag("LeftButton")
        wf:SetScript("OnDragStart", function(selfFrame) if not (InCombatLockdown and InCombatLockdown()) then selfFrame:StartMoving() end end)
        wf:SetScript("OnDragStop", function(selfFrame) selfFrame:StopMovingOrSizing() end)
        CreateBackdrop(wf)

        local title = wf:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", wf, "TOP", 0, -16)
        title:SetText("|cff4dd0ffWoW Forever Leveling Guide Addon ByJTT|r")

        local by = wf:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        by:SetPoint("TOP", title, "BOTTOM", 0, -2)
        by:SetText("|cffaaaaaaby ByJTT - " .. tostring(ns.WEB or "https://byjtt.com") .. "|r")

        local body = wf:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        body:SetPoint("TOPLEFT", wf, "TOPLEFT", 20, -54)
        body:SetPoint("TOPRIGHT", wf, "TOPRIGHT", -20, -54)
        body:SetJustifyH("LEFT")
        body:SetJustifyV("TOP")
        body:SetSpacing(2)
        wf.body = body

        local function mkBtn(text, x, y, w, onClick)
            local b = CreateFrame("Button", nil, wf, "UIPanelButtonTemplate")
            b:SetSize(w or 120, 22)
            b:SetPoint("BOTTOM", wf, "BOTTOM", x, y)
            b:SetText(text)
            b:SetScript("OnClick", onClick)
            return b
        end

        mkBtn("Got it", -165, 16, 90, function()
            DismissWelcome(true)
            if ns.Print then ns:Print("You're all set. Use Guides or /flg continue to load a route. Type /flg help anytime.") end
        end)
        mkBtn("Open Settings", -55, 16, 110, function()
            DismissWelcome(true)
            if UI.OpenOptions then UI:OpenOptions() end
        end)
        mkBtn("Guides", 55, 16, 90, function()
            DismissWelcome(true)
            UI:Show()
            if frame and frame.guidesBtn then
                ToggleGuidePicker(frame.guidesBtn)
            elseif frame then
                ToggleGuidePicker(frame)
            end
        end)
        mkBtn("Later", 165, 16, 80, function()
            DismissWelcome(false)
        end)

        welcomeFrame = wf
    end

    if welcomeFrame.body then
        welcomeFrame.body:SetText(
            "A clear, step-by-step leveling guide to help you know what to do next.\n\n" ..
            "-  Use |cffffd100Guides|r or |cffffd100/flg continue|r to load a route for your character.\n" ..
            "-  Follow each step in the panel. Click |cffffd100Next|r, |cffffd100Prev|r, or |cffffd100Skip|r anytime (manual control always works).\n" ..
            "-  The arrow/minimap button can help with navigation. Use |cffffd100/flg way|r for a custom waypoint.\n" ..
            "-  Routes marked |cff888888scaffold/WIP|r are original outlines refined by relative leveling flow and still need in-game verification on WoW Forever.\n\n" ..
            "Safe by design: this addon gives guidance only (no gameplay automation).\n" ..
            "Tip: |cffffd100/flg config|r opens settings, |cffffd100/flg help|r lists commands, and |cffffd100/flg debug export|r creates a copyable report for tuning."
        )
    end

    welcomeFrame:Show()
end

function UI:EnsureOptionsPanel()
    if optionsPanel then return optionsPanel end

    local panel = CreateFrame("Frame", "ForeverLevelingGuideOptionsPanel", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    panel.name = ns.DISPLAY_NAME or "WoW Forever Leveling Guide Addon ByJTT"
    panel:Hide()

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("|cff4dd0ffWoW Forever Leveling Guide Addon|r |cffaaaaaaby ByJTT|r")

    local sub = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    sub:SetText("Step-by-step leveling guidance for all skill levels. Safe, guidance-only, and easy to adjust. Type /flg help for commands.")

    local y = -58
    local function mkCheck(label, get, set, tooltip)
        local cb = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 16, y)
        if cb.Text and cb.Text.SetText then
            cb.Text:SetText(label)
        elseif cb.text and cb.text.SetText then
            cb.text:SetText(label)
        end
        cb:SetScript("OnShow", function(self) self:SetChecked(get() and true or false) end)
        cb:SetScript("OnClick", function(self) set(self:GetChecked() and true or false) end)
        if tooltip then
            cb.tooltipText = label
            cb.tooltipRequirement = tooltip
        end
        y = y - 26
        return cb
    end

    mkCheck("Show navigation arrow", function() return ns.profile and ns.profile.showArrow end, function(v)
        if not ns.profile then return end
        ns.profile.showArrow = v and true or false
        if ns.Arrow and ns.Arrow.Update then ns.Arrow:Update() end
        if ns.Print then ns:Print("Navigation arrow: " .. (ns.profile.showArrow and "|cff88ff88ON|r" or "|cffff8888OFF|r")) end
    end, "Shows an arrow toward the current step/waypoint when available (best-effort).")

    mkCheck("Auto-advance steps (best-effort)", function() return ns.profile and ns.profile.autoAdvance end, function(v)
        if not ns.profile then return end
        ns.profile.autoAdvance = v and true or false
        if ns.Print then ns:Print("Auto-advance: " .. (ns.profile.autoAdvance and "|cff88ff88ON|r" or "|cffff8888OFF|r")) end
    end, "Automatically moves to the next step when completion is detected. Manual controls always work.")

    mkCheck("Announce progress in chat", function() return ns.profile and ns.profile.announce end, function(v)
        if not ns.profile then return end
        ns.profile.announce = v and true or false
        if ns.Print then ns:Print("Announcements: " .. (ns.profile.announce and "|cff88ff88ON|r" or "|cffff8888OFF|r")) end
    end)

    mkCheck("Show minimap button", function() return ns.profile and ns.profile.minimap and not ns.profile.minimap.hide end, function(v)
        if not ns.profile then return end
        ns.profile.minimap = ns.profile.minimap or {}
        ns.profile.minimap.hide = not (v and true or false)
        if UI.UpdateMinimapButton then UI:UpdateMinimapButton() end
        if ns.Print then ns:Print("Minimap button: " .. ((ns.profile.minimap.hide) and "|cffff8888OFF|r" or "|cff88ff88ON|r")) end
    end, "Left-click: show/hide panel. Right-click: open Guides. Drag to move.")

    mkCheck("Lock panel position/size", function() return ns.profile and ns.profile.locked end, function(v)
        if not ns.profile then return end
        ns.profile.locked = v and true or false
        if frame and frame.lock and frame.lock.SetChecked then frame.lock:SetChecked(ns.profile.locked and true or false) end
        if UI.Refresh then UI:Refresh() end
        if ns.Print then ns:Print("Panel lock: " .. (ns.profile.locked and "|cff88ff88ON|r" or "|cffff8888OFF|r")) end
    end, "When locked, the guide panel cannot be moved or resized.")

    mkCheck("Update notifications (peer, no internet)", function() return ns.profile and ns.profile.updateNotify ~= false end, function(v)
        if not ns.profile then return end
        ns.profile.updateNotify = v and true or false
        if ns.profile.updateNotify and ns.ScheduleVersionBroadcast then ns:ScheduleVersionBroadcast(2, true) end
        if ns.Print then ns:Print("Update notifications (peer, no internet): " .. (ns.profile.updateNotify and "|cff88ff88ON|r" or "|cffff8888OFF|r")) end
    end, "Best-effort: notifies you if a group/guild peer runs a newer version. No internet and no auto-install. Get updates via CurseForge/WowUp/Wago when released, or from the repo.")

    y = y - 8
    local actions = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    actions:SetPoint("TOPLEFT", 16, y)
    actions:SetText("Quick actions")
    y = y - 30

    local btnRow1 = {
        { "Open Guides", function() UI:Show(); if frame and frame.guidesBtn then ToggleGuidePicker(frame.guidesBtn) end end },
        { "Show Welcome", function() UI:ShowWelcome(true) end },
        { "Reset Window", function() if ns.ResetWindowPosition then ns:ResetWindowPosition() end end },
    }
    local bx = 16
    for _, def in ipairs(btnRow1) do
        local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        b:SetSize(120, 22)
        b:SetPoint("TOPLEFT", bx, y)
        b:SetText(def[1])
        b:SetScript("OnClick", def[2])
        bx = bx + 128
    end
    y = y - 30

    local btnRow2 = {
        { "Reset Settings", function() if ns.ResetAddonSettings then ns:ResetAddonSettings() end end },
        { "Debug Export", function() if ns.ShowDebugExport then ns:ShowDebugExport() end end },
        { "Close", function() panel:Hide() end },
    }
    bx = 16
    for _, def in ipairs(btnRow2) do
        local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        b:SetSize(120, 22)
        b:SetPoint("TOPLEFT", bx, y)
        b:SetText(def[1])
        b:SetScript("OnClick", def[2])
        bx = bx + 128
    end
    y = y - 36

    local help = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    help:SetPoint("TOPLEFT", 16, y)
    help:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, y)
    help:SetJustifyH("LEFT")
    help:SetWordWrap(true)
    help:SetText("Common commands: /flg continue, /flg suggest, /flg goto <n>, /flg way clear, /flg resetui, /flg help.\nRoutes marked scaffold/WIP are original outlines (relative flow) and need WoW Forever in-game verification before release-quality tuning.")

    local about = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    about:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 16, 14)
    about:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 14)
    about:SetJustifyH("LEFT")
    about:SetText("|cff888888" .. tostring(ns.DISPLAY_NAME or panel.name) .. " - v" .. tostring(ns.VERSION or "?") .. " - by ByJTT - " .. tostring(ns.WEB or "https://byjtt.com") .. " - " .. tostring(ns.REPO or "") .. "\nSupport (placeholder): " .. tostring(ns.SUPPORT or "https://buymeacoffee.com/ByJTT") .. "|r")

    optionsPanel = panel

    local registered = false
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local ok, cat = pcall(Settings.RegisterCanvasLayoutCategory, panel, panel.name)
        if ok and cat then
            cat.ID = panel.name
            pcall(Settings.RegisterAddOnCategory, cat)
            panel._settingsCategory = cat
            registered = true
        end
    end
    if not registered and InterfaceOptions_AddCategory then
        pcall(InterfaceOptions_AddCategory, panel)
        registered = true
    end
    panel._registered = registered
    return panel
end

function UI:OpenOptions()
    local panel = self:EnsureOptionsPanel()
    if not panel then
        if ns.Print then ns:Print("Settings UI not available on this client. Use /flg help for commands.") end
        return
    end

    if Settings and Settings.OpenToCategory and panel._settingsCategory then
        local ok = pcall(Settings.OpenToCategory, panel._settingsCategory.ID or panel._settingsCategory)
        if ok then return end
    end
    if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(panel)
        InterfaceOptionsFrame_OpenToCategory(panel)
        return
    end

    panel:ClearAllPoints()
    panel:SetSize(560, 420)
    panel:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
    panel:SetFrameStrata("DIALOG")
    panel:SetClampedToScreen(true)
    panel:EnableMouse(true)
    panel:SetMovable(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", function(selfFrame) if not (InCombatLockdown and InCombatLockdown()) then selfFrame:StartMoving() end end)
    panel:SetScript("OnDragStop", function(selfFrame) selfFrame:StopMovingOrSizing() end)
    if not panel._standaloneStyled then
        if panel.SetBackdrop then
            panel:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = true, tileSize = 32, edgeSize = 32,
                insets = { left = 11, right = 12, top = 12, bottom = 11 }
            })
        else
            local bg = panel:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(true)
            bg:SetColorTexture(0, 0, 0, 0.92)
            panel._standaloneBg = bg
        end
        panel._standaloneStyled = true
    end
    panel:Show()
    if ns.Print then ns:Print("Settings panel opened (standalone). Drag to move; use Close to dismiss.") end
end
