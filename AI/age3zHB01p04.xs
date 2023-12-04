//==============================================================================
/* age3zhb01p04.xs
   
	This is a standard AI. The AI for the Spanish naval fort south of the city. Player 4, Spanish. This player is very aggressive and will try to besiege the player's city. The AI will also build ships to attack the player from water.
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
   gDelayAttacks = true;	// AI will only attack under certain conditions
   cvPlayerToAttack = 1;  // The AI will focus its attacks on player 1.
   cvOkToFish = false;	// The AI will not build fishing ships or use its ships to fish.
   
   // TBD what units to train
   // btBiasArt = 0.5;			// High tendency to build artillery
   // btBiasInf = 0.2;			// Medium tendency to build Infantry
   // btBiasCav = -0.5;		    // Low tendency to build Cavalry
   
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