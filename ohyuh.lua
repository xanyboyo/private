local Players = cloneref(game:GetService("Players"))
local player = Players.LocalPlayer
local tcs = cloneref(game:GetService("TextChatService"))
local RunService = cloneref(game:GetService("RunService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local vim = cloneref(game:GetService("VirtualInputManager"))

local HOST = "proton_mail"
local whitelist = {HOST}
local MAX_LENGTH = 200
local lastCommandTime = 0
local COMMAND_COOLDOWN = 0.5
local scriptRunning = true
local useWhisper = true

if _G.ChatBotRunning then
    _G.ChatBotKillFlag = true
    task.wait(0.5)
end
_G.ChatBotRunning = true
_G.ChatBotKillFlag = false

local commands = {}

-- ============================================================================
-- VIRTUAL INPUT MANAGER SETUP
-- ============================================================================

local inputs = {
    ["~"] = Enum.KeyCode.Tilde,
    ["Backspace"] = Enum.KeyCode.Backspace,
    ["Tab"] = Enum.KeyCode.Tab,
    ["Space"] = Enum.KeyCode.Space,
    ["0"] = Enum.KeyCode.Zero,
    ["/"] = Enum.KeyCode.Slash,
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,
    ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven,
    ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,
    ["A"] = Enum.KeyCode.A,
    ["B"] = Enum.KeyCode.B,
    ["C"] = Enum.KeyCode.C,
    ["D"] = Enum.KeyCode.D,
    ["E"] = Enum.KeyCode.E,
    ["F"] = Enum.KeyCode.F,
    ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H,
    ["I"] = Enum.KeyCode.I,
    ["J"] = Enum.KeyCode.J,
    ["K"] = Enum.KeyCode.K,
    ["L"] = Enum.KeyCode.L,
    ["M"] = Enum.KeyCode.M,
    ["N"] = Enum.KeyCode.N,
    ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P,
    ["Q"] = Enum.KeyCode.Q,
    ["R"] = Enum.KeyCode.R,
    ["S"] = Enum.KeyCode.S,
    ["T"] = Enum.KeyCode.T,
    ["U"] = Enum.KeyCode.U,
    ["V"] = Enum.KeyCode.V,
    ["W"] = Enum.KeyCode.W,
    ["X"] = Enum.KeyCode.X,
    ["Y"] = Enum.KeyCode.Y,
    ["Z"] = Enum.KeyCode.Z,
    ["Delete"] = Enum.KeyCode.Delete,
    ["F1"] = Enum.KeyCode.F1,
    ["F2"] = Enum.KeyCode.F2,
    ["F3"] = Enum.KeyCode.F3,
    ["F4"] = Enum.KeyCode.F4,
    ["F5"] = Enum.KeyCode.F5,
    ["F6"] = Enum.KeyCode.F6,
    ["F7"] = Enum.KeyCode.F7,
    ["F8"] = Enum.KeyCode.F8,
    ["F9"] = Enum.KeyCode.F9,
    ["F10"] = Enum.KeyCode.F10,
    ["F11"] = Enum.KeyCode.F11,
    ["F12"] = Enum.KeyCode.F12,
    ["Ctrl"] = Enum.KeyCode.LeftControl,
    ["Right Ctrl"] = Enum.KeyCode.RightControl,
    ["Shift"] = Enum.KeyCode.LeftShift,
    ["Right Shift"] = Enum.KeyCode.RightShift,
    ["Alt"] = Enum.KeyCode.LeftAlt,
    ["Right Alt"] = Enum.KeyCode.RightAlt,
    ["Caps Lock"] = Enum.KeyCode.CapsLock,
    ["Esc"] = Enum.KeyCode.Escape,
    ["Enter"] = Enum.KeyCode.Return,
    ["Insert"] = Enum.KeyCode.Insert,
    ["Home"] = Enum.KeyCode.Home,
    ["End"] = Enum.KeyCode.End,
    ["Page Up"] = Enum.KeyCode.PageUp,
    ["Page Down"] = Enum.KeyCode.PageDown,
    ["Up"] = Enum.KeyCode.Up,
    ["Down"] = Enum.KeyCode.Down,
    ["Left"] = Enum.KeyCode.Left,
    ["Right"] = Enum.KeyCode.Right,
    ["Num Lock"] = Enum.KeyCode.NumLock,
    ["Scroll Lock"] = Enum.KeyCode.ScrollLock,
    ["Print Screen"] = Enum.KeyCode.Print,
    ["Pause"] = Enum.KeyCode.Pause,
    ["-"] = Enum.KeyCode.Minus,
    ["="] = Enum.KeyCode.Equals,
    ["["] = Enum.KeyCode.LeftBracket,
    ["]"] = Enum.KeyCode.RightBracket,
    ["\\"] = Enum.KeyCode.BackSlash,
    [";"] = Enum.KeyCode.Semicolon,
    ["'"] = Enum.KeyCode.Quote,
    [","] = Enum.KeyCode.Comma,
    ["."] = Enum.KeyCode.Period,
    ["+"] = Enum.KeyCode.Plus,
    ["*"] = Enum.KeyCode.Asterisk,
    ["Num 0"] = Enum.KeyCode.KeypadZero,
    ["Num 1"] = Enum.KeyCode.KeypadOne,
    ["Num 2"] = Enum.KeyCode.KeypadTwo,
    ["Num 3"] = Enum.KeyCode.KeypadThree,
    ["Num 4"] = Enum.KeyCode.KeypadFour,
    ["Num 5"] = Enum.KeyCode.KeypadFive,
    ["Num 6"] = Enum.KeyCode.KeypadSix,
    ["Num 7"] = Enum.KeyCode.KeypadSeven,
    ["Num 8"] = Enum.KeyCode.KeypadEight,
    ["Num 9"] = Enum.KeyCode.KeypadNine,
    ["Num +"] = Enum.KeyCode.KeypadPlus,
    ["Num -"] = Enum.KeyCode.KeypadMinus,
    ["Num *"] = Enum.KeyCode.KeypadMultiply,
    ["Num /"] = Enum.KeyCode.KeypadDivide,
    ["Num Enter"] = Enum.KeyCode.KeypadEnter,
    ["Num ."] = Enum.KeyCode.KeypadPeriod,
}

local function pressKey(key, duration)
    pcall(function()
        local keyCode = inputs[key] or key
        vim:SendKeyEvent(true, keyCode, false, game)
        task.wait(duration or 0.05)
        vim:SendKeyEvent(false, keyCode, false, game)
    end)
end

-- ============================================================================
-- PLAYER FINDING SYSTEM
-- ============================================================================

local function findPlayer(input, sender)
    if not input or input == "" then return nil end
    
    local query = input:lower()
    
    if query == "me" or query == "self" then
        return sender
    end
    
    if query == "random" or query == "rand" then
        local allPlayers = Players:GetPlayers()
        local validPlayers = {}
        
        for _, p in ipairs(allPlayers) do
            if p ~= player then
                table.insert(validPlayers, p)
            end
        end
        
        if #validPlayers > 0 then
            return validPlayers[math.random(1, #validPlayers)]
        end
        return nil
    end
    
    if query == "host" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == HOST or p.DisplayName == HOST then
                return p
            end
        end
        return nil
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == query or p.DisplayName:lower() == query then
            return p
        end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #query) == query or p.DisplayName:lower():sub(1, #query) == query then
            return p
        end
    end
    
    if #query >= 3 then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():find(query, 1, true) or p.DisplayName:lower():find(query, 1, true) then
                return p
            end
        end
    end
    
    return nil
end

local function getPlayerName(p)
    if not p then return "Unknown" end
    return p.DisplayName ~= p.Name and (p.DisplayName .. " (@" .. p.Name .. ")") or p.Name
end

-- ============================================================================
-- MESSAGING FUNCTIONS
-- ============================================================================

local function sendMessage(msg, targetPlayer, channel)
    local formattedMsg = tostring(msg)
    local target
    local success = false
    
    if channel == "Team" then
        target = tcs.TextChannels:FindFirstChild("RBXTeam")
    elseif channel == "player" or channel == "whisper" then
        local targetId = typeof(targetPlayer) == "Instance" and targetPlayer.UserId
            or typeof(targetPlayer) == "number" and targetPlayer
            or Players:FindFirstChild(tostring(targetPlayer)) and Players:FindFirstChild(tostring(targetPlayer)).UserId
        
        if targetId then
            local channelName = "RBXWhisper:" .. math.min(player.UserId, targetId) .. "_" .. math.max(player.UserId, targetId)
            target = tcs.TextChannels:WaitForChild(channelName, 2)
            
            if target then
                success = pcall(function()
                    target:SendAsync(formattedMsg)
                end)
            end
            
            if not success or not target then
                local general = tcs.TextChannels:WaitForChild("RBXGeneral", 5)
                if general then 
                    pcall(function()
                        general:SendAsync(formattedMsg)
                    end)
                end
            end
            return
        end
    else
        target = tcs.TextChannels:WaitForChild("RBXGeneral", 5)
    end
    
    if target then 
        pcall(function()
            target:SendAsync(formattedMsg)
        end)
    end
end

local function sendLongMessage(msg, targetPlayer, channel)
    while #msg > 0 do
        if #msg <= MAX_LENGTH then
            sendMessage(msg, targetPlayer, channel)
            break
        end
        
        local cutPos = MAX_LENGTH
        local spacePos = msg:sub(1, MAX_LENGTH):reverse():find(" ")
        
        if spacePos then
            cutPos = MAX_LENGTH - spacePos + 1
        end
        
        local chunk = msg:sub(1, cutPos)
        sendMessage(chunk, targetPlayer, channel)
        
        msg = msg:sub(cutPos + 1)
        task.wait(0.5)
    end
end

local function notifyHost(msg)
    local hostPlayer = Players:FindFirstChild(HOST)
    if not hostPlayer then
        for _, p in Players:GetPlayers() do
            if p.DisplayName == HOST then
                hostPlayer = p
                break
            end
        end
    end
    
    if hostPlayer then
        if useWhisper then
            sendLongMessage(msg, hostPlayer, "whisper")
        --else
            --sendLongMessage(msg, nil, "general")
        end
    end
end

local function registerCommand(name, func)
    commands[name:lower()] = func
end

local function isWhitelisted(p)
    for _, name in ipairs(whitelist) do
        if p.Name == name or p.DisplayName == name then
            return true
        end
    end
    return false
end

local function isHost(p)
    return p.Name == HOST or p.DisplayName == HOST
end

local function parseCommand(message)
    local prefix = message:sub(1, 1)
    if prefix ~= "!" and prefix ~= "." and prefix ~= "/" then return end
    
    local args = message:sub(2):split(" ")
    local cmd = args[1]:lower()
    table.remove(args, 1)
    
    return cmd, args
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function getCharacter(p)
    return p and p.Character
end

local function getHumanoid(char)
    return char and char:FindFirstChild("Humanoid")
end

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ============================================================================
-- CHAT COMMANDS
-- ============================================================================

registerCommand("say", function(args)
    local message = table.concat(args, " ")
    sendMessage(message, nil, "general")
    notifyHost("✓ Message sent to general chat")
end)

registerCommand("whisper", function(args, sender)
    local targetPlayer = findPlayer(args[1], sender)
    if not targetPlayer then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    table.remove(args, 1)
    local message = table.concat(args, " ")
    sendMessage(message, targetPlayer, "whisper")
    notifyHost("✓ Whisper sent to " .. getPlayerName(targetPlayer))
end)

registerCommand("team", function(args)
    local message = table.concat(args, " ")
    sendMessage(message, nil, "Team")
    notifyHost("✓ Message sent to team chat")
end)

-- ============================================================================
-- CHARACTER COMMANDS
-- ============================================================================

registerCommand("reset", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.Health = 0
        notifyHost("✓ Character reset")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("jump", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.Jump = true
        notifyHost("✓ Jumped")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("sit", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.Sit = true
        notifyHost("✓ Sitting")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("unsit", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.Sit = false
        humanoid.Jump = true
        notifyHost("✓ Standing up")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("speed", function(args, sender)
    local speed = tonumber(args[1])
    
    if not speed then
        notifyHost("✗ Usage: !speed <number>")
        return
    end
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.WalkSpeed = speed
        notifyHost("✓ Speed set to " .. speed)
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("jumppower", function(args, sender)
    local power = tonumber(args[1])
    
    if not power then
        notifyHost("✗ Usage: !jumppower <number>")
        return
    end
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        if humanoid.UseJumpPower then
            humanoid.JumpPower = power
        else
            humanoid.JumpHeight = power
        end
        notifyHost("✓ Jump power set to " .. power)
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

-- ============================================================================
-- EMOTE COMMANDS
-- ============================================================================

registerCommand("dance1", function(args, sender)
    sendMessage("/e dance", nil, "general")
    notifyHost("✓ Dancing (dance1)")
end)

registerCommand("dance2", function(args, sender)
    sendMessage("/e dance2", nil, "general")
    notifyHost("✓ Dancing (dance2)")
end)

registerCommand("dance3", function(args, sender)
    sendMessage("/e dance3", nil, "general")
    notifyHost("✓ Dancing (dance3)")
end)

registerCommand("cheer", function(args, sender)
    sendMessage("/e cheer", nil, "general")
    notifyHost("✓ Cheering")
end)

registerCommand("laugh", function(args, sender)
    sendMessage("/e laugh", nil, "general")
    notifyHost("✓ Laughing")
end)

registerCommand("point", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if humanoid then
        local rigType = humanoid.RigType
        if rigType == Enum.HumanoidRigType.R15 then
            sendMessage("/e point2", nil, "general")
        else
            sendMessage("/e point", nil, "general")
        end
        notifyHost("✓ Pointing")
    else
        sendMessage("/e point", nil, "general")
        notifyHost("✓ Pointing")
    end
end)

registerCommand("wave", function(args, sender)
    sendMessage("/e wave", nil, "general")
    notifyHost("✓ Waving")
end)

registerCommand("shrug", function(args, sender)
    sendMessage("/e shrug", nil, "general")
    notifyHost("✓ Shrugging")
end)

registerCommand("stadium", function(args, sender)
    sendMessage("/e stadium", nil, "general")
    notifyHost("✓ Stadium emote")
end)

-- ============================================================================
-- MOVEMENT COMMANDS
-- ============================================================================

registerCommand("goto", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    local targetChar = getCharacter(target)
    if not targetChar then
        notifyHost("✗ Failed: " .. getPlayerName(target) .. " has no character")
        return
    end
    
    local offsetX = tonumber(args[2]) or 3
    local offsetY = tonumber(args[3]) or 0
    local offsetZ = tonumber(args[4]) or 0
    
    local targetRoot = getRoot(targetChar)
    local playerRoot = getRoot(getCharacter(player))
    
    if targetRoot and playerRoot then
        playerRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, offsetY, offsetZ)
        notifyHost("✓ Teleported to " .. getPlayerName(target) .. " (offset: " .. offsetX .. ", " .. offsetY .. ", " .. offsetZ .. ")")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("bring", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can use bring")
        return 
    end
    
    local offsetX = tonumber(args[1]) or 0
    local offsetY = tonumber(args[2]) or 0
    local offsetZ = tonumber(args[3]) or 0
    
    local senderChar = getCharacter(sender)
    local playerChar = getCharacter(player)
    if senderChar and playerChar then
        local senderRoot = getRoot(senderChar)
        local playerRoot = getRoot(playerChar)
        if senderRoot and playerRoot then
            playerRoot.CFrame = senderRoot.CFrame * CFrame.new(offsetX, offsetY, offsetZ)
            if offsetX ~= 0 or offsetY ~= 0 or offsetZ ~= 0 then
                notifyHost("✓ Brought to " .. sender.Name .. " (offset: " .. offsetX .. ", " .. offsetY .. ", " .. offsetZ .. ")")
            else
                notifyHost("✓ Brought to " .. sender.Name)
            end
        else
            notifyHost("✗ Failed: Character not found")
        end
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("freeze", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    if root then
        root.Anchored = true
        notifyHost("✓ Frozen")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("unfreeze", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    if root then
        root.Anchored = false
        notifyHost("✓ Unfrozen")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("thaw", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    if root then
        root.Anchored = false
        notifyHost("✓ Unfrozen")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("follow", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    local targetChar = getCharacter(target)
    if not targetChar then
        notifyHost("✗ Failed: " .. getPlayerName(target) .. " has no character")
        return
    end
    
    local offsetX = tonumber(args[2]) or 0
    local offsetY = tonumber(args[3]) or 0
    local offsetZ = tonumber(args[4]) or 0
    
    if _G.FollowConnection then
        _G.FollowConnection:Disconnect()
    end
    
    _G.FollowConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            local currentTargetChar = getCharacter(target)
            if not currentTargetChar then return end
            
            local targetRoot = getRoot(currentTargetChar)
            local playerRoot = getRoot(getCharacter(player))
            
            if targetRoot and playerRoot then
                local offset = Vector3.new(offsetX, offsetY, offsetZ)
                playerRoot.CFrame = CFrame.new(targetRoot.Position + offset)
            end
        end)
    end)
    
    notifyHost("✓ Following " .. getPlayerName(target) .. " (offset: " .. offsetX .. ", " .. offsetY .. ", " .. offsetZ .. ")")
end)

registerCommand("unfollow", function(args, sender)
    if _G.FollowConnection then
        _G.FollowConnection:Disconnect()
        _G.FollowConnection = nil
        notifyHost("✓ Stopped following")
    else
        notifyHost("✗ Not following anyone")
    end
end)

registerCommand("orbit", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    local targetChar = getCharacter(target)
    if not targetChar then
        notifyHost("✗ Failed: " .. getPlayerName(target) .. " has no character")
        return
    end
    
    local speed = tonumber(args[2]) or 0.2
    local distance = tonumber(args[3]) or 6
    
    if _G.OrbitConnection then
        _G.OrbitConnection:Disconnect()
    end
    if _G.OrbitConnection2 then
        _G.OrbitConnection2:Disconnect()
    end
    
    local rotation = 0
    local playerRoot = getRoot(getCharacter(player))
    local targetRoot = getRoot(targetChar)
    
    if not playerRoot or not targetRoot then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    _G.OrbitConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local currentTargetChar = getCharacter(target)
            if not currentTargetChar then return end
            local newTargetRoot = getRoot(currentTargetChar)
            if not newTargetRoot then return end
            
            rotation = rotation + speed
            playerRoot.CFrame = CFrame.new(newTargetRoot.Position) * CFrame.Angles(0, math.rad(rotation), 0) * CFrame.new(distance, 0, 0)
        end)
    end)
    
    _G.OrbitConnection2 = RunService.RenderStepped:Connect(function()
        pcall(function()
            local currentTargetChar = getCharacter(target)
            if not currentTargetChar then return end
            local newTargetRoot = getRoot(currentTargetChar)
            if not newTargetRoot or not playerRoot then return end
            
            playerRoot.CFrame = CFrame.new(playerRoot.Position, newTargetRoot.Position)
        end)
    end)
    
    notifyHost("✓ Orbiting " .. getPlayerName(target))
end)

registerCommand("unorbit", function(args, sender)
    if _G.OrbitConnection then
        _G.OrbitConnection:Disconnect()
        _G.OrbitConnection = nil
    end
    if _G.OrbitConnection2 then
        _G.OrbitConnection2:Disconnect()
        _G.OrbitConnection2 = nil
    end
    notifyHost("✓ Stopped orbiting")
end)

-- ============================================================================
-- VIRTUAL INPUT COMMAND
-- ============================================================================

registerCommand("input", function(args, sender)
    local key = args[1]
    local duration = tonumber(args[2]) or 0.05
    
    if not key then
        notifyHost("✗ Usage: !input <key> [duration]")
        return
    end
    
    if not inputs[key] then
        notifyHost("✗ Invalid key: " .. key)
        return
    end
    
    pressKey(key, duration)
    notifyHost("✓ Pressed key: " .. key)
end)

-- ============================================================================
-- RAINPARTS COMMAND
-- ============================================================================

registerCommand("rainparts", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    if _G.RainPartsConnection then
        _G.RainPartsConnection:Disconnect()
        _G.RainPartsConnection = nil
    end
    
    local targetChar = getCharacter(target)
    if not targetChar then
        notifyHost("✗ Failed: " .. getPlayerName(target) .. " has no character")
        return
    end
    
    local targetRoot = getRoot(targetChar)
    if not targetRoot then
        notifyHost("✗ Failed: Character root not found")
        return
    end
    
    local playerChar = getCharacter(player)
    if not playerChar then
        notifyHost("✗ Failed: Bot character not found")
        return
    end
    
    local bodyParts = {}
    for _, part in ipairs(playerChar:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            table.insert(bodyParts, part)
        end
    end
    
    if #bodyParts == 0 then
        notifyHost("✗ Failed: No body parts found")
        return
    end
    
    local rainHeight = tonumber(args[2]) or 50
    local rainRadius = tonumber(args[3]) or 10
    local rainSpeed = tonumber(args[4]) or -50
    local partIndex = 1
    
    _G.RainPartsConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local currentTargetChar = getCharacter(target)
            if not currentTargetChar then return end
            local currentTargetRoot = getRoot(currentTargetChar)
            if not currentTargetRoot then return end
            
            local part = bodyParts[partIndex]
            if part and part.Parent then
                local randomOffset = Vector3.new(
                    math.random(-rainRadius, rainRadius),
                    rainHeight,
                    math.random(-rainRadius, rainRadius)
                )
                part.CFrame = CFrame.new(currentTargetRoot.Position + randomOffset)
                part.Velocity = Vector3.new(0, rainSpeed, 0)
            end
            
            partIndex = partIndex + 1
            if partIndex > #bodyParts then
                partIndex = 1
            end
        end)
    end)
    
    notifyHost("✓ Raining body parts above " .. getPlayerName(target) .. " (height: " .. rainHeight .. ", radius: " .. rainRadius .. ", speed: " .. rainSpeed .. ")")
end)

registerCommand("stoprain", function(args, sender)
    if _G.RainPartsConnection then
        _G.RainPartsConnection:Disconnect()
        _G.RainPartsConnection = nil
        notifyHost("✓ Stopped raining body parts")
    else
        notifyHost("✗ Not raining body parts")
    end
end)

-- ============================================================================
-- ADDITIONAL UTILITY COMMANDS
-- ============================================================================

registerCommand("spin", function(args, sender)
    local speed = tonumber(args[1]) or 20
    
    local char = getCharacter(player)
    local root = getRoot(char)
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.SpinConnection then
        _G.SpinConnection:Disconnect()
    end
    
    local spin = Instance.new("BodyAngularVelocity")
    spin.Name = "BotSpin"
    spin.MaxTorque = Vector3.new(0, math.huge, 0)
    spin.AngularVelocity = Vector3.new(0, speed, 0)
    spin.Parent = root
    
    _G.SpinConnection = char.Humanoid.Died:Connect(function()
        if spin then spin:Destroy() end
    end)
    
    notifyHost("✓ Spinning at speed " .. speed)
end)

registerCommand("unspin", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        local spin = root:FindFirstChild("BotSpin")
        if spin then
            spin:Destroy()
            notifyHost("✓ Stopped spinning")
        else
            notifyHost("✗ Not spinning")
        end
    end
    
    if _G.SpinConnection then
        _G.SpinConnection:Disconnect()
        _G.SpinConnection = nil
    end
end)

registerCommand("float", function(args, sender)
    local height = tonumber(args[1]) or 10
    
    local char = getCharacter(player)
    local root = getRoot(char)
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.FloatConnection then
        _G.FloatConnection:Disconnect()
    end
    
    local bodyPos = Instance.new("BodyPosition")
    bodyPos.Name = "BotFloat"
    bodyPos.MaxForce = Vector3.new(0, math.huge, 0)
    bodyPos.D = 1000
    bodyPos.P = 10000
    bodyPos.Parent = root
    
    _G.FloatConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if root and bodyPos then
                bodyPos.Position = root.Position + Vector3.new(0, height, 0)
            end
        end)
    end)
    
    notifyHost("✓ Floating at height " .. height)
end)

registerCommand("unfloat", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        local bodyPos = root:FindFirstChild("BotFloat")
        if bodyPos then
            bodyPos:Destroy()
            notifyHost("✓ Stopped floating")
        else
            notifyHost("✗ Not floating")
        end
    end
    
    if _G.FloatConnection then
        _G.FloatConnection:Disconnect()
        _G.FloatConnection = nil
    end
end)

registerCommand("invisible", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
            end
        end
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 1
        end
    end
    
    notifyHost("✓ Character is now invisible")
end)

registerCommand("visible", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0
        elseif part:IsA("Decal") then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 0
            end
        end
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 0
        end
    end
    
    notifyHost("✓ Character is now visible")
end)

registerCommand("noclip", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.NoclipConnection then
        _G.NoclipConnection:Disconnect()
    end
    
    _G.NoclipConnection = RunService.Stepped:Connect(function()
        pcall(function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end)
    
    notifyHost("✓ Noclip enabled")
end)

registerCommand("clip", function(args, sender)
    if _G.NoclipConnection then
        _G.NoclipConnection:Disconnect()
        _G.NoclipConnection = nil
    end
    
    local char = getCharacter(player)
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    notifyHost("✓ Noclip disabled")
end)

registerCommand("god", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if not humanoid then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    notifyHost("✓ God mode enabled")
end)

registerCommand("ungod", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    if not humanoid then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    
    notifyHost("✓ God mode disabled")
end)

registerCommand("respawn", function(args, sender)
    local char = getCharacter(player)
    if char then
        local humanoid = getHumanoid(char)
        if humanoid then
            humanoid.Health = 0
        end
    end
    
    player.CharacterAdded:Wait()
    task.wait(0.5)
    
    notifyHost("✓ Character respawned")
end)

registerCommand("loopkill", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    local velocity = tonumber(args[2]) or 9999
    
    if _G.LoopKillConnection then
        _G.LoopKillConnection:Disconnect()
    end
    
    _G.LoopKillConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame
                    playerRoot.Velocity = Vector3.new(0, velocity, 0)
                end
            end
        end)
    end)
    
    notifyHost("✓ Loop killing " .. getPlayerName(target) .. " (velocity: " .. velocity .. ")")
end)

registerCommand("unloopkill", function(args, sender)
    if _G.LoopKillConnection then
        _G.LoopKillConnection:Disconnect()
        _G.LoopKillConnection = nil
        notifyHost("✓ Stopped loop killing")
    else
        notifyHost("✗ Not loop killing anyone")
    end
end)

registerCommand("attach", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if not targetChar or not playerChar then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local offsetX = tonumber(args[2]) or 0
    local offsetY = tonumber(args[3]) or 0
    local offsetZ = tonumber(args[4]) or 0
    
    local targetRoot = getRoot(targetChar)
    local playerRoot = getRoot(playerChar)
    
    if not targetRoot or not playerRoot then
        notifyHost("✗ Failed: Character root not found")
        return
    end
    
    if _G.AttachConnection then
        _G.AttachConnection:Disconnect()
    end
    
    _G.AttachConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local currentTargetChar = getCharacter(target)
            if not currentTargetChar then return end
            local currentTargetRoot = getRoot(currentTargetChar)
            if not currentTargetRoot or not playerRoot then return end
            
            playerRoot.CFrame = currentTargetRoot.CFrame * CFrame.new(offsetX, offsetY, offsetZ)
        end)
    end)
    
    if offsetX ~= 0 or offsetY ~= 0 or offsetZ ~= 0 then
        notifyHost("✓ Attached to " .. getPlayerName(target) .. " (offset: " .. offsetX .. ", " .. offsetY .. ", " .. offsetZ .. ")")
    else
        notifyHost("✓ Attached to " .. getPlayerName(target))
    end
end)

registerCommand("unattach", function(args, sender)
    if _G.AttachConnection then
        _G.AttachConnection:Disconnect()
        _G.AttachConnection = nil
        notifyHost("✓ Detached")
    else
        notifyHost("✗ Not attached to anyone")
    end
end)

registerCommand("spam", function(args, sender)
    local message = table.concat(args, " ")
    
    if message == "" then
        notifyHost("✗ Usage: !spam <message>")
        return
    end
    
    if _G.SpamConnection then
        _G.SpamConnection:Disconnect()
    end
    
    _G.SpamConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            sendMessage(message, nil, "general")
        end)
        task.wait(0.5)
    end)
    
    notifyHost("✓ Spamming message")
end)

registerCommand("unspam", function(args, sender)
    if _G.SpamConnection then
        _G.SpamConnection:Disconnect()
        _G.SpamConnection = nil
        notifyHost("✓ Stopped spamming")
    else
        notifyHost("✗ Not spamming")
    end
end)

registerCommand("walkto", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player '" .. (args[1] or "") .. "' not found")
        return
    end
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if not targetChar or not playerChar then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local targetRoot = getRoot(targetChar)
    local humanoid = getHumanoid(playerChar)
    
    if targetRoot and humanoid then
        humanoid:MoveTo(targetRoot.Position)
        notifyHost("✓ Walking to " .. getPlayerName(target))
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("stopwalk", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid:MoveTo(humanoid.Parent.HumanoidRootPart.Position)
        notifyHost("✓ Stopped walking")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("size", function(args, sender)
    local scale = tonumber(args[1])
    
    if not scale then
        notifyHost("✗ Usage: !size <number>")
        return
    end
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        for _, obj in ipairs(humanoid:GetChildren()) do
            if obj:IsA("NumberValue") then
                obj.Value = scale
            end
        end
        notifyHost("✓ Size set to " .. scale)
    else
        notifyHost("✗ Failed: Humanoid not found")
    end
end)

registerCommand("health", function(args, sender)
    local health = tonumber(args[1])
    
    if not health then
        notifyHost("✗ Usage: !health <number>")
        return
    end
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid.Health = health
        notifyHost("✓ Health set to " .. health)
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("maxhealth", function(args, sender)
    local maxHealth = tonumber(args[1])
    
    if not maxHealth then
        notifyHost("✗ Usage: !maxhealth <number>")
        return
    end
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid.MaxHealth = maxHealth
        humanoid.Health = maxHealth
        notifyHost("✓ Max health set to " .. maxHealth)
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

-- ============================================================================
-- ADDITIONAL MOVEMENT COMMANDS
-- ============================================================================

registerCommand("tpto", function(args, sender)
    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    if not x or not y or not z then
        notifyHost("✗ Usage: !tpto <x> <y> <z>")
        return
    end
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        root.CFrame = CFrame.new(x, y, z)
        notifyHost("✓ Teleported to coordinates (" .. x .. ", " .. y .. ", " .. z .. ")")
    else
        notifyHost("✗ Failed: Character not found")
    end
end)

registerCommand("tphere", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can use tphere")
        return 
    end
    
    local target = findPlayer(args[1], sender)
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local senderChar = getCharacter(sender)
    local targetChar = getCharacter(target)
    
    if senderChar and targetChar then
        local senderRoot = getRoot(senderChar)
        local targetRoot = getRoot(targetChar)
        if senderRoot and targetRoot then
            targetRoot.CFrame = senderRoot.CFrame * CFrame.new(3, 0, 0)
            notifyHost("✓ Teleported " .. getPlayerName(target) .. " to you")
        end
    end
end)

registerCommand("tpall", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can use tpall")
        return 
    end
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local pChar = getCharacter(p)
            local pRoot = getRoot(pChar)
            if pRoot then
                pRoot.CFrame = root.CFrame * CFrame.new(math.random(-10, 10), 0, math.random(-10, 10))
                count = count + 1
            end
        end
    end
    
    notifyHost("✓ Teleported " .. count .. " players to bot")
end)

registerCommand("fling", function(args, sender)
    local target = findPlayer(args[1], sender)
    local power = tonumber(args[2]) or 500
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if targetChar and playerChar then
        local targetRoot = getRoot(targetChar)
        local playerRoot = getRoot(playerChar)
        
        if targetRoot and playerRoot then
            playerRoot.CFrame = targetRoot.CFrame
            playerRoot.Velocity = Vector3.new(power, power, power)
            notifyHost("✓ Flinging " .. getPlayerName(target))
        end
    end
end)

registerCommand("rocket", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if targetChar and playerChar then
        local targetRoot = getRoot(targetChar)
        local playerRoot = getRoot(playerChar)
        
        if targetRoot and playerRoot then
            playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -5, 0)
            playerRoot.Velocity = Vector3.new(0, 1000, 0)
            notifyHost("✓ Rocketing " .. getPlayerName(target))
        end
    end
end)

registerCommand("benx", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if targetChar and playerChar then
        local targetRoot = getRoot(targetChar)
        local playerRoot = getRoot(playerChar)
        
        if targetRoot and playerRoot then
            for i = 1, 10 do
                task.spawn(function()
                    playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, i * 5, 0)
                    playerRoot.Velocity = Vector3.new(0, -500, 0)
                    task.wait(0.1)
                end)
            end
            notifyHost("✓ Ben X attacking " .. getPlayerName(target))
        end
    end
end)

-- ============================================================================
-- CHARACTER APPEARANCE COMMANDS
-- ============================================================================

registerCommand("headless", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end
        notifyHost("✓ Headless enabled")
    end
end)

registerCommand("unheadless", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        notifyHost("✓ Headless disabled")
    end
end)

registerCommand("bighead", function(args, sender)
    local scale = tonumber(args[1]) or 3
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(scale, scale, scale)
        notifyHost("✓ Big head enabled (scale: " .. scale .. ")")
    end
end)

registerCommand("normalhead", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(2, 1, 1)
        notifyHost("✓ Head size reset")
    end
end)

registerCommand("blockhead", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local head = char:FindFirstChild("Head")
    if head and head:IsA("Part") then
        head.Shape = Enum.PartType.Block
        notifyHost("✓ Block head enabled")
    end
end)

registerCommand("creeper", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Bright green")
        end
    end
    
    local head = char:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(2, 2, 2)
    end
    
    notifyHost("✓ Creeper mode enabled")
end)

registerCommand("gold", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Bright yellow")
            part.Material = Enum.Material.SmoothPlastic
        end
    end
    
    notifyHost("✓ Gold skin enabled")
end)

registerCommand("diamond", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Cyan")
            part.Material = Enum.Material.DiamondPlate
            part.Reflectance = 0.5
        end
    end
    
    notifyHost("✓ Diamond skin enabled")
end)

registerCommand("naked", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
            obj:Destroy()
        end
    end
    
    notifyHost("✓ Clothing removed")
end)

registerCommand("removeaccessories", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Accessory") then
            obj:Destroy()
        end
    end
    
    notifyHost("✓ Accessories removed")
end)

-- ============================================================================
-- VISUAL EFFECTS COMMANDS
-- ============================================================================

registerCommand("fire", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        local fire = Instance.new("Fire")
        fire.Parent = root
        notifyHost("✓ Fire effect enabled")
    end
end)

registerCommand("unfire", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("Fire") then
                obj:Destroy()
            end
        end
        notifyHost("✓ Fire effect removed")
    end
end)

registerCommand("smoke", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        local smoke = Instance.new("Smoke")
        smoke.Parent = root
        notifyHost("✓ Smoke effect enabled")
    end
end)

registerCommand("unsmoke", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("Smoke") then
                obj:Destroy()
            end
        end
        notifyHost("✓ Smoke effect removed")
    end
end)

registerCommand("sparkles", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        local sparkles = Instance.new("Sparkles")
        sparkles.Parent = root
        notifyHost("✓ Sparkles effect enabled")
    end
end)

registerCommand("unsparkles", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("Sparkles") then
                obj:Destroy()
            end
        end
        notifyHost("✓ Sparkles effect removed")
    end
end)

registerCommand("pointlight", function(args, sender)
    local brightness = tonumber(args[1]) or 5
    local range = tonumber(args[2]) or 20
    
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        local light = Instance.new("PointLight")
        light.Brightness = brightness
        light.Range = range
        light.Parent = root
        notifyHost("✓ Point light enabled (brightness: " .. brightness .. ", range: " .. range .. ")")
    end
end)

registerCommand("unpointlight", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("PointLight") then
                obj:Destroy()
            end
        end
        notifyHost("✓ Point light removed")
    end
end)

registerCommand("trail", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        local attachment0 = Instance.new("Attachment")
        local attachment1 = Instance.new("Attachment")
        attachment0.Parent = root
        attachment1.Parent = root
        attachment1.Position = Vector3.new(0, -2, 0)
        
        local trail = Instance.new("Trail")
        trail.Attachment0 = attachment0
        trail.Attachment1 = attachment1
        trail.Lifetime = 2
        trail.Parent = root
        notifyHost("✓ Trail effect enabled")
    end
end)

registerCommand("untrail", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(char)
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("Trail") or obj:IsA("Attachment") then
                obj:Destroy()
            end
        end
        notifyHost("✓ Trail effect removed")
    end
end)

registerCommand("explode", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local targetChar = getCharacter(target)
    if not targetChar then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local root = getRoot(targetChar)
    if root then
        local explosion = Instance.new("Explosion")
        explosion.Position = root.Position
        explosion.Parent = workspace
        notifyHost("✓ Exploded " .. getPlayerName(target))
    end
end)

-- ============================================================================
-- UTILITY COMMANDS
-- ============================================================================

registerCommand("time", function(args, sender)
    local timeOfDay = args[1]
    
    if not timeOfDay then
        notifyHost("✗ Usage: !time <hour> or !time <dawn/noon/dusk/midnight>")
        return
    end
    
    local Lighting = game:GetService("Lighting")
    
    if timeOfDay == "dawn" then
        Lighting.ClockTime = 6
    elseif timeOfDay == "noon" then
        Lighting.ClockTime = 12
    elseif timeOfDay == "dusk" then
        Lighting.ClockTime = 18
    elseif timeOfDay == "midnight" then
        Lighting.ClockTime = 0
    else
        local hour = tonumber(timeOfDay)
        if hour then
            Lighting.ClockTime = hour
        else
            notifyHost("✗ Invalid time")
            return
        end
    end
    
    notifyHost("✓ Time set to " .. timeOfDay)
end)

registerCommand("fogend", function(args, sender)
    local distance = tonumber(args[1]) or 100000
    
    local Lighting = game:GetService("Lighting")
    Lighting.FogEnd = distance
    
    notifyHost("✓ Fog end set to " .. distance)
end)

registerCommand("brightness", function(args, sender)
    local brightness = tonumber(args[1]) or 2
    
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = brightness
    
    notifyHost("✓ Brightness set to " .. brightness)
end)

registerCommand("ambient", function(args, sender)
    local r = tonumber(args[1]) or 255
    local g = tonumber(args[2]) or 255
    local b = tonumber(args[3]) or 255
    
    local Lighting = game:GetService("Lighting")
    Lighting.Ambient = Color3.fromRGB(r, g, b)
    
    notifyHost("✓ Ambient color set to RGB(" .. r .. ", " .. g .. ", " .. b .. ")")
end)

registerCommand("gravity", function(args, sender)
    local gravity = tonumber(args[1]) or 196.2
    
    workspace.Gravity = gravity
    
    notifyHost("✓ Gravity set to " .. gravity)
end)

registerCommand("day", function(args, sender)
    local Lighting = game:GetService("Lighting")
    Lighting.ClockTime = 12
    Lighting.Brightness = 2
    notifyHost("✓ Set to day")
end)

registerCommand("night", function(args, sender)
    local Lighting = game:GetService("Lighting")
    Lighting.ClockTime = 0
    Lighting.Brightness = 0
    notifyHost("✓ Set to night")
end)

registerCommand("fly", function(args, sender)
    local speed = tonumber(args[1]) or 50
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    local root = getRoot(char)
    
    if not char or not humanoid or not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.FlyConnection then
        _G.FlyConnection:Disconnect()
    end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = root
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e9
    bodyGyro.Parent = root
    
    _G.FlyConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local moveDirection = humanoid.MoveDirection
            bodyVelocity.Velocity = moveDirection * speed
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end)
    end)
    
    notifyHost("✓ Fly enabled (speed: " .. speed .. ")")
end)

registerCommand("unfly", function(args, sender)
    if _G.FlyConnection then
        _G.FlyConnection:Disconnect()
        _G.FlyConnection = nil
    end
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                obj:Destroy()
            end
        end
    end
    
    notifyHost("✓ Fly disabled")
end)

registerCommand("platform", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.Platform then
        _G.Platform:Destroy()
    end
    
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(10, 1, 10)
    platform.Anchored = true
    platform.Position = root.Position - Vector3.new(0, 3, 0)
    platform.Parent = workspace
    _G.Platform = platform
    
    if _G.PlatformConnection then
        _G.PlatformConnection:Disconnect()
    end
    
    _G.PlatformConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if root and platform then
                platform.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3, root.Position.Z)
            end
        end)
    end)
    
    notifyHost("✓ Platform enabled")
