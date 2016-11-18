#include <sourcemod>
#include <cstrike>
#include <clientprefs>
#include "include/retakes.inc"
#include "retakes/generic.sp"

#pragma semicolon 1
#pragma newdecls required

#include "ziksallocator/defines.sp"
#include "ziksallocator/types.sp"
#include "ziksallocator/config.sp"
#include "ziksallocator/helpers.sp"
#include "ziksallocator/weapons.sp"
#include "ziksallocator/grenades.sp"
#include "ziksallocator/loadouts.sp"
#include "ziksallocator/preferences.sp"
#include "ziksallocator/persistence.sp"
#include "ziksallocator/allocator.sp"
#include "ziksallocator/menus.sp"

public Plugin myinfo =
{
    name = "CS:GO Retakes: ziks.net weapon allocator",
    author = "Ziks",
    description = "A more complex weapon allocator with extra configurable preferences.",
    version = PLUGIN_VERSION,
    url = "https://github.com/Metapyziks/retakes-ziksallocator"
};

/**
 * Called when the plugin is fully initialized and all known external
 * references are resolved.
 *
 * @noreturn
 */
public void OnPluginStart()
{
    SetupClientCookies();
    SetupConVars();
}

/**
 * Called once a client successfully connects.
 *
 * @param client    Client index.
 * @noreturn
 */
public void OnClientConnected( int client )
{
    ResetAllLoadouts( client );
    InvalidateLoadedCookies( client );
}

/**
 * Called when a client issues a command to bring up a "guns" menu.
 *
 * @param client    Client index.
 * @noreturn
 */
public void Retakes_OnGunsCommand( int client )
{
    CheckForSavedLoadouts( client );
    GiveMainMenu( client );
}

/**
 * Called when player weapons are being allocated for the round.
 *
 * @param tPlayers  An ArrayList of the players on the terrorist team.
 * @param ctPlayers An ArrayList of the players on the counter-terrorist team.
 * @param bombsite
 * @noreturn
 */
public void Retakes_OnWeaponsAllocated( ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite )
{
    int tCount = GetArraySize( tPlayers );
    int ctCount = GetArraySize( ctPlayers );

    for ( int i = 0; i < tCount; i++ )
    {
        int client = GetArrayCell( tPlayers, i );
        CheckForSavedLoadouts( client );
    }
    
    for ( int i = 0; i < ctCount; i++ )
    {
        int client = GetArrayCell( ctPlayers, i );
        CheckForSavedLoadouts( client );
    }

    WeaponAllocator( tPlayers, ctPlayers, bombsite );
}