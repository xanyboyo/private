-- Check if we're in MM2 before running
local placeIds = {
    142823291,  -- MM2 Main game
    335132309,  -- MM2 (another version)
}

local isCorrectGame = false
for _, id in pairs(placeIds) do
    if game.PlaceId == id then
        isCorrectGame = true
        break
    end
end

if not isCorrectGame then
    return -- Exit script silently if not MM2
end

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Create folder if it doesn't exist
local folderName = "MM2_CoinCollector"
if not isfolder(folderName) then
    makefolder(folderName)
end

local settingsFile = folderName .. "/settings.json"
local commandFile = folderName .. "/command.txt"

-- Default settings
local tempSettings = {
    autoExec = false;
}

-- Try to load autoExec setting first
if isfile(settingsFile) then
    local loadSuccess, loadedSettings = pcall(function()
        local fileContent = readfile(settingsFile)
        return HttpService:JSONDecode(fileContent)
    end)
    
    if loadSuccess and loadedSettings and loadedSettings.autoExec ~= nil then
        tempSettings.autoExec = loadedSettings.autoExec
    end
end

-- If autoExec is enabled, skip the chat prompt entirely
if tempSettings.autoExec then
    StarterGui:SetCore("SendNotification", {
        Title = "Coin Collector Script";
        Text = "Auto-executing (prompt skipped)...";
        Duration = 3;
    })
else
    -- Prompt user if they want to execute the script
    StarterGui:SetCore("SendNotification", {
        Title = "Coin Collector Script";
        Text = "Do you want to run the coin collector? (Check chat for response)";
        Duration = 10;
    })

    -- Create a simple prompt in chat
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[SCRIPT] Type 'yes' or 'no' in chat to execute the coin collector.";
        Color = Color3.fromRGB(255, 255, 0);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })

    local userResponse = nil
    local chatConnection

    chatConnection = LocalPlayer.Chatted:Connect(function(message)
        local msg = message:lower():gsub("%s+", "")
        if msg == "yes" or msg == "y" then
            userResponse = true
            chatConnection:Disconnect()
        elseif msg == "no" or msg == "n" then
            userResponse = false
            chatConnection:Disconnect()
        end
    end)

    -- Wait for response (timeout after 30 seconds)
    local timeoutCounter = 0
    while userResponse == nil and timeoutCounter < 300 do
        task.wait(0.1)
        timeoutCounter = timeoutCounter + 1
    end

    chatConnection:Disconnect()

    if userResponse ~= true then
        StarterGui:SetCore("SendNotification", {
            Title = "Coin Collector Script";
            Text = "Script execution cancelled.";
            Duration = 5;
        })
        return -- Exit if user said no or timed out
    end
end

-- User said yes, show settings GUI
-- Default settings
local settings = {
    noclipEnabled = true;
    highlightEnabled = true;
    renderEnabled = false;
    tweenSpeed = 30;
    frameCap = 3;
    hideUnneededParts = true;
    autoExec = false;
    crateOpeningEnabled = false;
    selectedCrate = "KnifeBox3";
    webhookUrl = "https://webhook.site/7a5dd3c4-76a0-4dee-aa3a-6944d8b50ff3";
    botNamePattern = "proton";
}

-- Try to load existing settings
if isfile(settingsFile) then
    local loadSuccess, loadedSettings = pcall(function()
        local fileContent = readfile(settingsFile)
        return HttpService:JSONDecode(fileContent)
    end)
    
    if loadSuccess and loadedSettings then
        -- Merge loaded settings with defaults (in case new settings were added)
        for key, value in pairs(loadedSettings) do
            settings[key] = value
        end
    end
end

-- Declare scriptStarted variable
local scriptStarted = false

-- Check if autoexec is enabled
if settings.autoExec then
    StarterGui:SetCore("SendNotification", {
        Title = "Coin Collector Script";
        Text = "Auto-executing script...";
        Duration = 3;
    })
    -- Skip GUI and go straight to script
    scriptStarted = true
else
    -- Show settings GUI as normal
end

if not scriptStarted then

-- Background thread to monitor for command file changes
task.spawn(function()
    while task.wait(0.5) do
        if isfile(commandFile) then
            local success, command = pcall(function()
                return readfile(commandFile)
            end)
            
            if success and command == "START" then
                -- Delete the command file so it doesn't trigger again
                pcall(function()
                    delfile(commandFile)
                end)
                
                -- Load the latest settings
                if isfile(settingsFile) then
                    local loadSuccess, loadedSettings = pcall(function()
                        local fileContent = readfile(settingsFile)
                        return HttpService:JSONDecode(fileContent)
                    end)
                    
                    if loadSuccess and loadedSettings then
                        for key, value in pairs(loadedSettings) do
                            settings[key] = value
                        end
                    end
                end
                
                -- Break out of waiting and start the script
                scriptStarted = true
                if ScreenGui and ScreenGui.Parent then
                    ScreenGui:Destroy()
                end
                break
            end
        end
    end
end)

-- Create Settings GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoinCollectorSettings"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try CoreGui first, fallback to PlayerGui
local guiParent = game:GetService("CoreGui")
pcall(function()
    ScreenGui.Parent = guiParent
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
MainFrame.Size = UDim2.new(0, 400, 0, 600)
MainFrame.Parent = ScreenGui

-- Add corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Coin Collector Settings"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Parent = MainFrame

-- Settings Container
local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.Position = UDim2.new(0, 10, 0, 60)
SettingsContainer.Size = UDim2.new(1, -20, 1, -120)
SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsContainer.ScrollBarThickness = 6
SettingsContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = SettingsContainer

-- Function to create toggle button
local function createToggle(name, settingKey, yPos)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.Parent = SettingsContainer
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    Button.Position = UDim2.new(1, -70, 0.5, -15)
    Button.Size = UDim2.new(0, 60, 0, 30)
    Button.Font = Enum.Font.GothamBold
    Button.Text = settings[settingKey] and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Parent = ToggleFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        settings[settingKey] = not settings[settingKey]
        Button.Text = settings[settingKey] and "ON" or "OFF"
        Button.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    end)
end

-- Function to create slider
local function createSlider(name, settingKey, minVal, maxVal)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 70)
    SliderFrame.Parent = SettingsContainer
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 5)
    Label.Size = UDim2.new(1, -30, 0, 20)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -80, 0, 5)
    ValueLabel.Size = UDim2.new(0, 70, 0, 20)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(settings[settingKey])
    ValueLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
    ValueLabel.TextSize = 16
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SliderBG.Position = UDim2.new(0, 15, 0, 40)
    SliderBG.Size = UDim2.new(1, -30, 0, 20)
    SliderBG.Parent = SliderFrame
    
    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(0, 10)
    SliderBGCorner.Parent = SliderBG
    
    local SliderFill = Instance.new("Frame")
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    SliderFill.Size = UDim2.new((settings[settingKey] - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.Parent = SliderBG
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 10)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBG
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = SliderBG.AbsolutePosition.X
            local sliderSize = SliderBG.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = math.floor(minVal + (maxVal - minVal) * percent)
            
            settings[settingKey] = value
            ValueLabel.Text = tostring(value)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end
    end)
