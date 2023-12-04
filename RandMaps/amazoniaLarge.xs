// LARGE AMAZONIA
// Nov 06 - YP update
//1v1 Balance update by Durokan for DE
// February 2021 edited by vividlyplain, updated May 2021
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

   // Picks the map size
	int playerTiles = 22000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 20000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 16000;			

   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	rmSetWindMagnitude(2);

   // Picks a default water height
   rmSetSeaLevel(0.0);

   // Picks default terrain and water
	//	rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
//	rmSetMapElevationParameters(cElevTurbulence, 0.04, 4, 0.4, 6.0);
//	rmAddMapTerrainByHeightInfo("amazon\ground2_am", 8.0, 10.0);
//	rmAddMapTerrainByHeightInfo("amazon\ground1_am", 10.0, 16.0);
//   rmSetSeaType("Amazon River");
	rmSetSeaType("Amazon River Basin RM");
 	rmSetBaseTerrainMix("amazon grass");
	rmSetMapType("amazonia");
	rmSetMapType("tropical");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
   rmSetLightingSet("Amazonia_Skirmish");

   // Init map.
   rmTerrainInitialize("water");

	chooseMercs();

	// Make it rain
   rmSetGlobalRain( 0.7 );
   
//			rmPaintAreaTerrainByHeight(elevID, "Amazon\ground1_am", 11, 14, 1);
//		rmPaintAreaTerrainByHeight(elevID, "Amazon\ground2_am", 10, 11, 1);
//		rmPaintAreaTerrainByHeight(elevID, "Amazon\ground3_am", 8, 10);

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("classCliff");
   rmDefineClass("importantItem");
   rmDefineClass("socketClass");
   int classNative=rmDefineClass("natives");
   int classIsland=rmDefineClass("island");
   int classTeamIsland=rmDefineClass("teamIsland");


   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
      int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.43), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
//   int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 24.0);

   // Cardinal Directions
   int Northward=rmCreatePieConstraint("northMapConstraint", 0.55, 0.55, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
   int Southward=rmCreatePieConstraint("southMapConstraint", 0.45, 0.45, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
   int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.45, 0.55, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
   int Westward=rmCreatePieConstraint("westMapConstraint", 0.55, 0.45, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 20.0);
   int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 10.0);
   int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 20);
   int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-180, rmGetMapXSize()-40, 0, 0, 0);
   int islandConstraint=rmCreateClassDistanceConstraint("islands avoid each other", classIsland, 55.0);
   int islandConstraintShort=rmCreateClassDistanceConstraint("islands avoid each other short", classIsland, 6.0);
   int avoidNatives=rmCreateClassDistanceConstraint("avoid natives", classNative, 8.0);
   int avoidNativesFar=rmCreateClassDistanceConstraint("avoid natives far", classNative, 32.0);
//   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
 
    // Nature avoidance
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
   int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 36.0);
   int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 44.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
   
   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int mediumShortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 10.0);
   int mediumAvoidImpassableLand=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);
   int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
   // Constraint to avoid water.
   int avoidWater2 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 2.0);
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater10 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 10.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water large", "Land", false, 20.0);
   int ferryOnShore=rmCreateTerrainMaxDistanceConstraint("ferry v. water", "water", true, 12.0);

   // Unit avoidance
   int avoidImportantItem=rmCreateClassDistanceConstraint("avoid natives, secrets", rmClassID("importantItem"), 30.0);
   int farAvoidImportantItem=rmCreateClassDistanceConstraint("secrets avoid each other by a lot", rmClassID("importantItem"), 50.0);
   int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 25.0);
   int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 40.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
   int avoidCliff=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);

     // Trade route avoidance.
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 15.0);

    int tpPlacedIn1v1 = rmRandInt(0,1);
   //tpPlacedIn1v1=0;//DEBUG
    
     //dk
    int avoidAll_dk=rmCreateTypeDistanceConstraint("avoid all_dk", "all", 3.0);
    int avoidWater5_dk = rmCreateTerrainDistanceConstraint("avoid water long_dk", "Land", false, 15.0);
    int avoidSocket2_dk=rmCreateClassDistanceConstraint("socket avoidance gold_dk", rmClassID("socketClass"), 4.0);
    int avoidTradeRouteSmall_dk = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small_dk", 2.0);
    int forestConstraintShort_dk=rmCreateClassDistanceConstraint("object vs. forest_dk", rmClassID("classForest"), 2.0);
    int avoidHunt2_dk=rmCreateTypeDistanceConstraint("herds avoid herds2_dk", "huntable", 36.0);
    int avoidHunt3_dk=rmCreateTypeDistanceConstraint("herds avoid herds3_dk", "huntable", 18.0);
	int avoidAll2_dk=rmCreateTypeDistanceConstraint("avoid all2_dk", "all", 3.0);
    int avoidGoldTypeFar_dk = rmCreateTypeDistanceConstraint("avoid gold type  far 2_dk", "mine", 21.0);
    int circleConstraint2_dk=rmCreatePieConstraint("circle Constraint2_dk", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int avoidMineForest_dk=rmCreateTypeDistanceConstraint("avoid mines forest _dk", "mine", 9.0);
    int avoidCow_dk=rmCreateTypeDistanceConstraint("cow avoids cow dk", "cow", 32.0);
    
   // -------------Define objects
   // These objects are all defined so they can be placed later

 	// Place Town Centers
		rmSetTeamSpacingModifier(0.6);

		float teamStartLoc = rmRandFloat(0.0, 1.0);
		if(cNumberTeams > 2)
		{
			rmSetPlacementSection(0.10, 0.90);
			rmSetTeamSpacingModifier(0.75);
			rmPlacePlayersCircular(0.4, 0.4, 0);
		}
		else if (cNumberPlayers > 5)
		//players are placed much more spread on if players > 5
		{
			//team 0 starts on top
			if (teamStartLoc > 0.5)
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.0, 0.30);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.45, 0.75); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
			else
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.45, 0.75);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.0, 0.30); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
		}
		else
		{
			//team 0 starts on top
			if (teamStartLoc > 0.5)
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.10, 0.20);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.60, 0.70); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
			else
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.60, 0.70);
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.10, 0.20); 
				rmPlacePlayersCircular(0.40, 0.40, rmDegreesToRadians(5.0));
			}
		}

 


	// -------------Done defining objects

  // Text
   rmSetStatusText("",0.10);


   //  Rivers
