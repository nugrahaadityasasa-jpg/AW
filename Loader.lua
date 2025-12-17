-- Pastikan bagian /aw/ atau /AW/ sesuai persis dengan nama repo kamu di GitHub
local RepoURL = "https://raw.githubusercontent.com/nugrahaadityasasa-jpg/AW/main/" 

local function LoadModule(path)
    local url = RepoURL .. path
    local success, result = pcall(function() return game:HttpGet(url) end)
    if not success then return warn("❌ Gagal Download (Cek URL/Repo): " .. url) end
    
    local func, err = loadstring(result)
    if not func then return warn("⚠️ Syntax Error di " .. path .. ": " .. tostring(err)) end
    
    return func()
end

-- [1] Setup Environment Global
getgenv().AW_Modules = {}

print("🔄 Loading Core Services...")
-- PERBAIKAN: Mengubah "Services.lua" menjadi "Service.lua" sesuai nama file kamu
getgenv().AW_Modules.Services = LoadModule("Core/Service.lua") 

print("🔄 Loading Utilities...")
getgenv().AW_Modules.Utils = LoadModule("Core/Utils.lua")

-- Load Features (Config & Farming) - Sesuai Tahap 2
print("🔄 Loading Configs...")
getgenv().AW_Modules.Configs = LoadModule("Core/Configs.lua")

print("🔄 Loading Feature: Farming...")
getgenv().AW_Modules.Farming = LoadModule("Features/Farming.lua")

-- [2] Validasi Game
if game.PlaceId ~= 79189799490564 then
    warn("Wrong Game ID!")
    return
end

repeat task.wait() until game:IsLoaded()

-- Setup Folder Awal
local Services = getgenv().AW_Modules.Services
local Utils = getgenv().AW_Modules.Utils

if Services and Utils then
    if not isfolder("ANUI") then makefolder("ANUI") end
    if not isfolder(Services.FolderPath) then makefolder(Services.FolderPath) end
    Utils.SecureWipe() -- Jalankan security check
    print("✅ Tahap 1 & 2 Berhasil: Core & Features Loaded!")
else
    warn("❌ Gagal memuat Services atau Utils! Cek nama file di GitHub.")
end