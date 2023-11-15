File = {}




function File.fileExists(filePath)
    local f = io.open(filePath, "r")

    if not f then
        return false
    end

    f:close()
    return true
end


function File.readJSON(filePath)
    local f = io.open(filePath, "r")
    
    if not f then
        return nil
    end

    local d = json.decode(f:read("*a"))
    f:close()
    return d
end


function File.writeJSON(filePath, data)
    local f = io.open(filePath, "w")
    
    if not f then
        return
    end

    local e = json.encode(data)
    f:write(e)
    f:close()
end


function File.updateJSON(filePath, data)
    local d = File.readJSON(filePath)

    if not d then
        return
    end

    for k, v in pairs(data) do
        if d[k] == nil then
            d[k] = v
        end
    end

    File.writeJSON(filePath, d)
end




return File
