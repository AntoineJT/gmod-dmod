/*
(c) Copyright October 2017, AntoineJT. All rights reserved.
The only things you can modify are the local vars below.
Don't modify anything else !
v. 1.1.0
*/

/*
FRENCH Customization

local isCustomizationEnabled = false
local dropMoneyPercentage = 50
local deathMessage = "Vous avez perdu " .. dropMoneyPercentage .. "% de l'argent que vous aviez sur vous !"
local deathWithoutMoneyMessage = "Vous n'avez pas perdu d'argent car vous n'en aviez pas sur vous !"
local resetNegativeMoneyMessage = "Le bug de votre portefeuille a été réparé ! Veuillez nous excuser pour le dérangement !"

*/

local isCustomizationEnabled = false
local dropMoneyPercentage = 50
local deathMessage = "You've lost " .. dropMoneyPercentage .. "% of your wallet money !"
local deathWithoutMoneyMessage = "You've lost nothing because you've nothing to lose !"
local resetNegativeMoneyMessage = "You're wallet glitch has been removed ! Sorry for the inconvenience !"

-- DON'T MODIFY ANYTHING BELOW THIS LINE !!
local module_prefix = "[DMOD] "
local module_version = "1.1.0"

function defaultValues()
	dropMoneyPercentage = 50
	deathMessage = "You've lost " .. dropMoneyPercentage .. "% of your wallet money !"
	deathWithoutMoneyMessage = "You've lost nothing because you've nothing to lose !"
	resetNegativeMoneyMessage = "You're wallet glitch has been removed ! Sorry for the inconvenience !"
end

function logConsole(text)
	Msg(module_prefix .. tostring(text) .. "\n")
end

function initialization()
	logConsole("Starting Drop Money On Death (DMOD) Module...")
	logConsole("(c) October 2017, AntoineJT")
	logConsole("DMOD module version: " .. module_version)
	
	logConsole("Loading config...")
	-- Content of the archaic loadVars function
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

function dropMoneyOnDeath( victim, weapon, killer )
	if (IsValid(victim)) then
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
hook.Add("loadCustomDarkRPItems", "Use to log into server console", initialization)
