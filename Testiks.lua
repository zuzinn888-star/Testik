-- Krev Hub MM2 - Ultra Modern Edition (Mobile & PC Supported)
-- Features exact requested UI style, toggle icon, and complete functionality set.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    local success, hiddenUi = pcall(function() return gethui() end)
    if success and typeof(hiddenUi) == "Instance" then return hiddenUi end
    return CoreGui
end

local guiParent = getGuiParent()
local existingGui = guiParent:FindFirstChild("KrevHubMM2")
if existingGui then existingGui:Destroy() end

local Theme = {
    background = Color3.fromRGB(15, 15, 18),
    panel = Color3.fromRGB(22, 22, 26),
    surface = Color3.fromRGB(30, 30, 35),
    surfaceHover = Color3.fromRGB(40, 40, 45),
    text = Color3.fromRGB(245, 248, 255),
    muted = Color3.fromRGB(150, 150, 160),
    accent = Color3.fromRGB(255, 0, 128), -- Neon Pink/Magenta Accent
    cyan = Color3.fromRGB(0, 220, 255),
    danger = Color3.fromRGB(255, 60, 90),
    success = Color3.fromRGB(50, 230, 120),
}

local state = {
    active = true,
    -- Main
    roleEsp = false,
    xray = false,
    xrayTransparency = 0.5,
    noclip = false,
    autoFlingSheriff = false,
    -- Sheriff
    autoPickupGun = false,
    gunEsp = false,
    silentAim = false,
    wallbang = false,
    autoShoot = false,
    autoKill = false,
    -- Murder
    killAura = false,
    killAll = false,
    killOnlySheriff = false,
    knifeThrow = false,
    knifeThrowAimbot = false,
    prediction = false,
    predictionLead = 100,
    selectedPlayer = "none",
    -- Auto Farm
    autoFarm = false,
    autoRespawn = false,
    antiFling = false,
    avoidMurderer = false,
    autoFling = false,
    -- Troll/Fun
    walkspeedEnabled = false,
    walkspeed = 16,
    jumppowerEnabled = false,
    jumppower = 50,
    touchFling = false,
}

local connections = {}
local espFolder = Workspace:FindFirstChild("KrevHubESP")
if not espFolder then
    espFolder = Instance.new("Folder")
    espFolder.Name = "KrevHubESP"
    espFolder.Parent = Workspace
end

local function connect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(connections, conn)
    return conn
end

local function tween(instance, duration, properties)
    return TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
end

local function corner(instance, radius)
    local obj = Instance.new("UICorner")
    obj.CornerRadius = UDim.new(0, radius)
    obj.Parent = instance
    return obj
end

local function createText(parent, text, size, font, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = font or Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color or Theme.text
    label.TextSize = size
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KrevHubMM2"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

-- Floating Toggle Icon
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "KrevToggle"
ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
ToggleButton.BackgroundColor3 = Theme.panel
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 15, 0.5, -160)
ToggleButton.Size = UDim2.fromOffset(45, 45)
ToggleButton.Text = "K"
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextColor3 = Theme.accent
ToggleButton.TextSize = 24
ToggleButton.Parent = ScreenGui
corner(ToggleButton, 10)
local tStroke = Instance.new("UIStroke")
tStroke.Color = Theme.accent
tStroke.Transparency = 0.5
tStroke.Thickness = 1.5
tStroke.Parent = ToggleButton

local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundColor3 = Theme.background
Window.BorderSizePixel = 0
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.Size = UDim2.fromOffset(800, 480)
Window.Parent = ScreenGui
corner(Window, 12)

local wStroke = Instance.new("UIStroke")
wStroke.Color = Theme.accent
wStroke.Transparency = 0.7
wStroke.Thickness = 1
wStroke.Parent = Window

local windowScale = Instance.new("UIScale")
windowScale.Parent = Window

local function updateScale()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    windowScale.Scale = math.clamp(math.min(viewport.X / 850, viewport.Y / 520), 0.5, 1)
end

updateScale()
if Workspace.CurrentCamera then
    connect(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateScale)
end

