// YUKON
// November 2003
// November 06 - YP update
// 1v1 resource balance and update by Durokan for DE
// February 2021 edited by vividlyplain, updated April 2021
// LARGE version by vividlyplain July 2021

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;

	// Only 2 natives this map
	int whichNative=rmRandInt(1,2);
	if ( whichNative == 1 )
	{
		if (rmAllocateSubCivs(2) == true)
		{
			subCiv0=rmGetCivID("Klamath");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "Klamath");

			subCiv1=rmGetCivID("Klamath");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Klamath");
		}
	}
	else
	{
		if (rmAllocateSubCivs(2) == true)
		{
			subCiv0=rmGetCivID("Nootka");
			if (subCiv0 >= 0)
				rmSetSubCiv(0, "Nootka");

			subCiv1=rmGetCivID("Nootka");
			if (subCiv1 >= 0)
				rmSetSubCiv(1, "Nootka");
		}
	}

	// Which map - four possible variations (excluding which end the players start on, which is a separate thing)
	// int whichMap=rmRandInt(1,4);
	int whichMap=2;

   // Picks the map size
	if (cNumberNonGaiaPlayers < 5)
		int playerTiles=20000;
	else
		playerTiles=28000;


	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Picks a default water height
   rmSetSeaLevel(4.5);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	//	rmAddMapTerrainByHeightInfo("yukon\ground2_yuk", 6.0, 9.0, 1.0);
	//	rmAddMapTerrainByHeightInfo("yukon\ground3_yuk", 9.0, 16.0);
   rmSetSeaType("Yukon River4");
	rmSetBaseTerrainMix("yukon snow");
   rmTerrainInitialize("yukon\ground1_yuk", 6);
   rmSetLightingSet("Yukon_Skirmish");
	rmSetMapType("yukon");
	rmSetMapType("snow");
	rmSetMapType("land");

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();

	// Make it snow
   rmSetGlobalSnow( 0.7 );

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   int classSocket=rmDefineClass("socketClass");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("classMountain");
	rmDefineClass("nuggets");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	int coinEdgeConstraint=rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.02);
   int shortPlayerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 12.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.5, 1, 1);
	int SEconstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 1, 0.5);
	int NEconstraint = rmCreateBoxConstraint("stay in NE portion", 0.5, 0, 1, 1);
	int SWconstraint = rmCreateBoxConstraint("stay in SW portion", 0, 0.0, 0.5, 1);
	int extremeSEconstraint = rmCreateBoxConstraint("stay deep into SE portion", 0, 0, 1, 0.4);
   
	// Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
 
   // Nature avoidance
   // int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   // int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int northForestConstraint=rmCreateClassDistanceConstraint("n forest vs. forest", rmClassID("classForest"), 18.0);
   int southForestConstraint=rmCreateClassDistanceConstraint("s forest vs. forest", rmClassID("classForest"), 24.0);
   int avoidMuskOx=rmCreateTypeDistanceConstraint("muskOx avoids muskOx", "MuskOx", 64.0);
   int avoidCaribou=rmCreateTypeDistanceConstraint("caribou avoids caribou", "Caribou", 75.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 20.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
   
   	int	coinAvoidsCoin2=-1;
    

	int coinAvoidsCoin=-1;
	if (cNumberNonGaiaPlayers < 7)
	{
		coinAvoidsCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 64.0);
        coinAvoidsCoin2=rmCreateTypeDistanceConstraint("coin avoids coin2", "gold", 80.0);
	}
	else
	{
		coinAvoidsCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 60.0);
        coinAvoidsCoin2=rmCreateTypeDistanceConstraint("coin avoids coin2", "gold", 75.0);

	}

   int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
   	int avoidAll3=rmCreateTypeDistanceConstraint("avoid all3", "all", 2.0);

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
   int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
   int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int mountainAvoidMountain=rmCreateClassDistanceConstraint("mountain vs. mountain", rmClassID("classMountain"), 60.0);
	int avoidMountain=rmCreateClassDistanceConstraint("avoid mountain", rmClassID("classMountain"), 10.0);
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water 4", "Land", false, 4.0);
	int avoidWater12 = rmCreateTerrainDistanceConstraint("avoid water 12", "Land", false, 12.0);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 12.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 8.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
   int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int avoidTradeRouteNugget = rmCreateTradeRouteDistanceConstraint("trade route nugget", 7.0);
   int avoidTradeRouteForest = rmCreateTradeRouteDistanceConstraint("trade route forest", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 50.0);

	// Durokan's 1v1 constraints - moved up in code by vividlyplain
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 4.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 3.0);
	
   // -------------Define objects
   // These objects are all defined so they can be placed later

   rmSetStatusText("",0.10);

   // *** Set up player starting locations. Circular around the outside of the map.  If WherePlayers == 1, then it's south.
   // int wherePlayers=rmRandInt(1,2);
   int wherePlayers = 1;
   if ( cNumberTeams == 2 && cNumberNonGaiaPlayers < 6 )
	{
		rmSetPlacementSection(0.3, 0.7);
		rmSetTeamSpacingModifier(0.8);
		rmPlacePlayersCircular(0.36, 0.36, 0);
	}
   else if ( cNumberTeams == 2 )
   {
		rmSetPlacementSection(0.28, 0.72);
		rmSetTeamSpacingModifier(0.9);
		rmPlacePlayersCircular(0.38, 0.38, 0);
   }
   else if ( cNumberNonGaiaPlayers < 7 )
   {
		rmSetPlacementSection(0.3, 0.7);
		rmPlacePlayersCircular(0.38, 0.38, 0);
   }
   else
   {
		rmSetPlacementSection(0.22, 0.775);
		rmPlacePlayersCircular(0.40, 0.40, 0); 	// rmPlacePlayersCircular(0.42, 0.42, rmDegreesToRadians(5));
   }
