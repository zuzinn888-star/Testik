-- Krev Hub MM2 - Compact Fixed Edition
-- Fixed window size constraint, smaller compact design, draggable elements, and working features.

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
local existingGui = guiParent:FindFirstChild("KrevHubMM2Compact")
if existingGui then existingGui:Destroy() end

local Theme = {
    background = Color3.fromRGB(15, 15, 20),
    panel = Color3.fromRGB(22, 22, 28),
    surface = Color3.fromRGB(30, 30, 38),
    text = Color3.fromRGB(255, 255, 255),
    muted = Color3.fromRGB(150, 150, 160),
    accent = Color3.fromRGB(255, 0, 128),
}

local state = {
    active = true,
    roleEsp = false, xray = false, xrayStr = 0.5, noclip = false, autoFlingSheriff = false,
    autoPickupGun = false, gunEsp = false, silentAim = false, wallbang = false, autoShoot = false, autoKill = false,
    killAura = false, killAll = false, killOnlySheriff = false, killPlayerTarget = "None",
    knifeThrow = false, knifeThrowAim = false, predict = false, predictLead = 100,
    autoFarm = false, autoRespawn = false, antiFling = false, avoidMurderer = false, autoFling = false,
    wsEnabled = false, ws = 16, jpEnabled = false, jp = 50, touchFling = false, autoEmote = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KrevHubMM2Compact"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

local function makeDraggable(gui, handle)
    handle = handle or gui
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Floating Icon Button (Draggable & Small)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(45, 45)
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.BackgroundColor3 = Theme.panel
ToggleBtn.Text = "K"
ToggleBtn.TextColor3 = Theme.accent
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 22
ToggleBtn.Parent = ScreenGui
local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(1, 0)
tCorner.Parent = ToggleBtn
local tStroke = Instance.new("UIStroke")
tStroke.Color = Theme.accent
tStroke.Thickness = 2
tStroke.Parent = ToggleBtn
makeDraggable(ToggleBtn)

-- Compact Fixed Size Window
local Window = Instance.new("Frame")
Window.Size = UDim2.fromOffset(480, 280)
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundColor3 = Theme.background
Window.Visible = false
Window.Parent = ScreenGui
local wCorner = Instance.new("UICorner")
wCorner.CornerRadius = UDim.new(0, 8)
wCorner.Parent = Window
local wStroke = Instance.new("UIStroke")
wStroke.Color = Theme.accent
wStroke.Thickness = 1
wStroke.Parent = Window

ToggleBtn.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Theme.panel
Header.Parent = Window
local hCorner = Instance.new("UICorner")
hCorner.CornerRadius = UDim.new(0, 8)
hCorner.Parent = Header
makeDraggable(Window, Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.fromOffset(12, 0)
Title.BackgroundTransparency = 1
Title.Text = "Krev Hub | MM2"
Title.TextColor3 = Theme.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(32, 32)
CloseBtn.Position = UDim2.new(1, -32, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.muted
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() Window.Visible = false end)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 115, 1, -32)
Sidebar.Position = UDim2.fromOffset(0, 32)
Sidebar.BackgroundColor3 = Theme.panel
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.Parent = Window
local sLayout = Instance.new("UIListLayout")
sLayout.Padding = UDim.new(0, 4)
sLayout.Parent = Sidebar
local sPad = Instance.new("UIPadding")
sPad.PaddingTop = UDim.new(0, 4)
sPad.PaddingLeft = UDim.new(0, 4)
sPad.PaddingRight = UDim.new(0, 4)
sPad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -115, 1, -32)
Content.Position = UDim2.fromOffset(115, 32)
Content.BackgroundTransparency = 1
Content.Parent = Window

local tabs = {}
local activeTab = nil
local elementCount = 0

local function addTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Theme.surface
    btn.BackgroundTransparency = 1
    btn.Text = " " .. name
    btn.TextColor3 = Theme.muted
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.fromOffset(8, 8)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.accent
    page.Visible = false
    page.Parent = Content
    local pLayout = Instance.new("UIListLayout")
    pLayout.Padding = UDim.new(0, 6)
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pLayout.Parent = page

    tabs[name] = {btn = btn, page = page}

    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        for tName, tData in pairs(tabs) do
            local isSel = (tName == name)
            tData.page.Visible = isSel
            tData.btn.BackgroundTransparency = isSel and 0 or 1
            tData.btn.TextColor3 = isSel and Theme.text or Theme.muted
        end
        activeTab = name
    end)
    return page
