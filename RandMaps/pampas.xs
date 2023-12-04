// Pampas - needs to find a home as one of the overmap RM's.  Using pampas for now.
// October 2003
// Nov 06 - YP update
// May 2020: ...still using Pampas, perhaps we will find a home soon. Anyway, this is a balance update for DE by Rikikipu
// updated the natives and trade route over river shallows, September 2021, vividlyplain
// touched up for standard map pool, September 2022 by vividlyplain

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
	int seasonPicker = rmRandInt(1,4);	// 1 = rainy
//	seasonPicker = 1;	// for testing

	// Strings
	string riverType = "Pampas River RM";	
    string paintMix1 = "";
    string paintMix2 = "";
    string paintMix3 = "";
    string forestMix = "";
    string initLand = "grass";
    string shineAlight = "";
	string toiletPaper = "dirt_trail";
	string forTesting = "testmix";	 
    string treasureSet = "pampas";
    string food1 = "rhea";
    string food2 = "deer";
    string cattleType = "Llama";
    string treeType1 = "TreePampas";
    string brushType1 = "UnderbrushTexasGrass";
    string brushType2 = "UnderbrushPampas";
    string brushType3 = "TreeGreatPlainsGrass";
    string riverBrushType1 = "RiverShallowsPam";
    string riverBrushType2 = "RiverRocksSmall";
	if (seasonPicker > 1)
	{

    	paintMix1 = "pampas_dirt";
    	paintMix2 = "pampas_grass";
    	paintMix3 = "pampas_grassy";
    	forestMix = "pampas_forest_dirt";
    	shineAlight = "Pampas_Skirmish";
	}
	else
	{
    	paintMix1 = "pampas_grassy";
    	paintMix2 = "pampas_dirt";
    	paintMix3 = "pampas_grass";
    	forestMix = "pampas_forest";
    	shineAlight = "rm_minasGerais";
	}
	string natType1 = "Mapuche";
	string natGrpName1 = "native mapuche village ";

	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);

	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ____________________ General ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	int riverPlacement = -1;
	if (TeamNum == 2 && teamZeroCount == teamOneCount && PlayerNum > 2) // 1v1 or weird spawns won't generate parallel river version
		riverPlacement = rmRandInt(0, 1);
	else
		riverPlacement = 0;
	if (PlayerNum > 6 && TeamNum == 2 && teamZeroCount == teamOneCount)
		riverPlacement = 1;
//		riverPlacement = 1;	// for testing

	// Picks the map size
	int playerTiles = 7500;
	if (teamZeroCount != teamOneCount || cNumberTeams > 2)
		playerTiles=10000;
	else
	{
		if (cNumberNonGaiaPlayers > 2)
			playerTiles = 7000;
		if (cNumberNonGaiaPlayers > 4)
			playerTiles = 6500;
		if (cNumberNonGaiaPlayers > 6)
			playerTiles = 6000;
	}

	int size = 1.7 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	int longSide = 1.4 * size; // 'Longside' is used to make the map rectangular
	rmEchoInfo("Map size=" + size + "m x " + longSide + "m");
	rmSetMapSize(longSide, size);

	// Make the corners
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(0.0);
	rmSetMapElevationParameters(cElevTurbulence, 0.5, 0.5, 0.5, 2.0); // type, frequency, octaves, persistence, variation

	// Picks default terrain and water
