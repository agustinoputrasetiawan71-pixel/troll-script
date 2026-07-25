--[[
    TINZZxXITERS AIM & ESP V4
    Fix: Scroll, Layout, Tampilan Rapi
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== THEME COLORS =====
local THEME = {
    Pink = Color3.fromRGB(255, 20, 147),
    DarkPink = Color3.fromRGB(200, 10, 110),
    Black = Color3.fromRGB(15, 15, 17),
    DarkBlack = Color3.fromRGB(25, 25, 27),
    Blue = Color3.fromRGB(0, 150, 255),
    White = Color3.fromRGB(255, 255, 255),
    OffText = Color3.fromRGB(160, 160, 160),
    Glass = Color3.fromRGB(255, 255, 255),
}

-- ===== SETTINGS =====
local Settings = {
    -- AIM Settings
    Sticky = false,
    WallCheck = true,
    TeamCheck = false,
    NPCs = false,
    FOV = 150,
    CircleVis = false,
    
    -- ESP Settings
    ESP = false,
    ESPName = true,
    ESPBox = false,
    ESPLine = false,
    ESPLinePosition = "Top",
    ESPLineThickness = 1,
    RainbowStyle = false,
}

-- ===== DRAWINGS =====
local Circle = Drawing.new("Circle")
Circle.Visible = false
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Radius = Settings.FOV
Circle.Filled = false

-- ===== UI SETUP =====
local TixUI = Instance.new("ScreenGui")
TixUI.Name = "TINZZ_AIM_ESP"
TixUI.Parent = gethui and gethui() or game:GetService("CoreGui")
TixUI.ResetOnSpawn = false

-- ===== TOGGLE ICON =====
local TogglePanel = Instance.new("Frame", TixUI)
TogglePanel.Size = UDim2.new(0, 50, 0, 50)
TogglePanel.Position = UDim2.new(0, 15, 0, 15)
TogglePanel.BackgroundColor3 = THEME.Black
TogglePanel.Active = true
TogglePanel.Draggable = true
Instance.new("UICorner", TogglePanel).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", TogglePanel)
ToggleStroke.Thickness = 2
ToggleStroke.Color = THEME.Pink

local ToggleBtn = Instance.new("TextButton", TogglePanel)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "TZ"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = THEME.Pink
ToggleBtn.TextSize = 20

-- ===== MAIN FRAME =====
local Main = Instance.new("Frame", TixUI)
local VisiblePos = UDim2.new(0.5, -200, 0.5, -200)
local HiddenPos = UDim2.new(0.5, -200, 1.2, 0)
Main.Size = UDim2.new(0, 400, 0, 400)
Main.Position = HiddenPos
Main.BackgroundColor3 = THEME.Black
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = THEME.Pink

-- ===== TITLE =====
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "✦ TINZZxXITERS ✦"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextColor3 = THEME.Pink

local SubTitle = Instance.new("TextLabel", Main)
SubTitle.Size = UDim2.new(1, 0, 0, 18)
SubTitle.Position = UDim2.new(0, 0, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "AIM • ESP • VISUAL"
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextColor3 = THEME.Blue
SubTitle.TextXAlignment = Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = THEME.Pink
CloseBtn.TextSize = 20

-- ===== TAB SYSTEM =====
local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(1, -20, 0, 32)
TabFrame.Position = UDim2.new(0, 10, 0, 50)
TabFrame.BackgroundTransparency = 1

local Tabs = {}
local CurrentTab = "AIM"

local function CreateTab(name, xPos)
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.BackgroundColor3 = THEME.DarkBlack
    btn.BorderSizePixel = 1
    btn.BorderColor3 = THEME.Pink
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = THEME.White
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local TabAIM = CreateTab("✦ AIM", 0)
local TabESP = CreateTab("✦ ESP", 0.26)

-- ===== SCROLL AREA =====
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 88)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = THEME.Pink
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

-- ===== CONTENT CONTAINERS =====
local AIMContent = Instance.new("Frame", Scroll)
AIMContent.Size = UDim2.new(1, 0, 0, 0)
AIMContent.BackgroundTransparency = 1
AIMContent.Visible = true

local ESPContent = Instance.new("Frame", Scroll)
ESPContent.Size = UDim2.new(1, 0, 0, 0)
ESPContent.BackgroundTransparency = 1
ESPContent.Visible = false

-- ===== FUNGSI TOGGLE =====
local function AddToggle(parent, text, settingKey, default)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.DarkBlack
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local BStroke = Instance.new("UIStroke", btn)
    BStroke.Thickness = 1
    BStroke.Color = THEME.Pink
    BStroke.Transparency = 0.5

    local Label = Instance.new("TextLabel", btn)
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = THEME.White
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Status = Instance.new("TextLabel", btn)
    Status.Size = UDim2.new(0, 45, 1, 0)
    Status.Position = UDim2.new(1, -55, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Text = default and "ON" or "OFF"
    Status.Font = Enum.Font.GothamBold
    Status.TextColor3 = default and THEME.Pink or THEME.OffText
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Right

    Settings[settingKey] = default

    btn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        local s = Settings[settingKey]
        Status.Text = s and "ON" or "OFF"
        Status.TextColor3 = s and THEME.Pink or THEME.OffText
        if settingKey == "CircleVis" then Circle.Visible = s end
        if settingKey == "ESP" or settingKey == "ESPLine" or settingKey == "ESPBox" or settingKey == "ESPName" then
            if Settings.ESP then updateESP() else clearESP() end
        end
    end)
    
    return btn
end

-- ===== FUNGSI SLIDER =====
local function AddSlider(parent, text, settingKey, min, max, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = THEME.White
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(1, 0, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 26)
    slider.BackgroundColor3 = THEME.DarkBlack
    slider.BorderSizePixel = 1
    slider.BorderColor3 = THEME.Blue
    
    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = THEME.Pink
    fill.BorderSizePixel = 0
    
    local drag = Instance.new("TextButton", slider)
    drag.Size = UDim2.new(0, 14, 0, 14)
    drag.Position = UDim2.new((default - min) / (max - min), -7, 0, -4)
    drag.BackgroundColor3 = THEME.White
    drag.BorderSizePixel = 2
    drag.BorderColor3 = THEME.Pink
    drag.Text = ""
    
    local value = default
    local dragging = false
    
    drag.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    local mouse = LocalPlayer:GetMouse()
    mouse.Move:Connect(function()
        if not dragging then return end
        local pos = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * pos
        value = math.round(value)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        drag.Position = UDim2.new(pos, -7, 0, -4)
        label.Text = text .. ": " .. tostring(value)
        Settings[settingKey] = value
        if settingKey == "FOV" then Circle.Radius = value end
        if settingKey == "ESPLineThickness" and Settings.ESP then updateESP() end
    end)
    
    return frame
end

-- ===== FUNGSI DROPDOWN =====
local function AddDropdown(parent, text, settingKey, options, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = THEME.DarkBlack
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.White
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(0.4, 0, 1, -6)
    dropdown.Position = UDim2.new(0.55, 0, 0, 3)
    dropdown.BackgroundColor3 = THEME.Black
    dropdown.BorderSizePixel = 1
    dropdown.BorderColor3 = THEME.Pink
    dropdown.Text = default
    dropdown.TextColor3 = THEME.White
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.Gotham
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 4)
    
    Settings[settingKey] = default
    local currentIndex = 1
    
    dropdown.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        local value = options[currentIndex]
        dropdown.Text = value
        Settings[settingKey] = value
        if settingKey == "ESPLinePosition" and Settings.ESP then updateESP() end
    end)
    
    return frame
end

-- ===== BUILD AIM TAB =====
local aimY = 0
local function addAIM(item)
    item.Position = UDim2.new(0, 0, 0, aimY)
    aimY = aimY + 40
    AIMContent.Size = UDim2.new(1, 0, 0, aimY + 10)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, aimY + 30)
end

addAIM(AddToggle(AIMContent, "✦ Sticky Aim", "Sticky", false))
addAIM(AddToggle(AIMContent, "✦ Wall Check", "WallCheck", true))
addAIM(AddToggle(AIMContent, "✦ Team Check", "TeamCheck", false))
addAIM(AddToggle(AIMContent, "✦ Include NPCs", "NPCs", false))
addAIM(AddToggle(AIMContent, "✦ Show FOV Circle", "CircleVis", false))
addAIM(AddSlider(AIMContent, "✦ FOV Radius", "FOV", 50, 300, 150))

-- ===== BUILD ESP TAB =====
local espY = 0
local function addESP(item)
    item.Position = UDim2.new(0, 0, 0, espY)
    espY = espY + 40
    ESPContent.Size = UDim2.new(1, 0, 0, espY + 10)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, espY + 30)
