local M = {}

local ParserState = {
    buf_nr = 0,
    line_idx = 0,
    in_string = false,
    namespace = 1
}

local function highlight_cshtml(state, col, c)
    if c == '@' then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@keyword", state.line_idx, col - 1, -1)
    elseif c == '<' then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@attribute", state.line_idx, col - 1, -1)
    elseif c == '>' then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col, -1)
        --TODO: its not about in string, it depends within which parent it is!!!!
        -- -> this is basically just a precidence issue?!
    elseif (c == '.' or c == ',') and not state.in_string then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@property", state.line_idx, col, -1)
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col - 1, col)
    elseif c == '(' then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col - 1, -1)
    elseif c == '"' then
        state.in_string = not state.in_string
        if state.in_string then
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@string", state.line_idx, col - 1, -1)
        else
            -- todo reset to revious
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col, -1)
        end
    end
end

-- first symbol
local csState = {
    within_closue = false,
    word_start = -1,
    line_word_count = 0,
    right_hand_side = false,
    last_c = 0,
    last_word_keyword = false
}
local function highlight_cs(state, col, c)
    if state.last_c == 'i' and c == 'f' then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@keyword", state.line_idx, col - 2, col)
        state.last_word_keyword = true
    elseif c:match('%a') then
        if state.word_start == -1 then
            state.word_start = col
            if state.right_hand_side then
                --FIXME: dunno why this doesn't work, it overrides the function ...
                --vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col - 1, -1)
            end
        end
        if col == 1 then
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@keyword", state.line_idx, col - 1, -1)
        end
    elseif c == ' ' then
        state.word_start = -1
        state.line_word_count = state.line_word_count + 1
        state.last_word_keyword = false
    elseif c == '?' or c == '!' then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "CurSearch", state.line_idx, col - 1, col)
    elseif c:match('%d') and not state.in_string then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@number", state.line_idx, col - 1, col)
    elseif not state.in_string and (c == '>' or c == '<' or c == '=' or c == '-' or c == '+' or c == '|' or c == '&') then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@operator", state.line_idx, col - 1, col)
        if c == '=' then state.right_hand_side = true end
    elseif not state.in_string and (c == '[' or c == ']' or c == ';') then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col - 1, col)
    elseif (c == '.' or c == ',') and not state.in_string then
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@property", state.line_idx, col, -1)
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col - 1, col)
        state.word_start = -1
        state.last_word_keyword = false
        state.line_word_count = state.line_word_count + 1
    elseif c == '(' then
        if state.word_start ~= -1 and not state.last_word_keyword then
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@function", state.line_idx, state.word_start -
                1, col)
            state.word_start = -1
            state.last_word_keyword = false
            state.line_word_count = state.line_word_count + 1
        end
        vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col - 1, -1)
    elseif c == '"' then
        state.in_string = not state.in_string
        if state.in_string then
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@string", state.line_idx, col - 1, -1)
        else
            -- todo reset to revious
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@variable", state.line_idx, col, -1)
        end
    end
end

local function highlight()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- clear previous matechs???? TODO: ??? Why which matches??
    local namespace = vim.api.nvim_create_namespace("Blazor")
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

    local state = {}
    state.buf_nr = bufnr
    state.namespace = namespace

    local codeSection = false
    local codeSectionKeyword = "@code"

    for lineNo, line in ipairs(lines) do
        state.line_idx = lineNo - 1
        --PERF: just check within the chars? Or do i need to check ith beforehand?
        if line:sub(1, #codeSectionKeyword) == codeSectionKeyword then
            -- TODO: should be next line only
            codeSection = true
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "CursorLineFold", state.line_idx, 0, -1)
        end

        if codeSection and line:sub(1, 2) == "//" then
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@comment", state.line_idx, 0, -1)
            goto continue
            -- TODO: pretty poor handling, because only when the comment is at the start
        elseif line:sub(1, 4) == "<!--" then
            vim.api.nvim_buf_add_highlight(state.buf_nr, state.namespace, "@comment", state.line_idx, 0, -1)
            goto continue
        end

        state.line_word_count = 0
        state.word_start = -1
        state.right_hand_side = false
        state.last_word_keyword = false
        for col = 1, #line do
            local c = line:sub(col, col)
            if not codeSection then
                highlight_cshtml(state, col, c)
            else
                highlight_cs(state, col, c)
            end
            state.last_c = c
        end
        ::continue::
    end
end

local function highlight_perf()
    local startTime = os.clock()
    highlight();
    local endTime = os.clock()
    print(string.format("Execution time: %.3f ms", (endTime - startTime) * 1000))
end

vim.keymap.set("n", "<leader>rh", highlight_perf, { desc = 'Runs the highlighter (for testing)' })

M.highlight = highlight
return M