end)

registerCommand("unplatform", function(args, sender)
    if _G.PlatformConnection then
        _G.PlatformConnection:Disconnect()
        _G.PlatformConnection = nil
    end
    
    if _G.Platform then
        _G.Platform:Destroy()
        _G.Platform = nil
    end
    
    notifyHost("✓ Platform disabled")
end)

-- ============================================================================
-- FUN/TROLL COMMANDS
-- ============================================================================

registerCommand("seizure", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    if _G.SeizureConnection then
        _G.SeizureConnection:Disconnect()
    end
    
    _G.SeizureConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame * CFrame.Angles(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
                end
            end
        end)
    end)
    
    notifyHost("✓ Seizure mode on " .. getPlayerName(target))
end)

registerCommand("unseizure", function(args, sender)
    if _G.SeizureConnection then
        _G.SeizureConnection:Disconnect()
        _G.SeizureConnection = nil
        notifyHost("✓ Seizure mode disabled")
    else
        notifyHost("✗ Seizure mode not active")
    end
end)

registerCommand("annoy", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    if _G.AnnoyConnection then
        _G.AnnoyConnection:Disconnect()
    end
    
    _G.AnnoyConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
                end
            end
        end)
    end)
    
    notifyHost("✓ Annoying " .. getPlayerName(target))
