//==============================================================================
/* age3hb02p03.xs
   
   Player 3, Russian allies, mostly passive-defensive player that provides support to main player. 

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
	cvMaxAge = cAge2;			// AI is capped at Age2.  
	cvOkToFortify = true;		// Will build outposts/blockhouses if considered necessary.
	cvOkToAttack = false;	    // Won't launch attacks of any new attacks.
    cvOkToExplore = false; 
	cvOkToGatherNuggets = false;
	cvOkToBuild = false;
	cvOkToBuildWalls = false;
	cvOkToBuildForts = false;
	cvOkToBuildConsulate = false;
	cvOkToFish = false;
	
	cvPrimaryArmyUnit = cUnitTypeStrelet;
	cvSecondaryArmyUnit = cUnitTypeCossack;
	
	cvMaxCivPop = 18;
	
	btBiasArt = -1.0;			// Low tendency to build artillery
    btBiasInf = 0.0;			// Medium tendency to build Infantry
    btBiasCav = -1.0;		    // Low tendency to build Cavalry

	btOffenseDefense = -1.0;  // Higher tendency to defense.
	btRushBoom = -1.0;   // Tendency to boom
	
    btBiasNative = -1.0;
    btBiasTrade = -1.0;
	
	cvDefenseReflexRadiusActive = 30.0;    // When the AI is in a defense reflex, this is the engage range from that base's center.
	cvDefenseReflexRadiusPassive = 28.0;   // When the AI is in a defense reflex, but hiding in its main base to regain strength, this is the main base attack range.
	cvDefenseReflexSearchRadius = 30.0; 
	
	 xsDisableRule("popManager");
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

   gNumTowers = 2;

   //xsEnableRule("scenTribute");
   xsEnableRule("scenBuildingMonitor");
   xsEnableRule("scenStreletMaintainPlan");
   
   aiSetMicroFlags(cMicroLevelNormal);
}


//==============================================================================
//scenCreateSimpleBuildPlan
//==============================================================================
int scenCreateSimpleBuildPlan(int puid = -1, int number = 1, int pri = 100, bool economy = true, int escrowID = -1, int baseID = -1, int numberBuilders = 1)
{

   //Create the right number of plans.
   for (i = 0; < number)
   {
      int planID = aiPlanCreate("Simple Build Plan, " + number + " " + kbGetUnitTypeName(puid), cPlanBuild);
      if (planID < 0)
         return(-1);
      // What to build
      aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, puid);

      // 3 meter separation
      aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 3.0);
      if (puid == gFarmUnit)
         aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 8.0);

      //Priority.
      aiPlanSetDesiredPriority(planID, pri);
      aiPlanSetDesiredResourcePriority(planID, pri);
      //Mil vs. Econ.
      if (economy == true)
         aiPlanSetMilitary(planID, false);
      else
         aiPlanSetMilitary(planID, true);
      aiPlanSetEconomy(planID, economy);
      //Escrow.
      aiPlanSetEscrowID(planID, escrowID);
      //Builders.
      aiPlanAddUnitType(planID, gEconUnit, numberBuilders, numberBuilders, numberBuilders);
      //Base ID.
      aiPlanSetBaseID(planID, baseID);

      //Go.
      aiPlanSetActive(planID);
   }
   return(planID);   // Only really useful if number == 1, otherwise returns last value.
}


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================

/*rule scenTribute
inactive
minInterval 120
{
   float woodToSend = kbResourceGet(cResourceWood) * .85; // Round down for tribute penalty.
   float foodToSend = kbResourceGet(cResourceFood) * .85; // Round down for tribute penalty.
   float goldToSend = kbResourceGet(cResourceGold) * .85; // Round down for tribute penalty.
   woodToSend = woodToSend - 100; // Leave some wood for strelets.
   foodToSend = foodToSend - 375; // Leave some food for strelets.
   if (woodToSend >= 100.0)
      aiTribute(1, cResourceWood, woodToSend);
   if (foodToSend >= 100.0)
      aiTribute(1, cResourceFood, foodToSend);
   if (goldToSend >= 100.0)
      aiTribute(1, cResourceGold, goldToSend);
}*/

rule scenBuildingMonitor
inactive
minInterval 20
{
   if (kbUnitCount(cMyID, gEconUnit, cUnitStateAlive) <= 0)
      return;

   if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gFarmUnit) < 0) &&
       (kbUnitCount(cMyID, gFarmUnit, cUnitStateAlive) <= 0))
   {
      scenCreateSimpleBuildPlan(gFarmUnit, 1, 56, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
	  gTimeToFarm = true;
   }

   if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gHouseUnit) < 0) &&
       (kbUnitCount(cMyID, gHouseUnit, cUnitStateAlive) <= 5) &&
	   (kbGetBuildLimit(cMyID, gHouseUnit) > kbUnitCount(cMyID, gHouseUnit, cUnitStateAlive)) &&
	   ((kbGetPopCap() - kbGetPop()) < 10))
      scenCreateSimpleBuildPlan(gHouseUnit, 1, 77, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);

   if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeStable) < 0) &&
       (kbUnitCount(cMyID, cUnitTypeStable, cUnitStateAlive) <= 0) &&
       (kbUnitCount(cMyID, gFarmUnit, cUnitStateAlive) >= 1))
      scenCreateSimpleBuildPlan(cUnitTypeStable, 1, 49, false, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
}

rule scenStreletMaintainPlan
inactive
mininterval 20
{
   static int streletMaintainPlan = -1;
   int limit = 40;

   if (kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive) < 1)
      limit = 0;

   // Create/update maintain plan
   if ((streletMaintainPlan < 0) && (limit >= 1))
      streletMaintainPlan = createSimpleMaintainPlan(cUnitTypeStrelet, limit, false, kbBaseGetMainID(cMyID), 1);
   else
      aiPlanSetVariableInt(streletMaintainPlan, cTrainPlanNumberToMaintain, 0, limit);
	  
   aiPlanSetDesiredResourcePriority(streletMaintainPlan, 55);
}