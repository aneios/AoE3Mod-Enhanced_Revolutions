//==============================================================================
/* age3zhb11p02.xs

   Player 2, Ignacio Allende (Green). Activated when first town has been captured (with the help of triggers) and this slot is not controlled by a human.
   Does not attack on his own, but will use defend plans activated through here to move units into enemy territory.
*/
//==============================================================================



include "aiHeader.xs";     // Gets global vars, function forward declarations
include "aiMain.xs";       // The bulk of the AI

int planID = -1;
int targetTime = -1;
vector defendLocation = cInvalidVector;
int qtyInf = 20;
int qtyCav = 20;
int qtyArt = 6;
int availableBuildingTypes = 0;



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
   
   btRushBoom = 0.8;
   btOffenseDefense = 0.7;
   btBiasTrade = -1.0;
   
   cvOkToAttack = false;
   cvOkToTrainNavy = false;
   cvOkToTaunt = false;
   cvOkToChat = false;
   cvOkToAllyNatives = true;
   cvOkToResign = false;
   cvMaxAge = cAge5;
   cvOkToClaimTrade = false;
   cvOkToExplore = false;
   
   //cvNumArmyUnitTypes = 3;
   //cvPrimaryArmyUnit = cUnitTypedeSoldado;
   //cvSecondaryArmyUnit = cUnitTypedeChinaco;
   //cvTertiaryArmyUnit = cUnitTypeFalconet;
   
   cvMaxCivPop = 30;
   
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

void preparePlan(int bogus = 0)
{
	targetTime = xsGetTime() + 6*60*1000; // 6 minutes after activation
	xsEnableRule("initiatePlan");
}

void killPlan(int bogus = 0)
{
	aiPlanDestroy(planID);
}

void newBase(int bogus = 0)
{
	// Set up a query for the AI Target Block Weak.
	int queryBlockWeak = kbUnitQueryCreate("Find the AI Target Block Weak");
	kbUnitQueryResetResults(queryBlockWeak);
	kbUnitQuerySetPlayerID(queryBlockWeak, cMyID);
	kbUnitQuerySetUnitType(queryBlockWeak, cUnitTypeAITargetBlockWeak);
	kbUnitQuerySetState(queryBlockWeak, cUnitStateAny);
	int count = kbUnitQueryExecute(queryBlockWeak);
	
	// Create a new base by the Weak Bloc Position Vector
	if(count > 0)
	{
		createMainBase(kbUnitGetPosition(kbUnitQueryGetResult(queryBlockWeak, 0)));
	}
	else
	{
		return;
	}
}

int findBuilding(int building = 0)
{
	int targetBuilding = -1;
	
	// Set up a query to find the appropriate building.
	int queryBuilding = kbUnitQueryCreate("Find the Building");
	kbUnitQueryResetResults(queryBuilding);
	kbUnitQuerySetPlayerID(queryBuilding, cMyID);
	kbUnitQuerySetUnitType(queryBuilding, building);
	kbUnitQuerySetState(queryBuilding, cUnitStateAlive);
	int count = kbUnitQueryExecute(queryBuilding);

	if(count > 0)
	{
		targetBuilding = kbUnitQueryGetResult(queryBuilding, aiRandInt(count));
	}
	
	return (targetBuilding);
}

void unlockNewBuilding(int bogus = 0)
{
	availableBuildingTypes = availableBuildingTypes + 1;
}