end)

registerCommand("unannoy", function(args, sender)
    if _G.AnnoyConnection then
        _G.AnnoyConnection:Disconnect()
        _G.AnnoyConnection = nil
        notifyHost("✓ Annoy mode disabled")
    else
        notifyHost("✗ Annoy mode not active")
    end
end)

registerCommand("mimic", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    if _G.MimicConnection then
        _G.MimicConnection:Disconnect()
    end
    
    _G.MimicConnection = target.Chatted:Connect(function(message)
        pcall(function()
            sendMessage(message, nil, "general")
        end)
    end)
    
    notifyHost("✓ Mimicking " .. getPlayerName(target))
end)

registerCommand("unmimic", function(args, sender)
    if _G.MimicConnection then
        _G.MimicConnection:Disconnect()
        _G.MimicConnection = nil
        notifyHost("✓ Mimic mode disabled")
    else
        notifyHost("✗ Mimic mode not active")
    end
end)

registerCommand("crash", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can use crash")
        return 
    end
    
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    for i = 1, 1000 do
        task.spawn(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame
                    playerRoot.Velocity = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
                end
            end
        end)
    end
    
    notifyHost("✓ Attempting to crash " .. getPlayerName(target))
end)

registerCommand("flip", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        root.CFrame = root.CFrame * CFrame.Angles(math.pi, 0, 0)
        notifyHost("✓ Character flipped")
    end
end)

