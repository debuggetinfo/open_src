for _, Gc in getgc() do
    if typeof(Gc) == "function" and islclosure(Gc) then
        local Up_Values = debug.getupvalues(Gc)
        if #Up_Values == 13 and typeof(Up_Values[1]) == "table" and debug.info(Gc, "s"):find("GunController") then
            local Old; Old = hookfunction(Gc, function(...)
                return
            end)
        end
    end
end
