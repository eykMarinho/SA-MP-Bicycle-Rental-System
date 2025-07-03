/*
===============================================================================

    ███╗   ███╗ █████╗ ██████╗ ██╗███╗   ██╗██╗  ██╗ ██████╗ 
    ████╗ ████║██╔══██╗██╔══██╗██║████╗  ██║██║  ██║██╔═══██╗
    ██╔████╔██║███████║██████╔╝██║██╔██╗ ██║███████║██║   ██║
    ██║╚██╔╝██║██╔══██║██╔══██╗██║██║╚██╗██║██╔══██║██║   ██║
    ██║ ╚═╝ ██║██║  ██║██║  ██║██║██║ ╚████║██║  ██║╚██████╔╝
    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ 

    ╔══════════════════════════════════════════════════════════════════════╗
    ║                        RENT VEHICLE SYSTEM                           ║
    ║                                                                      ║
    ║  Desenvolvido por: MARINHO                                           ║
    ║                                                                      ║
    ║                                                                      ║
    ║                                                                      ║
    ║  GitHub: https://github.com/eykMarinho                               ║
    ║  YouTube: https://www.youtube.com/@eykMarinho                        ║
    ╚══════════════════════════════════════════════════════════════════════╝

===============================================================================
*/

#include <a_samp>
#include <streamer>
#include <Pawn.CMD>
#include <YSI_Data\y_iterate>

// ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██╗   ██╗███████╗██╗███████╗
// ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██║   ██║██╔════╝██║██╔════╝
// ██║   ██║███████║██████╔╝██║███████║██║   ██║█████╗  ██║███████╗
// ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║╚██╗ ██╔╝██╔══╝  ██║╚════██║
//  ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║ ╚████╔╝ ███████╗██║███████║
//   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝╚══════╝
//
#define RENT_LIMITS_POINTS      2
#define RENT_PRICE_PER_MINUTE   50
#define MAX_RENT_TIME           60      // minutos
#define RENT_PICKUP_MODEL       1239                  
#define RENT_MAPICON_MODEL      55  
#define RENT_VEHICLE_MODEL      509             
#define RENT_VEHICLE_COLOR_ID   3       //Vermelho           

enum E_RENT_VEHICLE {
    Float:rvPosX,
    Float:rvPosY,
    Float:rvPosZ,
    Float:rvPosA
}
static RentVehicles[RENT_LIMITS_POINTS][E_RENT_VEHICLE] = 
{
	{126.8853,-77.1170,1.5781},
	{140.7119,-80.0326,1.5781}
};

enum E_PLAYER_RENT {
    prRentedVehicle,
    prRentTime,
    prTotalCost,
    Text3D:prLabelVehicle
}
static PlayerRentData[MAX_PLAYERS][E_PLAYER_RENT];
new Iterator:yRentPlayer<MAX_PLAYERS>;


forward UpdateSystemRent();
main(){	}

