-- TASKLIST:
-- - parse based on input string and then +1 etc
-- - current CW functions

local function today_iso()
    return os.date("%Y-%m-%d")
end

local function now_iso()
    return os.date("%Y-%m-%dT%H:%M")
end

-- TODO: is this utc or what is it?
-- -> Prolly not, just os functionality?
local function yesterday_iso()
    return os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
end

local function tomorrow_iso()
    return os.date("%Y-%m-%d", os.time() + 24 * 60 * 60)
end

local function date_from(baseIso, daysOffset)
    local y, m, d = baseIso:match("^(%d+)%-(%d+)%-(%d+)$")

    if daysOffset == nil then
        daysOffset = 0
    end

    return os.date("%Y-%m-%d", os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d) + daysOffset,
        houre = 12
    }))
end

local function cw(dateIso)
    local y, m, d = dateIso:match("^(%d+)%-(%d+)%-(%d+)$")

    local t = os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        houre = 12
    })

    return os.date("%V", t)
end

local function year(dateIso)
    return dateIso:sub(3, 4)
end

--[[print(today_iso())
print(yesterday_iso())
print(tomorrow_iso())
print(now_iso())]]

return {
    today = today_iso,
    yesterday = yesterday_iso,
    tomorrow = tomorrow_iso,
    now = now_iso,
    by_offset = date_from,
    cw = cw,
    year_short = year
}
