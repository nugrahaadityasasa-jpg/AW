local Interface = {}

local Services = getgenv().AW_Modules.Services
local Configs = getgenv().AW_Modules.Configs
local Utils = getgenv().AW_Modules.Utils

-- 1. Load Library ANUI
local ANUI_URL = "https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"
local Library = loadstring(game:HttpGet(ANUI_URL))()

-- 2. Membuat Window
local Window = Library:CreateWindow({
    Title = "AN Hub - Anime Weapons (V2)",
    Icon = "rbxassetid://84366761557806",
    Author = "Aditya Nugraha",
    Folder = "AnimeWeaponsV2",
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
})

-- 3. Membuat Tab Farm
local FarmTab = Window:Tab({
    Title = "Main Feature",
    Icon = "swords"
})

-- 4. Fitur: Pilih Musuh
-- Fungsi Helper untuk mengambil daftar musuh dari data game
local function GetEnemyList()
    local list = {}
    local data = getgenv().EnemiesData -- Didapat dari Configs.ScanControllers
    
    if data then
        for _, enemy in pairs(data) do
            if enemy.Config and enemy.Alive then
                local name = enemy.Config.Display
                table.insert(list, name)
            end
        end
    end
    -- Hapus duplikat & urutkan (sederhana)
    table.sort(list)
    return list
end

local EnemyDropdown = FarmTab:Dropdown({
    Title = "Select Enemy",
    Multi = false,
    Values = {}, -- Nanti di-refresh
    Callback = function(val)
        Configs.Settings.SelectedEnemy = val
        -- Auto Save Zone Config bisa ditaruh disini nanti
    end
})

FarmTab:Button({
    Title = "Refresh Enemy List",
    Callback = function()
        EnemyDropdown:Refresh(GetEnemyList())
    end
})

-- 5. Fitur: Toggle Auto Farm
FarmTab:Toggle({
    Title = "Auto Farm",
    Callback = function(val)
        Configs.Settings.AutoFarm = val
    end
})

-- Simpan Window ke variable global agar bisa diakses jika perlu
Interface.Window = Window
return Interface