// ============================================================================
//
//  ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗███████╗
//  ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝██╔════╝
//  ██████╔╝██║   ██║██████╔╝██║     ██║██║     ███████╗
//  ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║     ╚════██║
//  ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗███████║
//  ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝╚══════╝
//
// ============================================================================
public OnGameModeInit()
{
    RentLoadPoints();
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Inicializa os dados do jogador
    PlayerRentData[playerid][prRentedVehicle] = INVALID_VEHICLE_ID;
    PlayerRentData[playerid][prRentTime] = 0;
    PlayerRentData[playerid][prTotalCost] = 0;
    PlayerRentData[playerid][prLabelVehicle] = Text3D:INVALID_3DTEXT_ID;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerRenting(playerid)){
        RemovePlayerRenting(playerid);
    }
    return 1;
}
// ============================================================================
//
//   ██████╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗██████╗  ██████╗ ███████╗
//  ██╔════╝██╔═══██╗████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔═══██╗██╔════╝
//  ██║     ██║   ██║██╔████╔██║███████║██╔██╗ ██║██║  ██║██║   ██║███████╗
//  ██║     ██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║██║   ██║╚════██║
//  ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝╚██████╔╝███████║
//   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚══════╝
//
// ============================================================================
CMD:Alugar(playerid)
{
    if(IsPlayerRenting(playerid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você já está alugando uma bicicleta!");

    if(GetPlayerMoney(playerid) < RENT_PRICE_PER_MINUTE)
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você não possui dinheiro suficiente!");
    
    if(!IsPlayerInAluguel(playerid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você não está perto de um ponto de aluguel!");


    RentVehiclePlayer(playerid);
    return true;
}
CMD:Devolver(playerid)
{
    if(!IsPlayerRenting(playerid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você não está alugando uma bicicleta!");
    RemovePlayerRenting(playerid);
    return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você devolveu a bicicleta!");
}
// ============================================================================
//
//  ███████╗████████╗ ██████╗  ██████╗██╗  ██╗
//  ██╔════╝╚══██╔══╝██╔═══██╗██╔════╝██║ ██╔╝
//  ███████╗   ██║   ██║   ██║██║     █████╔╝ 
//  ╚════██║   ██║   ██║   ██║██║     ██╔═██╗ 
//  ███████║   ██║   ╚██████╔╝╚██████╗██║  ██╗
//  ╚══════╝   ╚═╝    ╚═════╝  ╚═════╝╚═╝  ╚═╝
//
// ============================================================================
stock IsPlayerInAluguel(playerid)
{
    for(new i = 0; i < RENT_LIMITS_POINTS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, RentVehicles[i][rvPosX], RentVehicles[i][rvPosY], RentVehicles[i][rvPosZ]))
            return true;
    }
    return false;

}
stock RentVehiclePlayer(playerid)
{
    Iter_Add(yRentPlayer, playerid);
    new Float:posX, Float:posY, Float:posZ;
    GetPlayerPos(playerid, posX, posY, posZ);
    new VehicleID = CreateVehicle(RENT_VEHICLE_MODEL, Float:posX, Float:posY, Float:posZ, Float:0.0, RENT_VEHICLE_COLOR_ID, RENT_VEHICLE_COLOR_ID, -1, -1);
    PutPlayerInVehicle(playerid, VehicleID, 0);
    PlayerRentData[playerid][prRentedVehicle] = VehicleID;
    PlayerRentData[playerid][prRentTime] = MAX_RENT_TIME;
    PlayerRentData[playerid][prTotalCost] = RENT_PRICE_PER_MINUTE;
    PlayerRentData[playerid][prLabelVehicle] = CreateDynamic3DTextLabel(".", -1, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, VehicleID, 0, 0, 0, -1, 11.0, -1);
    UpdateVehicleTextLabel(playerid);
    SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você alugou uma bicicleta");
    return true;
}
stock RentLoadPoints()
{
    for(new i = 0; i < RENT_LIMITS_POINTS; i++)
    {
        CreateDynamicPickup(RENT_PICKUP_MODEL, 23, RentVehicles[i][rvPosX], RentVehicles[i][rvPosY], RentVehicles[i][rvPosZ]);   
        CreateDynamicMapIcon(RentVehicles[i][rvPosX], RentVehicles[i][rvPosY], RentVehicles[i][rvPosZ], RENT_MAPICON_MODEL, -1, -1, -1, -1, 150.0, 1);
        CreateDynamic3DTextLabel("{ffffff}Aluguel de Bicicleta {6BBD59}(" #RENT_PRICE_PER_MINUTE "$)\n{ffffff}/Alugar", -1,RentVehicles[i][rvPosX],RentVehicles[i][rvPosY], RentVehicles[i][rvPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, STREAMER_3D_TEXT_LABEL_SD, -1, 0);
    }
    SetTimer(
        "UpdateSystemRent",
        1000 * 60,
        true
    );
    print("SISTEMA: O sistema de aluguel de bicicletas foi carregado com sucesso!");
    return 1;
}

stock IsPlayerRenting(playerid)
{
    return (!Iter_Contains(yRentPlayer, playerid) ? (false) : (true));
}
stock RemovePlayerRenting(playerid)
{
    if(!IsPlayerRenting(playerid))
        return false;

    Iter_Remove(yRentPlayer, playerid);
    DestroyVehicle(PlayerRentData[playerid][prRentedVehicle]);
    PlayerRentData[playerid][prRentedVehicle] = INVALID_VEHICLE_ID;
    PlayerRentData[playerid][prRentTime] = 0;
    PlayerRentData[playerid][prTotalCost] = 0;
    return true;
}
static stock UpdateVehicleTextLabel(playerid)
{
    if(!IsPlayerRenting(playerid))
        return false;

    static Str[80];
    format(Str, sizeof Str,"Veículo Alugado\n Tempo Restante: %d minuto(s)\n Custo Total: %d$", PlayerRentData[playerid][prRentTime], PlayerRentData[playerid][prTotalCost]);
    UpdateDynamic3DTextLabelText(PlayerRentData[playerid][prLabelVehicle],-1, Str);
    return true;
}
// ============================================================================
//
//   ██████╗ █████╗ ██╗     ██╗     ██████╗  █████╗  ██████╗██╗  ██╗
//  ██╔════╝██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
//  ██║     ███████║██║     ██║     ██████╔╝███████║██║     █████╔╝ 
//  ██║     ██╔══██║██║     ██║     ██╔══██╗██╔══██║██║     ██╔═██╗ 
//  ╚██████╗██║  ██║███████╗███████╗██████╔╝██║  ██║╚██████╗██║  ██╗
//   ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
//
// ============================================================================

public UpdateSystemRent()
{
    foreach(new p: yRentPlayer){
        --PlayerRentData[p][prRentTime];
        if(GetPlayerMoney(p) < RENT_PRICE_PER_MINUTE){
            SendClientMessage(p, 0xFFFFFFFF, "ALUGUEL: Você não possui dinheiro suficiente para pagar o aluguel!");
            RemovePlayerRenting(p);
            continue;
        }
        GivePlayerMoney(p, -RENT_PRICE_PER_MINUTE);
        PlayerRentData[p][prTotalCost] += RENT_PRICE_PER_MINUTE;
        if(PlayerRentData[p][prRentTime] == 0)
            RemovePlayerRenting(p);
        else
            UpdateVehicleTextLabel(p);
    }
    return true;
}

