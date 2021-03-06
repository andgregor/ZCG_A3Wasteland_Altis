//	@file Name: c_setupPlayerDB.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

fn_requestPlayerData = compileFinal "requestPlayerData = player; publicVariableServer 'requestPlayerData'";
fn_requestDonatorData = compileFinal "requestDonatorData = player; publicVariableServer 'requestDonatorData'";
fn_deletePlayerData = compileFinal "deletePlayerData = player; publicVariableServer 'deletePlayerData'";
fn_applyPlayerData = "persistence\players\c_applyPlayerData.sqf" call mf_compile;
fn_applyDonatorData = "persistence\players\c_applyDonatorData.sqf" call mf_compile;
fn_savePlayerData = "persistence\players\c_savePlayerData.sqf" call mf_compile;

"applyPlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_data = _this select 1;
		
		if (count _data > 0) then
		{
			
			_pos = [_data, "Position", []] call BIS_fnc_getFromPairs;
			
			if (count _pos > 2) then
			{
				player groupChat "Preloading location...";
				waitUntil {sleep 0.1; preloadCamera _pos};
			};
			
			_data call fn_applyPlayerData;
			
			player globalChat "Player account loaded!";
			
			//fixes the issue with saved player being GOD when they log back on the server!
			player allowDamage true;
			
			playerData_alive = true;
			
			execVM "client\functions\firstSpawn.sqf";
		};
		
		playerData_loaded = true;
	};
};

"applyDonatorData" addPublicVariableEventHandler
{
	_this spawn
	{
		_data = _this select 1;
		
		if (count _data > 0) then
		{
			playerData_isDonator = true;
			
			_data call fn_applyDonatorData;
			
			player groupChat "Donator data loaded!";
		};
		
		donatorData_loaded = true;
	};
};

"confirmSave" addPublicVariableEventHandler 
{
	if( _this select 1) then {
		cutText ["\nPlayer Saved", "PLAIN DOWN", 0.2];
	};
	player setVariable ["IsSaving", false, true];
};
