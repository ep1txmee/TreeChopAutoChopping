local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local remote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("Main")
    :WaitForChild("DataService")
    :WaitForChild("Networker")
    :WaitForChild("_remotes")
    :WaitForChild("TreeService")
    :WaitForChild("RemoteEvent")

---------------------------------------------------
-- GUI
---------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "TreeTester"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180, 250)
frame.Position = UDim2.new(0.02,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(32,32,32)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,28)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "Tree Tester"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Minimize
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(20,20)
minimize.Position = UDim2.new(1,-44,0,4)
minimize.BackgroundTransparency = 1
minimize.BorderSizePixel = 0
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 16
minimize.Parent = frame

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(20,20)
close.Position = UDim2.new(1,-22,0,4)
close.BackgroundTransparency = 1
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = frame

local holder = Instance.new("Frame")
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1,-10,1,-36)
holder.Position = UDim2.new(0,5,0,32)
holder.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.Parent = holder

---------------------------------------------------
-- Logic
---------------------------------------------------

local currentTree = nil
local running = false

local function stop()
    running = false
    currentTree = nil
end

local function start(tree)
    stop()

    currentTree = tree
    running = true

    task.spawn(function()
        while running and currentTree == tree do
            remote:FireServer("requestChop", tree)
            task.wait(0.1)
        end
    end)
end

---------------------------------------------------
-- Buttons
---------------------------------------------------

for i = 1,7 do
    local tree = "Tree"..i

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,0,0,28)
    button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.Text = tree
    button.Parent = holder

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,6)
    c.Parent = button

    button.MouseButton1Click:Connect(function()

        if currentTree == tree then
            stop()
            button.BackgroundColor3 = Color3.fromRGB(50,50,50)
            return
        end

        for _,v in ipairs(holder:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(50,50,50)
            end
        end

        button.BackgroundColor3 = Color3.fromRGB(0,170,127)
        start(tree)
    end)
end

---------------------------------------------------
-- Minimize / Close
---------------------------------------------------

local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    holder.Visible = not minimized

    if minimized then
        frame.Size = UDim2.fromOffset(180,32)
    else
        frame.Size = UDim2.fromOffset(180,250)
    end
end)

close.MouseButton1Click:Connect(function()
    stop()
    gui:Destroy()
end)
