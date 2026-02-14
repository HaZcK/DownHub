-- Custom Fishing Executor GUI by KHAFIDZKTP
-- Elegant Design with All Functions

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local fishesFolder = workspace:WaitForChild("Game"):WaitForChild("Fishes")
local spawnLocation = workspace:WaitForChild("Game"):WaitForChild("Plots"):WaitForChild("KHAFIDZKTP"):WaitForChild("SpawnLocation")

-- Variables
local selectedFish = ""
local isFarming = false
local autoTpEnabled = false
local tpThreshold = 10

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingExecutor"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 480)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Gradient Background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
Gradient.Rotation = 135
Gradient.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 15)
TopBarCorner.Parent = TopBar

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 15)
TopBarFix.Position = UDim2.new(0, 0, 1, -15)
TopBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title with Icon
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐟 DownHub Executor"
Title.TextColor3 = Color3.fromRGB(100, 180, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Rainbow animation for title
spawn(function()
    while wait(0.05) do
        for i = 0, 1, 0.01 do
            if Title then
                Title.TextColor3 = Color3.fromHSV(i, 0.7, 1)
            end
            wait(0.05)
        end
    end
end)

-- Credits
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(0, 150, 1, 0)
Credits.Position = UDim2.new(1, -285, 0, 0)
Credits.BackgroundTransparency = 1
Credits.Text = "By: KHAFIDZKTP"
Credits.TextColor3 = Color3.fromRGB(150, 100, 255)
Credits.TextSize = 13
Credits.Font = Enum.Font.GothamBold
Credits.TextXAlignment = Enum.TextXAlignment.Right
Credits.Parent = TopBar

-- Animated gradient for credits
local CreditsGradient = Instance.new("UIGradient")
CreditsGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
}
CreditsGradient.Parent = Credits

spawn(function()
    while wait() do
        TweenService:Create(CreditsGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
            Offset = Vector2.new(1, 0)
        }):Play()
        wait(3)
    end
end)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(20, 20, 30)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ContentFrame.Parent = MainFrame

-- Section 1: Auto TP Oxygen
local Section1 = Instance.new("Frame")
Section1.Size = UDim2.new(1, -20, 0, 180)
Section1.Position = UDim2.new(0, 10, 0, 10)
Section1.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Section1.BorderSizePixel = 0
Section1.Parent = ContentFrame

local Section1Corner = Instance.new("UICorner")
Section1Corner.CornerRadius = UDim.new(0, 10)
Section1Corner.Parent = Section1

local Section1Title = Instance.new("TextLabel")
Section1Title.Size = UDim2.new(1, -20, 0, 35)
Section1Title.Position = UDim2.new(0, 10, 0, 5)
Section1Title.BackgroundTransparency = 1
Section1Title.Text = "⚡ Auto Teleport Oxygen"
Section1Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Section1Title.TextSize = 16
Section1Title.Font = Enum.Font.GothamBold
Section1Title.TextXAlignment = Enum.TextXAlignment.Left
Section1Title.Parent = Section1

-- Oxygen Input
local OxygenLabel = Instance.new("TextLabel")
OxygenLabel.Size = UDim2.new(1, -20, 0, 25)
OxygenLabel.Position = UDim2.new(0, 10, 0, 45)
OxygenLabel.BackgroundTransparency = 1
OxygenLabel.Text = "Oxygen % Threshold:"
OxygenLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OxygenLabel.TextSize = 13
OxygenLabel.Font = Enum.Font.Gotham
OxygenLabel.TextXAlignment = Enum.TextXAlignment.Left
OxygenLabel.Parent = Section1

local OxygenInput = Instance.new("TextBox")
OxygenInput.Size = UDim2.new(1, -20, 0, 40)
OxygenInput.Position = UDim2.new(0, 10, 0, 75)
OxygenInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
OxygenInput.BorderSizePixel = 0
OxygenInput.Text = "10"
OxygenInput.PlaceholderText = "Masukkan angka (contoh: 6)"
OxygenInput.TextColor3 = Color3.fromRGB(255, 255, 255)
OxygenInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
OxygenInput.TextSize = 14
OxygenInput.Font = Enum.Font.Gotham
OxygenInput.Parent = Section1

