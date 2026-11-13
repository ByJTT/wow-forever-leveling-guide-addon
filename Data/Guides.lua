local _, ns = ...

ns.Guides = ns.Guides or {}

function ns:RegisterGuide(key, guide)
    if type(key) ~= "string" or key == "" then return false end
    if type(guide) ~= "table" then return false end

    guide.key = key
    if type(guide.steps) ~= "table" then guide.steps = {} end
    if guide.title == nil then guide.title = key end

    ns.Guides[key] = guide
    return true
end

function ns:RegisterBundledGuides()
    -- Bundled guides register themselves via TOC-ordered Data/*.lua files.
end
