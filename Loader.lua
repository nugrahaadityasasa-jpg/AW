-- Pastikan URL ini benar sesuai repo kamu
local RepoURL = "https://raw.githubusercontent.com/nugrahaadityasasa-jpg/AW/main/" 

local function LoadModule(path)
    local url = RepoURL .. path
    local success, result = pcall(function() return game:HttpGet(url) end)
    if not success then return warn("❌ Gagal Download: " .. url) end
    
    local func, err = loadstring(result)
    if not func then return warn("⚠️ Syntax Error di " .. path .. ": " .. tostring(err)) end
    
    return func()
end

-- [SETUP ENVIRONMENT]
getgenv().AW_Modules = {}

-- 1. Load Core (Pondasi)
print("Loading Core...")
getgenv().AW_Modules.Services = LoadModule("Core/Service.lua") -- Perhatikan nama file 'Service.lua'
getgenv().AW_Modules.Utils = LoadModule("Core/Utils.lua")
getgenv().AW_Modules.Configs = LoadModule("Core/Configs.lua")

-- 2. Load Features (Otak)
print("Loading Features...")
getgenv().AW_Modules.Farming = LoadModule("Features/Farming.lua")

-- 3. Load UI (Wajah)
print("Loading UI...")
getgenv().AW_Modules.Interface = LoadModule("UI/Interface.lua")

-- 4. Start Main Loop (Jantung)
print("Starting Engine...")
LoadModule("Main.lua")

print("✅ SUCCESS: Script V2 Loaded Completely!")