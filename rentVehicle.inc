

/*

            ooo        ooooo       .o.       ooooooooo.   ooooo ooooo      ooo ooooo   ooooo   .oooooo.   
            `88.       .888'      .888.      `888   `Y88. `888' `888b.     `8' `888'   `888'  d8P'  `Y8b  
            888b     d'888      .8"888.      888   .d88'  888   8 `88b.    8   888     888  888      888 
            8 Y88. .P  888     .8' `888.     888ooo88P'   888   8   `88b.  8   888ooooo888  888      888 
            8  `888'   888    .88ooo8888.    888`88b.     888   8     `88b.8   888     888  888      888 
            8    Y     888   .8'     `888.   888  `88b.   888   8       `888   888     888  `88b    d88' 
            o8o        o888o o88o     o8888o o888o  o888o o888o o8o        `8  o888o   o888o  `Y8bood8P'  

*/

            // Includes
#include <a_samp>
#include <streamer>
#include <Pawn.CMD>
#include <YSI_Coding\y_data>
#include <YSI_Data\y_hooks>

            // Definers [Fake]
static const RENT_LIMITS_POINTS = 2;
static const RENT_PRICE_PER_MINUTE = 50;
static const MAX_RENT_TIME = 60;            // Minutos
static const RENT_PICKUP_MODEL = 1239;
static const RENT_MAPICON_MODEL = 55;
static const RENT_VEHICLE_MODEL = 509;
static const RENT_VEHICLE_COLOR_ID = 3;     // Vermelho

            // Forwards
forward UpdateSystemRent();

static enum E_VEHICLES_RENT {
    Float:E_VEHICLES_RENT_X,
    Float:E_VEHICLES_RENT_Y,
    Float:E_VEHICLES_RENT_Z,
    Float:E_VEHICLES_RENT_A
}

static enum E_PLAYER_RENT {
    E_PLAYER_RENT_VEHICLE,
    E_PLAYER_RENT_TIMER,
    E_PLAYER_RENT_COST,
    Text3D:E_PLAYER_RENT_TEXT3D
}
static 
    Iterator:PlayersRent<MAX_PLAYERS>,
    e_PlayerRent[MAX_PLAYERS][E_PLAYER_RENT];

static const 
    positionRent[RENT_LIMITS_POINTS][E_VEHICLES_RENT] = {
        {126.8853,-77.1170,1.5781},
        {140.7119,-80.0326,1.5781}
    };

hook OnGameModeInit() {
    RentLoadPoints();
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid) {
    
    static const e_Clear[E_PLAYER_RENT];
    e_PlayerRent[playerid] = e_Clear;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason) {

    if(IsPlayerRenting(playerid))
        RemovePlayerRenting(playerid);
    
    return Y_HOOKS_CONTINUE_RETURN_1;
}



/*

                    ooooooooo.   ooooo     ooo oooooooooo.  ooooo        ooooo   .oooooo.   
                    `888   `Y88. `888'     `8' `888'   `Y8b `888'        `888'  d8P'  `Y8b  
                    888   .d88'  888       8   888     888  888          888  888          
                    888ooo88P'   888       8   888oooo888'  888          888  888          
                    888          888       8   888    `88b  888          888  888          
                    888          `88.    .8'   888    .88P  888       o  888  `88b    ooo  
                    o888o           `YbodP'    o888bood8P'  o888ooooood8 o888o  `Y8bood8P'  

*/

public UpdateSystemRent() {

    foreach(new i: PlayersRent) {
        e_PlayerRent[i][E_PLAYER_RENT_TIMER]--;

        if(GetPlayerMoney(i) < RENT_PRICE_PER_MINUTE) {
            SendClientMessage(i, 0xFFFFFFFF, "ALUGUEL: Você não possui dinheiro suficiente para pagar o aluguel!");
            RemovePlayerRenting(i);
            continue;
        }

        GivePlayerMoney(i, -RENT_PRICE_PER_MINUTE);
        e_PlayerRent[i][E_PLAYER_RENT_COST] += RENT_PRICE_PER_MINUTE;

        if(e_PlayerRent[i][E_PLAYER_RENT_TIMER]) UpdateVehicleTextLabel(i);
        else RemovePlayerRenting(i);
    }
    return true;
}



/*

                    .oooooo..o ooooooooooooo   .oooooo.     .oooooo.   oooo    oooo  .oooooo..o 
                    d8P'    `Y8 8'   888   `8  d8P'  `Y8b   d8P'  `Y8b  `888   .8P'  d8P'    `Y8 
                    Y88bo.           888      888      888 888           888  d8'    Y88bo.      
                    `"Y8888o.       888      888      888 888           88888[       `"Y8888o.  
                        `"Y88b      888      888      888 888           888`88b.         `"Y88b 
                    oo     .d8P      888      `88b    d88' `88b    ooo   888  `88b.  oo     .d8P 
                    8""88888P'      o888o      `Y8bood8P'   `Y8bood8P'  o888o  o888o 8""88888P'  

*/

static stock IsPlayerInAluguel(playerid) {

    for(new i = 0; i < RENT_LIMITS_POINTS; i++)
        if(IsPlayerInRangeOfPoint(playerid, 2.0, positionRent[i][E_VEHICLES_RENT_X], positionRent[i][E_VEHICLES_RENT_Y], positionRent[i][E_VEHICLES_RENT_Z]))
            return true;
    
    return false;
}