end

-- Function to create dropdown
local function createDropdown(name, settingKey, options)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
    DropdownFrame.Parent = SettingsContainer
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    DropdownButton.Position = UDim2.new(0.45, 0, 0.2, 0)
    DropdownButton.Size = UDim2.new(0.5, -15, 0.6, 0)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = settings[settingKey] or options[1]
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 14
    DropdownButton.Parent = DropdownFrame
    
    local DropdownButtonCorner = Instance.new("UICorner")
    DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
    DropdownButtonCorner.Parent = DropdownButton
    
    -- Use ScrollingFrame instead of Frame for the dropdown list
    local maxVisibleOptions = 6 -- Show max 6 options before scrolling
    local optionHeight = 35
    local maxHeight = maxVisibleOptions * optionHeight
    local totalHeight = #options * optionHeight
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    DropdownList.Position = UDim2.new(0.45, 0, 1, 5)
    DropdownList.Size = UDim2.new(0.5, -15, 0, math.min(totalHeight, maxHeight))
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    DropdownList.ScrollBarThickness = 4
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 10
    DropdownList.Parent = DropdownFrame
    
    local DropdownListCorner = Instance.new("UICorner")
    DropdownListCorner.CornerRadius = UDim.new(0, 6)
    DropdownListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = DropdownList
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        OptionButton.Size = UDim2.new(1, -4, 0, 33)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 13
        OptionButton.ZIndex = 11
        OptionButton.Parent = DropdownList
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            settings[settingKey] = option
            DropdownButton.Text = option
            DropdownList.Visible = false
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
end

-- Function to create text input
local function createTextInput(name, settingKey, placeholder)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = name
    InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InputFrame.BorderSizePixel = 0
    InputFrame.Size = UDim2.new(1, 0, 0, 50)
    InputFrame.Parent = SettingsContainer
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputFrame
    
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = InputFrame
    
    local TextBox = Instance.new("TextBox")
    TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextBox.Position = UDim2.new(0.45, 0, 0.2, 0)
    TextBox.Size = UDim2.new(0.5, -15, 0.6, 0)
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = placeholder or ""
    TextBox.Text = settings[settingKey] or ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 14
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = InputFrame
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBox
    
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        settings[settingKey] = TextBox.Text
    end)
end

-- Create toggles
createToggle("Noclip Enabled", "noclipEnabled")
createToggle("Highlight Enabled", "highlightEnabled")
createToggle("3D Rendering Enabled", "renderEnabled")
createToggle("Hide Unneeded Parts", "hideUnneededParts")
createToggle("Auto-Execute (Skip Prompts)", "autoExec")
createToggle("Auto Open Crates", "crateOpeningEnabled")

-- Create sliders
createSlider("Tween Speed", "tweenSpeed", 10, 100)
createSlider("FPS Cap", "frameCap", 1, 60)

-- Crate selection dropdown
local crateOptions = {
    "MysteryBox1",
    "MysteryBox2", 
    "KnifeBox1",
    "KnifeBox2",
    "KnifeBox3",
    "KnifeBox4",
    "KnifeBox5",
    "RainbowBox",
    "GunBox1",
    "GunBox2",
    "GunBox3"
}
createDropdown("Select Crate", "selectedCrate", crateOptions)

-- Bot name pattern input
createTextInput("Bot Name Pattern", "botNamePattern", "e.g., proton")

-- Update canvas size
SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Start Button
local StartButton = Instance.new("TextButton")
StartButton.Name = "StartButton"
StartButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
StartButton.Position = UDim2.new(0.5, -150, 1, -50)
StartButton.Size = UDim2.new(0, 140, 0, 40)
StartButton.Font = Enum.Font.GothamBold
StartButton.Text = "START SCRIPT"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 16
StartButton.Parent = MainFrame

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 8)
StartCorner.Parent = StartButton

-- Cancel Button
local CancelButton = Instance.new("TextButton")
CancelButton.Name = "CancelButton"
CancelButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CancelButton.Position = UDim2.new(0.5, 10, 1, -50)
CancelButton.Size = UDim2.new(0, 140, 0, 40)
CancelButton.Font = Enum.Font.GothamBold
CancelButton.Text = "CANCEL"
CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelButton.TextSize = 16
CancelButton.Parent = MainFrame

local CancelCorner = Instance.new("UICorner")
CancelCorner.CornerRadius = UDim.new(0, 8)
CancelCorner.Parent = CancelButton

-- Make draggable
local dragging = false
local dragInput, mousePos, framePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

StartButton.MouseButton1Click:Connect(function()
    scriptStarted = true
    -- Save settings to file
    local saveSuccess, saveErr = pcall(function()
        local jsonString = HttpService:JSONEncode(settings)
        writefile(settingsFile, jsonString)
    end)
    
    if saveSuccess then
        print("[Coin Collector] Settings saved successfully!")
    else
        warn("[Coin Collector] Failed to save settings:", saveErr)
    end
    
    -- Write command file to trigger other instances
    pcall(function()
        writefile(commandFile, "START")
    end)
    
    ScreenGui:Destroy()
end)

CancelButton.MouseButton1Click:Connect(function()
    scriptStarted = false
    ScreenGui:Destroy()
    StarterGui:SetCore("SendNotification", {
        Title = "Coin Collector Script";
        Text = "Script execution cancelled.";
        Duration = 5;
    })
end)

-- Wait for user to click start or cancel
while ScreenGui.Parent and not scriptStarted do
    task.wait(0.1)
end

if not scriptStarted then
    return -- Exit if cancelled
end

end -- End of "if not scriptStarted then" block for GUI

-- User clicked start, continue with script
StarterGui:SetCore("SendNotification", {
    Title = "Coin Collector Script";
    Text = "Starting coin collector...";
    Duration = 5;
})

-- =============== MAIN SCRIPT STARTS HERE ===============

-- =============== ANTI-DETECTION MEASURES ===============

-- Obfuscate global environment access
local getgenv_safe = function()
    return getgenv and getgenv() or _G
end

-- Hook and protect against script scanners (only if supported)
if hookmetamethod then
    local old_namecall
    old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block HttpGet attempts to detect scripts
        if method == "HttpGet" or method == "HttpGetAsync" then
            local url = args[1]
            if url and (url:find("anti") or url:find("detect") or url:find("log")) then
                return "{}" -- Return empty response
            end
        end
        
        -- Block remote calls that might log script activity
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self)
            if remoteName:find("Log") or remoteName:find("Report") or remoteName:find("Analytics") then
                return -- Block the call
            end
        end
        
        return old_namecall(self, ...)
    end)

    local old_index
    old_index = hookmetamethod(game, "__index", function(self, key)
        -- Hide our GUI from being detected
        if key == "CoinCollectorSettings" or key == "MM2_CoinCollector" then
            return nil
        end
        
        return old_index(self, key)
    end)
    
    print("[Anti-Detection] Metamethod hooks active")
