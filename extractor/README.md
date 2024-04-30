# Extracts content from Nostalrius Core

> [!IMPORTANT]
> Small utilities that extract data the **Nostalrius** Core database.
> This exported files can be used in **your addons** since they have a bunch
> of additional data that is not provided by WoW API.

## Extracted content

### Weapons

You can copy file in [WoWCodexWeapons.lua](export/WoWCodexWeapons.lua)
to your WoW addon and then use it in your Lua code.

```lua
local WoWCodexWeapons = {
  ["15464"] = {Name = "Brute Hammer", BuyPrice = "22523", ItemLevel = "28", SellPrice = "4504", Quality = "2"},
  ["4445"] = {Name = "Flesh Carver", BuyPrice = "10341", ItemLevel = "23", SellPrice = "2068", Quality = "2"},
  ["3445"] = {Name = "Ceremonial Knife", BuyPrice = "1133", ItemLevel = "12", SellPrice = "226", Quality = "1"},
  ["2243"] = {Name = "Hand of Edward the Odd", BuyPrice = "352770", ItemLevel = "62", SellPrice = "70554", Quality = "4"},
  ["14527"] = {Name = "Monster - Mace2H, Horde Hammer A03 Dark", BuyPrice = "0", ItemLevel = "1", SellPrice = "0", Quality = "0"},
  ["19107"] = {Name = "Bloodseeker", BuyPrice = "220858", ItemLevel = "63", SellPrice = "44171", Quality = "3"},
  ["1811"] = {Name = "Blunt Claymore", BuyPrice = "2255", ItemLevel = "17", SellPrice = "451", Quality = "0"},
  ["21703"] = {Name = "Hammer of Ji'zhi", BuyPrice = "811491", ItemLevel = "73", SellPrice = "162298", Quality = "4"},
  ["15276"] = {Name = "Magus Long Staff", BuyPrice = "226315", ItemLevel = "58", SellPrice = "45263", Quality = "2"},
}
```

### Armor

You can copy file in [WoWCodexArmor.lua](export/WoWCodexArmor.lua)
to your WoW addon and then use it in your Lua code.

```lua
local WoWCodexArmor = {
  ["236"] = {Name = "Cured Leather Armor", BuyPrice = "2795", ItemLevel = "22", SellPrice = "559", Quality = "1"},
  ["9476"] = {Name = "Big Bad Pauldrons", BuyPrice = "42968", ItemLevel = "50", SellPrice = "8593", Quality = "3"},
  ["2988"] = {Name = "Inscribed Leather Gloves", BuyPrice = "1571", ItemLevel = "19", SellPrice = "314", Quality = "2"},
  ["1988"] = {Name = "Chief Brigadier Gauntlets", BuyPrice = "14260", ItemLevel = "38", SellPrice = "2852", Quality = "2"},
  ["10023"] = {Name = "Shadoweave Gloves", BuyPrice = "16672", ItemLevel = "45", SellPrice = "3334", Quality = "2"},
  ["19690"] = {Name = "Bloodsoul Breastplate", BuyPrice = "198415", ItemLevel = "65", SellPrice = "39683", Quality = "3"},
  ["19952"] = {Name = "Gri'lek's Charm of Valor", BuyPrice = "0", ItemLevel = "65", SellPrice = "0", Quality = "4"},
  ["16999"] = {Name = "Royal Seal of Alexis", BuyPrice = "42837", ItemLevel = "59", SellPrice = "10709", Quality = "3"},
  ["15656"] = {Name = "Merciless Epaulets", BuyPrice = "66833", ItemLevel = "54", SellPrice = "13366", Quality = "2"},
}
```

## Running it yourself

These tools require you to have Lua, LuaRocks and Docker installed on
your system.

Lua scripts require `luasql-mysql` and MySQL development C headers to
be installed. Check `deps.sh` to check what is being installed.

```sh
# First lets install all the LUA dependencies.
sh ./deps.sh

# Extract SQL data. This step is important because Docker will use
# extracted file to populate the database automatically.
7z x data/world_full_08082017.7z -o./data

# Lets start docker stack.
docker-compose -f docker.yaml up

# Now we can run the scripts that export the data.
lua armor.lua
lua weapons.lua
```

## Original data

Data comes from Nostalrius Core project
https://github.com/brian8544/nostalrius-core/ but there is also a fork
available at https://github.com/mitjafelicijan/nostalrius-core.
