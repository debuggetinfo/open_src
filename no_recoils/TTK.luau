for _, Gc in getgc() do
	if typeof(Gc) == "function" and debug.info(Gc, "n") == "GetAttachmentRecoilMult" then
		hookfunction(Gc, function(...)
			return 0 
		end)
	end
end