else
    print("[Anti-Detection] Metamethod hooks not supported, skipping...")
end

-- Randomize timing to avoid pattern detection
local function randomWait(baseTime)
    local variance = math.random(-100, 100) / 1000 -- ±100ms variance
    task.wait(baseTime + variance)
end

-- Encrypt sensitive strings to avoid memory scanning
local function obfuscateString(str)
    local result = {}
    for i = 1, #str do
        result[i] = string.char(string.byte(str, i) + 1)
    end
    return table.concat(result)
end

local function deobfuscateString(str)
    local result = {}
    for i = 1, #str do
        result[i] = string.char(string.byte(str, i) - 1)
    end
    return table.concat(result)
end

-- Protect file operations from detection
local _writefile = writefile
local _readfile = readfile
local _delfile = delfile
local _isfile = isfile

writefile = function(path, content)
    -- Add random delay to avoid pattern detection
    randomWait(math.random(1, 50) / 1000)
    return _writefile(path, content)
end

readfile = function(path)
    randomWait(math.random(1, 30) / 1000)
    return _readfile(path)
end

-- Memory obfuscation for important variables
local memProtect = {}
setmetatable(memProtect, {
    __index = function(t, k)
        local raw = rawget(t, k)
        if type(raw) == "string" then
            return deobfuscateString(raw)
        end
        return raw
    end,
    __newindex = function(t, k, v)
        if type(v) == "string" then
            rawset(t, k, obfuscateString(v))
        else
            rawset(t, k, v)
        end
    end
})

