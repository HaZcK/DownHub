-- [[ KHAFIDZKTP PRIVATE LOADER - FAMILY EDITION ]] --

local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- 1. SISTEM WHITELIST (Hanya 2 Orang)
local allowedUsers = { 
    ["KHAFIDZKTP"] = true, 
    ["zeros7299"] = true 
}

if not allowedUsers[player.Name] then 
    player:Kick("Akses Ditolak: Skrip ini Private untuk KHAFIDZKTP & zeros7299 sahaja.") 
    return 
end

-- 2. DYNAMIC PLOT DETECTION
local function getMyPlot()
    local plots = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(player.Name)
    return plot and plot:FindFirstChild("SpawnLocation")
end

local function safeTeleport()
    local target = getMyPlot()
    if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:PivotTo(target.CFrame + Vector3.new(0, 10, 0))
    end
end

-- 3. LOAD DOWNHUB ULTIMATE (ASAL)
-- Memanggil skrip utama dari link yang kamu berikan
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HaZcK/DownHub/refs/heads/main/Ultimate.lua"))()
end)

-- 4. LOGIKA TAMBAHAN (Oksigen, Noclip, Anti-Void)
-- Variabel ini boleh kamu sambungkan ke Toggle UI kamu sendiri nanti
_G.KhafidzFlags = {
    autoOxy = false,
    oxyValue = 10,
    infOxy = false,
    noclip = false
}

-- Loop Noclip & Anti-Void
RunService.Stepped:Connect(function()
    if _G.KhafidzFlags.noclip and player.Character then
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    -- Anti-Void
    if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position.Y < -50 then
        safeTeleport()
    end
end)

-- Loop Background Oksigen
task.spawn(function()
    while true do
        if _G.KhafidzFlags.autoOxy then
            local label = pGui:FindFirstChild("PersistentUI") and pGui.PersistentUI.OxygenBar.OxygenBar:FindFirstChild("Amount")
            if label then
                local current = tonumber(label.Text:match("%d+"))
                if current and current <= _G.KhafidzFlags.oxyValue then 
                    safeTeleport() 
                    task.wait(5) 
                end
            end
        end
        
        if _G.KhafidzFlags.infOxy then
            local fill = pGui:FindFirstChild("PersistentUI") and pGui.PersistentUI.Code.OxygenController:FindFirstChild("OxygenFill")
            if fill then fill.Value = 1 end
        end
        task.wait(0.5)
    end
end)

-- Notifikasi Welcome
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "KHAFIDZHUB ACTIVE",
    Text = "Welcome " .. player.Name .. "!",
    Duration = 5
})

print("KhafidzHub Private Edition successfully integrated with DownHub.")

