--[[
-- Util funcitons for determine project paths / files etc
--]]

local function delim()
    local is_windows = vim.loop.os_uname().sysname:match("Windows")
    return is_windows and "\\" or "/"
end

local debug = true
local debug_buffer = nil

--TODO: extract to generalized debug functions?
local function createDebugBuffer()
    if not debug_buffer or not vim.api.nvim_buf_is_valid(debug_buffer) then
        debug_buffer = vim.api.nvim_create_buf(false, true)
        --vim.api.nvim_buf_set_name(debug_buffer, "Debug Log")
        vim.api.nvim_buf_set_option(debug_buffer, "buftype", "nofile")
    end
    return debug_buffer
end

local function debugLog(...)
    if debug then
        local buffer = createDebugBuffer()
        local curFocusBufNr = vim.api.nvim_win_get_buf(0)
        if curFocusBufNr ~= debug_buffer then
            -- clear buffer, when opening new
            vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {})
            -- opening new buffer below -> setting height to 10 lines
            vim.api.nvim_command("belowright split | resize 10")
            vim.api.nvim_command("buffer " .. buffer)
        end

        local message = table.concat({ ... }, " ")
        vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { message })
    end
end

local function printExecutionTime(startTime, finishedTime)
    local timeSeconds = finishedTime - startTime
    local timeMillsecond = timeSeconds * 1000

    -- NOTE: it seems like it only tracks to ms precision
    print(string.format("The operation took %d ms", timeMillsecond));
end

--- Gets the parent directory from either a file or directory
--- This is just a string modification function, it doens't actually check for existing paths
--- @param path (string) The path from which to get the parent directory from
local function getParentDir(path)
    return vim.fn.fnamemodify(path, ":h")
end


local function searchPatternInDir(searchPattern, dir)
    -- NOTE: returns a string containing the file paths
    -- TODO: does this path work also on linux?
    local foundFiles = vim.fn.glob(dir .. delim() .. searchPattern)

    if foundFiles and foundFiles ~= "" then
        return foundFiles
    end

    -- not found just return null
    return nil
end

local function findFilePathUptree(searchFile, startSearchDir)
    local currentSearchDir = startSearchDir
    local workspaceRootDir = vim.fn.getcwd()
    debugLog("Detected root dir:", workspaceRootDir)
    local currentFileToCheck = nil

    while currentSearchDir ~= '' do
        debugLog("Searching in dir:", currentSearchDir)
        currentFileToCheck = searchPatternInDir(searchFile, currentSearchDir)
        if currentFileToCheck then break end

        if #currentSearchDir <= #workspaceRootDir then
            debugLog("Unable to find file '", searchFile, "' up-path within working dir", workspaceRootDir)
            return nil
        end
        assert(#currentSearchDir > #workspaceRootDir,
            "Did not find the file " .. searchFile .. " within the scope of the workspace " .. workspaceRootDir)
        currentSearchDir = getParentDir(currentSearchDir)
    end

    debugLog("Found file", currentFileToCheck)

    return currentFileToCheck
end

local function getBufferFilePath()
    local bufferFilePath = vim.api.nvim_buf_get_name(0);
    return bufferFilePath
end

--- tries to find a project file based on the given path and glob pattern
--- @param opts: {TargetfilePath?, GlobPattern}
local function findProjectFile(opts)
    if opts.TargetFilePath == nil then
        opts.TargetFilePath = getBufferFilePath()
    end
    local startSearchDir = getParentDir(opts.TargetFilePath)
    debugLog("Start search dir: ", startSearchDir)
    return findFilePathUptree(opts.GlobPattern, startSearchDir)
end

function test()
    local curPath = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")
    local file = findProjectFile({ GlobPattern = "init*" })
end

vim.keymap.set("n", "<leader>gc", function()
    vim.cmd("w")
    vim.cmd("so")
    test()
end, { desc = "go command!!!! - runs a test function somewhere" });

return {
    print_execution_time = printExecutionTime,
    find_project_file = findProjectFile
}
