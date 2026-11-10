local fs = require 'mg.fs'
local t = require 'mg.performance.timing'

local function open_to_right(bufNr)
    local openWindow = nil
    for _, cur in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(cur) == bufNr then
            openWindow = cur
            break
        end
    end

    if openWindow ~= nil then
        vim.api.nvim_set_current_win(openWindow)
    else
        vim.api.nvim_open_win(bufNr, true, { split = "right" })
        vim.cmd("wincmd L")
    end
end

local function write_to_named_buf(bufName, output)
    local buf = vim.fn.bufnr(bufName)

    if buf == -1 then
        vim.cmd("botright vnew")
        buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(buf, bufName)
    end


    -- no wipe, because we want to reuse it
    --vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].modifiable = true
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].swapfile = false

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
    vim.bo[buf].modifiable = false

    return buf
end

local CHANNEL_MAP = {}
local function write_to_named_term(bufName, output)
    local buf = vim.fn.bufnr(bufName)

    if buf == -1 then
        vim.cmd("botright vnew")
        buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(buf, bufName)
        CHANNEL_MAP[buf] = vim.api.nvim_open_term(buf, {})
    end

    local CLEAR = "\027[2J\027[H"
    vim.api.nvim_chan_send(CHANNEL_MAP[buf], CLEAR .. output .. "\r\n")

    return buf
end

-- TODO: support uptree searching?
local function env_file_name()
    local parentDir = vim.fn.expand('%:h')

    local envPath = parentDir .. '/.env'
    local encEnvPath = parentDir .. '/.env.gpg'

    local envExists = fs.file_exists(envPath)
    local encEnvExists = fs.file_exists(encEnvPath)

    local file = nil

    if encEnvExists then
        file = encEnvPath
    elseif envExists then
        file = envPath
    end

    return { found = envExists or encEnvExists, is_enc = encEnvExists, file = file }
end

local function run()
    local envInfo = env_file_name()

    local fileExt = fs.cur_file_ext()
    local filePath = vim.fn.expand('%')

    if fileExt == 'hurl' then
        local cmd = {}

        table.insert(cmd, "hurl")

        if envInfo.found and envInfo.is_enc then
            table.insert(cmd, "--variables-file <(gpg -d " .. envInfo.file .. ")")
        elseif envInfo.found then
            table.insert(cmd, "--variables-file")
            table.insert(cmd, envInfo.file)
        end

        table.insert(cmd, filePath)

        local cmdStr = table.concat(cmd, ' ')


        local stdoutBuf = {}
        local stderrBuf = {}

        local timer = {}
        t.start(timer)

        local job = vim.fn.jobstart(cmdStr, {
            -- use pty else it doesn't print ansi codes
            pty = true,
            on_stdout = function(job_id, data, event)
                -- data is a list of strings (lines), may be partial
                for _, line in ipairs(data) do
                    table.insert(stdoutBuf, line)
                end
            end,
            on_stderr = function(job_id, data, event)
                for _, line in ipairs(data) do
                    table.insert(stderrBuf, line)
                end
            end,
            on_exit = function(job_id, code, event)
                local content = table.concat(stdoutBuf, '\r\n')

                -- because if it's empty it has like a single "" inside
                if #stdoutBuf < 2 then
                    content = table.concat(stderrBuf, '\r\n')
                end

                local bufName = '[OUT] hurl tmp buffer'
                -- FIXME: WTF? t is not available here??
                --local ms = t.elapsed_ms(timer)
                --local appended = string.format("%s\r\n%.3f ms", content, ms)

                local bufNr = write_to_named_term(bufName, content)


                open_to_right(bufNr)
            end,
        })
    else
        vim.notify("Run hurl requested, but " .. filePath .. " is not a hurl file!", vim.log.levels.WARN)
    end
end

vim.keymap.set("n", "<leader>gc", function()
    vim.cmd("w")
    run()
end, { desc = "go command!!!! - runs a test function somewhere" });


return {
    run_cur_hurl = run
}
