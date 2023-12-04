// LARGE Panama (formerly TSREV Panama)
// Designed by dansil92
// ported to DE by vividlyplain September 2021
// LARGE version by vividlyplain October 2021

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
	rmSetStatusText("",0.01); 

	// ____________________ Strings ____________________
	string toiletPaper = "dirt_trail";
	string wetType = "Yucatan Coast Alt";
	string mntType = "Amazon River Bank Muddy";
	string initLand = "grass";
	string cliffPaint = "Amazon\ground5_ama";
	string forestPaint = "Amazon\groundforest_ama";
	string paintMix1 = "Amazon Grass Medium";
	string paintMix2 = "Amazon Grass Dirt";
	string paintMix3 = "Amazon Grass";
	string paintMix4 = "Amazon Dirt";
	string forTesting = "testmix";
	string treasureSet = "yucatan";
	string shineAlight = "rm_panama";
	string food1 = "tapir";
	string food2 = "capybara";
	string treeType1 = "treeYucatan";
	string treeType2 = "TreeAmazon";
	string natType1 = "Zapotec";
	string natType2 = "Maya";
	string natGrpName1 = "native zapotec village ";
	string natGrpName2 = "native Maya village ";

	// ____________________ General ____________________	
	int spawnChooser=rmRandInt(1,2);

//	int spawnBias=rmRandInt(1,4);
//	if (spawnBias == 2)
//		spawnChooser = 2;

	if (PlayerNum >= 6)
		spawnChooser = 1;
//	spawnChooser = 2;		// for testing

	// Picks the map size
	int playerTiles=36000;
	if (PlayerNum >= 4){
		playerTiles = 32000;
	}
	else if (PlayerNum >= 6){
		playerTiles = 28000;
	}
	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(0);	
//	rmSetMapElevationParameters(cElevTurbulence, 0.1, 1, 0.0, 0.5); // type, frequency, octaves, persistence, variation 
	
	// Picks default terrain and water
	rmSetSeaType(wetType);
//	rmSetBaseTerrainMix(paintMix1); 
	rmTerrainInitialize(initLand, 0.0); 
	rmSetMapType(treasureSet); 
//	rmSetMapType("water");
	rmSetLightingSet(shineAlight);
