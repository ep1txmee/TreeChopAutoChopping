-- LocalScript (StarterPlayerScripts or StarterGui)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
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