//	rmSetBaseTerrainMix(paintMix1); 
	rmTerrainInitialize(initLand, 0.00); 
	rmSetMapType(treasureSet);		
    rmSetLightingSet(shineAlight);
	if (seasonPicker == 1)
		rmSetGlobalRain(0.75);
	else
		rmSetWindMagnitude(2.0);

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	int classNative=rmDefineClass("natives");
	rmDefineClass("importantItem");
	rmDefineClass("classCliff");
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("center");
	rmDefineClass("tradeIslands");
    rmDefineClass("socketClass");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPatch4 = rmDefineClass("patch4");
	int classPatch5 = rmDefineClass("patch5");
	int classCliff = rmDefineClass("Cliffs");
	int classGrass = rmDefineClass("grass");
	int classPond = rmDefineClass("pond");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.10), rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.05), rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int stayNW = rmCreatePieConstraint("Stay NW", 0.50, 0.50,rmXFractionToMeters(0.05), rmXFractionToMeters(0.70), rmDegreesToRadians(270),rmDegreesToRadians(090));
	int staySE = rmCreatePieConstraint("Stay SE", 0.50, 0.50,rmXFractionToMeters(0.05), rmXFractionToMeters(0.70), rmDegreesToRadians(090),rmDegreesToRadians(270));
	int stayE = rmCreatePieConstraint("Stay E", 0.50, 0.50,rmXFractionToMeters(0.05), rmXFractionToMeters(0.70), rmDegreesToRadians(100),rmDegreesToRadians(170));
	int stayW = rmCreatePieConstraint("Stay W", 0.50, 0.50,rmXFractionToMeters(0.05), rmXFractionToMeters(0.70), rmDegreesToRadians(280),rmDegreesToRadians(350));
		
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 20.0);
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 24.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 30.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 8.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidCattle = rmCreateTypeDistanceConstraint("avoid cattle", cattleType, 40);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 40.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 20.0);
	int avoidHunt2Med = rmCreateTypeDistanceConstraint("avoid hunt2 med", food2, 30.0);
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 50.0);
	int avoidHunt2VeryFar = rmCreateTypeDistanceConstraint("avoid hunt2 very far", food2, 65.0);
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 60.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 44.0);
	int avoidHunt1Med = rmCreateTypeDistanceConstraint("avoid hunt1 med", food1, 35.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 25.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 15.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 40+2*PlayerNum);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 76.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 40.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 70.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 40.0); 
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 50.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 30.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 20.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 2.0);

	// Avoid impassable land
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 50.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 12.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 20.0);
	int avoidPatch4 = rmCreateClassDistanceConstraint("avoid patch4", rmClassID("patch4"), 20.0);
	int avoidPatch5 = rmCreateClassDistanceConstraint("avoid patch5", rmClassID("patch5"), 12.0);
	int avoidEmbellishmentShort = rmCreateClassDistanceConstraint("grass avoid grass short", rmClassID("grass"), 4.0);
	int avoidEmbellishment = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 8.0);
	int avoidEmbellishmentFar = rmCreateClassDistanceConstraint("grass avoid grass far", rmClassID("grass"), 16.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidPlayer=rmCreateClassDistanceConstraint("avoid player", classIsland, 24.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 12.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 16.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 24.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 6.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 12.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", rmClassID("natives"), 4.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("stuff avoids natives min", rmClassID("natives"), 2.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 15.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 10.0);
	int stayNearWaterFar = rmCreateTerrainMaxDistanceConstraint("stay near water far ", "land", false, 20.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPondMin=rmCreateClassDistanceConstraint("avoid pond min", classPond, 2.0);
	int avoidPond=rmCreateClassDistanceConstraint("avoid pond", classPond, 8.0);
	int avoidPondFar=rmCreateClassDistanceConstraint("avoid pond far", classPond, 16+2*PlayerNum);
	int avoidPondShort=rmCreateClassDistanceConstraint("avoid pond short", classPond, 4.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 12.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 2.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 6.0);
    int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 4.0);
    int treeWaterFar = rmCreateTerrainDistanceConstraint("trees avoid river far", "Land", false, 8.0);

	// ____________________ Player Placement ____________________
	if (cNumberTeams <= 2) // 1v1 and TEAM
	{
		if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
		{
			float OneVOnePlacement=rmRandFloat(0.0, 0.9);
			if (OneVOnePlacement < 0.5)
			{
				rmPlacePlayer(1, 0.20, 0.25);
				rmPlacePlayer(2, 0.80, 0.75);
			}
			else
			{
				rmPlacePlayer(2, 0.20, 0.25);
				rmPlacePlayer(1, 0.80, 0.75);
			}
		}
		else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
		{
			if (teamZeroCount == 2) // 2v2
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.20, 0.10, 0.20, 0.35, 0.05, 0.2);
				rmSetTeamSpacingModifier(0.50);

				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.80, 0.90, 0.80, 0.65, 0.05, 0.2);
				rmSetTeamSpacingModifier(0.50);
			}
			else if (teamZeroCount == 3) // 3v3
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.20, 0.10, 0.20, 0.60, 0.05, 0.2);
				rmSetTeamSpacingModifier(0.50);

				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.80, 0.90, 0.80, 0.40, 0.05, 0.2);
				rmSetTeamSpacingModifier(0.50);
			}
			else // 4v4
			{
				rmSetPlacementTeam(0);
				if (riverPlacement == 0)
					rmPlacePlayersLine(0.20, 0.10, 0.20, 0.80, 0.05, 0.2);
				else
					rmPlacePlayersLine(0.20, 0.10, 0.20, 0.90, 0.05, 0.2);
				rmSetTeamSpacingModifier(0.50);

				rmSetPlacementTeam(1);
				if (riverPlacement == 0)
					rmPlacePlayersLine(0.80, 0.90, 0.80, 0.20, 0.05, 0.2);
				else
					rmPlacePlayersLine(0.80, 0.90, 0.80, 0.10, 0.05, 0.2);
				rmSetTeamSpacingModifier(0.50);
			}
		}
		else 
		{
			rmSetPlacementTeam(0);
			if (teamZeroCount < 4)
				rmPlacePlayersLine(0.20, 0.10, 0.20, 0.60, 0.05, 0.2);
			else
				rmPlacePlayersLine(0.20, 0.10, 0.20, 0.90, 0.05, 0.2);
			rmSetTeamSpacingModifier(0.50);

			rmSetPlacementTeam(1);
			if (teamOneCount < 4)
				rmPlacePlayersLine(0.80, 0.90, 0.80, 0.40, 0.05, 0.2);
			else
				rmPlacePlayersLine(0.80, 0.90, 0.80, 0.10, 0.05, 0.2);
			rmSetTeamSpacingModifier(0.50);
		}
	}
	else  //FFA
	{	
        rmSetTeamSpacingModifier(0.7);
        rmPlacePlayersSquare(0.38, 0.0, 0.0);
	}

	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	int continentID = rmCreateArea("continent");
	rmSetAreaLocation(continentID, 0.5, 0.5);
	rmSetAreaWarnFailure(continentID, false);
	rmSetAreaSize(continentID, 0.99);
	rmSetAreaCoherence(continentID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(continentID, false);
	rmSetAreaMix(continentID, paintMix1); 
	rmSetAreaElevationType(continentID, cElevTurbulence);
	rmSetAreaElevationVariation(continentID, 5.0);
	rmSetAreaElevationMinFrequency(continentID, 0.04);
	rmSetAreaElevationOctaves(continentID, 3);
	rmSetAreaElevationPersistence(continentID, 0.4);      
	rmBuildArea(continentID); 
	
	// Player Areas
	for (i=1; < numPlayer)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID, rmAreaTilesToFraction(222));
		rmSetAreaLocPlayer(playerareaID, i);
		rmAddAreaToClass(playerareaID, classPlayer);
		rmAddAreaToClass(playerareaID, classIsland);
		rmSetAreaCoherence(playerareaID, 0.69);
		if (TeamNum == 2 && teamOneCount == teamZeroCount)
			rmSetAreaMix(playerareaID, paintMix3);