//	rmSetOceanReveal(true);

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPond = rmDefineClass("pond");
	int classRocks = rmDefineClass("rocks");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classBerry = rmDefineClass ("Berry");
	int classProp = rmDefineClass("prop");
	int classIsland=rmDefineClass("island");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayN = rmCreatePieConstraint("Stay N", 0.70, 0.7,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(40),rmDegreesToRadians(140));
	int stayE = rmCreatePieConstraint("Stay E", 0.70, 0.3,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(320),rmDegreesToRadians(40));
	int stayMiddle = rmCreateBoxConstraint("stay in the middle", 0.40, 0.00, 0.60, 1.00, 0.00);	
	int stayS = rmCreatePieConstraint("Stay S", 0.3, 0.3,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayW = rmCreatePieConstraint("Stay W", 0.3, 0.7,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(140),rmDegreesToRadians(220));
	int staySouthHalf = rmCreatePieConstraint("Stay south half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
	int Wcorner = rmCreatePieConstraint("Stay west corner", 0.00, 1.00,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int Ncorner = rmCreatePieConstraint("Stay north corner", 1.00, 1.00,rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0); //15.0
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest medium", rmClassID("Forest"), 20.0); //15.0
	int avoidForestBase=rmCreateClassDistanceConstraint("avoid forest base", rmClassID("Forest"), 12.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 8.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt 1 far", food1, 64.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt 1", food1, 44.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt 1 short", food1, 30.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt 1 min", food1, 10.0);
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt 2 far", food2, 75.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt 2 ", food2, 44.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt 2 short ", food2, 36.0);
	int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt 2 min ", food2, 8.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 18.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin med ", "gold", 55.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 75.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 24.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold", rmClassID("Gold"), 40.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 55.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 70.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 80.0);
	int avoidBerry = rmCreateClassDistanceConstraint ("avoid berry", rmClassID("Berry"), 25.0);
	int avoidBerryFar = rmCreateClassDistanceConstraint ("avoid berry far", rmClassID("Berry"), 50.0);
	int avoidBerryShort = rmCreateClassDistanceConstraint ("avoid berry short", rmClassID("Berry"), 12.0);
	int avoidBerryMin = rmCreateClassDistanceConstraint ("avoid berry min", rmClassID("Berry"), 4.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 6.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 24.0);
	int avoidNuggetMed = rmCreateTypeDistanceConstraint("nugget avoid nugget med", "AbstractNugget", 36.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 75.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 80.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 44.0);
	int avoidTownCenterMore = rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 50.0);
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 30.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("avoid natives min", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 12.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidWhaleFar=rmCreateTypeDistanceConstraint("avoid whale far", "MinkeWhale", 50);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "MinkeWhale", 64+2*PlayerNum);
	int avoidWhaleMin=rmCreateTypeDistanceConstraint("avoid whale min", "MinkeWhale", 4);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "ypFishTuna", 16.0);
	int avoidCattle=rmCreateTypeDistanceConstraint("avoid cattle", "deZebuCattle", 32.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 6.0);

	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 15.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int stayNearLand = rmCreateTerrainMaxDistanceConstraint("stay near land ", "Land", true, 5.0);
	int avoidLandMin = rmCreateTerrainDistanceConstraint("avoid land min", "Land", true, 4.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land ", "Land", true, 8.0);
	int avoidLandFar = rmCreateTerrainDistanceConstraint("avoid land far ", "Land", true, 12.0);
	int avoidFlag = rmCreateTypeDistanceConstraint("avoid water flag", "HomeCityWaterSpawnFlag", 8.0);
	int avoidFlagShort = rmCreateTypeDistanceConstraint("avoid water flag short", "HomeCityWaterSpawnFlag", 4.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 4.0);
	int avoidWaterMin = rmCreateTerrainDistanceConstraint("avoid water min", "water", true, 3.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 8.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 12.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 24.0);
	int stayCoast = rmCreateTerrainMaxDistanceConstraint("stay river", "Land", false, 4+PlayerNum);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 8.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 5.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 4.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 8.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 12.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 24+PlayerNum);
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.43), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayVeryNearEdge = rmCreatePieConstraint("stay very near edge",0.5,0.5,rmXFractionToMeters(0.50), rmXFractionToMeters(0.505), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 10.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("avoid trade route socket min", "socketTradeRoute", 4.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 12.0);
	
	// ____________________ Player Placement ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.60, 0.20);
					rmPlacePlayer(2, 0.20, 0.60);
				}
				else
				{
					rmPlacePlayer(2, 0.60, 0.20);
					rmPlacePlayer(1, 0.20, 0.60);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.60, 0.10, 0.60, 0.25, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.10, 0.60, 0.25, 0.60, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.60, 0.10, 0.60, 0.40, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.10, 0.60, 0.40, 0.60, 0.00, 0.20);
				}
			}
				else
				{
					rmSetPlacementTeam(0);
					if (teamZeroCount < 4)
						rmPlacePlayersLine(0.61, 0.15, 0.80, 0.40, 0.00, 0.20);
					else
						rmPlacePlayersLine(0.55, 0.05, 0.80, 0.40, 0.00, 0.20);

					rmSetPlacementTeam(1);
					if (teamOneCount < 4)
						rmPlacePlayersLine(0.15, 0.61, 0.40, 0.80, 0.00, 0.20);
					else
						rmPlacePlayersLine(0.05, 0.55, 0.40, 0.80, 0.00, 0.20);
				}
		}
		else  //FFA
			{	
				if (PlayerNum == 4) {
					rmPlacePlayer(1, 0.60, 0.20);
					rmPlacePlayer(2, 0.20, 0.60);
					rmPlacePlayer(3, .80, .40);
					rmPlacePlayer(4, .40, .80);
					}
				else if (PlayerNum == 3) {
					rmPlacePlayer(1, 0.60, 0.20);
					rmPlacePlayer(2, 0.20, 0.60);
					rmPlacePlayer(3, .65, .65);
					}
				else if (PlayerNum == 5) {
					rmPlacePlayer(1, 0.60, 0.15);
					rmPlacePlayer(2, 0.15, 0.60);
					rmPlacePlayer(3, .80, .30);
					rmPlacePlayer(4, .30, .80);
					rmPlacePlayer(5, .65, .65);
					}
				else if (PlayerNum == 6) {
					rmPlacePlayer(1, 0.60, 0.15);
					rmPlacePlayer(2, 0.15, 0.60);
					rmPlacePlayer(3, .80, .30);
					rmPlacePlayer(4, .30, .80);
					rmPlacePlayer(5, .65, .65);
					rmPlacePlayer(6, .50, .50);
					}
				else {
					rmPlacePlayer(1, 0.60, 0.10);
					rmPlacePlayer(2, 0.10, 0.60);
					rmPlacePlayer(3, .80, .25);
					rmPlacePlayer(4, .25, .80);
					rmPlacePlayer(5, .80, .50);
					rmPlacePlayer(6, .50, .80);
					rmPlacePlayer(7, .40, .55);
					rmPlacePlayer(8, .55, .40);
					}
			}
   
	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	// Place Trade Route
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		int tradeRouteID3 = rmCreateTradeRoute();

		int socketID3=rmCreateObjectDef("sockets to dock Trade Posts3");
			rmAddObjectDefItem(socketID3, "SocketTradeRoute", 1, 0.0);
			rmSetObjectDefAllowOverlap(socketID3, true);
			rmSetObjectDefMinDistance(socketID3, 2.0);
			rmSetObjectDefMaxDistance(socketID3, 8.0);  

			rmSetObjectDefTradeRouteID(socketID3, tradeRouteID3);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.85, 0.15);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.75, 0.45);
	//		rmAddTradeRouteWaypoint(tradeRouteID3, 0.65, 0.65);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.45, 0.75);
			rmAddTradeRouteWaypoint(tradeRouteID3, 0.15, 0.85);

			rmBuildTradeRoute(tradeRouteID3, toiletPaper);	
		}

	int tradeIslandID=rmCreateArea("Trade Island");
	rmSetAreaSize(tradeIslandID, 0.10);
	rmSetAreaLocation(tradeIslandID, 0.65, 0.65);
	rmAddAreaInfluenceSegment(tradeIslandID, 0.85, 0.15, 0.75, 0.45);
	rmAddAreaInfluenceSegment(tradeIslandID, 0.75, 0.45, 0.45, 0.75);
	rmAddAreaInfluenceSegment(tradeIslandID, 0.45, 0.75, 0.15, 0.85);
