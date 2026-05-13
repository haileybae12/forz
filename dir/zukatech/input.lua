local url = "https://raw.githubusercontent.com/zukatechlive/allmychains/refs/heads/main/ZukasPanel.lua"
local ok, err = pcall(function()
	local src = game:HttpGet(url)
	assert(type(src) == "string" and #src > 0, "Empty response")
	local fn, e = loadstring(src)
	assert(fn, "loadstring failed: " .. tostring(e))
	fn()
end)
if not ok then
	warn("[Loader] Failed:", err)
end
