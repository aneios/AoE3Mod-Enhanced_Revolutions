// TEXAS
// October 2003
// Nov 06 - YP update
// Main entry point for random map script
// edited by vividlyplain, October 2021

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01);

	// ____________________ General ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	int whichMap = rmRandInt(1,3);
	int whichNative = rmRandInt(1,2);
	int isItWet = rmRandInt(1,2);
	int spawnNat1 = -1;
	int spawnNat2 = -1;
	int spawnNat3 = -1;
	int spawnNat4 = -1;
	int centralPond = -1;

	if (rmGetIsTreaty() == true)
		isItWet = 1;

	// 1 - 4 nats, sometimes a central pond, scattered cliffs (1v1 or 2v2 only)
	// 2 - 3 nats inline, 2 mid cliffs, scattered ponds (1v1 or 2v2 only) - removed ponds
	// 3 - 3 nats across mid, 1 cliff on each team's side, scattered ponds - removed ponds
	// 4 - ffa has central pond with scattered cliffs and trade route rings around

//	isItWet = 1;		// for testing
//	whichMap = 2;		// for testing

	if (teamZeroCount != teamOneCount || TeamNum > 2)
		whichMap = 4;
	if (TeamNum == 2 && teamZeroCount == teamOneCount && PlayerNum > 4)
		whichMap = 3;
	if (rmGetIsTreaty() == true && PlayerNum <= 4 && teamZeroCount == teamOneCount)
		whichMap = 1;

		rmEchoInfo("whichMap = "+whichMap);
		rmEchoInfo("isItWet = "+isItWet);
		rmEchoInfo("whichNative = "+whichNative);
		if (rmGetIsKOTH() == true)
			rmEchoInfo("KOTH = true");
		else
			rmEchoInfo("KOTH = false");

	// Pond and Native Control
	if (rmGetIsKOTH() == true)
	{
		centralPond = -1;
		rmEchoInfo("no pond you fool, it's KOTH");
	}
	else
	{
		if (whichMap == 1 && isItWet == 1)
		{
			if (rmGetIsTreaty() == true && PlayerNum == 2)
			{
				centralPond = -1;
				rmEchoInfo("no pond, 1v1 player treaty");
			}
			else
			{
				centralPond = 1;
				rmEchoInfo("build the pond");
			}
		}
		else if (whichMap == 1)
		{
			centralPond = -1;
			rmEchoInfo("no pond, it is not wet");
		}
		else if (whichMap == 2)
		{
			if (isItWet == 1)
			{
				centralPond = 1;
				rmEchoInfo("build the pond");
			}
			else
			{
				centralPond = -1;
				rmEchoInfo("no pond, it is not wet");
			}
		}
		else if (whichMap == 3)
		{
			if (rmGetIsTreaty() == true)
			{
				if (PlayerNum == 6)
				{
					centralPond =-1;
					rmEchoInfo("no pond in 3v3 treaty");
				}
				else
				{
					centralPond =1;
					rmEchoInfo("nbuild the pond in 4v4 treaty");
				}
			}
			else if (isItWet == 1)
			{
				centralPond = 1;
				rmEchoInfo("build the pond");
			}
			else
			{
				centralPond =-1;
				rmEchoInfo("no pond, it is not wet");
			}
		}
		else	// weird
		{
			centralPond = 1;
			rmEchoInfo("always build the pond in weird spawns");
		}
	}

	// Controlling Native Sites
	if (whichMap == 1)
	{
		spawnNat1 = 1;
		spawnNat2 = 1;
		spawnNat3 = 1;
		spawnNat4 = 1;
	}
	if (whichMap == 2)
	{
		spawnNat1 = 1;
		spawnNat2 = 1;
		if (isItWet == 2 && rmGetIsKOTH() == false)
			spawnNat3 = 1;
		else
			spawnNat3 = -1;
		spawnNat4 = -1;
	}
	if (whichMap == 3)
	{
		spawnNat1 = 1;
		spawnNat2 = 1;
		if (isItWet == 2 && rmGetIsKOTH() == false)
			spawnNat3 = 1;
		else
			spawnNat3 = -1;
		spawnNat4 = -1;
	}
	if (rmGetIsTreaty() == true)
	{
		spawnNat1 = 1;
		spawnNat2 = 1;
		spawnNat3 = 1;
		spawnNat4 = 1;
	}
	if (whichMap == 4)
	{
		spawnNat1 = -1;
		spawnNat2 = -1;
		spawnNat3 = -1;
		spawnNat4 = -1;
	}

	// Strings
	string wetType = "texas pond rm";	
	string paintMix1 = "texas_grass";
	string paintMix2 = "texas_grass_Skrimish";
	string paintMix3 = "texas_dirt_Skirmish";
	string paintMix4 = "texas_dirt";
	string paintMix5 = "texas_cliff_top";
	string paintMix6 = "texas_forest";
	string mntType = "texas grass";	
	string cliffPaint = "texas\Cliff_gravel_tex";	
	string forTesting = "testmix";	 
	string treasureSet = "texas";
	string shineAlight = "Texas_Skirmish";
	string toiletPaper = "dirt";
	string food1 = "bison";
	string food2 = "deer";
	string food3 = "pronghorn";
	string cattleType = "cow";
	string treeType1 = "TreeTexas";
	string treeType2 = "TreeTexasDirt";
	string treeType3 = "TreeSonora";
	string brushType1 = "UnderbrushTexas";
	string brushType2 = "UnderbrushTexasGrass";
	string natType1 = "";
	string natType2 = "";
	string natGrpName1 = "";
	string natGrpName2 = "";
	if (whichNative == 1)
	{
		natType1 = "Comanche";
		natType2 = "Apache";
		natGrpName1 = "native comanche village ";
		natGrpName2 = "native apache village ";
	}
	else
	{
		natType2 = "Comanche";
		natType1 = "Apache";
		natGrpName2 = "native comanche village ";
		natGrpName1 = "native apache village ";
	}

	// Picks the map size
	int size = 0;
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
	{
		if (rmGetIsTreaty() == true)
			size=40*PlayerNum+260; 
		else
			size=40*PlayerNum+200; 
	}
	if (TeamNum > 2 || teamZeroCount != teamOneCount)
			size=75*PlayerNum+250;
	rmSetMapSize(size, size);

	// Elevation
	rmSetMapElevationParameters(cElevTurbulence,  0.15, 2.0, 0.50, 2.0); // type, frequency, octaves, persistence, variation 
	rmSetMapElevationHeightBlend(1);
	
	// Make the corners
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(-2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
//	rmSetBaseTerrainMix(paintMix2);
	rmSetSeaType(wetType);
	rmTerrainInitialize("grass", 0.0);
	rmSetMapType(treasureSet); 
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetLightingSet(shineAlight);

	// Choose Mercs
	chooseMercs();

	// Make it windy
	rmSetWindMagnitude(2.0);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPatch4 = rmDefineClass("patch4");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classGold = rmDefineClass("Gold");
	int classGold2 = rmDefineClass("Gold2");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland=rmDefineClass("island");
	int classCliff = rmDefineClass("Cliffs");
	int classNative = rmDefineClass("natives");
	int classProp = rmDefineClass("prop");
	int classPond=rmDefineClass("pond");
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
	int avoidEmbellishmentMin = rmCreateClassDistanceConstraint("prop avoid prop min", rmClassID("prop"), 4.0);
	int avoidEmbellishment = rmCreateClassDistanceConstraint("prop avoid prop", rmClassID("prop"), 8.0);
	int avoidEmbellishmentFar = rmCreateClassDistanceConstraint("prop avoid prop far", rmClassID("prop"), 16.0);
	int avoidPondMin=rmCreateClassDistanceConstraint("avoid pond min", classPond, 4.0);
	int avoidPond=rmCreateClassDistanceConstraint("avoid pond", classPond, 40.0);
	float pondAvoid = 0.00;
	if (whichMap == 4)
		pondAvoid = 150;
	else
		pondAvoid = 100;

	int avoidPondFar=rmCreateClassDistanceConstraint("avoid pond far", classPond, pondAvoid);
	int avoidPondShort=rmCreateClassDistanceConstraint("avoid pond short", classPond, 12.0);

	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.46), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.15), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 30.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 20.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 34.0);
	int avoidForestVeryFar=rmCreateClassDistanceConstraint("avoid forest very far", rmClassID("Forest"), 50.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 16.0);
	int avoidForestShorter=rmCreateClassDistanceConstraint("avoid forest shorter", rmClassID("Forest"), 8.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 18.0);
	int avoidHunt3Far = rmCreateTypeDistanceConstraint("avoid hunt3 far", food3, 50.0);
	int avoidHunt3VeryFar = rmCreateTypeDistanceConstraint("avoid hunt3 very far", food3, 60.0);
	int avoidHunt3 = rmCreateTypeDistanceConstraint("avoid hunt3", food3, 36.0);
	int avoidHunt3Med = rmCreateTypeDistanceConstraint("avoid hunt3 med", food3, 30.0);
	int avoidHunt3Short = rmCreateTypeDistanceConstraint("avoid hunt3 short", food3, 20.0);
	int avoidHunt3Min = rmCreateTypeDistanceConstraint("avoid hunt3 min", food3, 10.0);	
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 50.0);
	int avoidHunt2VeryFar = rmCreateTypeDistanceConstraint("avoid hunt2 very far", food2, 60.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 36.0);
	int avoidHunt2Med = rmCreateTypeDistanceConstraint("avoid hunt2 med", food2, 30.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 20.0);
	int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt2 min", food2, 10.0);	
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 50.0);
	int avoidHunt1VeryFar = rmCreateTypeDistanceConstraint("avoid hunt1 very far", food1, 60.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 50.0);
	int avoidHunt1Med = rmCreateTypeDistanceConstraint("avoid hunt1 med", food1, 30.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 20.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 30.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 40.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 12.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 4.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 8.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 40.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 60.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 100.0);
	int avoidGold2Min=rmCreateClassDistanceConstraint("min distance vs gold2", rmClassID("Gold2"), 4.0);
	int avoidGold2Short = rmCreateClassDistanceConstraint ("gold avoid gold2 short", rmClassID("Gold2"), 8.0);
	int avoidGold2 = rmCreateClassDistanceConstraint ("gold avoid gold2 med", rmClassID("Gold2"), 40.0);
	int avoidGold2Far = rmCreateClassDistanceConstraint ("gold avoid gold2 far", rmClassID("Gold2"), 60.0);
	int avoidGold2VeryFar = rmCreateClassDistanceConstraint ("gold avoid gold2 very far", rmClassID("Gold2"), 100.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 30.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	int avoidNomad = rmCreateTypeDistanceConstraint("avoid covered wagon", "CoveredWagon", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 75.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 60.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
	int avoidCliffMin = rmCreateClassDistanceConstraint("avoid cliff min", rmClassID("Cliffs"), 4.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 8.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 12.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 16.0);
	int avoidCliffVeryFar = rmCreateClassDistanceConstraint("avoid cliff very far", rmClassID("Cliffs"), 50+5*PlayerNum);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
	int stayNatives = rmCreateClassDistanceConstraint("stuff stays near natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 12.0);
	int avoidCattle = rmCreateTypeDistanceConstraint("cow avoid cow", cattleType, 58+PlayerNum);
	int avoidCattleMed = rmCreateTypeDistanceConstraint("cow avoid cow med", cattleType, 50+PlayerNum);
	int avoidCattleMin = rmCreateTypeDistanceConstraint("cow avoid cow min", cattleType, 4);
	int avoidBerries=rmCreateTypeDistanceConstraint("avoid berries", "berrybush", 50.0);
	int avoidBerriesVeryFar=rmCreateTypeDistanceConstraint("avoid berries very far", "berrybush", 80.0);
	int avoidBerriesFar=rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 66.0);
	int avoidBerriesShort=rmCreateTypeDistanceConstraint("avoid berries short", "berrybush", 8.0);
	int avoidBerriesMin=rmCreateTypeDistanceConstraint("avoid berries min", "berrybush", 4.0);
	
	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 2.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 4.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 15.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 40.0);
	int avoidPatchMin = rmCreateClassDistanceConstraint("avoid patch min", rmClassID("patch"), 4.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int stayIsland=rmCreateClassDistanceConstraint("stay island", classIsland, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 4.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 8.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 30.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 24.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	
	// VP avoidance
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 16.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
	
	// ____________________ Player Placement ____________________
	if (whichMap == 4)
	{
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.36+0.005*PlayerNum, 0.36+0.005*PlayerNum, 0.02);
	}
	else 
	{
		if (PlayerNum == 2)
		{
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.175, 0.1755); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.34, 0.34, 0);

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.675, 0.6755); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.34, 0.34, 0);
		}
		else if (PlayerNum == 4)
		{
			rmSetPlacementTeam(0);
			if (rmGetIsTreaty() == true)
				rmSetPlacementSection(0.17, 0.33); 
			else
				rmSetPlacementSection(0.175, 0.325); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.35, 0.35, 0);

			rmSetPlacementTeam(1);
			if (rmGetIsTreaty() == true)
				rmSetPlacementSection(0.67, 0.83); 
			else
				rmSetPlacementSection(0.675, 0.825); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.35, 0.35, 0);
		}
		else if (PlayerNum == 6)
		{
			rmSetPlacementTeam(0);
			if (rmGetIsTreaty() == true)
				rmSetPlacementSection(0.64, 0.86); 
			else
				rmSetPlacementSection(0.675, 0.825); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.36, 0.36, 0);

			rmSetPlacementTeam(1);
			if (rmGetIsTreaty() == true)
				rmSetPlacementSection(0.14, 0.36); 
			else
				rmSetPlacementSection(0.175, 0.325); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.36, 0.36, 0);
		}
		else 
		{
			rmSetPlacementTeam(0);
			if (rmGetIsTreaty() == true)
			{
				rmSetPlacementSection(0.12, 0.38); 
				rmPlacePlayersCircular(0.37, 0.37, 0);
			}
			else 
			{
				rmSetPlacementSection(0.15, 0.35); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.36, 0.36, 0);
			}
			rmSetTeamSpacingModifier(0.50);

			rmSetPlacementTeam(1);
			if (rmGetIsTreaty() == true) 
			{
				rmSetPlacementSection(0.62, 0.88); 
				rmPlacePlayersCircular(0.37, 0.37, 0);
			}
			else 
			{
				rmSetPlacementSection(0.65, 0.85); 
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.36, 0.36, 0);
			}
			rmSetTeamSpacingModifier(0.50);
		}
	}
	
	// ____________________ Map Parameters ____________________
	// Place Trade Routes
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	if (rmGetIsTreaty() == true && whichMap != 4)
	{
		rmSetObjectDefMinDistance(socketID, 0.0);
		rmSetObjectDefMaxDistance(socketID, 0.0);    
	}
	else
	{
		rmSetObjectDefMinDistance(socketID, 2.0);
		rmSetObjectDefMaxDistance(socketID, 8.0);    
	}

	int tradeRouteID = rmCreateTradeRoute();
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	if (whichMap == 4) 
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.70);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.65);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.35);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.30);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.35);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
	}
	else 
	{
		if (rmGetIsTreaty() == false) 
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.90);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.70);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.30);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.10);
		}
		else 
		{
			rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.99);
			rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.01);
		}
	}
	rmBuildTradeRoute(tradeRouteID, toiletPaper);

	if (whichMap < 4) 
	{
		int socketID1=rmCreateObjectDef("sockets to dock Trade Posts2");
		rmAddObjectDefItem(socketID1, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID1, true);
		if (rmGetIsTreaty() == true && whichMap != 4)
		{
			rmSetObjectDefMinDistance(socketID1, 0.0);
			rmSetObjectDefMaxDistance(socketID1, 0.0);    
		}
		else
		{
			rmSetObjectDefMinDistance(socketID1, 2.0);
			rmSetObjectDefMaxDistance(socketID1, 8.0);    
		}
		int tradeRouteID1 = rmCreateTradeRoute();
		rmSetObjectDefTradeRouteID(socketID1, tradeRouteID1);
		if (rmGetIsTreaty() == false) 
		{
			rmAddTradeRouteWaypoint(tradeRouteID1, 0.20, 0.10);
			rmAddTradeRouteWaypoint(tradeRouteID1, 0.35, 0.30);
			rmAddTradeRouteWaypoint(tradeRouteID1, 0.35, 0.70);
			rmAddTradeRouteWaypoint(tradeRouteID1, 0.20, 0.90);
		}
		else 
		{
			rmAddTradeRouteWaypoint(tradeRouteID1, 0.40, 0.01);
			rmAddTradeRouteWaypoint(tradeRouteID1, 0.40, 0.99);
		}
		rmBuildTradeRoute(tradeRouteID1, toiletPaper);
	}

	// Continent
	int continentID = rmCreateArea("continent");
	rmSetAreaLocation(continentID, 0.5, 0.5);
	rmSetAreaWarnFailure(continentID, false);
	rmSetAreaSize(continentID,0.99);
	rmSetAreaCoherence(continentID, 1.0);
	rmSetAreaBaseHeight(continentID, 1.0);
	rmSetAreaSmoothDistance(continentID, 10);
	rmSetAreaHeightBlend(continentID, 1);
	rmSetAreaObeyWorldCircleConstraint(continentID, false);
	rmSetAreaMix(continentID, paintMix2); 
	rmBuildArea(continentID); 

	// Text
	rmSetStatusText("",0.10);

	// Mid Plain
	int paintMidID=rmCreateArea("Mid Paint");
	rmSetAreaSize(paintMidID, 0.222);
	rmSetAreaLocation(paintMidID, 0.5, 0.0);
	rmAddAreaInfluenceSegment(paintMidID, 0.5, 0.0, 0.5, 0.55);
 	rmSetAreaMix(paintMidID, paintMix1);
	rmSetAreaCoherence(paintMidID, 0.777);
	rmAddAreaConstraint(paintMidID, avoidTradeRouteMin);
	rmBuildArea(paintMidID); 
	
	int avoidMidPlain = rmCreateAreaDistanceConstraint("avoid mid plain ", paintMidID, 4.0);
	int avoidMidPlainMin = rmCreateAreaDistanceConstraint("avoid mid plain min", paintMidID, 0.5);
	int avoidMidPlainFar = rmCreateAreaDistanceConstraint("avoid mid plain far", paintMidID, 8.0);
	int stayMidPlain = rmCreateAreaMaxDistanceConstraint("stay mid plain ", paintMidID, 0.0);

	// NW Desert
	int paintNWID=rmCreateArea("NW Paints");
	rmSetAreaSize(paintNWID, 0.175);
	rmSetAreaLocation(paintNWID, 0.5, 0.9);
 	rmSetAreaMix(paintNWID, paintMix3);
	rmSetAreaCoherence(paintNWID, 0.444);
