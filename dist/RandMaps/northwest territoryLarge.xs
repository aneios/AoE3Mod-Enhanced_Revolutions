// LARGE NORTHWEST TERRITORY
// Dec 06 - YP update
// Durokan's May 20 update for DE -- only changed 1v1
// LARGE version by vividlyplain, July 2021

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   int randomnumber=-1;

   // Four natives appear on this map!
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;

	string natType1 = "";
	string natGrpName1 = "";
	if (rmRandFloat(0,1) <= 0.50)
	{
		natType1 = "Cree";
		natGrpName1 = "native cree village ";
	}
	else
	{
		natType1 = "Klamath";
		natGrpName1 = "native klamath village ";
	}

	if (rmAllocateSubCivs(3) == true)
	{
		subCiv0=rmGetCivID("Nootka");
		rmEchoInfo("subCiv0 is nootka "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Nootka");

		subCiv1=rmGetCivID(natType1);
		rmEchoInfo("subCiv1 is "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, natType1);

		if(rmRandFloat(0,1) < 0.5)
		{
			subCiv2=rmGetCivID(natType1);
			rmEchoInfo("subCiv2 is "+subCiv2);
			if (subCiv2 >= 0)
				rmSetSubCiv(2, natType1);
		}
		else 
		{
			subCiv2=rmGetCivID(natType1);
			rmEchoInfo("subCiv2 is "+subCiv2);
			if (subCiv2 >= 0)
				rmSetSubCiv(2, natType1);
		}

		subCiv3=rmGetCivID("Nootka");
		rmEchoInfo("subCiv3 is Nootka "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Nootka");
	}

   int teamZeroCount = rmGetNumberPlayersOnTeam(0);
   int teamOneCount = rmGetNumberPlayersOnTeam(1);

	// Picks the map size
	int playerTiles=24000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles = 21000;

	// Special case code for the 3v1s, 5v1s, 6v1s, and 7v1s - bigger map.
	if (( teamZeroCount >= teamOneCount * 2 ) || ( teamOneCount >= teamZeroCount * 2 ))
	{
		playerTiles = 13000;
	}

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetWindMagnitude(2);

	// Picks a default water height
	rmSetSeaLevel(0);

	// Picks default terrain and water
	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	rmSetMapElevationParameters(cElevTurbulence, 0.04, 4, 0.4, 6.0);
	// rmSetSeaType("NW Territory River");
	rmSetSeaType("New England Coast");
	rmSetBaseTerrainMix("nwt_grass1");
	rmTerrainInitialize("NWterritory\ground_grass1_nwt", 5);
	rmSetMapType("northwestTerritory");
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetLightingSet("NorthwestTerritory_Skirmish");
	rmSetWorldCircleConstraint(true);

	// Make it rain
	rmSetGlobalRain( 1.0 );
	rmSetGlobalStormLength(1.0, 0.0);

	// Sets up the rain triggers - rain hard for 20 seconds, then lightly, then hard again, then medium, then off.
	rmCreateTrigger("ChangeRain1");
	rmSwitchToTrigger(rmTriggerID("ChangeRain1"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 20);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 0.3);

	rmCreateTrigger("ChangeRain2");
	rmSwitchToTrigger(rmTriggerID("ChangeRain2"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 40);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 1.0);

	rmCreateTrigger("ChangeRain3");
	rmSwitchToTrigger(rmTriggerID("ChangeRain3"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 60);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 0.3);

	rmCreateTrigger("ChangeRain4");
	rmSwitchToTrigger(rmTriggerID("ChangeRain4"));
	rmSetTriggerActive(true);
	rmAddTriggerCondition("Timer");
	rmSetTriggerConditionParamInt("Param1", 75);
	rmAddTriggerEffect("Render Rain");
	rmSetTriggerEffectParamFloat("Percent", 0.0);

	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	int classSocket=rmDefineClass("socketClass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classSocket");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short 2", rmClassID("natives"), 5.0);

   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
//   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 24.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, rmXFractionToMeters(0.05), rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	// Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
	// int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
 
    // Nature avoidance
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 24.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 10.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "HumpbackWhale", 25.0);

   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 44.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int avoidFastCoin = -1;
	if (cNumberNonGaiaPlayers > 4)
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 64.0);	// DAL was 50
	}
	else
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 82.0);	// DAL was 50
	}
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 64.0);
   int avoidElk=rmCreateTypeDistanceConstraint("elk avoids food", "elk", 75.0);  // DAL was 50
   int avoidMoose=rmCreateTypeDistanceConstraint("moose avoids food", "moose", 55.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);

   // Constraint to avoid water.
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water 8", "Land", false, 8.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 20.0);
   int ferryOnShore=rmCreateTerrainMaxDistanceConstraint("ferry v. water", "water", true, 12.0);
   int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 20.0);
   int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);

   // New extra stuff for water spawn point avoidance.
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 15.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 10);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);
	int flagBoxConstraint=rmCreateBoxConstraint("flag area", 0, 0.5, 0.6, 0.9, 0.0);

	// Unit avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
   int avoidSocket = rmCreateClassDistanceConstraint("avoid socket", rmClassID("classSocket"), 10.0);
   int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);

   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // ships vs. ships
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

   // -------------Define objects
   // These objects are all defined so they can be placed later

   // Text
   rmSetStatusText("",0.10);

   // Set up player starting locations. These are used to place Caravels.

   //  MAIN RIVER
    // int pugetSound = rmRiverCreate(-1, "New England Coast", 5, 10, 16, 20);
	int pugetSound = -1;
	if ( cNumberNonGaiaPlayers < 4 )
	{
		pugetSound = rmRiverCreate(-1, "Northwest Territory Water", 5, 10, 10, 14);
	}
	else
	{
		pugetSound = rmRiverCreate(-1, "Northwest Territory Water", 5, 10, 16, 20);
	}
	rmRiverSetConnections(pugetSound, 0.0, 0.4, 0.6, 1);
	// rmRiverSetShallowRadius(pugetSound, 6);
	//	   rmRiverAddShallow(pugetSound, rmRandFloat(0.5, 0.5));
    rmRiverBuild(pugetSound);
    rmRiverReveal(pugetSound, 2); 

	// On FFA maps, do not build the other rivers.
	if ( cNumberTeams == 2 )
	{
		//TRIB RIVER
		// int columbiaRiver = rmRiverCreate(-1, "New England Coast", 6, 20, 9, 12);
		int columbiaRiver = rmRiverCreate(-1, "Northwest Territory Water", 6, 8, 8, 10);
		//rmRiverConnectRiver(source river, dest river, float pct, float x2, float z2)
		rmRiverConnectRiver(columbiaRiver, pugetSound, 0.5, 0.65, 0.35);
		// rmRiverSetConnections(columbiaRiver, 0.3, 0.7, 0.65, 0.35);
		rmRiverSetShallowRadius(columbiaRiver, 8+2*cNumberNonGaiaPlayers);

		// First crossing if 4 players or more.
		if ( cNumberNonGaiaPlayers > 3 )
		{
			rmRiverAddShallow(columbiaRiver, 0.7);
			rmRiverAddShallow(columbiaRiver, 0.6);
		}

		if ( cNumberNonGaiaPlayers > 3 )
		{
			rmRiverAddShallow(columbiaRiver, 0.1);
		}
		else
		{
			rmRiverAddShallow(columbiaRiver, 0.6);
			rmRiverAddShallow(columbiaRiver, 0.5);
		}

		rmRiverBuild(columbiaRiver);

		// Two tributaries off the Columbia River
		int riverBranchNorth = rmRiverCreate(-1, "Northwest Territory Water", 4, 10, 8, 10);
		rmRiverConnectRiver(riverBranchNorth, columbiaRiver, 0.0, 1.0, 0.35);
		rmRiverSetShallowRadius(riverBranchNorth, 8+2*cNumberNonGaiaPlayers);
		rmRiverAddShallow(riverBranchNorth, 0.5);
		rmRiverBuild(riverBranchNorth);

		int riverBranchSouth = rmRiverCreate(-1, "Northwest Territory Water", 4, 10, 8, 10);
		rmRiverConnectRiver(riverBranchSouth, columbiaRiver, 0.0, 0.65, 0.0);
		rmRiverSetShallowRadius(riverBranchSouth, 8+2*cNumberNonGaiaPlayers);
		rmRiverAddShallow(riverBranchSouth, 0.5);
		rmRiverBuild(riverBranchSouth);

		randomnumber=rmRandInt(1, 100);
	}

	// Make areas for the main islands... kinda hacky I guess, but it works.
	// Build an invisible north island area.
	int northIslandID = rmCreateArea("north island");
	rmSetAreaLocation(northIslandID, 0.75, 0.5); 
	rmSetAreaWarnFailure(northIslandID, false);
	rmSetAreaSize(northIslandID, 0.5, 0.5);
	rmSetAreaCoherence(northIslandID, 1.0);
	rmAddAreaConstraint(northIslandID, avoidWater4);
	rmBuildArea(northIslandID);

   // Build an invisible south island area.
   int southIslandID = rmCreateArea("south island");
   rmSetAreaLocation(southIslandID, 0.5, 0.25); 
   rmSetAreaWarnFailure(southIslandID, false);
   rmSetAreaSize(southIslandID, 0.5, 0.5);
   rmSetAreaCoherence(southIslandID, 1.0);
   rmAddAreaConstraint(southIslandID, avoidWater4);
   rmBuildArea(southIslandID);

   // add island constraints
   int northIslandConstraint=rmCreateAreaConstraint("north Island", northIslandID);
   int southIslandConstraint=rmCreateAreaConstraint("south Island", southIslandID);

   // Text
   rmSetStatusText("",0.20);

   // NEW player placement.
   if ( cNumberTeams == 2 )
   {
		rmSetPlacementTeam(0);
		// Special case code for 7v1s and the like
		if (( teamZeroCount > teamOneCount * 2 ) )
		{
			rmPlacePlayersLine(0.45, 0.45, 0.2, 0.2, 0.0, 0.2);
		}
		else
		{
			rmPlacePlayersLine(0.35, 0.35, 0.2, 0.2, 0.0, 0.2);
		}

		rmSetPlacementTeam(1);
		// Special case code for 7v1s and the like
		if ( teamOneCount > teamZeroCount * 2 )
		{
			rmPlacePlayersLine(0.55, 0.55, 0.8, 0.8, 0.0, 0.2);
		}
		else
		{
			rmPlacePlayersLine(0.65, 0.65, 0.8, 0.8, 0.0, 0.2);
		}
			
   }
   else
   {
		rmSetPlacementSection(0.1, 0.65);
		rmPlacePlayersCircular(0.25, 0.30, 0.0);
   }

    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Clear out constraints for good measure.
   rmClearClosestPointConstraints();

	// TRADE ROUTES
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);


	int tradeRoute1ID = rmCreateTradeRoute();
	rmAddTradeRouteWaypoint(tradeRoute1ID, 1.0, 0.4);
	rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.8, 0.6, 6, 8);
	rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 1.0, 1.0, 6, 8);

	bool placedTradeRoute1 = rmBuildTradeRoute(tradeRoute1ID, "dirt");
	if(placedTradeRoute1 == false)
		rmEchoError("Failed to place trade route one");

	// add the meeting sockets along the trade route.
	rmSetObjectDefTradeRouteID(socketID, tradeRoute1ID);
	vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.2);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.6);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	int tradeRoute2ID = rmCreateTradeRoute();
	rmAddTradeRouteWaypoint(tradeRoute2ID, 0.6, 0.0);
	rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.4, 0.2, 6, 8);
	rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.0, 0.0, 6, 8);

	bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "dirt");
	if(placedTradeRoute2 == false)
		rmEchoError("Failed to place trade route 2");

	// add the meeting sockets along the trade route.
	rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);
	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.2);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);

	socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.6);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);

	// Text
   rmSetStatusText("",0.20);

   // 
   /*
   if (subCiv0 == rmGetCivID("Nootka"))
   {  
		int nootkaVillage1ID = -1;
		int nootkaVillageType = rmRandInt(1,5);
		nootkaVillage1ID = rmCreateGrouping("nootka village 1", "native nootka village "+nootkaVillageType);
		rmSetGroupingMinDistance(nootkaVillage1ID, 0.0);
		rmSetGroupingMaxDistance(nootkaVillage1ID, 0.0);
		rmAddGroupingToClass(nootkaVillage1ID, rmClassID("importantItem"));
		rmAddGroupingToClass(nootkaVillage1ID, rmClassID("natives"));
		rmAddGroupingConstraint(nootkaVillage1ID, avoidTradeRoute);
		rmAddGroupingConstraint(nootkaVillage1ID, avoidSocket);
		rmAddGroupingConstraint(nootkaVillage1ID, avoidImportantItem);
		rmPlaceGroupingAtLoc(nootkaVillage1ID, 0, 0.2, 0.8);
   }
   */

   int KlamathVillageType = -1;

	if (subCiv1 == rmGetCivID(natType1))
   {  
		int KlamathVillage2ID = -1;
		KlamathVillageType = rmRandInt(1,5);
		KlamathVillage2ID = rmCreateGrouping("Klamath village 2", natGrpName1+KlamathVillageType);
		rmSetGroupingMinDistance(KlamathVillage2ID, 0.0);
		rmSetGroupingMaxDistance(KlamathVillage2ID, 0.0);
		rmAddGroupingToClass(KlamathVillage2ID, rmClassID("importantItem"));
		rmAddGroupingConstraint(KlamathVillage2ID, avoidTradeRoute);
        rmAddGroupingToClass(KlamathVillage2ID, rmClassID("natives"));
		rmAddGroupingConstraint(KlamathVillage2ID, avoidSocket);
		rmAddGroupingConstraint(KlamathVillage2ID, avoidImportantItem);
		if ( cNumberTeams == 2 )
		{
			rmPlaceGroupingAtLoc(KlamathVillage2ID, 0, 0.7, 0.6);
		}
		else
		{
			rmPlaceGroupingAtLoc(KlamathVillage2ID, 0, 0.6, 0.6);
		}
   }

	if (subCiv2 == rmGetCivID(natType1))
   {  
		int KlamathVillage3ID = -1;
		KlamathVillageType = rmRandInt(1,5);
		KlamathVillage3ID = rmCreateGrouping("Klamath village 3", natGrpName1+KlamathVillageType);
		rmSetGroupingMinDistance(KlamathVillage3ID, 0.0);
		rmSetGroupingMaxDistance(KlamathVillage3ID, 0.0);
		rmAddGroupingToClass(KlamathVillage3ID, rmClassID("importantItem"));
		rmAddGroupingConstraint(KlamathVillage3ID, avoidTradeRoute);
		rmAddGroupingConstraint(KlamathVillage3ID, avoidSocket);
        rmAddGroupingToClass(KlamathVillage3ID, rmClassID("natives"));
		rmAddGroupingConstraint(KlamathVillage3ID, avoidImportantItem);
		if ( cNumberTeams == 2 )
		{
			rmPlaceGroupingAtLoc(KlamathVillage3ID, 0, 0.4, 0.3);
		}
		else
		{
			rmPlaceGroupingAtLoc(KlamathVillage3ID, 0, 0.4, 0.4);
		}
   }

   if (subCiv3 == rmGetCivID("Nootka"))
   {  
		int nootkaVillage4ID = -1;
		int nootkaVillageType = rmRandInt(1,5);
		nootkaVillage4ID = rmCreateGrouping("nootka village 4", "native nootka village "+nootkaVillageType);
		rmSetGroupingMinDistance(nootkaVillage4ID, 0.0);
		rmSetGroupingMaxDistance(nootkaVillage4ID, 0.0);
		rmAddGroupingToClass(nootkaVillage4ID, rmClassID("importantItem"));
		rmAddGroupingConstraint(nootkaVillage4ID, avoidTradeRoute);
		rmAddGroupingConstraint(nootkaVillage4ID, avoidSocket);
		rmAddGroupingConstraint(nootkaVillage4ID, avoidImportantItem);
        rmAddGroupingToClass(nootkaVillage4ID, rmClassID("natives"));
		// Do not place this village in FFA placement
		if ( cNumberTeams == 2 )
		{
			rmPlaceGroupingAtLoc(nootkaVillage4ID, 0, 0.8, 0.2);
		}
   }

   // Starting Unit placement - this can move more in weird configurations
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	if (( teamZeroCount >= teamOneCount * 2 ) || ( teamOneCount >= teamZeroCount * 2 ))
	{
		rmSetObjectDefMaxDistance(startingUnits, 20.0);
	}
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidWater8);

	int startingTCID= rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	if (( teamZeroCount >= teamOneCount * 2 ) || ( teamOneCount >= teamZeroCount * 2 ))
	{
		rmSetObjectDefMinDistance(startingTCID, 0.0);
		rmSetObjectDefMaxDistance(startingTCID, 10.0);
	}

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeTexas", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 15.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartDeerID=rmCreateObjectDef("starting deer");
	rmAddObjectDefItem(StartDeerID, "deer", 1, 0.0);
	rmSetObjectDefMinDistance(StartDeerID, 10.0);
	rmSetObjectDefMaxDistance(StartDeerID, 15.0);
	rmAddObjectDefConstraint(StartDeerID, avoidStartingUnitsSmall);

    int silverID = -1;
	int silverType = rmRandInt(1,10);
	int playerGoldID = -1;

    int classStartingResource = rmDefineClass("startingResource");
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other 2", rmClassID("startingResource"), 14.0);
    
    int baseGold = rmCreateObjectDef("starting gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold, 14.0);
    rmSetObjectDefMaxDistance(baseGold, 20.0);
   	rmAddObjectDefToClass(baseGold, classStartingResource);
	rmAddObjectDefConstraint(baseGold, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold, avoidStartingResources);
    
    int baseHunt1=rmCreateObjectDef("baseHunt1");
    rmAddObjectDefItem(baseHunt1, "deer", 8, 7.0);
    rmSetObjectDefMinDistance(baseHunt1, 11.0);
    rmSetObjectDefMaxDistance(baseHunt1, 15.0);
    rmAddObjectDefConstraint(baseHunt1, avoidStartingUnitsSmall);
    rmAddObjectDefConstraint(baseHunt1, avoidStartingResources);
    rmAddObjectDefConstraint(baseHunt1, avoidImpassableLand);
    rmAddObjectDefConstraint(baseHunt1, avoidTradeRoute);
    rmAddObjectDefConstraint(baseHunt1, avoidNativesShort);
    rmSetObjectDefCreateHerd(baseHunt1, true);
    rmAddObjectDefConstraint(baseHunt1, avoidSocket);

    int baseHunt2=rmCreateObjectDef("baseHunt2");
    rmAddObjectDefItem(baseHunt2, "deer", 8, 7.0);
    rmSetObjectDefMinDistance(baseHunt2, 31.0);
    rmSetObjectDefMaxDistance(baseHunt2, 33.0);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingUnitsSmall);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingResources);
    rmAddObjectDefConstraint(baseHunt2, avoidTradeRoute);
    rmAddObjectDefConstraint(baseHunt2, avoidSocket);
    rmSetObjectDefCreateHerd(baseHunt2, true);
    rmAddObjectDefConstraint(baseHunt2, avoidImpassableLand);
            
	int waterFlagID = -1;

	for(i=1; <cNumberPlayers)
	{
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets two ore groupings, one pretty close, the other a little further away.
        if(cNumberNonGaiaPlayers>2){
            silverType = rmRandInt(1,10);
            playerGoldID = rmCreateObjectDef("player silver closer "+i);
            rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
            rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
            rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
            rmAddObjectDefConstraint(playerGoldID, avoidWater8);
            rmSetObjectDefMinDistance(playerGoldID, 15.0);
            rmSetObjectDefMaxDistance(playerGoldID, 20.0);
            rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            
            // Placing starting Pronghorns...
            rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }else{
            rmPlaceObjectDefAtLoc(baseGold, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            rmPlaceObjectDefAtLoc(baseGold, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            rmPlaceObjectDefAtLoc(baseHunt1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
           // rmPlaceObjectDefAtLoc(baseHunt2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

            
        }
		
		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flag
		waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		// rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		rmAddClosestPointConstraint(flagBoxConstraint);		
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
        vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();
	}

   // Text
   rmSetStatusText("",0.30);
   
    //constraints for durokan's 1v1 balance
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 4.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 3.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 25.0);
    int avoidHunt3=rmCreateTypeDistanceConstraint("herds avoid herds3", "huntable", 30.0);
	int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type  far ", "gold", 34.0);
    int avoidGoldForest = rmCreateTypeDistanceConstraint("avoid gold 2", "gold", 9.0);
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
    int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water 5", "Land", false, 5.0);
    int avoidWater6 = rmCreateTerrainDistanceConstraint("avoid water 6", "Land", false, 6.5);

   
if(cNumberNonGaiaPlayers>2){
    //non 1v1 code, unchanged
	// FAST COIN
    silverID = -1;
	silverType = rmRandInt(1,10);
	int silverCount = (cNumberNonGaiaPlayers*5);
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,1);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, avoidFastCoin);
		rmAddObjectDefConstraint(silverID, avoidAll);
		rmAddObjectDefConstraint(silverID, avoidWater8);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidStartingUnits);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }
}else{
//1v1 mines         
    int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 1.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, 22);
    rmAddObjectDefConstraint(topMine, avoidSocket2);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(topMine, forestConstraintShort);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
    rmAddObjectDefConstraint(topMine, circleConstraint2);  
    rmAddObjectDefConstraint(topMine, avoidWater5);  
    rmAddObjectDefConstraint(topMine, avoidAll2);       
    //west
    //top->bot->mid
    rmPlaceObjectDefAtLoc(topMine, 0, 0.3, 0.88, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.12, 0.7, 1);
    //rmPlaceObjectDefAtLoc(topMine, 0, 0.18, 0.82, 1);//mid
    //east
    rmPlaceObjectDefAtLoc(topMine, 0, 0.76, 0.24, 1);
    //
    /*
    //west right-angle corner mines, where the river turns inland on the west
    rmPlaceObjectDefAtLoc(topMine, 0, 0.485, 0.635, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.365, 0.515, 1);
    */
    //TR mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.93, 0.6, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.4, 0.07, 1);
    //east right-angle corner mines, where the river forks on the east
    rmPlaceObjectDefAtLoc(topMine, 0, 0.75, 0.52, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.48, 0.25, 1);
    //western player shores
    rmPlaceObjectDefAtLoc(topMine, 0, 0.1, 0.3, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.7, 0.9, 1);
    
    /*
    int marker1 = rmCreateArea("marker1");
    rmSetAreaSize(marker1, 0.01, 0.01);
    rmSetAreaLocation(marker1, 0.3, 0.47);
    rmSetAreaBaseHeight(marker1, 2.0);
    rmSetAreaCoherence(marker1, 1.0);
    rmSetAreaTerrainType(marker1, "texas\ground4_tex");
    rmBuildArea(marker1); 

    int marker2 = rmCreateArea("marker2");
    rmSetAreaSize(marker2, 0.01, 0.01);
    rmSetAreaLocation(marker2, 0.53, 0.7);
    rmSetAreaBaseHeight(marker2, 2.0);
    rmSetAreaCoherence(marker2, 1.0);
    rmSetAreaTerrainType(marker2, "texas\ground4_tex");
    rmBuildArea(marker2);
    */
}

	// FORESTS
   int forestTreeID = 0;
   int numTries=8*cNumberNonGaiaPlayers;
   int failCount=0;
   int whichForest=-1;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest "+i);
		 whichForest=rmRandInt(1, 2);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(300));
         if ( whichForest == 1 )
		 {
			rmSetAreaForestType(forest, "NW Territory Birch Forest");
		 }
		 else
		 {
			 rmSetAreaForestType(forest, "NW Territory Forest");
		 }
         rmSetAreaForestDensity(forest, 0.8);
         rmSetAreaForestClumpiness(forest, 0.4);
         rmSetAreaForestUnderbrush(forest, 0.8);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
         if(cNumberNonGaiaPlayers==2){   
            rmAddAreaConstraint(forest, avoidGoldForest);
          }
         rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRoute); 
		 rmAddAreaConstraint(forest, avoidStartingUnits); 
         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==5)
               break;
         }
         else
            failCount=0; 
      } 

	// Define and place Nuggets
  
  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.85;
    float yLoc = 0.0;
    float walk = 0.075;
    
    if(randLoc == 1 || cNumberTeams > 2)
      xLoc = .15;
    
    ypKingsHillPlacer(xLoc, (1.0-xLoc), walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+(1.0-xLoc));
  }
    
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidWater20);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
	rmSetNuggetDifficulty(1, 2);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*rmRandInt(7,8));
