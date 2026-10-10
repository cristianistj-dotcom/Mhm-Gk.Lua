
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Evita interfaces duplicadas
local oldGui = playerGui:FindFirstChild("MhmGk")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MhmGk"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local states = {}
local values = {}
local statusLabels = {}

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 430)
main.Position = UDim2.new(0.5, -170, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Cabeçalho
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 0, 45)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "Mhm Gk | Goalkeeper"
title.TextColor3 = Color3.new(1, 1, 1)
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

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Arrastar a janela com o mouse ou toque
local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- Abas
local tabs = Instance.new("Frame")
tabs.Position = UDim2.fromOffset(12, 52)
tabs.Size = UDim2.new(1, -24, 0, 35)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local function makeButton(text, position, size, parent)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(43, 43, 53)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 240, 245)
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 7)

    return button
end

local gkTab = makeButton(
    "GK",
    UDim2.fromOffset(0, 0),
    UDim2.new(0.5, -4, 1, 0),
    tabs
)

local statusTab = makeButton(
    "STATUS",
    UDim2.new(0.5, 4, 0, 0),
    UDim2.new(0.5, -4, 1, 0),
    tabs
)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(12, 96)
content.Size = UDim2.new(1, -24, 1, -108)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = content

-- Página de status
local statusPage = Instance.new("ScrollingFrame")
statusPage.Position = content.Position
statusPage.Size = content.Size
statusPage.BackgroundTransparency = 1
statusPage.BorderSizePixel = 0
statusPage.ScrollBarThickness = 4
statusPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
statusPage.CanvasSize = UDim2.new()
statusPage.Visible = false
statusPage.Parent = main

local statusLayout = Instance.new("UIListLayout")
statusLayout.Padding = UDim.new(0, 8)
statusLayout.Parent = statusPage

local function makeStatusLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 36)
    label.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = statusPage

    Instance.new("UICorner", label).CornerRadius =
        UDim.new(0, 8)

    return label
end

local info = makeStatusLabel("Mhm Gk carregado")
info.TextWrapped = true

local function refreshStatus()
    info.Text = "Mhm Gk | Configurações locais"

    for name, label in pairs(statusLabels) do
        label.Text = name .. ": "
            .. (states[name] and "ON" or "OFF")
    end
end

-- Botões ON/OFF
local function makeToggle(name)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -5, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    row.Parent = content

    Instance.new("UICorner", row).CornerRadius =
        UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Position = UDim2.fromOffset(10, 0)
    label.Size = UDim2.new(1, -90, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggle = makeButton(
        "OFF",
        UDim2.new(1, -66, 0, 5),
        UDim2.fromOffset(58, 28),
        row
    )

    states[name] = false
    statusLabels[name] = makeStatusLabel(name .. ": OFF")

    local function refresh()
        toggle.Text = states[name] and "ON" or "OFF"
        toggle.BackgroundColor3 = states[name]
            and Color3.fromRGB(45, 155, 105)
            or Color3.fromRGB(65, 65, 77)

        refreshStatus()
    end

    toggle.Activated:Connect(function()
        states[name] = not states[name]
        refresh()

        print(name .. ": " .. tostring(states[name]))
    end)

    refresh()
end

-- Sliders com toque e arraste
local function makeSlider(name, minValue, maxValue, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -5, 0, 60)
    row.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    row.Parent = content

    Instance.new("UICorner", row).CornerRadius =
        UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Position = UDim2.fromOffset(10, 3)
    label.Size = UDim2.new(1, -20, 0, 22)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(10, 34)
    bar.Size = UDim2.new(1, -20, 0, 12)
    bar.BackgroundColor3 = Color3.fromRGB(65, 65, 78)
    bar.Active = true
    bar.Parent = row

    Instance.new("UICorner", bar).CornerRadius =
        UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(45, 155, 105)
    fill.Parent = bar

    Instance.new("UICorner", fill).CornerRadius =
        UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = bar

    Instance.new("UICorner", knob).CornerRadius =
        UDim.new(1, 0)

    values[name] = defaultValue

    local function setValueFromX(x)
        local width = bar.AbsoluteSize.X
        if width <= 0 then
            return
        end

        local alpha = math.clamp(
            (x - bar.AbsolutePosition.X) / width,
            0,
            1
        )

        local newValue = minValue
            + alpha * (maxValue - minValue)

        values[name] = math.floor(newValue + 0.5)

        local fraction = (values[name] - minValue)
            / (maxValue - minValue)

        fill.Size = UDim2.new(fraction, 0, 1, 0)
        knob.Position = UDim2.new(fraction, 0, 0.5, 0)
        label.Text = name .. ": " .. values[name]
    end

    local function setFromInput(input)
        setValueFromX(input.Position.X)
    end

    local draggingSlider = false

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            setFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            setFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    setValueFromX(
        bar.AbsolutePosition.X
        + bar.AbsoluteSize.X
        * ((defaultValue - minValue) / (maxValue - minValue))
    )
end

-- Troca real de páginas
gkTab.Activated:Connect(function()
    content.Visible = true
    statusPage.Visible = false
end)

statusTab.Activated:Connect(function()
    content.Visible = false
    statusPage.Visible = true
    refreshStatus()
end)

-- Controles
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

refreshStatus()
print("Mhm Gk carregado!")
