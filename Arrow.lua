local _, ns = ...

ns.Arrow = ns.Arrow or {}
local Arrow = ns.Arrow

Arrow.frame = Arrow.frame or nil
Arrow.enabled = (Arrow.enabled ~= false)
Arrow.target = Arrow.target or nil

local ARROW_TEXTURE = "Interface\\Minimap\\MiniMap-QuestArrow" -- may or may not exist on all clients
local PI2 = math.pi * 2

local function GetPlayerMapAndPos()
    if not C_Map or not C_Map.GetBestMapForUnit or not C_Map.GetPlayerMapPosition then
        return nil, nil, nil
    end
    local okMap, mapID = pcall(C_Map.GetBestMapForUnit, "player")
    if not okMap or not mapID then return nil, nil, nil end
    local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
    if not okPos or not pos then return mapID, nil, nil end

    local x, y = pos.x, pos.y
    if (x == nil or y == nil) and type(pos.GetXY) == "function" then
        local okXY, ax, ay = pcall(pos.GetXY, pos)
        if okXY then x, y = ax, ay end
    end
    if type(x) ~= "number" or type(y) ~= "number" then return mapID, nil, nil end
    return mapID, x, y
end

local function GetFacingSafe()
    local ok, facing = pcall(GetPlayerFacing)
    if ok and type(facing) == "number" then return facing end
    return nil
end

local function NormalizeCoord(v)
    local n = tonumber(v)
    if not n then return nil end
    if n > 1 then n = n / 100 end
    if n < 0 or n > 1 then return nil end
    return n
end

local function NormalizeTargetCoords(target)
    if type(target) ~= "table" then return nil end
    local c = target.coords or target
    if type(c) ~= "table" then return nil end
    local mapID = tonumber(c.mapID or c.mapId or c.map or c.uiMapID)
    local x = NormalizeCoord(c.x or c.X)
    local y = NormalizeCoord(c.y or c.Y)
    if not mapID or not x or not y then return nil end
    return mapID, x, y
end

function Arrow:Create()
    if self.frame then return self.frame end

    local f = CreateFrame("Frame", "ForeverLevelingGuideArrow", UIParent)
    f:SetSize(64, 64)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
    f:SetFrameStrata("MEDIUM")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(selfFrame)
        if ns.profile and ns.profile.arrowLocked == false then
            selfFrame:StartMoving()
        end
    end)
    f:SetScript("OnDragStop", function(selfFrame)
        selfFrame:StopMovingOrSizing()
    end)
    f:Hide()

    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints(true)
    local ok = tex:SetTexture(ARROW_TEXTURE)
    if not ok then
        tex:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    end
    tex:SetVertexColor(0.2, 1.0, 0.4, 1.0)
    f.texture = tex

    local dist = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dist:SetPoint("TOP", f, "BOTTOM", 0, -2)
    dist:SetText("")
    f.distText = dist

    local label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("BOTTOM", f, "TOP", 0, 2)
    label:SetWidth(260)
    label:SetWordWrap(false)
    label:SetText("")
    f.labelText = label

    f:SetScript("OnUpdate", function(_, elapsed)
        Arrow:OnUpdate(elapsed)
    end)

    self.frame = f
    return f
end

function Arrow:SetEnabled(enabled)
    self.enabled = not not enabled
    if ns.profile then ns.profile.showArrow = self.enabled end
    if not self.enabled then
        self:ClearTomTomWaypoint()
        self:ClearTarget()
        return
    end
    self:Update(0)
end

function Arrow:SetTarget(target)
    if type(target) ~= "table" then
        self:ClearTarget()
        return
    end

    local mapID, x, y = NormalizeTargetCoords(target)
    if not mapID or not x or not y then
        self:ClearTarget()
        return
    end

    local title = target.title or target.name or target.stepTitle or "Objective"
    local zone = target.zone
    local prev = self.target
    local same = prev and prev.mapID == mapID and prev.x == x and prev.y == y and prev.title == title and prev.zone == zone

    self.target = {
        mapID = mapID,
        x = x,
        y = y,
        title = title,
        zone = zone,
    }

    self:Create()
    if not same then
        -- Only (re)set waypoint when the logical target changes to avoid TomTom churn.
        self._tomtomKey = nil
    end
    self:ApplyVisibility()
