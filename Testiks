-- Krev Hub Neon Edition (Overhauled Design)
-- Client-side interface for a Roblox environment with game services enabled.

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
    local success, hiddenUi = pcall(function()
        return gethui()
    end)

    if success and typeof(hiddenUi) == "Instance" then
        return hiddenUi
    end

    return CoreGui
end

local guiParent = getGuiParent()
local existingGui = guiParent:FindFirstChild("KrevHubNeon")
if existingGui then
    existingGui:Destroy()
end

local Colors = {
    background = Color3.fromRGB(7, 9, 15),
    panel = Color3.fromRGB(13, 16, 26),
    surface = Color3.fromRGB(20, 24, 38),
    surfaceHover = Color3.fromRGB(28, 33, 52),
    text = Color3.fromRGB(250, 252, 255),
    muted = Color3.fromRGB(140, 150, 180),
    accent = Color3.fromRGB(120, 70, 255),
    accentGradient1 = Color3.fromRGB(140, 60, 255),
    accentGradient2 = Color3.fromRGB(0, 240, 255),
    cyan = Color3.fromRGB(0, 224, 255),
    danger = Color3.fromRGB(255, 75, 110),
    success = Color3.fromRGB(50, 245, 160),
}

local state = {
    active = true,
    fly = false,
    spin = false,
    bhop = false,
    autoFarm = false,
    gunSnatcher = false,
    esp = false,
    fling = false,
    invisible = false,
    flySpeed = 60,
    spinSpeed = 14,
    bhopPower = 5,
}

local heldKeys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false,
}

local connections = {}
local invisibleParts = {}
local flyHumanoid = nil
local flyAutoRotate = nil
local lastBhop = 0

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function tween(instance, duration, properties)
    return TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), properties)
end

local function corner(instance, radius)
    local object = Instance.new("UICorner")
    object.CornerRadius = UDim.new(0, radius)
    object.Parent = instance
    return object
end

local function stroke(instance, color, transparency, thickness)
    local object = Instance.new("UIStroke")
    object.Color = color
    object.Transparency = transparency or 0.5
    object.Thickness = thickness or 1
    object.Parent = instance
    return object
end

local function createText(parent, text, size, font, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = font or Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color or Colors.text
    label.TextSize = size
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KrevHubNeon"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundColor3 = Colors.background
Window.BorderSizePixel = 0
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.Size = UDim2.fromOffset(860, 540)
Window.Parent = ScreenGui
corner(Window, 22)
stroke(Window, Color3.fromRGB(120, 90, 255), 0.4, 1.5)

local WindowGlow = Instance.new("UIStroke")
WindowGlow.Color = Colors.accent
WindowGlow.Transparency = 0.8
WindowGlow.Thickness = 6
WindowGlow.Parent = Window

local windowScale = Instance.new("UIScale")
windowScale.Parent = Window

local function updateWindowScale()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    windowScale.Scale = math.clamp(math.min(viewport.X / 920, viewport.Y / 600), 0.55, 1)
end

updateWindowScale()
if Workspace.CurrentCamera then
    connect(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateWindowScale)
end

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Colors.panel
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 75)
Header.Parent = Window
corner(Header, 22)

local HeaderFill = Instance.new("Frame")
HeaderFill.BackgroundColor3 = Colors.panel
HeaderFill.BorderSizePixel = 0
HeaderFill.Position = UDim2.new(0, 0, 1, -20)
HeaderFill.Size = UDim2.new(1, 0, 0, 20)
HeaderFill.Parent = Header

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 25, 110)),
    ColorSequenceKeypoint.new(0.5, Colors.panel),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 60, 90)),
})
HeaderGradient.Rotation = 10
HeaderGradient.Parent = Header

local BrandMark = Instance.new("Frame")
BrandMark.BackgroundColor3 = Colors.accent
BrandMark.BorderSizePixel = 0
BrandMark.Position = UDim2.fromOffset(22, 17)
BrandMark.Size = UDim2.fromOffset(40, 40)
BrandMark.Parent = Header
corner(BrandMark, 14)

local BrandMarkStroke = stroke(BrandMark, Colors.cyan, 0.3, 1)

local BrandGradient = Instance.new("UIGradient")
BrandGradient.Color = ColorSequence.new(Colors.accentGradient1, Colors.accentGradient2)
BrandGradient.Rotation = 45
BrandGradient.Parent = BrandMark

