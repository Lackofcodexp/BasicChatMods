
--[[     Basic Config Module     ]]--

local name, f = ...
f.modules[#f.modules+1] = function()
	if bcmDB.noconfig then return end

	--[[-------------------------------
	-- Localization
	-------------------------------]]--

	local L = {}
	L.CORE = "Welcome to BasicChatMods, a basic and modular approach to chat customization. Due to the way BCM is designed a /reload may be required for some changes.\n\nBy default BCM will allow you to drag your chat frames to the very edge of the screen, the remaining customization is done in BCM's modules which can be enabled or disabled at will.\n\n In BCM disabled modules use no memory, disable the ones you don't use!"
	L.WARNING = "<<The changes you've made require a /reload to take effect>>"
	L.OPTIONS = "<<More options may be available after enabling this module>>"

	L.BCM_AutoLog = "Automatically log chat after logging on and automatically log the combat log when in a raid instance."
	L.BCM_BNet = "Customize the brackets or add color to the various Real Id events such as whispers, conversations, and friends logging on."
	L.BCM_ButtonHide = "Completely hides the chat frame side buttons from view for the people that have no use for them."
	L.BCM_ChannelNames = "Selectively replace the channel names with custom names of your liking. E.g. [Party] >> [P]"
	L.BCM_ChatCopy = "This module allows you to copy chat directly from your chat frame by double-clicking the chat frame tab."
	L.BCM_EditBox = "This module simply moves the edit box (the box you type in) to the top of the chat frame, instead of the bottom."
	L.BCM_Fade = "Fade out the chat frames completely instead of partially when moving your mouse away from a chat frame."
	L.BCM_Font = "Change the font name/size/flag of your chat frames. Disable if you use defaults."
	L.BCM_GMOTD = "Re-display the guild MOTD in the main chat frame after 10 seconds."
	L.BCM_Highlight = "Play a sound if your name is mentioned in chat, also class color it. You can enter the short version of your name in the box below."
	L.BCM_History = "Choose how many lines of chat history your chat frames remember."
	L.BCM_InviteLinks = "Scan for the word 'invite' and convert it into an ALT-clickable link that invites that person. E.g. |cFFFF7256[invite]|r"
	L.BCM_PlayerNames = "Customize the player name in chat with player level/group (if known) or remove/change brackets. E.g. [85:|cFFFFFFFFCoolPriest|r:5]"
	L.BCM_Justify = "Justify the text of the various chat frames to the right, left, or center of the chat frame."
	L.BCM_Resize = "Allows you to change the size of the chat frame to sizes smaller/bigger than what Blizz allows."
	L.BCM_ScrollDown = "Create a small clickable arrow over your chat frames that flashes if you're not at the very bottom."
	L.BCM_Sticky = "Customize your 'sticky' chat. Makes the chat edit box remember the last chat type you used so that you don't need to re-enter it again next time you chat."
	L.BCM_TellTarget = "Allows you to whisper/tell your current target with the command /tt message or /wt message."
	L.BCM_Timestamp = "Customize the timestamps you want your chat to use. Choose a color or no color at all, then choose the exact format of the timestamp."
	L.BCM_URLCopy = "Turn websites in your chat frame into clickable links for you to easily copy. E.g. |cFFFFFFFF[www.battle.net]|r"

	L.CHATLOG = "Always log chat."
	L.COMBATLOG = "Log combat in a raid instance."

	L.LEFT = "Left"
	L.RIGHT = "Right"
	L.CENTER = "Center"

	L.GENERAL = "General"
	L.TRADE = "Trade"
	L.WORLDDEFENSE = "WorldDefense"
	L.LOCALDEFENSE = "LocalDefense"
	L.LFG = "LookingForGroup"
	L.GUILDRECRUIT = "GuildRecruitment"
	L.CHANNELNUMBER = "Channel Number"
	L.CHANNELNAME = "Channel Name"
	L.CUSTOMCHANNEL = "Custom Channel"

	L.SHOWLEVELS = "Player level next to name."
	L.SHOWGROUP = "Player group next to name."
	L.COLORMISC = "Class color missed names (friend login, channel join, etc.)"
	L.PLAYERBRACKETS = "Player Brackets:"

--[[ Start WowAce Localization Mess ]]--
local GetL = GetLocale()
if GetL == "deDE" then
--@localization(locale="deDE", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "frFR" then
--@localization(locale="frFR", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "esES" then
--@localization(locale="esES", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "ruRU" then
--@localization(locale="ruRU", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "zhTW" then
--@localization(locale="zhTW", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "zhCN" then
--@localization(locale="zhCN", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "koKR" then
--@localization(locale="koKR", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
elseif GetL == "esMX" then
--@localization(locale="esMX", namespace="Config_Module", format="lua_additive_table", handle-unlocalized="ignore")@
end
--[[ End WowAce Localization Mess ]]--

	--[[-------------------------------
	-- Core widgets/functions/etc
	-------------------------------]]--

	local onShow = function(frame)
		--Don't move recycled widgets when opening the main BCM panel
		if InterfaceOptionsFramePanelContainer.displayedPanel and InterfaceOptionsFramePanelContainer.displayedPanel.name == name then return end

		local btn = BCMEnableButton
		btn:ClearAllPoints()
		btn:SetParent(frame)
		btn:SetPoint("TOPLEFT", 16, -100)

		local desc = BCMPanelDesc
		desc:ClearAllPoints()
		desc:SetParent(frame)
		desc:SetPoint("TOPLEFT", 16, -20)
		desc:SetText(L[frame:GetName()] or "No Description")

		local warn = BCM_Warning
		warn:ClearAllPoints()
		warn:SetParent(frame)
		warn:SetPoint("CENTER", 0, -200)
		if bcmDB[frame:GetName()] then
			btn:SetChecked(false)
			local optionWarn = BCM_OptionsWarn
			optionWarn:ClearAllPoints()
			optionWarn:SetParent(frame)
			optionWarn:SetPoint("CENTER")
			optionWarn:Show()
		else
			btn:SetChecked(true)
			BCM_OptionsWarn:Hide()
		end

		--[[ Modules ]]--
		if frame:GetName() == "BCM_AutoLog" and BCM_ChatLog_Button then
			BCM_ChatLog_Button:SetChecked(bcmDB.logchat)
			BCM_CombatLog_Button:SetChecked(bcmDB.logcombat)
		elseif frame:GetName() == "BCM_BNet" and BCM_BNetColor_Button then
			BCM_BNetColor_Button:SetChecked(not bcmDB.noBNetColor and true)
			BCM_PlayerBrackDesc:SetParent(frame)
			BCM_PlayerLBrack:SetParent(frame)
			BCM_PlayerRBrack:SetParent(frame)
			BCM_PlayerSeparator:SetParent(frame)
			BCM_PlayerLBrack:SetText("1234567890")
			BCM_PlayerLBrack:SetText(bcmDB.playerLBrack)
			BCM_PlayerRBrack:SetText("1234567890")
			BCM_PlayerRBrack:SetText(bcmDB.playerRBrack)
			BCM_PlayerSeparator:SetText("1234567890")
			BCM_PlayerSeparator:SetText(bcmDB.playerSeparator)
		elseif frame:GetName() == "BCM_ChatCopy" and BCM_ChatCopy_Button then
			BCM_ChatCopy_Button:SetChecked(not bcmDB.noChatCopyTip and true)
		elseif frame:GetName() == "BCM_History" and BCM_Lines_Set then
			BCM_Lines_Set:SetText(1234)
			BCM_Lines_Set:SetText(_G[BCM_Lines_GetText:GetText()]:GetMaxLines())
		elseif frame:GetName() == "BCM_PlayerNames" and BCM_PlayerLevel_Button then
			BCM_PlayerLevel_Button:SetChecked(not bcmDB.nolevel and true)
			BCM_PlayerGroup_Button:SetChecked(not bcmDB.nogroup and true)
			BCM_PlayerColor_Button:SetChecked(not bcmDB.noMiscColor and true)
			BCM_PlayerBrackDesc:SetParent(frame)
			BCM_PlayerLBrack:SetParent(frame)
			BCM_PlayerRBrack:SetParent(frame)
			BCM_PlayerSeparator:SetParent(frame)
			BCM_PlayerLBrack:SetText("1234567890")
			BCM_PlayerLBrack:SetText(bcmDB.playerLBrack)
			BCM_PlayerRBrack:SetText("1234567890")
			BCM_PlayerRBrack:SetText(bcmDB.playerRBrack)
			BCM_PlayerSeparator:SetText("1234567890")
			BCM_PlayerSeparator:SetText(bcmDB.playerSeparator)
		elseif frame:GetName() == "BCM_Highlight" and BCM_Highlight_Input and bcmDB.highlightWord then
			BCM_Highlight_Input:SetText("1234567890")
			BCM_Highlight_Input:SetText(bcmDB.highlightWord)
		elseif frame:GetName() == "BCM_Timestamp" and BCM_Timestamp_InputCol then
			BCM_Timestamp_InputCol:SetText("123456")
			BCM_Timestamp_Format:SetText("1234567890")
			BCM_Timestamp_Format:SetText(bcmDB.stampformat)
			if bcmDB.stampcolor == "" then
				BCM_TimestampColor_Button:SetChecked(false)
				BCM_Timestamp_InputCol:EnableMouse(false)
				BCM_Timestamp_InputCol:SetText("")
				BCM_Timestamp_InputCol:ClearFocus()
			else
				BCM_TimestampColor_Button:SetChecked(true)
				BCM_Timestamp_InputCol:SetText((bcmDB.stampcolor):sub(5))
			end
		end
	end
	local makePanel = function(frameName, bcm, panelName)
		local panel = CreateFrame("Frame", frameName, bcm)
		panel.name, panel.parent = panelName, name
		panel:SetScript("OnShow", onShow)
		InterfaceOptions_AddCategory(panel)
	end

	--[[ Slash handler ]]--
	SlashCmdList[name] = function() InterfaceOptionsFrame_OpenToCategory(name) end
	SLASH_BasicChatMods1 = "/bcm"

	--[[ Main Panel ]]--
	local bcm = CreateFrame("Frame", "BCM", InterfaceOptionsFramePanelContainer)
	bcm.name = name
	InterfaceOptions_AddCategory(bcm)
	local bcmTitle = bcm:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	bcmTitle:SetPoint("TOPLEFT", 16, -16)
	bcmTitle:SetText(name.." @project-version@") --wowace magic, replaced with tag version
	local bcmDesc = bcm:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	bcmDesc:SetPoint("TOPLEFT", 16, -62)
	bcmDesc:SetText(L.CORE)
	bcmDesc:SetWidth(375)
	bcmDesc:SetJustifyH("CENTER")

	--[[ The main enable button, enable text, and panel description that all modules use, recycled ]]--
	local panelDesc = bcm:CreateFontString("BCMPanelDesc", "ARTWORK", "GameFontNormalLarge")
	panelDesc:SetWidth(350)
	panelDesc:SetWordWrap(true)
	local enableBtn = CreateFrame("CheckButton", "BCMEnableButton", BCM, "OptionsBaseCheckButtonTemplate")
	enableBtn:SetScript("OnClick", function(frame)
		BCM_Warning:Show()
		local tick = frame:GetChecked()
		if tick then
			PlaySound("igMainMenuOptionCheckBoxOn")
			bcmDB[frame:GetParent():GetName()] = nil
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			bcmDB[frame:GetParent():GetName()] = true
		end
	end)
	local enableBtnText = enableBtn:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	enableBtnText:SetPoint("LEFT", enableBtn, "RIGHT")
	enableBtnText:SetText(ENABLE)
	local warn = bcm:CreateFontString("BCM_Warning", "ARTWORK", "GameFontNormal")
	warn:SetJustifyH("CENTER")
	warn:SetText(L.WARNING)
	warn:Hide()
	local optionsWarn = bcm:CreateFontString("BCM_OptionsWarn", "ARTWORK", "GameFontNormal")
	optionsWarn:SetJustifyH("CENTER")
	optionsWarn:SetText(L.OPTIONS)
	optionsWarn:Hide()

	--[[-------------------------------
	-- Module Panel Creation
	-------------------------------]]--

	--[[ Auto Log ]]--
	makePanel("BCM_AutoLog", bcm, "Auto Log")

	if not bcmDB.BCM_AutoLog then
		local onClick = function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				if frame:GetName() == "BCM_ChatLog_Button" then
					bcmDB.logchat = true
					LoggingChat(true)
					print("|cFF33FF99BasicChatMods|r: ", CHATLOGENABLED)
				else
					BCM_Warning:Show()
					bcmDB.logcombat = true
				end
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				if frame:GetName() == "BCM_ChatLog_Button" then
					bcmDB.logchat = nil
					LoggingChat(false)
					print("|cFF33FF99BasicChatMods|r: ", CHATLOGDISABLED)
				else
					BCM_Warning:Show()
					bcmDB.logcombat = nil
				end
			end
		end

		local chatLogBtn = CreateFrame("CheckButton", "BCM_ChatLog_Button", BCM_AutoLog, "OptionsBaseCheckButtonTemplate")
		chatLogBtn:SetScript("OnClick", onClick)
		chatLogBtn:SetPoint("TOPLEFT", 16, -150)
		local chatLogBtnText = chatLogBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		chatLogBtnText:SetPoint("LEFT", chatLogBtn, "RIGHT")
		chatLogBtnText:SetText(L.CHATLOG)

		local combatLogBtn = CreateFrame("CheckButton", "BCM_CombatLog_Button", BCM_AutoLog, "OptionsBaseCheckButtonTemplate")
		combatLogBtn:SetScript("OnClick", onClick)
		combatLogBtn:SetPoint("TOPLEFT", 16, -180)
		local combatLogBtnText = combatLogBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		combatLogBtnText:SetPoint("LEFT", combatLogBtn, "RIGHT")
		combatLogBtnText:SetText(L.COMBATLOG)
	end

	--[[ BNet Color ]]--
	makePanel("BCM_BNet", bcm, "BattleNet")

	if not bcmDB.BCM_BNet then
		local colorBtn = CreateFrame("CheckButton", "BCM_BNetColor_Button", BCM_BNet, "OptionsBaseCheckButtonTemplate")
		colorBtn:SetScript("OnClick", function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.noBNetColor = nil
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.noBNetColor = true
			end
		end)
		colorBtn:SetPoint("TOPLEFT", 16, -160)
		local colorBtnText = colorBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		colorBtnText:SetPoint("LEFT", colorBtn, "RIGHT")
		colorBtnText:SetText(CLASS_COLORS)

		local brackInputText = BCM_BNet:CreateFontString("BCM_PlayerBrackDesc", "ARTWORK", "GameFontNormal")
		brackInputText:SetPoint("TOPLEFT", 16, -240)
		brackInputText:SetText(L.PLAYERBRACKETS)
		local brackLInput = CreateFrame("EditBox", "BCM_PlayerLBrack", BCM_BNet, "InputBoxTemplate")
		brackLInput:SetPoint("TOPLEFT", 32, -260)
		brackLInput:SetAutoFocus(false)
		brackLInput:SetWidth(20)
		brackLInput:SetHeight(20)
		brackLInput:SetJustifyH("CENTER")
		brackLInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.playerLBrack = frame:GetText() end
		end)
		local brackRInput = CreateFrame("EditBox", "BCM_PlayerRBrack", BCM_BNet, "InputBoxTemplate")
		brackRInput:SetPoint("TOPLEFT", 64, -260)
		brackRInput:SetAutoFocus(false)
		brackRInput:SetWidth(20)
		brackRInput:SetHeight(20)
		brackRInput:SetJustifyH("CENTER")
		brackRInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.playerRBrack = frame:GetText() end
		end)
		local separatorInput = CreateFrame("EditBox", "BCM_PlayerSeparator", BCM_BNet, "InputBoxTemplate")
		separatorInput:SetPoint("TOPLEFT", 96, -260)
		separatorInput:SetAutoFocus(false)
		separatorInput:SetWidth(20)
		separatorInput:SetHeight(20)
		separatorInput:SetJustifyH("CENTER")
		separatorInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.playerSeparator = frame:GetText() end
		end)
	end

	--[[ Button Hide ]]--
	makePanel("BCM_ButtonHide", bcm, "Button Hide")

	--[[ Channel Names ]]--
	makePanel("BCM_ChannelNames", bcm, "Channel Names")

	if not bcmDB.BCM_ChannelNames then
		local channelTip = BCM_ChannelNames:CreateFontString("BCM_ChanName_Tip", "ARTWORK", "GameFontHighlight")
		channelTip:SetPoint("TOPLEFT", 210, -170)
		channelTip:SetText("%1 == ".. L.CHANNELNUMBER.. "\n%2 == ".. L.CHANNELNAME)
		channelTip:Hide()
		local chan = CreateFrame("Frame", "BCM_ChanName_Drop", BCM_ChannelNames, "UIDropDownMenuTemplate")
		chan:SetPoint("TOPLEFT", 16, -140)
		BCM_ChanName_DropMiddle:SetWidth(130)
		BCM_ChanName_DropText:SetText(ADD_CHANNEL)
		UIDropDownMenu_Initialize(chan, function()
			local selected, info = BCM_ChanName_DropText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_ChanName_DropText:SetText(v:GetText())
				if v:GetText() == L.CUSTOMCHANNEL then BCM_ChanName_Tip:Show() else BCM_ChanName_Tip:Hide() end
				local input = BCM_ChanName_Input
				input:EnableMouse(true)
				input:SetText("1234567890") --for some reason the text wont display without calling something long
				input:SetText(bcmDB.replacements[v.value])
				input.value = v.value
			end
			local tbl = {L.GENERAL, L.TRADE, L.WORLDDEFENSE, L.LOCALDEFENSE, L.LFG, L.GUILDRECRUIT, BATTLEGROUND, BATTLEGROUND_LEADER, GUILD, PARTY, PARTY_LEADER, gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%1"), OFFICER, RAID, RAID_LEADER, RAID_WARNING, L.CUSTOMCHANNEL}
			for i=1, #tbl do
				info.text = tbl[i]
				info.value = i
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end)

		local chanNameInput = CreateFrame("EditBox", "BCM_ChanName_Input", BCM_ChannelNames, "InputBoxTemplate")
		chanNameInput:SetPoint("LEFT", chan, "RIGHT", 170, 0)
		chanNameInput:SetAutoFocus(false)
		chanNameInput:SetWidth(100)
		chanNameInput:SetHeight(20)
		chanNameInput:SetJustifyH("CENTER")
		chanNameInput:SetMaxLetters(10)
		chanNameInput:EnableMouse(false)
		chanNameInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then bcmDB.replacements[frame.value] = frame:GetText() end
		end)
	end

	--[[ Chat Copy ]]--
	makePanel("BCM_ChatCopy", bcm, "Chat Copy")

	if not bcmDB.BCM_ChatCopy then
		local chatCopyBtn = CreateFrame("CheckButton", "BCM_ChatCopy_Button", BCM_ChatCopy, "OptionsBaseCheckButtonTemplate")
		chatCopyBtn:SetScript("OnClick", function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.noChatCopyTip = nil
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.noChatCopyTip = true
			end
		end)
		chatCopyBtn:SetPoint("TOPLEFT", 16, -150)
		local chatCopyBtnText = chatCopyBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		chatCopyBtnText:SetPoint("LEFT", chatCopyBtn, "RIGHT")
		chatCopyBtnText:SetText(SHOW_NEWBIE_TIPS_TEXT)
	end

	--[[ Edit Box ]]--
	makePanel("BCM_EditBox", bcm, "Edit Box")

	--[[ Fade ]]--
	makePanel("BCM_Fade", bcm, "Fade")

	--[[ Font ]]--
	makePanel("BCM_Font", bcm, "Font")

	if not bcmDB.BCM_Font then
		local fontName = CreateFrame("Frame", "BCM_FontName", BCM_Font, "UIDropDownMenuTemplate")
		fontName:SetPoint("TOPLEFT", 4, -140)
		BCM_FontNameMiddle:SetWidth(100)
		BCM_FontNameText:SetText("Font")
		UIDropDownMenu_Initialize(fontName, function()
			local selected, info = BCM_FontNameText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_FontNameText:SetText(v:GetText())
				bcmDB.fontname = v.value
				for i = 1, 10 do
					local cF = _G[format("%s%d", "ChatFrame", i)]
					local _, size = cF:GetFont()
					cF:SetFont(v.value, bcmDB.fontsize or size, bcmDB.fontflag)
				end
			end
			local lsm = LibStub and LibStub("LibSharedMedia-3.0", true)
			if lsm then
				local tbl = lsm:List("font")
				for i=1, #tbl do
					info.text = tbl[i]
					info.value = lsm:Fetch("font", tbl[i])
					info.checked = info.text == selected
					UIDropDownMenu_AddButton(info)
				end
			else
				local tbl
				local myLocale = GetLocale()
				if myLocale == "ruRU" then
					tbl = {["Arial Narrow"] = "Fonts\\ARIALN.TTF", ["Friz Quadrata"] = "Fonts\\FRIZQT__.TTF", ["Morpheus"] = "Fonts\\MORPHEUS.TTF", ["Nimrod MT"] = "Fonts\\NIM_____.ttf", ["Skurri"] = "Fonts\\SKURRI.TTF"}
				elseif myLocale == "koKR" then
					tbl = {["굵은 글꼴"] = "Fonts\\2002B.TTF", ["기본 글꼴"] = "Fonts\\2002.TTF", ["데미지 글꼴"] = "Fonts\\K_Damage.TTF", ["퀘스트 글꼴"] = "Fonts\\K_Pagetext.TTF"}
				elseif myLocale == "zhTW" then
					tbl = {["提示訊息"] = "Fonts\\bHEI00M.ttf", ["聊天"] = "Fonts\\bHEI01B.ttf", ["傷害數字"] = "Fonts\\bKAI00M.ttf", ["預設"] = "Fonts\\bLEI00D.ttf"}
				elseif myLocale == "zhCN" then
					tbl = {["伤害数字"] = "Fonts\\ZYKai_C.ttf", ["默认"] = "Fonts\\ZYKai_T.ttf", ["聊天"] = "Fonts\\ZYHei.ttf"}
				else
					tbl = {["Arial Narrow"] = "Fonts\\ARIALN.TTF", ["Friz Quadrata"] = "Fonts\\FRIZQT__.TTF", ["Morpheus"] = "Fonts\\MORPHEUS.TTF", ["Skurri"] = "Fonts\\SKURRI.TTF"}
				end
				for k,v in pairs(tbl) do
					info.text = k
					info.value = v
					info.checked = info.text == selected
					UIDropDownMenu_AddButton(info)
					tbl[k] = nil
				end
				tbl = nil
			end
		end)

		local fontSize = CreateFrame("Frame", "BCM_FontSize", BCM_Font, "UIDropDownMenuTemplate")
		fontSize:SetPoint("LEFT", fontName, "RIGHT", 100, 0)
		BCM_FontSizeMiddle:SetWidth(70)
		BCM_FontSizeText:SetText(FONT_SIZE)
		UIDropDownMenu_Initialize(fontSize, function()
			local selected, info = BCM_FontSizeText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_FontSizeText:SetText(v:GetText())
				bcmDB.fontsize = v.value
				for i = 1, 10 do
					local cF = _G[format("%s%d", "ChatFrame", i)]
					local fName, size = cF:GetFont()
					cF:SetFont(bcmDB.fontname or fName, v.value, bcmDB.fontflag)
				end
			end
			for i=8, 18 do
				info.text = FONT_SIZE_TEMPLATE:format(i)
				info.value = i
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
			end
		end)

		local fontFlag = CreateFrame("Frame", "BCM_FontFlag", BCM_Font, "UIDropDownMenuTemplate")
		fontFlag:SetPoint("LEFT", fontSize, "RIGHT", 70, 0)
		BCM_FontFlagMiddle:SetWidth(100)
		BCM_FontFlagText:SetText(NONE)
		UIDropDownMenu_Initialize(fontFlag, function()
			local selected, info = BCM_FontFlagText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) print(v.value) BCM_FontFlagText:SetText(v:GetText())
				if v.value == NONE then 
					bcmDB.fontflag = nil
				else
					bcmDB.fontflag = v.value
				end
				for i = 1, 10 do
					local cF = _G[format("%s%d", "ChatFrame", i)]
					local fName, size = cF:GetFont()
					cF:SetFont(bcmDB.fontname or fName, bcmDB.fontsize or size, bcmDB.fontflag)
				end
			end
			local tbl = {NONE, "OUTLINE", "THICKOUTLINE", "MONOCHROME"}
			for i=1, #tbl do
				info.text = tbl[i]
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end)
	end

	--[[ GMOTD ]]--
	makePanel("BCM_GMOTD", bcm, "GMOTD")

	--[[ Highlight ]]--
	makePanel("BCM_Highlight", bcm, "Highlight")

	if not bcmDB.BCM_Highlight then
		local secondaryNameDesc = BCM_Highlight:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		secondaryNameDesc:SetPoint("TOPLEFT", 20, -150)
		secondaryNameDesc:SetText("Secondary Name:")
		local secondaryNameInput = CreateFrame("EditBox", "BCM_Highlight_Input", BCM_Highlight, "InputBoxTemplate")
		secondaryNameInput:SetPoint("TOPLEFT", 25, -165)
		secondaryNameInput:SetAutoFocus(false)
		secondaryNameInput:SetWidth(100)
		secondaryNameInput:SetHeight(20)
		secondaryNameInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local t = frame:GetText()
				if t:find("[%(%)%.%%%+%-%*%?%[%^%$%]!\"£&_={}@'~#:;/\\<>,|`¬%d]") then frame:SetText(bcmDB.highlightWord or "") return end
				t = (t):lower()
				frame:SetText(t)
				if strlen(t) > 2 then
					bcmDB.highlightWord = t
				else
					bcmDB.highlightWord = nil
				end
				BCM_Warning:Show()
			end
		end)
	end

	--[[ History ]]--
	makePanel("BCM_History", bcm, "History")

	if not bcmDB.BCM_History then
		local get = CreateFrame("Frame", "BCM_Lines_Get", BCM_History, "UIDropDownMenuTemplate")
		get:SetPoint("TOPLEFT", 16, -140)
		BCM_Lines_GetText:SetText("ChatFrame1")
		UIDropDownMenu_Initialize(get, function()
			local selected, info = BCM_Lines_GetText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Lines_GetText:SetText(v.value)
				BCM_Lines_Set:SetText(bcmDB.lines[v.value] or _G[v.value]:GetMaxLines())
			end
			for i=1, 10 do
				info.text = ("ChatFrame%d"):format(i)
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
			end
		end)

		local linesInput = CreateFrame("EditBox", "BCM_Lines_Set", BCM_History, "InputBoxTemplate")
		linesInput:SetPoint("LEFT", get, "RIGHT", 170, 0)
		linesInput:SetNumeric(true)
		linesInput:SetAutoFocus(false)
		linesInput:SetWidth(100)
		linesInput:SetHeight(20)
		linesInput:SetJustifyH("CENTER")
		linesInput:SetMaxLetters(4)
		linesInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local input, cF = tonumber(frame:GetText()), BCM_Lines_GetText:GetText()
				if not input then return end
				if input <1 then frame:SetText(1) return end
				if input >2500 then frame:SetText(2500) return end
				bcmDB.lines[cF] = input
				_G[cF]:SetMaxLines(input)
			end
		end)
	end
	--[[ Invite Links ]]--
	makePanel("BCM_InviteLinks", bcm, "Invite Links")

	--[[ Justify ]]--
	makePanel("BCM_Justify", bcm, "Justify")

	if not bcmDB.BCM_Justify then
		local get = CreateFrame("Frame", "BCM_Justify_Get", BCM_Justify, "UIDropDownMenuTemplate")
		get:SetPoint("TOPLEFT", 16, -140)
		BCM_Justify_GetText:SetText("ChatFrame1")
		UIDropDownMenu_Initialize(get, function()
			local selected, info = BCM_Justify_GetText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Justify_GetText:SetText(v.value)
				if bcmDB.justify and bcmDB.justify[v.value] then
					BCM_Justify_SetText:SetText(L[bcmDB.justify[v.value]])
				else
					BCM_Justify_SetText:SetText(L.LEFT)
				end
			end
			for i=1, 10 do
				info.text = ("ChatFrame%d"):format(i)
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
			end
		end)

		local set = CreateFrame("Frame", "BCM_Justify_Set", BCM_Justify, "UIDropDownMenuTemplate")
		set:SetPoint("LEFT", get, "RIGHT", 140, 0)
		if bcmDB.justify and bcmDB.justify[BCM_Justify_GetText:GetText()] then
			BCM_Justify_SetText:SetText(bcmDB.justify[BCM_Justify_GetText:GetText()])
		else
			BCM_Justify_SetText:SetText(L.LEFT)
		end
		UIDropDownMenu_Initialize(set, function()
			local selected, info = BCM_Justify_SetText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Justify_SetText:SetText(v:GetText())
				if not bcmDB.justify then bcmDB.justify = {} end
				_G[BCM_Justify_GetText:GetText()]:SetJustifyH(v.value)
				if v.value == "RIGHT" or v.value == "CENTER" then
					bcmDB.justify[BCM_Justify_GetText:GetText()] = v.value
				else
					bcmDB.justify[BCM_Justify_GetText:GetText()] = nil
					--remove the table if we have no entries
					local w = nil
					for k in pairs(bcmDB.justify) do w = true end
					if not w then bcmDB.justify = nil end
				end
			end
			local tbl = {"LEFT", "RIGHT", "CENTER"}
			for i=1, #tbl do
				info.text = L[tbl[i]]
				info.value = tbl[i]
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end)
	end

	--[[ Player Names ]]--
	makePanel("BCM_PlayerNames", bcm, "Player Names")

	if not bcmDB.BCM_PlayerNames then
		local onClick = function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				if not BCM_PlayerName_Harvest then BCM_Warning:Show() end
				if frame:GetName() == "BCM_PlayerLevel_Button" then
					bcmDB.nolevel = nil
				elseif frame:GetName() == "BCM_PlayerColor_Button" then
					bcmDB.noMiscColor = nil
				else
					bcmDB.nogroup = nil
				end
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				if frame:GetName() == "BCM_PlayerLevel_Button" then
					bcmDB.nolevel = true
				elseif frame:GetName() == "BCM_PlayerColor_Button" then
					bcmDB.noMiscColor = true
				else
					bcmDB.nogroup = true
				end
			end
		end

		local levelsBtn = CreateFrame("CheckButton", "BCM_PlayerLevel_Button", BCM_PlayerNames, "OptionsBaseCheckButtonTemplate")
		levelsBtn:SetScript("OnClick", onClick)
		levelsBtn:SetPoint("TOPLEFT", 16, -140)
		local levelsBtnText = levelsBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		levelsBtnText:SetPoint("LEFT", levelsBtn, "RIGHT")
		levelsBtnText:SetText(L.SHOWLEVELS)

		local groupBtn = CreateFrame("CheckButton", "BCM_PlayerGroup_Button", BCM_PlayerNames, "OptionsBaseCheckButtonTemplate")
		groupBtn:SetScript("OnClick", onClick)
		groupBtn:SetPoint("TOPLEFT", 16, -170)
		local groupBtnText = groupBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		groupBtnText:SetPoint("LEFT", groupBtn, "RIGHT")
		groupBtnText:SetText(L.SHOWGROUP)

		local colorBtn = CreateFrame("CheckButton", "BCM_PlayerColor_Button", BCM_PlayerNames, "OptionsBaseCheckButtonTemplate")
		colorBtn:SetScript("OnClick", onClick)
		colorBtn:SetPoint("TOPLEFT", 16, -200)
		local colorBtnText = colorBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		colorBtnText:SetPoint("LEFT", colorBtn, "RIGHT")
		colorBtnText:SetText(L.COLORMISC)

		if not BCM_PlayerBrackDesc then
			local brackInputText = BCM_PlayerNames:CreateFontString("BCM_PlayerBrackDesc", "ARTWORK", "GameFontNormal")
			brackInputText:SetPoint("TOPLEFT", 16, -240)
			brackInputText:SetText(L.PLAYERBRACKETS)
			local brackLInput = CreateFrame("EditBox", "BCM_PlayerLBrack", BCM_PlayerNames, "InputBoxTemplate")
			brackLInput:SetPoint("TOPLEFT", 32, -260)
			brackLInput:SetAutoFocus(false)
			brackLInput:SetWidth(20)
			brackLInput:SetHeight(20)
			brackLInput:SetJustifyH("CENTER")
			brackLInput:SetScript("OnTextChanged", function(frame, changed)
				if changed then bcmDB.playerLBrack = frame:GetText() end
			end)
			local brackRInput = CreateFrame("EditBox", "BCM_PlayerRBrack", BCM_PlayerNames, "InputBoxTemplate")
			brackRInput:SetPoint("TOPLEFT", 64, -260)
			brackRInput:SetAutoFocus(false)
			brackRInput:SetWidth(20)
			brackRInput:SetHeight(20)
			brackRInput:SetJustifyH("CENTER")
			brackRInput:SetScript("OnTextChanged", function(frame, changed)
				if changed then bcmDB.playerRBrack = frame:GetText() end
			end)
			local separatorInput = CreateFrame("EditBox", "BCM_PlayerSeparator", BCM_PlayerNames, "InputBoxTemplate")
			separatorInput:SetPoint("TOPLEFT", 96, -260)
			separatorInput:SetAutoFocus(false)
			separatorInput:SetWidth(20)
			separatorInput:SetHeight(20)
			separatorInput:SetJustifyH("CENTER")
			separatorInput:SetScript("OnTextChanged", function(frame, changed)
				if changed then bcmDB.playerSeparator = frame:GetText() end
			end)
		end
	end

	--[[ Resize ]]--
	makePanel("BCM_Resize", bcm, "Resize")

	--[[ Scroll Down ]]--
	makePanel("BCM_ScrollDown", bcm, "Scroll Down")

	--[[ Sticky ]]--
	makePanel("BCM_Sticky", bcm, "Sticky")

	if not bcmDB.BCM_Sticky then
		local sticky = CreateFrame("Frame", "BCM_Sticky_Drop", BCM_Sticky, "UIDropDownMenuTemplate")
		sticky:SetPoint("TOPLEFT", 16, -140)
		BCM_Sticky_DropText:SetText(GUILD_NEWS_MAKE_STICKY)
		UIDropDownMenu_Initialize(sticky, function()
			local selected, info = BCM_Sticky_DropText:GetText(), UIDropDownMenu_CreateInfo()
			info.func = function(v) BCM_Sticky_DropText:SetText(v:GetText())
				local btn = BCM_Sticky_Button
				btn:Enable()
				if ChatTypeInfo[v.value].sticky > 0 then
					btn:SetChecked(true)
				else
					btn:SetChecked(false)
				end
				btn.value = v.value
			end
			local tbl = {"SAY", "PARTY", "RAID", "GUILD", "OFFICER", "YELL", "WHISPER", "BN_WHISPER", "BN_CONVERSATION", "EMOTE", "RAID_WARNING", "BATTLEGROUND", "CHANNEL"}
			for i=1, #tbl do
				info.text = _G[tbl[i]]
				info.value = tbl[i]
				info.checked = info.text == selected
				UIDropDownMenu_AddButton(info)
				tbl[i] = nil
			end
			tbl = nil
		end)

		local stickyBtn = CreateFrame("CheckButton", "BCM_Sticky_Button", BCM_Sticky, "OptionsBaseCheckButtonTemplate")
		stickyBtn:SetScript("OnClick", function(frame)
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				ChatTypeInfo[frame.value].sticky = 1
				bcmDB.sticky[frame.value] = 1
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				ChatTypeInfo[frame.value].sticky = 0
				bcmDB.sticky[frame.value] = 0
			end
		end)
		stickyBtn:Disable()
		stickyBtn:SetPoint("LEFT", sticky, "RIGHT", 225, 0)
		local stickyBtnText = stickyBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stickyBtnText:SetPoint("RIGHT", stickyBtn, "LEFT")
		stickyBtnText:SetText(GUILD_NEWS_MAKE_STICKY)
	end

	--[[ Tell Target ]]--
	makePanel("BCM_TellTarget", bcm, "Tell Target")

	--[[ Timestamp Customize ]]--
	makePanel("BCM_Timestamp", bcm, "Timestamp")

	if not bcmDB.BCM_Timestamp then
		local stampBtn = CreateFrame("CheckButton", "BCM_TimestampColor_Button", BCM_Timestamp, "OptionsBaseCheckButtonTemplate")
		stampBtn:SetScript("OnClick", function(frame)
			local input = BCM_Timestamp_InputCol
			if frame:GetChecked() then
				PlaySound("igMainMenuOptionCheckBoxOn")
				bcmDB.stampcolor = "|cff777777"
				input:SetText("777777")
				input:EnableMouse(true)
			else
				PlaySound("igMainMenuOptionCheckBoxOff")
				bcmDB.stampcolor = ""
				input:SetText("")
				input:EnableMouse(false)
				input:ClearFocus()
			end
		end)
		stampBtn:SetPoint("TOPLEFT", 16, -140)
		stampBtn:SetHitRectInsets(0, -50, 0, 0)
		local stampBtnText = stampBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampBtnText:SetPoint("LEFT", stampBtn, "RIGHT")
		stampBtnText:SetText(COLOR)

		local stampColInput = CreateFrame("EditBox", "BCM_Timestamp_InputCol", BCM_Timestamp, "InputBoxTemplate")
		stampColInput:SetPoint("LEFT", stampBtn, "RIGHT", 60, 0)
		stampColInput:SetAutoFocus(false)
		stampColInput:SetWidth(50)
		stampColInput:SetHeight(20)
		stampColInput:SetMaxLetters(6)
		stampColInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				local txt = frame:GetText()
				if txt:find("%X") then frame:SetText((bcmDB.stampcolor):sub(5)) return end
				bcmDB.stampcolor = "|cff"..txt
			end
		end)
		local stampColInputText = stampColInput:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampColInputText:SetPoint("LEFT", stampColInput, "RIGHT", 10, 0)
		stampColInputText:SetText(">>>   http://bit.ly/bevPp")

		local stampFormatTitle = BCM_Timestamp:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		stampFormatTitle:SetPoint("TOPLEFT", 20, -190)
		stampFormatTitle:SetText(FORMATTING..":")
		local stampFormatText = BCM_Timestamp:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		stampFormatText:SetPoint("TOPLEFT", 20, -210)
		stampFormatText:SetText("%p == "..TIMEMANAGER_AM.."/"..TIMEMANAGER_PM.."\n%S == "..gsub(D_SECONDS, ".*:(.*);$", "%1").."\n%M == "..gsub(D_MINUTES, ".*:(.*);$", "%1").."\n%I == "..AUCTION_DURATION_ONE.."\n%H == "..AUCTION_DURATION_TWO)
		local stampBrackInput = CreateFrame("EditBox", "BCM_Timestamp_Format", BCM_Timestamp, "InputBoxTemplate")
		stampBrackInput:SetPoint("TOPLEFT", 25, -280)
		stampBrackInput:SetAutoFocus(false)
		stampBrackInput:SetWidth(100)
		stampBrackInput:SetHeight(20)
		stampBrackInput:SetScript("OnTextChanged", function(frame, changed)
			if changed then
				bcmDB.stampformat = frame:GetText()
			end
		end)
	end

	--[[ URLCopy ]]--
	makePanel("BCM_URLCopy", bcm, "URL Copy")

	makePanel = nil
end