//	rmAddAreaConstraint(paintNWID, avoidTradeRouteMin);
	rmAddAreaConstraint(paintNWID, avoidMidPlainMin);
	rmBuildArea(paintNWID); 
	
	int avoidNWDesert = rmCreateAreaDistanceConstraint("avoid NW desert ", paintNWID, 4.0);
	int avoidNWDesertMin = rmCreateAreaDistanceConstraint("avoid NW desert min", paintNWID, 0.5);
	int avoidNWDesertFar = rmCreateAreaDistanceConstraint("avoid NW desert far", paintNWID, 8.0);
	int stayNWDesert = rmCreateAreaMaxDistanceConstraint("stay NW desert ", paintNWID, 0.0);

	// Player areas
	for (i=1; < numPlayer)
	{
		int playerAreaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerAreaID);
		rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(111));
		rmSetAreaCoherence(playerAreaID, 0.00);
		rmSetAreaWarnFailure(playerAreaID, false);
		rmSetAreaMix(playerAreaID, paintMix5);	
		rmSetAreaLocPlayer(playerAreaID, i);
		rmSetAreaObeyWorldCircleConstraint(playerAreaID, false);
		rmAddAreaToClass(playerAreaID, classIsland);
		rmBuildArea(playerAreaID);
	}
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Natives ____________________
	float natLocAx = 0.00;
	float natLocAy = 0.00;
	float natLocBx = 0.00;
	float natLocBy = 0.00;
	float natLocCx = 0.00;
	float natLocCy = 0.00;
	float natLocDx = 0.50;
	float natLocDy = 0.15;

	if (rmGetIsTreaty() == true)
	{
		if (PlayerNum == 6)
		{
			natLocAx = 0.20;
			natLocAy = 0.40;
			natLocBx = 0.80;
			natLocBy = 0.40;
		}
		else if (PlayerNum == 8)
		{
			natLocAx = 0.20;
			natLocAy = 0.30;
			natLocBx = 0.80;
			natLocBy = 0.30;
		}
		else
		{
			natLocAx = 0.15;
			natLocAy = 0.53;
			natLocBx = 0.85;
			natLocBy = 0.47;
		}
		if (PlayerNum == 2) 
		{
			natLocCx = 0.325;
			natLocCy = 0.10;
			natLocDx = 0.666;
			natLocDy = 0.90;
		}
		else 
		{
			natLocCx = 0.30;
			natLocCy = 0.10;
			natLocDx = 0.70;
			natLocDy = 0.10;
		}
	}
	else if (whichMap == 1) 
	{
		natLocAx = 0.15;
		natLocAy = 0.50;
		natLocBx = 0.85;
		natLocBy = 0.50;
		natLocCx = 0.50;
		natLocCy = 0.85;
	}
	else if (whichMap == 2) 
	{
		natLocAx = 0.15;
		natLocAy = 0.50;
		natLocBx = 0.85;
		natLocBy = 0.50;
		natLocCx = 0.50;
		natLocCy = 0.50;
	}
	else if (whichMap == 3) 
	{
		if (rmGetIsTreaty() == false) 
		{
			natLocAx = 0.50;
			natLocAy = 0.15;
			natLocBx = 0.50;
			natLocBy = 0.85;
			natLocCx = 0.50;
			natLocCy = 0.50;
		}
		else 
		{
			natLocAx = 0.34;
			natLocAy = 0.10;
			natLocBx = 0.66;
			natLocBy = 0.10;
			natLocCx = 0.25;
			natLocCy = 0.40;
			natLocDx = 0.75;
			natLocDy = 0.40;
		}
	}
	else
	{
		// player natives for weird spawns
	}

	// Set up Natives
	int subCiv0 = rmGetCivID(natType1);
	int subCiv1 = rmGetCivID(natType2);
	rmSetSubCiv(0, natType1);
	rmSetSubCiv(1, natType2);

	int nativeID0 = -1;
    int nativeID1 = -1;
    int nativeID2 = -1;
    int nativeID3 = -1;
	
	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);
	int whichVillage4 = rmRandInt(1,5);
	
	if (rmGetIsTreaty() == true) 
	{
		whichVillage1 = 2;
		whichVillage2 = 3;
		whichVillage3 = 3;
		whichVillage4 = 1;
	}

	rmEchoInfo("whichVillage1 = "+whichVillage1);
	rmEchoInfo("whichVillage2 = "+whichVillage2);
	rmEchoInfo("whichVillage3 = "+whichVillage3);
	rmEchoInfo("whichVillage4 = "+whichVillage4);

	nativeID0 = rmCreateGrouping("native A", natGrpName2+whichVillage1);
	nativeID1 = rmCreateGrouping("native B", natGrpName2+whichVillage2);
	nativeID2 = rmCreateGrouping("native C", natGrpName1+whichVillage3);
	nativeID3 = rmCreateGrouping("native D", natGrpName1+whichVillage4);

	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));

	if (spawnNat1 == 1)
		rmPlaceGroupingAtLoc(nativeID0, 0, natLocAx, natLocAy);
	if (spawnNat2 == 1)
		rmPlaceGroupingAtLoc(nativeID1, 0, natLocBx, natLocBy);
	if (spawnNat3 == 1)
		rmPlaceGroupingAtLoc(nativeID2, 0, natLocCx, natLocCy);
	if (spawnNat4 == 1)
		rmPlaceGroupingAtLoc(nativeID3, 0, natLocDx, natLocDy);
	
	// Native Islands
	int natIsland1ID = rmCreateArea("nat isle 1");
	rmSetAreaSize(natIsland1ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland1ID, natLocAx, natLocAy);
	rmSetAreaWarnFailure(natIsland1ID, false);
	rmSetAreaMix(natIsland1ID, paintMix5);
	rmSetAreaCoherence(natIsland1ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland1ID, false);
	if (spawnNat1 == 1)
		rmBuildArea(natIsland1ID);	
	
	int natIsland2ID = rmCreateArea("nat isle 2");
	rmSetAreaSize(natIsland2ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland2ID, natLocBx, natLocBy);
	rmSetAreaWarnFailure(natIsland2ID, false);
	rmSetAreaMix(natIsland2ID, paintMix5);
	rmSetAreaCoherence(natIsland2ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland2ID, false);
	if (spawnNat2 == 1)
		rmBuildArea(natIsland2ID);	

	int natIsland3ID = rmCreateArea("nat isle 3");
	rmSetAreaSize(natIsland3ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland3ID, natLocCx, natLocCy);
	rmSetAreaWarnFailure(natIsland3ID, false);
	rmSetAreaMix(natIsland3ID, paintMix5);
	rmSetAreaCoherence(natIsland3ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland3ID, false);
	if (spawnNat3 == 1)
		rmBuildArea(natIsland3ID);	
	
	int natIsland4ID = rmCreateArea("nat isle 4");
	rmSetAreaSize(natIsland4ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland4ID, natLocDx, natLocDy);
	rmSetAreaWarnFailure(natIsland4ID, false);
	rmSetAreaMix(natIsland4ID, paintMix2);
	rmSetAreaCoherence(natIsland4ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland4ID, false);
	if (spawnNat4 == 1)
		rmBuildArea(natIsland4ID);	

	// Text
	rmSetStatusText("",0.30);

	// Avoidance Islands
	int midBigIslandID=rmCreateArea("Big Mid Island");
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmSetAreaSize(midBigIslandID, 0.50);
	else
		rmSetAreaSize(midBigIslandID, 0.55);
	rmSetAreaLocation(midBigIslandID, 0.5, 0.5);
