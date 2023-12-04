// LARGE Guianas (formerly vivid's Pantanal Marsh and the OG vivid's Empire Wars Marsh)
// designed by vividlyplain
// ported to DE by vividlyplain, September 2021
// large version by vividlyplain, September 2021
// thanks to Enki_ for the OP colour converter

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
	string wetType = "Amazon Rainforest River Muddy";
	string mntType = "Amazon River Bank Muddy";
	string initLand = "grass";
	string cliffPaint = "Amazon\ground5_ama";
	string forestPaint = "Amazon\groundforest_ama";
	string paintMix1 = "Amazon Grass Medium";
	string paintMix2 = "Amazon Grass Dirt";
	string paintMix3 = "Amazon Grass";
	string paintMix4 = "Amazon Dirt";
	string forTesting = "testmix";
	string treasureSet = "amazonia";
	string shineAlight = "rm_guianas";
	string food1 = "tapir";
	string food2 = "capybara";
	string treeType1 = "TreeAmazon";
	string treeType2 = "TreeAraucania";
	string natType1 = "Tupi";
	string natType2 = "Caribs";
	string natGrpName1 = "native tupi village ";
	string natGrpName2 = "native carib village ";

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
	rmSetSeaLevel(0.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	rmSetSeaType(wetType);
	rmSetBaseTerrainMix(paintMix1);
	rmTerrainInitialize(initLand, 0.0); 
	rmSetMapType(treasureSet); 
	rmSetMapType("water");
	rmSetLightingSet(shineAlight);

	// Choose Mercs
	chooseMercs();
	
	// Make it rain
	rmSetGlobalRain(1.00);
  
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	int classPond=rmDefineClass("pond");
	int classNative = rmDefineClass("natives");
	int classWonder = rmDefineClass("wonder");
	int classCliff = rmDefineClass("Cliffs");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMost = rmCreatePieConstraint("Avoid Edge most",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.40), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMore = rmCreatePieConstraint("Avoid Center More",0.5,0.5,rmXFractionToMeters(0.36), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.43), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.20), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.35), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 40.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 12.0);
	int avoidForestShorter=rmCreateClassDistanceConstraint("avoid forest shorter", rmClassID("Forest"), 8.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 20.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 64.0);
	int avoidHunt2Med = rmCreateTypeDistanceConstraint("avoid hunt2 med", food2, 50.0);
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 80.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 30.0);
	int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt2 min", food2, 10.0);
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 80.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 64.0);
	int avoidHunt1Med = rmCreateTypeDistanceConstraint("avoid hunt1 med", food1, 50.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 30.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 25.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 55.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 75.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 15.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 40.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 80.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 100.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 64.0);
	int avoidNuggetVeryFar = rmCreateTypeDistanceConstraint("nugget avoid nugget very far", "AbstractNugget", 120.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 36.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 30.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 24.0);
	int avoidTownCenterHouse = rmCreateTypeDistanceConstraint("avoid Town Center house", "townCenter", 16.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 2.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 16.0);

	// Avoid impassable land
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 24.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 24.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 5.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 4.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int stayIsland=rmCreateClassDistanceConstraint("stay island", classIsland, 0.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 36.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 8.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short ", "water", true, 4.0);
	int avoidWaterMin = rmCreateTerrainDistanceConstraint("avoid water min ", "water", true, 2.0);
	int avoidPondMin=rmCreateClassDistanceConstraint("avoid pond min", classPond, 4.0);
	int avoidPond=rmCreateClassDistanceConstraint("avoid pond", classPond, 40.0);
	int avoidPondFar=rmCreateClassDistanceConstraint("avoid pond far", classPond, 50.0);
	int avoidPondShort=rmCreateClassDistanceConstraint("avoid pond short", classPond, 12.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 12.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 2.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 6.0);
	int avoidCliffMin = rmCreateClassDistanceConstraint("avoid cliff min", rmClassID("Cliffs"), 8.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", rmClassID("Cliffs"), 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 12.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 16.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 32.0);
	int avoidCliffVeryFar = rmCreateClassDistanceConstraint("avoid cliff very far", rmClassID("Cliffs"), 100.0);
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
	int avoidTradeRouteSocketFar = rmCreateTypeDistanceConstraint("avoid trade route socket far", "socketTradeRoute", 16.0);

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
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.25, 0.26); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.75, 0.76); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				}
				else
				{
					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.25, 0.26); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);

					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.75, 0.76); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.34, 0.34, 0);
				}
			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.20, 0.30); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.35, 0.35, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.70, 0.80); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.35, 0.35, 0);
				}
				else if (teamZeroCount == 3) // 3v3
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.175, 0.325); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0.02);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.675, 0.825); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.36, 0.36, 0.02);
				}
				else // 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.15, 0.35); 
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.37, 0.37, 0.02);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.65, 0.85); 
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
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	// Main Land
	int mainLandID=rmCreateArea("mainland");
	rmSetAreaSize(mainLandID, 0.99, 0.99);
	rmSetAreaLocation(mainLandID, 0.50, 0.50);
	rmSetAreaMix(mainLandID, paintMix1); 
	rmSetAreaBaseHeight(mainLandID, 2.0); 
	rmSetAreaCoherence(mainLandID, 1.00);
	rmBuildArea(mainLandID); 

	// Player Areas
	for (i=1; < numPlayer) {
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID, rmAreaTilesToFraction(444));
		rmSetAreaLocPlayer(playerareaID, i);
		rmAddAreaToClass(playerareaID, classIsland);
		rmSetAreaCoherence(playerareaID, 0.222);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaMix(playerareaID, paintMix2);
