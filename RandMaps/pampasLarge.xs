// LARGE Pampas - needs to find a home as one of the overmap RM's.  Using pampas for now.
// October 2003
// Nov 06 - YP update
// May 2020: ...still using Pampas, perhaps we will find a home soon. Anyway, this is a balance update for DE by Rikikipu
// LARGE version by vividlyplain, July 2021
// updated the natives and trade route over river shallows, September 2021, vividlyplain

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("", 0.01);

	// ***************** CHOOSE NATIVES ******************
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;

	if (rmAllocateSubCivs(3) == true)
	{
		// Always Tupi.
		subCiv0 = rmGetCivID("mapuche");
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "mapuche");

		// For now, always Mapuche.
		subCiv1 = rmGetCivID("mapuche");
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "mapuche");

		// And for now, always Mapuche.
		subCiv2 = rmGetCivID("mapuche");
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "mapuche");
	}

	// *************************** MAP PARAMETERS **************************
	//int playerTiles=11000;		// OLD SIZE
	int playerTiles = 20000;
	if (cNumberNonGaiaPlayers > 4)
		playerTiles = 18000;
	if (cNumberNonGaiaPlayers > 6)
		playerTiles = 16000;
	if (cMapSize == 1)
	{
		playerTiles = 15000; // DAL modified from 18K
		rmEchoInfo("Large map");
	}
	int size = 1.7 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	int longSide = 1.4 * size; // 'Longside' is used to make the map rectangular
	rmEchoInfo("Map size=" + size + "m x " + longSide + "m");
	rmSetMapSize(longSide, size);

	// rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.5, 3.0);  // DAL - original
	rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
	rmSetMapElevationHeightBlend(1);

	// Picks a default water height
	rmSetSeaLevel(5.0);
	rmSetLightingSet("Pampas_Skirmish");

	// Picks default terrain and water
	rmSetSeaType("Pampas River RM");
	rmSetBaseTerrainMix("pampas_dirt");
	rmTerrainInitialize("pampas\ground5_pam", 6.0);
	rmEnableLocalWater(false);
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetMapType("pampas");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);

	chooseMercs();

	//	rmSetLightingSet("alfheim");

	// ************************************** DEFINE CLASSES *********************************
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("corner");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("classNugget");
	rmDefineClass("natives");
	rmDefineClass("classCliff");

	// ************************************ DEFINE CONSTRAINTS ***********************************

	// Map edge constraints
	int playerEdgeConstraint = rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0 - rmXTilesToFraction(6), 1.0 - rmZTilesToFraction(6), 0.01);
	int longplayerEdgeConstraint = rmCreateBoxConstraint("long player edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0 - rmXTilesToFraction(20), 1.0 - rmZTilesToFraction(20), 0.01);
	int longPlayerConstraint = rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 60.0);

	// Cardinal Directions
	int Northward = rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int Southward = rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int Eastward = rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int Westward = rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));

	// Player constraints
	int playerConstraint = rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
	int mediumPlayerConstraint = rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 15.0);
	int shortPlayerConstraint = rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);
	int smallMapPlayerConstraint = rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
	int forestObjConstraint = rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint = rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 60.0);
	int avoidResource = rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource = rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
	int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "gold", 30.0);
	int avoidStartResource = rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand = rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
	int hillConstraint = rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
	int shortHillConstraint = rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
	int patchConstraint = rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs = rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 50.0);
	int shortAvoidCliffs = rmCreateClassDistanceConstraint("short cliff vs. cliff", rmClassID("classCliff"), 5.0);
	int avoidSilver = rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 75.0);
	int mediumAvoidSilver = rmCreateTypeDistanceConstraint("medium gold avoid gold", "Mine", 30.0);
	int avoidTrees = rmCreateTypeDistanceConstraint("avoid trees", "TreeGreatPlains", 75.0);
	int shortAvoidTrees = rmCreateTypeDistanceConstraint("short avoid trees", "TreePampas", 44.0);
	int deerAvoidDeer = rmCreateTypeDistanceConstraint("deer avoid deer", "rhea", 75.0);
	int avoidNuggets = rmCreateClassDistanceConstraint("nugget vs. nugget", rmClassID("classNugget"), 20.0);
	int avoidNuggetFar = rmCreateClassDistanceConstraint("nugget vs. nugget far", rmClassID("classNugget"), 100.0);
	//int avoidTobacco=rmCreateTypeDistanceConstraint("avoid tobacco", "tobacco", 40.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 10.0);

	// Specify true so constraint stays outside of circle (i.e. inside corners)
	int cornerConstraint0 = rmCreateCornerConstraint("in corner 0", 0, true);
	int cornerConstraint1 = rmCreateCornerConstraint("in corner 1", 1, true);
	int cornerConstraint2 = rmCreateCornerConstraint("in corner 2", 2, true);
	int cornerConstraint3 = rmCreateCornerConstraint("in corner 3", 3, true);
	int insideCircleConstraint = rmCreateCornerConstraint("inside circle", -1, false);
	int circleConstraint = rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 40.0);
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), rmXFractionToMeters(0.3));
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int shortAvoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 10);
	int farAvoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives alot", rmClassID("natives"), 80.0);
	int avoidLlama = rmCreateTypeDistanceConstraint("llama avoids llama", "llama", 75.0);

	// Decoration avoidance
	int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);

	// Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeRouteSockets = rmCreateTypeDistanceConstraint("avoid trade route sockets", "sockettraderoute", 8.0);
	int avoidTradeRouteSocketsFar = rmCreateTypeDistanceConstraint("avoid trade route sockets far", "sockettraderoute", 16.0);
	int avoidMineSockets = rmCreateTypeDistanceConstraint("avoid mine sockets", "mine", 10.0);

	// ************************** DEFINE OBJECTS ****************************

	int grizzlyID = rmCreateObjectDef("grizzly float");
	float bonusChance = rmRandFloat(0, 1);
	if (bonusChance < 0.5)
		rmAddObjectDefItem(grizzlyID, "Jaguar", 1, 0.0);
	else
		rmAddObjectDefItem(grizzlyID, "Jaguar", rmRandInt(2, 4), 4.0);
	rmSetObjectDefMinDistance(grizzlyID, 0.0);
	rmSetObjectDefMaxDistance(grizzlyID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(grizzlyID, avoidResource);
	rmAddObjectDefConstraint(grizzlyID, avoidImpassableLand);

	// -------------Done defining objects
	// Text
	rmSetStatusText("", 0.10);

	// Define river width based on # of players
	int rivermin = -1;
	int rivermax = -1;

	if (cNumberNonGaiaPlayers <= 3)
	{
		rivermin = 5;
		rivermax = 6;
	}
	else
	{
		rivermin = 6;
		rivermax = 8;
	}

	// ************************* TRADE ROUTE **********************
	int riverPlacement = -1;
	if (cNumberNonGaiaPlayers <= 3) // 1v1 or 1v2 won't generate parallel river version
		riverPlacement = 0;
	else
		riverPlacement = rmRandInt(0, 1);
		
	int socketID = rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	rmAddObjectDefConstraint(socketID, avoidWater);

	//	float tradeRouteLoc = 0.4; // can lock this value to test a cases of trade route placement
	float tradeRouteLoc = 0.4; //rmRandFloat(0,1);
	rmEchoInfo("TRADE ROUTE FLOAT=" + tradeRouteLoc + "");
	int tradeRouteID = rmCreateTradeRoute();
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	if (riverPlacement == 1) // PARALLEL
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.50);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.35, 0.40, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.65, 0.53, 5, 8);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.0, 0.45, 5, 8);
		bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt_trail");
		if (placedTradeRouteA == false)
			rmEchoError("Failed to place trade route");
		rmPlaceObjectDefAtLoc(socketID, 0, 0.05, 0.50);
		rmPlaceObjectDefAtLoc(socketID, 0, 0.35, 0.41);
		rmPlaceObjectDefAtLoc(socketID, 0, 0.65, 0.53);
		rmPlaceObjectDefAtLoc(socketID, 0, 0.95, 0.45);
	}
	else
	{
		if (tradeRouteLoc < 0.50) // from bottom - start north end south
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.70);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.45, 0.70, 5, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.55, 0.25, 5, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.0, 0.30, 5, 8);
			bool placedTradeRouteC = rmBuildTradeRoute(tradeRouteID, "dirt_trail");
			if (placedTradeRouteC == false)
				rmEchoError("Failed to place trade route");
			rmPlaceObjectDefAtLoc(socketID, 0, 0.92, 0.30);
			rmPlaceObjectDefAtLoc(socketID, 0, 0.45, 0.70);
			rmPlaceObjectDefAtLoc(socketID, 0, 0.55, 0.25);
			rmPlaceObjectDefAtLoc(socketID, 0, 0.08, 0.70);
		}
		else // from bottom - start south end north
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.30);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.40, 0.40, 5, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.60, 0.60, 5, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 1.0, 0.70, 5, 8);
			bool placedTradeRouteE = rmBuildTradeRoute(tradeRouteID, "dirt_trail");
			if (placedTradeRouteE == false)
				rmEchoError("Failed to place trade route");
			rmPlaceObjectDefAtLoc(socketID, 0, 0.08, 0.30);
			rmPlaceObjectDefAtLoc(socketID, 0, 0.40, 0.40);
			rmPlaceObjectDefAtLoc(socketID, 0, 0.60, 0.60);
			rmPlaceObjectDefAtLoc(socketID, 0, 0.92, 0.70);
		}
	}
	// ************************* PLACE THE RIVER **************************
	//	float shallowsLoc = rmRandFloat(0,1);

	// SINGLE WIDE RIVER
	if (riverPlacement == 0)
	{
		int coloradoRiver = rmRiverCreate(-1, "Pampas River RM", 20, 10, rivermin, rivermax); // SINGLE WIDE RIVER
		rmRiverSetConnections(coloradoRiver, 0.0, 0.35, 1.0, 0.38);

		rmRiverSetShallowRadius(coloradoRiver, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver, rmRandFloat(0.1, 0.35)); // Begin defining shallows in the river

		rmRiverSetShallowRadius(coloradoRiver, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver, 0.5);

		rmRiverSetShallowRadius(coloradoRiver, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver, rmRandFloat(0.65, 0.95));
		rmRiverSetBankNoiseParams(coloradoRiver, 0.07, 2, 1.5, 10.0, 0.667, 3.0);

		rmRiverBuild(coloradoRiver);
		//rmRiverReveal(coloradoRiver, 0);
	}
	else
	{
		int coloradoRiver3 = rmRiverCreate(-1, "Pampas River RM", 30, 10, rivermin, rivermax); // PARALLEL RIVERS
		rmRiverSetConnections(coloradoRiver3, 0.0, 0.20, 1.0, 0.20);

		rmRiverSetShallowRadius(coloradoRiver3, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver3, rmRandFloat(0.1, 0.35)); // Begin defining shallows in the river

		rmRiverSetShallowRadius(coloradoRiver3, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver3, 0.5);

		rmRiverSetShallowRadius(coloradoRiver3, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver3, rmRandFloat(0.65, 0.95));
		rmRiverSetBankNoiseParams(coloradoRiver3, 0.07, 2, 1.5, 10.0, 0.667, 3.0);

		rmRiverBuild(coloradoRiver3);
		//rmRiverReveal(coloradoRiver3, 0);

		int coloradoRiver4 = rmRiverCreate(-1, "Pampas River RM", 30, 10, rivermin, rivermax);
		rmRiverSetConnections(coloradoRiver4, 0.0, 0.5, 1.0, 0.5);

		rmRiverSetShallowRadius(coloradoRiver4, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver4, rmRandFloat(0.1, 0.35)); // Begin defining shallows in the river

		rmRiverSetShallowRadius(coloradoRiver4, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver4, 0.5);

		rmRiverSetShallowRadius(coloradoRiver4, rmRandInt(10, 12));
		rmRiverAddShallow(coloradoRiver4, rmRandFloat(0.65, 0.95));
		rmRiverSetBankNoiseParams(coloradoRiver4, 0.07, 2, 1.5, 10.0, 0.667, 3.0);

		rmRiverBuild(coloradoRiver4);
		//rmRiverReveal(coloradoRiver4, 0);
	}

	// ***********************	PLACE PLAYERS ***********************

	// *** Set up player starting locations. Rectangular at far ends of the map.

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	float OneVOnePlacement = 0;
	if (cNumberTeams == 2 && teamZeroCount <= 4 && teamOneCount <= 4)
	{
		// TEAM ONE PLACEMENT RULES
		if (teamZeroCount == 1)
		{
			rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.23, 0.15, 0.23, 0.85, .02, 0.00);
		}
		else if (teamZeroCount >= 2)
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.20, 0.60, 0.20, 0.10, 0.05, 0.2);
			rmSetTeamSpacingModifier(0.25);
			//rmSetPlacementSection(0.01, 0.25);
		}

		// TEAM 2 PLACEMENT RULES
		if (teamOneCount == 1)
		{
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.77, 0.83, 0.77, 0.17, .02, 0.00);
		}
		else if (teamOneCount >= 2)
		{
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.80, 0.1, 0.80, 0.60, 0.1, 0.2);
			//rmSetPlacementSection(0.5, 0.75);
		}
	}
	else
	{
        if(cNumberNonGaiaPlayers==3){
            rmSetTeamSpacingModifier(0.7);
            rmPlacePlayersSquare(0.38, 0.0, 0.00);
        }else{
            rmSetTeamSpacingModifier(0.7);
            rmPlacePlayersSquare(0.38, 0.0, 0.0);
        }
		
	}

	// Set up player areas.
	float playerFraction = rmAreaTilesToFraction(100);
	for (i = 1; < cNumberPlayers)
	{
		// Create the area.
		int id = rmCreateArea("Player" + i);
		// Assign to the player.
		rmSetPlayerArea(i, id);
		// Set the size.
		rmSetAreaSize(id, playerFraction, playerFraction);
		rmAddAreaToClass(id, classPlayer);
		rmSetAreaMix(id, "pampas_grass");
		rmSetAreaMinBlobs(id, 1);
		rmSetAreaMaxBlobs(id, 1);
		rmAddAreaConstraint(id, playerConstraint);
		rmAddAreaConstraint(id, playerEdgeConstraint);
		rmSetAreaCoherence(id, 1.0);
		//	  rmAddAreaConstraint(id, avoidWater);
		rmAddAreaConstraint(id, longAvoidImpassableLand);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaWarnFailure(id, false);
	}

	// Build the areas.
	rmBuildAllAreas();

	// starting resources
	int TCfloat = -1;
	if (cNumberNonGaiaPlayers <= 2){
		TCfloat = 0;
	}else if (cNumberNonGaiaPlayers <= 4){
        TCfloat = 18;
    }else{
        TCfloat = 30;
    }
		

	int startingTCID = rmCreateObjectDef("startingTC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 5.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "townCenter", 1, 5.0);
	}
	rmSetObjectDefMinDistance(startingTCID, 0);
	rmSetObjectDefMaxDistance(startingTCID, TCfloat);
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingTCID, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSockets);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	//rmAddObjectDefConstraint(startingTCID, avoidWater);
	//rmPlaceObjectDefPerPlayer(startingTCID, true);

	int StartAreaTreeID = rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreePampas", 5, 7.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 10);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 14);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);
	//	rmAddObjectDefConstraint(StartAreaTreeID, playerConstraint);
	//rmPlaceObjectDefPerPlayer(StartAreaTreeID, true);

	int StartBerriesID = rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 3, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 20);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartResource);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, avoidNatives);
	//rmAddObjectDefConstraint(StartBerriesID, deerAvoidDeer);
	rmAddObjectDefConstraint(StartBerriesID, shortPlayerConstraint);
	//rmPlaceObjectDefPerPlayer(StartBerriesID, true);

	// Text
	rmSetStatusText("", 0.20);

	int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(startSilverID, shortAvoidTradeRoute);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 15.0);
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);
	//rmPlaceObjectDefPerPlayer(startSilverID, true);

	int startHunt = rmCreateObjectDef("start hunt");
	rmAddObjectDefItem(startHunt, "rhea", 4, 2.0);
	rmAddObjectDefConstraint(startHunt, shortAvoidTradeRoute);
	rmSetObjectDefMinDistance(startHunt, 12.0);
	rmSetObjectDefMaxDistance(startHunt, 13.0);
	rmAddObjectDefConstraint(startHunt, avoidAll);
	rmAddObjectDefConstraint(startHunt, avoidImpassableLand);
	rmSetObjectDefCreateHerd(startHunt, true);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidResource);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);
	//rmAddObjectDefConstraint(startingUnits, avoidWater);
	//rmPlaceObjectDefPerPlayer(startingUnits, true);

	// John's sweet solution to placing stuff around the TC regardless of where the player start area actually is, YAY!!!!!!
	for (i = 1; < cNumberPlayers)
	{

		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(startHunt, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

		if (ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 0), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	}

	// Text
	rmSetStatusText("", 0.40);

	// **************************** NATIVES **************************

	float SecretLoc = rmRandFloat(0, 1);
	float SecretChoice = rmRandFloat(0, 1);
	//rmEchoInfo("SECRET LOC RANDOM NUM="+SecretLoc+"");
	//rmEchoInfo("SECRET CHOICE RANDOM NUM="+SecretChoice+"");
	// Text`
	rmSetStatusText("", 0.50);

	float NativeVillageLoc = rmRandFloat(0, 1);
	//if (cNumberNonGaiaPlayers <= 3)
	//	riverPlacement = 1;

	// Comanche, Iroquois, Aztec rules (DAL - these are stub for now.)
	if (riverPlacement >= 0)
	{
		if (rmRandFloat(0, 1) > 0.5)
		{
			int mayaVillageID = -1;
			int tupisVillageType = rmRandInt(1, 5);
			mayaVillageID = rmCreateGrouping("tupis village", "native mapuche village " + tupisVillageType);
			rmSetGroupingMinDistance(mayaVillageID, 0.0);
			rmSetGroupingMaxDistance(mayaVillageID, 5.0);
			rmAddGroupingConstraint(mayaVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(mayaVillageID, mediumPlayerConstraint);
			rmAddGroupingToClass(mayaVillageID, rmClassID("natives"));
			rmAddGroupingToClass(mayaVillageID, rmClassID("importantItem"));
			rmAddGroupingConstraint(mayaVillageID, avoidTradeRouteFar);
			rmAddGroupingConstraint(mayaVillageID, avoidTradeRouteSocketsFar);
			rmPlaceGroupingAtLoc(mayaVillageID, 0, 0.63, 0.83);
			rmPlaceGroupingAtLoc(mayaVillageID, 0, 0.37, 0.17);
		}
		else
		{
			int mapuche3VillageID = -1;
			int mapuche3VillageType = rmRandInt(1, 5);

			mapuche3VillageID = rmCreateGrouping("mapuche3 village", "native mapuche village " + mapuche3VillageType);
			rmSetGroupingMinDistance(mapuche3VillageID, 0.0);
			rmSetGroupingMaxDistance(mapuche3VillageID, 5.0);
			rmAddGroupingConstraint(mapuche3VillageID, avoidImpassableLand);
			rmAddGroupingConstraint(mapuche3VillageID, mediumPlayerConstraint);
			rmAddGroupingToClass(mapuche3VillageID, rmClassID("natives"));
			rmAddGroupingToClass(mapuche3VillageID, rmClassID("importantItem"));
			//rmAddGroupingConstraint(mapuche3VillageID, insideCircleConstraint);
			rmAddGroupingConstraint(mapuche3VillageID, avoidTradeRouteSocketsFar);
			rmAddGroupingConstraint(mapuche3VillageID, avoidTradeRoute);
			rmPlaceGroupingAtLoc(mapuche3VillageID, 0, 0.63, 0.83);
			rmPlaceGroupingAtLoc(mapuche3VillageID, 0, 0.37, 0.17);
		}
	}
	else
	{
		if (subCiv0 == rmGetCivID("tupi"))
		{
			int comancheVillageID = -1;
			int comancheVillageType = rmRandInt(1, 5);
			//		comancheVillageID = rmCreateGrouping("mayan village", "native maya village "+comancheVillageType);
			comancheVillageID = rmCreateGrouping("tupis village2", "native mapuche village " + comancheVillageType);
			rmSetGroupingMinDistance(comancheVillageID, 0.0);
			rmSetGroupingMaxDistance(comancheVillageID, 5.0);
			rmAddGroupingConstraint(comancheVillageID, avoidImpassableLand);
			rmAddGroupingToClass(comancheVillageID, rmClassID("natives"));
			rmAddGroupingToClass(comancheVillageID, rmClassID("importantItem"));
			//		rmAddGroupingConstraint(comancheVillageID, avoidImportantItem);
			//		rmAddGroupingConstraint(comancheVillageID, farAvoidNatives);
			//rmAddGroupingConstraint(comancheVillageID, insideCircleConstraint);
			rmAddGroupingConstraint(comancheVillageID, avoidTradeRouteFar);
			//		rmAddGroupingConstraint(comancheVillageID, longPlayerConstraint);
			if (SecretLoc < 0.53) // CASE 1 0.33
			{
				rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.48, 0.78);
			}
			else //(SecretLoc < 0.67) // CASE 2
			{
				rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.38, 0.90);
			}
			//else  // CASE 3
			//	{
			//		 rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.30, 0.78);
			//	}
		}

		if (subCiv1 == rmGetCivID("mapuche"))
		{
			int mapuche1VillageID = -1;
			int mapuche1VillageType = rmRandInt(1, 5);
			//		mapuche1VillageID = rmCreateGrouping("inca village", "native mapuche village "+tupis1VillageType);
			mapuche1VillageID = rmCreateGrouping("mapuche1 village", "native mapuche village " + mapuche1VillageType);
			rmSetGroupingMinDistance(mapuche1VillageID, 0.0);
			rmSetGroupingMaxDistance(mapuche1VillageID, 5.0);
			rmAddGroupingConstraint(mapuche1VillageID, avoidImpassableLand);
			rmAddGroupingToClass(mapuche1VillageID, rmClassID("natives"));
			rmAddGroupingToClass(mapuche1VillageID, rmClassID("importantItem"));
			//		rmAddGroupingConstraint(mapuche1VillageID, avoidImportantItem);
			//		rmAddGroupingConstraint(mapuche1VillageID, farAvoidNatives);
			//rmAddGroupingConstraint(mapuche1VillageID, insideCircleConstraint);
			rmAddGroupingConstraint(mapuche1VillageID, avoidTradeRouteFar);
			//		rmAddGroupingConstraint(mapuche1VillageID, longPlayerConstraint);
			if (SecretLoc < 0.53) // CASE 1
			{
				rmPlaceGroupingAtLoc(mapuche1VillageID, 0, 0.38, 0.16);
			}
			else //(SecretLoc < 0.67) // CASE 2
			{
				rmPlaceGroupingAtLoc(mapuche1VillageID, 0, 0.65, 0.82);
			}
			//	else  // CASE 3
			//	{
			//		 rmPlaceGroupingAtLoc(tupis1VillageID, 0, 0.70, 0.86);
			//	}
		}

		if (subCiv2 == rmGetCivID("mapuche"))
		{
			int mapuche2VillageID = -1;
			int mapuche2VillageType = rmRandInt(1, 5);
			mapuche2VillageID = rmCreateGrouping("mapuche2 village", "native mapuche village " + mapuche2VillageType);
			rmSetGroupingMinDistance(mapuche2VillageID, 0.0);
			rmSetGroupingMaxDistance(mapuche2VillageID, 5.0);
			rmAddGroupingConstraint(mapuche2VillageID, avoidImpassableLand);
			rmAddGroupingToClass(mapuche2VillageID, rmClassID("natives"));
			rmAddGroupingToClass(mapuche2VillageID, rmClassID("importantItem"));
			//		rmAddGroupingConstraint(mapuche2VillageID, avoidImportantItem);
			//		rmAddGroupingConstraint(mapuche2VillageID, farAvoidNatives);
			//rmAddGroupingConstraint(mapuche2VillageID, insideCircleConstraint);
			rmAddGroupingConstraint(mapuche2VillageID, avoidTradeRouteFar);
			//		rmAddGroupingConstraint(mapuche2VillageID, longPlayerConstraint);
			if (SecretLoc < 0.53) // CASE 1
			{
				rmPlaceGroupingAtLoc(mapuche2VillageID, 0, 0.65, 0.20);
			}
			else //(SecretLoc < 0.67) // CASE 2
			{
				rmPlaceGroupingAtLoc(mapuche2VillageID, 0, 0.48, 0.20);
			}
			//	else  // CASE 3
			//	{
			//		 rmPlaceGroupingAtLoc(tupis2VillageID, 0, 0.48, 0.72);
			//	}
		}
	}

	// Text
	rmSetStatusText("", 0.60);

	// Text
	rmSetStatusText("", 0.80);

	// ************************* TERRAIN PATCHES *************************

	// make Mainland more pretty by placing patches of terrain
	// For this map, place patches before cliffs so they can avoid impassable land by a lot
	for (i = 0; < 30)
	{
		int patch = rmCreateArea("first patch " + i);
		rmSetAreaWarnFailure(patch, false);
		rmSetAreaSize(patch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaMix(patch, "pampas_grass");
		// rmSetAreaTerrainType(patch, "great_plains\ground8_gp");
		// rmAddAreaTerrainLayer(patch, "carolinas\grass3", 0, 1);
		rmAddAreaToClass(patch, rmClassID("classPatch"));
		rmSetAreaMinBlobs(patch, 1);
		rmSetAreaMaxBlobs(patch, 5);
		rmSetAreaMinBlobDistance(patch, 16.0);
		rmSetAreaMaxBlobDistance(patch, 40.0);
		rmSetAreaCoherence(patch, 0.0);
		rmAddAreaConstraint(patch, shortAvoidImpassableLand);
		rmBuildArea(patch);
	}

	for (i = 0; < 10)
	{
		int dirtPatch = rmCreateArea("open dirt patch " + i);
		rmSetAreaWarnFailure(dirtPatch, false);
		rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaMix(dirtPatch, "pampas_grass");
		//rmSetAreaTerrainType(dirtPatch, "great_plains\ground7_gp");
		// rmAddAreaTerrainLayer(dirtPatch, "great_plains\ground2_gp", 0, 1);
		rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
		//rmSetAreaBaseHeight(dirtPatch, 4.0);
		rmSetAreaMinBlobs(dirtPatch, 1);
		rmSetAreaMaxBlobs(dirtPatch, 5);
		rmSetAreaMinBlobDistance(dirtPatch, 16.0);
		rmSetAreaMaxBlobDistance(dirtPatch, 40.0);
		rmSetAreaCoherence(dirtPatch, 0.0);
		rmSetAreaSmoothDistance(dirtPatch, 10);
		rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
		rmAddAreaConstraint(dirtPatch, patchConstraint);
		rmBuildArea(dirtPatch);
	}

	// Text
	rmSetStatusText("", 0.85);

	// ************************* Place wacky silver mines! ************************

	int silverType = rmRandInt(1, 10);
	int silverID = -1;
	int silverCount = cNumberNonGaiaPlayers * 3;
	rmEchoInfo("silver count = " + silverCount);

	if (cNumberNonGaiaPlayers > 2)
	{
		for (i = 0; < silverCount)
		{
			silverID = rmCreateObjectDef("silver mines" + i);
			rmAddObjectDefItem(silverID, "mine", rmRandInt(1, 1), 5.0);
			rmSetObjectDefMinDistance(silverID, 0.0);
			rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint(silverID, avoidNatives);
			rmAddObjectDefConstraint(silverID, avoidImpassableLand);
			rmAddObjectDefConstraint(silverID, avoidSilver);
			rmAddObjectDefConstraint(silverID, playerConstraint);
			rmAddObjectDefConstraint(silverID, avoidWater);
			rmAddObjectDefConstraint(silverID, shortAvoidTradeRoute);
			rmAddObjectDefConstraint(silverID, avoidTradeRouteSockets);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
		}
	}
	else
	{
		silverID = rmCreateObjectDef("silver mines" + i);
		rmAddObjectDefItem(silverID, "mine", rmRandInt(1, 1), 5.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, 0.0);
		if (rmRandFloat(0, 1) < 0.33)
		{
			rmPlaceObjectDefAtLoc(silverID, 0, 0.1, 0.3);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.9, 0.7);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.4, 0.3);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.6, 0.7);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.3, 0.9);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.7, 0.1);
		}
		else if (rmRandFloat(0, 1) < 0.66)
		{
			rmPlaceObjectDefAtLoc(silverID, 0, 0.4, 0.6);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.6, 0.4);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.85, 0.2);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.15, 0.8);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.63, 0.93);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.37, 0.07);
		}
		else
		{
			rmPlaceObjectDefAtLoc(silverID, 0, 0.1, 0.6);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.9, 0.4);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.3, 0.3);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.7, 0.7);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.4, 0.9);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.6, 0.1);
		}
	}

	int deerID = rmCreateObjectDef("deer herd");
	rmAddObjectDefItem(deerID, "rhea", 10, 6.0);
	rmSetObjectDefCreateHerd(deerID, true);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(deerID, avoidResource);
	rmAddObjectDefConstraint(deerID, mediumPlayerConstraint);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerID, deerAvoidDeer);
	rmAddObjectDefConstraint(deerID, avoidNatives);
	rmAddObjectDefConstraint(deerID, avoidTradeRouteSockets);

	/*
   rmPlaceObjectDefPerPlayer(silverIDs, false, 1); // old placement method
   rmPlaceObjectDefPerPlayer(silverIDn, false, 1); 
*/

	// ********************** FORESTS *************************
	int forestTreeID = 0;

	int numTries = 10 * cNumberNonGaiaPlayers; // DAL - 3 here, 3 below
	int failCount = 0;
	for (i = 0; < numTries)
	{
		int forestID = rmCreateArea("forest" + i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaForestType(forestID, "pampas forest");
		rmSetAreaForestDensity(forestID, 0.8);
		rmSetAreaForestClumpiness(forestID, 0.0); //DAL more forest with more clumps
		rmSetAreaForestUnderbrush(forestID, 0.0);
		rmSetAreaCoherence(forestID, 0.4);
		rmAddAreaConstraint(forestID, avoidNatives);		   // DAL added, to try and make sure natives got on the map w/o override.
		rmAddAreaConstraint(forestID, mediumPlayerConstraint); // PJJ modified - short constraint is not large enough for consistent monastery placementppp
		rmAddAreaConstraint(forestID, shortAvoidTrees);		   // DAL adeed, to keep forests away from each other.
		rmAddAreaConstraint(forestID, shortAvoidResource);
		rmAddAreaConstraint(forestID, shortAvoidTradeRoute);
		rmAddAreaConstraint(forestID, avoidTradeRouteSockets);
		rmAddAreaConstraint(forestID, avoidMineSockets);
		rmAddAreaConstraint(forestID, shortAvoidImportantItem);
		if (rmBuildArea(forestID) == false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if (failCount == 5)
				break;
		}
		else
			failCount = 0;
	}

	/* 
numTries=8*cNumberNonGaiaPlayers;  // DAL - 3 here, three above.
	failCount=0;
	for (i=0; <numTries)
		{   
			int grassID=rmCreateArea("grassID"+i);
			rmSetAreaWarnFailure(grassID, false);
			rmSetAreaSize(grassID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
			rmSetAreaForestType(grassID, "great plains grass");
			rmSetAreaForestDensity(grassID, 0.4);
			rmSetAreaForestClumpiness(grassID, 0.1);	
			rmSetAreaForestUnderbrush(grassID, 0.0);
			rmSetAreaCoherence(grassID, 0.4);
			rmAddAreaConstraint(grassID, avoidNatives);			
			rmAddAreaConstraint(grassID, shortAvoidTrees);   
			rmAddAreaConstraint(grassID, shortAvoidResource);			
			rmAddAreaConstraint(grassID, avoidTradeRoute);
			rmAddAreaConstraint(grassID, avoidTradeRouteSockets);
			rmAddAreaConstraint(grassID, avoidMineSockets);
			rmAddAreaConstraint(grassID, shortAvoidImportantItem);
			if(rmBuildArea(grassID)==false)
			{
				// Stop trying once we fail 5 times in a row.  
				failCount++;
				if(failCount==5)
					break;
			}
			else
				failCount=0; 
		} 

*/
	// *********************** OBJECTS PLACED AFTER FORESTS ********************
	// Resources that can be placed after forests
	//rmPlaceObjectDefPerPlayer(elkID, false, rmRandInt(4,5));
	rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 6 * cNumberNonGaiaPlayers);
	//	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers);  //DAL used to be 18.

	// Text
	rmSetStatusText("", 0.90);

	// ********************* DECORATIONS ************************
	int rockID = rmCreateObjectDef("lone rock");
	int avoidRock = rmCreateTypeDistanceConstraint("avoid rock", "underbrushPampas", 8.0);
	rmAddObjectDefItem(rockID, "underbrushPampas", 1, 0.0);
	rmSetObjectDefMinDistance(rockID, 0.0);
	rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockID, avoidAll);
	rmAddObjectDefConstraint(rockID, avoidImpassableLand);
	rmAddObjectDefConstraint(rockID, avoidRock);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 15 * cNumberNonGaiaPlayers);

	int Grass = rmCreateObjectDef("grass");
	rmAddObjectDefItem(Grass, "underbrushPampas", 1, 0.0);
	rmSetObjectDefMinDistance(Grass, 0.0);
	rmSetObjectDefMaxDistance(Grass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(Grass, avoidAll);
	rmAddObjectDefConstraint(Grass, avoidImpassableLand);
	rmAddObjectDefConstraint(Grass, avoidRock);
	rmPlaceObjectDefAtLoc(Grass, 0, 0.5, 0.5, 8 * cNumberNonGaiaPlayers);

	int rockAndGrass = rmCreateObjectDef("grass and rock");
	rmAddObjectDefItem(rockAndGrass, "underbrushPampas", 2, 2.0);
	rmAddObjectDefItem(rockAndGrass, "underbrushPampas", 1, 2.0);
	rmSetObjectDefMinDistance(rockAndGrass, 0.0);
	rmSetObjectDefMaxDistance(rockAndGrass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockAndGrass, avoidAll);
	rmAddObjectDefConstraint(rockAndGrass, avoidImpassableLand);
	rmAddObjectDefConstraint(rockAndGrass, avoidRock);
	rmPlaceObjectDefAtLoc(rockAndGrass, 0, 0.5, 0.5, 8 * cNumberNonGaiaPlayers);

	int pampasGrassType = -1;
	int pampasGrassID = -1;

	for (i = 0; < cNumberNonGaiaPlayers * 4)
	{
		pampasGrassType = rmRandInt(4, 9);
		pampasGrassID = rmCreateGrouping("tall grass group " + i, "pa_grasspatch01"); //+pampasGrassType);
		rmSetGroupingMinDistance(pampasGrassID, 0.0);
		rmSetGroupingMaxDistance(pampasGrassID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(pampasGrassID, playerConstraint);
		rmAddGroupingConstraint(pampasGrassID, avoidCoin);
		//		rmAddGroupingConstraint(pampasGrassID, avoidResource);
		rmAddGroupingConstraint(pampasGrassID, avoidNatives);
		rmAddGroupingConstraint(pampasGrassID, avoidImpassableLand);
		rmAddGroupingConstraint(pampasGrassID, avoidTradeRoute);
		//		rmAddGroupingConstraint(pampasGrassID, avoidSilver);
		//		rmAddGroupingConstraint(pampasGrassID, avoidTobacco);
		rmPlaceGroupingAtLoc(pampasGrassID, 0, 0.5, 0.5);
	}

	/*
	for(i=1; <cNumberPlayers)
	{
		
		// Test of Marcin's Starting Units stuff...
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		//rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Place starting resources - DAL
//		rmPlaceGroupingAtLoc(StartAreaSilverID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartElkID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		//vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		//rmSetHomeCityGatherPoint(i, closestPoint);
	}

*/

	/*
	int pampasGrassType = -1;
   int pampasGrassID = -1;
   
   for(i=0; <cNumberNonGaiaPlayers*3)
   {
		pampasGrassType = rmRandInt(1,3);
		pampasGrassID = rmCreateGrouping("tall grass group "+i, "pampas grass"+tobaccoType);
		rmSetGroupingMinDistance(pampasGrassID, 0.0);
		rmSetGroupingMaxDistance(pampasGrassID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(pampasGrassID, playerConstraint); 
		rmAddGroupingConstraint(pampasGrassID, avoidCoin);
//		rmAddGroupingConstraint(pampasGrassID, avoidResource);
//		rmAddGroupingConstraint(pampasGrassID, avoidNatives);
		rmAddGroupingConstraint(pampasGrassID, avoidImpassableLand);
		rmAddGroupingConstraint(pampasGrassID, avoidTradeRoute);
//		rmAddGroupingConstraint(pampasGrassID, avoidSilver);
//		rmAddGroupingConstraint(pampasGrassID, avoidTobacco);
		rmPlaceGroupingAtLoc(pampasGrassID, 0, 0.5, 0.5);
   }
*/

	// ******************** TREASURES *******************
	int nugget4 = rmCreateObjectDef("nugget harder");
	rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmAddObjectDefToClass(nugget4, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget4, 0.05);
	rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nugget4, avoidResource);
	rmAddObjectDefConstraint(nugget4, avoidNuggetFar);
	rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget4, mediumPlayerConstraint);
	rmAddObjectDefConstraint(nugget4, circleConstraint);
	if (cNumberNonGaiaPlayers > 4 && rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	int nugget3 = rmCreateObjectDef("nugget hard");
	rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmAddObjectDefToClass(nugget3, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget3, 0.05);
	rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nugget3, avoidResource);
	rmAddObjectDefConstraint(nugget3, avoidNuggetFar);
	rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget3, mediumPlayerConstraint);
	rmAddObjectDefConstraint(nugget3, circleConstraint);
	if (cNumberNonGaiaPlayers > 2)
		rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int nugget2 = rmCreateObjectDef("nugget medium");
	rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmAddObjectDefToClass(nugget2, rmClassID("classNugget"));
	rmSetObjectDefMinDistance(nugget2, 0.0);
	rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nugget2, avoidResource);
	rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
	rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget2, mediumPlayerConstraint);
	rmAddObjectDefConstraint(nugget2, circleConstraint);
	rmSetObjectDefMinDistance(nugget2, 80.0);
	rmSetObjectDefMaxDistance(nugget2, 120.0);
	rmPlaceObjectDefPerPlayer(nugget2, false, cNumberNonGaiaPlayers*4);

	int nugget1 = rmCreateObjectDef("nugget easy");
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefToClass(nugget1, rmClassID("classNugget"));
	rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
	rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
	rmAddObjectDefConstraint(nugget1, avoidResource);
	rmAddObjectDefConstraint(nugget1, avoidNuggetFar);
	rmAddObjectDefConstraint(nugget1, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(nugget1, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nugget1, mediumPlayerConstraint);
	rmAddObjectDefConstraint(nugget1, circleConstraint);
	rmSetObjectDefMinDistance(nugget1, 40.0);
	rmSetObjectDefMaxDistance(nugget1, 60.0);
	rmPlaceObjectDefPerPlayer(nugget1, false, cNumberNonGaiaPlayers*3);

	/*
	
	int nuggetID = 0;
	for(i=0; <cNumberNonGaiaPlayers*5)
	{
		nuggetID= rmCreateObjectDef("nugget "+i); 
		rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetID, 0.0);
		rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.40));
		rmAddObjectDefToClass(nuggetID, rmClassID("classNugget"));
		rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
		rmAddObjectDefConstraint(nuggetID, shortAvoidImportantItem);
		rmAddObjectDefConstraint(nuggetID, avoidResource);
		rmAddObjectDefConstraint(nuggetID, avoidNuggetFar);
		rmAddObjectDefConstraint(nuggetID, shortAvoidTradeRoute);
		rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSockets);
		rmAddObjectDefConstraint(nuggetID, mediumPlayerConstraint);
		rmAddObjectDefConstraint(nuggetID, insideCircleConstraint);
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5);
	}
*/

	// check for KOTH game mode
	if (rmGetIsKOTH())
	{

		int randLoc = rmRandInt(1, 3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.075;

		//~ if(randLoc == 1 || cNumberTeams > 2)
		//~ yLoc = .5;

		//~ else if(randLoc == 2)
		//~ yLoc = .8;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = " + xLoc);
		rmEchoInfo("YLOC = " + yLoc);
	}

	int avoidEagles = rmCreateTypeDistanceConstraint("avoids Eagles", "PropEaglesRocks", 40.0);
	int avoidVultures = rmCreateTypeDistanceConstraint("avoids Vultures", "PropVulturePerching", 40.0);

	int randomEagleTreeID = rmCreateObjectDef("random eagle rock");
	//rmAddObjectDefItem(randomEagleTreeID, "PropEaglesRocks", 1, 3.0);
	rmAddObjectDefItem(randomEagleTreeID, "UnderbrushPampas", rmRandInt(4, 6), 3.0);
	rmSetObjectDefMinDistance(randomEagleTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomEagleTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomEagleTreeID, avoidAll);
	rmAddObjectDefConstraint(randomEagleTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomEagleTreeID, playerConstraint);
	rmAddObjectDefConstraint(randomEagleTreeID, avoidEagles);
	rmAddObjectDefConstraint(randomEagleTreeID, avoidTradeRoute);

	int randomVultureTreeID = rmCreateObjectDef("random vulture tree");
	rmAddObjectDefItem(randomVultureTreeID, "PropVulturePerching", 1, 3.0);
	rmAddObjectDefItem(randomVultureTreeID, "UnderbrushPampas", rmRandInt(4, 6), 3.0);
	rmSetObjectDefMinDistance(randomVultureTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomVultureTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomVultureTreeID, avoidAll);
	rmAddObjectDefConstraint(randomVultureTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomVultureTreeID, playerConstraint);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidEagles);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidVultures);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTradeRoute);

	int herdableID = rmCreateObjectDef("llama");
	rmAddObjectDefItem(herdableID, "llama", 1, 4.0);
	rmSetObjectDefMinDistance(herdableID, 0.0);
	rmSetObjectDefMaxDistance(herdableID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(herdableID, avoidLlama);
	rmAddObjectDefConstraint(herdableID, avoidAll);
	rmAddObjectDefConstraint(herdableID, playerConstraint);
	rmAddObjectDefConstraint(herdableID, avoidImpassableLand);
	rmAddObjectDefConstraint(herdableID, avoidTradeRoute);
	rmPlaceObjectDefAtLoc(herdableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers * 3);

	rmPlaceObjectDefAtLoc(randomEagleTreeID, 0, 0.5, 0.5, 2 * cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(randomVultureTreeID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	//Added by Paul
	//int randomWaterFlowingID=rmCreateObjectDef("random flowing in water");
	//rmAddObjectDefItem(randomWaterFlowingID, "RiverFlow", 1, 0);
	//rmSetObjectDefMinDistance(randomWaterFlowingID, 0.0);
	//rmSetObjectDefMaxDistance(randomWaterFlowingID, rmXFractionToMeters(0.5));
	//rmPlaceObjectDefAtLoc(randomWaterFlowingID, 0, 0.5, 0.5, 40*cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("", 0.99);
}
}
