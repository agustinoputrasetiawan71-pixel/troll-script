-- ================================================
-- TINZZ GRAB PLAYER - TARIK ORANG KE POSISI KAMU
-- ================================================
-- [[
--    Developed by: TINZZxXITERS
--    Fitur: Tarik player ke posisi kamu, anti bug visual
--    Status: 100% Work All Maps
-- ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================================
-- CONFIG
-- ================================================

local CORRECT_KEY = "TINZZxXITERS"
local GrabEnabled = false
local GrabTarget = nil
local GrabMode = "halus" -- "halus" atau "langsung"
local GrabDistance = 2 -- Jarak setelah ditarik (makin kecil makin nempel)

-- ================================================
-- UTILITIES
-- ================================================

local function Create(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props) do 
        if k ~= "Parent" then o[k] = v end 
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

-- ================================================
-- FUNGSI TARIK PLAYER (GRAB)
-- ================================================

-- METHOD 1: GRAB HALUS (PAKE TWEEN - ANTI BUG VISUAL)
local function grabPlayerSmooth(targetChar, myChar)
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    
    if not targetHrp or not myHrp or not targetHumanoid then return end
    
    -- Hitung posisi target (di depan/samping kamu, sesuai keinginan)
    -- Bisa diatur: di depan, samping, atau tepat di posisi kamu
    local targetPos = myHrp.Position + (myHrp.CFrame.LookVector * 2) -- Di depan kamu
    
    -- Pake Tween biar gerak halus (anti bug visual)
    local tweenInfo = TweenInfo.new(
        0.3, -- Waktu (cepat tapi halus)
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(targetHrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    
    -- Bikin dia ngadep ke kamu
    local lookAt = CFrame.lookAt(targetHrp.Position, myHrp.Position)
    targetHrp.CFrame = CFrame.new(targetHrp.Position) * CFrame.Angles(0, lookAt:ToOrientation(), 0)
end

-- METHOD 2: GRAB LANGSUNG (CEPAT, TAPI KASAR)
local function grabPlayerDirect(targetChar, myChar)
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    
    if not targetHrp or not myHrp then return end
    
    -- Teleport langsung ke posisi yang ditentukan
    local targetPos = myHrp.Position + (myHrp.CFrame.LookVector * 2) -- Di depan kamu
    targetHrp.CFrame = CFrame.new(targetPos)
    
    -- Puter badan ngadep kamu
    local lookAt = CFrame.lookAt(targetHrp.Position, myHrp.Position)
    targetHrp.CFrame = CFrame.new(targetHrp.Position) * CFrame.Angles(0, lookAt:ToOrientation(), 0)
end

-- METHOD 3: GRAB + FREEZE SEMENTARA (BIAR DIAM)
local function grabAndFreeze(targetChar, myChar, duration)
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    
    if not targetHrp or not myHrp or not targetHumanoid then return end
    
    -- 1. Tarik ke posisi kamu
    local targetPos = myHrp.Position + (myHrp.CFrame.LookVector * 2)
    targetHrp.CFrame = CFrame.new(targetPos)
    
    -- 2. Freeze sementara (pake BodyPosition)
    local bp = Instance.new("BodyPosition")
    bp.P = 10000
    bp.D = 100
    bp.MaxForce = Vector3.new(9e4, 9e4, 9e4)
    bp.Position = targetPos
    bp.Parent = targetHrp
    
    -- 3. Matiin humanoid biar ga gerak
    targetHumanoid.PlatformStand = true
    
    -- 4. Unfreeze setelah beberapa detik
    task.delay(duration or 2, function()
        if bp and bp.Parent then bp:Destroy() end
        if targetHumanoid then targetHumanoid.PlatformStand = false end
    end)
end

-- ================================================
-- MAIN GRAB LOOP
-- ================================================

local function UpdateGrab()
    if not GrabEnabled or not GrabTarget or not GrabTarget.Character or not LocalPlayer.Character then 
        return 
    end
    
    local targetChar = GrabTarget.Character
    local myChar = LocalPlayer.Character
    
    if GrabMode == "halus" then
        grabPlayerSmooth(targetChar, myChar)
    elseif GrabMode == "langsung" then
        grabPlayerDirect(targetChar, myChar)
    elseif GrabMode == "freeze" then
        grabAndFreeze(targetChar, myChar, 2)
    end
end

-- ================================================
-- GUI GRAB PANEL
-- ================================================

local ScreenGui = Create("ScreenGui", {
    Name = "TINZZ_Grab",
    Parent = game.CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

-- Key System
local KeyFrame = Create("Frame", {
    Size = UDim2.new(0, 350, 0, 220),
    Position = UDim2.new(0.5, -175, 0.5, -110),
    BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    BackgroundTransparency = 0.05,
    ZIndex = 100,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(0, 20), Parent = KeyFrame})

local KeyBorder = Create("UIStroke", {
    Thickness = 3,
    Color = Color3.fromRGB(255, 50, 50),
    Transparency = 0.3,
    Parent = KeyFrame
})

local KeyTitle = Create("TextLabel", {
    Text = "🔐 TINZZ GRAB PANEL",
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    ZIndex = 101,
    Parent = KeyFrame
})

local KeyInput = Create("TextBox", {
    PlaceholderText = "Key...",
    Text = "",
    Size = UDim2.new(0.8, 0, 0, 40),
    Position = UDim2.new(0.1, 0, 0.4, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 18),
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.Gotham,
    TextSize = 16,
    ZIndex = 101,
    Parent = KeyFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = KeyInput})

local KeyBtn = Create("TextButton", {
    Text = "MASUK",
    Size = UDim2.new(0.6, 0, 0, 40),
    Position = UDim2.new(0.2, 0, 0.65, 0),
    BackgroundColor3 = Color3.fromRGB(255, 50, 50),
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 101,
    Parent = KeyFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = KeyBtn})

-- Main Menu
local MainFrame = Create("Frame", {
    Size = UDim2.new(0, 350, 0, 400),
    Position = UDim2.new(0.5, -175, 0.5, -200),
    BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    BackgroundTransparency = 0.02,
    Visible = false,
    ZIndex = 10,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(0, 20), Parent = MainFrame})
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(15, 15, 18),
    ZIndex = 11,
    Parent = MainFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 20), Parent = TitleBar})

local TitleText = Create("TextLabel", {
    Text = "🎣 TINZZ GRAB PLAYER",
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
    Parent = TitleBar
})

local CloseBtn = Create("TextButton", {
    Text = "✕",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(255, 50, 50),
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    ZIndex = 12,
    Parent = TitleBar
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = CloseBtn})

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Content
local ContentFrame = Create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50),
    CanvasSize = UDim2.new(0, 0, 2, 0),
    ZIndex = 13,
    Parent = MainFrame
})

