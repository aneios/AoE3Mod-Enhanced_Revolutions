// Minas Gerais (formerly vivid's Alberta merged with vivid's Twin Sisters)
// map made by vividlyplain
// original design of Alberta by dansil92
// original design of Twin Sisters by JaiLeD
// thanks to Kenoki for some map balance feedback
// ported to DE by vividlyplain, September 2021

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	int TeamNum = cNumberTeams;
	int PlayerNum = cNumberNonGaiaPlayers;
	int numPlayer = cNumberPlayers;

	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01);

	// ____________________ General ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	int spawnChooser=rmRandInt(1,4);

	// Strings
	string wetType = "Pampas River RM";	
	string paintMix1 = "pampas_grassy";
	string paintMix2 = "pampas_dirt";
	string paintMix3 = "pampas_grass";
	string paintMix4 = "pampas_forest_dirt";
	string paintLand1 = "pampas\ground1_pam";
	string paintLand2 = "pampas\ground2_pam";
	string paintLand3 = "pampas\ground3_pam";
	string paintLand4 = "pampas\ground4_pam";
	string paintLand5 = "pampas\ground5_pam";
	string paintLand6 = "pampas\ground6_pam";
	string paintLand7 = "pampas\groundforest_pam";
	string mntType = "pampas";	
	string cliffPaint = "pampas\ground1_pam";	
	string forTesting = "testmix";	 
	string treasureSet = "pampas";
	string shineAlight = "rm_minasGerais";
	string toiletPaper = "dirt_trail";
	string food1 = "tapir";
	string food2 = "deer";
	string food3 = "capybara";
	string cattleType = "Llama";
	string treeType1 = "TreeAraucania";
	string treeType2 = "TreePolyepis";
	string treeType3 = "TreePaintedDesert";
	string treeType4 = "TreeAmazon";
	string natType1 = "Tupi";
	string natType2 = "Jesuit";
	string natGrpName1 = "native tupi village ";
	string natGrpName2 = "native jesuit mission borneo 0";

	// Picks the map size
	int playerTiles=8000;
	if (teamZeroCount != teamOneCount || TeamNum > 2)
		playerTiles=10000;
	
	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Picks a default water height
	rmSetSeaLevel(2.0);	

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 3, 0.5, 3.5); // type, frequency, octaves, persistence, variation

	// Picks default terrain and water
	rmSetSeaType(wetType);
	rmSetBaseTerrainMix(paintMix1); 
	rmTerrainInitialize(paintLand1, 0); 
	rmSetMapType(treasureSet);
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetLightingSet(shineAlight); 

	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPatch4 = rmDefineClass("patch4");
	int classForest = rmDefineClass("Forest");
	int classNative=rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classIsland=rmDefineClass("island");
	int classGrass=rmDefineClass("grass");

	// ____________________ Constraints ____________________
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.44), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 30.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 20.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 40.0);
	int avoidForestVeryFar=rmCreateClassDistanceConstraint("avoid forest very far", rmClassID("Forest"), 50.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 16.0);
	int avoidForestShorter=rmCreateClassDistanceConstraint("avoid forest shorter", rmClassID("Forest"), 8.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 18.0);
	int avoidHunt3Far = rmCreateTypeDistanceConstraint("avoid hunt3 far", food3, 50.0);
	int avoidHunt3VeryFar = rmCreateTypeDistanceConstraint("avoid hunt3 very far", food3, 60.0);
	int avoidHunt3 = rmCreateTypeDistanceConstraint("avoid hunt3", food3, 40.0);
	int avoidHunt3Med = rmCreateTypeDistanceConstraint("avoid hunt3 med", food3, 30.0);
	int avoidHunt3Short = rmCreateTypeDistanceConstraint("avoid hunt3 short", food3, 20.0);
	int avoidHunt3Min = rmCreateTypeDistanceConstraint("avoid hunt3 min", food3, 8.0);	
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 50.0);
	int avoidHunt2VeryFar = rmCreateTypeDistanceConstraint("avoid hunt2 very far", food2, 60.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 36.0);
	int avoidHunt2Med = rmCreateTypeDistanceConstraint("avoid hunt2 med", food2, 30.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 20.0);
	int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt2 min", food2, 8.0);	
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 50.0);
	int avoidHunt1VeryFar = rmCreateTypeDistanceConstraint("avoid hunt1 very far", food1, 60.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 50.0);
	int avoidHunt1Med = rmCreateTypeDistanceConstraint("avoid hunt1 med", food1, 30.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 20.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 8.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 8.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 16.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 26.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 40.0); 
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 72.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("avoid nugget far", "AbstractNugget", 64.0);
	int avoidNuggetVeryFar=rmCreateTypeDistanceConstraint("avoid nugget very far", "AbstractNugget", 80.0);

	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 65.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 62.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint(" avoid Town Center med", "townCenter", 24.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint(" avoid Town Center short", "townCenter", 12.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint(" avoid Town Center", "townCenter", 40.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", rmClassID("natives"), 4.0);
	int stayNatives = rmCreateClassDistanceConstraint("stuff stays near natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 12.0);
	int avoidNativesVeryFar = rmCreateClassDistanceConstraint("stuff avoids natives very far", rmClassID("natives"), 16.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other short", rmClassID("startingResource"), 4.0);

	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 12.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 2.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 6.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 8.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 8.0);
	int stayNearWaterFar = rmCreateTerrainMaxDistanceConstraint("stay near water far", "land", false, 16.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 4.0);
	int avoidWaterMin = rmCreateTerrainDistanceConstraint("avoid water min", "water", true, 2.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 12.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch 2", rmClassID("patch2"), 12.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("patch avoid patch 3", rmClassID("patch3"), 20.0);
	int avoidPatch4 = rmCreateClassDistanceConstraint("patch avoid patch 4", rmClassID("patch4"), 24.0);
	int avoidEmbellishment = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 12.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 8.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 12.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 16.0);
	
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);

	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 1.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("avoid trade route socket min", "socketTradeRoute", 2.0);
	
	// ____________________ Player Placement ____________________
		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.03, 0.05); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.72, 0.74); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				}
				else
				{
					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.03, 0.05); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.72, 0.74); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				}
			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.02, 0.12); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.35, 0.35, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.62, 0.72); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.35, 0.35, 0);
				}
				else if (teamZeroCount == 3) // 3v3
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.02, 0.17); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0.02);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.57, 0.72); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0.02);
				}
				else // 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.02, 0.20); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.37, 0.37, 0.02);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.54, 0.72); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.37, 0.37, 0.02);
				}
			}
			else // unequal N of players per TEAM
			{
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.34, 0.34, 0.0);
			}
		}
		else  //FFA
			{	
				rmSetPlacementSection(0.99, 0.989999);
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.34, 0.34, 0.0);
			}

	// Text
	rmSetStatusText("",0.20);

	// ____________________ Map Parameters ____________________
	//Trade Route
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		int tradeRouteID = rmCreateTradeRoute();

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 2.0);
        rmSetObjectDefMaxDistance(socketID, 8.0);      
		
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.55);
		else
			rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.60);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.60);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.80);
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.45, 1.00);
		else
			rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 1.00);
		
        rmBuildTradeRoute(tradeRouteID, toiletPaper);

    	vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.10);
    	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		if (PlayerNum > 2) {
		    socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.33);
		    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.67);
		    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.90);
    	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
	}
	else {
	int socketID3=rmCreateObjectDef("sockets to dock Trade Posts3");
        rmAddObjectDefItem(socketID3, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID3, true);
        rmSetObjectDefMinDistance(socketID3, 2.0);
        rmSetObjectDefMaxDistance(socketID3, 8.0);    
	       
        int tradeRouteID3 = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID3, tradeRouteID3);
		
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.94); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.60, 0.92); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.70, 0.90);
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.81, 0.81);
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.92, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.95, 0.50); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.89, 0.29); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.81, 0.18); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.65, 0.08); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.05); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.30, 0.10); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.17, 0.17); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.07, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.05, 0.50); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.09, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.11, 0.73); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.20, 0.80); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.22, 0.87); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.35, 0.92); 
		rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.94); 
		
        rmBuildTradeRoute(tradeRouteID3, toiletPaper);

		vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.00);
		rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);

		if (PlayerNum == 8) {	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.125);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.250);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.375);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.500);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.625);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
		
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.750);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.875);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}
		
		else if (PlayerNum == 7) {
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.1429);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.2858);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.4287);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.5716);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.7145);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
		
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.8574);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}

		else if (PlayerNum == 6) {
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.16667);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.33334);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.50001);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.66668);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.83335);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}	

		else if (PlayerNum == 5) {
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.20);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.40);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.60);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.80);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}			

		else if (PlayerNum == 4) {
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.25);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.50);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.75);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}	
			
		else if (PlayerNum == 3) {
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.33333);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.66666);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}		

		else if (PlayerNum == 2) {
			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.50);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
			}						
	}
	
	//River
	int riverID = rmRiverCreate(-5, wetType, 1, 1, 4+PlayerNum/2, 4+PlayerNum/2); 
	rmRiverAddWaypoint(riverID,  0.65, 0.35);
	rmRiverAddWaypoint(riverID,  0.61, 0.43);
	rmRiverAddWaypoint(riverID,  0.50, 0.50);
	rmRiverAddWaypoint(riverID,  0.39, 0.57);
	rmRiverAddWaypoint(riverID,  0.35, 0.65);
	rmRiverAddWaypoint(riverID,  0.00, 1.00);
	rmRiverSetShallowRadius(riverID, 6+PlayerNum);
	rmRiverAddShallow(riverID, 0.05);
	rmRiverAddShallow(riverID, 0.30);
	rmRiverAddShallow(riverID, 0.535);
	rmRiverAddShallow(riverID, 0.75);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmRiverBuild(riverID);

	// Plateau
	float pxLoc = 0.00;
	float pyLoc = 0.00;
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		pxLoc = 0.96;
		pyLoc = 0.04;
		}
	else {
		pxLoc = 0.50;
		pyLoc = 0.50;
		}

	int plateauID = rmCreateArea("plateau");
	rmSetAreaSize(plateauID, 0.15); 
	rmSetAreaWarnFailure(plateauID, false);
	rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	rmSetAreaCliffType(plateauID, mntType); 
	rmSetAreaTerrainType(plateauID, cliffPaint);
	rmSetAreaCliffHeight(plateauID, 4.5, 0.0, 0.8);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmSetAreaCliffEdge(plateauID, 6, 0.07, 0.0, 0.50, 1);
	else
		rmSetAreaCliffEdge(plateauID, 8, 0.08, 0.0, 1.00, 1);
	rmSetAreaCoherence(plateauID, 0.75);
	rmSetAreaSmoothDistance(plateauID, 2);
	rmSetAreaLocation(plateauID, pxLoc, pyLoc);
	rmBuildArea(plateauID);

	int avoidPlateau = rmCreateAreaDistanceConstraint("avoid plateau", plateauID, 8.0);
	int avoidPlateauShort = rmCreateAreaDistanceConstraint("avoid plateau short", plateauID, 4.0);
	int avoidPlateauFar = rmCreateAreaDistanceConstraint("avoid plateau far", plateauID, 16.0);
	int stayInPlateau = rmCreateAreaMaxDistanceConstraint("stay in plateau", plateauID, 0.0);
	int stayNearPlateau = rmCreateAreaMaxDistanceConstraint("stay near plateau", plateauID, 8.0);

	int plateauPaintID = rmCreateArea("bison zone north");
	rmSetAreaSize(plateauPaintID, 0.20);
	rmSetAreaLocation(plateauPaintID, pxLoc, pyLoc);
	rmSetAreaWarnFailure(plateauPaintID, false);
	rmSetAreaMix(plateauPaintID, paintMix3);
	rmSetAreaCoherence(plateauPaintID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(plateauPaintID, false);
	rmAddAreaConstraint(plateauPaintID, stayNearPlateau);
	rmBuildArea(plateauPaintID);	

	// Players area
	for (i=1; < numPlayer)
	{
	int playerAreaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerAreaID);
	rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(444));
	rmSetAreaMix(playerAreaID, paintMix2);
	rmSetAreaCoherence(playerAreaID, 0.333);
	rmSetAreaWarnFailure(playerAreaID, false);
	rmAddAreaToClass(playerAreaID, classIsland);
	rmSetAreaLocPlayer(playerAreaID, i);
	rmBuildArea(playerAreaID);
	
	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerAreaID, 20.0);
	int stayInPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerAreaID, 0.0);
	}

	// Git Off Muh Lawn!
	int huntZoneNID = rmCreateArea("hunt zone north");
	rmSetAreaSize(huntZoneNID, 0.03);
	rmSetAreaLocation(huntZoneNID, 0.60, 0.60);
	rmAddAreaInfluenceSegment(huntZoneNID, 0.75, 0.45, 0.50, 0.70);	
	rmSetAreaWarnFailure(huntZoneNID, false);
