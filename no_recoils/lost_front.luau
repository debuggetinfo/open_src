for _, Gc in getgc() do
    if typeof(Gc) == "function" and debug.info(Gc, "n") == "fire" then
        local Old; Old = hookfunction(Gc, function(...)
            local Arguments = {...}
            if Arguments[1] and Arguments[1].data and Arguments[1].data.recoil then
                setreadonly(Arguments[1].data, false)
                Arguments[1].data.recoil = 0
                setreadonly(Arguments[1].data, true)
            end
            if Arguments[1] and Arguments[1].characterAnimations and Arguments[1].characterAnimations.recoil then
                Arguments[1].characterAnimations.recoil = nil
            end
            return Old(unpack(Arguments))
        end)
    end
end
