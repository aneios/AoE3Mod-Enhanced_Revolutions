// Central Asia LARGE (a new map for DE)
// by vividlyplain, May 2022

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
	// Strings
	string wetType = "";	
	string riverType = "";	
    string paintMix1 = "";
    string paintMix2 = "";
    string paintMix3 = "";
    string forestMix = "";
    string mntType = "Manchuria";
    string initLand = "";
    string shineAlight = "";
	if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "Mongolia_skirmish";
	if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "deccan_skirmish";
	if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "adirondacks_skirmish";
	if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "Hokkaido_skirmish";
	else if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "GreatLakes_Summer_skirmish";
	else if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "Patagonia_skirmish";
	else if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "Punjab_skirmish";
	else if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "rm_afri_ivorycoast";
	else if (rmRandFloat(0,1) <= 0.50)
	    shineAlight = "Manchuria_skirmish";
	else
	    shineAlight = "Yucatan_skirmish";
	string toiletPaper = "water";
	string forTesting = "testmix";	 
    string treasureSet = "mongolia";
    string food1 = "ypNilgai";
    string food2 = "ypSerow";
    string fishies = "FishSalmon";
    string treeType1 = "";
    string treeType2 = "";
    string treeType3 = "";
    string brushType1 = "";
    string brushType2 = "";
    string brushType3 = "";
    string brushType4 = "";

		wetType = "Manchuria Inland";		
		riverType = "Manchuria Inland";
		paintMix1 = "mongolia_desert";
		paintMix2 = "mongolia_grass";
		paintMix3 = "mongolia_grass_b";
		forestMix = "mongolia_forest";
    	initLand = "grass";
    	treeType1 = "ypTreeMongolianFir";
    	treeType2 = "ypTreeSaxaul";
    	treeType3 = "TreeJuniper";
    	brushType1 = "deUnderbrushDesertAlt";
    	brushType2 = "UnderbrushBlackhills";
    	brushType3 = "RiverRocksSmall";
    	brushType4 = "UnderbrushMongolia";

	string natType1 = "Tengri";
	string natType2 = "Sufi";
	string natGrpName1 = "native tengri village 0";
	string natGrpName2 = "native sufi mosque mongol ";

	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);

	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ____________________ General ____________________
	// Picks the map size
	int playerTiles=22000;
	if (PlayerNum >= 4)
		playerTiles = 20000;
	else if (PlayerNum >= 6)
		playerTiles = 18000;
	
	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmSetMapSize(size, size);

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
	int classPlateau = rmDefineClass("plateau");
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
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.45), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.10), rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.05), rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int stayNorth = rmCreatePieConstraint("stay north", 0.50, 0.50,rmXFractionToMeters(0.15), rmXFractionToMeters(0.45), rmDegreesToRadians(000),rmDegreesToRadians(090));
	int stayWest = rmCreatePieConstraint("stay west", 0.50, 0.50,rmXFractionToMeters(0.15), rmXFractionToMeters(0.45), rmDegreesToRadians(270),rmDegreesToRadians(000));
	int stayNE = rmCreatePieConstraint("Stay NE", 0.50, 0.50,rmXFractionToMeters(0.10), rmXFractionToMeters(0.45), rmDegreesToRadians(060),rmDegreesToRadians(120));
	int stayNW = rmCreatePieConstraint("Stay NW", 0.50, 0.50,rmXFractionToMeters(0.10), rmXFractionToMeters(0.45), rmDegreesToRadians(330),rmDegreesToRadians(030));
	int staySE = rmCreatePieConstraint("Stay SE", 0.50, 0.50,rmXFractionToMeters(0.10), rmXFractionToMeters(0.45), rmDegreesToRadians(150),rmDegreesToRadians(210));
	int staySW = rmCreatePieConstraint("Stay SW", 0.50, 0.50,rmXFractionToMeters(0.10), rmXFractionToMeters(0.45), rmDegreesToRadians(240),rmDegreesToRadians(300));
		
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 24.0);
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 16.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 36.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 12.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 64.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 20.0);
	int avoidHunt2Med = rmCreateTypeDistanceConstraint("avoid hunt2 med", food2, 33.0);
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 75.0);
	int avoidHunt2VeryFar = rmCreateTypeDistanceConstraint("avoid hunt2 very far", food2, 65.0);
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 75.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 64.0);
	int avoidHunt1Med = rmCreateTypeDistanceConstraint("avoid hunt1 med", food1, 33.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 20.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 30.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 30);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 18.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 76.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 90.0);
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
	int avoidEmbellishment = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 12.0);
	int avoidEmbellishmentFar = rmCreateClassDistanceConstraint("grass avoid grass far", rmClassID("grass"), 24.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidPlayer=rmCreateClassDistanceConstraint("avoid player", classIsland, 24.0);
	int avoidPlateau = rmCreateClassDistanceConstraint("avoid plateau", rmClassID("plateau"), 2.0);
	int avoidPlateauFar = rmCreateClassDistanceConstraint("avoid plateau far", rmClassID("plateau"), 32.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 4.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 8.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 16.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 1.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
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
	int avoidPondFar=rmCreateClassDistanceConstraint("avoid pond far", classPond, 16+PlayerNum);
	int avoidPondShort=rmCreateClassDistanceConstraint("avoid pond short", classPond, 4.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 12.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 2.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 6.0);
    int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 4.0);
    int treeWaterFar = rmCreateTerrainDistanceConstraint("trees avoid river far", "Land", false, 8.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "fish", 20.0);

	// ____________________ Player Placement ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	int teamOne = rmRandInt(0,1);
	int teamTwo = -1;
	if (teamOne == 0)
		teamTwo = 1;
	else
		teamTwo = 0;

	if (cNumberTeams <= 2) // 1v1 and TEAM
	{
		if (teamZeroCount == teamOneCount) // equal N of players per TEAM
		{
			if (teamZeroCount == 1) // 1v1
			{
				rmSetPlacementTeam(teamOne);
				rmSetPlacementSection(0.75, 0.76); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.35, 0.35, 0);

				rmSetPlacementTeam(teamTwo);
				rmSetPlacementSection(0.25, 0.26); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.35, 0.35, 0);	
			}
			if (teamZeroCount == 2) // 2v2
			{
				rmSetPlacementTeam(teamOne);
				rmSetPlacementSection(0.70, 0.80); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.36, 0.36, 0);

				rmSetPlacementTeam(teamTwo);
				rmSetPlacementSection(0.20, 0.30); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.36, 0.36, 0);	
			}
			else // 3v3
			{
				rmSetPlacementTeam(teamOne);
				rmSetPlacementSection(0.675, 0.825); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.37, 0.37, 0);

				rmSetPlacementTeam(teamTwo);
				rmSetPlacementSection(0.175, 0.325); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.37, 0.37, 0);	
			}
		}
		else 
		{
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.675, 0.825); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.38, 0.38, 0);

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.175, 0.325); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.38, 0.38, 0);	
		}
	}
	else  //FFA
		{	
			rmSetPlacementSection(0.70, 0.30);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.36, 0.36, 0.0);
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
		rmSetAreaCoherence(playerareaID, 0.888);
		rmSetAreaMix(playerareaID, paintMix2);