//	rmSetAreaMix(tradeIslandID, "himalayas_a"); 	// for testing
	rmSetAreaCoherence(tradeIslandID, 1.00);
	rmBuildArea(tradeIslandID); 
	
	int avoidTradeIsland = rmCreateAreaDistanceConstraint("avoid trade island ", tradeIslandID, 8.0);

	// Main Land
	int mainlandID = rmCreateArea("main island");
	rmSetAreaSize(mainlandID, 0.72);
	rmSetAreaLocation(mainlandID, 0.27, 0.27);
	rmSetAreaMix(mainlandID, paintMix1);
	rmSetAreaWarnFailure(mainlandID, false);
	rmSetAreaCoherence(mainlandID, 0.90); 
//	rmSetAreaElevationType(mainlandID, cElevTurbulence);
//	rmSetAreaElevationVariation(mainlandID, 1.0);
	rmSetAreaBaseHeight(mainlandID, 1.0);
//	rmSetAreaElevationMinFrequency(mainlandID, 0.04);
//	rmSetAreaElevationOctaves(mainlandID, 3);
//	rmSetAreaElevationPersistence(mainlandID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(mainlandID, false);
	rmBuildArea(mainlandID);
	
	int avoidMainLandMin = rmCreateAreaDistanceConstraint("avoid main land min", mainlandID, 0.5);
	int avoidMainLand = rmCreateAreaDistanceConstraint("avoid main land", mainlandID, 16.0);
	int avoidMainLandShort = rmCreateAreaDistanceConstraint("avoid main land short", mainlandID, 8.0);
	int stayInMainLand = rmCreateAreaMaxDistanceConstraint("stay in main land", mainlandID, 0.0);

	float southXLoc = 0.30;
	float southYLoc = 0.30;

	// North Sea
	int northSeaID = rmCreateArea("north sea");
	rmSetAreaWaterType(northSeaID, wetType);
	rmSetAreaSize(northSeaID, 0.25);
	rmSetAreaLocation(northSeaID, 0.80, 0.80);
	rmSetAreaWarnFailure(northSeaID, false);
	rmSetAreaCoherence(northSeaID, 0.777); 
	rmSetAreaObeyWorldCircleConstraint(northSeaID, false);
	rmAddAreaConstraint(northSeaID, avoidMainLandMin);
	rmAddAreaConstraint(northSeaID, avoidTradeRoute);
	rmAddAreaConstraint(northSeaID, avoidTradeIsland);
	rmBuildArea(northSeaID);
	
	int avoidNorthSeaMin = rmCreateAreaDistanceConstraint("avoid N sea min", northSeaID, 0.5);
	int avoidNorthSea = rmCreateAreaDistanceConstraint("avoid N sea ", northSeaID, 8.0);
	int avoidNorthSeaFar = rmCreateAreaDistanceConstraint("avoid N sea far", northSeaID, 24.0);
	int stayNorthSea = rmCreateAreaMaxDistanceConstraint("stay in N sea ", northSeaID, 0.0);

	// Canal
	int riverID = rmRiverCreate(-1, wetType, 10, 10, 4, 4);  
	rmRiverAddWaypoint(riverID, 0.80, 0.80);
	rmRiverAddWaypoint(riverID, rmRandFloat(0.72, 0.77), rmRandFloat(0.72, 0.77));
	rmRiverAddWaypoint(riverID, rmRandFloat(0.67, 0.72), rmRandFloat(0.67, 0.72));
	rmRiverAddWaypoint(riverID, rmRandFloat(0.62, 0.67), rmRandFloat(0.62, 0.67));
	rmRiverAddWaypoint(riverID, rmRandFloat(0.57, 0.62), rmRandFloat(0.57, 0.62));
	rmRiverAddWaypoint(riverID, rmRandFloat(0.52, 0.57), rmRandFloat(0.52, 0.57));
	rmRiverAddWaypoint(riverID, rmRandFloat(0.47, 0.50), rmRandFloat(0.47, 0.50));
	rmRiverAddWaypoint(riverID, 0.40, 0.40);
	rmRiverSetShallowRadius(riverID, 8+PlayerNum);
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
	rmRiverAddShallow(riverID, 1.00);
	rmRiverBuild(riverID);
	
	// Place TR Sockets
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.10);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);

			if (PlayerNum > 4) {
				socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.30);
				rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
				}

			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.50);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);

			if (PlayerNum > 4) {
				socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.70);
				rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
				}

			socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.90);
			rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
		}

	// South Sea
	int southSeaID = rmCreateArea("south sea");
	rmSetAreaWaterType(southSeaID, wetType);
	rmSetAreaSize(southSeaID, 0.22);
	rmSetAreaLocation(southSeaID, southXLoc+0.03, southYLoc+0.03);
	rmAddAreaInfluenceSegment(southSeaID, 0.15, 0.15, 0.30, 0.00);
	rmAddAreaInfluenceSegment(southSeaID, 0.15, 0.15, 0.00, 0.30);
	rmSetAreaWarnFailure(southSeaID, false);
	rmSetAreaCoherence(southSeaID, 0.777); 
	rmSetAreaObeyWorldCircleConstraint(southSeaID, false);
	rmAddAreaConstraint(southSeaID, avoidTradeRoute);
	rmAddAreaConstraint(southSeaID, avoidTradeIsland);
	rmBuildArea(southSeaID);
	
	int avoidSouthSeaMin = rmCreateAreaDistanceConstraint("avoid south sea min", southSeaID, 0.5);
	int avoidSouthSea = rmCreateAreaDistanceConstraint("avoid south sea ", southSeaID, 8.0);
	int avoidSouthSeaFar = rmCreateAreaDistanceConstraint("avoid south sea far", southSeaID, 24.0);
	int staySouthSea = rmCreateAreaMaxDistanceConstraint("stay in south sea ", southSeaID, 0.0);
	
	// Text
	rmSetStatusText("",0.40);
		
	// Player areas
	for (i=1; < numPlayer)
	{
	int playerAreaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerAreaID);
	rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(222));
	rmSetAreaCoherence(playerAreaID, 0.666);
	rmSetAreaBaseHeight(playerAreaID, 2.0);
	rmSetAreaWarnFailure(playerAreaID, false);
	rmSetAreaMix(playerAreaID, paintMix4);	
	rmSetAreaLocPlayer(playerAreaID, i);
	rmSetAreaObeyWorldCircleConstraint(playerAreaID, false);
	rmAddAreaToClass(playerAreaID, classIsland);
	rmBuildArea(playerAreaID);
	rmCreateAreaDistanceConstraint("avoid player area "+i, playerAreaID, 3.0);
	rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerAreaID, 0.0);
	}
	
	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayInPlayerArea1 = rmConstraintID("stay in player area 1");
	int stayInPlayerArea2 = rmConstraintID("stay in player area 2");

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
	
	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);
	int whichVillage4 = rmRandInt(1,5);

	nativeID0 = rmCreateGrouping("native A", natGrpName1+whichVillage1);
	rmAddGroupingToClass(nativeID0, classNative);
	nativeID1 = rmCreateGrouping("native B", natGrpName1+whichVillage2);
	rmAddGroupingToClass(nativeID1, classNative);
	nativeID2 = rmCreateGrouping("native C", natGrpName2+whichVillage3);
	rmAddGroupingToClass(nativeID2, classNative);
	nativeID3 = rmCreateGrouping("native D", natGrpName2+whichVillage4);
	rmAddGroupingToClass(nativeID3, classNative);
	
	if (TeamNum == 2) {
		if (teamZeroCount == teamOneCount) {
			if (spawnChooser == 1) {
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.30, 0.70);
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.70, 0.30);
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.55, 0.75);
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.75, 0.55);
				}
			else {
				rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.60);
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.40);
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.50, 0.80);
				rmPlaceGroupingAtLoc(nativeID3, 0, 0.80, 0.50);
				}
			}
		else {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.60, 0.40);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.40, 0.60);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.55, 0.75);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.75, 0.55);
			}
		}
	else {
		if (PlayerNum < 5) {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.60, 0.40);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.40, 0.60);
			}
		else {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.70, 0.30);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.70);
			}
		if (PlayerNum < 7) {
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.55, 0.75);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.75, 0.55);
			}
		else {
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.65, 0.65);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.55, 0.55);
			}
	}

	// Bonus Island
	int SislandID=rmCreateArea("S island");
	rmSetAreaSize(SislandID, 0.008);
	rmSetAreaLocation(SislandID, southXLoc, southYLoc);
	rmSetAreaMix(SislandID, paintMix1); 
	rmSetAreaObeyWorldCircleConstraint(SislandID, false);
	rmAddAreaToClass(SislandID, classIsland);
	rmSetAreaBaseHeight(SislandID, 2.0);
	rmSetAreaCoherence(SislandID, 0.777);
	if (rmGetIsKOTH() == true)
		rmSetAreaReveal(SislandID, 01);
	rmAddAreaConstraint(SislandID, avoidTradeRouteShort);
	rmBuildArea(SislandID); 

	int avoidSislandIDMin = rmCreateAreaDistanceConstraint("avoid S island min", SislandID, 4.0);
	int avoidSislandID = rmCreateAreaDistanceConstraint("avoid S island", SislandID, 8.0);
	int avoidSislandIDFar = rmCreateAreaDistanceConstraint("avoid S island far", SislandID, 12.0);
	int staySislandID = rmCreateAreaMaxDistanceConstraint("stay near S island", SislandID, 0.0);

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) {	
		// Place King's Hill
		float walk = 0.0;
			
		ypKingsHillPlacer(southXLoc, southYLoc, walk, 0);
		}

	int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 8.0);

	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	if (PlayerNum == 2)
		rmSetAreaSize(midIslandID, 0.325);
	else if (teamZeroCount == teamOneCount)
		rmSetAreaSize(midIslandID, 0.20);
	else
		rmSetAreaSize(midIslandID, 0.30);
	rmSetAreaLocation(midIslandID, 0.50, 0.50);
	if (PlayerNum > 2 && teamZeroCount == teamOneCount) {
		rmAddAreaInfluenceSegment(midIslandID, 0.50, 0.50, 0.50, 0.10);
		rmAddAreaInfluenceSegment(midIslandID, 0.50, 0.50, 0.10, 0.50);
		}
	else if (teamZeroCount != teamOneCount) {
		rmAddAreaInfluenceSegment(midIslandID, 0.75, 0.50, 0.40, 0.00);
		rmAddAreaInfluenceSegment(midIslandID, 0.50, 0.75, 0.00, 0.40);
		}
