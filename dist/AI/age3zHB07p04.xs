//==============================================================================
/* age3zhb07p04.xs
   
   Player 4, Kano (Green), one of three enemy cities.

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
	
	btRushBoom = 0.2;
	btOffenseDefense = 1.0;
	
	btBiasCav = 0.0;
	btBiasInf = 0.0;
	btBiasArt = 0.0;
	
	cvOkToAllyNatives = false;
	cvOkToClaimTrade = false;
	cvOkToResign = false;
	cvOkToFish = false;
	cvOkToGatherNuggets = false;
	cvOkToBuild = false;
	//cvOkToExplore = false;
	
	cvNumArmyUnitTypes = 3;
	cvPrimaryArmyUnit = cUnitTypedeJavelinRider;
	cvSecondaryArmyUnit = cUnitTypedeRaider;
	cvTertiaryArmyUnit = cUnitTypeFalconet;
	
	cvMaxAge = cAge4;
	
	switch(aiGetWorldDifficulty())
	{
		case cDifficultyEasy:
		{
			cvMaxArmyPop = 20;
			break;
		}
		case cDifficultyModerate:
		{
			cvMaxArmyPop = 27;
			break;
		}
		case cDifficultyHard:
		{
			cvMaxArmyPop = 35;
			break;
		}
	}
	
	cvMaxCivPop = 5;		// no lemmings, economy supported by triggers.
	
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