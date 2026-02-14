local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local fishesFolder = workspace:WaitForChild("Game"):WaitForChild("Fishes")
local spawnLocation = workspace:WaitForChild("Game"):WaitForChild("Plots"):WaitForChild("KHAFIDZKTP"):WaitForChild("SpawnLocation")

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
})

local Tab = Window:Tab({
    Title = "Farm",
    Icon = "fish-symbol", -- optional
    Locked = false,
})

Tab:Select() -- Select Tabi

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


-- Variabel penyimpan data
local selectedFish = ""
local isFarming = false

-- ==========================================
-- FUNGSI TELEPORT AMAN (ANTI TEMBUS BAWAH)
-- ==========================================
local function safeTeleport(targetCFrame)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Ditambah Vector3(0, 10, 0) supaya teleport di atas target (langit-langit)
        character:PivotTo(targetCFrame + Vector3.new(0, 10, 0))
    end
end

-- ==========================================
-- UI ELEMENT: DROPDOWN, BUTTON & TOGGLE
-- ==========================================

-- 1. Dropdown (Selection)
local FishDropdown = Tab:Dropdown({
    Title = "Pilih Ikan Target",
    Desc = "Pilih jenis ikan yang mau di-farm",
    Values = {"Kosong (Klik Refresh)"},
    Value = "Kosong (Klik Refresh)",
    Callback = function(value)
        selectedFish = value
        print("Membidik ikan: " .. value)
    end
})

-- 2. Button (Refresh List)
local RefreshBtn = Tab:Button({
    Title = "Refresh List Ikan",
    Desc = "Mencari ikan yang spawn dan menghapus nama ganda",
    Callback = function()
        local uniqueFishes = {} -- Untuk nyimpen sementara agar tidak duplikat
        local listForDropdown = {} -- Untuk dimasukkan ke UI
        
        -- Cek semua ikan di folder
        for _, fish in ipairs(fishesFolder:GetChildren()) do
            if not uniqueFishes[fish.Name] then
                uniqueFishes[fish.Name] = true
                table.insert(listForDropdown, fish.Name)
            end
        end
        
        -- Update Dropdown di UI
        if #listForDropdown > 0 then
            FishDropdown:Refresh(listForDropdown)
            print("Berhasil refresh! Ditemukan " .. #listForDropdown .. " jenis ikan.")
        else
            FishDropdown:Refresh({"Tidak ada ikan"})
            print("Folder ikan kosong!")
        end
    end
})

-- 3. Toggle (Auto Farm)
local FarmToggle = Tab:Toggle({
    Title = "Auto Farm Ikan",
    Desc = "TP ke ikan, ambil, ulang. Balik ke base kalau habis.",
    Icon = "swords",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        isFarming = state
        print("Auto Farm: " .. tostring(state))
    end
})

-- ==========================================
-- BACKGROUND LOOP (LOGIKA AUTO FARM)
-- ==========================================
task.spawn(function()
    while true do
        if isFarming and selectedFish ~= "" and selectedFish ~= "Kosong (Klik Refresh)" and selectedFish ~= "Tidak ada ikan" then
            
            -- Cari 1 ikan yang namanya cocok sama pilihan kita
            local targetFish = nil
            for _, fish in ipairs(fishesFolder:GetChildren()) do
                if fish.Name == selectedFish then
                    targetFish = fish
                    break -- Langsung stop pencarian kalau udah ketemu 1
                end
            end
            
            if targetFish then
                -- 1. Teleport ke ikan tersebut (pakai CFrame/Pivot)
                -- Kalau ikan bentuknya Model, pakai GetPivot(). Kalau Part, pakai CFrame.
                local targetPos = targetFish:IsA("Model") and targetFish:GetPivot() or targetFish.CFrame
                safeTeleport(targetPos)
                
                -- Tunggu sebentar biar karakter mendarat dan server ngebaca kita udah di sana
                task.wait(0.5) 
                
                -- 2. Cari ProximityPrompt di dalam ikan tersebut dan aktifkan
                local prompt = targetFish:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    -- Script executor standar untuk interaksi (nge-klik E otomatis)
                    fireproximityprompt(prompt)
                end
                
                -- Tunggu sedikit sebelum nyari ikan selanjutnya
                task.wait(1) 
                
            else
                -- JIKA IKAN SUDAH HABIS/TIDAK DITEMUKAN
                print("Ikan " .. selectedFish .. " sudah habis! Balik ke base...")
                
                -- Teleport aman ke Base/Plot
                safeTeleport(spawnLocation.CFrame)
                
                -- Matikan farming supaya tidak teleport-teleport sendiri nyari hantu
                isFarming = false
                
                -- Opsional: Kalau WindUI punya cara matiin toggle lewat script, panggil di sini
                -- (Bergantung dari library WindUI, biasanya cukup ubah variabel internal atau pakai function SetValue)
                
                -- Beri jeda agak lama biar aman
                task.wait(3)
            end
        end
        task.wait(0.5) -- Loop jalan setiap 0.5 detik
    end
end)