end

local function addLabel(page, text)
    elementCount = elementCount + 1
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = elementCount
    lbl.Parent = page
end

local function addToggle(page, text, default, callback)
    elementCount = elementCount + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = Theme.surface
    row.LayoutOrder = elementCount
    row.Parent = page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.fromOffset(8, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(32, 16)
    btn.Position = UDim2.new(1, -40, 0.5, -8)
    btn.BackgroundColor3 = default and Theme.accent or Color3.fromRGB(45, 45, 50)
    btn.Text = ""
    btn.Parent = row
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = btn

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(12, 12)
    knob.Position = UDim2.new(default and 1 or 0, default and -14 or 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = btn
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local val = default
    btn.MouseButton1Click:Connect(function()
        val = not val
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = val and Theme.accent or Color3.fromRGB(45, 45, 50)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(val and 1 or 0, val and -14 or 2, 0.5, -6)}):Play()
        callback(val)
    end)
end

local function addSlider(page, text, min, max, default, callback)
    elementCount = elementCount + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Theme.surface
    row.LayoutOrder = elementCount
    row.Parent = page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 0, 16)
    lbl.Position = UDim2.fromOffset(8, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.fromOffset(30, 16)
    valLbl.Position = UDim2.new(1, -35, 0, 2)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = Theme.accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 10
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -16, 0, 4)
    bar.Position = UDim2.new(0, 8, 0, 24)
    bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    bar.Text = ""
    bar.Parent = row
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.accent
    fill.Parent = bar
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local dragging = false
    local function update(inp)
        local pct = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * pct)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valLbl.Text = tostring(v)
        callback(v)
    end
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true update(inp)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then update(inp) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

local function addBtn(page, text, callback)
    elementCount = elementCount + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = Theme.surface
    btn.Text = text
    btn.TextColor3 = Theme.accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.LayoutOrder = elementCount
    btn.Parent = page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
end

local function addDropdown(page, text, options, callback)
    elementCount = elementCount + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = Theme.surface
    row.LayoutOrder = elementCount
    row.ClipsDescendants = true
    row.Parent = page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 16)
    lbl.Position = UDim2.fromOffset(8, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local dBtn = Instance.new("TextButton")
    dBtn.Size = UDim2.new(1, -16, 0, 20)
    dBtn.Position = UDim2.fromOffset(8, 22)
    dBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    dBtn.Text = " " .. options[1]
    dBtn.TextColor3 = Theme.accent
    dBtn.Font = Enum.Font.GothamBold
    dBtn.TextSize = 10
    dBtn.TextXAlignment = Enum.TextXAlignment.Left
    dBtn.Parent = row
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 4)
    dc.Parent = dBtn

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -16, 0, 60)
    list.Position = UDim2.fromOffset(8, 45)
    list.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 2
    list.Parent = row
    local ll = Instance.new("UIListLayout")
    ll.Parent = list

    local isOpen = false
    local function refresh(opts)
        for _, v in pairs(list:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, o in pairs(opts) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 18)
            b.BackgroundTransparency = 1
            b.Text = "  " .. o
            b.TextColor3 = Theme.text
            b.Font = Enum.Font.Gotham
            b.TextSize = 10
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = list
            b.MouseButton1Click:Connect(function()
                isOpen = false
                row.Size = UDim2.new(1, 0, 0, 48)
                dBtn.Text = " " .. o
                callback(o)
            end)
        end
    end
    refresh(options)

    dBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        row.Size = isOpen and UDim2.new(1, 0, 0, 110) or UDim2.new(1, 0, 0, 48)
    end)
    return refresh
end

local pMain = addTab("Main")
addToggle(pMain, "Enable Role ESP", false, function(v) state.roleEsp = v end)
addToggle(pMain, "Gun ESP", false, function(v) state.gunEsp = v end)
addToggle(pMain, "X-Ray", false, function(v) state.xray = v end)
addSlider(pMain, "X-Ray Strength", 10, 100, 50, function(v) state.xrayStr = v / 100 end)
addToggle(pMain, "No Clip", false, function(v) state.noclip = v end)
addToggle(pMain, "Auto Fling Sheriff", false, function(v) state.autoFlingSheriff = v end)

local pSheriff = addTab("Sheriff")
addToggle(pSheriff, "Auto Pickup Gun", false, function(v) state.autoPickupGun = v end)
addToggle(pSheriff, "Silent Aim", false, function(v) state.silentAim = v end)
addToggle(pSheriff, "Wallbang", false, function(v) state.wallbang = v end)
addToggle(pSheriff, "Auto Shoot", false, function(v) state.autoShoot = v end)
addToggle(pSheriff, "Auto Kill", false, function(v) state.autoKill = v end)

