//==============================================================================
/* age3zhb01p08.xs
   
	This is a standard AI. The AI for the Spanish fort east of the city. Player 8, Spanish. This player is very aggressive and will try to besiege the player's city.
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
   btOffenseDefense = 1.0; // Will focus on military upgrades.
   btRushBoom = 1.0; // Is very aggressive and will attack whenever possible.
   cvOkToExplore = false;  // Not Okay Explore the map.
   cvOkToBuild = false;	// Do not allow to build and do not calculate buildings into resource management.
   gDelayAttacks = false;	// AI can attack on easy even if he's not been attacked.
   cvPlayerToAttack = 1;  // The AI will focus its attacks on player 1.
   
   // TBD what units to train
   btBiasArt = 0.0;			// Medium tendency to build artillery
   btBiasInf = 0.5;			// High tendency to build Infantry
   btBiasCav = 0.5;		    // High tendency to build Cavalry
   
   switch (aiGetWorldDifficulty())
   {
	   case cDifficultyEasy: // Easy
	   {
		  cvMaxArmyPop = 15;
		  break;
	   }
	   case cDifficultyModerate: // Moderate
	   { 
		  cvMaxArmyPop = 25;
		  break;
	   }
	   case cDifficultyHard: // Hard
	   { 
        cvMaxArmyPop = 35;
		  break;
		}
   }
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