//	rmSetAreaMix(midBigIslandID, "mongolia_grass"); 	// for testing
	rmSetAreaCoherence(midBigIslandID, 1.00);
	rmBuildArea(midBigIslandID); 

	int avoidBigMidIsland = rmCreateAreaDistanceConstraint("avoid big mid island ", midBigIslandID, 8.0);
	int avoidBigMidIslandMin = rmCreateAreaDistanceConstraint("avoid big mid island min", midBigIslandID, 0.5);
	int avoidBigMidIslandFar = rmCreateAreaDistanceConstraint("avoid big mid island far", midBigIslandID, 17+PlayerNum);
	int stayBigMidIsland = rmCreateAreaMaxDistanceConstraint("stay big mid island ", midBigIslandID, 0.0);

	int midIslandID=rmCreateArea("Mid Island");
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmSetAreaSize(midIslandID, 0.30+0.01*PlayerNum);
	else
		rmSetAreaSize(midIslandID, 0.30+0.02*PlayerNum);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
//	rmSetAreaMix(midIslandID, forTesting); 
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 

	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.18+0.01*PlayerNum);
	rmSetAreaLocation(midSmIslandID, 0.5, 0.5);
// 	rmSetAreaMix(midSmIslandID, "mongolia_grass"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 1.00);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 4.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 8.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	// Mid Gold Zone
	int goldZoneID=rmCreateArea("gold zone");
	rmSetAreaSize(goldZoneID, 0.333);
	rmSetAreaLocation(goldZoneID, 0.5, 0.5);
	rmAddAreaInfluenceSegment(goldZoneID, 0.5, 0.0, 0.5, 1.0);
