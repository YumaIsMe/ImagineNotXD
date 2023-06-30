-- Variables
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local V3 = Vector3.new
local FPP = fireproximityprompt
local LootSpawns = game:GetService("Workspace").SpawnsLoot
local TweenService = game:GetService("TweenService")

local Teleporting = false

local function TPTo(Position)
    print("TPTo called.")

    if typeof(Position) == "Instance" then
        Position = Position.CFrame
    end

    if typeof(Position) == "Vector3" then
        Position = CFrame.new(Position)
    end

    if typeof(Position) ~= "CFrame" then
        warn("[!] Invalid Argument Passed to TP()")
    else
        LocalPlayer.Character:PivotTo(Position + Vector3.new(0, 3, 0))
        return 0
    end
end

local function CheckLoot(Model)
    for i, v in pairs(Model:GetChildren()) do
        if v.Name == "Spring" and v.Transparency == 0 then
            return "Spring", v
        elseif v.Name == "Gear" and v.Transparency == 0 then
            return "Gear", v
        elseif v.Name == "Blade" and v.Transparency == 0 then
            return "Blade", v
        end
    end
    return false, nil
end

local function GetLoot()
    local LootT = {}

    for _, LootSpawn in pairs(LootSpawns:GetChildren()) do
        local Loot, Model = CheckLoot(LootSpawn)
        if Loot then
            table.insert(LootT, { Loot, Model })
        end
    end

    return LootT
end

local function Count(Name, Model)
    local count = 0
    for _, v in pairs(Model:GetChildren()) do
        if v.Name == Name then
            count = count + 1
        end
    end
    return count
end

getgenv().GrabItems = function(Springs, Blades, Gears)
    local YLevel = -54
    local OP = Character.HumanoidRootPart.CFrame

    repeat
        wait(1)

        local LootTBL = GetLoot()
        for _, v in pairs(LootTBL) do
            if v[1] == "Spring" and Count("Spring", LocalPlayer.Backpack) < Springs and Springs > 0 then
                wait(TPTo(CFrame.new(Vector3.new(OP.Position.X, YLevel, OP.Position.Z))))
                wait(TPTo(CFrame.new(Vector3.new(v[2].Position.X, YLevel, v[2].Position.Z))))
                wait(TPTo(v[2].CFrame))
                wait(0.5) -- Adjusted delay for pickup

                FPP(v[2].Parent.Part.Attachment.ProximityPrompt, 1)
            elseif v[1] == "Blade" and Count("Blade", LocalPlayer.Backpack) < Blades and Blades > 0 then
                wait(TPTo(CFrame.new(Vector3.new(OP.Position.X, YLevel, OP.Position.Z))))
                wait(TPTo(CFrame.new(Vector3.new(v[2].Position.X, YLevel, v[2].Position.Z))))
                wait(TPTo(v[2].CFrame))
                wait(0.5) -- Adjusted delay for pickup

                FPP(v[2].Parent.Part.Attachment.ProximityPrompt, 1)
            elseif v[1] == "Gear" and Count("Gear", LocalPlayer.Backpack) < Gears and Gears > 0 then
                wait(TPTo(CFrame.new(Vector3.new(OP.Position.X, YLevel, OP.Position.Z))))
                wait(TPTo(CFrame.new(Vector3.new(v[2].Position.X, YLevel, v[2].Position.Z))))
                wait(TPTo(v[2].CFrame))
                wait(0.5) -- Adjusted delay for pickup

                FPP(v[2].Parent.Part.Attachment.ProximityPrompt, 1)
            end
        end

        TPTo(Vector3.new(145, 30, -162))
        OP = Character.HumanoidRootPart.CFrame
    until Count("Gear", LocalPlayer.Backpack) >= Gears and Count("Blade", LocalPlayer.Backpack) >= Blades and Count("Spring", LocalPlayer.Backpack) >= Springs

    wait(TPTo(OP))
end