end

function Arrow:ClearTarget()
    self.target = nil
    self:ClearTomTomWaypoint()
    if self.frame then
        self.frame:Hide()
        if self.frame.distText then self.frame.distText:SetText("") end
        if self.frame.labelText then self.frame.labelText:SetText("") end
        if self.frame.texture then
            self.frame.texture:SetRotation(0)
            self.frame.texture:SetVertexColor(0.2, 1.0, 0.4, 1.0)
        end
    end
end

function Arrow:ApplyVisibility()
    if not self.frame then return end
    local panelShown = not (ns.profile and ns.profile.ui and ns.profile.ui.shown == false)
    local want = self.enabled and self.target ~= nil and (ns.profile and ns.profile.showArrow) and panelShown
    if want then
        self.frame:Show()
        if self.target then
            self:TrySetTomTomWaypoint(self.target.mapID, self.target.x, self.target.y, self.target.title)
        end
    else
        self.frame:Hide()
        self:ClearTomTomWaypoint()
    end
end

function Arrow:SetVisible(visible)
    -- Visibility is derived from enabled state + valid target from the current step.
    if visible == false then
        if self.frame then self.frame:Hide() end
        return
    end
    self:ApplyVisibility()
end

function Arrow:RefreshTargetFromStep()
    local panelShown = not (ns.profile and ns.profile.ui and ns.profile.ui.shown == false)
    local wantArrow = ns.profile and ns.profile.showArrow

    -- Keep enabled state aligned with the user's preference; visibility is handled separately.
    self.enabled = wantArrow and true or false

    if not wantArrow or not panelShown then
        self:ClearTarget()
        return
    end

    local guide = ns:GetCurrentGuide()
    local steps = (guide and type(guide.steps) == "table") and guide.steps or nil
    if not guide or not steps or #steps == 0 then
        self:ClearTarget()
        return
    end

    local idx = tonumber(ns.charDB and ns.charDB.stepIndex) or 1
    if idx < 1 or idx > #steps then
        self:ClearTarget()
        return
    end

    local step = steps[idx]
    if type(step) ~= "table" or type(step.coords) ~= "table" then
        self:ClearTarget()
        return
    end

    local mapID, x, y = NormalizeTargetCoords(step.coords)
    if not mapID or not x or not y then
        self:ClearTarget()
        return
    end

    local title = "Objective"
    if ns.Engine and ns.Engine.GetStepTitle then
        title = ns.Engine:GetStepTitle(step, idx)
    else
        title = step.title or step.name or step.desc or guide.title or "Objective"
    end

    self:SetTarget({
        coords = step.coords,
        title = title,
        zone = step.zone or step.area or step.subzone,
    })
end

function Arrow:OnUpdate(elapsed)
    if not self.enabled or not self.frame then return end
    self._elapsed = (self._elapsed or 0) + (elapsed or 0)
    if self._elapsed < 0.05 then return end
    self._elapsed = 0
    self:Update(0)
end

function Arrow:Update(_)
    self:Create()

    -- Keep target in sync with current step/profile state.
    self:RefreshTargetFromStep()

    if not self.enabled or not self.target or not self.frame or not self.frame:IsShown() then
        return
    end

    local mapID, px, py = GetPlayerMapAndPos()
    local t = self.target
    local label = t.title or "Objective"
    if t.zone and t.zone ~= "" then
        label = label .. " (" .. tostring(t.zone) .. ")"
    end

    if not mapID or not px or not py then
        self.frame.texture:SetRotation(0)
        self.frame.texture:SetVertexColor(0.9, 0.8, 0.2, 1.0)
        self.frame.labelText:SetText(label)
        self.frame.distText:SetText("Position unavailable")
        return
    end

    if t.mapID ~= mapID then
        self.frame.texture:SetRotation(0)
        self.frame.texture:SetVertexColor(0.9, 0.8, 0.2, 1.0)
        self.frame.labelText:SetText(label)
        self.frame.distText:SetText("Different map")
        return
    end

    local dx = (t.x - px)
    local dy = (t.y - py)
    local angle = math.atan2(dx, -dy)
    local facing = GetFacingSafe()
    local rot = angle
    if facing ~= nil then
        rot = angle - facing
    end
    while rot > math.pi do rot = rot - PI2 end
    while rot < -math.pi do rot = rot + PI2 end

    local d = math.sqrt(dx * dx + dy * dy)
    local approxYards = d * 10000
    local distStr
    if approxYards < 15 then
        distStr = "Arrived"
        self.frame.texture:SetVertexColor(0.3, 1.0, 0.4, 1.0)
    else
        distStr = string.format("~%d yd", math.floor(approxYards + 0.5))
        self.frame.texture:SetVertexColor(0.2, 1.0, 0.4, 1.0)
    end

    self.frame.texture:SetRotation(rot)
    self.frame.labelText:SetText(label)
    self.frame.distText:SetText(distStr)
