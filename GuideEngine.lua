local _, ns = ...

ns.Engine = ns.Engine or {}
local Engine = ns.Engine

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if ok then return a, b, c, d end
    return nil
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

local function GetItemCountSafe(item)
    if item == nil or item == "" then return 0 end
    if type(GetItemCount) == "function" then
        local ok, n = pcall(GetItemCount, item, false)
        if ok and type(n) == "number" then return n end
        local ok2, n2 = pcall(GetItemCount, item, true)
        if ok2 and type(n2) == "number" then return n2 end
        local ok3, n3 = pcall(GetItemCount, item)
        if ok3 and type(n3) == "number" then return n3 end
    end
    if C_Item and type(C_Item.GetItemCount) == "function" then
        local ok, n = pcall(C_Item.GetItemCount, item, false)
        if ok and type(n) == "number" then return n end
        local ok2, n2 = pcall(C_Item.GetItemCount, item)
        if ok2 and type(n2) == "number" then return n2 end
    end
    return 0
end

function Engine:GetGuide()
    return ns:GetCurrentGuide()
end

function Engine:GetStep(index)
    local guide = self:GetGuide()
    if not guide or type(guide.steps) ~= "table" then return nil, index, 0 end
    if index == nil then
        index = (ns.charDB and ns.charDB.stepIndex) or 1
    end
    return guide.steps[index], index, #guide.steps
end

function Engine:ClampIndex()
    if not ns.charDB then return 1 end
    local guide = self:GetGuide()
    if not guide or type(guide.steps) ~= "table" then
        ns.charDB.stepIndex = 1
        return 1
    end

    local total = #guide.steps
    local idx = ToNumber(ns.charDB.stepIndex) or 1
    if idx < 1 then idx = 1 end
    if idx > total + 1 then idx = total + 1 end
    ns.charDB.stepIndex = idx
    return idx
end

function Engine:IsComplete(index)
    if not ns.charDB or type(ns.charDB.completed) ~= "table" then return false end
    index = ToNumber(index or ns.charDB.stepIndex)
    if not index then return false end
    return ns.charDB.completed[index] == true
end

function Engine:GetStepTitle(step, index)
    if type(step) ~= "table" then
        return index and ("Step " .. tostring(index)) or "Step"
    end
    local title = step.title or step.name or step.text or step.desc
    if title and tostring(title) ~= "" then return tostring(title) end

    local t = NormalizeType(step)
    local q = step.quest or step.questID or step.questId or step.id
    if t == "accept" or t == "pickup" or t == "take" or t == "start" then
        return q and ("Accept quest " .. tostring(q)) or "Accept quest"
    elseif t == "turnin" or t == "handin" or t == "finish" or t == "deliver" or t == "submit" then
        return q and ("Turn in quest " .. tostring(q)) or "Turn in quest"
    elseif t == "complete" or t == "do" or t == "objective" or t == "objectives" or t == "progress" or t == "work" then
        return q and ("Complete quest " .. tostring(q)) or "Complete objective"
    elseif t == "goto" or t == "travel" or t == "move" or t == "run" or t == "fly" or t == "taxi" or t == "discover" or t == "arrive" or t == "path" or t == "waypoint" then
        return "Travel"
    elseif t == "level" or t == "grind" or t == "xp" or t == "ding" or t == "reach" then
        local need = ToNumber(step.level or step.toLevel or step.value or step.at or step.required)
        return need and ("Reach level " .. tostring(need)) or "Reach level"
    elseif t == "hearth" or t == "hearthstone" then
        return "Use hearthstone"
    elseif t == "sethearth" or t == "inn" or t == "home" or t == "bind" then
        return "Set hearthstone"
    elseif t == "train" or t == "learn" or t == "trainer" then
        return "Train skills"
    elseif t == "buy" or t == "vendor" or t == "sell" or t == "repair" then
        return "Vendor / supplies"
    elseif t == "collect" or t == "item" or t == "getitem" or t == "get" or t == "loot" or t == "gather" or t == "acquire" or t == "purchase" then
        return "Collect items"
    elseif t == "use" then
        return "Use item"
    elseif t == "kill" or t == "grindmobs" then
        return "Kill targets"
    elseif t == "class" or t == "profession" or t == "spell" then
        return "Class / profession step"
    end
    return index and ("Step " .. tostring(index)) or "Step"
end