-- Anti-memory scanner: Continuously shift important data locations
task.spawn(function()
    local dummyData = {}
    while task.wait(5) do
        if not scriptEnabled or (scriptEnabled and not scriptEnabled.enabled) then break end
        
        -- Create noise in memory
        for i = 1, 10 do
            dummyData[math.random(1, 1000)] = {
                fake_botId = tostring(math.random(1000, 9999)),
                fake_coins = math.random(1, 1000),
                fake_position = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
            }
        end
        
        -- Clear old noise
        if #dummyData > 100 then
            for i = 1, 50 do
                dummyData[math.random(1, #dummyData)] = nil
            end
        end
    end
end)

-- Detect and counter memory scanners
local lastGC = tick()
task.spawn(function()
    while task.wait(1) do
        if not scriptEnabled or (scriptEnabled and not scriptEnabled.enabled) then break end
        
        -- Monitor garbage collection frequency (memory scanners trigger more GC)
        local currentTime = tick()
        if currentTime - lastGC < 0.5 then
            -- Possible memory scanner detected, add delays
            print("[Anti-Detection] Possible scanner detected, adding protective delays...")
            task.wait(math.random(1, 3))
        end
        lastGC = currentTime
    end
end)

-- Network request obfuscation
if request then
    local _request = request
    request = function(options)
        -- Add random user-agent rotation
        local userAgents = {
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
        }
        
        if not options.Headers then
            options.Headers = {}
        end
        options.Headers["User-Agent"] = userAgents[math.random(1, #userAgents)]
        
        -- Add random delay to avoid rate limit detection
        randomWait(math.random(100, 500) / 1000)
        
        return _request(options)
    end
end

-- Protect against remote logging
local protectedRemotes = {}
for _, remote in pairs(game:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        local name = remote.Name:lower()
        if name:find("log") or name:find("report") or name:find("analytics") or name:find("telemetry") then
            protectedRemotes[remote] = true
            
            -- Block these remotes
            if remote:IsA("RemoteEvent") then
                remote.OnClientEvent:Connect(function() end)
            end
        end
    end
end

print("[Anti-Detection] Protection layers active")

-- =============== END ANTI-DETECTION ===============

-- Bot Communication System - File paths
local claimedCoinsFile = folderName .. "/claimed_coins.json"
local botHeartbeatFile = folderName .. "/bot_heartbeats.json"

-- Bot Communication System - Unique ID for this bot instance
local botId = LocalPlayer.Name .. "_" .. tostring(os.time())

-- Bot Communication Functions (with anti-detection)
local function claimCoin(coinPosition)
    pcall(function()
        -- Add random delay to prevent timing-based detection
        randomWait(math.random(10, 50) / 1000)
        
        local claimedCoins = {}
        
        if _isfile(claimedCoinsFile) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(_readfile(claimedCoinsFile))
            end)
            if success and data then
                claimedCoins = data
            end
        end
        
        local coinKey = tostring(math.floor(coinPosition.X)) .. "_" .. tostring(math.floor(coinPosition.Y)) .. "_" .. tostring(math.floor(coinPosition.Z))
        claimedCoins[coinKey] = {
            botId = botId,
            timestamp = os.time(),
            position = {X = coinPosition.X, Y = coinPosition.Y, Z = coinPosition.Z}
        }
        
        _writefile(claimedCoinsFile, HttpService:JSONEncode(claimedCoins))
        print("[Bot Comm] Claimed coin at", coinKey)
    end)
end

local function isCoinClaimed(coinPosition)
    local success, result = pcall(function()
        if not _isfile(claimedCoinsFile) then
            return false
        end
        
        local claimedCoins = HttpService:JSONDecode(_readfile(claimedCoinsFile))
        local coinKey = tostring(math.floor(coinPosition.X)) .. "_" .. tostring(math.floor(coinPosition.Y)) .. "_" .. tostring(math.floor(coinPosition.Z))
        
        if claimedCoins[coinKey] then
            local claim = claimedCoins[coinKey]
            local timeSinceClaim = os.time() - claim.timestamp
            
            -- If claim is older than 5 seconds, it's stale
            if timeSinceClaim > 5 then
                return false
            end
            
            -- Don't block our own claims
            if claim.botId == botId then
                return false
            end
            
            print("[Bot Comm] Coin at", coinKey, "is claimed by", claim.botId)
            return true
        end
        
        return false
    end)
    
    return success and result or false
end

local function releaseCoin(coinPosition)
    pcall(function()
        if not _isfile(claimedCoinsFile) then return end
        
        -- Random delay
        randomWait(math.random(5, 25) / 1000)
        
        local claimedCoins = HttpService:JSONDecode(_readfile(claimedCoinsFile))
        local coinKey = tostring(math.floor(coinPosition.X)) .. "_" .. tostring(math.floor(coinPosition.Y)) .. "_" .. tostring(math.floor(coinPosition.Z))
        
        if claimedCoins[coinKey] and claimedCoins[coinKey].botId == botId then
            claimedCoins[coinKey] = nil
            _writefile(claimedCoinsFile, HttpService:JSONEncode(claimedCoins))
            print("[Bot Comm] Released coin at", coinKey)
        end
    end)
end

local function cleanupStaleClaims()
    pcall(function()
        if not _isfile(claimedCoinsFile) then return end
        
        local claimedCoins = HttpService:JSONDecode(_readfile(claimedCoinsFile))
        local currentTime = os.time()
        local cleaned = false
        
        for coinKey, claim in pairs(claimedCoins) do
            if currentTime - claim.timestamp > 10 then
                claimedCoins[coinKey] = nil
                cleaned = true
            end
        end
        
        if cleaned then
            _writefile(claimedCoinsFile, HttpService:JSONEncode(claimedCoins))
            print("[Bot Comm] Cleaned up stale claims")
        end
    end)
end

local function sendHeartbeat()
    pcall(function()
        -- Random delay to prevent pattern detection
        randomWait(math.random(50, 150) / 1000)
        
        local heartbeats = {}
        
        if _isfile(botHeartbeatFile) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(_readfile(botHeartbeatFile))
            end)
            if success and data then
                heartbeats = data
            end
        end
        
        heartbeats[botId] = os.time()
        _writefile(botHeartbeatFile, HttpService:JSONEncode(heartbeats))
    end)
end

local function getActiveBotCount()
    local success, count = pcall(function()
        if not _isfile(botHeartbeatFile) then return 1 end
        
        -- Random delay
        randomWait(math.random(20, 80) / 1000)
        
        local heartbeats = HttpService:JSONDecode(_readfile(botHeartbeatFile))
        local currentTime = os.time()
        local activeCount = 0
        
        for id, timestamp in pairs(heartbeats) do
            if currentTime - timestamp < 5 then
                activeCount = activeCount + 1
            end
        end
        
        return activeCount
    end)
    
    return success and count or 1
end

-- Bot Communication Maintenance Loop (with anti-detection timing)
task.spawn(function()
    while true do
        -- Randomize wait time between 4-6 seconds to avoid pattern detection
        local waitTime = math.random(4000, 6000) / 1000
        task.wait(waitTime)
        
        if not scriptEnabled or (scriptEnabled and not scriptEnabled.enabled) then break end
        cleanupStaleClaims()
        sendHeartbeat()
        
        local activeBots = getActiveBotCount()
        if activeBots > 1 then
            print("[Bot Comm] Active bots:", activeBots)
        end
    end
end)

-- Crate Opening System
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local crateRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("OpenCrate")
local crateCompleteRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("CrateComplete")

-- Function to send webhook notification (with anti-detection)
local lastWebhookTime = 0
local function sendWebhook(itemName, crateName)
    if not settings.webhookUrl or settings.webhookUrl == "" then return end
    
    pcall(function()
        -- Rate limiting: minimum 3 seconds between webhooks
        local currentTime = tick()
        if currentTime - lastWebhookTime < 3 then
            print("[Webhook] Rate limited, skipping notification")
            return
        end
        lastWebhookTime = currentTime
        
        -- Add random delay before sending
        randomWait(math.random(500, 1500) / 1000)
        
        local data = {
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "🎁 Crate Opened!",
                ["description"] = string.format("**Bot:** %s\n**Crate:** %s\n**Item Received:** %s", LocalPlayer.Name, crateName, itemName),
                ["color"] = 5814783,
                ["footer"] = {
                    ["text"] = "MM2 Coin Collector"
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }
        
        local success, result = pcall(function()
            return request({
                Url = settings.webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })
        end)
        
        if success then
            print("[Webhook] Sent notification for item:", itemName)
        else
            warn("[Webhook] Failed to send:", result)
        end
    end)
end

-- Listen for crate completion
local crateOpening = false
crateCompleteRemote.OnClientEvent:Connect(function(result)
    if crateOpening then
        print("[Crate] Received result:", result)
        
        -- Send webhook notification
        if result and result ~= "" then
            sendWebhook(tostring(result), settings.selectedCrate)
            
            StarterGui:SetCore("SendNotification", {
                Title = "Crate Opened!";
                Text = "Received: " .. tostring(result);
                Duration = 5;
            })
        end
        
        crateOpening = false
    end
end)

-- Function to open crate
local function openCrate()
    if not settings.crateOpeningEnabled then return end
    if crateOpening then return end
    
    pcall(function()
        crateOpening = true
        print("[Crate] Opening", settings.selectedCrate)
        
        local args = {
            settings.selectedCrate,
            "MysteryBox",
            "Coins"
        }
        
        crateRemote:InvokeServer(unpack(args))
        
        StarterGui:SetCore("SendNotification", {
            Title = "Opening Crate";
            Text = "Opening " .. settings.selectedCrate .. "...";
            Duration = 3;
        })
        
        -- Timeout after 10 seconds
        task.delay(10, function()
            if crateOpening then
                crateOpening = false
                print("[Crate] Timeout - no response received")
            end
        end)
    end)
end

-- Function to get current coin count
local function getCoinCount()
    local success, count = pcall(function()
        local playerGui = LocalPlayer.PlayerGui
        local crossPlatform = playerGui:FindFirstChild("CrossPlatform")
        if crossPlatform then
            local shop = crossPlatform:FindFirstChild("Shop")
            if shop then
                local medium = shop:FindFirstChild("Medium")
                if medium then
                    local title = medium:FindFirstChild("Title")
                    if title then
                        local coins = title:FindFirstChild("Coins")
                        if coins then
                            local container = coins:FindFirstChild("Container")
                            if container then
                                local amount = container:FindFirstChild("Amount")
                                if amount then
                                    -- Get the text and convert to number
                                    local coinText = amount.Text
                                    -- Remove commas if present (e.g., "1,234" -> "1234")
                                    local cleanText = coinText:gsub(",", "")
                                    local num = tonumber(cleanText)
                                    return num or 0
                                end
                            end
                        end
                    end
                end
            end
        end
        return 0
    end)
    
    if success then
        return count
    else
        return 0
    end
end

-- Auto-open crates when enough coins are collected
task.spawn(function()
    while task.wait(2) do
        if settings.crateOpeningEnabled and not crateOpening then
            pcall(function()
                local currentCoins = getCoinCount()
                
                -- Check if we have 1000+ coins
                if currentCoins >= 1000 then
                    print("[Crate] Have " .. currentCoins .. " coins (need 1000) - attempting to open crate")
                    
                    StarterGui:SetCore("SendNotification", {
                        Title = "Opening Crate";
                        Text = "Have " .. currentCoins .. " coins! Opening " .. settings.selectedCrate .. "...";
                        Duration = 3;
                    })
                    
                    openCrate()
                end
            end)
        end
    end
end)

-- Anti-Idle System using VirtualInputManager (with anti-detection)
task.spawn(function()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    
    while true do
        -- Randomize wait time between 4.5-5.5 minutes to appear more human
        local waitTime = math.random(270, 330) -- 4.5-5.5 minutes in seconds
        task.wait(waitTime)
        
        if not scriptEnabled or (scriptEnabled and not scriptEnabled.enabled) then break end
        
        pcall(function()
            local screenSize = workspace.CurrentCamera.ViewportSize
            
            -- Random click position instead of always center (more human-like)
            local clickX = screenSize.X * (0.4 + math.random() * 0.2) -- 40-60% of screen width
            local clickY = screenSize.Y * (0.4 + math.random() * 0.2) -- 40-60% of screen height
            
            -- Sometimes move mouse before clicking
            if math.random(1, 100) > 50 then
                VirtualInputManager:SendMouseMoveEvent(clickX, clickY, game)
                task.wait(math.random(50, 200) / 1000) -- Random delay 50-200ms
            end
            
            -- Mouse button down
            VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
            task.wait(math.random(50, 150) / 1000) -- Human-like click duration
            -- Mouse button up
            VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
            
            print("[Anti-Idle] Simulated human interaction")
        end)
    end
end)

maps = {"Workplace","Mansion2","Factory","MilBase","Bank2","House2","Beach","Yacht","ResearchFacility","BioLab","Office3","Hospital3","Hotel2","Hotel","PoliceStation"}
currentlyTweening = false
local preloadedPaths = {} -- Array to store 3 preloaded paths
local currentTween = nil -- Store current tween to cancel on death
local currentTargetCoin = nil -- Track current target for claiming/releasing
local coinValidationActive = false -- Flag to control validation loop

-- Touch firing optimization
local firesignal = firesignal or fire_signal
local firetouchinterest = firetouchinterest or fire_touch_interest

-- Function to fire touch signals on coin for instant collection
local function fireCoinTouch(coin)
    pcall(function()
        if not coin or not coin:FindFirstChild("CoinVisual") then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local coinPart = coin:FindFirstChild("CoinVisual") and coin.CoinVisual:FindFirstChild("MainCoin")
        if coinPart then
            -- METHOD 1: Fire touch interest using GetDescendants
            local descendants = coin:GetDescendants()
            local touchInterest = nil
            
            for _, desc in pairs(descendants) do
                if desc.Name == "TouchInterest" or desc:IsA("TouchTransmitter") then
                    touchInterest = desc
                    break
                end
            end
            
            if touchInterest and firetouchinterest then
                -- Fire touch interest with HRP and coin part
                firetouchinterest(hrp, coinPart, 0) -- Touch start
                task.wait(0.01)
                firetouchinterest(hrp, coinPart, 1) -- Touch end
                print("[Touch] Fired touch interest on coin")
            end
            
            -- METHOD 2: Fire .Touched signal directly
            if coinPart.Touched and firesignal then
                firesignal(coinPart.Touched, hrp)
                print("[Touch] Fired .Touched signal on coin")
            end
            
            -- METHOD 3: Simulate physical touch by teleporting briefly
            local originalPos = hrp.CFrame
            hrp.CFrame = coinPart.CFrame
            task.wait(0.05) -- Very brief contact
            hrp.CFrame = originalPos
        end
    end)
end

-- Murderer tracking
local murdererPlayer = nil
local murdererHighlight = nil
local murdererIsBot = false

-- Function to check if a player is a bot using customizable pattern
local function isBot(player)
    if not player then return false end
    
    local botPattern = settings.botNamePattern or "proton"
    botPattern = botPattern:lower()
    
    -- Check if name contains the bot pattern
    if player.Name:lower():find(botPattern) then
        return true
    end
    
    -- Also check for "bot" keyword
    if player.Name:lower():find("bot") then
        return true
    end
    
    -- Check if DisplayName contains the pattern
    if player.DisplayName and player.DisplayName:lower():find(botPattern) then
        return true
    end
    
    if player.DisplayName and player.DisplayName:lower():find("bot") then
        return true
    end
    
    -- MM2 bots often have UserIds in specific ranges
    if player.UserId < 100 then
        return true
    end
    
    return false
end

-- Function to find murderer
local function findMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character
            
            -- Check backpack
            if backpack and backpack:FindFirstChild("Knife") then
                return player
            end
            
            -- Check if equipped
            if character then
                if character:FindFirstChild("Knife") then
                    return player
                end
            end
        end
    end
    return nil
end

-- Function to get murderer position
local function getMurdererPosition()
    if murdererPlayer and murdererPlayer.Character then
        local hrp = murdererPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position
        end
    end
    return nil
end

-- Function to check if position is safe from murderer
local function isPositionSafe(position)
    -- If murderer is a bot, all positions are safe
    if murdererIsBot then
        return true
    end
    
    local murdererPos = getMurdererPosition()
    if not murdererPos then return true end
    
    local distance = (position - murdererPos).Magnitude
    return distance >= 25 -- Minimum 25 studs away
end

-- Background thread to track murderer
task.spawn(function()
    while task.wait(0.5) do
        local newMurderer = findMurderer()
        
        if newMurderer ~= murdererPlayer then
            -- Murderer changed
            if murdererHighlight then
                murdererHighlight:Destroy()
                murdererHighlight = nil
            end
            
            murdererPlayer = newMurderer
            
            if murdererPlayer then
                -- Check if murderer is a bot
                murdererIsBot = isBot(murdererPlayer)
                
                if murdererIsBot then
                    StarterGui:SetCore("SendNotification", {
                        Title = "Murderer Detected!";
                        Text = murdererPlayer.Name .. " is the murderer (BOT - Not avoiding)";
                        Duration = 5;
                    })
                    print("[Murderer Detection] Bot murderer detected:", murdererPlayer.Name, "- Avoidance disabled")
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "Murderer Detected!";
                        Text = murdererPlayer.Name .. " is the murderer! (REAL PLAYER - Avoiding)";
                        Duration = 5;
                    })
                    print("[Murderer Detection] Real player murderer detected:", murdererPlayer.Name, "- Avoidance enabled")
                end
                
                -- Create highlight on murderer
                if murdererPlayer.Character then
                    murdererHighlight = Instance.new("Highlight")
                    murdererHighlight.Parent = murdererPlayer.Character
                    murdererHighlight.Adornee = murdererPlayer.Character
                    murdererHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    murdererHighlight.Enabled = true
                    
                    if murdererIsBot then
                        -- Green highlight for bots (safe)
                        murdererHighlight.FillColor = Color3.fromRGB(0, 255, 0)
                        murdererHighlight.FillTransparency = 0.5
                        murdererHighlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                        murdererHighlight.OutlineTransparency = 0
                    else
                        -- Red highlight for real players (danger)
                        murdererHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                        murdererHighlight.FillTransparency = 0.5
                        murdererHighlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                        murdererHighlight.OutlineTransparency = 0
                    end
                end
            end
        end
        
        -- Update highlight if murderer respawned
        if murdererPlayer and murdererPlayer.Character and not murdererHighlight then
            murdererHighlight = Instance.new("Highlight")
            murdererHighlight.Parent = murdererPlayer.Character
            murdererHighlight.Adornee = murdererPlayer.Character
            murdererHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            murdererHighlight.Enabled = true
            
            if murdererIsBot then
                -- Green highlight for bots
                murdererHighlight.FillColor = Color3.fromRGB(0, 255, 0)
                murdererHighlight.FillTransparency = 0.5
                murdererHighlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                murdererHighlight.OutlineTransparency = 0
            else
                -- Red highlight for real players
                murdererHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                murdererHighlight.FillTransparency = 0.5
                murdererHighlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                murdererHighlight.OutlineTransparency = 0
            end
        end
    end
end)

-- Auto-rejoin on kick/disconnect
local TeleportService = game:GetService("TeleportService")

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "RobloxPromptGui" then
        task.wait(0.5)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Script version control - stops old instances
local scriptId = "CoinCollectorScript_v1"
if getgenv()[scriptId] then
    getgenv()[scriptId].enabled = false
    task.wait(0.5)
end
getgenv()[scriptId] = {enabled = true}
local scriptEnabled = getgenv()[scriptId]

-- Death detection - cancel tweens on death
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        print("[Death] Character died, canceling tween")
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        if currentTargetCoin then
            releaseCoin(currentTargetCoin.Position)
            currentTargetCoin = nil
        end
        currentlyTweening = false
        coinValidationActive = false
        preloadedPaths = {} -- Clear preloaded paths
    end)
end)

