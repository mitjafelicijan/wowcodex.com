function serializeTable(tbl)
    local str = "{\n"
    for key, value in pairs(tbl) do
        str = str .. '    ["' .. key .. '"] = {'
        for k, v in pairs(value) do
            if type(v) == "string" then
                str = str .. k .. ' = "' .. v:gsub('"', "'") .. '", '
            else
                str = str .. k .. " = " .. tostring(v):gsub('"', "'") .. ", "
            end
        end
        str = str:sub(1, -3) -- Remove the last comma and space
        str = str .. "},\n"
    end
    str = str .. "}"
    return str
end

function saveSerializedTable(filename, varname, data)
  local file = io.open(filename, "w")
  if file then
    file:write(string.format("%s = ", varname))
    file:write(data)
    file:close()
    print("Data exported to " .. filename)
  else
    print("Failed to open file for writing")
  end
end
