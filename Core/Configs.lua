local Configs = {}
local Services = getgenv().AW_Modules.Services -- Mengambil Service.lua
local Utils = getgenv().AW_Modules.Utils       -- Mengambil Utils.lua

-- [1] User Settings (Pengganti tabel local Config di script lama)
Configs.Settings = {
    AutoFarm = false,
    SelectedEnemy = nil,
    ZoneConfigurations = {},
    -- Tambahkan setting lain disini nanti seiring pemisahan fitur
    AutoMegaBoss = false,
    AutoMeteor = false,
}

-- [2] Load Game Modules (Mengambil data asli game)
-- Kita bungkus pcall agar script tidak error jika game update path
pcall(function()
    local CfgPath = Services.ConfigsPath
    Configs.Materials = require(CfgPath.General.Materials)
    Configs.Weapons = {} 
    Configs.Accessories = {}
    Configs.Enemies = {}
    
    -- Load Weapons (Iterasi Folder)
    local MZPath = CfgPath:FindFirstChild("MultipleZones") or CfgPath:FindFirstChild("Multiple Zones")
    if MZPath and MZPath:FindFirstChild("Weapons") then
        for _, module in pairs(MZPath.Weapons:GetChildren()) do
            if module:IsA("ModuleScript") then
                local s, data = pcall(require, module)
                if s then
                    for id, val in pairs(data) do Configs.Weapons[id] = val end
                end
            end
        end
    end
    
    -- Load Enemies & Accesssories
    if MZPath then
        if MZPath:FindFirstChild("Enemies") then 
            pcall(function() Configs.Enemies = require(MZPath.Enemies) end) 
        end
        if MZPath:FindFirstChild("Accessories") then 
            pcall(function() Configs.Accessories = require(MZPath.Accessories) end) 
        end
    end
end)

-- [3] MainController Scanner (PENTING untuk Farming)
-- Ini mengisi data musuh (EnemiesData)
function Configs.ScanControllers()
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "Data") and rawget(v, "SyncChanged") then
            getgenv().EnemiesData = v.Enemies
            getgenv().PlayerData = v.Data
            break 
        end
    end
end
task.spawn(Configs.ScanControllers)

-- [4] Zone Database Logic (Save/Load Enemy per Map)
function Configs.LoadZoneDB()
    if isfile(Services.FolderPath .. "/" .. Services.ZoneDBFile) then
        local s, r = pcall(function()
            return Services.HttpService:JSONDecode(readfile(Services.FolderPath .. "/" .. Services.ZoneDBFile))
        end)
        if s and type(r) == "table" then
            Configs.Settings.ZoneConfigurations = r
        end
    end
end

function Configs.SaveZoneConfig(zone, enemyName)
    if not zone or zone == "" then return end
    Configs.Settings.SelectedEnemy = enemyName
    Configs.Settings.ZoneConfigurations[zone] = { Value = enemyName }
    
    if writefile then
        pcall(function()
            writefile(Services.FolderPath .. "/" .. Services.ZoneDBFile, Services.HttpService:JSONEncode(Configs.Settings.ZoneConfigurations))
        end)
    end
end

-- Load DB saat script jalan
Configs.LoadZoneDB()

return Configs