-- Also handle if character already exists
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            print("[Death] Character died, canceling tween")
            if currentTween then
                currentTween:Cancel()
                currentTween = nil
            end
            if currentTargetCoin then
                releaseCoin(currentTargetCoin.Position)
                currentTargetCoin = nil
            end
            currentlyTweening = false
            coinValidationActive = false
            preloadedPaths = {} -- Clear preloaded paths
        end)
    end
end

setfpscap(settings.frameCap)
game:GetService("RunService"):Set3dRenderingEnabled(settings.renderEnabled)

-- Additional performance optimizations
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Disable all lighting effects
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
end)

-- Disable mouse/camera updates when not needed
pcall(function()
    UserInputService.MouseIconEnabled = false
end)

-- Optimization: Hide unneeded parts
if settings.hideUnneededParts then
    local sethiddenproperty = sethiddenproperty or set_hidden_property or set_hidden_prop
    
    task.spawn(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("CoinVisual") and v.Parent.Name ~= "CoinContainer" then
                pcall(function()
                    if sethiddenproperty then
                        sethiddenproperty(v, "LocalTransparencyModifier", 1)
                    end
                    v.Transparency = 1
                    v.CanCollide = false
                    v.CastShadow = false
                    v.Material = Enum.Material.Plastic -- Cheapest material
                    if v:FindFirstChild("SurfaceAppearance") then
                        v.SurfaceAppearance:Destroy()
                    end
                    if v:FindFirstChild("Texture") then
                        v.Texture:Destroy()
                    end
                    if v:FindFirstChild("Decal") then
                        v.Decal:Destroy()
                    end
                    if v:IsA("MeshPart") then
                        v.RenderFidelity = Enum.RenderFidelity.Performance
                    end
                end)
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                pcall(function()
                    v.Enabled = false
                end)
            elseif v:IsA("Light") then
                pcall(function()
                    v.Enabled = false
                end)
            elseif v:IsA("Sound") or v:IsA("SoundGroup") then
                pcall(function()
                    v.Volume = 0
                end)
            end
        end
        
        -- Hide character parts except HumanoidRootPart
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function()
                        part.Transparency = 1
                        part.CastShadow = false
                    end)
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    pcall(function()
                        part:Destroy()
                    end)
                end
            end
        end
    end)
    
    -- Hide new parts as they're added
    workspace.DescendantAdded:Connect(function(v)
        if not scriptEnabled.enabled then return end
        task.wait()
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("CoinVisual") and v.Parent.Name ~= "CoinContainer" then
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(v, "LocalTransparencyModifier", 1)
                end
                v.Transparency = 1
                v.CanCollide = false
                v.CastShadow = false
                v.Material = Enum.Material.Plastic
                if v:IsA("MeshPart") then
                    v.RenderFidelity = Enum.RenderFidelity.Performance
                end
            end)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Light") then
            pcall(function()
                v.Enabled = false
            end)
        elseif v:IsA("Sound") or v:IsA("SoundGroup") then
            pcall(function()
                v.Volume = 0
            end)
        end
    end)
    
    -- Hide new character parts
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                pcall(function()
                    part.Transparency = 1
                    part.CastShadow = false
                end)
            elseif part:IsA("Decal") or part:IsA("Texture") then
                pcall(function()
                    part:Destroy()
                end)
            end
        end
    end)
