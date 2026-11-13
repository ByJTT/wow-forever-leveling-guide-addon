local _, ns = ...

ns.Tracker = ns.Tracker or {}
local Tracker = ns.Tracker

local frame = CreateFrame("Frame")
local initialized = false

local EVENTS = {
    "QUEST_ACCEPTED",
    "QUEST_TURNED_IN",
    "QUEST_REMOVED",
    "QUEST_LOG_UPDATE",
    "UNIT_QUEST_LOG_CHANGED",
    "PLAYER_LEVEL_UP",
    "ZONE_CHANGED",
    "ZONE_CHANGED_NEW_AREA",
    "ZONE_CHANGED_INDOORS",
    "PLAYER_ENTERING_WORLD",
    "BAG_UPDATE",
    "BAG_UPDATE_DELAYED",
}

local function SafeAfter(delay, fn)
    if type(fn) ~= "function" then return end
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(delay, fn)
    else
        fn()
    end
end

local function NormalizeType(t)
    t = tostring(t or ""):lower()
    t = t:gsub("[%s%-_]+", "")
    return t
end

local function IsTravelType(t)
    t = NormalizeType(t)
    return t == "goto" or t == "travel" or t == "move" or t == "run" or t == "fly" or t == "taxi"
        or t == "discover" or t == "arrive" or t == "path" or t == "waypoint"
end

local function EvaluateSoon()
    if not (ns.Engine and ns.Engine.EvaluateCurrent) then return end
    SafeAfter(0.15, function()
        if ns.Engine and ns.Engine.EvaluateCurrent then ns.Engine:EvaluateCurrent("event") end
    end)
    SafeAfter(0.8, function()
        if ns.Engine and ns.Engine.EvaluateCurrent then ns.Engine:EvaluateCurrent("event-delayed") end
    end)
end

local function TryCompleteTravelStep(reason)
    if not (ns.Engine and ns.charDB and ns.profile and ns.profile.autoAdvance) then return false end
    local step = ns.Engine:GetStep(ns.charDB.stepIndex)
    if type(step) ~= "table" then return false end
    if not IsTravelType(step.type or step.kind) then return false end
    if ns.Engine:IsPlayerNear(step, step.radius or 0.03) then
        ns.Engine:NextStep(reason or "arrived")
        return true
    end
    return false
end

function Tracker:OnEvent(event, ...)
    if event == "UNIT_QUEST_LOG_CHANGED" then
        local unit = ...
        if unit and unit ~= "player" then return end
    end

    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED_INDOORS" or event == "PLAYER_ENTERING_WORLD" then
        if ns.Arrow and ns.Arrow.Update then ns.Arrow:Update() end
        if ns.UI and ns.UI.Refresh then ns.UI:Refresh() end
    end

    if TryCompleteTravelStep("arrived") then
        return
    end

    EvaluateSoon()
end

function Tracker:Initialize()
    if initialized then return end
    initialized = true

    for _, ev in ipairs(EVENTS) do
        pcall(frame.RegisterEvent, frame, ev)
    end

    frame:SetScript("OnEvent", function(_, event, ...)
        Tracker:OnEvent(event, ...)
    end)

    if C_Timer and type(C_Timer.NewTicker) == "function" and not self.ticker then
        self.ticker = C_Timer.NewTicker(2.0, function()
            if not (ns.Engine and ns.charDB and ns.profile) then return end

            if TryCompleteTravelStep("arrived") then
                return
            end

            -- Periodic evaluation helps with APIs/events that are inconsistent across clients.
            if ns.profile.autoAdvance and ns.Engine and ns.Engine.EvaluateCurrent then
                ns.Engine:EvaluateCurrent("tick")
            end

            if ns.Arrow and ns.Arrow.Update and ns.profile.showArrow then
                ns.Arrow:Update()
            end
        end)
    end
end
