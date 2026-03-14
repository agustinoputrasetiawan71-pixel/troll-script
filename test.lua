-- ================================================
-- TINZZxXITERS TROLL PANEL V1 - ESP + TROLL ONLY
-- ================================================
-- [[
--    Developed by: TINZZxXITERS
--    Features: Simple ESP, Troll Menu, Auto Follow
--    Status: 100% Work All Maps (FIXED)
-- ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")  -- FIXED!
local TweenService = game:GetService("TweenService")          -- FIXED!
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================================
-- CONFIG & KEY SYSTEM
-- ================================================

local CORRECT_KEY = "TINZZxXITERS"
local ESPEnabled = false
local AutoFollowEnabled = false
local FollowTarget = nil
local FollowDistance = 3
local InfiniteJump = false
local FlyEnabled = false
local SpinEnabled = false
local BigHeadEnabled = false
local SmallHeadEnabled = false
local RainbowEnabled = false
local WalkSpeedEnabled = false
local JumpPowerEnabled = false

-- ESP Settings (simple)
local ESPSettings = {
    Box = false,
    Name = false,
    Distance = false,
    Tracer = false
}

-- ================================================
-- UI COLORS
-- ================================================

local C = {
    MainBG = Color3.fromRGB(10, 10, 12),
    SidebarBG = Color3.fromRGB(15, 15, 18),
    Accent = Color3.fromRGB(255, 50, 50), -- TINZZ Red
    Text = Color3.fromRGB(240, 240, 240),
    ToggleOff = Color3.fromRGB(40, 40, 45),
    Troll = Color3.fromRGB(255, 100, 100),
    ESP = Color3.fromRGB(100, 150, 255)
}

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

local function MakeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
end

-- ================================================
-- SIMPLE ESP SYSTEM
-- ================================================

local ESP_Objects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local objects = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    objects.Box.Thickness = 1.5
    objects.Box.Filled = false
    objects.Box.Color = C.Accent
    
    objects.Name.Size = 14
    objects.Name.Center = true
    objects.Name.Outline = true
    objects.Name.Color = Color3.fromRGB(255, 255, 255)
    
    objects.Distance.Size = 12
    objects.Distance.Center = true
    objects.Distance.Outline = true
    objects.Distance.Color = Color3.fromRGB(255, 255, 0)
    
    objects.Tracer.Thickness = 1.5
    objects.Tracer.Color = C.Accent
    
    ESP_Objects[player] = objects
end

local function UpdateESP()
    for player, objects in pairs(ESP_Objects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            
            if hrp and hum and head then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    -- Box ESP
                    objects.Box.Visible = ESPSettings.Box and ESPEnabled
                    if ESPSettings.Box and ESPEnabled then
                        local size = Vector2.new(3000 / pos.Z, 4000 / pos.Z)
                        objects.Box.Size = size
                        objects.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                    end
                    
                    -- Tracer
                    objects.Tracer.Visible = ESPSettings.Tracer and ESPEnabled
                    if ESPSettings.Tracer and ESPEnabled then
                        objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        objects.Tracer.To = Vector2.new(pos.X, pos.Y)
                    end
                    
                    -- Name
                    objects.Name.Visible = ESPSettings.Name and ESPEnabled
                    objects.Name.Text = player.Name
                    objects.Name.Position = Vector2.new(pos.X, pos.Y - 35)
                    
                    -- Distance
                    objects.Distance.Visible = ESPSettings.Distance and ESPEnabled
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        objects.Distance.Text = dist .. "m"
                        objects.Distance.Position = Vector2.new(pos.X, pos.Y + 25)
                    end
                else
                    objects.Box.Visible = false
                    objects.Tracer.Visible = false
                    objects.Name.Visible = false
                    objects.Distance.Visible = false
                end
            else
                objects.Box.Visible = false
                objects.Tracer.Visible = false
                objects.Name.Visible = false
                objects.Distance.Visible = false
            end
        else
            if objects then
                objects.Box.Visible = false
                objects.Tracer.Visible = false
                objects.Name.Visible = false
                objects.Distance.Visible = false
            end
        end
    end
end

-- ================================================
-- TROLL FUNCTIONS
-- ================================================

-- Big Head
local function SetBigHead(enabled)
    if not LocalPlayer.Character then return end
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if head then
        if enabled then
            head.Size = Vector3.new(4, 4, 4)
            head.Transparency = 0.3
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(2, 2, 2)
            end
        else
            head.Size = Vector3.new(2, 1, 1)
            head.Transparency = 0
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(1, 1, 1)
            end
        end
    end
end

-- Small Head
local function SetSmallHead(enabled)
    if not LocalPlayer.Character then return end
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if head then
        if enabled then
            head.Size = Vector3.new(0.5, 0.5, 0.5)
        else
            head.Size = Vector3.new(2, 1, 1)
        end
    end
end

-- Rainbow Mode
local function Rainbow(enabled)
    if enabled then
        spawn(function()
            while RainbowEnabled do
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.BrickColor = BrickColor.random()
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
end

-- Walk Speed
local function SetWalkSpeed(enabled)
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        if enabled then
            humanoid.WalkSpeed = 100
        else
            humanoid.WalkSpeed = 16
        end
    end
end

-- Jump Power
local function SetJumpPower(enabled)
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        if enabled then
            humanoid.JumpPower = 100
        else
            humanoid.JumpPower = 50
        end
    end
end

-- Spin
local function Spin()
    if SpinEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
    end
end

-- Fly
local function Fly(enabled)
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    if enabled then
        humanoid.PlatformStand = true
        local bg = Instance.new("BodyGyro")
        local bv = Instance.new("BodyVelocity")
        
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
        
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bv.Parent = hrp
        
        spawn(function()
            while FlyEnabled do
                wait()
                if not LocalPlayer.Character then break end
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                bv.Velocity = moveDir * 50
                bg.CFrame = Camera.CFrame
            end
        end)
    else
        humanoid.PlatformStand = false
        local bg = hrp:FindFirstChild("BodyGyro")
        local bv = hrp:FindFirstChild("BodyVelocity")
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end

-- Infinite Jump
local function SetupInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if InfiniteJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState("Jumping")
            end
        end
    end)
end

-- ================================================
-- AUTO FOLLOW - YANG KAMU MINTA!
-- ================================================

local function UpdateFollow()
    -- Cek apakah fitur nyala, target ada, dan karakter valid
    if not AutoFollowEnabled or not FollowTarget or not FollowTarget.Character or not LocalPlayer.Character then 
        return 
    end
    
    -- Ambil komponen penting
    local targetHrp = FollowTarget.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = FollowTarget.Character:FindFirstChild("Humanoid")
    
    if targetHrp and myHrp and targetHumanoid then
        -- Hitung posisi target (di belakang kamu)
        local targetPos = myHrp.Position - (myHrp.CFrame.LookVector * FollowDistance)
        
        -- SURUH DIA JALAN KE POSISI TERSEBUT!
        pcall(function()
            targetHumanoid:MoveTo(targetPos)
        end)
        
        -- Bikin dia ngadep ke kamu (biar keliatan natural)
        local lookAt = CFrame.lookAt(targetHrp.Position, myHrp.Position)
        targetHrp.CFrame = CFrame.new(targetHrp.Position) * CFrame.Angles(0, lookAt:ToOrientation(), 0)
    end
end

-- ================================================
-- MAIN GUI
-- ================================================

local ScreenGui = Create("ScreenGui", {
    Name = "TINZZ_Troll",
    Parent = game.CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

-- ================================================
-- KEY SYSTEM
-- ================================================

local KeyFrame = Create("Frame", {
    Size = UDim2.new(0, 350, 0, 220),
    Position = UDim2.new(0.5, -175, 0.5, -110),
    BackgroundColor3 = C.MainBG,
    BackgroundTransparency = 0.05,
    ZIndex = 100,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(0, 20), Parent = KeyFrame})

local KeyBorder = Create("UIStroke", {
    Thickness = 3,
    Color = C.Accent,
    Transparency = 0.3,
    Parent = KeyFrame
})

local KeyTitle = Create("TextLabel", {
    Text = "🔐 TINZZxXITERS TROLL",
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    ZIndex = 101,
    Parent = KeyFrame
})

local KeySubTitle = Create("TextLabel", {
    Text = "MASUKKAN KEY UNTUK AKSES",
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ZIndex = 101,
    Parent = KeyFrame
})

local KeyInput = Create("TextBox", {
    PlaceholderText = "Key...",
    Text = "",
    Size = UDim2.new(0.8, 0, 0, 40),
    Position = UDim2.new(0.1, 0, 0.4, 0),
    BackgroundColor3 = C.SidebarBG,
    TextColor3 = C.Text,
    PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
    Font = Enum.Font.Gotham,
    TextSize = 16,
    ZIndex = 101,
    Parent = KeyFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = KeyInput})
Create("UIStroke", {Thickness = 1.5, Color = C.Accent, Transparency = 0.5, Parent = KeyInput})

local KeyBtn = Create("TextButton", {
    Text = "MASUK",
    Size = UDim2.new(0.6, 0, 0, 40),
    Position = UDim2.new(0.2, 0, 0.65, 0),
    BackgroundColor3 = C.Accent,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 101,
    Parent = KeyFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = KeyBtn})

-- ================================================
-- MAIN MENU
-- ================================================

local MainFrame = Create("Frame", {
    Size = UDim2.new(0, 400, 0, 500),
    Position = UDim2.new(0.5, -200, 0.5, -250),
    BackgroundColor3 = C.MainBG,
    BackgroundTransparency = 0.02,
    Visible = false,
    ZIndex = 10,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(0, 20), Parent = MainFrame})
MakeDraggable(MainFrame)

local MainBorder = Create("UIStroke", {
    Thickness = 3,
    Color = C.Accent,
    Transparency = 0.3,
    Parent = MainFrame
})

-- Title Bar
local TitleBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = C.SidebarBG,
    ZIndex = 11,
    Parent = MainFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 20), Parent = TitleBar})

local TitleText = Create("TextLabel", {
    Text = "🎭 TINZZ TROLL PANEL",
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
    Parent = TitleBar
})

local CloseBtn = Create("TextButton", {
    Text = "✕",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    BackgroundColor3 = C.Accent,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    ZIndex = 12,
    Parent = TitleBar
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = CloseBtn})

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab Buttons
local TabContainer = Create("Frame", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 60),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Parent = MainFrame
})

