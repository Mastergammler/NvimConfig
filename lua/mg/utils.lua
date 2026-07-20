local function reload(moduleName)
    package.loaded[moduleName] = nil
    return require(moduleName)
end

local function wordcount()
    return tostring(vim.fn.wordcount().words)
end

return {
    reload_module = reload,
    wordcount = wordcount
}