-- Dropdown Player
local playerFrame = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 80),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    ZIndex = 14,
    Parent = ContentFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = playerFrame})

local playerTitle = Create("TextLabel", {
    Text = "🎯 Pilih Target",
    Size = UDim2.new(1, -10, 0, 25),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 15,
    Parent = playerFrame
})

local selectedLabel = Create("TextLabel", {
    Text = "Belum dipilih",
    Size = UDim2.new(1, -50, 0, 30),
    Position = UDim2.new(0, 10, 0, 35),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ZIndex = 15,
    Parent = playerFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = selectedLabel})

local dropdownBtn = Create("TextButton", {
    Text = "▼",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -45, 0, 35),
    BackgroundColor3 = Color3.fromRGB(255, 50, 50),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    ZIndex = 15,
    Parent = playerFrame
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dropdownBtn})

-- Dropdown list
local listFrame = Create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 0, 150),
    Position = UDim2.new(0, 10, 1, 5),
    BackgroundColor3 = Color3.fromRGB(25, 25, 30),
    Visible = false,
    ZIndex = 999,
    Parent = playerFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = listFrame})

local function updatePlayerList()
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local yPos = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Create("TextButton", {
                Text = player.Name,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, yPos),
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                TextColor3 = Color3.fromRGB(240, 240, 240),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                ZIndex = 1000,
                Parent = listFrame
            })
            
            btn.MouseButton1Click:Connect(function()
                GrabTarget = player
                selectedLabel.Text = "📌 " .. player.Name
                listFrame.Visible = false
                dropdownBtn.Text = "▼"
            end)
            
            yPos = yPos + 30
        end
    end
    listFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

