
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MhmGk"
gui.ResetOnSpawn = false

local parent = player:WaitForChild("PlayerGui")
gui.Parent = parent

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(340, 390)
main.Position = UDim2.new(0.5, -170, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "Mhm Gk  |  Goalkeeper"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -40, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(180, 55, 65)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local tabs = Instance.new("Frame")
tabs.Position = UDim2.fromOffset(12, 52)
tabs.Size = UDim2.new(1, -24, 0, 35)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local function makeButton(text, position, size, parent)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = Color3.fromRGB(43, 43, 53)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(240, 240, 245)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.Parent = parent

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(12, 96)
content.Size = UDim2.new(1, -24, 1, -108)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = content

local function makeToggle(label)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -5, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    row.Parent = content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local text = Instance.new("TextLabel")
    text.Position = UDim2.fromOffset(10, 0)
    text.Size = UDim2.new(1, -90, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Color3.fromRGB(230, 230, 235)
    text.Font = Enum.Font.Gotham
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = row

    local enabled = false
    local toggle = makeButton("OFF", UDim2.new(1, -66, 0, 5),
        UDim2.fromOffset(58, 28), row)

    local function update()
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled
            and Color3.fromRGB(45, 155, 105)
            or Color3.fromRGB(65, 65, 77)
    end

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        print(label .. ": " .. tostring(enabled))
    end)

    update()
end

local function makeSlider(label, minValue, maxValue, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -5, 0, 58)
    row.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    row.Parent = content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local text = Instance.new("TextLabel")
    text.Position = UDim2.fromOffset(10, 4)
    text.Size = UDim2.new(1, -20, 0, 20)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(230, 230, 235)
    text.Font = Enum.Font.Gotham
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = row

    local slider = Instance.new("TextButton")
    slider.Position = UDim2.fromOffset(10, 30)
    slider.Size = UDim2.new(1, -20, 0, 18)
    slider.BackgroundColor3 = Color3.fromRGB(65, 65, 78)
    slider.Text = ""
    slider.Parent = row
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)

    local value = defaultValue
    local function refresh()
        text.Text = label .. ": " .. tostring(value)
    end
    refresh()

    slider.MouseButton1Click:Connect(function()
        value += 1
        if value > maxValue then value = minValue end
        refresh()
        print(label .. " = " .. tostring(value))
    end)
end

local gkTab = makeButton("GK", UDim2.fromOffset(0, 0),
    UDim2.new(0.5, -4, 1, 0), tabs)
local statusTab = makeButton("STATUS", UDim2.new(0.5, 4, 0, 0),
    UDim2.new(0.5, -4, 1, 0), tabs)

gkTab.MouseButton1Click:Connect(function()
    content.Visible = true
end)

statusTab.MouseButton1Click:Connect(function()
    content.Visible = true
    print("Mhm Gk: interface ativa")
end)

makeToggle("Auto Catch")
makeToggle("GK Reach")
makeToggle("Auto Dive")
makeToggle("Auto Catch During Dive")
makeToggle("GK Controls")

makeSlider("Auto Catch Range", 1, 30, 10)
makeSlider("Auto Catch Cooldown", 1, 10, 3)
makeSlider("GK Reach Distance", 1, 30, 12)
makeSlider("Dive Cooldown", 1, 10, 2)
makeSlider("Lateral Force Min", 1, 50, 10)
makeSlider("Lateral Force Max", 1, 100, 30)
makeSlider("Jump Force", 1, 100, 25)
makeSlider("Max Dive Distance", 1, 50, 20)

print("Mhm Gk carregado!")
