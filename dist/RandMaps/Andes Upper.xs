// NEW ANDES - river removed, player positions improved, resource balance improved, trade route position altered slightly modified by Rikikipu - September 2016
// Selected by Interjection, Incas minor natives kept by design for Treaty 40 gameplay - May 2020
// April 2021 edited by vividlyplain for DE, thanks, Floko, for the journey into the treaty universe. Updated May 2021.

	int TeamNum = cNumberTeams;
	int PlayerNum = cNumberNonGaiaPlayers;
	int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("", 0.01);

	//Chooses which natives appear on the map
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	int subCiv3 = -1;

	// All Inca all the time
	// now Quechua
	if (rmAllocateSubCivs(4) == true)
	{
		subCiv0 = rmGetCivID("Incas");
		if (subCiv0 >= 0)
			rmSetSubCiv(0, "Incas");

		subCiv1 = rmGetCivID("Incas");
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Incas");

		subCiv2 = rmGetCivID("Incas");
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Incas");

		subCiv3 = rmGetCivID("Incas");
		if (subCiv3 >= 0)
			rmSetSubCiv(3, "Incas");
	}

	// Picks the map size
	int playerTiles = 12705;
	if (cNumberNonGaiaPlayers < 3)
		int size = 2.2 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	else if (cNumberNonGaiaPlayers < 5)
		size = 2.15 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	else if (cNumberNonGaiaPlayers < 7)
		size = 2.1 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	else
		size = 2.0 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	rmEchoInfo("Map size=" + size + "m x " + size + "m");
	rmSetMapSize(size, size);

	// Picks a default water height
	rmSetSeaLevel(3.0); // height of river surface compared to surrounding land. River depth is in the river XML.
	rmSetWindMagnitude(2);

	// Picks default terrain and water

	rmSetBaseTerrainMix("andes_grass_a");
	rmTerrainInitialize("andes\ground10_and", 4);
	rmSetMapType("andes");
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetLightingSet("Andes_Skirmish");

	// Make the corners.
	rmSetWorldCircleConstraint(false);

	// Choose Mercs
	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("classMountain");
	rmDefineClass("classClearing");
	rmDefineClass("classGold");
	rmDefineClass("startingResource");

	// -------------Define constraints
	// These are used to have objects and areas avoid each other

	// Map edge constraints
	int coinEdgeConstraint = rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(7), rmZTilesToFraction(7), 1.0 - rmXTilesToFraction(7), 1.0 - rmZTilesToFraction(7), 0.01);
	int playerEdgeConstraint = rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(25), rmZTilesToFraction(25), 1.0 - rmXTilesToFraction(25), 1.0 - rmZTilesToFraction(25), 0.01);

	// Directional constraints
	int NWconstraint = rmCreateBoxConstraint("stay in NW portion", 0, 0.55, 0.7, 1);
	int SEconstraint = rmCreateBoxConstraint("stay in SE portion", 0, 0, 0.7, 0.45);
	int NEconstraint = rmCreateBoxConstraint("stay in NE portion", 0.65, 0.0, 1, 1);
	int extremeNEconstraint = rmCreateBoxConstraint("stay deep into NE portion", 0.6, 0.0, 1.0, 1.0);
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45),rmDegreesToRadians(0),rmDegreesToRadians(360));		
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(1.0), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.25), rmDegreesToRadians(0),rmDegreesToRadians(360));

	// Player constraints
	int playerConstraint = rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
	int longPlayerConstraint = rmCreateClassDistanceConstraint("stay far away from players", classPlayer, 50.0);
	int longerPlayerConstraint = rmCreateClassDistanceConstraint("stay farther away from players", classPlayer, 65.0);

	// Nature avoidance
	int avoidForestShort = rmCreateClassDistanceConstraint("forest avoids forest short", rmClassID("classForest"), 12.0);
	int avoidForest = rmCreateClassDistanceConstraint("forest avoids forest", rmClassID("classForest"), 24.0);
	int avoidForestFar = rmCreateClassDistanceConstraint("forest avoids forest far", rmClassID("classForest"), 40.0);
	int avoidForestMin = rmCreateClassDistanceConstraint("forest avoids forest min", rmClassID("classForest"), 4.0);
	int avoidLlama = rmCreateTypeDistanceConstraint("llama avoids llama", "Llama", 60.0);
	int avoidGuanaco = rmCreateTypeDistanceConstraint("guanaco avoids guanaco", "Guanaco", 30.0);
	int avoidGuanacoFar = rmCreateTypeDistanceConstraint("guanaco avoids guanaco far", "Guanaco", 45.0);
	int avoidGuanacoShort = rmCreateTypeDistanceConstraint("guanaco avoids guanaco short", "Guanaco", 25.0);
	int avoidGuanacoMin = rmCreateTypeDistanceConstraint("guanaco avoids guanaco min", "Guanaco", 4.0);
	int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "Mine", 30.0);
	int avoidCoinShort = rmCreateTypeDistanceConstraint("avoid coin short", "Mine", 30.0);
	int avoidCoinFar = 0;
	if (cNumberNonGaiaPlayers < 4)
		avoidCoinFar = rmCreateTypeDistanceConstraint("avoid coin far for less players", "Mine", 30.0);
	else
		avoidCoinFar = rmCreateTypeDistanceConstraint("avoid coin far", "Mine", 30.0);
	int avoidClearing = rmCreateClassDistanceConstraint("avoid clearings", rmClassID("classClearing"), 8.0);

	int avoidGold = rmCreateClassDistanceConstraint("avoid gold", rmClassID("classGold"), 30.0);
	int avoidGoldMin = rmCreateClassDistanceConstraint("avoid gold min", rmClassID("classGold"), 4.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint("avoid gold short", rmClassID("classGold"), 12.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint("avoid gold med", rmClassID("classGold"), 20.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint("avoid gold far", rmClassID("classGold"), 36.0);

	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 2.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidStartingResourcesMed = rmCreateClassDistanceConstraint("avoid starting resources med", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesFar = rmCreateClassDistanceConstraint("avoid starting resources far", rmClassID("startingResource"), 16.0);
	
	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidCliff = rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 8.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("stuff vs. cliff far", rmClassID("classCliff"), 16.0);
	int cliffAvoidCliff = rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

	// Unit avoidance
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center Short", "townCenter", 17.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
	int avoidTownCenterSupaFar = rmCreateTypeDistanceConstraint("avoid Town Center Supa Far", "townCenter", 25.0);
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
	int shortAvoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 10.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", rmClassID("natives"), 5.0);
	int avoidNugget = rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetVeryFar = rmCreateTypeDistanceConstraint("nugget avoid nugget very far", "AbstractNugget", 55.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget far", "AbstractNugget", 45.0);
	int avoidTradeRouteSockets = rmCreateTypeDistanceConstraint("avoid Trade Socket", "sockettraderoute", 8.0);
	int avoidTradeRouteSocketsMin = rmCreateTypeDistanceConstraint("avoid Trade Socket min", "sockettraderoute", 4.0);
	int avoidTradeRouteSocketsTC = rmCreateTypeDistanceConstraint("avoid Trade Socket from TC", "sockettraderoute", 25);
	int avoidIncaSocketsTC = rmCreateTypeDistanceConstraint("avoid Inca Socket from TC", "socketinca", 85);

	// Decoration avoidance
	int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 8.0);

	// Important object avoidance.
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 15.0);
	int avoidTradeRouteTC = rmCreateTradeRouteDistanceConstraint("TC avoid trade route", 20.0);
	int avoidKOTH = rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 15.0);

	// -------------Define objects
	// These objects are all defined so they can be placed later

	rmSetStatusText("", 0.10);
	int playerSide = rmRandInt(1, 2);
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	if (cNumberNonGaiaPlayers == 2)
	{
		if (rmRandInt(1, 2) < 2)
		{
			rmPlacePlayer(1, 0.4, 0.82);
			rmPlacePlayer(2, 0.4, 0.18);
		}
		else
		{
			rmPlacePlayer(2, 0.4, 0.82);
			rmPlacePlayer(1, 0.4, 0.18);
		}
	}
	else if (cNumberTeams==2 && teamOneCount == teamZeroCount)	// equal N of players per TEAM
	{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.2, 0.75, 0.52, 0.8, 0, 0);

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.2, 0.25, 0.52, 0.2, 0, 0);
	}
	else if (cNumberTeams==2 && teamOneCount != teamZeroCount) 	// unequal N of players per TEAM - used code from Mexico
	{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.95, 0.97); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.55, 0.65); //
	else
							rmSetPlacementSection(0.50, 0.70); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
	{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.85, 0.95); //
						else
							rmSetPlacementSection(0.80, 0.00); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.53, 0.55); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.85, 0.95); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.50, 0.70); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.80, 0.00); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.55, 0.65); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.85, 0.00); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.50, 0.65); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0);
				}
	}
	else	// ffa
	{
		rmSetPlacementSection(0.50, 0.00); //
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.38, 0.38, 0);
/*		rmPlacePlayer(1, 0.4, 0.82);
		rmPlacePlayer(2, 0.4, 0.18);
		rmPlacePlayer(3, 0.85, 0.5);
		rmPlacePlayer(4, 0.15, 0.5);
		rmPlacePlayer(5, 0.65, 0.3);
		rmPlacePlayer(6, 0.65, 0.7);
		rmPlacePlayer(7, 0.15, 0.25);
		rmPlacePlayer(8, 0.15, 0.75);*/ // old
	}

	// Build a north area
	int northIslandID = rmCreateArea("north island");
	rmSetAreaLocation(northIslandID, 0.5, 0.9);
	rmSetAreaWarnFailure(northIslandID, false);
	rmSetAreaSize(northIslandID, 0.5, 0.5);
	rmSetAreaCoherence(northIslandID, 0.5);

	rmSetAreaElevationType(northIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(northIslandID, 3.0);
	rmSetAreaBaseHeight(northIslandID, 4.0);
	rmSetAreaElevationMinFrequency(northIslandID, 0.07);
	rmSetAreaElevationOctaves(northIslandID, 4);
	rmSetAreaElevationPersistence(northIslandID, 0.5);
	rmSetAreaElevationNoiseBias(northIslandID, 1);

	rmSetAreaObeyWorldCircleConstraint(northIslandID, false);
	rmSetAreaMix(northIslandID, "andes_grass_b");

	// Text
	rmSetStatusText("", 0.20);

	// Build a south area
	int southIslandID = rmCreateArea("south island");
	rmSetAreaLocation(southIslandID, 0.5, 0.1);
	rmSetAreaWarnFailure(southIslandID, false);
	rmSetAreaSize(southIslandID, 0.5, 0.5);
	rmSetAreaCoherence(southIslandID, 0.5);

	rmSetAreaElevationType(southIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(southIslandID, 5.0);
	rmSetAreaBaseHeight(southIslandID, 4.0);
	rmSetAreaElevationMinFrequency(southIslandID, 0.07);
	rmSetAreaElevationOctaves(southIslandID, 4);
	rmSetAreaElevationPersistence(southIslandID, 0.5);
	rmSetAreaElevationNoiseBias(southIslandID, 1);
	rmAddAreaTerrainLayer(southIslandID, "andes\ground10_and", 0, 5);
	rmSetAreaObeyWorldCircleConstraint(southIslandID, false);
	rmSetAreaMix(southIslandID, "andes_grass_a");

	rmBuildAllAreas();

	// Avoidance Zones
	int mountainID = rmCreateArea("mountain zone");
	rmSetAreaSize(mountainID, 0.30);
	rmSetAreaLocation(mountainID, 1.00, 0.50);
	rmAddAreaInfluenceSegment(mountainID, 1.00, 0.70, 1.00, 0.30);
	rmAddAreaInfluenceSegment(mountainID, 0.90, 0.80, 0.90, 0.20);
	rmAddAreaInfluenceSegment(mountainID, 0.85, 0.90, 0.85, 0.10);
	rmAddAreaInfluenceSegment(mountainID, 0.85, 0.90, 0.75, 0.90);
	rmAddAreaInfluenceSegment(mountainID, 0.85, 0.10, 0.75, 0.10);
	rmAddAreaInfluenceSegment(mountainID, 0.80, 1.00, 0.80, 0.00);
//	rmAddAreaInfluenceSegment(mountainID, 0.65, 1.00, 0.65, 0.00);
	rmSetAreaWarnFailure(mountainID, false);
//	rmSetAreaMix(mountainID, "testmix");		// for testing
	rmSetAreaCoherence(mountainID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(mountainID, false);
	rmBuildArea(mountainID);	

	int avoidMountainZone = rmCreateAreaDistanceConstraint("avoid central zone ", mountainID, 20.0);
	int avoidMountainZoneMin = rmCreateAreaDistanceConstraint("avoid central zone min ", mountainID, 0.5);
	int avoidMountainZoneShort = rmCreateAreaDistanceConstraint("avoid central zone short ", mountainID, 12.0);
	int stayMountainZone = rmCreateAreaMaxDistanceConstraint("stay in central zone ", mountainID, 0.0);	

	int northZoneID = rmCreateArea("north zone");
	rmSetAreaSize(northZoneID, 0.25);
	rmSetAreaLocation(northZoneID, 0.45, 0.85);
	rmAddAreaInfluenceSegment(northZoneID, 0.60, 0.60, 0.00, 0.60);
	rmAddAreaInfluenceSegment(northZoneID, 0.60, 0.70, 0.00, 0.70);
	rmSetAreaWarnFailure(northZoneID, false);
//	rmSetAreaMix(northZoneID, "testmix");		// for testing
	rmSetAreaCoherence(northZoneID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(northZoneID, true);
	rmAddAreaConstraint(northZoneID, avoidTradeRoute);
	rmAddAreaConstraint(northZoneID, avoidMountainZoneMin);
	rmBuildArea(northZoneID);	

	int avoidNorthZone = rmCreateAreaDistanceConstraint("avoid north zone ", northZoneID, 8.0);
	int stayNorthZone = rmCreateAreaMaxDistanceConstraint("stay in north zone ", northZoneID, 0.0);	

	int southZoneID = rmCreateArea("south zone");
	rmSetAreaSize(southZoneID, 0.25);
	rmSetAreaLocation(southZoneID, 0.45, 0.15);
	rmAddAreaInfluenceSegment(southZoneID, 0.60, 0.40, 0.00, 0.40);
	rmAddAreaInfluenceSegment(southZoneID, 0.60, 0.30, 0.00, 0.30);
	rmSetAreaWarnFailure(southZoneID, false);
//	rmSetAreaMix(southZoneID, "rockies_grass");		// for testing
	rmSetAreaCoherence(southZoneID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(southZoneID, true);
	rmAddAreaConstraint(southZoneID, avoidTradeRoute);
	rmAddAreaConstraint(southZoneID, avoidMountainZoneMin);
	rmBuildArea(southZoneID);	

	int avoidSouthZone = rmCreateAreaDistanceConstraint("avoid south zone ", southZoneID, 8.0);
	int staySouthZone = rmCreateAreaMaxDistanceConstraint("stay in south zone ", southZoneID, 0.0);	

	int midIslandID=rmCreateArea("Mid Island");
	if (teamZeroCount != teamOneCount && PlayerNum > 4)
		rmSetAreaSize(midIslandID, 0.46);
	else if (PlayerNum == 2)
		rmSetAreaSize(midIslandID, 0.30);
	else
		{
		rmSetAreaSize(midIslandID, 0.25);
		rmAddAreaInfluenceSegment(midIslandID, 0.20, 0.35, 0.50, 0.30);
		rmAddAreaInfluenceSegment(midIslandID, 0.20, 0.65, 0.50, 0.70);
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
	rmSetAreaSize(midSmIslandID, 0.15);
	rmSetAreaLocation(midSmIslandID, 0.5, 0.5);
//	rmSetAreaMix(midSmIslandID, "great plains drygrass"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 0.75);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);
	
	// Text
	rmSetStatusText("", 0.30);

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
		rmSetAreaMinBlobs(id, 1);
		rmSetAreaMaxBlobs(id, 1);
		rmAddAreaConstraint(id, playerConstraint);
		rmAddAreaConstraint(id, playerEdgeConstraint);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaTerrainType(id, "carolina\marshflats");
		rmSetAreaWarnFailure(id, false);
	}

	// Build the areas.
	rmBuildAllAreas();

	// Text
	rmSetStatusText("", 0.40);

	// TRADE ROUTES
	// Trade route setup
	int tradeRoutePos = rmRandInt(1, 2);
	if (cNumberTeams == 2 && teamZeroCount != teamOneCount || rmGetIsTreaty()==true)
		tradeRoutePos = 2;

	if (cNumberTeams == 2) {
	if (cNumberNonGaiaPlayers >= 5)
	{
		tradeRoutePos = 2;
	}
		if (rmGetIsKOTH() == true)
	{
		tradeRoutePos = 1;
	}

	int socketID = rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);

	int tradeRoute1ID = rmCreateTradeRoute();

	if (tradeRoutePos == 1) // Trade Route in a V shape
	{
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.65);
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.42, 0.54);
		//rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.45, 0.54, 5, 8);
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.42, 0.46);
		//rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0, 0.35, 5, 8);
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.35);
	}
	else //Trade Route down the middle
	{
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0, 0.5);
		rmAddTradeRouteWaypoint(tradeRoute1ID, 0.5, 0.5);
		rmAddTradeRouteWaypoint(tradeRoute1ID, 1, 0.5);
		//rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 0.5, 0.5, 6, 8);
		//rmAddRandomTradeRouteWaypoints(tradeRoute1ID, 1, 0.5, 6, 8);
	}

	bool placedTradeRoute1 = rmBuildTradeRoute(tradeRoute1ID, "dirt_trail");
	if (placedTradeRoute1 == false)
		rmEchoError("Failed to place trade route one");

	// add the meeting sockets along the trade route.
	rmSetObjectDefTradeRouteID(socketID, tradeRoute1ID);
	float startRoute = 0.05;
	float midRoute = 0.4;
	float endRoute = 0.9;
	if (tradeRoutePos == 1)
	{
		startRoute = 0.07;
		midRoute = 0.5;
		endRoute = 0.93;
	}

	vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, startRoute);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, midRoute);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	socketLoc1 = rmGetTradeRouteWayPoint(tradeRoute1ID, endRoute);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	}

	// Text
	rmSetStatusText("", 0.45);

	// check for KOTH game mode
	if (rmGetIsKOTH())
	{
		ypKingsHillPlacer(0.7, 0.5, 0.00, avoidCliff);
	}

	// Text
	rmSetStatusText("", 0.50);

	if (subCiv0 == rmGetCivID("Incas"))
	{
		int IncaVillageAID = -1;
		IncaVillageAID = rmCreateGrouping("back inca village", "native inca village " + 4);
		rmSetGroupingMinDistance(IncaVillageAID, 0.0);
		rmSetGroupingMaxDistance(IncaVillageAID, 0.0);
		rmAddGroupingToClass(IncaVillageAID, rmClassID("natives"));
		rmAddGroupingToClass(IncaVillageAID, rmClassID("importantItem"));
		rmAddGroupingConstraint(IncaVillageAID, avoidTradeRoute);
		rmAddGroupingConstraint(IncaVillageAID, avoidNatives);
		rmPlaceGroupingAtLoc(IncaVillageAID, 0, 0.90, 0.70);
	}

	if (subCiv1 == rmGetCivID("Incas"))
	{
		int IncavillageBID = -1;
		IncavillageBID = rmCreateGrouping("left city", "native inca village " + 2);
		rmSetGroupingMinDistance(IncavillageBID, 0.0);
		rmSetGroupingMaxDistance(IncavillageBID, 0.0);
		rmAddGroupingToClass(IncavillageBID, rmClassID("natives"));
		rmAddGroupingToClass(IncavillageBID, rmClassID("importantItem"));
		rmAddGroupingConstraint(IncavillageBID, avoidTradeRoute);
		rmAddGroupingConstraint(IncavillageBID, avoidNatives);
		rmPlaceGroupingAtLoc(IncavillageBID, 0, 0.75, 0.85);
	}

	if (subCiv2 == rmGetCivID("Incas"))
	{
		int IncavillageCID = -1;
		IncavillageCID = rmCreateGrouping("right city", "native inca village " + 4);
		rmSetGroupingMinDistance(IncavillageCID, 0.0);
		rmSetGroupingMaxDistance(IncavillageCID, 0.0);
		rmAddGroupingToClass(IncavillageCID, rmClassID("natives"));
		rmAddGroupingToClass(IncavillageCID, rmClassID("importantItem"));
		rmAddGroupingConstraint(IncavillageCID, avoidTradeRoute);
		rmAddGroupingConstraint(IncavillageCID, avoidNatives);
		rmPlaceGroupingAtLoc(IncavillageCID, 0, 0.90, 0.30);
	}

	if (subCiv3 == rmGetCivID("Incas"))
	{
		int IncavillageDID = -1;
		IncavillageDID = rmCreateGrouping("front city", "native inca village " + 1);
		rmSetGroupingMinDistance(IncavillageDID, 0.0);
		rmSetGroupingMaxDistance(IncavillageDID, 0.0);
		rmAddGroupingToClass(IncavillageDID, rmClassID("natives"));
		rmAddGroupingToClass(IncavillageDID, rmClassID("importantItem"));
		rmAddGroupingConstraint(IncavillageDID, avoidTradeRoute);
		rmAddGroupingConstraint(IncavillageDID, avoidNatives);
		rmPlaceGroupingAtLoc(IncavillageDID, 0, 0.75, 0.15);
	}

	// Text
	rmSetStatusText("", 0.50);
	int failCount = -1;

	int numTries = cNumberNonGaiaPlayers + 2;

	// Fixing Cliffs by Rikikipu - edited by vividlyplain
	int cliffIDA1 = rmCreateArea("cliffa1");
	rmSetAreaSize(cliffIDA1, rmAreaTilesToFraction(150*cNumberNonGaiaPlayers), rmAreaTilesToFraction(150*cNumberNonGaiaPlayers));	// 0.01
	rmSetAreaLocation(cliffIDA1, 0.63, 1);
	rmAddAreaInfluenceSegment(cliffIDA1, 0.63, 1.0, 0.63, 0.85);
	rmSetAreaCliffType(cliffIDA1, "andes");
	rmAddAreaToClass(cliffIDA1, rmClassID("classCliff"));
	rmSetAreaCliffEdge(cliffIDA1, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffHeight(cliffIDA1, rmRandInt(4, 6), 1.0, 1.0);
	rmSetAreaCoherence(cliffIDA1, 0.5);
	rmSetAreaSmoothDistance(cliffIDA1, 10);
	rmAddAreaConstraint(cliffIDA1, avoidNativesShort);
	rmAddAreaConstraint(cliffIDA1, avoidTradeRouteSockets);
	rmAddAreaConstraint(cliffIDA1, avoidTradeRouteMin);
	rmBuildArea(cliffIDA1);

	int cliffIDA2 = rmCreateArea("cliffa2");
	rmSetAreaSize(cliffIDA2, rmAreaTilesToFraction(62.5*cNumberNonGaiaPlayers), rmAreaTilesToFraction(62.5*cNumberNonGaiaPlayers));		// 0.005
	rmSetAreaLocation(cliffIDA2, 0.65, 0.6);
	rmSetAreaCliffType(cliffIDA2, "andes");
	rmAddAreaToClass(cliffIDA2, rmClassID("classCliff"));
	rmSetAreaCliffEdge(cliffIDA2, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffHeight(cliffIDA2, rmRandInt(4, 6), 1.0, 1.0);
	rmSetAreaCoherence(cliffIDA2, 0.5);
	rmSetAreaSmoothDistance(cliffIDA2, 10);
	rmAddAreaConstraint(cliffIDA2, avoidNativesShort);
	rmAddAreaConstraint(cliffIDA2, avoidTradeRouteSockets);
	rmAddAreaConstraint(cliffIDA2, avoidTradeRouteMin);
	rmBuildArea(cliffIDA2);

	int cliffIDA3 = rmCreateArea("cliffa3");
	rmSetAreaSize(cliffIDA3, rmAreaTilesToFraction(200*cNumberNonGaiaPlayers), rmAreaTilesToFraction(200*cNumberNonGaiaPlayers));		// 0.015
	if (cNumberNonGaiaPlayers == 2) {
		rmSetAreaLocation(cliffIDA3, 1.0, 0.57);
		rmAddAreaInfluenceSegment(cliffIDA3, 1.0, 0.57, 0.85, 0.57);
		}
	else {
		rmSetAreaLocation(cliffIDA3, 1.0, 0.60);
		rmAddAreaInfluenceSegment(cliffIDA3, 1.0, 0.60, 0.85, 0.60);
		}
	rmSetAreaCliffType(cliffIDA3, "andes");
	rmAddAreaToClass(cliffIDA3, rmClassID("classCliff"));
	rmSetAreaCliffEdge(cliffIDA3, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffHeight(cliffIDA3, rmRandInt(4, 6), 1.0, 1.0);
	rmSetAreaCoherence(cliffIDA3, 0.75);
	rmSetAreaSmoothDistance(cliffIDA3, 10);
	rmAddAreaConstraint(cliffIDA3, avoidNativesShort);
	rmAddAreaConstraint(cliffIDA3, avoidTradeRouteSockets);
	rmAddAreaConstraint(cliffIDA3, avoidTradeRouteMin);
	rmBuildArea(cliffIDA3);

	int cliffIDB1 = rmCreateArea("cliffb1");
	rmSetAreaSize(cliffIDB1, rmAreaTilesToFraction(150*cNumberNonGaiaPlayers), rmAreaTilesToFraction(150*cNumberNonGaiaPlayers));	// 0.01
	rmSetAreaLocation(cliffIDB1, 0.63, 0.0);
	rmAddAreaInfluenceSegment(cliffIDB1, 0.63, 0.0, 0.63, 0.15);
	rmSetAreaCliffType(cliffIDB1, "andes");
	rmAddAreaToClass(cliffIDB1, rmClassID("classCliff"));
	rmSetAreaCliffEdge(cliffIDB1, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffHeight(cliffIDB1, rmRandInt(4, 6), 1.0, 1.0);
	rmSetAreaCoherence(cliffIDB1, 0.5);
	rmSetAreaSmoothDistance(cliffIDB1, 10);
	rmAddAreaConstraint(cliffIDB1, avoidNativesShort);
	rmAddAreaConstraint(cliffIDB1, avoidTradeRouteSockets);
	rmAddAreaConstraint(cliffIDB1, avoidTradeRouteMin);
	rmBuildArea(cliffIDB1);

	int cliffIDB2 = rmCreateArea("cliffb2");
	rmSetAreaSize(cliffIDB2, rmAreaTilesToFraction(62.5*cNumberNonGaiaPlayers), rmAreaTilesToFraction(62.5*cNumberNonGaiaPlayers));		// 0.005
	rmSetAreaLocation(cliffIDB2, 0.65, 0.4);
	rmSetAreaCliffType(cliffIDB2, "andes");
	rmAddAreaToClass(cliffIDB2, rmClassID("classCliff"));
	rmSetAreaCliffEdge(cliffIDB2, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffHeight(cliffIDB2, rmRandInt(4, 6), 1.0, 1.0);
	rmSetAreaCoherence(cliffIDB2, 0.5);
	rmSetAreaSmoothDistance(cliffIDB2, 10);
	rmAddAreaConstraint(cliffIDB2, avoidNativesShort);
	rmAddAreaConstraint(cliffIDB2, avoidTradeRouteSockets);
	rmAddAreaConstraint(cliffIDB2, avoidTradeRouteMin);
	rmBuildArea(cliffIDB2);

	int cliffIDB3 = rmCreateArea("cliffb3");
	rmSetAreaSize(cliffIDB3, rmAreaTilesToFraction(200*cNumberNonGaiaPlayers), rmAreaTilesToFraction(200*cNumberNonGaiaPlayers));		// 0.015
	if (cNumberNonGaiaPlayers == 2) {
		rmSetAreaLocation(cliffIDB3, 1.0, 0.43);
		rmAddAreaInfluenceSegment(cliffIDB3, 1.0, 0.43, 0.85, 0.43);
		}
	else {
		rmSetAreaLocation(cliffIDB3, 1.0, 0.40);
		rmAddAreaInfluenceSegment(cliffIDB3, 1.0, 0.40, 0.85, 0.40);
		}
	rmSetAreaCliffType(cliffIDB3, "andes");
	rmAddAreaToClass(cliffIDB3, rmClassID("classCliff"));
	rmSetAreaCliffEdge(cliffIDB3, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffHeight(cliffIDB3, rmRandInt(4, 6), 1.0, 1.0);
	rmSetAreaCoherence(cliffIDB3, 0.75);
	rmSetAreaSmoothDistance(cliffIDB3, 10);
	rmAddAreaConstraint(cliffIDB3, avoidNativesShort);
	rmAddAreaConstraint(cliffIDB3, avoidTradeRouteSockets);
	rmAddAreaConstraint(cliffIDB3, avoidTradeRouteMin);
	rmBuildArea(cliffIDB3);

	// Text
	rmSetStatusText("", 0.55);

	// PLAYER STARTING RESOURCES
	rmClearClosestPointConstraints();

	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmAddObjectDefToClass(TCID, rmClassID("startingResource"));
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	}

	/*	rmAddObjectDefConstraint(TCID, playerEdgeConstraint);
	int TCfloat = -1;

	if (cNumberTeams == 2)
	{
		rmAddObjectDefConstraint(TCID, avoidTradeRouteTC);
		rmAddObjectDefConstraint(TCID, avoidTradeRouteSocketsTC);
		TCfloat = 0;
	}
	else 
	{
		rmAddObjectDefConstraint(TCID, avoidTradeRouteFar);
		TCfloat = 0;
	}*/

	rmSetObjectDefMinDistance(TCID, 0.0);
    if(cNumberNonGaiaPlayers==2){
        rmSetObjectDefMaxDistance(TCID, 0.0);
    }else if(cNumberTeams>2){
        rmSetObjectDefMaxDistance(TCID, 0.0);
    }else if(teamZeroCount!=teamOneCount){
        rmSetObjectDefMaxDistance(TCID, 0.0);
        rmAddObjectDefConstraint(TCID, avoidCliff);
	}

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmAddObjectDefToClass(playerSilverID, rmClassID("startingResource"));
	rmAddObjectDefToClass(playerSilverID, rmClassID("classGold"));
	rmSetObjectDefMinDistance(playerSilverID, 16.0);
	rmSetObjectDefMaxDistance(playerSilverID, 16.0);
	rmAddObjectDefConstraint(playerSilverID, avoidStartingResources);
	rmAddObjectDefConstraint(playerSilverID, avoidGoldShort);
	rmAddObjectDefConstraint(playerSilverID, avoidCliff);
	rmAddObjectDefConstraint(playerSilverID, stayMidIsland);

	int playerMedSilverID = rmCreateObjectDef("player medium mine");
	rmAddObjectDefItem(playerMedSilverID, "mine", 1, 0);
	rmAddObjectDefToClass(playerMedSilverID, rmClassID("startingResource"));
	rmAddObjectDefToClass(playerMedSilverID, rmClassID("classGold"));
	rmSetObjectDefMinDistance(playerMedSilverID, 34.0);
	rmSetObjectDefMaxDistance(playerMedSilverID, 34.0);
	rmAddObjectDefConstraint(playerMedSilverID, avoidStartingResources);
	rmAddObjectDefConstraint(playerMedSilverID, avoidGold);
	rmAddObjectDefConstraint(playerMedSilverID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerMedSilverID, avoidTradeRouteSocketsMin);
	rmAddObjectDefConstraint(playerMedSilverID, avoidCliff);
	rmAddObjectDefConstraint(playerMedSilverID, avoidMidIsland);

	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeAndes", 20, 7.0);
	rmSetObjectDefMinDistance(playerTreeID, 20);
	rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, rmClassID("startingResource"));
	rmAddObjectDefToClass(playerTreeID, rmClassID("classForest"));
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesFar);
	rmAddObjectDefConstraint(playerTreeID, avoidForest);
	rmAddObjectDefConstraint(playerTreeID, avoidGold);
	rmAddObjectDefConstraint(playerTreeID, avoidCliff);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);

	int playerTree2ID = rmCreateObjectDef("player trees2");
	rmAddObjectDefItem(playerTree2ID, "TreeAndes", 20, 7.0);
	rmSetObjectDefMinDistance(playerTree2ID, 30);
	rmSetObjectDefMaxDistance(playerTree2ID, 30);
	rmAddObjectDefToClass(playerTree2ID, rmClassID("startingResource"));
	rmAddObjectDefToClass(playerTree2ID, rmClassID("classForest"));
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResourcesMed);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidCliff);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree2ID, avoidMidIslandMin);

	int playerTree3ID = rmCreateObjectDef("player trees3");
	rmAddObjectDefItem(playerTree3ID, "TreeAndes", 30, 10.0);
	rmSetObjectDefMinDistance(playerTree3ID, 50);
	rmSetObjectDefMaxDistance(playerTree3ID, 55);
	rmAddObjectDefToClass(playerTree3ID, rmClassID("startingResource"));
	rmAddObjectDefToClass(playerTree3ID, rmClassID("classForest"));
	rmAddObjectDefConstraint(playerTree3ID, avoidStartingResourcesMed);
	rmAddObjectDefConstraint(playerTree3ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree3ID, avoidCliff);
	rmAddObjectDefConstraint(playerTree3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree3ID, avoidMidIslandFar);
	rmAddObjectDefConstraint(playerTree3ID, avoidEdgeMore);

	int playerGuanacoID = rmCreateObjectDef("player guanaco");
	rmAddObjectDefItem(playerGuanacoID, "guanaco", 20, 8.0);
	rmSetObjectDefMinDistance(playerGuanacoID, 18);
	rmSetObjectDefMaxDistance(playerGuanacoID, 18);
	rmSetObjectDefCreateHerd(playerGuanacoID, true);
	rmAddObjectDefToClass(playerGuanacoID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerGuanacoID, avoidStartingResourcesMed);
	rmAddObjectDefConstraint(playerGuanacoID, avoidCliff);
	rmAddObjectDefConstraint(playerGuanacoID, avoidStartingResources);

	int farGuanacoID = rmCreateObjectDef("player far guanaco");
	rmAddObjectDefItem(farGuanacoID, "guanaco", 10, 6.0);
	rmSetObjectDefMinDistance(farGuanacoID, 50);
	rmSetObjectDefMaxDistance(farGuanacoID, 55);
	rmSetObjectDefCreateHerd(farGuanacoID, true);
	rmAddObjectDefToClass(farGuanacoID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(farGuanacoID, avoidMountainZoneMin);
	rmAddObjectDefConstraint(farGuanacoID, avoidCliff);
	rmAddObjectDefConstraint(farGuanacoID, avoidGuanacoShort);
	rmAddObjectDefConstraint(farGuanacoID, avoidMidIslandFar);
	rmAddObjectDefConstraint(farGuanacoID, avoidStartingResources);

	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(playerNuggetID, 30.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 36.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketsMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);

	for (i = 1; < cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGuanacoID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (cNumberNonGaiaPlayers > 2)
			rmPlaceObjectDefAtLoc(playerMedSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree3ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (PlayerNum > 4)
			rmPlaceObjectDefAtLoc(farGuanacoID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		rmClearClosestPointConstraints();
	}

	// Text
	rmSetStatusText("", 0.60);

	// Silver mines
		int silverID = rmCreateObjectDef("silver ");
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmAddObjectDefToClass(silverID, rmClassID("classGold"));
		if (cNumberNonGaiaPlayers == 2) {
			rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.08));
			rmAddObjectDefConstraint(silverID, avoidGold);
			}
		else {
			rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.50));
			rmAddObjectDefConstraint(silverID, avoidGoldFar);
			}
		rmAddObjectDefConstraint(silverID, avoidStartingResources);
		rmAddObjectDefConstraint(silverID, avoidTownCenter);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteSockets);
		rmAddObjectDefConstraint(silverID, coinEdgeConstraint);
		if (cNumberTeams == 2) {
			rmAddObjectDefConstraint(silverID, avoidMountainZoneMin);
			rmAddObjectDefConstraint(silverID, stayNorthZone);
			rmAddObjectDefConstraint(silverID, avoidSouthZone);
			}
		rmAddObjectDefConstraint(silverID, avoidCliff);
		rmAddObjectDefConstraint(silverID, avoidNativesShort);