local OxygenInputCorner = Instance.new("UICorner")
OxygenInputCorner.CornerRadius = UDim.new(0, 8)
OxygenInputCorner.Parent = OxygenInput

-- Oxygen Toggle
local OxygenToggle = Instance.new("TextButton")
OxygenToggle.Size = UDim2.new(1, -20, 0, 45)
OxygenToggle.Position = UDim2.new(0, 10, 0, 125)
OxygenToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
OxygenToggle.BorderSizePixel = 0
OxygenToggle.Text = "🔴 Auto TP: OFF"
OxygenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
OxygenToggle.TextSize = 15
OxygenToggle.Font = Enum.Font.GothamBold
OxygenToggle.Parent = Section1

local OxygenToggleCorner = Instance.new("UICorner")
OxygenToggleCorner.CornerRadius = UDim.new(0, 8)
OxygenToggleCorner.Parent = OxygenToggle

-- Section 2: Auto Farm Ikan
local Section2 = Instance.new("Frame")
Section2.Size = UDim2.new(1, -20, 0, 280)
Section2.Position = UDim2.new(0, 10, 0, 200)
Section2.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Section2.BorderSizePixel = 0
Section2.Parent = ContentFrame

local Section2Corner = Instance.new("UICorner")
Section2Corner.CornerRadius = UDim.new(0, 10)
Section2Corner.Parent = Section2

local Section2Title = Instance.new("TextLabel")
Section2Title.Size = UDim2.new(1, -20, 0, 35)
Section2Title.Position = UDim2.new(0, 10, 0, 5)
Section2Title.BackgroundTransparency = 1
Section2Title.Text = "🐠 Auto Farm Ikan"
Section2Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Section2Title.TextSize = 16
Section2Title.Font = Enum.Font.GothamBold
Section2Title.TextXAlignment = Enum.TextXAlignment.Left
Section2Title.Parent = Section2

-- Fish Dropdown Button
local FishDropdown = Instance.new("TextButton")
FishDropdown.Size = UDim2.new(1, -20, 0, 45)
FishDropdown.Position = UDim2.new(0, 10, 0, 45)
FishDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FishDropdown.BorderSizePixel = 0
FishDropdown.Text = "📋 Pilih Ikan: Kosong (Klik Refresh)"
FishDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
FishDropdown.TextSize = 14
FishDropdown.Font = Enum.Font.Gotham
FishDropdown.TextXAlignment = Enum.TextXAlignment.Left
FishDropdown.Parent = Section2

local FishDropdownPadding = Instance.new("UIPadding")
FishDropdownPadding.PaddingLeft = UDim.new(0, 10)
FishDropdownPadding.Parent = FishDropdown

local FishDropdownCorner = Instance.new("UICorner")
FishDropdownCorner.CornerRadius = UDim.new(0, 8)
FishDropdownCorner.Parent = FishDropdown

-- Dropdown List
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Size = UDim2.new(1, 0, 0, 0)
DropdownList.Position = UDim2.new(0, 0, 1, 5)
DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
DropdownList.BorderSizePixel = 0
DropdownList.ScrollBarThickness = 4
DropdownList.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
DropdownList.Visible = false
DropdownList.ClipsDescendants = true
DropdownList.Parent = FishDropdown

local DropdownListCorner = Instance.new("UICorner")
DropdownListCorner.CornerRadius = UDim.new(0, 8)
DropdownListCorner.Parent = DropdownList

local DropdownListLayout = Instance.new("UIListLayout")
DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropdownListLayout.Padding = UDim.new(0, 2)
DropdownListLayout.Parent = DropdownList

