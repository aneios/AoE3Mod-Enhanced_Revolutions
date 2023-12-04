// PATAGONIA DE
// 5/7/2020 - Durokan's update

// Based on the happy Saguenay map to start with.
//
// Main entry point for random map script
// April 2021 edited by vividlyplain for DE

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
    // Text
    // These status text lines are used to manually animate the map generation progress bar
    rmSetStatusText("",0.01);

    //Chooses which natives appear on the map

    // Picks the map size
    int playerTiles=12000;
    int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
    rmEchoInfo("Map size="+size+"m x "+size+"m");
    rmSetMapSize(size, size);

    int whichVariation = rmRandInt(1,2);

    // Picks a default water height
    rmSetSeaLevel(1.0);

    // Picks default terrain and water
    // rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
    rmSetMapElevationParameters(cElevTurbulence, 0.1, 4, 0.2, 3.0);
    rmSetSeaType("new england coast");
    rmEnableLocalWater(false);
    rmSetBaseTerrainMix("patagonia_grass");
    rmTerrainInitialize("patagonia\ground_dirt1_pat", 4.0);
    rmSetMapType("patagonia");
    rmSetMapType("water");
    rmSetMapType("grass");
    rmSetLightingSet("Patagonia_Skirmish");
    rmSetWorldCircleConstraint(true);

    // Choose mercs.
    chooseMercs();

    // Define some classes. These are used later for constraints.
    int classPlayer=rmDefineClass("player");
    rmDefineClass("classCliff");
    rmDefineClass("classPatch");
    int classbigContinent=rmDefineClass("big continent");
    rmDefineClass("starting settlement");
    rmDefineClass("startingUnit");
    rmDefineClass("classForest");
    rmDefineClass("classWestForest");
    rmDefineClass("importantItem");
    rmDefineClass("secrets");
    //rmDefineClass("bay");
    rmDefineClass("nuggets");
    rmDefineClass("socketClass");

    int lakeClass=rmDefineClass("lake");

    // -------------Define constraints
    // These are used to have objects and areas avoid each other

    // Map edge constraints
    int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
    int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 24.0);

    // Player constraints
    int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
    int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 44.0);
    int flagConstraint=rmCreateHCGPConstraint("flags avoid same", 30.0);
    int nearWater10 = rmCreateTerrainDistanceConstraint("near water", "Water", true, 10.0);

    // Bonus area constraint.
    int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 20.0);

    // Resource avoidance
    int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
    int westForestConstraint=rmCreateClassDistanceConstraint("west forest vs. forest", rmClassID("classWestForest"), 35.0);
    int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 1.0);
    int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 40.0);
    int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 45.0);
    int avoidPlayerNugget=rmCreateTypeDistanceConstraint("player nugget avoid nugget", "AbstractNugget", 25.0);
    int avoidDeerMH=rmCreateTypeDistanceConstraint("bighorn avoids bighorn", "deer", 40.0); // was 40
    int avoidHunt=rmCreateTypeDistanceConstraint("hunt avoid hunt", "huntable", 35.0);
    int avoidRheaShort=rmCreateTypeDistanceConstraint("rheas avoid hunts", "huntable", 25.0);
    int rheaAvoidRheaShort=rmCreateTypeDistanceConstraint("rheas avoid rhea", "rhea", 35.0);
    int avoidMoose=rmCreateTypeDistanceConstraint("moose avoids moose", "Moose", 35.0);
    int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "FishSalmon", 18.0);
   int whaleVsWhaleID = -1;
   if (cNumberNonGaiaPlayers > 2)
      whaleVsWhaleID = rmCreateTypeDistanceConstraint("whale v whale", "beluga", 50.0);
   else
      whaleVsWhaleID = rmCreateTypeDistanceConstraint("whale v whale", "beluga", 34.0);
    int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 4.0);
    int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 17.0);
    int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 60.0);
    int avoidFastCoinForest=rmCreateTypeDistanceConstraint("forests avoid fast coin", "gold", 10.0);
    int rheaAvoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 55.0);
    int rheaAvoidTownCenter2=rmCreateTypeDistanceConstraint("avoid Town Center2", "townCenter", 65.0);
    int goldAvoidTownCenter=rmCreateTypeDistanceConstraint("gold avoid TC", "townCenter", 40.0);

	// Ore mines, to be avoided by forests, etc.
    int avoidFastCoin45=rmCreateTypeDistanceConstraint("fast coin avoids coin 45", "gold", 50.0);
    int avoidCoinShort=rmCreateTypeDistanceConstraint("short avoid coin", "gold", 30.0);
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 5.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 5.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 32.0);
	int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
  
    //whales avoid center lake
    int classLake = rmDefineClass("centerLake");
    int classEastLake = rmDefineClass("bay");
    int avoidCenterLake = rmCreateClassDistanceConstraint("avoid center lake", classLake, 15.0);
    int avoidEastLake = rmCreateClassDistanceConstraint("avoid east lake", classEastLake, 35.0);

    // Avoid impassable land
    int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
    int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land med", "Land", false, 7.0);
    int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
    int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
    int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

    int avoidLake=rmCreateClassDistanceConstraint("lake vs stuff", lakeClass, 30.0);
    int eastBeach = rmDefineClass("eastBeach");
    int rheaBeach = rmDefineClass("rheaBeach");
    int avoidEastBeach=rmCreateClassDistanceConstraint("avoid eastBeach", eastBeach, 5.0);
    int avoidRheaBeach=rmCreateClassDistanceConstraint("avoid rheaBeach", rheaBeach, 5.0);

    // Decoration avoidance
    int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
    int avoidAllMines=rmCreateTypeDistanceConstraint("avoid all mines", "all", 3.0);

    // Starting units avoidance
    int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
    int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

    // Trade route avoidance.
    // VP avoidance
    int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
    int avoidTradeRouteMH = rmCreateTradeRouteDistanceConstraint("trade route 2", 6.0);
    int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 5.0);
    int avoidSocketCliff=rmCreateClassDistanceConstraint("cliffs avoid sockets by a lot", rmClassID("socketClass"), 10.0);
    int avoidSocketPlayer=rmCreateClassDistanceConstraint("cliffs avoid sockets by a lot more", rmClassID("socketClass"), 15.0);
    int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 50.0);
    int secretsAvoidSecrets = rmCreateClassDistanceConstraint("secrets avoid secrets", rmClassID("secrets"), 60.0);
    int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 30.0);

    // Constraint to avoid water.
    int avoidWater8 = rmCreateTerrainDistanceConstraint("avoid water 8", "Land", false, 8.0);
    int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water 5", "Land", false, 5.0);

    // Cardinal Directions Constraints (handy!)
    int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
    int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
    int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
    int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

    // ships vs. ships
    int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 15.0);

    // New extra stuff for water spawn point avoidance.
    int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
    int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
    int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

    int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

    // Text
    rmSetStatusText("",0.10);

	// int avoidBeach = rmCreateAreaDistanceConstraint("stay away from InnerLandID", InnerLandID, 4);

    int beachToTheEast = rmCreateArea("beach to the east");
    rmAddAreaToClass(beachToTheEast, rmClassID("eastBeach"));
    rmSetAreaSize(beachToTheEast, 0.15, 0.15);
    rmSetAreaLocation(beachToTheEast, 0.625, 0.375);
    //rmSetAreaBaseHeight(beachToTheEast, 1.0); // Was 10
    rmSetAreaCoherence(beachToTheEast, 1.0);
    //rmSetAreaTerrainType(beachToTheEast, "texas\ground4_tex");
    rmBuildArea(beachToTheEast); 
    
    int b4 = rmCreateArea("b4");
    rmAddAreaToClass(b4, rmClassID("eastBeach"));
    rmSetAreaSize(b4, 0.05, 0.05);
    rmSetAreaLocation(b4, 0.65, 0.45);
    rmSetAreaBaseHeight(b4, 1.0); // Was 10
    rmSetAreaCoherence(b4, 1.0);
    //rmSetAreaTerrainType(b4, "texas\ground4_tex");
    rmBuildArea(b4); 
 
     int b5 = rmCreateArea("b5");
    rmAddAreaToClass(b5, rmClassID("eastBeach"));
    rmSetAreaSize(b5, 0.05, 0.05);
    rmSetAreaLocation(b5, 0.55, 0.35);
    rmSetAreaBaseHeight(b5, 1.0); // Was 10
    rmSetAreaCoherence(b5, 1.0);
    //rmSetAreaTerrainType(b5, "texas\ground4_tex");
    rmBuildArea(b5); 

        /*
    int beachToTheWest = rmCreateArea("beach to the west");
    rmAddAreaToClass(beachToTheWest, rmClassID("eastBeach"));
    rmSetAreaSize(beachToTheWest, 0.05, 0.05);
    rmSetAreaLocation(beachToTheWest, 0.23, 0.77);
    //rmSetAreaBaseHeight(beachToTheEast, 1.0); // Was 10
    rmSetAreaCoherence(beachToTheWest, 1.0);
    rmSetAreaTerrainType(beachToTheWest, "texas\ground4_tex");
    rmBuildArea(beachToTheWest); */
    
    int beachToTheNorth = rmCreateArea("beach to the north");
    rmAddAreaToClass(beachToTheNorth, rmClassID("eastBeach"));
    //rmAddAreaToClass(beachToTheNorth, rmClassID("rheaBeach"));
    rmSetAreaSize(beachToTheNorth, 0.03, 0.03);
    rmSetAreaLocation(beachToTheNorth, 0.925, 0.675);
    //rmSetAreaBaseHeight(beachToTheEast, 1.0); // Was 10
    rmSetAreaCoherence(beachToTheNorth, 1.0);
    //rmSetAreaTerrainType(beachToTheNorth, "texas\ground4_tex");
    rmBuildArea(beachToTheNorth); 
    
   int beachToTheSouth = rmCreateArea("beach to the south");
    rmAddAreaToClass(beachToTheSouth, rmClassID("eastBeach"));
    //rmAddAreaToClass(beachToTheNorth, rmClassID("rheaBeach"));
    rmSetAreaSize(beachToTheSouth, 0.03, 0.03);
    rmSetAreaLocation(beachToTheSouth, 0.325, 0.075);
    //rmSetAreaBaseHeight(beachToTheEast, 1.0); // Was 10
    rmSetAreaCoherence(beachToTheSouth, 1.0);
    //rmSetAreaTerrainType(beachToTheSouth, "texas\ground4_tex");
    rmBuildArea(beachToTheSouth); 

	// Create two Bay Areas.
    int bay1ID=rmCreateArea("Bay 1");
    rmSetAreaSize(bay1ID, 0.05, 0.05);
    rmSetAreaLocation(bay1ID, 1.0, 0.45);
    rmSetAreaWaterType(bay1ID, "Patagonia bay");
    rmSetAreaBaseHeight(bay1ID, 1.0); // Was 10
    rmSetAreaCoherence(bay1ID, 0.4);
    rmAddAreaToClass(bay1ID, rmClassID("bay"));
    rmSetAreaObeyWorldCircleConstraint(bay1ID, false);
    rmBuildArea(bay1ID);

    int bay2ID=rmCreateArea("Bay 2");
    rmSetAreaSize(bay2ID, 0.05, 0.05);
    rmSetAreaLocation(bay2ID, 0.55, 0.0);
    rmSetAreaWaterType(bay2ID, "Patagonia bay");
    rmSetAreaBaseHeight(bay2ID, 1.0); // Was 10
    rmSetAreaCoherence(bay2ID, 0.4);
    rmAddAreaToClass(bay2ID, rmClassID("bay"));
    rmSetAreaObeyWorldCircleConstraint(bay2ID, false);
    rmBuildArea(bay2ID);

    int bay3ID=rmCreateArea("Bay 3");
    rmSetAreaSize(bay3ID, 0.14, 0.14);
    rmSetAreaLocation(bay3ID, 1.0, 0.0);
    rmSetAreaWaterType(bay3ID, "Patagonia bay");
    rmSetAreaBaseHeight(bay3ID, 1.0); // Was 10
    rmSetAreaCoherence(bay3ID, 0.3);
    rmAddAreaToClass(bay3ID, rmClassID("bay"));
    rmSetAreaObeyWorldCircleConstraint(bay3ID, false);
    rmBuildArea(bay3ID);
    //if you comment out bay 3 it becomes a cool lil triangle. fun map
    
   // Text
   rmSetStatusText("",0.20);

   // Placement order
   // Trade route -> Player Areas -> Lake -> Cliffs -> Nuggets
	// Two glorious trade routes
   int tradeRouteID = rmCreateTradeRoute();
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts 1");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.1);
   rmSetObjectDefAllowOverlap(socketID, true);

   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmAddObjectDefConstraint(socketID, circleConstraint);

   rmSetObjectDefMinDistance(socketID, 2.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);

   rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.15);						// DAL - 0.5, 1.0; 0.0, 0.5
   rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.05, 0.65, 10, 10);	// 0.15, 0.80

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt_trail");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.4);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
   if ( cNumberNonGaiaPlayers < 4 )
   {
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
   }
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   // Text
   rmSetStatusText("",0.30);

	// DEFINE Player Areas
   // Set up player starting locations. These are just used to place Caravels away from each other.
   /* DAL - old placement.
	rmSetPlacementSection(0.35, 0.65);
   rmSetTeamSpacingModifier(0.50);
   rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));
	*/

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	
   if ( cNumberTeams == 2 )
   {
	   if ( rmGetNumberPlayersOnTeam(0) < 5 && rmGetNumberPlayersOnTeam(1) < 5)
	   {
			rmSetPlacementTeam(0);
			// rmPlacePlayersLine(0.46, 0.36, 0.3, 0.2, 0.0, 0.1);
			rmPlacePlayersLine(0.3, 0.25, 0.2, 0.55, 0.0, 0.1);

			rmSetPlacementTeam(1);
			// rmPlacePlayersLine(0.64, 0.54, 0.8, 0.7, 0.0, 0.1);
			rmPlacePlayersLine(0.75, 0.7, 0.45, 0.8, 0.0, 0.1);
	   }
	   else
	   {
   			rmSetPlacementTeam(0);
			// rmPlacePlayersLine(0.46, 0.36, 0.3, 0.2, 0.0, 0.1);
			rmPlacePlayersLine(0.3, 0.2, 0.25, 0.6, 0.0, 0.1);		// 0.25

			rmSetPlacementTeam(1);
			// rmPlacePlayersLine(0.64, 0.54, 0.8, 0.7, 0.0, 0.1);
			rmPlacePlayersLine(0.8, 0.7, 0.4, 0.75, 0.0, 0.1);	// 0.75, 0.7
	   }
   }
   else
   {
        //1v1 ffa now spawns the same as 1v1
      if (cNumberNonGaiaPlayers == 2)
      {
            rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.3, 0.25, 0.2, 0.55, 0.0, 0.1);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.75, 0.7, 0.45, 0.8, 0.0, 0.1);
      }
      else
      {
            // rmPlacePlayersLine(0.3, 0.2, 0.8, 0.7, 0.0, 0.1);
            // rmSetPlayerPlacementArea(0.0, 0.5, 0.7, 0.8);
            rmSetPlacementSection(0.6, 0.15);
            rmPlacePlayersCircular(0.3, 0.3, 0.0);
        }
   }

    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
	  rmAddAreaConstraint(i, avoidSocketPlayer);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      // rmAddAreaConstraint(id, playerConstraint); 
      // rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
	
   // Text
   rmSetStatusText("",0.40);

	// Trade route hack.
   //	rmAddTradeRouteWaypoint(tradeRouteID, xFraction, zFraction)
   // rmAddRandomTradeRouteWaypoints(tradeRouteID, endXFraction, endZFraction, count, maxVariation) 
   int tradeRouteID2 = rmCreateTradeRoute();
   socketID=rmCreateObjectDef("sockets to dock Trade Posts 2");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);

   rmAddObjectDefConstraint(socketID, circleConstraint);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));

   rmSetObjectDefMinDistance(socketID, 2.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);

   rmAddTradeRouteWaypoint(tradeRouteID2, 0.85, 0.80);							// DAL - 0.9, 1.0; 0.0, 0.1
   rmAddRandomTradeRouteWaypoints(tradeRouteID2, 0.35, 0.95, 10, 10);			// 0.2, 0.85

   placedTradeRoute = rmBuildTradeRoute(tradeRouteID2, "dirt_trail");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route");

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID2);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.0);
   if ( cNumberNonGaiaPlayers < 4 )
   {
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.05);
   }
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.4);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.8);
   if ( cNumberNonGaiaPlayers < 4 )
   {
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID2, 0.75);
   }
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	// Adding a lake in the middle.
	int lakeID=rmCreateArea("small lake 1");
	int lakeConstraint=rmCreateClassDistanceConstraint("stuff vs. lake", rmClassID("lake"), 15.0);

	// Two variants:
	// 1 - lake moves to the left side, creating safe zones deep inland
	// 2 - lake is central, with ways around on either side
    
    // Due to design decisions at the start of DE this has been hardcoded to central lake
    whichVariation = 2;
	if ( whichVariation == 1 )
	{
		rmSetAreaLocation(lakeID, 0.2, 0.8);
		rmAddAreaInfluenceSegment(lakeID, 0.0, 1.0, 0.35, 0.65);
		if ( cNumberNonGaiaPlayers < 4 )
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(1750), rmAreaTilesToFraction(1750));
		}
		else
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(3500), rmAreaTilesToFraction(3500));
		}
		rmSetAreaObeyWorldCircleConstraint(lakeID, false);
		rmSetAreaCoherence(lakeID, 0.5);									// higher = rounder
	}
	else
	{
		rmSetAreaLocation(lakeID, 0.4, 0.6);
		rmAddAreaInfluenceSegment(lakeID, 0.4, 0.5, 0.5, 0.6);
		if ( cNumberNonGaiaPlayers < 4 )
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
		}
		else
		{
			rmSetAreaSize(lakeID, rmAreaTilesToFraction(1500), rmAreaTilesToFraction(1500));
		}
		rmSetAreaCoherence(lakeID, 0.4);		
	}
	rmSetAreaWaterType(lakeID, "Patagonia lake");
    rmAddAreaToClass(lakeID, rmClassID("centerLake"));
	rmSetAreaBaseHeight(lakeID, 1.0);
	rmAddAreaToClass(lakeID, lakeClass);
	rmSetAreaWarnFailure(lakeID, false);
	// Only build if two teams.
	if ( cNumberTeams == 2 )
	{
		rmBuildArea(lakeID);
	}

   // Text
   rmSetStatusText("",0.50);

	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	rmSetAreaSize(midIslandID, 0.30);
	if (cNumberNonGaiaPlayers > 2) 
	{
		rmAddAreaInfluenceSegment(midIslandID, 0.4, 0.2, 0.35, 0.6);
		rmAddAreaInfluenceSegment(midIslandID, 0.8, 0.6, 0.4, 0.65);
	}
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
//	rmSetAreaMix(midIslandID, "testmix"); 	// for testing
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);
	
	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.10);
		rmAddAreaInfluenceSegment(midSmIslandID, 0.6, 0.4, 0.2, 0.8);
	rmSetAreaLocation(midSmIslandID, 0.5, 0.5);
