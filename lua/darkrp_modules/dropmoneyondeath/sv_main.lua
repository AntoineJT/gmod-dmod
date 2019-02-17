/*
(c) Copyright October 2017, AntoineJT. All rights reserved.
Reworked on July 2018.
DON'T MODIFY ANYTHING !
v. 1.2.0
*/

-- Loads Config
include("config.lua")

-- CONSTANTS
local module_prefix = "[DMOD] "
local module_version = "1.1.0"

-- 
function defaultValues()
	local dropMoneyPercentage = 50
	local deathMessage = "You've lost " .. dropMoneyPercentage .. "% of your wallet money !"
	local deathWithoutMoneyMessage = "You've lost nothing because you've nothing to lose !"
	local resetNegativeMoneyMessage = "You're wallet glitch has been removed ! Sorry for the inconvenience !"
end

function logConsole(text)
	Msg(module_prefix .. tostring(text) .. "\n")
end

function initialization()
	logConsole("Starting Drop Money On Death (DMOD) Module...")
	logConsole("(c) October 2017, AntoineJT")
	logConsole("DMOD module version: " .. module_version)
	
	logConsole("Loading config...")
	--Content of the archaic loadVars function
	if (!isCustomizationEnabled) then
		logConsole("Customization is not enabled !")
		logConsole("Loading default values...")
		defaultValues()
		logConsole("Loading complete !")
	else
		logConsole("Customization is enabled !")
		logConsole("DMOD will use your custom values")
	end
	
end
hook.Add("loadCustomDarkRPItems", "Use to log into server console", initialization)

function dropMoneyOnDeath( victim, weapon, killer )
	if ( IsValid( victim ) ) then
		local victimMoney = victim:getDarkRPVar("money")
		
		if (victimMoney > 0) then
			local moneyToDrop = victimMoney*(dropMoneyPercentage/100)
			victim:addMoney(-moneyToDrop)
		
			local trace = {}
			trace.start = victim:EyePos()
			trace.endpos = trace.start + victim:GetAimVector() * 85
			trace.filter = victim

			local tr = util.TraceLine(trace)
			local moneybag = DarkRP.createMoneyBag(tr.HitPos, moneyToDrop)
			hook.Call("playerDroppedMoney", nil, victim, moneyToDrop, moneybag)
			victim:PrintMessage(HUD_PRINTCENTER, deathMessage)
		elseif (victimMoney == 0) then
			victim:PrintMessage(HUD_PRINTCENTER, deathWithoutMoneyMessage)
		elseif (victimMoney < 0) then
			victim:addMoney(-victimMoney)
			victim:PrintMessage(HUD_PRINTTALK, module_prefix .. resetNegativeMoneyMessage)
		end
    end
end
hook.Add("PlayerDeath", "Drop some money when you die", dropMoneyOnDeath)
