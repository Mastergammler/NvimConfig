local timing = require("mg.performance.timing")

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

local TokenType = setmetatable({
        NONE = 0,
        STRING = 1,
        CS_IDENTIFIER = 2,
        OPERATOR = 3,
        HTML_TAG = 4,
    },
    {
        __index = function(_, k)
            error("Undefind TokenType enum member: " .. tostring(k), 2)
        end,
        __newindex = function()
            error("Read-only enum", 2)
        end,
    });

local TokenizerState = {
    tokenStart = 0,
    tokenEnd = 0,
    -- maybe more a token changed?
    isTokenEnd = false,
    endsPreviousToken = false,
    withinToken = false,
    tokenType = TokenType.NONE
}

local function reset_tokenizer(state)
    state.withinToken = false
    state.isTokenEnd = false
    state.endsPreviousToken = false
    state.tokenType = TokenType.NONE
    state.previousType = TokenType.NONE
    state.tokenStart = 0
    state.tokenEnd = -1
end

local function isPartOf(c, charSet)
    return string.find(charSet, c, 1, true) ~= nil
end

-- TODO: i need some "token end:" functionality
-- when a new token starts, then i automatically should end the previous one!
local function tokenize(state, c, cidx)
    local withinString = state.withinToken and state.tokenType == TokenType.STRING
    local withinHtmlTag = state.withinToken and state.tokenType == TokenType.HTML_TAG

    if c == '"' then
        -- TODO: not sure if this is right?
        if withinString then
            state.tokenEnd = cidx + 1 -- after current
            state.isTokenEnd = true
            state.endsCurrentToken = true
            state.withinToken = false
        elseif state.withinToken then
            -- FIXME: this doen't work, because i can't set the start index
            -- -> At least it shouldn't work, but somehow it does ....
            state.tokenEnd = cidx
            state.previousType = state.tokenType
            state.tokenType = TokenType.STRING
            state.endsPreviousToken = true
            state.withinToken = true
        else
            state.tokenStart = cidx
            state.withinToken = true
            state.tokenType = TokenType.STRING
        end
        -- TODO: these 2 types don't end the previous taken correctly
        -- -> because they override the start index ...
    elseif not withinString and c == '@' then
        state.tokenStart = cidx
        state.tokenType = TokenType.CS_IDENTIFIER
        state.withinToken = true
        state.endsPreviousToken = true
        -- TODO: this has different meanings for html & cs!
    elseif not withinString and c == '<' then
        state.tokenStart = cidx
        state.tokenType = TokenType.HTML_TAG
        state.withinToken = true
        state.endsPreviousToken = true
    elseif withinHtmlTag and c == '>' then
        state.tokenEnd = cidx + 1
        state.withinToken = false
        state.isTokenEnd = true
        state.endsCurrentToken = true
    elseif not withinString and isPartOf(c, " ;()[]{}") then
        state.tokenEnd = cidx
        state.previousType = state.tokenType
        state.tokenType = TokenType.NONE
        state.endsPreviousToken = true
        state.withinToken = false
        state.isTokenEnd = true -- single symbol token
    elseif not withinString and not withinHtmlTag and isPartOf(c, "=+-<>?!*/|&") then
        -- FIXME: this doesn't work because i can't set the start index either
        state.tokenEnd = cidx
        state.previousType = state.tokenType
        state.tokenType = TokenType.OPERATOR
        state.endsPreviousToken = true
        state.withinToken = false
        state.isTokenEnd = true -- single symbol token
    end
end

local function determineHighlight(hl, tokenizerState, previousToken)
    local tokenType = (previousToken and tokenizerState.previousType) or tokenizerState.tokenType

    if tokenType == TokenType.STRING then
        hl.group = "@string"
    elseif tokenType == TokenType.CS_IDENTIFIER then
        hl.group = "@keyword"
    elseif tokenType == TokenType.OPERATOR then
        hl.group = "@operator"
    elseif tokenType == TokenType.HTML_TAG then
        hl.group = "@attribute"
    elseif tokenType == TokenType.NONE then
        hl.group = "@variable"
    end

    if previousToken or tokenizerState.endsCurrentToken then
        hl.startIdx = tokenizerState.tokenStart
        hl.endIdx = tokenizerState.tokenEnd
    else
        hl.startIdx = tokenizerState.tokenEnd
        hl.endIdx = tokenizerState.tokenEnd + 1
    end
end

local function highlightToken(highlighterState, tokenizerState)
    if not tokenizerState.isTokenEnd and not tokenizerState.endsPreviousToken then return end

    local curHl = {}
    local prevHl = {}
    curHl.startIdx = 0
    curHl.endIdx = -1
    prevHl.startIdx = 0
    prevHl.endIdx = -1

    if tokenizerState.endsPreviousToken then
        determineHighlight(prevHl, tokenizerState, true)
        --[[if prevHl.endIdx > highlighterState.linelength then
            prevHl.endIdx = -1
        end]] --
        vim.api.nvim_buf_add_highlight(highlighterState.bufnr, highlighterState.namespace, prevHl.group,
            highlighterState.lineidx,
            prevHl.startIdx, prevHl.endIdx)
        tokenizerState.endsPreviousToken = false
    end

    if tokenizerState.isTokenEnd then
        determineHighlight(curHl, tokenizerState, false)
        vim.api.nvim_buf_add_highlight(highlighterState.bufnr, highlighterState.namespace, curHl.group,
            highlighterState.lineidx,
            curHl.startIdx, curHl.endIdx)
        tokenizerState.isTokenEnd = false
        tokenizerState.endsCurrentToken = false
    end
