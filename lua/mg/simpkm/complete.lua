local cmp = require("cmp")
local cfg = require "mg.simpkm.config"

local opt = {
    exec_path = cfg.config.simpkm_exec,
    index_file = vim.fn.getcwd() .. "/" .. ".index"
}

local vault_index = {
    {
        title = "book",
        file_name = "book",
        dir_id = 0,
        is_alias = false,
        file_exists = true,
    },
    {
        title = "rusty",
        file_name = "book",
        dir_id = 0,
        is_alias = true,
        file_exists = true,
    },
    {
        title = "madeup",
        file_name = "madeup",
        dir_id = 0,
        is_alias = false,
        file_exists = false,
    },
    {
        title = "alias of madeup",
        file_name = "madeup",
        dir_id = 0,
        is_alias = true,
        file_exists = false,
    },
}

local index_cache = {}

-- kinds of completion, for different presentation
local Kind = {
    Normal = cmp.lsp.CompletionItemKind.File,
    Alias = cmp.lsp.CompletionItemKind.Reference,
    NoFile = cmp.lsp.CompletionItemKind.Constant,
    AliasNoFile = cmp.lsp.CompletionItemKind.Property
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

local function test_vault_query(prefix, index)
    prefix = prefix:lower()

    local matches = {}

    for _, entry in ipairs(index) do
        if entry.title:lower():find(prefix, 1, true) then
            -- TODO: do something for showing if files exists
            -- -> I could do this here prolly also
            table.insert(matches, entry)
        end
    end

    return matches
end

-- actual function that defines the building blocks of the match
-- -> function that creates the matched string, what actually gets shown
function source:complete(_, callback)
    local prefix = get_prefix():lower()

    -- TODO: replace this line with my c-tool callback
    local matches = test_vault_query(prefix, index_cache)
    local items = {}

    for _, m in ipairs(matches) do
        local kind = Kind.Normal

        if m.is_alias then
            if m.file_exists then
                kind = Kind.Alias
            else
                kind = Kind.AliasNoFile
            end
        elseif not m.file_exists then
            kind = Kind.NoFile
        end

        if m.is_alias then
            table.insert(items, {
                label = m.title .. " (" .. m.file_name .. ")",
                insertText = m.file_name .. "|" .. m.title .. "]]",
                kind = kind,
                detail = "from: " .. m.dir_id .. "/" .. m.file_name,
            })
        else
            table.insert(items, {
                label = m.title,
                insertText = m.title .. "]]",
                kind = kind,
                detail = m.dir_id .. "/" .. m.file_name,
            })
        end
    end

    callback(items)
end

function source.new()
    return setmetatable({}, { __index = source })
end

local function create_index()
    -- TODO: check success?
    local result = vim.system({ opt.exec_path, "index", cfg.config.vault_root }):wait()

    index_cache = {};

    for line in io.lines(opt.index_file) do
        local title, file_name, dir_id, is_alias, file_exists =
            line:match("^(.-):(.-):(%d+):([01]):([01])$")

        if title then
            -- this means it's the same as title
            -- to not need to put 2x the same string into the index
            if file_name == '"' then
                file_name = title
            end

            index_cache[#index_cache + 1] = {
                title = title,
                file_name = file_name,
                dir_id = tonumber(dir_id),
                is_alias = is_alias == "1",
                file_exists = file_exists == "1",
            }
        end
    end
end

create_index()

cmp.register_source("vault", source.new())

return {
    regenerate_index = create_index
}
