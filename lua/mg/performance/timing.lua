local struct_timer = {
    start_nanos = 0,
    update_nanos = 0,
};

local function start(timer)
    timer.start_nanos = vim.uv.hrtime()
    timer.update_nanos = timer.start_nanos
end

local function update(timer)
    timer.update_nanos = vim.uv.hrtime()
end

local function elapsed_ms(timer)
    return (vim.uv.hrtime() - timer.update_nanos) / 1e6
end

local function elapsed_total_ms(timer)
    return (vim.uv.hrtime() - timer.start_nanos) / 1e6
end

--- measures execution time based on nanoseconds
---@param fn function Function to pass in to be measured
---@param ... params Arguments that should be passed to the function
local function measure_void_function(msg, fn, ...)
    local startNanos = vim.uv.hrtime()
    fn(...)
    local elapsed = vim.uv.hrtime() - startNanos

    local elpasedMs = elapsed / 1e6

    print(msg, string.format("%.3f ms", elpasedMs))
end

return {
    measure = measure_void_function,
    start = start,
    update = update,
    since_update = elapsed_ms,
    since_start = elapsed_total_ms
}
