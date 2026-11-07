
-- 배긴표 수쿠립뚜
-- Roblox Studio LocalScript
-- 위치: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 설정
local ESP_ENABLED = true
local AIM_ENABLED = false
local RANGE_ENABLED = true
local AIM_RANGE = 120

-- GUI 생성
local gui = Instance.new("ScreenGui")
gui.Name = "BaeginScript"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- 로딩 화면
local loading = Instance.new("Frame")
loading.Size = UDim2.fromScale(1, 1)
loading.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
loading.Parent = gui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.fromScale(1, 0.1)
loadingText.Position = UDim2.fromScale(0, 0.4)
loadingText.BackgroundTransparency = 1
loadingText.Text = "로딩중..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.TextScaled = true
loadingText.Parent = loading

local subText = Instance.new("TextLabel")
subText.Size = UDim2.fromScale(1, 0.06)
subText.Position = UDim2.fromScale(0, 0.51)
subText.BackgroundTransparency = 1
subText.Text = "배긴표 수쿠립뚜"
subText.TextColor3 = Color3.new(1, 1, 1)
subText.TextScaled = true
subText.Parent = loading

task.wait(1.5)
loading:Destroy()

-- 메인 UI
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 430)
main.Position = UDim2.new(0.5, -170, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
title.Text = "배긴표 수쿠립뚜"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local function createToggle(name, description, y, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 76)
    frame.Position = UDim2.fromOffset(10, y)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    frame.Parent = main

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 0, 30)
    label.Position = UDim2.fromOffset(10, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 17
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(0.95, 0, 0, 30)
    desc.Position = UDim2.fromOffset(10, 38)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(190, 190, 190)
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(65, 30)
    button.Position = UDim2.new(1, -75, 0, 8)
    button.BackgroundColor3 = Color3.fromRGB(80, 150, 90)
    button.Text = "ON"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Parent = frame

    local enabled = true

    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.Text = enabled and "ON" or "OFF"
        button.BackgroundColor3 = enabled
            and Color3.fromRGB(80, 150, 90)
            or Color3.fromRGB(140, 65, 65)

        callback(enabled)
    end)
end

-- ESP
local highlights = {}

local function addESP(target)
    if target == player then return end

    local function apply(character)
        if highlights[target] then
            highlights[target]:Destroy()
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.8
        highlight.Adornee = character
        highlight.Parent = character

        highlights[target] = highlight
    end

    if target.Character then
        apply(target.Character)
    end

    target.CharacterAdded:Connect(apply)
end

for _, target in ipairs(Players:GetPlayers()) do
    addESP(target)
end

Players.PlayerAdded:Connect(addESP)

createToggle(
    "ESP",
    "플레이어 캐릭터 외곽선을 표시합니다.",
    65,
    function(value)
        ESP_ENABLED = value

        for _, highlight in pairs(highlights) do
            highlight.Enabled = value
        end
    end
)

createToggle(
    "AIMbot",
    "연습용 NPC 조준 보조 기능입니다.",
    150,
    function(value)
        AIM_ENABLED = value
    end
)

createToggle(
    "Aim 범위 표시",
    "화면 중앙에 조준 범위를 표시합니다.",
    235,
    function(value)
        RANGE_ENABLED = value
    end
)

-- FOV 원
local circle = Instance.new("Frame")
circle.Name = "AimRange"
circle.Size = UDim2.fromOffset(AIM_RANGE * 2, AIM_RANGE * 2)
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.Parent = gui

Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.new(1, 1, 1)
stroke.Thickness = 2
stroke.Parent = circle

-- 범위 크기 슬라이더
local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, -20, 0, 25)
rangeLabel.Position = UDim2.fromOffset(10, 320)
rangeLabel.BackgroundTransparency = 1
rangeLabel.Text = "Aim 범위 크기: 120"
rangeLabel.TextColor3 = Color3.new(1, 1, 1)
rangeLabel.TextSize = 15
rangeLabel.Parent = main

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(1, -30, 0, 12)
slider.Position = UDim2.fromOffset(15, 360)
slider.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
slider.Text = ""
slider.Parent = main

local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(16, 16)
knob.Position = UDim2.new(0.35, -8, 0.5, -8)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.Parent = slider
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local dragging = false

slider.MouseButton1Down:Connect(function()
    dragging = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local x = math.clamp(
            (input.Position.X - slider.AbsolutePosition.X) /
            slider.AbsoluteSize.X,
            0, 1
        )

        knob.Position = UDim2.new(x, -8, 0.5, -8)
        AIM_RANGE = math.floor(50 + x * 250)
        rangeLabel.Text = "Aim 범위 크기: " .. AIM_RANGE
        circle.Size = UDim2.fromOffset(AIM_RANGE * 2, AIM_RANGE * 2)
    end
end)

local camera = workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    circle.Visible = RANGE_ENABLED
    circle.Position = UDim2.fromOffset(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2
    )
end)
