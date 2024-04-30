local lfs = require("lfs")

local Helpers = {}

Helpers.printTable = function(tbl, indent)
  indent = indent or 0
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. tostring(k) .. ": "
    if type(v) == "table" then
      print(formatting)
      printTable(v, indent + 1)
    else
      print(formatting .. tostring(v))
    end
  end
end

Helpers.fileExists = function(filePath)
  local file = io.open(filePath, "r")
  if file then
    file:close()
  return true
  else
    return false
  end
end

Helpers.readFile = function(filePath)
  local file = io.open(filePath, "r")
  if not file then
    return nil, "Unable to open file"
  end

  local content = file:read("*a")
  file:close()

  return content
end

Helpers.writeFile = function(filePath, content)
  local file = io.open(filePath, "w")
  if not file then
    return false, "Unable to open file for writing"
  end

  file:write(content)
  file:close()

  return true
end

Helpers.createFolderIfNotExists = function(folderPath)
  if not lfs.attributes(folderPath, "mode") then
    lfs.mkdir(folderPath)
    return true
  else
    return false
  end
end

return Helpers
