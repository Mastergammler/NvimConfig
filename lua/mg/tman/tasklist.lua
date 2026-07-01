--  TEST:
--  TASKLIST: 133 Do something [8/9]
-- ✔ this is my item
-- ✔ this is done
-- ✔ hello world
-- ✔ this needs to be done
-- ✔ this is done
-- ✔ helllo
-- - hello
--
-- Hello world
-- ✔ hi
-- ✔ okey

-- [[
-- TODO: MOVE to todo module or something
-- NOTE: Limited to the first tasklist in the file
-- Will not work with block comments!
-- Will replace any string behind the tasklist
-- TODO:
-- - just append count to the end
-- ✔ auto detect list changes / new item shortcut?
-- ]]
local function update_tasklist()
    local bufnr             = vim.api.nvim_get_current_buf()
    local lines             = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local commentPrefix     = vim.bo.commentstring:gsub("%%s", "")
    local prefixPat         = vim.pesc(commentPrefix:gsub("%s+$", ""))
    local tasklistPat       = "^%s*" .. prefixPat .. "%s*TASKLIST:"
    local todoPat           = "^%s*" .. prefixPat .. "%s* %- "
    local donePat           = "^%s*" .. prefixPat .. "%s* ✔ "
    local commentPat        = "^%s*" .. prefixPat
    local tasksSubPat       = "%s*%[%d+/%d+%]%s*$";

    local tasklistHeaderIdx = nil

    -- Find TASKLIST header
    for i, line in ipairs(lines) do
        if line:match(tasklistPat) then
            tasklistHeaderIdx = i
            break
        end
    end

    if not tasklistHeaderIdx then
        return
    end

    local taskInfo = { total = 0, done = 0 };

    -- search lines after tasklist
    for i = tasklistHeaderIdx + 1, #lines do
        local line = lines[i]

        -- when the comment ends we stop
        if not line:match(commentPat) then
            break
        end

        if line:match(todoPat) then
            taskInfo.total = taskInfo.total + 1
        elseif line:match(donePat) then
            taskInfo.total = taskInfo.total + 1
            taskInfo.done = taskInfo.done + 1
        end
    end


    -- Remove existing [x/y] at the end (if any)
    local headerPrefix = lines[tasklistHeaderIdx]:gsub(tasksSubPat, "");
    local newHeader    = {
        string.format("%s [%d/%d]", headerPrefix, taskInfo.done, taskInfo.total)
    }
    vim.api.nvim_buf_set_lines(bufnr, tasklistHeaderIdx - 1, tasklistHeaderIdx, true, newHeader)
end

local function mark_as_done()
    local current_line = vim.api.nvim_get_current_line()
    local new_line = current_line:gsub(' %- ', ' ✔ ')
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
    update_tasklist()
end

return {
    update_tasklist = update_tasklist,
    mark_done_under_cursor = mark_as_done
}
