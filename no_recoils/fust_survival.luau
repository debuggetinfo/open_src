for _, Gc in getgc() do
    if typeof(Gc) == "function" then
        if debug.info(Gc, "n") == "recoilPattern" then
            hookfunction(Gc, function(...)
                return 0, 0
            end)
        end
        if debug.info(Gc, "n") == "yawPattern167" then
            hookfunction(Gc, function(...)
                return 0
            end)
        end
        if debug.info(Gc, "n") == "kick294" then
            hookfunction(Gc, function(...)
                return nil, nil
            end)
        end
    end
end