registerCommand("spinchar", function(args, sender)
    local speed = tonumber(args[1]) or 20
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.SpinCharConnection then
        _G.SpinCharConnection:Disconnect()
    end
    
    _G.SpinCharConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(speed), 0)
        end)
    end)
    
    notifyHost("✓ Character spinning (speed: " .. speed .. ")")
end)

registerCommand("unspinchar", function(args, sender)
    if _G.SpinCharConnection then
        _G.SpinCharConnection:Disconnect()
        _G.SpinCharConnection = nil
        notifyHost("✓ Character spin disabled")
    else
        notifyHost("✗ Character not spinning")
    end
end)

registerCommand("lay", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        root.CFrame = root.CFrame * CFrame.Angles(math.pi/2, 0, 0)
        notifyHost("✓ Character laying down")
    end
end)

registerCommand("standup", function(args, sender)
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if root then
        root.CFrame = CFrame.new(root.Position)
        notifyHost("✓ Character standing up")
    end
end)

registerCommand("nolimbs", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local limbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    for _, limbName in ipairs(limbs) do
        local limb = char:FindFirstChild(limbName)
        if limb then
            limb:Destroy()
        end
    end
    
    notifyHost("✓ Limbs removed")
end)

registerCommand("nolegs", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local legs = {"Left Leg", "Right Leg"}
    for _, legName in ipairs(legs) do
        local leg = char:FindFirstChild(legName)
        if leg then
            leg:Destroy()
        end
    end
    
    notifyHost("✓ Legs removed")
end)

registerCommand("noarms", function(args, sender)
    local char = getCharacter(player)
    
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local arms = {"Left Arm", "Right Arm"}
    for _, armName in ipairs(arms) do
        local arm = char:FindFirstChild(armName)
        if arm then
            arm:Destroy()
        end
    end
    
    notifyHost("✓ Arms removed")
end)

registerCommand("superspeed", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid.WalkSpeed = 200
        notifyHost("✓ Super speed enabled (200)")
    end
end)

registerCommand("superjump", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid.JumpPower = 200
        notifyHost("✓ Super jump enabled (200)")
    end
end)

registerCommand("normspeed", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid.WalkSpeed = 16
        notifyHost("✓ Speed reset to normal (16)")
    end
end)

registerCommand("normjump", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if humanoid then
        humanoid.JumpPower = 50
        notifyHost("✓ Jump power reset to normal (50)")
    end
end)

-- ============================================================================
-- ADMIN COMMANDS
-- ============================================================================

registerCommand("sethost", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can change host")
        return 
    end
    
    local newHost = args[1]
    if newHost then
        HOST = newHost
        local found = false
        for _, name in whitelist do
            if name == newHost then
                found = true
                break
            end
        end
        if not found then
            table.insert(whitelist, newHost)
        end
        notifyHost("✓ Host changed to " .. newHost)
    else
        notifyHost("✗ Failed: No player specified")
    end
end)

registerCommand("whitelist", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can modify whitelist")
        return 
    end
    
    local action = args[1]
    local targetInput = args[2]
    
    if action == "add" and targetInput then
        local targetPlayer = findPlayer(targetInput, sender)
        
        if not targetPlayer then
            notifyHost("✗ Player not found: " .. targetInput)
            return
        end
        
        local targetName = targetPlayer.Name
        local found = false
        for _, name in ipairs(whitelist) do
            if name == targetName then
                found = true
                break
            end
        end
        
        if not found then
            table.insert(whitelist, targetName)
            notifyHost("✓ Added " .. getPlayerName(targetPlayer) .. " to whitelist")
            sendMessage("You've been whitelisted! Use !cmds to show a list of commands!", targetPlayer, "whisper")
        else
            notifyHost("✗ " .. getPlayerName(targetPlayer) .. " is already whitelisted")
        end
    elseif action == "remove" and targetInput then
        local targetPlayer = findPlayer(targetInput, sender)
        
        if not targetPlayer then
            for i, name in ipairs(whitelist) do
                if name:lower() == targetInput:lower() then
                    table.remove(whitelist, i)
                    notifyHost("✓ Removed " .. name .. " from whitelist")
                    return
                end
            end
            notifyHost("✗ Player not found in whitelist: " .. targetInput)
            return
        end
        
        local targetName = targetPlayer.Name
        for i, name in ipairs(whitelist) do
            if name == targetName then
                table.remove(whitelist, i)
                notifyHost("✓ Removed " .. getPlayerName(targetPlayer) .. " from whitelist")
                return
            end
        end
        notifyHost("✗ " .. getPlayerName(targetPlayer) .. " not found in whitelist")
    elseif action == "list" then
        notifyHost("Whitelisted users: " .. table.concat(whitelist, ", "))
    else
        notifyHost("✗ Invalid whitelist command. Use: add/remove/list")
    end
end)

registerCommand("killscript", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can kill the script")
        return 
    end
    
    notifyHost("✓ Script terminated")
    task.wait(0.5)
    scriptRunning = false
    _G.ChatBotKillFlag = true
    _G.ChatBotRunning = false
end)

registerCommand("killprocess", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can crash the client")
        return 
    end
    
    notifyHost("✓ Crashing client...")
    task.wait(0.5)
    while true do end
end)

registerCommand("rejoin", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can rejoin")
        return 
    end
    
    notifyHost("✓ Rejoining...")
    task.wait(0.5)
    
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end)

-- ============================================================================
-- INFO COMMANDS
-- ============================================================================