/*
   // Build the main river which defines the map more-or-less.
	int amazonRiver = rmRiverCreate(-1, "Amazon River", 5, 18, 10, 10);
	if (cNumberNonGaiaPlayers >2)
		amazonRiver = rmRiverCreate(-1, "Amazon River", 6, 30, 14, 17);
	if (cNumberNonGaiaPlayers >4)
		amazonRiver = rmRiverCreate(-1, "Amazon River", 6, 30, 16, 20);
	if (cNumberNonGaiaPlayers >6)
		amazonRiver = rmRiverCreate(-1, "Amazon River", 6, 30, 18, 22);
   rmRiverSetConnections(amazonRiver, 0.0, 1.0, 1.0, 0.0);
   //rmRiverSetShallowRadius(amazonRiver, 10);
   //rmRiverAddShallow(amazonRiver, rmRandFloat(0.2, 0.2));
   //rmRiverAddShallow(amazonRiver, rmRandFloat(0.8, 0.8));
   rmRiverSetBankNoiseParams(amazonRiver, 0.07, 2, 1.5, 20.0, 0.667, 2.0);
   rmRiverBuild(amazonRiver);
   rmRiverReveal(amazonRiver, 2);  

 */

   int northIslandID = rmCreateArea("north island");
   int areaSizerNum = rmRandInt(1,10);
   float areaSizer = 0.33; 
   if (areaSizerNum > 6)
	   areaSizer = 0.38;
   rmEchoInfo("Island size "+areaSizer);
   
   // Make areas for the main islands... kinda hacky I guess, but it works.
   // Build an invisible north island area.
   
   //rmSetAreaLocation(northIslandID, 0.75, 0.75);
   rmSetAreaLocation(northIslandID, 1, 1);
   rmSetAreaMix(northIslandID, "caribbean grass");
   //rmSetAreaSize(northIslandID, 0.5, 0.5);
   rmSetAreaCoherence(northIslandID, 1.0);
   //rmAddAreaConstraint(northIslandID, avoidWater4);
   //rmSetAreaSize(northIslandID, isleSize, isleSize);
	rmSetAreaSize(northIslandID, areaSizer, areaSizer);
      rmSetAreaMinBlobs(northIslandID, 10);
      rmSetAreaMaxBlobs(northIslandID, 15);
      rmSetAreaMinBlobDistance(northIslandID, 8.0);
      rmSetAreaMaxBlobDistance(northIslandID, 10.0);
      rmSetAreaCoherence(northIslandID, 0.60);
      rmSetAreaBaseHeight(northIslandID, 3.0);
      rmSetAreaSmoothDistance(northIslandID, 20);
		rmSetAreaMix(northIslandID, "amazon grass");
      rmAddAreaToClass(northIslandID, classIsland);
      rmAddAreaConstraint(northIslandID, islandConstraint);
      rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
//      rmSetAreaElevationType(northIslandID, cElevTurbulence);
//      rmSetAreaElevationVariation(northIslandID, 3.0);
//      rmSetAreaElevationMinFrequency(northIslandID, 0.09);
//      rmSetAreaElevationOctaves(northIslandID, 3);
//      rmSetAreaElevationPersistence(northIslandID, 0.2);
//		rmSetAreaElevationNoiseBias(northIslandID, 1);
      rmSetAreaWarnFailure(northIslandID, false);
//      if(cNumberNonGaiaPlayers==2){
//        rmSetAreaEdgeFilling(northIslandID, 3);
//      }
   //rmBuildArea(northIslandID);

   // Build an invisible south island area.
   
  int southIslandID = rmCreateArea("south island");
   //rmSetAreaLocation(southIslandID, 0.25, 0.25);
   rmSetAreaLocation(southIslandID, 0, 0);
   rmSetAreaMix(southIslandID, "caribbean grass");
  // rmSetAreaSize(southIslandID, 0.5, 0.5);
   rmSetAreaCoherence(southIslandID, 1.0);
   //rmAddAreaConstraint(southIslandID, avoidWater4);
   rmSetAreaSize(southIslandID, areaSizer, areaSizer);
      rmSetAreaMinBlobs(southIslandID, 10);
      rmSetAreaMaxBlobs(southIslandID, 15);
      rmSetAreaMinBlobDistance(southIslandID, 8.0);
      rmSetAreaMaxBlobDistance(southIslandID, 10.0);
      rmSetAreaCoherence(southIslandID, 0.60);
      rmSetAreaBaseHeight(southIslandID, 3.0);
      rmSetAreaSmoothDistance(southIslandID, 20);
		rmSetAreaMix(southIslandID, "amazon grass");
      rmAddAreaToClass(southIslandID, classIsland);
      rmAddAreaConstraint(southIslandID, islandConstraint);
      rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
//      rmSetAreaElevationType(southIslandID, cElevTurbulence);
//      rmSetAreaElevationVariation(southIslandID, 3.0);
//      rmSetAreaElevationMinFrequency(southIslandID, 0.09);
//      rmSetAreaElevationOctaves(southIslandID, 3);
//      rmSetAreaElevationPersistence(southIslandID, 0.2);
//		rmSetAreaElevationNoiseBias(southIslandID, 1);
      rmSetAreaWarnFailure(southIslandID, false);
   //rmBuildArea(southIslandID);

   rmBuildAllAreas();

   // add island constraints
   int northIslandConstraint=rmCreateAreaConstraint("north Island", northIslandID);
   int southIslandConstraint=rmCreateAreaConstraint("south Island", southIslandID);