end

local function tokenizer_highlight()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local namespace = vim.api.nvim_create_namespace("Blazor")
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

    local tokenizerState = {}
    local highlighterState = {}
    reset_tokenizer(tokenizerState)
    highlighterState.bufnr = bufnr
    highlighterState.namespace = namespace

    for lineNo, line in ipairs(lines) do
        highlighterState.lineidx = lineNo - 1
        highlighterState.linelength = #line
        reset_tokenizer(tokenizerState)
        for col = 1, #line do
            -- lua is 1 based -> so we convent it back to 0 based
            tokenize(tokenizerState, line:sub(col, col), col - 1)
            highlightToken(highlighterState, tokenizerState)
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

local CsParser = {
    startTokens = "@",
    splitTokens = " =(){};",
    -- NL only
    endTokens = "",
    lineStartIdx = -1,
    colStartIdx = -1,
    hlGroup = "@keyword",
    -- TODO: how do make this work?
    endOnNewline = true
}

local TagParser = {
    startTokens = "<",
    -- here NO newline!
    endTokens = ">",
    splitTokens = " =",
    lineStartIdx = -1,
    colStartIdx = -1,
    hlGroup = "@attribute",
    endOnNewline = true
}

local StringParser = {
    startTokens = "\"",
    endTokens = "\"",
    splitTokens = "",
    lineStartIdx = -1,
    colStartIdx = -1,
    hlGroup = "@string",
    endOnNewline = true
}

local function statefull_highlight()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local namespace = vim.api.nvim_create_namespace("Blazor")
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

    local selectedParser = nil

    for lineNo, line in ipairs(lines) do
        for col = 1, #line do
            local c = line:sub(col, col)
            local justStarted = false
            if selectedParser == nil then
                if isPartOf(c, StringParser.startTokens) then
                    selectedParser = StringParser
                elseif isPartOf(c, TagParser.startTokens) then
                    selectedParser = TagParser
                elseif isPartOf(c, CsParser.startTokens) then
                    selectedParser = CsParser
                else
                    -- do nothing
                end

                if selectedParser ~= nil then
                    selectedParser.lineStartIdx = lineNo - 1
                    selectedParser.colStartIdx = col - 1
                    justStarted = true
                end
            end

            -- within tag, is different again!
            -- -> within tag & within cs can switch @if ... <p> ... else ...<p> ...
            -- => Both need the ability to handle the other!
            -- The deciding queustion is: WHAT does the parser statet need to save?
            -- -> Or is it just a different kind of tokenizer?
            -- I think when to start and end needs to be controlled by the parser?
            -- -> Similarly for end on line or NOT end on line
            -- => That i could tall @code -> always will use CS parser for example
            -- I almost feel like this should create a kind of parser tree,
            -- where each parser call another sub parser for the next token etc
            -- and then it goes back into the current one, then i need to modify start & end index etc

            if selectedParser ~= nil and not justStarted then
                -- TODO: inclusive exclusive?
                if isPartOf(c, selectedParser.endTokens) then
                    selectedParser.colEndIdx = col
                    vim.api.nvim_buf_add_highlight(bufnr, namespace, selectedParser.hlGroup, selectedParser.lineStartIdx,
                        selectedParser.colStartIdx, selectedParser.colEndIdx)
                    selectedParser = nil
                elseif isPartOf(c, selectedParser.splitTokens) then
                    -- TODO: evaluate next token differently?
                    -- -> E.g. change selected parser or something to sub parser
                    selectedParser.colEndIdx = col
                    vim.api.nvim_buf_add_highlight(bufnr, namespace, selectedParser.hlGroup, selectedParser.lineStartIdx,
                        selectedParser.colStartIdx, selectedParser.colEndIdx)
                    selectedParser.colStartIdx = col
                end
            end
        end
        if selectedParser ~= nil and selectedParser.endOnNewline then
            selectedParser.colEndIdx = -1
            vim.api.nvim_buf_add_highlight(bufnr, namespace, selectedParser.hlGroup, selectedParser.lineStartIdx,
                selectedParser.colStartIdx, selectedParser.colEndIdx)
            selectedParser = nil
        end
    end
end

local function highlight_perf()
    timing.measure(statefull_highlight)
end

vim.keymap.set("n", "<leader>rh", highlight_perf, { desc = 'Run highlighter (for testing)' })

M.highlight = highlight
M.highlight2 = tokenizer_highlight
return M