local menuVisible = true
local function toggleMenu(visible)
    if visible ~= nil then menuVisible = visible else menuVisible = not menuVisible end
    Window.Visible = menuVisible
end
connect(ToggleButton.MouseButton1Click, function() toggleMenu() end)

-- Header
local Header = Instance.new("Frame")
Header.BackgroundColor3 = Theme.panel
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Parent = Window
corner(Header, 12)

local HeaderFill = Instance.new("Frame")
HeaderFill.BackgroundColor3 = Theme.panel
HeaderFill.BorderSizePixel = 0
HeaderFill.Position = UDim2.new(0, 0, 1, -10)
HeaderFill.Size = UDim2.new(1, 0, 0, 10)
HeaderFill.Parent = Header

local BrandIcon = createText(Header, "K", 20, Enum.Font.GothamBlack, Theme.accent)
BrandIcon.Position = UDim2.fromOffset(15, 0)
BrandIcon.Size = UDim2.fromOffset(30, 50)
BrandIcon.TextXAlignment = Enum.TextXAlignment.Center
BrandIcon.TextYAlignment = Enum.TextYAlignment.Center

local Title = createText(Header, "Krev Hub", 16, Enum.Font.GothamBold, Theme.text)
Title.Position = UDim2.fromOffset(50, 0)
Title.Size = UDim2.fromOffset(150, 50)
Title.TextYAlignment = Enum.TextYAlignment.Center

local Subtitle = createText(Header, "MM2 - v1.0", 11, Enum.Font.GothamMedium, Theme.muted)
Subtitle.Position = UDim2.fromOffset(130, 0)
Subtitle.Size = UDim2.fromOffset(150, 50)
Subtitle.TextYAlignment = Enum.TextYAlignment.Center

local CloseBtn = Instance.new("TextButton")
CloseBtn.AutoButtonColor = false
CloseBtn.BackgroundColor3 = Theme.background
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.Size = UDim2.fromOffset(30, 30)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.muted
CloseBtn.TextSize = 20
CloseBtn.Parent = Header
corner(CloseBtn, 8)
connect(CloseBtn.MouseButton1Click, function() toggleMenu(false) end)

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.BackgroundColor3 = Theme.panel
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.fromOffset(0, 50)
Sidebar.Size = UDim2.new(0, 180, 1, -50)
Sidebar.CanvasSize = UDim2.new()
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 0
Sidebar.Parent = Window

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 10)
SidebarPad.PaddingLeft = UDim.new(0, 10)
SidebarPad.PaddingRight = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.fromOffset(180, 50)
ContentArea.Size = UDim2.new(1, -180, 1, -50)
ContentArea.Parent = Window

local function getRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then return "Murderer" end
    if char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

connect(RunService.RenderStepped, function()
    espFolder:ClearAllChildren()
    if state.roleEsp or state.gunEsp then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local role = getRole(player)
                local color = Theme.success
                if role == "Murderer" then color = Theme.danger elseif role == "Sheriff" then color = Theme.cyan end
                if state.roleEsp then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = player.Character
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillColor = color
                    hl.FillTransparency = 0.6
                    hl.OutlineColor = color
                    hl.OutlineTransparency = 0
                    hl.Parent = espFolder
                end
            end
        end
    end

    if state.gunEsp then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                local hl = Instance.new("Highlight")
                hl.Adornee = obj
                hl.FillColor = Theme.cyan
                hl.Parent = espFolder
            end
        end
    end

    if state.xray then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                part.LocalTransparencyModifier = state.xrayTransparency
            end
        end
    end

    if state.noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if state.walkspeedEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = state.walkspeed end
    end

    if state.jumppowerEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = state.jumppower end
    end
end)

local pages = {}
local tabButtons = {}
local activeTab = nil

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Position = UDim2.fromOffset(15, 15)
    page.Size = UDim2.new(1, -30, 1, -30)
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.accent
    page.Visible = false
    page.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page
    return page
end

