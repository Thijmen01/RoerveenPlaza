ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Wait(5)
        if ESX ~= nil then

        else
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
        end
    end
end)

-- Alle blips die altijd zichtbaar zijn

local blip = AddBlipForCoord(Config.MediaPlaza.x, Config.MediaPlaza.y, Config.MediaPlaza.z)

SetBlipSprite(blip, 124)
SetBlipDisplay(blip, 4)
SetBlipScale(blip, 0.8)
SetBlipColour(blip, 70)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("MediaPlaza")
EndTextCommandSetBlipName(blip)

local blip2 = AddBlipForCoord(2740.99, 3476.72, 55.67)

SetBlipSprite(blip2, 85)
SetBlipDisplay(blip2, 4)
SetBlipScale(blip2, 1.0)
SetBlipColour(blip2, 43)
SetBlipAsShortRange(blip2, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Distributiecentrum")
EndTextCommandSetBlipName(blip2)

local boxes = math.random(1, 2)
local boxesDone = 0
local boxDeliverd = true
local boxPicked = true

-- Laat een baas staan in MediaPlaza

Citizen.CreateThread(function()
    local model = 'a_m_m_prolhost_01'
    local pedtypes = 1
    local pedcreated = false

    while true do
        Citizen.Wait(7)
        if not pedcreated then
            while not HasModelLoaded(GetHashKey(model)) do
                RequestModel(GetHashKey(model))
                Wait(7)
            end
            MediaBoss = CreatePed(4, "a_m_m_prolhost_01", Config.PedMedia.x, Config.PedMedia.y, Config.PedMedia.z,
                Config.PedMedia.h, false, true)

            FreezeEntityPosition(MediaBoss, true)
            pedcreated = true
        end

    end
end)

-- Eerste Marker waarbij je het script activeert

Citizen.CreateThread(function()
    local ped = GetPlayerPed(-1)
    local marker = true
    local ArrowHeight = Config.PedMedia.z + 2.2
    while true do

        Citizen.Wait(0)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local isInMarker = false

        if marker then
            DrawMarker(2, Config.PedMedia.x, Config.PedMedia.y, ArrowHeight, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 200, 30,
                40, 70, true, true, 2) -- Marker Begin
            if Vdist(Config.PedMedia.x, Config.PedMedia.y, Config.PedMedia.z, playerCoords.x, playerCoords.y,
                playerCoords.z) < 1.5 then
                isInMarker = true
            end

            if isInMarker and marker then
                ESX.ShowHelpNotification("Druk op ~INPUT_PICKUP~ om te beginnen.")
                if IsControlJustPressed(0, 38) then
                    marker = false
                    marker2 = true
                    ESX.ShowNotification("Ik: Hey baas heb je een klus voor me?", true, true, 80)
                    Citizen.Wait(1000)
                    ESX.ShowNotification(
                        "Baas: Ja, goed dat je gekomen bent loop naar de kamer hiernaast en kleed je om.", true, true,
                        80)
                end
            end
        end
    end
end)

-- Tweede Marker uit het script waarbij je je omkleed

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local isInMarker = false
        if marker2 then
            DrawMarker(2, Config.Clothes.x, Config.Clothes.y, Config.Clothes.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 200,
                30, 40, 70, true, true, 2) -- Marker Begin
            if Vdist(Config.Clothes.x, Config.Clothes.y, Config.Clothes.z, playerCoords.x, playerCoords.y,
                playerCoords.z) < 2 then
                isInMarker = true
            end

            if isInMarker and marker2 then
                ESX.ShowHelpNotification("Druk op ~INPUT_PICKUP~ om je bedrijfskleding aan te doen.")
                if IsControlJustPressed(0, 38) then -- E Key
                    marker2 = false
                    marker3 = true

                    for k, v in pairs(Config.Outfit) do
                        SetPedComponentVariation(ped, k, v.drawables, v.texture, 1)
                    end 

                    TriggerEvent("rv_plaza:ClothingDone")
                    TriggerEvent("rv_plaza:BossDelete")

                end
            end
        end
    end
end)

-- Creeert een Marker waar je het voertuig spawned dmv een Event

Citizen.CreateThread(function()
    local vehicleName = 'mule'
    route = false
    while true do

        Citizen.Wait(0)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local isInMarker = false

        if marker3 then
            DrawMarker(2, Config.Vehicle.x, Config.Vehicle.y, Config.Vehicle.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 200,
                30, 40, 70, true, true, 2) -- Marker Begin
            if Vdist(Config.Vehicle.x, Config.Vehicle.y, Config.Vehicle.z, playerCoords.x, playerCoords.y,
                playerCoords.z) < 2 then

                ESX.ShowHelpNotification("Druk op ~INPUT_PICKUP~ om je vrachtwagen te pakken.")
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("rv_plaza:SpawnVehicle") 
                    TriggerEvent("rv_plaza:SpawnVehicleMessage")
                    
                    blipdrawn = false
                    marker3 = false
                    route = true

                    TriggerEvent("rv_plaza:BlipParking")
                    
                end
            end
        end
    end
end)