end

addESP(AddToggle(ESPContent, "✦ Enable ESP", "ESP", false))
addESP(AddToggle(ESPContent, "✦ Show Name", "ESPName", true))
addESP(AddToggle(ESPContent, "✦ Show Box", "ESPBox", false))
addESP(AddToggle(ESPContent, "✦ Show Line", "ESPLine", false))
addESP(AddToggle(ESPContent, "✦ Rainbow Mode", "RainbowStyle", false))
addESP(AddSlider(ESPContent, "✦ Line Thickness", "ESPLineThickness", 1, 5, 1))
addESP(AddDropdown(ESPContent, "✦ Line Position", "ESPLinePosition", {"Top", "Center", "Bottom"}, "Top"))

-- ===== TAB SWITCHING =====
TabAIM.MouseButton1Click:Connect(function()
    CurrentTab = "AIM"
    AIMContent.Visible = true
    ESPContent.Visible = false
    TabAIM.BackgroundColor3 = THEME.Pink
    TabESP.BackgroundColor3 = THEME.DarkBlack
    TabAIM.TextColor3 = THEME.Black
    TabESP.TextColor3 = THEME.White
    Scroll.CanvasPosition = 0
end)

TabESP.MouseButton1Click:Connect(function()
    CurrentTab = "ESP"
    AIMContent.Visible = false
    ESPContent.Visible = true
    TabESP.BackgroundColor3 = THEME.Pink
    TabAIM.BackgroundColor3 = THEME.DarkBlack
    TabESP.TextColor3 = THEME.Black
    TabAIM.TextColor3 = THEME.White
    Scroll.CanvasPosition = 0
end)