-- Refresh Button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 45)
RefreshBtn.Position = UDim2.new(0, 10, 0, 100)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Text = "🔄 Refresh List Ikan"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 15
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Parent = Section2

local RefreshBtnCorner = Instance.new("UICorner")
RefreshBtnCorner.CornerRadius = UDim.new(0, 8)
RefreshBtnCorner.Parent = RefreshBtn

-- Farm Info
local FarmInfo = Instance.new("TextLabel")
FarmInfo.Size = UDim2.new(1, -20, 0, 60)
FarmInfo.Position = UDim2.new(0, 10, 0, 155)
FarmInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FarmInfo.BorderSizePixel = 0
FarmInfo.Text = "ℹ️ Info: Pilih ikan, lalu aktifkan farming.\nScript akan TP ke ikan, ambil, dan repeat."
FarmInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
FarmInfo.TextSize = 12
FarmInfo.Font = Enum.Font.Gotham
FarmInfo.TextWrapped = true
FarmInfo.TextYAlignment = Enum.TextYAlignment.Top
FarmInfo.Parent = Section2

local FarmInfoPadding = Instance.new("UIPadding")
FarmInfoPadding.PaddingLeft = UDim.new(0, 10)
FarmInfoPadding.PaddingTop = UDim.new(0, 10)
FarmInfoPadding.Parent = FarmInfo

local FarmInfoCorner = Instance.new("UICorner")
FarmInfoCorner.CornerRadius = UDim.new(0, 8)
FarmInfoCorner.Parent = FarmInfo

-- Farm Toggle
local FarmToggle = Instance.new("TextButton")
FarmToggle.Size = UDim2.new(1, -20, 0, 50)
FarmToggle.Position = UDim2.new(0, 10, 0, 225)
FarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FarmToggle.BorderSizePixel = 0
FarmToggle.Text = "🔴 Auto Farm: OFF"
FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmToggle.TextSize = 16
FarmToggle.Font = Enum.Font.GothamBold
FarmToggle.Parent = Section2

local FarmToggleCorner = Instance.new("UICorner")
FarmToggleCorner.CornerRadius = UDim.new(0, 10)
FarmToggleCorner.Parent = FarmToggle

-- Notification System
local function ShowNotification(text, duration, color)
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 320, 0, 70)
    Notif.Position = UDim2.new(1, 10, 0, 60)
    Notif.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
    Notif.BorderSizePixel = 0
    Notif.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = Notif
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, -10)
    NotifText.Position = UDim2.new(0, 10, 0, 5)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 13
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextWrapped = true
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.Parent = Notif
    
    TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -330, 0, 60)
    }):Play()
    
    wait(duration or 3)
    TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 10, 0, 60)
    }):Play()
    wait(0.5)
    Notif:Destroy()
end

-- Button Hover Animation
local function AnimateButton(button, hoverColor)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor or originalColor:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

AnimateButton(MinimizeBtn, Color3.fromRGB(255, 200, 80))
AnimateButton(CloseBtn, Color3.fromRGB(255, 120, 120))
AnimateButton(OxygenToggle)
AnimateButton(RefreshBtn, Color3.fromRGB(120, 170, 255))
AnimateButton(FarmToggle)

-- No loading screen, just opening animation

-- ==========================================
-- FUNCTIONS
-- ==========================================

-- Safe Teleport Function
local function doSafeTeleport()
    local gameFolder = workspace:FindFirstChild("Game")
    local plotsFolder = gameFolder and gameFolder:FindFirstChild("Plots")
    local myPlot = plotsFolder and plotsFolder:FindFirstChild("KHAFIDZKTP")
    local target = myPlot and myPlot:FindFirstChild("SpawnLocation")
    
    local character = player.Character
    
    if target and character and character:FindFirstChild("HumanoidRootPart") then
        character:PivotTo(target.CFrame + Vector3.new(0, 10, 0))
        ShowNotification("✅ Auto TP: Oksigen kritis!\nKembali ke base.", 2, Color3.fromRGB(100, 200, 120))
    else
        ShowNotification("❌ Gagal TP: Plot tidak ditemukan!", 2, Color3.fromRGB(255, 100, 100))
    end