/*
   // Tributaries
   //northern tributaries
   int tribID1 = -1;
   int tribID2 = -1;
   //southern tributaries
   int tribID3 = -1; 
   int tribID4 = -1; 

   float RiverPlaceN = rmRandFloat(0,1);
   float RiverPlaceS = rmRandFloat(0,1);

*/


   // Text
   rmSetStatusText("",0.20);

  // check for KOTH game mode
    float xLoc = rmRandFloat(0.25,0.75);
	float yLoc = 1.0-xLoc;
	float walk = 0.0;

	//King's "Island"
	if (rmGetIsKOTH() == true) {
		int kingislandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingislandID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
		rmSetAreaLocation(kingislandID, xLoc, yLoc);
		rmSetAreaMix(kingislandID, "amazon grass");
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaReveal(kingislandID, 01);
		rmSetAreaBaseHeight(kingislandID, 3.0);
		rmSetAreaCoherence(kingislandID, 1.0);
		rmBuildArea(kingislandID); 
	
	// Place King's Hill
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}

		int avoidKOTH = rmCreateAreaDistanceConstraint("avoid KOTH", kingislandID, 4.0);

    // wood resources
   int randomTreeID=rmCreateObjectDef("random tree");
   rmAddObjectDefItem(randomTreeID, "TreeAmazon", 1, 1.0);
   rmSetObjectDefMinDistance(randomTreeID, 0.0);
   rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(randomTreeID, avoidResource);
   rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
   if (rmGetIsKOTH() == true)
	   rmAddObjectDefConstraint(randomTreeID, avoidKOTH);

	// Player placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);

   // Placement order
   // Trade route -> River (none on this map) -> Natives -> Secrets -> Cliffs -> Nuggets

   // Text
   rmSetStatusText("",0.30);

	int tpVariation = rmRandInt(1,2);
