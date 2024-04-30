-- Generates HTML version of the Blizzard WoW Game API available
-- inside of the game and through Lua.

require("luarocks.loader")

local helpers = require("helpers")
local etlua = require("etlua")
local lunajson = require("lunajson")

local BLIZZ_DOCS = "Blizzard_APIDocumentationGenerated"
local APIREF_OUT_DIRECTORY = "../public/apiref"

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
local toc = io.open(string.format("%s/%s.toc", BLIZZ_DOCS, BLIZZ_DOCS), "r")
if not toc then
  print("Error: Unable to read a TOC file")
else
  for line in toc:lines() do
    if string.sub(line, 1, 1) ~= "#" then
      filename = string.format("%s/%s", BLIZZ_DOCS, string.gsub(line, "%.lua$", ""))
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

-- Creates apiref directory in public.
helpers.createFolderIfNotExists(APIREF_OUT_DIRECTORY)

local sectionTemplateHTML, error = helpers.readFile("../templates/apiref.section.html")
if not sectionTemplateHTML then
  print(error)
  os.Exit(1)
end

local sectionTemplate = etlua.compile(sectionTemplateHTML)

-- Looping over all of the sections, generating are reference files.
print("Sections:", #APIDocumentation.Sections)
for _, section in ipairs(APIDocumentation.Sections) do
  print(section.Name)
  print("   functions:", #section.Functions)
  print("   events:", #section.Events)
  print("   tables:", #section.Tables)

  local outputFile = string.format("%s/api.%s.html", APIREF_OUT_DIRECTORY, string.lower(section.Name))
  local output = sectionTemplate({
    section = section,
  })
  
  local written = helpers.writeFile(outputFile, output)
  if not written then
    print("HTML file not written")
    os.Exit(1)
  end
end

-- Generate search index file.

local searchIndex = {}
for _, section in ipairs(APIDocumentation.Sections) do
  table.insert(searchIndex, {
    name = section.Name,
    api = "namespace",
    url = string.format("/apiref/api.%s.html", string.lower(section.Name)),
  })

  if section.Functions then
    for _, func in pairs(section.Functions) do
      table.insert(searchIndex, {
        name = string.format("%s.%s", section.Name, func.Name),
        api = "function",
        url = string.format("/apiref/api.%s.html", string.lower(section.Name)),
      })
    end
  end
  
  if section.Events then
    for _, item in pairs(section.Events) do
      table.insert(searchIndex, {
        name = item.LiteralName,
        api = "event",
        url = string.format("/apiref/api.%s.html", string.lower(section.Name)),
      })
    end
  end
  
  if section.Tables then
    for _, item in pairs(section.Tables) do
      table.insert(searchIndex, {
        name = item.Name,
        api = "table",
        url = string.format("/apiref/api.%s.html", string.lower(section.Name)),
      })
    end
  end
end

local written = helpers.writeFile(string.format("%s/search.json", APIREF_OUT_DIRECTORY), lunajson.encode(searchIndex))
if not written then
  print("Search index file not written")
  os.Exit(1)
end

-- Generates index of all the API sections.

local indexTemplateHTML, error = helpers.readFile("../templates/apiref.index.html")
if not indexTemplateHTML then
  print(error)
  os.Exit(1)
end

local indexTemplate = etlua.compile(indexTemplateHTML)

local output = indexTemplate({
  sections = APIDocumentation.Sections,
})

local written = helpers.writeFile(string.format("%s/index.html", APIREF_OUT_DIRECTORY), output)
if not written then
  print("HTML file not written")
  os.Exit(1)
end