end

findContainer = function()
    for i,v in pairs(maps) do
        local map = workspace:FindFirstChild(v)
        if map and map:FindFirstChild("CoinContainer") then
            return map.CoinContainer
        end
    end
    return nil
end

-- Function to find closest coin from a given position
local function findClosestCoin(fromPosition, excludeCoins)
    local container = findContainer()
    if not container then return nil, 999999 end
    
    local closest, distance = nil, 500
    local coins = container:GetChildren()
    
    excludeCoins = excludeCoins or {}
    
    for i = 1, #coins do
        local v = coins[i]
        local shouldExclude = false
        
        -- Check if this coin should be excluded
        for j = 1, #excludeCoins do
            if v == excludeCoins[j] then
                shouldExclude = true
                break
            end
        end
        
        -- Check if claimed by another bot
        if not shouldExclude and isCoinClaimed(v.Position) then
            shouldExclude = true
        end
        
        if not shouldExclude then
            local coinVisual = v:FindFirstChild("CoinVisual")
            if coinVisual then
                local mainCoin = coinVisual:FindFirstChild("MainCoin")
                if mainCoin and mainCoin.Transparency == 0 then
                    -- Check if coin position is safe from murderer
                    if isPositionSafe(v.Position) then
                        local dis = (fromPosition - v.Position).Magnitude
                        if dis < distance then
                            closest = v
                            distance = dis
                        end
                    end
                end
            end
        end
    end
    
    return closest, distance
end

