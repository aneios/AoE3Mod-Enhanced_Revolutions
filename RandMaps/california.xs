// CALIFORNIA

// JANUARY 2006
// Dec 06 - YP update
//Updated 1v1 balance by Durokan for DE
// edited by by vividlyplain, October 2021

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
	// Strings
	string wetType = "california coast";	
	string paintMix1 = "california_grass";
	string paintMix2 = "california_desert0";
	string paintMix3 = "california_desert";
	string paintMix4 = "california_desert2";
	string paintMix5 = "california_desert3";
	string paintMix6 = "california_grassrocks";
	string paintMix7 = "california_madrone_forest";
	string paintMix8 = "california_shoregrass";
	string paintMix9 = "desertforestflr_cal";
	string paintLand1 = "california\ground5_cal";
	string paintLand2 = "california\ground4_cal";
	string paintLand3 = "california\desert6_cal";
	string paintLand4 = "california\desert5_cal";
	string mntType = "California";	
	string impPaint = "bayou\ground4a_bay";	
	string cliffPaint1 = "california\ground5_cal";	
	string cliffPaint2 = "california\ground4_cal";	
	string cliffPaint3 = "california\desert6_cal";	
	string cliffPaint4 = "california\desert5_cal";	
	string forTesting = "testmix";	 
	string treasureSet = "california";
	string shineAlight = "California_Skirmish";
	string toiletPaper1 = "dirt";
	string food1 = "elk";
	string food2 = "deer";
	string food3 = "pronghorn";
	string fishies = "FishSalmon";
	string treeType1 = "TreeRedwoodChonky";
	string treeType2 = "TreeMadrone";
	string treeType3 = "TreeSonora";
	string treeType4 = "TreeGreatLakes";
	string brushType1 = "UnderbrushCalifornia";
	string brushType2 = "UnderbrushTexas";
	string brushType3 = "UnderbrushTexasGrass";
	string cattleType = "sheep";
	string natType1 = "Klamath";
	string natType2 = "Nootka";
	string natGrpName1 = "native Klamath village ";
	string natGrpName2 = "native nootka village ";

	// map size
	if (rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1) && cNumberTeams == 2)
	{
		int playerTiles=11820;
		if (PlayerNum > 2)
			playerTiles=11000;
		if (PlayerNum > 4)
			playerTiles=10000;
		if (PlayerNum > 6)
			playerTiles=9000;
	}
	else
		playerTiles=13000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);

	if (rmGetIsTreaty() == true)
	{
		playerTiles = 13000;
		if (cNumberNonGaiaPlayers < 3)
			size = 2.3 * sqrt(cNumberNonGaiaPlayers * playerTiles);
		else if (cNumberNonGaiaPlayers < 5)
			size = 2.15 * sqrt(cNumberNonGaiaPlayers * playerTiles);
		else if (cNumberNonGaiaPlayers < 7)
			size = 2.1 * sqrt(cNumberNonGaiaPlayers * playerTiles);
		else
			size = 2.0 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	}

	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);	
		
	// Make the corners.
		rmSetWorldCircleConstraint(true);
			
	// Picks a default water height
		rmSetSeaLevel(2.0);	
		rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0); 
		rmSetMapElevationHeightBlend(0.2);
		
	// Picks default terrain and water
		rmSetSeaType(wetType);
		rmTerrainInitialize(paintLand1, 0.0); 		
		rmSetMapType(treasureSet); 
		rmSetMapType("grass");
		rmSetMapType("water");
		rmSetLightingSet(shineAlight); 