//		rmAddObjectDefConstraint(silverID, avoidClearing);
		rmAddObjectDefConstraint(silverID, avoidForestMin);
		if (cNumberNonGaiaPlayers == 2) {
			rmPlaceObjectDefAtLoc(silverID, 0, 0.45, 0.90);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.40, 0.58);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.15, 0.70);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.65, 0.75);
			}
		else
			rmPlaceObjectDefAtLoc(silverID, 0, 0.40, 0.90, 3*cNumberNonGaiaPlayers/2);

		int silverSouthID = rmCreateObjectDef("silverSouth ");
		rmAddObjectDefItem(silverSouthID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverSouthID, 0.0);
		rmAddObjectDefToClass(silverSouthID, rmClassID("classGold"));
		if (cNumberNonGaiaPlayers == 2) {
			rmSetObjectDefMaxDistance(silverSouthID, rmXFractionToMeters(0.075));
			rmAddObjectDefConstraint(silverSouthID, avoidGold);
			}
		else {
			rmSetObjectDefMaxDistance(silverSouthID, rmXFractionToMeters(0.50));
			rmAddObjectDefConstraint(silverSouthID, avoidGoldFar);
			}
		rmAddObjectDefConstraint(silverSouthID, avoidStartingResources);
		rmAddObjectDefConstraint(silverSouthID, avoidTownCenter);
		rmAddObjectDefConstraint(silverSouthID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverSouthID, avoidTradeRouteSockets);
		rmAddObjectDefConstraint(silverSouthID, coinEdgeConstraint);
		if (cNumberTeams == 2) {
			rmAddObjectDefConstraint(silverSouthID, avoidMountainZoneMin);
			rmAddObjectDefConstraint(silverSouthID, staySouthZone);
			rmAddObjectDefConstraint(silverSouthID, avoidNorthZone);
			}
		rmAddObjectDefConstraint(silverSouthID, avoidCliff);
		rmAddObjectDefConstraint(silverSouthID, avoidNativesShort);