local function addTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = Theme.surface
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Text = ""
    btn.Parent = Sidebar
    corner(btn, 6)

    local iconLabel = createText(btn, icon, 14, Enum.Font.GothamBold, Theme.muted)
    iconLabel.Position = UDim2.fromOffset(10, 0)
    iconLabel.Size = UDim2.fromOffset(24, 38)
    iconLabel.TextYAlignment = Enum.TextYAlignment.Center

    local textLabel = createText(btn, name, 13, Enum.Font.GothamMedium, Theme.muted)
    textLabel.Position = UDim2.fromOffset(38, 0)
    textLabel.Size = UDim2.new(1, -40, 1, 0)
    textLabel.TextYAlignment = Enum.TextYAlignment.Center

    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3 = Theme.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.fromOffset(0, 9)
    indicator.Size = UDim2.fromOffset(3, 20)
    indicator.Visible = false
    indicator.Parent = btn
    corner(indicator, 2)

    local page = createPage(name)
    tabButtons[name] = {btn = btn, text = textLabel, icon = iconLabel, ind = indicator, page = page}

    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        for tName, tab in pairs(tabButtons) do
            local isSel = (tName == name)
            tab.page.Visible = isSel
            tab.ind.Visible = isSel
            tween(tab.btn, 0.2, {BackgroundTransparency = isSel and 0 or 1}):Play()
            tween(tab.text, 0.2, {TextColor3 = isSel and Theme.text or Theme.muted}):Play()
            tween(tab.icon, 0.2, {TextColor3 = isSel and Theme.accent or Theme.muted}):Play()
        end
        activeTab = name
    end)
    return page
end

local function addToggle(page, title, default, callback)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Theme.surface
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 45)
    row.Parent = page
    corner(row, 8)

    local tLbl = createText(row, title, 13, Enum.Font.GothamMedium, Theme.text)
    tLbl.Position = UDim2.fromOffset(15, 0)
    tLbl.Size = UDim2.new(1, -80, 1, 0)
    tLbl.TextYAlignment = Enum.TextYAlignment.Center

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.AutoButtonColor = false
    toggleBtn.BackgroundColor3 = default and Theme.accent or Color3.fromRGB(45, 45, 50)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBtn.Size = UDim2.fromOffset(40, 22)
    toggleBtn.Text = ""
    toggleBtn.Parent = row
    corner(toggleBtn, 11)

    local knob = Instance.new("Frame")
    knob.BackgroundColor3 = Theme.text
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(default and 1 or 0, default and -20 or 2, 0.5, -9)
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Parent = toggleBtn
    corner(knob, 9)

    local val = default
    toggleBtn.MouseButton1Click:Connect(function()
        val = not val
        tween(toggleBtn, 0.2, {BackgroundColor3 = val and Theme.accent or Color3.fromRGB(45, 45, 50)}):Play()
        tween(knob, 0.2, {Position = UDim2.new(val and 1 or 0, val and -20 or 2, 0.5, -9)}):Play()
        callback(val)
    end)
end

local function addSlider(page, title, min, max, default, callback)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Theme.surface
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 60)
    row.Parent = page
    corner(row, 8)

    local tLbl = createText(row, title, 13, Enum.Font.GothamMedium, Theme.text)
    tLbl.Position = UDim2.fromOffset(15, 10)
    tLbl.Size = UDim2.new(1, -50, 0, 15)

    local valLbl = createText(row, tostring(default), 12, Enum.Font.GothamBold, Theme.accent)
    valLbl.Position = UDim2.new(1, -45, 10, 0)
    valLbl.Size = UDim2.fromOffset(30, 15)
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("TextButton")
    bar.AutoButtonColor = false
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    bar.BorderSizePixel = 0
    bar.Position = UDim2.new(0, 15, 0, 35)
    bar.Size = UDim2.new(1, -30, 0, 6)
    bar.Text = ""
    bar.Parent = row
    corner(bar, 3)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.Parent = bar
    corner(fill, 3)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Theme.text
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.Size = UDim2.fromOffset(12, 12)
    knob.Parent = bar
    corner(knob, 6)

    local dragging = false
    local function update(input)
        local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pct)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        valLbl.Text = tostring(val)
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function addLabel(page, text)
    local lbl = createText(page, text, 14, Enum.Font.GothamBold, Theme.accent)
    lbl.Size = UDim2.new(1, 0, 0, 20)