//		rmSetGlobalRain(0.333);
//		rmSetOceanReveal(true);
		
	// Choose Mercs
		chooseMercs();
		
	// Text
		rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
		int classPlayer = rmDefineClass("Players");
		int classPatch = rmDefineClass("patch");
		int classPatch2 = rmDefineClass("patch2");
		int classPatch3 = rmDefineClass("patch3");
		int classPatch4 = rmDefineClass("patch4");
		rmDefineClass("startingUnit");
		int classForest = rmDefineClass("Forest");
		int importantItem = rmDefineClass("importantItem");
		int classNative = rmDefineClass("natives");
		int classSwamp = rmDefineClass("Swamp");
		int classIsland = rmDefineClass("Island");
		int classIsland2 = rmDefineClass("Island2");
		int classPlateau = rmDefineClass("plateau");
		int classGold = rmDefineClass("Gold");
		int classStartingResource = rmDefineClass("startingResource");
		
	// ____________________ Constraints ____________________	
	// Cardinal Directions & Map placement
		int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(1.0), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.25), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
		int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.10), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));

	// Resource avoidance
		int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 30.0); 
		int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 24.0);  
		int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 18.0); 
		int avoidForestShorter=rmCreateClassDistanceConstraint("avoid forest shorter", rmClassID("Forest"), 8.0); 
		int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
		int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 60.0);
		int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 45.0);
		int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 30.0);
		int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 4.0);
		int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 60.0);
		int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 45.0);
		int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 30.0);
		int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt2 min", food2, 4.0);
		int avoidHunt3Far = rmCreateTypeDistanceConstraint("avoid hunt3 far", food3, 60.0);
		int avoidHunt3 = rmCreateTypeDistanceConstraint("avoid hunt3", food3, 45.0);
		int avoidHunt3Short = rmCreateTypeDistanceConstraint("avoid hunt3 short", food3, 30.0);
		int avoidHunt3Min = rmCreateTypeDistanceConstraint("avoid hunt3 min", food3, 4.0);
		int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 50.0);
		int avoidBerriesMed = rmCreateTypeDistanceConstraint("avoid  berries med", "berrybush", 40.0);
		int avoidBerries = rmCreateTypeDistanceConstraint("avoid  berries", "berrybush", 30.0);
		int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid  berries short", "berrybush", 20.0);
		int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min", "berrybush", 4.0);
		int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 8.0);
		int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 12.0);
		int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 26.0);
		int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 38.0);
		int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 4.0);
		int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 32.0);
		int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50.0);
		int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 64.0);
		int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 24.0);
		int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
		int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget avoid nugget far", "AbstractNugget", 64.0);
		int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", fishies, 14);
		int avoidFishShort=rmCreateTypeDistanceConstraint("avoid fish short", fishies, 8);
		int avoidFishMin=rmCreateTypeDistanceConstraint("avoid fish min", fishies, 2);
		int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "MinkeWhale", 40);
		int avoidWhaleMin=rmCreateTypeDistanceConstraint("avoid whale min", "MinkeWhale", 4);
		
		int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 82.0);
		int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 64.0);
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 52.0);
		int avoidTownCenterMed=rmCreateTypeDistanceConstraint(" avoid Town Center med", "townCenter", 30.0);
		int avoidTownCenterShort=rmCreateTypeDistanceConstraint(" avoid Town Center short", "townCenter", 20.0);
		int avoidTownCenterResources=rmCreateTypeDistanceConstraint(" avoid Town Center", "townCenter", 40.0);
		int avoidNativesMin = rmCreateClassDistanceConstraint("stuff avoids natives min", rmClassID("natives"), 2.0);
		int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", rmClassID("natives"), 4.0);
		int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
		int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 12.0);
		int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resource", rmClassID("startingResource"), 8.0);
		int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resource short", rmClassID("startingResource"), 4.0);
		int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
		int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
		int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
		int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
		int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 8.0);
		int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("avoid trade route socket min", "socketTradeRoute", 4.0);
		
	// Land and terrain constraints
		int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
		int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 8.0);
		int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
		int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 1.0);
		int avoidImpassableLandZero=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 0.2);
		int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 8);
		int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 12.0);
		int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
		int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 4.0);
		int avoidWaterMin = rmCreateTerrainDistanceConstraint("avoid water min", "water", true, 2.0);
		int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 24.0);
		int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch 2", rmClassID("patch2"), 40.0);
		int avoidPatch3 = rmCreateClassDistanceConstraint("patch avoid patch 3", rmClassID("patch3"), 24.0);
		int avoidPatch4 = rmCreateClassDistanceConstraint("patch avoid patch 4", rmClassID("patch4"), 24.0);
		int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
		int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 12.0);
		int avoidLandShort = rmCreateTerrainDistanceConstraint("avoid land short ", "Land", true, 4.0);
		int avoidLandMin = rmCreateTerrainDistanceConstraint("avoid land min ", "Land", true, 2.0);
		int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 2.0);
		int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 4.0);
		int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 8.0);
		int avoidIsland2=rmCreateClassDistanceConstraint("avoid island2", classIsland2, 8.0);
		int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 12.0);
		int avoidPlateauMin=rmCreateClassDistanceConstraint("avoid plateau min", classPlateau, 2.0);
		int avoidPlateauShort=rmCreateClassDistanceConstraint("avoid plateau short", classPlateau, 4.0);
		int avoidPlateau=rmCreateClassDistanceConstraint("avoid plateau", classPlateau, 8.0);
		int avoidPlateauFar=rmCreateClassDistanceConstraint("avoid plateau far", classPlateau, 36.0);

	// Unit avoidance
		int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
		int avoidColonyShip=rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 8.0);
		int avoidColonyShipShort = rmCreateTypeDistanceConstraint("avoid colony ship short", "HomeCityWaterSpawnFlag", 4.0);		

	// ____________________ Player Placement ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	float OneVOnePlacement=rmRandFloat(0.0, 0.9);
	int team1 = rmRandInt(0,1);
	int team2 = -1;
	if (team1 == 0)
		team2 = 1;
	else
		team2 = 0;

		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount) // 1v1 and even teams
		{
			if (rmGetIsTreaty() == true)
			{
				if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
				{
					rmSetPlacementTeam(team1);
					rmSetPlacementSection(0.125, 0.126); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
	
					rmSetPlacementTeam(team2);
					rmSetPlacementSection(0.625, 0.626); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);	
				}
				else
				{
					rmSetPlacementTeam(team1);
					rmSetPlacementSection(0.125-0.015*PlayerNum, 0.125+0.015*PlayerNum); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34+0.005*PlayerNum, 0.34+0.005*PlayerNum, 0);
	
					rmSetPlacementTeam(team2);
					rmSetPlacementSection(0.625-0.015*PlayerNum, 0.625+0.015*PlayerNum); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34+0.005*PlayerNum, 0.34+0.005*PlayerNum, 0);	
				}
			}
			else
			{
				if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
				{
					rmSetPlacementTeam(team1);
					rmSetPlacementSection(0.00, 0.01); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(team2);
					rmSetPlacementSection(0.50, 0.51); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);	
				}
				if (teamZeroCount == 2 && teamOneCount == 2) // 2v2
				{
					rmSetPlacementTeam(team1);
					rmSetPlacementSection(0.44, 0.52); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0);

					rmSetPlacementTeam(team2);
					rmSetPlacementSection(0.98, 0.06); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0);	
				}
				if (teamZeroCount == 3 && teamOneCount == 3) // 3v3
				{
					rmSetPlacementTeam(team1);
					rmSetPlacementSection(0.41, 0.53); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.37, 0.37, 0);

					rmSetPlacementTeam(team2);
					rmSetPlacementSection(0.97, 0.09); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.37, 0.37, 0);	
				}
				if (teamZeroCount == 4 && teamOneCount == 4) // 4v4
				{
					rmSetPlacementTeam(team1);
					rmSetPlacementSection(0.39, 0.55); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(team2);
					rmSetPlacementSection(0.95, 0.11); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);	
				}
			}
		}
		else if (teamZeroCount != teamOneCount && TeamNum == 2)
		{
			if (teamZeroCount == 1 || teamOneCount == 1)
			{
				if (teamZeroCount < teamOneCount) 	// 1v7, 1v6, etc
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.50, 0.51); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);

					rmSetPlacementTeam(1);
					if (teamOneCount == 2)
					{
						rmSetPlacementSection(0.98, 0.05); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);	
					}
					else
					{
						rmSetPlacementSection(0.95, 0.11); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.39, 0.39, 0);	
					}
				}
				else 								// 7v1, etc 
				{
					rmSetPlacementTeam(0);
					if (teamZeroCount == 2)
					{
						rmSetPlacementSection(0.45, 0.52); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);	
					}
					else
					{
						rmSetPlacementSection(0.39, 0.55); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.39, 0.39, 0);	
					}

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.00, 0.01); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);
				}
			}
			else 
			{
				if (teamZeroCount < teamOneCount) 	// 2v6, 3v5, etc
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.45, 0.52); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.95, 0.13); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);	
				}
				else 								// 6v2, 5v3, etc 
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.37, 0.55); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);	

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.97, 0.05); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.39, 0.39, 0);					
				}
			}
		}
		else // FFA
		{
			rmSetTeamSpacingModifier(0.50);
			rmSetPlacementSection(0.95, 0.55); 
			rmPlacePlayersCircular(0.39, 0.39, 0);		
		}
	
	// Text
		rmSetStatusText("",0.20);
	
	// ____________________ Map Parameters ____________________
	// Main Land
	int mainLandID = rmCreateArea("main land");
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
	{
		rmSetAreaSize(mainLandID, 0.99);
		rmSetAreaLocation(mainLandID, 0.50, 0.50);
		rmSetAreaBaseHeight(mainLandID, -1.0);
	}
	else
	{
		rmSetAreaSize(mainLandID, 0.70);
		rmSetAreaLocation(mainLandID, 1.00, 0.50);
		rmSetAreaBaseHeight(mainLandID, 1.0);
	}
	rmSetAreaMix(mainLandID, paintMix1);
	rmSetAreaWarnFailure(mainLandID, false);
	rmSetAreaCoherence(mainLandID, 0.95); 
	rmSetAreaElevationType(mainLandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainLandID, 0.25);
	rmSetAreaElevationMinFrequency(mainLandID, 0.04);
	rmSetAreaElevationOctaves(mainLandID, 3);
	rmSetAreaElevationPersistence(mainLandID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(mainLandID, false);
	rmBuildArea(mainLandID);
	
	int avoidMainLandMin = rmCreateAreaDistanceConstraint("avoid main land min", mainLandID, 0.01);
	int stayMainLand = rmCreateAreaMaxDistanceConstraint("stay in main land", mainLandID, 0.0);

	int spurID = rmCreateArea("spur");
	rmSetAreaSize(spurID, 0.40);
	rmSetAreaLocation(spurID, 0.50, 0.50);
	rmSetAreaMix(spurID, paintMix1);
	rmSetAreaWarnFailure(spurID, false);
	rmSetAreaCoherence(spurID, 0.95); 
	rmSetAreaElevationType(spurID, cElevTurbulence);    
	rmSetAreaObeyWorldCircleConstraint(spurID, false);
	if (rmGetIsTreaty() == false && teamOneCount == teamZeroCount && TeamNum == 2)
		rmBuildArea(spurID);
	if (TeamNum != 2 || teamOneCount != teamZeroCount)
		rmBuildArea(spurID);

	int avoidSpur = rmCreateAreaDistanceConstraint("avoid spur", spurID, 0.01);
	int staySpur = rmCreateAreaMaxDistanceConstraint("stay in spur", spurID, 0.0);

	// Terrain Layers
	int terrainLayerID = rmCreateArea("terrain layer");
	rmSetAreaSize(terrainLayerID, 0.26);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmSetAreaLocation(terrainLayerID, 0.90, 0.10);
	else
		rmSetAreaLocation(terrainLayerID, 0.90, 0.50);
	rmSetAreaMix(terrainLayerID, paintMix6);
	rmSetAreaWarnFailure(terrainLayerID, false);
	rmSetAreaCoherence(terrainLayerID, 0.666); 
	rmSetAreaObeyWorldCircleConstraint(terrainLayerID, false);
	rmAddAreaConstraint(terrainLayerID, stayMainLand);
	rmBuildArea(terrainLayerID);

	int terrainLayer2ID = rmCreateArea("terrain layer2");
	rmSetAreaSize(terrainLayer2ID, 0.22);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmSetAreaLocation(terrainLayer2ID, 0.90, 0.10);
	else
		rmSetAreaLocation(terrainLayer2ID, 0.90, 0.50);
	rmSetAreaMix(terrainLayer2ID, paintMix5);
	rmSetAreaWarnFailure(terrainLayer2ID, false);
	rmSetAreaCoherence(terrainLayer2ID, 0.666); 
	rmSetAreaObeyWorldCircleConstraint(terrainLayer2ID, false);
	rmAddAreaConstraint(terrainLayer2ID, stayMainLand);
	rmBuildArea(terrainLayer2ID);
	
	int terrainLayer3ID = rmCreateArea("terrain layer3");
	rmSetAreaSize(terrainLayer3ID, 0.18);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmSetAreaLocation(terrainLayer3ID, 0.90, 0.10);
	else
		rmSetAreaLocation(terrainLayer3ID, 0.90, 0.50);
	rmSetAreaMix(terrainLayer3ID, paintMix4);
	rmSetAreaWarnFailure(terrainLayer3ID, false);
	rmSetAreaCoherence(terrainLayer3ID, 0.666); 
	rmSetAreaObeyWorldCircleConstraint(terrainLayer3ID, false);
	rmAddAreaConstraint(terrainLayer3ID, stayMainLand);
	rmBuildArea(terrainLayer3ID);

	int terrainLayer4ID = rmCreateArea("terrain layer4");
	rmSetAreaSize(terrainLayer4ID, 0.14);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmSetAreaLocation(terrainLayer4ID, 0.90, 0.10);
	else
		rmSetAreaLocation(terrainLayer4ID, 0.90, 0.50);
	rmSetAreaMix(terrainLayer4ID, paintMix3);
	rmSetAreaWarnFailure(terrainLayer4ID, false);
	rmSetAreaCoherence(terrainLayer4ID, 0.999); 
	rmSetAreaObeyWorldCircleConstraint(terrainLayer4ID, false);
	rmAddAreaConstraint(terrainLayer4ID, stayMainLand);
	rmBuildArea(terrainLayer4ID);
	
	int avoidDesert1 = rmCreateAreaDistanceConstraint("avoid desert1", terrainLayer4ID, 4.0);
	int stayDesert1 = rmCreateAreaMaxDistanceConstraint("stay desert1", terrainLayer4ID, 0.0);

	int terrainLayer5ID = rmCreateArea("terrain layer5");
	rmSetAreaSize(terrainLayer5ID, 0.10);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmSetAreaLocation(terrainLayer5ID, 0.90, 0.10);
	else
		rmSetAreaLocation(terrainLayer5ID, 0.90, 0.50);
	rmSetAreaMix(terrainLayer5ID, paintMix2);
	rmSetAreaWarnFailure(terrainLayer5ID, false);
	rmSetAreaCoherence(terrainLayer5ID, 0.666); 
	rmSetAreaObeyWorldCircleConstraint(terrainLayer5ID, false);
	rmAddAreaConstraint(terrainLayer5ID, stayMainLand);
	rmBuildArea(terrainLayer5ID);

	int avoidDesert2 = rmCreateAreaDistanceConstraint("avoid desert2", terrainLayer5ID, 8.0);
	int stayDesert2 = rmCreateAreaMaxDistanceConstraint("stay desert2", terrainLayer5ID, 0.0);

	// Sea
	int seaID=rmCreateArea("sea");
	rmSetAreaSize(seaID, 0.40);
	rmSetAreaLocation(seaID, 0.10, 0.50);
	rmSetAreaWaterType(seaID, wetType);
	rmSetAreaCoherence(seaID, 1.00);
	rmAddAreaConstraint(seaID, avoidMainLandMin);
	rmAddAreaConstraint(seaID, avoidSpur);
	rmSetAreaObeyWorldCircleConstraint(seaID, false);
	if (rmGetIsTreaty() == false && teamOneCount == teamZeroCount && TeamNum == 2)
		rmBuildArea(seaID);
	if (TeamNum != 2 || teamOneCount != teamZeroCount)
		rmBuildArea(seaID); 

	int avoidSeaMin = rmCreateAreaDistanceConstraint("avoid sea min", seaID, 1.0);
	int avoidSeaShort = rmCreateAreaDistanceConstraint("avoid sea short", seaID, 4.0);
	int avoidSea = rmCreateAreaDistanceConstraint("avoid sea", seaID, 8.0);
	int avoidSeaFar = rmCreateAreaDistanceConstraint("avoid sea far", seaID, 12.0);
	int avoidSeaFarther = rmCreateAreaDistanceConstraint("avoid sea farther", seaID, 16.0);
	int avoidSeaVeryFar = rmCreateAreaDistanceConstraint("avoid sea very far", seaID, 24.0);
	int staySea = rmCreateAreaMaxDistanceConstraint("stay in sea", seaID, 0.0);	
		
	// Players area
	for (i=1; < numPlayer)
	{
		int playerAreaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerAreaID);
		rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(222));