//	rmSetAreaMix(midSmIslandID, "great plains drygrass"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 0.75);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);
	
      // Starting Unit placement
	int classStartingResource = rmDefineClass("startingResource");
	int classGold = rmDefineClass("Gold");
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type  far ", "gold", 45.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resource", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resource short", rmClassID("startingResource"), 6.0);
	int avoidStartingResourcesMin  = rmCreateClassDistanceConstraint("avoid starting resource min", rmClassID("startingResource"), 4.0);
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.40), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));
		
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefConstraint(startingUnits, avoidAll);

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
	rmAddObjectDefToClass(startingTCID, classStartingResource);  
	rmSetObjectDefMinDistance(startingTCID, 0);
	rmSetObjectDefMaxDistance(startingTCID, 0); 

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreePatagoniaDirt", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 14.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
	rmAddObjectDefToClass(StartAreaTreeID, classStartingResource);  
//	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingResourcesShort);

	int StartAreaTree2ID = rmCreateObjectDef("starting trees2");
	rmAddObjectDefItem(StartAreaTree2ID, "TreePatagoniaDirt", 12, 8.0);
	rmSetObjectDefMinDistance(StartAreaTree2ID, 36.0);
	rmSetObjectDefMaxDistance(StartAreaTree2ID, 44.0);
	rmAddObjectDefToClass(StartAreaTree2ID, classStartingResource);  
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidMidIsland);
	if (teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(StartAreaTree2ID, stayNearEdge);
	
	int StartDeerID=rmCreateObjectDef("starting rhea");
	rmAddObjectDefItem(StartDeerID, "rhea", 8, 5.0);
	rmSetObjectDefMinDistance(StartDeerID, 14.0);
	rmSetObjectDefMaxDistance(StartDeerID, 16.0);
	rmAddObjectDefToClass(StartDeerID, classStartingResource);  
//	rmAddObjectDefConstraint(StartDeerID, avoidStartingUnitsSmall);
    rmAddObjectDefConstraint(StartDeerID, avoidStartingResourcesMin);
    rmAddObjectDefConstraint(StartDeerID, avoidImpassableLand);
    rmAddObjectDefConstraint(StartDeerID, avoidTradeRoute);
    rmSetObjectDefCreateHerd(StartDeerID, true);
	rmAddObjectDefConstraint(StartDeerID, avoidSocket);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(StartDeerID, stayMidIsland);

    int StartDeerID2=rmCreateObjectDef("starting deer2");
    rmAddObjectDefItem(StartDeerID2, "deer", 8, 7.0);
	rmSetObjectDefMinDistance(StartDeerID2, 34.0);
	rmSetObjectDefMaxDistance(StartDeerID2, 40.0);
	rmAddObjectDefToClass(StartDeerID2, classStartingResource);  
//    rmAddObjectDefConstraint(StartDeerID2, avoidStartingUnitsSmall);
    rmAddObjectDefConstraint(StartDeerID2, avoidStartingResourcesMin);
    rmAddObjectDefConstraint(StartDeerID2, avoidTradeRoute);
	rmAddObjectDefConstraint(StartDeerID2, avoidSocket);
    rmSetObjectDefCreateHerd(StartDeerID2, true);
    rmAddObjectDefConstraint(StartDeerID2, avoidImpassableLand);
	rmAddObjectDefConstraint(StartDeerID2, avoidMidIsland);
	if (teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(StartDeerID2, stayNearEdge);

	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 16.0);
	rmSetObjectDefMaxDistance(sheepID, 20.0);	
	rmAddObjectDefToClass(sheepID, classStartingResource);  
//    rmAddObjectDefConstraint(sheepID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(sheepID, avoidStartingResourcesShort);
    rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
    rmAddObjectDefConstraint(sheepID, avoidTradeRoute);

	int StartBerryBushID=rmCreateObjectDef("starting berry bush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 2, 4.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 16.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 16.0);
	rmAddObjectDefToClass(StartBerryBushID, classStartingResource);  
//	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingResourcesMin);
//	if (cNumberNonGaiaPlayers == 2)
//		rmAddObjectDefConstraint(StartBerryBushID, stayMidIsland);
    
	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);  
//	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidPlayerNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);

	// Starting mines
    int baseGold = rmCreateObjectDef("starting gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
	rmSetObjectDefMinDistance(baseGold, 16.0);
	rmSetObjectDefMaxDistance(baseGold, 18.0);
   	rmAddObjectDefToClass(baseGold, classStartingResource);
	rmAddObjectDefToClass(baseGold, classGold);
	rmAddObjectDefConstraint(baseGold, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold, avoidStartingResources);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(baseGold, stayMidIsland);
	rmAddObjectDefConstraint(baseGold, avoidCoinShort);
	
	int baseGold2 = rmCreateObjectDef("starting gold2");
	rmAddObjectDefItem(baseGold2, "mine", 1, 0.0);
	rmSetObjectDefMinDistance(baseGold2, 16.0);
	rmSetObjectDefMaxDistance(baseGold2, 18.0);
	rmAddObjectDefToClass(baseGold2, classStartingResource);
	rmAddObjectDefToClass(baseGold2, classGold);
	rmAddObjectDefConstraint(baseGold2, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold2, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold2, avoidStartingResources);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(baseGold2, avoidMidIslandMin);
	rmAddObjectDefConstraint(baseGold2, avoidCoinShort);

	for(i=1; <cNumberPlayers)
	{
		rmClearClosestPointConstraints();
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
    rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(baseGold, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(baseGold2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting herds...
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        //starting sheep!
		rmPlaceObjectDefAtLoc(sheepID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Berry Bushes
		rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting trees...
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

		// Water flag
		int waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		rmAddClosestPointConstraint(Eastward);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
        vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();
	}
   
	int numTries=cNumberNonGaiaPlayers*2;
	// Define and place cliffs
   for(i=0; <numTries)
   {
      int cliffID=rmCreateArea("cliff"+i);
      rmSetAreaSize(cliffID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(200+100*cNumberNonGaiaPlayers));
      rmSetAreaWarnFailure(cliffID, false);
      rmSetAreaCliffType(cliffID, "Patagonia");
      rmSetAreaCliffEdge(cliffID, 2, 0.3, 0.1, 1.0, 0);
      rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
      rmSetAreaCliffHeight(cliffID, 7, 2.0, 0.5);
      rmSetAreaHeightBlend(cliffID, 1);
      rmSetAreaObeyWorldCircleConstraint(cliffID, false);
      rmAddAreaToClass(cliffID, rmClassID("classCliff")); 
	  rmSetAreaMix(cliffID, "patagonia_dirt");
      rmAddAreaConstraint(cliffID, avoidImportantItem);
      rmAddAreaConstraint(cliffID, avoidImpassableLand);
      rmAddAreaConstraint(cliffID, avoidCliffs);
	  rmAddAreaConstraint(cliffID, smallMapPlayerConstraint);   // playerConstraint
      rmAddAreaConstraint(cliffID, avoidTradeRoute);
	  rmAddAreaConstraint(cliffID, avoidSocketCliff);
	  rmAddAreaConstraint(cliffID, avoidStartingUnits);
	  rmAddAreaConstraint(cliffID, avoidStartingResources);
	  rmAddAreaConstraint(cliffID, avoidLake);
	  rmAddAreaConstraint(cliffID, Westward);
      rmSetAreaCoherence(cliffID, 0.69);		// higher = tries to make round
      rmBuildArea(cliffID);
   } 

   // Text
   rmSetStatusText("",0.60);

	// Sea resources
    int whaleID=rmCreateObjectDef("whale");
    rmAddObjectDefItem(whaleID, "beluga", 1, 0.0);
    rmSetObjectDefMinDistance(whaleID, 0.0);
    rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
    rmAddObjectDefConstraint(whaleID, whaleLand);
    rmAddObjectDefConstraint(whaleID, avoidCenterLake);
    //rmAddObjectDefConstraint(whaleID, avoidLake);
    if (cNumberNonGaiaPlayers > 2)
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 1.5 * cNumberNonGaiaPlayers);
   else
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 2 * cNumberNonGaiaPlayers + 1);

    int fishID=rmCreateObjectDef("fish");
    rmAddObjectDefItem(fishID, "FishSalmon", 1, 0.0);
    rmSetObjectDefMinDistance(fishID, 0.0);
    rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(fishID, fishVsFishID);
    rmAddObjectDefConstraint(fishID, fishLand);
    //rmAddObjectDefConstraint(fishID, avoidCenterLake);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 6 + 10 * cNumberNonGaiaPlayers);
    
   // Text
   rmSetStatusText("",0.70);

	// Mines 
   if (cNumberNonGaiaPlayers > 2)
   {
        int silverID = rmCreateObjectDef("mapSilver");
        rmAddObjectDefItem(silverID, "mine", 1, 0.0);
        rmSetObjectDefMinDistance(silverID, 0.0);
        rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(silverID, avoidFastCoin45);
        rmAddObjectDefConstraint(silverID, avoidAllMines);
        rmAddObjectDefConstraint(silverID, avoidImpassableLandMed);
        rmAddObjectDefConstraint(silverID, avoidTradeRouteMH);
        //rmAddObjectDefConstraint(silverID, avoidEastBeach);
        rmAddObjectDefConstraint(silverID, avoidSocket);
        rmAddObjectDefConstraint(silverID, avoidStartingResources);
        //rmAddObjectDefConstraint(silverID, avoidEastLake);
        rmAddObjectDefConstraint(silverID, avoidWater8);
        rmAddObjectDefConstraint(silverID, circleConstraint);
        rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);  
   }
   else
   {
         
        int topMine = rmCreateObjectDef("topMine");
        rmAddObjectDefItem(topMine, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(topMine, 0.0);
        rmSetObjectDefMaxDistance(topMine, 22);
        rmAddObjectDefConstraint(topMine, avoidSocket2);
        rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(topMine, forestConstraintShort);
        rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
        rmAddObjectDefConstraint(topMine, circleConstraint2); 
        rmAddObjectDefConstraint(topMine, avoidWater8);
        rmAddObjectDefConstraint(topMine, avoidAll);       
        //west edge mine
        rmPlaceObjectDefAtLoc(topMine, 0, 0.25, 0.75, 1);  
        
        //east beach mine     
        rmPlaceObjectDefAtLoc(topMine, 0, 0.67, 0.47, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.53, 0.33, 1);
        //NW mines
        //TOP TR
        /*
        rmPlaceObjectDefAtLoc(topMine, 0, 0.64, 0.875, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.74, 1);
        */
        rmPlaceObjectDefAtLoc(topMine, 0, 0.62, 0.875, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.43, 0.79, 1);
        //west mines top->bot
        /*
        rmPlaceObjectDefAtLoc(topMine, 0, 0.34, 0.81, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.19, 0.66, 1);
        */
        //SW mines
        /*
        rmPlaceObjectDefAtLoc(topMine, 0, 0.125, 0.36, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.26, 0.5, 1);   */
        //BOT TR
        rmPlaceObjectDefAtLoc(topMine, 0, 0.125, 0.38, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.22, 0.56, 1);
    }
    
   // Define and place Forests
   int forestTreeID = 0;
   numTries=4*cNumberNonGaiaPlayers;
   int failCount=0;
   for (i=0; <numTries)
      {   
         int forest=rmCreateArea("forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(150), rmAreaTilesToFraction(250));
         rmSetAreaForestType(forest, "patagonia forest");
			// rmSetAreaForestType(forest, "dunes");
         rmSetAreaForestDensity(forest, 1.0);
         rmSetAreaForestClumpiness(forest, 0.2);
         rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
			rmAddAreaConstraint(forest, avoidFastCoinForest);
         // rmAddAreaConstraint(forest, avoidBeach);
         rmAddAreaConstraint(forest, avoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRoute); 
		  rmAddAreaConstraint(forest, avoidStartingUnits); 
		  rmAddAreaConstraint(forest, avoidStartingResources); 
			rmAddAreaConstraint(forest, avoidSocket); 
			rmAddAreaConstraint(forest, Eastward); 
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

   // Define and place Forests - now a few to the west too
   numTries=cNumberNonGaiaPlayers*2;
   failCount=0;
   for (i=0; <numTries)
      {   
         forest=rmCreateArea("west forest "+i);
         rmSetAreaWarnFailure(forest, false);
         rmSetAreaSize(forest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
         rmSetAreaForestType(forest, "patagonia forest");
			// rmSetAreaForestType(forest, "dunes");
         rmSetAreaForestDensity(forest, 1.0);
         rmSetAreaForestClumpiness(forest, 0.2);
         rmSetAreaForestUnderbrush(forest, 0.0);
         rmSetAreaCoherence(forest, 0.4);
         rmSetAreaSmoothDistance(forest, 10);
         rmAddAreaToClass(forest, rmClassID("classForest")); 
		 rmAddAreaToClass(forest, rmClassID("classWestForest")); 
         rmAddAreaConstraint(forest, forestConstraint);
		 rmAddAreaConstraint(forest, westForestConstraint);
         rmAddAreaConstraint(forest, avoidAll);
			rmAddAreaConstraint(forest, avoidFastCoinForest);
         // rmAddAreaConstraint(forest, avoidBeach);
         rmAddAreaConstraint(forest, avoidStartingResources); 
         rmAddAreaConstraint(forest, avoidImpassableLand); 
         rmAddAreaConstraint(forest, avoidTradeRoute); 
		  // rmAddAreaConstraint(forest, avoidStartingUnits); 
			rmAddAreaConstraint(forest, avoidSocket); 
			rmAddAreaConstraint(forest, Westward); 
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

	// Text
    rmSetStatusText("",0.80);
    int rheaID=rmCreateObjectDef("rhea flock");
    int mapHunts=rmCreateObjectDef("mapHunts");
    
   if (cNumberNonGaiaPlayers > 2)
   {
        //place rhea
        rmAddObjectDefItem(rheaID, "rhea", 8, 10.0);
        rmSetObjectDefMinDistance(rheaID, 0.0);
        rmSetObjectDefMaxDistance(rheaID, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(rheaID, avoidHunt);
        rmAddObjectDefConstraint(rheaID, avoidAll);
        rmAddObjectDefConstraint(rheaID, avoidImpassableLand);
        rmAddObjectDefConstraint(rheaID, avoidStartingUnits);
        rmAddObjectDefConstraint(rheaID, rheaAvoidTownCenter);
        rmAddObjectDefConstraint(rheaID, avoidTradeRoute);
        rmAddObjectDefConstraint(rheaID, avoidStartingResources);
        rmAddObjectDefConstraint(rheaID, Eastward);
        rmAddObjectDefConstraint(rheaID, avoidWater8);
        rmSetObjectDefCreateHerd(rheaID, true);
        rmPlaceObjectDefAtLoc(rheaID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
        
        rmAddObjectDefItem(mapHunts, "deer", 8, 6.0);
        rmSetObjectDefMinDistance(mapHunts, 0.0);
        rmSetObjectDefMaxDistance(mapHunts, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(mapHunts, avoidDeerMH);
        rmAddObjectDefConstraint(mapHunts, avoidAll);
        rmAddObjectDefConstraint(mapHunts, avoidImpassableLand);
        rmAddObjectDefConstraint(mapHunts, Westward);
        rmAddObjectDefConstraint(mapHunts, avoidStartingUnits);
        rmAddObjectDefConstraint(mapHunts, avoidSocket);
        rmAddObjectDefConstraint(mapHunts, avoidTradeRouteMH);
        rmAddObjectDefConstraint(mapHunts, avoidStartingResources);
        rmAddObjectDefConstraint(mapHunts, circleConstraint2);
        rmAddObjectDefConstraint(mapHunts, avoidEastBeach);
        rmAddObjectDefConstraint(mapHunts, avoidWater8);
        rmSetObjectDefCreateHerd(mapHunts, true);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
   }
   else
   {
          //1v1 balance
        int eastRhea = rmCreateObjectDef("eastRhea");
        rmAddObjectDefItem(eastRhea, "rhea", rmRandInt(8,8), 10.0);
        rmSetObjectDefCreateHerd(eastRhea, true);
        rmSetObjectDefMinDistance(eastRhea, 0);
        rmSetObjectDefMaxDistance(eastRhea, 15);
        rmAddObjectDefConstraint(eastRhea, avoidSocket2);
        rmAddObjectDefConstraint(eastRhea, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(eastRhea, forestConstraintShort);	
        rmAddObjectDefConstraint(eastRhea, avoidHunt2);
        rmAddObjectDefConstraint(eastRhea, avoidAll);       
        rmAddObjectDefConstraint(eastRhea, circleConstraint2);       
        rmAddObjectDefConstraint(eastRhea, avoidWater5);   
        rmPlaceObjectDefAtLoc(eastRhea, 0, 0.67, 0.47, 1);
        rmPlaceObjectDefAtLoc(eastRhea, 0, 0.53, 0.33, 1);
        
        //map hunts
/*
        int marker3 = rmCreateArea("marker3");
        rmSetAreaSize(marker3, 0.01, 0.01);
        rmSetAreaLocation(marker3, 0.29, 0.8);
        rmSetAreaBaseHeight(marker3, 2.0); // Was 10
        rmSetAreaCoherence(marker3, 1.0);
        rmSetAreaTerrainType(marker3, "texas\ground4_tex");
        rmBuildArea(marker3); 
*/
        
        int mapHunts2 = rmCreateObjectDef("mapHunts2");
        rmAddObjectDefItem(mapHunts2, "deer", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(mapHunts2, true);
        rmSetObjectDefMinDistance(mapHunts2, 0);
        rmSetObjectDefMaxDistance(mapHunts2, 15);
        rmAddObjectDefConstraint(mapHunts2, avoidSocket2);
        rmAddObjectDefConstraint(mapHunts2, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(mapHunts2, forestConstraintShort);	
        rmAddObjectDefConstraint(mapHunts2, avoidHunt2);
        rmAddObjectDefConstraint(mapHunts2, avoidAll);       
        rmAddObjectDefConstraint(mapHunts2, circleConstraint2); 
        rmAddObjectDefConstraint(mapHunts2, avoidWater5);   
                 
        //top
        rmPlaceObjectDefAtLoc(mapHunts2, 0, 0.65, 0.9, 1);
        rmPlaceObjectDefAtLoc(mapHunts2, 0, 0.51, 0.76, 1);
        
        //bot
        rmPlaceObjectDefAtLoc(mapHunts2, 0, 0.1, 0.35, 1);
        rmPlaceObjectDefAtLoc(mapHunts2, 0, 0.24, 0.49, 1);
        
        //west
        rmPlaceObjectDefAtLoc(mapHunts2, 0, 0.29, 0.8, 1);  
        rmPlaceObjectDefAtLoc(mapHunts2, 0, 0.2, 0.71, 1); 
   }
     
	int bigBerryPatches = rmCreateObjectDef("bigBerryPatches");
	rmAddObjectDefItem(bigBerryPatches, "BerryBush", 5, 12.0);
	rmSetObjectDefMinDistance(bigBerryPatches, 0.0);
	rmSetObjectDefMaxDistance(bigBerryPatches, 10.0);
	rmPlaceObjectDefAtLoc(bigBerryPatches, 0, 0.25, 0.75, 1);
    rmAddObjectDefConstraint(bigBerryPatches, avoidAll); 
    rmAddObjectDefConstraint(bigBerryPatches, avoidWater8);
  
   // Text
   rmSetStatusText("",0.90);
/*
	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
    rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
    rmAddObjectDefConstraint(sheepID, avoidStartingUnits);
	rmAddObjectDefConstraint(sheepID, avoidTradeRoute);
	rmAddObjectDefConstraint(sheepID, Westward);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
*/
	// Define and place Nuggets
	int nugget4ID = rmCreateObjectDef("nugget4");
	rmAddObjectDefItem(nugget4ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget4ID, 0.0);
	rmSetObjectDefMaxDistance(nugget4ID, rmXFractionToMeters(0.10));
	rmAddObjectDefConstraint(nugget4ID, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget4ID, avoidNugget);
	rmAddObjectDefConstraint(nugget4ID, avoidAll);
	rmAddObjectDefConstraint(nugget4ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget4ID, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget4ID, avoidSocket);
	rmAddObjectDefConstraint(nugget4ID, avoidWater8);
	rmAddObjectDefConstraint(nugget4ID, circleConstraint);
	rmAddObjectDefConstraint(nugget4ID, stayMidSmIsland);
	rmAddObjectDefConstraint(nugget4ID, avoidStartingResources);
	rmSetNuggetDifficulty(4, 4);
   if (cNumberNonGaiaPlayers > 2 && rmGetIsTreaty() == false)
   	rmPlaceObjectDefAtLoc(nugget4ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
	
	// Define and place Nuggets
	int nugget3ID = rmCreateObjectDef("nugget3");
	rmAddObjectDefItem(nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget3ID, 0.0);
	rmSetObjectDefMaxDistance(nugget3ID, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(nugget3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget3ID, avoidNugget);
	rmAddObjectDefConstraint(nugget3ID, avoidAll);
	rmAddObjectDefConstraint(nugget3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget3ID, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget3ID, avoidSocket);
	rmAddObjectDefConstraint(nugget3ID, avoidWater8);
	rmAddObjectDefConstraint(nugget3ID, circleConstraint);
	rmAddObjectDefConstraint(nugget3ID, stayMidSmIsland);
	rmAddObjectDefConstraint(nugget3ID, avoidStartingResources);
	rmSetNuggetDifficulty(3, 3);
   if (cNumberNonGaiaPlayers > 2)
   	rmPlaceObjectDefAtLoc(nugget3ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	
	int nugget2ID = rmCreateObjectDef("nugget2");
	rmAddObjectDefItem(nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget2ID, 0.0);
	rmSetObjectDefMaxDistance(nugget2ID, rmXFractionToMeters(0.40));
	rmAddObjectDefConstraint(nugget2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget2ID, avoidNugget);
	rmAddObjectDefConstraint(nugget2ID, avoidAll);
	rmAddObjectDefConstraint(nugget2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget2ID, avoidStartingUnits);
	rmAddObjectDefConstraint(nugget2ID, avoidSocket);
	rmAddObjectDefConstraint(nugget2ID, avoidWater8);
	rmAddObjectDefConstraint(nugget2ID, circleConstraint);
	rmAddObjectDefConstraint(nugget2ID, avoidStartingResources);
	rmSetNuggetDifficulty(2, 2);
	rmPlaceObjectDefAtLoc(nugget2ID, 0, 0.5, 0.5, 4+cNumberNonGaiaPlayers);
	
	int nuggetID = rmCreateObjectDef("nugget");
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
	rmAddObjectDefConstraint(nuggetID, avoidSocket);
	rmAddObjectDefConstraint(nuggetID, avoidWater8);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidStartingResources);
	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
   
   // check for KOTH game mode
   if (rmGetIsKOTH())
   {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
   rmSetStatusText("",1.0);      
}