registerCommand("players", function(args, sender)
    local playerList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(playerList, getPlayerName(p))
        end
    end
    
    if #playerList > 0 then
        notifyHost("Players in server (" .. #playerList .. "): " .. table.concat(playerList, ", "))
    else
        notifyHost("No other players in server")
    end
end)

registerCommand("debug", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can use debug")
        return 
    end
    
    notifyHost("=== DEBUG INFO ===")
    notifyHost("HOST: " .. HOST)
    notifyHost("Whitelist: " .. table.concat(whitelist, ", "))
    notifyHost("Sender: " .. sender.Name .. " (Display: " .. sender.DisplayName .. ")")
    notifyHost("Is Whitelisted: " .. tostring(isWhitelisted(sender)))
    notifyHost("Is Host: " .. tostring(isHost(sender)))
    notifyHost("Script Running: " .. tostring(scriptRunning))
    notifyHost("Commands Registered: " .. tostring(#commands))
    notifyHost("Whisper Mode: " .. tostring(useWhisper))
end)

registerCommand("wtoggle", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can toggle whisper mode")
        return 
    end
    
    useWhisper = not useWhisper
    
    if useWhisper then
        notifyHost("✓ Whisper mode enabled - Bot will send messages via whisper (with fallback to general)")
    else
        notifyHost("✓ Whisper mode disabled - Bot will send all messages to general chat")
    end
end)

registerCommand("cmds", function(args, sender)
    local isHostUser = isHost(sender)
    
    local commandSyntax = {
        say = "!say [message]",
        whisper = "!whisper [player] [message]",
        team = "!team [message]",
        reset = "!reset",
        jump = "!jump",
        sit = "!sit",
        unsit = "!unsit",
        speed = "!speed [number]",
        jumppower = "!jumppower [number]",
        health = "!health [number]",
        maxhealth = "!maxhealth [number]",
        dance1 = "!dance1",
        dance2 = "!dance2",
        dance3 = "!dance3",
        cheer = "!cheer",
        laugh = "!laugh",
        point = "!point",
        wave = "!wave",
        shrug = "!shrug",
        stadium = "!stadium",
        goto = "!goto [player] [offsetX?] [offsetY?] [offsetZ?]",
        follow = "!follow [player] [offsetX?] [offsetY?] [offsetZ?]",
        unfollow = "!unfollow",
        orbit = "!orbit [player] [speed?] [distance?]",
        unorbit = "!unorbit",
        freeze = "!freeze",
        unfreeze = "!unfreeze",
        thaw = "!thaw",
        walkto = "!walkto [player]",
        stopwalk = "!stopwalk",
        input = "!input [key] [duration?]",
        rainparts = "!rainparts [player] [height?] [radius?] [speed?]",
        stoprain = "!stoprain",
        spin = "!spin [speed?]",
        unspin = "!unspin",
        float = "!float [height?]",
        unfloat = "!unfloat",
        invisible = "!invisible",
        visible = "!visible",
        noclip = "!noclip",
        clip = "!clip",
        god = "!god",
        ungod = "!ungod",
        respawn = "!respawn",
        loopkill = "!loopkill [player] [velocity?]",
        unloopkill = "!unloopkill",
        attach = "!attach [player] [offsetX?] [offsetY?] [offsetZ?]",
        unattach = "!unattach",
        spam = "!spam [message]",
        unspam = "!unspam",
        size = "!size [number]",
        bring = "!bring [offsetX?] [offsetY?] [offsetZ?]",
        tpto = "!tpto <x> <y> <z>",
        tphere = "!tphere [player]",
        tpall = "!tpall",
        fling = "!fling [player] [power?]",
        rocket = "!rocket [player]",
        benx = "!benx [player]",
        headless = "!headless",
        unheadless = "!unheadless",
        bighead = "!bighead [scale?]",
        normalhead = "!normalhead",
        blockhead = "!blockhead",
        creeper = "!creeper",
        gold = "!gold",
        diamond = "!diamond",
        naked = "!naked",
        removeaccessories = "!removeaccessories",
        fire = "!fire",
        unfire = "!unfire",
        smoke = "!smoke",
        unsmoke = "!unsmoke",
        sparkles = "!sparkles",
        unsparkles = "!unsparkles",
        pointlight = "!pointlight [brightness?] [range?]",
        unpointlight = "!unpointlight",
        trail = "!trail",
        untrail = "!untrail",
        explode = "!explode [player]",
        time = "!time <hour/dawn/noon/dusk/midnight>",
        fogend = "!fogend [distance?]",
        brightness = "!brightness [level?]",
        ambient = "!ambient [r?] [g?] [b?]",
        gravity = "!gravity [value?]",
        day = "!day",
        night = "!night",
        fly = "!fly [speed?]",
        unfly = "!unfly",
        platform = "!platform",
        unplatform = "!unplatform",
        seizure = "!seizure [player]",
        unseizure = "!unseizure",
        annoy = "!annoy [player]",
        unannoy = "!unannoy",
        mimic = "!mimic [player]",
        unmimic = "!unmimic",
        crash = "!crash [player]",
        flip = "!flip",
        spinchar = "!spinchar [speed?]",
        unspinchar = "!unspinchar",
        lay = "!lay",
        standup = "!standup",
        nolimbs = "!nolimbs",
        nolegs = "!nolegs",
        noarms = "!noarms",
        superspeed = "!superspeed",
        superjump = "!superjump",
        normspeed = "!normspeed",
        normjump = "!normjump",
        sethost = "!sethost [username]",
        whitelist = "!whitelist [add/remove/list] [username?]",
        killscript = "!killscript",
        killprocess = "!killprocess",
        rejoin = "!rejoin",
        players = "!players",
        debug = "!debug",
        wtoggle = "!wtoggle",
        cmds = "!cmds",
    }
    
    if isHostUser then
        local hostCmds = {}
        local regularCmds = {}
        
        local hostOnlyCmds = {
            "bring", "sethost", "whitelist", "killscript", "killprocess", "rejoin", "debug", "wtoggle", "crash", "tphere", "tpall"
        }
        
        for name, syntax in pairs(commandSyntax) do
            local isHostOnly = false
            for _, hostCmd in ipairs(hostOnlyCmds) do
                if name == hostCmd then
                    isHostOnly = true
                    break
                end
            end
            
            if isHostOnly then
                table.insert(hostCmds, syntax)
            else
                table.insert(regularCmds, syntax)
            end
        end
        
        table.sort(hostCmds)
        table.sort(regularCmds)
        
        notifyHost("=== COMMANDS (Host) ===")
        notifyHost("")
        notifyHost("Regular: " .. table.concat(regularCmds, ", "))
        notifyHost("")
        notifyHost("Host-Only: " .. table.concat(hostCmds, ", "))
        notifyHost("")
        notifyHost("Special: Use ME, RANDOM, or HOST as [player]")
    else
        local whitelistedCmds = {}
        
        local hostOnlyCmds = {
            "bring", "sethost", "whitelist", "killscript", "killprocess", "rejoin"
        }
        
        for name, syntax in pairs(commandSyntax) do
            local isHostOnly = false
            for _, hostCmd in ipairs(hostOnlyCmds) do
                if name == hostCmd then
                    isHostOnly = true
                    break
                end
            end
            
            if not isHostOnly then
                table.insert(whitelistedCmds, syntax)
            end
        end
        
        table.sort(whitelistedCmds)
        
        if sender then
            sendLongMessage("=== AVAILABLE COMMANDS ===", sender, "whisper")
            sendLongMessage(table.concat(whitelistedCmds, ", "), sender, "whisper")
            sendLongMessage("Special: Use ME, RANDOM, or HOST as [player]", sender, "whisper")
        end
    end
end)

-- ============================================================================
-- CHAT LISTENER
-- ============================================================================

local function setupChannelListener(channel)
    channel.MessageReceived:Connect(function(message)
        if not scriptRunning or _G.ChatBotKillFlag then return end
        
        if message.TextSource then
            local sender = Players:GetPlayerByUserId(message.TextSource.UserId)
            
            if sender and sender ~= player then
                if isWhitelisted(sender) then
                    local currentTime = tick()
                    if currentTime - lastCommandTime < COMMAND_COOLDOWN then
                        return
                    end
                    
                    local cmd, args = parseCommand(message.Text)
                    if cmd and commands[cmd] then
                        lastCommandTime = currentTime
                        task.spawn(function()
                            pcall(function()
                                commands[cmd](args, sender)
                            end)
                        end)
                    end
                end
            end
        end
    end)
end

for _, channel in tcs.TextChannels:GetChildren() do
    setupChannelListener(channel)
end

tcs.TextChannels.ChildAdded:Connect(function(channel)
    setupChannelListener(channel)
end)

player.Chatted:Connect(function(message)
    if not scriptRunning or _G.ChatBotKillFlag then return end
    
    local cmd, args = parseCommand(message)
    if cmd == "sethost" and args[1] then
        HOST = args[1]
        local found = false
        for _, name in whitelist do
            if name == args[1] then
                found = true
                break
            end
        end
        if not found then
            table.insert(whitelist, args[1])
        end
    elseif cmd == "whitelist" then
        local action = args[1]
        local targetName = args[2]
        
        if action == "add" and targetName then
            local found = false
            for _, name in whitelist do
                if name == targetName then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(whitelist, targetName)
            end
        elseif action == "remove" and targetName then
            for i, name in whitelist do
                if name == targetName then
                    table.remove(whitelist, i)
                    break
                end
            end
        end
    end
end)

-- ============================================================================
-- ADVANCED MOVEMENT COMMANDS
-- ============================================================================

registerCommand("circle", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local radius = tonumber(args[2]) or 10
    local speed = tonumber(args[3]) or 0.1
    
    if _G.CircleConnection then
        _G.CircleConnection:Disconnect()
    end
    
    local angle = 0
    _G.CircleConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    angle = angle + speed
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    playerRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(x, 0, z))
                end
            end
        end)
    end)
    
    notifyHost("✓ Circling " .. getPlayerName(target) .. " (radius: " .. radius .. ", speed: " .. speed .. ")")
end)

registerCommand("uncircle", function(args, sender)
    if _G.CircleConnection then
        _G.CircleConnection:Disconnect()
        _G.CircleConnection = nil
        notifyHost("✓ Stopped circling")
    else
        notifyHost("✗ Not circling anyone")
    end
end)

registerCommand("spiral", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local startRadius = tonumber(args[2]) or 5
    local endRadius = tonumber(args[3]) or 20
    local speed = tonumber(args[4]) or 0.1
    
    if _G.SpiralConnection then
        _G.SpiralConnection:Disconnect()
    end
    
    local angle = 0
    local currentRadius = startRadius
    _G.SpiralConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    angle = angle + speed
                    currentRadius = startRadius + ((endRadius - startRadius) * ((angle % (math.pi * 2)) / (math.pi * 2)))
                    local x = math.cos(angle) * currentRadius
                    local z = math.sin(angle) * currentRadius
                    playerRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(x, 0, z))
                end
            end
        end)
    end)
    
    notifyHost("✓ Spiraling around " .. getPlayerName(target))
end)

registerCommand("unspiral", function(args, sender)
    if _G.SpiralConnection then
        _G.SpiralConnection:Disconnect()
        _G.SpiralConnection = nil
        notifyHost("✓ Stopped spiraling")
    else
        notifyHost("✗ Not spiraling")
    end
end)

registerCommand("zigzag", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local distance = tonumber(args[2]) or 10
    local speed = tonumber(args[3]) or 0.5
    
    if _G.ZigZagConnection then
        _G.ZigZagConnection:Disconnect()
    end
    
    local direction = 1
    local offset = 0
    _G.ZigZagConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    offset = offset + (speed * direction)
                    if math.abs(offset) >= distance then
                        direction = -direction
                    end
                    playerRoot.CFrame = targetRoot.CFrame * CFrame.new(offset, 0, -5)
                end
            end
        end)
    end)
    
    notifyHost("✓ Zigzagging around " .. getPlayerName(target))
end)

registerCommand("unzigzag", function(args, sender)
    if _G.ZigZagConnection then
        _G.ZigZagConnection:Disconnect()
        _G.ZigZagConnection = nil
        notifyHost("✓ Stopped zigzagging")
    else
        notifyHost("✗ Not zigzagging")
    end
end)

registerCommand("bounce", function(args, sender)
    local height = tonumber(args[1]) or 20
    local speed = tonumber(args[2]) or 0.1
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.BounceConnection then
        _G.BounceConnection:Disconnect()
    end
    
    local startY = root.Position.Y
    local time = 0
    _G.BounceConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if root then
                time = time + speed
                local offset = math.abs(math.sin(time)) * height
                root.CFrame = CFrame.new(root.Position.X, startY + offset, root.Position.Z)
            end
        end)
    end)
    
    notifyHost("✓ Bouncing (height: " .. height .. ", speed: " .. speed .. ")")
end)

registerCommand("unbounce", function(args, sender)
    if _G.BounceConnection then
        _G.BounceConnection:Disconnect()
        _G.BounceConnection = nil
        notifyHost("✓ Stopped bouncing")
    else
        notifyHost("✗ Not bouncing")
    end
end)

registerCommand("hover", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local height = tonumber(args[2]) or 10
    
    if _G.HoverConnection then
        _G.HoverConnection:Disconnect()
    end
    
    _G.HoverConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, height, 0))
                end
            end
        end)
    end)
    
    notifyHost("✓ Hovering above " .. getPlayerName(target) .. " (height: " .. height .. ")")
end)

registerCommand("unhover", function(args, sender)
    if _G.HoverConnection then
        _G.HoverConnection:Disconnect()
        _G.HoverConnection = nil
        notifyHost("✓ Stopped hovering")
    else
        notifyHost("✗ Not hovering")
    end
end)

registerCommand("shadow", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local distance = tonumber(args[2]) or -5
    
    if _G.ShadowConnection then
        _G.ShadowConnection:Disconnect()
    end
    
    _G.ShadowConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, distance)
                end
            end
        end)
    end)
    
    notifyHost("✓ Shadowing " .. getPlayerName(target) .. " (distance: " .. distance .. ")")
end)

registerCommand("unshadow", function(args, sender)
    if _G.ShadowConnection then
        _G.ShadowConnection:Disconnect()
        _G.ShadowConnection = nil
        notifyHost("✓ Stopped shadowing")
    else
        notifyHost("✗ Not shadowing")
    end
end)

registerCommand("mirror", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local distance = tonumber(args[2]) or 10
    
    if _G.MirrorConnection then
        _G.MirrorConnection:Disconnect()
    end
    
    _G.MirrorConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    local lookVector = targetRoot.CFrame.LookVector
                    playerRoot.CFrame = CFrame.new(targetRoot.Position - (lookVector * distance), targetRoot.Position)
                end
            end
        end)
    end)
    
    notifyHost("✓ Mirroring " .. getPlayerName(target) .. " (distance: " .. distance .. ")")