function Engine:MarkComplete(index, reason)
    if not ns.charDB then return end
    if type(ns.charDB.completed) ~= "table" then ns.charDB.completed = {} end

    index = ToNumber(index or ns.charDB.stepIndex)
    if not index then return end

    local guide = self:GetGuide()
    local total = (guide and type(guide.steps) == "table" and #guide.steps) or 0
    if index < 1 or index > total then return end
    if ns.charDB.completed[index] then return end

    ns.charDB.completed[index] = true

    local step = guide.steps[index]
    local title = self:GetStepTitle(step, index)

    if reason == "skipped" then
        ns:Announce("Skipped: " .. title)
    elseif reason == "manual" then
        ns:Announce("Completed: " .. title)
    elseif reason == "arrived" then
        ns:Announce("Arrived: " .. title)
    elseif reason == "auto" then
        if ns.profile and ns.profile.announce then
            ns:Print("Completed (auto): " .. title)
        end
    elseif reason then
        ns:Announce("Completed: " .. title)
    end
end

function Engine:NextStep(reason)
    if not ns.charDB then return end
    local guide = self:GetGuide()
    local total = (guide and type(guide.steps) == "table" and #guide.steps) or 0
    local idx = self:ClampIndex()

    if total == 0 then return end
    if idx > total then
        ns:RefreshUI()
        return
    end

    self:MarkComplete(idx, reason or "manual")
    ns.charDB.stepIndex = idx + 1
    self:ClampIndex()
    if ns.charDB.stepIndex > total and total > 0 then
        if ns and ns.Announce then
            ns:Announce("Guide complete: " .. tostring(guide.title or guide.name or "Guide"))
        end
        if ns and ns.PrintSuggestedGuide then
            ns:PrintSuggestedGuide()
        end
    end
    ns:RefreshUI()
    self:EvaluateCurrent(reason or "advance")
end

function Engine:PrevStep()
    if not ns.charDB then return end
    local idx = ToNumber(ns.charDB.stepIndex) or 1
    idx = idx - 1
    if idx < 1 then idx = 1 end

    -- Clear completion/skipped state for the target step and all later steps so
    -- "go back" provides a clean re-do path from that point forward.
    if type(ns.charDB.completed) ~= "table" then ns.charDB.completed = {} end
    if type(ns.charDB.skipped) ~= "table" then ns.charDB.skipped = {} end
    local guide = self:GetGuide()
    local total = (guide and type(guide.steps) == "table" and #guide.steps) or idx
    if total < idx then total = idx end
    for i = idx, total do
        ns.charDB.completed[i] = nil
        ns.charDB.skipped[i] = nil
    end

    ns.charDB.stepIndex = idx
    self:ClampIndex()
    ns:RefreshUI()
    self:EvaluateCurrent("prev")
end

function Engine:SkipStep()
    if not ns.charDB then return end
    if type(ns.charDB.skipped) ~= "table" then ns.charDB.skipped = {} end
    local idx = self:ClampIndex()
    local guide = self:GetGuide()
    local total = (guide and type(guide.steps) == "table" and #guide.steps) or 0
    if total == 0 or idx > total then return end

    ns.charDB.skipped[idx] = true
    self:MarkComplete(idx, "skipped")
    ns.charDB.stepIndex = idx + 1
    self:ClampIndex()
    if ns.charDB.stepIndex > total and total > 0 then
        if ns and ns.Announce then
            ns:Announce("Guide complete: " .. tostring(guide.title or guide.name or "Guide"))
        end
        if ns and ns.PrintSuggestedGuide then
            ns:PrintSuggestedGuide()
        end
    end
    ns:RefreshUI()
    self:EvaluateCurrent("skip")
end

function Engine:ResetProgress()
    if not ns.charDB then return end
    ns.charDB.stepIndex = 1
    ns.charDB.completed = {}
    ns.charDB.skipped = {}
    ns:Print("Progress reset for this character and guide.")
    ns:RefreshUI()
    self:EvaluateCurrent("reset")
end

local function IsQuestInLog(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsOnQuest then
        local res = SafeCall(C_QuestLog.IsOnQuest, questID)
        if res ~= nil then return res and true or false end
    end
    if GetQuestLogIndexByID then
        local idx = SafeCall(GetQuestLogIndexByID, questID)
        if type(idx) == "number" then return idx > 0 end
    end
    return false
end

local function IsQuestComplete(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsComplete then
        local res = SafeCall(C_QuestLog.IsComplete, questID)
        if res ~= nil then return res and true or false end
    end
    if C_QuestLog and C_QuestLog.IsQuestComplete then
        local res = SafeCall(C_QuestLog.IsQuestComplete, questID)
        if res ~= nil then return res and true or false end
    end
    if IsQuestComplete then
        local res = SafeCall(IsQuestComplete, questID)
        if res == true or res == 1 then return true end
    end
    if IsQuestObjectivesComplete then
        local res = SafeCall(IsQuestObjectivesComplete, questID)
        if res == true or res == 1 then return true end
    end
    return false
end

local function IsQuestFlaggedCompleted(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        local res = SafeCall(C_QuestLog.IsQuestFlaggedCompleted, questID)
        if res ~= nil then return res and true or false end
    end
    if IsQuestFlaggedCompleted then
        local res = SafeCall(IsQuestFlaggedCompleted, questID)
        if res == true or res == 1 then return true end
    end
    return false
end

function Engine:StepSatisfied(step)
    if type(step) ~= "table" then return false end
    if step.satisfied == true or step.complete == true or step.completed == true then return true end

    local t = NormalizeType(step)
    local q = step.quest or step.questID or step.questId or step.id

    if t == "accept" or t == "pickup" or t == "take" or t == "start" then
        if q and (IsQuestInLog(q) or IsQuestComplete(q) or IsQuestFlaggedCompleted(q)) then
            return true
        end
        return false
    elseif t == "turnin" or t == "handin" or t == "finish" or t == "deliver" or t == "submit" then
        if q and IsQuestFlaggedCompleted(q) then
            return true
        end
        return false
    elseif t == "complete" or t == "do" or t == "objectives" or t == "objective" or t == "progress" or t == "work" then
        if q and (IsQuestComplete(q) or IsQuestFlaggedCompleted(q)) then
            return true
        end
        return false
    elseif t == "collect" or t == "item" or t == "getitem" or t == "get" or t == "loot" or t == "gather" or t == "acquire" or t == "purchase" then
        local item = step.item or step.itemID or step.itemId or step.itemName
        local need = ToNumber(step.count or step.amount or step.quantity or step.qty or step.need or step.required) or 1
        if need < 1 then need = 1 end
        if item ~= nil and item ~= "" then
            local have = GetItemCountSafe(item)
            if have >= need then return true end
        end
        if q and (IsQuestComplete(q) or IsQuestFlaggedCompleted(q)) then
            return true
        end
        return false
    elseif t == "level" or t == "grind" or t == "ding" or t == "xp" or t == "reach" then
        local need = ToNumber(step.level or step.toLevel or step.value or step.at or step.required)
        if need and UnitLevel then
            local lvl = ToNumber(SafeCall(UnitLevel, "player")) or 0
            if lvl >= need then return true end
        end
        return false
    elseif t == "goto" or t == "travel" or t == "fly" or t == "taxi" or t == "move" or t == "run"
        or t == "discover" or t == "arrive" or t == "path" or t == "waypoint" then
        -- Arrival-based completion is handled by Tracker via IsPlayerNear.
        return false
    end

    -- Informational/manual by default: note, talk, train, hearth, sethearth/inn, use, kill, vendor/sell/repair, class/profession, etc.
    return false
end

function Engine:EvaluateCurrent(source)
    if not (ns.profile and ns.profile.autoAdvance) then return end
    if not ns.charDB then return end

    local guide = self:GetGuide()
    if not guide or type(guide.steps) ~= "table" then return end

    local safety = 0
    local changed = false
    while safety < 40 do
        safety = safety + 1
        local idx = self:ClampIndex()
        local step = guide.steps[idx]
        if not step then break end

        -- Guide complete state.
        if idx > #guide.steps then break end

        if self:StepSatisfied(step) then
            self:MarkComplete(idx, "auto")
            if idx >= #guide.steps then
                ns.charDB.stepIndex = #guide.steps + 1
                changed = true
                if ns and ns.Announce then
                    ns:Announce("Guide complete: " .. tostring(guide.title or guide.name or "Guide"))
                end
                if ns and ns.PrintSuggestedGuide then
                    ns:PrintSuggestedGuide()
                end
                break
            end
            ns.charDB.stepIndex = idx + 1
            changed = true
        else
            break
        end
    end

    if changed or source == "init" or source == "toggle" or source == "reset" then
        ns:RefreshUI()
    end
end

function Engine:GetPlayerMapPosition(mapID)
    if not mapID or not C_Map then return nil, nil end

    mapID = ToNumber(mapID) or mapID

    if C_Map.GetBestMapForUnit then
        local ok, current = pcall(C_Map.GetBestMapForUnit, "player")
        if ok and current and mapID and tonumber(current) and tonumber(mapID) and tonumber(current) ~= tonumber(mapID) then
            return nil, nil
        end
    end

    if C_Map.GetPlayerMapPosition then
        local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
        if ok and pos then
            local x, y = pos.x, pos.y
            if (x == nil or y == nil) and type(pos.GetXY) == "function" then
                local ok2, ax, ay = pcall(pos.GetXY, pos)
                if ok2 then x, y = ax, ay end
            end
            if type(x) == "number" and type(y) == "number" and (x > 0 or y > 0) then
                return x, y
            end
        end
    end

    return nil, nil
end

function Engine:IsPlayerNear(step, threshold)
    if type(step) ~= "table" or type(step.coords) ~= "table" then return false end

    local t = ToNumber(step.radius)
    if t == nil then t = ToNumber(threshold) end
    if t == nil or t <= 0 then t = 0.03 end

    local c = step.coords
    local mapID = c.mapID or c.mapId or c.map or c.uiMapID
    local tx = ToNumber(c.x or c.X)
    local ty = ToNumber(c.y or c.Y)
    if not mapID or tx == nil or ty == nil then return false end

    if tx > 1 then tx = tx / 100 end
    if ty > 1 then ty = ty / 100 end

    local px, py = self:GetPlayerMapPosition(mapID)
    if not px or not py then return false end

    local dx = px - tx
    local dy = py - ty
    return (dx * dx + dy * dy) <= (t * t)
end

function Engine:Initialize()
    if not ns.charDB then return end
    self:ClampIndex()
    self:EvaluateCurrent("init")
end
