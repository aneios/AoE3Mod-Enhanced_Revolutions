//==============================================================================
/* age3hb08p03.xs
   
   Player 4, Orange Enemies, mostly pocket enemy player 

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
	cvMaxAge = cAge4;			// AI is capped at Age IV.
	cvOkToFortify = false;		// Won't build outposts/blockhouses if considered necessary.
    cvOkToExplore = true; 
	cvOkToAttack = false;	    
	cvOkToGatherNuggets = false;
	cvOkToBuild = false;
	cvOkToBuildWalls = false;
	cvOkToBuildForts = false;
	cvOkToBuildConsulate = false;
	cvOkToFish = false;
	
	cvNumArmyUnitTypes = 3;
	cvPrimaryArmyUnit = cUnitTypedeGascenya;
	cvSecondaryArmyUnit = cUnitTypedeNeftenya;
	cvTertiaryArmyUnit = cUnitTypeFalconet;

	
	
	btBiasArt = -0.3;			// Low tendency to build artillery
    btBiasInf = 1.0;			// Tendency to build Infantry
    btBiasCav = -1.0;		    // Low tendency to build Cavalry

	btOffenseDefense = 0.2;  // Higher tendency to offense.
	btRushBoom = 0.0;   
	
    btBiasNative = -1.0;
    btBiasTrade = -1.0;
	
	cvDefenseReflexRadiusActive = 55.0;    // When the AI is in a defense reflex, this is the engage range from that base's center.
	cvDefenseReflexRadiusPassive = 28.0;   // When the AI is in a defense reflex, but hiding in its main base to regain strength, this is the main base attack range.
	cvDefenseReflexSearchRadius = 30.0; 
	
	cvPlayerToAttack = -1;
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
   //kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.85);
}