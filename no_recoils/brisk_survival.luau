local Os_Clock; Os_Clock = hookfunction(getrenv().os.clock, function(...)
    local Traceback = debug.traceback()
    if Traceback:find("addRecoilStep") then
        local Func = debug.info(3, "f")
        if Func then
            local Old; Old = hookfunction(Func, function(...)
                return
            end)
        end
    end
    return Os_Clock(...)
end)
