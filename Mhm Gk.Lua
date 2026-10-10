

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("Mastertrap")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "Mastertrap"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local followEnabled = false
local activeTab = "GK"

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local panel = make("Frame", {
    Size = UDim2.fromOffset(300, 230),
    Position = UDim2.new(0.5, -150, 0.5, -115),
    BackgroundColor3 = Color3.fromRGB(18, 18, 18),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Active = true
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, panel)
make("UIStroke", {
    Color = Color3.fromRGB(220, 220, 220),
    Transparency = 0.65
}, panel)

local header = make("TextLabel", {
    Size = UDim2.new(1, -100, 0, 38),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "Mastertrap",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, panel)

local minimize = make("TextButton", {
    Size = UDim2.fromOffset(35, 30),
    Position = UDim2.new(1, -78, 0, 4),
    Text = "—",
    TextSize = 20,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
}, panel)

local close = make("TextButton", {
    Size = UDim2.fromOffset(35, 30),
    Position = UDim2.new(1, -39, 0, 4),
    Text = "X",
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(120, 35, 35)
}, panel)

local tabs = make("Frame", {
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.fromOffset(10, 45),
    BackgroundTransparency = 1
}, panel)

local function tabButton(text, x)
    return make("TextButton", {
        Size = UDim2.fromOffset(135, 32),
        Position = UDim2.fromOffset(x, 0),
        Text = text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }, tabs)
end

local gkTab = tabButton("GK", 0)
local statusTab = tabButton("STATUS", 145)

local status = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.fromOffset(10, 88),
    BackgroundTransparency = 1,
    Text = "Mastertrap pronto",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextSize = 13,
    Font = Enum.Font.Gotham
}, panel)

local followButton = make("TextButton", {
    Size = UDim2.new(1, -30, 0, 42),
    Position = UDim2.fromOffset(15, 130),
    Text = "Alto Ball: OFF",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = Color3.fromRGB(45, 70, 55)
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, followButton)

local info = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.fromOffset(10, 180),
    BackgroundTransparency = 1,
    Text = "Use o botão para alternar o movimento",
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextWrapped = true
}, panel)

-- Bolinha flutuante
local orb = make("TextButton", {
    Name = "FloatingButton",
    Size = UDim2.fromOffset(52, 52),
    Position = UDim2.new(0.82, 0, 0.45, 0),
    Text = "MX",
    TextSize = 19,
    Font = Enum.Font.GothamBlack,
    TextColor3 = Color3.fromRGB(245, 245, 245),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    Visible = false,
    Active = true
}, gui)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, orb)
make("UIStroke", {
    Color = Color3.fromRGB(235, 235, 235),
    Transparency = 0.4,
    Thickness = 1.5
}, orb)

-- Arrastar painel pela barra superior
local function makeDraggable(object, handle)
    local dragging = false
    local startInput, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input
            startPos = object.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input == startInput
            or input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput.Position
            object.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == startInput then
            dragging = false
        end
    end)
end

makeDraggable(panel, header)
makeDraggable(orb, orb)

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    orb.Visible = true
end)

orb.MouseButton1Click:Connect(function()
    panel.Visible = true
    orb.Visible = false
end)

close.MouseButton1Click:Connect(function()
    followEnabled = false
    gui:Destroy()
end)

gkTab.MouseButton1Click:Connect(function()
    activeTab = "GK"
    status.Text = "Aba GK selecionada"
    followButton.Visible = true
    info.Text = "Alto Ball controla o movimento"
end)

statusTab.MouseButton1Click:Connect(function()
    activeTab = "STATUS"
    status.Text = "Status do Mastertrap"
    followButton.Visible = false
    info.Text = "Interface ativa"
end)

-- Localizar a bola
local function findBall()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "Football" or obj.Name == "Ball")
            and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- Alternar movimento automático
followButton.MouseButton1Click:Connect(function()
    followEnabled = not followEnabled
    followButton.Text = followEnabled
        and "Alto Ball: ON"
        or "Alto Ball: OFF"
    status.Text = followEnabled
        and "Movimento ativado"
        or "Movimento desativado"
end)

-- Atualizar destino enquanto estiver ativado
local lastMove = 0

RunService.Heartbeat:Connect(function()
    if not followEnabled or not gui.Parent then return end
    if os.clock() - lastMove < 0.25 then return end
    lastMove = os.clock()

    local character = player.Character
    local ball = findBall()
    if not character or not ball then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    local offset = ball.Position - root.Position
    if offset.Magnitude > 5 then
        humanoid:MoveTo(ball.Position - offset.Unit * 3)
    end
end)
