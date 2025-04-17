-- VampzLibModule

local VampzLib = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local CoreGui = game:GetService("StarterGui")

local function Notify(title, text, duration)
	CoreGui:SetCore("SendNotification", {
		Title = "Notification";
		Text = "Is this a notification?";
		Duration = 5;
	})
end

local function create(class, props)
	local inst = Instance.new(class)
	for prop, val in pairs(props) do
		inst[prop] = val
	end
	return inst
end

function VampzLib:CreateWindow(settings)
	settings = settings or {}
	local title = settings.Title or "Vampz UI"

	local ScreenGui = create("ScreenGui", {
		Name = "VampzLibUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = LocalPlayer:WaitForChild("PlayerGui")
	})

	local MainFrame = create("Frame", {
		Name = "MainFrame",
		Size = UDim2.new(0, 600, 0, 320),
		Position = UDim2.new(0.5, -300, 0.5, -160),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Draggable = true,
		Active = true,
		Parent = ScreenGui
	})
	create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MainFrame })

	local TopBar = create("Frame", {
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		Parent = MainFrame
	})
	create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TopBar })

	local TitleLabel = create("TextLabel", {
		Text = title,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 16,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar
	})

	local MinimizeBtn = create("TextButton", {
		Text = "-",
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 16,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 35, 1, 0),
		Position = UDim2.new(1, -70, 0, 0),
		Parent = TopBar
	})

	local CloseBtn = create("TextButton", {
		Text = "✕",
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 16,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 35, 1, 0),
		Position = UDim2.new(1, -35, 0, 0),
		Parent = TopBar
	})

	local ContentFrame = create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -20, 1, -45),
		Position = UDim2.new(0, 10, 0, 40),
		BackgroundTransparency = 1,
		Parent = MainFrame
	})

	local UIListLayout = create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = ContentFrame
	})

	local minimized = false
	local originalSize = MainFrame.Size

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local newSize = minimized and UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35) or originalSize
		TweenService:Create(MainFrame, TweenInfo.new(0.3), { Size = newSize }):Play()
		ContentFrame.Visible = not minimized
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween:Play()
		tween.Completed:Wait()
		ScreenGui:Destroy()
	end)

	local interface = {
		Window = ScreenGui,
		Main = MainFrame,
		Content = ContentFrame,
		AddSection = function(self, sectionName)
			local sectionFrame = create("Frame", {
				Name = sectionName,
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Parent = ContentFrame
			})
			create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = sectionFrame })

			create("TextLabel", {
				Text = sectionName,
				Font = Enum.Font.Gotham,
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 14,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 5, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = sectionFrame
			})

			local container = create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				Parent = ContentFrame
			})

			create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = container
			})

			return container
		end
	}

	-- Append all component functions
	for key, fn in pairs(VampzLib) do
		if key ~= "CreateWindow" then
			interface[key] = fn
		end
	end

	return interface
end

-- COMPONENTS
function VampzLib:AddButton(parent, text, callback)
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		AutoButtonColor = false,
		Parent = parent
	})
	create("UICorner", { Parent = btn })
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

function VampzLib:AddToggle(parent, text, default, callback)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local label = create("TextLabel", {
		Size = UDim2.new(0.8, 0, 1, 0),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	local toggleBtn = create("TextButton", {
		Size = UDim2.new(0, 40, 0, 20),
		Position = UDim2.new(1, -50, 0.5, -10),
		BackgroundColor3 = default and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(60, 60, 60),
		Text = "",
		Parent = frame
	})
	create("UICorner", { Parent = toggleBtn })

	local enabled = default
	toggleBtn.MouseButton1Click:Connect(function()
		enabled = not enabled
		TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(60, 60, 60)
		}):Play()
		if callback then callback(enabled) end
	end)
end

function VampzLib:AddSlider(parent, text, min, max, default, callback)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local label = create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		Text = text .. ": " .. tostring(default),
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	local sliderBar = create("Frame", {
		Size = UDim2.new(1, -20, 0, 10),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Parent = frame
	})
	create("UICorner", { Parent = sliderBar })

	local sliderFill = create("Frame", {
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 170, 127),
		Parent = sliderBar
	})
	create("UICorner", { Parent = sliderFill })

	local dragging = false

	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		local value = math.floor(min + (max - min) * pos)
		label.Text = text .. ": " .. tostring(value)
		if callback then callback(value) end
	end

	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(input)
		end
	end)

	sliderBar.InputEnded:Connect(function(input)
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
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 30 + #options * 25),
		BackgroundTransparency = 1,
		Parent = parent
	})

	create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	for i, option in ipairs(options) do
		local btn = create("TextButton", {
			Size = UDim2.new(1, -20, 0, 25),
			Position = UDim2.new(0, 10, 0, 20 + (i - 1) * 25),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			Text = option,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			Parent = frame
		})
		create("UICorner", { Parent = btn })

		btn.MouseButton1Click:Connect(function()
			if callback then callback(option) end
		end)
	end
end

function VampzLib:ShowNotification(text, color, duration)
	local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return end

	local announceFrame = create("Frame", {
		Size = UDim2.new(0, 300, 0, 40),
		Position = UDim2.new(0.5, -150, 1, -60),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 1),
		Parent = playerGui
	})
	create("UICorner", { Parent = announceFrame })

	create("TextLabel", {
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 5, 0, 0),
		Text = text,
		TextColor3 = color or Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		Parent = announceFrame
	})

	local tweenIn = TweenService:Create(announceFrame, TweenInfo.new(0.4), {
		Position = UDim2.new(0.5, -150, 1, -110)
	})
	local tweenOut = TweenService:Create(announceFrame, TweenInfo.new(0.4), {
		Position = UDim2.new(0.5, -150, 1, -60)
	})

	tweenIn:Play()
	task.delay(duration or 3, function()
		tweenOut:Play()
		tweenOut.Completed:Wait()
		announceFrame:Destroy()
	end)
end

return VampzLib