//		rmSetAreaBaseHeight(playerareaID, 2.0); 
		rmBuildArea(playerareaID);
	}
	
	// ____________________ Trade Routes ____________________
	int tradeRouteID = rmCreateTradeRoute();

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
    rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID, true);
    rmSetObjectDefMinDistance(socketID, 2.0);
    rmSetObjectDefMaxDistance(socketID, 8.0);      

	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	if (riverPlacement == 0)
	{
		if (rmRandFloat(0,1) <= 0.50)
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.65);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.65);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.50);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.35);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.35);
		}
		else
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.35);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.35);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.50);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 0.65);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.65);
		}
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.50);
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.95, 0.50, rmRandInt(6,9), rmRandInt(8,11)); 
	}

    rmBuildTradeRoute(tradeRouteID, toiletPaper);

	// Rivers
	int riverMin = -1;
	int riverMax = -1;
	if (PlayerNum <= 4)
	{
		riverMin = 5+rmRandInt(0,1);
		riverMax = rmRandInt(5,6)+PlayerNum/2;
	}
	else if (PlayerNum == 6)
	{
		riverMin = 4+PlayerNum/3;
		riverMax = rmRandInt(4,5)+PlayerNum/3;
	}
	else
	{
		riverMin = 4+PlayerNum/4;
		riverMax = rmRandInt(4,5)+PlayerNum/4;
	}

	int coloradoRiverID = rmRiverCreate(-1, riverType, 8, 4, riverMin, riverMax);
	if (riverPlacement == 0)
	{
		rmRiverSetConnections(coloradoRiverID, 0.00, 0.35, 1.00, 0.35);
	}
	else
	{
		rmRiverSetConnections(coloradoRiverID, 0.00, 0.55, 1.00, 0.55);
	}
	rmRiverSetShallowRadius(coloradoRiverID, rmRandInt(8,11)+PlayerNum);
	rmRiverAddShallow(coloradoRiverID, 0.20);
	rmRiverSetShallowRadius(coloradoRiverID, rmRandInt(8,11)+PlayerNum);
	rmRiverAddShallow(coloradoRiverID, 0.45);
	rmRiverAddShallow(coloradoRiverID, 0.50);
	rmRiverAddShallow(coloradoRiverID, 0.55);
	rmRiverSetShallowRadius(coloradoRiverID, rmRandInt(8,11)+PlayerNum);
	rmRiverAddShallow(coloradoRiverID, 0.80);
	rmRiverSetBankNoiseParams(coloradoRiverID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
	rmRiverBuild(coloradoRiverID);	

	int coloradoRiver2ID = rmRiverCreate(-1, riverType, 20, 10, riverMin, riverMax);
	rmRiverSetConnections(coloradoRiver2ID, 0.00, 0.15, 1.00, 0.15);
	rmRiverSetShallowRadius(coloradoRiver2ID, rmRandInt(8,11)+PlayerNum);
	rmRiverAddShallow(coloradoRiver2ID, 0.20);
	rmRiverSetShallowRadius(coloradoRiver2ID, rmRandInt(8,11)+PlayerNum);
	rmRiverAddShallow(coloradoRiver2ID, 0.45);
	rmRiverAddShallow(coloradoRiver2ID, 0.50);
	rmRiverAddShallow(coloradoRiver2ID, 0.55);
	rmRiverSetShallowRadius(coloradoRiver2ID, rmRandInt(8,11)+PlayerNum);
	rmRiverAddShallow(coloradoRiver2ID, 0.80);
	rmRiverSetBankNoiseParams(coloradoRiver2ID, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
	if (riverPlacement == 1)
		rmRiverBuild(coloradoRiver2ID);	

    // Shallows Décor
	int shoreGrassStayWater = rmCreateTerrainMaxDistanceConstraint("shore grass stays near the water", "Land", false, 0.0);
    int avoidGrassForest=rmCreateClassDistanceConstraint("avoid grass tiny", classGrass, 2.0);
	int grassNumber = 24*PlayerNum;

	int riverDecorID=rmCreateObjectDef("decorate the shallows");
	rmAddObjectDefItem(riverDecorID, riverBrushType1, 1, 3);
//	rmAddObjectDefItem(riverDecorID, riverBrushType2, 1, 3);
	rmAddObjectDefItem(riverDecorID, brushType2, 1, 3);
	rmAddObjectDefToClass(riverDecorID, classGrass); 
	rmSetObjectDefMinDistance(riverDecorID, 0);
	rmSetObjectDefMaxDistance(riverDecorID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(riverDecorID, avoidGrassForest);
	rmAddObjectDefConstraint(riverDecorID, shoreGrassStayWater);
//	rmPlaceObjectDefAtLoc(riverDecorID, 0, 0.5, 0.5, grassNumber);

	// place tr sockets
    vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.01);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	
	socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.30);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	
	socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.70);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	
	socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.99);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	// ____________________ Natives ____________________
	//Choose Natives
    int subCiv0 = -1;
    subCiv0 = rmGetCivID(natType1);
    rmSetSubCiv(0, natType1);
	
	float xNatLocA = 0.50;
	float yNatLocA = 0.15;
	float xNatLocB = 0.50;
	float yNatLocB = 0.85;
	if (riverPlacement == 1)
	{
		xNatLocA = 0.40;
		yNatLocA = 0.60;
		xNatLocB = 0.60;
		yNatLocB = 0.40;	
	}

	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	
	nativeID0 = rmCreateGrouping("native site 1", natGrpName1+whichVillage1);
	nativeID1 = rmCreateGrouping("native site 2", natGrpName1+whichVillage2);

	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));

	// place natives
	rmPlaceGroupingAtLoc(nativeID0, 0, xNatLocA, yNatLocA);
	rmPlaceGroupingAtLoc(nativeID1, 0, xNatLocB, yNatLocB);

	// nat islands
	int natIsle1ID=rmCreateArea("Nat 1 Island");
	rmSetAreaSize(natIsle1ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle1ID, xNatLocA, yNatLocA);
	rmSetAreaMix(natIsle1ID, paintMix3);
	rmAddAreaToClass(natIsle1ID, classIsland);
	rmSetAreaCoherence(natIsle1ID, 0.333);
	rmBuildArea(natIsle1ID); 

	int natIsle2ID=rmCreateArea("Nat 2 Island");
	rmSetAreaSize(natIsle2ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle2ID, xNatLocB, yNatLocB);
	rmSetAreaMix(natIsle2ID, paintMix3);
	rmAddAreaToClass(natIsle2ID, classIsland);
	rmSetAreaCoherence(natIsle2ID, 0.333);
	rmBuildArea(natIsle2ID); 

	// ____________________ Avoidance Islands ____________________
	int midLineID=rmCreateArea("Mid Line");
	rmSetAreaSize(midLineID, 0.15);
	rmSetAreaLocation(midLineID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(midLineID, 0.50, 0.01, 0.50, 0.99);
	rmAddAreaInfluenceSegment(midLineID, 0.01, 0.50, 0.99, 0.50);
//	rmSetAreaMix(midLineID, forTesting); 	
	rmSetAreaCoherence(midLineID, 1.00);
	rmBuildArea(midLineID); 
	
	int avoidMidLine = rmCreateAreaDistanceConstraint("avoid mid line ", midLineID, 8.0);
	int avoidMidLineMin = rmCreateAreaDistanceConstraint("avoid mid line min", midLineID, 0.5);
	int avoidMidLineFar = rmCreateAreaDistanceConstraint("avoid mid line far", midLineID, 16.0);
	int stayMidLine = rmCreateAreaMaxDistanceConstraint("stay mid line ", midLineID, 0.0);

	int midIslandID=rmCreateArea("Mid Island");
	rmSetAreaSize(midIslandID, 0.40+.01*PlayerNum);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(midIslandID, 0.30, 0.10, 0.30, 0.90);
	rmAddAreaInfluenceSegment(midIslandID, 0.70, 0.10, 0.70, 0.90);
//	rmSetAreaMix(midIslandID, forTesting); 	
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.10);
	rmSetAreaLocation(midSmIslandID, 0.5, 0.5);