end

local function safeTeleport(targetCFrame)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:PivotTo(targetCFrame + Vector3.new(0, 10, 0))
    end
end

-- Refresh Fish List
local function RefreshFishList()
    for _, child in pairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local uniqueFishes = {}
    local fishList = {}
    
    for _, fish in ipairs(fishesFolder:GetChildren()) do
        if not uniqueFishes[fish.Name] then
            uniqueFishes[fish.Name] = true
            table.insert(fishList, fish.Name)
        end
    end
    
    if #fishList > 0 then
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, #fishList * 42)
        
        for i, fishName in ipairs(fishList) do
            local FishOption = Instance.new("TextButton")
            FishOption.Size = UDim2.new(1, -8, 0, 40)
            FishOption.Position = UDim2.new(0, 4, 0, (i-1) * 42)
            FishOption.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            FishOption.BorderSizePixel = 0
            FishOption.Text = "🐠 " .. fishName
            FishOption.TextColor3 = Color3.fromRGB(255, 255, 255)
            FishOption.TextSize = 13
            FishOption.Font = Enum.Font.Gotham
            FishOption.TextXAlignment = Enum.TextXAlignment.Left
            FishOption.Parent = DropdownList
            
            local OptionPadding = Instance.new("UIPadding")
            OptionPadding.PaddingLeft = UDim.new(0, 10)
            OptionPadding.Parent = FishOption
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 6)
            OptionCorner.Parent = FishOption
            
            FishOption.MouseButton1Click:Connect(function()
                selectedFish = fishName
                FishDropdown.Text = "📋 Pilih Ikan: " .. fishName
                DropdownList.Visible = false
                ShowNotification("🎯 Target ikan: " .. fishName, 2, Color3.fromRGB(100, 150, 255))
            end)
            
            AnimateButton(FishOption, Color3.fromRGB(60, 60, 85))
        end
        
        ShowNotification("🔄 Refresh berhasil!\nDitemukan " .. #fishList .. " jenis ikan.", 2, Color3.fromRGB(100, 200, 120))
    else
        ShowNotification("⚠️ Tidak ada ikan ditemukan!", 2, Color3.fromRGB(255, 150, 80))
    end
end

-- ==========================================
-- BUTTON FUNCTIONS
-- ==========================================

-- Oxygen Input Change
OxygenInput.FocusLost:Connect(function()
    local cleanInput = string.match(OxygenInput.Text, "%d+")
    local num = tonumber(cleanInput)
    
    if num then
        tpThreshold = num
        ShowNotification("⚙️ Batas Oksigen: " .. tpThreshold .. "%", 2, Color3.fromRGB(100, 150, 255))
    else
        OxygenInput.Text = tostring(tpThreshold)
        ShowNotification("⚠️ Input tidak valid!\nGunakan angka saja.", 2, Color3.fromRGB(255, 150, 80))
    end
end)

-- Oxygen Toggle
OxygenToggle.MouseButton1Click:Connect(function()
    autoTpEnabled = not autoTpEnabled
    
    if autoTpEnabled then
        OxygenToggle.Text = "🟢 Auto TP: ON"
        OxygenToggle.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        ShowNotification("🟢 Auto TP Oksigen AKTIF!\nBatas: " .. tpThreshold .. "%", 2, Color3.fromRGB(100, 200, 120))
    else
        OxygenToggle.Text = "🔴 Auto TP: OFF"
        OxygenToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ShowNotification("🔴 Auto TP Oksigen MATI!", 2, Color3.fromRGB(255, 100, 100))
    end
end)

-- Dropdown Toggle
FishDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, math.min(200, DropdownList.CanvasSize.Y.Offset))
        }):Play()
    else
        TweenService:Create(DropdownList, TweenInfo.new(0.2), {
            Size = UDim2.new(1, 0, 0, 0)
        }):Play()
    end