//		rmSetAreaBaseHeight(playerareaID, 2.0); 
		rmBuildArea(playerareaID);
	}
	
	// ____________________ Trade Routes ____________________
	if (TeamNum <= 2)
	{
		int tradeRouteID = rmCreateTradeRoute();

		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 2.0);
        rmSetObjectDefMaxDistance(socketID, 8.0);      
		
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.10, 0.90);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.90);
		
        rmBuildTradeRoute(tradeRouteID, toiletPaper);
	}

	// Grass Zones
	int dryGrass1ID = rmCreateArea("dry grass NW");
	rmSetAreaSize(dryGrass1ID, 0.30);
	rmSetAreaLocation(dryGrass1ID, 0.50, 0.99);
	rmAddAreaInfluenceSegment(dryGrass1ID, 0.10, 0.90, 0.90, 0.90);
	rmSetAreaWarnFailure(dryGrass1ID, false);
	rmSetAreaMix(dryGrass1ID, paintMix2); 
//	rmSetAreaMix(dryGrass1ID, forTesting); 
	rmSetAreaCoherence(dryGrass1ID, 0.85); 
	rmSetAreaObeyWorldCircleConstraint(dryGrass1ID, false);
	rmBuildArea(dryGrass1ID);	

	int avoidDryGrassMin = rmCreateAreaDistanceConstraint("avoid dry grass min", dryGrass1ID, 4.0);
	int avoidDryGrassShort = rmCreateAreaDistanceConstraint("avoid dry grass short", dryGrass1ID, 8.0);
	int avoidDryGrass = rmCreateAreaDistanceConstraint("avoid dry grass", dryGrass1ID, 12.0);
	int avoidDryGrassFar = rmCreateAreaDistanceConstraint("avoid dry grass far", dryGrass1ID, 20.0);
	int stayDryGrass = rmCreateAreaMaxDistanceConstraint("stay in dry grass", dryGrass1ID, 0);	

	int grasszoneID = rmCreateArea("grass zone");
	rmSetAreaSize(grasszoneID, 0.12);
	rmSetAreaLocation(grasszoneID, 0.50, 0.70);
	rmAddAreaInfluenceSegment(grasszoneID, 0.40, 0.70, 0.60, 0.70);
	rmSetAreaWarnFailure(grasszoneID, false);
	rmSetAreaMix(grasszoneID, paintMix3); 
//	rmSetAreaMix(grasszoneID, forTesting); 
	rmSetAreaCoherence(grasszoneID, 0.80); 
	rmSetAreaObeyWorldCircleConstraint(grasszoneID, false);
	rmAddAreaConstraint(grasszoneID, avoidImpassableLand);
	rmAddAreaConstraint(grasszoneID, avoidTradeRouteSocket);
	rmAddAreaConstraint(grasszoneID, avoidIsland);
	rmBuildArea(grasszoneID);	

	int avoidGrassMin = rmCreateAreaDistanceConstraint("avoid grass min", grasszoneID, 4.0);
	int avoidGrassShort = rmCreateAreaDistanceConstraint("avoid grass short", grasszoneID, 8.0);
	int avoidGrass = rmCreateAreaDistanceConstraint("avoid grass", grasszoneID, 12.0);
	int avoidGrassFar = rmCreateAreaDistanceConstraint("avoid grass far", grasszoneID, 20.0);
	int stayGrass = rmCreateAreaMaxDistanceConstraint("stay in grass", grasszoneID, 0);	

	int tpGrassID = rmCreateArea("tp grass zone");
	rmSetAreaSize(tpGrassID, 0.05);
	rmSetAreaLocation(tpGrassID, 0.50, 0.99);
	rmAddAreaInfluenceSegment(tpGrassID, 0.20, 1.00, 0.80, 1.00);
	rmSetAreaWarnFailure(tpGrassID, false);
	rmSetAreaMix(tpGrassID, paintMix3); 
//	rmSetAreaMix(tpGrassID, forTesting); 
	rmSetAreaCoherence(tpGrassID, 0.85); 
	rmSetAreaObeyWorldCircleConstraint(tpGrassID, false);
	rmAddAreaConstraint(tpGrassID, avoidTradeRouteMin);
	rmAddAreaConstraint(tpGrassID, avoidImpassableLand);
	rmAddAreaConstraint(tpGrassID, avoidTradeRouteSocket);
	rmBuildArea(tpGrassID);	

	// Rivers
	int riverID = rmRiverCreate(-1, riverType, 1, 1, 4+PlayerNum/2, 4+PlayerNum/2);  
	rmRiverAddWaypoint(riverID, 0.95, 0.00);
	rmRiverAddWaypoint(riverID, 0.90, 0.10);
	rmRiverAddWaypoint(riverID, 0.70, 0.20);
	rmRiverAddWaypoint(riverID, 0.63, 0.30);
	rmRiverAddWaypoint(riverID, 0.58, 0.40);
	rmRiverAddWaypoint(riverID, 0.56, 0.50);
	rmRiverAddWaypoint(riverID, 0.55, 0.60);
	rmRiverSetShallowRadius(riverID, 10+PlayerNum);
	rmRiverAddShallow(riverID, 0.00);
	rmRiverAddShallow(riverID, 0.10);
	rmRiverAddShallow(riverID, 0.20);
	rmRiverAddShallow(riverID, 0.30);
	rmRiverAddShallow(riverID, 0.40);
	rmRiverAddShallow(riverID, 0.50);
	rmRiverAddShallow(riverID, 0.60);
	rmRiverAddShallow(riverID, 0.70);
	rmRiverAddShallow(riverID, 0.80);
	rmRiverAddShallow(riverID, 0.90);
	rmRiverAddShallow(riverID, 0.99);

	int river2ID = rmRiverCreate(-1, riverType, 1, 1, 4+PlayerNum/2, 4+PlayerNum/2);  
	rmRiverAddWaypoint(river2ID, 0.00, 0.05);
	rmRiverAddWaypoint(river2ID, 0.10, 0.10);
	rmRiverAddWaypoint(river2ID, 0.30, 0.20);
	rmRiverAddWaypoint(river2ID, 0.37, 0.30);
	rmRiverAddWaypoint(river2ID, 0.42, 0.40);
	rmRiverAddWaypoint(river2ID, 0.44, 0.50);
	rmRiverAddWaypoint(river2ID, 0.45, 0.60);
	rmRiverSetShallowRadius(river2ID, 10+PlayerNum);
	rmRiverAddShallow(river2ID, 0.00);
	rmRiverAddShallow(river2ID, 0.10);
	rmRiverAddShallow(river2ID, 0.20);
	rmRiverAddShallow(river2ID, 0.30);
	rmRiverAddShallow(river2ID, 0.40);
	rmRiverAddShallow(river2ID, 0.50);
	rmRiverAddShallow(river2ID, 0.60);
	rmRiverAddShallow(river2ID, 0.70);
	rmRiverAddShallow(river2ID, 0.80);
	rmRiverAddShallow(river2ID, 0.90);
	rmRiverAddShallow(river2ID, 0.99);