static stock RentVehiclePlayer(playerid) {

    new 
        Float:posX, 
        Float:posY, 
        Float:posZ;

    GetPlayerPos(playerid, posX, posY, posZ);

    new VehicleID = CreateVehicle(RENT_VEHICLE_MODEL, Float:posX, Float:posY, Float:posZ, Float:0.0, RENT_VEHICLE_COLOR_ID, RENT_VEHICLE_COLOR_ID, -1, -1);
    PutPlayerInVehicle(playerid, VehicleID, 0);

    e_PlayerRent[playerid][E_PLAYER_RENT_VEHICLE] = VehicleID;
    e_PlayerRent[playerid][E_PLAYER_RENT_TIMER] = MAX_RENT_TIME;
    e_PlayerRent[playerid][E_PLAYER_RENT_COST] = RENT_PRICE_PER_MINUTE;
    e_PlayerRent[playerid][E_PLAYER_RENT_TEXT3D] = CreateDynamic3DTextLabel(".", -1, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, VehicleID, 0, 0, 0, -1, 11.0, -1);

    UpdateVehicleTextLabel(playerid);
    SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você alugou uma bicicleta");

    Iter_Add(PlayersRent, playerid);
    return;
}

static stock RemovePlayerRenting(playerid) {

    if(!IsPlayerRenting(playerid))
        return;

    Iter_Remove(PlayersRent, playerid);
    DestroyVehicle(e_PlayerRent[playerid][E_PLAYER_RENT_VEHICLE]);
    e_PlayerRent[playerid][E_PLAYER_RENT_VEHICLE] = INVALID_VEHICLE_ID;
    e_PlayerRent[playerid][E_PLAYER_RENT_TIMER] = 0;
    e_PlayerRent[playerid][E_PLAYER_RENT_COST] = 0;
    return;
}

static stock UpdateVehicleTextLabel(playerid) {

    if(!IsPlayerRenting(playerid))
        return;

    new string[80];
    strcat(string, "Veículo Alugado\n");
    strcat(string, va_return("Tempo Restante: %d minuto(s)\n", e_PlayerRent[playerid][E_PLAYER_RENT_TIMER]));
    strcat(string, va_return("Custo Total: %d$", e_PlayerRent[playerid][E_PLAYER_RENT_COST]));
    UpdateDynamic3DTextLabelText(e_PlayerRent[playerid][E_PLAYER_RENT_TEXT3D], -1, string);
    return;
}

static stock RentLoadPoints() {

    for(new i = 0; i < RENT_LIMITS_POINTS; i++) {
        CreateDynamicPickup(RENT_PICKUP_MODEL, 23, positionRent[i][E_VEHICLES_RENT_X], positionRent[i][E_VEHICLES_RENT_Y], positionRent[i][E_VEHICLES_RENT_Z]);   
        CreateDynamicMapIcon(positionRent[i][E_VEHICLES_RENT_X], positionRent[i][E_VEHICLES_RENT_Y], positionRent[i][E_VEHICLES_RENT_Z], RENT_MAPICON_MODEL, -1, -1, -1, -1, 150.0, 1);
        CreateDynamic3DTextLabel("{ffffff}Aluguel de Bicicleta {6BBD59}(" #RENT_PRICE_PER_MINUTE "$)\n{ffffff}/Alugar", -1,positionRent[i][E_VEHICLES_RENT_X],positionRent[i][E_VEHICLES_RENT_Y], positionRent[i][E_VEHICLES_RENT_Z], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, STREAMER_3D_TEXT_LABEL_SD, -1, 0);
    }

    SetTimer("UpdateSystemRent", 1000 * 60, true);
    print("SISTEMA: O sistema de aluguel de bicicletas foi carregado com sucesso!");
}

static stock IsPlayerRenting(playerid)
    return (!Iter_Contains(PlayersRent, playerid) ? (false) : (true));



/*

                    .oooooo.     .oooooo.   ooo        ooooo       .o.       ooooo      ooo oooooooooo.     .oooooo.    .oooooo..o 
                    d8P'  `Y8b   d8P'  `Y8b  `88.       .888'      .888.      `888b.     `8' `888'   `Y8b   d8P'  `Y8b  d8P'    `Y8 
                    888          888      888  888b     d'888      .8"888.      8 `88b.    8   888      888 888      888 Y88bo.      
                    888          888      888  8 Y88. .P  888     .8' `888.     8   `88b.  8   888      888 888      888  `"Y8888o.  
                    888          888      888  8  `888'   888    .88ooo8888.    8     `88b.8   888      888 888      888      `"Y88b 
                    `88b    ooo  `88b    d88'  8    Y     888   .8'     `888.   8       `888   888     d88' `88b    d88' oo     .d8P 
                    `Y8bood8P'   `Y8bood8P'  o8o        o888o o88o     o8888o o8o        `8  o888bood8P'    `Y8bood8P'  8""88888P'  

*/

CMD:alugar(playerid) {

    if(IsPlayerRenting(playerid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você já está alugando uma bicicleta!");

    if(GetPlayerMoney(playerid) < RENT_PRICE_PER_MINUTE)
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você não possui dinheiro suficiente!");
    
    if(!IsPlayerInAluguel(playerid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você não está perto de um ponto de aluguel!");

    RentVehiclePlayer(playerid);
    return true;
}

CMD:devolver(playerid) {

    if(!IsPlayerRenting(playerid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você não está alugando uma bicicleta!");

    RemovePlayerRenting(playerid);
    SendClientMessage(playerid, 0xFFFFFFFF, "ALUGUEL: Você devolveu a bicicleta!");
    return true;
}