-- Set default tab
TabAIM.BackgroundColor3 = THEME.Pink
TabAIM.TextColor3 = THEME.Black

-- ===== OPEN/CLOSE =====
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    TogglePanel.Visible = false
    Main:TweenPosition(VisiblePos, "Out", "Quart", 0.5, true)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main:TweenPosition(HiddenPos, "In", "Quart", 0.4, true, function()
        Main.Visible = false
        TogglePanel.Visible = true
    end)
end)

-- ===== WALL CHECK =====
local function isVisible(targetPart)
    if not Settings.WallCheck then return true end
    local ignoreList = {LocalPlayer.Character, Camera}
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    if hit and hit:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

-- ===== GET CLOSEST TARGET =====
local function getClosest()
    local target, shortestFOV = nil, Settings.FOV
    local potentials = {}
    
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            table.insert(potentials, v.Character.Head)
        end
    end
    
    if Settings.NPCs then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") and v.Humanoid.Health > 0 then
                if not Players:GetPlayerFromCharacter(v) then table.insert(potentials, v.Head) end
            end
        end
    end

    for _, head in pairs(potentials) do
        local pos, vis = Camera:WorldToViewportPoint(head.Position)
        if vis and isVisible(head) then
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if mag < shortestFOV then 
                target = head 
                shortestFOV = mag 
            end
        end
    end
    return target
