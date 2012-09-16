
--[[     Invite Links Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_InviteLinks then return end

	-- add locale to these tables
	local triggers = {"[Ii][Nn][Vv][Ii][Tt][Ee]$", "[Ii][Nn][Vv]$", -- These are any triggers e.g. "please inv"
	-- These are mid-sentance triggers e.g. "hey inv me" that could be mistaken for other words e.g. "invention", "invited"
	"([Ii][Nn][Vv][Ii][Tt][Ee]) ", "([Ii][Nn][Vv]) "}

	local filterFunc = function(self, event, msg, player, ...)
		local found, hasFound
		for i=1, 4 do
			msg, found = gsub(msg, triggers[i], "|cffFF7256|Hinvite:"..player.."|h[%1]|h|r"..(i > 2 and " " or ""))
			if found > 0 then hasFound = true end
		end
		if hasFound then
			return false, msg, player, ...
		end
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		if (link):sub(1, 6) == "invite" then
			if IsAltKeyDown() then
				if InviteToGroup then
					InviteToGroup((link):sub(8))
				else
					InviteUnit((link):sub(8))
				end
			end
		else
			SetHyperlink(self, link, ...)
		end
	end
end