local BrandText = createText(BrandMark, "K", 21, Enum.Font.GothamBlack, Colors.text)
BrandText.Size = UDim2.new(1, 0, 1, 0)
BrandText.TextXAlignment = Enum.TextXAlignment.Center
BrandText.TextYAlignment = Enum.TextYAlignment.Center

local Title = createText(Header, "KREV HUB", 21, Enum.Font.GothamBold, Colors.text)
Title.Position = UDim2.fromOffset(78, 16)
Title.Size = UDim2.fromOffset(240, 24)

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 190, 230))
TitleGradient.Parent = Title

local Subtitle = createText(Header, "MM2  •  NEXT-GEN EDITION", 11, Enum.Font.GothamMedium, Colors.muted)
Subtitle.Position = UDim2.fromOffset(79, 43)
Subtitle.Size = UDim2.fromOffset(250, 16)

local StatusDot = Instance.new("Frame")
StatusDot.BackgroundColor3 = Colors.success
StatusDot.BorderSizePixel = 0
StatusDot.Position = UDim2.new(1, -210, 0, 31)
StatusDot.Size = UDim2.fromOffset(8, 8)
StatusDot.Parent = Header
corner(StatusDot, 8)
stroke(StatusDot, Colors.success, 0.2, 1)

local Status = createText(Header, "SECURE ONLINE", 11, Enum.Font.GothamBold, Colors.success)
Status.Position = UDim2.new(1, -195, 0, 25)
Status.Size = UDim2.fromOffset(100, 20)

local CloseButton = Instance.new("TextButton")
CloseButton.AutoButtonColor = false
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 22, 35)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Position = UDim2.new(1, -65, 0, 18)
CloseButton.Size = UDim2.fromOffset(38, 38)
CloseButton.Text = "×"
CloseButton.TextColor3 = Colors.danger
CloseButton.TextSize = 26
CloseButton.Parent = Header
corner(CloseButton, 12)
stroke(CloseButton, Colors.danger, 0.4, 1)

connect(CloseButton.MouseEnter, function()
    tween(CloseButton, 0.2, { BackgroundColor3 = Colors.danger, TextColor3 = Colors.text }):Play()
end)
connect(CloseButton.MouseLeave, function()
    tween(CloseButton, 0.2, { BackgroundColor3 = Color3.fromRGB(45, 22, 35), TextColor3 = Colors.danger }):Play()
end)

local Sidebar = Instance.new("Frame")
Sidebar.BackgroundColor3 = Colors.panel
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.fromOffset(0, 75)
Sidebar.Size = UDim2.new(0, 230, 1, -75)
Sidebar.Parent = Window

local SideDivider = Instance.new("Frame")
SideDivider.BackgroundColor3 = Colors.accent
SideDivider.BackgroundTransparency = 0.8
SideDivider.BorderSizePixel = 0
SideDivider.Position = UDim2.new(1, -1, 0, 10)
SideDivider.Size = UDim2.new(0, 1, 1, -20)
SideDivider.Parent = Sidebar

local TabList = Instance.new("ScrollingFrame")
TabList.BackgroundTransparency = 1
TabList.Position = UDim2.fromOffset(12, 16)
TabList.Size = UDim2.new(1, -24, 1, -106)
TabList.CanvasSize = UDim2.new()
TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabList.ScrollBarThickness = 2
TabList.ScrollBarImageColor3 = Colors.accent
TabList.Parent = Sidebar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 6)
TabLayout.Parent = TabList

local BottomCard = Instance.new("Frame")
BottomCard.BackgroundColor3 = Colors.surface
BottomCard.BorderSizePixel = 0
BottomCard.Position = UDim2.new(0, 12, 1, -82)
BottomCard.Size = UDim2.new(1, -24, 0, 66)
BottomCard.Parent = Sidebar
corner(BottomCard, 14)
stroke(BottomCard, Colors.accent, 0.6, 1)

local PlayerAvatar = Instance.new("Frame")
PlayerAvatar.BackgroundColor3 = Colors.accentDark
PlayerAvatar.BorderSizePixel = 0
PlayerAvatar.Position = UDim2.fromOffset(11, 13)
PlayerAvatar.Size = UDim2.fromOffset(40, 40)
PlayerAvatar.Parent = BottomCard
corner(PlayerAvatar, 20)

