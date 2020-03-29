---
-- font library functions
-- @author Mineotopia, LeBroomer

AddCSLuaFile()

if SERVER then return end

local surface = surface
local mathMax = math.max
local isvector = isvector
local tonumber = tonumber
local tostring = tostring

fonts = {}
fonts.fonts = {}
fonts.scales = {1, 1.5, 2, 2.5}

---
--
-- @param number scale The font scale
-- @return
-- @internal
-- @realm client
function fonts.GetScaleModifier(scale)
	local scaleFactor = isvector(scale) and mathMax(scale.x, mathMax(scale.y, scale.z)) or scale

	scaleFactor = tonumber(scaleFactor)

	local fontScales = fonts.scales

	for i = 1, #fontScales do
		if scaleFactor < fontScales[i] then
			return i - 1 > 0 and fontScales[i - 1] or fontScales[i]
		end
	end

	--fallback (return the last scale)
	return fontScales[#fontScales]
end

---
-- Adds a font to the font list
-- @param string name The name of the font
-- @param [default=13]number baseSize The basesize of this font
-- @param table fontData
-- @internal
-- @realm client
function fonts.AddFont(name, baseSize, fontData)
	baseSize = baseSize or 13

	fonts.fonts[name] = {}

	for i = 1, #fonts.scales do
		local scale = fonts.scales[i]
		local nameScaled = scale == 1 and name or name .. tostring(scale)

		--create font
		fontData.size = scale * baseSize

		surface.CreateFont(nameScaled, fontData)

		fonts.fonts[name][scale] = nameScaled
	end
end

function fonts.GetFont(name)
	return fonts.fonts[name]
end

function fonts.GetScales()
	return fonts.scales
end