//		tpVariation = 2;		// for testing

	// ____________________ Trade Routes ____________________
	if (tpVariation == 1) {
		int tradeRouteID = rmCreateTradeRoute();	// north
        int tradeRouteID2 = rmCreateTradeRoute();	// south

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts N");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 2.0);
        rmSetObjectDefMaxDistance(socketID, 8.0);      
		rmAddObjectDefConstraint(socketID, avoidImpassableLand);

		int socketID2=rmCreateObjectDef("sockets to dock Trade Posts S");
        rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID2, true);
        rmSetObjectDefMinDistance(socketID2, 2.0);
        rmSetObjectDefMaxDistance(socketID2, 8.0);      
		rmAddObjectDefConstraint(socketID2, avoidImpassableLand);
		
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.41, 1.00);
		rmAddTradeRouteWaypoint(tradeRouteID, 1.00, 0.41);
       
        rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.59, 0.00);
		rmAddTradeRouteWaypoint(tradeRouteID2, 0.00, 0.59);
		
        rmBuildTradeRoute(tradeRouteID, "dirt_trail");
        rmBuildTradeRoute(tradeRouteID2, "dirt_trail");

        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);		
			
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		
        vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.15);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.50);
		rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
		
		socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.85);
        rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
		}

   // Text
   rmSetStatusText("",0.40);

	// PLAYER STARTING RESOURCES

   rmClearClosestPointConstraints();
   int TCfloat = -1;
   if (cNumberTeams == 2)
	   TCfloat = 50;
   else 
	   TCfloat = 85;
    
    if(cNumberNonGaiaPlayers==2){
        TCfloat = 15;
    }
    
	int TCID = rmCreateObjectDef("player TC");
	if (rmGetNomadStart())
		{
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
		}
	else{
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);

		int playerMarketID = rmCreateObjectDef("player market");
		rmAddObjectDefItem(playerMarketID, "market", 1, 0);
		rmAddObjectDefConstraint(playerMarketID, avoidTradeRoute);
		rmSetObjectDefMinDistance(playerMarketID, 10.0);
		rmSetObjectDefMaxDistance(playerMarketID, 18.0);
		rmAddObjectDefConstraint(playerMarketID, playerEdgeConstraint);
		rmAddObjectDefConstraint(playerMarketID, mediumShortAvoidImpassableLand);
    
    int playerAsianMarketID = rmCreateObjectDef("player asian market");
		rmAddObjectDefItem(playerAsianMarketID , "ypTradeMarketAsian", 1, 0);
		rmAddObjectDefConstraint(playerAsianMarketID , avoidTradeRoute);
		rmSetObjectDefMinDistance(playerAsianMarketID , 10.0);
		rmSetObjectDefMaxDistance(playerAsianMarketID , 18.0);
		rmAddObjectDefConstraint(playerAsianMarketID , playerEdgeConstraint);
		rmAddObjectDefConstraint(playerAsianMarketID , mediumShortAvoidImpassableLand);
		
		int playerAfricanMarketID = rmCreateObjectDef("player african market");
		rmAddObjectDefItem(playerAfricanMarketID , "deLivestockMarket", 1, 0);
		rmAddObjectDefConstraint(playerAfricanMarketID , avoidTradeRoute);
		rmSetObjectDefMinDistance(playerAfricanMarketID , 10.0);
		rmSetObjectDefMaxDistance(playerAfricanMarketID , 18.0);
		rmAddObjectDefConstraint(playerAfricanMarketID , playerEdgeConstraint);
		rmAddObjectDefConstraint(playerAfricanMarketID , mediumShortAvoidImpassableLand);
  }
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);

	rmAddObjectDefConstraint(TCID, avoidTradeRouteFar);
	rmAddObjectDefConstraint(TCID, avoidTownCenter);
	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	rmAddObjectDefConstraint(TCID, mediumShortAvoidImpassableLand);
	//rmPlaceObjectDefPerPlayer(TCID, true);

	//WATER HC ARRIVAL POINT

   int waterFlagID = 0;
   for(i=1; <cNumberPlayers)
    {
        waterFlagID=rmCreateObjectDef("HC water flag "+i);
        rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
   if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(waterFlagID, avoidKOTH);
	}  

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(playerSilverID, avoidTradeRoute);
    if(cNumberNonGaiaPlayers>2){
        rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
    }
	rmSetObjectDefMinDistance(playerSilverID, 10.0);
	rmSetObjectDefMaxDistance(playerSilverID, 25.0);
  rmAddObjectDefConstraint(playerSilverID, mediumAvoidImpassableLand);

	int playerDeerID=rmCreateObjectDef("player turkey");
  rmAddObjectDefItem(playerDeerID, "turkey", 8, 10.0);
  rmSetObjectDefMinDistance(playerDeerID, 10);
  rmSetObjectDefMaxDistance(playerDeerID, 16);
	rmAddObjectDefConstraint(playerDeerID, avoidAll);
  rmAddObjectDefConstraint(playerDeerID, avoidImpassableLand);
  rmSetObjectDefCreateHerd(playerDeerID, true);

	int playerTreeID=rmCreateObjectDef("player trees");
  rmAddObjectDefItem(playerTreeID, "TreeAmazon", rmRandInt(7,10), 2.0);
  rmSetObjectDefMinDistance(playerTreeID, 16);
  rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefConstraint(playerTreeID, avoidAll);
  rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);

	for(i=1; <cNumberPlayers) {
    rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

    if (rmGetNomadStart() == false)
    {
      if(ypIsAsian(i)) {
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(playerAsianMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
      
      else if(rmGetPlayerCiv(i) ==  rmGetCivID("Chinese") || rmGetPlayerCiv(i) ==  rmGetCivID("Indians")) {
        rmPlaceObjectDefAtLoc(playerAsianMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
      
      else if(rmGetPlayerCiv(i) ==  rmGetCivID("DEEthiopians") || rmGetPlayerCiv(i) ==  rmGetCivID("DEHausa")) {
        rmPlaceObjectDefAtLoc(playerAfricanMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
      }
      
      else 
        rmPlaceObjectDefAtLoc(playerMarketID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    }
    rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    rmPlaceObjectDefAtLoc(playerDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

    vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
    rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
	
  }
  
  rmClearClosestPointConstraints();



	// ____________________ Natives ____________________
	string natType1 = "";
	string natType2 = "";
	string natType3 = "";
	string natGrpName1 = "";
	string natGrpName2 = "";
	string natGrpName3 = "";
	
	int whichNative = rmRandInt(1,7);

	if (whichNative == 1) {
		natType1 = "Tupi";
		natType2 = "Zapotec";
		natType3 = "Incas";
		natGrpName1 = "native tupi village ";
		natGrpName2 = "native zapotec village ";
		natGrpName3 = "native inca village ";
		}
	if (whichNative == 2) {
		natType1 = "Tupi";
		natType2 = "Incas";
		natType3 = "Incas";
		natGrpName1 = "native tupi village ";
		natGrpName2 = "native inca village ";
		natGrpName3 = "native inca village ";
		}
	if (whichNative == 3) {
		natType1 = "Tupi";
		natType2 = "Tupi";
		natType3 = "Incas";
		natGrpName1 = "native tupi village ";
		natGrpName2 = "native tupi village ";
		natGrpName3 = "native inca village ";
		}
	if (whichNative == 4) {
		natType1 = "Tupi";
		natType2 = "Zapotec";
		natType3 = "Zapotec";
		natGrpName1 = "native tupi village ";
		natGrpName2 = "native zapotec village ";
		natGrpName3 = "native zapotec village ";
		}
	if (whichNative == 5) {
		natType1 = "Zapotec";
		natType2 = "Zapotec";
		natType3 = "Incas";
		natGrpName1 = "native zapotec village ";
		natGrpName2 = "native zapotec village ";
		natGrpName3 = "native inca village ";
		}
	if (whichNative == 6) {
		natType1 = "Tupi";
		natType2 = "Zapotec";
		natType3 = "Tupi";
		natGrpName1 = "native tupi village ";
		natGrpName2 = "native zapotec village ";
		natGrpName3 = "native tupi village ";
		}
	if (whichNative == 7) {
		natType1 = "Incas";
		natType2 = "Zapotec";
		natType3 = "Incas";
		natGrpName1 = "native inca village ";
		natGrpName2 = "native zapotec village ";
		natGrpName3 = "native inca village ";
		}		
		
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID(natType1);
	subCiv1 = rmGetCivID(natType2);
	subCiv2 = rmGetCivID(natType3);
	rmSetSubCiv(0, natType1);
	rmSetSubCiv(1, natType2);
	rmSetSubCiv(2, natType3);

	// Place Natives
    int avoidWater11_dk = rmCreateTerrainDistanceConstraint("avoid water 11_dk", "Land", false, 16.0);
    int avoidTownCenter20_dk=rmCreateTypeDistanceConstraint("avoid Town Center 19 _dk", "townCenter", 23.0);
	
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;
	int nativeID4 = -1;
	int nativeID5 = -1;

	int whichVillage1 = rmRandInt(1,5);	
	int whichVillage2 = rmRandInt(1,5);	
	int whichVillage3 = rmRandInt(1,5);	

	nativeID0 = rmCreateGrouping("native A", natGrpName1+whichVillage1);
	rmSetGroupingMinDistance(nativeID0, 0.0);
	rmSetGroupingMaxDistance(nativeID0, rmXFractionToMeters(0.50));
	rmAddGroupingConstraint(nativeID0, avoidTownCenter);
	rmAddGroupingConstraint(nativeID0, avoidImportantItem);
	rmAddGroupingConstraint(nativeID0, longAvoidImpassableLand);
	rmAddGroupingConstraint(nativeID0, southIslandConstraint);
	rmAddGroupingConstraint(nativeID0, avoidTradeRoute);
	rmAddGroupingConstraint(nativeID0, avoidNativesFar);
	rmAddGroupingToClass(nativeID0, classNative);
	
	nativeID1 = rmCreateGrouping("native B", natGrpName2+whichVillage2);
	rmSetGroupingMinDistance(nativeID1, 0.0);
	rmSetGroupingMaxDistance(nativeID1, rmXFractionToMeters(0.50));
	rmAddGroupingConstraint(nativeID1, avoidTownCenter);
	rmAddGroupingConstraint(nativeID1, avoidImportantItem);
	rmAddGroupingConstraint(nativeID1, longAvoidImpassableLand);
	rmAddGroupingConstraint(nativeID1, southIslandConstraint);
	rmAddGroupingConstraint(nativeID1, avoidTradeRoute);
	rmAddGroupingConstraint(nativeID1, avoidNativesFar);
	rmAddGroupingToClass(nativeID1, classNative);

	nativeID2 = rmCreateGrouping("native C", natGrpName3+whichVillage3);	
	rmSetGroupingMinDistance(nativeID2, 0.0);
	rmSetGroupingMaxDistance(nativeID2, rmXFractionToMeters(0.50));
	rmAddGroupingConstraint(nativeID2, avoidTownCenter);
	rmAddGroupingConstraint(nativeID2, avoidImportantItem);
	rmAddGroupingConstraint(nativeID2, longAvoidImpassableLand);
	rmAddGroupingConstraint(nativeID2, southIslandConstraint);
	rmAddGroupingConstraint(nativeID2, avoidTradeRoute);
	rmAddGroupingConstraint(nativeID2, avoidNativesFar);
	rmAddGroupingToClass(nativeID2, classNative);

	nativeID3 = rmCreateGrouping("native D", natGrpName1+whichVillage1);
	rmSetGroupingMinDistance(nativeID3, 0.0);
	rmSetGroupingMaxDistance(nativeID3, rmXFractionToMeters(0.50));
	rmAddGroupingConstraint(nativeID3, avoidTownCenter);
	rmAddGroupingConstraint(nativeID3, avoidImportantItem);
	rmAddGroupingConstraint(nativeID3, longAvoidImpassableLand);
	rmAddGroupingConstraint(nativeID3, northIslandConstraint);
	rmAddGroupingConstraint(nativeID3, avoidTradeRoute);
	rmAddGroupingConstraint(nativeID3, avoidNativesFar);
	rmAddGroupingToClass(nativeID3, classNative);

	nativeID4 = rmCreateGrouping("native E", natGrpName2+whichVillage2);
	rmSetGroupingMinDistance(nativeID4, 0.0);
	rmSetGroupingMaxDistance(nativeID4, rmXFractionToMeters(0.50));
	rmAddGroupingConstraint(nativeID4, avoidTownCenter);
	rmAddGroupingConstraint(nativeID4, avoidImportantItem);
	rmAddGroupingConstraint(nativeID4, longAvoidImpassableLand);
	rmAddGroupingConstraint(nativeID4, northIslandConstraint);
	rmAddGroupingConstraint(nativeID4, avoidTradeRoute);
	rmAddGroupingConstraint(nativeID4, avoidNativesFar);
	rmAddGroupingToClass(nativeID4, classNative);

	nativeID5 = rmCreateGrouping("native F", natGrpName3+whichVillage3);
	rmSetGroupingMinDistance(nativeID5, 0.0);
	rmSetGroupingMaxDistance(nativeID5, rmXFractionToMeters(0.50));
	rmAddGroupingConstraint(nativeID5, avoidTownCenter);
	rmAddGroupingConstraint(nativeID5, avoidImportantItem);
	rmAddGroupingConstraint(nativeID5, longAvoidImpassableLand);
	rmAddGroupingConstraint(nativeID5, northIslandConstraint);
	rmAddGroupingConstraint(nativeID5, avoidTradeRoute);
	rmAddGroupingConstraint(nativeID5, avoidNativesFar);
	rmAddGroupingToClass(nativeID5, classNative);

	rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.10);
	rmPlaceGroupingAtLoc(nativeID3, 0, 0.90, 0.50);
	if (tpVariation == 2) {    // only if no TR
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.10, 0.50);
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.30, 0.30);
		rmPlaceGroupingAtLoc(nativeID4, 0, 0.50, 0.90);
		rmPlaceGroupingAtLoc(nativeID5, 0, 0.70, 0.70);
		}

   // Text
   rmSetStatusText("",0.50);
   
   int numTries = -1;
   int failCount = -1;

   // Text
   rmSetStatusText("",0.60);

   // Text
   rmSetStatusText("",0.70);
 // if(cNumberNonGaiaPlayers>2){
	int silverType = -1;
	int silverID = -1;
	int silverCount = (cNumberNonGaiaPlayers*2.75);
	rmEchoInfo("silver count = "+silverCount);

	for(i=0; < silverCount)
	{
	  int southSilverID = rmCreateObjectDef("south silver "+i);
	  rmAddObjectDefItem(southSilverID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(southSilverID, 0.0);
      rmSetObjectDefMaxDistance(southSilverID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(southSilverID, avoidCoin);
      rmAddObjectDefConstraint(southSilverID, avoidAll);
      rmAddObjectDefConstraint(southSilverID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(southSilverID, avoidTradeRoute);
      rmAddObjectDefConstraint(southSilverID, mediumAvoidImpassableLand);
      rmAddObjectDefConstraint(southSilverID, southIslandConstraint);
	  rmPlaceObjectDefAtLoc(southSilverID, 0, 0.5, 0.5);
   }

	for(i=0; < silverCount)
	{
	  silverID = rmCreateObjectDef("north silver "+i);
	  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(silverID, 0.0);
      rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	  rmAddObjectDefConstraint(silverID, avoidCoin);
      rmAddObjectDefConstraint(silverID, avoidAll);
      rmAddObjectDefConstraint(silverID, avoidTownCenterFar);
	  rmAddObjectDefConstraint(silverID, avoidTradeRoute);
      rmAddObjectDefConstraint(silverID, mediumAvoidImpassableLand);
      rmAddObjectDefConstraint(silverID, northIslandConstraint);
	  rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   } 

/* }else{
    //1v1 mines
    int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, 31.0);
    rmAddObjectDefConstraint(topMine, avoidSocket2_dk);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall_dk);
    rmAddObjectDefConstraint(topMine, forestConstraintShort_dk);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar_dk);
    rmAddObjectDefConstraint(topMine, circleConstraint2_dk);       
    rmAddObjectDefConstraint(topMine, avoidAll_dk); 
    rmAddObjectDefConstraint(topMine, avoidWater5_dk);
    rmAddObjectDefConstraint(topMine, avoidTownCenter);
	if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(topMine, avoidKOTH);
    
    //top mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.63, 0.63, 1);
    if(rmRandInt(0,1)==0){
        rmPlaceObjectDefAtLoc(topMine, 0, 0.88, 0.65, 1);
    }else{
        rmPlaceObjectDefAtLoc(topMine, 0, 0.65, 0.88, 1);
    }
    rmPlaceObjectDefAtLoc(topMine, 0, 0.43, 0.83, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.83, 0.43, 1);
    
    //bot mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.37, 0.37, 1);
    if(rmRandInt(0,1)==0){
        rmPlaceObjectDefAtLoc(topMine, 0, 0.12, 0.35, 1);
    }else{
        rmPlaceObjectDefAtLoc(topMine, 0, 0.35, 0.12, 1);
    }
    rmPlaceObjectDefAtLoc(topMine, 0, 0.57, 0.17, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.17, 0.57, 1);
 }
*/



/*
   // Define and place Forests
   //ABC NEED TO BE SCATTERED BETWEEN THE TWO RIVERBANKS
   int forestTreeID = 0;
   numTries=8*cNumberNonGaiaPlayers;
   failCount=0;
   for (i=0; <numTries)
      {   
         int forestS=rmCreateArea("forestS"+i);
         rmSetAreaWarnFailure(forestS, false);
         rmSetAreaSize(forestS, rmAreaTilesToFraction(11), rmAreaTilesToFraction(11));
         rmSetAreaForestType(forestS, "amazon rain forest");
         rmSetAreaForestDensity(forestS, 0.8);
         rmSetAreaForestClumpiness(forestS, 0.6);
         rmSetAreaForestUnderbrush(forestS, 0.0);
         rmSetAreaMinBlobs(forestS, 6);
         rmSetAreaMaxBlobs(forestS, 15);
         rmSetAreaMinBlobDistance(forestS, 16.0);
         rmSetAreaMaxBlobDistance(forestS, 25.0);
         rmSetAreaCoherence(forestS, 0.4);
         rmSetAreaSmoothDistance(forestS, 10);
	      rmAddAreaToClass(forestS, rmClassID("classForest"));
         rmAddAreaConstraint(forestS, forestConstraint);
         rmAddAreaConstraint(forestS, forestObjConstraint);
         rmAddAreaConstraint(forestS, shortAvoidImpassableLand); 
         rmAddAreaConstraint(forestS, avoidTradeRoute);
		 rmAddAreaConstraint(forestS, avoidTownCenter);
		 rmAddAreaConstraint(forestS, avoidKOTH);
         if(cNumberNonGaiaPlayers==2){
           rmAddAreaConstraint(forestS, avoidMineForest_dk);
         }
	//	 rmBuildArea(forestS);	 
         if(rmBuildArea(forest)==false)
         {
            // Stop trying once we fail 3 times in a row.
            failCount++;
            if(failCount==6)
               break;
         }
         else
            failCount=0; 
   
	} 
*/
 
  // Text
   rmSetStatusText("",0.80);

	// Trees 
	int southTreesID = rmCreateObjectDef("south tree");
		rmAddObjectDefItem(southTreesID, "TreeAmazon", 20, 14.0);
		rmSetObjectDefMinDistance(southTreesID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(southTreesID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(southTreesID, rmClassID("classForest"));
		rmAddObjectDefConstraint(southTreesID, forestConstraint);
		rmAddObjectDefConstraint(southTreesID, avoidMineForest_dk);
		rmAddObjectDefConstraint(southTreesID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(southTreesID, avoidTradeRoute);
		rmAddObjectDefConstraint(southTreesID, forestObjConstraint);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(southTreesID, avoidKOTH);
		rmAddObjectDefConstraint(southTreesID, avoidTownCenter);
		rmAddObjectDefConstraint(southTreesID, southIslandConstraint);
		rmPlaceObjectDefAtLoc(southTreesID, 0, 0.50, 0.50, 2+4*cNumberNonGaiaPlayers);

	int northTreesID = rmCreateObjectDef("north tree");
		rmAddObjectDefItem(northTreesID, "TreeAmazon", 20, 14.0);
		rmSetObjectDefMinDistance(northTreesID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(northTreesID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(northTreesID, rmClassID("classForest"));
		rmAddObjectDefConstraint(northTreesID, forestConstraint);
		rmAddObjectDefConstraint(northTreesID, avoidMineForest_dk);
		rmAddObjectDefConstraint(northTreesID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(northTreesID, avoidTradeRoute);
		rmAddObjectDefConstraint(northTreesID, forestObjConstraint);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(northTreesID, avoidKOTH);
		rmAddObjectDefConstraint(northTreesID, avoidTownCenter);
		rmAddObjectDefConstraint(northTreesID, northIslandConstraint);
		rmPlaceObjectDefAtLoc(northTreesID, 0, 0.50, 0.50, 2+4*cNumberNonGaiaPlayers);

	// Place other objects that were defined earlier
    
 // Resources that can be placed after forests
  
  //Place fish
  int fishID=rmCreateObjectDef("fish");
  rmAddObjectDefItem(fishID, "FishBass", 3, 9.0);
  rmSetObjectDefMinDistance(fishID, 0.0);
  rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID, fishVsFishID);
  rmAddObjectDefConstraint(fishID, fishLand);
	if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(fishID, avoidKOTH);
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 11*cNumberNonGaiaPlayers); 
  
   //PAROT : underwater Decoration
   int avoidLand = rmCreateTerrainDistanceConstraint("avoid land long", "Land", true, 5.0);
   int underwaterDecoID=rmCreateObjectDef("SeaweedRocks");
   rmAddObjectDefItem(underwaterDecoID, "UnderbrushCoast", 1, 3);
   //rmAddObjectDefItem(int defID, string unitName, int count, float clusterDistance)
   rmSetObjectDefMinDistance(underwaterDecoID, 0.00);
   rmSetObjectDefMaxDistance(underwaterDecoID, rmXFractionToMeters(0.04));   
   rmAddObjectDefConstraint(underwaterDecoID, avoidLand);   
   if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(underwaterDecoID, avoidKOTH);   
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.10, 0.70, 20);    
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.25, 0.90, 15);    
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.25, 0.60, 15);    
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.30, 0.80, 10);    
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.30, 0.50, 10);    
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.40, 0.40, 5); 
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.60, 0.35, 5); 
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.70, 0.50, 5); 
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.70, 0.40, 5); 
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.70, 0.20, 10);
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.80, 0.30, 15);        
   rmPlaceObjectDefAtLoc(underwaterDecoID, 0, 0.90, 0.20, 20);     
       
   //rmPlaceObjectDefAtLoc(int defID, int playerID, float xFraction, float zFraction, long placeCount)   