//	rmPlacePlayersCircular(0.40, 0.40, 0); 		// rmPlacePlayersCircular(0.42, 0.42, rmDegreesToRadians(5));
    
   // Build a north area
   int northIslandID = rmCreateArea("north island");
   rmSetAreaLocation(northIslandID, 0.5, 0.75); 
   rmSetAreaWarnFailure(northIslandID, false);

	rmSetAreaElevationType(northIslandID, cElevTurbulence);
   rmSetAreaElevationVariation(northIslandID, 5.0);
   rmSetAreaBaseHeight(northIslandID, 5.0);
   rmSetAreaElevationMinFrequency(northIslandID, 0.07);
   rmSetAreaElevationOctaves(northIslandID, 4);
   rmSetAreaElevationPersistence(northIslandID, 0.5);
	rmSetAreaElevationNoiseBias(northIslandID, 1);

	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
	//	rmSetMapElevationParameters(cElevTurbulence, 0.02, 4, 0.5, 8.0);

   rmSetAreaSize(northIslandID, 1.0, 1.0);
   rmSetAreaCoherence(northIslandID, 1.0);
   rmAddAreaConstraint(northIslandID, NWconstraint);
   rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
   rmSetAreaTerrainType(northIslandID, "yukon\ground1_yuk");
	rmSetAreaMix(northIslandID, "yukon snow");
   rmBuildArea(northIslandID);

	//	rmPaintAreaTerrainByHeight(northIslandID, "yukon\ground2_yuk", 6, 10);
	//	rmPaintAreaTerrainByHeight(northIslandID, "yukon\ground3_yuk", 10, 16);

   // Text
   rmSetStatusText("",0.20);

   // Build a south area
   int southIslandID = rmCreateArea("south island");
   rmSetAreaLocation(southIslandID, 0.5, 0); 
   rmSetAreaWarnFailure(southIslandID, false);
	rmSetAreaElevationType(southIslandID, cElevTurbulence);
   rmSetAreaElevationVariation(southIslandID, 5.0);
   rmSetAreaBaseHeight(southIslandID, 5.0);
   rmSetAreaElevationMinFrequency(southIslandID, 0.07);
   rmSetAreaElevationOctaves(southIslandID, 4);
   rmSetAreaElevationPersistence(southIslandID, 0.5);
	rmSetAreaElevationNoiseBias(southIslandID, 1); 
   rmSetAreaSize(southIslandID, 0.20, 0.20);
   rmSetAreaCoherence(southIslandID, 0.10);
   rmAddAreaInfluenceSegment(southIslandID, 0, 0, 1, 0);
   //rmAddAreaConstraint(southIslandID, SEconstraint);
   rmSetAreaTerrainType(southIslandID, "yukon\ground6_yuk");
   rmAddAreaTerrainLayer(southIslandID, "yukon\ground4_yuk", 0, 3);
   rmAddAreaTerrainLayer(southIslandID, "yukon\ground5_yuk", 3, 6);
   rmAddAreaTerrainLayer(southIslandID, "yukon\ground6_yuk", 6, 8);
   rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
	rmSetAreaMix(southIslandID, "yukon grass");
   rmBuildArea(southIslandID);
   //	rmPaintAreaTerrainByHeight(southIslandID, "yukon\ground6_yuk", 9, 16);

   // Text
   rmSetStatusText("",0.30);

	// TRADE ROUTES
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
//	rmAddObjectDefConstraint(socketID, avoidImpassableLand);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	
	if(whichMap < 4) // one trade route
	{
		int tradeRouteID = rmCreateTradeRoute();
		
		rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.5);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.5);

		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
		if(placedTradeRoute == false)
			rmEchoError("Failed to place trade route");

		// add the sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.6);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}
	else // dual trade routes
	{
		int tradeRoute1ID = rmCreateTradeRoute();
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.3, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.3, 1.0, 8, 10);

		bool placedTradeRoute1 = rmBuildTradeRoute(tradeRoute1ID, "dirt");
		if(placedTradeRoute1 == false)
			rmEchoError("Failed to place trade route one");

		// add the meeting sockets along the trade route.
        rmSetObjectDefTradeRouteID(socketID, tradeRoute1ID);
		vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.1);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, 0.9);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	
		int tradeRoute2ID = rmCreateTradeRoute();
		rmAddTradeRouteWaypoint(tradeRoute2ID, 0.7, 0.0);
		rmAddRandomTradeRouteWaypoints(tradeRoute2ID, 0.7, 1.0, 8, 10);

		bool placedTradeRoute2 = rmBuildTradeRoute(tradeRoute2ID, "dirt");
		if(placedTradeRoute2 == false)
			rmEchoError("Failed to place trade route 2");

		// add the meeting sockets along the trade route.
      rmSetObjectDefTradeRouteID(socketID, tradeRoute2ID);
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.1);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.9);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc2);
	}

	// River - a river 75% of the time - most of the time n/s, once in a while e/w
	int riverID = -1;
	if(whichMap > 1)
	{
		// DAL - always three shallows now
		if(whichMap > 2) // NS river
		{
			if ( cNumberNonGaiaPlayers < 4 )
			{
				riverID = rmRiverCreate(-1, "Yukon River4", 8, 8, 6, 8);
			}
			else
			{
				riverID = rmRiverCreate(-1, "Yukon River4", 12, 12, 7, 9);
			}
			rmRiverSetConnections(riverID, 0.5, 0, 0.5, 1.0);
			rmRiverSetShallowRadius(riverID, 10);
			rmRiverAddShallow(riverID, rmRandFloat(0.1, 0.2));
			rmRiverAddShallow(riverID, rmRandFloat(0.4, 0.6));
			rmRiverAddShallow(riverID, rmRandFloat(0.8, 0.9));
			rmRiverAvoid(riverID, socketID, 8.0);
			rmRiverSetBankNoiseParams(riverID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(riverID);
		}
		else // EW river
		{
			if ( cNumberNonGaiaPlayers < 4 )
			{
				riverID = rmRiverCreate(-1, "Yukon River4", 8, 8, 6, 7);
			}
			else
			{
				riverID = rmRiverCreate(-1, "Yukon River4", 12, 12, 7, 9);
			}
			if ( cNumberNonGaiaPlayers < 4 )
			{
				rmRiverSetConnections(riverID, 0, 0.62, 1, 0.62);
			}
			else
			{
				rmRiverSetConnections(riverID, 0, 0.65, 1, 0.65);
			}
			rmRiverSetShallowRadius(riverID, 10);
			// Half the time, a center crossing point
            //added in the central crossing always if players = 2
			if((rmRandFloat(0,1) < 0.5) || (cNumberNonGaiaPlayers==2)){
				rmRiverAddShallow(riverID, rmRandFloat(0.5, 0.5));
            }
			rmRiverAddShallow(riverID, rmRandFloat(0.1, 0.2));
			rmRiverAddShallow(riverID, rmRandFloat(0.8, 0.9));
			rmRiverSetBankNoiseParams(riverID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
			rmRiverBuild(riverID);
		}
	}

	// Mid Island for Avoidance
	int midIslandID = rmCreateArea("mid island");
	rmSetAreaLocation(midIslandID, 0.50, 0.50);
	rmSetAreaWarnFailure(midIslandID, false);
	rmSetAreaSize(midIslandID,0.42+0.0025*cNumberNonGaiaPlayers, 0.42+0.0025*cNumberNonGaiaPlayers);
	rmSetAreaCoherence(midIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(midIslandID, false);
//	rmSetAreaMix(midIslandID, "testmix");   // for testing
//	rmAddAreaConstraint (midIslandID, SEconstraint);
	rmBuildArea(midIslandID); 
	
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island", midIslandID, 13.0);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 20.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay in mid island", midIslandID, 0.0);

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
      rmAddAreaConstraint(id, shortPlayerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint);
      rmAddAreaConstraint(id, avoidImpassableLand); 
      rmSetAreaLocPlayer(id, i);
		 rmSetAreaTerrainType(id, "carolina\marshflats");
		// rmSetAreaBaseHeight(id, 8.0);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
   
	// Text
	rmSetStatusText("",0.40);

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
	
    float xLoc = 0.5;
    float yLoc = 0.4;
    float walk = 0.0;
		
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
	}
    int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 12.0);

    //STARTING UNITS and RESOURCES DEFS
    //1v1 stuff
    int classStartingResource = rmDefineClass("startingResource");
	int avoidStartingResourcesFar  = rmCreateClassDistanceConstraint("start resources avoid each other far", rmClassID("startingResource"), 30.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other 2", rmClassID("startingResource"), 16.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other 2 short", rmClassID("startingResource"), 4.0);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 6.0);

	int startingTCID = rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	rmAddObjectDefToClass(startingTCID, classStartingResource);
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 0.0);

	int playerGoldID=-1;
	int silverType = -1;
	int silverID = -1;

	int StartCaribouID=rmCreateObjectDef("starting caribou");
	rmAddObjectDefItem(StartCaribouID, "caribou", 8, 3.0);
	rmSetObjectDefMinDistance(StartCaribouID, 13.0);
	rmSetObjectDefMaxDistance(StartCaribouID, 14.0);
	rmAddObjectDefToClass(StartCaribouID, classStartingResource);
	rmSetObjectDefCreateHerd(StartCaribouID, true);
	rmAddObjectDefConstraint(StartCaribouID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartCaribouID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartCaribouID, avoidAll);

	int StartCaribouID2=rmCreateObjectDef("starting caribou 2");
	rmAddObjectDefItem(StartCaribouID2, "caribou", 8, 4.0);
	rmSetObjectDefMinDistance(StartCaribouID2, 26.0);
	rmSetObjectDefMaxDistance(StartCaribouID2, 28.0);
	rmAddObjectDefToClass(StartCaribouID2, classStartingResource);
	rmSetObjectDefCreateHerd(StartCaribouID2, true);
	rmAddObjectDefConstraint(StartCaribouID2, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartCaribouID2, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartCaribouID2, avoidAll);
	rmAddObjectDefConstraint(StartCaribouID2, avoidMidIslandMin);

	int StartCaribouID3=rmCreateObjectDef("starting caribou 3");
	rmAddObjectDefItem(StartCaribouID3, "caribou", 8, 5.0);
	rmSetObjectDefMinDistance(StartCaribouID3, 40.0);
	rmSetObjectDefMaxDistance(StartCaribouID3, 40.0);
	rmAddObjectDefToClass(StartCaribouID3, classStartingResource);
	rmSetObjectDefCreateHerd(StartCaribouID3, true);
	rmAddObjectDefConstraint(StartCaribouID3, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartCaribouID3, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartCaribouID3, avoidAll);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(StartCaribouID3, stayMidIsland);
	else
		rmAddObjectDefConstraint(StartCaribouID3, avoidMidIslandFar);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 20.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);
    
    int baseGold = rmCreateObjectDef("base gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold, 14.0);
    rmSetObjectDefMaxDistance(baseGold, 14.0);
   	rmAddObjectDefToClass(baseGold, classStartingResource);
	rmAddObjectDefConstraint(baseGold, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(baseGold, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(baseGold, stayMidIsland);

    int baseGold2 = rmCreateObjectDef("base gold2");
    rmAddObjectDefItem(baseGold2, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold2, 24.0);
    rmSetObjectDefMaxDistance(baseGold2, 26.0);
   	rmAddObjectDefToClass(baseGold2, classStartingResource);
	rmAddObjectDefConstraint(baseGold2, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(baseGold2, avoidSocket2);
	rmAddObjectDefConstraint(baseGold2, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold2, avoidStartingResources);
	rmAddObjectDefConstraint(baseGold2, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(baseGold2, avoidMidIslandMin);
	rmAddObjectDefConstraint(baseGold2, avoidCoin);
    
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeYukon", 2, 2.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 15.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
   	rmAddObjectDefToClass(StartAreaTreeID, classStartingResource);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingResourcesShort);

	int StartAreaTree2ID=rmCreateObjectDef("starting trees2");
	rmAddObjectDefItem(StartAreaTree2ID, "TreeYukon", 10, 8.0);
	rmSetObjectDefMinDistance(StartAreaTree2ID, 30.0);
	rmSetObjectDefMaxDistance(StartAreaTree2ID, 33.0);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingUnitsSmall);
   	rmAddObjectDefToClass(StartAreaTree2ID, classStartingResource);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidMidIslandMin);
    
	// Player placement
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		// vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		// rmSetHomeCityGatherPoint(i, closestPoint);
    if(cNumberNonGaiaPlayers>2){
		// Everyone gets one ore grouping.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);			
		rmAddObjectDefToClass(playerGoldID, classStartingResource);
		rmSetObjectDefMinDistance(playerGoldID, 14.0);
		rmSetObjectDefMaxDistance(playerGoldID, 14.0);
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidImpassableLand);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmAddObjectDefConstraint(playerGoldID, stayMidIsland);
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    }else{
        rmPlaceObjectDefAtLoc(baseGold, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(baseGold2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    }
		rmPlaceObjectDefAtLoc(StartCaribouID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartCaribouID2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
		rmPlaceObjectDefAtLoc(StartCaribouID3, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));	
        rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Nuggets
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	// Text
	rmSetStatusText("",0.50);

	int creeVillageAID = -1;
	int creeVillageType = rmRandInt(1,5);
	if ( whichNative == 1 )
	{
		creeVillageAID = rmCreateGrouping("Klamath village A", "native klamath village "+creeVillageType);
	}
	else
	{
		creeVillageAID = rmCreateGrouping("Nootka village A", "native nootka village "+creeVillageType);
	}
	rmSetGroupingMinDistance(creeVillageAID, 0.0);
	rmSetGroupingMaxDistance(creeVillageAID, 0.0);
	// rmSetGroupingMaxDistance(creeVillageAID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(creeVillageAID, avoidImpassableLand);
	// rmAddGroupingConstraint(creeVillageAID, playerEdgeConstraint);
	rmAddGroupingToClass(creeVillageAID, rmClassID("natives"));
	rmAddGroupingToClass(creeVillageAID, rmClassID("importantItem"));
	rmAddGroupingConstraint(creeVillageAID, avoidTradeRoute);
	if ( whichMap == 4 )
	{
		rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.9, 0.5);
	}
	else 
	{
		if (wherePlayers == 1 )
		{
			rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.80, 0.80);
		}
		else
		{
			rmPlaceGroupingAtLoc(creeVillageAID, 0, 0.80, 0.20);
		}
	}

	int creeVillageBID = -1;
	creeVillageType = rmRandInt(1,5);
	if ( whichNative == 1 )
	{
		creeVillageBID = rmCreateGrouping("Klamath village B", "native klamath village "+creeVillageType);
	}
	else
	{
		creeVillageBID = rmCreateGrouping("Nootka village B", "native nootka village "+creeVillageType);
	}
	rmSetGroupingMinDistance(creeVillageBID, 0.0);
	rmSetGroupingMaxDistance(creeVillageBID, 0.0);
	// rmSetGroupingMaxDistance(creeVillageBID, rmXFractionToMeters(0.05));
	rmAddGroupingConstraint(creeVillageBID, avoidImpassableLand);
	// rmAddGroupingConstraint(creeVillageBID, playerEdgeConstraint);
	rmAddGroupingToClass(creeVillageBID, rmClassID("natives"));
	rmAddGroupingToClass(creeVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(creeVillageBID, avoidTradeRoute);
	if ( whichMap == 4 )
	{
		rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.1, 0.5);
	}
	else
	{
		if ( wherePlayers == 1 )
		{
			rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.20, 0.80);
		}
		else
		{
			rmPlaceGroupingAtLoc(creeVillageBID, 0, 0.20, 0.15);
		}
	}	

	// Text
	rmSetStatusText("",0.50);
	int numTries = -1;
	int failCount = -1;

	// Text
	rmSetStatusText("",0.60);
	
	// Taking out Ruins - BH promises replacement with something else.
	/*
   int RuinID=rmCreateObjectDef("Inuksuk");
	rmAddObjectDefItem(RuinID, "Inuksuk", 1);
	rmSetObjectDefMinDistance(RuinID, 0);
	rmSetObjectDefMaxDistance(RuinID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(RuinID, avoidTradeRoute);
	rmAddObjectDefConstraint(RuinID, avoidImportantItem);
   rmAddObjectDefConstraint(RuinID, playerConstraint);
   rmAddObjectDefConstraint(RuinID, avoidImpassableLand);
	rmAddObjectDefToClass(RuinID, rmClassID("classMountain"));
	rmPlaceObjectDefAtLoc(RuinID, 0, 0.5, 0.5, 2);
	*/
  
	// Text
	rmSetStatusText("",0.70);

	// Define and place Forests - north and south
	int forestTreeID = 0;
	// These constraints keep forests from mucking up the transition zone between grass and snow
	// DAL - think these are basically killing placement for most of these things...
	int forestNWconstraint = rmCreateEdgeDistanceConstraint("north forest avoid edge", northIslandID, 10);
	int forestSEconstraint = rmCreateEdgeDistanceConstraint("south forest avoid edge", southIslandID, 10);

	numTries=2+2*cNumberNonGaiaPlayers;  
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestID=rmCreateArea("forestID"+i);
			rmSetAreaWarnFailure(forestID, false);
			rmSetAreaSize(forestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
			rmSetAreaForestType(forestID, "yukon forest");
			rmSetAreaForestDensity(forestID, .9);
			rmSetAreaForestClumpiness(forestID, 0.7);		
			rmSetAreaForestUnderbrush(forestID, 0.0);
			rmSetAreaCoherence(forestID, 0.4);
			rmAddAreaToClass(forestID, rmClassID("classForest"));
			rmAddAreaConstraint(forestID, southForestConstraint);  
			rmAddAreaConstraint(forestID, avoidTradeRouteForest);
			rmAddAreaConstraint(forestID, extremeSEconstraint);
			rmAddAreaConstraint(forestID, avoidMountain);
			rmAddAreaConstraint(forestID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestID, shortPlayerConstraint);
			rmAddAreaConstraint(forestID, avoidAll3);
			rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
			rmAddAreaConstraint(forestID, avoidKOTH);
			rmAddAreaConstraint(forestID, avoidStartingResources);
			rmAddAreaConstraint(forestID, avoidStartingUnits);
			if(rmBuildArea(forestID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		} 

	// Snow forests get placed later, to avoid screws.
	numTries=2+8*cNumberNonGaiaPlayers;  
	failCount=0;
	for (i=0; <numTries)
		{   
			int snowforestID=rmCreateArea("snowforestID"+i);
			rmSetAreaWarnFailure(snowforestID, false);
			rmSetAreaSize(snowforestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
			rmSetAreaForestType(snowforestID, "yukon snow forest");
			rmSetAreaForestDensity(snowforestID, .9);
			rmSetAreaForestClumpiness(snowforestID, 0.7);		
			rmSetAreaForestUnderbrush(snowforestID, 0.0);
			rmSetAreaCoherence(snowforestID, 0.4);
			rmSetAreaSmoothDistance(snowforestID, 10);
			rmAddAreaToClass(snowforestID, rmClassID("classForest"));
			rmAddAreaConstraint(snowforestID, northForestConstraint);
			rmAddAreaConstraint(snowforestID, avoidTradeRouteForest);
			// rmAddAreaConstraint(snowforestID, NWconstraint);
			rmAddAreaConstraint(snowforestID, avoidMountain);
            rmAddAreaConstraint(snowforestID, avoidAll3);
			rmAddAreaConstraint(snowforestID, shortAvoidImportantItem);
			rmAddAreaConstraint(snowforestID, shortPlayerConstraint);
			rmAddAreaConstraint(snowforestID, shortAvoidImpassableLand);
			rmAddAreaConstraint(snowforestID, avoidKOTH);
			rmAddAreaConstraint(snowforestID, avoidStartingResources);
			rmAddAreaConstraint(snowforestID, avoidStartingUnits);
			if(rmBuildArea(snowforestID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		} 

	int silverCount1 = cNumberNonGaiaPlayers;
	int silverCount2 = cNumberNonGaiaPlayers*2;
	rmEchoInfo("silver count 1 = "+silverCount1);
	rmEchoInfo("silver count 2 = "+silverCount2);

  //constraints for durokan's 1v1 balance

    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 2.0);
    int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);

    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 25.0);
    int avoidHunt3=rmCreateTypeDistanceConstraint("herds avoid herds3", "huntable", 23.0);
    int avoidHunt4=rmCreateTypeDistanceConstraint("herds avoid herds4", "huntable", 35.0);
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type 2 far ", "gold", 50.0);
    int avoidGoldForest = rmCreateTypeDistanceConstraint("avoid gold 2", "gold", 9.0);
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
    int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 5.0);
    int avoidWater6 = rmCreateTerrainDistanceConstraint("avoid water medium6", "Land", false, 6.5);
    
    rmDefineClass("farSide");
    rmDefineClass("closeSide");
    int avoidFarSide=rmCreateClassDistanceConstraint("avoid far side of river", rmClassID("farSide"), 15.0);
    int avoidCloseSide=rmCreateClassDistanceConstraint("avoid close side of river", rmClassID("closeSide"), 15.0);
   
    int acrossRiver = rmCreateArea("acrossRiver");
    rmSetAreaSize(acrossRiver, 0.25, 0.25); 
    rmAddAreaToClass(acrossRiver, rmClassID("farSide"));
    rmSetAreaCoherence(acrossRiver, 1.0);
    rmSetAreaLocation(acrossRiver, .18, .85);
    //rmSetAreaBaseHeight(acrossRiver, 2.0);
    //rmSetAreaTerrainType(acrossRiver, "texas\ground4_tex");
    rmAddAreaInfluenceSegment(acrossRiver, 0.18, 0.85, .82, 0.85);
    rmBuildArea(acrossRiver); 
    
    int mainLand = rmCreateArea("mainLand");
    rmSetAreaSize(mainLand, 0.51, 0.51); 
    rmAddAreaToClass(mainLand, rmClassID("closeSide"));
    rmSetAreaCoherence(mainLand, 1.0);
    rmSetAreaLocation(mainLand, .1, .3);
    //rmSetAreaBaseHeight(mainLand, 2.0);
    //rmSetAreaTerrainType(mainLand, "texas\ground4_tex");
    rmAddAreaInfluenceSegment(mainLand, 0.1, 0.3, .9, 0.3);
    rmBuildArea(mainLand);
        
if(cNumberNonGaiaPlayers>2){
	// Two per player in the north - and these are GOLD!
	
    for(i=0; < silverCount2)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("north silver "+i);
		rmAddObjectDefItem(silverID, "mineGold", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin);
		rmAddObjectDefConstraint(silverID, avoidNatives);
		rmAddObjectDefConstraint(silverID, coinEdgeConstraint);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteForest);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, avoidWater12);
		//rmAddObjectDefConstraint(silverID, Northward);
		rmAddObjectDefConstraint(silverID, avoidCloseSide);
		rmAddObjectDefConstraint(silverID, avoidKOTH);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.95);
   }
