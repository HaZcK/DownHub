local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "DownHub",
    Icon = "fish", -- lucide icon
    Author = "KHAFIDZKTP",
    Folder = "OpenUi",
    
    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("Hi!")
        end,
    },
    
    --       remove this all, 
    -- !  ↓  if you DON'T need the key system
    KeySystem = { 
        -- ↓ Optional. You can remove it.
        Key = { "Hafidz", "Khafidz", "Hafiz"},
        
        Note = "Nama Aku Apa?",
        
        -- ↓ Optional. You can remove it.
        SaveKey = false, -- automatically save and load the key.
        
        -- ↓ Optional. You can remove it.
        -- API = {} ← Services. Read about it below ↓
    },
})

local Tab = Window:Tab({
    Title = "Farm",
    Icon = "fish-symbol", -- optional
    Locked = false,
})

Tab:Select() -- Select Tab

local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Variabel penampung
local autoTpEnabled = false
local tpThreshold = 10 -- Nilai default jika belum diinput

-- 1. FUNGSI TELEPORT (ANTI TEMBUS)
local function doSafeTeleport()
    local target = workspace.Game.Plots.KHAFIDZKTP.SpawnLocation
    local character = player.Character
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Gunakan Vector3(0, 10, 0) agar muncul dari langit-langit spawn
        character:PivotTo(target.CFrame + Vector3.new(0, 10, 0))
        print("Auto Teleport Aktif: Menghindari tembus bawah!")
    end
end

-- 2. INPUT (Setting Persentase)
local Input = Tab:Input({
    Title = "Oxygen % Threshold",
    Desc = "Teleport saat oksigen di bawah angka ini",
    Value = "10",
    InputIcon = "wind",
    Type = "Input",
    Placeholder = "Masukkan angka (misal: 6)",
    Callback = function(input) 
        local num = tonumber(input)
        if num then
            tpThreshold = num
            print("Threshold diset ke: " .. tpThreshold .. "%")
        end
    end
})

-- 3. TOGGLE (Aktifkan Fitur)
local Toggle = Tab:Toggle({
    Title = "Auto Teleport Oxygen",
    Desc = "Otomatis balik ke Plot saat sesak napas",
    Icon = "locate",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        autoTpEnabled = state
        print("Auto TP Status: " .. tostring(state))
    end
})

-- 4. MONITORING LOOP (Tetap berjalan di background)
task.spawn(function()
    while true do
        if autoTpEnabled then
            -- Path sesuai info: PersistentUI.OxygenBar
            local oxygenBar = pGui:FindFirstChild("PersistentUI") and pGui.PersistentUI:FindFirstChild("OxygenBar")
            local amountLabel = oxygenBar and oxygenBar.OxygenBar:FindFirstChild("Amount")
            
            if amountLabel then
                -- Ambil angka saja dari text "Oxygen: 100%"
                local currentVal = tonumber(amountLabel.Text:match("%d+"))
                
                if currentVal and currentVal <= tpThreshold then
                    doSafeTeleport()
                    
                    -- Jeda 5 detik supaya tidak teleport terus-menerus dalam satu waktu
                    task.wait(5)
                end
            end
        end
        task.wait(1) -- Cek setiap detik biar hemat performa
    end
end)