end)

registerCommand("unmirror", function(args, sender)
    if _G.MirrorConnection then
        _G.MirrorConnection:Disconnect()
        _G.MirrorConnection = nil
        notifyHost("✓ Stopped mirroring")
    else
        notifyHost("✗ Not mirroring")
    end
end)

-- ============================================================================
-- ANIMATION COMMANDS
-- ============================================================================

registerCommand("animate", function(args, sender)
    local animId = args[1]
    
    if not animId then
        notifyHost("✗ Usage: !animate <animationId>")
        return
    end
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if not humanoid then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animId
    
    if _G.CurrentAnimation then
        _G.CurrentAnimation:Stop()
    end
    
    _G.CurrentAnimation = animator:LoadAnimation(animation)
    _G.CurrentAnimation:Play()
    
    notifyHost("✓ Playing animation: " .. animId)
end)

registerCommand("stopanimate", function(args, sender)
    if _G.CurrentAnimation then
        _G.CurrentAnimation:Stop()
        _G.CurrentAnimation = nil
        notifyHost("✓ Stopped animation")
    else
        notifyHost("✗ No animation playing")
    end
end)

registerCommand("loopanim", function(args, sender)
    local animId = args[1]
    
    if not animId then
        notifyHost("✗ Usage: !loopanim <animationId>")
        return
    end
    
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    
    if not humanoid then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animId
    
    if _G.LoopAnimation then
        _G.LoopAnimation:Stop()
    end
    
    _G.LoopAnimation = animator:LoadAnimation(animation)
    _G.LoopAnimation.Looped = true
    _G.LoopAnimation:Play()
    
    notifyHost("✓ Looping animation: " .. animId)
end)

registerCommand("stoploopani m", function(args, sender)
    if _G.LoopAnimation then
        _G.LoopAnimation:Stop()
        _G.LoopAnimation = nil
        notifyHost("✓ Stopped loop animation")
    else
        notifyHost("✗ No loop animation playing")
    end
end)

-- ============================================================================
-- PART MANIPULATION COMMANDS
-- ============================================================================

registerCommand("scalepart", function(args, sender)
    local partName = args[1]
    local scale = tonumber(args[2]) or 2
    
    if not partName then
        notifyHost("✗ Usage: !scalepart <partName> <scale>")
        return
    end
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local part = char:FindFirstChild(partName)
    if part and part:IsA("BasePart") then
        part.Size = part.Size * scale
        notifyHost("✓ Scaled " .. partName .. " by " .. scale)
    else
        notifyHost("✗ Part not found: " .. partName)
    end
end)

registerCommand("colorpart", function(args, sender)
    local partName = args[1]
    local r = tonumber(args[2]) or 255
    local g = tonumber(args[3]) or 255
    local b = tonumber(args[4]) or 255
    
    if not partName then
        notifyHost("✗ Usage: !colorpart <partName> <r> <g> <b>")
        return
    end
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local part = char:FindFirstChild(partName)
    if part and part:IsA("BasePart") then
        part.Color = Color3.fromRGB(r, g, b)
        notifyHost("✓ Colored " .. partName .. " to RGB(" .. r .. ", " .. g .. ", " .. b .. ")")
    else
        notifyHost("✗ Part not found: " .. partName)
    end
end)

registerCommand("materialpart", function(args, sender)
    local partName = args[1]
    local material = args[2]
    
    if not partName or not material then
        notifyHost("✗ Usage: !materialpart <partName> <material>")
        return
    end
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local part = char:FindFirstChild(partName)
    if part and part:IsA("BasePart") then
        local materialEnum = Enum.Material[material]
        if materialEnum then
            part.Material = materialEnum
            notifyHost("✓ Changed " .. partName .. " material to " .. material)
        else
            notifyHost("✗ Invalid material: " .. material)
        end
    else
        notifyHost("✗ Part not found: " .. partName)
    end
end)

registerCommand("transparentpart", function(args, sender)
    local partName = args[1]
    local transparency = tonumber(args[2]) or 0.5
    
    if not partName then
        notifyHost("✗ Usage: !transparentpart <partName> <transparency>")
        return
    end
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local part = char:FindFirstChild(partName)
    if part and part:IsA("BasePart") then
        part.Transparency = transparency
        notifyHost("✓ Set " .. partName .. " transparency to " .. transparency)
    else
        notifyHost("✗ Part not found: " .. partName)
    end
end)

registerCommand("reflectpart", function(args, sender)
    local partName = args[1]
    local reflectance = tonumber(args[2]) or 0.5
    
    if not partName then
        notifyHost("✗ Usage: !reflectpart <partName> <reflectance>")
        return
    end
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local part = char:FindFirstChild(partName)
    if part and part:IsA("BasePart") then
        part.Reflectance = reflectance
        notifyHost("✓ Set " .. partName .. " reflectance to " .. reflectance)
    else
        notifyHost("✗ Part not found: " .. partName)
    end
end)

-- ============================================================================
-- ADVANCED VISUAL EFFECTS
-- ============================================================================

registerCommand("beam", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if not targetChar or not playerChar then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local targetRoot = getRoot(targetChar)
    local playerRoot = getRoot(playerChar)
    
    if not targetRoot or not playerRoot then
        notifyHost("✗ Failed: Character root not found")
        return
    end
    
    local att0 = Instance.new("Attachment")
    att0.Parent = playerRoot
    
    local att1 = Instance.new("Attachment")
    att1.Parent = targetRoot
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Width0 = 1
    beam.Width1 = 1
    beam.Parent = playerRoot
    
    notifyHost("✓ Beam created to " .. getPlayerName(target))
end)

registerCommand("removebeams", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local count = 0
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Beam") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    notifyHost("✓ Removed " .. count .. " beams")
end)

registerCommand("particle", function(args, sender)
    local particleType = args[1] or "Fire"
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local particle
    if particleType == "Fire" then
        particle = Instance.new("Fire")
    elseif particleType == "Smoke" then
        particle = Instance.new("Smoke")
    elseif particleType == "Sparkles" then
        particle = Instance.new("Sparkles")
    else
        notifyHost("✗ Invalid particle type. Use: Fire, Smoke, or Sparkles")
        return
    end
    
    particle.Parent = root
    notifyHost("✓ Added " .. particleType .. " particle effect")
end)

registerCommand("removeparticles", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local count = 0
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("ParticleEmitter") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    notifyHost("✓ Removed " .. count .. " particle effects")
end)

registerCommand("glow", function(args, sender)
    local brightness = tonumber(args[1]) or 10
    local color = args[2] or "white"
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            local light = Instance.new("PointLight")
            light.Brightness = brightness
            light.Range = 20
            
            if color == "red" then
                light.Color = Color3.fromRGB(255, 0, 0)
            elseif color == "blue" then
                light.Color = Color3.fromRGB(0, 0, 255)
            elseif color == "green" then
                light.Color = Color3.fromRGB(0, 255, 0)
            elseif color == "yellow" then
                light.Color = Color3.fromRGB(255, 255, 0)
            elseif color == "purple" then
                light.Color = Color3.fromRGB(128, 0, 128)
            else
                light.Color = Color3.fromRGB(255, 255, 255)
            end
            
            light.Parent = part
        end
    end
    
    notifyHost("✓ Glow effect enabled (brightness: " .. brightness .. ", color: " .. color .. ")")
end)

registerCommand("unglow", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj:Destroy()
        end
    end
    
    notifyHost("✓ Glow effect removed")
end)

registerCommand("aura", function(args, sender)
    local color = args[1] or "white"
    local size = tonumber(args[2]) or 5
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.AuraPart then
        _G.AuraPart:Destroy()
    end
    
    local auraPart = Instance.new("Part")
    auraPart.Name = "Aura"
    auraPart.Size = Vector3.new(size, size, size)
    auraPart.Shape = Enum.PartType.Ball
    auraPart.Transparency = 0.7
    auraPart.CanCollide = false
    auraPart.Anchored = false
    auraPart.Material = Enum.Material.Neon
    
    if color == "red" then
        auraPart.Color = Color3.fromRGB(255, 0, 0)
    elseif color == "blue" then
        auraPart.Color = Color3.fromRGB(0, 0, 255)
    elseif color == "green" then
        auraPart.Color = Color3.fromRGB(0, 255, 0)
    elseif color == "yellow" then
        auraPart.Color = Color3.fromRGB(255, 255, 0)
    elseif color == "purple" then
        auraPart.Color = Color3.fromRGB(128, 0, 128)
    else
        auraPart.Color = Color3.fromRGB(255, 255, 255)
    end
    
    auraPart.Parent = workspace
    _G.AuraPart = auraPart
    
    local weld = Instance.new("Weld")
    weld.Part0 = root
    weld.Part1 = auraPart
    weld.Parent = auraPart
    
    notifyHost("✓ Aura enabled (color: " .. color .. ", size: " .. size .. ")")
end)

registerCommand("unaura", function(args, sender)
    if _G.AuraPart then
        _G.AuraPart:Destroy()
        _G.AuraPart = nil
        notifyHost("✓ Aura removed")
    else
        notifyHost("✗ No aura active")
    end
end)

registerCommand("rainbow", function(args, sender)
    local speed = tonumber(args[1]) or 0.5
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.RainbowConnection then
        _G.RainbowConnection:Disconnect()
    end
    
    local hue = 0
    _G.RainbowConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            hue = (hue + speed) % 360
            local color = Color3.fromHSV(hue / 360, 1, 1)
            
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
        end)
    end)
    
    notifyHost("✓ Rainbow mode enabled (speed: " .. speed .. ")")
end)

registerCommand("unrainbow", function(args, sender)
    if _G.RainbowConnection then
        _G.RainbowConnection:Disconnect()
        _G.RainbowConnection = nil
        notifyHost("✓ Rainbow mode disabled")
    else
        notifyHost("✗ Rainbow mode not active")
    end
end)

registerCommand("disco", function(args, sender)
    local speed = tonumber(args[1]) or 0.1
    
    if _G.DiscoConnection then
        _G.DiscoConnection:Disconnect()
    end
    
    local Lighting = game:GetService("Lighting")
    _G.DiscoConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            Lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            Lighting.OutdoorAmbient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        end)
        task.wait(speed)
    end)
    
    notifyHost("✓ Disco mode enabled (speed: " .. speed .. ")")
end)

registerCommand("undisco", function(args, sender)
    if _G.DiscoConnection then
        _G.DiscoConnection:Disconnect()
        _G.DiscoConnection = nil
        
        local Lighting = game:GetService("Lighting")
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        notifyHost("✓ Disco mode disabled")
    else
        notifyHost("✗ Disco mode not active")
    end
end)

-- ============================================================================
-- SOUND COMMANDS
-- ============================================================================

registerCommand("playsound", function(args, sender)
    local soundId = args[1]
    local volume = tonumber(args[2]) or 0.5
    
    if not soundId then
        notifyHost("✗ Usage: !playsound <soundId> [volume]")
        return
    end
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.CurrentSound then
        _G.CurrentSound:Destroy()
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume
    sound.Parent = root
    sound:Play()
    
    _G.CurrentSound = sound
    notifyHost("✓ Playing sound: " .. soundId .. " (volume: " .. volume .. ")")
end)

registerCommand("stopsound", function(args, sender)
    if _G.CurrentSound then
        _G.CurrentSound:Stop()
        _G.CurrentSound:Destroy()
        _G.CurrentSound = nil
        notifyHost("✓ Sound stopped")
    else
        notifyHost("✗ No sound playing")
    end
end)

registerCommand("loopsound", function(args, sender)
    local soundId = args[1]
    local volume = tonumber(args[2]) or 0.5
    
    if not soundId then
        notifyHost("✗ Usage: !loopsound <soundId> [volume]")
        return
    end
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    if _G.LoopSound then
        _G.LoopSound:Destroy()
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume
    sound.Looped = true
    sound.Parent = root
    sound:Play()
    
    _G.LoopSound = sound
    notifyHost("✓ Looping sound: " .. soundId .. " (volume: " .. volume .. ")")
end)

registerCommand("stoploopsound", function(args, sender)
    if _G.LoopSound then
        _G.LoopSound:Stop()
        _G.LoopSound:Destroy()
        _G.LoopSound = nil
        notifyHost("✓ Loop sound stopped")
    else
        notifyHost("✗ No loop sound playing")
    end
end)

registerCommand("pitch", function(args, sender)
    local pitch = tonumber(args[1]) or 1
    
    if _G.CurrentSound then
        _G.CurrentSound.PlaybackSpeed = pitch
        notifyHost("✓ Sound pitch set to " .. pitch)
    elseif _G.LoopSound then
        _G.LoopSound.PlaybackSpeed = pitch
        notifyHost("✓ Sound pitch set to " .. pitch)
    else
        notifyHost("✗ No sound playing")
    end
end)