//		rmSetAreaBaseHeight(playerAreaID, 5.0);		// for testing
		rmSetAreaMix(playerAreaID, paintMix5);
		rmSetAreaCoherence(playerAreaID, 0.55);
		rmSetAreaWarnFailure(playerAreaID, false);
		rmAddAreaToClass (playerAreaID, classIsland);
		rmSetAreaLocPlayer(playerAreaID, i);
		rmBuildArea(playerAreaID);
	}

	// ____________________ Trade Routes ____________________
	int handedness = rmRandInt(1,2);

	int tradeRoute2ID = rmCreateTradeRoute();
	int socket2ID=rmCreateObjectDef("sockets to dock Trade Posts2");
		rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socket2ID, true);
		if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		{
			rmSetObjectDefMinDistance(socket2ID, 0.0);
			rmSetObjectDefMaxDistance(socket2ID, 0.0);
		}
		else
		{
			rmSetObjectDefMinDistance(socket2ID, 2.0);
			rmSetObjectDefMaxDistance(socket2ID, 8.0);
		}

		rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);

		if (TeamNum == 2)
		{
			if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
			{
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.6, 0.6);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.4, 0.6);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.4, 0.4);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.6, 0.4);
				rmAddTradeRouteWaypoint(tradeRoute2ID, 0.6, 0.6);
			}
			else
			{
				if (handedness == 1)
				{
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.85, 0.10); 
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.75, 0.30); 
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.60, 0.50); 
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.75, 0.70);
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.85, 0.90);
				}
				else
				{
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.85, 0.90);
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.75, 0.70);
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.60, 0.50);
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.75, 0.30);
					rmAddTradeRouteWaypoint(tradeRoute2ID, 0.85, 0.10);
				}
			}
		}
		else
		{
			rmAddTradeRouteWaypoint(tradeRoute2ID, 0.80, 0.50);
			rmAddTradeRouteWaypoint(tradeRoute2ID, 0.30, 0.50);
		}
		
		rmBuildTradeRoute(tradeRoute2ID, toiletPaper1);

		rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);

		float TPLoc1 = 0.00;
		float TPLoc2 = 0.00;
		float TPLoc3 = 0.00;
		float TPLoc4 = 0.00;
		if (PlayerNum < 5)
		{
			TPLoc1 = 0.12;
			TPLoc2 = 0.39;
			TPLoc3 = 0.61;
			TPLoc4 = 0.88;
		}
		else
		{
			TPLoc1 = 0.12;
			TPLoc2 = 0.30;
			TPLoc3 = 0.70;
			TPLoc4 = 0.88;
		}
		if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		{
			TPLoc1 = 0.01;
			TPLoc2 = 0.30;
			TPLoc3 = 0.50;
			TPLoc4 = 0.99;
		}


		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, TPLoc1);
		if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		{
			if (PlayerNum == 8)
				rmPlaceObjectDefAtLoc(socket2ID, 0, 0.78, 0.55);
			else if (PlayerNum == 2)
				rmPlaceObjectDefAtLoc(socket2ID, 0, 0.55, 0.75);
			else
				rmPlaceObjectDefAtLoc(socket2ID, 0, 0.75, 0.55);
		}
		else
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, TPLoc2);
		if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
			rmPlaceObjectDefAtLoc(socket2ID, 0, 0.56, 0.50);
		else
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);	

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, TPLoc3);
		if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
			rmPlaceObjectDefAtLoc(socket2ID, 0, 0.44, 0.50);
		else
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);	

		socketLoc2 = rmGetTradeRouteWayPoint(tradeRoute2ID, TPLoc4);
		if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		{
			if (PlayerNum == 8)
				rmPlaceObjectDefAtLoc(socket2ID, 0, 0.45, 0.22);
			else if (PlayerNum == 2)
				rmPlaceObjectDefAtLoc(socket2ID, 0, 0.25, 0.45);
			else
				rmPlaceObjectDefAtLoc(socket2ID, 0, 0.45, 0.25);
		}
		else
			rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc2);	
			
	// Text
	rmSetStatusText("",0.30);

	// ____________________ KOTH ____________________
	//King's Island
	if (rmGetIsKOTH() == true)
	{
		int kingIslandID=rmCreateArea("King's Island");
		rmSetAreaSize(kingIslandID, rmAreaTilesToFraction(333));
		rmSetAreaLocation(kingIslandID, 0.045, 0.50);
		rmSetAreaMix(kingIslandID, paintMix5);
		rmAddAreaToClass(kingIslandID, classIsland);
		rmSetAreaReveal(kingIslandID, 01);
		rmSetAreaBaseHeight(kingIslandID, 2.0);
		rmSetAreaCoherence(kingIslandID, 1.0);
		rmBuildArea(kingIslandID); 
	
	// Place King's Hill
		float xLoc = 0.045;
		float yLoc = 0.50;
		float walk = 0.0;
		
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	int avoidKOTH = rmCreateAreaDistanceConstraint("avoid koth island ", kingIslandID, 4.0);	
	
	// ____________________ Natives ____________________
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	int subCiv3 = -1;
	subCiv0 = rmGetCivID(natType1);
	subCiv1 = rmGetCivID(natType2);
	rmSetSubCiv(0, natType1);
	rmSetSubCiv(1, natType2);

	// Native Islands
	int natIsland1ID = rmCreateArea("nat isle 1");
	rmSetAreaSize(natIsland1ID, rmAreaTilesToFraction(333));
	if (TeamNum == 2)
		rmSetAreaLocation(natIsland1ID, 0.75, 0.50);
	else
		rmSetAreaLocation(natIsland1ID, 0.60, 0.60);
	rmSetAreaWarnFailure(natIsland1ID, false);
	rmSetAreaMix(natIsland1ID, paintMix4);
	rmSetAreaCoherence(natIsland1ID, 0.55); 
	rmSetAreaObeyWorldCircleConstraint(natIsland1ID, false);
	if (rmGetIsTreaty() == false)
		rmBuildArea(natIsland1ID);	
	
	int natIsland2ID = rmCreateArea("nat isle 2");
	rmSetAreaSize(natIsland2ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland2ID, 0.60, 0.40);
	rmSetAreaWarnFailure(natIsland2ID, false);
	rmSetAreaMix(natIsland2ID, paintMix5);
	rmSetAreaCoherence(natIsland2ID, 0.55); 
	rmSetAreaObeyWorldCircleConstraint(natIsland2ID, false);
	if (TeamNum > 2 && rmGetIsTreaty() == false)
		rmBuildArea(natIsland2ID);	
	
	int natIsland3ID = rmCreateArea("nat isle 3");
	rmSetAreaSize(natIsland3ID, rmAreaTilesToFraction(333));
	if (TeamNum == 2)
		rmSetAreaLocation(natIsland3ID, 0.35, 0.50);
	else
		rmSetAreaLocation(natIsland3ID, 0.40, 0.60);
	rmSetAreaWarnFailure(natIsland3ID, false);
	rmSetAreaMix(natIsland3ID, paintMix6);
	rmSetAreaCoherence(natIsland3ID, 0.55); 
	rmSetAreaObeyWorldCircleConstraint(natIsland3ID, false);
	if (rmGetIsTreaty() == false)
		rmBuildArea(natIsland3ID);	
	
	int natIsland4ID = rmCreateArea("nat isle 4");
	rmSetAreaSize(natIsland4ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland4ID, 0.40, 0.40);
	rmSetAreaWarnFailure(natIsland4ID, false);
	rmSetAreaMix(natIsland4ID, paintMix6);
	rmSetAreaCoherence(natIsland4ID, 0.55); 
	rmSetAreaObeyWorldCircleConstraint(natIsland4ID, false);
	if (TeamNum > 2 && rmGetIsTreaty() == false)
		rmBuildArea(natIsland4ID);	
	
	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;

	int whichNative = rmRandInt(1,2);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		whichNative = 1;

	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);
	int whichVillage4 = rmRandInt(1,5);
	
	if (whichNative < 2)
	{
		nativeID0 = rmCreateGrouping("native A", natGrpName1+whichVillage1);
		nativeID1 = rmCreateGrouping("native B", natGrpName1+whichVillage2);
		nativeID2 = rmCreateGrouping("native C", natGrpName2+whichVillage3);	
		nativeID3 = rmCreateGrouping("native D", natGrpName2+whichVillage4);	
	}
	else
	{
		nativeID0 = rmCreateGrouping("native A", natGrpName2+whichVillage1);
		nativeID1 = rmCreateGrouping("native B", natGrpName2+whichVillage2);
		nativeID2 = rmCreateGrouping("native C", natGrpName1+whichVillage3);	
		nativeID3 = rmCreateGrouping("native D", natGrpName1+whichVillage4);	
	}

	rmAddGroupingToClass(nativeID0, classNative);
	rmAddGroupingToClass(nativeID1, classNative);
	rmAddGroupingToClass(nativeID2, classNative);
	rmAddGroupingToClass(nativeID3, classNative);

	if (TeamNum == 2)
	{
		if (rmGetIsTreaty() == true && teamZeroCount == teamOneCount)
		{
			if (PlayerNum == 2)
			{
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.15, 0.40);
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.85);
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.10);
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.90, 0.50);
			}
			if (PlayerNum == 4)
			{
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.15, 0.50);
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.85);
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.07, 0.60);
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.93);
			}
			if (PlayerNum == 6)
			{
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.15, 0.52);
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.48, 0.85);
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.05, 0.60);
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.95);
			}
			if (PlayerNum == 8)
			{
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.15, 0.57);
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.43, 0.85);
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.07, 0.67);
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.33, 0.93);
			}
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.75, 0.50);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.35, 0.50);
		}
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.60, 0.60);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.40);
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.40, 0.60);
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.40);
	}

	// Avoidance Islands
	int midBigIslandID=rmCreateArea("Mid Big Island");
	rmSetAreaSize(midBigIslandID, 0.44+0.015*PlayerNum);
	rmSetAreaLocation(midBigIslandID, 0.50, 0.50);
