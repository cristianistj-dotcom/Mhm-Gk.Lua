
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("MhmGkPanel")
if oldGui then
    oldGui:Destroy()
end

local altoBallAtivo = false
local rastreadorAtivo = true
local minimized = false
local closed = false
local connections = {}
local visualStates = {
    ["Auto Catch"] = false,
    ["GK Reach"] = false,
    ["Auto Dive"] = false,
    ["Save Assist"] = false,
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local gui = make("ScreenGui", {
    Name = "MhmGkPanel",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(330, 365),
    Position = UDim2.new(0.5, -165, 0.5, -182),
    BackgroundColor3 = Color3.fromRGB(20, 23, 32),
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, main)
make("UIStroke", {
    Color = Color3.fromRGB(72, 130, 210),
    Transparency = 0.25,
    Thickness = 1.5,
}, main)

local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 43),
    BackgroundColor3 = Color3.fromRGB(30, 38, 55),
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, header)

make("TextLabel", {
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "Mhm Gk | Goalkeeper",
    TextColor3 = Color3.fromRGB(240, 245, 255),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local minimize = make("TextButton", {
    Size = UDim2.fromOffset(32, 30),
    Position = UDim2.new(1, -72, 0, 6),
    Text = "—",
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(65, 75, 95),
    BorderSizePixel = 0,
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, minimize)

local close = make("TextButton", {
    Size = UDim2.fromOffset(32, 30),
    Position = UDim2.new(1, -36, 0, 6),
    Text = "×",
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(175, 55, 65),
    BorderSizePixel = 0,
}, header)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, close)

-- Arrastar o painel pela barra superior.
do
    local dragging = false
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local orb = make("TextButton", {
    Name = "ReopenOrb",
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0, 18, 0.5, -28),
    BackgroundColor3 = Color3.fromRGB(40, 115, 210),
    BackgroundTransparency = 0.08,
    Text = "GK",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    Visible = false,
    BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, orb)
make("UIStroke", {Color = Color3.fromRGB(170, 210, 255), Thickness = 1.5}, orb)

-- Arrastar a bolinha.
do
    local dragging = false
    local dragStart
    local startPosition

    orb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = orb.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            orb.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local tabs = make("Frame", {
    Position = UDim2.fromOffset(10, 51),
    Size = UDim2.new(1, -20, 0, 34),
    BackgroundTransparency = 1,
}, main)

local function tabButton(text, x)
    local b = make("TextButton", {
        Position = UDim2.new(x, 0, 0, 0),
        Size = UDim2.new(0.5, -4, 1, 0),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(43, 88, 150),
        BorderSizePixel = 0,
    }, tabs)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, b)
    return b
end

local gkTab = tabButton("GK", 0)
local statusTab = tabButton("STATUS", 0.5)

local content = make("Frame", {
    Position = UDim2.fromOffset(10, 94),
    Size = UDim2.new(1, -20, 1, -104),
    BackgroundTransparency = 1,
}, main)

local gkPage = make("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 310),
}, content)

local statusPage = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Visible = false,
}, content)

local function addToggle(label, order, callback)
    local b = make("TextButton", {
        Position = UDim2.fromOffset(0, (order - 1) * 43),
        Size = UDim2.new(1, -5, 0, 37),
        BackgroundColor3 = Color3.fromRGB(38, 44, 59),
        Text = label .. ": OFF",
        TextColor3 = Color3.fromRGB(235, 240, 250),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        BorderSizePixel = 0,
    }, gkPage)
    make("UICorner", {CornerRadius = UDim.new(0, 7)}, b)

    local state = false
    b.Activated:Connect(function()
        state = not state
        b.Text = label .. (state and ": ON" or ": OFF")
        b.BackgroundColor3 = state
            and Color3.fromRGB(35, 125, 78)
            or Color3.fromRGB(38, 44, 59)
        if callback then callback(state) end
    end)
    return b
end

addToggle("Alto Ball", 1, function(state)
    altoBallAtivo = state
end)

addToggle("Rastreador da bola", 2, function(state)
    rastreadorAtivo = state
end)

addToggle("Auto Catch", 3, function(state)
    visualStates["Auto Catch"] = state
end)

addToggle("GK Reach", 4, function(state)
    visualStates["GK Reach"] = state
end)

addToggle("Auto Dive", 5, function(state)
    visualStates["Auto Dive"] = state
end)

addToggle("Save Assist", 6, function(state)
    visualStates["Save Assist"] = state
end)

local ballInfo = make("TextLabel", {
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, 0, 0, 85),
    BackgroundColor3 = Color3.fromRGB(32, 39, 53),
    BackgroundTransparency = 0.1,
    Text = "Status: iniciando...",
    TextColor3 = Color3.fromRGB(230, 238, 250),
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Center,
    BorderSizePixel = 0,
}, statusPage)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, ballInfo)

local sessionInfo = make("TextLabel", {
    Position = UDim2.fromOffset(0, 95),
    Size = UDim2.new(1, 0, 0, 95),
    BackgroundTransparency = 1,
    Text = "Sessão local ativa.\nEste indicador não bloqueia expulsões do servidor.",
    TextColor3 = Color3.fromRGB(200, 210, 225),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
}, statusPage)

gkTab.Activated:Connect(function()
    gkPage.Visible = true
    statusPage.Visible = false
end)

statusTab.Activated:Connect(function()
    gkPage.Visible = false
    statusPage.Visible = true
end)

minimize.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    tabs.Visible = not minimized
    main.Size = minimized
        and UDim2.fromOffset(330, 43)
        or UDim2.fromOffset(330, 365)
    orb.Visible = minimized
end)

orb.Activated:Connect(function()
    minimized = false
    main.Size = UDim2.fromOffset(330, 365)
    content.Visible = true
    tabs.Visible = true
    orb.Visible = false
end)

close.Activated:Connect(function()
    closed = true
    altoBallAtivo = false
    gui:Destroy()
end)

local function findBall()
    local ball = Workspace:FindFirstChild("Ball", true)
    if ball and ball:IsA("BasePart") then
        return ball
    end
    return nil
end

local lastUpdate = 0
connections.heartbeat = RunService.Heartbeat:Connect(function()
    if closed then return end

    local now = os.clock()
    if now - lastUpdate >= 0.15 then
        lastUpdate = now

        local ball = findBall()
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if ball and root then
            local distance = (ball.Position - root.Position).Magnitude
            ballInfo.Text = string.format(
                "Ball encontrada\nDistância: %.1f studs\nPosição: %.1f, %.1f, %.1f",
                distance,
                ball.Position.X,
                ball.Position.Y,
                ball.Position.Z
            )
        elseif ball then
            ballInfo.Text = string.format(
                "Ball encontrada\nPosição: %.1f, %.1f, %.1f",
                ball.Position.X,
                ball.Position.Y,
                ball.Position.Z
            )
        else
            ballInfo.Text = "Ball não encontrada no Workspace."
        end
    end

    if altoBallAtivo then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local ball = findBall()

        if humanoid and root and ball then
            local direction = ball.Position - root.Position
            direction = Vector3.new(direction.X, 0, direction.Z)

            if direction.Magnitude > 3 then
                humanoid:Move(direction.Unit, false)
            else
                humanoid:Move(Vector3.zero, false)
            end
        end
    end
end)

gui.Destroying:Connect(function()
    closed = true
    altoBallAtivo = false
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
end)
