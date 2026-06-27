--[ HEARTBEAT ]--
local function faceAlong(pos, dir)
    return CFrame.new(pos, pos + dir) * CFrame.Angles(-math.pi / 2, 0, 0)
end

local CharCF = GetCharacterCFrame()
local now    = Clock
local isAttacking = now < (GetGlobal("AttackUntil") or 0)

if not isAttacking then
    SafeFor(1, 6, function(i)
        local N = now / 30 + i * math.pi / 3
        local a = CharCF.Position + 8 * Vector3.new(math.sin(N), 0, math.cos(N))
        CreateMover(Ref("SWORD" .. tostring(i)), "BodyPosition", {
            MaxForce = Vector3.new(6e7, 6e7, 6e7),
            P = 2000,
            D = 200,
            Position = a,
        })
        CreateMover(Ref("SWORD" .. tostring(i)), "BodyGyro", {
            MaxTorque = Vector3.new(6e7, 6e7, 6e7),
            P = 2000,
            D = 200,
            CFrame = faceAlong(a, a - CharCF.Position),
        })
    end)

    if (GetGlobal("SwordsHidden") or 0) == 1 and now >= (GetGlobal("VisibleAgainAt") or 0) then
        SafeFor(1, 6, function(i)
            Tween(Ref("SWORD" .. tostring(i)), { Transparency = 0 }, 0.4, "Quad", "Out")
        end)
        SetGlobal("SwordsHidden", 0)
    end
end

--[ Attack Burst ]--
local function faceAlong(pos, dir)
    return CFrame.new(pos, pos + dir) * CFrame.Angles(-math.pi / 2, 0, 0)
end

local CharCF = GetCharacterCFrame()
local now = Clock
if now < (GetGlobal("BurstCooldown") or 0) then return end

local attackUntilTick = now + 40

SafeFor(1, 6, function(i)
    local N = now / 30 + i * math.pi / 3
    local a = CharCF.Position + 50 * Vector3.new(math.sin(N), 0, math.cos(N))
    local id = Ref("SWORD" .. tostring(i))
    CreateMover(id, "BodyPosition", {
        MaxForce = Vector3.new(6e7, 6e7, 6e7),
        P = 8000,
        D = 80,
        Position = a,
    })
    CreateMover(id, "BodyGyro", {
        MaxTorque = Vector3.new(6e7, 6e7, 6e7),
        P = 4000,
        D = 100,
        CFrame = faceAlong(a, a - CharCF.Position),
    })
    SetAppearance(id, { Color = Color3.fromRGB(255, 255, 255) })
    Tween(id, { Color = Color3.fromRGB(70, 130, 255) }, 0.3, "Quad", "Out")
end)

SetGlobal("AttackUntil", attackUntilTick)
SetGlobal("BurstCooldown", now + 60)
wait(0.5)
SafeFor(1, 6, function(i)
    Tween(Ref("SWORD" .. tostring(i)), { Transparency = 1 }, 0.15, "Quad", "Out")
end)
SetGlobal("SwordsHidden", 1)
SetGlobal("VisibleAgainAt", attackUntilTick + 30)

--[ Attack Rain ]--
local function faceAlong(pos, dir)
    return CFrame.new(pos, pos + dir) * CFrame.Angles(-math.pi / 2, 0, 0)
end

local now = Clock
if now < (GetGlobal("RainCooldown") or 0) then return end

local GroundPos   = Cursor.Position
local RISE_HEIGHT = 40
local SPREAD      = 4
local STAGGER     = 0.15

local attackUntilTick = now + 140

SetGlobal("AttackUntil", attackUntilTick)

SafeFor(1, 6, function(i)
    Tween(Ref("SWORD" .. tostring(i)), { Transparency = 1 }, 0.15, "Quad", "Out")
end)
wait(0.15)

SafeFor(1, 6, function(i)
    local id = Ref("SWORD" .. tostring(i))
    local angle = i * (math.pi * 2 / 6)
    local skyPos = GroundPos + Vector3.new(math.cos(angle) * SPREAD, RISE_HEIGHT, math.sin(angle) * SPREAD)
    CreateMover(id, "BodyPosition", {
        MaxForce = Vector3.new(6e7, 6e7, 6e7),
        P = 6000,
        D = 200,
        Position = skyPos,
    })
    CreateMover(id, "BodyGyro", {
        MaxTorque = Vector3.new(6e7, 6e7, 6e7),
        P = 3000,
        D = 150,
        CFrame = faceAlong(skyPos, Vector3.new(0, -1, 0)),
    })
end)

