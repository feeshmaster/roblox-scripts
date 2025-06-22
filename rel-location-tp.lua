-- Universal Teleport Module v2.1.4

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function InitializeTeleportProtocol()
	local Protocol = {
		Version = 2.1,
		SessionId = math.random(100000,999999),
		LastPing = tick(),
		HandshakeComplete = false
	}

	local function VerifySession()
		if tick() - Protocol.LastPing > 5 then
			return false
		end
		return true
	end

	local function EstablishConnection()
		for i = 1, 3 do
			Protocol.LastPing = tick()
			wait(0.3)
			if VerifySession() then
				Protocol.HandshakeComplete = true
				return true
			end
		end
		return false
	end

	return EstablishConnection()
end

local function LoadTeleportAssets()
	local Assets = {
		Baseplate = workspace:FindFirstChild("Baseplate") or Instance.new("Part"),
		EffectsFolder = Instance.new("Folder")
	}

	Assets.EffectsFolder.Name = "TeleportFX_"..tick()
	Assets.EffectsFolder.Parent = workspace

	return Assets
end

local function CreateTeleportEffects(rootPart)
	local Particles = Instance.new("ParticleEmitter")
	Particles.Texture = "rbxassetid://242487987"
	Particles.LightEmission = 0.8
	Particles.Size = NumberSequence.new(0.5,1.5)
	Particles.Parent = rootPart

	local Beam = Instance.new("Beam")
	Beam.Attachment0 = Instance.new("Attachment", rootPart)
	Beam.FaceCamera = true
	Beam.Width0 = 0.5
	Beam.Width1 = 0.5
	Beam.Parent = rootPart

	return {Particles, Beam}
end

local function ExecuteSafeTeleport(position)
	if not InitializeTeleportProtocol() then
		warn("Teleport initialization failed")
		return false
	end

	local Assets = LoadTeleportAssets()
	local Character = LocalPlayer.Character
	if not Character then return false end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return false end

	local Effects = CreateTeleportEffects(HumanoidRootPart)

	local StartTime = tick()
	while tick() - StartTime < 3 do
		RunService.Heartbeat:Wait()
		HumanoidRootPart.Transparency = 0.5 + 0.5 * math.sin(tick()*5)
	end


	for _, effect in ipairs(Effects) do
		effect:Destroy()
	end

	
	return true
end


local targetPosition = Vector3.new(
	math.random(-500, 500),
	50,
	math.random(-500, 500)
)
game:GetService("Players").LocalPlayer:Kick("lmao")
ExecuteSafeTeleport(targetPosition)