local AvatarText = createText(PlayerAvatar, "P", 16, Enum.Font.GothamBold, Colors.text)
AvatarText.Size = UDim2.fromScale(1, 1)
AvatarText.TextXAlignment = Enum.TextXAlignment.Center
AvatarText.TextYAlignment = Enum.TextYAlignment.Center

local PlayerName = createText(BottomCard, LocalPlayer.DisplayName, 12, Enum.Font.GothamBold, Colors.text)
PlayerName.Position = UDim2.fromOffset(60, 15)
PlayerName.Size = UDim2.new(1, -70, 0, 18)
PlayerName.TextTruncate = Enum.TextTruncate.AtEnd

local PlayerHandle = createText(BottomCard, "@" .. LocalPlayer.Name, 10, Enum.Font.GothamMedium, Colors.muted)
PlayerHandle.Position = UDim2.fromOffset(60, 34)
PlayerHandle.Size = UDim2.new(1, -70, 0, 16)
PlayerHandle.TextTruncate = Enum.TextTruncate.AtEnd

local Content = Instance.new("Frame")
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(230, 75)
Content.Size = UDim2.new(1, -230, 1, -75)
Content.Parent = Window

local PageContainer = Instance.new("Frame")
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.fromOffset(26, 22)
PageContainer.Size = UDim2.new(1, -52, 1, -44)
PageContainer.Parent = Content

local ToastHolder = Instance.new("Frame")
ToastHolder.AnchorPoint = Vector2.new(1, 0)
ToastHolder.BackgroundTransparency = 1
ToastHolder.Position = UDim2.new(1, -24, 0, 22)
ToastHolder.Size = UDim2.fromOffset(300, 240)
ToastHolder.Parent = ScreenGui

local ToastLayout = Instance.new("UIListLayout")
ToastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ToastLayout.Padding = UDim.new(0, 10)
ToastLayout.Parent = ToastHolder

local function notify(title, message, color)
    local toast = Instance.new("Frame")
    toast.BackgroundColor3 = Colors.panel
    toast.BackgroundTransparency = 0.05
    toast.BorderSizePixel = 0
    toast.Size = UDim2.fromOffset(300, 0)
    toast.AutomaticSize = Enum.AutomaticSize.Y
    toast.Parent = ToastHolder
    corner(toast, 14)
    stroke(toast, color or Colors.cyan, 0.3, 1)

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 14)
    padding.PaddingLeft = UDim.new(0, 16)
    padding.PaddingRight = UDim.new(0, 16)
    padding.PaddingTop = UDim.new(0, 14)
    padding.Parent = toast

    local titleLabel = createText(toast, title, 13, Enum.Font.GothamBold, color or Colors.cyan)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)

    local messageLabel = createText(toast, message, 11, Enum.Font.GothamMedium, Colors.text)
    messageLabel.AutomaticSize = Enum.AutomaticSize.Y
    messageLabel.Position = UDim2.fromOffset(0, 22)
    messageLabel.Size = UDim2.new(1, 0, 0, 0)
    messageLabel.TextWrapped = true

    task.delay(4, function()
        if toast.Parent then
            local animation = tween(toast, 0.3, { BackgroundTransparency = 1 })
            animation:Play()
            task.wait(0.35)
            toast:Destroy()
        end
    end)
end

local function getCharacterData()
    local character = LocalPlayer.Character
    if not character then return nil, nil, nil end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return character, rootPart, humanoid
end

local function resetFly()
    if flyHumanoid and flyHumanoid.Parent then
        flyHumanoid.PlatformStand = false
        if flyAutoRotate ~= nil then
            flyHumanoid.AutoRotate = flyAutoRotate
        end
    end
    flyHumanoid = nil
    flyAutoRotate = nil
end

local function clearInvisibility()
    for part, transparency in pairs(invisibleParts) do
        if part and part.Parent then
            part.LocalTransparencyModifier = transparency
        end
    end
    invisibleParts = {}
end

local function setInvisibility(enabled)
    clearInvisibility()
    if not enabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            invisibleParts[descendant] = descendant.LocalTransparencyModifier
            descendant.LocalTransparencyModifier = 1
        end
    end
end

local espFolder = Workspace:FindFirstChild("KrevHubNeonESP")
if not espFolder then
    espFolder = Instance.new("Folder")
    espFolder.Name = "KrevHubNeonESP"
    espFolder.Parent = Workspace
end

local function clearESP()
    espFolder:ClearAllChildren()
end

local function getRole(player)
    local character = player.Character
    if not character then return "Innocent" end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    end
    if character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

