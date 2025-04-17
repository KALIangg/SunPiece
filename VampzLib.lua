local VampzLib = {}

function VampzLib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "VampzUI"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 450, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Text = title
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", ContentFrame)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)

    local SectionFunctions = {}

    function SectionFunctions:AddSection(name)
        local SectionHolder = Instance.new("Frame")
        SectionHolder.Size = UDim2.new(1, -10, 0, 40)
        SectionHolder.BackgroundTransparency = 1
        SectionHolder.LayoutOrder = #ContentFrame:GetChildren()
        SectionHolder.AutomaticSize = Enum.AutomaticSize.Y
        SectionHolder.Parent = ContentFrame

        local Toggle = Instance.new("TextButton", SectionHolder)
        Toggle.Size = UDim2.new(1, 0, 0, 40)
        Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Toggle.Text = "▶ " .. name
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 16
        Toggle.AutoButtonColor = true

        local Corner = Instance.new("UICorner", Toggle)
        Corner.CornerRadius = UDim.new(0, 6)

        local SectionContent = Instance.new("Frame", SectionHolder)
        SectionContent.BackgroundTransparency = 1
        SectionContent.Size = UDim2.new(1, 0, 0, 0)
        SectionContent.ClipsDescendants = true
        SectionContent.Visible = false
        SectionContent.AutomaticSize = Enum.AutomaticSize.Y

        local ContentLayout = Instance.new("UIListLayout", SectionContent)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 4)

        Toggle.MouseButton1Click:Connect(function()
            for _, other in pairs(ContentFrame:GetChildren()) do
                if other:IsA("Frame") and other:FindFirstChildWhichIsA("TextButton") then
                    local otherToggle = other:FindFirstChildWhichIsA("TextButton")
                    local otherContent = other:FindFirstChildWhichIsA("Frame")
                    if otherContent and otherContent ~= SectionContent then
                        otherContent.Visible = false
                        otherToggle.Text = "▶ " .. otherToggle.Text:match("▶ (.+)") or otherToggle.Text:match("▼ (.+)")
                    end
                end
            end

            SectionContent.Visible = not SectionContent.Visible
            if SectionContent.Visible then
                Toggle.Text = "▼ " .. name
            else
                Toggle.Text = "▶ " .. name
            end
        end)

        local function addElement(instance)
            instance.Size = UDim2.new(1, -10, 0, 30)
            instance.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            instance.TextColor3 = Color3.fromRGB(255, 255, 255)
            instance.Font = Enum.Font.Gotham
            instance.TextSize = 14
            instance.Parent = SectionContent
            local ic = Instance.new("UICorner", instance)
            ic.CornerRadius = UDim.new(0, 4)
        end

        local sectionAPI = {}

        function sectionAPI:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Text = text
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            addElement(Button)
        end

        function sectionAPI:AddToggle(text, callback)
            local ToggleBtn = Instance.new("TextButton")
            local state = false
            local function updateText()
                ToggleBtn.Text = (state and "[✓] " or "[ ] ") .. text
            end
            updateText()

            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                updateText()
                pcall(callback, state)
            end)
            addElement(ToggleBtn)
        end

        function sectionAPI:AddDropdown(options, callback)
            local Dropdown = Instance.new("TextButton")
            local selected = options[1]
            Dropdown.Text = "▼ " .. selected
            local index = 1

            Dropdown.MouseButton1Click:Connect(function()
                index = (index % #options) + 1
                selected = options[index]
                Dropdown.Text = "▼ " .. selected
                pcall(callback, selected)
            end)
            addElement(Dropdown)
        end

        return sectionAPI
    end

    return SectionFunctions
end

return VampzLib
