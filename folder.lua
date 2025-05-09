local path = "ElysianHub"
local subpath = path .. "/Stuffs"

local function createfolder()
    if not isfolder(path) then
        makefolder(path)
    end

    if isfolder(path) and not isfolder(subpath) then
        makefolder(subpath)
    end
end

createfolder()