// 	rmSetAreaMix(goldZoneID, forTesting);
	rmSetAreaCoherence(goldZoneID, 1.00);
	rmAddAreaConstraint(goldZoneID, avoidTradeRoute);
	rmBuildArea(goldZoneID); 
	
	int avoidGoldZone = rmCreateAreaDistanceConstraint("avoid mid gold zone ", goldZoneID, 4.0);
	int avoidGoldZoneMin = rmCreateAreaDistanceConstraint("avoid mid gold zone min", goldZoneID, 0.5);
	int avoidGoldZoneFar = rmCreateAreaDistanceConstraint("avoid mid gold zone far", goldZoneID, 8.0);
	int stayGoldZone = rmCreateAreaMaxDistanceConstraint("stay mid gold zone ", goldZoneID, 0.0);

	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.43), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int treesNearEdge = rmCreatePieConstraint("trees stay near edge",0.5,0.5,rmXFractionToMeters(0.48+0.00033*PlayerNum), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(360));

	// Place TR Sockets
	float TPLoc = 0;
	float TPLoc2 = 0;
	if (whichMap == 4)
		TPLoc = 0.125;
	else
		TPLoc = 0.30;
	if (PlayerNum < 5)
		TPLoc2 = 0.60;
	else
		TPLoc2 = 0.70;

	vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, TPLoc);
	if (rmGetIsTreaty() == true && whichMap != 4)
		rmPlaceObjectDefAtLoc(socketID, 0, 0.69, 0.70);
	else
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

	if (whichMap == 4) {
		if (PlayerNum > 4) {			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.375);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		if (PlayerNum > 4) {			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.625);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		if (PlayerNum > 4) {			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.875);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		if (PlayerNum > 4) {			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 1.00);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}
		}
	else {
		if (PlayerNum > 4) {			
			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			if (rmGetIsTreaty() == true)
				rmPlaceObjectDefAtLoc(socketID, 0, 0.72+0.0075*PlayerNum, 0.50);
			else
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

		socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.70);
		if (rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(socketID, 0, 0.69, 0.30);
		else
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);	
	}

	if (whichMap < 4) {
		vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID1, TPLoc);
		if (rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(socketID1, 0, 0.31, 0.30);
		else
			rmPlaceObjectDefAtPoint(socketID1, 0, socketLoc2);

			if (PlayerNum > 4) {			
				socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID1, 0.50);
				if (rmGetIsTreaty() == true)
					rmPlaceObjectDefAtLoc(socketID1, 0, 0.28-0.0075*PlayerNum, 0.50);
				else
					rmPlaceObjectDefAtPoint(socketID1, 0, socketLoc2);
				}

			socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID1, 0.70);
			if (rmGetIsTreaty() == true)
				rmPlaceObjectDefAtLoc(socketID1, 0, 0.31, 0.70);
			else
				rmPlaceObjectDefAtPoint(socketID1, 0, socketLoc2);	
		}

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) 
	{
		int kingsIslandID=rmCreateArea("king isle");
		rmSetAreaSize(kingsIslandID, rmAreaTilesToFraction(333));
		rmSetAreaLocation(kingsIslandID, 0.50, 0.50);
		rmAddAreaToClass(kingsIslandID, classIsland);
//		rmSetAreaMix(kingsIslandID, "mongolia_grass"); 	// for testing
		rmSetAreaCoherence(kingsIslandID, 1.00);
		rmBuildArea(kingsIslandID); 

			// Place King's Hill
			float xLoc = 0.50;
			float yLoc = 0.50;
			float walk = 0.0;

			ypKingsHillLandfill(xLoc, yLoc, rmAreaTilesToFraction(333), 1.0, paintMix2, 0);
			ypKingsHillPlacer(xLoc, yLoc, walk, 0);
	}

	int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 8.0);

	// Text
	rmSetStatusText("",0.40);
	
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

	// Player Native 
	int playerNativeID = -1;
	if (whichNative == 1)
		playerNativeID = rmCreateGrouping("player native", natGrpName1+whichVillage2);
	else
		playerNativeID = rmCreateGrouping("player native", natGrpName2+whichVillage3);
	rmAddGroupingToClass(playerNativeID, classNative);
	rmAddGroupingToClass(playerNativeID, classStartingResource);
	rmSetGroupingMinDistance(playerNativeID, 30);
	rmSetGroupingMaxDistance(playerNativeID, 30);
	rmAddGroupingConstraint(playerNativeID, stayMidIsland);
	rmAddGroupingConstraint(playerNativeID, avoidStartingResources);
	rmAddGroupingConstraint(playerNativeID, avoidTradeRoute);

	// Starting mines
	int playerGoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerGoldID, "MineCopper", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 16.0);
	rmSetObjectDefMaxDistance(playerGoldID, 16.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidNatives);
	rmAddObjectDefConstraint(playerGoldID, avoidPondMin);
	rmAddObjectDefConstraint(playerGoldID, avoidCliffMin);
	if (rmGetIsTreaty() == false)
		rmAddObjectDefConstraint(playerGoldID, stayMidIsland);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "MineCopper", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 33.0);
	rmSetObjectDefMaxDistance(playerGold2ID, 33.0);
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResourcesShort);
//	rmAddObjectDefConstraint(playerGold2ID, stayBigMidIsland);
	rmAddObjectDefConstraint(playerGold2ID, avoidCliffMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidPondMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playerGold2ID, avoidNatives);
	rmAddObjectDefConstraint(playerGold2ID, avoidMidIsland);

	int playerGold3ID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(playerGold3ID, "MineCopper", 1, 0);
	rmSetObjectDefMinDistance(playerGold3ID, 46.0);
	rmSetObjectDefMaxDistance(playerGold3ID, 50+PlayerNum/2);
	rmAddObjectDefToClass(playerGold3ID, classStartingResource);
	rmAddObjectDefToClass(playerGold3ID, classGold);
	rmAddObjectDefConstraint(playerGold3ID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(playerGold3ID, avoidCliffMin);
	rmAddObjectDefConstraint(playerGold3ID, avoidPondMin);
	rmAddObjectDefConstraint(playerGold3ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGold3ID, avoidNatives);
	rmAddObjectDefConstraint(playerGold3ID, avoidTradeRouteMin);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(playerGold3ID, avoidBigMidIslandMin);
	else
		rmAddObjectDefConstraint(playerGold3ID, avoidMidIslandMin);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType1, 1, 0.0);
    rmSetObjectDefMinDistance(playerTreeID, 15);
    rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTreeID, avoidCliffMin);
	rmAddObjectDefConstraint(playerTreeID, avoidPondMin);
	rmAddObjectDefConstraint(playerTreeID, avoidNatives);

	int playerTree2ID = rmCreateObjectDef("player back trees");
	rmAddObjectDefItem(playerTree2ID, treeType1, 8, 8.0);
	rmAddObjectDefItem(playerTree2ID, treeType3, 2, 6.0);
    rmSetObjectDefMinDistance(playerTree2ID, 45);
    rmSetObjectDefMaxDistance(playerTree2ID, 50+PlayerNum);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShorter);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree2ID, avoidGoldShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidBigMidIsland);
	rmAddObjectDefConstraint(playerTree2ID, avoidNatives);
	rmAddObjectDefConstraint(playerTree2ID, avoidCliffMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidPondMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidIslandMin);
	if (teamZeroCount != teamOneCount || TeamNum > 2)
		rmAddObjectDefConstraint(playerTree2ID, stayNearEdge);

	// Starting berries
	int playerBerriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerBerriesID, "berrybush", 3, 4.0);
	rmSetObjectDefMinDistance(playerBerriesID, 12.0);
	rmSetObjectDefMaxDistance(playerBerriesID, 14.0);
	rmAddObjectDefToClass(playerBerriesID, classStartingResource);
	rmAddObjectDefConstraint(playerBerriesID, avoidStartingResourcesShort);

	// Starting cow
	int playerCowID = rmCreateObjectDef("player cow");
	rmAddObjectDefItem(playerCowID, cattleType, 2, 4.0);
	rmSetObjectDefMinDistance(playerCowID, 10.0);
	rmSetObjectDefMaxDistance(playerCowID, 16.0);
	rmAddObjectDefToClass(playerCowID, classStartingResource);
	rmAddObjectDefConstraint(playerCowID, avoidStartingResourcesShort);

	// Starting herds
	int playerHerdID = rmCreateObjectDef("starting herd");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerHerdID, food1, 12, 4.0);
	else
		rmAddObjectDefItem(playerHerdID, food1, 6, 4.0);
	rmSetObjectDefMinDistance(playerHerdID, 12);
	rmSetObjectDefMaxDistance(playerHerdID, 12);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);		
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerdID, avoidWaterShort);
	rmAddObjectDefConstraint(playerHerdID, avoidNatives);
		
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerHerd2ID, food3, 12, 5.0);
	else
		rmAddObjectDefItem(playerHerd2ID, food3, 8, 4.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 34);
    rmSetObjectDefMaxDistance(playerHerd2ID, 36);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidEdge);
	rmAddObjectDefConstraint(playerHerd2ID, avoidPondMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerHerd2ID, avoidHunt1Short);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIsland);

	int playerHerd3ID = rmCreateObjectDef("player 3rd herd");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(playerHerd3ID, food2, 14, 7.0);
	else
		rmAddObjectDefItem(playerHerd3ID, food2, 10, 6.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 40);
    rmSetObjectDefMaxDistance(playerHerd3ID, 44+PlayerNum/2);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidEdge);
	rmAddObjectDefConstraint(playerHerd3ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNatives);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResourcesShort);
	if (whichMap == 4)
	{
		rmAddObjectDefConstraint(playerHerd3ID, stayNearEdge);
		rmAddObjectDefConstraint(playerHerd3ID, avoidBigMidIsland);
		rmAddObjectDefConstraint(playerHerd3ID, avoidHunt1);
	}
	else 
		rmAddObjectDefConstraint(playerHerd3ID, stayMidSmIsland);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 24.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	rmAddObjectDefConstraint(playerNuggetID, avoidWaterShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	if (teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidIsland);
	int nugget0count = rmRandInt (1,2);
	
	//  Place Starting Objects/Resources
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (whichMap == 4)
			rmPlaceGroupingAtLoc(playerNativeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (whichMap == 4)
			rmPlaceObjectDefAtLoc(playerGold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (rmGetIsTreaty() == false) {
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(playerBerriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerCowID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		{
			if (rmGetIsTreaty() == false)
				rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			else
				rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i,1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		}
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}

	// moar wud, moar ppaarrttyy
	int rimTrees=rmCreateObjectDef("rim trees");
	rmAddObjectDefItem(rimTrees, treeType1, 2, 2.0);
	rmAddObjectDefItem(rimTrees, treeType2, 2, 2.0);
	rmAddObjectDefToClass(rimTrees, classForest); 
	rmSetObjectDefMinDistance(rimTrees, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(rimTrees, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rimTrees, avoidNatives);
	rmAddObjectDefConstraint(rimTrees, avoidGoldZoneFar);
	rmAddObjectDefConstraint(rimTrees, avoidCliff);
	rmAddObjectDefConstraint(rimTrees, avoidTradeRouteFar);
	rmAddObjectDefConstraint(rimTrees, avoidStartingResources);
	rmAddObjectDefConstraint(rimTrees, avoidBigMidIslandFar);
	rmAddObjectDefConstraint(rimTrees, treesNearEdge);
	if (rmGetIsTreaty() == true)
		rmPlaceObjectDefAtLoc(rimTrees, 0, 0.5, 0.5, 300+50*PlayerNum);

	// Text
	rmSetStatusText("",0.50);

	// ____________________ Common Resources ____________________
	// central pond
	int centralPondID=rmCreateArea("central pond");
	if (whichMap == 4)
		rmSetAreaSize(centralPondID, 0.0269);
	else
		rmSetAreaSize(centralPondID, rmAreaTilesToFraction(400+PlayerNum*64));
	rmSetAreaLocation(centralPondID, 0.50, 0.50);
	rmSetAreaWaterType(centralPondID, wetType);
	rmSetAreaWarnFailure(centralPondID, false);
	rmAddAreaToClass(centralPondID, classPond);
	rmSetAreaCoherence(centralPondID, 0.333);
	rmSetAreaObeyWorldCircleConstraint(centralPondID, false);
	rmAddAreaConstraint(centralPondID, avoidGoldShort);
	rmAddAreaConstraint(centralPondID, avoidGold2Short);
	rmAddAreaConstraint(centralPondID, avoidNomad);
//	rmAddAreaConstraint(centralPondID, stayGoldZone);
	rmAddAreaConstraint(centralPondID, avoidStartingResources);
	rmAddAreaConstraint(centralPondID, avoidIslandFar);
	rmAddAreaConstraint(centralPondID, avoidPondFar);
	rmAddAreaConstraint(centralPondID, avoidNatives);
	rmAddAreaConstraint(centralPondID, avoidTradeRouteSocket);
	if (rmGetIsTreaty() == true)
		rmAddAreaConstraint(centralPondID, avoidTradeRouteMin);
	else
		rmAddAreaConstraint(centralPondID, avoidTradeRouteShort);
	rmAddAreaConstraint(centralPondID, avoidEdge);
	if (centralPond == 1)
		rmBuildArea(centralPondID);

	// static team mines
	int minesID = rmCreateObjectDef("silver mines static");
	rmAddObjectDefItem(minesID, "mine", 1, 0.0);
	rmSetObjectDefMinDistance(minesID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(minesID, rmXFractionToMeters(0.025));
	rmAddObjectDefToClass(minesID, classGold);
	rmAddObjectDefConstraint(minesID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(minesID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(minesID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(minesID, avoidPondShort);
	if (whichMap < 4 && PlayerNum > 2)
	{
		rmPlaceObjectDefAtLoc(minesID, 0, 0.25, 0.50);
		rmPlaceObjectDefAtLoc(minesID, 0, 0.75, 0.50);
	}

	// Mid Mines
	if (PlayerNum > 2) 
	{
		int midSilverID = rmCreateObjectDef("mid silver");
		rmAddObjectDefItem(midSilverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(midSilverID, rmXFractionToMeters(0.05));
		if (rmGetIsTreaty() == true)
			rmSetObjectDefMaxDistance(midSilverID, rmXFractionToMeters(0.40));
		else
			rmSetObjectDefMaxDistance(midSilverID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(midSilverID, classGold);
		if (whichMap < 4 && rmGetIsTreaty() == false)
			rmAddObjectDefConstraint(midSilverID, stayGoldZone);
		rmAddObjectDefConstraint(midSilverID, avoidForestShort);
		rmAddObjectDefConstraint(midSilverID, avoidEdgeMore);
		rmAddObjectDefConstraint(midSilverID, avoidTownCenterFar);
		rmAddObjectDefConstraint(midSilverID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(midSilverID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(midSilverID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(midSilverID, avoidPondMin);
		rmAddObjectDefConstraint(midSilverID, avoidGoldTypeFar);
		rmPlaceObjectDefAtLoc(midSilverID, 0, 0.50, 0.50, 3*PlayerNum);
	}
	else 
	{
		// Symmetrical Mines - from Riki (thx)
		int silverIDSA = -1;
		silverIDSA = rmCreateObjectDef("silver STARTA");
		rmAddObjectDefItem(silverIDSA, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverIDSA, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silverIDSA, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(silverIDSA, classGold2);
		rmAddObjectDefConstraint(silverIDSA, avoidTownCenterMed);
		rmAddObjectDefConstraint(silverIDSA, avoidTradeRouteShort);
		rmAddObjectDefConstraint(silverIDSA, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(silverIDSA, avoidEdgeMore);
		rmAddObjectDefConstraint(silverIDSA, avoidStartingResources);
		rmAddObjectDefConstraint(silverIDSA, avoidNatives);
		rmAddObjectDefConstraint(silverIDSA, avoidCliffMin);
		rmAddObjectDefConstraint(silverIDSA, avoidPondShort);
		rmAddObjectDefConstraint(silverIDSA, avoidGoldType);
		rmAddObjectDefConstraint(silverIDSA, avoidMidSmIslandFar);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddObjectDefConstraint(silverIDSA, avoidGold2Far);
		else 
			rmAddObjectDefConstraint(silverIDSA, avoidGold2VeryFar);
		rmAddObjectDefConstraint(silverIDSA, avoidNomad);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(silverIDSA, avoidKOTH);

		int silverIDSB = -1;
		silverIDSB = rmCreateObjectDef("silver STARTB");
		rmAddObjectDefItem(silverIDSB, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverIDSB, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silverIDSB, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(silverIDSB, classGold2);

		int minePlacement=0;
		float minePositionX=-1;
		float minePositionZ=-1;
		int result=0;
		int leaveWhile=0;

		while (minePlacement < 3)  	// 3 per player
		{
			if (rmGetIsTreaty() == false) 
			{
				minePositionX=rmRandFloat(0.05,0.95);
				minePositionZ=rmRandFloat(0.05,0.95);
			}
			else 
			{
				minePositionX=rmRandFloat(0.10,0.90);
				minePositionZ=rmRandFloat(0.10,0.90);
			}
		rmSetObjectDefForceFullRotation(silverIDSA, true);
		result=rmPlaceObjectDefAtLoc(silverIDSA, 0, minePositionX, minePositionZ);
		if (result == 1) 
		{
			rmSetObjectDefForceFullRotation(silverIDSB, true);
			rmPlaceObjectDefAtLoc(silverIDSB, 0, 1.0-minePositionX, 1.0-minePositionZ);
			minePlacement++;
			leaveWhile=0;
		}
		else
			leaveWhile++;
		if (leaveWhile==300)
			break;
		}
	}

	// Ponds
	int pondCount = 1+PlayerNum/2;
	if (whichMap == 4)
		pondCount = PlayerNum;

	for (i=0; < pondCount) 
	{
		int pondID=rmCreateArea("pond"+i);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmSetAreaSize(pondID, rmAreaTilesToFraction(50+PlayerNum*25));
		else
			rmSetAreaSize(pondID, rmAreaTilesToFraction(100+PlayerNum*50));
		rmSetAreaWaterType(pondID, wetType);
		rmSetAreaWarnFailure(pondID, false);
		rmAddAreaToClass(pondID, classPond);
		rmSetAreaCoherence(pondID, 0.555);
		rmSetAreaObeyWorldCircleConstraint(pondID, false);
		rmAddAreaConstraint(pondID, avoidGoldShort);
		rmAddAreaConstraint(pondID, avoidGold2Short);
		rmAddAreaConstraint(pondID, avoidNomad);
		rmAddAreaConstraint(pondID, avoidTownCenterFar);
		rmAddAreaConstraint(pondID, avoidStartingResources);
		rmAddAreaConstraint(pondID, avoidIslandFar);
		rmAddAreaConstraint(pondID, avoidPondFar);
		rmAddAreaConstraint(pondID, avoidNatives);
		rmAddAreaConstraint(pondID, avoidTradeRouteSocket);
		rmAddAreaConstraint(pondID, avoidTradeRoute);
		rmAddAreaConstraint(pondID, avoidEdge);
		if (PlayerNum > 2 && whichMap < 4)
			rmAddAreaConstraint(pondID, stayGoldZone);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(pondID, avoidKOTH);
//		if (whichMap > 1)
//			rmBuildArea(pondID);
	}

	// Text
	rmSetStatusText("",0.60);

	// Cliffs
	int cliffcount = 2+PlayerNum; 
	if (rmGetIsTreaty() == true && whichMap != 4)
		cliffcount = 2;
	int stayNearCliff = -1;
	int stayInCliff = -1;
	int cliffPatchID = -1;
	int cliffVegID = -1;
	int whichHeight = -1;

	for (i= 0; < cliffcount)
	{
		whichHeight = rmRandInt(1,2);
//		whichHeight = 1;	// for testing

		int cliffID = rmCreateArea("cliff"+i);
		rmAddAreaToClass(cliffID, classCliff);
		if (rmGetIsTreaty() == true && PlayerNum > 4 && whichMap != 4)
			rmSetAreaSize(cliffID, rmAreaTilesToFraction(100+64*PlayerNum));
		else if (rmGetIsTreaty() == true && whichMap != 4)
			rmSetAreaSize(cliffID, rmAreaTilesToFraction(100+64*PlayerNum));
		else
			rmSetAreaSize(cliffID, rmAreaTilesToFraction(200+25*PlayerNum));
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		rmSetAreaCliffType(cliffID, mntType); 
		rmSetAreaTerrainType(cliffID, cliffPaint);
		if (rmGetIsTreaty() == true && whichMap != 4)
		{
			if (i == 1)
				rmSetAreaLocation(cliffID, 0.50, 0.01);
			else 
				rmSetAreaLocation(cliffID, 0.50, 0.99);
			rmSetAreaCliffEdge(cliffID, 1, 1.00, 0.0, 0.0, 1); 
		}
		else 
		{
			rmSetAreaCliffEdge(cliffID, 2, 0.25, 0.0, 0.0, 1); 
		}
		if (whichHeight == 1)
			rmSetAreaCliffHeight(cliffID, rmRandInt(-10,-6), 0.1, 0.5); 
		else
			rmSetAreaCliffHeight(cliffID, rmRandInt(4,6), 0.1, 0.5); 
		rmSetAreaHeightBlend(cliffID, 0);
		rmSetAreaCoherence(cliffID, 0.70);
		rmSetAreaSmoothDistance(cliffID, 0);
		rmAddAreaConstraint(cliffID, avoidNatives);
		rmAddAreaConstraint(cliffID, avoidGoldTypeMin);
		rmAddAreaConstraint(cliffID, avoidNomad);
		rmAddAreaConstraint(cliffID, avoidTownCenterFar);
		rmAddAreaConstraint(cliffID, avoidStartingResourcesShort);
		rmAddAreaConstraint(cliffID, avoidPondMin);
		rmAddAreaConstraint(cliffID, avoidCliffVeryFar);
		if (rmGetIsTreaty() == false) 
		{
			rmAddAreaConstraint(cliffID, avoidEdgeMore);	
			rmAddAreaConstraint(cliffID, avoidTradeRouteSocket);
			rmAddAreaConstraint(cliffID, avoidTradeRouteMin);
		}
		else 
		{
			if (PlayerNum == 2)
				rmAddAreaConstraint(cliffID, avoidTradeRouteShort);
			else
				rmAddAreaConstraint(cliffID, avoidTradeRoute);
		}
		rmAddAreaConstraint(cliffID, avoidIsland);
		rmAddAreaConstraint(cliffID, avoidPondShort);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(cliffID, avoidKOTH);
		rmSetAreaWarnFailure(cliffID, false);
		rmBuildArea(cliffID);		

		stayNearCliff = rmCreateAreaMaxDistanceConstraint("stay near cliff"+i, cliffID, 4.0);
		stayInCliff = rmCreateAreaMaxDistanceConstraint("stay in cliff"+i, cliffID, 0.0);

        cliffPatchID = rmCreateArea("cliff patch"+i);
        rmSetAreaWarnFailure(cliffPatchID, false);
		rmSetAreaObeyWorldCircleConstraint(cliffPatchID, true);
        rmSetAreaSize(cliffPatchID, rmAreaTilesToFraction(300+50*PlayerNum));
		rmSetAreaMix(cliffPatchID, paintMix5);
        rmSetAreaCoherence(cliffPatchID, 1.00);
		rmAddAreaConstraint(cliffPatchID, stayNearCliff);
		rmBuildArea(cliffPatchID);

		cliffVegID = rmCreateObjectDef("cliff veg "+i);
		if (rmGetIsTreaty() == false)
			rmAddObjectDefItem(cliffVegID, treeType3, rmRandInt(5,8), 8.0);
		rmAddObjectDefItem(cliffVegID, brushType1, rmRandInt(20,30), 15+PlayerNum);
		if (rmGetIsTreaty() == false)
			rmAddObjectDefItem(cliffVegID, "PropVulturePerching", rmRandInt(0,1), 12.0);
		rmAddObjectDefItem(cliffVegID, "PropDustCloud", 5, 8.0);
		rmSetObjectDefMinDistance(cliffVegID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(cliffVegID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(cliffVegID, classForest);
		rmAddObjectDefToClass(cliffVegID, rmClassID("prop"));
		rmAddObjectDefConstraint(cliffVegID, stayInCliff);
		rmAddObjectDefConstraint(cliffVegID, avoidForestShort);
		rmAddObjectDefConstraint(cliffVegID, avoidGoldMin);
		rmAddObjectDefConstraint(cliffVegID, avoidNatives);
		rmAddObjectDefConstraint(cliffVegID, avoidTradeRouteSocketMin);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(cliffVegID, avoidKOTH);
		rmPlaceObjectDefAtLoc(cliffVegID, 0, 0.50, 0.50, 2);
	}

	// Text
	rmSetStatusText("",0.70);

	// map forest patches
	int maptreecount = 20+8*PlayerNum;
	int stayForest2ndPatch = -1;

	for (i=0; < maptreecount)
    {
        int forestpatch2ID = rmCreateArea("map forest patch"+i);
        rmSetAreaWarnFailure(forestpatch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatch2ID, true);
        rmSetAreaSize(forestpatch2ID, rmAreaTilesToFraction(100));
		rmSetAreaMix(forestpatch2ID, paintMix6);
        rmSetAreaCoherence(forestpatch2ID, 0.2);
		rmSetAreaSmoothDistance(forestpatch2ID, 5);
		if (rmGetIsTreaty() == true) 
		{
			rmAddAreaConstraint(forestpatch2ID, avoidGoldZoneFar);
			rmAddAreaConstraint(forestpatch2ID, avoidTradeRoute);
			rmAddAreaConstraint(forestpatch2ID, avoidForest);
		}
		else
			rmAddAreaConstraint(forestpatch2ID, avoidForestMed);
		rmAddAreaConstraint(forestpatch2ID, avoidEdge);
		rmAddAreaConstraint(forestpatch2ID, avoidGoldTypeMin);
		rmAddAreaConstraint(forestpatch2ID, avoidTownCenterShort);
		rmAddAreaConstraint(forestpatch2ID, avoidNatives);
		rmAddAreaConstraint(forestpatch2ID, avoidStartingResources);
		rmAddAreaConstraint(forestpatch2ID, avoidBerriesShort);
		rmAddAreaConstraint(forestpatch2ID, avoidIslandShort);
		rmAddAreaConstraint(forestpatch2ID, avoidPondMin);
		rmAddAreaConstraint(forestpatch2ID, avoidTradeRouteSocketMin);
		if (rmGetIsTreaty() == true)
			rmAddAreaConstraint(forestpatch2ID, avoidCliff);
		if (centralPond == 1)	
			rmAddAreaConstraint(forestpatch2ID, avoidWaterFar);
		if (rmGetIsKOTH() == true)
			rmAddAreaConstraint(forestpatch2ID, avoidKOTH);
		rmBuildArea(forestpatch2ID);

		stayForest2ndPatch = rmCreateAreaMaxDistanceConstraint("stay in second forest patch"+i, forestpatch2ID, 0.0);

		int foresttree2ID = rmCreateObjectDef("map trees"+i);
		rmAddObjectDefItem(foresttree2ID, treeType1, 4, 5.0);
		rmSetObjectDefMinDistance(foresttree2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(foresttree2ID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(foresttree2ID, classForest);
		rmAddObjectDefConstraint(foresttree2ID, stayForest2ndPatch);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(foresttree2ID, avoidCliffMin);
		if (rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(foresttree2ID, 0, 0.50, 0.50, 1+PlayerNum/4);
		else
			rmPlaceObjectDefAtLoc(foresttree2ID, 0, 0.50, 0.50, 1+PlayerNum/2);

		int foresttree2BID = rmCreateObjectDef("map 2nd trees"+i);
		rmAddObjectDefItem(foresttree2BID, treeType2, 3, 3.0);
		rmAddObjectDefItem(foresttree2BID, treeType3, 2, 3.0);
		rmSetObjectDefMinDistance(foresttree2BID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(foresttree2BID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(foresttree2BID, classForest);
		rmAddObjectDefConstraint(foresttree2BID, stayForest2ndPatch);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(foresttree2BID, avoidCliffMin);
		rmPlaceObjectDefAtLoc(foresttree2BID, 0, 0.50, 0.50, 2);
		if (PlayerNum > 4 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(foresttree2BID, 0, 0.50, 0.50);
    }

	// Text
	rmSetStatusText("",0.80);

	// Random Vegetation
	float treeOne = rmRandInt(1,4);

	int randomVegID = rmCreateObjectDef("random veg ");
		rmAddObjectDefItem(randomVegID, treeType2, treeOne, 4.0);
		rmAddObjectDefItem(randomVegID, treeType3, 4-treeOne, 4.0);
		rmSetObjectDefMinDistance(randomVegID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(randomVegID, rmXFractionToMeters(0.48));
		rmAddObjectDefToClass(randomVegID, classForest);
		rmAddObjectDefConstraint(randomVegID, avoidForestShort);
		rmAddObjectDefConstraint(randomVegID, avoidGoldMin);
		rmAddObjectDefConstraint(randomVegID, avoidTownCenterShort);
		rmAddObjectDefConstraint(randomVegID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(randomVegID, avoidIslandMin);
		rmAddObjectDefConstraint(randomVegID, avoidNatives);
		rmAddObjectDefConstraint(randomVegID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(randomVegID, avoidBerriesShort);
		rmAddObjectDefConstraint(randomVegID, avoidPondShort);
		rmAddObjectDefConstraint(randomVegID, avoidImpassableLandMin);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(randomVegID, avoidCliff);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(randomVegID, avoidKOTH);
		rmPlaceObjectDefAtLoc(randomVegID, 0, 0.50, 0.50, 5*PlayerNum);

	int dryGrassID = rmCreateObjectDef("dry grass");
		rmAddObjectDefItem(dryGrassID, brushType1, rmRandInt(3,5), 10.0);
		rmAddObjectDefItem(dryGrassID, brushType2, rmRandInt(1,2), 6.0);
		rmSetObjectDefMinDistance(dryGrassID, 0);
		rmSetObjectDefMaxDistance(dryGrassID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(dryGrassID, rmClassID("prop"));
		rmAddObjectDefConstraint(dryGrassID, avoidIslandMin);
//		rmAddObjectDefConstraint(dryGrassID, avoidTownCenterShort);
		rmAddObjectDefConstraint(dryGrassID, avoidStartingResources);
		rmAddObjectDefConstraint(dryGrassID, avoidEmbellishmentFar);
		rmAddObjectDefConstraint(dryGrassID, avoidPondShort);
		rmAddObjectDefConstraint(dryGrassID, avoidNatives);
		rmAddObjectDefConstraint(dryGrassID, avoidForestMin);
		rmAddObjectDefConstraint(dryGrassID, avoidGoldShort);
		rmAddObjectDefConstraint(dryGrassID, avoidGold2Short);
		rmAddObjectDefConstraint(dryGrassID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(dryGrassID, avoidBerriesMin);
		rmPlaceObjectDefAtLoc(dryGrassID, 0, 0.50, 0.50, 10*PlayerNum);

	int bigTexasThingsID = rmCreateObjectDef("big texas things");
		rmAddObjectDefItem(bigTexasThingsID, "BigPropTexas", 1, 0.0);
		rmSetObjectDefMinDistance(bigTexasThingsID, 0);
		rmSetObjectDefMaxDistance(bigTexasThingsID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(bigTexasThingsID, rmClassID("prop"));
		rmAddObjectDefConstraint(bigTexasThingsID, avoidNatives);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidIslandMin);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidTownCenter);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidStartingResources);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidEmbellishmentFar);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidPondShort);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidForestMin);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidGoldShort);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidGold2Short);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(bigTexasThingsID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(bigTexasThingsID, stayNWDesert);
		if (rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(bigTexasThingsID, 0, 0.50, 0.50, PlayerNum);

	// Text
	rmSetStatusText("",0.90);

	// Mid Herds 
	int mapHuntID = rmCreateObjectDef("mid herd");
		rmAddObjectDefItem(mapHuntID, food2, 6, 3.0);
		if (PlayerNum == 2) 
		{
			rmSetObjectDefMinDistance(mapHuntID, 0.00);
			rmSetObjectDefMaxDistance(mapHuntID, rmXFractionToMeters(0.015));
		}
		else 
		{
			rmSetObjectDefMinDistance(mapHuntID, 0.10);
			rmSetObjectDefMaxDistance(mapHuntID, rmXFractionToMeters(0.15));
		}
		rmSetObjectDefCreateHerd(mapHuntID, true);
		rmAddObjectDefConstraint(mapHuntID, avoidHunt2);
		rmAddObjectDefConstraint(mapHuntID, avoidGoldMin);
		rmAddObjectDefConstraint(mapHuntID, avoidForestMin);
		rmAddObjectDefConstraint(mapHuntID, avoidStartingResources);
		rmAddObjectDefConstraint(mapHuntID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(mapHuntID, avoidNatives);
		rmAddObjectDefConstraint(mapHuntID, avoidBerriesMin);
		rmAddObjectDefConstraint(mapHuntID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(mapHuntID, avoidPondMin);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(mapHuntID, avoidCliffFar);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(mapHuntID, avoidKOTH);
		if (PlayerNum == 2)
			rmPlaceObjectDefAtLoc(mapHuntID, 0, 0.50, 0.50, 0*PlayerNum/2);
		else
			rmPlaceObjectDefAtLoc(mapHuntID, 0, 0.50, 0.50, 2+PlayerNum);
		
	if (PlayerNum == 2) 
	{
		// Symmetrical Hunts - from Riki (thx)
		int midHuntAID = -1;
		midHuntAID = rmCreateObjectDef("mid hunt A");
		rmAddObjectDefItem(midHuntAID, food2, 6, 3.0);
		rmSetObjectDefMinDistance(midHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(midHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(midHuntAID, true);
		rmAddObjectDefConstraint(midHuntAID, avoidHunt2);
		rmAddObjectDefConstraint(midHuntAID, avoidForestShorter);
		rmAddObjectDefConstraint(midHuntAID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(midHuntAID, avoidStartingResources);
		rmAddObjectDefConstraint(midHuntAID, avoidPondMin);
		rmAddObjectDefConstraint(midHuntAID, avoidGoldMin);
		rmAddObjectDefConstraint(midHuntAID, avoidNatives);
		rmAddObjectDefConstraint(midHuntAID, avoidNomad);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(midHuntAID, avoidCliff);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(midHuntAID, avoidKOTH);

		int midHuntBID = -1;
		midHuntBID = rmCreateObjectDef("mid hunt B");
		rmAddObjectDefItem(midHuntBID, food2, 6, 3.0);
		rmSetObjectDefMinDistance(midHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(midHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(midHuntBID, true);

		int huntMidPlacement=0;
		float huntMidPositionX=-1;
		float huntMidPositionZ=-1;
		int resultMidF=0;
		int leaveWhileMidF=0;

		while (huntMidPlacement < 1) 
		{
			huntMidPositionX=rmRandFloat(0.35,0.65);
			huntMidPositionZ=rmRandFloat(0.35,0.65);
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

		// Symmetrical Hunts - from Riki (thx)
		int mapHuntAID = -1;
		mapHuntAID = rmCreateObjectDef("hunt A");
		rmAddObjectDefItem(mapHuntAID, food1, 9, 8.0);
		rmSetObjectDefMinDistance(mapHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(mapHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(mapHuntAID, true);
		rmAddObjectDefConstraint(mapHuntAID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(mapHuntAID, avoidEdge);
		rmAddObjectDefConstraint(mapHuntAID, avoidStartingResources);
		rmAddObjectDefConstraint(mapHuntAID, avoidNatives);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(mapHuntAID, avoidCliffMed);
		else
			rmAddObjectDefConstraint(mapHuntAID, avoidCliffMin);
		rmAddObjectDefConstraint(mapHuntAID, avoidForestMin);
		rmAddObjectDefConstraint(mapHuntAID, avoidPondShort);
		rmAddObjectDefConstraint(mapHuntAID, avoidGoldShort);
		rmAddObjectDefConstraint(mapHuntAID, avoidGold2Short);
		rmAddObjectDefConstraint(mapHuntAID, avoidHunt2);
		rmAddObjectDefConstraint(mapHuntAID, avoidCenterMin);
		if (whichMap == 3)
			rmAddObjectDefConstraint(mapHuntAID, avoidWater);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)
			rmAddObjectDefConstraint(mapHuntAID, avoidHunt1Far);
		else 
			rmAddObjectDefConstraint(mapHuntAID, avoidHunt1VeryFar);
		rmAddObjectDefConstraint(mapHuntAID, avoidNomad);
		rmAddObjectDefConstraint(mapHuntAID, avoidTownCenterMed);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(mapHuntAID, avoidKOTH);

		int mapHuntBID = -1;
		mapHuntBID = rmCreateObjectDef("hunt B");
		rmAddObjectDefItem(mapHuntBID, food1, 9, 3.0);
		rmSetObjectDefMinDistance(mapHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(mapHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(mapHuntBID, true);

		int huntPlacement=0;
		float huntPositionX=-1;
		float huntPositionZ=-1;
		int resultF=0;
		int leaveWhileF=0;

		while (huntPlacement < 1.5*PlayerNum) 
		{
			huntPositionX=rmRandFloat(0.03,0.97);
			huntPositionZ=rmRandFloat(0.03,0.97);
			resultF=rmPlaceObjectDefAtLoc(mapHuntAID, 0, huntPositionX, huntPositionZ);
			if (resultF != 0) 
			{
				rmPlaceObjectDefAtLoc(mapHuntBID, 0, 1.0-huntPositionX, 1.0-huntPositionZ);
				huntPlacement++;
				leaveWhileF=0;
			}
			else
				leaveWhileF++;
			if (leaveWhileF==300)
				break;
		}

	// Text
	rmSetStatusText("",0.95);

	// Treasures L4
	int Nugget4ID = rmCreateObjectDef("nugget lvl4 "); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, rmXFractionToMeters(0.025));
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.15));
		rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget4ID, stayGoldZone);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget4ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort); 
		rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocketShort); 
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(Nugget4ID, avoidCliff); 
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives); 
		rmAddObjectDefConstraint(Nugget4ID, avoidPondShort); 
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(Nugget4ID, avoidKOTH);
		if (PlayerNum > 4 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50, PlayerNum);
			
	// Treasures L3
	int Nugget3ID = rmCreateObjectDef("nugget lvl3 "); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		if (PlayerNum < 7)
			rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.15));
		else
			rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.30));
		rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, stayGoldZone);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort); 
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocketShort); 
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(Nugget3ID, avoidCliff); 
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives); 
		rmAddObjectDefConstraint(Nugget3ID, avoidPondMin); 
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(Nugget3ID, avoidKOTH);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, PlayerNum);

	// Treasures L2
	if (PlayerNum > 2) 
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl2 "); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2,2);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(Nugget2ID, avoidEdgeMore);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, stayMidIsland); 
		rmAddObjectDefConstraint(Nugget2ID, avoidStartingResources);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketShort); 
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidWaterShort); 
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(Nugget2ID, avoidCliff); 
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(Nugget2ID, avoidKOTH);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, 2*PlayerNum+2);
	}
	else 
	{
		// Symmetrical Nuggets - from Riki (thx)
		int nugget2AID = -1;
		nugget2AID = rmCreateObjectDef("nugget lvl 2 A");
		rmAddObjectDefItem(nugget2AID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2,2);
		rmSetObjectDefMinDistance(nugget2AID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(nugget2AID, rmXFractionToMeters(0.00));
		rmAddObjectDefConstraint(nugget2AID, avoidNatives);
		rmAddObjectDefConstraint(nugget2AID, stayGoldZone);
		rmAddObjectDefConstraint(nugget2AID, avoidNuggetFar);
		rmAddObjectDefConstraint(nugget2AID, avoidTownCenterFar);
		rmAddObjectDefConstraint(nugget2AID, avoidEdgeMore);
		rmAddObjectDefConstraint(nugget2AID, avoidStartingResources);
		rmAddObjectDefConstraint(nugget2AID, avoidGoldMin);
		rmAddObjectDefConstraint(nugget2AID, avoidHunt1Min);
		rmAddObjectDefConstraint(nugget2AID, avoidHunt2Min);
		rmAddObjectDefConstraint(nugget2AID, avoidPondMin);
		rmAddObjectDefConstraint(nugget2AID, avoidForestMin);
		rmAddObjectDefConstraint(nugget2AID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(nugget2AID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nugget2AID, avoidNomad);
		rmAddObjectDefConstraint(nugget2AID, avoidImpassableLand);
		if (rmGetIsTreaty() == true)
			rmAddObjectDefConstraint(nugget2AID, avoidCliff);
		if (rmGetIsKOTH() == true)
			rmAddObjectDefConstraint(nugget2AID, avoidKOTH);

		int nugget2BID = -1;
		nugget2BID = rmCreateObjectDef("nugget lvl 2 B");
		rmAddObjectDefItem(nugget2BID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(2,2);
		rmSetObjectDefMinDistance(nugget2BID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(nugget2BID, rmXFractionToMeters(0.00));

		int nuggetPlacement=0;
		float nuggetPositionX=-1;
		float nuggetPositionZ=-1;
		int resultNugget=0;
		int leaveWhileN=0;

		while (nuggetPlacement < 3)
		{
			nuggetPositionX=rmRandFloat(0.05,0.95);
			nuggetPositionZ=rmRandFloat(0.05,0.95);
			rmSetObjectDefForceFullRotation(nugget2AID, true);
			resultNugget=rmPlaceObjectDefAtLoc(nugget2AID, 0, nuggetPositionX, nuggetPositionZ);
			if (resultNugget == 1) 
			{
				rmSetObjectDefForceFullRotation(nugget2BID, true);
				rmPlaceObjectDefAtLoc(nugget2BID, 0, 1.0-nuggetPositionX, 1.0-nuggetPositionZ);
				nuggetPlacement++;
				leaveWhileN=0;
			}
			else
				leaveWhileN++;
			if (leaveWhileN==300)
				break;
		}
	}
		
	// Treasures L1
	int Nugget1ID = rmCreateObjectDef("nugget lvl1 "); 
	rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget1ID, 0);
	rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.5));
	rmSetNuggetDifficulty(1,1);
	rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
	rmAddObjectDefConstraint(Nugget1ID, avoidHunt1Min);
	rmAddObjectDefConstraint(Nugget1ID, avoidHunt2Min);
	rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
	rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter); 
	rmAddObjectDefConstraint(Nugget1ID, avoidStartingResources); 
	rmAddObjectDefConstraint(Nugget1ID, avoidNatives); 
	rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteMin); 
	rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketShort); 
	rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandMin); 
	rmAddObjectDefConstraint(Nugget1ID, avoidGoldZone); 
	rmAddObjectDefConstraint(Nugget1ID, avoidPondMin); 
	if (rmGetIsTreaty() == true)
		rmAddObjectDefConstraint(Nugget1ID, avoidCliff); 
	if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(Nugget1ID, avoidKOTH);
	rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50, 2+2*PlayerNum);

	// Cows 
	int cowID=rmCreateObjectDef("moo");
	rmAddObjectDefItem(cowID, cattleType, 1, 0.0);
	rmSetObjectDefMinDistance(cowID, 0.0);
	rmSetObjectDefMaxDistance(cowID, rmXFractionToMeters(0.48));
	if (centralPond == 1)
		rmAddObjectDefConstraint(cowID, avoidCattleMed);
	else
		rmAddObjectDefConstraint(cowID, avoidCattle);
	rmAddObjectDefConstraint(cowID, avoidTownCenterFar); 
	rmAddObjectDefConstraint(cowID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(cowID, avoidGoldMin);
	rmAddObjectDefConstraint(cowID, avoidGold2Min);
	rmAddObjectDefConstraint(cowID, avoidHunt1Min);
	rmAddObjectDefConstraint(cowID, avoidForestMin);
	rmAddObjectDefConstraint(cowID, avoidNuggetMin);
	rmAddObjectDefConstraint(cowID, avoidEdge); 
	rmAddObjectDefConstraint(cowID, avoidImpassableLandMin); 
	rmAddObjectDefConstraint(cowID, avoidNatives); 
	rmAddObjectDefConstraint(cowID, avoidPondMin); 
	rmAddObjectDefConstraint(cowID, stayGoldZone); 
	if (rmGetIsTreaty() == true)
		rmAddObjectDefConstraint(cowID, avoidCliff); 
	if (rmGetIsKOTH() == true)
		rmAddObjectDefConstraint(cowID, avoidKOTH);
	rmPlaceObjectDefAtLoc(cowID, 0, 0.50, 0.50, 3*PlayerNum);

	// Disable Dock for Treaty thanks Eaglemut for this method that doesn't remove the dock from villager building options
	if (rmGetIsTreaty() == true) 
	{
		rmCreateTrigger("dockForbidTrigger");
		rmSwitchToTrigger(rmTriggerID("dockForbidTrigger"));
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4);
		
		for(i=1; <= cNumberNonGaiaPlayers) 
		{
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "Dock");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 01);		// none
		}

		rmCreateTrigger("dockAsianForbidTrigger");
		rmSwitchToTrigger(rmTriggerID("dockAsianForbidTrigger"));
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4);

		for(i=1; <= cNumberNonGaiaPlayers) 
		{
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "YPDockAsian");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 01);		// none
		}

		rmCreateTrigger("portAfricanForbidTrigger");
		rmSwitchToTrigger(rmTriggerID("portAfricanForbidTrigger"));
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4);

		for(i=1; <= cNumberNonGaiaPlayers) 
		{
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "dePort");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 01);		// none
		}
	}

	// Text
	rmSetStatusText("",1.00);
	
} // END