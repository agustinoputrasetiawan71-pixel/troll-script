--[[
    Script ESP Lengkap dengan Customisasi
    Fitur: Name, Line, Box
    Cara Penggunaan: Jalankan script ini di executor favoritmu
]]

-- Buat GUI utama
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Fungsi untuk membuat notifikasi
local function notify(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "ESP System",
        Text = message,
        Duration = 3
    })
end

-- Buat ScreenGui utama
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_GUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 320)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 1
title.BorderColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "⚡ ESP Settings ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Fungsi untuk membuat toggle
local function createToggle(parent, yPos, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 1, -4)
    toggle.Position = UDim2.new(1, -45, 0, 2)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.BorderSizePixel = 1
    toggle.BorderColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return function() return state end
end

-- Fungsi untuk membuat slider
local function createSlider(parent, yPos, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 28)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 16, 0, 16)
    drag.Position = UDim2.new((default - min) / (max - min), -8, 0, -5)
    drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    drag.BorderSizePixel = 1
    drag.BorderColor3 = Color3.fromRGB(200, 200, 200)
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

-- Fungsi untuk membuat color picker
local function createColorPicker(parent, yPos, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 30, 1, -4)
    colorBtn.Position = UDim2.new(1, -35, 0, 2)
    colorBtn.BackgroundColor3 = default
    colorBtn.BorderSizePixel = 1
    colorBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.Text = ""
    colorBtn.Parent = frame
    
    local colorValue = default
    colorBtn.MouseButton1Click:Connect(function()
        -- Color picker sederhana dengan 5 pilihan warna
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255)
        }
        local currentIndex = 0
        for i, c in ipairs(colors) do
            if c == colorValue then
                currentIndex = i
                break
            end
        end
        currentIndex = currentIndex % #colors + 1
        colorValue = colors[currentIndex]
        colorBtn.BackgroundColor3 = colorValue
        callback(colorValue)
    end)
    
    return function() return colorValue end
end

-- Variabel ESP
local espEnabled = false
local showName = true
local showBox = true
local showLine = true
local boxColor = Color3.fromRGB(0, 255, 0)
local lineColor = Color3.fromRGB(255, 255, 0)
local nameColor = Color3.fromRGB(255, 255, 255)
local lineThickness = 2
local espObjects = {}

-- Fungsi untuk membersihkan ESP
local function clearESP()
    for _, v in pairs(espObjects) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    espObjects = {}
end

-- Fungsi untuk update ESP
local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = target.Character.HumanoidRootPart
            local humanoid = target.Character:FindFirstChild("Humanoid")
            
            if not humanoid or humanoid.Health <= 0 then continue end
            
            -- Box
            if showBox then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(3, 5, 1.5)
                box.Color3 = boxColor
                box.Transparency = 0.5
                box.ZIndex = 0
                box.AlwaysOnTop = true
                box.Adornee = rootPart
                box.Parent = rootPart
                table.insert(espObjects, box)
            end
            
            -- Line (Ray)
            if showLine then
                local line = Instance.new("SelectionBox")
                line.Color3 = lineColor
                line.Transparency = 0.7
                line.LineThickness = lineThickness
                line.Adornee = rootPart
                line.Parent = rootPart
                table.insert(espObjects, line)
            end
            
            -- Name
            if showName then
                local nameTag = Instance.new("BillboardGui")
                nameTag.Size = UDim2.new(0, 200, 0, 30)
                nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
                nameTag.AlwaysOnTop = true
                nameTag.Parent = rootPart
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = target.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                label.TextColor3 = nameColor
                label.TextSize = 14
                label.TextStrokeTransparency = 0.3
                label.Font = Enum.Font.GothamBold
                label.Parent = nameTag
                table.insert(espObjects, nameTag)
            end
        end
    end
end

-- Buat UI Controls
local yPos = 35

-- Enable/Disable ESP
local espToggle = createToggle(mainFrame, yPos, "Enable ESP", false, function(state)
    espEnabled = state
    if state then
        updateESP()
        notify("ESP Enabled")
    else
        clearESP()
        notify("ESP Disabled")
    end
end)
yPos = yPos + 35

-- Toggle Name
local nameToggle = createToggle(mainFrame, yPos, "Show Name", true, function(state)
    showName = state
    if espEnabled then updateESP() end
end)
yPos = yPos + 35

-- Toggle Box
local boxToggle = createToggle(mainFrame, yPos, "Show Box", true, function(state)
    showBox = state
    if espEnabled then updateESP() end
end)
yPos = yPos + 35

-- Toggle Line
local lineToggle = createToggle(mainFrame, yPos, "Show Line", true, function(state)
    showLine = state
    if espEnabled then updateESP() end
end)
yPos = yPos + 40

-- Color Pickers
local boxColorPicker = createColorPicker(mainFrame, yPos, "Box Color", Color3.fromRGB(0, 255, 0), function(color)
    boxColor = color
    if espEnabled then updateESP() end
end)
yPos = yPos + 35

local lineColorPicker = createColorPicker(mainFrame, yPos, "Line Color", Color3.fromRGB(255, 255, 0), function(color)
    lineColor = color
    if espEnabled then updateESP() end
end)
yPos = yPos + 35

local nameColorPicker = createColorPicker(mainFrame, yPos, "Name Color", Color3.fromRGB(255, 255, 255), function(color)
    nameColor = color
    if espEnabled then updateESP() end
end)
yPos = yPos + 40

-- Line Thickness
local thicknessSlider = createSlider(mainFrame, yPos, "Line Thickness", 1, 5, 2, function(value)
    lineThickness = value
    if espEnabled then updateESP() end
end)

-- Tombol Refresh
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.8, 0, 0, 30)
refreshBtn.Position = UDim2.new(0.1, 0, 1, -40)
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
refreshBtn.BorderSizePixel = 0
refreshBtn.Text = "🔄 Refresh ESP"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.TextScaled = true
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.Parent = mainFrame

refreshBtn.MouseButton1Click:Connect(function()
    if espEnabled then
        updateESP()
        notify("ESP Refreshed!")
    else
        notify("Please enable ESP first!")
    end
end)

-- Auto refresh setiap 2 detik
game:GetService("RunService").RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Deteksi pemain baru
game.Players.PlayerAdded:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Deteksi pemain keluar
game.Players.PlayerRemoving:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

notify("ESP Script Loaded! Drag the window to move it.")
