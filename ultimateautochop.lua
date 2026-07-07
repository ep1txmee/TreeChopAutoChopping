local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local Remote = ReplicatedStorage
	:WaitForChild("Packages")
	:WaitForChild("Main")
	:WaitForChild("DataService")
	:WaitForChild("Networker")
	:WaitForChild("_remotes")
	:WaitForChild("TreeService")
	:WaitForChild("RemoteEvent")

---------------------------------------------------
-- SETTINGS
---------------------------------------------------

local enabled = false

local world = 1

local worlds = {
	[1] = {
		name = "World 1",
		prefix = "Tree",
		max = 6
	},

	[2] = {
		name = "World 2",
		prefix = "FrostTree",
		max = 5
	}
}

local treeIndex = 1
local selectedTree = "Tree1"

local function updateTree()
	selectedTree = worlds[world].prefix .. treeIndex
end

---------------------------------------------------
-- GUI
---------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "TreeChopper"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,180,0,160)
frame.Position = UDim2.new(.5,-90,.5,-80)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80,160,255)
stroke.Parent = frame

---------------------------------------------------
-- Universal Dragging (PC + Mobile + Studio)
---------------------------------------------------

frame.Active = true
frame.Selectable = true

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart

	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)

---------------------------------------------------
-- Title
---------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,24)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Tree Chopper"
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

---------------------------------------------------
-- Minimize
---------------------------------------------------

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,20,0,20)
minimize.Position = UDim2.new(1,-44,0,2)
minimize.BackgroundTransparency = 1
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = frame

---------------------------------------------------
-- Close
---------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,20,0,20)
close.Position = UDim2.new(1,-22,0,2)
close.BackgroundTransparency = 1
close.Text = "×"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

---------------------------------------------------
-- Toggle
---------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(.9,0,0,28)
toggle.Position = UDim2.new(.05,0,0,30)
toggle.BackgroundColor3 = Color3.fromRGB(170,60,60)
toggle.Text = "OFF"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 15
toggle.Parent = frame
Instance.new("UICorner",toggle)

toggle.MouseButton1Click:Connect(function()

	enabled = not enabled

	if enabled then
		toggle.Text = "ON"
		toggle.BackgroundColor3 = Color3.fromRGB(70,180,90)
	else
		toggle.Text = "OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(170,60,60)
	end
end)

---------------------------------------------------
-- World Button
---------------------------------------------------

local worldButton = Instance.new("TextButton")
worldButton.Size = UDim2.new(.9,0,0,28)
worldButton.Position = UDim2.new(.05,0,0,66)
worldButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
worldButton.TextColor3 = Color3.new(1,1,1)
worldButton.Font = Enum.Font.Gotham
worldButton.TextSize = 14
worldButton.Parent = frame
Instance.new("UICorner",worldButton)

---------------------------------------------------
-- Tree Button
---------------------------------------------------

local selector = Instance.new("TextButton")
selector.Size = UDim2.new(.9,0,0,28)
selector.Position = UDim2.new(.05,0,0,102)
selector.BackgroundColor3 = Color3.fromRGB(45,45,45)
selector.TextColor3 = Color3.new(1,1,1)
selector.Font = Enum.Font.Gotham
selector.TextSize = 14
selector.Parent = frame
Instance.new("UICorner",selector)

local function refreshButtons()

	worldButton.Text = worlds[world].name

	if treeIndex > worlds[world].max then
		treeIndex = 1
	end

	updateTree()
	selector.Text = selectedTree
end

refreshButtons()

---------------------------------------------------
-- Switch Worlds
---------------------------------------------------

worldButton.MouseButton1Click:Connect(function()

	world += 1

	if world > 2 then
		world = 1
	end

	treeIndex = 1
	refreshButtons()

end)

---------------------------------------------------
-- Tree Selector
---------------------------------------------------

selector.MouseButton1Click:Connect(function()

	treeIndex += 1

	if treeIndex > worlds[world].max then
		treeIndex = 1
	end

	refreshButtons()

end)

---------------------------------------------------
-- Minimize
---------------------------------------------------

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	worldButton.Visible = not minimized
	selector.Visible = not minimized
	toggle.Visible = not minimized

	if minimized then
		frame.Size = UDim2.new(0,180,0,26)
	else
		frame.Size = UDim2.new(0,180,0,160)
	end

end)

---------------------------------------------------
-- Loop
---------------------------------------------------

task.spawn(function()

	while task.wait(0.1) do

		if enabled then
			Remote:FireServer("requestChop", selectedTree)
		end

	end

end)
