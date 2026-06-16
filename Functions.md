# Documentation on functions scripting

## Globals (injected each run)

| Name | Type | Description |
|---|---|---|
| `State` | `boolean` | Intended next toggle state (`true` = turning on) |
| `Blocks` | `number[]` | Opaque IDs for the keybind's configured parts |
| `Build` | `number[]` | Opaque IDs for all your special parts on your plot |

---

## Part API

All functions take an opaque ID from `Blocks` or `Build`.

| Function | Returns | Description |
|---|---|---|
| `SetEnabled(id, bool)` | — | Toggle a part on or off |
| `GetEnabled(id)` | `boolean` | Whether the part is currently enabled |
| `GetName(id)` | `string` | The part's name |
| `GetType(id)` | `string` | `SpecialType` attribute (e.g. `"Piston"`, `"Laser"`) |
| `IsAlive(id)` | `boolean` | Whether the part still exists (not destroyed) |

---

## Config API

| Function | Returns | Description |
|---|---|---|
| `SetConfig(id, key, value)` | — | Set a config attribute live. `value` must be `number` or `string`. Fires the same hook as the config UI (e.g. piston extends immediately) |
| `GetConfig(id, key)` | `number\|string\|nil` | Read the current value of a config attribute |

Common keys by block type:
- **Piston** → `"VLength"`, `"Speed"`
- **Laser** → `"Diameter"`, `"Range"`
- Others depend on block type

---

## Appearance API

| Function | Returns | Description |
|---|---|---|
| `SetAppearance(id, props)` | — | Set visual properties immediately |
| `Tween(id, props, duration, style?, dir?)` | `handle` | Smoothly animate appearance properties. Returns a handle |
| `CancelTween(handle)` | — | Stop a tween early |

**`SetAppearance` / `Tween` props:**

| Key | Type | Notes |
|---|---|---|
| `Color` | `Color3` | Part colour |
| `Transparency` | `number` | `0` – `1` |
| `Reflectance` | `number` | `0` – `1` |
| `CastShadow` | `boolean` | `SetAppearance` only |
| `Material` | `Enum.Material` | `SetAppearance` only |

**Tween easing styles** (strings): `"Linear"`, `"Quad"`, `"Cubic"`, `"Quart"`, `"Quint"`, `"Sine"`, `"Bounce"`, `"Elastic"`, `"Exponential"`, `"Circular"`, `"Back"`

**Tween easing directions** (strings): `"In"`, `"Out"`, `"InOut"`

Max 16 active tweens per player. Max duration 30 seconds.

---

## Velocity API

| Function | Returns | Description |
|---|---|---|
| `SetVelocity(id, linear, angular?)` | — | Directly set assembly velocity. `linear`: `Vector3`, capped at **300 studs/s**. `angular`: `Vector3`, capped at **50 rad/s** |

---

## Body Mover API (legacy)

| Function | Returns | Description |
|---|---|---|
| `CreateMover(id, type, props)` | `handle` | Create a body mover parented to the part. Returns an opaque handle |
| `SetMover(handle, props)` | — | Update an existing mover's props in place. Only keys valid for that mover's type are applied; same caps as `CreateMover` |
| `RemoveMover(handle)` | — | Destroy the mover and release the slot |

Max 8 active movers per player. All destroyed when you leave.

**Mover types and their props:**

| Type | Props |
|---|---|
| `"BodyVelocity"` | `Velocity: Vector3`, `MaxForce: Vector3`, `P: number` |
| `"BodyForce"` | `Force: Vector3` |
| `"BodyPosition"` | `Position: Vector3`, `MaxForce: Vector3`, `D: number`, `P: number` |
| `"BodyGyro"` | `CFrame: CFrame`, `MaxTorque: Vector3`, `D: number`, `P: number` |
| `"BodyAngularVelocity"` | `AngularVelocity: Vector3`, `MaxTorque: Vector3`, `P: number` |

All forces capped at `1,000,000` per component. Velocities follow the same caps as `SetVelocity`.

---

## Persistent Globals API

Values survive between keybind fires for the session. Cleared when you leave.

| Function | Returns | Description |
|---|---|---|
| `SetGlobal(key, value)` | — | Store a value. `value`: `number`, `string`, `boolean`, or `nil` (nil deletes it). Key max 40 chars, value max 1000 chars, max 64 keys |
| `GetGlobal(key)` | `number\|string\|boolean\|nil` | Retrieve a stored value |

---

## Output

| Function | Description |
|---|---|
| `print(...)` | Captured and shown in the function editor's output panel. Max 20 lines |
| `warn(...)` | Same as `print` |

---

## Safe stdlib

`math` · `table` · `string` · `ipairs` · `pairs` · `type` · `tostring` · `tonumber` · `Color3` · `Vector3` · `CFrame` · `Enum` · `unpack` · `select` · `assert` · `error` · `pcall`