local function updateESP()
    clearESP()
    if not state.esp then return end
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if player ~= LocalPlayer and character and character:FindFirstChild("HumanoidRootPart") then
            local role = getRole(player)
            local color = Color3.fromRGB(87, 226, 142)

            if role == "Murderer" then
                color = Colors.danger
            elseif role == "Sheriff" then
                color = Colors.cyan
            end

            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = color
            highlight.FillTransparency = 0.55
            highlight.OutlineColor = color
            highlight.OutlineTransparency = 0
            highlight.Parent = espFolder
        end
    end
end

local function findGunDrop()
    local directDrop = Workspace:FindFirstChild("GunDrop")
    if directDrop and directDrop:IsA("BasePart") then return directDrop end
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object.Name == "GunDrop" and object:IsA("BasePart") then
            return object
        end
    end
end

local function getCoinParts()
    local coins = {}
    local containers = {}
    for _, name in ipairs({ "Normal", "CoinContainer", "Coins" }) do
        local container = Workspace:FindFirstChild(name)
        if container then table.insert(containers, container) end
    end
    for _, container in ipairs(containers) do
        if container then
            for _, object in ipairs(container:GetDescendants()) do
                if object:IsA("BasePart") then
                    local name = object.Name:lower()
                    if name:find("coin") or object:FindFirstChildOfClass("TouchTransmitter") then
                        table.insert(coins, object)
                    end
                end
            end
        end
    end
    return coins
end

local function touchPart(rootPart, target)
    if type(firetouchinterest) == "function" then
        pcall(firetouchinterest, rootPart, target, 0)
        pcall(firetouchinterest, rootPart, target, 1)
        return
    end
    rootPart.CFrame = target.CFrame
end

connect(UserInputService.InputBegan, function(input, gameProcessed)
    if gameProcessed then return end
    local keyName = input.KeyCode and input.KeyCode.Name
    if keyName and heldKeys[keyName] ~= nil then
        heldKeys[keyName] = true
    end
end)

connect(UserInputService.InputEnded, function(input)
    local keyName = input.KeyCode and input.KeyCode.Name
    if keyName and heldKeys[keyName] ~= nil then
        heldKeys[keyName] = false
    end
end)

connect(LocalPlayer.CharacterAdded, function()
    resetFly()
    invisibleParts = {}
    if state.invisible then
        task.defer(function() setInvisibility(true) end)
    end
end)

connect(RunService.RenderStepped, function(deltaTime)
    if not state.active then return end
    local character, rootPart, humanoid = getCharacterData()
    if not character or not rootPart or not humanoid then return end

    if state.fly then
        if flyHumanoid and flyHumanoid ~= humanoid then resetFly() end
        if not flyHumanoid then
            flyHumanoid = humanoid
            flyAutoRotate = humanoid.AutoRotate
        end
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false

        local direction = Vector3.zero
        local camera = Workspace.CurrentCamera
        if camera then
            local cameraFrame = camera.CFrame
            if heldKeys.W then direction += cameraFrame.LookVector end
            if heldKeys.S then direction -= cameraFrame.LookVector end
            if heldKeys.A then direction -= cameraFrame.RightVector end
            if heldKeys.D then direction += cameraFrame.RightVector end
        end
        if heldKeys.Space then direction += Vector3.yAxis end
        if heldKeys.LeftShift then direction -= Vector3.yAxis end

        rootPart.AssemblyLinearVelocity = direction.Magnitude > 0 and direction.Unit * state.flySpeed or Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
    elseif flyHumanoid then
        resetFly()
    end

    if state.spin and not state.fling then
        rootPart.CFrame *= CFrame.Angles(0, math.rad(state.spinSpeed * 10) * deltaTime, 0)
    end

    if state.bhop and humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial ~= Enum.Material.Air then
        local now = os.clock()
        if now - lastBhop >= 0.14 then
            lastBhop = now
            humanoid.Jump = true
            rootPart.AssemblyLinearVelocity += humanoid.MoveDirection * state.bhopPower
        end
    end

    if state.fling then
        rootPart.AssemblyLinearVelocity = Vector3.new(50000, 50000, 50000)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 50000, 0)
    end
end)

