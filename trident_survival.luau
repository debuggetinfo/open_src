local Actor = getactors()[1]
-- coded in like 20 minutes, so its so so

run_on_actor(Actor, [[
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/secrethaxx/Library.lua"))()

local Classes = getrenv()._G.classes

local Entity_List = debug.getupvalue(Classes.EntityClient.GetEntityFromPart, 1)

local My_Camera = workspace.CurrentCamera

local getSkewedOrigin
for _, Gc in getgc() do
	if typeof(Gc) == "function" and debug.info(Gc, "n") == "getSkewedOrigin" then
		getSkewedOrigin = Gc
		break
	end
end

local Trident = {
	Silent_Aim = false,
	Use_Fov = false,
	Fov_Radius = 100,
	Use_Snapline = false,

	No_Recoil = false,
	No_Sway = false,
	No_Spread = false,
	No_Shoot_Restrictions = false,

	Hit_Sounds = false,
}

local Services = {
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	Players = game:GetService("Players"),
	RunService = game:GetService("RunService"),
	ScriptContext = game:GetService("ScriptContext"),
	LogService = game:GetService("LogService"),
	Lighting = game:GetService("Lighting"),
	UserInputService = game:GetService("UserInputService"),
	TweenService = game:GetService("TweenService"),
	MyPlayer = game:GetService("Players").LocalPlayer
}

local New_Drawing = function(Obj, Properties)
	local Object = Drawing.new(Obj)
	for Property, Value in pairs(Properties) do
		Object[Property] = Value
	end
	return Object
end

local New_Instance = function(Class, Properties)
	local Instance = Instance.new(Class)
	for Property, Value in pairs(Properties) do
		Instance[Property] = Value
	end
	return Instance
end

local Play_Sound = function(Id)
	local Sound = New_Instance("Sound", {
		SoundId = "rbxassetid://" .. Id,
		Volume = 1,
		PlayOnRemove = true,
		Parent = game:GetService("SoundService")
	})
	Sound:Destroy()
end

local Get_Target = function()
	local Closest, Closest_Distance = nil, Trident.Fov_Radius
	local Screen_Center = Vector2.new(My_Camera.ViewportSize.X / 2, My_Camera.ViewportSize.Y / 2)

	for _, Entity in Entity_List do
		local Model = rawget(Entity, "model")
		local Part = Model and Model:FindFirstChild("Head")

		if not Part then continue end
		if rawget(Entity, "type") ~= "Player" then continue end
		if rawget(Entity, "sleeping") then continue end

		local Screen_Position, On_Screen = My_Camera:WorldToScreenPoint(Part.Position)
		if not On_Screen then continue end

		local Distance = (Vector2.new(Screen_Position.X, Screen_Position.Y) - Screen_Center).Magnitude

		if Distance < Closest_Distance then
			Closest_Distance = Distance
			Closest = Entity
		end
	end

	return Closest
end

local Fov_Circle = New_Drawing("Circle", {
	Thickness = 1,
	Filled = false,
	Color = Color3.fromRGB(255, 255, 255),
	NumSides = 64,
	Transparency = 1
})

local Snapline = New_Drawing("Line", {
	Thickness = 1,
	Color = Color3.fromRGB(255, 255, 255),
	Transparency = 1
})

local Is_Grounded; Is_Grounded = hookfunction(Classes.Character.IsGrounded, newcclosure(function(...)
	if Trident.No_Shoot_Restrictions then
		return true
	end
	return Is_Grounded(...)
end))

local Is_Swimming; Is_Swimming = hookfunction(Classes.Character.IsSwimming, newcclosure(function(...)
	if Trident.No_Shoot_Restrictions then
		return false
	end
	return Is_Swimming(...)
end))

local Un_Equip_Item; Un_Equip_Item = hookfunction(Classes.FPS.UnEquipItem, newcclosure(function(...)
	local Traceback = debug.traceback()

	if Trident.No_Shoot_Restrictions then
		if Traceback:find("SetVehicle") or Traceback:find("updateCharacter") then
			return
		end
	end

	return Un_Equip_Item(...)
end))

local Get_Piloted_Vehicle; Get_Piloted_Vehicle = hookfunction(Classes.Character.GetPilotedVehicle, newcclosure(function(...)
	if Trident.No_Shoot_Restrictions then
		return nil
	end
	return Get_Piloted_Vehicle(...)
end))

local Play; Play = hookfunction(Classes.Sound.Play, newcclosure(function(Sound, ...)
	local Traceback = debug.traceback()

	if Trident.Hit_Sounds and (Traceback:find("MeleeClient") or Traceback:find("MiningDrillClient") or Traceback:find("RangedWeaponClient")) then
		if Sound == "Dink" or Sound == "PlayerHitHeadshot" or Sound == "PlayerHit2" then
			Play_Sound("198598793")
			return
		end
	end

	return Play(Sound, ...)
end))

local Recoil; Recoil = hookfunction(Classes.Camera.Recoil, newcclosure(function(...)
	if Trident.No_Recoil then
		return {
			cameraX = 0,
			rotSpeed = 0,
			rotMag = 0,
			returnTime = 0,
			push = 0,
			returnLerp = 0,
			cameraXShake = 0,
			cameraY = 0,
			lerp = 0
		}
	end

	return Recoil(...)
end))
local Set_Sway_Speed; Set_Sway_Speed = hookfunction(Classes.Camera.SetSwaySpeed, newcclosure(function(Sway, ...)
	if Trident.No_Sway then
		return Set_Sway_Speed(0, ...)
	end
	return Set_Sway_Speed(Sway, ...)
end))

local Get_Skewed_Origin; Get_Skewed_Origin = hookfunction(getSkewedOrigin, function(Base, Value)
	if Trident.No_Spread then
		return Base
	end
	return Get_Skewed_Origin(Base, Value)
end)

local Get_CFrame; Get_CFrame = hookfunction(Classes.Camera.GetCFrame, newcclosure(function(...)
	local Traceback = debug.traceback()

	if Trident.Silent_Aim and (Traceback:find("BowClient") or Traceback:find("RangedWeaponClient")) then
		local Target = Get_Target()

		if Target then
			local Model = rawget(Target, "model")
			local Head = Model and Model:FindFirstChild("Head")

			if Head then
				return CFrame.new(My_Camera.CFrame.Position, Head.Position)
			end
		end
	end

	return Get_CFrame(...)
end))

local Pre_Render = Services.RunService.RenderStepped:Connect(function()
	local Target = Trident.Silent_Aim and Get_Target()
	local Screen_Center = Vector2.new(My_Camera.ViewportSize.X / 2, My_Camera.ViewportSize.Y / 2)

	Fov_Circle.Visible = Trident.Use_Fov and Trident.Silent_Aim
	Fov_Circle.Radius = Trident.Fov_Radius
	Fov_Circle.Position = Screen_Center
	Fov_Circle.Transparency = 1

	local Model = Target and rawget(Target, "model")
	local Head = Model and Model:FindFirstChild("Head")

	Snapline.Visible = Trident.Use_Snapline and Trident.Silent_Aim and Head ~= nil

	if Head then
		local Position = My_Camera:WorldToViewportPoint(Head.Position)
		Snapline.From = Screen_Center
		Snapline.To = Vector2.new(Position.X, Position.Y)
	end

end)

local Window = Library:Window({
	Name = 'trident',
	Rank = "user"
}) do
	local Combat_Page = Window:Page({Name = "combat"})
	local Misc_Page = Window:Page({Name = "misc"})

	local Aimbot = Combat_Page:Section({Name = "aimbot", Side = 1})
	local Removals = Combat_Page:Section({Name = "removals", Side = 2})
	local Other = Misc_Page:Section({Name = "other", Side = 1})

	Aimbot:Toggle({Name = "silent aim", Flag = "silent_aim", Default = false, Callback = function(Value) Trident.Silent_Aim = Value end})
	Aimbot:Toggle({Name = "use fov", Flag = "use_fov", Default = false, Callback = function(Value) Trident.Use_Fov = Value end})
	Aimbot:Slider({Name = "fov radius", Flag = "fov_radius", Min = 10, Max = 500, Default = 100, Decimals = 1, Suffix = "px", Callback = function(Value) Trident.Fov_Radius = Value end})
	Aimbot:Toggle({Name = "snapline", Flag = "use_snapline", Default = false, Callback = function(Value) Trident.Use_Snapline = Value end})

	Removals:Toggle({Name = "no recoil", Flag = "no_recoil", Default = false, Callback = function(Value) Trident.No_Recoil = Value end})
	Removals:Toggle({Name = "no sway", Flag = "no_sway", Default = false, Callback = function(Value) Trident.No_Sway = Value end})
	Removals:Toggle({Name = "no spread", Flag = "no_spread", Default = false, Callback = function(Value) Trident.No_Spread = Value end})
	Removals:Toggle({Name = "no shoot restrictions", Flag = "no_shoot_restrictions", Default = false, Callback = function(Value) Trident.No_Shoot_Restrictions = Value end})

	Other:Toggle({Name = "hit sounds", Flag = "hit_sounds", Default = false, Callback = function(Value) Trident.Hit_Sounds = Value end})
end

Window:InitWindow()
]])
