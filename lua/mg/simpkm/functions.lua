local function todo_cycle()
    local line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local indent, text = line:match("^(%s*)(.*)$")
    local prefixedText
    local charsAdded = 0

    if text:match("^%-%s*$") then
        prefixedText = "- [ ] "
        charsAdded = 6
    elseif text:match("^%-%s*%[%s?%]") then
        prefixedText = text:gsub("^%-%s*%[%s?%]", "- [x]")
    elseif text:match("^%-%s*%[x%]") then
        prefixedText = text:gsub("^%-%s*%[x%]", "- [ ]")
    elseif text:match("^%-%s*.*") then
        prefixedText = text:gsub("^%-%s*", "- [ ] ")
        charsAdded = 4
    else
        prefixedText = "- " .. text
        charsAdded = 2
    end

    -- STFO: we replace the whole line which seems pretty unecessary
    -- -> Maybe we can do this a bit smarter?
    vim.api.nvim_set_current_line(indent .. prefixedText)

    if charsAdded > 0 then
        vim.api.nvim_win_set_cursor(0, {
            row,
            col + charsAdded,
        })
    end
end

return {
    cycle_bullet_todo = todo_cycle
}