local ESPTabBtn = Create("TextButton", {
    Text = "👁️ ESP",
    Size = UDim2.new(0.5, -5, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.ESP,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 12,
    Parent = TabContainer
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ESPTabBtn})

local TrollTabBtn = Create("TextButton", {
    Text = "🎭 TROLL",
    Size = UDim2.new(0.5, -5, 1, 0),
    Position = UDim2.new(0.5, 5, 0, 0),
    BackgroundColor3 = C.Troll,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 12,
    Parent = TabContainer
})
Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TrollTabBtn})

-- Content Container
local ContentFrame = Create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -120),
    Position = UDim2.new(0, 10, 0, 110),
    BackgroundTransparency = 1,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = C.Accent,
    CanvasSize = UDim2.new(0, 0, 2, 0),
    ZIndex = 13,
    Parent = MainFrame
})

local ESPPage = Instance.new("Frame")
ESPPage.Size = UDim2.new(1, 0, 1, 0)
ESPPage.BackgroundTransparency = 1
ESPPage.Parent = ContentFrame
ESPPage.Visible = true

local TrollPage = Instance.new("Frame")
TrollPage.Size = UDim2.new(1, 0, 1, 0)
TrollPage.BackgroundTransparency = 1
TrollPage.Parent = ContentFrame
TrollPage.Visible = false