wait(0.5)

SafeFor(1, 6, function(i)
    Tween(Ref("SWORD" .. tostring(i)), { Transparency = 0 }, 0.2, "Quad", "Out")
end)

wait(0.17)

SafeFor(1, 6, function(i)
    local id = Ref("SWORD" .. tostring(i))
    CreateMover(id, "BodyPosition", {
        MaxForce = Vector3.new(6e7, 6e7, 6e7),
        P = 15000,
        D = 60,
        Position = GroundPos + SPREAD * Vector3.new(math.random(), 0, math.random()),
    })
    CreateMover(id, "BodyGyro", {
        MaxTorque = Vector3.new(6e7, 6e7, 6e7),
        P = 3000,
        D = 150,
        CFrame = faceAlong(GroundPos, Vector3.new(0, -1, 0)),
    })
    SetAppearance(id, { Color = Color3.fromRGB(255, 255, 255) })
    Tween(id, { Color = Color3.fromRGB(100, 200, 255) }, 0.4, "Quad", "Out")
    wait(STAGGER)
end)

SafeFor(1, 6, function(i)
    Tween(Ref("SWORD" .. tostring(i)), { Transparency = 1 }, 0.3, "Quad", "Out")
end)
SetGlobal("VisibleAgainAt", attackUntilTick + 40)
SetGlobal("SwordsHidden", 1)

SetGlobal("RainCooldown", now + 200)
print("Rain!")

--[ Attack Projectile ]--
local function faceAlong(pos, dir)
    return CFrame.new(pos, pos + dir) * CFrame.Angles(-math.pi / 2, 0, 0)
end
local now = Clock
if now < (GetGlobal("ProjectileCooldown") or 0) then return end

local CharCF        = GetCharacterCFrame()
local chargeCenter  = CharCF.Position + CharCF.LookVector * 6
local CHARGE_TIME   = 1
local STEPS         = 12
local RING_RADIUS   = 2.5
local LAUNCH_SPEED  = 670
local FADE_DELAY    = 1.5

local attackUntilTick = now + 200

SetGlobal("AttackUntil", attackUntilTick)

local posHandles  = {}
local gyroHandles = {}

SafeFor(1, STEPS, function(step)
    local spin = step * (math.pi * 2 / STEPS) * 3
    SafeFor(1, 6, function(i)
        local id = Ref("SWORD" .. tostring(i))
        local angle = spin + i * (math.pi * 2 / 6)
        local ringPos = chargeCenter
            + CharCF.RightVector * math.cos(angle) * RING_RADIUS
            + CharCF.UpVector * math.sin(angle) * RING_RADIUS
        posHandles[i] = CreateMover(id, "BodyPosition", {
            MaxForce = Vector3.new(6e7, 6e7, 6e7),
            P = 1000,
            D = 150,
            Position = ringPos,
        })
        gyroHandles[i] = CreateMover(id, "BodyGyro", {
            MaxTorque = Vector3.new(6e7, 6e7, 6e7),
            P = 3000,
            D = 150,
            CFrame = faceAlong(ringPos, CharCF.LookVector),
        })
    end)
    wait(CHARGE_TIME / STEPS)
end)

SafeFor(1, 6, function(i)
    if posHandles[i]  then RemoveMover(posHandles[i])  end
    if gyroHandles[i] then RemoveMover(gyroHandles[i]) end
    local id = Ref("SWORD" .. tostring(i))
    SetVelocity(id, (CharCF.LookVector + 0.15 * CharCF.UpVector) * LAUNCH_SPEED)
    SetAppearance(id, { Color = Color3.fromRGB(255, 255, 255) })
    Tween(id, { Color = Color3.fromRGB(30, 90, 255) }, 0.3, "Quad", "Out")
end)

wait(FADE_DELAY)
SafeFor(1, 6, function(i)
    Tween(Ref("SWORD" .. tostring(i)), { Transparency = 1 }, 0.3, "Quad", "Out")
end)
SetGlobal("VisibleAgainAt", attackUntilTick)
SetGlobal("SwordsHidden", 1)
SetGlobal("ProjectileCooldown", now + 250)