//	rmSetAreaMix(midBigIslandID, "mongolia_grass");
	rmSetAreaCoherence(midBigIslandID, 1.00);
	rmBuildArea(midBigIslandID); 
	
	int avoidMidBigIsland = rmCreateAreaDistanceConstraint("avoid mid big island ", midBigIslandID, 8.0);
	int avoidMidBigIslandShort = rmCreateAreaDistanceConstraint("avoid mid big island short", midBigIslandID, 4.0);
	int avoidMidBigIslandMin = rmCreateAreaDistanceConstraint("avoid mid big island min", midBigIslandID, 0.5);
	int avoidMidBigIslandFar = rmCreateAreaDistanceConstraint("avoid mid big island far", midBigIslandID, 16.0);
	int stayMidBigIsland = rmCreateAreaMaxDistanceConstraint("stay mid big island ", midBigIslandID, 0.0);

	int midIslandID=rmCreateArea("Mid Island");
	if (teamZeroCount == teamOneCount)
		rmSetAreaSize(midIslandID, 0.35+0.01*PlayerNum);
	else
		rmSetAreaSize(midIslandID, 0.38+0.01*PlayerNum);
	rmSetAreaLocation(midIslandID, 0.50, 0.50);
//	rmSetAreaMix(midIslandID, forTesting);
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandShort = rmCreateAreaDistanceConstraint("avoid mid island short", midIslandID, 4.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.20);
	rmSetAreaLocation(midSmIslandID, 0.50, 0.50);
//	rmSetAreaMix(midSmIslandID, "africa desert sand"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 1.00);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);
	int stayNearMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay near mid sm island ", midSmIslandID, 4.0);

	int stayNearEdge = -1;
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.47), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(360));
	else
		stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.43), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	// Text
	rmSetStatusText("",0.40);
	
	// ____________________ Starting Resource ____________________
	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	if (rmGetNomadStart())
		rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
	else
		rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	rmAddObjectDefToClass(TCID, classStartingResource);
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 0.0);
	
	// Starting mines
	int playerGoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerGoldID, "MineGold", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 16.0);
	rmSetObjectDefMaxDistance(playerGoldID, 16.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerGoldID, avoidNativesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidSeaShort);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteSocketMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(playerGoldID, stayMidIsland);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerGold2ID, "MineGold", 1, 0);
	else
		rmAddObjectDefItem(playerGold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 40.0);
	rmSetObjectDefMaxDistance(playerGold2ID, 44+PlayerNum);
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerGold2ID, avoidNativesMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidSeaShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidMidBigIslandFar);

	// Bonus sheep
	int playerSheepID=rmCreateObjectDef("baaaa");
	rmAddObjectDefItem(playerSheepID, cattleType, rmRandInt(2,3), 2.0);
	rmSetObjectDefMinDistance(playerSheepID, 8);
	rmSetObjectDefMaxDistance(playerSheepID, 16);
	rmAddObjectDefConstraint(playerSheepID, avoidStartingResourcesShort);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType2, 2, 5.0);
	rmAddObjectDefItem(playerTreeID, treeType4, 1, 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTreeID, avoidNativesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidSeaShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketMin);

	int playerTree2ID = rmCreateObjectDef("player trees2");
	rmAddObjectDefItem(playerTree2ID, brushType1, 4, 3.0);
	rmAddObjectDefItem(playerTree2ID, treeType1, 1, 2.0);
	if (rmGetIsTreaty() == false)
	{
		rmAddObjectDefItem(playerTree2ID, treeType2, 1, 2.0);
		rmAddObjectDefItem(playerTree2ID, treeType4, 1, 2.0);
	}
	else
		rmAddObjectDefItem(playerTree2ID, treeType1, 2, 2.0);
	if (rmGetIsTreaty() == true)
	{
    	rmSetObjectDefMinDistance(playerTree2ID, 60);
	    rmSetObjectDefMaxDistance(playerTree2ID, 70+2*PlayerNum);
	}
	else
	{
    	rmSetObjectDefMinDistance(playerTree2ID, 40);
	    rmSetObjectDefMaxDistance(playerTree2ID, 60);
	}
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	if (rmGetIsTreaty() == false)
		rmAddObjectDefConstraint(playerTree2ID, avoidForestMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResourcesShort);
	if (rmGetIsTreaty() == false)
		rmAddObjectDefConstraint(playerTree2ID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidSeaFar);
	rmAddObjectDefConstraint(playerTree2ID, avoidDesert1);
	rmAddObjectDefConstraint(playerTree2ID, avoidDesert2);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocketMin);
