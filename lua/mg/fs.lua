local function delim()
    local is_windows = vim.loop.os_uname().sysname:match("Windows")
    return is_windows and "\\" or "/"
end

local function get_parent_dir(path)
    return vim.fn.fnamemodify(path, ":h")
end

local function search_file(dir, fileName)
    local files = vim.fn.glob(dir .. delim() .. fileName)

    if files and files ~= "" then
        return files
    end

    return nil
end

local function find_file_uptree(fileName)
    local filePath = vim.fn.expand("%:p")
    local startDir = get_parent_dir(filePath)
    local workspaceDir = vim.fn.getcwd()

    local searchDir = startDir;
    local foundFile = nil

    while searchDir ~= '' do
        foundFile = search_file(searchDir, fileName)

        if foundFile then
            break
        end

        if #searchDir <= #workspaceDir then
            print("Unable to find file '" .. fileName .. "' within working dir " .. workspaceDir)
            break
        end

        searchDir = get_parent_dir(searchDir)
    end

    return foundFile
end

local function file_append(filePath, text)
    if filePath then
        local file = io.open(filePath, "a");
        if file then
            file:write(text .. "\n")
            file:close()
        end
    end
end

local function remove_common_prefix(filePath, other)
    local i = 1
    while filePath:sub(i, i) == other:sub(i, i) do
        i = i + 1
    end

    return filePath:sub(i)
end

local function get_parent_dir_name()
    local filePath = vim.fn.expand("%:p")
    local dir = get_parent_dir(filePath)
    local dirParent = get_parent_dir(dir)

    local dirName = remove_common_prefix(dir, dirParent)
    return dirName
end

local function ensure_dir_exists(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

local function file_exists(path)
    return vim.uv.fs_stat(path)
end

return {
    find_file_uptree = find_file_uptree,
    file_append = file_append,
    relative_path = remove_common_prefix,
    parent_dir_name = get_parent_dir_name,
    ensure_dir = ensure_dir_exists,
    file_exists = file_exists
}
