-- Módulo VampzLib

local VampzLib = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("StarterGui")

function VampzLib:Notify(title, text, duration)
	CoreGui:SetCore("SendNotification", {
		Title = title or "Notification",
		Text = text or "This is a notification!",
		Duration = duration or 5,
	})
end

function VampzLib:create(class, props)
	local inst = Instance.new(class)
	for prop, val in pairs(props) do
		inst[prop] = val
	end
	return inst
end

function VampzLib:CreateWindow(settings)
	settings = settings or {}
	local title = settings.Title or "Vampz UI"

	local ScreenGui = self:create("ScreenGui", {
		Name = "VampzLibUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = LocalPlayer:WaitForChild("PlayerGui")
	})

	local MainFrame = self:create("Frame", {
		Name = "MainFrame",
		Size = UDim2.new(0, 600, 0, 320),
		Position = UDim2.new(0, 5, 0, 5),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Draggable = true,
		Active = true,
		Parent = ScreenGui
	})

	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MainFrame })

	local TopBar = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		Parent = MainFrame
	})

	self:create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TopBar })

	local TitleLabel = self:create("TextLabel", {
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

	local MinimizeBtn = self:create("TextButton", {
		Text = "-",
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 16,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 35, 1, 0),
		Position = UDim2.new(1, -70, 0, 0),
		Parent = TopBar
	})

	local CloseBtn = self:create("TextButton", {
		Text = "✕",
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 16,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 35, 1, 0),
		Position = UDim2.new(1, -35, 0, 0),
		Parent = TopBar
	})

	-- Adicionando o ScrollingFrame
	local ContentFrame = self:create("ScrollingFrame", {
		Name = "Content",
		Size = UDim2.new(1, -20, 1, -45),
		Position = UDim2.new(0, 10, 0, 40),
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = MainFrame
	})

	self:create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = ContentFrame
	})

	-- Configuração do botão de minimizar
	local minimized = false
	local originalSize = MainFrame.Size

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local newSize = minimized and UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35) or originalSize
		TweenService:Create(MainFrame, TweenInfo.new(0.3), { Size = newSize }):Play()
		ContentFrame.Visible = not minimized
	end)

	-- Configuração do botão de fechar
	CloseBtn.MouseButton1Click:Connect(function()
		local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0, 5, 0, 0)
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
			local sectionFrame = self:create("Frame", {
				Name = sectionName,
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Parent = ContentFrame
			})
			self:create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = sectionFrame })

			self:create("TextLabel", {
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

			local container = self:create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				Parent = ContentFrame
			})

			self:create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = container
			})

			return container
		end
	}

	-- Adicionar todas as funções de componentes
	for key, fn in pairs(VampzLib) do
		if key ~= "CreateWindow" then
			interface[key] = fn
		end
	end

	return interface
end

-- COMPONENTS

function VampzLib:AddButton(parent, text, callback)
	local btn = self:create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		AutoButtonColor = false,
		Parent = parent
	})

	self:create("UICorner", { Parent = btn })

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(70, 70, 70) }):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

function VampzLib:AddToggle(parent, text, default, callback)
	local frame = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local label = self:create("TextLabel", {
		Size = UDim2.new(0, 8, 0, 1, 0),
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	local toggleBtn = self:create("TextButton", {
		Size = UDim2.new(0, 40, 0, 20),
		Position = UDim2.new(1, -50, 0, 5, -10),
		BackgroundColor3 = default and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(60, 60, 60),
		Text = "",
		Parent = frame
	})

	self:create("UICorner", { Parent = toggleBtn })

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
	local frame = self:create("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local label = self:create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		Text = text .. ": " .. tostring(default),
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	local sliderBar = self:create("Frame", {
		Size = UDim2.new(1, -20, 0, 10),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		Parent = frame
	})

	self:create("UICorner", { Parent = sliderBar })

	local sliderFill = self:create("Frame", {
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 170, 127),
		Parent = sliderBar
	})

	self:create("UICorner", { Parent = sliderFill })

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
		if dragging then
			update(input)
		end
	end)
end

return VampzLib
