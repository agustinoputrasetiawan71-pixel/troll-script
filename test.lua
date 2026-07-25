--[[
    TINZZxXITERS ESP V2
    Fitur: Name, Line, Box
    Style: Pink, Black, Blue Modern
]]

-- Buat GUI utama
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Warna tema
local THEME = {
    Pink = Color3.fromRGB(255, 20, 147),
    DarkPink = Color3.fromRGB(200, 10, 110),
    Black = Color3.fromRGB(20, 20, 20),
    DarkBlack = Color3.fromRGB(10, 10, 10),
    Blue = Color3.fromRGB(0, 150, 255),
    White = Color3.fromRGB(255, 255, 255),
    Glass = Color3.fromRGB(255, 255, 255)
}

-- Fungsi notifikasi
local function notify(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "TINZZxXITERS ESP",
        Text = message,
        Duration = 3
    })
end

-- Buat ScreenGui utama
local gui = Instance.new("ScreenGui")
gui.Name = "TINZZ_ESP"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- Frame utama dengan efek glass
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = THEME.Black
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = THEME.Pink
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Efek blur/glass (gradient)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.Black),
    ColorSequenceKeypoint.new(0.5, THEME.DarkPink),
    ColorSequenceKeypoint.new(1, THEME.Black)
})
gradient.Transparency = NumberSequence.new(0.85)
gradient.Parent = mainFrame

-- Header dengan efek neon
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = THEME.DarkPink
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✦ TINZZxXITERS ✦"
titleLabel.TextColor3 = THEME.White
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeColor3 = THEME.Pink
titleLabel.TextStrokeTransparency = 0.3
titleLabel.Parent = header

-- Subtitle
local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(1, 0, 0, 20)
subTitle.Position = UDim2.new(0, 0, 1, -20)
subTitle.BackgroundTransparency = 1
subTitle.Text = "✦ ESP SYSTEM ✦"
subTitle.TextColor3 = THEME.Pink
subTitle.TextSize = 12
subTitle.Font = Enum.Font.Gotham
subTitle.TextXAlignment = Enum.TextXAlignment.Center
subTitle.Parent = header

-- Scroll Frame untuk konten
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = THEME.Pink
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
scrollFrame.Parent = mainFrame

local contentY = 0
local function addSpacing(amount)
    contentY = contentY + amount
end

-- Fungsi untuk membuat toggle modern
local function createToggle(parent, yPos, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundColor3 = THEME.DarkBlack
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = THEME.Pink
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 160, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.White
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 1, -4)
    toggle.Position = UDim2.new(1, -55, 0, 2)
    toggle.BackgroundColor3 = default and THEME.Pink or THEME.DarkBlack
    toggle.BorderSizePixel = 1
    toggle.BorderColor3 = THEME.Blue
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = THEME.White
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and THEME.Pink or THEME.DarkBlack
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return function() return state end
end

-- Fungsi untuk membuat color picker modern
local function createColorPicker(parent, yPos, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundColor3 = THEME.DarkBlack
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = THEME.Pink
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 160, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.White
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 50, 1, -4)
    colorBtn.Position = UDim2.new(1, -55, 0, 2)
    colorBtn.BackgroundColor3 = default
    colorBtn.BorderSizePixel = 1
    colorBtn.BorderColor3 = THEME.Blue
    colorBtn.Text = ""
    colorBtn.Parent = frame
    
    local colorValue = default
    local colorIndex = 1
    local colors = {
        Color3.fromRGB(255, 20, 147),  -- Pink
        Color3.fromRGB(0, 150, 255),   -- Blue
        Color3.fromRGB(255, 0, 0),     -- Red
        Color3.fromRGB(0, 255, 0),     -- Green
        Color3.fromRGB(255, 255, 0),   -- Yellow
        Color3.fromRGB(255, 0, 255),   -- Magenta
        Color3.fromRGB(0, 255, 255),   -- Cyan
        Color3.fromRGB(255, 255, 255)  -- White
    }
    
    colorBtn.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        colorValue = colors[colorIndex]
        colorBtn.BackgroundColor3 = colorValue
        callback(colorValue)
    end)
    
    return function() return colorValue end
end

-- Fungsi untuk membuat slider modern
local function createSlider(parent, yPos, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundColor3 = THEME.DarkBlack
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = THEME.Pink
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = THEME.White
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -10, 0, 6)
    slider.Position = UDim2.new(0, 5, 0, 28)
    slider.BackgroundColor3 = THEME.DarkBlack
    slider.BorderSizePixel = 1
    slider.BorderColor3 = THEME.Blue
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = THEME.Pink
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 16, 0, 16)
    drag.Position = UDim2.new((default - min) / (max - min), -8, 0, -5)
    drag.BackgroundColor3 = THEME.White
    drag.BorderSizePixel = 2
    drag.BorderColor3 = THEME.Pink
    drag.Text = ""
    drag.Parent = slider
    
    local value = default
    local dragging = false
    
    drag.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    mouse.Move:Connect(function()
        if not dragging then return end
        local pos = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * pos
        value = math.round(value)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        drag.Position = UDim2.new(pos, -8, 0, -5)
        label.Text = text .. ": " .. tostring(value)
        callback(value)
    end)
    
    return function() return value end