-- UIListLayout for pages
local ESPLayout = Instance.new("UIListLayout")
ESPLayout.Parent = ESPPage
ESPLayout.Padding = UDim.new(0, 8)
ESPLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TrollLayout = Instance.new("UIListLayout")
TrollLayout.Parent = TrollPage
TrollLayout.Padding = UDim.new(0, 8)
TrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Tab switching
ESPTabBtn.MouseButton1Click:Connect(function()
    ESPPage.Visible = true
    TrollPage.Visible = false
    ESPTabBtn.BackgroundColor3 = C.ESP
    TrollTabBtn.BackgroundColor3 = C.Troll + Color3.new(0.2, 0.2, 0.2)
end)

TrollTabBtn.MouseButton1Click:Connect(function()
    ESPPage.Visible = false
    TrollPage.Visible = true
    TrollTabBtn.BackgroundColor3 = C.Troll
    ESPTabBtn.BackgroundColor3 = C.ESP + Color3.new(0.2, 0.2, 0.2)
end)

-- Floating Button
local FloatingBtn = Create("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 10, 0.5, -25),
    BackgroundColor3 = C.Accent,
    Text = "🎭",
    TextColor3 = C.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Visible = false,
    ZIndex = 20,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = FloatingBtn})
MakeDraggable(FloatingBtn)

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

