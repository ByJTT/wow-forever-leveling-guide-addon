local _, ns = ...

ns.UI = ns.UI or {}
local UI = ns.UI

local frame
local guidePicker

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
    frame.progress:SetText((total > 0) and (tostring(shownIdx) .. " / " .. tostring(total)) or "0 / 0")

    local subtitle = guide.title or key or "Guide"
    local meta = {}
    if guide.faction then meta[#meta + 1] = tostring(guide.faction) end
    if guide.minLevel and guide.maxLevel then meta[#meta + 1] = tostring(guide.minLevel) .. "-" .. tostring(guide.maxLevel) end
    if guide.scaffold then meta[#meta + 1] = "scaffold/WIP" end
    if key then meta[#meta + 1] = tostring(key) end
    if #meta > 0 then subtitle = subtitle .. " |cff888888(" .. table.concat(meta, ", ") .. ")|r" end
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
        ns:Print("No guide loaded. Use /flg list and /flg load <key>.")
        return
    end

    local steps = (type(guide.steps) == "table") and guide.steps or {}
    local total = #steps
    local idx = ToNumber(ns.charDB and ns.charDB.stepIndex) or 1
    if idx < 1 then idx = 1 end

    ns:Print(string.format("Guide: %s [%s] (%d/%d)", tostring(guide.title or key), tostring(key), math.min(idx, math.max(total, 1)), total))

    if idx > total then
        ns:Print("Current: Guide complete.")
        return
    end

    local step = steps[idx]
    local title = "Step"
    if ns.Engine and ns.Engine.GetStepTitle then
        title = ns.Engine:GetStepTitle(step, idx)
    elseif step then
        title = step.title or step.name or step.desc or step.type or "Step"
    end
    ns:Print("Current: " .. tostring(title))
end

function UI:Initialize()
    self:Create()
    self:Refresh()
end