//	if (TeamNum == 2)
//	{
		rmRiverBuild(riverID);	
		rmRiverBuild(river2ID);	
//	}

    // Shallows Décor
	int shoreGrassStayWater = rmCreateTerrainMaxDistanceConstraint("shore grass stays near the water", "Land", false, 0.0);
	int stayNearRiver = rmCreateTerrainMaxDistanceConstraint("trees stay near the water", "Land", false, 8.0);
    int avoidGrassForest=rmCreateClassDistanceConstraint("avoid grass tiny", classGrass, 4.0);
	int grassNumber = 90*PlayerNum;

	int riverDecorID=rmCreateObjectDef("decorate the shallows");
	rmAddObjectDefItem(riverDecorID, brushType2, 1, 3);
	rmAddObjectDefItem(riverDecorID, brushType3, 1, 2);
	rmAddObjectDefToClass(riverDecorID, classGrass); 
	rmSetObjectDefMinDistance(riverDecorID, 0);
	rmSetObjectDefMaxDistance(riverDecorID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(riverDecorID, avoidGrassForest);
	rmAddObjectDefConstraint(riverDecorID, shoreGrassStayWater);
	rmPlaceObjectDefAtLoc(riverDecorID, 0, 0.5, 0.5, grassNumber);

	// central dry grass
	int dryGrass2ID = rmCreateArea("dry grass central");
	rmSetAreaSize(dryGrass2ID, 0.15);
	rmSetAreaLocation(dryGrass2ID, 0.50, 0.25);
	rmSetAreaWarnFailure(dryGrass2ID, false);
	rmSetAreaMix(dryGrass2ID, paintMix2); 
//	rmSetAreaMix(dryGrass2ID, forTesting); 
	rmSetAreaCoherence(dryGrass2ID, 0.85); 
	rmSetAreaObeyWorldCircleConstraint(dryGrass2ID, true);
	rmAddAreaConstraint(dryGrass2ID, treeWater);
	rmAddAreaConstraint(dryGrass2ID, avoidGrassForest);
	rmBuildArea(dryGrass2ID);	

	// place tr sockets
	if (TeamNum <= 2)
	{
        vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.14);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		
		if (PlayerNum > 2)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.32);
        	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		
		if (PlayerNum == 2 || PlayerNum > 4)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
        	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		
		if (PlayerNum > 2)
		{
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.68);
        	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.86);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	}

	// ____________________ Natives ____________________
	//Choose Natives
    int subCiv0 = -1;
    int subCiv1 = -1;
    subCiv0 = rmGetCivID(natType1);
    subCiv1 = rmGetCivID(natType2);
    rmSetSubCiv(0, natType1);
    rmSetSubCiv(1, natType2);
	
	float xNatLocA = 0.25;
	float yNatLocA = 0.35;
	float xNatLocB = 0.50;
	float yNatLocB = 0.27;
	float xNatLocC = 0.75;
	float yNatLocC = 0.35;

	int natChooser = rmRandInt(1,2);
	
	// Set up Natives	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
	
	if (natChooser == 1)
	{
		nativeID0 = rmCreateGrouping("native site 1", natGrpName2+whichVillage1);
		nativeID1 = rmCreateGrouping("native site 2", natGrpName1+whichVillage2);
		nativeID2 = rmCreateGrouping("native site 3", natGrpName2+whichVillage3);
	}
	else
	{
		nativeID0 = rmCreateGrouping("native site 1", natGrpName1+whichVillage1);
		nativeID1 = rmCreateGrouping("native site 2", natGrpName2+whichVillage2);
		nativeID2 = rmCreateGrouping("native site 3", natGrpName1+whichVillage3);
	}

	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));

	// place natives
	rmPlaceGroupingAtLoc(nativeID0, 0, xNatLocA, yNatLocA);
	rmPlaceGroupingAtLoc(nativeID1, 0, xNatLocB, yNatLocB);
	rmPlaceGroupingAtLoc(nativeID2, 0, xNatLocC, yNatLocC);

	// nat islands
	int natIsle1ID=rmCreateArea("Nat 1 Island");
	rmSetAreaSize(natIsle1ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle1ID, xNatLocA, yNatLocA);
	rmSetAreaMix(natIsle1ID, paintMix2);
	rmAddAreaToClass(natIsle1ID, classIsland);
	rmSetAreaCoherence(natIsle1ID, 0.90);
	rmBuildArea(natIsle1ID); 

	int natIsle2ID=rmCreateArea("Nat 2 Island");
	rmSetAreaSize(natIsle2ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle2ID, xNatLocB, yNatLocB);
	rmSetAreaMix(natIsle2ID, paintMix2);
	rmAddAreaToClass(natIsle2ID, classIsland);
	rmSetAreaCoherence(natIsle2ID, 0.90);
	rmBuildArea(natIsle2ID); 

	int natIsle3ID=rmCreateArea("Nat 3 Island");
	rmSetAreaSize(natIsle3ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle3ID, xNatLocC, yNatLocC);
	rmSetAreaMix(natIsle3ID, paintMix2);
	rmAddAreaToClass(natIsle3ID, classIsland);
	rmSetAreaCoherence(natIsle3ID, 0.90);
	rmBuildArea(natIsle3ID); 

	// ____________________ Avoidance Islands ____________________
	int midLineID=rmCreateArea("Mid Line");
	rmSetAreaSize(midLineID, 0.05);
	rmSetAreaLocation(midLineID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(midLineID, 0.50, 0.00, 0.50, 1.00);
//	rmSetAreaMix(midLineID, forTesting); 	
	rmSetAreaCoherence(midLineID, 1.00);
	rmBuildArea(midLineID); 
	
	int avoidMidLine = rmCreateAreaDistanceConstraint("avoid mid line ", midLineID, 8.0);
	int avoidMidLineMin = rmCreateAreaDistanceConstraint("avoid mid line min", midLineID, 0.5);
	int avoidMidLineFar = rmCreateAreaDistanceConstraint("avoid mid line far", midLineID, 16.0);
	int stayMidLine = rmCreateAreaMaxDistanceConstraint("stay mid line ", midLineID, 0.0);

	int midIslandID=rmCreateArea("Mid Island");
	rmSetAreaSize(midIslandID, 0.38+.005*PlayerNum);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
//	rmSetAreaMix(midIslandID, forTesting); 	
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.20);
	rmSetAreaLocation(midSmIslandID, 0.5, 0.5);
