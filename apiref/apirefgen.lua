-- Generates HTML version of the Blizzard WoW Game API available
-- inside of the game and through Lua.

require("luarocks.loader")

local helpers = require("helpers")
local etlua = require("etlua")

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

print("Sections:", #APIDocumentation.Sections)

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
