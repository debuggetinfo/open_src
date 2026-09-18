for _, Gc in getgc() do
    if typeof(Gc) == "function" and debug.info(Gc, "n") == "Add" and debug.info(Gc, "s"):find("Recoil") then
		local Old; Old = hookfunction(Gc, function(...)
			local Arguments = {...}
			Arguments[4] = 0
			return Old(unpack(Arguments))
		end)
    end
end
