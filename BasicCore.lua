
--[[     BCM Core     ]]--

local _, BCM = ...
BCM.chatFrames = 10
BCM.modules, BCM.chatFuncs, BCM.chatFuncsPerFrame, BCM.Events = {}, {}, {}, CreateFrame("Frame")
BCM.Events:SetScript("OnEvent", function(frame, event) if frame[event] then frame[event](frame) end end)

--[[ Common Functions ]]--
function BCM:GetColor(className, isLocal)
	if isLocal then
		local found
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == className then className = k found = true break end
		end
		if not found then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == className then className = k break end
			end
		end
	end
	local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[className] or RAID_CLASS_COLORS[className]
	local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

do
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}
	)
	frame:SetSize(650, 40)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetFrameStrata("DIALOG")
	frame:Hide()

	local editBox = CreateFrame("EditBox", nil, frame)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetSize(610, 40)
	editBox:SetPoint("LEFT", frame, "LEFT", 10, 0)
	local hide = function(f) f:GetParent():Hide() end
	editBox:SetScript("OnEscapePressed", hide)

	local close = CreateFrame("Button", nil, frame)
	close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
	close:SetSize(32, 32)
	close:SetPoint("RIGHT", frame, "RIGHT")
	close:SetScript("OnClick", hide)
	function BCM:Popup(text)
		editBox:SetText(text)
		editBox:HighlightText(0)
		editBox:GetParent():Show()
	end
end

local oldAddMsg = {}
local AddMessage = function(frame, text, ...)
	if not text or text == "" then return end
	for i=1, #BCM.chatFuncs do
		text = BCM.chatFuncs[i](text)
	end
	return oldAddMsg[frame:GetName()](frame, text, ...)
end

BCM.Events.PLAYER_LOGIN = function(frame)
	--[[ Check Database ]]--
	if type(bcmDB) ~= "table" then bcmDB = {} end
	if not bcmDB.v then
		bcmDB.v = 1
		bcmDB.BCM_AutoLog = true
		bcmDB.BCM_PlayerNames = true
	end

	--[[ Run Modules ]]--
	for i=1, #BCM.modules do
		BCM.modules[i]()
		BCM.modules[i] = nil
	end

	--[[ Hook Chat Frame ]]--
	for i=1, BCM.chatFrames do
		local n = ("%s%d"):format("ChatFrame", i)

		--Allow arrow keys editing in the edit box
		local eB =  _G[n.."EditBox"]
		eB:SetAltArrowKeyMode(false)

		if i ~= 2 then --skip combatlog
			local cF = _G[n]
			oldAddMsg[n] = cF.AddMessage
			cF.AddMessage = AddMessage
		end

		for j=1, #BCM.chatFuncsPerFrame do
			BCM.chatFuncsPerFrame[j](n)
		end
	end

	--[[ Hook On-Demand Chat Frames ]]--
	hooksecurefunc("FCF_OpenTemporaryWindow", function()
		for i=11, 20 do
			local n = ("%s%d"):format("ChatFrame", i)
			local cF = _G[n]
			if not cF or oldAddMsg[n] then return end

			BCM.chatFrames = i -- Update the chat frame count for config options

			--Allow the chat frame to move to the end of the screen
			cF:SetClampRectInsets(0,0,0,0)

			--Allow arrow keys editing in the edit box
			local eB =  _G[n.."EditBox"]
			eB:SetAltArrowKeyMode(false)

			oldAddMsg[n] = cF.AddMessage
			cF.AddMessage = AddMessage

			--Fire functions to apply to various frames
			for j=1, #BCM.chatFuncsPerFrame do
				BCM.chatFuncsPerFrame[j](n)
			end
		end
	end)

	--[[ Self-Cleanup ]]--
	BCM.modules = nil
	frame.PLAYER_LOGIN = nil
end
BCM.Events:RegisterEvent("PLAYER_LOGIN")

--These need to be set before PLAYER_LOGIN
for i=1, BCM.chatFrames do
	local cF = _G[("%s%d"):format("ChatFrame", i)]
	--Allow the chat frame to move to the end of the screen
	cF:SetClampRectInsets(0,0,0,0)
end
--Clamp the toast frame to screen to prevent it cutting out
BNToastFrame:SetClampedToScreen(true)