//		rmSetAreaBaseHeight(playerareaID, 2.0); 
		rmSetAreaWarnFailure(playerareaID, false);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmBuildArea(playerareaID);
		rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 3.0);
		rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
		}

	// King's Island
	int kingislandID=rmCreateArea("King's Island");
	rmSetAreaSize(kingislandID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(kingislandID, 0.5, 0.5);
	rmSetAreaMix(kingislandID, paintMix1); 
	rmSetAreaBaseHeight(kingislandID, 2.0); 
	rmAddAreaToClass(kingislandID, classIsland);
	rmSetAreaCoherence(kingislandID, 0.50);
	if (rmGetIsKOTH() == true) 
		rmBuildArea(kingislandID); 

	int avoidKOTH = rmCreateAreaDistanceConstraint("avoid KOTH", kingislandID, 18.0);
	int stayKOTH = rmCreateAreaMaxDistanceConstraint("stay in KOTH", kingislandID, 0.0);

	if (rmGetIsKOTH() == true) {
	// Place King's Hill
	float xLoc = 0.5;
	float yLoc = 0.5;
	float walk = 0.0;

	ypKingsHillPlacer(xLoc, yLoc, walk, 0);
	rmEchoInfo("XLOC = "+xLoc);
	rmEchoInfo("XLOC = "+yLoc);
	}

	// Avoidance Islands
	int midBigIslandID=rmCreateArea("Big Mid Island");
	rmSetAreaSize(midBigIslandID, 0.66+0.00666*PlayerNum);
	rmSetAreaLocation(midBigIslandID, 0.5, 0.5);
//	rmSetAreaMix(midBigIslandID, forTesting);
	rmSetAreaCoherence(midBigIslandID, 1.00);
	rmBuildArea(midBigIslandID); 

	int avoidBigMidIsland = rmCreateAreaDistanceConstraint("avoid big mid island ", midBigIslandID, 8.0);
	int avoidBigMidIslandMin = rmCreateAreaDistanceConstraint("avoid big mid island min", midBigIslandID, 0.5);
	int avoidBigMidIslandFar = rmCreateAreaDistanceConstraint("avoid big mid island far", midBigIslandID, 16.0);
	int stayBigMidIsland = rmCreateAreaMaxDistanceConstraint("stay big mid island ", midBigIslandID, 0.0);

	int midLineID=rmCreateArea("Mid Line");
	rmSetAreaSize(midLineID, 0.05);
	rmSetAreaLocation(midLineID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(midLineID, 0.50, 0.99, 0.50, 0.01);
//	rmSetAreaMix(midLineID, forTesting);
	rmSetAreaCoherence(midLineID, 1.00);
	rmBuildArea(midLineID); 

	int avoidMidLine = rmCreateAreaDistanceConstraint("avoid mid line ", midLineID, 8.0);
	int avoidMidLineMin = rmCreateAreaDistanceConstraint("avoid mid line min", midLineID, 0.5);
	int avoidMidLineFar = rmCreateAreaDistanceConstraint("avoid mid line far", midLineID, 16.0);
	int stayMidLine = rmCreateAreaMaxDistanceConstraint("stay mid line ", midLineID, 0.0);
	
	int midLineTRID=rmCreateArea("Treaty Mid Line");
	rmSetAreaSize(midLineTRID, 0.35);
	rmSetAreaLocation(midLineTRID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(midLineTRID, 0.50, 0.99, 0.50, 0.01);
//	rmSetAreaMix(midLineTRID, forTesting);
	rmSetAreaCoherence(midLineTRID, 1.00);
	if (rmGetIsTreaty() == true)
		rmBuildArea(midLineTRID); 

	int avoidTRMidLine = rmCreateAreaDistanceConstraint("avoid treaty mid line ", midLineTRID, 12.0);
	int avoidTRMidLineMin = rmCreateAreaDistanceConstraint("avoid treaty mid line min", midLineTRID, 0.5);
	int avoidTRMidLineFar = rmCreateAreaDistanceConstraint("avoid treaty mid line far", midLineTRID, 16.0);
	int stayTRMidLine = rmCreateAreaMaxDistanceConstraint("stay treaty mid line ", midLineTRID, 0.0);
	
	int midIslandID=rmCreateArea("Mid Island");
	if (rmGetIsTreaty() == false)
		rmSetAreaSize(midIslandID, 0.34+0.01*PlayerNum);
	else
		rmSetAreaSize(midIslandID, 0.33+0.01*PlayerNum);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
//	rmSetAreaMix(midIslandID, forTesting);
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
	rmSetAreaCoherence(midSmIslandID, 1.00);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);
	
	// Text
	rmSetStatusText("",0.40);

	// ____________________ Rivers ____________________
	int riverID = rmRiverCreate(-5, wetType, 1, 1, 4+PlayerNum/2, 4+PlayerNum/2); 
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmRiverAddWaypoint(riverID,  0.10, 0.200);
		rmRiverAddWaypoint(riverID,  0.20, 0.225);
		rmRiverAddWaypoint(riverID,  0.40, 0.175);
		rmRiverAddWaypoint(riverID,  0.50, 0.200);
		rmRiverAddWaypoint(riverID,  0.60, 0.175);
		rmRiverAddWaypoint(riverID,  0.90, 0.200);
		rmRiverAddShallow(riverID, 0.10);
		rmRiverAddShallow(riverID, 0.40);
		rmRiverAddShallow(riverID, 0.60);
		rmRiverAddShallow(riverID, 0.90);
		}
	else {
		rmRiverAddWaypoint(riverID, 0.65, 0.65);
		rmRiverAddWaypoint(riverID, 0.50, 0.70);
		rmRiverAddWaypoint(riverID, 0.35, 0.65);
		rmRiverAddWaypoint(riverID, 0.30, 0.50);
		rmRiverAddWaypoint(riverID, 0.35, 0.35);
		rmRiverAddWaypoint(riverID, 0.50, 0.30);
		rmRiverAddWaypoint(riverID, 0.65, 0.35);
		rmRiverAddWaypoint(riverID, 0.70, 0.50);
		rmRiverAddWaypoint(riverID, 0.65, 0.65);
		rmRiverAddShallow(riverID, 0.00);
		rmRiverAddShallow(riverID, 0.20);
		rmRiverAddShallow(riverID, 0.40);
		rmRiverAddShallow(riverID, 0.60);
		rmRiverAddShallow(riverID, 0.80);
		}
	rmRiverSetShallowRadius(riverID, 6+PlayerNum);
	if (TeamNum > 2 || teamZeroCount != teamOneCount)
		rmRiverBuild(riverID);
	int river2ID = rmRiverCreate(-5, wetType, 1, 1, 4+PlayerNum/2, 4+PlayerNum/2); 
	rmRiverAddWaypoint(river2ID,  0.10, 0.800);
	rmRiverAddWaypoint(river2ID,  0.20, 0.775);
	rmRiverAddWaypoint(river2ID,  0.40, 0.825);
	rmRiverAddWaypoint(river2ID,  0.50, 0.800);
	rmRiverAddWaypoint(river2ID,  0.60, 0.825);
	rmRiverAddWaypoint(river2ID,  0.80, 0.775);
	rmRiverAddWaypoint(river2ID,  0.90, 0.800);
	rmRiverSetShallowRadius(river2ID, 6+PlayerNum);
	rmRiverAddShallow(river2ID, 0.10);
	rmRiverAddShallow(river2ID, 0.40);
	rmRiverAddShallow(river2ID, 0.60);
	rmRiverAddShallow(river2ID, 0.90);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
//		rmRiverBuild(river2ID);

	int fauxRiver1ID=rmCreateArea("faux river1");
	rmSetAreaSize(fauxRiver1ID, 0.05);
	rmSetAreaLocation(fauxRiver1ID, 0.50, 0.20);
	rmAddAreaInfluenceSegment(fauxRiver1ID, 0.00, 0.200, 0.20, 0.225);
	rmAddAreaInfluenceSegment(fauxRiver1ID, 0.20, 0.225, 0.40, 0.175);
	rmAddAreaInfluenceSegment(fauxRiver1ID, 0.40, 0.175, 0.50, 0.200);
	rmAddAreaInfluenceSegment(fauxRiver1ID, 0.50, 0.200, 0.60, 0.175);
	rmAddAreaInfluenceSegment(fauxRiver1ID, 0.60, 0.175, 1.00, 0.200);
	rmSetAreaCoherence(fauxRiver1ID, 0.777);
	rmSetAreaMix(fauxRiver1ID, paintMix4);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(fauxRiver1ID); 

	int fauxRiver2ID=rmCreateArea("faux river2");
	rmSetAreaSize(fauxRiver2ID, 0.05);
	rmSetAreaLocation(fauxRiver2ID, 0.50, 0.80);
	rmAddAreaInfluenceSegment(fauxRiver2ID, 0.00, 0.800, 0.20, 0.775);
	rmAddAreaInfluenceSegment(fauxRiver2ID, 0.20, 0.775, 0.40, 0.825);
	rmAddAreaInfluenceSegment(fauxRiver2ID, 0.40, 0.825, 0.50, 0.800);
	rmAddAreaInfluenceSegment(fauxRiver2ID, 0.50, 0.800, 0.60, 0.825);
	rmAddAreaInfluenceSegment(fauxRiver2ID, 0.60, 0.825, 1.00, 0.800);
	rmSetAreaMix(fauxRiver2ID, paintMix4);
	rmSetAreaCoherence(fauxRiver2ID, 0.777);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(fauxRiver2ID); 

	int avoidFauxRiver1 = rmCreateAreaDistanceConstraint("avoid faux river 1 ", fauxRiver1ID, 8.0);
	int avoidFauxRiver1Short = rmCreateAreaDistanceConstraint("avoid faux river 1 short", fauxRiver1ID, 4.0);
	int avoidFauxRiver1Min = rmCreateAreaDistanceConstraint("avoid faux river 1 min", fauxRiver1ID, 2.0);
	int avoidFauxRiver1Far = rmCreateAreaDistanceConstraint("avoid faux river 1 far", fauxRiver1ID, 16.0);
	int stayFauxRiver1 = rmCreateAreaMaxDistanceConstraint("stay faux river 1 ", fauxRiver1ID, 0.0);
	int stayNearFauxRiver1 = rmCreateAreaMaxDistanceConstraint("stay near faux river 1 ", fauxRiver1ID, 4.0);
	int avoidFauxRiver2 = rmCreateAreaDistanceConstraint("avoid faux river 2 ", fauxRiver2ID, 8.0);
	int avoidFauxRiver2Short = rmCreateAreaDistanceConstraint("avoid faux river 2 short", fauxRiver2ID, 4.0);
	int avoidFauxRiver2Min = rmCreateAreaDistanceConstraint("avoid faux river 2 min", fauxRiver2ID, 2.0);
	int avoidFauxRiver2Far = rmCreateAreaDistanceConstraint("avoid faux river 2 far", fauxRiver2ID, 16.0);
	int stayFauxRiver2 = rmCreateAreaMaxDistanceConstraint("stay faux river 2 ", fauxRiver2ID, 0.0);
	int stayNearFauxRiver2 = rmCreateAreaMaxDistanceConstraint("stay near faux river 2 ", fauxRiver2ID, 4.0);

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
	int natVariation = rmRandInt(1,2);
	
	float xNatLocA = 0.00;
	float yNatLocA = 0.00;
	float xNatLocB = 0.00;
	float yNatLocB = 0.00;
	float xNatLocC = 0.00;
	float yNatLocC = 0.00;
	float xNatLocD = 0.00;
	float yNatLocD = 0.00;

	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		if (rmGetIsTreaty() == false) {
			if (natVariation == 1) {
				xNatLocA = 0.65;
				yNatLocA = 0.65;
				xNatLocB = 0.35;
				yNatLocB = 0.35;
				}
			else {
				xNatLocA = 0.65;
				yNatLocA = 0.35;
				xNatLocB = 0.35;
				yNatLocB = 0.65;
				}
				xNatLocC = 0.50;
				yNatLocC = 0.50;
			}
		else {	// treaty
				whichVillage1 = 4;
				whichVillage2 = 1;
				whichVillage3 = 1;
				whichVillage4 = 3;
				xNatLocA = 0.30;
				yNatLocA = 0.70;
				xNatLocB = 0.70;
				yNatLocB = 0.70;
				xNatLocC = 0.30;
				yNatLocC = 0.90;
				xNatLocD = 0.70;
				yNatLocD = 0.90;
				}
		}
	else {
		xNatLocA = 0.60;
		yNatLocA = 0.50;
		xNatLocB = 0.40;
		yNatLocB = 0.50;
		xNatLocC = 0.50;
		yNatLocC = 0.60;
		xNatLocD = 0.50;
		yNatLocD = 0.40;
		}

	nativeID0 = rmCreateGrouping("native A", natGrpName1+whichVillage1);
	nativeID1 = rmCreateGrouping("native B", natGrpName1+whichVillage2);
	nativeID2 = rmCreateGrouping("native C", natGrpName2+whichVillage3);	
	nativeID3 = rmCreateGrouping("native D", natGrpName2+whichVillage4);	
		
	rmAddGroupingToClass(nativeID0, classNative);
	rmAddGroupingToClass(nativeID1, classNative);
	rmAddGroupingToClass(nativeID2, classNative);
	rmAddGroupingToClass(nativeID3, classNative);

	rmPlaceGroupingAtLoc(nativeID0, 0, xNatLocA, yNatLocA);
	rmPlaceGroupingAtLoc(nativeID1, 0, xNatLocB, yNatLocB);
	if (rmGetIsKOTH() == false) {
		rmPlaceGroupingAtLoc(nativeID2, 0, xNatLocC, yNatLocC);
		if (rmGetIsTreaty() == true || TeamNum > 2 || teamOneCount != teamZeroCount)
			rmPlaceGroupingAtLoc(nativeID3, 0, xNatLocD, yNatLocD);
		}

	// Native Islands
	int treatyNatZoneID=rmCreateArea("treaty nat zone");
	rmSetAreaSize(treatyNatZoneID, 0.20);
	rmSetAreaLocation(treatyNatZoneID, 0.50, 0.99);
	rmSetAreaMix(treatyNatZoneID, paintMix4); 
	rmSetAreaCoherence(treatyNatZoneID, 0.777);
	if (rmGetIsTreaty() == true && TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(treatyNatZoneID); 
	
	int avoidNatZone = rmCreateAreaDistanceConstraint("avoid nat zone", treatyNatZoneID, 4.0);

	int natIslandID=rmCreateArea("nat Island 1");
	rmSetAreaSize(natIslandID, rmAreaTilesToFraction(255));
	rmSetAreaLocation(natIslandID, xNatLocA, yNatLocA);
	rmSetAreaMix(natIslandID, paintMix2); 
//	rmSetAreaBaseHeight(natIslandID, 2.0); 
	rmAddAreaToClass(natIslandID, classIsland);
	rmSetAreaCoherence(natIslandID, 0.777);
	rmBuildArea(natIslandID); 

	int natIsland2ID=rmCreateArea("nat Island 2");
	rmSetAreaSize(natIsland2ID, rmAreaTilesToFraction(255));
	rmSetAreaLocation(natIsland2ID, xNatLocB, yNatLocB);
	rmSetAreaMix(natIsland2ID, paintMix2); 
//	rmSetAreaBaseHeight(natIsland2ID, 2.0); 
	rmAddAreaToClass(natIsland2ID, classIsland);
	rmSetAreaCoherence(natIsland2ID, 0.777);
	rmBuildArea(natIsland2ID); 

	int natIsland3ID=rmCreateArea("nat Island 3");
	rmSetAreaSize(natIsland3ID, rmAreaTilesToFraction(255));
	rmSetAreaLocation(natIsland3ID, xNatLocC, yNatLocC);
	rmSetAreaMix(natIsland3ID, paintMix2); 
//	rmSetAreaBaseHeight(natIsland3ID, 2.0); 
	rmAddAreaToClass(natIsland3ID, classIsland);
	rmSetAreaCoherence(natIsland3ID, 0.777);
	rmBuildArea(natIsland3ID); 

	int natIsland4ID=rmCreateArea("nat Island 4");
	rmSetAreaSize(natIsland4ID, rmAreaTilesToFraction(255));
	rmSetAreaLocation(natIsland4ID, xNatLocD, yNatLocD);
	rmSetAreaMix(natIsland4ID, paintMix2); 
//	rmSetAreaBaseHeight(natIsland4ID, 2.0); 
	rmAddAreaToClass(natIsland4ID, classIsland);
	rmSetAreaCoherence(natIsland4ID, 0.777);
	rmBuildArea(natIsland4ID); 

	// ____________________ Trade Routes ____________________
	if (TeamNum <= 2 && teamZeroCount == teamOneCount) {
		// first TR - bottom side
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmSetObjectDefMinDistance(socketID, 2.0);
        rmSetObjectDefMaxDistance(socketID, 8.0);      

		int tradeRouteID = rmCreateTradeRoute();
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.10);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.10);
        rmBuildTradeRoute(tradeRouteID, toiletPaper);

        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
		
		if (PlayerNum > 4) {
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);		
			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);		
			}
			
		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		if (rmGetIsTreaty() == false) {	// second TR - top side
			int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
        	rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
        	rmSetObjectDefAllowOverlap(socketID2, true);
        	rmSetObjectDefMinDistance(socketID2, 2.0);
        	rmSetObjectDefMaxDistance(socketID2, 8.0);      

        	int tradeRouteID2 = rmCreateTradeRoute();
        	rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
			rmAddTradeRouteWaypoint(tradeRouteID2, 0.80, 0.90);
			rmAddTradeRouteWaypoint(tradeRouteID2, 0.20, 0.90);
        	rmBuildTradeRoute(tradeRouteID2, toiletPaper);

        	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.15);
        	rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);

			if (PlayerNum > 4) {
				socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.35);
				rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);

				socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.65);
				rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
				}

			socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.85);
        	rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
			}
		}
	else {	// ffa TR - ring
	int socketID3=rmCreateObjectDef("sockets to dock Trade Posts3");
        rmAddObjectDefItem(socketID3, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID3, true);
        rmSetObjectDefMinDistance(socketID3, 0.0);
        rmSetObjectDefMaxDistance(socketID3, 6.0);    
	       
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

	// Cliffs
//	int cliffcount = 4; 
	int cliffcount = 3; 
	if (rmGetIsTreaty() == true)
		cliffcount = 2;
	
	for (i= 0; < cliffcount)
	{
		int cliff1ID = rmCreateArea("cliff1"+i);
		rmAddAreaToClass(cliff1ID, classCliff);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmSetAreaSize(cliff1ID, 0.004-0.0001*PlayerNum, 0.0045-0.0001*PlayerNum);
		else
			rmSetAreaSize(cliff1ID, 0.001, 0.0015);
		rmSetAreaObeyWorldCircleConstraint(cliff1ID, false);
		rmSetAreaCliffType(cliff1ID, mntType); 
		rmSetAreaTerrainType(cliff1ID, cliffPaint);
		rmSetAreaCliffEdge(cliff1ID, 1, 1.00, 0.0, 0.0, 1); 
		rmSetAreaCliffHeight(cliff1ID, 12, 0.1, 0.5); 
	//	rmSetAreaHeightBlend(cliff1ID, 1);
		rmSetAreaCoherence(cliff1ID, 0.888);
		rmAddAreaConstraint(cliff1ID, avoidTradeRouteSocket);
		if (i <= 0 && rmGetIsTreaty() == false)
			rmSetAreaLocation(cliff1ID, 0.50, 0.20);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
		{
			rmAddAreaConstraint(cliff1ID, stayFauxRiver1);
			if (rmGetIsTreaty() == false)
				rmAddAreaConstraint(cliff1ID, avoidCliffFar);
			else 
				rmAddAreaConstraint(cliff1ID, avoidCliffVeryFar);
		}
		else
		{
			rmAddAreaConstraint(cliff1ID, avoidIslandFar);
			rmAddAreaConstraint(cliff1ID, avoidMidSmIslandMin);
			rmAddAreaConstraint(cliff1ID, avoidCliffVeryFar);
			rmAddAreaConstraint(cliff1ID, avoidTownCenterFar);
		}
		rmAddAreaConstraint(cliff1ID, avoidEdgeMore);	
		rmAddAreaConstraint(cliff1ID, avoidTradeRouteMin);
		rmAddAreaConstraint(cliff1ID, avoidIslandMin);
		rmAddAreaConstraint(cliff1ID, avoidNativesShort);
		rmAddAreaConstraint(cliff1ID, avoidImpassableLandMin);
		rmAddAreaConstraint(cliff1ID, avoidWaterFar);
//		rmAddAreaConstraint(cliff1ID, avoidMidLine);
		if (rmGetIsTreaty() == true)
			rmAddAreaConstraint(cliff1ID, avoidTRMidLine);
		rmSetAreaWarnFailure(cliff1ID, false);
		rmBuildArea(cliff1ID);		
	}

	for (i= 0; < cliffcount)
	{
		int cliff2ID = rmCreateArea("cliff2"+i);
		rmAddAreaToClass(cliff2ID, classCliff);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmSetAreaSize(cliff2ID, 0.004-0.0001*PlayerNum, 0.0045-0.0001*PlayerNum);
		else
			rmSetAreaSize(cliff2ID, 0.001, 0.0015);
		rmSetAreaObeyWorldCircleConstraint(cliff2ID, false);
		rmSetAreaCliffType(cliff2ID, mntType); 
		rmSetAreaTerrainType(cliff2ID, cliffPaint);
		rmSetAreaCliffEdge(cliff2ID, 1, 1.00, 0.0, 0.0, 1); 
		rmSetAreaCliffHeight(cliff2ID, 12, 0.1, 0.5); 
	//	rmSetAreaHeightBlend(cliff2ID, 1);
		rmSetAreaCoherence(cliff2ID, 0.888);
		rmAddAreaConstraint(cliff2ID, avoidTradeRouteSocket);
		if (i <= 0 && rmGetIsTreaty() == false)
			rmSetAreaLocation(cliff2ID, 0.50, 0.80);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
		{
			rmAddAreaConstraint(cliff2ID, stayFauxRiver2);
			if (rmGetIsTreaty() == false)
				rmAddAreaConstraint(cliff2ID, avoidCliffFar);
			else 
				rmAddAreaConstraint(cliff2ID, avoidCliffVeryFar);
		}
		else
		{
			rmAddAreaConstraint(cliff2ID, avoidIslandFar);
			rmAddAreaConstraint(cliff2ID, avoidMidSmIslandMin);
			rmAddAreaConstraint(cliff2ID, avoidCliffVeryFar);
			rmAddAreaConstraint(cliff2ID, avoidTownCenterFar);
		}
		rmAddAreaConstraint(cliff2ID, avoidEdgeMore);	
		rmAddAreaConstraint(cliff2ID, avoidTradeRouteMin);
		rmAddAreaConstraint(cliff2ID, avoidIslandMin);
		rmAddAreaConstraint(cliff2ID, avoidNativesShort);
		rmAddAreaConstraint(cliff2ID, avoidImpassableLandMin);
		rmAddAreaConstraint(cliff2ID, avoidWaterFar);
//		rmAddAreaConstraint(cliff2ID, avoidMidLine);
		if (rmGetIsTreaty() == true)
			rmAddAreaConstraint(cliff2ID, avoidTRMidLine);
		rmSetAreaWarnFailure(cliff2ID, false);
		rmBuildArea(cliff2ID);		
	}

	// Gold Zone NW
	int GoldZoneNWID = rmCreateArea("gold zone NW");
	rmSetAreaSize(GoldZoneNWID, 0.10);
	rmSetAreaLocation(GoldZoneNWID, 0.50, 0.95);
//	rmAddAreaToClass(GoldZoneNWID, classIsland);
	rmSetAreaWarnFailure(GoldZoneNWID, false);
//	rmSetAreaMix(GoldZoneNWID, forTesting);	
	rmSetAreaCoherence(GoldZoneNWID, 1.0); 
	rmSetAreaObeyWorldCircleConstraint(GoldZoneNWID, false);
	rmAddAreaConstraint(GoldZoneNWID, avoidCliffMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddAreaConstraint(GoldZoneNWID, avoidFauxRiver1Min);
		rmAddAreaConstraint(GoldZoneNWID, avoidFauxRiver2Min);
		}
	if (TeamNum == 2 && teamZeroCount == teamOneCount)	
		rmBuildArea(GoldZoneNWID);	

	// Gold Zone SE
	int GoldZoneSEID = rmCreateArea("gold zone SE");
	rmSetAreaSize(GoldZoneSEID, 0.10);
	rmSetAreaLocation(GoldZoneSEID, 0.50, 0.05);
//	rmAddAreaToClass(GoldZoneSEID, classIsland);
	rmSetAreaWarnFailure(GoldZoneSEID, false);
//	rmSetAreaMix(GoldZoneSEID, forTesting);	
	rmSetAreaCoherence(GoldZoneSEID, 1.0);  
	rmSetAreaObeyWorldCircleConstraint(GoldZoneSEID, false);
	rmAddAreaConstraint(GoldZoneSEID, avoidCliffMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddAreaConstraint(GoldZoneSEID, avoidFauxRiver1Min);
		rmAddAreaConstraint(GoldZoneSEID, avoidFauxRiver2Min);
		}
	if (TeamNum == 2 && teamZeroCount == teamOneCount)	
		rmBuildArea(GoldZoneSEID);	

	int avoidGoldZoneSE = rmCreateAreaDistanceConstraint("avoid gold zone E ", GoldZoneSEID, 8.0);
	int avoidGoldZoneSEFar = rmCreateAreaDistanceConstraint("avoid gold zone E far", GoldZoneSEID, 16.0);
	int avoidGoldZoneSEVeryFar = rmCreateAreaDistanceConstraint("avoid gold zone E very far", GoldZoneSEID, 24.0);
	int avoidGoldZoneSEShort = rmCreateAreaDistanceConstraint("avoid gold zone E short ", GoldZoneSEID, 4.0);
	int avoidGoldZoneSEMin = rmCreateAreaDistanceConstraint("avoid gold zone E min ", GoldZoneSEID, 0.5);
	int stayGoldZoneSE = rmCreateAreaMaxDistanceConstraint("stay in gold zone E ", GoldZoneSEID, 0.0);	
	int avoidGoldZoneNW = rmCreateAreaDistanceConstraint("avoid gold zone W ", GoldZoneNWID, 8.0);
	int avoidGoldZoneNWFar = rmCreateAreaDistanceConstraint("avoid gold zone W far", GoldZoneNWID, 16.0);
	int avoidGoldZoneNWVeryFar = rmCreateAreaDistanceConstraint("avoid gold zone W very far", GoldZoneNWID, 24.0);
	int avoidGoldZoneNWShort = rmCreateAreaDistanceConstraint("avoid gold zone W short ", GoldZoneNWID, 4.0);
	int avoidGoldZoneNWMin = rmCreateAreaDistanceConstraint("avoid gold zone W min ", GoldZoneNWID, 0.5);
	int stayGoldZoneNW = rmCreateAreaMaxDistanceConstraint("stay in gold zone W ", GoldZoneNWID, 0.0);

	// ____________________ Static Resources ____________________
	// Static Mines 
	int staticMineID = rmCreateObjectDef("static mine 1");
		rmAddObjectDefItem(staticMineID, "mine", 1, 2.0);
		rmSetObjectDefMinDistance(staticMineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticMineID, rmXFractionToMeters(0.01));
		rmAddObjectDefToClass(staticMineID, classStartingResource);
		rmAddObjectDefToClass(staticMineID, classGold);
		rmAddObjectDefConstraint(staticMineID, avoidWaterMin);
		rmAddObjectDefConstraint(staticMineID, avoidImpassableLandMin);
		if (rmGetIsTreaty() == false) {
			if (natVariation == 1) {
				rmPlaceObjectDefAtLoc(staticMineID, 0, 0.55, 0.60);
				rmPlaceObjectDefAtLoc(staticMineID, 0, 0.45, 0.40);
				}
			else {
				rmPlaceObjectDefAtLoc(staticMineID, 0, 0.45, 0.60);
				rmPlaceObjectDefAtLoc(staticMineID, 0, 0.55, 0.40);
				}
			}
		else {
			rmPlaceObjectDefAtLoc(staticMineID, 0, 0.55, 0.60);
			rmPlaceObjectDefAtLoc(staticMineID, 0, 0.45, 0.40);
			rmPlaceObjectDefAtLoc(staticMineID, 0, 0.45, 0.60);
			rmPlaceObjectDefAtLoc(staticMineID, 0, 0.55, 0.40);
			}

	if (PlayerNum == 2) {
		int staticMine2ID = rmCreateObjectDef("mines behind base");
		rmAddObjectDefItem(staticMine2ID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(staticMine2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticMine2ID, rmXFractionToMeters(0.025));
		rmAddObjectDefToClass(staticMine2ID, classGold);
		rmAddObjectDefToClass(staticMine2ID, classStartingResource);
		rmAddObjectDefConstraint(staticMine2ID, avoidWaterShort);
		rmAddObjectDefConstraint(staticMine2ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(staticMine2ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(staticMine2ID, avoidTradeRoute);
		rmAddObjectDefConstraint(staticMine2ID, avoidCliffShort);
		rmAddObjectDefConstraint(staticMine2ID, avoidIsland);
		rmPlaceObjectDefAtLoc(staticMine2ID, 0, 0.90, 0.70);
		rmPlaceObjectDefAtLoc(staticMine2ID, 0, 0.90, 0.30);
		rmPlaceObjectDefAtLoc(staticMine2ID, 0, 0.10, 0.70);
		rmPlaceObjectDefAtLoc(staticMine2ID, 0, 0.10, 0.30);
		}

	// Static Herds 
	int staticherdID = rmCreateObjectDef("static herd");
		rmAddObjectDefItem(staticherdID, food2, 6, 5.0);
		rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.02));
		rmAddObjectDefToClass(staticherdID, classStartingResource);
		rmSetObjectDefCreateHerd(staticherdID, true);
		if (rmGetIsTreaty() == false) {
			if (natVariation == 1) {
				rmPlaceObjectDefAtLoc(staticherdID, 0, 0.45, 0.60);
				rmPlaceObjectDefAtLoc(staticherdID, 0, 0.55, 0.40);
				}
			else {
				rmPlaceObjectDefAtLoc(staticherdID, 0, 0.45, 0.60);
				rmPlaceObjectDefAtLoc(staticherdID, 0, 0.55, 0.40);
				}
			}
		else {
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.45, 0.60);
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.55, 0.40);
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.45, 0.60);
			rmPlaceObjectDefAtLoc(staticherdID, 0, 0.55, 0.40);
			}

	// Text
	rmSetStatusText("",0.50);

	// ____________________ Starting Resources ____________________

	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	int startingUnits = rmCreateStartingUnitsObjectDef(20.0);
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
	rmAddObjectDefItem(playerGoldID, "Mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 16.0);
	rmSetObjectDefMaxDistance(playerGoldID, 16.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidGoldShort);
	rmAddObjectDefConstraint(playerGoldID, avoidImpassableLandMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerGoldID, avoidFauxRiver1Min);
		rmAddObjectDefConstraint(playerGoldID, avoidFauxRiver2Min);
		}
	rmAddObjectDefConstraint(playerGoldID, avoidCliffMin);
	if (rmGetIsTreaty() == false)
		rmAddObjectDefConstraint(playerGoldID, stayMidIsland);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 33.0);
	rmSetObjectDefMaxDistance(playerGold2ID, 36.0);
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidGoldShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidNativesShort);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerGold2ID, avoidFauxRiver1Min);
		rmAddObjectDefConstraint(playerGold2ID, avoidFauxRiver2Min);
		rmAddObjectDefConstraint(playerGold2ID, avoidGoldZoneNW);
		rmAddObjectDefConstraint(playerGold2ID, avoidGoldZoneSE);
		}
	rmAddObjectDefConstraint(playerGold2ID, avoidCliffMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidMidIslandFar);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType1, 1, 3.0);
	rmAddObjectDefItem(playerTreeID, treeType2, 2, 5.0);
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 22);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTreeID, avoidCliffMin);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShorter);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketMin);

	int playerTree2ID = rmCreateObjectDef("player 2nd trees");
	rmAddObjectDefItem(playerTree2ID, treeType1, 6, 8.0);
	rmAddObjectDefItem(playerTree2ID, treeType2, 6, 8.0);
    rmSetObjectDefMinDistance(playerTree2ID, 44);
    rmSetObjectDefMaxDistance(playerTree2ID, 50);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidMidIslandFar);
	rmAddObjectDefConstraint(playerTree2ID, stayBigMidIsland);
	rmAddObjectDefConstraint(playerTree2ID, stayNearEdge);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidCliffFar);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerTree2ID, avoidFauxRiver1Min);
		rmAddObjectDefConstraint(playerTree2ID, avoidFauxRiver2Min);
		}

	// Starting berries 
	int playerBerriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerriesID, "berrybush", 5, 4.0);
	rmSetObjectDefMinDistance(playerBerriesID, 14.0);
	rmSetObjectDefMaxDistance(playerBerriesID, 14.0);
	rmAddObjectDefToClass(playerBerriesID, classStartingResource);
	rmAddObjectDefConstraint(playerBerriesID, avoidCliffMin);
	rmAddObjectDefConstraint(playerBerriesID, avoidStartingResourcesShort);
	
	// Starting herd 
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, food1, 1, 0.0);
	rmSetObjectDefMinDistance(playerHerdID, 8);
	rmSetObjectDefMaxDistance(playerHerdID, 8);
	rmSetObjectDefCreateHerd(playerHerdID, false);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(playerHerdID, avoidCliffMin);
	rmAddObjectDefConstraint(playerHerdID, avoidForestShorter);
		
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerHerd2ID, food2, 16, 6.0);
	else
		rmAddObjectDefItem(playerHerd2ID, food2, 12, 4.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 24);
    rmSetObjectDefMaxDistance(playerHerd2ID, 24);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerHerd2ID, stayBigMidIsland);
	rmAddObjectDefConstraint(playerHerd2ID, avoidCliffShort);

	int playerHerd3ID = rmCreateObjectDef("player 3rd herd");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerHerd3ID, food1, 16, 6.0);
	else
		rmAddObjectDefItem(playerHerd3ID, food1, 8, 3.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 50);
    rmSetObjectDefMaxDistance(playerHerd3ID, 50);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerHerd3ID, avoidEdge);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNativesShort);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerHerd3ID, avoidFauxRiver1Min);
		rmAddObjectDefConstraint(playerHerd3ID, avoidFauxRiver2Min);
		}
	rmAddObjectDefConstraint(playerHerd3ID, stayBigMidIsland);
	rmAddObjectDefConstraint(playerHerd3ID, avoidCliffMin);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerHerd3ID, avoidMidIslandMin);
	else
		rmAddObjectDefConstraint(playerHerd3ID, avoidMidIsland);

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
	rmAddObjectDefConstraint(playerNuggetID, avoidCliffMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		rmAddObjectDefConstraint(playerNuggetID, avoidFauxRiver1Min);
		rmAddObjectDefConstraint(playerNuggetID, avoidFauxRiver2Min);
		}
	if (PlayerNum > 2)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidIsland);

	//  Place Starting Objects/Resources
	for(i=1; <numPlayer) {
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		// Starting herds
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		// Starting Trees
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerBerriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		// Extra res for larger games 
		if (PlayerNum > 2) {
			rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			if (rmGetIsTreaty() == true)
				rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
		if (TeamNum > 2 || teamZeroCount != teamOneCount)
			rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		}
	
	// Text
	rmSetStatusText("",0.60);

	// MOAR CLIFFS
	int cliff3ID = rmCreateArea("cliff3");
		rmAddAreaToClass(cliff3ID, classCliff);
		if (rmGetIsTreaty() == true) {
			rmSetAreaLocation(cliff3ID, 0.60, 0.65);
			rmSetAreaSize(cliff3ID, rmAreaTilesToFraction(60+20*PlayerNum));
			rmSetAreaCoherence(cliff3ID, 0.666);
			}
		else {
			rmSetAreaLocation(cliff3ID, 0.01, 0.50);
			rmSetAreaSize(cliff3ID, 0.05);
			rmAddAreaConstraint(cliff3ID, avoidBigMidIslandMin);
			rmAddAreaConstraint(cliff3ID, avoidCliffFar);
			rmSetAreaCoherence(cliff3ID, 1.00);
			}
		rmSetAreaObeyWorldCircleConstraint(cliff3ID, false);
		rmSetAreaCliffType(cliff3ID, mntType); 
		rmSetAreaTerrainType(cliff3ID, cliffPaint);
		rmSetAreaCliffEdge(cliff3ID, 1, 1.00, 0.0, 0.0, 1); 
		rmSetAreaCliffHeight(cliff3ID, 8, 0.1, 0.5); 
		rmSetAreaSmoothDistance(cliff3ID, 3);
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddAreaConstraint(cliff3ID, avoidFauxRiver1);
			rmAddAreaConstraint(cliff3ID, avoidFauxRiver2);
			rmAddAreaConstraint(cliff3ID, avoidGoldZoneNW);
			rmAddAreaConstraint(cliff3ID, avoidGoldZoneSE);
			}
		rmAddAreaConstraint(cliff3ID, avoidStartingResourcesShort);
		rmAddAreaConstraint(cliff3ID, avoidNativesShort);
		rmSetAreaWarnFailure(cliff3ID, false);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmBuildArea(cliff3ID);	

	int cliff4ID = rmCreateArea("cliff4");
		rmAddAreaToClass(cliff4ID, classCliff);
		if (rmGetIsTreaty() == true) {
			rmSetAreaLocation(cliff4ID, 0.40, 0.65);
			rmSetAreaSize(cliff4ID, rmAreaTilesToFraction(60+20*PlayerNum));
			rmSetAreaCoherence(cliff4ID, 0.666);
			}
		else {
			rmSetAreaLocation(cliff4ID, 0.99, 0.50);
			rmSetAreaSize(cliff4ID, 0.05);
			rmAddAreaConstraint(cliff4ID, avoidBigMidIslandMin);
			rmAddAreaConstraint(cliff4ID, avoidCliffFar);
			rmSetAreaCoherence(cliff4ID, 1.00);
			}
		rmSetAreaObeyWorldCircleConstraint(cliff4ID, false);
		rmSetAreaCliffType(cliff4ID, mntType); 
		rmSetAreaTerrainType(cliff4ID, cliffPaint);
		rmSetAreaCliffEdge(cliff4ID, 1, 1.00, 0.0, 0.0, 1); 
		rmSetAreaCliffHeight(cliff4ID, 8, 0.1, 0.5); 
		rmSetAreaSmoothDistance(cliff4ID, 3);
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddAreaConstraint(cliff4ID, avoidFauxRiver1);
			rmAddAreaConstraint(cliff4ID, avoidFauxRiver2);
			rmAddAreaConstraint(cliff4ID, avoidGoldZoneNW);
			rmAddAreaConstraint(cliff4ID, avoidGoldZoneSE);
			}
		rmAddAreaConstraint(cliff4ID, avoidStartingResourcesShort);
		rmAddAreaConstraint(cliff4ID, avoidNativesShort);
		rmSetAreaWarnFailure(cliff4ID, false);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmBuildArea(cliff4ID);	

	// ____________________ Common Resources ____________________
	// SE Mines 
	int SEgoldID = rmCreateObjectDef("common mines 1");
		rmAddObjectDefItem(SEgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(SEgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(SEgoldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(SEgoldID, classGold);
		rmAddObjectDefConstraint(SEgoldID, avoidWaterMin);
		rmAddObjectDefConstraint(SEgoldID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(SEgoldID, avoidGoldFar);
		rmAddObjectDefConstraint(SEgoldID, avoidEdge);
		rmAddObjectDefConstraint(SEgoldID, avoidPondShort);
		rmAddObjectDefConstraint(SEgoldID, avoidNativesShort);
		rmAddObjectDefConstraint(SEgoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(SEgoldID, avoidStartingResourcesMin);
		rmAddObjectDefConstraint(SEgoldID, avoidCliffShort);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmAddObjectDefConstraint(SEgoldID, stayGoldZoneSE);
		if (rmGetIsTreaty() == true) {
			rmAddObjectDefConstraint(SEgoldID, avoidTRMidLine);
			rmPlaceObjectDefAtLoc(SEgoldID, 0, 0.50, 0.50, 2);
			}
		else {
			rmAddObjectDefConstraint(SEgoldID, avoidMidLine);
			rmPlaceObjectDefAtLoc(SEgoldID, 0, 0.50, 0.50, PlayerNum);
			}
	
	// NW Mines 
	int NWgoldID = rmCreateObjectDef("common mines 2");
		rmAddObjectDefItem(NWgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(NWgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(NWgoldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(NWgoldID, classGold);
		rmAddObjectDefConstraint(NWgoldID, avoidWaterMin);
		rmAddObjectDefConstraint(NWgoldID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(NWgoldID, avoidGoldFar);
		rmAddObjectDefConstraint(NWgoldID, avoidEdge);
		rmAddObjectDefConstraint(NWgoldID, avoidPondShort);
		rmAddObjectDefConstraint(NWgoldID, avoidNativesShort);
		rmAddObjectDefConstraint(NWgoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(NWgoldID, avoidStartingResourcesMin);
		rmAddObjectDefConstraint(NWgoldID, avoidCliffShort);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmAddObjectDefConstraint(NWgoldID, stayGoldZoneNW);
		if (rmGetIsTreaty() == true) {
			rmAddObjectDefConstraint(NWgoldID, avoidTRMidLine);
			rmPlaceObjectDefAtLoc(NWgoldID, 0, 0.50, 0.50, 2);
			}
		else {
			rmAddObjectDefConstraint(NWgoldID, avoidMidLine);
			rmPlaceObjectDefAtLoc(NWgoldID, 0, 0.50, 0.50, PlayerNum);
			}

	// Common Mines 
	if (PlayerNum > 2) {
		int commongoldID = rmCreateObjectDef("common mines");
		rmAddObjectDefItem(commongoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(commongoldID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(commongoldID, rmXFractionToMeters(0.40));
		rmAddObjectDefToClass(commongoldID, classGold);
		rmAddObjectDefConstraint(commongoldID, avoidWaterMin);
		rmAddObjectDefConstraint(commongoldID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(commongoldID, avoidGoldFar);
		rmAddObjectDefConstraint(commongoldID, avoidTownCenter);
		rmAddObjectDefConstraint(commongoldID, avoidNativesFar);
		rmAddObjectDefConstraint(commongoldID, avoidIslandMin);
		rmAddObjectDefConstraint(commongoldID, avoidPondMin);
		rmAddObjectDefConstraint(commongoldID, avoidStartingResourcesMin);
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(commongoldID, avoidGoldZoneNW);
			rmAddObjectDefConstraint(commongoldID, avoidGoldZoneSE);
			}
		rmAddObjectDefConstraint(commongoldID, avoidCliffMin);
		rmPlaceObjectDefAtLoc(commongoldID, 0, 0.50, 0.50, PlayerNum);
		}
		
	// Text
	rmSetStatusText("",0.70);

	// ____________________ Forest ____________________
	int mainforestcount = 20+7*PlayerNum;
	int stayInForestPatch = -1;
	int treeWater = rmCreateTerrainDistanceConstraint("trees avoid river", "Land", false, 4.0);

	for (i=0; < mainforestcount)
    {
		int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(100));
	//	rmSetAreaTerrainType(forestpatchID, forestPaint);
        rmSetAreaMix(forestpatchID, paintMix3);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmAddAreaConstraint(forestpatchID, avoidTownCenterShort);
		rmAddAreaConstraint(forestpatchID, avoidStartingResourcesShort);
		rmAddAreaConstraint(forestpatchID, avoidNativesShort);
		rmAddAreaConstraint(forestpatchID, avoidHunt1Min);
		rmAddAreaConstraint(forestpatchID, avoidHunt2Min);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocketMin);
		rmAddAreaConstraint(forestpatchID, avoidForest);
		rmAddAreaConstraint(forestpatchID, avoidGoldMin);
		rmAddAreaConstraint(forestpatchID, avoidNuggetMin);
		rmAddAreaConstraint(forestpatchID, avoidIslandMin);
		rmAddAreaConstraint(forestpatchID, avoidImpassableLandShort);
		if (rmGetIsTreaty() == true && TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddAreaConstraint(forestpatchID, avoidNatZone);
		rmAddAreaConstraint(forestpatchID, avoidCliff);
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddAreaConstraint(forestpatchID, avoidGoldZoneNW);
			rmAddAreaConstraint(forestpatchID, avoidGoldZoneSE);
			rmAddAreaConstraint(forestpatchID, avoidFauxRiver1);
			rmAddAreaConstraint(forestpatchID, avoidFauxRiver2);
			}
		rmAddAreaConstraint(forestpatchID, treeWater);
        rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
			rmAddObjectDefItem(foresttreeID, treeType1, 8, 8.0);
			rmAddObjectDefItem(foresttreeID, treeType2, 4, 6.0);
			rmSetObjectDefMinDistance(foresttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(foresttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(foresttreeID, avoidGoldMin);
			rmAddObjectDefConstraint(foresttreeID, avoidCliff);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);

		int foresttree2ID = rmCreateObjectDef("second forest trees"+i);
			rmAddObjectDefItem(foresttree2ID, treeType1, 8, 8.0);
			rmAddObjectDefItem(foresttree2ID, treeType2, 4, 6.0);
			rmSetObjectDefMinDistance(foresttree2ID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(foresttree2ID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttree2ID, classForest);
			rmAddObjectDefConstraint(foresttree2ID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(foresttree2ID, avoidGoldMin);
			rmAddObjectDefConstraint(foresttree2ID, avoidCliff);
			rmAddObjectDefConstraint(foresttree2ID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttree2ID, 0, 0.50, 0.50);
    }

	// Random Trees
	int randdomTreeID = rmCreateObjectDef("random tree");
		rmAddObjectDefItem(randdomTreeID, treeType1, 3, 4.0);
		rmAddObjectDefItem(randdomTreeID, treeType2, 1, 4.0);
		rmSetObjectDefMinDistance(randdomTreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randdomTreeID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(randdomTreeID, classForest);
		rmAddObjectDefConstraint(randdomTreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(randdomTreeID, avoidCliff);
		rmAddObjectDefConstraint(randdomTreeID, avoidForestShorter);
		rmAddObjectDefConstraint(randdomTreeID, avoidTownCenterMin);
		rmAddObjectDefConstraint(randdomTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randdomTreeID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(randdomTreeID, avoidStartingResourcesMin);
		rmAddObjectDefConstraint(randdomTreeID, avoidNativesShort);
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(randdomTreeID, avoidGoldZoneNWMin);
			rmAddObjectDefConstraint(randdomTreeID, avoidGoldZoneSEMin);
			}
		rmPlaceObjectDefAtLoc(randdomTreeID, 0, 0.50, 0.50, 10+10*PlayerNum);

	// Text
	rmSetStatusText("",0.80);

	// Central Herds 
	int centralherdID = rmCreateObjectDef("central herd");
		rmAddObjectDefItem(centralherdID, food2, 8, 3.0);
		rmSetObjectDefMinDistance(centralherdID, rmXFractionToMeters(0.00));
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(centralherdID, rmXFractionToMeters(0.05));
		else
			rmSetObjectDefMaxDistance(centralherdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(centralherdID, true);
		rmAddObjectDefConstraint(centralherdID, avoidCliffMin);
		rmAddObjectDefConstraint(centralherdID, avoidForestMin);
		rmAddObjectDefConstraint(centralherdID, avoidGoldMin);
		rmAddObjectDefConstraint(centralherdID, avoidNativesShort);
		rmAddObjectDefConstraint(centralherdID, avoidTownCenter);
		rmAddObjectDefConstraint(centralherdID, avoidIslandMin);
		rmAddObjectDefConstraint(centralherdID, avoidWaterMin);
		rmAddObjectDefConstraint(centralherdID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(centralherdID, avoidPondMin);
		rmAddObjectDefConstraint(centralherdID, avoidEdge);
		if (TeamNum == 2 && teamZeroCount == teamOneCount && PlayerNum > 2) {
			rmAddObjectDefConstraint(centralherdID, avoidGoldZoneNW);
			rmAddObjectDefConstraint(centralherdID, avoidGoldZoneSE);
			}
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(centralherdID, avoidHunt1Far);
			rmAddObjectDefConstraint(centralherdID, avoidHunt2Far);
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.50, 0.50, 3*PlayerNum);
			}
		else {
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.30, 0.35);
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.70, 0.65);
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.30, 0.65);
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.70, 0.35);
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.50, 0.15);
			rmPlaceObjectDefAtLoc(centralherdID, 0, 0.50, 0.85);
			}				

	// SE Herds 
	int SEherdID = rmCreateObjectDef("team 1 herd");
		rmAddObjectDefItem(SEherdID, food1, 6, 3.0);
		rmSetObjectDefMinDistance(SEherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(SEherdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(SEherdID, true);
		rmAddObjectDefConstraint(SEherdID, avoidCliffMin);
		rmAddObjectDefConstraint(SEherdID, avoidTownCenterFar);
		rmAddObjectDefConstraint(SEherdID, avoidWaterMin);
		rmAddObjectDefConstraint(SEherdID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(SEherdID, avoidPondMin);
		rmAddObjectDefConstraint(SEherdID, avoidForestMin);
		rmAddObjectDefConstraint(SEherdID, avoidGoldMin);
		rmAddObjectDefConstraint(SEherdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(SEherdID, avoidNativesShort);
		rmAddObjectDefConstraint(SEherdID, avoidEdge);
		rmAddObjectDefConstraint(SEherdID, avoidHunt1Med);
		rmAddObjectDefConstraint(SEherdID, avoidHunt2Short);
		rmAddObjectDefConstraint(SEherdID, avoidMidLine);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmAddObjectDefConstraint(SEherdID, stayGoldZoneSE);
		if (rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(SEherdID, 0, 0.50, 0.50, 1+PlayerNum/2);	
		else
			rmPlaceObjectDefAtLoc(SEherdID, 0, 0.50, 0.50, 2+PlayerNum);	
				
	// NW Herds 
	int NWherdID = rmCreateObjectDef("team 2 herd");
		rmAddObjectDefItem(NWherdID, food1, 6, 3.0);
		rmSetObjectDefMinDistance(NWherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(NWherdID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(NWherdID, true);
		rmAddObjectDefConstraint(NWherdID, avoidCliffMin);
		rmAddObjectDefConstraint(NWherdID, avoidTownCenterFar);
		rmAddObjectDefConstraint(NWherdID, avoidWaterMin);
		rmAddObjectDefConstraint(NWherdID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(NWherdID, avoidPondMin);
		rmAddObjectDefConstraint(NWherdID, avoidForestMin);
		rmAddObjectDefConstraint(NWherdID, avoidGoldMin);
		rmAddObjectDefConstraint(NWherdID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(NWherdID, avoidNativesShort);
		rmAddObjectDefConstraint(NWherdID, avoidEdge);
		rmAddObjectDefConstraint(NWherdID, avoidHunt1Med);
		rmAddObjectDefConstraint(NWherdID, avoidHunt2Short);
		rmAddObjectDefConstraint(NWherdID, avoidMidLine);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmAddObjectDefConstraint(NWherdID, stayGoldZoneNW);
		if (rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(NWherdID, 0, 0.50, 0.50, 1+PlayerNum/2);	
		else
			rmPlaceObjectDefAtLoc(NWherdID, 0, 0.50, 0.50, 2+PlayerNum);	
		
	// ____________________ Treasures ____________________
	int Nugget4ID = rmCreateObjectDef("nugget lvl 4"); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0.005);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidCliff);
		rmAddObjectDefConstraint(Nugget4ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget4ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidHunt2Min); 
		rmAddObjectDefConstraint(Nugget4ID, avoidHunt1Min); 
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidWaterMin);  
		rmAddObjectDefConstraint(Nugget4ID, avoidPondMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldZoneNW); 
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldZoneSE); 
		if (PlayerNum > 4 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50, 1+PlayerNum/2);
	
	int Nugget3ID = rmCreateObjectDef("nugget lvl3a "); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0.0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.45));
		if (PlayerNum == 2)
			rmSetNuggetDifficulty(2,2);
		else
			rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidCliffMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget3ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt2Min); 
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt1Min); 
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidWaterMin);  
		rmAddObjectDefConstraint(Nugget3ID, avoidPondMin); 
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(Nugget3ID, avoidMidLine); 
			rmAddObjectDefConstraint(Nugget3ID, stayGoldZoneNW); 
			}
		else 
			rmAddObjectDefConstraint(Nugget3ID, stayMidSmIsland); 
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, 2+PlayerNum);
	
	int Nugget2ID = rmCreateObjectDef("nugget lvl3b "); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0.0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.45));
		if (PlayerNum == 2)
			rmSetNuggetDifficulty(2,2);
		else
			rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget2ID, avoidCliffMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min); 
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt1Min); 
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidWaterMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidPondMin); 
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(Nugget2ID, avoidMidLine); 
			rmAddObjectDefConstraint(Nugget2ID, stayGoldZoneSE); 
			}
		else 
			rmAddObjectDefConstraint(Nugget2ID, stayMidSmIsland); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, 2+PlayerNum);

	int Nugget22ID = rmCreateObjectDef("nugget lvl22 "); 
		rmAddObjectDefItem(Nugget22ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget22ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(Nugget22ID, rmXFractionToMeters(0.45));
		if (PlayerNum == 2)
			rmSetNuggetDifficulty(1,1);
		else
			rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget22ID, avoidCliffMin);
		rmAddObjectDefConstraint(Nugget22ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget22ID, stayMidSmIsland);
		rmAddObjectDefConstraint(Nugget22ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget22ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget22ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget22ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget22ID, avoidHunt2Min); 
		rmAddObjectDefConstraint(Nugget22ID, avoidHunt1Min); 
		rmAddObjectDefConstraint(Nugget22ID, avoidImpassableLandMin); 
		rmAddObjectDefConstraint(Nugget22ID, avoidWaterMin);  
		rmAddObjectDefConstraint(Nugget22ID, avoidPondMin); 
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(Nugget22ID, avoidGoldZoneSEMin); 
			rmAddObjectDefConstraint(Nugget22ID, avoidGoldZoneNWMin); 
			}
		rmAddObjectDefConstraint(Nugget22ID, avoidTradeRouteSocketMin); 
		rmAddObjectDefConstraint(Nugget22ID, avoidMidLine); 
		rmPlaceObjectDefAtLoc(Nugget22ID, 0, 0.50, 0.50, 2+PlayerNum);

	int Nugget1ID = rmCreateObjectDef("nugget lvl1 "); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidCliffMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidHunt2Min); 
		rmAddObjectDefConstraint(Nugget1ID, avoidHunt1Min); 
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidWaterMin);  
		rmAddObjectDefConstraint(Nugget1ID, avoidPondMin); 
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			rmAddObjectDefConstraint(Nugget1ID, avoidGoldZoneSEMin); 
			rmAddObjectDefConstraint(Nugget1ID, avoidGoldZoneNWMin); 
			}
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketMin); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50, 2*PlayerNum);
		
	// Text
	rmSetStatusText("",0.90);

	// Edge Trees
	int SETreeID = rmCreateObjectDef("SE tree");
		rmAddObjectDefItem(SETreeID, treeType1, 3, 4.0);
		rmAddObjectDefItem(SETreeID, treeType2, 1, 4.0);
		rmSetObjectDefMinDistance(SETreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(SETreeID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(SETreeID, classForest);
		rmAddObjectDefConstraint(SETreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(SETreeID, avoidCliffShort);
		rmAddObjectDefConstraint(SETreeID, avoidForestShorter);
		rmAddObjectDefConstraint(SETreeID, avoidHunt1Min);
		rmAddObjectDefConstraint(SETreeID, avoidHunt2Min);
		rmAddObjectDefConstraint(SETreeID, avoidTownCenterMin);
		rmAddObjectDefConstraint(SETreeID, avoidGoldMin);
		rmAddObjectDefConstraint(SETreeID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(SETreeID, avoidStartingResourcesMin);
		rmAddObjectDefConstraint(SETreeID, avoidNativesShort);
		rmAddObjectDefConstraint(SETreeID, stayGoldZoneSE);
		rmPlaceObjectDefAtLoc(SETreeID, 0, 0.50, 0.50, 4*PlayerNum);

	int NWTreeID = rmCreateObjectDef("NW tree");
		rmAddObjectDefItem(NWTreeID, treeType1, 3, 4.0);
		rmAddObjectDefItem(NWTreeID, treeType2, 1, 4.0);
		rmSetObjectDefMinDistance(NWTreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(NWTreeID,  rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(NWTreeID, classForest);
		rmAddObjectDefConstraint(NWTreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(NWTreeID, avoidCliffShort);
		rmAddObjectDefConstraint(NWTreeID, avoidForestShorter);
		rmAddObjectDefConstraint(NWTreeID, avoidHunt1Min);
		rmAddObjectDefConstraint(NWTreeID, avoidHunt2Min);
		rmAddObjectDefConstraint(NWTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(NWTreeID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(NWTreeID, avoidStartingResourcesMin);
		rmAddObjectDefConstraint(NWTreeID, avoidNativesShort);
		rmAddObjectDefConstraint(NWTreeID, stayGoldZoneNW);
		rmPlaceObjectDefAtLoc(NWTreeID, 0, 0.50, 0.50, 4*PlayerNum);

	// Text
	rmSetStatusText("",1.00);

} // END