if(cNumberNonGaiaPlayers>2){
	int elkID=rmCreateObjectDef("elk herd");
	int bonusChance=rmRandFloat(0, 1);
	if(bonusChance<0.5)   
		rmAddObjectDefItem(elkID, "elk", rmRandInt(4,6), 10.0);
	else
		rmAddObjectDefItem(elkID, "elk", rmRandInt(8,10), 10.0);
	rmSetObjectDefMinDistance(elkID, 0.0);
	rmSetObjectDefMaxDistance(elkID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(elkID, avoidAll);
	rmAddObjectDefConstraint(elkID, avoidElk);
	rmAddObjectDefConstraint(elkID, avoidImpassableLand);
	rmAddObjectDefConstraint(elkID, avoidStartingUnits);
	rmSetObjectDefCreateHerd(elkID, true);
	rmPlaceObjectDefAtLoc(elkID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);

	int mooseID=rmCreateObjectDef("moose herd");
	bonusChance=rmRandFloat(0, 1);
	if(bonusChance<0.5)   
		rmAddObjectDefItem(mooseID, "moose", rmRandInt(4,6), 10.0);
	else
		rmAddObjectDefItem(mooseID, "moose", rmRandInt(8,10), 10.0);
	rmSetObjectDefMinDistance(mooseID, 0.0);
	rmSetObjectDefMaxDistance(mooseID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(mooseID, avoidAll);
	rmAddObjectDefConstraint(mooseID, avoidMoose);
	rmAddObjectDefConstraint(mooseID, avoidImpassableLand);
	rmAddObjectDefConstraint(mooseID, avoidStartingUnits);
	rmSetObjectDefCreateHerd(mooseID, true);
	rmPlaceObjectDefAtLoc(mooseID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	// Two extra Moose Herds on the "Western" half of the map
	int mooseID2=rmCreateObjectDef("moose herd west");
	rmAddObjectDefItem(mooseID2, "moose", rmRandInt(5,7), 10.0);
	rmSetObjectDefMinDistance(mooseID2, 0.0);
	rmSetObjectDefMaxDistance(mooseID2, rmXFractionToMeters(0.2));
	rmAddObjectDefConstraint(mooseID2, avoidAll);
	rmAddObjectDefConstraint(mooseID2, avoidMoose);
	rmAddObjectDefConstraint(mooseID2, Westward);
	rmAddObjectDefConstraint(mooseID2, avoidImpassableLand);
	rmSetObjectDefCreateHerd(mooseID2, true);
	rmPlaceObjectDefAtLoc(mooseID2, 0, 0.2, 0.8, 2);
}else{
//1v1 hunts
        //elk for center continents
        int mapElk = rmCreateObjectDef("mapElk");
        rmAddObjectDefItem(mapElk, "elk", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(mapElk, true);
        rmSetObjectDefMinDistance(mapElk, 0);
        rmSetObjectDefMaxDistance(mapElk, 18);
        rmAddObjectDefConstraint(mapElk, avoidSocket2);
        rmAddObjectDefConstraint(mapElk, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(mapElk, forestConstraintShort);	
        rmAddObjectDefConstraint(mapElk, avoidHunt2);
        rmAddObjectDefConstraint(mapElk, avoidAll);       
        rmAddObjectDefConstraint(mapElk, circleConstraint2);    
        rmAddObjectDefConstraint(mapElk, avoidWater6);
       //east bot->top
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.76, 0.45, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.55, 0.24, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.875, 0.6, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.4, 0.125, 1);
        //west player shore elks
        //top->bot
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.3, 0.47, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.53, 0.7, 1);
            //
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.2, 0.2, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.8, 0.8, 1);
        
        //moose for left and right continents
        int mapMoose = rmCreateObjectDef("mapMoose");
        rmAddObjectDefItem(mapMoose, "moose", rmRandInt(4,5), 6.0);
        rmSetObjectDefCreateHerd(mapMoose, true);
        rmSetObjectDefMinDistance(mapMoose, 0);
        rmSetObjectDefMaxDistance(mapMoose, 15);
        rmAddObjectDefConstraint(mapMoose, avoidSocket2);
        rmAddObjectDefConstraint(mapMoose, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(mapMoose, forestConstraintShort);	
        rmAddObjectDefConstraint(mapMoose, avoidHunt3);
        rmAddObjectDefConstraint(mapMoose, avoidAll);       
        rmAddObjectDefConstraint(mapMoose, circleConstraint2);    
        rmAddObjectDefConstraint(mapMoose, avoidWater6);
        //east
        rmPlaceObjectDefAtLoc(mapMoose, 0, 0.76, 0.24, 1);
        //west continent
        rmPlaceObjectDefAtLoc(mapMoose, 0, 0.33, 0.9, 1);
        rmPlaceObjectDefAtLoc(mapMoose, 0, 0.1, 0.67, 1);
        rmPlaceObjectDefAtLoc(mapMoose, 0, 0.18, 0.82, 1);//mid

}

	// High-level reward nuggets on the western half of the map.
	int nuggetWestID= rmCreateObjectDef("nugget west"); 
	rmAddObjectDefItem(nuggetWestID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetWestID, 0.0);
	rmSetObjectDefMaxDistance(nuggetWestID, rmXFractionToMeters(0.2));
  	rmAddObjectDefConstraint(nuggetWestID, avoidNugget);
  	rmAddObjectDefConstraint(nuggetWestID, Westward);
	rmAddObjectDefConstraint(nuggetWestID, circleConstraint);
  	rmAddObjectDefConstraint(nuggetWestID, avoidImpassableLand);
    if(cNumberNonGaiaPlayers==2 || rmGetIsTreaty() == true){
        rmSetNuggetDifficulty(3, 3);
    }else{
        rmSetNuggetDifficulty(3, 4);
    }
	rmPlaceObjectDefAtLoc(nuggetWestID, 0, 0.2, 0.8, cNumberNonGaiaPlayers);

	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 3, 9.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, Westward);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	
	//Added by Paul
	//int randomWaterFlowID=rmCreateObjectDef("random flow in water");
	//rmAddObjectDefItem(randomWaterFlowID, "RiverEdgeFlow", 1, 0);
	//rmSetObjectDefMinDistance(randomWaterFlowID, 0.0);
	//rmSetObjectDefMaxDistance(randomWaterFlowID, rmXFractionToMeters(0.5));
	//rmPlaceObjectDefAtLoc(randomWaterFlowID, 0, 0.5, 0.5, 40*cNumberNonGaiaPlayers);
	
	//Added by Paul
	//int randomWaterFlowingID=rmCreateObjectDef("random flowing in water");
	//rmAddObjectDefItem(randomWaterFlowingID, "RiverFlow", 1, 0);
	//rmSetObjectDefMinDistance(randomWaterFlowingID, 0.0);
	//rmSetObjectDefMaxDistance(randomWaterFlowingID, rmXFractionToMeters(0.5));
	//rmPlaceObjectDefAtLoc(randomWaterFlowingID, 0, 0.5, 0.5, 80*cNumberNonGaiaPlayers);
	
   rmSetStatusText("",1.0);
}  
