local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local fishesFolder = workspace:WaitForChild("Game"):WaitForChild("Fishes")
local player = game.Players.LocalPlayer
local spawnLocation = workspace:WaitForChild("Game"):WaitForChild("Plots"):WaitForChild(player.Name):WaitForChild("SpawnLocation")


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

local autoTpEnabled = false
local tpThreshold = 10 

-- ==========================================
-- 1. FUNGSI TELEPORT AMAN
-- ==========================================
local function doSafeTeleport()
    -- Menggunakan FindFirstChild agar script tidak langsung error/mati kalau plotnya telat load
    local gameFolder = workspace:FindFirstChild("Game")
    local plotsFolder = gameFolder and gameFolder:FindFirstChild("Plots")
    local myPlot = plotsFolder and plotsFolder:FindFirstChild("KHAFIDZKTP")
    local target = myPlot and myPlot:FindFirstChild("SpawnLocation")
    
    local character = player.Character
    
    if target and character and character:FindFirstChild("HumanoidRootPart") then
        character:PivotTo(target.CFrame + Vector3.new(0, 10, 0))
        print("✅ Auto TP Berhasil! Oksigen kritis, balik ke base.")
    else
        warn("❌ Gagal TP: Karakter atau SpawnLocation KHAFIDZKTP tidak ditemukan!")
    end
end

-- ==========================================
-- 2. SETUP UI WINDUI
-- ==========================================
local Input = Tab:Input({
    Title = "Oxygen % Threshold",
    Desc = "Teleport saat oksigen di bawah angka ini",
    Value = "10",
    InputIcon = "wind",
    Type = "Input",
    Locked = True,
    Placeholder = "Masukkan angka (misal: 6)",
    Callback = function(input) 
        -- Memastikan input dibersihkan dari huruf/spasi, murni ambil angkanya saja
        local cleanInput = string.match(input, "%d+")
        local num = tonumber(cleanInput)
        
        if num then
            tpThreshold = num
            print("⚙️ Batas Oksigen diubah menjadi: " .. tpThreshold .. "%")
        else
            warn("⚠️ Input tidak valid! Tolong masukkan angka.")
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "Auto Teleport Oxygen",
    Desc = "Otomatis balik ke Plot saat oksigen menipis",
    Icon = "locate",
    Type = "Checkbox",
    Value = false,
    Locked = True,
    Callback = function(state) 
        autoTpEnabled = state
        print("🔄 Auto TP Oksigen: " .. (state and "MENYALA" or "MATI"))
    end
})

-- ==========================================
-- 3. BACKGROUND LOOP (Pendeteksi Oksigen)
-- ==========================================
task.spawn(function()
    while true do
        if autoTpEnabled then
            -- Mencari UI Oksigen dengan aman
            local persistentUI = pGui:FindFirstChild("PersistentUI")
            local oxygenBar1 = persistentUI and persistentUI:FindFirstChild("OxygenBar")
            local oxygenBar2 = oxygenBar1 and oxygenBar1:FindFirstChild("OxygenBar")
            local amountLabel = oxygenBar2 and oxygenBar2:FindFirstChild("Amount")
            
            if amountLabel then
                -- Menarik angka dari teks UI (misal: "Oxygen: 100%" -> jadi 100)
                local currentVal = tonumber(string.match(amountLabel.Text, "%d+"))
                
                if currentVal then
                    -- Matikan tanda kutip di bawah ini kalau kamu mau lihat log pembacaan oksigen di F9
                    -- print("🔍 Info Oksigen: Saat ini " .. currentVal .. "% | Batas TP: " .. tpThreshold .. "%")
                    
                    if currentVal <= tpThreshold then
                        doSafeTeleport()
                        task.wait(5) -- Berhenti sejenak selama 5 detik setelah TP agar tidak spam
                    end
                else
                    warn("❌ Script tidak bisa membaca angka dari teks: " .. tostring(amountLabel.Text))
                end
            else
                -- Jika UI belum muncul di layar
                -- warn("⏳ Menunggu UI Oksigen muncul...")
            end
        end
        task.wait(1) -- Cek setiap 1 detik
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
