--[[
    TINZZxXITERS AIM & ESP V6
    Menggunakan logika ESP dari script referensi
    Fitur: Highlight ESP, Tracers, Name Tags
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
}

-- ===== SETTINGS =====
local Settings = {
    -- AIM
    Sticky = false,
    WallCheck = true,
    TeamCheck = false,
    NPCs = false,
    FOV = 150,
    CircleVis = false,
    
    -- ESP (pakai logika dari script referensi)
    ESP = false,
    Tracers = false,
    RainbowStyle = false,
    
    -- Tambahan custom
    ESPName = true,
    ESPBox = false,
    ESPLinePosition = "Top",
}

-- ===== DRAWINGS =====
local Circle = Drawing.new("Circle")
Circle.Visible = false
Circle.Thickness = 2
Circle.NumSides = 64
Circle.Radius = Settings.FOV
Circle.Filled = false

-- ===== VISUAL CACHE (dari script referensi) =====
local visualCache = {}

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
local VisiblePos = UDim2.new(0.5, -200, 0.5, -180)
local HiddenPos = UDim2.new(0.5, -200, 1.2, 0)
Main.Size = UDim2.new(0, 400, 0, 380)
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
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "✦ TINZZxXITERS ✦"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextColor3 = THEME.Pink

local SubTitle = Instance.new("TextLabel", Main)
SubTitle.Size = UDim2.new(1, 0, 0, 16)
SubTitle.Position = UDim2.new(0, 0, 0, 26)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "AIM • ESP • VISUAL"
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextColor3 = THEME.Blue
SubTitle.TextXAlignment = Enum.TextXAlignment.Center

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 4)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = THEME.Pink
CloseBtn.TextSize = 20

-- ===== TAB SYSTEM =====
local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(1, -20, 0, 30)
TabFrame.Position = UDim2.new(0, 10, 0, 46)
TabFrame.BackgroundTransparency = 1

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
Scroll.Position = UDim2.new(0, 10, 0, 82)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = THEME.Pink

-- ===== CONTENT CONTAINERS =====
local AIMContent = Instance.new("Frame", Scroll)
AIMContent.Size = UDim2.new(1, 0, 0, 0)
AIMContent.BackgroundTransparency = 1
AIMContent.Visible = true

local ESPContent = Instance.new("Frame", Scroll)
ESPContent.Size = UDim2.new(1, 0, 0, 0)
ESPContent.BackgroundTransparency = 1
ESPContent.Visible = false

-- ===== UIListLayout =====
local aimLayout = Instance.new("UIListLayout", AIMContent)
aimLayout.Padding = UDim.new(0, 4)
aimLayout.SortOrder = Enum.SortOrder.LayoutOrder

local espLayout = Instance.new("UIListLayout", ESPContent)
espLayout.Padding = UDim.new(0, 4)
espLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== UPDATE SIZE =====
local function updateSize()
    local aimHeight = aimLayout.AbsoluteContentSize.Y
    local espHeight = espLayout.AbsoluteContentSize.Y
    AIMContent.Size = UDim2.new(1, 0, 0, aimHeight + 5)
    ESPContent.Size = UDim2.new(1, 0, 0, espHeight + 5)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(aimHeight, espHeight) + 30)
end

-- ===== FUNGSI TOGGLE =====
local function AddToggle(parent, text, settingKey, default, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.DarkBlack
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
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
    end)
    
    return btn
end

-- ===== FUNGSI SLIDER =====
local function AddSlider(parent, text, settingKey, min, max, default, order)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    
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
    end)
    
    return frame
end

-- ===== FUNGSI DROPDOWN =====
local function AddDropdown(parent, text, settingKey, options, default, order)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = THEME.DarkBlack
    frame.LayoutOrder = order
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
    end)
    
    return frame
end

-- ===== BUILD AIM TAB =====
AddToggle(AIMContent, "✦ Sticky Aim", "Sticky", false, 1)
AddToggle(AIMContent, "✦ Wall Check", "WallCheck", true, 2)
AddToggle(AIMContent, "✦ Team Check", "TeamCheck", false, 3)
AddToggle(AIMContent, "✦ Include NPCs", "NPCs", false, 4)
AddToggle(AIMContent, "✦ Show FOV Circle", "CircleVis", false, 5)
AddSlider(AIMContent, "✦ FOV Radius", "FOV", 50, 300, 150, 6)

-- ===== BUILD ESP TAB =====
AddToggle(ESPContent, "✦ Enable ESP", "ESP", false, 1)
AddToggle(ESPContent, "✦ Tracers (Line)", "Tracers", false, 2)
AddToggle(ESPContent, "✦ Rainbow Mode", "RainbowStyle", false, 3)
AddToggle(ESPContent, "✦ Show Name", "ESPName", true, 4)
AddToggle(ESPContent, "✦ Show Box", "ESPBox", false, 5)
AddDropdown(ESPContent, "✦ Name Position", "ESPLinePosition", {"Top", "Center", "Bottom"}, "Top", 6)

-- ===== UPDATE SIZE =====
task.wait(0.1)
updateSize()
aimLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)
espLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