end

-- ===== VARIABEL ESP =====
local espEnabled = false
local showName = true
local showBox = true
local showLine = true
local boxColor = THEME.Pink
local lineColor = THEME.Blue
local nameColor = THEME.White
local lineThickness = 2
local espObjects = {}

-- ===== FUNGSI ESP =====
local function clearESP()
    for _, v in pairs(espObjects) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = target.Character.HumanoidRootPart
            local humanoid = target.Character:FindFirstChild("Humanoid")
            
            if not humanoid or humanoid.Health <= 0 then continue end
            
            -- BOX
            if showBox then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(3, 5, 1.5)
                box.Color3 = boxColor
                box.Transparency = 0.3
                box.ZIndex = 0
                box.AlwaysOnTop = true
                box.Adornee = rootPart
                box.Parent = rootPart
                table.insert(espObjects, box)
            end
            
            -- LINE (Fixed)
            if showLine then
                local line = Instance.new("SelectionBox")
                line.Color3 = lineColor
                line.Transparency = 0.5
                line.LineThickness = lineThickness
                line.Adornee = rootPart
                line.Parent = rootPart
                table.insert(espObjects, line)
            end
            
            -- NAME
            if showName then
                local nameTag = Instance.new("BillboardGui")
                nameTag.Size = UDim2.new(0, 200, 0, 30)
                nameTag.StudsOffset = Vector3.new(0, 4, 0)
                nameTag.AlwaysOnTop = true
                nameTag.Parent = rootPart
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = target.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                label.TextColor3 = nameColor
                label.TextSize = 14
                label.TextStrokeTransparency = 0.2
                label.TextStrokeColor3 = THEME.Black
                label.Font = Enum.Font.GothamBold
                label.Parent = nameTag
                table.insert(espObjects, nameTag)
            end
        end
    end
end

-- ===== UI CONTROLS =====
local yPos = 5

-- Enable ESP
local espToggle = createToggle(scrollFrame, yPos, "✦ Enable ESP", false, function(state)
    espEnabled = state
    if state then
        updateESP()
        notify("✦ ESP Activated ✦")
    else
        clearESP()
        notify("ESP Deactivated")
    end
end)
addSpacing(40)

-- Show Name
local nameToggle = createToggle(scrollFrame, yPos + 40, "✦ Show Name", true, function(state)
    showName = state
    if espEnabled then updateESP() end
end)
addSpacing(40)

-- Show Box
local boxToggle = createToggle(scrollFrame, yPos + 80, "✦ Show Box", true, function(state)
    showBox = state
    if espEnabled then updateESP() end
end)
addSpacing(40)

-- Show Line
local lineToggle = createToggle(scrollFrame, yPos + 120, "✦ Show Line", true, function(state)
    showLine = state
    if espEnabled then updateESP() end
end)
addSpacing(45)

-- Color Pickers
local boxColorPicker = createColorPicker(scrollFrame, yPos + 165, "✦ Box Color", THEME.Pink, function(color)
    boxColor = color
    if espEnabled then updateESP() end
end)
addSpacing(40)

local lineColorPicker = createColorPicker(scrollFrame, yPos + 205, "✦ Line Color", THEME.Blue, function(color)
    lineColor = color
    if espEnabled then updateESP() end
end)
addSpacing(40)

local nameColorPicker = createColorPicker(scrollFrame, yPos + 245, "✦ Name Color", THEME.White, function(color)
    nameColor = color
    if espEnabled then updateESP() end
end)
addSpacing(45)

-- Line Thickness
local thicknessSlider = createSlider(scrollFrame, yPos + 290, "✦ Line Thickness", 1, 5, 2, function(value)
    lineThickness = value
    if espEnabled then updateESP() end
end)
addSpacing(50)

-- Tombol Refresh
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.8, 0, 0, 35)
refreshBtn.Position = UDim2.new(0.1, 0, 1, -45)
refreshBtn.BackgroundColor3 = THEME.Pink
refreshBtn.BackgroundTransparency = 0.2
refreshBtn.BorderSizePixel = 2
refreshBtn.BorderColor3 = THEME.Blue
refreshBtn.Text = "✦ REFRESH ESP ✦"
refreshBtn.TextColor3 = THEME.White
refreshBtn.TextScaled = true
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.Parent = mainFrame

refreshBtn.MouseButton1Click:Connect(function()
    if espEnabled then
        updateESP()
        notify("✦ ESP Refreshed ✦")
    else
        notify("Enable ESP first!")
    end
end)

-- Auto refresh
game:GetService("RunService").RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Deteksi pemain
game.Players.PlayerAdded:Connect(function()
    if espEnabled then updateESP() end
end)

game.Players.PlayerRemoving:Connect(function()
    if espEnabled then updateESP() end
end)

-- ===== WATERMARK =====
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 200, 0, 20)
watermark.Position = UDim2.new(1, -210, 1, -25)
watermark.BackgroundTransparency = 1
watermark.Text = "✦ TINZZxXITERS ✦ v2"
watermark.TextColor3 = THEME.Pink
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = gui

notify("✦ TINZZxXITERS ESP Loaded ✦")
print("✦ TINZZxXITERS ESP V2 Loaded ✦")
