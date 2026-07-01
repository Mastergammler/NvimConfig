local cmp = require("cmp")

local vault_index = {
    {
        title = "Rust Book",
        path = "notes/rust/book.md",
        aliases = { "rust", "ownership" }
    },
    {
        title = "Lua Guide",
        path = "notes/lua/guide.md",
        aliases = { "lua", "neovim scripting" }
    },
    {
        title = "Neovim API",
        path = "notes/nvim/api.md",
        aliases = { "api", "vim api" }
    },
}

-- kinds of completion, for different presentation
local Kind = {
    Normal = cmp.lsp.CompletionItemKind.File,
    Alias = cmp.lsp.CompletionItemKind.Reference
}

local source = {}

function source:is_available()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)

    -- only inside [[...]]
    return before:match("%[%[[^%]]*$") ~= nil
end

local function get_prefix()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)

    return before:match("%[%[([^%]]*)$") or ""
end

local function test_vault_query(prefix)
    prefix = prefix:lower()

    local matches = {}

    for _, entry in ipairs(vault_index) do
        -- title match
        if entry.title:lower():find(prefix, 1, true) then
            table.insert(matches, {
                kind = "normal",
                entry = entry,
            })
        end

        -- alias matches
        for _, alias in ipairs(entry.aliases or {}) do
            if alias:lower():find(prefix, 1, true) then
                table.insert(matches, {
                    kind = "alias",
                    alias = alias,
                    entry = entry,
                })
            end
        end
    end

    return matches
end

-- actual function that defines the building blocks of the match
-- -> function that creates the matched string, what actually gets shown
function source:complete(_, callback)
    local prefix = get_prefix():lower()

    -- TODO: replace this line with my c-tool callback
    local matches = test_vault_query(prefix)
    local items = {}

    for _, m in ipairs(matches) do
        if m.kind == "normal" then
            table.insert(items, {
                label = m.entry.title,
                insertText = m.entry.title .. "]]",
                kind = Kind.Normal,
                detail = " .. " .. m.entry.path,
            })
        elseif m.kind == "alias" then
            table.insert(items, {
                label = m.alias .. " (" .. m.entry.title .. ")",
                insertText = m.entry.title .. "|" .. m.alias .. "]]",
                kind = Kind.Alias,
                detail = "from: " .. m.entry.path,
            })
        end
    end

    callback(items)
end

function source.new()
    return setmetatable({}, { __index = source })
end

cmp.register_source("vault", source.new())