//	rmSetAreaMix(midSmIslandID, "great plains drygrass"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 1.00);
//	rmAddAreaConstraint(midSmIslandID, avoidWaterShort);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	// ____________________ Aral Sea ____________________
	int pondcount = 1;
	int stayNearPond = -1;
	int stayPond = -1;

	for (i=0; < pondcount)
	{
		int pondID=rmCreateArea("pond"+i);
		rmSetAreaWaterType(pondID, wetType);
		rmSetAreaObeyWorldCircleConstraint(pondID, true);
		rmSetAreaWarnFailure(pondID, false);
		rmAddAreaToClass(pondID, classPond);
		rmSetAreaCoherence(pondID, 0.69);
		rmSetAreaSize(pondID, 0.07);
		rmSetAreaLocation(pondID, 0.50, 0.70);
		rmAddAreaInfluenceSegment(pondID, 0.40, 0.70, 0.60, 0.70);
		rmAddAreaConstraint(pondID, avoidPlayer);
		rmAddAreaConstraint(pondID, avoidStartingResources);
		rmAddAreaConstraint(pondID, avoidGoldMin);
		rmAddAreaConstraint(pondID, avoidIslandShort);
		rmAddAreaConstraint(pondID, stayGrass);
		rmAddAreaConstraint(pondID, avoidTradeRouteSocket);
		rmBuildArea(pondID);
	
		stayNearPond = rmCreateAreaMaxDistanceConstraint("stay near pond"+i, pondID, 12.0);
		stayPond = rmCreateAreaMaxDistanceConstraint("stay in pond"+i, pondID, 0.0);

		int pondTreeID = rmCreateObjectDef("pond tree"+i);
		rmAddObjectDefItem(pondTreeID, brushType1, 6, 4.0);
		rmAddObjectDefItem(pondTreeID, treeType1, 3, 4.0);
		rmAddObjectDefItem(pondTreeID, treeType2, 3, 4.0);
		rmSetObjectDefMinDistance(pondTreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(pondTreeID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(pondTreeID, classForest);
		rmAddObjectDefConstraint(pondTreeID, avoidGrassForest);
		rmAddObjectDefConstraint(pondTreeID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(pondTreeID, avoidForestShort);
		rmAddObjectDefConstraint(pondTreeID, stayNearPond);
		rmAddObjectDefConstraint(pondTreeID, avoidPondMin);
		rmAddObjectDefConstraint(pondTreeID, avoidNatives);
		rmAddObjectDefConstraint(pondTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(pondTreeID, avoidIslandMin);
		rmPlaceObjectDefAtLoc(pondTreeID, 0, 0.50, 0.50, 10+5*PlayerNum);

		int fishID = rmCreateObjectDef("fish"+i);
		rmAddObjectDefItem(fishID, fishies, 2, 5.0);
		rmSetObjectDefMinDistance(fishID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(fishID,  rmXFractionToMeters(0.48));
		rmAddObjectDefConstraint(fishID, stayPond);
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50, 10+4*PlayerNum);
	}

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true)
	{
		float xLoc = 0.5;
		float yLoc = 0.4;
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

	// Plateau
	int classAvoidance = rmDefineClass("avoidance");
	for (i=0; < 5)
	{
		int avoidTHisID=rmCreateArea("avoid this island"+i);
		rmSetAreaSize(avoidTHisID, 0.002);
		if (i == 0)
			rmSetAreaLocation(avoidTHisID, 0.25, 0.11);
		else if (i == 1)
			rmSetAreaLocation(avoidTHisID, 0.75, 0.11);
		else if (i == 2)
			rmSetAreaLocation(avoidTHisID, 0.20, 0.27);
		else if (i == 3)
			rmSetAreaLocation(avoidTHisID, 0.80, 0.27);
		else
			rmSetAreaLocation(avoidTHisID, 0.50, 0.13);
		rmAddAreaToClass(avoidTHisID, classAvoidance);
//		rmSetAreaMix(avoidTHisID, "testmix");
		rmSetAreaCoherence(avoidTHisID, 1.00);
		rmBuildArea(avoidTHisID); 
	}

	int plateauID = rmCreateArea("plateau");
	rmSetAreaSize(plateauID, 0.10); 
	rmSetAreaWarnFailure(plateauID, false);
	rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	rmAddAreaToClass(plateauID, classCliff); 	
	rmSetAreaCliffType(plateauID, mntType); 	
	rmSetAreaCliffHeight(plateauID, 12, 0.0, 0.2);
	rmSetAreaCliffEdge(plateauID, 1, 1.00, 0.0, 0.0, 1);
	rmSetAreaCoherence(plateauID, 1.00);
	rmSetAreaSmoothDistance(plateauID, 0);
	rmSetAreaLocation(plateauID, 0.50, 0.05);
	rmAddAreaCliffEdgeAvoidClass(plateauID, classAvoidance, 1);
	rmAddAreaConstraint(plateauID, avoidMidIsland);
	rmAddAreaConstraint(plateauID, avoidIslandMin);
	rmAddAreaConstraint(plateauID, treeWater);
	rmBuildArea(plateauID);

	int stayPlateau = rmCreateAreaMaxDistanceConstraint("stay in plateau", plateauID, 0.0);
	int stayNearPlateau = rmCreateAreaMaxDistanceConstraint("stay near plateau", plateauID, 4.0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid ramp", plateauID, 4+PlayerNum);

	int plateauPaintID=rmCreateArea("paint the plateau");
	rmSetAreaSize(plateauPaintID, 0.15);
	rmSetAreaLocation(plateauPaintID, 0.50, 0.05);
	rmSetAreaMix(plateauPaintID, paintMix3);
	rmSetAreaCoherence(plateauPaintID, 1.00);
	rmAddAreaConstraint(plateauPaintID, stayNearPlateau); 
	rmBuildArea(plateauPaintID); 

	// small cliffs
	for (i=0; < PlayerNum)
	{
		int stayInMountain = -1;

		int mountainID=rmCreateArea("mountain"+i);
		rmSetAreaSize(mountainID, 0.001);
		rmSetAreaCliffType(mountainID, mntType);  
		rmSetAreaTerrainType(mountainID, initLand);
		rmSetAreaWarnFailure(mountainID, false);
		rmAddAreaToClass(mountainID, classPlateau);
		rmSetAreaObeyWorldCircleConstraint(mountainID, true);
		rmSetAreaCliffHeight(mountainID, 10, 0.0, 0.4);
		rmSetAreaCliffEdge(mountainID, 1, 1.0, 0.0, 0.0, 1);
		rmSetAreaCoherence(mountainID, 0.666);
		if (i == 0 && PlayerNum == 2)
			rmSetAreaLocation(mountainID, 0.60, 0.07);
		if (i == 1 && PlayerNum == 2)
			rmSetAreaLocation(mountainID, 0.40, 0.07);
		rmAddAreaConstraint(mountainID, avoidNuggetMin);
		rmAddAreaConstraint(mountainID, avoidGoldShort);
		rmAddAreaConstraint(mountainID, avoidEdge);
		rmAddAreaConstraint(mountainID, stayPlateau);
		if (PlayerNum > 2)
		{
			rmAddAreaConstraint(mountainID, avoidRamp);
			rmAddAreaConstraint(mountainID, avoidPlateauFar);
		}
		rmBuildArea(mountainID);

		stayInMountain = rmCreateAreaMaxDistanceConstraint("stay in mountain"+i, mountainID, 2.0);

		int mountainTopID=rmCreateArea("mountaintop"+i);
		rmSetAreaSize(mountainTopID, 0.02);
		rmSetAreaMix(mountainTopID, paintMix1);
		rmSetAreaWarnFailure(mountainTopID, false);
		rmSetAreaObeyWorldCircleConstraint(mountainTopID, false);
		rmSetAreaCoherence(mountainTopID, 0.999);
		rmAddAreaConstraint(mountainTopID, stayInMountain);
		rmBuildArea(mountainTopID);

		int cliffTopPropID = rmCreateObjectDef("cliff top props"+i);
		rmAddObjectDefItem(cliffTopPropID, brushType4, rmRandInt(1,3), 7.0);
		rmSetObjectDefMinDistance(cliffTopPropID, 50);
		rmSetObjectDefMaxDistance(cliffTopPropID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(cliffTopPropID, rmClassID("grass"));
		rmAddObjectDefConstraint(cliffTopPropID, stayInMountain);
		rmAddObjectDefConstraint(cliffTopPropID, avoidEmbellishmentShort);
		rmPlaceObjectDefAtLoc(cliffTopPropID, 0, 0.50, 0.50, 2);
	}

	int plateau2ID = rmCreateArea("plateau2");
	rmSetAreaSize(plateau2ID, 0.03); 
	rmSetAreaWarnFailure(plateau2ID, false);
	rmSetAreaObeyWorldCircleConstraint(plateau2ID, false);
	rmAddAreaToClass(plateau2ID, classCliff); 	
	rmSetAreaCliffType(plateau2ID, mntType); 	
	rmSetAreaCliffHeight(plateau2ID, 6, 0.0, 0.2);
	rmSetAreaCliffEdge(plateau2ID, 1, 1.00, 0.0, 0.0, 1);
	rmSetAreaCoherence(plateau2ID, 0.80);
	rmSetAreaSmoothDistance(plateau2ID, 0);
	rmSetAreaLocation(plateau2ID, 0.10, 0.20);
	rmAddAreaCliffEdgeAvoidClass(plateau2ID, classAvoidance, 1);
	rmAddAreaConstraint(plateau2ID, avoidMidIsland);
	rmAddAreaConstraint(plateau2ID, avoidNatives);
	rmAddAreaConstraint(plateau2ID, avoidIslandMin);
	rmAddAreaConstraint(plateau2ID, treeWater);
	rmBuildArea(plateau2ID);

	int stayPlateau2 = rmCreateAreaMaxDistanceConstraint("stay in plateau2", plateau2ID, 0.0);
	int stayNearPlateau2 = rmCreateAreaMaxDistanceConstraint("stay near plateau2", plateau2ID, 4.0);

	int plateauPaint2ID=rmCreateArea("paint the plateau2");
	rmSetAreaSize(plateauPaint2ID, 0.05);
	rmSetAreaLocation(plateauPaint2ID, 0.10, 0.20);
	rmSetAreaMix(plateauPaint2ID, paintMix3);
	rmSetAreaCoherence(plateauPaint2ID, 1.00);
	rmAddAreaConstraint(plateauPaint2ID, stayNearPlateau2); 
	rmBuildArea(plateauPaint2ID); 

	int plateau3ID = rmCreateArea("plateau3");
	rmSetAreaSize(plateau3ID, 0.03); 
	rmSetAreaWarnFailure(plateau3ID, false);
	rmSetAreaObeyWorldCircleConstraint(plateau3ID, false);
	rmAddAreaToClass(plateau3ID, classCliff); 	
	rmSetAreaCliffType(plateau3ID, mntType); 	
	rmSetAreaCliffHeight(plateau3ID, 6, 0.0, 0.2);
	rmSetAreaCliffEdge(plateau3ID, 1, 1.00, 0.0, 0.0, 1);
	rmSetAreaCoherence(plateau3ID, 0.80);
	rmSetAreaSmoothDistance(plateau3ID, 0);
	rmSetAreaLocation(plateau3ID, 0.90, 0.20);
	rmAddAreaCliffEdgeAvoidClass(plateau3ID, classAvoidance, 1);
	rmAddAreaConstraint(plateau3ID, avoidMidIsland);
	rmAddAreaConstraint(plateau3ID, avoidNatives);
	rmAddAreaConstraint(plateau3ID, avoidIslandMin);
	rmAddAreaConstraint(plateau3ID, treeWater);
	rmBuildArea(plateau3ID);

	int stayPlateau3 = rmCreateAreaMaxDistanceConstraint("stay in plateau3", plateau3ID, 0.0);
	int stayNearPlateau3 = rmCreateAreaMaxDistanceConstraint("stay near plateau3", plateau3ID, 4.0);

	int plateauPaint3ID=rmCreateArea("paint the plateau3");
	rmSetAreaSize(plateauPaint3ID, 0.05);
	rmSetAreaLocation(plateauPaint3ID, 0.90, 0.20);
	rmSetAreaMix(plateauPaint3ID, paintMix3);
	rmSetAreaCoherence(plateauPaint3ID, 1.00);
	rmAddAreaConstraint(plateauPaint3ID, stayNearPlateau3); 
	rmBuildArea(plateauPaint3ID); 

	// Embellishments
	int grasscount = 10+6*PlayerNum;

	for (i=0; < grasscount)
	{
		int propGrassID = rmCreateObjectDef("grass props"+i);
		rmAddObjectDefItem(propGrassID, brushType4, rmRandInt(2,5), 7.0);
		rmSetObjectDefMinDistance(propGrassID, 50);
		rmSetObjectDefMaxDistance(propGrassID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(propGrassID, rmClassID("grass"));
		if (i < grasscount/2)
			rmAddObjectDefConstraint(propGrassID, stayNearPlateau);
		else if (i < 3*grasscount/4)
			rmAddObjectDefConstraint(propGrassID, stayNearPlateau2);
		else
			rmAddObjectDefConstraint(propGrassID, stayNearPlateau3);
		rmAddObjectDefConstraint(propGrassID, avoidStartingResources);
		rmAddObjectDefConstraint(propGrassID, avoidEmbellishmentFar);
		rmPlaceObjectDefAtLoc(propGrassID, 0, 0.50, 0.50);
	}

	// Static Mines 
	int staticGoldID = rmCreateObjectDef("static gold");
	rmAddObjectDefItem(staticGoldID, "MineGold", 1, 0.0);
	rmSetObjectDefMinDistance(staticGoldID, rmXFractionToMeters(0.000));
	rmSetObjectDefMaxDistance(staticGoldID, rmXFractionToMeters(0.025));
	rmAddObjectDefToClass(staticGoldID, classStartingResource);
	rmAddObjectDefToClass(staticGoldID, classGold);
	rmAddObjectDefConstraint(staticGoldID, avoidPlateau);
	rmAddObjectDefConstraint(staticGoldID, avoidNativesMin);
	rmAddObjectDefConstraint(staticGoldID, avoidForestMin);
	rmAddObjectDefConstraint(staticGoldID, treeWater);
	if (PlayerNum == 2)
		rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.50, 0.07);
	else
	{
		if (PlayerNum == 4)
		{
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.60, 0.09);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.40, 0.09);
		}
		if (PlayerNum == 6)
		{
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.65, 0.10);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.50, 0.07);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.35, 0.10);
		}
		if (PlayerNum == 8)
		{
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.70, 0.10);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.57, 0.09);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.43, 0.09);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.30, 0.10);
		}
	}
	if (rmGetIsKOTH() == false)
		rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.50, 0.40+0.005*PlayerNum);
	rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.15, 0.25);
	rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.85, 0.25);

	int staticSaltID = rmCreateObjectDef("static salt");
	rmAddObjectDefItem(staticSaltID, "MineSalt", 1, 0.0);
	rmSetObjectDefMinDistance(staticSaltID, rmXFractionToMeters(0.000));
	rmSetObjectDefMaxDistance(staticSaltID, rmXFractionToMeters(0.025));
	rmAddObjectDefToClass(staticSaltID, classStartingResource);
	rmAddObjectDefToClass(staticSaltID, classGold);
	rmAddObjectDefConstraint(staticSaltID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(staticSaltID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(staticSaltID, avoidNativesMin);
	rmAddObjectDefConstraint(staticSaltID, avoidPondMin);
	rmAddObjectDefConstraint(staticSaltID, avoidForestMin);
	rmAddObjectDefConstraint(staticSaltID, treeWater);
	if (PlayerNum == 2)
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.50, 0.95);
	else
	{
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.60, 0.95);
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.40, 0.95);
		if (PlayerNum > 4)
		{
			rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.70, 0.80);
			rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.30, 0.80);
		}
	}
	if (PlayerNum <= 4)
	{
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.85, 0.75);
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.15, 0.75);
	}
	else
	{
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.90, 0.75);
		rmPlaceObjectDefAtLoc(staticSaltID, 0, 0.10, 0.75);
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
	rmSetObjectDefMaxDistance(TCID, 0.0);
	
	// Starting mines
	int playerGoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerGoldID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 12.0);
	rmSetObjectDefMaxDistance(playerGoldID, 12.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 32.0);
	rmSetObjectDefMaxDistance(playerGold2ID, 32.0);
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, treeWater);
	rmAddObjectDefConstraint(playerGold2ID, avoidEdge);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerGold2ID, avoidCliff);

	int playerGold3ID = rmCreateObjectDef("player 3rd mine");
	rmAddObjectDefItem(playerGold3ID, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(playerGold3ID, 62);
	rmSetObjectDefMaxDistance(playerGold3ID, 65+2*PlayerNum);
	rmAddObjectDefToClass(playerGold3ID, classStartingResource);
	rmAddObjectDefToClass(playerGold3ID, classGold);
	rmAddObjectDefConstraint(playerGold3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold3ID, avoidEdge);
	if (TeamNum == 2)
	{
		rmAddObjectDefConstraint(playerGold3ID, avoidGrass);
	}
	else
		rmAddObjectDefConstraint(playerGold3ID, stayNearEdge);
	rmAddObjectDefConstraint(playerGold3ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerGold3ID, treeWaterFar);
	rmAddObjectDefConstraint(playerGold3ID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(playerGold3ID, avoidIslandFar);
	rmAddObjectDefConstraint(playerGold3ID, avoidCliff);
	rmAddObjectDefConstraint(playerGold3ID, avoidNativesShort);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType1, 2, 2.0);
	rmAddObjectDefItem(playerTreeID, treeType2, 2, 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 15);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketShort);

	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, treeType1, 5, 8.0);
	rmAddObjectDefItem(playerTree2ID, treeType2, 5, 8.0);
	rmAddObjectDefItem(playerTree2ID, treeType3, 3, 8.0);
    rmSetObjectDefMinDistance(playerTree2ID, 36);
    rmSetObjectDefMaxDistance(playerTree2ID, 40);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerTree2ID, treeWaterFar);
	rmAddObjectDefConstraint(playerTree2ID, avoidEdge);
	rmAddObjectDefConstraint(playerTree2ID, avoidCliff);

	// Starting berries
	int playerBerryID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerryID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerBerryID, 15.0);
	rmSetObjectDefMaxDistance(playerBerryID, 15.0);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);
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
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHerd2ID, treeWater);
	rmAddObjectDefConstraint(playerHerd2ID, avoidCliff);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketShort);
		
	int playerHerd3ID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(playerHerd3ID, food1, 9, 6.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 48);
	rmSetObjectDefMaxDistance(playerHerd3ID, 50);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidEdge);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerHerd3ID, treeWater);
	rmAddObjectDefConstraint(playerHerd3ID, avoidHunt1Med);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidCliff);
	rmAddObjectDefConstraint(playerHerd3ID, avoidGrass);
	rmAddObjectDefConstraint(playerHerd3ID, avoidIsland);

	int playerHerd4ID = rmCreateObjectDef("player 4th herd");
	rmAddObjectDefItem(playerHerd4ID, food1, 9, 6.0);
    rmSetObjectDefMinDistance(playerHerd4ID, 60);
	rmSetObjectDefMaxDistance(playerHerd4ID, 64);
	rmAddObjectDefToClass(playerHerd4ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd4ID, true);
	rmAddObjectDefConstraint(playerHerd4ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd4ID, avoidEdge);
	rmAddObjectDefConstraint(playerHerd4ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerHerd4ID, treeWater);
	rmAddObjectDefConstraint(playerHerd4ID, avoidHunt1Med);
	rmAddObjectDefConstraint(playerHerd4ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd4ID, avoidCliff);
	rmAddObjectDefConstraint(playerHerd4ID, avoidIsland);

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
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);
	
	//  Place Starting Objects/Resources
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
	}
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGold2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
//		if (PlayerNum > 2)
//			rmPlaceObjectDefAtLoc(playerGold3ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (PlayerNum == 2)
			rmPlaceObjectDefAtLoc(playerHerd4ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerBerryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}
	
	// Text
	rmSetStatusText("",0.60);

	// ____________________ Trees ____________________
	int riverforestcount = 30+6*PlayerNum;

	for (i=0; < riverforestcount)
    {
		int riverForestID=rmCreateObjectDef("river forest"+i);
		rmAddObjectDefToClass(riverForestID, classForest); 
		rmSetObjectDefMinDistance(riverForestID, 0);
		rmSetObjectDefMaxDistance(riverForestID, rmXFractionToMeters(0.5));
		if (i < riverforestcount/2)
		{
			rmAddObjectDefItem(riverForestID, brushType1, 2, 3);
			rmAddObjectDefItem(riverForestID, treeType3, 2, 3);
//			rmAddObjectDefItem(riverForestID, "berrybush", 1, 3);
			rmAddObjectDefConstraint(riverForestID, avoidCliff);
			rmAddObjectDefConstraint(riverForestID, stayNearRiver);
		}
		else
		{
			rmAddObjectDefItem(riverForestID, brushType4, 2, 3);
			rmAddObjectDefItem(riverForestID, treeType3, 5, 4);
//			rmAddObjectDefItem(riverForestID, "berrybush", 1, 3);
			if (i < riverforestcount*0.90)
				rmAddObjectDefConstraint(riverForestID, stayNearPlateau);
			else if (i < riverforestcount*0.95)
				rmAddObjectDefConstraint(riverForestID, stayNearPlateau2);
			else
				rmAddObjectDefConstraint(riverForestID, stayNearPlateau3);
		}
		rmAddObjectDefConstraint(riverForestID, avoidPlateau);
		rmAddObjectDefConstraint(riverForestID, avoidForestMed);
		rmAddObjectDefConstraint(riverForestID, avoidGoldMin);
		rmAddObjectDefConstraint(riverForestID, avoidGrass);
		rmAddObjectDefConstraint(riverForestID, treeWater);
		rmAddObjectDefConstraint(riverForestID, avoidGrassForest);
		rmPlaceObjectDefAtLoc(riverForestID, 0, 0.5, 0.5, 1);
	}

	// Text
	rmSetStatusText("",0.70);

	// Main Forest
	int mainforestcount = 20+3*PlayerNum;
	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, true);
		rmSetAreaMix(forestpatchID, forestMix);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(33));
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmAddAreaConstraint(forestpatchID, avoidStartingResources);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestpatchID, avoidForest);
		rmAddAreaConstraint(forestpatchID, avoidPlayer);
		rmAddAreaConstraint(forestpatchID, avoidGoldMin);
		rmAddAreaConstraint(forestpatchID, avoidNatives); 
		rmAddAreaConstraint(forestpatchID, avoidIslandMin); 
		rmAddAreaConstraint(forestpatchID, stayNearEdge);
		rmAddAreaConstraint(forestpatchID, treeWater);        
		rmAddAreaConstraint(forestpatchID, avoidCliffFar);        
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		for (j=0; < 4)
    	{
			int foresttreeID = rmCreateObjectDef("forest trees"+i+j);
			if (rmRandFloat(0,1) <= 0.333)
				rmAddObjectDefItem(foresttreeID, brushType1, 1, 3.0);
			else if (rmRandFloat(0,1) <= 0.50)
				rmAddObjectDefItem(foresttreeID, brushType2, 1, 3.0);
			else
				rmAddObjectDefItem(foresttreeID, brushType4, 1, 3.0);
			if (rmRandFloat(0,1) <= 0.667)
				rmAddObjectDefItem(foresttreeID, treeType1, 1, 3.0);
			else if (rmRandFloat(0,1) <= 0.80)
				rmAddObjectDefItem(foresttreeID, treeType2, 1, 3.0);
			else
				rmAddObjectDefItem(foresttreeID, treeType3, 1, 3.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, treeWater);
			rmAddObjectDefConstraint(foresttreeID, avoidTradeRouteSocketShort);
			rmAddObjectDefConstraint(foresttreeID, avoidCliff);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50, 1);
		}
    }

	// Text
	rmSetStatusText("",0.80);

	// ____________________ Hunts ____________________	
	int herd2count = 4*PlayerNum;
				
	for (i=0; < herd2count)
	{
		int mapHerd2ID = rmCreateObjectDef("herd2"+i);
		rmAddObjectDefItem(mapHerd2ID, food2, 6, 5.0);
		rmSetObjectDefMinDistance(mapHerd2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(mapHerd2ID, rmXFractionToMeters(0.45));
		rmSetObjectDefCreateHerd(mapHerd2ID, true);
		if (i == 0)
			rmAddObjectDefConstraint(mapHerd2ID, stayPlateau3);
		else if (i == 1)
			rmAddObjectDefConstraint(mapHerd2ID, stayPlateau2);
		else if (i <= 3)
		{
			rmAddObjectDefConstraint(mapHerd2ID, stayMidLine);
			rmAddObjectDefConstraint(mapHerd2ID, avoidCliff);
		}
		else
		{
			rmAddObjectDefConstraint(mapHerd2ID, avoidMidLine);
			rmAddObjectDefConstraint(mapHerd2ID, stayNearPlateau);
		}
		rmAddObjectDefConstraint(mapHerd2ID, avoidPlateau);
		rmAddObjectDefConstraint(mapHerd2ID, avoidDryGrass);
		rmAddObjectDefConstraint(mapHerd2ID, avoidGrass);
		rmAddObjectDefConstraint(mapHerd2ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(mapHerd2ID, treeWater);
//		rmAddObjectDefConstraint(mapHerd2ID, avoidForestMin);
		rmAddObjectDefConstraint(mapHerd2ID, avoidGoldMin);
		rmAddObjectDefConstraint(mapHerd2ID, avoidStartingResources); 
		rmAddObjectDefConstraint(mapHerd2ID, avoidIslandMin);
		rmAddObjectDefConstraint(mapHerd2ID, avoidEdge);
		rmAddObjectDefConstraint(mapHerd2ID, avoidHunt2Far);
		rmAddObjectDefConstraint(mapHerd2ID, avoidNatives);
		rmPlaceObjectDefAtLoc(mapHerd2ID, 0, 0.50, 0.50);	
	}

	int herd1count = 2*PlayerNum;
	if (PlayerNum > 2)
		herd1count = 3*PlayerNum;
				
	for (i=0; < herd1count)
	{
		int mapHerd1ID = rmCreateObjectDef("herd1"+i);
		rmAddObjectDefItem(mapHerd1ID, food1, 10, 5.0);
		rmSetObjectDefMinDistance(mapHerd1ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(mapHerd1ID, rmXFractionToMeters(0.45));
		rmSetObjectDefCreateHerd(mapHerd1ID, true);
		rmAddObjectDefConstraint(mapHerd1ID, avoidPlateau);
		rmAddObjectDefConstraint(mapHerd1ID, stayDryGrass);
		rmAddObjectDefConstraint(mapHerd1ID, avoidGrass);
		rmAddObjectDefConstraint(mapHerd1ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(mapHerd1ID, treeWater);
		rmAddObjectDefConstraint(mapHerd1ID, avoidForestMin);
		rmAddObjectDefConstraint(mapHerd1ID, avoidGoldMin);
		rmAddObjectDefConstraint(mapHerd1ID, avoidStartingResources); 
		rmAddObjectDefConstraint(mapHerd1ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(mapHerd1ID, avoidIslandMin);
		rmAddObjectDefConstraint(mapHerd1ID, avoidMidLine);
		rmAddObjectDefConstraint(mapHerd1ID, avoidEdge);
		rmAddObjectDefConstraint(mapHerd1ID, avoidHunt1);
		rmAddObjectDefConstraint(mapHerd1ID, avoidHunt2Far);
		rmAddObjectDefConstraint(mapHerd1ID, avoidNatives);
		rmPlaceObjectDefAtLoc(mapHerd1ID, 0, 0.50, 0.50);	
	}

	// Text
	rmSetStatusText("",0.90);

	// ____________________ Treasures ____________________
	int treasure1count = 6+3*PlayerNum;
	int treasure2count = 2+2*PlayerNum;
	int treasure3count = 2*PlayerNum;
	
	// Treasures L12
	for (i=0; < treasure3count)
	{
		int nugget12ID = rmCreateObjectDef("nugget lvl12"+i); 
		rmAddObjectDefItem(nugget12ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nugget12ID, 0);
		rmSetObjectDefMaxDistance(nugget12ID, rmXFractionToMeters(0.35));
		rmSetNuggetDifficulty(12,12);
		rmAddObjectDefConstraint(nugget12ID, avoidNuggetFar);
		rmAddObjectDefConstraint(nugget12ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget12ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget12ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget12ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget12ID, avoidNatives); 
		rmAddObjectDefConstraint(nugget12ID, avoidPondMin);
		rmAddObjectDefConstraint(nugget12ID, treeWater);
		rmAddObjectDefConstraint(nugget12ID, avoidIslandMin);
		rmAddObjectDefConstraint(nugget12ID, avoidStartingResources);
		rmAddObjectDefConstraint(nugget12ID, avoidPlateau);
		rmAddObjectDefConstraint(nugget12ID, avoidCliff);
		rmAddObjectDefConstraint(nugget12ID, avoidPlayer);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(nugget12ID, 0, 0.50, 0.50);
	}

	// Treasures L3
	for (i=0; < treasure3count)
	{
		int nugget3ID = rmCreateObjectDef("nugget lvl3"+i); 
		rmAddObjectDefItem(nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nugget3ID, 0);
		rmSetObjectDefMaxDistance(nugget3ID, rmXFractionToMeters(0.50));
		if (PlayerNum > 4 && rmGetIsTreaty() == false)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(3,3);
		if (i < treasure3count/2)
			rmAddObjectDefConstraint(nugget3ID, stayPlateau);
		else
			rmAddObjectDefConstraint(nugget3ID, stayDryGrass);
		rmAddObjectDefConstraint(nugget3ID, avoidPlateau);
		rmAddObjectDefConstraint(nugget3ID, avoidGrass);
		rmAddObjectDefConstraint(nugget3ID, avoidMidLine);
		rmAddObjectDefConstraint(nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(nugget3ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget3ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget3ID, avoidNatives); 
		rmAddObjectDefConstraint(nugget3ID, avoidPondMin);
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
		rmAddObjectDefConstraint(nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(nugget2ID, avoidPlateau);
		rmAddObjectDefConstraint(nugget2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget2ID, avoidNatives); 
		rmAddObjectDefConstraint(nugget2ID, treeWater);
		rmAddObjectDefConstraint(nugget2ID, avoidIslandMin);
		rmAddObjectDefConstraint(nugget2ID, avoidGrass);
		rmAddObjectDefConstraint(nugget2ID, avoidPlayer);
		if (TeamNum == 2)
		{
			rmAddObjectDefConstraint(nugget2ID, avoidMidLineMin);
			rmAddObjectDefConstraint(nugget2ID, stayDryGrass);
			if (i < treasure2count*0.50)
			{
				rmAddObjectDefConstraint(nugget2ID, stayNorth); 
			}
			else
			{
				rmAddObjectDefConstraint(nugget2ID, stayWest); 
			}
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
		rmAddObjectDefConstraint(nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(nugget1ID, avoidPlateau);
		rmAddObjectDefConstraint(nugget1ID, avoidMidLine);
//		rmAddObjectDefConstraint(nugget1ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(nugget1ID, avoidEdge); 
		rmAddObjectDefConstraint(nugget1ID, avoidNativesShort); 
		rmAddObjectDefConstraint(nugget1ID, avoidGrass);
		rmAddObjectDefConstraint(nugget1ID, treeWater);
		rmAddObjectDefConstraint(nugget1ID, avoidStartingResources);
		rmAddObjectDefConstraint(nugget1ID, avoidIslandMin);
		rmAddObjectDefConstraint(nugget1ID, avoidCliffFar);
		rmAddObjectDefConstraint(nugget1ID, avoidPlayer);
		rmPlaceObjectDefAtLoc(nugget1ID, 0, 0.50, 0.50);
	}

	// Text
	rmSetStatusText("",1.00);
	
} // END