/*
	// One per player in the "east"
	for(i=0; < silverCount1)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("east silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, Eastward);
		rmAddObjectDefConstraint(silverID, avoidWater12);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }

	// One per player in the "west"
	for(i=0; < silverCount1)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("west silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, Westward);
		rmAddObjectDefConstraint(silverID, avoidWater12);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5); 
   }*/
        
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("map silver");
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(silverID, coinAvoidsCoin2);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(silverID, playerConstraint);
		rmAddObjectDefConstraint(silverID, avoidFarSide);
		rmAddObjectDefConstraint(silverID, avoidWater12);
        rmAddObjectDefConstraint(silverID, circleConstraint2);  
        rmAddObjectDefConstraint(silverID, avoidKOTH);  

		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers); 
}else{
//1v1 mines
    int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 1.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, rmXFractionToMeters(0.05));
    rmAddObjectDefConstraint(topMine, avoidSocket2);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(topMine, forestConstraintShort);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
    rmAddObjectDefConstraint(topMine, circleConstraint2);  
    rmAddObjectDefConstraint(topMine, avoidWater6);  
    rmAddObjectDefConstraint(topMine, avoidAll2);  
    rmAddObjectDefConstraint(topMine, avoidKOTH);  
    
    int riverMine = rmCreateObjectDef("riverMine");
    rmAddObjectDefItem(riverMine, "mineGold", 1, 1.0);
    rmSetObjectDefMinDistance(riverMine, 0.0);
    rmSetObjectDefMaxDistance(riverMine, rmXFractionToMeters(0.10));
    rmAddObjectDefConstraint(riverMine, avoidSocket2);
    rmAddObjectDefConstraint(riverMine, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(riverMine, forestConstraintShort);
    rmAddObjectDefConstraint(riverMine, avoidGoldTypeFar);
    rmAddObjectDefConstraint(riverMine, circleConstraint2);  
    rmAddObjectDefConstraint(riverMine, avoidWater6);  
    rmAddObjectDefConstraint(riverMine, avoidAll2);  
    rmAddObjectDefConstraint(riverMine, avoidKOTH);  
    rmAddObjectDefConstraint(riverMine, avoidNatives);  
    
    //mines across river
    //mines closer to river crossings on west side
    rmPlaceObjectDefAtLoc(riverMine, 0, 0.74, 0.77, 1);   
    rmPlaceObjectDefAtLoc(riverMine, 0, 0.26, 0.77, 1);   
    //top on west side (possibly make this one 5k gold stack)
    rmPlaceObjectDefAtLoc(riverMine, 0, 0.5, 0.87, 1);

int mineVariation = rmRandInt(1,2);
//mineVariation = 2; //test

if(mineVariation == 1){
  //eastern forest gold
    //rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.25, 1); //maybe save for a variant
    rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.11, 1); 
    rmPlaceObjectDefAtLoc(topMine, 0, 0.7, 0.2, 1); 
    rmPlaceObjectDefAtLoc(topMine, 0, 0.3, 0.2, 1); 
    
    //river mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.65, 0.48, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.35, 0.48, 1);
}else{
   //eastern forest gold
    //rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.25, 1); //maybe save for a variant
    rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.25, 1); 
    rmPlaceObjectDefAtLoc(topMine, 0, 0.63, 0.48, 1); 
    rmPlaceObjectDefAtLoc(topMine, 0, 0.37, 0.48, 1); 
    
    //river mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.68, 0.15, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.32, 0.15, 1); 
}
  

    
}

	// Text
	rmSetStatusText("",0.80);
  
  
