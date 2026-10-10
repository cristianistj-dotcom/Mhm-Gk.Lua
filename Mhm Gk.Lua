
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("MhmGkComplete")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "MhmGkComplete"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, obj)
end

local function outline(obj, color, thickness)
    make("UIStroke", {
        Color = color or Color3.fromRGB(65, 145, 255),
        Thickness = thickness or 1.5
    }, obj)
end

local bg = Color3.fromRGB(24, 23, 30)
local panel2 = Color3.fromRGB(42, 41, 52)
local white = Color3.fromRGB(245, 245, 250)
local blue = Color3.fromRGB(65, 145, 255)
local green = Color3.fromRGB(100, 235, 145)

local panel = make("Frame", {
    Name = "MainPanel",
    Size = UDim2.new(0, 310, 0, 350),
    Position = UDim2.new(0.5, -155, 0.5, -175),
    BackgroundColor3 = bg,
    BorderSizePixel = 0
}, gui)
round(panel, 15)
outline(panel, Color3.fromRGB(55, 55, 70), 1)

-- Cabeçalho arrastável
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Color3.fromRGB(30, 29, 37),
    BorderSizePixel = 0
}, panel)
round(header, 15)

make("TextLabel", {
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(1, -105, 1, 0),
    BackgroundTransparency = 1,
    Text = "Mhm Gk | Goalkeeper",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local minimize = make("TextButton", {
    Position = UDim2.new(1, -78, 0, 7),
    Size = UDim2.new(0, 32, 0, 32),
    BackgroundColor3 = panel2,
    Text = "—",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 19
}, header)
round(minimize, 8)

local close = make("TextButton", {
    Position = UDim2.new(1, -39, 0, 7),
    Size = UDim2.new(0, 32, 0, 32),
    BackgroundColor3 = Color3.fromRGB(150, 55, 65),
    Text = "X",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 15
}, header)
round(close, 8)

-- Abas
local tabs = make("Frame", {
    Position = UDim2.new(0, 10, 0, 58),
    Size = UDim2.new(1, -20, 0, 36),
    BackgroundTransparency = 1
}, panel)

local gkTab = make("TextButton", {
    Size = UDim2.new(0.5, -4, 1, 0),
    BackgroundColor3 = blue,
    Text = "GK",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 14
}, tabs)
round(gkTab, 8)

local statusTab = make("TextButton", {
    Position = UDim2.new(0.5, 4, 0, 0),
    Size = UDim2.new(0.5, -4, 1, 0),
    BackgroundColor3 = panel2,
    Text = "STATUS",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 14
}, tabs)
round(statusTab, 8)

local content = make("Frame", {
    Position = UDim2.new(0, 10, 0, 104),
    Size = UDim2.new(1, -20, 1, -114),
    BackgroundTransparency = 1
}, panel)

local gkPage = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(0, 0, 0, 310)
}, content)

make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, gkPage)

local statusPage = make("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false
}, content)

local connectionText = make("TextLabel", {
    Position = UDim2.new(0, 0, 0, 10),
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundTransparency = 1,
    Text = "Monitor ativo",
    TextColor3 = green,
    Font = Enum.Font.GothamBold,
    TextSize = 16
}, statusPage)

make("TextLabel", {
    Position = UDim2.new(0, 5, 0, 48),
    Size = UDim2.new(1, -10, 0, 48),
    BackgroundTransparency = 1,
    Text = "Monitor visual de conexão.\nNão bloqueia kicks do servidor.",
    TextWrapped = true,
    TextColor3 = white,
    Font = Enum.Font.Gotham,
    TextSize = 12
}, statusPage)

local check = make("TextButton", {
    Position = UDim2.new(0, 0, 0, 108),
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = panel2,
    Text = "Verificar status",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 13
}, statusPage)
round(check, 8)

check.Activated:Connect(function()
    if player.Parent and game:IsLoaded() then
        connectionText.Text = "Conectado ao jogo"
        connectionText.TextColor3 = green
    else
        connectionText.Text = "Conexão indisponível"
        connectionText.TextColor3 = Color3.fromRGB(255, 90, 90)
    end
end)

-- Botões da aba GK
local features = {
    "Auto Catch",
    "GK Reach",
    "Auto Dive",
    "Save Assist"
}

local enabled = {}

local function addToggle(name)
    local button = make("TextButton", {
        Size = UDim2.new(1, -4, 0, 43),
        BackgroundColor3 = panel2,
        Text = name .. "   [OFF]",
        TextColor3 = white,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        LayoutOrder = #gkPage:GetChildren()
    }, gkPage)
    round(button, 9)

    enabled[name] = false

    button.Activated:Connect(function()
        enabled[name] = not enabled[name]
        button.Text = name .. (enabled[name] and "   [ON]" or "   [OFF]")
        button.BackgroundColor3 =
            enabled[name] and Color3.fromRGB(35, 100, 65) or panel2
    end)
end

for _, name in ipairs(features) do
    addToggle(name)
end

make("TextLabel", {
    Size = UDim2.new(1, -4, 0, 42),
    BackgroundTransparency = 1,
    Text = "Os botões são visuais; não ativam\nmecânicas automaticamente.",
    TextColor3 = Color3.fromRGB(190, 190, 200),
    TextWrapped = true,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    LayoutOrder = 99
}, gkPage)

gkTab.Activated:Connect(function()
    gkPage.Visible = true
    statusPage.Visible = false
    gkTab.BackgroundColor3 = blue
    statusTab.BackgroundColor3 = panel2
end)

statusTab.Activated:Connect(function()
    gkPage.Visible = false
    statusPage.Visible = true
    statusTab.BackgroundColor3 = blue
    gkTab.BackgroundColor3 = panel2
end)

-- Bolinha para reabrir o painel
local orb = make("TextButton", {
    Name = "MhmOrb",
    Size = UDim2.new(0, 58, 0, 58),
    Position = UDim2.new(0, 22, 0.45, 0),
    BackgroundColor3 = bg,
    Text = "Mhm",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    Visible = false
}, gui)
round(orb, 50)
outline(orb, blue, 2)

minimize.Activated:Connect(function()
    panel.Visible = false
    orb.Visible = true
end)

orb.Activated:Connect(function()
    panel.Visible = true
    orb.Visible = false
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Arrastar painel e bolinha com toque ou mouse
local function makeDraggable(target, handle)
    local dragging = false
    local dragInput
    local startInput
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(panel, header)
makeDraggable(orb, orb)

-- Aviso visual para erros reportados pelo Roblox
pcall(function()
    GuiService.ErrorMessageChanged:Connect(function(message)
        if message and message ~= "" and gui.Parent then
            connectionText.Text = "Erro reportado pelo Roblox"
            connectionText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end)

print("Mhm Gk carregado!")