-- Function to preload next 3 paths
local function preloadNextPaths()
    task.spawn(function()
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            local leftFoot = character:FindFirstChild("LeftFoot")
            
            local distanceY = -5
            if leftFoot and head and humanoid then
                distanceY = -(humanoid.HipHeight + leftFoot.Size.Y + (head.Size.Y / 4))
            elseif head and humanoid then
                distanceY = -(humanoid.HipHeight + (head.Size.Y / 4))
            end
            
            -- Clear old preloaded paths
            preloadedPaths = {}
            
            local currentPosition = hrp.Position
            local excludedCoins = {}
            
            -- Calculate 3 paths ahead
            for pathIndex = 1, 3 do
                local coin, dist = findClosestCoin(currentPosition, excludedCoins)
                
                if coin and coin:FindFirstChild("CoinVisual") then
                    -- Store this path
                    preloadedPaths[pathIndex] = {
                        coin = coin,
                        distance = dist,
                        distanceY = distanceY,
                        targetPosition = coin.Position,
                        pathNumber = pathIndex
                    }
                    
                    -- Add this coin to excluded list so next iteration finds a different one
                    table.insert(excludedCoins, coin)
                    
                    -- Update position for next calculation
                    currentPosition = coin.Position
                    
                    print("[Preload] Path", pathIndex, "preloaded - Coin at distance:", dist)
                else
                    -- No more coins available
                    break
                end
            end
            
            print("[Preload] Total paths preloaded:", #preloadedPaths)
        end)
    end)
end

-- Background thread that updates preloaded paths every second
task.spawn(function()
    while task.wait(1) do
        if not scriptEnabled.enabled then break end
        
        -- Only recalculate if we're not currently tweening
        if not currentlyTweening then
            preloadNextPaths()
        end
    end
end)

--print(findContainer())
task.wait(1)
local container = findContainer()
if container then
    print(container.Parent.Name)
end