if(cNumberNonGaiaPlayers>2){
	// Resources that can be placed after forests
	int muskOxID=rmCreateObjectDef("muskOx herd");
	rmAddObjectDefItem(muskOxID, "muskOx", rmRandInt(8,10), 8.0);
	rmSetObjectDefMinDistance(muskOxID, 0.0);
	rmSetObjectDefMaxDistance(muskOxID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(muskOxID, avoidMuskOx);
	rmAddObjectDefConstraint(muskOxID, avoidAll);
	rmAddObjectDefConstraint(muskOxID, NWconstraint);
	rmAddObjectDefConstraint(muskOxID, avoidImpassableLand);
	rmAddObjectDefConstraint(muskOxID, avoidMountain);
	rmAddObjectDefConstraint(muskOxID, playerConstraint);
	rmAddObjectDefConstraint(muskOxID, avoidKOTH);
	rmSetObjectDefCreateHerd(muskOxID, true);

	int caribouID=rmCreateObjectDef("caribou herd");
	rmAddObjectDefItem(caribouID, "caribou", rmRandInt(8,12), 8);
	rmSetObjectDefMinDistance(caribouID, 0.0);
	rmSetObjectDefMaxDistance(caribouID, rmXFractionToMeters(0.3));
	rmAddObjectDefConstraint(caribouID, avoidCaribou);
	rmAddObjectDefConstraint(caribouID, avoidAll);
	rmAddObjectDefConstraint(caribouID, SEconstraint);
	rmAddObjectDefConstraint(caribouID, avoidImpassableLand);
	rmAddObjectDefConstraint(caribouID, avoidMountain);
	rmAddObjectDefConstraint(caribouID, playerConstraint);
	rmAddObjectDefConstraint(caribouID, avoidKOTH);
	rmSetObjectDefCreateHerd(caribouID, true);

	rmPlaceObjectDefAtLoc(muskOxID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(caribouID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
}else{
//1v1 hunts

int mapElk = rmCreateObjectDef("mapElk");
    rmAddObjectDefItem(mapElk, "muskOx", rmRandInt(8,8), 6.0);
    rmSetObjectDefCreateHerd(mapElk, true);
    rmSetObjectDefMinDistance(mapElk, 0);
    rmSetObjectDefMaxDistance(mapElk, 16);
    rmAddObjectDefConstraint(mapElk, avoidSocket2);
    rmAddObjectDefConstraint(mapElk, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapElk, forestConstraintShort);	
//    rmAddObjectDefConstraint(mapElk, avoidHunt4);
    rmAddObjectDefConstraint(mapElk, avoidAll);       
    rmAddObjectDefConstraint(mapElk, circleConstraint2);    
    rmAddObjectDefConstraint(mapElk, avoidWater6);
    rmAddObjectDefConstraint(mapElk, avoidKOTH);
    
    int mapHunts = rmCreateObjectDef("mapHunts");
    rmAddObjectDefItem(mapHunts, "caribou", rmRandInt(8,8), 6.0);
    rmSetObjectDefCreateHerd(mapHunts, true);
    rmSetObjectDefMinDistance(mapHunts, 0);
    rmSetObjectDefMaxDistance(mapHunts, 13);
    rmAddObjectDefConstraint(mapHunts, avoidSocket2);
    rmAddObjectDefConstraint(mapHunts, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapHunts, forestConstraintShort);	
//    rmAddObjectDefConstraint(mapHunts, avoidHunt2);
    rmAddObjectDefConstraint(mapHunts, avoidAll);       
    rmAddObjectDefConstraint(mapHunts, circleConstraint2);    
    rmAddObjectDefConstraint(mapHunts, avoidWater6);
    rmAddObjectDefConstraint(mapHunts, avoidKOTH);
    
      
    //caribou across river
    //hunts closer to river crossings on west side
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.79, 0.75, 1);   
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.21, 0.75, 1);   
    //top on west side
    int westHuntVar = rmRandInt(1,2);
    //westHuntVar = 1; //test
    if(westHuntVar==1){
        //middle hunts look like "\"
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.92, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.72, 1);
    }else{
        //middle hunts look like /
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.62, 0.82, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.38, 0.82, 1);
    }
    
    int forestHuntVar = rmRandInt(1,2);
    //forestHuntVar = 2; //test

    if(forestHuntVar == 1){
      //eastern forest hunts
        //rmPlaceObjectDefAtLoc(mapElk, 0, 0.5, 0.25, 1); //maybe save for a variant
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.5, 0.11, 1); 
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.7, 0.2, 1); 
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.3, 0.2, 1); 
        
        //river hunts
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.65, 0.48, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.35, 0.48, 1);
    }else{
       //eastern forest hunts
        //rmPlaceObjectDefAtLoc(mapElk, 0, 0.5, 0.25, 1); //maybe save for a variant
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.5, 0.25, 1); 
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.63, 0.48, 1); 
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.37, 0.48, 1); 
        
        //river hunts
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.68, 0.15, 1);
        rmPlaceObjectDefAtLoc(mapElk, 0, 0.32, 0.15, 1); 
    }

