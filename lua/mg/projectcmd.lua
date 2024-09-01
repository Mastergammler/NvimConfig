--[[
-- Module to handle project commands like 'build' 'run' 'test' 'publish' etc
--]]
proj = require("mg.projectutil")

local ProjectType = {
    CS = "*.csproj",
    Gradle = "build.gradle",
    -- TODO: cleanup, this is quite a akward solution
    -- There has to be a better way of handling this ...
    SCRIPT = "notafile.nope"
}

local DotnetCommands = {
    build = "dotnet build",
    run = "dotnet run --project",
    test = "dotnet test"
}

-- TODO: i want the following
-- if there's a *.csproj file -> then it's dotent
-- if there's a build.gradle file -> gradle project
-- else, check linux or not
-- -if so concat cmdName.sh else cmdName.bat


local function determineProjectType(cmdName)
    for key, value in pairs(ProjectType) do
        local projectFile = proj.find_project_file({ GlobPattern = value })
        if projectFile ~= nil then
            return key, projectFile
        end
    end

    -- if no special type, search for build/run scripts
    local scriptSuffix;
    if proj.is_windows() then
        scriptSuffix = ".bat"
    else
        scriptSuffix = ".sh"
    end

    local scriptFile = proj.find_project_file({ GlobPattern = cmdName .. scriptSuffix })
    if not scriptFile then
        print "Unable to determine project type"
    end

    -- FIXME: I wanted to get the 'enum' name here but doesn't seem possible
    -- it always returns only the value
    return "SCRIPT", scriptFile
end

function createProjectCommand(commandName, cmdappend)
    local type, projectFile = determineProjectType(commandName);
    if cmdappend == nil then
        cmdappend = ''
    end

    if type ~= nil then
        for k, v in pairs(ProjectType) do
            print("checking type: ", k)
            if type == k and v == ProjectType.CS then
                local pathQuoted = string.format(' "%s"', projectFile)
                return DotnetCommands[commandName] .. pathQuoted .. ' ' .. cmdappend
            elseif type == k and v == ProjectType.Gradle then
                return "Not implemented"
            elseif type == k and v == ProjectType.SCRIPT then
                return projectFile
            end
        end
    else
        print "No buildable project files where found in the current working directory"
    end
end

return {
    get_project_cmd = createProjectCommand
}
