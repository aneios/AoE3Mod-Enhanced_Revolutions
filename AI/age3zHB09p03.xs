//==============================================================================
/* age3zHB09p03.xs
   
   This AI is focussed on send constant attacks, no building. This is computer player 3, King Sebastian.
   Created 24-11-2020.  Pablo ML.
   
   01-07-2021: Modified to act more like a normal AI, taking its time for larger, more focused attacks. Earlier attacks handled by triggers.
   /Oscar Mackenrott
   
   27-09-2021: Removed the cvOkToGatherCrates control variable.
   /Oscar Mackenrott
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

	btRushBoom = 0.7;
	btOffenseDefense = 1.0;
	
	cvNumArmyUnitTypes = 3;
	cvPrimaryArmyUnit = cUnitTypeCrossbowman;
	cvSecondaryArmyUnit = cUnitTypePikeman;
	cvTertiaryArmyUnit = cUnitTypeOrganGun;

	btBiasNative = -1.0;
	btBiasTrade = -1.0; 
	

	cvOkToFortify = false;      
	cvOkToChat = false;       
	cvOkToAllyNatives = false;
	cvOkToClaimTrade = false;
	cvOkToBuild = false;
	cvOkToBuildWalls = false;
	cvOkToBuildForts = false;

	cvOkToFish = false;

	cvOkToGatherFood = false;
	cvOkToGatherGold = false;
	cvOkToGatherWood = false;

	cvOkToGatherNuggets = false;
	
	cvMaxAge = cAge4;
	
	switch(aiGetWorldDifficulty())
	{
		case cDifficultyEasy:
		{
			cvMaxArmyPop = 30;
			break;
		}
		case cDifficultyModerate:
		{
			cvMaxArmyPop = 45;
			break;
		}
		case cDifficultyHard:
		{
			cvMaxArmyPop = 60;
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