local utils = require 'mg.utils'
local fs = utils.reload_module("mg.fs")
--[[

FUNCTIONS:
1. New File -> Add to compile
2. Add Function to header
3. Update Function in header


STEPS:

#NewFile:
1. Get current file name
2. Find compile.cpp uptree
3. Add '#include <filename>' to the end

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

local function add_current_as_template_to(fileName, templateText)
    local fileToExtend = fs.find_file_uptree(fileName)
    if fileToExtend then
        local currentFile = vim.fn.expand("%:p")
        local curRelativePath = fs.relative_path(currentFile, fileToExtend)
        fs.file_append(fileToExtend, string.format(templateText, curRelativePath))
    else
        print("WARN: No file '" .. fileName .. "' found.")
    end
end

return {
    add_import = add_current_as_template_to
}