-- Marker voor ontvangst bij distributiecentrum

Citizen.CreateThread(function()
    Message = false
   
    while true do
        Citizen.Wait(0)
        if route then
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)

            if not ParkingDone then
            DrawMarker(2, Config.Parking.x, Config.Parking.y, Config.Parking.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 200,
                30, 40, 70, true, true, 2)

                if Vdist(Config.Parking.x, Config.Parking.y, Config.Parking.z, playerCoords.x, playerCoords.y,
                    playerCoords.z) < 2 then
                    RemoveBlip(deliveryblip)
                    SetBlipRoute(deliveryblip, false)

                    TriggerEvent("rv_plaza:Destination")
                    TriggerEvent("rv_plaza:FreezeVehicle", try)
                    TriggerEvent("rv_plaza:Props")

                
                    boxPicked = false
                    ParkingDone = true
                end
            end
        end
    end
end)

-- Waar je je dozen kan oppaken

Citizen.CreateThread(function()
    local startdelivery = false

    while true do
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        Citizen.Wait(0)

        if not boxPicked then

            DrawMarker(2, Config.PropsMarker.x, Config.PropsMarker.y, Config.PropsMarker.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 200, 30, 40, 70, true, true, 2)
            if Vdist(Config.Props.x, Config.Props.y, Config.Props.z, playerCoords.x, playerCoords.y, playerCoords.z) < 2 then
                ESX.ShowHelpNotification("Druk op ~INPUT_PICKUP~ om de doos op te pakken.")
                if IsControlJustPressed(0, 38) then
                    ExecuteCommand("e wave")

                    ESX.ShowNotification("Je hebt de doos opgepakt je moet nog ~b~" .. boxes - boxesDone - 1 .. "~w~ dozen.")
                    Citizen.Wait(1000)

                    boxPicked = true
                    boxDeliverd = false
                    startdelivery = false
                end
            end

        end
    end
end)

-- Locatie van de vrachtwagen waar je je dozen in stopt.

Citizen.CreateThread(function()
    ped = PlayerPedId()
    while true do
        Citizen.Wait(0)
        CurrentVehicle = GetVehiclePedIsIn(ped, true)
        local offPos = GetOffsetFromEntityInWorldCoords(CurrentVehicle, 0.0, -5.0, 0.5)
        local playerCoords = GetEntityCoords(ped)

        if not boxDeliverd then
            DrawMarker(2, offPos.x, offPos.y, offPos.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 10, 200, 100, 70, true, true, 2, nil, nil, false)
            if Vdist(offPos.x, offPos.y, offPos.z, playerCoords.x, playerCoords.y, playerCoords.z) < 2 then
                ESX.ShowHelpNotification("Druk op ~INPUT_PICKUP~ om de doos in de vrachtwagen te leggen.")
                if IsControlJustPressed(0, 38) then
                    boxesDone = boxesDone + 1
                    ESX.ShowNotification("Er liggen nu~b~ " .. boxesDone .. " ~w~dozen in je vrachtwagen.")
                    Citizen.Wait(1000)
                    boxDeliverd = true
                    boxPicked = false
                end
            end
        end
    end
end)

-- Functie die bekijkt of je alles hebt gedaan zoja unfreezed die het voertuig kan je weg.

Citizen.CreateThread(function()
    messageSend = false
    madeblip = false
    ArrivedHome = true
    local messagehasbeensend = false
    local unLoadBoxes = true

    while true do
    Citizen.Wait(0)
        if boxesDone == boxes then
            StartDelivery = true
            boxes = nil
        end

        if StartDelivery then
            local vehicle = GetVehiclePedIsIn(ped, false)
            FreezeEntityPosition(CurrentVehicle, false)
           
            TriggerEvent("rv_plaza:BoxesFull")
            TriggerEvent("rv_plaza:BlipHome")
            ArrivedHome = false
            StartDelivery = false
        end
    end
end)

-- Opvangen van de vrachtwagen bij MediaPlaza

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        if not ArrivedHome then
        DrawMarker(2, Config.MediaParking.x, Config.MediaParking.y, Config.MediaParking.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 10, 200, 100, 70, true, true, 2, nil, nil, false)
        if Vdist(Config.MediaParking.x, Config.MediaParking.y, Config.MediaParking.z, playerCoords.x, playerCoords.y, playerCoords.z) < 2 then
            ESX.ShowHelpNotification("Druk op ~INPUT_PICKUP~ om je vrachtwagen te verwijderen")
            if IsControlJustPressed(0, 38) then
            TriggerEvent("rv_plaza:DeleteVehicle")
            TriggerEvent("rv_plaza:ArrivedHome")
            ArrivedHome = true
                end
            end
        end
    end
end)

-- Functie om je kleding te herstellen.

function LoadDefaultPlayerSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

-- Betaling Event hiermee krijg je betaald en rond je het script af.

RegisterNetEvent("rv_plaza:ArrivedHome")
AddEventHandler("rv_plaza:ArrivedHome", function()
    local ped = PlayerPedId()
    LoadDefaultPlayerSkin()
    ESX.ShowNotification("Bedankt voor je inzet! De baas heeft nog wat geld voor je!", true, false, 80)
    Citizen.Wait(1000)
    TriggerServerEvent("rv_plaza:Payment")
end)

-- Geeft een bericht aan als je alles in de vrachtwagen hebt ingeladen.

RegisterNetEvent("rv_plaza:BoxesFull")
AddEventHandler("rv_plaza:BoxesFull", function()
        ESX.ShowNotification("~g~Dat waren alle dozen stap in het voertuig en rijd terug naar ~y~MediaPlaza.", true, false, 80)
        boxDeliverd = true
        boxPicked = true	
end)

-- Standaard bericht voor TP komen van Distributiecentrum

RegisterNetEvent("rv_plaza:Destination")
AddEventHandler("rv_plaza:Destination", function()
    ESX.ShowNotification("Stap uit het voertuig en haal de vracht op uit de Ikea", true, true, 80)

end)

-- Het verwijderen van de NPC / Baas

RegisterNetEvent("rv_plaza:BossDelete")
AddEventHandler("rv_plaza:BossDelete", function()
    DeletePed(MediaBoss)
end)

-- Bericht voor wanneer jij je hebt omgekleed

RegisterNetEvent("rv_plaza:ClothingDone")
AddEventHandler("rv_plaza:ClothingDone", function()
        ESX.ShowNotification("Die outfit staat je goed! Loop naar buiten en pak de vrachtwagen.", true,
            true, 80)
end)

-- Alle Blips die een trigger nodig hadden

RegisterNetEvent("rv_plaza:BlipHome")
AddEventHandler("rv_plaza:BlipHome",function()
    local mediadelivery = AddBlipForCoord(Config.MediaParking.x, Config.MediaParking.y, Config.MediaParking.z)
    SetBlipSprite(mediadelivery, 2)
    SetBlipDisplay(mediadelivery, 4)
    SetBlipScale(mediadelivery, 0.8)
    SetBlipColour(mediadelivery, 5)
    SetBlipAsShortRange(mediadelivery, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Parkeerplaats")
    EndTextCommandSetBlipName(mediadelivery)

    SetBlipRoute(mediadelivery, true)
end)

RegisterNetEvent("rv_plaza:BlipParking")
AddEventHandler("rv_plaza:BlipParking", function(blipmaking)
    deliveryblip = AddBlipForCoord(Config.Parking.x, Config.Parking.y, Config.Parking.z)
    SetBlipSprite(deliveryblip, 0)
    SetBlipDisplay(deliveryblip, 4)
    SetBlipScale(deliveryblip, 0.8)
    SetBlipColour(deliveryblip, 70)
    SetBlipAsShortRange(deliveryblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Parkeerplaats")
    EndTextCommandSetBlipName(deliveryblip)

    SetBlipRoute(deliveryblip, true)

    ESX.ShowNotification("Rijd naar de aangegeven marker", true, true, 80)
end)

-- Event om jou voertuig te spawnen.

RegisterNetEvent("rv_plaza:SpawnVehicle")
AddEventHandler("rv_plaza:SpawnVehicle", function()
    local ped = PlayerPedId()
    local vehicleName = 'mule'

    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Citizen.Wait(500)
    end

    local truck = CreateVehicle(vehicleName, Config.SpawnVehicle.x, Config.SpawnVehicle.y,
        Config.SpawnVehicle.z, 221.1, true, false)

    SetPedIntoVehicle(ped, truck, -1)

end)

-- Spawned props in in Distributiecentrum

RegisterNetEvent("rv_plaza:Props")
AddEventHandler("rv_plaza:Props", function()
    local hash = 3504117558
    local boxes = CreateObject(hash, Config.Props.x, Config.Props.y, Config.Props.z, false, false, false)

    FreezeEntityPosition(boxes, true)
end)

-- Het Freeze van een voertuig

RegisterNetEvent("rv_plaza:FreezeVehicle")
AddEventHandler("rv_plaza:FreezeVehicle", function()
    ped = PlayerPedId()
    lastVehicle = GetVehiclePedIsIn(ped, true)
    FreezeEntityPosition(lastVehicle, true)
end)

-- Het verwijderen van het voertuig.

RegisterNetEvent("rv_plaza:DeleteVehicle")
AddEventHandler("rv_plaza:DeleteVehicle", function()
    local ped = PlayerPedId()
    local CurrentVehicle = GetVehiclePedIsIn(ped, false)
    SetVehicleAsNoLongerNeeded(CurrentVehicle)
	DeleteEntity(CurrentVehicle)
end)