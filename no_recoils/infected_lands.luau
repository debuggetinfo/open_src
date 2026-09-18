for _, Gc in getgc() do
    if typeof(Gc) == "function" and debug.info(Gc, "s"):find("ViewmodelController") then
        local Up_Values = debug.getupvalues(Gc)
        if #Up_Values == 7 then
            if typeof(Up_Values[3]) == "boolean" then
                local Old; Old = hookfunction(Gc, function(...)
                    return
                end)
            end
        end
    end
end
