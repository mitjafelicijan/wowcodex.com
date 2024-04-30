require("luarocks.loader")
require("helpers")

local luasql = require("luasql.mysql")

local env = assert(luasql.mysql())
local conn = assert(env:connect("wow", "wow", "wow", "127.0.0.1", 3306))

-- https://wowpedia.fandom.com/wiki/ItemType
-- Export all the weapon items (ItemType=2).

if conn then
  local data = {}
  local cursor = conn:execute("SELECT * FROM item_template WHERE class=2")
  local row = cursor:fetch({}, "a")
  while row do
    data[row.entry] = {
      Name = row.name,
      Quality = row.Quality,
      ItemLevel = row.ItemLevel,
      BuyPrice = row.BuyPrice,
      SellPrice= row.SellPrice,
    }
    row = cursor:fetch({}, "a")
  end
  cursor:close()

  local serializedData = serializeTable(data)
  saveSerializedTable("weapons.lua", "Weapons", serializedData)
end

conn:close()
env:close()
