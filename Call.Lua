-- Hextia UI Library for Roblox
-- Author: GitHub Copilot
-- Usage: local Hextia = require(path.to.Hextia)

local Hextia = {}
Hextia.__index = Hextia

local TweenService = game:GetService("TweenService")

-- Utility functions
local function create(instanceType, props)
    local obj = Instance.new(instanceType)
    for k, v in pairs(props or {}) do
        if type(k) == "number" then
            v.Parent = obj
        else
            obj[k] = v
        end
    end
    return obj
end
-- Theme (dynamic rainbow)
local theme = {
    Background = Color3.fromRGB(30, 32, 48),
    Accent = Color3.fromRGB(255, 0, 60),
    Button = Color3.fromRGB(44, 47, 63),
    ButtonHover = Color3.fromRGB(255, 0, 60),
    Text = Color3.fromRGB(255, 255, 255),
    Section = Color3.fromRGB(36, 38, 56),
}

-- Rainbow color generator
local function getRainbowColor(speed, offset)
    local t = tick() * (speed or 1) + (offset or 0)
    local hue = (t % 1)
    return Color3.fromHSV(hue, 1, 1)
end

-- Animate theme.Accent as rainbow
spawn(function()
    while true do
        local accent = getRainbowColor(0.2)
        theme.Accent = accent
        theme.ButtonHover = accent
        -- Update all UI elements using the accent color
        for _, gui in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name == "HextiaUI" then
                local main = gui:FindFirstChild("Main")
                if main then
                    local titleBar = main:FindFirstChild("TitleBar")
                    if titleBar then
                        titleBar.BackgroundColor3 = accent
                    end
                    -- Update buttons and toggles
                    local container = main:FindFirstChild("Container")
                    if container then
                        for _, section in ipairs(container:GetChildren()) do
                            if section:IsA("Frame") then
                                local content = section:FindFirstChild("Content")
                                if content then
                                    for _, item in ipairs(content:GetChildren()) do
                                        if item:IsA("TextButton") then
                                            -- Only update if button is hovered, otherwise keep Button color
                                            if item.BackgroundColor3 == theme.ButtonHover or item.BackgroundColor3 == theme.Accent then
                                                item.BackgroundColor3 = accent
                                            end
                                        elseif item:IsA("Frame") then
                                            -- For toggles, update the fill color
                                            local indicator = item:FindFirstChildWhichIsA("Frame")
                                            if indicator then
                                                local fill = indicator:FindFirstChildWhichIsA("Frame")
                                                if fill then
                                                    fill.BackgroundColor3 = accent
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.03)
    end
end)


-- Main Window
function Hextia:CreateWindow(title, size)
    local self = setmetatable({}, Hextia)

    -- ScreenGui
    self.Gui = create("ScreenGui", {
        Name = "HextiaUI",
        ResetOnSpawn = false,
        Parent = game:GetService("Players").LocalPlayer.PlayerGui
    })

    -- Main Frame
    self.Main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, size.X or 400, 0, size.Y or 300),
        Position = UDim2.new(0.5, -(size.X or 400)/2, 0.5, -(size.Y or 300)/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Parent = self.Gui
    })

    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.Main})

    -- Title Bar
    self.TitleBar = create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.TitleBar})

    self.Title = create("TextLabel", {
        Name = "Title",
        Text = title or "Hextia UI",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.TitleBar
    })

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)

    -- Container for sections
    self.Container = create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, -20, 1, -56),
        Position = UDim2.new(0, 10, 0, 46),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    self.UIListLayout = create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Container
    })

    return self
end