-- ================================================
-- CREATE TOGGLE FUNCTION
-- ================================================

local function CreateToggle(parent, title, color, default, callback)
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        ZIndex = 14,
        Parent = parent
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = frame})
    
    local titleLabel = Create("TextLabel", {
        Text = title,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = C.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = frame
    })
    
    local toggle = Create("TextButton", {
        Text = "",
        Size = UDim2.new(0, 45, 0, 22),
        Position = UDim2.new(1, -55, 0.5, -11),
        BackgroundColor3 = default and color or C.ToggleOff,
        ZIndex = 15,
        Parent = frame
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggle})
    
    local circle = Create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = default and UDim2.new(1, -23, 0.5, -9) or UDim2.new(0, 5, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 16,
        Parent = toggle
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
    
    local state = default
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = state and color or C.ToggleOff}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -23, 0.5, -9) or UDim2.new(0, 5, 0.5, -9)
        }):Play()
        callback(state)
    end)
    
    return frame
end

-- ================================================
-- CREATE BUTTON FUNCTION
-- ================================================

local function CreateActionButton(parent, title, color, callback)
    local btn = Create("TextButton", {
        Text = title,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = color,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 14,
        Parent = parent
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = btn})
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- ================================================
-- CREATE DROPDOWN FOR PLAYER LIST
-- ================================================

local function CreatePlayerDropdown(parent)
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        ZIndex = 14,
        Parent = parent
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = frame})
    
    local titleLabel = Create("TextLabel", {
        Text = "👤 Follow Target",
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = frame
    })
    
    local selectedLabel = Create("TextLabel", {
        Text = "Pilih Player...",
        Size = UDim2.new(0.8, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundColor3 = C.SidebarBG,
        TextColor3 = C.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ZIndex = 15,
        Parent = frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = selectedLabel})
    
    local dropdownBtn = Create("TextButton", {
        Text = "▼",
        Size = UDim2.new(0, 30, 0, 25),
        Position = UDim2.new(1, -40, 0, 30),
        BackgroundColor3 = C.Accent,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 15,
        Parent = frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = dropdownBtn})
    
    local expanded = false
    local optionsFrame = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundColor3 = C.SidebarBG,
        BackgroundTransparency = 0.1,
        Visible = false,
        ZIndex = 20,
        Parent = frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optionsFrame})
    
    local function updatePlayerList()
        for _, child in pairs(optionsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local yPos = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local btn = Create("TextButton", {
                    Text = player.Name,
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, yPos),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    ZIndex = 21,
                    Parent = optionsFrame
                })
                
                btn.MouseButton1Click:Connect(function()
                    FollowTarget = player
                    selectedLabel.Text = "📌 " .. player.Name
                    optionsFrame.Visible = false
                    expanded = false
                    dropdownBtn.Text = "▼"
                end)
                
                yPos = yPos + 25
            end
        end
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end
    
    updatePlayerList()
    
    dropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        optionsFrame.Visible = expanded
        dropdownBtn.Text = expanded and "▲" or "▼"
        if expanded then
            updatePlayerList()
        end
    end)
    
    return frame