//	rmSetAreaMix(huntZoneNID, forTesting);
	rmSetAreaCoherence(huntZoneNID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(huntZoneNID, false);
	rmAddAreaConstraint(huntZoneNID, avoidWaterMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(huntZoneNID);	

	int huntZoneSID = rmCreateArea("hunt zone south");
	rmSetAreaSize(huntZoneSID, 0.03);
	rmSetAreaLocation(huntZoneSID, 0.40, 0.40);
	rmAddAreaInfluenceSegment(huntZoneSID, 0.55, 0.25, 0.30, 0.50);	
	rmSetAreaWarnFailure(huntZoneSID, false);
//	rmSetAreaMix(huntZoneSID, forTesting);
	rmSetAreaCoherence(huntZoneSID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(huntZoneSID, false);
	rmAddAreaConstraint(huntZoneSID, avoidWaterMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(huntZoneSID);	

	int avoidHuntZoneN = rmCreateAreaDistanceConstraint("avoid bison zone north", huntZoneNID, 8.0);
	int avoidHuntZoneNShort = rmCreateAreaDistanceConstraint("avoid bison zone north short", huntZoneNID, 4.0);
	int stayHuntZoneN = rmCreateAreaMaxDistanceConstraint("stay in bison zone north", huntZoneNID, 0.0);	
	int avoidHuntZoneS = rmCreateAreaDistanceConstraint("avoid bison zone south", huntZoneSID, 8.0);
	int avoidHuntZoneSShort = rmCreateAreaDistanceConstraint("avoid bison zone south short", huntZoneSID, 4.0);
	int stayHuntZoneS = rmCreateAreaMaxDistanceConstraint("stay in bison zone south", huntZoneSID, 0.0);		

	rmSetStatusText("",0.30);

	// 1st patches
	for (i=0; < 20*PlayerNum)
	{
		int patchID = rmCreateArea("first patch"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, true);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(10));
//		rmSetAreaTerrainType(patchID, paintLand5);
		rmSetAreaMix(patchID, paintMix3); 
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 13.0);
		rmSetAreaMaxBlobDistance(patchID, 30.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidPlateau);
//		rmBuildArea(patchID); 
	}
	
	// 2nd patches
	for (i=0; < 15*PlayerNum)
	{
		int patch2ID = rmCreateArea("second patch"+i);
		rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, true);
		rmSetAreaSize(patch2ID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(20));
		rmSetAreaTerrainType(patch2ID, paintLand5);
//		rmSetAreaMix(patch2ID, paintMix1); 
		rmAddAreaToClass(patch2ID, rmClassID("patch2"));
		rmSetAreaMinBlobs(patch2ID, 1);
		rmSetAreaMaxBlobs(patch2ID, 2);
		rmSetAreaMinBlobDistance(patch2ID, 1.0);
		rmSetAreaMaxBlobDistance(patch2ID, 10.0);
		rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, stayNearPlateau);	
		rmBuildArea(patch2ID); 
	}

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) {
		float xLoc = 0.00;
		float yLoc = 0.00;
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			xLoc = 0.75;
			yLoc = 0.25;
			}
		else {
			xLoc = 0.50;
			yLoc = 0.50;
			}

	//King's "Island"
		int kingislandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingislandID, rmAreaTilesToFraction(333));
		rmSetAreaLocation(kingislandID, xLoc, yLoc);