-- Section
function Hextia:CreateSection(title)
    local section = create("Frame", {
        Name = "Section",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = theme.Section,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = section})

    local label = create("TextLabel", {
        Name = "SectionTitle",
        Text = title or "Section",
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 24),
        Position = UDim2.new(0, 5, 0, 2),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section
    })

    local content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -10, 1, -28),
        Position = UDim2.new(0, 5, 0, 26),
        BackgroundTransparency = 1,
        Parent = section
    })

    local layout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = content
    })

    return {
        Section = section,
        Content = content,
        AddButton = function(self, text, callback)
            local btn = create("TextButton", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundColor3 = theme.Button,
                Size = UDim2.new(1, 0, 0, 32),
                AutoButtonColor = false,
                Parent = content
            })
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = btn})

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.ButtonHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Button}):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            return btn
        end,
        AddToggle = function(self, text, default, callback)
            local toggle = false
            local btn = create("TextButton", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundColor3 = theme.Button,
                Size = UDim2.new(1, 0, 0, 32),
                AutoButtonColor = false,
                Parent = content
            })
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = btn})

            local indicator = create("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -28, 0.5, -10),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Parent = btn
            })
            create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = indicator})

            local fill = create("Frame", {
                Size = UDim2.new(1, -6, 1, -6),
                Position = UDim2.new(0, 3, 0, 3),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Visible = default or false,
                Parent = indicator
            })
            create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

            toggle = default or false

            btn.MouseButton1Click:Connect(function()
                toggle = not toggle
                fill.Visible = toggle
                if callback then callback(toggle) end
            end)
            return btn
        end,
        AddSlider = function(self, text, min, max, default, callback)
            local value = default or min
            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Parent = content
            })

            local label = create("TextLabel", {
                Text = text .. ": " .. tostring(value),
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Parent = frame
            })

            local sliderBar = create("Frame", {
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 0, 22),
                BackgroundColor3 = theme.Button,
                BorderSizePixel = 0,
                Parent = frame
            })
            create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderBar})

            local sliderFill = create("Frame", {
                Size = UDim2.new((value-min)/(max-min), 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Parent = sliderBar
            })
            create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderFill})

            local dragging = false
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                    rel = math.clamp(rel, 0, 1)
                    value = math.floor((min + (max-min)*rel) + 0.5)
                    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
                    label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end
            end)
            return frame
        end,
        AddTextbox = function(self, text, default, callback)
            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent = content
            })
            local label = create("TextLabel", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            local box = create("TextBox", {
                Text = default or "",
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundColor3 = theme.Button,
                Size = UDim2.new(0.6, -10, 1, 0),
                Position = UDim2.new(0.4, 10, 0, 0),
                Parent = frame
            })
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = box})

            box.FocusLost:Connect(function(enter)
                if enter and callback then
                    callback(box.Text)
                end
            end)
            return frame
        end,
        AddDropdown = function(self, text, options, callback)
            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent = content
            })
            local label = create("TextLabel", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            local btn = create("TextButton", {
                Text = options[1] or "",
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = theme.Text,
                BackgroundColor3 = theme.Button,
                Size = UDim2.new(0.6, -10, 1, 0),
                Position = UDim2.new(0.4, 10, 0, 0),
                AutoButtonColor = false,
                Parent = frame
            })
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = btn})

            local open = false
            local dropdownFrame

            btn.MouseButton1Click:Connect(function()
                if open then
                    if dropdownFrame then dropdownFrame:Destroy() end
                    open = false
                else
                    open = true
                    dropdownFrame = create("Frame", {
                        Size = UDim2.new(0, btn.AbsoluteSize.X, 0, #options*28),
                        Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y),
                        BackgroundColor3 = theme.Section,
                        BorderSizePixel = 0,
                        Parent = game:GetService("CoreGui")
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = dropdownFrame})

                    for i, opt in ipairs(options) do
                        local optBtn = create("TextButton", {
                            Text = opt,
                            Font = Enum.Font.Gotham,
                            TextSize = 15,
                            TextColor3 = theme.Text,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 28),
                            Position = UDim2.new(0, 0, 0, (i-1)*28),
                            Parent = dropdownFrame
                        })
                        optBtn.MouseButton1Click:Connect(function()
                            btn.Text = opt
                            if callback then callback(opt) end
                            dropdownFrame:Destroy()
                            open = false
                        end)
                    end
                end
            end)
            return frame
        end
    }
end

return Hextia