rule initiatePlan
	inactive
	minInterval 10
{
	// Check if we've reached 6 minutes.
	if(xsGetTime() < targetTime)
	{
		return;
	}
	
	// Set up a query for the AI Target Block.
	int queryBlock = kbUnitQueryCreate("Find the AI Target Block");
	kbUnitQueryResetResults(queryBlock);
	kbUnitQuerySetPlayerID(queryBlock, cMyID);
	kbUnitQuerySetUnitType(queryBlock, cUnitTypeAITargetBlockStrong);
	kbUnitQuerySetState(queryBlock, cUnitStateAny);
	int count = kbUnitQueryExecute(queryBlock);
	
	if(count > 0)
	{
		defendLocation = kbUnitGetPosition(kbUnitQueryGetResult(queryBlock, 0));
	}
	else
	{
		return;
	}
	
	// Set up the plan.
	planID = aiPlanCreate("Move into the next area", cPlanDefend);
	aiPlanAddUnitType(planID, cUnitTypeMilitary, 20, 40, 40);
	aiPlanSetVariableVector(planID, cDefendPlanDefendPoint, 0, defendLocation);
	aiPlanSetVariableFloat(planID, cDefendPlanGatherDistance, 0, 10.0);
	aiPlanSetUnitStance(planID, cUnitStanceAggressive);
	aiPlanSetDesiredPriority(planID, 90);
	aiPlanSetVariableFloat(planID, cDefendPlanEngageRange, 40.0);
	aiPlanSetRequiresAllNeedUnits(planID, true);
	aiPlanSetActive(planID);
	
	xsDisableSelf();
}

/*rule spawnSoldiers
	inactive
	minInterval 45
{
	// CHECK FOR INFANTRY
	if (availableBuildingTypes >= 1)
	{
		if (kbUnitCount(2, cUnitTypeBarracks, cUnitStateAlive) > 0)
		{
			if (kbUnitCount(2, cUnitTypedeSoldado, cUnitStateAlive) < qtyInf*0.5)
			{
				aiUnitCreateCheat(2, cUnitTypedeSoldado, kbGetBlockPosition(findBuilding(cUnitTypeBarracks)), "Infantry", 3);
			}
			if (kbUnitCount(2, cUnitTypedeEmboscador, cUnitStateAlive) < qtyInf*0.25)
			{
				aiUnitCreateCheat(2, cUnitTypedeEmboscador, kbGetBlockPosition(findBuilding(cUnitTypeBarracks)), "Infantry", 3);
			}
			if (kbUnitCount(2, cUnitTypedeInsurgente, cUnitStateAlive) < qtyInf*0.25)
			{
				aiUnitCreateCheat(2, cUnitTypedeInsurgente, kbGetBlockPosition(findBuilding(cUnitTypeBarracks)), "Infantry", 3);
			}
		}
	}
	
	// CHECK FOR CAVALRY
	if (availableBuildingTypes >= 2)
	{
		if (kbUnitCount(2, cUnitTypeStable, cUnitStateAlive) > 0)
		{
			if (kbUnitCount(2, cUnitTypedeChinaco, cUnitStateAlive) < qtyCav*0.75)
			{
				aiUnitCreateCheat(2, cUnitTypedeChinaco, kbGetBlockPosition(findBuilding(cUnitTypeStable)), "Cavalry", 3);
			}
			if (kbUnitCount(2, cUnitTypeDragoon, cUnitStateAlive) < qtyCav*0.25)
			{
				aiUnitCreateCheat(2, cUnitTypeDragoon, kbGetBlockPosition(findBuilding(cUnitTypeStable)), "Cavalry", 2);
			}
		}
	}
	
	// CHECK FOR ARTILLERY
	if (availableBuildingTypes >= 3)
	{
		if (kbUnitCount(2, cUnitTypeArtilleryDepot, cUnitStateAlive) > 0)
		{
			if (kbUnitCount(2, cUnitTypedeFalconet, cUnitStateAlive) < qtyArt*0.8)
			{
				aiUnitCreateCheat(2, cUnitTypedeFalconet, kbGetBlockPosition(findBuilding(cUnitTypeArtilleryDepot)), "Artillery", 2);
			}
			if (kbUnitCount(2, cUnitTypeMortar, cUnitStateAlive) < qtyArt*0.2)
			{
				aiUnitCreateCheat(2, cUnitTypeMortar, kbGetBlockPosition(findBuilding(cUnitTypeArtilleryDepot)), "Artillery", 1);
			}
		}
	}
}*/