//	rmSetAreaMix(midIslandID, forTesting);
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.51+0.015*PlayerNum);
	rmSetAreaLocation(midSmIslandID, 0.50, 0.50);
//	rmSetAreaMix(midSmIslandID, "himalayas_a"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 1.00);
	rmAddAreaConstraint(midSmIslandID, avoidSislandID);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	// Text
	rmSetStatusText("",0.50);

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
	if (TeamNum == 2)
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0);
	else
		rmAddObjectDefItem(playerGoldID, "deShipRuins", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 16.0);
	rmSetObjectDefMaxDistance(playerGoldID, 16.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidNativesMin);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidImpassableLandMin);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerGoldID, avoidMidIslandMin);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	if (TeamNum == 2)
		rmAddObjectDefItem(playerGold2ID, "mine", 1, 0);
	else
		rmAddObjectDefItem(playerGold2ID, "deShipRuins", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 28.0); 
	rmSetObjectDefMaxDistance(playerGold2ID, 30.0); 
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidNativesMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold2ID, avoidImpassableLandMin);
		
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType1, 3, 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 22);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidNativesMin);
	rmAddObjectDefConstraint(playerTreeID, avoidWaterShort);
	rmAddObjectDefConstraint(playerTreeID, avoidImpassableLandMin);

	// Starting berries
    int playerBerryID = rmCreateObjectDef("starting berries");
    rmAddObjectDefItem(playerBerryID, "BerryBush", 4, 3.0);
    rmSetObjectDefMinDistance(playerBerryID, 12.0);
    rmSetObjectDefMaxDistance(playerBerryID, 14.0);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);
	rmAddObjectDefConstraint(playerBerryID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerBerryID, avoidNativesMin);
	rmAddObjectDefConstraint(playerBerryID, avoidStartingResources);
	rmAddObjectDefConstraint(playerBerryID, avoidImpassableLandShort);

	// Starting herds
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, food2, 8, 3.0);
	rmSetObjectDefMinDistance(playerHerdID, 12.0);
	rmSetObjectDefMaxDistance(playerHerdID, 12.0);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerdID, avoidImpassableLandShort);
		
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(playerHerd2ID, food1, 10, 4.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 30);
    rmSetObjectDefMaxDistance(playerHerd2ID, 30);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidForestMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerHerd2ID, avoidImpassableLandShort);
	if (TeamNum == 2 && teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIslandFar);
	else if (TeamNum == 2)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIsland);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 26.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 32.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetMed);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidForestMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandShort);
	if (TeamNum == 2)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandFar);
	
	//Colony water shipment flag
	int shipmentflagID = rmCreateObjectDef("colony ship");
	rmAddObjectDefItem(shipmentflagID, "HomeCityWaterSpawnFlag", 1, 0.0);
	rmSetObjectDefMinDistance(shipmentflagID, rmXFractionToMeters(0.05));
	rmSetObjectDefMaxDistance(shipmentflagID, rmXFractionToMeters(0.25));
	rmAddObjectDefConstraint(shipmentflagID, avoidFlag);
	rmAddObjectDefConstraint(shipmentflagID, avoidLand);
	rmAddObjectDefConstraint(shipmentflagID, avoidEdge);
	rmAddObjectDefConstraint(shipmentflagID, avoidTradeRouteMin);

	// Place Starting Objects	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(shipmentflagID, i, 0.40, 0.40);
		vector flagLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(shipmentflagID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerBerryID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));	
	}
	
	// Text
	rmSetStatusText("",0.60);
	
	// ____________________ Common Resources ____________________
	// Static Gold Ships
	int goldShipID = rmCreateObjectDef("gold ships");
		rmAddObjectDefItem(goldShipID, "deShipRuins", 1, 0.0);
		rmSetObjectDefMinDistance(goldShipID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(goldShipID, rmXFractionToMeters(0.05));
		rmAddObjectDefToClass(goldShipID, classGold);
		rmAddObjectDefConstraint(goldShipID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(goldShipID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(goldShipID, avoidNatives);
		rmAddObjectDefConstraint(goldShipID, avoidSouthSeaMin);
		rmAddObjectDefConstraint(goldShipID, stayInMainLand);
		if (TeamNum == 2)
			rmAddObjectDefConstraint(goldShipID, stayCoast);
		else 
			rmAddObjectDefConstraint(goldShipID, avoidGoldShort);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(goldShipID, avoidKOTH);
		if (TeamNum == 2) {
			if (spawnChooser == 1)
				rmPlaceObjectDefAtLoc(goldShipID, 0, 0.715, 0.715);
			else 
				rmPlaceObjectDefAtLoc(goldShipID, 0, 0.46, 0.46);
			rmPlaceObjectDefAtLoc(goldShipID, 0, 0.85, 0.35);
			rmPlaceObjectDefAtLoc(goldShipID, 0, 0.35, 0.85);
			if (PlayerNum > 4) {
				rmPlaceObjectDefAtLoc(goldShipID, 0, 0.85, 0.50);
				rmPlaceObjectDefAtLoc(goldShipID, 0, 0.50, 0.85);
				}
			}
		else {
			rmPlaceObjectDefAtLoc(goldShipID, 0, 0.30, 0.30, 3);
			}

	// Static Mines
	int staticGoldID = rmCreateObjectDef("staticgold");
		rmAddObjectDefItem(staticGoldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(staticGoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(staticGoldID, rmXFractionToMeters(0.03));
		rmAddObjectDefToClass(staticGoldID, classGold);
		rmAddObjectDefConstraint(staticGoldID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(staticGoldID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(staticGoldID, avoidNatives);
		rmAddObjectDefConstraint(staticGoldID, avoidWater);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(staticGoldID, avoidKOTH);
		if (TeamNum == 2) {
			if (PlayerNum == 2) {
				if (spawnChooser == 1) {
					rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.60, 0.40);
					rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.40, 0.60);
					}
				else {
					rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.70, 0.55);
					rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.55, 0.70);
					}
				}
			else {
				rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.50, 0.50);
				}
			if (rmGetIsKOTH() == false)
				rmPlaceObjectDefAtLoc(staticGoldID, 0, southXLoc, southYLoc);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.82, 0.15);
			rmPlaceObjectDefAtLoc(staticGoldID, 0, 0.15, 0.82);
			}

	// Common Mines 
	int goldcount = 2*PlayerNum; 

	int goldID = rmCreateObjectDef("gold");
		rmAddObjectDefItem(goldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.00));
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.025));
		else
			rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidSouthSea);
		rmAddObjectDefConstraint(goldID, avoidGoldMed);
		rmAddObjectDefConstraint(goldID, avoidIslandFar);
