local players = game.Players
local plr = players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()

plr.CharacterAdded:Connect(function(new)
    new.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then
            _G.firebullet = c:WaitForChild("UnrealEngine"):WaitForChild("FireAltBullet")
        end
    end)
end)

character.ChildAdded:Connect(function(c)
    if c:IsA("Tool") then
        _G.firebullet = c:WaitForChild("UnrealEngine"):WaitForChild("FireAltBullet")
    end
end)

local weapon = character and character:FindFirstChildWhichIsA("Tool")

_G.firebullet = weapon and weapon.UnrealEngine.FireAltBullet

local nc; nc = hookmetamethod(game, "__namecall", function(self, ...)
    local ncm = getnamecallmethod()
    
    if self == _G.firebullet and ncm == "FireServer" then
        local args = {...}
        
        coroutine.wrap(function()
            while true do wait() 
                for _, v in next, players.GetPlayers(players) do
                    if v.Team == plr.Team or v.Team.Name == "Observers" then continue end
                    
                    local enemy_head = v.Character and v.Character.FindFirstChild(v.Character, "Head")
                    if enemy_head then
                        args[9] = enemy_head
                        
                        _G.firebullet.FireServer(_G.firebullet, unpack(args))
                    end
                end
            end
        end)()

        return nc(self, unpack(args))
    end
    
    return nc(self, ...)
end)
