//==============================================================================
/*  age3zhb04p04.xs
	Fort Duquesne, Player 4. This is the standard AI. It is used for the Seneca (Iroquois) player. The AI becomes active once the player liberates the village. 
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
   btOffenseDefense = -0.5; // // Higher tendency to defend.
   btRushBoom = 0.0; // Balanced
   cvOkToExplore = false;  // Not Okay Explore the map.
   cvOkToBuild = false;	// Do not allow to build and do not calculate buildings into resource management.
   cvOkToFortify = false; // Do not allow to build war huts.
   cvOkToAttack = false; // Will not attack.
   cvOkToGatherNuggets = false;
   
   btBiasArt = -0.5;			// Low tendency to build artillery
   btBiasInf = 0.25;			// Medium tendency to build Infantry
   btBiasCav = 0.5;				// High tendency to build Cavalry

   cvMaxCivPop = 8;
   cvMaxArmyPop = 20;
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