local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

---------------------------------------------------
-- REMOTES (your existing ones)
---------------------------------------------------

local treeRemote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("Main")
    :WaitForChild("DataService")
    :WaitForChild("Networker")
    :WaitForChild("_remotes")
    :WaitForChild("TreeService")
    :WaitForChild("RemoteEvent")

local clickRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("ProgressionClick")

---------------------------------------------------
-- GUI
---------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "DevTestGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200, 320)
frame.Position = UDim2.new(0.03,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

---------------------------------------------------
-- TOP BAR
---------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,28)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "Dev Test Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(20,20)
minimize.Position = UDim2.new(1,-44,0,4)
minimize.BackgroundTransparency = 1
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 16
minimize.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(20,20)
close.Position = UDim2.new(1,-22,0,4)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = frame

---------------------------------------------------
-- CONTENT HOLDER
---------------------------------------------------

local holder = Instance.new("Frame")
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1,-10,1,-36)
holder.Position = UDim2.new(0,5,0,32)
holder.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.Parent = holder

---------------------------------------------------
-- STATE
---------------------------------------------------

local currentTree = nil
local treeRunning = false
local autoClicking = false
local minimized = false

local function stopTrees()
    treeRunning = false
    currentTree = nil
end

---------------------------------------------------
-- TREE AUTO CHOP
---------------------------------------------------

for i = 1,7 do
    local tree = "Tree"..i

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,26)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = tree
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = holder

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        if currentTree == tree then
            stopTrees()
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            return
        end

        for _,v in ipairs(holder:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(50,50,50)
            end
        end

        btn.BackgroundColor3 = Color3.fromRGB(0,170,127)

        stopTrees()
        currentTree = tree
        treeRunning = true

        task.spawn(function()
            while treeRunning and currentTree == tree do
                treeRemote:FireServer("requestChop", tree)
                task.wait(0.1)
            end
        end)
    end)
end

---------------------------------------------------
-- AUTO CLICKER
---------------------------------------------------

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,0,18)
label.BackgroundTransparency = 1
label.Text = "Auto Clicker"
label.Font = Enum.Font.GothamBold
label.TextSize = 13
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Parent = holder

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1,0,0,26)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
autoBtn.Text = "OFF"
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.Font = Enum.Font.Gotham
autoBtn.TextSize = 13
autoBtn.Parent = holder

Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,6)

autoBtn.MouseButton1Click:Connect(function()
    autoClicking = not autoClicking

    if autoClicking then
        autoBtn.Text = "ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(0,170,127)

        task.spawn(function()
            while autoClicking do
                clickRemote:FireServer()
                task.wait(0.1)
            end
        end)
    else
        autoBtn.Text = "OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

---------------------------------------------------
-- MINIMIZE / CLOSE
---------------------------------------------------

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    holder.Visible = not minimized

    if minimized then
        frame.Size = UDim2.fromOffset(200,32)
    else
        frame.Size = UDim2.fromOffset(200,320)
    end
end)

close.MouseButton1Click:Connect(function()
    stopTrees()
    autoClicking = false
    gui:Destroy()
end)
