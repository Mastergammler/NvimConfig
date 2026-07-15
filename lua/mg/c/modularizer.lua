local utils = require 'mg.utils'
local fs = utils.reload_module("mg.fs")

local ts = require 'nvim-treesitter.ts_utils'

--[[

FUNCTIONS:
1. New File -> Add to compile
2. Add Function to header
3. Update Function in header


STEPS:

#NewFile (Space-im[port]):
1. Get current file name
2. Find compile.cpp uptree
3. Add '#include <filename>' to the end

#Add Function:
1. Get current function string (multiline)
1. Add to correct file
    - Add to next internal ( Space-in[ternal] )
        1. Find 'internal.h'
        2. Add to the end
    - Add to module header ( Space-he[ader] )
        1. Get parent folder
        2. Get header file that matches the dir -> '<dir>'.h
        3. Add name to the end

#Replace Function:
> Uses same shortcuts as add function
> But runs a check before, if it already exists (match by name only)

** RULES **
- We always take the next found file uptree!

]] --

local function test()
    local filePath = fs.find_file_uptree("test.log")
    print(filePath)

    local currentFile = vim.fn.expand("%:p")
    print("Comparing:" .. currentFile .. " - " .. filePath)
    local currentRelative = fs.relative_path(currentFile, filePath)
    print(currentRelative)
    fs.file_append(filePath, "#include \"" .. currentRelative .. "\"")
end


local function get_fn_name_under_cursor()
    local node = ts.get_node_at_cursor()

    while node do
        if node:type() == 'function_definition' then break end
        node = node:parent()
    end

    if not node then
        print("WARN: No function under cursor")
        return nil
    else
        local bufnr = vim.api.nvim_get_current_buf()
        -- unclear what decl[0] would be, it seems to be nil
        local decl = node:field('declarator')[1]
        local retTypeNode = node:named_child(0)
        local fnDeclStr = vim.treesitter.get_node_text(decl, bufnr)
        local rTypeStr = vim.treesitter.get_node_text(retTypeNode, bufnr)
        return string.format("%s %s;", rTypeStr, fnDeclStr)
    end
end

local function add_function_to(fileName)
    local fnName = get_fn_name_under_cursor()
    if not fnName then return end

    local fileToExtend = fs.find_file_uptree(fileName)
    if fileToExtend then
        fs.file_append_refresh(fileToExtend, fnName)
    else
        print("WARN: No file '" .. fileName .. "' found.")
    end
end

local function add_fn_to_parent_dir_header()
    local fnName = get_fn_name_under_cursor()
    if not fnName then return end

    local curFileParent = fs.parent_dir_name()
    local fileName = curFileParent .. ".h"
    local fileToExtend = fs.find_file_uptree(fileName)
    if fileToExtend then
        fs.file_append_refresh(fileToExtend, fnName)
    else
        local moduleHeader = "module.h";
        local moduleHeaderFile = fs.find_file_uptree(moduleHeader)
        if moduleHeaderFile then
            fs.file_append_refresh(moduleHeaderFile, fnName)
        else
            print("WARN: No file '" .. fileName " or " .. moduleHeaderFile .. "' found.")
        end
    end
end

local function add_current_as_template_to(fileName, templateText)
    local fileToExtend = fs.find_file_uptree(fileName)


    if fileToExtend then
        local currentFile = vim.fn.expand("%:p")
        local curRelativePath = fs.relative_path(currentFile, fileToExtend)
        fs.file_append_refresh(fileToExtend, string.format(templateText, curRelativePath))
    elseif string.match(fileName, "%.cpp$") then
        local cImportFile = string.gsub(fileName, "%.cpp$", ".c")
        local cFileToExtend = fs.find_file_uptree(cImportFile);

        if cFileToExtend then
            local currentFile = vim.fn.expand("%:p")
            local curRelativePath = fs.relative_path(currentFile, cFileToExtend)
            fs.file_append_refresh(fileToExtend, string.format(templateText, curRelativePath))
        else
            print("WARN: No file '" .. fileName .. "' found.")
        end
    end
end


return {
    add_import = add_current_as_template_to,
    add_fn_to = add_function_to,
    add_header_fn = add_fn_to_parent_dir_header
}