registerCommand("volume", function(args, sender)
    local volume = tonumber(args[1]) or 0.5
    
    if _G.CurrentSound then
        _G.CurrentSound.Volume = volume
        notifyHost("✓ Sound volume set to " .. volume)
    elseif _G.LoopSound then
        _G.LoopSound.Volume = volume
        notifyHost("✓ Sound volume set to " .. volume)
    else
        notifyHost("✗ No sound playing")
    end
end)

-- ============================================================================
-- TOOL COMMANDS
-- ============================================================================

registerCommand("tool", function(args, sender)
    local toolName = table.concat(args, " ")
    
    if not toolName or toolName == "" then
        notifyHost("✗ Usage: !tool <toolName>")
        return
    end
    
    local tool = player.Backpack:FindFirstChild(toolName)
    if not tool then
        for _, t in ipairs(player.Backpack:GetChildren()) do
            if t.Name:lower():find(toolName:lower(), 1, true) then
                tool = t
                break
            end
        end
    end
    
    if tool then
        local char = getCharacter(player)
        local humanoid = getHumanoid(char)
        if humanoid then
            humanoid:EquipTool(tool)
            notifyHost("✓ Equipped tool: " .. tool.Name)
        end
    else
        notifyHost("✗ Tool not found: " .. toolName)
    end
end)

registerCommand("untool", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = player.Backpack
        notifyHost("✓ Unequipped tool: " .. tool.Name)
    else
        notifyHost("✗ No tool equipped")
    end
end)

registerCommand("droptools", function(args, sender)
    local count = 0
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = workspace
            count = count + 1
        end
    end
    
    local char = getCharacter(player)
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = workspace
                count = count + 1
            end
        end
    end
    
    notifyHost("✓ Dropped " .. count .. " tools")
end)

registerCommand("removetools", function(args, sender)
    local count = 0
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool:Destroy()
            count = count + 1
        end
    end
    
    local char = getCharacter(player)
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
                count = count + 1
            end
        end
    end
    
    notifyHost("✓ Removed " .. count .. " tools")
end)

registerCommand("clonetools", function(args, sender)
    local count = tonumber(args[1]) or 1
    local cloned = 0
    
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for i = 1, count do
                local clone = tool:Clone()
                clone.Parent = player.Backpack
                cloned = cloned + 1
            end
        end
    end
    
    notifyHost("✓ Cloned " .. cloned .. " tools")
end)

-- ============================================================================
-- TEAM COMMANDS
-- ============================================================================

registerCommand("changeteam", function(args, sender)
    local teamName = table.concat(args, " ")
    
    if not teamName or teamName == "" then
        notifyHost("✗ Usage: !changeteam <teamName>")
        return
    end
    
    local Teams = game:GetService("Teams")
    local team = Teams:FindFirstChild(teamName)
    
    if not team then
        for _, t in ipairs(Teams:GetTeams()) do
            if t.Name:lower():find(teamName:lower(), 1, true) then
                team = t
                break
            end
        end
    end
    
    if team then
        player.Team = team
        notifyHost("✓ Changed team to: " .. team.Name)
    else
        notifyHost("✗ Team not found: " .. teamName)
    end
end)

registerCommand("listteams", function(args, sender)
    local Teams = game:GetService("Teams")
    local teamList = {}
    
    for _, team in ipairs(Teams:GetTeams()) do
        table.insert(teamList, team.Name)
    end
    
    if #teamList > 0 then
        notifyHost("Available teams: " .. table.concat(teamList, ", "))
    else
        notifyHost("No teams available")
    end
end)

registerCommand("teamcolor", function(args, sender)
    if not player.Team then
        notifyHost("✗ Not on a team")
        return
    end
    
    notifyHost("Current team: " .. player.Team.Name .. " (Color: " .. tostring(player.Team.TeamColor) .. ")")
end)

-- ============================================================================
-- WORKSPACE MANIPULATION COMMANDS
-- ============================================================================

registerCommand("clearworkspace", function(args, sender)
    if not isHost(sender) then 
        notifyHost("✗ Failed: Only host can clear workspace")
        return 
    end
    
    local count = 0
    for _, obj in ipairs(workspace:GetChildren()) do
        if not obj:IsA("Terrain") and not obj:IsA("Camera") and not Players:GetPlayerFromCharacter(obj) then
            pcall(function()
                obj:Destroy()
                count = count + 1
            end)
        end
    end
    
    notifyHost("✓ Cleared " .. count .. " objects from workspace")
end)

registerCommand("spawnpart", function(args, sender)
    local size = tonumber(args[1]) or 5
    local r = tonumber(args[2]) or 128
    local g = tonumber(args[3]) or 128
    local b = tonumber(args[4]) or 128
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local part = Instance.new("Part")
    part.Size = Vector3.new(size, size, size)
    part.Color = Color3.fromRGB(r, g, b)
    part.Position = root.Position + Vector3.new(0, size + 2, 0)
    part.Parent = workspace
    
    notifyHost("✓ Spawned part (size: " .. size .. ", color: RGB(" .. r .. ", " .. g .. ", " .. b .. "))")
end)

registerCommand("spawnmodel", function(args, sender)
    local modelId = args[1]
    
    if not modelId then
        notifyHost("✗ Usage: !spawnmodel <modelId>")
        return
    end
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local InsertService = game:GetService("InsertService")
    pcall(function()
        local model = InsertService:LoadAsset(tonumber(modelId))
        if model then
            model:MoveTo(root.Position + Vector3.new(0, 5, 0))
            model.Parent = workspace
            notifyHost("✓ Spawned model: " .. modelId)
        end
    end)
end)

-- ============================================================================
-- ADVANCED TELEPORT COMMANDS
-- ============================================================================

registerCommand("tploop", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local delay = tonumber(args[2]) or 0.5
    
    if _G.TpLoopConnection then
        _G.TpLoopConnection:Disconnect()
    end
    
    _G.TpLoopConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local targetChar = getCharacter(target)
            local playerChar = getCharacter(player)
            
            if targetChar and playerChar then
                local targetRoot = getRoot(targetChar)
                local playerRoot = getRoot(playerChar)
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame * CFrame.new(3, 0, 0)
                end
            end
        end)
        task.wait(delay)
    end)
    
    notifyHost("✓ TP loop to " .. getPlayerName(target) .. " (delay: " .. delay .. ")")
end)

registerCommand("untploop", function(args, sender)
    if _G.TpLoopConnection then
        _G.TpLoopConnection:Disconnect()
        _G.TpLoopConnection = nil
        notifyHost("✓ Stopped TP loop")
    else
        notifyHost("✗ TP loop not active")
    end
end)

registerCommand("tpbehind", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local distance = tonumber(args[2]) or 5
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if targetChar and playerChar then
        local targetRoot = getRoot(targetChar)
        local playerRoot = getRoot(playerChar)
        
        if targetRoot and playerRoot then
            local lookVector = targetRoot.CFrame.LookVector
            playerRoot.CFrame = CFrame.new(targetRoot.Position - (lookVector * distance), targetRoot.Position)
            notifyHost("✓ Teleported behind " .. getPlayerName(target))
        end
    end
end)

registerCommand("tpabove", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local height = tonumber(args[2]) or 10
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if targetChar and playerChar then
        local targetRoot = getRoot(targetChar)
        local playerRoot = getRoot(playerChar)
        
        if targetRoot and playerRoot then
            playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, height, 0)
            notifyHost("✓ Teleported above " .. getPlayerName(target) .. " (height: " .. height .. ")")
        end
    end
end)

registerCommand("tpunder", function(args, sender)
    local target = findPlayer(args[1], sender)
    
    if not target then
        notifyHost("✗ Failed: Player not found")
        return
    end
    
    local depth = tonumber(args[2]) or 10
    
    local targetChar = getCharacter(target)
    local playerChar = getCharacter(player)
    
    if targetChar and playerChar then
        local targetRoot = getRoot(targetChar)
        local playerRoot = getRoot(playerChar)
        
        if targetRoot and playerRoot then
            playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -depth, 0)
            notifyHost("✓ Teleported under " .. getPlayerName(target) .. " (depth: " .. depth .. ")")
        end
    end
end)

registerCommand("tprandom", function(args, sender)
    local range = tonumber(args[1]) or 100
    
    local char = getCharacter(player)
    local root = getRoot(char)
    
    if not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local randomX = math.random(-range, range)
    local randomY = math.random(0, range)
    local randomZ = math.random(-range, range)
    
    root.CFrame = CFrame.new(randomX, randomY, randomZ)
    notifyHost("✓ Teleported to random location (" .. randomX .. ", " .. randomY .. ", " .. randomZ .. ")")
end)

registerCommand("tpspawn", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local spawnLocation = workspace:FindFirstChild("SpawnLocation")
    if not spawnLocation then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("SpawnLocation") then
                spawnLocation = obj
                break
            end
        end
    end
    
    if spawnLocation then
        local root = getRoot(char)
        if root then
            root.CFrame = spawnLocation.CFrame * CFrame.new(0, 5, 0)
            notifyHost("✓ Teleported to spawn")
        end
    else
        notifyHost("✗ Spawn location not found")
    end
end)

-- ============================================================================
-- CHARACTER STATE COMMANDS
-- ============================================================================

registerCommand("ragdoll", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        notifyHost("✓ Ragdoll enabled")
    end
end)

registerCommand("unragdoll", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        notifyHost("✓ Ragdoll disabled")
    end
end)

registerCommand("platformstand", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.PlatformStand = true
        notifyHost("✓ Platform stand enabled")
    end
end)

registerCommand("unplatformstand", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.PlatformStand = false
        notifyHost("✓ Platform stand disabled")
    end
end)

registerCommand("swim", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        notifyHost("✓ Swimming state enabled")
    end
end)

registerCommand("climb", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
        notifyHost("✓ Climbing state enabled")
    end
end)

registerCommand("freefall", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        notifyHost("✓ Freefall state enabled")
    end
end)

-- ============================================================================
-- ADVANCED APPEARANCE COMMANDS
-- ============================================================================

registerCommand("scale", function(args, sender)
    local scale = tonumber(args[1]) or 2
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Size = part.Size * scale
        end
    end
    
    notifyHost("✓ Character scaled by " .. scale)
end)

registerCommand("stretch", function(args, sender)
    local axis = args[1] or "Y"
    local amount = tonumber(args[2]) or 2
    
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if axis:upper() == "X" then
                part.Size = Vector3.new(part.Size.X * amount, part.Size.Y, part.Size.Z)
            elseif axis:upper() == "Y" then
                part.Size = Vector3.new(part.Size.X, part.Size.Y * amount, part.Size.Z)
            elseif axis:upper() == "Z" then
                part.Size = Vector3.new(part.Size.X, part.Size.Y, part.Size.Z * amount)
            end
        end
    end
    
    notifyHost("✓ Character stretched on " .. axis .. " axis by " .. amount)
end)

registerCommand("thin", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Size = Vector3.new(part.Size.X * 0.5, part.Size.Y, part.Size.Z * 0.5)
        end
    end
    
    notifyHost("✓ Character made thin")
end)

registerCommand("fat", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Size = Vector3.new(part.Size.X * 2, part.Size.Y, part.Size.Z * 2)
        end
    end
    
    notifyHost("✓ Character made fat")
end)

registerCommand("tiny", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * 0.5
        end
    end
    
    notifyHost("✓ Character made tiny")
end)

registerCommand("giant", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * 3
        end
    end
    
    notifyHost("✓ Character made giant")
end)

registerCommand("normalsize", function(args, sender)
    player:LoadCharacter()
    notifyHost("✓ Character size reset (respawned)")
end)

-- ============================================================================
-- MATERIAL COMMANDS
-- ============================================================================

registerCommand("neon", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Neon
        end
    end
    
    notifyHost("✓ Character material set to Neon")
end)

registerCommand("glass", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Glass
            part.Transparency = 0.5
        end
    end
    
    notifyHost("✓ Character material set to Glass")
end)

registerCommand("metal", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Metal
            part.Reflectance = 0.5
        end
    end
    
    notifyHost("✓ Character material set to Metal")
end)

registerCommand("wood", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Wood
            part.Color = Color3.fromRGB(163, 162, 165)
        end
    end
    
    notifyHost("✓ Character material set to Wood")
end)

registerCommand("ice", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Ice
            part.Color = Color3.fromRGB(200, 230, 255)
            part.Transparency = 0.3
        end
    end
    
    notifyHost("✓ Character material set to Ice")
end)

registerCommand("brick", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Brick
            part.Color = Color3.fromRGB(138, 86, 62)
        end
    end
    
    notifyHost("✓ Character material set to Brick")
end)

