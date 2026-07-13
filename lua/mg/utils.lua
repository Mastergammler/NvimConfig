local function reload(moduleName)
    package.loaded[moduleName] = nil
    return require(moduleName)
end

return {
    reload_module = reload
}
