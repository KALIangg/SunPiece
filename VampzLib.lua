local VampzLib = {}

local TweenService = game:GetService("TweenService")

function VampzLib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "VampzUI"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(255, 136, 0)

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 6)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 " .. title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    local ContentScroller = Instance.new("ScrollingFrame", MainFrame)
    ContentScroller.Size = UDim2.new(1, 0, 1, -40)
    ContentScroller.Position = UDim2.new(0, 0, 0, 40)
    ContentScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroller.BackgroundTransparency = 1
    ContentScroller.ScrollBarThickness = 6
    ContentScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local Layout = Instance.new("UIListLayout", ContentScroller)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)

    function VampzLib:AddSection(sectionName)
        local SectionHolder = Instance.new("Frame")
        SectionHolder.Size = UDim2.new(1, -10, 0, 30)
        SectionHolder.BackgroundTransparency = 1
        SectionHolder.AutomaticSize = Enum.AutomaticSize.Y
        SectionHolder.LayoutOrder = 1

        local Toggle = Instance.new("TextButton", SectionHolder)
        Toggle.Size = UDim2.new(1, 0, 0, 30)
        Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Toggle.Text = "▼ " .. sectionName
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 16
        Toggle.AutoButtonColor = false

        local UICorner = Instance.new("UICorner", Toggle)
        UICorner.CornerRadius = UDim.new(0, 4)

        local Container = Instance.new("Frame", SectionHolder)
        Container.Size = UDim2.new(1, 0, 0, 0)
        Container.BackgroundTransparency = 1
        Container.ClipsDescendants = true
        Container.Visible = false

        local ListLayout = Instance.new("UIListLayout", Container)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 4)

        local padding = Instance.new("UIPadding", Container)
        padding.PaddingTop = UDim.new(0, 4)
        padding.PaddingBottom = UDim.new(0, 4)

        local open = false

        Toggle.MouseButton1Click:Connect(function()
            open = not open
            Container.Visible = true

            Toggle.Text = (open and "▲ " or "▼ ") .. sectionName

            local targetHeight = 0
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("GuiObject") then
                    targetHeight += child.AbsoluteSize.Y + ListLayout.Padding.Offset
                end
            end

            local tween = TweenService:Create(Container, TweenInfo.new(0.25), {
                Size = open and UDim2.new(1, 0, 0, targetHeight) or UDim2.new(1, 0, 0, 0)
            })
            tween:Play()

            if not open then
                tween.Completed:Wait()
                Container.Visible = false
            end
        end)

        SectionHolder.Parent = ContentScroller
        return {
            AddButton = function(_, name, callback)
                local Btn = Instance.new("TextButton", Container)
                Btn.Size = UDim2.new(1, 0, 0, 30)
                Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                Btn.Text = name
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 14
                Btn.AutoButtonColor = true

                local corner = Instance.new("UICorner", Btn)
                corner.CornerRadius = UDim.new(0, 4)

                Btn.MouseButton1Click:Connect(callback)
            end
        }
    end

    return VampzLib
end

return VampzLib
