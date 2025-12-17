-- Ganti link ini dengan RAW LINK GitHub repo kamu nanti
local RepoURL = "https://raw.githubusercontent.com/USERNAME/REPO/main/AnimeWeapons_V2/"

local function LoadModule(path)
    local url = RepoURL .. path
    local success, result = pcall(function() return game:HttpGet(url) end)
    if not success then return warn("❌ Gagal Download: " .. path) end
    
    local func, err = loadstring(result)
    if not func then return warn("⚠️ Syntax Error di " .. path .. ": " .. tostring(err)) end
    
    return func()
end

-- [1] Setup Environment Global
-- Kita pakai getgenv() supaya modul bisa saling akses tanpa require berulang
getgenv().AW_Modules = {}

print("🔄 Loading Core Services...")
getgenv().AW_Modules.Services = LoadModule("Core/Services.lua")

print("🔄 Loading Utilities...")
getgenv().AW_Modules.Utils = LoadModule("Core/Utils.lua")

-- [2] Validasi Game (Dari baris paling awal script lama)
if game.PlaceId ~= 79189799490564 then
    warn("Wrong Game ID!")
    return
end

repeat task.wait() until game:IsLoaded()

-- Setup Folder Awal
local Services = getgenv().AW_Modules.Services
local Utils = getgenv().AW_Modules.Utils

if not isfolder("ANUI") then makefolder("ANUI") end
if not isfolder(Services.FolderPath) then makefolder(Services.FolderPath) end
Utils.SecureWipe() -- Jalankan security check

print("✅ Tahap 1 Berhasil: Core Loaded!")

-- NANTI: Di sini kita akan load Features dan UI
-- LoadModule("UI/Interface.lua")