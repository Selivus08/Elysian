local placeId = game.PlaceId

if placeId == 18687417158 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Selivus08/forsakenfr/refs/heads/main/forsaken.lua",true))()
elseif placeId == 71895508397153 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Selivus08/forsakenfr/refs/heads/main/dieofdeath.lua",true))()
else
_G.Config = { ["Theme"] = "spotify" }
local Notifs = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Selivus08/forsakenfr/refs/heads/main/notification.lua", true))();
Notifs:Notify(nil, "this game is not supported by elysian", "error", 3);
end