end

-- ===== ESP VARIABLES =====
local espObjects = {}
local nameTags = {}

-- ===== CLEAR ESP =====
local function clearESP()
    for _, v in pairs(espObjects) do
        pcall(function() v:Destroy() end)
    end
    espObjects = {}
    for _, v in pairs(nameTags) do
        pcall(function() v:Destroy() end)
    end
    nameTags = {}
end

-- ===== UPDATE ESP =====
local function updateESP()
    clearESP()
    if not Settings.ESP then return end
    
    local accent = Settings.RainbowStyle and Color3.fromHSV(tick() % 5 / 5, 0.7, 1) or THEME.Pink
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = target.Character.HumanoidRootPart
            local humanoid = target.Character:FindFirstChild("Humanoid")
            
            if not humanoid or humanoid.Health <= 0 then continue end
            
            -- LINE
            if Settings.ESPLine then
                local line = Instance.new("SelectionBox")
                line.Color3 = accent
                line.Transparency = 0.3
                line.LineThickness = Settings.ESPLineThickness
                line.Adornee = rootPart
                line.Parent = rootPart
                table.insert(espObjects, line)
            end
            
            -- BOX
            if Settings.ESPBox then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(3, 5, 1.5)
                box.Color3 = accent
                box.Transparency = 0.3
                box.ZIndex = 0
                box.AlwaysOnTop = true
                box.Adornee = rootPart
                box.Parent = rootPart
                table.insert(espObjects, box)
            end
            
            -- NAME
            if Settings.ESPName then
                local nameTag = Instance.new("BillboardGui")
                nameTag.Size = UDim2.new(0, 200, 0, 30)
                nameTag.AlwaysOnTop = true
                
                local pos = Settings.ESPLinePosition
                if pos == "Top" then
                    nameTag.StudsOffset = Vector3.new(0, 4, 0)
                elseif pos == "Center" then
                    nameTag.StudsOffset = Vector3.new(0, 0, 0)
                elseif pos == "Bottom" then
                    nameTag.StudsOffset = Vector3.new(0, -3, 0)
                end
                
                nameTag.Parent = rootPart
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = target.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                label.TextColor3 = accent
                label.TextSize = 14
                label.TextStrokeTransparency = 0.2
                label.TextStrokeColor3 = THEME.Black
                label.Font = Enum.Font.GothamBold
                label.Parent = nameTag
                table.insert(nameTags, nameTag)
            end
        end
    end
end

-- ===== AUTO UPDATE ESP =====
RunService.RenderStepped:Connect(function()
    if Settings.ESP then
        updateESP()
    end
end)

-- ===== MAIN LOOP =====
RunService.RenderStepped:Connect(function()
    local accent = Settings.RainbowStyle and Color3.fromHSV(tick() % 5 / 5, 0.7, 1) or THEME.Pink
    
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Color = accent
    Circle.Visible = Settings.CircleVis
    Circle.Radius = Settings.FOV
    
    MainStroke.Color = accent
    ToggleStroke.Color = accent
    Title.TextColor3 = accent
    
    if Settings.Sticky then
        local lock = getClosest()
        if lock then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, lock.Position) 
        end
    end
end)

-- ===== WATERMARK =====
local watermark = Instance.new("TextLabel", TixUI)
watermark.Size = UDim2.new(0, 200, 0, 20)
watermark.Position = UDim2.new(1, -210, 1, -30)
watermark.BackgroundTransparency = 1
watermark.Text = "✦ TINZZxXITERS ✦ V4"
watermark.TextColor3 = THEME.Pink
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.TextXAlignment = Enum.TextXAlignment.Right

-- ===== NOTIFICATION =====
local function notify(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "TINZZxXITERS",
        Text = msg,
        Duration = 2
    })
end

notify("✦ System Loaded ✦")
print("✦ TINZZxXITERS V4 Loaded ✦")
