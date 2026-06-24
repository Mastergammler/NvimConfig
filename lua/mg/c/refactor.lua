local function convert_member_access(fromPointer)
    local bufnr = vim.api.nvim_get_current_buf()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    local findPat = "%."
    local replacePat = "->"
    local replaceLen = 1

    if fromPointer then
        findPat = "%->"
        replacePat = "."
        replaceLen = 2
    end


    local var_name = vim.fn.expand("<cword>")

    -- Find enclosing compound_statement
    local node = vim.treesitter.get_node()

    while node and node:type() ~= "compound_statement" do
        node = node:parent()
    end

    if not node then
        print("Not inside a scope")
        return
    end

    local scope = node

    local query = vim.treesitter.query.parse(
        lang,
        [[
        (field_expression
          argument: (identifier) @obj
        ) @field
        ]]
    )


    local edits = {}

    for _, match in query:iter_matches(scope, bufnr) do
        local obj = match[1][1]
        local field = match[2][1]

        if obj and field then
            local text = vim.treesitter.get_node_text(obj, bufnr)
            if text == var_name then
                local sr, sc, er, ec = field:range()

                local field_text =
                    vim.treesitter.get_node_text(field, bufnr)

                local dot_col = field_text:find(findPat)

                if dot_col then
                    table.insert(edits, {
                        row = sr,
                        col = sc + dot_col - 1,
                    })
                end
            end
        end
    end

    -- Apply edits from bottom up
    for i = #edits, 1, -1 do
        local e = edits[i]

        vim.api.nvim_buf_set_text(
            bufnr,
            e.row,
            e.col,
            e.row,
            e.col + replaceLen,
            { replacePat }
        )
    end
end

vim.keymap.set("n", "<leader>gc", function()
    print("running go command ...")
    convert_member_access(true)
end, { desc = "go command - running convert member access" });

return {
    replace_pointer_access = convert_member_access
}
