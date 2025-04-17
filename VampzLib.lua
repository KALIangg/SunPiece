local VampzLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function VampzLib:create(class, properties)
	local obj = Instance.new(class)
	for i, v in pairs(properties) do
		obj[i] = v
	end
	return obj
end

function VampzLib:CreateWindow(title)
	local screenGui = self:create("ScreenGui", {
		Name = "VampzUI",
		ResetOnSpawn = false,
		Parent = game:GetService("CoreGui")
	})

	local main = self:create("Frame", {
		Size = UDim2.new(0, 550, 0, 500),
		Position = UDim2.new(0.5, -275, 0.5, -250),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = screenGui
	})

	self:create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })

	local titleLabel = self:create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		Text = title,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		Parent = main
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = titleLabel })

	local scrollingFrame = self:create("ScrollingFrame", {
		Size = UDim2.new(1, -20, 1, -60),
		Position = UDim2.new(0, 10, 0, 50),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 8,
		BackgroundTransparency = 1,
		Parent = main
	})

	local layout = self:create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = scrollingFrame
	})

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
	end)

	self.Window = screenGui
	self.Content = scrollingFrame
	return self
end

function VampzLib:AddSection(sectionName)
	local sectionContainer = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Parent = self.Content
	})

	local sectionButton = self:create("TextButton", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Text = "▼ " .. sectionName,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		AutoButtonColor = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sectionContainer
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = sectionButton })

	local contentFrame = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = sectionContainer
	})

	local layout = self:create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		Parent = contentFrame
	})

	-- Expand/Collapse
	local expanded = false
	sectionButton.MouseButton1Click:Connect(function()
		expanded = not expanded
		sectionButton.Text = (expanded and "▲ " or "▼ ") .. sectionName
		local targetSize = expanded and layout.AbsoluteContentSize.Y or 0
		TweenService:Create(contentFrame, TweenInfo.new(0.25), {
			Size = UDim2.new(1, 0, 0, targetSize)
		}):Play()
	end)

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if expanded then
			contentFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		end
	end)

	return contentFrame
end

function VampzLib:AddButton(parent, text, callback)
	local button = self:create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		AutoButtonColor = true,
		Parent = parent
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = button })

	button.MouseButton1Click:Connect(callback)
end

function VampzLib:AddToggle(parent, text, callback)
	local toggle = self:create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Text = text .. ": OFF",
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		AutoButtonColor = true,
		Parent = parent
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = toggle })

	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

function VampzLib:AddSlider(parent, text, min, max, callback)
	local container = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local label = self:create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		Text = text .. ": " .. min,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		Parent = container
	})

	local sliderBar = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 0, 25),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Parent = container
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sliderBar })

	local fill = self:create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 255),
		Parent = sliderBar
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = fill })

	local dragging = false
	local function update(input)
		local pos = input.Position.X - sliderBar.AbsolutePosition.X
		local pct = math.clamp(pos / sliderBar.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * pct)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		label.Text = text .. ": " .. value
		callback(value)
	end

	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)
end

function VampzLib:AddDropdown(parent, text, options, callback)
	local container = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local dropdown = self:create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		Parent = container
	})
	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropdown })

	local list = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		ClipsDescendants = true,
		Parent = container
	})

	local layout = self:create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		Parent = list
	})

	local open = false
	dropdown.MouseButton1Click:Connect(function()
		open = not open
		local targetSize = open and layout.AbsoluteContentSize.Y or 0
		TweenService:Create(list, TweenInfo.new(0.25), {
			Size = UDim2.new(1, 0, 0, targetSize)
		}):Play()
	end)

	for _, option in pairs(options) do
		local optBtn = self:create("TextButton", {
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			Text = option,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			Parent = list
		})
		self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optBtn })

		optBtn.MouseButton1Click:Connect(function()
			callback(option)
			dropdown.Text = text .. ": " .. option
			open = false
			TweenService:Create(list, TweenInfo.new(0.25), {
				Size = UDim2.new(1, 0, 0, 0)
			}):Play()
		end)
	end
end

return VampzLib
