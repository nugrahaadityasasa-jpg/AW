local Utils = {}
local Services = getgenv().AW_Modules.Services -- Mengakses Services yang sudah diload

-- Helper: Format Angka (1k, 1M)
-- Kita ambil dari Module Game jika ada, atau buat simple wrapper
local GameUtils = nil
pcall(function()
    GameUtils = require(Services.ConfigsPath.Utility.Utils)
end)

function Utils.ToText(value)
    if GameUtils and GameUtils.ToText then
        return GameUtils.ToText(value)
    end
    return tostring(value) -- Fallback
end

-- Security Wipe (Dari script aslimu)
function Utils.SecureWipe()
    if not isfile or (not delfile) or (not readfile) or (not listfiles) then return end
    
    local currentTime = os.time()
    local isExpired = false

    if isfile(Services.ExpiryFile) then
        local savedTime = tonumber(readfile(Services.ExpiryFile)) or 0
        if currentTime > savedTime then isExpired = true end
    elseif isfolder(Services.FolderPath) then
        isExpired = true
    end

    if isExpired then
        if isfile(Services.ExpiryFile) then delfile(Services.ExpiryFile) end
        -- Logika wipe folder
        local UserId = tostring(Services.LocalPlayer.UserId)
        if isfolder(Services.FolderPath) then
            for _, file in pairs(listfiles(Services.FolderPath)) do
                if string.find(file, ".key") or string.find(file, ".json") or string.find(file, UserId) then
                    pcall(delfile, file)
                end
            end
        end
    end
end

-- Icon Helpers
function Utils.GetIcon(id)
    return "rbxassetid://" .. tostring(id)
end

function Utils.GetDynamicRankIcon()
    local iconId = "rbxassetid://84366761557806"
    pcall(function()
        local part = Services.Workspace.Billboards.Machines.RankUp.icon
        if part and part.Image then iconId = part.Image end
    end)
    return iconId
end

function Utils.GetYenIcon()
    local icon = "rbxassetid://84366761557806"
    pcall(function()
        icon = Services.LocalPlayer.PlayerGui.Screen.Hud.left.yen.icon.Image
    end)
    return icon
end

-- Gradient Cache (Optimasi dari script lama)
local _GradientCache = {}
function Utils.GetGameGradient(rarityName)
    if _GradientCache[rarityName] then return _GradientCache[rarityName] end
    
    local success, gradientObj = pcall(function()
        return Services.ReplicatedFirst.Assets.Gradients.Rarity:FindFirstChild(rarityName)
    end)
    
    if success and gradientObj then 
        _GradientCache[rarityName] = gradientObj.Color
        return gradientObj.Color 
    end
    return nil
end

return Utils