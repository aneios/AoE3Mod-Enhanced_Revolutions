//==============================================================================
/* age3zhb02p04.xs
   
   Player 4, Tatar enemy fortress, mostly defensive player that will launch mild attacks to the player later on. 

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
	cvMaxAge = cAge3;			// AI is capped at Age3.  
	cvOkToFortify = false;		// Will build outposts if he cnsiders necessary.
	cvOkToBuild = false;		// Won't build new buildings.
	cvOkToAttack = true;	    // Will launch some attacks
	cvOkToExplore = false;   
	cvOkToGatherNuggets = false;
	cvPlayerToAttack = 1;
	
    btBiasArt = -1;			// Low tendency to build artillery
    btBiasInf = -1;			// Low tendency to build Infantry
    btBiasCav = 1;		    // High tendency to build Cavalry
	
	btOffenseDefense = 0.5;  // Higher tendency to attack.
	btRushBoom = 0;   
	
    btBiasNative = -1.0;
    btBiasTrade = -1.0;
	
	cvMaxCivPop = 20;
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
	kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.50);  // Handicap.  50% 
}


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================