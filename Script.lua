-- Fly Script with Dynamic Thumbstick for Roblox by Hunter
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Position = UDim2.new(0.5, -75, 0.8, -50) -- Lower for mobile
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "Fly Owned by Hunter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 100, 0, 30)
FlyButton.Position = UDim2.new(0.5, -50, 0, 50)
FlyButton.Text = "Toggle Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
FlyButton.TextScaled = true
FlyButton.Font = Enum.Font.Gotham
FlyButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = FlyButton

-- Draggable UI
local dragging = false
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Fly functionality
local flying = false
local speed = 50
local bodyVelocity = nil
local thumbstickInput = Vector3.new(0, 0, 0)

local function toggleFly()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    if flying then
        flying = false
        FlyButton.Text = "Enable Fly"
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        ContextActionService:UnbindAction("FlyThumbstick")
    else
        flying = true
        FlyButton.Text = "Disable Fly"
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = Player.Character.HumanoidRootPart

        -- Bind thumbstick for mobile
        ContextActionService:BindAction("FlyThumbstick", function(actionName, inputState, inputObject)
            if inputState == Enum.UserInputState.Change and flying then
                local moveDirection = inputObject.Position
                thumbstickInput = Player.Character.HumanoidRootPart.CFrame * Vector3.new(moveDirection.X * speed, moveDirection.Y * speed, -moveDirection.Y * speed)
            elseif inputState == Enum.UserInputState.End then
                thumbstickInput = Vector3.new(0, 0, 0)
            end
            return Enum.ContextActionResult.Pass
        end, true, Enum.KeyCode.Thumbstick1)
    end
end

FlyButton.MouseButton1Click:Connect(toggleFly)

-- PC controls (W, S, Space, LeftControl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        if input.KeyCode == Enum.KeyCode.W then
            thumbstickInput = Player.Character.HumanoidRootPart.CFrame.LookVector * speed
        elseif input.KeyCode == Enum.KeyCode.S then
            thumbstickInput = Player.Character.HumanoidRootPart.CFrame.LookVector * -speed
        elseif input.KeyCode == Enum.KeyCode.Space then
            thumbstickInput = Vector3.new(0, speed, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            thumbstickInput = Vector3.new(0, -speed, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and flying and (input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl) then
        thumbstickInput = Vector3.new(0, 0, 0)
    end
end)

-- Update velocity
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        bodyVelocity.Velocity = thumbstickInput
    end
end)

-- Reset on character respawn
Player.CharacterAdded:Connect(function(character)
    flying = false
    FlyButton.Text = "Enable Fly"
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    thumbstickInput = Vector3.new(0, 0, 0)
    ContextActionService:UnbindAction("FlyThumbstick")
end)
