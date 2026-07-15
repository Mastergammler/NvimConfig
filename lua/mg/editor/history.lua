---@type table<integer, {stack: integer[], frame: integer}>
-- TASKLIST:
-- - debug: print history command (to see if it's actually working correctly
-- - clearup the strange logic
-- - check if insert in middle behaviour works as expected
--  -> What is expected even in this case? What do i want here

local navHistory = {};
local internalNavigation = false

local function get_history(winId)
    local winHistory = navHistory[winId]
    if not winHistory then
        winHistory = { stack = {}, frame = 0 }
        navHistory[winId] = winHistory
    end
    return winHistory
end

local function setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
            -- if we jumped to the buffer using the goto_history function
            -- then we don't want it to trigger again!
            if internalNavigation then return end

            local winId = vim.api.nvim_get_current_win()
            local winHist = get_history(winId)
            local buf = args.buf

            if not vim.api.nvim_buf_is_valid(buf) then return end
            if not vim.bo[buf].buflisted then return end
            if winHist.stack[winHist.frame] == buf then return end

            -- TODO: seems quite odd, why do it like that?
            while #winHist.stack > winHist.frame do
                table.remove(winHist.stack)
            end

            table.insert(winHist.stack, buf)
            winHist.frame = #winHist.stack
            --print(string.format("Adding buffer %d to window %d, frame %d", args.buf, winId, winHist.frame))
        end
    })
    vim.api.nvim_create_autocmd("WinClosed", {
        callback = function(args)
            --print("Deleting history for ", args.match)
            navHistory[tonumber(args.match)] = nil
        end
    })
end

local function goto_history(delta)
    local win = vim.api.nvim_get_current_win()
    local winHistory = get_history(win)

    local stackPos = winHistory.frame + delta
    if stackPos < 1 or stackPos > #winHistory.stack then return end

    local buf = winHistory.stack[stackPos]
    if not vim.api.nvim_buf_is_valid(buf) then
        table.remove(winHistory.stack, stackPos)
        -- TODO: why???
        if stackPos <= winHistory.frame then
            winHistory.frame = winHistory.frame - 1
        end
        return
    end

    winHistory.frame = stackPos

    internalNavigation = true
    vim.api.nvim_win_set_buf(win, buf)
    internalNavigation = false
end

local function clear_history()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    local winHistory = get_history(win)
    winHistory.stack = { buf }
    winHistory.frame = 1

    --print("History of win " .. win .. " cleared")
    print(vim.inspect(winHistory))
end

local function back()
    goto_history(-1)
end

local function forward()
    goto_history(1)
end

-- copies the history form the old to the new window
-- else i lose the previous stack
local function history_aware_split(cmd)
    local old = vim.api.nvim_get_current_win()
    local hist = vim.deepcopy(navHistory[old])

    vim.cmd(cmd)

    local new = vim.api.nvim_get_current_win()
    navHistory[new] = hist
end


setup()

return {
    prev_buf = back,
    next_buf = forward,
    clear = clear_history,
    vs = function() history_aware_split("vs") end,
    split = function() history_aware_split("split") end
}