task.spawn(function()
    while state.active do
        task.wait(0.15)
        if state.gunSnatcher then
            local _, rootPart = getCharacterData()
            local gunDrop = findGunDrop()
            if rootPart and gunDrop then
                local originalFrame = rootPart.CFrame
                touchPart(rootPart, gunDrop)
                task.wait(0.18)
                if rootPart.Parent then rootPart.CFrame = originalFrame end
            end
        end
    end
end)

task.spawn(function()
    while state.active do
        task.wait(0.75)
        if state.autoFarm then
            local _, rootPart = getCharacterData()
            if rootPart then
                for _, coin in ipairs(getCoinParts()) do
                    if not state.autoFarm or not rootPart.Parent then break end
                    touchPart(rootPart, coin)
                    task.wait(0.12)
                end
            end
        end
    end
end)

task.spawn(function()
    while state.active do
        if state.esp then updateESP() end
        task.wait(1)
    end
end)

local tabButtons = {}
local selectedTab = nil
local selectTab
local closeMenu

local function createPage(title, subtitle)
    local page = Instance.new("ScrollingFrame")
    page.Active = true
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new()
    page.ScrollBarImageColor3 = Colors.cyan
    page.ScrollBarThickness = 3
    page.Size = UDim2.fromScale(1, 1)
    page.Visible = false
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.Parent = page

    local heading = Instance.new("Frame")
    heading.BackgroundTransparency = 1
    heading.LayoutOrder = 0
    heading.Size = UDim2.new(1, -8, 0, 54)
    heading.Parent = page

    local headingTitle = createText(heading, title, 24, Enum.Font.GothamBold, Colors.text)
    headingTitle.Size = UDim2.new(1, 0, 0, 28)

    local headingSubtitle = createText(heading, subtitle, 11, Enum.Font.GothamMedium, Colors.muted)
    headingSubtitle.Position = UDim2.fromOffset(0, 32)
    headingSubtitle.Size = UDim2.new(1, 0, 0, 18)

    return page
end

local function addSection(page, title, subtitle)
    local section = Instance.new("Frame")
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, -8, 0, subtitle and 48 or 30)
    section.Parent = page

    local sectionTitle = createText(section, title, 12, Enum.Font.GothamBold, Colors.cyan)
    sectionTitle.Size = UDim2.new(1, 0, 0, 18)

    if subtitle then
        local sectionSubtitle = createText(section, subtitle, 10, Enum.Font.GothamMedium, Colors.muted)
        sectionSubtitle.Position = UDim2.fromOffset(0, 21)
        sectionSubtitle.Size = UDim2.new(1, 0, 0, 17)
    end
end

local function addToggle(page, title, description, default, callback)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Colors.surface
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, -8, 0, 68)
    row.Parent = page
    corner(row, 14)
    stroke(row, Colors.accent, 0.7, 1)

    local titleLabel = createText(row, title, 13, Enum.Font.GothamBold, Colors.text)
    titleLabel.Position = UDim2.fromOffset(16, 13)
    titleLabel.Size = UDim2.new(1, -95, 0, 18)

    local descriptionLabel = createText(row, description, 10, Enum.Font.GothamMedium, Colors.muted)
    descriptionLabel.Position = UDim2.fromOffset(16, 34)
    descriptionLabel.Size = UDim2.new(1, -95, 0, 17)
    descriptionLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.BackgroundColor3 = default and Colors.accent or Color3.fromRGB(35, 40, 60)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(1, -64, 0.5, -14)
    button.Size = UDim2.fromOffset(48, 28)
    button.Text = ""
    button.Parent = row
    corner(button, 14)

    local knob = Instance.new("Frame")
    knob.BackgroundColor3 = Colors.text
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(default and 1 or 0, default and -24 or 4, 0.5, -10)
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Parent = button
    corner(knob, 20)

    local enabled = default
    local function setEnabled(value, shouldCallback)
        enabled = value
        tween(button, 0.2, { BackgroundColor3 = value and Colors.accent or Color3.fromRGB(35, 40, 60) }):Play()
        tween(knob, 0.2, { Position = UDim2.new(value and 1 or 0, value and -24 or 4, 0.5, -10) }):Play()
        if shouldCallback then callback(value) end
    end

    connect(button.MouseButton1Click, function()
        setEnabled(not enabled, true)
    end)

    return setEnabled
end