end)

-- Refresh Button
RefreshBtn.MouseButton1Click:Connect(function()
    RefreshFishList()
end)

-- Farm Toggle
FarmToggle.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    
    if isFarming then
        if selectedFish == "" or selectedFish == "Kosong (Klik Refresh)" then
            isFarming = false
            ShowNotification("⚠️ Pilih ikan terlebih dahulu!", 2, Color3.fromRGB(255, 150, 80))
            return
        end
        FarmToggle.Text = "🟢 Auto Farm: ON"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        ShowNotification("🟢 Auto Farm AKTIF!\nTarget: " .. selectedFish, 2, Color3.fromRGB(100, 200, 120))
    else
        FarmToggle.Text = "🔴 Auto Farm: OFF"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ShowNotification("🔴 Auto Farm MATI!", 2, Color3.fromRGB(255, 100, 100))
    end
end)

-- Close Button
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    wait(0.4)
    ScreenGui:Destroy()
end)

-- Minimize
local minimized = false
local originalSize = MainFrame.Size
local originalPosition = MainFrame.Position

MinimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 280, 0, 45),
            Position = UDim2.new(1, -290, 0, 10)
        }):Play()
        minimized = true
        ShowNotification("📌 GUI diminimalkan", 1.5, Color3.fromRGB(255, 180, 50))
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize,
            Position = originalPosition
        }):Play()
        minimized = false
    end
end)

-- Draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    TweenService:Create(MainFrame, TweenInfo.new(0.1), {
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    }):Play()
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ==========================================
-- BACKGROUND LOOPS
-- ==========================================

-- Oxygen Monitor Loop
task.spawn(function()
    while true do
        if autoTpEnabled then
            local persistentUI = pGui:FindFirstChild("PersistentUI")
            local oxygenBar1 = persistentUI and persistentUI:FindFirstChild("OxygenBar")
            local oxygenBar2 = oxygenBar1 and oxygenBar1:FindFirstChild("OxygenBar")
            local amountLabel = oxygenBar2 and oxygenBar2:FindFirstChild("Amount")
            
            if amountLabel then
                local currentVal = tonumber(string.match(amountLabel.Text, "%d+"))
                
                if currentVal and currentVal <= tpThreshold then
                    doSafeTeleport()
                    task.wait(5)
                end
            end
        end
        task.wait(1)
    end
end)

-- Auto Farm Loop
task.spawn(function()
    while true do
        if isFarming and selectedFish ~= "" and selectedFish ~= "Kosong (Klik Refresh)" then
            local targetFish = nil
            for _, fish in ipairs(fishesFolder:GetChildren()) do
                if fish.Name == selectedFish then
                    targetFish = fish
                    break
                end
            end
            
            if targetFish then
                local targetPos = targetFish:IsA("Model") and targetFish:GetPivot() or targetFish.CFrame
                safeTeleport(targetPos)
                task.wait(0.5)
                
                local prompt = targetFish:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    fireproximityprompt(prompt)
                end
                task.wait(1)
            else
                ShowNotification("⚠️ Ikan " .. selectedFish .. " habis!\nKembali ke base...", 3, Color3.fromRGB(255, 150, 80))
                safeTeleport(spawnLocation.CFrame)
                isFarming = false
                FarmToggle.Text = "🔴 Auto Farm: OFF"
                FarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                task.wait(3)
            end
        end
        task.wait(0.5)
    end
end)

-- Opening Animation Only
spawn(function()
    -- Start from zero size
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    -- Animate to full size
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = originalSize
    }):Play()
    
    wait(0.7)
    ShowNotification("🎉 DownHub Executor siap!\nBy: KHAFIDZKTP", 3, Color3.fromRGB(100, 180, 255))
end)

print("✅ DownHub Executor GUI Loaded!")
print("👤 Created by: KHAFIDZKTP")
