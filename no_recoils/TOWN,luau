--use adonis bypass
local Tween_Service = game:GetService("TweenService")
local Namecall; Namecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Method = getnamecallmethod()
    if Self == Tween_Service then
        if Method == "Create" then
            if debug.traceback():find("GunScript") then
                if not debug.traceback():find("moveBolt") then
                    local Func = debug.info(3, "f")
                    local Up_Values = debug.getupvalues(Func)
                    if #Up_Values == 6 then
                        local Old; Old = hookfunction(Func, function(...)
                            return
                        end)
                    end
                end
            end
        end
    end
    return Namecall(Self, ...)
end)