local function addSlider(page, title, description, minimum, maximum, default, callback)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Colors.surface
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, -8, 0, 80)
    row.Parent = page
    corner(row, 14)
    stroke(row, Colors.accent, 0.7, 1)

    local titleLabel = createText(row, title, 13, Enum.Font.GothamBold, Colors.text)
    titleLabel.Position = UDim2.fromOffset(16, 12)
    titleLabel.Size = UDim2.new(1, -130, 0, 18)

    local descriptionLabel = createText(row, description, 10, Enum.Font.GothamMedium, Colors.muted)
    descriptionLabel.Position = UDim2.fromOffset(16, 31)
    descriptionLabel.Size = UDim2.new(1, -130, 0, 16)

    local valueLabel = createText(row, tostring(default), 12, Enum.Font.GothamBold, Colors.cyan)
    valueLabel.Position = UDim2.new(1, -75, 0, 14)
    valueLabel.Size = UDim2.fromOffset(55, 18)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("TextButton")
    bar.AutoButtonColor = false
    bar.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
    bar.BorderSizePixel = 0
    bar.Position = UDim2.new(0, 16, 1, -22)
    bar.Size = UDim2.new(1, -32, 0, 8)
    bar.Text = ""
    bar.Parent = row
    corner(bar, 8)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Colors.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - minimum) / (maximum - minimum), 0, 1, 0)
    fill.Parent = bar
    corner(fill, 8)

    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new(Colors.accentGradient1, Colors.cyan)
    fillGradient.Parent = fill

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Colors.text
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new((default - minimum) / (maximum - minimum), 0, 0.5, 0)
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Parent = bar
    corner(knob, 14)

    local value = default
    local dragging = false
    local function setValueFromPosition(positionX)
        local percentage = math.clamp((positionX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(minimum + (maximum - minimum) * percentage + 0.5)
        local exactPercentage = (value - minimum) / (maximum - minimum)
        fill.Size = UDim2.new(exactPercentage, 0, 1, 0)
        knob.Position = UDim2.new(exactPercentage, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        callback(value)
    end

    connect(bar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setValueFromPosition(input.Position.X)
        end
    end)

    connect(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setValueFromPosition(input.Position.X)
        end
    end)

    connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function addButton(page, title, description, color, callback)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.BackgroundColor3 = Colors.surface
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, -8, 0, 60)
    button.Text = ""
    button.Parent = page
    corner(button, 14)
    stroke(button, color, 0.5, 1)

    local titleLabel = createText(button, title, 12, Enum.Font.GothamBold, Colors.text)
    titleLabel.Position = UDim2.fromOffset(16, 11)
    titleLabel.Size = UDim2.new(1, -75, 0, 18)

    local descriptionLabel = createText(button, description, 10, Enum.Font.GothamMedium, Colors.muted)
    descriptionLabel.Position = UDim2.fromOffset(16, 31)
    descriptionLabel.Size = UDim2.new(1, -75, 0, 16)

    local arrow = createText(button, "›", 26, Enum.Font.GothamBold, color)
    arrow.Position = UDim2.new(1, -40, 0.5, -16)
    arrow.Size = UDim2.fromOffset(20, 32)
    arrow.TextXAlignment = Enum.TextXAlignment.Center

    connect(button.MouseEnter, function()
        tween(button, 0.15, { BackgroundColor3 = Colors.surfaceHover }):Play()
    end)
    connect(button.MouseLeave, function()
        tween(button, 0.15, { BackgroundColor3 = Colors.surface }):Play()
    end)
    connect(button.MouseButton1Click, callback)
end

local function addTab(id, label, icon, page)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.BackgroundColor3 = Colors.surface
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 44)
    button.Text = ""
    button.Parent = TabList
    corner(button, 12)

    local accent = Instance.new("Frame")
    accent.BackgroundColor3 = Colors.cyan
    accent.BorderSizePixel = 0
    accent.Position = UDim2.fromOffset(0, 11)
    accent.Size = UDim2.fromOffset(3, 22)
    accent.Visible = false
    accent.Parent = button
    corner(accent, 3)

    local iconLabel = createText(button, icon, 16, Enum.Font.GothamBold, Colors.muted)
    iconLabel.Position = UDim2.fromOffset(14, 10)
    iconLabel.Size = UDim2.fromOffset(22, 23)
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center

    local labelText = createText(button, label, 12, Enum.Font.GothamMedium, Colors.muted)
    labelText.Position = UDim2.fromOffset(46, 0)
    labelText.Size = UDim2.new(1, -56, 1, 0)

    tabButtons[id] = {
        button = button,
        accent = accent,
        icon = iconLabel,
        label = labelText,
        page = page,
    }

    connect(button.MouseButton1Click, function()
        selectTab(id)
    end)
end

selectTab = function(id)
    if selectedTab == id then return end
    for tabId, tab in pairs(tabButtons) do
        local isSelected = tabId == id
        tab.page.Visible = isSelected
        tab.accent.Visible = isSelected
        tween(tab.button, 0.2, { BackgroundTransparency = isSelected and 0 or 1 }):Play()
        tween(tab.label, 0.2, { TextColor3 = isSelected and Colors.text or Colors.muted }):Play()
        tween(tab.icon, 0.2, { TextColor3 = isSelected and Colors.cyan or Colors.muted }):Play()
    end
    selectedTab = id
end

local movementPage = createPage("Движение", "Контролируй скорость и передвижение без лишних кнопок.")
addSection(movementPage, "MOTION ENGINE", "Управление полётом: W A S D • Space ↑ • Shift ↓")
addToggle(movementPage, "Полёт", "Свободное движение по направлению камеры.", false, function(enabled)
    state.fly = enabled
    if not enabled then resetFly() end
end)
addSlider(movementPage, "Скорость полёта", "От 10 до 150.", 10, 150, state.flySpeed, function(value)
    state.flySpeed = value
end)
addToggle(movementPage, "Вращение", "Крути персонажа с выбранной скоростью.", false, function(enabled)
    state.spin = enabled
end)
addSlider(movementPage, "Скорость вращения", "Плавный поворот, от 1 до 50.", 1, 50, state.spinSpeed, function(value)
    state.spinSpeed = value
end)
addToggle(movementPage, "Bhop", "Автоматический прыжок при движении.", false, function(enabled)
    state.bhop = enabled
end)
addSlider(movementPage, "Сила Bhop", "Дополнительный импульс при прыжке.", 1, 25, state.bhopPower, function(value)
    state.bhopPower = value
end)

local sheriffPage = createPage("Шериф", "Быстрый поиск выпавшего оружия на карте.")
addSection(sheriffPage, "GUN DROP", "Проверяется объект с именем GunDrop.")
addToggle(sheriffPage, "Авто-подбор оружия", "Подходит к GunDrop и возвращается на позицию.", false, function(enabled)
    state.gunSnatcher = enabled
    notify("GUN DROP", enabled and "Авто-подбор включён." or "Авто-подбор выключен.", enabled and Colors.success or Colors.muted)
end)
addButton(sheriffPage, "Проверить оружие сейчас", "Однократная проверка наличия GunDrop.", Colors.cyan, function()
    local gunDrop = findGunDrop()
    notify("GUN DROP", gunDrop and "Оружие найдено на карте." or "GunDrop пока не найден.", gunDrop and Colors.success or Colors.danger)
end)

local murderPage = createPage("Убийца", "Информация о видимых ролях в текущем раунде.")
addSection(murderPage, "ROLE STATUS", "Роль определяется по инструментам, доступным клиенту.")
addButton(murderPage, "Обновить роли", "Перерисовать ESP и определить видимые инструменты.", Colors.accent, function()
    updateESP()
    notify("ROLE STATUS", "Данные ролей обновлены.", Colors.success)
end)
addButton(murderPage, "Открыть вкладку ESP", "Включи подсветку игроков для отображения ролей.", Colors.cyan, function()
    selectTab("visuals")
end)

local farmPage = createPage("Авто-фарм", "Сбор видимых предметов с проверкой контейнеров карты.")
addSection(farmPage, "COIN RUNNER", "Ищет Coin и TouchTransmitter в Normal, CoinContainer и Coins.")
addToggle(farmPage, "Авто-сбор монет", "Собирает найденные монеты по очереди.", false, function(enabled)
    state.autoFarm = enabled
    notify("COIN RUNNER", enabled and "Авто-сбор включён." or "Авто-сбор выключен.", enabled and Colors.success or Colors.muted)
end)
addButton(farmPage, "Сканировать монеты", "Показать количество доступных объектов.", Colors.cyan, function()
    local coins = getCoinParts()
    notify("COIN RUNNER", "Найдено объектов: " .. tostring(#coins) .. ".", #coins > 0 and Colors.success or Colors.danger)
end)

local funPage = createPage("Развлечения", "Экспериментальные функции с быстрым включением и выключением.")
addSection(funPage, "EXPERIMENTAL", "Эти эффекты зависят от ограничений сервера.")
addToggle(funPage, "Fling", "Высокая скорость и вращение персонажа.", false, function(enabled)
    state.fling = enabled
    notify("FLING", enabled and "Режим включён." or "Режим выключен.", enabled and Colors.danger or Colors.muted)
end)

local playerPage = createPage("Игрок", "Локальные настройки персонажа.")
addSection(playerPage, "CHARACTER", "Изменения видны только на твоём клиенте.")
addToggle(playerPage, "Локальная невидимость", "Скрывает персонажа только на твоём экране.", false, function(enabled)
    state.invisible = enabled
    setInvisibility(enabled)
    notify("CHARACTER", enabled and "Локальная невидимость включена." or "Видимость восстановлена.", enabled and Colors.success or Colors.muted)
end)
addButton(playerPage, "Восстановить видимость", "Сбросить локальную прозрачность частей.", Colors.cyan, function()
    state.invisible = false
    clearInvisibility()
    notify("CHARACTER", "Видимость восстановлена.", Colors.success)
end)

local visualsPage = createPage("Визуал", "Контрастная подсветка игроков на карте.")
addSection(visualsPage, "NEON ESP", "Красный — убийца, голубой — шериф, зелёный — игрок.")
addToggle(visualsPage, "Role ESP", "Подсветка игроков и их видимых ролей.", false, function(enabled)
    state.esp = enabled
    if enabled then updateESP() else clearESP() end
    notify("NEON ESP", enabled and "Подсветка включена." or "Подсветка выключена.", enabled and Colors.success or Colors.muted)
end)
addButton(visualsPage, "Обновить ESP", "Принудительно перерисовать подсветку.", Colors.cyan, function()
    updateESP()
    notify("NEON ESP", "Подсветка обновлена.", Colors.success)
end)

local settingsPage = createPage("Настройки", "Управление интерфейсом и загрузчиком.")
addSection(settingsPage, "INTERFACE", "Окно можно перетаскивать за верхнюю панель.")
addButton(settingsPage, "Скопировать лоадер", "Сохранить короткую ссылку на этот скрипт.", Colors.accent, function()
    local loader = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/zuzinn888-star/tested-/refs/heads/main/tested.lua"))()'
    if type(setclipboard) == "function" then
        setclipboard(loader)
        notify("LOADER", "Лоадер скопирован в буфер обмена.", Colors.success)
    else
        notify("LOADER", "Буфер обмена недоступен в этом окружении.", Colors.danger)
    end
end)
addButton(settingsPage, "Закрыть меню", "Остановить эффекты и убрать интерфейс.", Colors.danger, function()
    closeMenu()
end)

local creditsPage = createPage("Авторы", "Krev Hub Neon Edition.")
addSection(creditsPage, "CREDITS", "Спасибо за тестирование интерфейса.")
addButton(creditsPage, "Telegram", "KREVETKASCRIPTS", Colors.cyan, function()
    if type(setclipboard) == "function" then
        setclipboard("https://t.me")
        notify("TELEGRAM", "Ссылка скопирована.", Colors.success)
    else
        notify("TELEGRAM", "Ссылка: https://t.me", Colors.cyan)
    end
end)

addTab("movement", "Движение", "↗", movementPage)
addTab("sheriff", "Шериф", "◈", sheriffPage)
addTab("murder", "Убийца", "◆", murderPage)
addTab("farm", "Авто-фарм", "✦", farmPage)
addTab("fun", "Развлечения", "⚡", funPage)
addTab("player", "Игрок", "◎", playerPage)
addTab("visuals", "Визуал", "◉", visualsPage)
addTab("settings", "Настройки", "⚙", settingsPage)
addTab("credits", "Авторы", "♥", creditsPage)

selectTab("movement")

local dragging = false
local dragStart = nil
local startPosition = nil

connect(Header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Window.Position
    end
end)

connect(UserInputService.InputChanged, function(input)
    if not dragging or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then
        return
    end
    local delta = (input.Position - dragStart) / windowScale.Scale
    Window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)

connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

closeMenu = function()
    if not state.active then return end
    state.active = false
    state.fly = false
    state.esp = false
    state.invisible = false
    resetFly()
    clearInvisibility()
    clearESP()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    ScreenGui:Destroy()
end

connect(CloseButton.MouseButton1Click, closeMenu)

notify("KREV HUB", "Neon Edition обновлен. Дизайн прокачан до ультра-версии.", Colors.cyan)