//		rmAddObjectDefConstraint(silverSouthID, avoidClearing);
		rmAddObjectDefConstraint(silverSouthID, avoidForestMin);
		if (cNumberNonGaiaPlayers == 2) {
			rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.45, 0.10);
			rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.40, 0.42);
			rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.15, 0.30);
			rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.65, 0.25);
			}
		else 
			rmPlaceObjectDefAtLoc(silverSouthID, 0, 0.40, 0.10, 3*cNumberNonGaiaPlayers/2);
	
	// Text
	rmSetStatusText("", 0.70);

	// Central Clearing
	int forestClearing = rmCreateArea("forest clearing ");
	rmSetAreaWarnFailure(forestClearing, false);
	rmSetAreaSize(forestClearing, rmAreaTilesToFraction(600), rmAreaTilesToFraction(700));
	rmSetAreaLocation(forestClearing, 0.5, 0.5);
	rmAddAreaInfluenceSegment(forestClearing, 0.50, 0.50, 0.80, 0.50);
	rmSetAreaMix(forestClearing, "andes_grass_b");
	rmAddAreaToClass(forestClearing, rmClassID("classClearing"));
	rmSetAreaCoherence(forestClearing, 0.55);
	rmSetAreaSmoothDistance(forestClearing, 10);
	rmBuildArea(forestClearing);

	// Forest areas
	numTries = 6+8 * cNumberNonGaiaPlayers;
	failCount = 0;
	for (i = 0; < numTries)
	{
		int forestID = rmCreateArea("forestID" + i, southIslandID);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaObeyWorldCircleConstraint(forestID, true);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(200));
		rmSetAreaForestType(forestID, "andes forest");
		rmSetAreaForestDensity(forestID, 1.00);
		rmSetAreaForestClumpiness(forestID, 1.00);
		rmSetAreaForestUnderbrush(forestID, 0.6);
		rmSetAreaCoherence(forestID, 0.4);
		rmAddAreaToClass(forestID, rmClassID("classForest"));
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, avoidTradeRouteMin);
		rmAddAreaConstraint(forestID, avoidTradeRouteSockets);
		rmAddAreaConstraint(forestID, avoidTownCenter);
		rmAddAreaConstraint(forestID, avoidStartingResources);
		rmAddAreaConstraint(forestID, avoidCliff);
		rmAddAreaConstraint(forestID, avoidClearing);
		rmAddAreaConstraint(forestID, avoidGoldShort);
		rmAddAreaConstraint(forestID, avoidNatives);
		if (rmBuildArea(forestID) == false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if (failCount == 10)
				break;
		}
		else
			failCount = 0;
	}

		rmSetStatusText("", 0.80);

	if (cNumberNonGaiaPlayers < 4)
		numTries = 8 * cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers < 6)
		numTries = 6 * cNumberNonGaiaPlayers;
	else if (cNumberNonGaiaPlayers == 6)
		numTries = 5 * cNumberNonGaiaPlayers;
	else
		numTries = 4 * cNumberNonGaiaPlayers;

	failCount = 0;
	for (i = 0; < numTries)
	{
		int forestmountainID = rmCreateArea("forestmountainID" + i, northIslandID);
		rmSetAreaWarnFailure(forestmountainID, false);
		rmSetAreaSize(forestmountainID, rmAreaTilesToFraction(200));
		rmSetAreaForestType(forestmountainID, "andes forest");
		rmSetAreaForestDensity(forestmountainID, 0.5);
		rmSetAreaForestClumpiness(forestmountainID, 0.4);
		rmSetAreaForestUnderbrush(forestmountainID, 0.7);
		rmSetAreaCoherence(forestmountainID, 0.4);
		rmSetAreaSmoothDistance(forestmountainID, 10);
		rmAddAreaToClass(forestmountainID, rmClassID("classForest"));
		rmAddAreaConstraint(forestmountainID, avoidForest);
		rmAddAreaConstraint(forestmountainID, avoidTradeRouteMin);
		rmAddAreaConstraint(forestmountainID, avoidTradeRouteSockets);
		rmAddAreaConstraint(forestmountainID, avoidTownCenterFar);
		rmAddAreaConstraint(forestmountainID, avoidStartingResources);
		rmAddAreaConstraint(forestmountainID, avoidCliff);
		rmAddAreaConstraint(forestmountainID, avoidClearing);
		rmAddAreaConstraint(forestmountainID, avoidGoldShort);
		rmAddAreaConstraint(forestmountainID, avoidNatives);
		if (rmBuildArea(forestmountainID) == false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if (failCount == 10)
				break;
		}
		else
			failCount = 0;
	}

