
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MhmConnectionMonitor"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 100)
frame.Position = UDim2.new(0.5, -120, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 30)
title.Position = UDim2.new(0, 8, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Mhm Gk | STATUS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -16, 0, 25)
status.Position = UDim2.new(0, 8, 0, 38)
status.BackgroundTransparency = 1
status.Text = "Monitor ativo"
status.TextColor3 = Color3.fromRGB(100, 255, 140)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -16, 0, 25)
button.Position = UDim2.new(0, 8, 0, 68)
button.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
button.Text = "Ver status"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 12
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

button.Activated:Connect(function()
    if game:IsLoaded() and player.Parent then
        status.Text = "Conectado ao jogo"
        status.TextColor3 = Color3.fromRGB(100, 255, 140)
    else
        status.Text = "Conexão indisponível"
        status.TextColor3 = Color3.fromRGB(255, 90, 90)
    end
end)

GuiService.ErrorMessageChanged:Connect(function(message)
    if message and message ~= "" then
        status.Text = "Erro de conexão"
        status.TextColor3 = Color3.fromRGB(255, 90, 90)
    end
end)
