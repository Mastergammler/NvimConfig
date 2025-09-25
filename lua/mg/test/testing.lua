local buf = nil

local function create_buffer()
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        buf = vim.api.nvim_create_buf(true, true)

        if not buf then
            vim.api.nvim_err_writeln("Failed to create buffer")
            return
        end
        vim.api.nvim_buf_set_name(buf, "*scratch*")
        vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {
        "-- Testing stuff", "", "Stuff in here", "Time: " .. os.time()
    })

    vim.api.nvim_win_set_buf(0, buf)

    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
end

local writeToCurrentBuffer = function(text)
    local currentBuffer = vim.api.nvim_get_current_buf();

    local lines = {};
    for line in string.gmatch(text, "[^\n]+") do
        table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(currentBuffer, 0, 1, true, lines)
end

local writeToNewFile = function(filename, text)
    local currentDir = vim.fn.expand("%:p:h")
    local newFilePath = currentDir .. "/" .. filename

    local file = io.open(newFilePath, "w")

    assert(file, "The file " .. newFilePath .. " could not be created")

    file:write(text)
    file:close()
end

--[[return {
    writeToCurrentBuffer = writeToCurrentBuffer,
    writeToNewFile = writeToNewFile
}]] --

create_buffer()