//		rmSetAreaMix(kingislandID, forTesting);
		rmSetAreaReveal(kingislandID, 01);
		rmAddAreaToClass(kingislandID, classIsland);
		rmSetAreaCoherence(kingislandID, 1.0);
		rmBuildArea(kingislandID); 
		
	// Place King's Hill
		float walk = 0.00;
	
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}

	// ____________________ Natives ____________________
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID(natType1);
	subCiv1 = rmGetCivID(natType2);
	rmSetSubCiv(0, natType1);
	rmSetSubCiv(1, natType2);

	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;

	int whichNative = rmRandInt(1,2);
	int whichVillage = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);
	int whichVillage4 = rmRandInt(1,5);
	
	nativeID0 = rmCreateGrouping("native A", natGrpName1+whichVillage);
	nativeID1 = rmCreateGrouping("native B", natGrpName1+whichVillage2);
	nativeID2 = rmCreateGrouping("native C", natGrpName2+whichVillage3);	
	nativeID3 = rmCreateGrouping("native D", natGrpName2+whichVillage4);	

	rmAddGroupingToClass(nativeID0, classNative);
	rmAddGroupingToClass(nativeID1, classNative);
	rmAddGroupingToClass(nativeID2, classNative);
	rmAddGroupingToClass(nativeID3, classNative);

	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.30);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.70, 0.50);
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.13, 0.70);
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.30, 0.87);
		}
	else {
		if (whichNative == 1) {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.50);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.50);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.40);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.50, 0.60);
			}
		if (whichNative == 2) {
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.40, 0.50);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.60, 0.50);
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.40);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.60);
			}
		}
	
	// Text
	rmSetStatusText("",0.40);

	// Avoidance Islands
	int midLineID=rmCreateArea("Mid Line");
	rmSetAreaSize(midLineID, 0.025);
	rmSetAreaLocation(midLineID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(midLineID, 0.10, 0.90, 0.90, 0.10);
//	rmSetAreaMix(midLineID, forTesting);
	rmSetAreaCoherence(midLineID, 1.00);
	rmBuildArea(midLineID); 

	int avoidMidLine = rmCreateAreaDistanceConstraint("avoid mid line ", midLineID, 8.0);
	int avoidMidLineMin = rmCreateAreaDistanceConstraint("avoid mid line min", midLineID, 0.5);
	int avoidMidLineFar = rmCreateAreaDistanceConstraint("avoid mid line far", midLineID, 16.0);
	int stayMidLine = rmCreateAreaMaxDistanceConstraint("stay mid line ", midLineID, 0.0);
	
	int midIslandID=rmCreateArea("Mid Island");
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmSetAreaSize(midIslandID, 0.35+0.01*PlayerNum);
	else
		rmSetAreaSize(midIslandID, 0.35);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
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
	rmSetAreaCoherence(midSmIslandID, 0.75);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);
	
	// ____________________ Starting Resources ____________________
	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
	rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(TCID, classStartingResource);
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 0.0);

	// Starting mines
	int playerGoldID = rmCreateObjectDef("player mine");
	if (PlayerNum == 2)
		rmAddObjectDefItem(playerGoldID, "minetin", 1, 0);
	else
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 14.0);
	rmSetObjectDefMaxDistance(playerGoldID, 14.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidNativesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteMin);
	if (PlayerNum <= 4)
		rmAddObjectDefConstraint(playerGoldID, avoidMidIslandMin);
	else
		rmAddObjectDefConstraint(playerGoldID, stayMidIsland);

	// 2nd mine
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 30.0); 
	rmSetObjectDefMaxDistance(playerGold2ID, 30.0); 
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidNatives);
	rmAddObjectDefConstraint(playerGold2ID, avoidGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold2ID, avoidMidIsland);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteMin);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType2, 1, 0.0);
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 22);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShorter);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerTreeID, avoidNativesShort);

	int playerTree2ID = rmCreateObjectDef("second trees");
	rmAddObjectDefItem(playerTree2ID, treeType3, 2, 2.0);
    rmSetObjectDefMinDistance(playerTree2ID, 16);
    rmSetObjectDefMaxDistance(playerTree2ID, 22);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidNativesShort);

	int playerTree3ID = rmCreateObjectDef("third trees");
	rmAddObjectDefItem(playerTree3ID, treeType1, 10, 8.0);
	rmAddObjectDefItem(playerTree3ID, treeType4, 4, 6.0);
    rmSetObjectDefMinDistance(playerTree3ID, 40);
    rmSetObjectDefMaxDistance(playerTree3ID, 44);
	rmAddObjectDefToClass(playerTree3ID, classStartingResource);
	rmAddObjectDefToClass(playerTree3ID, classForest);
	rmAddObjectDefConstraint(playerTree3ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree3ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTree3ID, avoidNativesVeryFar);
	rmAddObjectDefConstraint(playerTree3ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerTree3ID, avoidMidIslandFar);
	rmAddObjectDefConstraint(playerTree3ID, avoidGoldTypeShort);

	// Starting herd
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, food1, 6, 3.0);
	rmSetObjectDefMinDistance(playerHerdID, 12.0);
	rmSetObjectDefMaxDistance(playerHerdID, 12.0);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerdID, avoidTradeRouteSocketShort);

	// 2nd herd
	int playerHerd2ID = rmCreateObjectDef("2nd herd");
    rmAddObjectDefItem(playerHerd2ID, food2, 12, 4.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 30);
    rmSetObjectDefMaxDistance(playerHerd2ID, 30);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketShort);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerHerd2ID, avoidHuntZoneN);
		rmAddObjectDefConstraint(playerHerd2ID, avoidHuntZoneS);
		}
	if (TeamNum == 2 && teamZeroCount == teamOneCount && PlayerNum > 2)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIslandMin);
	else
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIslandFar);

	// 3rd herd
	int playerHerd3ID = rmCreateObjectDef("3rd herd");
    rmAddObjectDefItem(playerHerd3ID, food1, 12, 6.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 42);
    rmSetObjectDefMaxDistance(playerHerd3ID, 42);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResourcesShort);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerHerd3ID, avoidHuntZoneN);
		rmAddObjectDefConstraint(playerHerd3ID, avoidHuntZoneS);
		}
	rmAddObjectDefConstraint(playerHerd3ID, avoidMidIslandFar);
	
	// Starting berries
	int playerBerriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerBerriesID, 10.0);
	rmSetObjectDefMaxDistance(playerBerriesID, 12.0);
	rmAddObjectDefToClass(playerBerriesID, classStartingResource);
	rmAddObjectDefConstraint(playerBerriesID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerBerriesID, avoidStartingResourcesShort);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 30-PlayerNum);
	rmSetObjectDefMaxDistance(playerNuggetID, 30);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIsland);

	// Place Starting units & Resources

	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (TeamNum == 2 && PlayerNum > 4 || TeamNum > 2 || teamZeroCount != teamOneCount)
			rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (TeamNum > 2 || teamOneCount != teamZeroCount)
			rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerBerriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}

	// ____________________ Mines ____________________
	// Static Mines
	if (PlayerNum <= 4 && TeamNum == 2 && teamZeroCount == teamOneCount) {
		int staticGoldID = rmCreateObjectDef("static mines");
		if (PlayerNum > 2)
			rmAddObjectDefItem(staticGoldID, "mine", 1, 0.0);
		else
			rmAddObjectDefItem(staticGoldID, "minetin", 1, 0.0);
		rmSetObjectDefMinDistance(staticGoldID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticGoldID, rmXFractionToMeters(0.025));
		rmAddObjectDefToClass(staticGoldID, classGold);
		rmAddObjectDefConstraint(staticGoldID, avoidPlateau);
		rmAddObjectDefConstraint(staticGoldID, avoidWaterShort);
		rmAddObjectDefConstraint(staticGoldID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(staticGoldID, avoidNativesShort);
		if (PlayerNum > 2) {
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.35, 0.45);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.55, 0.65);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.40, 0.10);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.90, 0.60);
			}
		else {
			if (spawnChooser == 2) {
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.30, 0.30);
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.70, 0.70);
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.45, 0.20);
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.80, 0.55);
				}
			else {
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.35, 0.40);
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.60, 0.65);
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.35, 0.15);
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.85, 0.65);
				}
			}
		}

	// Plateau Mines
	int plateaugoldID = rmCreateObjectDef("plateau mines");
		rmAddObjectDefItem(plateaugoldID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(plateaugoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(plateaugoldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(plateaugoldID, classGold);
		if (PlayerNum <= 4 && TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddObjectDefConstraint(plateaugoldID, avoidGoldType);
		else if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddObjectDefConstraint(plateaugoldID, avoidGold);
		else
			rmAddObjectDefConstraint(plateaugoldID, avoidGoldFar);
		if (PlayerNum == 2)
			rmAddObjectDefConstraint(plateaugoldID, avoidMidLineMin);
		rmAddObjectDefConstraint(plateaugoldID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(plateaugoldID, stayInPlateau);
		rmAddObjectDefConstraint(plateaugoldID, avoidNatives);
		rmAddObjectDefConstraint(plateaugoldID, avoidIslandMin);
		rmPlaceObjectDefAtLoc(plateaugoldID, 0, 0.50, 0.50, 2+2*PlayerNum);

	// ____________________ Hunts ____________________
	// Static Herds 
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		int staticherdID = rmCreateObjectDef("static herd");
		rmAddObjectDefItem(staticherdID, food2, 10+PlayerNum, 3+PlayerNum/2);
		rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.015));
		rmSetObjectDefCreateHerd(staticherdID, true);
		rmAddObjectDefConstraint(staticherdID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(staticherdID, avoidNativesShort);
	//	rmAddObjectDefConstraint(staticherdID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(staticherdID, avoidWaterShort);
		rmAddObjectDefConstraint(staticherdID, avoidPlateau);
		if (PlayerNum <= 4) {
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.40, 0.10);
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.90, 0.60);
			}
		else {
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.05, 0.65);
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.35, 0.95);
			}
		rmPlaceObjectDefAtLoc(staticherdID, 0, 0.20, 0.65);
		rmPlaceObjectDefAtLoc(staticherdID, 0, 0.35, 0.80);
		}

	// South Herds 
	int southherdID = rmCreateObjectDef("south herd");
		rmAddObjectDefItem(southherdID, food3, 10, 4.0);
		rmSetObjectDefMinDistance(southherdID, 0.0);
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(southherdID, rmXFractionToMeters(0.015));
		else
			rmSetObjectDefMaxDistance(southherdID, rmXFractionToMeters(0.45));
		rmSetObjectDefCreateHerd(southherdID, true);
		rmAddObjectDefConstraint(southherdID, avoidGoldMin);
		rmAddObjectDefConstraint(southherdID, avoidHunt2Min);
		rmAddObjectDefConstraint(southherdID, avoidHunt1Min);
		rmAddObjectDefConstraint(southherdID, avoidIslandShort);
		rmAddObjectDefConstraint(southherdID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(southherdID, avoidPlateau);
		rmAddObjectDefConstraint(southherdID, avoidNativesShort);
		if (PlayerNum == 2) {
			if (spawnChooser == 3) {
				rmPlaceObjectDefAtLoc(southherdID, 0, 0.35, 0.50);	
				rmPlaceObjectDefAtLoc(southherdID, 0, 0.30, 0.20);	
				}
			else {
				rmPlaceObjectDefAtLoc(southherdID, 0, 0.40, 0.40);	
				rmPlaceObjectDefAtLoc(southherdID, 0, 0.40, 0.25);	
				}
			}
		else if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(southherdID, avoidHunt3Med);
			rmAddObjectDefConstraint(southherdID, stayHuntZoneS);
			rmPlaceObjectDefAtLoc(southherdID, 0, 0.50, 0.50, PlayerNum);	
			}
		else {
			rmAddObjectDefConstraint(southherdID, avoidHunt3Far);
			rmAddObjectDefConstraint(southherdID, avoidStartingResources);
			rmAddObjectDefConstraint(southherdID, avoidTownCenterFar);
			rmPlaceObjectDefAtLoc(southherdID, 0, 0.50, 0.50, 2*PlayerNum);	
			}
		
	// North Herds 
	int northherdID = rmCreateObjectDef("north herd");
		rmAddObjectDefItem(northherdID, food3, 10, 4.0);
		rmSetObjectDefMinDistance(northherdID, 0.0);
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(northherdID, rmXFractionToMeters(0.015));
		else
			rmSetObjectDefMaxDistance(northherdID, rmXFractionToMeters(0.45));
		rmSetObjectDefCreateHerd(northherdID, true);
		rmAddObjectDefConstraint(northherdID, avoidGoldMin);
		rmAddObjectDefConstraint(northherdID, avoidHunt2Min);
		rmAddObjectDefConstraint(northherdID, avoidHunt1Min);
		rmAddObjectDefConstraint(northherdID, avoidIslandShort);
		rmAddObjectDefConstraint(northherdID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(northherdID, avoidPlateau);
		rmAddObjectDefConstraint(northherdID, avoidNativesShort);
		if (PlayerNum == 2) {
			if (spawnChooser == 3) {
				rmPlaceObjectDefAtLoc(northherdID, 0, 0.50, 0.65);	
				rmPlaceObjectDefAtLoc(northherdID, 0, 0.80, 0.70);	
				}
			else {
				rmPlaceObjectDefAtLoc(northherdID, 0, 0.60, 0.60);	
				rmPlaceObjectDefAtLoc(northherdID, 0, 0.75, 0.60);	
				}
			}
		else if(TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(northherdID, avoidHunt3Med);
			rmAddObjectDefConstraint(northherdID, stayHuntZoneN);
			rmPlaceObjectDefAtLoc(northherdID, 0, 0.50, 0.50, PlayerNum);
			}
		else {
			rmAddObjectDefConstraint(northherdID, avoidHunt3Far);
			rmAddObjectDefConstraint(northherdID, avoidStartingResources);
			rmAddObjectDefConstraint(northherdID, avoidTownCenterFar);
			rmPlaceObjectDefAtLoc(northherdID, 0, 0.50, 0.50, 2*PlayerNum);
			}

	// Text
	rmSetStatusText("",0.50);

	// ____________________ Forest1 ____________________
	int mainforestcount = 6+6*PlayerNum;
	int stayInForestPatch = -1;
	int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 4.0);

	for (i=0; < mainforestcount)
    {
		int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(99));
        rmSetAreaMix(forestpatchID, paintMix4);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidStartingResources);
		rmAddAreaConstraint(forestpatchID, avoidNativesShort);
		rmAddAreaConstraint(forestpatchID, avoidHunt1Short);
		rmAddAreaConstraint(forestpatchID, avoidHunt2Short);
		rmAddAreaConstraint(forestpatchID, avoidHunt3Short);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocketShort);
		rmAddAreaConstraint(forestpatchID, avoidPlateauFar);
		rmAddAreaConstraint(forestpatchID, avoidForest);
		rmAddAreaConstraint(forestpatchID, avoidGoldTypeMin);
		rmAddAreaConstraint(forestpatchID, avoidNuggetMin);
		rmAddAreaConstraint(forestpatchID, avoidIslandShort);
		rmAddAreaConstraint(forestpatchID, treeWater);
        rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
			rmAddObjectDefItem(foresttreeID, treeType1, 4, 8.0);
			rmAddObjectDefItem(foresttreeID, treeType4, 2, 6.0);
			rmSetObjectDefMinDistance(foresttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(foresttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(foresttreeID, avoidPlateauShort);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);

		int foresttree2ID = rmCreateObjectDef("second forest trees"+i);
			rmAddObjectDefItem(foresttree2ID, treeType1, 2, 5.0);
			rmAddObjectDefItem(foresttree2ID, treeType4, 1, 4.0);
			rmSetObjectDefMinDistance(foresttree2ID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(foresttree2ID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttree2ID, classForest);
			rmAddObjectDefConstraint(foresttree2ID, avoidImpassableLandMin);
			rmAddObjectDefConstraint(foresttree2ID, avoidPlateauShort);
			rmAddObjectDefConstraint(foresttree2ID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttree2ID, 0, 0.50, 0.50);
    }

	rmSetStatusText("",0.60);

	// ____________________ Mountains ____________________
	for (i=0; <2+4*PlayerNum)
	{
		int mountainID=rmCreateArea("mountain"+i);
		rmSetAreaSize(mountainID, 0.0005, 0.001);
		rmSetAreaCliffType(mountainID, mntType);  
		rmSetAreaTerrainType(mountainID, cliffPaint);
		rmSetAreaWarnFailure(mountainID, false);
		rmAddAreaToClass(mountainID, rmClassID("Cliffs"));
		rmSetAreaObeyWorldCircleConstraint(mountainID, false);
		rmSetAreaCliffHeight(mountainID, rmRandInt(4,10), 0.0, 0.4);
		rmSetAreaCliffEdge(mountainID, 1, 1.0, 0.0, 0.0, 1);
		rmSetAreaCoherence(mountainID, 0.35);
		rmSetAreaSmoothDistance(mountainID, 5);
		rmAddAreaConstraint(mountainID, avoidGoldTypeMin);
		rmAddAreaConstraint(mountainID, stayInPlateau);
		rmAddAreaConstraint(mountainID, avoidCliffFar);
		rmAddAreaConstraint(mountainID, avoidNativesFar);
		rmAddAreaConstraint(mountainID, avoidIsland);
		if (rmGetIsKOTH() == false)
			rmBuildArea(mountainID);
	}

	rmSetStatusText("",0.70);

	// ____________________ Forest2 ____________________
	int secondforestcount = 2+2*PlayerNum;
	int stayIn2ndForest = -1;

	for (i=0; < secondforestcount)
	{
		int secondforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondforestID, false);
		rmSetAreaSize(secondforestID, rmAreaTilesToFraction(33));
        rmSetAreaMix(secondforestID, paintMix3);
		rmSetAreaObeyWorldCircleConstraint(secondforestID, true);
		rmSetAreaCoherence(secondforestID, 0.2);
		rmSetAreaSmoothDistance(secondforestID, 4);
		rmAddAreaConstraint(secondforestID, avoidIslandShort);
		rmAddAreaConstraint(secondforestID, avoidForestMed);
		rmAddAreaConstraint(secondforestID, avoidGoldMin);
		rmAddAreaConstraint(secondforestID, avoidNatives);
		rmAddAreaConstraint(secondforestID, avoidHunt2Min);
		rmAddAreaConstraint(secondforestID, avoidHunt1Min);
		rmAddAreaConstraint(secondforestID, avoidImpassableLandMin);
		rmAddAreaConstraint(secondforestID, stayNearPlateau);
		rmAddAreaConstraint(secondforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(secondforestID, avoidNuggetMin);
		rmAddAreaConstraint(secondforestID, avoidCliff);		
		rmAddAreaConstraint(secondforestID, treeWater);		
		rmBuildArea(secondforestID);

		stayIn2ndForest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondforestID, 0);

		int secondforesttreeID = rmCreateObjectDef("secondary forest trees"+i);
			rmAddObjectDefItem(secondforesttreeID, treeType2, 1, 5.0);
			rmAddObjectDefItem(secondforesttreeID, treeType3, 1, 5.0);
			rmSetObjectDefMinDistance(secondforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(secondforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(secondforesttreeID, classForest);
			rmAddObjectDefConstraint(secondforesttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(secondforesttreeID, stayIn2ndForest);
			rmPlaceObjectDefAtLoc(secondforesttreeID, 0, 0.50, 0.50, 2);
	}

	// Text
	rmSetStatusText("",0.80);

	// ____________________ Random Trees ____________________
	float rdmTree1 = rmRandInt(0,2);
	float rdmTree2 = rmRandInt(0,2);

	int randomtreeID = rmCreateObjectDef("random tree");
		rmAddObjectDefItem(randomtreeID, treeType1, rdmTree1, 3.0);
		rmAddObjectDefItem(randomtreeID, treeType2, 2-rdmTree1, 3.0);
		rmAddObjectDefItem(randomtreeID, treeType3, rdmTree2, 3.0);
		rmAddObjectDefItem(randomtreeID, treeType4, 2-rdmTree2, 3.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestMin);
		rmAddObjectDefConstraint(randomtreeID, avoidHunt1Min);
		rmAddObjectDefConstraint(randomtreeID, avoidHunt2Min);
		rmAddObjectDefConstraint(randomtreeID, avoidHunt3Min);
		rmAddObjectDefConstraint(randomtreeID, avoidNativesShort);
		rmAddObjectDefConstraint(randomtreeID, avoidIslandShort);
		rmAddObjectDefConstraint(randomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomtreeID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(randomtreeID, avoidPlateau);
		rmAddObjectDefConstraint(randomtreeID, avoidNuggetMin);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50, 8*PlayerNum);

	// ____________________ Treasures ____________________
	// Treasures L3
	int Nugget3ID = rmCreateObjectDef("Nugget lvl 3");
	rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget3ID, 0);
    rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.45));
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetShort);
	else
		rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
	rmAddObjectDefConstraint(Nugget3ID, stayInPlateau);
	rmAddObjectDefConstraint(Nugget3ID, avoidCliff);
	rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidHunt1Min);
	rmAddObjectDefConstraint(Nugget3ID, avoidHunt2Min);
	rmAddObjectDefConstraint(Nugget3ID, avoidHunt3Min);
	rmAddObjectDefConstraint(Nugget3ID, avoidIslandMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
	rmAddObjectDefConstraint(Nugget3ID, avoidNativesShort);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
	if (PlayerNum > 4 && rmGetIsTreaty() == false) {
		rmSetNuggetDifficulty(4,4);
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, PlayerNum/2);
		}
	rmSetNuggetDifficulty(3,3);
	rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, PlayerNum);

	// Treasures L2
	int Nugget2ID = rmCreateObjectDef("Nugget lvl 2");
	rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget2ID, 0);
	if (PlayerNum == 2) 
    	rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.05));
	else
	    rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.50));
	rmSetNuggetDifficulty(2,2);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidNativesShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidPlateauShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidHunt3Min);
	rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min);
	rmAddObjectDefConstraint(Nugget2ID, avoidHunt1Min);
	rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidWaterMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
	if (PlayerNum == 2) {
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.28, 0.60);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.40, 0.72);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.40, 0.40);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.60, 0.60);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.40, 0.10);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.90, 0.60);
		}
	else {
		rmAddObjectDefConstraint(Nugget2ID, avoidIslandFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, 3*PlayerNum);
		}

	// Text
	rmSetStatusText("",0.90);

	// ____________________ Embellishments ____________________
	// Plains embellishments
	int PlainsunderbrushID = rmCreateObjectDef("plains embellishments");
		rmAddObjectDefItem(PlainsunderbrushID, "UnderbrushTexasGrass", rmRandInt(4,6), 10.0);
		rmSetObjectDefMinDistance(PlainsunderbrushID, 0);
		rmSetObjectDefMaxDistance(PlainsunderbrushID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(PlainsunderbrushID, rmClassID("grass"));
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidNatives);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidForestMin);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidNuggetMin);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidHunt1Min);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidHunt2Min);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidHunt3Min);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidPlateau);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidEmbellishment);
		rmAddObjectDefConstraint(PlainsunderbrushID, avoidIslandMin);
		rmPlaceObjectDefAtLoc(PlainsunderbrushID, 0, 0.50, 0.50, 5*PlayerNum);

	// Plateau embellishments
	int PlateauunderbrushID = rmCreateObjectDef("plateau embellishments");
		rmAddObjectDefItem(PlateauunderbrushID, "UnderbrushPampas", rmRandInt(2,3), 6.0);
		rmSetObjectDefMinDistance(PlateauunderbrushID, 0);
		rmSetObjectDefMaxDistance(PlateauunderbrushID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(PlateauunderbrushID, rmClassID("grass"));
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidGoldMin);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidEmbellishment);
		rmAddObjectDefConstraint(PlateauunderbrushID, stayInPlateau);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidIslandMin);
//		rmAddObjectDefConstraint(PlateauunderbrushID, avoidCliff);
		rmPlaceObjectDefAtLoc(PlateauunderbrushID, 0, 0.50, 0.50, 4*PlayerNum);

	// Text
	rmSetStatusText("",1.00);

} // END