-- ANMOL: LIVING WORLD | Main Menu v0.1
-- Put this LocalScript inside StarterPlayer > StarterPlayerScripts.
-- This is a working menu prototype. Real game mode rules must be validated on the server.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("AnmolLivingWorldMenu")
if previous then previous:Destroy() end

local selectedMode = "Normal"
local reducedMotion = false
local soundEnabled = true
local entered = false

local gui = Instance.new("ScreenGui")
gui.Name = "AnmolLivingWorldMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function rounded(obj, amount)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, amount)
    corner.Parent = obj
end

local function border(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1.5
    stroke.Parent = obj
    return stroke
end

local function label(parent, text, size, y, h, font, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(232, 246, 235)
    l.Font = font or Enum.Font.GothamBold
    l.TextScaled = true
    l.TextWrapped = true
    l.Size = UDim2.new(1, -24, 0, h)
    l.Position = UDim2.new(0, 12, 0, y)
    l.Parent = parent
    return l
end

local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.fromRGB(8, 19, 19)
backdrop.BorderSizePixel = 0
backdrop.Parent = gui

-- Optional: Upload the generated menu art as a Roblox image, then insert its asset ID.
-- Example: background.Image = "rbxassetid://123456789"
local background = Instance.new("ImageLabel")
background.Name = "JungleBackground"
background.BackgroundTransparency = 1
background.Image = "" -- Replace with YOUR Roblox-approved image asset ID
background.ImageTransparency = 0.28
background.ScaleType = Enum.ScaleType.Crop
background.Size = UDim2.fromScale(1, 1)
background.Parent = backdrop

local tint = Instance.new("Frame")
tint.Name = "DarkOverlay"
tint.BackgroundColor3 = Color3.fromRGB(5, 13, 13)
tint.BackgroundTransparency = 0.35
tint.BorderSizePixel = 0
tint.Size = UDim2.fromScale(1, 1)
tint.Parent = backdrop

local panel = Instance.new("Frame")
panel.Name = "MenuPanel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(0.88, 0, 0.82, 0)
panel.BackgroundColor3 = Color3.fromRGB(12, 32, 25)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Parent = backdrop
rounded(panel, 18)
border(panel, Color3.fromRGB(56, 153, 106), 2)

local limit = Instance.new("UISizeConstraint")
limit.MaxSize = Vector2.new(560, 550)
limit.MinSize = Vector2.new(250, 320)
limit.Parent = panel

local heading = label(panel, "ANMOL", 30, 18, 54, Enum.Font.GothamBlack, Color3.fromRGB(235, 249, 239))
local subtitle = label(panel, "L I V I N G   W O R L D", 20, 72, 32, Enum.Font.GothamBold, Color3.fromRGB(95, 245, 129))
label(panel, "The island remembers your choices.", 14, 112, 24, Enum.Font.Gotham, Color3.fromRGB(192, 218, 201))

local container = Instance.new("Frame")
container.BackgroundTransparency = 1
container.Size = UDim2.new(1, -32, 0, 220)
container.Position = UDim2.new(0, 16, 0.43, -12)
container.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

local function makeButton(text, bg, order, height)
    local button = Instance.new("TextButton")
    button.Name = text:gsub("%W", "")
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.TextColor3 = Color3.fromRGB(245, 255, 247)
    button.BackgroundColor3 = bg
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, height or 47)
    button.LayoutOrder = order
    button.AutoButtonColor = true
    button.Parent = container
    rounded(button, 12)
    local stroke = border(button, Color3.fromRGB(88, 120, 95), 1)
    return button, stroke
end

local normalButton, normalStroke = makeButton("NORMAL  -  Respawn enabled", Color3.fromRGB(29, 95, 53), 1, 46)
local hardcoreButton, hardcoreStroke = makeButton("HARDCORE  -  One life", Color3.fromRGB(86, 31, 36), 2, 46)
local playButton = makeButton("PLAY  >", Color3.fromRGB(29, 145, 70), 3, 50)
local settingsButton = makeButton("SETTINGS", Color3.fromRGB(50, 58, 60), 4, 42)

local status = label(panel, "Selected mode: NORMAL", 15, 0, 20, Enum.Font.GothamBold, Color3.fromRGB(153, 249, 181))
status.AnchorPoint = Vector2.new(0, 1)
status.Position = UDim2.new(0, 12, 1, -13)

local function updateMode()
    normalStroke.Color = selectedMode == "Normal" and Color3.fromRGB(126, 255, 149) or Color3.fromRGB(88, 120, 95)
    normalStroke.Thickness = selectedMode == "Normal" and 3 or 1
    hardcoreStroke.Color = selectedMode == "Hardcore" and Color3.fromRGB(255, 98, 98) or Color3.fromRGB(88, 120, 95)
    hardcoreStroke.Thickness = selectedMode == "Hardcore" and 3 or 1
    status.Text = "Selected mode: " .. string.upper(selectedMode)
end
normalButton.MouseButton1Click:Connect(function()
    selectedMode = "Normal"
    updateMode()
end)
hardcoreButton.MouseButton1Click:Connect(function()
    selectedMode = "Hardcore"
    updateMode()
end)

local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Visible = false
settingsPanel.Size = UDim2.new(1, -36, 0, 215)
settingsPanel.Position = UDim2.new(0, 18, 0.4, 0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(14, 40, 36)
settingsPanel.Parent = panel
rounded(settingsPanel, 12)
border(settingsPanel, Color3.fromRGB(112, 164, 130), 1)
label(settingsPanel, "SETTINGS", 24, 10, 36)

local function settingButton(y, text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 44)
    b.Position = UDim2.new(0, 12, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 76, 62)
    b.Text = text
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.fromRGB(240, 255, 241)
    b.Parent = settingsPanel
    rounded(b, 8)
    return b
end
local soundButton = settingButton(55, "UI Sound: ON (future audio)")
local motionButton = settingButton(107, "Reduced motion: OFF")
local backButton = settingButton(160, "BACK")

settingsButton.MouseButton1Click:Connect(function()
    container.Visible = false
    settingsPanel.Visible = true
end)
backButton.MouseButton1Click:Connect(function()
    settingsPanel.Visible = false
    container.Visible = true
end)
soundButton.MouseButton1Click:Connect(function()
    soundEnabled = not soundEnabled
    soundButton.Text = soundEnabled and "UI Sound: ON (future audio)" or "UI Sound: OFF"
end)
motionButton.MouseButton1Click:Connect(function()
    reducedMotion = not reducedMotion
    motionButton.Text = reducedMotion and "Reduced motion: ON" or "Reduced motion: OFF"
end)

playButton.MouseButton1Click:Connect(function()
    if entered then return end
    entered = true
    -- Local-only demo: server must authoritatively assign and validate modes.
    player:SetAttribute("AnmolMenuModePreview", selectedMode)
    playButton.Text = "ENTERING " .. string.upper(selectedMode) .. "..."
    if reducedMotion then
        gui.Enabled = false
    else
        local animation = TweenService:Create(panel, TweenInfo.new(0.35), {BackgroundTransparency = 1})
        animation:Play()
        animation.Completed:Wait()
        gui.Enabled = false
    end
    print("[Anmol Living World] Menu preview selected:", selectedMode)
end)

updateMode()