//		rmAddObjectDefConstraint(goldID, stayMidSmIsland);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidImpassableLandMin);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(goldID, avoidKOTH);
		if (TeamNum == 2 && PlayerNum > 2)
			rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50, goldcount);
		else if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50, 2*goldcount);
			
	// Text
	rmSetStatusText("",0.70);
	
	// Main forest patches
	int mainforestcount = 15+10*PlayerNum;
	int stayInForestPatch = -1;
	int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 6.0);

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(55));
		rmSetAreaMix(forestpatchID, paintMix4);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocket);
		rmAddAreaConstraint(forestpatchID, avoidForest);
		rmAddAreaConstraint(forestpatchID, avoidWater);
		rmAddAreaConstraint(forestpatchID, avoidStartingResources);
		rmAddAreaConstraint(forestpatchID, avoidIslandFar);
		rmAddAreaConstraint(forestpatchID, avoidGold);
		rmAddAreaConstraint(forestpatchID, stayMidSmIsland);
		rmAddAreaConstraint(forestpatchID, avoidNatives);
		rmAddAreaConstraint(forestpatchID, treeWater);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(forestpatchID, avoidKOTH);
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
			rmAddObjectDefItem(foresttreeID, treeType1, 4, 7.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmAddObjectDefConstraint(foresttreeID, avoidTradeRouteSocketMin);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50, 6);
    }

	// Text
	rmSetStatusText("",0.80);
	
	// Trees 
	for (i=0; < 32) {
		int patchID = rmCreateArea("first patch"+i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaObeyWorldCircleConstraint(patchID, true);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(44), rmAreaTilesToFraction(66));
		rmSetAreaMix(patchID, paintMix4); 
		rmAddAreaToClass(patchID, rmClassID("patch"));
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 0.0);
		rmSetAreaMaxBlobDistance(patchID, 1.0);
		rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidSouthSeaMin);
		rmAddAreaConstraint(patchID, stayInMainLand);
		rmAddAreaConstraint(patchID, avoidMidSmIslandMin);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmBuildArea(patchID); 
		}	
		
		int rimTreeID = rmCreateObjectDef("rim trees");
		rmAddObjectDefItem(rimTreeID, treeType1, 1, 0.0);
		rmSetObjectDefMinDistance(rimTreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(rimTreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(rimTreeID, classForest);
		rmAddObjectDefConstraint(rimTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(rimTreeID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(rimTreeID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(rimTreeID, avoidMidSmIslandMin);
		rmAddObjectDefConstraint(rimTreeID, avoidNativesMin);
		rmAddObjectDefConstraint(rimTreeID, avoidSislandID);
		rmAddObjectDefConstraint(rimTreeID, avoidWater);
		rmAddObjectDefConstraint(rimTreeID, avoidStartingResources);
		rmAddObjectDefConstraint(rimTreeID, treeWater);
		rmAddObjectDefConstraint(rimTreeID, avoidIsland);
		rmPlaceObjectDefAtLoc(rimTreeID, 0, 0.50, 0.50, 50+25*PlayerNum);

	int southTreeID = rmCreateObjectDef("south tree");
		rmAddObjectDefItem(southTreeID, treeType2, 4, 6.0);
		rmSetObjectDefMinDistance(southTreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(southTreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(southTreeID, classForest);
		rmAddObjectDefConstraint(southTreeID, staySislandID);
		rmAddObjectDefConstraint(southTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(southTreeID, avoidForestMin);
		rmAddObjectDefConstraint(southTreeID, avoidWaterShort);
		if (rmGetIsKOTH() == false)
			rmPlaceObjectDefAtLoc(southTreeID, 0, 0.50, 0.50, 2+PlayerNum/2);
		
	int randomTreeID = rmCreateObjectDef("random tree");
		rmAddObjectDefItem(randomTreeID, treeType2, 5, 5.0);
		rmSetObjectDefMinDistance(randomTreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(randomTreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(randomTreeID, classForest);
		rmAddObjectDefConstraint(randomTreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomTreeID, avoidIslandShort);
		rmAddObjectDefConstraint(randomTreeID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(randomTreeID, avoidWater);
		rmAddObjectDefConstraint(randomTreeID, avoidNativesMin);
		rmAddObjectDefConstraint(randomTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomTreeID, treeWater);
		rmAddObjectDefConstraint(randomTreeID, avoidTradeRouteSocketMin);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(randomTreeID, avoidKOTH);
		rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.50, 0.50, 10*PlayerNum);

	// Hunts 
	int herdcount = 4*PlayerNum;
	
	int commonHuntID = rmCreateObjectDef("common herd");
		rmAddObjectDefItem(commonHuntID, food1, 8, 3.0);
		rmSetObjectDefMinDistance(commonHuntID, rmXFractionToMeters(0.00));
		if (PlayerNum > 2)
			rmSetObjectDefMaxDistance(commonHuntID, rmXFractionToMeters(0.48));
		else
			rmSetObjectDefMaxDistance(commonHuntID, rmXFractionToMeters(0.03));
		rmSetObjectDefCreateHerd(commonHuntID, true);
		rmAddObjectDefConstraint(commonHuntID, avoidGoldMin);
		rmAddObjectDefConstraint(commonHuntID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(commonHuntID, avoidForestMin);
		rmAddObjectDefConstraint(commonHuntID, avoidIslandFar);
		rmAddObjectDefConstraint(commonHuntID, avoidHunt1);
		rmAddObjectDefConstraint(commonHuntID, avoidEdge);
		rmAddObjectDefConstraint(commonHuntID, avoidNativesMin);
		rmAddObjectDefConstraint(commonHuntID, stayInMainLand);
		rmAddObjectDefConstraint(commonHuntID, avoidWaterShort);
		rmAddObjectDefConstraint(commonHuntID, avoidSouthSeaMin);
		if (TeamNum == 2)
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.50, 0.50);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.50, 0.50, 1.5*herdcount);
		else {
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.65, 0.35);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.35, 0.65);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.75, 0.10);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.10, 0.75);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.80, 0.40);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.40, 0.80);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.65, 0.55);
			rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.55, 0.65);
			}

	// Text
	rmSetStatusText("",0.90);

	// Treasures 
	int treasure1count = 4+PlayerNum;
	int treasure2count = 2+PlayerNum;
	int treasure3count = PlayerNum/2;

	int Nugget3SID = rmCreateObjectDef("nugget L3 S"); 
		rmAddObjectDefItem(Nugget3SID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3SID, 0);
		rmSetObjectDefMaxDistance(Nugget3SID, rmXFractionToMeters(0.275));
		if (PlayerNum > 2 && rmGetIsTreaty() == false)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3SID, avoidNuggetShort);
		rmAddObjectDefConstraint(Nugget3SID, avoidIslandFar);
		rmAddObjectDefConstraint(Nugget3SID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3SID, avoidEdge);
		rmAddObjectDefConstraint(Nugget3SID, avoidWaterShort);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(Nugget3SID, 0, 0.60, 0.60, 1.5*treasure3count);
		
	// Treasures L2	
	int Nugget2ID = rmCreateObjectDef("nugget L2 "); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.40));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidIslandFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidStartingResources);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, stayMidSmIsland);
		rmAddObjectDefConstraint(Nugget2ID, avoidWater);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.60, 0.60, 2*treasure2count);
	
	// Treasures L1
	int Nugget1ID = rmCreateObjectDef("nugget L1 "); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidIslandFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidHunt1Min);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidSouthSea);
		rmAddObjectDefConstraint(Nugget1ID, avoidWater);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget1ID, stayInMainLand);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.60, 0.60, 2*treasure1count);

	// Text
	rmSetStatusText("",0.95);
	
	// Sea Resources 
	int fishcount = 4+5*PlayerNum;
	int whalecount = PlayerNum;
	
	//Whales
	int whaleID=rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, "MinkeWhale", 1, 0.0);
	rmSetObjectDefMinDistance(whaleID, rmXFractionToMeters(0.00));
	if (PlayerNum <= 4)
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.05));
	else
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(whaleID, avoidWhale);
	rmAddObjectDefConstraint(whaleID, avoidLandFar);
	rmAddObjectDefConstraint(whaleID, avoidColonyShip);
	rmAddObjectDefConstraint(whaleID, avoidEdge);
	rmAddObjectDefConstraint(whaleID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(whaleID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(whaleID, staySouthSea);
	if (PlayerNum > 4)
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.50, 0.50, whalecount);
	else
	{
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.40, 0.20);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.20, 0.40);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.20, 0.20);
		if (PlayerNum == 4)
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.40, 0.40);
	}

	int whale2ID=rmCreateObjectDef("whale2");
	rmAddObjectDefItem(whale2ID, "MinkeWhale", 1, 0.0);
	rmSetObjectDefMinDistance(whale2ID, rmXFractionToMeters(0.00));
	if (PlayerNum <= 4)
		rmSetObjectDefMaxDistance(whale2ID, rmXFractionToMeters(0.05));
	else
		rmSetObjectDefMaxDistance(whale2ID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(whale2ID, avoidWhale);
	rmAddObjectDefConstraint(whale2ID, avoidLandFar);
	rmAddObjectDefConstraint(whale2ID, avoidColonyShip);
	rmAddObjectDefConstraint(whale2ID, avoidEdge);
	rmAddObjectDefConstraint(whale2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(whale2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(whale2ID, stayNorthSea);
	if (PlayerNum == 2)
	{
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.80, 0.80);
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.90, 0.60);
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.60, 0.90);
	}
	else if (PlayerNum == 4)
	{
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.85, 0.71);
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.71, 0.85);
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.95, 0.50);
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.50, 0.95);
	}
	else
	{
		rmPlaceObjectDefAtLoc(whale2ID, 0, 0.50, 0.50, whalecount);
	}
		
	//Fishes
	int fishID = rmCreateObjectDef("fish");
		rmAddObjectDefItem(fishID, "ypFishTuna", 1, 0.0);
		rmSetObjectDefMinDistance(fishID, 0.00);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidWhaleMin);
		rmAddObjectDefConstraint(fishID, avoidLandMin);
		rmAddObjectDefConstraint(fishID, avoidColonyShip);
		rmAddObjectDefConstraint(fishID, avoidEdge);
		rmAddObjectDefConstraint(fishID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(fishID, staySouthSea);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50, 2.5*fishcount);

	int fish2ID = rmCreateObjectDef("fish2");
		rmAddObjectDefItem(fish2ID, "ypFishTuna", 1, 0.0);
		rmSetObjectDefMinDistance(fish2ID, 0.00);
		rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fish2ID, avoidFish);
		rmAddObjectDefConstraint(fish2ID, avoidWhaleMin);
		rmAddObjectDefConstraint(fish2ID, avoidLandMin);
		rmAddObjectDefConstraint(fish2ID, avoidColonyShip);
		rmAddObjectDefConstraint(fish2ID, avoidEdge);
		rmAddObjectDefConstraint(fish2ID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(fish2ID, stayNorthSea);
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.50, 0.50, 2.5*fishcount);

	// Text
	rmSetStatusText("",1.00);
	
} // END
	
	