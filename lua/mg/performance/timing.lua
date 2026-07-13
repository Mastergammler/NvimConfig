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
    measure = measure_void_function
}
