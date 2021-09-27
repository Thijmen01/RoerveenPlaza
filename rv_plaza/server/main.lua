ESX = nil 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Het betalen van de speler voor zijn goede daad.

RegisterServerEvent("rv_plaza:Payment")
AddEventHandler("rv_plaza:Payment", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local Payment = math.random(150, 250)
		xPlayer.addAccountMoney('bank', Payment)
		TriggerClientEvent('esx:showNotification', source, "Je ontvingt ~b~€" .. Payment .. " ~w~van je baas")
end)