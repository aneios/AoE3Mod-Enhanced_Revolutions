//==============================================================================
/* age3zhb11p06.xs

	Player 6, Southern Spanish Army (Purple).

   Create a new loader file for each personality.  Always specify loader
   file names (not the main or header files) in scenarios.
*/
//==============================================================================



include "aiHeader.xs";     // Gets global vars, function forward declarations
include "aiMain.xs";       // The bulk of the AI



//==============================================================================
/*	preInit()

	This function is called in main() before any of the normal initialization 
	happens.  Use it to override default values of variables as needed for 
	personality or scenario effects.
*/
//==============================================================================
void preInit(void)
{
   aiEcho("preInit() starting.");
   
	btRushBoom = -0.6;
	btOffenseDefense = 0.7;
   
	btBiasCav = 0.7;
	btBiasArt = -0.6;
	btBiasInf = 0.4;  
   
	cvOkToTrainNavy = false;
	cvOkToTaunt = false;
	cvOkToChat = false;
	cvOkToAllyNatives = false;
	cvOkToResign = false;
	cvMaxAge = cAge5;
	cvPlayerToAttack = 2;
	
	cvMaxCivPop = 16;
	cvCreateBaseAttackRoute = [](int targetPlayerID = -1, int targetBaseID = -1) -> int
	{
		// only override the attack route when we are attacking P2.
		if (targetPlayerID != 2)
			return(-1);
		vector startPoint = vector(68.0, 0.0, 85.0);
		vector targetPoint = kbBaseGetLocation(targetPlayerID, targetBaseID);
		int routeID = kbCreateAttackRouteWithPath("Route P2: "+targetBaseID, startPoint, targetPoint);
		int pathID = kbPathCreate("Path P2:"+targetBaseID);

		kbPathAddWaypoint(pathID, startPoint);
		kbPathAddWaypoint(pathID, targetPoint);

		kbAttackRouteAddPath(routeID, pathID);
		return(routeID);
	};
}




//==============================================================================
/*	postInit()

	This function is called in main() after the normal initialization is 
	complete.  Use it to override settings and decisions made by the startup logic.
*/
//==============================================================================
void postInit(void)
{
   aiEcho("postInit() starting.");
}




//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================