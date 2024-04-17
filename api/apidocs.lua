-- Generates HTML version of the Blizzard WoW Game API available
-- inside of the game and through Lua.
-- local currentDir = debug.getinfo(1).source:match("@?(.*/)") or ""
-- package.path = package.path .. ";~./luarocks/?/init.lua"

require("luarocks.loader")

local helpers = require("helpers")
local etlua = require "etlua"

print("Generating API documentation")

APIDocumentation = {
  Sections = {}
}

APIDocumentation.AddDocumentationTable = function(self, Section)
  if Section.Name then
    table.insert(self.Sections, Section)
  end
end

-- Reads TOC file where all the links to documentation is available.
local directory = "Blizzard_APIDocumentationGenerated"
local toc = io.open(string.format("%s/Blizzard_APIDocumentationGenerated.toc", directory), "r")
if not toc then
  print("Error: Unable to read a TOC file")
else
  for line in toc:lines() do
    if string.sub(line, 1, 1) ~= "#" then
      filename = string.format("%s/%s", directory, string.gsub(line, "%.lua$", ""))
      if helpers.fileExists(string.format("%s.lua", filename)) then
        local success, module = pcall(require, filename)
        if not success then
          print("Error requiring file:", module)
        end
      end
    end
  end
  toc:close()
end

-- Looping over all of the sections
for _, section in ipairs(APIDocumentation.Sections) do
  print(section.Name)
  print("   functions:", #section.Functions)
  print("   events:", #section.Events)
  print("   tables:", #section.Tables)
end

print("Sections:", #APIDocumentation.Sections)

local templateHTML, error = helpers.readFile("../templates/api.html")
if not templateHTML then
  print(error)
  os.Exit(1)
end

local template = etlua.compile(templateHTML)
local output = template({
  sections = APIDocumentation.Sections,
})

local written = helpers.writeFile("../public/api.html", output)
if not written then
  print("HTML file not written")
  os.Exit(1)
end

print(output)