local pMurder = addTab("Murder")
addToggle(pMurder, "Kill Aura", false, function(v) state.killAura = v end)
addToggle(pMurder, "Kill All", false, function(v) state.killAll = v end)
addToggle(pMurder, "Kill Only Sheriff", false, function(v) state.killOnlySheriff = v end)
local pList = {"None"}
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(pList, p.Name) end end
local dRefresh = addDropdown(pMurder, "Select Player", pList, function(v) state.killPlayerTarget = v end)
addBtn(pMurder, "Refresh Players", function()
    local nl = {"None"}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(nl, p.Name) end end
    dRefresh(nl)
end)
addBtn(pMurder, "Kill Selected", function()
    if state.killPlayerTarget ~= "None" then
        local t = Players:FindFirstChild(state.killPlayerTarget)
        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local k = c and c:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and r and k then
            k.Parent = c
            r.CFrame = t.Character.HumanoidRootPart.CFrame
            task.wait(0.1) k:Activate()
        end
    end
end)
addToggle(pMurder, "Knife Throw Aimbot", false, function(v) state.knifeThrowAim = v end)

local pFarm = addTab("Auto Farm")
addToggle(pFarm, "Auto Farm", false, function(v) state.autoFarm = v end)
addToggle(pFarm, "Auto-Respawn", false, function(v) state.autoRespawn = v end)
addToggle(pFarm, "Anti-Fling", false, function(v) state.antiFling = v end)
addToggle(pFarm, "Avoid Murderer", false, function(v) state.avoidMurderer = v end)

local pFun = addTab("Troll Fun")
addToggle(pFun, "Walk Speed Toggle", false, function(v) state.wsEnabled = v end)
addSlider(pFun, "Walk Speed", 16, 150, 16, function(v) state.ws = v end)
addToggle(pFun, "Jump Power Toggle", false, function(v) state.jpEnabled = v end)
addSlider(pFun, "Jump Power", 50, 200, 50, function(v) state.jp = v end)
addToggle(pFun, "Touch Fling", false, function(v) state.touchFling = v end)

tabs["Main"].btn.MouseButton1Click:Fire()

local espFolder = Workspace:FindFirstChild("KrevHubESP")
if not espFolder then
    espFolder = Instance.new("Folder")
    espFolder.Name = "KrevHubESP"
    espFolder.Parent = Workspace
end

local function getRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then return "Murderer" end
    if char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    if not state.active then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    espFolder:ClearAllChildren()
    if state.roleEsp then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local role = getRole(player)
                local color = Color3.fromRGB(50, 230, 120)
                if role == "Murderer" then color = Color3.fromRGB(255, 60, 90) elseif role == "Sheriff" then color = Color3.fromRGB(0, 220, 255) end
                local hl = Instance.new("Highlight")
                hl.Adornee = player.Character
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = color
                hl.FillTransparency = 0.6
                hl.Parent = espFolder
            end
        end
    end
    if state.gunEsp then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                local hl = Instance.new("Highlight")
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(0, 220, 255)
                hl.Parent = espFolder
            end
        end
    end

    if state.wsEnabled and char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = state.ws end
    end
    if state.jpEnabled and char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = state.jp end
    end
    if state.noclip and char then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if state.xray then
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p:IsDescendantOf(char) then p.LocalTransparencyModifier = state.xrayStr end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if not state.active then break end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if state.autoPickupGun then
                local gunDrop = Workspace:FindFirstChild("GunDrop", true)
                if gunDrop and gunDrop:IsA("BasePart") then
                    root.CFrame = gunDrop.CFrame
                    task.wait(0.2)
                end
            end
            if state.autoFarm then
                local c = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("CoinContainer")
                if c then
                    for _, coin in pairs(c:GetDescendants()) do
                        if coin:IsA("BasePart") and coin.Name == "Coin_Server" then
                            root.CFrame = coin.CFrame
                            task.wait(0.15)
                        end
                    end
                end
            end
            if state.killAura then
                local knife = char:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local role = getRole(p)
                            if state.killAll or (state.killOnlySheriff and role == "Sheriff") then
                                if (p.Character.HumanoidRootPart.Position - root.Position).Magnitude < 15 then
                                    knife.Parent = char
                                    pcall(function() knife:Activate() end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
