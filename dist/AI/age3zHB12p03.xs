//==============================================================================
/* age3hb12p03.xs
   
   Player 3, American

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
	cvMaxAge = cAge5;			// AI is capped at Age 3.  
	cvOkToFortify = false;		
	cvOkToAttack = true;	    
    cvOkToExplore = true; 
	cvOkToGatherNuggets = false;
	cvOkToBuild = true;
	cvOkToBuildWalls = false;
	cvOkToBuildForts = false;
	cvOkToBuildConsulate = false;
	cvOkToFish = false;
	
	
	
	btBiasArt = 0.5;			//  tendency to build artillery
    btBiasInf = 1.0;			// Tendency to build Infantry
    btBiasCav = 0.25;		    // Low tendency to build Cavalry

	btOffenseDefense = 0.45;  // Higher tendency to offense.
	btRushBoom = 0;   // Tendency to rush
	
    btBiasNative = -1.0;
    btBiasTrade = -1.0;
	
	cvDefenseReflexRadiusActive = 45.0;    // When the AI is in a defense reflex, this is the engage range from that base's center.
	cvDefenseReflexRadiusPassive = 25.0;   // When the AI is in a defense reflex, but hiding in its main base to regain strength, this is the main base attack range.
	cvDefenseReflexSearchRadius = 30.0; 
	
	
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
   //kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.65);  // Handicap.  65% 
}