local Farming = {}
local Services = getgenv().AW_Modules.Services
local Utils = getgenv().AW_Modules.Utils
local Configs = getgenv().AW_Modules.Configs

-- Variables Internal
local CurrentTarget = nil

-- Helper Local: Mendapatkan Posisi
local function GetPartPosition(obj)
    if typeof(obj) == "Instance" then
        if obj:IsA("Model") then return obj:GetPivot().Position
        elseif obj:IsA("BasePart") then return obj.Position end
    end
    return nil
end

-- [LOGIC UTAMA] Auto Farm Loop
-- Dipanggil terus menerus oleh Main Loop
function Farming.Update()
    local Settings = Configs.Settings
    if not Settings.AutoFarm then return end
    
    local hrp = Services.GetRoot()
    if not hrp then return end

    -- 1. Validasi Target
    if CurrentTarget then
        if not CurrentTarget.Alive or not CurrentTarget.Root or not CurrentTarget.Root.Parent then
            CurrentTarget = nil
        elseif CurrentTarget.Data and CurrentTarget.Data.Health <= 0 then
            CurrentTarget = nil
        end
    end

    -- 2. Cari Target Baru (Jika Kosong)
    if not CurrentTarget and Settings.SelectedEnemy then
        local liveEnemies = getgenv().EnemiesData
        if liveEnemies then
            local myPos = hrp.Position
            local minDist = math.huge
            local candidate = nil
            
            for _, enemy in pairs(liveEnemies) do
                if enemy.Alive and enemy.Config and enemy.Config.Display == Settings.SelectedEnemy then
                    if enemy.Root then
                        local dist = (myPos - enemy.Root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            candidate = enemy
                        end
                    end
                end
            end
            CurrentTarget = candidate
        end
    end

    -- 3. Teleport & Serang
    if CurrentTarget and CurrentTarget.Root then
        pcall(function()
            local enemyRoot = CurrentTarget.Root
            local enemyPos = enemyRoot.Position
            local enemyLook = enemyRoot.CFrame.LookVector
            
            -- Posisi Attack: 6 Stud di depan wajah musuh
            -- Y dikoreksi agar tidak melayang (Logic Feet-Align)
            local attackPos = enemyPos + (Vector3.new(enemyLook.X, 0, enemyLook.Z).Unit * 6)
            local finalPos = Vector3.new(attackPos.X, enemyPos.Y, attackPos.Z)
            
            hrp.CFrame = CFrame.lookAt(finalPos, Vector3.new(enemyPos.X, finalPos.Y, enemyPos.Z))
            
            -- Reset Velocity agar tidak mental
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end)
    end
end

return Farming