end

function Arrow:TrySetTomTomWaypoint(mapID, x, y, title)
    -- Optional, best-effort integration with TomTom if installed. No dependency required.
    local tt = _G and _G.TomTom
    if not tt or not mapID or not x or not y then
        if not tt then self:ClearTomTomWaypoint() end
        return false
    end

    local key = tostring(mapID) .. ":" .. tostring(x) .. ":" .. tostring(y) .. ":" .. tostring(title or "")
    if self._tomtomUid and self._tomtomKey == key then
        return true
    end

    -- Remove previous waypoint we own (avoid accumulating pins).
    if self._tomtomUid and type(tt.RemoveWaypoint) == "function" then
        pcall(tt.RemoveWaypoint, tt, self._tomtomUid)
        pcall(tt.RemoveWaypoint, self._tomtomUid)
        self._tomtomUid = nil
    end
    self._tomtomKey = nil

    local uid
    if type(tt.AddWaypoint) == "function" then
        -- Common signatures across TomTom variants; try safely.
        local ok, res = pcall(tt.AddWaypoint, tt, mapID, x, y, { title = title or "Guide objective", persistent = false, minimap = true, world = true, crazy = true, from = "FLG" })
        if ok and res ~= nil then uid = res end
        if not uid then
            ok, res = pcall(tt.AddWaypoint, tt, mapID, x, y, title or "Guide objective", false, true, true, true)
            if ok and res ~= nil then uid = res end
        end
        if not uid then
            ok, res = pcall(tt.AddWaypoint, mapID, x, y, { title = title or "Guide objective", persistent = false, minimap = true, world = true, crazy = true, from = "FLG" })
            if ok and res ~= nil then uid = res end
        end
    elseif type(tt.AddMFWaypoint) == "function" then
        local ok, res = pcall(tt.AddMFWaypoint, tt, mapID, nil, x, y, { title = title or "Guide objective" })
        if ok and res ~= nil then uid = res end
    end

    if uid ~= nil then
        self._tomtomUid = uid
        self._tomtomKey = key
        return true
    end
    return false
end

function Arrow:ClearTomTomWaypoint()
    local tt = _G and _G.TomTom
    local uid = self._tomtomUid
    self._tomtomUid = nil
    self._tomtomKey = nil
    if not tt or not uid then
        return
    end
    if type(tt.RemoveWaypoint) == "function" then
        pcall(tt.RemoveWaypoint, tt, uid)
        pcall(tt.RemoveWaypoint, uid)
    end
end

function Arrow:Initialize()
    self:Create()
    if ns.profile then
        self.enabled = ns.profile.showArrow ~= false
    end
    self:RefreshTargetFromStep()
    self:ApplyVisibility()
    self:Update(0)
end

-- ns helpers (compat)
function ns:ArrowInit()
    Arrow:Initialize()
end

function ns:ArrowSetTarget(target)
    Arrow:SetTarget(target)
end

function ns:ArrowClearTarget()
    Arrow:ClearTarget()
end

function ns:ArrowSetEnabled(enabled)
    Arrow:SetEnabled(enabled)
end

function ns:ArrowSetVisible(visible)
    Arrow:SetVisible(visible)
end

function ns:ArrowUpdate()
    Arrow:Update(0)
end