-- ===== TAB SWITCHING =====
TabAIM.MouseButton1Click:Connect(function()
    AIMContent.Visible = true
    ESPContent.Visible = false
    TabAIM.BackgroundColor3 = THEME.Pink
    TabESP.BackgroundColor3 = THEME.DarkBlack
    TabAIM.TextColor3 = THEME.Black
    TabESP.TextColor3 = THEME.White
    Scroll.CanvasPosition = 0
    updateSize()
end)

TabESP.MouseButton1Click:Connect(function()
    AIMContent.Visible = false
    ESPContent.Visible = true
    TabESP.BackgroundColor3 = THEME.Pink
    TabAIM.BackgroundColor3 = THEME.DarkBlack
    TabESP.TextColor3 = THEME.Black
    TabAIM.TextColor3 = THEME.White
    Scroll.CanvasPosition = 0
    updateSize()
end)

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

-- ===== GET RAINBOW =====
local function getRainbow()
    return Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
end

-- ===== MAIN LOOP (dari script referensi) =====
RunService.RenderStepped:Connect(function()
    local accent = Settings.RainbowStyle and getRainbow() or THEME.Pink
    
    -- Update Circle
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Color = accent
    Circle.Visible = Settings.CircleVis
    Circle.Radius = Settings.FOV
    
    -- Update UI Colors
    MainStroke.Color = accent
    ToggleStroke.Color = accent
    Title.TextColor3 = accent

    -- AIM STICKY
    if Settings.Sticky then
        local lock = getClosest()
        if lock then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, lock.Position) 
        end
    end

    -- ===== VISUAL PROCESSING (dari script referensi) =====
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer and p.Character then 
            table.insert(targets, p.Character) 
        end 
    end
    
    for _, char in pairs(targets) do
        -- Buat cache jika belum ada
        if not visualCache[char] then
            visualCache[char] = {
                Line = Drawing.new("Line"),
                Highlight = Instance.new("Highlight", TixUI)
            }
        end
        
        local visual = visualCache[char]
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChild("Humanoid")
        local isAlive = head and hum and hum.Health > 0
        
        -- ===== TRACERS (Line dari player ke target) =====
        if Settings.Tracers and isAlive then
            local pos, vis = Camera:WorldToViewportPoint(head.Position)
            if vis then
                visual.Line.Visible = true
                visual.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                visual.Line.To = Vector2.new(pos.X, pos.Y)
                visual.Line.Color = accent
                visual.Line.Thickness = 1.5
            else
                visual.Line.Visible = false
            end
        else
            visual.Line.Visible = false
        end

        -- ===== HIGHLIGHT ESP (dari script referensi) =====
        visual.Highlight.Enabled = Settings.ESP and isAlive
        visual.Highlight.Adornee = char
        visual.Highlight.FillColor = accent
        visual.Highlight.OutlineColor = Color3.new(1, 1, 1)
        visual.Highlight.FillTransparency = 0.3
        visual.Highlight.OutlineTransparency = 0.2
        
        -- ===== NAME TAG (Custom tambahan) =====
        if Settings.ESPName and isAlive then
            -- Cari atau buat name tag
            local nameTag = char:FindFirstChild("TINZZ_NameTag")
            if not nameTag then
                nameTag = Instance.new("BillboardGui")
                nameTag.Name = "TINZZ_NameTag"
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
                
                nameTag.Parent = char
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = accent
                label.TextSize = 14
                label.TextStrokeTransparency = 0.2
                label.TextStrokeColor3 = THEME.Black
                label.Font = Enum.Font.GothamBold
                label.Parent = nameTag
            end
            
            -- Update label
            local label = nameTag:FindFirstChild("Label")
            if label then
                label.Text = char.Name .. " [" .. math.floor(hum.Health) .. "HP]"
                label.TextColor3 = accent
            end
            nameTag.Enabled = true
        else
            -- Hapus name tag jika dimatikan
            local nameTag = char:FindFirstChild("TINZZ_NameTag")
            if nameTag then nameTag:Destroy() end
        end
        
        -- ===== BOX (Custom tambahan) =====
        if Settings.ESPBox and isAlive then
            local box = char:FindFirstChild("TINZZ_Box")
            if not box then
                box = Instance.new("BoxHandleAdornment")
                box.Name = "TINZZ_Box"
                box.Size = Vector3.new(3, 5, 1.5)
                box.Transparency = 0.3
                box.ZIndex = 0
                box.AlwaysOnTop = true
                box.Adornee = char:FindFirstChild("HumanoidRootPart")
                box.Parent = char
            end
            box.Color3 = accent
            box.Visible = true
        else
            local box = char:FindFirstChild("TINZZ_Box")
            if box then box:Destroy() end
        end
    end
end)

-- ===== WATERMARK =====
local watermark = Instance.new("TextLabel", TixUI)
watermark.Size = UDim2.new(0, 200, 0, 20)
watermark.Position = UDim2.new(1, -210, 1, -30)
watermark.BackgroundTransparency = 1
watermark.Text = "✦ TINZZxXITERS ✦ V6"
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
print("✦ TINZZxXITERS V6 Loaded ✦")