/*
    int marker1 = rmCreateArea("marker1");
    rmSetAreaSize(marker1, 0.01, 0.01);
    rmSetAreaLocation(marker1, 0.62, 0.82);
    rmSetAreaBaseHeight(marker1, 2.0);
    rmSetAreaCoherence(marker1, 1.0);
    rmSetAreaTerrainType(marker1, "texas\ground4_tex");
    rmBuildArea(marker1); 

    int marker2 = rmCreateArea("marker2");
    rmSetAreaSize(marker2, 0.01, 0.01);
    rmSetAreaLocation(marker2, 0.38, 0.82);
    rmSetAreaBaseHeight(marker2, 2.0);
    rmSetAreaCoherence(marker2, 1.0);
    rmSetAreaTerrainType(marker2, "texas\ground4_tex");
    //rmBuildArea(marker2);
    
    int marker3 = rmCreateArea("marker3");
    rmSetAreaSize(marker3, 0.01, 0.01);
    rmSetAreaLocation(marker3, 0.79, 0.75);
    rmSetAreaBaseHeight(marker3, 2.0);
    rmSetAreaCoherence(marker3, 1.0);
    rmSetAreaTerrainType(marker3, "texas\ground4_tex");
    rmBuildArea(marker3);
*/
    
}

	// And one big nugget somewhere in the northern half.
    if(cNumberNonGaiaPlayers>2 && rmGetIsTreaty() == false){
        rmSetNuggetDifficulty(4, 4);
    }else{
        rmSetNuggetDifficulty(3, 3);
    }
	int nuggetBigID= rmCreateObjectDef("nugget big"); 
	rmAddObjectDefItem(nuggetBigID, "nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetBigID, 0.0);
	rmSetObjectDefMaxDistance(nuggetBigID, rmXFractionToMeters(0.10));
	rmAddObjectDefConstraint(nuggetBigID, avoidImpassableLand);
	rmAddObjectDefToClass(nuggetBigID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(nuggetBigID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetBigID, NWconstraint);
	rmAddObjectDefConstraint(nuggetBigID, avoidAll);
	rmAddObjectDefConstraint(nuggetBigID, avoidTradeRouteNugget);
	rmAddObjectDefConstraint(nuggetBigID, avoidNugget);
	rmAddObjectDefConstraint(nuggetBigID, circleConstraint);
	rmAddObjectDefConstraint(nuggetBigID, avoidKOTH);
	rmPlaceObjectDefAtLoc(nuggetBigID, 0, 0.5, 0.8, 2);

	// Lots of nuggets in the north - 5 per player.  Crazy!  Go get 'em!
	rmSetNuggetDifficulty(2, 3);
	int nuggetnorthID= rmCreateObjectDef("nugget north"); 
	rmAddObjectDefItem(nuggetnorthID, "nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetnorthID, 0.0);
	rmSetObjectDefMaxDistance(nuggetnorthID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetnorthID, avoidImpassableLand);
	rmAddObjectDefToClass(nuggetnorthID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(nuggetnorthID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetnorthID, NWconstraint);
	rmAddObjectDefConstraint(nuggetnorthID, avoidAll);
	rmAddObjectDefConstraint(nuggetnorthID, avoidTradeRouteNugget);
	rmAddObjectDefConstraint(nuggetnorthID, avoidNugget);
	rmAddObjectDefConstraint(nuggetnorthID, avoidKOTH);
	rmPlaceObjectDefAtLoc(nuggetnorthID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*5);

	// 1 per player in the southeast half - lower difficulty
	rmSetNuggetDifficulty(1, 1);
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmAddObjectDefToClass(nuggetID, rmClassID("importantItem"));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nuggetID, SEconstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteNugget);
	rmAddObjectDefConstraint(nuggetID, avoidAll3);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidKOTH);
	rmAddObjectDefConstraint(nuggetID, avoidStartingResourcesFar);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
	rmAddObjectDefConstraint(nuggetID, playerConstraint);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	// PAROT decorative particle 
		int particleDecorationID=rmCreateObjectDef("Particle Things");
		//int avoidparticleDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "PropDustCloud", 0.0);
		rmAddObjectDefItem(particleDecorationID, "PropBlizzard", 1, 0.0);	
		rmSetObjectDefMinDistance(particleDecorationID, 0.0);
		rmSetObjectDefMaxDistance(particleDecorationID, rmXFractionToMeters(0.60));
		rmAddObjectDefConstraint(particleDecorationID, NWconstraint);
		rmAddObjectDefConstraint(particleDecorationID, avoidAll);
		rmAddObjectDefConstraint(particleDecorationID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(particleDecorationID, circleConstraint);
		//rmAddObjectDefConstraint(particleDecorationID, avoidBigDecoration);
		//rmAddObjectDefConstraint(particleDecorationID, avoidCliffs);
		//rmAddObjectDefConstraint(particleDecorationID, avoidparticleDecoration);
		//rmAddObjectDefConstraint(particleDecorationID, Westward);
		rmPlaceObjectDefAtLoc(particleDecorationID, 0, 0.5, 0.5, 8+2*cNumberNonGaiaPlayers);
	
	// Text
	rmSetStatusText("",1.0);
}