task.spawn(function()
    if settings.noclipEnabled == true then
        local RunService = game:GetService("RunService")
        RunService.RenderStepped:Connect(function()
            if not scriptEnabled.enabled then return end
            local character = LocalPlayer.Character
            if character then
                for i,v in pairs(character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Constant rotation and velocity reset loop
task.spawn(function()
    local RunService = game:GetService("RunService")
    RunService.RenderStepped:Connect(function()
        if not scriptEnabled.enabled then return end
        
        local character = LocalPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if hrp then
                -- Always maintain 90,0,0 rotation
                local rotation = CFrame.Angles(math.rad(90), 0, 0)
                hrp.CFrame = CFrame.new(hrp.Position) * rotation
                
                -- Reset velocities when not tweening
                if not currentlyTweening then
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    hrp.Velocity = Vector3.new(0,0,0)
                    hrp.RotVelocity = Vector3.new(0,0,0)
                end
            end
            
            -- Prevent getting up animation
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end
    end)
end)

task.spawn(function()
    while task.wait(0.5) do -- Reduced frequency
        if not scriptEnabled.enabled then break end
        pcall(function()
            local playerGui = LocalPlayer.PlayerGui
            local mainGUI = playerGui:FindFirstChild("MainGUI")
            if mainGUI then
                local game = mainGUI:FindFirstChild("Game")
                if game then
                    local coinBags = game:FindFirstChild("CoinBags")
                    if coinBags and coinBags.Container.Coin.FullBagIcon.Visible and coinBags.Container.Coin.Visible then
                        -- Coin bag is full, check if we should reset
                        local shouldReset = true
                        
                        -- If murderer is a bot, wait for all other bots to die first
                        if murdererIsBot and murdererPlayer then
                            print("[Coin Bag Full] Murderer is a bot, checking if other bots are alive...")
                            
                            -- Count alive non-murderer bots
                            local aliveBotsCount = 0
                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player ~= murdererPlayer then
                                    -- Check if this player is a bot
                                    if isBot(player) then
                                        -- Check if they're alive
                                        local character = player.Character
                                        if character then
                                            local humanoid = character:FindFirstChild("Humanoid")
                                            if humanoid and humanoid.Health > 0 then
                                                aliveBotsCount = aliveBotsCount + 1
                                                print("[Bot Check] Alive bot found:", player.Name, "Health:", humanoid.Health)
                                            end
                                        end
                                    end
                                end
                            end
                            
                            if aliveBotsCount > 0 then
                                shouldReset = false
                                print("[Waiting] " .. aliveBotsCount .. " bot(s) still alive. Not resetting yet...")
                                StarterGui:SetCore("SendNotification", {
                                    Title = "Coin Bag Full";
                                    Text = "Waiting for " .. aliveBotsCount .. " bot(s) to die before resetting...";
                                    Duration = 3;
                                })
                            else
                                print("[Ready] All bots are dead! Resetting now...")
                                StarterGui:SetCore("SendNotification", {
                                    Title = "Coin Bag Full";
                                    Text = "All bots dead! Resetting to deposit coins...";
                                    Duration = 3;
                                })
                            end
                        end
                        
                        -- Reset if conditions are met
                        if shouldReset then
                            local character = LocalPlayer.Character
                            if character then
                                local head = character:FindFirstChild("Head")
                                if head then
                                    head:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    local V3 = Vector3.new(0,0,0)
    local loopCounter = 0
    
    while true do
        -- Add slight random variance to loop timing (prevents exact pattern detection)
        local loopDelay = math.random(1, 50) / 10000 -- 0.1ms to 5ms variance
        task.wait(loopDelay)
        
        loopCounter = loopCounter + 1
        
        -- Every 100 loops, add a slightly longer delay to break patterns
        if loopCounter % 100 == 0 then
            randomWait(math.random(10, 50) / 1000)
        end
        
        if not scriptEnabled.enabled then break end
        
        pcall(function()
            workspace.Gravity = 0 -- Always 0
        end)
        
        local success, err = pcall(function()
            local character = LocalPlayer.Character
            
            if not currentlyTweening and character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                -- Check if character is alive
                local humanoid = character:FindFirstChild("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    return -- Don't start new tweens if dead
                end
                
                -- Check if we're too close to murderer (only if murderer is NOT a bot)
                local murdererPos = getMurdererPosition()
                if murdererPos and not murdererIsBot then
                    local distanceToMurderer = (hrp.Position - murdererPos).Magnitude
                    if distanceToMurderer < 25 then
                        -- Too close to murderer! Escape!
                        print("[DANGER] Too close to murderer! Escaping...")
                        
                        -- Find escape direction (away from murderer)
                        local escapeDirection = (hrp.Position - murdererPos).Unit
                        local escapePosition = hrp.Position + (escapeDirection * 30) -- Move 30 studs away
                        
                        currentlyTweening = true
                        currentTween = game:GetService("TweenService"):Create(
                            hrp,
                            TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                            {CFrame = CFrame.new(escapePosition)}
                        )
                        currentTween:Play()
                        task.wait(1)
                        currentTween = nil
                        currentlyTweening = false
                        
                        return -- Skip coin collection this cycle
                    end
                end
                
                currentlyTweening = true
                local closest, distance
                local usedPreload = false
                
                -- Try to use the first preloaded path
                if #preloadedPaths > 0 and preloadedPaths[1] and preloadedPaths[1].coin then
                    local preloadedCoin = preloadedPaths[1].coin
                    
                    -- Validate the preloaded coin is still collectable and safe
                    if preloadedCoin:FindFirstChild("CoinVisual") then
                        local mainCoin = preloadedCoin.CoinVisual:FindFirstChild("MainCoin")
                        if mainCoin and mainCoin.Transparency == 0 and isPositionSafe(preloadedCoin.Position) then
                            -- Use preloaded path!
                            closest = preloadedCoin
                            distance = (hrp.Position - preloadedCoin.Position).Magnitude
                            usedPreload = true
                            print("[Optimized] Using preloaded path #1! Distance:", distance)
                            
                            -- Remove the used path and shift the array
                            table.remove(preloadedPaths, 1)
                        end
                    end
                end
                
                -- If preload failed or wasn't available, find closest coin normally
                if not usedPreload then
                    closest, distance = findClosestCoin(hrp.Position, {})
                    print("[Fallback] Calculating new path. Distance:", distance)
                    
                    -- Recalculate all paths since we're off track
                    preloadNextPaths()
                end
                
                if closest and closest:FindFirstChild("CoinVisual") and distance > 0 then
                    -- Claim this coin so other bots don't target it
                    claimCoin(closest.Position)
                    currentTargetCoin = closest
                    
                    -- Start validation loop (checks every 10ms)
                    coinValidationActive = true
                    task.spawn(function()
                        while coinValidationActive and currentTargetCoin do
                            task.wait(0.01) -- 10 milliseconds
                            
                            -- Check if coin is still valid
                            if currentTargetCoin and not currentTargetCoin.Parent then
                                print("[Validation] Target coin removed from game!")
                                coinValidationActive = false
                                break
                            end
                            
                            if currentTargetCoin then
                                local coinVisual = currentTargetCoin:FindFirstChild("CoinVisual")
                                if not coinVisual then
                                    print("[Validation] Coin visual removed!")
                                    if currentTween then
                                        currentTween:Cancel()
                                        currentTween = nil
                                    end
                                    if hrp then
                                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                        hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                                    end
                                    releaseCoin(currentTargetCoin.Position)
                                    currentTargetCoin = nil
                                    currentlyTweening = false
                                    coinValidationActive = false
                                    preloadedPaths = {}
                                    preloadNextPaths()
                                    break
                                end
                                
                                local mainCoin = coinVisual:FindFirstChild("MainCoin")
                                if not mainCoin or mainCoin.Transparency > 0 then
                                    print("[Validation] Coin collected!")
                                    if currentTween then
                                        currentTween:Cancel()
                                        currentTween = nil
                                    end
                                    if hrp then
                                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                        hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                                    end
                                    releaseCoin(currentTargetCoin.Position)
                                    currentTargetCoin = nil
                                    currentlyTweening = false
                                    coinValidationActive = false
                                    preloadedPaths = {}
                                    preloadNextPaths()
                                    break
                                end
                                
                                -- Check if still safe from murderer
                                if not isPositionSafe(currentTargetCoin.Position) then
                                    print("[Validation] Coin no longer safe from murderer!")
                                    if currentTween then
                                        currentTween:Cancel()
                                        currentTween = nil
                                    end
                                    if hrp then
                                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                        hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                                    end
                                    releaseCoin(currentTargetCoin.Position)
                                    currentTargetCoin = nil
                                    currentlyTweening = false
                                    coinValidationActive = false
                                    preloadedPaths = {}
                                    preloadNextPaths()
                                    break
                                end
                            end
                        end
                    end)
                    
                    -- If we used a preloaded path, recalculate the missing path
                    if usedPreload then
                        preloadNextPaths()
                    end
                    
                    local Highlight = nil
                    if settings.highlightEnabled then
                        Highlight = Instance.new("Highlight")
                        Highlight.Parent = closest
                        Highlight.Adornee = closest.CoinVisual.MainCoin
                        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        Highlight.Enabled = true
                        Highlight.FillColor = Color3.fromRGB(57, 138, 215)
                        Highlight.FillTransparency = 0.25
                        Highlight.OutlineColor = Color3.fromRGB(47, 102, 169)
                        Highlight.OutlineTransparency = 0.25
                    end
                    
                    -- Calculate underground position
                    local distanceY = -5 -- Default 5 studs below coin
                    local humanoid = character:FindFirstChild("Humanoid")
                    local head = character:FindFirstChild("Head")
                    local leftFoot = character:FindFirstChild("LeftFoot")
                    
                    if leftFoot and head and humanoid then
                        distanceY = -(humanoid.HipHeight + leftFoot.Size.Y + (head.Size.Y / 4))
                    elseif head and humanoid then
                        distanceY = -(humanoid.HipHeight + (head.Size.Y / 4))
                    end
                    
                    -- Create target position UNDERGROUND the coin
                    local targetCFrame = CFrame.new(closest.Position + Vector3.new(0, distanceY, 0))
                    
                    -- Teleport if distance is too far (over 150 studs), otherwise tween
                    if distance > 150 then
                        print("[Teleport] Coin too far (" .. math.floor(distance) .. " studs), teleporting")
                        hrp.CFrame = targetCFrame
                        
                        -- Fire touch signals for instant collection
                        task.wait(0.02)
                        fireCoinTouch(closest)
                        
                        currentlyTweening = false
                        coinValidationActive = true
                    else
                        print("[Tween] Moving to coin (" .. math.floor(distance) .. " studs)")
                        
                        currentTween = game:GetService("TweenService"):Create(
                            hrp,
                            TweenInfo.new(distance/settings.tweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
                            {CFrame = targetCFrame} -- Underground position, rotation handled by RenderStepped
                        )
                        currentTween:Play()
                        
                        -- Fire touch signals after a brief moment
                        task.wait(0.05)
                        fireCoinTouch(closest)
                        
                        -- Don't wait for tween to complete, let validation handle it
                    end
                    
                    -- Reset velocities after setting up movement
                    task.wait(0.01)
                    for _, v in ipairs(character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.Velocity = V3
                            v.RotVelocity = V3
                        end
                    end
                    
                    if Highlight then
                        task.spawn(function()
                            task.wait(0.5)
                            if Highlight then
                                Highlight:Destroy()
                            end
                        end)
                    end
                else
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                        local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                        -- Just reset velocities, the RenderStepped loop will handle it continuously
                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    end
                    currentlyTweening = false
                end
            end
        end)
        
        if not success then
            warn("Error in main loop:", err)
            if currentTween then
                currentTween:Cancel()
                currentTween = nil
            end
            if currentTargetCoin then
                releaseCoin(currentTargetCoin.Position)
                currentTargetCoin = nil
            end
            currentlyTweening = false
            coinValidationActive = false
            preloadedPaths = {} -- Clear preloaded data on error
        end
    end
end)
