-- holding 

```
Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SKR-Hub-t/Sakura-ui/refs/heads/main/Sakura.luau"))()

Window = Library.new({
    title = "Vanish Lite",
    PrimaryColor = Color3.fromRGB(255, 143, 188)
})

AutoparryTab = Window:create_tab("Combat", "rbxassetid://10734975692")
MiscTab = Window:create_tab("Misc", "rbxassetid://10709782497")

local cloneref = cloneref or function(o) return o end

UserInputService = cloneref(game:GetService("UserInputService"))
ContentProvider = cloneref(game:GetService("ContentProvider"))
TweenService = cloneref(game:GetService("TweenService"))
HttpService = cloneref(game:GetService("HttpService"))
TextService = cloneref(game:GetService("TextService"))
RunService = cloneref(game:GetService("RunService"))
Lighting = cloneref(game:GetService("Lighting"))
Players = cloneref(game:GetService("Players"))
CoreGui = cloneref(game:GetService("CoreGui"))
Debris = cloneref(game:GetService("Debris"))
ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
Stats = cloneref(game:GetService("Stats"))
Workspace = workspace
LocalPlayer = Players.LocalPlayer
Mouse = LocalPlayer and LocalPlayer:GetMouse()

if not LocalPlayer or not LocalPlayer.Character then
    if LocalPlayer then LocalPlayer.CharacterAdded:Wait() end
end
Alive = workspace:FindFirstChild("Alive") or workspace:WaitForChild("Alive")
Runtime = workspace.Runtime

System = {
    __properties = {
        __autoparry_enabled = false,
        __auto_spam_enabled = false,
        __auto_spam_distance_multiplier = 1,
        __curve_mode = 1,
        __accuracy = 1,
        __divisor_multiplier = 1.1,
        __parried = false,
        __training_parried = false,
        __spam_threshold = 1.5,
        __parries = 0,
        __parry_key = nil,
        __grab_animation = nil,
        __tornado_time = tick(),
        __first_parry_done = false,
        __last_self_fire_time = 0,
        __connections = {},
        __reverted_remotes = {},
        __randomized_accuracy_enabled = false,
        __is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
        __mobile_guis = {},
        __block_primed = false,
    },
    __config = {
        __curve_names = {'Camera', 'Random', 'Accelerated', 'Backwards', 'Slow', 'High', 'RandomTarget', 'Left', 'Right'},
        __detections = {

        }
    },

}
revertedRemotes = {}
Parry_Key = nil
PF = nil
SC = nil

hook = hookfunction or (getgenv and getgenv().hookfunction)
assert(hook, "This executor is not supported, please use a paid executor for the best experience.")
HASH = "5455ef47-de02-4074-808c-8d82c2cd12ec"

local byte, char = string.byte, string.char
local floor, bxor = math.floor, bit32.bxor

captured = {}
votes = {}
local key

local function timestamp()
    return tostring(floor(Workspace:GetServerTimeNow() * 100))
end

local function learn(token, stamp)
    if #token ~= #stamp then return false end
    for i = 1, #token do
        local value = bxor(byte(token, i), (byte(stamp, i) + i) % 256)
        local counts = votes[i] or {}
        votes[i] = counts
        counts[value] = (counts[value] or 0) + 1
    end
    local nextKey = {}
    for i = 1, #token do
        local best, highest = 0, -1
        for value, count in pairs(votes[i]) do
            if count > highest then
                best, highest = value, count
            end
        end
        nextKey[i] = best
    end
    key = nextKey
    return true
end

local function makeToken()
    if not key then return end
    local stamp = timestamp()
    local token = {}
    for i = 1, #stamp do
        local value = key[i] or key[#key]
        if not value then return end
        token[i] = char(bxor((byte(stamp, i) + i) % 256, value))
    end
    return table.concat(token)
end

local function getTail()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local points = {}
    local alive = Workspace:FindFirstChild("Alive")
    if alive then
        for _, character in ipairs(alive:GetChildren()) do
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                points[character.Name] = camera:WorldToScreenPoint(root.Position)
            end
        end
    end
    local mouse = UserInputService:GetMouseLocation()
    return captured.timing or 0.5, camera.CFrame, points,
        { mouse.X, mouse.Y }, captured.tailBool or false
end

local fire

local function replay(curveCFrame, screenPositions, mouseLocation)
    local token = makeToken()
    if not captured.remote or not captured.sessionKey or not token then
        return false
    end
    local timing, camera, points, mouse, tail = getTail()
    if not timing then
        return false
    end
    fire(captured.remote, HASH, captured.sessionKey, token,
        timing, curveCFrame or camera, screenPositions or points, mouseLocation or mouse, tail)
    return true
end

fire = hook(Instance.new("RemoteEvent").FireServer, function(self, ...)
    local args = table.pack(...)
    if args[1] ~= HASH or type(args[3]) ~= "string" then
        return fire(self, ...)
    end
    captured = {
        remote = self,
        sessionKey = args[2],
        token = args[3],
        timing = args[4],
        tailBool = args[8],
        args = args,
    }
    learn(args[3], timestamp())
    return fire(self, ...)
end)

local function fireParry_wh()
    if captured.sessionKey == nil or key == nil then return false end
    local cam = workspace.CurrentCamera
    local char = LocalPlayer.Character
    if not char then return false end
    local curveCF = System.curve.get_cframe()
    local screens = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok then screens[tostring(entity)] = sp end
            end
        end
    end
    local vp = cam.ViewportSize
    return replay(curveCF or cam.CFrame, screens, {vp.X/2, vp.Y/2}) == true
end

if ReplicatedStorage:FindFirstChild("Controllers") then
    for _, child in ipairs(ReplicatedStorage.Controllers:GetChildren()) do
        if child.Name:match("^SwordsController%s*$") then
            SC = child
        end
    end
end

local function update_divisor()
    System.__properties.__divisor_multiplier = 0.7 + (System.__properties.__accuracy - 1) * 0.0035353535353535
end

local function update_randomized_accuracy()
    if not System.__properties.__randomized_accuracy_enabled then return end
    local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(ping_str:match("%d+")) or 0
    local new_accuracy
    if ping >= 90 then
        new_accuracy = 4
    elseif ping <= 50 then
        new_accuracy = math.random(70, 100)
    else
        new_accuracy = System.__properties.__accuracy
    end
    if new_accuracy then
        System.__properties.__accuracy = new_accuracy
        update_divisor()
    end
end

task.spawn(function()
    while task.wait(1) do
        if System.__properties.__randomized_accuracy_enabled then
            pcall(update_randomized_accuracy)
        end
    end
end)

local DualBypassSystem = {
    __properties = {
        __captured_data = nil,
        __first_parry_done = false,
        __test_bypass_enabled = true,
        __use_virtual_input_once = true,
        __virtual_input_used = false,
        __original_metatables = {},
        __active_hooks = {}
    }
}

function DualBypassSystem.isValidRemoteArgs(args)
    return #args == 7 and
        type(args[2]) == "string" and
        type(args[3]) == "number" and
        typeof(args[4]) == "CFrame" and
        type(args[5]) == "table" and
        type(args[6]) == "table" and
        type(args[7]) == "boolean"
end

function DualBypassSystem.hookRemote(remote)
    if not getrawmetatable or not setreadonly then return end
    local ok, meta = pcall(getrawmetatable, remote)
    if not ok or not meta then return end
    if DualBypassSystem.__properties.__original_metatables[meta] then return end
    DualBypassSystem.__properties.__original_metatables[meta] = true
    pcall(function()
        setreadonly(meta, false)
        local oldIndex = meta.__index
        meta.__index = function(self, key)
            if (key == "FireServer" and self:IsA("RemoteEvent")) or
               (key == "InvokeServer" and self:IsA("RemoteFunction")) then
                return function(obj, ...)
                    local args = {...}
                    if DualBypassSystem.isValidRemoteArgs(args) and not DualBypassSystem.__properties.__captured_data then
                        DualBypassSystem.__properties.__captured_data = {
                            remote = obj,
                            args = args
                        }
                    end
                    if DualBypassSystem.isValidRemoteArgs(args) and not revertedRemotes[obj] then
                        revertedRemotes[obj] = args
                        Parry_Key = args[2]
                    end
                    if obj:IsA("RemoteEvent") then
                        return fire(obj, unpack(args))
                    end
                    return oldIndex(self, key)(obj, unpack(args))
                end
            end
            return oldIndex(self, key)
        end
        setreadonly(meta, true)
    end)
end

for _, remote in pairs(ReplicatedStorage:GetChildren()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        DualBypassSystem.hookRemote(remote)
    end
end

ReplicatedStorage.ChildAdded:Connect(function(child)
    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
        DualBypassSystem.hookRemote(child)
    end
end)

System.animation = {}
function System.animation.play_grab_parry() end

System.ball = {}

function System.ball.get()
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return nil end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then
            ball.CanCollide = false
            return ball
        end
    end
    return nil
end

function System.ball.get_all()
    local t = {}
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return t end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then
            ball.CanCollide = false
            table.insert(t, ball)
        end
    end
    return t
end

System.player = {}
local Closest_Entity = nil

function System.player.get_closest()
    local max_distance = math.huge
    local closest_entity = nil
    if not Alive then return nil end
    for _, entity in pairs(Alive:GetChildren()) do
        if entity ~= LocalPlayer.Character and entity.PrimaryPart then
            local distance = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
            if distance < max_distance then
                max_distance = distance
                closest_entity = entity
            end
        end
    end
    Closest_Entity = closest_entity
    return closest_entity
end

function System.player.get_closest_to_cursor()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then return nil end
    local closest_player = nil
    local minimal_dot = -math.huge
    local camera = workspace.CurrentCamera
    if not Alive then return nil end
    local success, mouse_location = pcall(function() return UserInputService:GetMouseLocation() end)
    if not success then return nil end
    local ray = camera:ScreenPointToRay(mouse_location.X, mouse_location.Y)
    local pointer = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
    for _, player in pairs(Alive:GetChildren()) do
        if player == LocalPlayer.Character or not player:FindFirstChild('HumanoidRootPart') then continue end
        local direction = (player.HumanoidRootPart.Position - camera.CFrame.Position).Unit
        local dot = pointer.LookVector:Dot(direction)
        if dot > minimal_dot then
            minimal_dot = dot
            closest_player = player
        end
    end
    return closest_player
end

System.curve = {}

function System.curve.get_cframe()
    local camera = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not root then return camera.CFrame end
    local targetPart
    local closest = System.player.get_closest_to_cursor()
    if closest and closest:FindFirstChild('HumanoidRootPart') then
        targetPart = closest.HumanoidRootPart
    end
    local target_pos = targetPart and targetPart.Position or (root.Position + camera.CFrame.LookVector * 100)
    local curve_functions = {
        function() return camera.CFrame end,
        function()
            local direction = (target_pos - root.Position).Unit
            local random_offset
            local attempts = 0
            repeat
                random_offset = Vector3.new(
                    math.random(-4000, 4000),
                    math.random(-4000, 4000),
                    math.random(-4000, 4000)
                )
                local curve_direction = (target_pos + random_offset - root.Position).Unit
                local dot = direction:Dot(curve_direction)
                attempts = attempts + 1
            until dot < 0.95 or attempts > 10
            return CFrame.new(root.Position, target_pos + random_offset)
        end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, 5, 0)) end,
        function()
            local direction = (root.Position - target_pos).Unit
            local backwards_pos = root.Position + direction * 10000 + Vector3.new(0, 1000, 0)
            return CFrame.new(camera.CFrame.Position, backwards_pos)
        end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, -9e18, 0)) end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, 9e18, 0)) end,
        function()
            local candidates = {}
            if Alive then
                for _, pl in pairs(Alive:GetChildren()) do
                    if pl ~= LocalPlayer.Character and pl.PrimaryPart then
                        table.insert(candidates, pl)
                    end
                end
            end
            if #candidates > 0 then
                local choice = candidates[math.random(1, #candidates)]
                return CFrame.new(root.Position, choice.PrimaryPart.Position)
            end
            return camera.CFrame
        end,
        function()
            local left_vec = -camera.CFrame.RightVector * 10000
            return CFrame.new(root.Position, root.Position + left_vec)
        end,
        function()
            local right_vec = camera.CFrame.RightVector * 10000
            return CFrame.new(root.Position, root.Position + right_vec)
        end
    }
    local fn = curve_functions[System.__properties.__curve_mode] or curve_functions[1]
    return fn()
end

System.parry = {}

local function fire_block()
    pcall(function()
        for _, connection in pairs(getconnections(LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
            connection:Fire()
        end
    end)
end

local function fire_reverted(curve_cframe, event_data, final_aim_target)
    local sent = false
    for remote, original_args in pairs(revertedRemotes) do
        pcall(function()
            local modified_args = {
                original_args[1],
                original_args[2],
                original_args[3],
                curve_cframe,
                event_data,
                final_aim_target,
                original_args[7]
            }
            if remote:IsA('RemoteEvent') then
                remote:FireServer(unpack(modified_args))
            elseif remote:IsA('RemoteFunction') then
                remote:InvokeServer(unpack(modified_args))
            end
            sent = true
        end)
    end
    return sent
end

function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then
        return
    end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local success, mouse = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if not success then return end
    local vec2_mouse = {mouse.X, mouse.Y}
    local is_mobile = System.__properties.__is_mobile
    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local success2, screen_point = pcall(function()
                    return camera:WorldToScreenPoint(entity.PrimaryPart.Position)
                end)
                if success2 then
                    event_data[entity.Name] = screen_point
                end
            end
        end
    end
    local curve_cframe = System.curve.get_cframe()
    if not System.__properties.__first_parry_done or not key or not captured.sessionKey then
        fire_block()
        System.__properties.__first_parry_done = true
        if not key or not captured.sessionKey then
            return
        end
    end
    local final_aim_target
    if is_mobile then
        local viewport = camera.ViewportSize
        final_aim_target = {viewport.X / 2, viewport.Y / 2}
    else
        final_aim_target = vec2_mouse
    end
    local fired = fireParry_wh()
    if not fired then
        fired = fire_reverted(curve_cframe, event_data, final_aim_target)
    end
    if not fired then
        fire_block()
    end
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries = System.__properties.__parries + 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then
            System.__properties.__parries = System.__properties.__parries - 1
        end
    end)
end

function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then
        return
    end
    if PF then pcall(PF) end
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries = System.__properties.__parries + 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then
            System.__properties.__parries = System.__properties.__parries - 1
        end
    end)
end

function System.parry.execute_action()
    System.animation.play_grab_parry()
    System.parry.execute()
end

local function linear_predict(a, b, t)
    return a + (b - a) * t
end

System.detection = {
    __ball_properties = {
        __aerodynamic_time = tick(),
        __last_warping = tick(),
        __lerp_radians = 0,
        __curving = tick()
    }
}

function System.detection.is_curved()
    local bp = System.detection.__ball_properties
    local ball = System.ball.get()
    if not ball then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local zoomies = ball:FindFirstChild('zoomies')
    if not zoomies then return false end
    local velocity = zoomies.VectorVelocity or Vector3.new()
    local speed = velocity.Magnitude
    if speed == 0 then return false end
    local ball_direction = velocity.Unit
    local direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball.Position
    if direction_vector.Magnitude == 0 then return false end
    local direction = direction_vector.Unit
    local dot = direction:Dot(ball_direction)
    local speed_threshold = math.min(speed / 100, 40)
    local direction_difference = ball_direction - velocity
    local direction_similarity = 0
    if direction_difference.Magnitude > 0 then
        direction_similarity = direction:Dot(direction_difference.Unit)
    end
    local dot_difference = dot - direction_similarity
    local distance = direction_vector.Magnitude
    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
    local dot_threshold = 0.5 - (ping / 1000)
    local reach_time = distance / speed - (ping / 1000)
    local ball_distance_threshold = 15 - math.min(distance / 1000, 15) + speed_threshold
    local clamped_dot = math.clamp(dot, -1, 1)
    local radians = math.rad(math.asin(clamped_dot))
    bp.__lerp_radians = linear_predict(bp.__lerp_radians, radians, 0.8)
    if speed > 0 and reach_time > ping / 10 then
        ball_distance_threshold = math.max(ball_distance_threshold - 15, 15)
    end
    if distance < ball_distance_threshold then return false end
    if dot_difference < dot_threshold then return true end
    if bp.__lerp_radians < 0.018 then
        bp.__last_warping = tick()
    end
    if (tick() - bp.__last_warping) < (reach_time / 1.5) then return true end
    if (tick() - bp.__curving) < (reach_time / 1.5) then return true end
    return dot < dot_threshold
end

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root.Parent and root.Parent ~= LocalPlayer.Character then
        if not Alive or root.Parent.Parent ~= Alive then
            return
        end
    end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return
    end
    local closest = System.player.get_closest()
    local ball = System.ball.get()
    if not ball or not closest or not closest.PrimaryPart then return end
    local target_distance = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Magnitude
    local direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball.Position
    if direction_vector.Magnitude == 0 then return end
    local distance = direction_vector.Magnitude
    local direction = direction_vector.Unit
    local ball_velocity = ball.AssemblyLinearVelocity or Vector3.new()
    if ball_velocity.Magnitude == 0 then return end
    local dot = direction:Dot(ball_velocity.Unit)
    local curve_detected = System.detection.is_curved()
    if target_distance < 15 and distance < 15 and dot > -0.25 then
        if curve_detected then
            System.parry.execute_action()
        end
    end
    if System.__properties.__grab_animation then
        System.__properties.__grab_animation:Stop()
    end
end)

local PlrForc = false
local SlashOfFuryActive = false

local function clearSlashOfFuryState() SlashOfFuryActive = false end
local function isSlashOfFuryBlocking() return getgenv().SlashOfFuryDetection == true and SlashOfFuryActive end
local function isSingularityBlocking()
    if not getgenv().SingularityDetection then return false end
    local char = LocalPlayer.Character
    local root = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
    return root ~= nil and root:FindFirstChild("SingularityCape") ~= nil
end
local function isCombatBlocked()
    if getgenv().DetectionsEnabled == false then return false end
    if PlrForc then return true end
    if isSlashOfFuryBlocking() then return true end
    if isSingularityBlocking() then return true end
    if getgenv().PulsedDetection and LocalPlayer.Character and LocalPlayer.Character:GetAttribute('Pulsed') then return true end
    return false
end

local function setupAbilityDetections()
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 30)
        local hotbar = playerGui and playerGui:WaitForChild("Hotbar", 30)
        local ability = hotbar and hotbar:WaitForChild("Ability", 30)
        local duration = ability and ability:FindFirstChild("Duration")
        local fill = duration and duration:FindFirstChild("Fill")
        local infinityCD = fill and fill:FindFirstChildOfClass("UIGradient")
        if infinityCD then
            infinityCD:GetPropertyChangedSignal("Offset"):Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    local abilities = char and char:FindFirstChild("Abilities")
                    if not abilities then return end
                    if abilities:FindFirstChild("Forcefield") and abilities["Forcefield"].Enabled and getgenv().ForcefieldDetection then
                        PlrForc = true
                    elseif abilities:FindFirstChild("Time Hole") and abilities["Time Hole"].Enabled and getgenv().TimeHoleDetection then
                        PlrForc = true
                    elseif abilities:FindFirstChild("Death Slash") and abilities["Death Slash"].Enabled and getgenv().DeathSlashDetection then
                        PlrForc = true
                    elseif abilities:FindFirstChild("Infinity") and abilities["Infinity"].Enabled and getgenv().InfinityDetection then
                        PlrForc = true
                    else
                        PlrForc = false
                    end
                    if infinityCD.Offset.Y >= 0.985 then PlrForc = false end
                end)
            end)
        end
        local ballsFolder = workspace:FindFirstChild("Balls") or workspace:WaitForChild("Balls", 120)
        if ballsFolder then
            ballsFolder.ChildRemoved:Connect(function() PlrForc = false end)
        end
    end)
end

local function watchSlashOfFuryBallFolder(folder)
    if not folder then return end
    folder.ChildAdded:Connect(function(ball)
        task.wait()
        if not ball then return end
        local function onComboCounter(counter)
            if not getgenv().SlashOfFuryDetection or counter.Name ~= "ComboCounter" then return end
            SlashOfFuryActive = true
            counter.AncestryChanged:Connect(function(_, parent)
                if not parent then clearSlashOfFuryState() end
            end)
        end
        ball.ChildAdded:Connect(onComboCounter)
        for _, child in ipairs(ball:GetChildren()) do onComboCounter(child) end
        ball.AncestryChanged:Connect(function(_, parent)
            if not parent then clearSlashOfFuryState() end
        end)
    end)
end

local function setupSlashOfFuryDetection()
    task.spawn(function()
        local ballsFolder = workspace:FindFirstChild("Balls") or workspace:WaitForChild("Balls", 120)
        local trainingFolder = workspace:FindFirstChild("TrainingBalls") or workspace:WaitForChild("TrainingBalls", 30)
        watchSlashOfFuryBallFolder(ballsFolder)
        watchSlashOfFuryBallFolder(trainingFolder)
    end)
end

local function hookSingularityCape(root)
    root.ChildAdded:Connect(function(child)
        if child.Name == "SingularityCape" then end
    end)
end

local function setupSingularityDetection()
    local function onCharacter(char)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if root then hookSingularityCape(root) end
    end
    if LocalPlayer.Character then onCharacter(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(onCharacter)
end

setupAbilityDetections()
setupSlashOfFuryDetection()
setupSingularityDetection()

getgenv().InfinityDetection = false
getgenv().ForcefieldDetection = false
getgenv().DeathSlashDetection = false
getgenv().TimeHoleDetection = false
getgenv().SlashOfFuryDetection = false
getgenv().SingularityDetection = false
getgenv().PulsedDetection = false
getgenv().CooldownProtection = false
getgenv().AutoAbility = false
getgenv().AutoSpamAnimationFix = false
getgenv().AutoStop = false
getgenv().AutoParryMode = "Remote"
getgenv().AutoSpamMode = "Remote"
getgenv().AntiHellHook = false
getgenv().AntiPhantom = false
getgenv().AntiPulse = false

System.auto_spam = {}

function System.auto_spam:get_entity_properties()
    System.player.get_closest()
    if not Closest_Entity or not Closest_Entity.PrimaryPart then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local entity_velocity = Closest_Entity.PrimaryPart.Velocity
    local entity_direction = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local entity_distance = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    return {
        Velocity = entity_velocity,
        Direction = entity_direction,
        Distance = entity_distance
    }
end

function System.auto_spam:get_ball_properties()
    local ball = System.ball.get()
    if not ball then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local ball_velocity = ball.AssemblyLinearVelocity or Vector3.new()
    local ball_origin = ball
    local ball_direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball_origin.Position
    local ball_distance = ball_direction_vector.Magnitude
    local ball_direction = Vector3.new()
    local ball_dot = 0
    if ball_distance > 0 then
        ball_direction = ball_direction_vector.Unit
        if ball_velocity.Magnitude > 0 then
            ball_dot = ball_direction:Dot(ball_velocity.Unit)
        end
    end
    return {
        Velocity = ball_velocity,
        Direction = ball_direction,
        Distance = ball_distance,
        Dot = ball_dot
    }
end

function System.auto_spam.spam_service(self)
    local ball = System.ball.get()
    local entity = System.player.get_closest()
    if not ball or not entity or not entity.PrimaryPart then
        return false
    end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return false
    end

    local D = 5

    local velocity = ball.AssemblyLinearVelocity or Vector3.new()
    local n = velocity.Magnitude
    if n == 0 then
        return D
    end

    local to_ball = (LocalPlayer.Character.PrimaryPart.Position - ball.Position)
    if to_ball.Magnitude == 0 then
        return D
    end

    local r = to_ball.Unit
    local t = 0
    if n > 0 and velocity.Magnitude > 0 then
        t = r:Dot(velocity.Unit)
    end

    local target_pos = entity.PrimaryPart.Position
    local X = LocalPlayer:DistanceFromCharacter(target_pos)

    local E = 1
    local Fmove = Vector3.new()
    local success, humanoid = pcall(function()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
    end)
    if success and humanoid and humanoid.MoveDirection then
        Fmove = humanoid.MoveDirection
    end

    local N = (target_pos - LocalPlayer.Character.PrimaryPart.Position)
    if N.Magnitude > 0 then N = N.Unit else N = Vector3.new() end
    local lmove = Vector3.new()
    if entity then
        local ehum = entity:FindFirstChildOfClass('Humanoid')
        if ehum and ehum.MoveDirection then lmove = ehum.MoveDirection end
    end

    _G.Last_Close_Contact = _G.Last_Close_Contact or 0
    _G.In_Close_Contact = _G.In_Close_Contact or false
    local now = tick()
    if X <= 3 then
        _G.In_Close_Contact = true
    end
    if _G.In_Close_Contact and X > 3.3 then
        _G.In_Close_Contact = false
        _G.Last_Close_Contact = now
    end
    local u = (not _G.In_Close_Contact) and (now - (_G.Last_Close_Contact or 0) >= 1.5)
    if u and (Fmove.Magnitude > 0.2 and Fmove:Dot(N) < -0.4) then
        E = 10
    end
    if u and (lmove.Magnitude > 0.2 and lmove:Dot(-N) < -0.4) then
        E = 10
    end

    local B = (self.Ping or 50) * 0.7 + math.min(n / (E * 1.2), 80)

    if (self.Entity_Properties and self.Entity_Properties.Distance or math.huge) > B then
        return D
    end
    if (self.Ball_Properties and self.Ball_Properties.Distance or math.huge) > B then
        return D
    end
    if X > B then
        return D
    end

    local U = math.clamp(-t, 0, 1)
    local q = math.clamp(U * (n / 40), 0, 4)
    D = B - q
    return D
end

function System.auto_spam.start()
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
    end
    System.__properties.__auto_spam_enabled = true
    System.__properties.__connections.__auto_spam = RunService.PreSimulation:Connect(function()
        if not System.__properties.__auto_spam_enabled then return end
        if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
        local ball = System.ball.get()
        if not ball then return end
        local zoomies = ball:FindFirstChild('zoomies')
        if not zoomies then return end
        local entity = System.player.get_closest()
        if not entity or not entity.PrimaryPart then return end
        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
        local ping_threshold = math.clamp(ping / 10, 1, 16)
        local ball_target = ball:GetAttribute('target')
        local ball_properties = System.auto_spam:get_ball_properties()
        local entity_properties = System.auto_spam:get_entity_properties()
        if not ball_properties or not entity_properties then return end
        local spam_accuracy = System.auto_spam.spam_service({
            Ball_Properties = ball_properties,
            Entity_Properties = entity_properties,
            Ping = ping_threshold
        })
        if type(spam_accuracy) ~= "number" then return end
        local target_position = entity.PrimaryPart.Position
        local target_distance = LocalPlayer:DistanceFromCharacter(target_position)
        local ball_velocity = zoomies.VectorVelocity
        if ball_velocity.Magnitude == 0 then return end
        local distance = LocalPlayer:DistanceFromCharacter(ball.Position)
        if not ball_target then return end
        local effective_range = spam_accuracy * System.__properties.__auto_spam_distance_multiplier
        if target_distance > effective_range or distance > effective_range then return end
        local pulsed = LocalPlayer.Character:GetAttribute('Pulsed')
        if pulsed then return end
        if ball_target == LocalPlayer.Name and target_distance > 30 and distance > 30 then return end
        if distance <= effective_range and System.__properties.__parries > System.__properties.__spam_threshold then
            if getgenv().AutoSpamMode == "Keypress" then
                if PF then pcall(PF) end
            else
                System.parry.execute()
                if getgenv().AutoSpamAnimationFix and PF then
                    pcall(PF)
                end
            end
        end
    end)
end

function System.auto_spam.stop()
    System.__properties.__auto_spam_enabled = false
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
        System.__properties.__connections.__auto_spam = nil
    end
end

System.autoparry = {}

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end
    System.__properties.__connections.__autoparry = RunService.PreSimulation:Connect(function()
        if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or
           not LocalPlayer.Character.PrimaryPart then
            return
        end
        local balls = System.ball.get_all()
        local one_ball = System.ball.get()
        local training_ball = nil
        if workspace:FindFirstChild("TrainingBalls") then
            for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
                if Instance:GetAttribute("realBall") then
                    training_ball = Instance
                    break
                end
            end
        end
        for _, ball in pairs(balls) do
            if getgenv().BallVelocityAbove800 then return end
            if not ball then continue end
            local zoomies = ball:FindFirstChild('zoomies')
            if not zoomies then continue end
            ball:GetAttributeChangedSignal('target'):Once(function()
                System.__properties.__parried = false
            end)
            if System.__properties.__parried then continue end
            local ball_target = ball:GetAttribute('target')
            local velocity = zoomies.VectorVelocity
            local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local ping_threshold = math.clamp(ping / 10, 5, 17)
            local speed = velocity.Magnitude
            local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
            local speed_divisor = (2.4 + capped_speed_diff * 0.002) * System.__properties.__divisor_multiplier
            local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
            local curved = System.detection.is_curved()
            if ball:FindFirstChild('AeroDynamicSlashVFX') then
                ball.AeroDynamicSlashVFX:Destroy()
                System.__properties.__tornado_time = tick()
            end
            if Runtime:FindFirstChild('Tornado') then
                if (tick() - System.__properties.__tornado_time) <
                   (Runtime.Tornado:GetAttribute('TornadoTime') or 1) + 0.314159 then
                    continue
                end
            end
            if one_ball and one_ball:GetAttribute('target') == LocalPlayer.Name and curved then
                continue
            end
            if ball:FindFirstChild('ComboCounter') then continue end
            if LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then continue end

            if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                if getgenv().CooldownProtection then
                    local ParryCD = LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
                    if ParryCD.Offset.Y < 0.4 then
                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                        continue
                    end
                end
                if getgenv().AutoAbility then
                    local AbilityCD = LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                    if AbilityCD.Offset.Y == 0.5 then
                        if LocalPlayer.Character.Abilities:FindFirstChild("Raging Deflection") and LocalPlayer.Character.Abilities["Raging Deflection"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Rapture") and LocalPlayer.Character.Abilities["Rapture"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Calming Deflection") and LocalPlayer.Character.Abilities["Calming Deflection"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Aerodynamic Slash") and LocalPlayer.Character.Abilities["Aerodynamic Slash"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Fracture") and LocalPlayer.Character.Abilities["Fracture"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Death Slash") and LocalPlayer.Character.Abilities["Death Slash"].Enabled then
                            System.__properties.__parried = true
                            ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                            task.wait(2.432)
                            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                            continue
                        end
                    end
                end
            end
            if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                if getgenv().AutoParryMode == "Keypress" then
                    System.parry.keypress()
                else
                    System.parry.execute_action()
                end
                System.__properties.__parried = true
            end
            local last_parrys = tick()
            repeat
                RunService.Stepped:Wait()
            until (tick() - last_parrys) >= 1 or not System.__properties.__parried
            System.__properties.__parried = false
        end
        if training_ball then
            local zoomies = training_ball:FindFirstChild('zoomies')
            if zoomies then
                training_ball:GetAttributeChangedSignal('target'):Once(function()
                    System.__properties.__training_parried = false
                end)
                if not System.__properties.__training_parried then
                    local ball_target = training_ball:GetAttribute('target')
                    local velocity = zoomies.VectorVelocity
                    local distance = LocalPlayer:DistanceFromCharacter(training_ball.Position)
                    local speed = velocity.Magnitude
                    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
                    local ping_threshold = math.clamp(ping / 10, 5, 17)
                    local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
                    local speed_divisor = (2.4 + capped_speed_diff * 0.002) * System.__properties.__divisor_multiplier
                    local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
                    if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                        if getgenv().AutoParryMode == "Keypress" then
                            System.parry.keypress()
                        else
                            System.parry.execute_action()
                        end
                        System.__properties.__training_parried = true
                        local last_parrys = tick()
                        repeat
                            RunService.Stepped:Wait()
                        until (tick() - last_parrys) >= 1 or not System.__properties.__training_parried
                        System.__properties.__training_parried = false
                    end
                end
            end
        end
    end)
end

function System.autoparry.stop()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
        System.__properties.__connections.__autoparry = nil
    end
end

System.protections = {
    __phantomConn = nil,
    __hellHookHeartbeat = nil,
    __hellHookConns = {},
    __pulseConn = nil,
}

function System.protections.fireAbilityButton()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local abilityPress = remotes and remotes:FindFirstChild("AbilityButtonPress")
    if abilityPress then
        pcall(function() abilityPress:Fire() end)
        return true
    end
    return false
end

function System.protections.startAntiPhantom()
    if System.protections.__phantomConn then return end
    task.spawn(function()
        local runtimeFolder = workspace:FindFirstChild("Runtime") or workspace:WaitForChild("Runtime", 120)
        if not runtimeFolder or not getgenv().AntiPhantom then return end
        Runtime = runtimeFolder
        System.protections.__phantomConn = runtimeFolder.ChildAdded:Connect(function(Object)
            if not getgenv().AntiPhantom then return end
            if Object.Name == "maxTransmission" or Object.Name == "transmissionpart" then
                local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
                if Weld then
                    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    if Character and Weld.Part1 == Character.HumanoidRootPart then
                        local currentBall = System.ball.get()
                        Weld:Destroy()
                        if currentBall then
                            local FocusConnection
                            FocusConnection = RunService.RenderStepped:Connect(function()
                                local Highlighted = currentBall:GetAttribute("highlighted")
                                if Highlighted == true then
                                    System.protections.fireAbilityButton()
                                elseif Highlighted == false then
                                    FocusConnection:Disconnect()
                                end
                            end)
                            task.delay(3, function()
                                if FocusConnection and FocusConnection.Connected then
                                    FocusConnection:Disconnect()
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end)
end

function System.protections.stopAntiPhantom()
    if System.protections.__phantomConn then
        System.protections.__phantomConn:Disconnect()
        System.protections.__phantomConn = nil
    end
end

function System.protections.stopAntiHellHookHeartbeat()
    if System.protections.__hellHookHeartbeat then
        System.protections.__hellHookHeartbeat:Disconnect()
        System.protections.__hellHookHeartbeat = nil
    end
end

function System.protections.stopAntiHellHook()
    System.protections.stopAntiHellHookHeartbeat()
    for _, conn in ipairs(System.protections.__hellHookConns) do
        pcall(function() conn:Disconnect() end)
    end
    System.protections.__hellHookConns = {}
end

function System.protections.startAntiHellHook()
    if #System.protections.__hellHookConns > 0 then return end
    task.spawn(function()
        if not getgenv().AntiHellHook then return end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 60)
        if not remotes or not getgenv().AntiHellHook then return end
        local hookedRemote = remotes:FindFirstChild("PlrHellHooked") or remotes:WaitForChild("PlrHellHooked", 30)
        local completedRemote = remotes:FindFirstChild("PlrHellHookCompleted") or remotes:WaitForChild("PlrHellHookCompleted", 30)
        if hookedRemote and getgenv().AntiHellHook then
            table.insert(System.protections.__hellHookConns, hookedRemote.OnClientEvent:Connect(function(_, victim)
                if not getgenv().AntiHellHook then return end
                if not victim or victim.Name ~= LocalPlayer.Name then return end
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local savedCFrame = root.CFrame
                System.protections.stopAntiHellHookHeartbeat()
                System.protections.__hellHookHeartbeat = RunService.Heartbeat:Connect(function()
                    if not getgenv().AntiHellHook then return end
                    local liveChar = LocalPlayer.Character
                    local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = savedCFrame end
                end)
            end))
        end
        if completedRemote and getgenv().AntiHellHook then
            table.insert(System.protections.__hellHookConns, completedRemote.OnClientEvent:Connect(function()
                task.delay(1, System.protections.stopAntiHellHookHeartbeat)
            end))
        end
    end)
end

function System.protections.stopAntiPulse()
    if System.protections.__pulseConn then
        System.protections.__pulseConn:Disconnect()
        System.protections.__pulseConn = nil
    end
end

function System.protections.startAntiPulse()
    if System.protections.__pulseConn then return end
    System.protections.__pulseConn = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiPulse then return end
        local char = LocalPlayer.Character
        if char and char:GetAttribute("Pulsed") then
            pcall(function() char:SetAttribute("Pulsed", false) end)
        end
    end)
end

function System.protections.setAntiPhantom(value)
    getgenv().AntiPhantom = value == true
    if getgenv().AntiPhantom then
        System.protections.startAntiPhantom()
    else
        System.protections.stopAntiPhantom()
    end
end

function System.protections.setAntiHellHook(value)
    getgenv().AntiHellHook = value == true
    if getgenv().AntiHellHook then
        System.protections.startAntiHellHook()
    else
        System.protections.stopAntiHellHook()
    end
end

function System.protections.setAntiPulse(value)
    getgenv().AntiPulse = value == true
    if getgenv().AntiPulse then
        System.protections.startAntiPulse()
    else
        System.protections.stopAntiPulse()
    end
end

local function create_mobile_button(name, position_y, color)
    local gui = Instance.new('ScreenGui')
    gui.Name = 'Sigma' .. name .. 'Mobile'
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local button = Instance.new('TextButton')
    button.Size = UDim2.new(0, 140, 0, 50)
    button.Position = UDim2.new(0.5, -70, position_y, 0)
    button.BackgroundTransparency = 1
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Draggable = true
    button.AutoButtonColor = false
    button.ZIndex = 2

    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bg.Parent = button

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg

    local stroke = Instance.new('UIStroke')
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = bg

    local text = Instance.new('TextLabel')
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.ZIndex = 3
    text.Parent = button

    button.Parent = gui
    gui.Parent = CoreGui

    return {gui = gui, button = button, text = text, bg = bg}
end

local function destroy_mobile_gui(gui_data)
    if gui_data and gui_data.gui then gui_data.gui:Destroy() end
end

autoparry_module = AutoparryTab:create_module({
    title = "Auto Parry",
    description = "Automatically parries incoming balls",
    flag = "AutoParryModule",
    section = "left",
    callback = function(state)
        if System then
            System.__properties.__autoparry_enabled = state
            if state then
                if System.autoparry and System.autoparry.start then pcall(System.autoparry.start) end
                if System.__properties.__is_mobile and not System.__properties.__mobile_guis.autoparry then
                    local success, autoparry_mobile = pcall(function()
                        return create_mobile_button('AutoParry', 0.6, Color3.fromRGB(100, 180, 255))
                    end)
                    if success and autoparry_mobile then
                        System.__properties.__mobile_guis.autoparry = autoparry_mobile
                        local touch_start = 0
                        local was_dragged = false
                        autoparry_mobile.button.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                touch_start = tick()
                                was_dragged = false
                            end
                        end)
                        autoparry_mobile.button.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                if (tick() - touch_start) > 0.1 then was_dragged = true end
                            end
                        end)
                        autoparry_mobile.button.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch and not was_dragged then
                                if System then
                                    System.__properties.__autoparry_enabled = not System.__properties.__autoparry_enabled
                                    if System.autoparry and System.autoparry.start and System.autoparry.stop then
                                        if System.__properties.__autoparry_enabled then
                                            pcall(System.autoparry.start)
                                        else
                                            pcall(System.autoparry.stop)
                                        end
                                    end
                                end
                                if System and System.__properties and System.__properties.__autoparry_enabled then
                                    autoparry_mobile.text.Text = "ON"
                                    autoparry_mobile.text.TextColor3 = Color3.fromRGB(100, 180, 255)
                                else
                                    autoparry_mobile.text.Text = "AutoParry"
                                    autoparry_mobile.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        end)
                    end
                end
            else
                if System.autoparry and System.autoparry.stop then pcall(System.autoparry.stop) end
                if System.__properties.__mobile_guis.autoparry then
                    destroy_mobile_gui(System.__properties.__mobile_guis.autoparry)
                    System.__properties.__mobile_guis.autoparry = nil
                end
            end
        end
    end
})


autoparry_module:create_dropdown({
    title = "Parry Mode",
    flag = "ParryMode",
    options = {"Remote", "Keypress"},
    maximum_options = 10,
    callback = function(value)
        getgenv().AutoParryMode = value
    end
})


mode_curve_dropdown = autoparry_module:create_dropdown({
    title = "Mode curve",
    flag = "ModeCurve",
    options = (System and System.__config and System.__config.__curve_names) or {"Camera", "Random", "Accelerated", "Backwards", "Slow", "High"},
    maximum_options = 10,
    callback = function(value)
        if System and System.__config and System.__config.__curve_names then
            for i, name in ipairs(System.__config.__curve_names) do
                if name == value then
                    System.__properties.__curve_mode = i
                    break
                end
            end
        end
    end
})


autoparry_module:create_slider({
    title = "Parry Accuracy",
    flag = "ParryAccuracy",
    maximum_value = 100,
    minimum_value = 1,
    value = 100,
    round_number = true,
    callback = function(value)
        if System then
            System.__properties.__accuracy = value
            if update_divisor then pcall(update_divisor) end
        end
    end
})

autoparry_module:create_checkbox({
    title = "Randomize Accuracy",
    flag = "RandomizeAccuracy",
    callback = function(value)
        if System then
            System.__properties.__randomized_accuracy_enabled = value
            if value and update_randomized_accuracy then pcall(update_randomized_accuracy) end
        end
    end
})

autoparry_module:create_divider({})

autoparry_module:create_checkbox({
    title = "Cooldown Protection",
    flag = "CooldownProtection",
    callback = function(value) getgenv().CooldownProtection = value end
})

autoparry_module:create_checkbox({
    title = "Auto Ability",
    flag = "AutoAbility",
    callback = function(value) getgenv().AutoAbility = value end
})

detections_module = AutoparryTab:create_module({
    title = "Ability Detections",
    description = "Skip parry during abilities",
    flag = "DetectionsModule",
    section = "left",
    callback = function(state)
        getgenv().DetectionsEnabled = state == true
        if not state then
            PlrForc = false
            SlashOfFuryActive = false
        end
    end
})

detections_module:create_checkbox({
    title = "Infinity",
    flag = "InfinityDetection",
    callback = function(value) getgenv().InfinityDetection = value == true end
})

detections_module:create_checkbox({
    title = "Singularity",
    flag = "SingularityDetection",
    callback = function(value) getgenv().SingularityDetection = value == true end
})

detections_module:create_checkbox({
    title = "Slash of Fury",
    flag = "SlashOfFuryDetection",
    callback = function(value)
        getgenv().SlashOfFuryDetection = value == true
        if not value then SlashOfFuryActive = false end
    end
})

detections_module:create_checkbox({
    title = "Forcefield",
    flag = "ForcefieldDetection",
    callback = function(value) getgenv().ForcefieldDetection = value == true end
})

detections_module:create_checkbox({
    title = "Time Hole",
    flag = "TimeHoleDetection",
    callback = function(value) getgenv().TimeHoleDetection = value == true end
})

detections_module:create_checkbox({
    title = "Death Slash",
    flag = "DeathSlashDetection",
    callback = function(value) getgenv().DeathSlashDetection = value == true end
})

protections_module = AutoparryTab:create_module({
    title = "Anti Abilities",
    description = "These abilities will no longer effect you",
    flag = "ProtectionsModule",
    section = "right",
    callback = function(state)
        getgenv().ProtectionsEnabled = state == true
        if not state and System and System.protections then
            System.protections.setAntiHellHook(false)
            System.protections.setAntiPhantom(false)
            System.protections.setAntiPulse(false)
        end
    end
})

protections_module:create_checkbox({
    title = "Anti HellHook",
    flag = "AntiHellHookToggle",
    callback = function(value)
        if System and System.protections then System.protections.setAntiHellHook(value) end
    end
})

protections_module:create_checkbox({
    title = "Anti Phantom",
    flag = "AntiPhantomToggle",
    callback = function(value)
        if System and System.protections then System.protections.setAntiPhantom(value) end
    end
})

protections_module:create_checkbox({
    title = "Anti Pulse",
    flag = "AntiPulseToggle",
    callback = function(value)
        if System and System.protections then System.protections.setAntiPulse(value) end
    end
})

auto_spam_module = AutoparryTab:create_module({
    title = "Auto Clash",
    description = "Automatically spams ball",
    flag = "AutoSpamModule",
    section = "right",
    callback = function(state)
        if System and System.auto_spam then
            System.__properties.__auto_spam_enabled = state
            if state then
                if System.auto_spam and System.auto_spam.start then pcall(System.auto_spam.start) end
            else
                if System.auto_spam and System.auto_spam.stop then pcall(System.auto_spam.stop) end
            end
        end
    end
})

auto_spam_module:create_slider({
    title = "Spam Threshold",
    flag = "ParryThreshold",
    maximum_value = 10,
    minimum_value = 0,
    value = 2.5,
    round_number = true,
    callback = function(value)
        if System then System.__properties.__spam_threshold = value end
    end
})

auto_spam_module:create_slider({
    title = "Distance Multiplier",
    flag = "DistanceMultiplier",
    maximum_value = 3.0,
    minimum_value = 0.3,
    value = 0.3,
    round_number = true,
    callback = function(value)
        if System then System.__properties.__auto_spam_distance_multiplier = value end
    end
})

getgenv().HideDeadESP = false
getgenv().ShowPlatformESP = false

local ability_esp
do
    ability_esp = {
        active = false,
        labels = {},
        conns = {},
        nameTagState = {},
    }
    local PINK_A = Color3.fromRGB(255, 210, 230)
    local PINK_B = Color3.fromRGB(255, 105, 180)
    local DARK_BLUE_A = Color3.fromRGB(90, 150, 230)
    local DARK_BLUE_B = Color3.fromRGB(20, 55, 130)
    local GRAY_A = Color3.fromRGB(200, 200, 200)
    local GRAY_B = Color3.fromRGB(130, 130, 130)

    local function getPlayerPlatform(p)
        local platform = "PC"
        pcall(function()
            local osPlatform
            pcall(function() osPlatform = p.OsPlatform end)
            if not osPlatform and gethiddenproperty then
                pcall(function() osPlatform = gethiddenproperty(p, "OsPlatform") end)
            end
            if osPlatform then
                local enumName
                pcall(function() enumName = osPlatform.Name end)
                local str = enumName and tostring(enumName) or tostring(osPlatform)
                if str:find("Android") or str:find("IOS") or str:find("iOS") then
                    platform = "Mobile"
                elseif str:find("XBox") or str:find("Xbox") or str:find("PS4") or str:find("PS5") or str:find("PlayStation") or str:find("Console") then
                    platform = "Console"
                end
            end
        end)
        return platform
    end

    local function hideDefaultNameTag(player, char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if ability_esp.nameTagState[player] == nil then ability_esp.nameTagState[player] = hum.DisplayDistanceType end
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.NameDisplayDistance = 0
        hum.HealthDisplayDistance = 0
    end

    local function restoreDefaultNameTag(player, char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local original = ability_esp.nameTagState[player]
        if hum and original ~= nil then hum.DisplayDistanceType = original end
        ability_esp.nameTagState[player] = nil
    end

    local function restoreAllDefaultNameTags()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                restoreDefaultNameTag(player, player.Character)
            end
        end
        ability_esp.nameTagState = {}
    end

    local function addTextGradient(label, c1, c2)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
        g.Rotation = 0
        g.Parent = label
        return g
    end

    local function makeEsp(player)
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        hideDefaultNameTag(player, char)
        local old = head:FindFirstChild("AbilityESPGui")
        if old then old:Destroy() end
        local bg = Instance.new("BillboardGui")
        bg.Name = "AbilityESPGui"
        bg.Size = UDim2.new(0, 260, 0, 28)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = head
        bg.Parent = head
        local row = Instance.new("Frame")
        row.Size = UDim2.fromScale(1, 1)
        row.BackgroundTransparency = 1
        row.Parent = bg
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 2)
        layout.Parent = row

        local function makeAbPart(text, order, c1, c2, prnt)
            local lbl = Instance.new("TextLabel")
            lbl.AutomaticSize = Enum.AutomaticSize.X
            lbl.Size = UDim2.new(0, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.TextColor3 = Color3.new(1, 1, 1)
            lbl.TextStrokeTransparency = 0.45
            lbl.Text = text
            lbl.LayoutOrder = order
            lbl.Parent = prnt
            if c1 and c2 then addTextGradient(lbl, c1, c2) end
            return lbl
        end

        local platformWrap = Instance.new("Frame")
        platformWrap.Name = "Platform"
        platformWrap.AutomaticSize = Enum.AutomaticSize.X
        platformWrap.Size = UDim2.new(0, 0, 1, 0)
        platformWrap.BackgroundTransparency = 1
        platformWrap.LayoutOrder = 0
        platformWrap.Visible = false
        platformWrap.Parent = row
        local platLayout = Instance.new("UIListLayout")
        platLayout.FillDirection = Enum.FillDirection.Horizontal
        platLayout.SortOrder = Enum.SortOrder.LayoutOrder
        platLayout.Parent = platformWrap

        makeAbPart("[", 1, GRAY_A, GRAY_B, platformWrap)
        local platName = makeAbPart(getPlayerPlatform(player), 2, GRAY_A, GRAY_B, platformWrap)
        makeAbPart("] ", 3, GRAY_A, GRAY_B, platformWrap)

        local nameLbl = makeAbPart(player.DisplayName, 1, PINK_A, PINK_B, row)

        local abWrap = Instance.new("Frame")
        abWrap.Name = "Ability"
        abWrap.AutomaticSize = Enum.AutomaticSize.X
        abWrap.Size = UDim2.new(0, 0, 1, 0)
        abWrap.BackgroundTransparency = 1
        abWrap.LayoutOrder = 2
        abWrap.Visible = false
        abWrap.Parent = row
        local abLayout = Instance.new("UIListLayout")
        abLayout.FillDirection = Enum.FillDirection.Horizontal
        abLayout.SortOrder = Enum.SortOrder.LayoutOrder
        abLayout.Parent = abWrap

        makeAbPart(" [", 1, PINK_A, PINK_B, abWrap)
        local abName = makeAbPart("", 2, DARK_BLUE_A, DARK_BLUE_B, abWrap)
        makeAbPart("]", 3, PINK_A, PINK_B, abWrap)
        ability_esp.labels[player] = { gui = bg, name = nameLbl, abilityWrap = abWrap, abilityName = abName, platformWrap = platformWrap, platName = platName, player = player }
    end

    local function refreshEsp()
        for player, data in pairs(ability_esp.labels) do
            local char = player.Character
            if player.Parent and char then hideDefaultNameTag(player, char) end
            if player.Parent and data and data.name and data.name.Parent then
                data.name.Text = player.DisplayName
                if data.platName and data.platName.Parent then
                    data.platName.Text = getPlayerPlatform(player)
                end
                local ab = player:GetAttribute("EquippedAbility")
                if ab and ab ~= "" then
                    data.abilityName.Text = tostring(ab)
                    data.abilityWrap.Visible = true
                else
                    data.abilityName.Text = ""
                    data.abilityWrap.Visible = false
                end
                data.platformWrap.Visible = getgenv().ShowPlatformESP and true or false
            end
        end
    end

    function ability_esp.start()
        if ability_esp.active then return end
        ability_esp.active = true
        getgenv().AbilityESP = true
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                ability_esp.conns[p] = p.CharacterAdded:Connect(function()
                    task.wait(0.2)
                    if ability_esp.active then makeEsp(p) end
                end)
                if p.Character then makeEsp(p) end
            end
        end
        ability_esp.added = Players.PlayerAdded:Connect(function(p)
            if p == LocalPlayer or not ability_esp.active then return end
            ability_esp.conns[p] = p.CharacterAdded:Connect(function()
                task.wait(0.2)
                if ability_esp.active then makeEsp(p) end
            end)
            if p.Character then makeEsp(p) end
        end)
        task.spawn(function()
            while ability_esp.active do
                refreshEsp()
                task.wait(0.5)
            end
        end)
    end

    function ability_esp.stop()
        ability_esp.active = false
        getgenv().AbilityESP = false
        if ability_esp.added then
            ability_esp.added:Disconnect()
            ability_esp.added = nil
        end
        for p, c in pairs(ability_esp.conns) do c:Disconnect(); ability_esp.conns[p] = nil end
        for p, data in pairs(ability_esp.labels) do
            if data and data.gui then data.gui:Destroy() end
            ability_esp.labels[p] = nil
        end
        restoreAllDefaultNameTags()
    end
end

local noRenderConn
local noRenderFXLoopRunning = false

local function setClientFXEnabled(enabled)
    pcall(function()
        local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
        if not playerScripts then return end
        local effectScripts = playerScripts:FindFirstChild("EffectScripts")
        if not effectScripts then return end
        local clientFX = effectScripts:FindFirstChild("ClientFX")
        if clientFX then clientFX.Disabled = not enabled end
    end)
end

local function stopNoRenderRuntime()
    if noRenderConn then
        noRenderConn:Disconnect()
        noRenderConn = nil
    end
end

local function bindNoRenderRuntime()
    stopNoRenderRuntime()
    task.spawn(function()
        local runtime = workspace:FindFirstChild("Runtime") or workspace:WaitForChild("Runtime", 60)
        if not runtime or not getgenv().NoRender then return end
        for _, child in ipairs(runtime:GetChildren()) do
            pcall(function() Debris:AddItem(child, 0) end)
        end
        noRenderConn = runtime.ChildAdded:Connect(function(value)
            if getgenv().NoRender then
                pcall(function() Debris:AddItem(value, 0) end)
            end
        end)
    end)
end

local function startNoRenderFXLoop()
    if noRenderFXLoopRunning then return end
    noRenderFXLoopRunning = true
    task.spawn(function()
        while getgenv().NoRender do
            setClientFXEnabled(false)
            task.wait(0.25)
        end
        noRenderFXLoopRunning = false
    end)
end

local function setNoRender(on)
    getgenv().NoRender = on == true
    if getgenv().NoRender then
        setClientFXEnabled(false)
        bindNoRenderRuntime()
        startNoRenderFXLoop()
    else
        stopNoRenderRuntime()
        setClientFXEnabled(true)
        task.defer(function() setClientFXEnabled(true) end)
    end
end

local Byte_Library = {}

function Byte_Library.Korblox(char)
    if not char then return end
    local leg = char:FindFirstChild("Right Leg")
    if not leg then return end
    if not leg:FindFirstChild("KorbloxMesh") then
        for _, v in leg:GetChildren() do if v:IsA("SpecialMesh") then v:Destroy() end end
        local m = Instance.new("SpecialMesh")
        m.Name = "KorbloxMesh"
        m.MeshId = "rbxassetid://902942096"
        m.TextureId = "rbxassetid://902843398"
        m.Offset = Vector3.new(0, 0.7, 0)
        m.Parent = leg
    end
end

function Byte_Library.Restore_Leg(char)
    if not char then return end
    local leg = char:FindFirstChild("Right Leg")
    if not leg then return end
    for _, v in leg:GetChildren() do if v:IsA("SpecialMesh") then v:Destroy() end end
end

function Byte_Library.Headless(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 1
    for _, child in head:GetChildren() do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 1
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            if not child:GetAttribute("OriginalScale") then
                child:SetAttribute("OriginalScale", child.Scale)
                child.Scale = Vector3.new(0, 0, 0)
            end
        end
    end
end

function Byte_Library.Restore_Head(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 0
    for _, child in head:GetChildren() do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 0
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            local orig = child:GetAttribute("OriginalScale")
            if orig then
                child.Scale = orig
                child:SetAttribute("OriginalScale", nil)
            end
        end
    end
end

local headlessKorblox_conn = nil
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if getgenv().HeadlessKorbloxEnabled then
        Byte_Library.Headless(char)
        Byte_Library.Korblox(char)
    end
end)

headless_module = MiscTab:create_module({
    title = "Cosmetics",
    description = "Apply Headless and Korblox",
    flag = "HeadlessKorbloxModule",
    section = "left",
    callback = function(state)
        getgenv().HeadlessKorbloxEnabled = state
        local char = LocalPlayer.Character
        if char then
            if state then
                pcall(function() Byte_Library.Headless(char); Byte_Library.Korblox(char) end)
            else
                pcall(function() Byte_Library.Restore_Head(char); Byte_Library.Restore_Leg(char) end)
            end
        end
        if state then
            if not headlessKorblox_conn then
                headlessKorblox_conn = LocalPlayer.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if getgenv().HeadlessKorbloxEnabled then
                        pcall(function() Byte_Library.Headless(char); Byte_Library.Korblox(char) end)
                    end
                end)
            end
        else
            if headlessKorblox_conn then
                headlessKorblox_conn:Disconnect()
                headlessKorblox_conn = nil
            end
        end
    end
})

ability_esp_module = MiscTab:create_module({
    title = "Ability ESP",
    description = "Displays equipped abilities over players",
    flag = "AbilityESPModule",
    section = "left",
    callback = function(state)
        if state then ability_esp.start() else ability_esp.stop() end
    end
})

ability_esp_module:create_checkbox({
    title = "Show Platform",
    flag = "ShowPlatformESP",
    callback = function(state) getgenv().ShowPlatformESP = state end
})

local no_render_module = MiscTab:create_module({
    title = "No Render",
    description = "Disables rendering of effects",
    flag = "NoRenderModule",
    section = "right",
    callback = function(state) setNoRender(state) end
})

if System and System.__properties then
    System.__properties.__reverted_remotes = revertedRemotes
end

getgenv().skinChangerEnabled = false
getgenv().swordModel = ""
getgenv().swordAnimations = ""
getgenv().swordFX = ""
getgenv().slashName = "SlashEffect"
getgenv()._realEquippedSword = "Default"

local swordInstances2

local function getSwordInstances()
    if swordInstances2 then return swordInstances2 end
    local ok, mod = pcall(function()
        return require(
            ReplicatedStorage:WaitForChild("Shared", 15)
                :WaitForChild("ReplicatedInstances", 15)
                :WaitForChild("Swords", 15)
        )
    end)
    if ok then swordInstances2 = mod end
    return swordInstances2
end

local swordsController
task.spawn(function()
    while task.wait() and not swordsController do
        local ok, conns = pcall(getconnections, ReplicatedStorage.Remotes.FireSwordInfo.OnClientEvent)
        if ok and conns then
            for _, v in ipairs(conns) do
                if v.Function and islclosure and islclosure(v.Function) then
                    local ok2, upvalues = pcall(getupvalues, v.Function)
                    if ok2 and #upvalues == 1 and type(upvalues[1]) == "table" then
                        swordsController = upvalues[1]
                        break
                    end
                end
            end
        end
    end
end)

local function getSlashName(swordName)
    local instances = getSwordInstances()
    if not instances then return "SlashEffect" end
    local ok, s = pcall(function() return instances:GetSword(swordName) end)
    return (ok and s and s.SlashName) or "SlashEffect"
end

local function refreshSlashName()
    local fx = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
    getgenv().slashName = fx ~= "" and getSlashName(fx) or "SlashEffect"
end

local function getRealEquippedSword()
    local attr = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
    local custom = getgenv().swordModel
    if type(attr) == "string" and attr ~= "" and attr ~= custom then return attr end
    if type(getgenv()._realEquippedSword) == "string" and getgenv()._realEquippedSword ~= "" then return getgenv()._realEquippedSword end
    return "Default"
end

local function cacheRealSword()
    if getgenv().skinChangerEnabled then return end
    local real = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
    if type(real) == "string" and real ~= "" then getgenv()._realEquippedSword = real end
end

local function equipSwordOnCharacter(swordName)
    if not LocalPlayer.Character or type(swordName) ~= "string" or swordName == "" then return end
    local instances = getSwordInstances()
    if not instances then return end
    pcall(function()
        local f = rawget(instances, "EquipSwordTo")
        if type(f) == "function" and getupvalues and setupvalue then
            for i, v in ipairs(getupvalues(f)) do
                if type(v) == "boolean" then setupvalue(f, i, false); break end
            end
        end
        instances:EquipSwordTo(LocalPlayer.Character, swordName)
    end)
end

local function applyControllerSword(name)
    task.spawn(function()
        local att = 0
        while not swordsController and att < 20 do task.wait(0.5); att = att + 1 end
        if not swordsController then return end
        pcall(function()
            if swordsController.SetSword then swordsController:SetSword(name) end
            if ReplicatedStorage.Remotes:FindFirstChild("FireSwordInfo") then
                ReplicatedStorage.Remotes.FireSwordInfo:FireServer(name)
            end
            if swordsController.currentSword ~= nil then swordsController.currentSword = name end
            if swordsController.SwordFX ~= nil then swordsController.SwordFX = name end
            if swordsController.swordAnimations ~= nil then swordsController.swordAnimations = name end
            if swordsController.SwordAnimations ~= nil then swordsController.SwordAnimations = name end
        end)
    end)
end

local function removeCustomSwordModel(keepName)
    local custom = getgenv().swordModel
    local char = LocalPlayer.Character
    if not char or type(custom) ~= "string" or custom == "" then return end
    if keepName and custom == keepName then return end
    pcall(function()
        local model = char:FindFirstChild(custom)
        if model then model:Destroy() end
    end)
end

local function setCustomSword()
    if not getgenv().skinChangerEnabled or not LocalPlayer.Character then return end
    local name = getgenv().swordModel
    if name == "" then return end
    cacheRealSword()
    refreshSlashName()
    equipSwordOnCharacter(name)
    applyControllerSword(name)
end

local function equipBaseSword()
    local char = LocalPlayer.Character
    if not char then return end
    local base = getRealEquippedSword()
    getgenv().slashName = getSlashName(base)
    equipSwordOnCharacter(base)
    applyControllerSword(base)
    task.wait(0.15)
    removeCustomSwordModel(base)
    if not char:FindFirstChild(base) then
        equipSwordOnCharacter(base)
        applyControllerSword(base)
    end
end

getgenv().updateSword = function()
    if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" then
        setCustomSword()
    else
        equipBaseSword()
    end
end

LocalPlayer:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function() cacheRealSword() end)
task.defer(cacheRealSword)

local hookedFuncs = {}
task.spawn(function()
    while task.wait(1) do
        if getconnections then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local parrySuccessAll = remotes and remotes:FindFirstChild("ParrySuccessAll")
            if parrySuccessAll then
                local ok, conns = pcall(getconnections, parrySuccessAll.OnClientEvent)
                if ok and type(conns) == "table" then
                    for _, v in ipairs(conns) do
                        local func = v.Function
                        if func and not hookedFuncs[func] then
                            if isourclosure and isourclosure(func) then
                                hookedFuncs[func] = true
                            else
                                hookedFuncs[func] = true
                                pcall(function() v:Disable() end)
                                local tf = func
                                local of
                                of = function(...)
                                    if getgenv().NoRender then
                                        pcall(tf, ...)
                                        return
                                    end
                                    local args = {...}
                                    if tostring(args[4]) == LocalPlayer.Name and getgenv().skinChangerEnabled then
                                        refreshSlashName()
                                        args[1] = getgenv().slashName
                                        args[3] = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                    end
                                    if setthreadidentity then pcall(setthreadidentity, 2) end
                                    pcall(tf, unpack(args))
                                end
                                hookedFuncs[of] = true
                                parrySuccessAll.OnClientEvent:Connect(of)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if char then
            if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" then
                if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel or not char:FindFirstChild(getgenv().swordModel) then
                    setCustomSword()
                end
                for _, v in char:GetChildren() do
                    if v:IsA("Model") and v.Name ~= getgenv().swordModel then
                        local base = getRealEquippedSword()
                        if v.Name ~= base then v:Destroy() end
                    end
                end
            else
                local base = getRealEquippedSword()
                local custom = getgenv().swordModel
                if custom ~= "" and custom ~= base and char:FindFirstChild(custom) then
                    removeCustomSwordModel(base)
                end
                if base ~= "" and not char:FindFirstChild(base) then
                    equipBaseSword()
                end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 10)
    task.wait(2)
    if not LocalPlayer.Character or LocalPlayer.Character ~= char then return end
    if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" then
        setCustomSword()
    else
        equipBaseSword()
    end
end)

local function applySwordNameInput(rawText)
    local name = tostring(rawText or ""):gsub("^%s+", ""):gsub("%s+$", "")
    getgenv().swordModel = name
    getgenv().swordAnimations = name
    getgenv().swordFX = name
    refreshSlashName()
    if getgenv().skinChangerEnabled and name ~= "" then getgenv().updateSword() end
    return name
end

local function setSkinChangerEnabled(enabled)
    if enabled then
        cacheRealSword()
        getgenv().skinChangerEnabled = true
        getgenv().updateSword()
    else
        local attr = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
        local custom = getgenv().swordModel
        if type(attr) == "string" and attr ~= "" and attr ~= custom then getgenv()._realEquippedSword = attr end
        getgenv().skinChangerEnabled = false
        equipBaseSword()
    end
end

skin_changer_module = MiscTab:create_module({
    title = "Skin Changer",
    description = "Changes your equipped sword",
    flag = "SkinChangerMod",
    section = "right",
    callback = function(state) setSkinChangerEnabled(state) end,
})

skin_changer_module:create_textbox({
    title = "Sword Model",
    flag = "SwordModelInput",
    default = "",
    callback = function(text) applySwordNameInput(text) end,
})

UserInputService.InputBegan:Connect(function(input, process)
    if process then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        if not Window then return end
        if Window._ui_open == nil then
            Window._ui_open = true
        end
        Window._ui_open = not Window._ui_open
        if Window.change_visiblity then
            pcall(function() Window:change_visiblity(Window._ui_open) end)
        elseif Window.change_visibility then
            pcall(function() Window:change_visibility(Window._ui_open) end)
        elseif Window.Toggle then
            pcall(function() Window:Toggle() end)
        elseif Window.toggle then
            pcall(function() Window:toggle() end)
        end
    end
end)

Window:load()

getgenv().SemiImmortalityEnabled = false
getgenv().SemiImmortalityConfig = {
    SpeedBypassEnabled = false,
    Angle = 72,
    Height = 8,
    Depth = -8,
    SquareRadius = 7,
}

local Immortality = {
    active = false,
    hookInstalled = false,
    heartbeatConn = nil,
    guardBound = false,
    speedFlagSet = false,
    desync = {},
}

local function immortalitySupported()
    return hookmetamethod and newcclosure and checkcaller
end

local function immortalityInstallHook()
    if Immortality.hookInstalled or not immortalitySupported() then return end
    Immortality.hookInstalled = true
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if checkcaller() or not Immortality.active then return oldIndex(self, key) end
        if key ~= "CFrame" then return oldIndex(self, key) end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return oldIndex(self, key) end
        if self == hrp then return Immortality.desync[1] or hrp.CFrame end
        local head = char:FindFirstChild("Head")
        if head and self == head then
            local base = Immortality.desync[1] or hrp.CFrame
            return base + Vector3.new(0, hrp.Size.Y / 2 + 0.5, 0)
        end
        return oldIndex(self, key)
    end))
end

local function isInActiveMatch()
    local alive = workspace:FindFirstChild("Alive")
    if not alive then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    if char:IsDescendantOf(alive) then return true end
    return alive:FindFirstChild(char.Name) == char
end

local function immortalityEnsureLoop()
    if Immortality.heartbeatConn then return end
    immortalityInstallHook()
    Immortality.heartbeatConn = RunService.Heartbeat:Connect(function()
        if not getgenv().SemiImmortalityEnabled then
            Immortality.active = false
            return
        end
        if not isInActiveMatch() or not immortalitySupported() then
            Immortality.active = false
            return
        end
        Immortality.active = true
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local cfg = getgenv().SemiImmortalityConfig
        if cfg.SpeedBypassEnabled and setfflag and not Immortality.speedFlagSet then
            Immortality.speedFlagSet = true
            pcall(function() setfflag("S2PhysicsSenderRate", "1333335") end)
        end
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.01, 0)
        Immortality.desync[1] = hrp.CFrame
        Immortality.desync[2] = hrp.AssemblyLinearVelocity
        local t = tick()
        local angle = t * math.pi * 2 * cfg.Angle / 5
        local cycle = math.floor(t * 29) % 2
        local yOffset = (cycle == 0) and cfg.Depth or cfg.Height
        local offset = Vector3.new(math.cos(angle) * cfg.SquareRadius, yOffset, math.sin(angle) * cfg.SquareRadius)
        hrp.CFrame = Immortality.desync[1] + offset
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        RunService.RenderStepped:Wait()
        hrp.CFrame = Immortality.desync[1]
        hrp.AssemblyLinearVelocity = Immortality.desync[2]
    end)
end

local function immortalityStop()
    Immortality.active = false
    Immortality.speedFlagSet = false
    if Immortality.heartbeatConn then
        Immortality.heartbeatConn:Disconnect()
        Immortality.heartbeatConn = nil
    end
end

local function immortalitySync()
    if getgenv().SemiImmortalityEnabled then
        immortalityEnsureLoop()
    else
        immortalityStop()
    end
end

local function immortalityWatchCharacter(char)
    if not char then return end
    char:GetPropertyChangedSignal("Parent"):Connect(function() immortalitySync() end)
    immortalitySync()
end

local function immortalityBindGuard()
    if Immortality.guardBound then return end
    Immortality.guardBound = true
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.defer(function()
            if LocalPlayer.Character == char then
                immortalityWatchCharacter(char)
            end
        end)
    end)
    if LocalPlayer.Character then
        immortalityWatchCharacter(LocalPlayer.Character)
    end
end

local function setSemiImmortalityEnabled(value)
    getgenv().SemiImmortalityEnabled = value == true
    immortalityBindGuard()
    immortalitySync()
end

semi_immortal_module = AutoparryTab:create_module({
    title = "Dysync Character",
    description = "Dysyncs your character from the server",
    flag = "ZX_SemiImmortalMod",
    section = "right",
    callback = function(state) setSemiImmortalityEnabled(state) end,
})

semi_immortal_module:create_checkbox({
    title = "Anti Limit",
    flag = "ZX_SemiImmortalSpeed",
    callback = function(value)
        getgenv().SemiImmortalityConfig.SpeedBypassEnabled = value
    end,
})

semi_immortal_module:create_slider({
    title = "Height",
    flag = "ZX_SemiImmortalHeight",
    minimum_value = 1,
    maximum_value = 75,
    value = getgenv().SemiImmortalityConfig.Height,
    round_number = true,
    callback = function(value) getgenv().SemiImmortalityConfig.Height = value end,
})

semi_immortal_module:create_slider({
    title = "Radius",
    flag = "ZX_SemiImmortalRadius",
    minimum_value = 1,
    maximum_value = 30,
    value = getgenv().SemiImmortalityConfig.SquareRadius,
    round_number = true,
    callback = function(value) getgenv().SemiImmortalityConfig.SquareRadius = value end,
})
```
i want you to fully rwetrie this lua scirpt with cureve mode working and all lgoic working with no note or AI JUNK use real lgoc 