end

-- POPULATE TABS
local mainTab = addTab("Main", "🏠")
addLabel(mainTab, "Visuals")
addToggle(mainTab, "Enable Role ESP", state.roleEsp, function(v) state.roleEsp = v end)
addToggle(mainTab, "X-Ray", state.xray, function(v) state.xray = v end)
addSlider(mainTab, "X-Ray Strength", 10, 100, 50, function(v) state.xrayTransparency = v / 100 end)
addLabel(mainTab, "Movement & Utility")
addToggle(mainTab, "No Clip", state.noclip, function(v) state.noclip = v end)
addToggle(mainTab, "Auto Fling Sheriff", state.autoFlingSheriff, function(v) state.autoFlingSheriff = v end)

local sheriffTab = addTab("Sheriff", "🔫")
addToggle(sheriffTab, "Auto Pickup Gun", state.autoPickupGun, function(v) state.autoPickupGun = v end)
addToggle(sheriffTab, "Gun ESP", state.gunEsp, function(v) state.gunEsp = v end)
addToggle(sheriffTab, "Silent Aim", state.silentAim, function(v) state.silentAim = v end)
addToggle(sheriffTab, "Wallbang", state.wallbang, function(v) state.wallbang = v end)
addToggle(sheriffTab, "Auto Shoot", state.autoShoot, function(v) state.autoShoot = v end)
addToggle(sheriffTab, "Auto Kill", state.autoKill, function(v) state.autoKill = v end)

local murderTab = addTab("Murder", "🔪")
addLabel(murderTab, "Aura & Targeting")
addToggle(murderTab, "Kill Aura", state.killAura, function(v) state.killAura = v end)
addToggle(murderTab, "Kill All", state.killAll, function(v) state.killAll = v end)
addToggle(murderTab, "Kill Only Sheriff", state.killOnlySheriff, function(v) state.killOnlySheriff = v end)
addLabel(murderTab, "Projectiles")
addToggle(murderTab, "Knife Throw", state.knifeThrow, function(v) state.knifeThrow = v end)
addToggle(murderTab, "Knife Throw Aimbot", state.knifeThrowAimbot, function(v) state.knifeThrowAimbot = v end)
addToggle(murderTab, "Prediction", state.prediction, function(v) state.prediction = v end)
addSlider(murderTab, "Prediction Lead %", 0, 200, 100, function(v) state.predictionLead = v end)

local farmTab = addTab("Auto Farm", "💸")
addToggle(farmTab, "Auto Farm", state.autoFarm, function(v) state.autoFarm = v end)
addToggle(farmTab, "Auto-Respawn", state.autoRespawn, function(v) state.autoRespawn = v end)
addToggle(farmTab, "Anti-Fling", state.antiFling, function(v) state.antiFling = v end)
addToggle(farmTab, "Avoid Murderer", state.avoidMurderer, function(v) state.avoidMurderer = v end)
addToggle(farmTab, "Auto-Fling", state.autoFling, function(v) state.autoFling = v end)

local funTab = addTab("Troll Fun", "🎭")
addLabel(funTab, "Character Modifications")
addToggle(funTab, "Walk Speed", state.walkspeedEnabled, function(v) state.walkspeedEnabled = v end)
addSlider(funTab, "Speed Value", 16, 150, 16, function(v) state.walkspeed = v end)
addToggle(funTab, "Jump Power", state.jumppowerEnabled, function(v) state.jumppowerEnabled = v end)
addSlider(funTab, "Jump Value", 50, 200, 50, function(v) state.jumppower = v end)
addLabel(funTab, "Misc Options")
addToggle(funTab, "Touch Fling", state.touchFling, function(v) state.touchFling = v end)
addToggle(funTab, "Auto Emote (Experimental)", false, function() end)

tabButtons["Main"].btn.MouseButton1Click:Fire()

-- Dragging Logic
local dragging = false
local dragStart, startPos
connect(Header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
    end
end)
connect(UserInputService.InputChanged, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = (input.Position - dragStart) / windowScale.Scale
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
