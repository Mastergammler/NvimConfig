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

--[[print(today_iso())
print(yesterday_iso())
print(tomorrow_iso())
print(now_iso())]]

return {
    today = today_iso,
    yesterday = yesterday_iso,
    tomorrow = tomorrow_iso,
    now = now_iso
}