updatePlayerList()

dropdownBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
    dropdownBtn.Text = listFrame.Visible and "▲" or "▼"
    if listFrame.Visible then updatePlayerList() end
end)

-- Mode Grab
local modeFrame = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    ZIndex = 14,
    Parent = ContentFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = modeFrame})

local modeTitle = Create("TextLabel", {
    Text = "⚙️ Mode Grab",
    Size = UDim2.new(1, -10, 0, 25),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 15,
    Parent = modeFrame
})

local modeBtns = {
    {text = "✨ Halus", mode = "halus", color = Color3.fromRGB(100, 200, 255)},
    {text = "⚡ Langsung", mode = "langsung", color = Color3.fromRGB(255, 150, 50)},
    {text = "❄️ Freeze", mode = "freeze", color = Color3.fromRGB(150, 100, 255)}
}

for i, data in ipairs(modeBtns) do
    local btn = Create("TextButton", {
        Text = data.text,
        Size = UDim2.new(0.3, -5, 0, 30),
        Position = UDim2.new(0.025 + ((i-1) * 0.325), 0, 0, 35),
        BackgroundColor3 = data.color,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 15,
        Parent = modeFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = btn})
    
    btn.MouseButton1Click:Connect(function()
        GrabMode = data.mode
        -- Highlight tombol yang dipilih
        for _, b in pairs(modeFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = b == btn and data.color or Color3.fromRGB(40, 40, 45)
            end
        end
    end)
end

-- Toggle Grab
local grabToggleFrame = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    ZIndex = 14,
    Parent = ContentFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = grabToggleFrame})

local grabToggleTitle = Create("TextLabel", {
    Text = "🎣 Aktifkan Grab",
    Size = UDim2.new(0.7, 0, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 15,
    Parent = grabToggleFrame
})

local grabToggle = Create("TextButton", {
    Text = "",
    Size = UDim2.new(0, 50, 0, 25),
    Position = UDim2.new(1, -60, 0.5, -12.5),
    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
    ZIndex = 15,
    Parent = grabToggleFrame
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = grabToggle})

local grabCircle = Create("Frame", {
    Size = UDim2.new(0, 21, 0, 21),
    Position = UDim2.new(0, 4, 0.5, -10.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    ZIndex = 16,
    Parent = grabToggle
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = grabCircle})

-- Reset button
local resetBtn = Create("TextButton", {
    Text = "🔄 Reset Target",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(255, 50, 50),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    ZIndex = 14,
    Parent = ContentFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = resetBtn})

resetBtn.MouseButton1Click:Connect(function()
    GrabTarget = nil
    selectedLabel.Text = "Belum dipilih"
    if GrabEnabled then
        GrabEnabled = false
        grabToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        grabCircle.Position = UDim2.new(0, 4, 0.5, -10.5)
    end
end)

-- Floating button
local FloatingBtn = Create("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 10, 0.5, -25),
    BackgroundColor3 = Color3.fromRGB(255, 50, 50),
    Text = "🎣",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Visible = false,
    ZIndex = 20,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = FloatingBtn})
FloatingBtn.Active = true
FloatingBtn.Draggable = true

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ================================================
-- KEY SYSTEM LOGIC
-- ================================================

KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
        FloatingBtn.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "KEY SALAH!"
    end
end)

-- Grab toggle logic
grabToggle.MouseButton1Click:Connect(function()
    GrabEnabled = not GrabEnabled
    if GrabEnabled then
        grabToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        grabCircle.Position = UDim2.new(1, -25, 0.5, -10.5)
    else
        grabToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        grabCircle.Position = UDim2.new(0, 4, 0.5, -10.5)
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    UpdateGrab()
end)

print("✅ TINZZ GRAB PLAYER Loaded!")
print("🔑 Key: " .. CORRECT_KEY)
