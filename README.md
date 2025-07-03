-- Fly Script with UI for Roblox by Hunter
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 2
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Fly Owned by Hunter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextScaled = true
Title.Parent = Frame

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 100, 0, 30)
FlyButton.Position = UDim2.new(0.5, -50, 0, 50)
FlyButton.Text = "Toggle Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
FlyButton.TextScaled = true
FlyButton.Parent = Frame

-- Fly functionality
local flying = false
local speed = 50
local bodyVelocity = nil

local function toggleFly()
    if flying then
        flying = false
        FlyButton.Text = "Enable Fly"
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    else
        flying = true
        FlyButton.Text = "Disable Fly"
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = Player.Character.HumanoidRootPart
    end
end

FlyButton.MouseButton1Click:Connect(toggleFly)

-- Fly controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and flying then
        if input.KeyCode == Enum.KeyCode.W then
            bodyVelocity.Velocity = Player.Character.HumanoidRootPart.CFrame.LookVector * speed
        elseif input.KeyCode == Enum.KeyCode.S then
            bodyVelocity.Velocity = Player.Character.HumanoidRootPart.CFrame.LookVector * -speed
        elseif input.KeyCode == Enum.KeyCode.Space then
            bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            bodyVelocity.Velocity = Vector3.new(0, -speed, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and flying then
        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
           input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)