registerCommand("concrete", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Concrete
            part.Color = Color3.fromRGB(127, 127, 127)
        end
    end
    
    notifyHost("✓ Character material set to Concrete")
end)

registerCommand("forcefield", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local ff = Instance.new("ForceField")
    ff.Parent = char
    
    notifyHost("✓ Force field enabled")
end)

registerCommand("unforcefield", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("ForceField") then
            obj:Destroy()
        end
    end
    
    notifyHost("✓ Force field removed")
end)

-- ============================================================================
-- ADVANCED LIGHTING COMMANDS
-- ============================================================================

registerCommand("fullbright", function(args, sender)
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    
    notifyHost("✓ Full bright enabled")
end)

registerCommand("darkness", function(args, sender)
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    Lighting.FogEnd = 100
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    
    notifyHost("✓ Darkness enabled")
end)

registerCommand("colorsky", function(args, sender)
    local r = tonumber(args[1]) or 255
    local g = tonumber(args[2]) or 255
    local b = tonumber(args[3]) or 255
    
    local Lighting = game:GetService("Lighting")
    Lighting.OutdoorAmbient = Color3.fromRGB(r, g, b)
    
    notifyHost("✓ Sky color set to RGB(" .. r .. ", " .. g .. ", " .. b .. ")")
end)

registerCommand("shadows", function(args, sender)
    local enabled = args[1] == "true" or args[1] == "on"
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = enabled
    
    notifyHost("✓ Global shadows " .. (enabled and "enabled" or "disabled"))
end)

registerCommand("exposure", function(args, sender)
    local exposure = tonumber(args[1]) or 1
    
    local Lighting = game:GetService("Lighting")
    Lighting.ExposureCompensation = exposure
    
    notifyHost("✓ Exposure set to " .. exposure)
end)

-- ============================================================================
-- CAMERA COMMANDS
-- ============================================================================

registerCommand("fixcam", function(args, sender)
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = getHumanoid(getCharacter(player))
    
    notifyHost("✓ Camera fixed")
end)

registerCommand("freecam", function(args, sender)
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Fixed
    
    notifyHost("✓ Free cam enabled")
end)

registerCommand("firstperson", function(args, sender)
    local humanoid = getHumanoid(getCharacter(player))
    if humanoid then
        humanoid.CameraOffset = Vector3.new(0, 0, 0)
        player.CameraMaxZoomDistance = 0.5
        player.CameraMinZoomDistance = 0.5
        notifyHost("✓ First person mode enabled")
    end
end)

registerCommand("thirdperson", function(args, sender)
    local humanoid = getHumanoid(getCharacter(player))
    if humanoid then
        humanoid.CameraOffset = Vector3.new(0, 0, 0)
        player.CameraMaxZoomDistance = 128
        player.CameraMinZoomDistance = 0.5
        notifyHost("✓ Third person mode enabled")
    end
end)

registerCommand("camshake", function(args, sender)
    local intensity = tonumber(args[1]) or 10
    local duration = tonumber(args[2]) or 5
    
    if _G.CamShakeConnection then
        _G.CamShakeConnection:Disconnect()
    end
    
    local camera = workspace.CurrentCamera
    local startTime = tick()
    
    _G.CamShakeConnection = RunService.RenderStepped:Connect(function()
        if tick() - startTime >= duration then
            _G.CamShakeConnection:Disconnect()
            _G.CamShakeConnection = nil
            notifyHost("✓ Camera shake ended")
            return
        end
        
        local shake = Vector3.new(
            math.random(-intensity, intensity) / 10,
            math.random(-intensity, intensity) / 10,
            math.random(-intensity, intensity) / 10
        )
        camera.CFrame = camera.CFrame * CFrame.new(shake)
    end)
    
    notifyHost("✓ Camera shake enabled (intensity: " .. intensity .. ", duration: " .. duration .. ")")
end)

registerCommand("uncamshake", function(args, sender)
    if _G.CamShakeConnection then
        _G.CamShakeConnection:Disconnect()
        _G.CamShakeConnection = nil
        notifyHost("✓ Camera shake disabled")
    else
        notifyHost("✗ Camera shake not active")
    end
end)

registerCommand("fov", function(args, sender)
    local fov = tonumber(args[1]) or 70
    
    local camera = workspace.CurrentCamera
    camera.FieldOfView = fov
    
    notifyHost("✓ Field of view set to " .. fov)
end)

-- ============================================================================
-- STAT TRACKING COMMANDS
-- ============================================================================

registerCommand("stats", function(args, sender)
    local char = getCharacter(player)
    local humanoid = getHumanoid(char)
    local root = getRoot(char)
    
    if not char or not humanoid or not root then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local stats = {
        "=== CHARACTER STATS ===",
        "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth),
        "WalkSpeed: " .. humanoid.WalkSpeed,
        "JumpPower: " .. (humanoid.UseJumpPower and humanoid.JumpPower or humanoid.JumpHeight),
        "Position: " .. tostring(root.Position),
        "Team: " .. (player.Team and player.Team.Name or "None"),
        "Sitting: " .. tostring(humanoid.Sit),
        "PlatformStand: " .. tostring(humanoid.PlatformStand),
    }
    
    for _, line in ipairs(stats) do
        notifyHost(line)
        task.wait(0.1)
    end
end)

registerCommand("ping", function(args, sender)
    local ping = player:GetNetworkPing() * 1000
    notifyHost("Ping: " .. math.floor(ping) .. "ms")
end)

registerCommand("fps", function(args, sender)
    local fps = 1 / RunService.RenderStepped:Wait()
    notifyHost("FPS: " .. math.floor(fps))
end)

registerCommand("serverinfo", function(args, sender)
    local info = {
        "=== SERVER INFO ===",
        "PlaceId: " .. game.PlaceId,
        "JobId: " .. game.JobId,
        "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        "Time: " .. math.floor(workspace.DistributedGameTime) .. "s",
    }
    
    for _, line in ipairs(info) do
        notifyHost(line)
        task.wait(0.1)
    end
end)

-- ============================================================================
-- UTILITY LOOP COMMANDS
-- ============================================================================

registerCommand("loopjump", function(args, sender)
    if _G.LoopJumpConnection then
        _G.LoopJumpConnection:Disconnect()
    end
    
    _G.LoopJumpConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local humanoid = getHumanoid(getCharacter(player))
            if humanoid then
                humanoid.Jump = true
            end
        end)
        task.wait(0.3)
    end)
    
    notifyHost("✓ Loop jump enabled")
end)

registerCommand("unloopjump", function(args, sender)
    if _G.LoopJumpConnection then
        _G.LoopJumpConnection:Disconnect()
        _G.LoopJumpConnection = nil
        notifyHost("✓ Loop jump disabled")
    else
        notifyHost("✗ Loop jump not active")
    end
end)

registerCommand("loopsit", function(args, sender)
    if _G.LoopSitConnection then
        _G.LoopSitConnection:Disconnect()
    end
    
    _G.LoopSitConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local humanoid = getHumanoid(getCharacter(player))
            if humanoid then
                humanoid.Sit = true
            end
        end)
    end)
    
    notifyHost("✓ Loop sit enabled")
end)

registerCommand("unloopsit", function(args, sender)
    if _G.LoopSitConnection then
        _G.LoopSitConnection:Disconnect()
        _G.LoopSitConnection = nil
        notifyHost("✓ Loop sit disabled")
    else
        notifyHost("✗ Loop sit not active")
    end
end)

registerCommand("loopheal", function(args, sender)
    if _G.LoopHealConnection then
        _G.LoopHealConnection:Disconnect()
    end
    
    _G.LoopHealConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local humanoid = getHumanoid(getCharacter(player))
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        task.wait(0.1)
    end)
    
    notifyHost("✓ Loop heal enabled")
end)

registerCommand("unloopheal", function(args, sender)
    if _G.LoopHealConnection then
        _G.LoopHealConnection:Disconnect()
        _G.LoopHealConnection = nil
        notifyHost("✓ Loop heal disabled")
    else
        notifyHost("✗ Loop heal not active")
    end
end)

-- ============================================================================
-- CLEANUP AND STOP ALL COMMANDS
-- ============================================================================

registerCommand("stopall", function(args, sender)
    local connections = {
        "FollowConnection", "OrbitConnection", "OrbitConnection2", "RainPartsConnection",
        "SpinConnection", "FloatConnection", "NoclipConnection", "LoopKillConnection",
        "AttachConnection", "SpamConnection", "FlyConnection", "PlatformConnection",
        "SeizureConnection", "AnnoyConnection", "MimicConnection", "SpinCharConnection",
        "CircleConnection", "SpiralConnection", "ZigZagConnection", "BounceConnection",
        "HoverConnection", "ShadowConnection", "MirrorConnection", "RainbowConnection",
        "DiscoConnection", "TpLoopConnection", "CamShakeConnection", "LoopJumpConnection",
        "LoopSitConnection", "LoopHealConnection"
    }
    
    local stopped = 0
    for _, connName in ipairs(connections) do
        if _G[connName] then
            _G[connName]:Disconnect()
            _G[connName] = nil
            stopped = stopped + 1
        end
    end
    
    if _G.CurrentSound then
        _G.CurrentSound:Destroy()
        _G.CurrentSound = nil
    end
    
    if _G.LoopSound then
        _G.LoopSound:Destroy()
        _G.LoopSound = nil
    end
    
    if _G.Platform then
        _G.Platform:Destroy()
        _G.Platform = nil
    end
    
    if _G.AuraPart then
        _G.AuraPart:Destroy()
        _G.AuraPart = nil
    end
    
    notifyHost("✓ Stopped " .. stopped .. " active connections and cleaned up")
end)

registerCommand("cleanup", function(args, sender)
    local char = getCharacter(player)
    if not char then
        notifyHost("✗ Failed: Character not found")
        return
    end
    
    local cleaned = 0
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj:IsA("BodyPosition") or 
           obj:IsA("BodyAngularVelocity") or obj:IsA("Fire") or obj:IsA("Smoke") or 
           obj:IsA("Sparkles") or obj:IsA("PointLight") or obj:IsA("Trail") or 
           obj:IsA("Beam") or obj:IsA("ForceField") then
            obj:Destroy()
            cleaned = cleaned + 1
        end
    end
    
    notifyHost("✓ Cleaned up " .. cleaned .. " objects from character")
end)

-- ============================================================================
-- MISCELLANEOUS UTILITY COMMANDS
-- ============================================================================

registerCommand("version", function(args, sender)
    notifyHost("ChatBot Version 2.0 - Optimized Edition")
end)

registerCommand("uptime", function(args, sender)
    local uptime = math.floor(workspace.DistributedGameTime)
    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = uptime % 60
    
    notifyHost("Server uptime: " .. hours .. "h " .. minutes .. "m " .. seconds .. "s")
end)

registerCommand("timestamp", function(args, sender)
    notifyHost("Current timestamp: " .. os.time())
end)

registerCommand("echo", function(args, sender)
    local message = table.concat(args, " ")
    notifyHost("Echo: " .. message)
end)

registerCommand("repeat", function(args, sender)
    local count = tonumber(args[1]) or 1
    table.remove(args, 1)
    local message = table.concat(args, " ")
    
    for i = 1, math.min(count, 10) do
        sendMessage(message, nil, "general")
        task.wait(0.5)
    end
    
    notifyHost("✓ Repeated message " .. count .. " times")
end)

registerCommand("countdown", function(args, sender)
    local start = tonumber(args[1]) or 10
    
    for i = start, 1, -1 do
        sendMessage(tostring(i), nil, "general")
        task.wait(1)
    end
    
    sendMessage("GO!", nil, "general")
    notifyHost("✓ Countdown complete")
end)

registerCommand("randomnumber", function(args, sender)
    local min = tonumber(args[1]) or 1
    local max = tonumber(args[2]) or 100
    
    local num = math.random(min, max)
    notifyHost("Random number (" .. min .. "-" .. max .. "): " .. num)
end)

registerCommand("coinflip", function(args, sender)
    local result = math.random(1, 2) == 1 and "Heads" or "Tails"
    notifyHost("Coin flip result: " .. result)
end)

registerCommand("dice", function(args, sender)
    local sides = tonumber(args[1]) or 6
    local result = math.random(1, sides)
    notifyHost("Dice roll (d" .. sides .. "): " .. result)
end)

registerCommand("calculate", function(args, sender)
    local expression = table.concat(args, " ")
    local success, result = pcall(function()
        return loadstring("return " .. expression)()
    end)
    
    if success then
        notifyHost("Result: " .. tostring(result))
    else
        notifyHost("✗ Invalid expression")
    end
end)

-- ============================================================================
-- FINAL INITIALIZATION
-- ============================================================================

task.wait(1)
if scriptRunning and not _G.ChatBotKillFlag then
    notifyHost("Bot initialized! Say !cmds to show a list of commands")
end