//	rmAddObjectDefConstraint(playerTree2ID, stayMidIsland);
	rmAddObjectDefConstraint(playerTree2ID, avoidMidBigIslandFar);
	rmAddObjectDefConstraint(playerTree2ID, stayNearEdge);
	rmAddObjectDefConstraint(playerTree2ID, avoidEdge);

	int playerTree3ID = rmCreateObjectDef("player trees3");
	rmAddObjectDefItem(playerTree3ID, brushType1, 15, 10.0);
	rmAddObjectDefItem(playerTree3ID, treeType1, 2, 8.0);
	rmAddObjectDefItem(playerTree3ID, treeType2, 4, 8.0);
	rmAddObjectDefItem(playerTree3ID, treeType4, 10, 8.0);
    rmSetObjectDefMinDistance(playerTree3ID, 40);
    rmSetObjectDefMaxDistance(playerTree3ID, 40+PlayerNum);
	rmAddObjectDefToClass(playerTree3ID, classStartingResource);
	rmAddObjectDefToClass(playerTree3ID, classForest);
	rmAddObjectDefConstraint(playerTree3ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree3ID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTree3ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerTree3ID, avoidSeaFar);
	rmAddObjectDefConstraint(playerTree3ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerTree3ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerTree3ID, avoidMidBigIslandFar);
	rmAddObjectDefConstraint(playerTree3ID, avoidEdge);

	// Starting herds
	int playerHerdID = rmCreateObjectDef("starting herd");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerHerdID, food1, 16, 6.0);
	else
		rmAddObjectDefItem(playerHerdID, food1, 5+PlayerNum/2, 4);
	rmSetObjectDefMinDistance(playerHerdID, 8.0);
	rmSetObjectDefMaxDistance(playerHerdID, 12.0);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerHerdID, avoidNatives);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHerdID, avoidSea);
	rmAddObjectDefConstraint(playerHerdID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerHerdID, avoidTradeRouteSocketMin);
		
	int playerHerd2ID = rmCreateObjectDef("2nd herd");
    rmAddObjectDefItem(playerHerd2ID, food2, 12, 5.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 30);
    rmSetObjectDefMaxDistance(playerHerd2ID, 31);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidSeaFar);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidEdge);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIsland);
	
	int playerHerd3ID = rmCreateObjectDef("3nd herd");
	if (rmGetIsTreaty() == true)
	    rmAddObjectDefItem(playerHerd3ID, food2, 16, 6.0);
    else
		rmAddObjectDefItem(playerHerd3ID, food2, 8, 5.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 44);
    rmSetObjectDefMaxDistance(playerHerd3ID, 44+PlayerNum);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerHerd3ID, avoidSeaFar);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteSocketMin);
	if (rmGetIsTreaty() == false)
		rmAddObjectDefConstraint(playerHerd3ID, stayNearEdge);
	rmAddObjectDefConstraint(playerHerd3ID, avoidEdge);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1,	0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 22+PlayerNum);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketMin);
	if (TeamNum == 2 && PlayerNum > 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandFar);
	if (teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidBigIslandMin);
		
	// Water flag
	int colonyShipID = 0;
	colonyShipID=rmCreateObjectDef("colony ship");
	rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 0);
	rmSetObjectDefMinDistance(colonyShipID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.05));
	rmAddObjectDefConstraint(colonyShipID, avoidColonyShip);
	rmAddObjectDefConstraint(colonyShipID, avoidLand);
	rmAddObjectDefConstraint(colonyShipID, avoidEdgeMore);	
	rmAddObjectDefConstraint(colonyShipID, avoidTradeRouteMin);	
	
	// Place Starting Resources and Objects	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
	}
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (TeamNum > 2 || rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(playerGold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(playerSheepID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(playerTree3ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (PlayerNum > 2 || rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(colonyShipID, i, 0.20, rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (PlayerNum == 2 || rmGetIsTreaty() == true)
		{
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
		if (rmGetIsTreaty() == true)
		{
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
	}
	
	// Text
	rmSetStatusText("",0.50);
	
	// ____________________ Common Resources ____________________
	// 1v1 Gold Mine 
	int goldMineID = rmCreateObjectDef("goldmine");
		rmAddObjectDefItem(goldMineID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(goldMineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(goldMineID, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(goldMineID, classGold);
		if (TeamNum == 2 && PlayerNum == 2 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.90, 0.50);

	// 1v1 Extra Mine 
	int extraMineID = rmCreateObjectDef("extra mine");
		rmAddObjectDefItem(extraMineID, "Minegold", 1, 0.0);
		rmSetObjectDefMinDistance(extraMineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(extraMineID, rmXFractionToMeters(0.02));
		rmAddObjectDefToClass(extraMineID, classGold);
		if (TeamNum == 2 && PlayerNum == 2 && rmGetIsTreaty() == false)
		{
			rmPlaceObjectDefAtLoc(extraMineID, 0, 0.725, 0.80);
			rmPlaceObjectDefAtLoc(extraMineID, 0, 0.725, 0.20);
		}

	// Plateau
	int upORdown = rmRandInt(1,2);

	int plateauID = rmCreateArea("cliffs");
//	rmAddAreaToClass(plateauID, rmClassID("classPlateau"));
	rmSetAreaSize(plateauID, 0.015); 
//	rmSetAreaTerrainType(plateauID, cliffPaint1); 
	rmSetAreaCliffType(plateauID, mntType);
	rmSetAreaCliffEdge(plateauID, 2, 0.35, 0.0, 0.0, 0); 
	rmSetAreaCliffPainting(plateauID, true, true, true, 1.5, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	if (upORdown == 1)
		rmSetAreaCliffHeight(plateauID, 7, 0.1, 0.5);
	else
		rmSetAreaCliffHeight(plateauID, -10, 0.1, 0.5);
	rmSetAreaCoherence(plateauID, 0.73);
	rmSetAreaLocation(plateauID, 0.90, 0.65);		
	rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	rmAddAreaConstraint (plateauID, avoidNatives);
	rmAddAreaConstraint (plateauID, avoidTradeRouteMin);
	rmAddAreaConstraint (plateauID, avoidTradeRouteSocket);
	rmAddAreaConstraint (plateauID, avoidGoldTypeShort);
	if (TeamNum == 2 && rmGetIsTreaty() == false)
		rmBuildArea(plateauID);

	int stayNearPlateau = rmCreateAreaMaxDistanceConstraint("stay near plateau", plateauID, 5);

	int plateauPaintID = rmCreateArea("plateau paint");
	rmSetAreaSize(plateauPaintID, 0.025);
	rmSetAreaLocation(plateauPaintID, 0.90, 0.65);
	rmSetAreaWarnFailure(plateauPaintID, false);
	rmSetAreaMix(plateauPaintID, paintMix3);	
	rmSetAreaCoherence(plateauPaintID, 0.85); 
	rmSetAreaObeyWorldCircleConstraint(plateauPaintID, false);
	rmAddAreaConstraint(plateauPaintID, stayNearPlateau);
	if (TeamNum == 2 && rmGetIsTreaty() == false)
		rmBuildArea(plateauPaintID);	

	int plateau2ID = rmCreateArea("cliffs2");
//	rmAddAreaToClass(plateau2ID, rmClassID("classPlateau"));
	rmSetAreaSize(plateau2ID, 0.015); 
//	rmSetAreaTerrainType(plateau2ID, cliffPaint1); 
	rmSetAreaCliffType(plateau2ID, mntType);
	rmSetAreaCliffEdge(plateau2ID, 2, 0.35, 0.0, 0.0, 0); 
	rmSetAreaCliffPainting(plateau2ID, true, true, true, 1.5, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight, paintInsideEdge
	if (upORdown == 1)
		rmSetAreaCliffHeight(plateau2ID, 7, 0.1, 0.5);
	else
		rmSetAreaCliffHeight(plateau2ID, -10, 0.1, 0.5);
	rmSetAreaCoherence(plateau2ID, 0.73);
	rmSetAreaLocation(plateau2ID, 0.90, 0.35);		
	rmSetAreaObeyWorldCircleConstraint(plateau2ID, false);
	rmAddAreaConstraint (plateau2ID, avoidNatives);
	rmAddAreaConstraint (plateau2ID, avoidTradeRouteMin);
	rmAddAreaConstraint (plateau2ID, avoidTradeRouteSocket);
	rmAddAreaConstraint (plateau2ID, avoidGoldTypeShort);
	if (TeamNum == 2 && rmGetIsTreaty() == false)
		rmBuildArea(plateau2ID);

	int stayNearPlateau2 = rmCreateAreaMaxDistanceConstraint("stay near plateau2", plateau2ID, 5);

	int plateauPaint2ID = rmCreateArea("plateau paint2");
	rmSetAreaSize(plateauPaint2ID, 0.025);
	rmSetAreaLocation(plateauPaint2ID, 0.90, 0.35);
	rmSetAreaWarnFailure(plateauPaint2ID, false);
	rmSetAreaMix(plateauPaint2ID, paintMix3);	
	rmSetAreaCoherence(plateauPaint2ID, 0.85); 
	rmSetAreaObeyWorldCircleConstraint(plateauPaint2ID, false);
	rmAddAreaConstraint(plateauPaint2ID, stayNearPlateau2);
	if (TeamNum == 2 && rmGetIsTreaty() == false)
		rmBuildArea(plateauPaint2ID);	

	// Place team gold mines
	if (TeamNum == 2 && PlayerNum > 2 && rmGetIsTreaty() == false)
	{
		rmPlaceObjectDefAtLoc(goldMineID, 0, 0.90, 0.65);
		rmPlaceObjectDefAtLoc(goldMineID, 0, 0.90, 0.35);
	}
	if (rmGetIsTreaty() == true && TeamNum == 2 && teamZeroCount == teamOneCount)
	{
		rmPlaceObjectDefAtLoc(goldMineID, 0, 0.90, 0.40);
		rmPlaceObjectDefAtLoc(goldMineID, 0, 0.60, 0.10);
		if (PlayerNum > 2)
		{
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.45, 0.90);
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.10, 0.55);
		}
		if (PlayerNum == 6)
		{
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.70, 0.70);
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.30, 0.30);
		}
		if (PlayerNum == 8)
		{
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.75, 0.65);
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.65, 0.75);
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.25, 0.35);
			rmPlaceObjectDefAtLoc(goldMineID, 0, 0.35, 0.25);
		}
	}

	// Mid Mines
	if (PlayerNum == 2 && rmGetIsTreaty() == false)
	{
		// Symmetrical Mines - from Riki (thx)
		int midMineA = -1;
		midMineA = rmCreateObjectDef("silver mid A");
		rmAddObjectDefItem(midMineA, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(midMineA, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(midMineA, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(midMineA, classGold);
		rmAddObjectDefConstraint(midMineA, avoidTradeRouteShort);
		rmAddObjectDefConstraint(midMineA, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(midMineA, avoidSeaFar);
		rmAddObjectDefConstraint(midMineA, avoidStartingResources);
		rmAddObjectDefConstraint(midMineA, avoidGoldTypeFar);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(midMineA, avoidKOTH);

		int midMineB = -1;
		midMineB = rmCreateObjectDef("silver mid B");
		rmAddObjectDefItem(midMineB, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(midMineB, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(midMineB, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(midMineB, classGold);

		int mineMidPlacement=0;
		float mineMidPositionX=-1;
		float mineMidPositionZ=-1;
		int resultMid=0;
		int leaveWhileMid=0;

		while (mineMidPlacement < 1)
		{
			mineMidPositionX=rmRandFloat(0.40,0.45);
			mineMidPositionZ=rmRandFloat(0.40,0.45);
			rmSetObjectDefForceFullRotation(midMineA, true);
			resultMid=rmPlaceObjectDefAtLoc(midMineA, 0, mineMidPositionX, mineMidPositionZ);
			if (resultMid == 1)
			{
				rmSetObjectDefForceFullRotation(midMineB, true);
				rmPlaceObjectDefAtLoc(midMineB, 0, 1.0-mineMidPositionX, 1.0-mineMidPositionZ);
				mineMidPlacement++;
				leaveWhileMid=0;
			}
			else
				leaveWhileMid++;
			if (leaveWhileMid==300)
				break;
		}
	}

	rmSetStatusText("",0.60);

	// Cliffs
	int classAvoidance = rmDefineClass("avoidance");
	int avoidAvoidance = rmCreateClassDistanceConstraint("avoid avoidance", rmClassID("avoidance"), 0.5);

	int avoidThisID=rmCreateArea("avoid this");
	rmSetAreaSize(avoidThisID, 0.10);
	rmSetAreaLocation(avoidThisID, 0.50, 0.50);
//	rmSetAreaMix(avoidThisID, "himalayas_a"); 	// for testing
	rmAddAreaToClass(avoidThisID, classAvoidance);
	rmSetAreaCoherence(avoidThisID, 1.00);
	rmBuildArea(avoidThisID); 

	int avoidThisTooID=rmCreateArea("avoid this too");
	rmSetAreaSize(avoidThisTooID, 0.05);
	rmSetAreaLocation(avoidThisTooID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(avoidThisTooID, 1.00, 1.00, 0.00, 0.00);
//	rmSetAreaMix(avoidThisTooID, "himalayas_a"); 	// for testing
	rmAddAreaToClass(avoidThisTooID, classIsland2);
	rmSetAreaCoherence(avoidThisTooID, 1.00);
	rmBuildArea(avoidThisTooID); 

	int cliffcount = 2; 
	if (TeamNum > 2)
		cliffcount = 4;

	int stayNearCliff = -1;
	int stayInCliff = -1;
	int cliffPatchID = -1;
	int cliffVegID = -1;
	int cliffMineID = -1;

	for (i= 0; < cliffcount)
	{
		int cliffID = rmCreateArea("cliff"+i);
		rmAddAreaToClass(cliffID, classPlateau);
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		rmSetAreaCliffType(cliffID, mntType); 
		if (rmGetIsTreaty() == true && TeamNum == 2 && teamZeroCount == teamOneCount)
		{
			rmSetAreaSize(cliffID, 0.05);
			rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.0, 1.0, 0); 
			if (i == 0)
			{
				rmSetAreaLocation(cliffID, 0.65, 0.35);
			}
			else
			{
				rmSetAreaLocation(cliffID, 0.35, 0.65);
			}
		}
		else
		{
			rmSetAreaSize(cliffID, 0.0225);
			rmSetAreaCliffEdge(cliffID, 1, 0.4, 0.0, 0.0, 1); 
		}
		rmSetAreaCliffHeight(cliffID, 10, 0.1, 0.5); 
		rmSetAreaHeightBlend(cliffID, 0);
		rmSetAreaCoherence(cliffID, 0.70);
		rmSetAreaSmoothDistance(cliffID, 0);
		if (rmGetIsTreaty() == true && TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddAreaCliffEdgeAvoidClass(cliffID, classAvoidance, 2);
		rmAddAreaConstraint(cliffID, avoidSeaFar);
		if (rmGetIsTreaty() == false)
		{
			rmAddAreaConstraint(cliffID, avoidPlateauFar);
			rmAddAreaConstraint(cliffID, staySpur);
		}
		else
			rmAddAreaConstraint(cliffID, stayMidSmIsland);
//			rmAddAreaConstraint(cliffID, stayNearMidSmIsland);
		rmAddAreaConstraint(cliffID, avoidNatives);
		rmAddAreaConstraint(cliffID, avoidGoldTypeShort);
		rmAddAreaConstraint(cliffID, avoidTownCenter);
		rmAddAreaConstraint(cliffID, avoidStartingResourcesShort);
		rmAddAreaConstraint(cliffID, avoidTradeRouteSocketShort);
		rmAddAreaConstraint(cliffID, avoidTradeRouteMin);
		rmAddAreaConstraint(cliffID, avoidIsland);
		if (rmGetIsTreaty() == true && TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddAreaConstraint(cliffID, avoidIsland2);
		rmAddAreaConstraint(cliffID, avoidDesert1);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(cliffID, avoidKOTH);
		rmSetAreaWarnFailure(cliffID, false);
		rmBuildArea(cliffID);		

		stayNearCliff = rmCreateAreaMaxDistanceConstraint("stay near cliff"+i, cliffID, 4.0);
		stayInCliff = rmCreateAreaMaxDistanceConstraint("stay in cliff"+i, cliffID, 0.0);

        cliffPatchID = rmCreateArea("cliff patch"+i);
        rmSetAreaWarnFailure(cliffPatchID, false);
		rmSetAreaObeyWorldCircleConstraint(cliffPatchID, true);
        rmSetAreaSize(cliffPatchID, 0.075);
		rmSetAreaMix(cliffPatchID, paintMix6);
        rmSetAreaCoherence(cliffPatchID, 1.00);
		rmAddAreaConstraint(cliffPatchID, stayNearCliff);
		rmBuildArea(cliffPatchID);

		cliffVegID = rmCreateObjectDef("cliff veg "+i);
		rmAddObjectDefItem(cliffVegID, brushType3, 2, 4.0);
		rmSetObjectDefMinDistance(cliffVegID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(cliffVegID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(cliffVegID, stayInCliff);
		rmAddObjectDefConstraint(cliffVegID, avoidGoldMin);
		rmAddObjectDefConstraint(cliffVegID, avoidNatives);
		rmAddObjectDefConstraint(cliffVegID, avoidTradeRouteSocketMin);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(cliffVegID, avoidKOTH);
		rmPlaceObjectDefAtLoc(cliffVegID, 0, 0.50, 0.50, PlayerNum*10);

		cliffMineID = rmCreateObjectDef("cliff mine "+i);
		rmAddObjectDefItem(cliffMineID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(cliffMineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(cliffMineID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(cliffMineID, stayInCliff);
		rmAddObjectDefConstraint(cliffMineID, avoidGoldTypeFar);
		rmAddObjectDefConstraint(cliffMineID, avoidSeaVeryFar);
		rmAddObjectDefConstraint(cliffMineID, avoidTownCenterFar);
		rmAddObjectDefConstraint(cliffMineID, avoidNativesFar);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(cliffMineID, avoidKOTH);
		if (PlayerNum > 2 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(cliffMineID, 0, 0.50, 0.50);
	}		

	// Mid Mines
	if (PlayerNum > 2 && rmGetIsTreaty() == false) 
	{
		int midSilverID = rmCreateObjectDef("mid silver");
		rmAddObjectDefItem(midSilverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(midSilverID, rmXFractionToMeters(0.05));
		rmSetObjectDefMaxDistance(midSilverID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(midSilverID, classGold);
		rmAddObjectDefConstraint(midSilverID, avoidTownCenterFar);
		rmAddObjectDefConstraint(midSilverID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(midSilverID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(midSilverID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(midSilverID, avoidSeaVeryFar);
		rmAddObjectDefConstraint(midSilverID, avoidGoldVeryFar);
		if (TeamNum == 2)
			rmAddObjectDefConstraint(midSilverID, stayMidSmIsland);
		else
			rmAddObjectDefConstraint(midSilverID, stayMidIsland);
		rmAddObjectDefConstraint(midSilverID, avoidImpassableLandShort);
		if (rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(midSilverID, 0, 0.50, 0.50, PlayerNum);
	}

	// Text
	rmSetStatusText("",0.70);

	// Main forest patches
	int mainforestcount = 10*PlayerNum;
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		mainforestcount = 20+7*PlayerNum;

	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(77));
        rmSetAreaMix(forestpatchID, paintMix7);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidCenterMin);
		rmAddAreaConstraint(forestpatchID, avoidNatives);
		if (rmGetIsTreaty() == true)
			rmAddAreaConstraint(forestpatchID, avoidForest);
		else
			rmAddAreaConstraint(forestpatchID, avoidForestShort);
		rmAddAreaConstraint(forestpatchID, avoidGoldTypeMin);
		rmAddAreaConstraint(forestpatchID, avoidSeaShort);
		rmAddAreaConstraint(forestpatchID, avoidDesert1);
		rmAddAreaConstraint(forestpatchID, avoidDesert2);
		rmAddAreaConstraint(forestpatchID, avoidIsland);
		rmAddAreaConstraint(forestpatchID, avoidSeaFar);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocketShort);
		rmAddAreaConstraint(forestpatchID, avoidImpassableLandShort);
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
		rmAddObjectDefItem(foresttreeID, brushType1, 10, 8.0);
		rmAddObjectDefItem(foresttreeID, treeType1, 1, 6.0);
		rmAddObjectDefItem(foresttreeID, treeType2, 3, 6.0);
		rmAddObjectDefItem(foresttreeID, treeType4, 3, 6.0);
		rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(foresttreeID, classForest);
		rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
		rmAddObjectDefConstraint(foresttreeID, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);

		int foresttreeBID = rmCreateObjectDef("forest treesB"+i);
		rmAddObjectDefItem(foresttreeBID, treeType1, 1, 5.0);
		rmAddObjectDefItem(foresttreeBID, treeType2, 3, 6.0);
		rmAddObjectDefItem(foresttreeBID, treeType4, 3, 6.0);
		rmSetObjectDefMinDistance(foresttreeBID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(foresttreeBID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(foresttreeBID, classForest);
		rmAddObjectDefConstraint(foresttreeBID, stayInForestPatch);
		rmAddObjectDefConstraint(foresttreeBID, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(foresttreeBID, 0, 0.50, 0.50, 2);
    }

	// Text
	rmSetStatusText("",0.80);

	// Secondary forest
	int secondforestcount = 4+4*PlayerNum;
//	if (rmGetIsTreaty() == true)
//		secondforestcount = 5+5*PlayerNum;

	int stayIn2ndForest = -1;

	for (i=0; < secondforestcount)
	{
		int secondforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondforestID, false);
		rmSetAreaSize(secondforestID, rmAreaTilesToFraction(55));
		rmSetAreaObeyWorldCircleConstraint(secondforestID, true);
        rmSetAreaMix(secondforestID, paintMix9);
		rmSetAreaCoherence(secondforestID, 0.2);
		rmSetAreaSmoothDistance(secondforestID, 4);
		rmAddAreaConstraint(secondforestID, stayDesert1);
		rmAddAreaConstraint(secondforestID, avoidForestShort);
		rmAddAreaConstraint(secondforestID, avoidGoldTypeMin);
		rmAddAreaConstraint(secondforestID, avoidNatives);
		rmAddAreaConstraint(secondforestID, avoidIsland);
		rmAddAreaConstraint(secondforestID, avoidPlateauShort);
		rmAddAreaConstraint(secondforestID, avoidTradeRouteSocketShort);
		rmBuildArea(secondforestID);

		stayIn2ndForest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondforestID, 0);

		int secondforesttreeID = rmCreateObjectDef("secondary forest trees"+i);
		rmAddObjectDefItem(secondforesttreeID, brushType2, 2, 5.0);
		rmAddObjectDefItem(secondforesttreeID, "PropDustCloud", 2, 5.0);
		rmAddObjectDefItem(secondforesttreeID, treeType3, 2, 6.0);
		rmSetObjectDefMinDistance(secondforesttreeID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(secondforesttreeID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(secondforesttreeID, classForest);
		rmAddObjectDefConstraint(secondforesttreeID, stayIn2ndForest);
		rmAddObjectDefConstraint(secondforesttreeID, avoidGoldMin);
		rmPlaceObjectDefAtLoc(secondforesttreeID, 0, 0.50, 0.50, 2);
	}

	// Desert Herds 
	int desertHerdID = rmCreateObjectDef("desert herd");
	rmAddObjectDefItem(desertHerdID, food3, 8, 3.0);
	rmSetObjectDefMinDistance(desertHerdID, rmXFractionToMeters(0.00));
	if (PlayerNum == 2)
		rmSetObjectDefMaxDistance(desertHerdID, rmXFractionToMeters(0.05));
	else
		rmSetObjectDefMaxDistance(desertHerdID, rmXFractionToMeters(0.45));
	rmSetObjectDefCreateHerd(desertHerdID, true);
	rmAddObjectDefConstraint(desertHerdID, avoidHunt3Far);
	rmAddObjectDefConstraint(desertHerdID, avoidGoldMin);
	rmAddObjectDefConstraint(desertHerdID, avoidNatives);
	rmAddObjectDefConstraint(desertHerdID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(desertHerdID, avoidEdge);
	rmAddObjectDefConstraint(desertHerdID, avoidForestMin);
	rmAddObjectDefConstraint(desertHerdID, avoidImpassableLandShort);
	if (rmGetIsTreaty() == false)
	{
		if (PlayerNum < 5)
			rmAddObjectDefConstraint(desertHerdID, stayDesert2);
		else
			rmAddObjectDefConstraint(desertHerdID, stayDesert1);
		if (PlayerNum == 2)
		{
			rmPlaceObjectDefAtLoc(desertHerdID, 0, 0.90, 0.70);
			rmPlaceObjectDefAtLoc(desertHerdID, 0, 0.90, 0.30);
		}
		else 
			rmPlaceObjectDefAtLoc(desertHerdID, 0, 0.50, 0.50, PlayerNum);
	}
	else
	{
		if (PlayerNum == 2)
		{
			rmPlaceObjectDefAtLoc(desertHerdID, 0, 0.50, 0.20);
			rmPlaceObjectDefAtLoc(desertHerdID, 0, 0.80, 0.50);
		}
		else
		{
			if (PlayerNum < 5)
				rmAddObjectDefConstraint(desertHerdID, stayDesert2);
			else
				rmAddObjectDefConstraint(desertHerdID, stayDesert1);
			rmPlaceObjectDefAtLoc(desertHerdID, 0, 0.50, 0.50, PlayerNum);
		}
	}

	// Mid herds
	if (PlayerNum == 2)
	{
		int midherdcount = 2;
		if (rmGetIsTreaty() == true)
			midherdcount = 1;

		// Symmetrical Hunts - from Riki (thx)
		int midHuntAID = -1;
		midHuntAID = rmCreateObjectDef("mid hunt A");
		rmAddObjectDefItem(midHuntAID, food1, 8, 3.0);
		rmSetObjectDefMinDistance(midHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(midHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(midHuntAID, true);
		rmAddObjectDefConstraint(midHuntAID, avoidHunt1);
		rmAddObjectDefConstraint(midHuntAID, avoidForestMin);
		rmAddObjectDefConstraint(midHuntAID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(midHuntAID, avoidStartingResources);
		rmAddObjectDefConstraint(midHuntAID, avoidSeaFar);
		rmAddObjectDefConstraint(midHuntAID, avoidGoldMin);
		rmAddObjectDefConstraint(midHuntAID, avoidNatives);
		rmAddObjectDefConstraint(midHuntAID, avoidImpassableLand);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(midHuntAID, avoidKOTH);

		int midHuntBID = -1;
		midHuntBID = rmCreateObjectDef("mid hunt B");
		rmAddObjectDefItem(midHuntBID, food1, 8, 3.0);
		rmSetObjectDefMinDistance(midHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(midHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(midHuntBID, true);

		int huntMidPlacement=0;
		float huntMidPositionX=-1;
		float huntMidPositionZ=-1;
		int resultMidF=0;
		int leaveWhileMidF=0;

		while (huntMidPlacement < midherdcount)
		{
			huntMidPositionX=rmRandFloat(0.33,0.67);
			huntMidPositionZ=rmRandFloat(0.33,0.67);
			resultMidF=rmPlaceObjectDefAtLoc(midHuntAID, 0, huntMidPositionX, huntMidPositionZ);
			if (resultMidF != 0)
			{
				rmPlaceObjectDefAtLoc(midHuntBID, 0, 1.0-huntMidPositionX, 1.0-huntMidPositionZ);
				huntMidPlacement++;
				leaveWhileMidF=0;
			}
			else
				leaveWhileMidF++;
			if (leaveWhileMidF==300)
				break;
		}
	}

	// Team Herds 
	int teamHerdID = rmCreateObjectDef("team herd");
	rmAddObjectDefItem(teamHerdID, food2, 10, 4.0);
	rmSetObjectDefMinDistance(teamHerdID, rmXFractionToMeters(0.00));
	if (PlayerNum == 2)
		rmSetObjectDefMaxDistance(teamHerdID, rmXFractionToMeters(0.05));
	else
		rmSetObjectDefMaxDistance(teamHerdID, rmXFractionToMeters(0.50));
	rmSetObjectDefCreateHerd(teamHerdID, true);
	rmAddObjectDefConstraint(teamHerdID, avoidGoldMin);
	rmAddObjectDefConstraint(teamHerdID, avoidForestMin);
	rmAddObjectDefConstraint(teamHerdID, avoidSeaShort);
	rmAddObjectDefConstraint(teamHerdID, avoidNatives);
	rmAddObjectDefConstraint(teamHerdID, avoidIslandFar);
	rmAddObjectDefConstraint(teamHerdID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(teamHerdID, avoidDesert1);
	rmAddObjectDefConstraint(teamHerdID, avoidImpassableLandShort);
	if (PlayerNum == 2 && rmGetIsTreaty() == false)
	{
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.35, 0.35);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.35, 0.65);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.72, 0.225);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.72, 0.775);
	}
	else if (PlayerNum == 2 && rmGetIsTreaty() == true)
	{
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.20, 0.50);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.50, 0.80);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.10, 0.70);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.30, 0.90);
	}
	else
	{
		rmAddObjectDefConstraint(teamHerdID, avoidHunt1Far);
		rmAddObjectDefConstraint(teamHerdID, avoidHunt2Far);
		rmAddObjectDefConstraint(teamHerdID, avoidTownCenter);
		rmPlaceObjectDefAtLoc(teamHerdID, 0, 0.50, 0.50, 2*PlayerNum);
	}

	// Treaty Pocket Herds 
	int treatyHerdID = rmCreateObjectDef("treaty herd");
	rmAddObjectDefItem(treatyHerdID, food2, 10, 4.0);
	rmSetObjectDefMinDistance(treatyHerdID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(treatyHerdID, rmXFractionToMeters(0.05));
	rmSetObjectDefCreateHerd(treatyHerdID, true);
	rmAddObjectDefConstraint(treatyHerdID, avoidGoldMin);
	rmAddObjectDefConstraint(treatyHerdID, avoidForestMin);
	rmAddObjectDefConstraint(treatyHerdID, avoidNatives);
	rmAddObjectDefConstraint(treatyHerdID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(treatyHerdID, avoidHunt1Min);
	rmAddObjectDefConstraint(treatyHerdID, avoidHunt2Min);
	rmAddObjectDefConstraint(treatyHerdID, avoidStartingResourcesShort);
	if (PlayerNum == 8 && rmGetIsTreaty() == true)
	{
		rmPlaceObjectDefAtLoc(treatyHerdID, 0, 0.70, 0.60);
		rmPlaceObjectDefAtLoc(treatyHerdID, 0, 0.60, 0.70);
		rmPlaceObjectDefAtLoc(treatyHerdID, 0, 0.30, 0.40);
		rmPlaceObjectDefAtLoc(treatyHerdID, 0, 0.40, 0.30);
	}
	if (PlayerNum == 6 && rmGetIsTreaty() == true)
	{
		rmPlaceObjectDefAtLoc(treatyHerdID, 0, 0.70, 0.70);
		rmPlaceObjectDefAtLoc(treatyHerdID, 0, 0.30, 0.30);
	}

	// Central Herds FFA
	int ffaHerdID = rmCreateObjectDef("herd FFA");
	rmAddObjectDefItem(ffaHerdID, food1, 10, 4.0);
	rmSetObjectDefMinDistance(ffaHerdID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(ffaHerdID, rmXFractionToMeters(0.50));
	rmSetObjectDefCreateHerd(ffaHerdID, true);
	rmAddObjectDefConstraint(ffaHerdID, avoidGoldMin);
	rmAddObjectDefConstraint(ffaHerdID, avoidForestMin);
	rmAddObjectDefConstraint(ffaHerdID, avoidHunt1Far);
	rmAddObjectDefConstraint(ffaHerdID, avoidHunt2Far);
	rmAddObjectDefConstraint(ffaHerdID, avoidSeaShort);
	rmAddObjectDefConstraint(ffaHerdID, avoidNatives);
	rmAddObjectDefConstraint(ffaHerdID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(ffaHerdID, avoidTownCenterFar);
	rmAddObjectDefConstraint(ffaHerdID, avoidIslandFar);
	rmAddObjectDefConstraint(ffaHerdID, avoidPlateauShort);
	if (TeamNum > 2)
		rmPlaceObjectDefAtLoc(ffaHerdID, 0, 0.50, 0.50, PlayerNum);

	// Random Trees
	int randomtreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomtreeID, treeType3, 2, 3.0);
	rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(randomtreeID, classForest);
	rmAddObjectDefConstraint(randomtreeID, avoidForestMin);
	rmAddObjectDefConstraint(randomtreeID, avoidNatives);
	rmAddObjectDefConstraint(randomtreeID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(randomtreeID, avoidHunt1Min);
	rmAddObjectDefConstraint(randomtreeID, avoidHunt2Min);
	rmAddObjectDefConstraint(randomtreeID, avoidHunt3Min);
	rmAddObjectDefConstraint(randomtreeID, avoidIslandMin);
	rmAddObjectDefConstraint(randomtreeID, stayDesert1);
	rmAddObjectDefConstraint(randomtreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(randomtreeID, avoidTradeRouteSocketMin);
	if (rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50, 10+5*PlayerNum);

	// Text
	rmSetStatusText("",0.90);

	// ____________________ Treasures ____________________
	int nugget3count = PlayerNum/2;
	int nugget2count = 2+PlayerNum;
	int nuggetcount = 4*PlayerNum;
	if (rmGetIsTreaty() == true)
	{
		nugget3count = PlayerNum;
		nugget2count = 2*(2+PlayerNum);
		nuggetcount = 4+4*PlayerNum;
	}

	// Treasures 3+4
	int Nugget4ID = rmCreateObjectDef("Nugget4"); 
	rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget4ID, 0);
	rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.15));
	rmSetNuggetDifficulty(4,4);
	rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidGoldMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidHunt1Min);
	rmAddObjectDefConstraint(Nugget4ID, avoidHunt2Min);
	rmAddObjectDefConstraint(Nugget4ID, avoidHunt3Min);
	rmAddObjectDefConstraint(Nugget4ID, avoidBerriesMin);	
	rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget4ID, avoidIslandFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidSeaShort);
	rmAddObjectDefConstraint(Nugget4ID, avoidStartingResources);
	rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
	if (PlayerNum > 4 && rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50, 2);

	int Nugget3ID = rmCreateObjectDef("Nugget3"); 
	rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget3ID, 0);
	rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.30));
	rmSetNuggetDifficulty(3,3);
	rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidHunt1Min);
	rmAddObjectDefConstraint(Nugget3ID, avoidHunt2Min);
	rmAddObjectDefConstraint(Nugget3ID, avoidHunt3Min);
	rmAddObjectDefConstraint(Nugget3ID, avoidBerriesMin);	
	rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget3ID, avoidIslandFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidSeaShort);
	rmAddObjectDefConstraint(Nugget3ID, avoidStartingResources);
	rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmAddObjectDefConstraint(Nugget3ID, stayMidSmIsland);
	if (PlayerNum > 2)
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, nugget3count);

	// Treasures 2
	int Nugget2ID = rmCreateObjectDef("Nugget2"); 
	rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget2ID, 0);
	rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.48));
	rmSetNuggetDifficulty(2,2);
	rmAddObjectDefConstraint(Nugget2ID, avoidHunt1Min);
	rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min);
	rmAddObjectDefConstraint(Nugget2ID, avoidHunt3Min);
	rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
//	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
//		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
//	else
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
	rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin);	
	rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget2ID, avoidIslandFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketMin);
	if (TeamNum == 2 && PlayerNum == 2)
		rmAddObjectDefConstraint(Nugget2ID, stayMidSmIsland);
	rmAddObjectDefConstraint(Nugget2ID, avoidSeaShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidStartingResources);
	rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, nugget2count);

	// Treasures 1
	int NuggetID = rmCreateObjectDef("Nugget"); 
	rmAddObjectDefItem(NuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(NuggetID, 0);
	rmSetObjectDefMaxDistance(NuggetID, rmXFractionToMeters(0.48));
	rmSetNuggetDifficulty(1,1);
	rmAddObjectDefConstraint(NuggetID, avoidImpassableLand);
	if (rmGetIsTreaty() == true && teamOneCount == teamZeroCount && TeamNum == 2)
		rmAddObjectDefConstraint(NuggetID, avoidNuggetFar);
	else
		rmAddObjectDefConstraint(NuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(NuggetID, avoidNatives);
	rmAddObjectDefConstraint(NuggetID, avoidGoldMin);
	rmAddObjectDefConstraint(NuggetID, avoidHunt1Min);
	rmAddObjectDefConstraint(NuggetID, avoidHunt2Min);
	rmAddObjectDefConstraint(NuggetID, avoidHunt3Min);
	rmAddObjectDefConstraint(NuggetID, avoidBerriesMin);	
	rmAddObjectDefConstraint(NuggetID, avoidForestMin);	
	rmAddObjectDefConstraint(NuggetID, avoidTownCenterFar);
	rmAddObjectDefConstraint(NuggetID, avoidIslandFar);
	rmAddObjectDefConstraint(NuggetID, avoidSeaShort);
	rmAddObjectDefConstraint(NuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(NuggetID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(NuggetID, avoidTradeRouteSocketMin);
	rmPlaceObjectDefAtLoc(NuggetID, 0, 0.50, 0.50, nuggetcount);
		
	// ____________________ Fishes ____________________
	int fishcount = -1;
	fishcount = 5*PlayerNum;
	
	//Whales
	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, "MinkeWhale", 1, 0.0);
	rmSetObjectDefMinDistance(whaleID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.05));
//	rmAddObjectDefConstraint(whaleID, avoidWhale);
	rmAddObjectDefConstraint(whaleID, avoidEdge);
	rmAddObjectDefConstraint(whaleID, avoidLandFar);
	rmAddObjectDefConstraint(whaleID, avoidIsland);
	rmAddObjectDefConstraint(whaleID, avoidColonyShip);
	rmAddObjectDefConstraint(whaleID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(whaleID, avoidKOTH);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.15, 0.15);
	if (PlayerNum == 2)
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.05, 0.50);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.15, 0.85);
	if (PlayerNum > 2)
	{
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.05, 0.60);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.05, 0.40);
	}	
	if (PlayerNum > 4)
	{
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.10, 0.30);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.10, 0.70);
	}	
	if (PlayerNum > 6)
	{
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.25, 0.10);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.25, 0.90);
	}

	//Fish
	int cornerFishID = rmCreateObjectDef("corner fish");
	rmAddObjectDefItem(cornerFishID, fishies, 2, 8.0);
	rmSetObjectDefMinDistance(cornerFishID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(cornerFishID, rmXFractionToMeters(0.025));
	rmAddObjectDefConstraint(cornerFishID, avoidFish);
	rmAddObjectDefConstraint(cornerFishID, avoidWhaleMin);
	rmAddObjectDefConstraint(cornerFishID, avoidKOTH);
	rmAddObjectDefConstraint(cornerFishID, avoidLandShort);
	rmAddObjectDefConstraint(cornerFishID, avoidColonyShipShort);
	rmAddObjectDefConstraint(cornerFishID, avoidIslandMin);
	rmAddObjectDefConstraint(cornerFishID, avoidTradeRouteMin);
	rmPlaceObjectDefAtLoc(cornerFishID, 0, 0.25, 0.10);
	rmPlaceObjectDefAtLoc(cornerFishID, 0, 0.25, 0.90);

	int fishID = rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, fishies, 2, 8.0);
	rmSetObjectDefMinDistance(fishID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.48));
	rmAddObjectDefConstraint(fishID, avoidFish);
	rmAddObjectDefConstraint(fishID, avoidWhaleMin);
	rmAddObjectDefConstraint(fishID, avoidKOTH);
	rmAddObjectDefConstraint(fishID, avoidLandShort);
	rmAddObjectDefConstraint(fishID, avoidColonyShipShort);
	rmAddObjectDefConstraint(fishID, avoidIslandMin);
	rmAddObjectDefConstraint(fishID, avoidTradeRouteMin);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50, fishcount);

	// Text
	rmSetStatusText("",1.00);
	
} // END