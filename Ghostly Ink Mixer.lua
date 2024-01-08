--[[

Title: Ghostly Ink Mixer V1.02
Description: Mixes ghostly ink, uses whatever necroplasm you set in first slot of inventory. Stops script when out of Materials of any kind.
Date: 1/08/2024
Author: Demoric
Instructions:
    Start at GE
    Set Materials to Preset 1:
        Necroplasm of choice
        13 Ashes
        13 Vial of Water 

Change Log:
V1.01 - Updated offsets.
V1.02 - Updated offsets.

IMPORTANT ----SET NECROPLASM TO FIRST SLOT IN INVENTORY----

Report any bugs in discord

]]

local API = require("api")

local ID = {

    Ashes = 592,
    VialofWater = 227,
    lesser = 55599,
    Banker = 3418,
}

local function bank()
    if API.PInArea(3163,20,3484,20) then
        API.DoAction_NPC(0x5,1488,{ ID.Banker },50);
        API.RandomSleep2(2000,1050,1000)
        if API.BankOpen2() then
            API.KeyboardPress32(0x31,0)
            API.RandomSleep2(2000,1050,1000)
            ::continue::
        else
            print("Reattempting Banking")
            bank()
        end
    else
        print("go to GE")
        API.Write_LoopyLoop(false)
    end
    ::continue::
    API.RandomSleep2(300,500,500)
end

API.Write_LoopyLoop(true)
while (API.Read_LoopyLoop()) do

    if API.InvItemcount_1(ID.Ashes) == 0 and API.InvItemcount_1(ID.VialofWater) == 0 then
        print("Getting Materials")
        bank()
    end

    Necroplasm = API.ScanForInterfaceTest2Get(false,{ { 1473,0,-1,-1,0 }, { 1473,2,-1,0,0 }, { 1473,5,-1,2,0 }, { 1473,5,0,5,0 } }) [1]
    API.RandomSleep2(2000,3050,4500)
    if (Necroplasm.itemid1 > 0 and Necroplasm.itemid1_size <= 19) or (Necroplasm.itemid1 < 0) then
        if API.InvItemcount_1(ID.Ashes) >=1 and API.InvItemcount_1(ID.VialofWater) >= 1 then
            print("Getting materials")
            bank()
        else
            print("No more NecroPlasm, Stopping Script")
            API.Write_LoopyLoop(false)
        end
    end

    if API.InvItemcount_1(ID.Ashes) >=1 and API.InvItemcount_1(ID.VialofWater) >= 1 then
        Necroplasm = API.ScanForInterfaceTest2Get(false,{ { 1473,0,-1,-1,0 }, { 1473,2,-1,0,0 }, { 1473,5,-1,2,0 }, { 1473,5,0,5,0 } }) [1]
        API.RandomSleep2(1000,1050,1500)
        if Necroplasm.itemid1 > 0 and Necroplasm.itemid1_size >= 20 then
            print("Mixing Ink")
            API.DoAction_Interface(0x3e,0xd92f,1,1473,5,0,3808)
            API.RandomSleep2(1000,1050,1500)
            API.KeyboardPress32(0x20,0)
            API.RandomSleep2(16000,1000,1050)
        else
            print("No more NecroPlasm, Stopping Script")
            API.Write_LoopyLoop(false)
        end
    elseif API.InvItemcount_1(ID.Ashes) == 0 and API.InvItemcount_1(ID.VialofWater) >= 1 then
        print("No more ashes, stopping Script")
        API.Write_LoopyLoop(false)
    elseif API.InvItemcount_1(ID.Ashes) >= 1 and API.InvItemcount_1(ID.VialofWater) == 0 then
        print("No more vial of water, stopping Script")
        API.Write_LoopyLoop(false)
    end
end