if(cNumberNonGaiaPlayers>2){
	int tapirCount = rmRandInt(3,6);
	int capyCount = rmRandInt(9,12);

   int tapirNID=rmCreateObjectDef("north tapir crash");
   rmAddObjectDefItem(tapirNID, "tapir", tapirCount, 2.0);
   rmSetObjectDefMinDistance(tapirNID, 0.0);
   rmSetObjectDefMaxDistance(tapirNID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(tapirNID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirNID, avoidHunt2_dk);
   rmAddObjectDefConstraint(tapirNID, northIslandConstraint);
   rmSetObjectDefCreateHerd(tapirNID, true);
   rmPlaceObjectDefAtLoc(tapirNID, 0, 0.5, 0.5, 1.5*cNumberNonGaiaPlayers);

	int tapirSID=rmCreateObjectDef("south tapir crash");
   rmAddObjectDefItem(tapirSID, "tapir", tapirCount, 2.0);
   rmSetObjectDefMinDistance(tapirSID, 0.0);
   rmSetObjectDefMaxDistance(tapirSID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(tapirSID, avoidImpassableLand);
   rmAddObjectDefConstraint(tapirSID, avoidHunt2_dk);
   rmAddObjectDefConstraint(tapirSID, southIslandConstraint);
   rmSetObjectDefCreateHerd(tapirSID, true);
   rmPlaceObjectDefAtLoc(tapirSID, 0, 0.5, 0.5, 1.5*cNumberNonGaiaPlayers);

	// Text
   rmSetStatusText("",0.90);

	int capybaraNID=rmCreateObjectDef("north capybara crash");
   rmAddObjectDefItem(capybaraNID, "capybara", capyCount, 2.0);
   rmSetObjectDefMinDistance(capybaraNID, 0.0);
   rmSetObjectDefMaxDistance(capybaraNID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(capybaraNID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraNID, avoidHunt2_dk);
   rmAddObjectDefConstraint(capybaraNID, northIslandConstraint);
   rmSetObjectDefCreateHerd(capybaraNID, true);
   rmPlaceObjectDefAtLoc(capybaraNID, 0, 0.5, 0.5, (2*cNumberNonGaiaPlayers));

	int capybaraSID=rmCreateObjectDef("south capybara crash");
   rmAddObjectDefItem(capybaraSID, "capybara", capyCount, 2.0);
   rmSetObjectDefMinDistance(capybaraSID, 0.0);
   rmSetObjectDefMaxDistance(capybaraSID, rmXFractionToMeters(0.4));
   rmAddObjectDefConstraint(capybaraSID, avoidImpassableLand);
   rmAddObjectDefConstraint(capybaraSID, avoidHunt2_dk);
   rmAddObjectDefConstraint(capybaraSID, southIslandConstraint);
   rmSetObjectDefCreateHerd(capybaraSID, true);
   rmPlaceObjectDefAtLoc(capybaraSID, 0, 0.5, 0.5, (2*cNumberNonGaiaPlayers));
}else{
//1v1 hunts
    //1v1 hunts
    int mapHunts = rmCreateObjectDef("mapHunts");
    rmAddObjectDefItem(mapHunts, "capybara", 8, 6.0);
    rmSetObjectDefCreateHerd(mapHunts, true);
    rmSetObjectDefMinDistance(mapHunts, 0);
    rmSetObjectDefMaxDistance(mapHunts, 25);
    rmAddObjectDefConstraint(mapHunts, forestConstraintShort_dk);	
    rmAddObjectDefConstraint(mapHunts, avoidHunt2_dk);
    rmAddObjectDefConstraint(mapHunts, avoidAll_dk);       
    rmAddObjectDefConstraint(mapHunts, circleConstraint2_dk);   
    rmAddObjectDefConstraint(mapHunts, avoidWater5_dk);
    
    int mapHuntsDeer = rmCreateObjectDef("mapHuntsDeer");
    rmAddObjectDefItem(mapHuntsDeer, "tapir", 8, 6.0);
    rmSetObjectDefCreateHerd(mapHuntsDeer, true);
    rmSetObjectDefMinDistance(mapHuntsDeer, 0);
    rmSetObjectDefMaxDistance(mapHuntsDeer, 25);
    rmAddObjectDefConstraint(mapHuntsDeer, forestConstraintShort_dk);	
    rmAddObjectDefConstraint(mapHuntsDeer, avoidHunt2_dk);
    rmAddObjectDefConstraint(mapHuntsDeer, avoidAll_dk);       
    rmAddObjectDefConstraint(mapHuntsDeer, circleConstraint2_dk);   
    rmAddObjectDefConstraint(mapHuntsDeer, avoidWater5_dk);
    
    //top mines
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.63, 0.63, 1);
        rmPlaceObjectDefAtLoc(mapHuntsDeer, 0, 0.88, 0.65, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.65, 0.88, 1);
    rmPlaceObjectDefAtLoc(mapHuntsDeer, 0, 0.43, 0.83, 1);
    rmPlaceObjectDefAtLoc(mapHuntsDeer, 0, 0.83, 0.43, 1);
    
    //bot mines
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.37, 0.37, 1);
        rmPlaceObjectDefAtLoc(mapHuntsDeer, 0, 0.12, 0.35, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.35, 0.12, 1);
    rmPlaceObjectDefAtLoc(mapHuntsDeer, 0, 0.57, 0.17, 1);
    rmPlaceObjectDefAtLoc(mapHuntsDeer, 0, 0.17, 0.57, 1);

}


   // Define and place Nuggets on both sides of the river

	   int southNugget1= rmCreateObjectDef("south nugget easy"); 
	   rmAddObjectDefItem(southNugget1, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(1, 1);
	   rmAddObjectDefConstraint(southNugget1, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget1, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget1, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget1, avoidAll);
	   rmAddObjectDefConstraint(southNugget1, avoidWater20);
	   rmAddObjectDefConstraint(southNugget1, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget1, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(southNugget1, false, 1);

	   int northNugget1= rmCreateObjectDef("north nugget easy"); 
	   rmAddObjectDefItem(northNugget1, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(1, 1);
	   rmAddObjectDefConstraint(northNugget1, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget1, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget1, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget1, avoidAll);
	   rmAddObjectDefConstraint(northNugget1, avoidWater20);
	   rmAddObjectDefConstraint(northNugget1, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget1, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(northNugget1, false, 1);

	   int southNugget2= rmCreateObjectDef("south nugget medium"); 
	   rmAddObjectDefItem(southNugget2, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(2, 2);
	   rmSetObjectDefMinDistance(southNugget2, 0.0);
	   rmSetObjectDefMaxDistance(southNugget2, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(southNugget2, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget2, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget2, avoidTownCenter);
  	   rmAddObjectDefConstraint(southNugget2, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget2, avoidAll);
  	   rmAddObjectDefConstraint(southNugget2, avoidWater20);
	   rmAddObjectDefConstraint(southNugget2, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget2, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(southNugget2, false, 1);

	   int northNugget2= rmCreateObjectDef("north nugget medium"); 
	   rmAddObjectDefItem(northNugget2, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(2, 2);
	   rmSetObjectDefMinDistance(northNugget2, 0.0);
	   rmSetObjectDefMaxDistance(northNugget2, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(northNugget2, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget2, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget2, avoidTownCenter);
  	   rmAddObjectDefConstraint(northNugget2, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget2, avoidAll);
  	   rmAddObjectDefConstraint(northNugget2, avoidWater20);
	   rmAddObjectDefConstraint(northNugget2, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget2, playerEdgeConstraint);
	   rmPlaceObjectDefPerPlayer(northNugget2, false, 1);

	   int southNugget3= rmCreateObjectDef("south nugget hard"); 
	   rmAddObjectDefItem(southNugget3, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(3, 3);
	   rmSetObjectDefMinDistance(southNugget3, 0.0);
	   rmSetObjectDefMaxDistance(southNugget3, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(southNugget3, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget3, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget3, avoidTownCenter);
  	   rmAddObjectDefConstraint(southNugget3, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget3, avoidAll);
  	   rmAddObjectDefConstraint(southNugget3, avoidWater20);
	   rmAddObjectDefConstraint(southNugget3, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget3, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(southNugget3, false, 1);
	   rmPlaceObjectDefAtLoc(southNugget3, 0, 0.5, 0.5, 1);

	   int northNugget3= rmCreateObjectDef("north nugget hard"); 
	   rmAddObjectDefItem(northNugget3, "Nugget", 1, 0.0);
	   rmSetNuggetDifficulty(3, 3);
	   rmSetObjectDefMinDistance(northNugget3, 0.0);
	   rmSetObjectDefMaxDistance(northNugget3, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(northNugget3, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget3, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget3, avoidTownCenter);
  	   rmAddObjectDefConstraint(northNugget3, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget3, avoidAll);
  	   rmAddObjectDefConstraint(northNugget3, avoidWater20);
	   rmAddObjectDefConstraint(northNugget3, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget3, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(northNugget3, false, 1);
	   rmPlaceObjectDefAtLoc(northNugget3, 0, 0.5, 0.5, 1);

	   //only try to place these 25% of the time
	   int nuggetNutsNum = rmRandInt(1,4);
	   if (nuggetNutsNum == 1)
	   {
	   int southNugget4= rmCreateObjectDef("south nugget nuts"); 
	   rmAddObjectDefItem(southNugget4, "Nugget", 1, 0.0);
       if(cNumberNonGaiaPlayers>2 && rmGetIsTreaty() == false){
            rmSetNuggetDifficulty(4, 4);
       }else{
            rmSetNuggetDifficulty(3, 3);
       }
	   rmSetObjectDefMinDistance(southNugget4, 0.0);
	   rmSetObjectDefMaxDistance(southNugget4, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(southNugget4, avoidImpassableLand);
  	   rmAddObjectDefConstraint(southNugget4, avoidNugget);
  	   rmAddObjectDefConstraint(southNugget4, avoidTownCenter);
  	   rmAddObjectDefConstraint(southNugget4, avoidTradeRoute);
  	   rmAddObjectDefConstraint(southNugget4, avoidAll);
  	   rmAddObjectDefConstraint(southNugget4, avoidWater20);
	   rmAddObjectDefConstraint(southNugget4, southIslandConstraint);
	   rmAddObjectDefConstraint(southNugget4, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(southNugget4, false, 1);
	   rmPlaceObjectDefAtLoc(southNugget4, 0, 0.5, 0.5, 1);

	   int northNugget4= rmCreateObjectDef("north nugget nuts"); 
	   rmAddObjectDefItem(northNugget4, "Nugget", 1, 0.0);
	   if(cNumberNonGaiaPlayers>2 && rmGetIsTreaty() == false){
            rmSetNuggetDifficulty(4, 4);
       }else{
            rmSetNuggetDifficulty(3, 3);
       }
	   rmSetObjectDefMinDistance(northNugget4, 0.0);
	   rmSetObjectDefMaxDistance(northNugget4, rmXFractionToMeters(0.5));
	   rmAddObjectDefConstraint(northNugget4, avoidImpassableLand);
  	   rmAddObjectDefConstraint(northNugget4, avoidNugget);
  	   rmAddObjectDefConstraint(northNugget4, avoidTownCenter);
  	   rmAddObjectDefConstraint(northNugget4, avoidTradeRoute);
  	   rmAddObjectDefConstraint(northNugget4, avoidAll);
  	   rmAddObjectDefConstraint(northNugget4, avoidWater20);
	   rmAddObjectDefConstraint(northNugget4, northIslandConstraint);
	   rmAddObjectDefConstraint(northNugget4, playerEdgeConstraint);
	   //rmPlaceObjectDefPerPlayer(northNugget4, false, 1);
	   rmPlaceObjectDefAtLoc(northNugget4, 0, 0.5, 0.5, 1);
	   }


   // Text
      rmSetStatusText("",1.0);
}  
