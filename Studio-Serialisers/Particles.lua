
local HttpService = game:GetService("HttpService")
local Selection   = game:GetService("Selection")
local emitter
for _, sel in ipairs(Selection:Get()) do
	if sel:IsA("ParticleEmitter") then
		emitter = sel
		break
	elseif sel:IsA("BasePart") or sel:IsA("Model") then
		for _, desc in ipairs(sel:GetDescendants()) do
			if desc:IsA("ParticleEmitter") then
				emitter = desc
				break
			end
		end
	end
	if emitter then break end
end

local function nr(r)
	return { r.Min, r.Max }
end

local function ns(seq)
	local out = {}
	for _, kp in ipairs(seq.Keypoints) do
		out[#out + 1] = { kp.Time, kp.Value, kp.Envelope }
	end
	return out
end

local function cs(seq)
	local out = {}
	for _, kp in ipairs(seq.Keypoints) do
		local c = kp.Value
		out[#out + 1] = { kp.Time, c.R, c.G, c.B }
	end
	return out
end

local function v2(v) return { v.X, v.Y }        end
local function v3(v) return { v.X, v.Y, v.Z }   end

local function safeRead(fn)
	local ok, v = pcall(fn)
	return ok and v or nil
end

local data = {
	_version = 1,
	Rate        = emitter.Rate,
	Lifetime    = nr(emitter.Lifetime),
	Speed       = nr(emitter.Speed),
	RotSpeed    = nr(emitter.RotSpeed),
	Rotation    = nr(emitter.Rotation),
	Drag        = emitter.Drag,
	Texture     = emitter.Texture,

	Brightness         = emitter.Brightness,
	LightEmission      = emitter.LightEmission,
	LightInfluence     = emitter.LightInfluence,
	ZOffset            = emitter.ZOffset,
	TimeScale          = emitter.TimeScale,
	VelocityInheritance = safeRead(function() return emitter.VelocityInheritance end),
	VelocitySpread      = safeRead(function() return emitter.VelocitySpread      end),
	EmissionDirection = emitter.EmissionDirection.Name,
	Orientation       = emitter.Orientation.Name,
	SpreadAngle  = v2(emitter.SpreadAngle),
	Acceleration = v3(emitter.Acceleration),
	LockedToPart = emitter.LockedToPart,
	Color        = cs(emitter.Color),
	Size         = ns(emitter.Size),
	Transparency = ns(emitter.Transparency),
	Squash       = safeRead(function() return ns(emitter.Squash) end),
	FlipbookLayout      = safeRead(function() return emitter.FlipbookLayout.Name  end),
	FlipbookMode        = safeRead(function() return emitter.FlipbookMode.Name    end),
	FlipbookBlendFrames = safeRead(function() return emitter.FlipbookBlendFrames  end),
	FlipbookStartRandom = safeRead(function() return emitter.FlipbookStartRandom  end),
	FlipbookFramerate   = safeRead(function() return nr(emitter.FlipbookFramerate) end),
	FlipbookSizeX       = safeRead(function() return emitter.FlipbookSizeX        end),
	FlipbookSizeY       = safeRead(function() return emitter.FlipbookSizeY        end),
	Shape        = safeRead(function() return emitter.Shape.Name        end),
	ShapeStyle   = safeRead(function() return emitter.ShapeStyle.Name   end),
	ShapeInOut   = safeRead(function() return emitter.ShapeInOut.Name   end),
	ShapePartial = safeRead(function() return emitter.ShapePartial      end),
	WindAffectsDrag = safeRead(function() return emitter.WindAffectsDrag end),
}

local clean = {}
for k, v in pairs(data) do
	if v ~= nil then clean[k] = v end
end
local json = HttpService:JSONEncode(clean)
local sv = workspace:FindFirstChild("ParticleJSON")
if not sv or not sv:IsA("StringValue") then
	sv = Instance.new("StringValue")
	sv.Name = "ParticleJSON"
	sv.Parent = workspace
end
sv.Value = json
print(json)
