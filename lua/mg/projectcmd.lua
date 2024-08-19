--[[
-- Module to handle project commands like 'build' 'run' 'test' 'publish' etc
--]]
proj = require("mg.projectutil")

-- TODO: handle windows linux switch (bat vs sh)
local ProjectType = {
    CS = "*.csproj",
    Gradle = "build.gradle",
    BAT = "*.bat",
    SHELL = "*.sh"
}

local DotnetCommands = {
    build = "dotnet build",
    run = "dotnet run --project",
    test = "dotnet test"
}

local function determineProjectType()
    for key, value in pairs(ProjectType) do
        print("checking type", key)
        local projectFile = proj.find_project_file({ GlobPattern = value })
        if projectFile ~= nil then
            return key, projectFile
        end
    end
    print "Unable to determine project type"
end

function createProjectCommand(commandName, cmdappend)
    local type, projectFile = determineProjectType();
    if cmdappend == nil then
        cmdappend = ''
    end

    if type ~= nil then
        for k, v in pairs(ProjectType) do
            if type == k and v == ProjectType.CS then
                local pathQuoted = string.format(' "%s"', projectFile)
                return DotnetCommands[commandName] .. pathQuoted .. ' ' .. cmdappend
            elseif type == k and v == ProjectType.Gradle then
                return "Not implemented"
            elseif type == k and v == ProjectType.BAT then
                return "Not implemented"
            elseif type == k and v == ProjectType.SHELL then
                return "Not implemented"
            end
        end
    else
        print "No buildable project files where found in the current working directory"
    end
end

return {
    get_project_cmd = createProjectCommand
}