/*
	//Define and place Huari Strongholds
	int strongholdID= rmCreateObjectDef("stronghold"); 
	rmAddObjectDefItem(strongholdID, "HuariStrongholdAndes", 1, 0.0);
	rmSetObjectDefMinDistance(strongholdID, 0.0);
	rmSetObjectDefMaxDistance(strongholdID, rmXFractionToMeters(0.5));
	rmPlaceObjectDefAtLoc(strongholdID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*1.5);

	// removed and added second, smaller clump of playertrees
	// Extra tree clumps near players - to ensure fair access to wood
	int extraTreesID = rmCreateObjectDef("extra trees");
	rmAddObjectDefItem(extraTreesID, "TreeAndes", 6, 5.0);
	rmSetObjectDefMinDistance(extraTreesID, 24);
	rmSetObjectDefMaxDistance(extraTreesID, 24);
	rmAddObjectDefConstraint(extraTreesID, avoidStartingResources);
	rmAddObjectDefConstraint(extraTreesID, avoidGoldShort);
	rmAddObjectDefConstraint(extraTreesID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(extraTreesID, avoidTradeRoute);
	rmAddObjectDefConstraint(extraTreesID, avoidTownCenterShort);
	for (i = 1; < cNumberPlayers)
		rmPlaceObjectDefInArea(extraTreesID, 0, rmAreaID("player" + i), 1);

	int extraTrees2ID = rmCreateObjectDef("more extra trees");
	rmAddObjectDefItem(extraTrees2ID, "TreeAndes", 6, 6.0);
	rmSetObjectDefMinDistance(extraTrees2ID, 30);
	rmSetObjectDefMaxDistance(extraTrees2ID, 30);
	rmAddObjectDefConstraint(extraTrees2ID, avoidStartingResources);
	rmAddObjectDefConstraint(extraTrees2ID, avoidGoldShort);
	rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(extraTrees2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(extraTrees2ID, avoidTownCenterShort);
	for (i = 1; < cNumberPlayers)
		rmPlaceObjectDefInArea(extraTrees2ID, 0, rmAreaID("player" + i), 1);
*/
	// Huntables
	int guanacoID = rmCreateObjectDef("guanaco herd " + i);
	rmAddObjectDefItem(guanacoID, "guanaco", 10, 4);
	rmSetObjectDefMinDistance(guanacoID, 0.0);
	if (cNumberNonGaiaPlayers == 2)
		rmSetObjectDefMaxDistance(guanacoID, rmXFractionToMeters(0.075));
	else if (cNumberTeams > 2)
		rmSetObjectDefMaxDistance(guanacoID, rmXFractionToMeters(0.40));
	else
		rmSetObjectDefMaxDistance(guanacoID, rmXFractionToMeters(0.45));
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(guanacoID, avoidGuanaco);
	else
		rmAddObjectDefConstraint(guanacoID, avoidGuanacoFar);
	rmAddObjectDefConstraint(guanacoID, avoidEdgeMore);
	rmAddObjectDefConstraint(guanacoID, avoidGoldMin);
	rmAddObjectDefConstraint(guanacoID, avoidForestMin);
	rmAddObjectDefConstraint(guanacoID, avoidTownCenter);
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(guanacoID, avoidMountainZoneMin);
	rmAddObjectDefConstraint(guanacoID, avoidTradeRouteSocketsMin);
	rmAddObjectDefConstraint(guanacoID, avoidCliff);
	rmAddObjectDefConstraint(guanacoID, avoidNatives);
	rmAddObjectDefConstraint(guanacoID, avoidStartingResources);
	rmAddObjectDefConstraint(guanacoID, avoidTradeRouteMin);
	rmSetObjectDefCreateHerd(guanacoID, true);
	if (cNumberNonGaiaPlayers == 2) {
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.50, 0.90);
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.38, 0.58);
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.15, 0.65);
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.65, 0.65);
		}
	else if (cNumberTeams > 2)
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.30, 0.50, 2*cNumberNonGaiaPlayers);
	else 
		rmPlaceObjectDefAtLoc(guanacoID, 0, 0.40, 1.00, 2*cNumberNonGaiaPlayers);
	
	int guanacoSEID = rmCreateObjectDef("guanaco SE herd ");
	rmAddObjectDefItem(guanacoSEID, "guanaco", 10, 4);
	rmSetObjectDefMinDistance(guanacoSEID, 0.0);
	if (cNumberNonGaiaPlayers == 2)
		rmSetObjectDefMaxDistance(guanacoSEID, rmXFractionToMeters(0.075));
	else if (cNumberTeams > 2)
		rmSetObjectDefMaxDistance(guanacoSEID, rmXFractionToMeters(0.40));
	else
		rmSetObjectDefMaxDistance(guanacoSEID, rmXFractionToMeters(0.45));
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(guanacoSEID, avoidGuanaco);
	else
		rmAddObjectDefConstraint(guanacoSEID, avoidGuanacoFar);
	rmAddObjectDefConstraint(guanacoSEID, avoidEdgeMore);
	rmAddObjectDefConstraint(guanacoSEID, avoidGoldMin);
	rmAddObjectDefConstraint(guanacoSEID, avoidForestMin);
	rmAddObjectDefConstraint(guanacoSEID, avoidTownCenter);
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(guanacoSEID, avoidMountainZoneMin);
	rmAddObjectDefConstraint(guanacoSEID, avoidTradeRouteSocketsMin);
	rmAddObjectDefConstraint(guanacoSEID, avoidCliff);
	rmAddObjectDefConstraint(guanacoSEID, avoidNatives);
	rmAddObjectDefConstraint(guanacoSEID, avoidStartingResources);
	rmAddObjectDefConstraint(guanacoSEID, avoidTradeRouteMin);
	rmSetObjectDefCreateHerd(guanacoSEID, true);
	if (cNumberNonGaiaPlayers == 2) {
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.50, 0.10);
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.38, 0.42);
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.15, 0.35);
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.65, 0.35);
		}
	else if (cNumberTeams > 2)
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.30, 0.50, 2*cNumberNonGaiaPlayers);
	else 
		rmPlaceObjectDefAtLoc(guanacoSEID, 0, 0.40, 0.00, 2*cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("", 0.90);

	// Define and place Puyas
	int puyaTreeID = rmCreateObjectDef("puya tree");
	rmAddObjectDefItem(puyaTreeID, "treePuya", rmRandInt(1,3), 3.0);
	rmAddObjectDefToClass(puyaTreeID, rmClassID("classForest"));
	rmSetObjectDefMinDistance(puyaTreeID, rmXFractionToMeters(0.25));
	rmSetObjectDefMaxDistance(puyaTreeID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(puyaTreeID, avoidCliff);
	rmAddObjectDefConstraint(puyaTreeID, avoidTownCenter);
	rmAddObjectDefConstraint(puyaTreeID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(puyaTreeID, avoidTradeRouteSocketsMin);
	rmAddObjectDefConstraint(puyaTreeID, avoidNatives);
	rmAddObjectDefConstraint(puyaTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(puyaTreeID, avoidGuanacoMin);
	rmAddObjectDefConstraint(puyaTreeID, avoidForestFar);
	rmPlaceObjectDefAtLoc(puyaTreeID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

	// Define and place Nuggets
	int nuggetharderID = rmCreateObjectDef("nugget harder");
	rmAddObjectDefItem(nuggetharderID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmSetObjectDefMinDistance(nuggetharderID, 0.0);
	rmSetObjectDefMaxDistance(nuggetharderID, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(nuggetharderID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggetharderID, avoidClearing);
	rmAddObjectDefConstraint(nuggetharderID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggetharderID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(nuggetharderID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nuggetharderID, avoidCliff);
	rmAddObjectDefConstraint(nuggetharderID, avoidNativesShort);
	rmAddObjectDefConstraint(nuggetharderID, avoidForestMin);
	rmAddObjectDefConstraint(nuggetharderID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetharderID, avoidGuanacoMin);
	rmAddObjectDefConstraint(nuggetharderID, avoidMountainZone);
	if (cNumberNonGaiaPlayers > 4 && rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(nuggetharderID, 0, 0.00, 0.50, cNumberNonGaiaPlayers);

	int nuggethardID = rmCreateObjectDef("nugget hard");
	rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(nuggethardID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggethardID, avoidClearing);
	rmAddObjectDefConstraint(nuggethardID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggethardID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(nuggethardID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nuggethardID, avoidCliff);
	rmAddObjectDefConstraint(nuggethardID, avoidNativesShort);
	rmAddObjectDefConstraint(nuggethardID, avoidForestMin);
	rmAddObjectDefConstraint(nuggethardID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggethardID, avoidGuanacoMin);
	rmAddObjectDefConstraint(nuggethardID, avoidMountainZone);
	if (cNumberNonGaiaPlayers > 2)
		rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.00, 0.50, cNumberNonGaiaPlayers/2);

	int nuggetmediumID = rmCreateObjectDef("nugget medium");
	rmAddObjectDefItem(nuggetmediumID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(nuggetmediumID, 0.0);
	rmSetObjectDefMaxDistance(nuggetmediumID, rmXFractionToMeters(0.30));
	rmAddObjectDefConstraint(nuggetmediumID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggetmediumID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggetmediumID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(nuggetmediumID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nuggetmediumID, avoidCliff);
	rmAddObjectDefConstraint(nuggetmediumID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetmediumID, avoidForestMin);
	rmAddObjectDefConstraint(nuggetmediumID, avoidGuanacoMin);
	rmAddObjectDefConstraint(nuggetmediumID, stayMountainZone);
	rmPlaceObjectDefAtLoc(nuggetmediumID, 0, 0.5, 0.5, 4+cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("", 0.95);

	int nuggeteasyID = rmCreateObjectDef("nugget easy");
	rmAddObjectDefItem(nuggeteasyID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(nuggeteasyID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggeteasyID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggeteasyID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidTradeRouteSockets);
	rmAddObjectDefConstraint(nuggeteasyID, avoidCliff);
	rmAddObjectDefConstraint(nuggeteasyID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidForestMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidGuanacoMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidNatives);
	rmPlaceObjectDefAtLoc(nuggeteasyID, 0, 0.5, 0.5, 2+cNumberNonGaiaPlayers*2);

	// Text
	rmSetStatusText("", 1.0);
}
