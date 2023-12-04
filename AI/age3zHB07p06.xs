//==============================================================================
/* age3zhb07p06.xs
   
   Player 6, Fulani Nomads, the player's AI ally.

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
	
	btRushBoom = 1.0;		// RUSH RUSH RUSH!
	btOffenseDefense = 1.0;	// spec hard into military
	
	btBiasCav = 0.0;		// standard bias to cavalry
	btBiasInf = 0.0;		// standard bias to infantry
	btBiasArt = 0.0;		// standard bias to artillery
	
	cvOkToExplore = false;	// Don't want the AI to run all of their Fula Warriors into the enemy in piecemeal now do we?
	cvOkToAllyNatives = false;
	cvOkToClaimTrade = false;
	cvOkToBuildWalls = true;
	cvOkToResign = false;
	cvOkToFish = false;
	cvOkToGatherNuggets = true;
	
	//cvNumArmyUnitTypes = 3;
	//cvPrimaryArmyUnit = cUnitTypedeFulaWarrior;
	//cvSecondaryArmyUnit = cUnitTypedeRaider;
	//cvTertiaryArmyUnit = cUnitTypedeJavelinRider;
	
	cvMaxAge = cAge5;
	//cvMaxArmyPop = 15;		// low number to increase importance of allied troop support
	cvMaxCivPop = 20;		// fewer lemmings to steal the human player's resources >:(
	
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

rule setMainBaseGatherPoint
inactive
group tcComplete
{
	int baseID = kbBaseGetMainID(cMyID);
	vector gatherPoint = kbBaseGetMilitaryGatherPoint(cMyID, baseID);
	vector unitVec = xsVectorNormalize(kbGetMapCenter() - gatherPoint);
	gatherPoint = gatherPoint + (unitVec * -5.0);
	kbBaseSetMilitaryGatherPoint(cMyID, baseID, gatherPoint);
	xsDisableSelf();
}

/*rule setMainBaseGatherPoint
inactive
group tcComplete
{
	int baseID = kbBaseGetMainID(cMyID);
	int tempQuery = kbUnitCreateQuery("Look for my AI Target Block Strong");
	vector gatherPoint = cInvalidVector;
	kbUnitQuerySetPlayerID(tempQuery, cMyID);
	kbUnitQuerySetUnitType(tempQuery, cUnitTypeAITargetBlockStrong);
	kbUnitQueryResetResults(tempQuery);
	int queryResult = kbUnitQueryExecute(tempQuery);
	gatherPoint = kbUnitGetPosition(kbUnitQueryGetResult(tempQuery, 0));
	kbBaseSetMilitaryGatherPoint(cMyID, baseID, gatherPoint);
	xsDisableSelf();
}*/

/*rule setMainBaseDefendPlan
inactive
group tcComplete
{
	int baseID = kbBaseGetMainID(cMyID);
	int tempQuery = kbUnitCreateQuery("Look for my AI Target Block Strong");
	kbUnitQuerySetPlayerID(tempQuery, cMyID);
	kbUnitQuerySetUnitType(tempQuery, cUnitTypeAITargetBlockStrong);
	kbUnitQueryResetResults(tempQuery);
	int queryResult = kbUnitQueryExecute(tempQuery);
	vector gatherPoint = kbUnitGetPosition(kbUnitQueryGetResult(tempQuery, 0));
	
	defendID = aiPlanCreate("Defend Base", cPlanDefend);
	aiPlanAddUnitType(defendID, cUnitTypeMilitary, 0, 200, 200);
    aiPlanSetDesiredPriority(defendID, 20);
	aiPlanSetVariableVector(defendID, cDefendPlanDefendPoint, 0, gatherPoint);
	aiPlanSetVariableInt(defendID, cDefendPlanGatherDistance, 0, 20);
	aiPlanSetVariableFloat(defendID, cDefendPlanEngageRange, 0, 40);
    aiPlanSetUnitStance(defendID, cUnitStanceDefensive);
	aiPlanSetActive(defendID);
	xsDisableSelf();
}*/