end

-- ================================================
-- BUILD ESP PAGE
-- ================================================

CreateToggle(ESPPage, "Enable ESP", C.ESP, false, function(v)
    ESPEnabled = v
end)

CreateToggle(ESPPage, "Box ESP", C.ESP, false, function(v)
    ESPSettings.Box = v
end)

CreateToggle(ESPPage, "Name ESP", C.ESP, false, function(v)
    ESPSettings.Name = v
end)

CreateToggle(ESPPage, "Distance ESP", C.ESP, false, function(v)
    ESPSettings.Distance = v
end)

CreateToggle(ESPPage, "Tracer Line", C.ESP, false, function(v)
    ESPSettings.Tracer = v
end)

-- ================================================
-- BUILD TROLL PAGE
-- ================================================

CreateToggle(TrollPage, "Big Head", C.Troll, false, function(v)
    BigHeadEnabled = v
    if v then SmallHeadEnabled = false end
    SetBigHead(v)
end)

CreateToggle(TrollPage, "Small Head", C.Troll, false, function(v)
    SmallHeadEnabled = v
    if v then BigHeadEnabled = false end
    SetSmallHead(v)
end)

CreateToggle(TrollPage, "Rainbow Mode", C.Troll, false, function(v)
    RainbowEnabled = v
    Rainbow(v)
end)

CreateToggle(TrollPage, "Super Speed", C.Troll, false, function(v)
    WalkSpeedEnabled = v
    SetWalkSpeed(v)
end)

CreateToggle(TrollPage, "Super Jump", C.Troll, false, function(v)
    JumpPowerEnabled = v
    SetJumpPower(v)
end)

CreateToggle(TrollPage, "Spin Bot", C.Troll, false, function(v)
    SpinEnabled = v
end)

CreateToggle(TrollPage, "Fly Mode", C.Troll, false, function(v)
    FlyEnabled = v
    Fly(v)
end)

CreateToggle(TrollPage, "Infinite Jump", C.Troll, false, function(v)
    InfiniteJump = v
end)

-- Auto Follow Section
CreatePlayerDropdown(TrollPage)

CreateToggle(TrollPage, "Auto Follow", C.Troll, false, function(v)
    AutoFollowEnabled = v
end)

-- Action Buttons
CreateActionButton(TrollPage, "💥 Reset Character", C.Accent, function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

CreateActionButton(TrollPage, "🔊 Play Random Sound", Color3.fromRGB(150, 0, 255), function()
    local sounds = {
        "rbxasset://sounds/uuhhh.mp3",
        "rbxasset://sounds/ouch.ogg",
        "rbxasset://sounds/punch.wav"
    }
    local sound = Instance.new("Sound")
    sound.SoundId = sounds[math.random(#sounds)]
    sound.Volume = 5
    sound.Parent = workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end)

-- ================================================
-- INITIALIZATION
-- ================================================

-- Setup Infinite Jump
SetupInfiniteJump()

-- Create ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Create ESP for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

-- Main update loop
RunService.RenderStepped:Connect(function()
    UpdateESP()
    if SpinEnabled then
        Spin()
    end
    UpdateFollow()  -- Auto Follow dipanggil tiap frame!
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    if BigHeadEnabled then SetBigHead(true) end
    if SmallHeadEnabled then SetSmallHead(true) end
    if WalkSpeedEnabled then SetWalkSpeed(true) end
    if JumpPowerEnabled then SetJumpPower(true) end
    if FlyEnabled then Fly(true) end
end)

print("✅ TINZZxXITERS Troll Panel Loaded!")
print("🔑 Key: " .. CORRECT_KEY)