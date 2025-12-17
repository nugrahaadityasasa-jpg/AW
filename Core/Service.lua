local Services = {}

-- 1. Roblox Services
Services.Players = game:GetService("Players")
Services.Workspace = game:GetService("Workspace")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.ReplicatedFirst = game:GetService("ReplicatedFirst")
Services.HttpService = game:GetService("HttpService")
Services.RunService = game:GetService("RunService")
Services.VirtualUser = game:GetService("VirtualUser")

-- 2. Local Player & Character shortcuts
Services.LocalPlayer = Services.Players.LocalPlayer
-- Fungsi untuk update character (karena mati/respawn)
function Services.GetCharacter()
    return Services.LocalPlayer.Character or Services.LocalPlayer.CharacterAdded:Wait()
end
function Services.GetRoot()
    local char = Services.GetCharacter()
    return char:WaitForChild("HumanoidRootPart", 10)
end
function Services.GetHumanoid()
    local char = Services.GetCharacter()
    return char:WaitForChild("Humanoid", 10)
end

-- 3. Paths & Constants
Services.FolderPath = "ANUI/AnimeWeapons"
Services.ExpiryFile = Services.FolderPath .. "/ANHub_Key_Timer.txt"
Services.ZoneDBFile = "Zone_Database.json"

-- 4. Remotes
Services.Reliable = Services.ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Reliable")
Services.Unreliable = Services.ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Unreliable")

-- 5. Game Config Paths
Services.ConfigsPath = Services.ReplicatedStorage.Scripts.Configs

return Services