//	rmSetAreaMix(midSmIslandID, "great plains drygrass"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 1.00);
//	rmAddAreaConstraint(midSmIslandID, avoidWaterShort);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true)
	{
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.0;

		//King's "Island"
		int kingislandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingislandID, rmAreaTilesToFraction(555));
		rmSetAreaLocation(kingislandID, xLoc, yLoc);
		rmSetAreaMix(kingislandID, paintMix1);
		rmSetAreaReveal(kingislandID, 01);
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaBaseHeight(kingislandID, 1.0);
		rmSetAreaCoherence(kingislandID, 1.0);
		rmBuildArea(kingislandID); 

		// Place King's Hill
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	rmSetStatusText("",0.40);

	// Embellishments
	for (i=0; < 5*PlayerNum)
	{
		int patchID = rmCreateArea("first patch"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, true);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(33));
		rmSetAreaMix(patchID, paintMix3);	
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 3);
		rmSetAreaMinBlobDistance(patchID, 3.0);
		rmSetAreaMaxBlobDistance(patchID, 4.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidImpassableLandMin);
		rmAddAreaConstraint(patchID, avoidIslandMin);
		rmAddAreaConstraint(patchID, avoidNatives);
		rmBuildArea(patchID); 
	}

	int grasscount = 10*PlayerNum;

	for (i=0; < grasscount)
	{
		int propGrassID = rmCreateObjectDef("grass props"+i);
		rmAddObjectDefItem(propGrassID, brushType1, rmRandInt(0,4), 6.0);
		rmAddObjectDefItem(propGrassID, brushType2, rmRandInt(0,2), 6.0);
		rmAddObjectDefItem(propGrassID, brushType3, rmRandInt(0,2), 6.0);
		if (rmRandFloat(0,1) <= 0.02)
			rmAddObjectDefItem(propGrassID, "PropVulturePerching", rmRandInt(0,1), 6.0);
		rmSetObjectDefMinDistance(propGrassID, 50);
		rmSetObjectDefMaxDistance(propGrassID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(propGrassID, rmClassID("grass"));
		if (i < grasscount/2)
			rmAddObjectDefConstraint(propGrassID, staySE);
		else
			rmAddObjectDefConstraint(propGrassID, stayNW);
		rmAddObjectDefConstraint(propGrassID, avoidPond);
		rmAddObjectDefConstraint(propGrassID, avoidStartingResources);
		rmAddObjectDefConstraint(propGrassID, avoidEmbellishmentFar);
		rmPlaceObjectDefAtLoc(propGrassID, 0, 0.50, 0.50);
	}

	// Text
	rmSetStatusText("",0.50);

	// ____________________ Starting Resources ____________________
	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	if (rmGetNomadStart())
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	else
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	rmAddObjectDefToClass(TCID, classStartingResource);
	rmSetObjectDefMinDistance(TCID, 0.0);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmSetObjectDefMaxDistance(TCID, 0.0);
	else
	{
		rmSetObjectDefMaxDistance(TCID, 30.0);
		rmAddObjectDefConstraint(TCID, treeWaterFar);
		rmAddObjectDefConstraint(TCID, avoidImpassableLand);
		rmAddObjectDefConstraint(TCID, avoidTradeRoute);
		rmAddObjectDefConstraint(TCID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(TCID, avoidEdgeMore);
		rmAddObjectDefConstraint(TCID, avoidNatives);
	}

	// Starting mines
	int playerGoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerGoldID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 12.0);
	rmSetObjectDefMaxDistance(playerGoldID, 12.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerGoldID, stayMidIsland);
	rmAddObjectDefConstraint(playerGoldID, avoidNativesMin);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 32.0);
	rmSetObjectDefMaxDistance(playerGold2ID, 32.0);
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, treeWater);
	rmAddObjectDefConstraint(playerGold2ID, avoidEdge);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold2ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocket);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerGold2ID, avoidMidIsland);

	int playerGold3ID = rmCreateObjectDef("player 3rd mine");
	rmAddObjectDefItem(playerGold3ID, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(playerGold3ID, 50);
	rmSetObjectDefMaxDistance(playerGold3ID, 50+PlayerNum);
	rmAddObjectDefToClass(playerGold3ID, classStartingResource);
	rmAddObjectDefToClass(playerGold3ID, classGold);
	rmAddObjectDefConstraint(playerGold3ID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(playerGold3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold3ID, avoidEdge);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerGold3ID, stayMidIsland);
	rmAddObjectDefConstraint(playerGold3ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerGold3ID, treeWater);
	rmAddObjectDefConstraint(playerGold3ID, avoidIslandMin);
	rmAddObjectDefConstraint(playerGold3ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerGold3ID, avoidMidSmIslandMin);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType1, 2, 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 15);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerTreeID, avoidNativesMin);

	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, brushType1, 4, 8.0);
	rmAddObjectDefItem(playerTree2ID, treeType1, 13, 8.0);
    rmSetObjectDefMinDistance(playerTree2ID, 33);
    rmSetObjectDefMaxDistance(playerTree2ID, 40);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerTree2ID, treeWaterFar);
	rmAddObjectDefConstraint(playerTree2ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidEdge);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerTree2ID, avoidMidIslandFar);

	// Starting berries
	int playerBerryID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerryID, "berrybush", 4, 3.0);
	rmSetObjectDefMinDistance(playerBerryID, 15.0);
	rmSetObjectDefMaxDistance(playerBerryID, 15.0);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);
	rmAddObjectDefConstraint(playerBerryID, avoidNativesMin);
	rmAddObjectDefConstraint(playerBerryID, avoidStartingResourcesShort);
	
	// Starting herds
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, food1, 7, 4.0);
	rmSetObjectDefMinDistance(playerHerdID, 10);
	rmSetObjectDefMaxDistance(playerHerdID, 10);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesMin);
		
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(playerHerd2ID, food2, 8, 6.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 30);
    rmSetObjectDefMaxDistance(playerHerd2ID, 30);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIslandMin);
	else if (TeamNum == 2)
		rmAddObjectDefConstraint(playerHerd2ID, stayMidIsland);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHerd2ID, treeWater);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNativesShort);
		
	int playerHerd3ID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(playerHerd3ID, food2, 9, 6.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 50);
	rmSetObjectDefMaxDistance(playerHerd3ID, 50);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidEdge);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerHerd3ID, stayMidIsland);
	else if (TeamNum == 2)
		rmAddObjectDefConstraint(playerHerd3ID, avoidMidIslandFar);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerHerd3ID, treeWater);
	rmAddObjectDefConstraint(playerHerd3ID, avoidHunt2Med);
	rmAddObjectDefConstraint(playerHerd3ID, avoidMidSmIslandMin);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidIsland);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 24.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, treeWater);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketShort);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);
	int nuggetChance = -1;
	if (rmRandFloat(0,1) <= 0.50)
		nuggetChance = 2;
	
	//  Place Starting Objects/Resources
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		if (TeamNum > 2)
		{
			rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerGold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			if (nuggetChance == 2)
				rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerBerryID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			if(ypIsAsian(i) && rmGetNomadStart() == false)
				rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));			
		}
	}
	if (TeamNum == 2)
	{
		for(i=1; <numPlayer)
		{
			rmPlaceObjectDefAtLoc(playerGoldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerGold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerGold3ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerHerdID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			if (nuggetChance == 2)
				rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerBerryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			if(ypIsAsian(i) && rmGetNomadStart() == false)
				rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
	}
	// Text
	rmSetStatusText("",0.60);

	// ____________________ Mines ____________________	
	int minecount = 2*PlayerNum;

	for (i=0; < minecount)
    {
		int mapGoldID = rmCreateObjectDef("map mines"+i);
		rmAddObjectDefItem(mapGoldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(mapGoldID, rmXFractionToMeters(0.0));
		rmAddObjectDefToClass(mapGoldID, classGold);
		if (PlayerNum > 2)
		{
			rmSetObjectDefMaxDistance(mapGoldID, rmXFractionToMeters(0.45));
		}
		else
		{
			rmSetObjectDefMaxDistance(mapGoldID, rmXFractionToMeters(0.10));
			if (i == 0)
				rmPlaceObjectDefAtLoc(mapGoldID, 0, 0.85, 0.20, 1);
			else if (i == 1)
				rmPlaceObjectDefAtLoc(mapGoldID, 0, 0.55, 0.25, 1);
			else if (i == 2)
				rmPlaceObjectDefAtLoc(mapGoldID, 0, 0.15, 0.80, 1);
			else
				rmPlaceObjectDefAtLoc(mapGoldID, 0, 0.45, 0.75, 1);
		}
		if (i < minecount/2)
			rmAddObjectDefConstraint(mapGoldID, stayNW);
		else
			rmAddObjectDefConstraint(mapGoldID, staySE);
		rmAddObjectDefConstraint(mapGoldID, avoidTradeRouteSocketShort);
		if (PlayerNum > 2 && TeamNum == 2)
			rmAddObjectDefConstraint(mapGoldID, avoidMidLineMin);
		else if (TeamNum == 2)
			rmAddObjectDefConstraint(mapGoldID, avoidMidIslandMin);
		rmAddObjectDefConstraint(mapGoldID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(mapGoldID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(mapGoldID, avoidGoldFar);
		rmAddObjectDefConstraint(mapGoldID, avoidStartingResources);
		rmAddObjectDefConstraint(mapGoldID, avoidEdge);
		rmAddObjectDefConstraint(mapGoldID, avoidNatives);
		rmAddObjectDefConstraint(mapGoldID, treeWater);
		rmAddObjectDefConstraint(mapGoldID, avoidIslandMin);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(mapGoldID, 0, 0.50, 0.50, 1);
	}

	// Text
	rmSetStatusText("",0.70);

	// ____________________ Trees ____________________
	// Main Forest
	int mainforestcount = 12+5*PlayerNum;
	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, true);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(69));
        rmSetAreaCoherence(forestpatchID, 0.2);
		if (i < 0.5*mainforestcount)
			rmAddAreaConstraint(forestpatchID, stayNW);
		else
			rmAddAreaConstraint(forestpatchID, staySE);
		rmAddAreaConstraint(forestpatchID, avoidStartingResources);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestpatchID, avoidForestMed);
//		rmAddAreaConstraint(forestpatchID, avoidPlayer);
		rmAddAreaConstraint(forestpatchID, avoidGoldMin);
		rmAddAreaConstraint(forestpatchID, avoidNatives); 
		rmAddAreaConstraint(forestpatchID, avoidIslandMin); 
		rmAddAreaConstraint(forestpatchID, treeWater);        
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
		rmAddObjectDefItem(foresttreeID, brushType1, rmRandInt(2,3), 6.0);
		rmAddObjectDefItem(foresttreeID, brushType3, rmRandInt(1,3), 6.0);
		rmAddObjectDefItem(foresttreeID, treeType1, 3, 6.0);
		rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.05));
		rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(foresttreeID, classForest);
		rmAddObjectDefConstraint(foresttreeID, treeWater);
		rmAddObjectDefConstraint(foresttreeID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
		rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50, 3);
    }

	// Text
	rmSetStatusText("",0.80);

	// ____________________ Hunts ____________________	
	int herdcount = 3*PlayerNum;

	for (i=0; < herdcount)
	{
		int mapHerdID = rmCreateObjectDef("herd"+i);
		rmAddObjectDefItem(mapHerdID, food1, 9, 5.0);
		rmSetObjectDefMinDistance(mapHerdID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(mapHerdID, true);
		if (PlayerNum > 2)
			rmSetObjectDefMaxDistance(mapHerdID, rmXFractionToMeters(0.45));
		else
		{
			rmSetObjectDefMaxDistance(mapHerdID, rmXFractionToMeters(0.05));
			if (i == 0)
			{
				rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.85, 0.20, 1);
				rmAddObjectDefConstraint(mapHerdID, avoidMidIslandMin);
			}
			else if (i == 1)
				rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.68, 0.10, 1);
			else if (i == 2)
			{
				rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.47, 0.25, 1);
				rmAddObjectDefConstraint(mapHerdID, avoidMidIslandMin);
			}
			else if (i == 3)
			{
				rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.15, 0.80, 1);
				rmAddObjectDefConstraint(mapHerdID, avoidMidIslandMin);
			}
			else if (i == 4)
				rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.32, 0.90, 1);
			else
			{
				rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.53, 0.75, 1);
				rmAddObjectDefConstraint(mapHerdID, avoidMidIslandMin);
			}
		}
		if (i < herdcount/2)
		{
			rmAddObjectDefConstraint(mapHerdID, stayNW);
		}
		else
		{
			rmAddObjectDefConstraint(mapHerdID, staySE);
		}
		rmAddObjectDefConstraint(mapHerdID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(mapHerdID, avoidForestMin);
		rmAddObjectDefConstraint(mapHerdID, avoidGoldMin);
		rmAddObjectDefConstraint(mapHerdID, avoidStartingResources); 
		rmAddObjectDefConstraint(mapHerdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(mapHerdID, avoidIslandMin);
		rmAddObjectDefConstraint(mapHerdID, avoidEdge);
		if (TeamNum == 2)
			rmAddObjectDefConstraint(mapHerdID, avoidHunt1);
		else
			rmAddObjectDefConstraint(mapHerdID, avoidHunt1Far);
		if (PlayerNum > 2)
			rmAddObjectDefConstraint(mapHerdID, avoidHunt2);
		else
			rmAddObjectDefConstraint(mapHerdID, avoidHunt2Short);
		rmAddObjectDefConstraint(mapHerdID, avoidNatives);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(mapHerdID, 0, 0.50, 0.50);	
	}

	// Text
	rmSetStatusText("",0.90);

	// ____________________ Treasures ____________________
	int treasure1count = 4+2*PlayerNum;
	int treasure2count = 2*PlayerNum;
	int treasure3count = PlayerNum;

	// Treasures L3
	for (i=0; < treasure3count)
	{
		int nugget3ID = rmCreateObjectDef("nugget lvl3"+i); 
		rmAddObjectDefItem(nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nugget3ID, 0);
		rmSetObjectDefMaxDistance(nugget3ID, rmXFractionToMeters(0.25));
		if (PlayerNum > 4 && rmGetIsTreaty() == false)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(3,3);
		if (i < treasure3count/2)
			rmAddObjectDefConstraint(nugget3ID, stayNW);
		else
			rmAddObjectDefConstraint(nugget3ID, staySE);
		if (TeamNum == 2)
			rmAddObjectDefConstraint(nugget3ID, avoidMidLineFar);
		rmAddObjectDefConstraint(nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(nugget3ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(nugget3ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget3ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget3ID, avoidNatives); 
		rmAddObjectDefConstraint(nugget3ID, treeWater);
		rmAddObjectDefConstraint(nugget3ID, avoidIslandMin);
		rmAddObjectDefConstraint(nugget3ID, avoidPlayer);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(nugget3ID, 0, 0.50, 0.50);
	}

	// Treasures L2	
	for (i=0; < treasure2count)
	{
		int nugget2ID = rmCreateObjectDef("nugget lvl2"+i); 
		rmAddObjectDefItem(nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nugget2ID, 0);
		rmSetObjectDefMaxDistance(nugget2ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(nugget2ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(nugget2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget2ID, avoidNatives); 
		rmAddObjectDefConstraint(nugget2ID, treeWater);
		rmAddObjectDefConstraint(nugget2ID, avoidIslandMin);
		rmAddObjectDefConstraint(nugget2ID, avoidPlayer);
		if (i < treasure2count/2)
		{
			rmAddObjectDefConstraint(nugget2ID, avoidMidLineMin); 
			rmAddObjectDefConstraint(nugget2ID, stayNW); 
		}
		else
		{
			rmAddObjectDefConstraint(nugget2ID, avoidMidLineMin); 
			rmAddObjectDefConstraint(nugget2ID, staySE); 
		}
		rmPlaceObjectDefAtLoc(nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures L1
	for (i=0; < treasure1count)
	{
		int nugget1ID = rmCreateObjectDef("nugget lvl1"+i); 
		rmAddObjectDefItem(nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nugget1ID, 0);
		rmSetObjectDefMaxDistance(nugget1ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(nugget1ID, avoidPlayer);
		rmAddObjectDefConstraint(nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(nugget1ID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(nugget1ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget1ID, avoidNativesShort); 
		rmAddObjectDefConstraint(nugget1ID, treeWater);
		rmAddObjectDefConstraint(nugget1ID, avoidStartingResources);
		rmAddObjectDefConstraint(nugget1ID, avoidIslandMin);
		if (i < treasure1count/2)
		{
			rmAddObjectDefConstraint(nugget1ID, avoidMidLineMin); 
			rmAddObjectDefConstraint(nugget1ID, stayNW); 
		}
		else
		{
			rmAddObjectDefConstraint(nugget1ID, avoidMidLineMin); 
			rmAddObjectDefConstraint(nugget1ID, staySE); 
		}
		rmPlaceObjectDefAtLoc(nugget1ID, 0, 0.50, 0.50);
	}

	// Llama Party
	int llamacount = 2+2*PlayerNum;

	for (i=0; < llamacount)
	{
		int llamaID = rmCreateObjectDef("llama"+i); 
		rmAddObjectDefItem(llamaID, cattleType, 1, 0.0);
		rmSetObjectDefMinDistance(llamaID, 0);
		rmSetObjectDefMaxDistance(llamaID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(llamaID, avoidCattle);
		rmAddObjectDefConstraint(llamaID, avoidTownCenterFar);
		rmAddObjectDefConstraint(llamaID, avoidMidSmIslandMin);
		rmAddObjectDefConstraint(llamaID, avoidPlayer);
		rmAddObjectDefConstraint(llamaID, avoidNuggetMin);
		rmAddObjectDefConstraint(llamaID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(llamaID, avoidGoldMin);
		rmAddObjectDefConstraint(llamaID, avoidForestMin);	
		rmAddObjectDefConstraint(llamaID, avoidEdge); 
		rmAddObjectDefConstraint(llamaID, avoidNativesShort); 
		rmAddObjectDefConstraint(llamaID, treeWater);
		rmAddObjectDefConstraint(llamaID, avoidStartingResources);
		rmAddObjectDefConstraint(llamaID, avoidIslandMin);
		if (PlayerNum > 2)
		{
			if (i < llamacount/2)
			{
				rmAddObjectDefConstraint(llamaID, stayNW); 
			}
			else
			{
				rmAddObjectDefConstraint(llamaID, staySE); 
			}
		}
		else
		{
			if (i < llamacount/2)
			{
				rmAddObjectDefConstraint(llamaID, stayW); 
			}
			else
			{
				rmAddObjectDefConstraint(llamaID, stayE); 
			}
		}
		rmPlaceObjectDefAtLoc(llamaID, 0, 0.50, 0.50);
	}

	// Text
	rmSetStatusText("",1.00);
	
} // END