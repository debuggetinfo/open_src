local CFrame_Angles; CFrame_Angles = hookfunction(CFrame.Angles, newcclosure(function(...)
    local Traceback = debug.traceback()
    if Traceback:find("Update") and (Traceback:find("ToolTemplate") or Traceback:find("GunTemplate")) then
        return CFrame.identity
    end
    return CFrame_Angles(...)
end))
