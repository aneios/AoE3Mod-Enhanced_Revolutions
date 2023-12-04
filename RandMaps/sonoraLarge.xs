// Sonora LARGE
// June 2004
// Nov. 2005 - JSB - Aztecs to Apache for Age3Xpack.  Maya villages left as-is.
// Nov 06 - YP update
// Durokan's July 2 2020 1v1 balance update for DE
// March 2021 edited by vividlyplain - thanks Mitoe for providing a good base with your own edit of Sonora

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

	// ____________________ General ____________________
	// Picks the map size
	int playerTiles = 18000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 16000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 14000;		

	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmSetMapSize(size, size);

	// Elevation
	rmSetMapElevationParameters(cElevTurbulence, 0.02, 4, 0.7, 8.0);
	rmSetMapElevationHeightBlend(1);

	// Make the corners
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(4.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

    // Picks default terrain and water
	rmSetBaseTerrainMix("sonora_dirt");
	rmTerrainInitialize("sonora\ground2_son", 4.0);
	rmSetMapType("sonora");
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetLightingSet("Sonora_Skirmish");

	// Choose Mercs
	chooseMercs();

	// Make it windy
	rmSetWindMagnitude(2.0);

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
	int classCliff = rmDefineClass("Cliffs");
	int classNative = rmDefineClass("natives");
	int classCanyon = rmDefineClass("conyons");
	int classFeature = rmDefineClass("features");
	int classProp = rmDefineClass("prop");

	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.1), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int staySouthPart = rmCreatePieConstraint("Stay south part", 0.55, 0.55,rmXFractionToMeters(0.0), rmXFractionToMeters(0.60), rmDegreesToRadians(135),rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("Stay north half", 0.50, 0.50,rmXFractionToMeters(0.0), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
		
	// Resource avoidance
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 26.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 20.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 34.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 16.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 25.0);
	int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 12.0);
	
	int avoidBisonFar = rmCreateTypeDistanceConstraint("avoid bison far", "bison", 55.0);
	int avoidBison = rmCreateTypeDistanceConstraint("avoid bison", "bison", 46.0);
	int avoidBisonShort = rmCreateTypeDistanceConstraint("avoid bison short", "bison", 24.0);
	int avoidBisonMin = rmCreateTypeDistanceConstraint("avoid bison min", "bison", 10.0);	
	
	int avoidPronghornFar = rmCreateTypeDistanceConstraint("avoid pronghorn far", "pronghorn", 60.0);
	int avoidPronghorn = rmCreateTypeDistanceConstraint("avoid pronghorn", "pronghorn", 50.0);
	int avoidPronghornShort = rmCreateTypeDistanceConstraint("avoid pronghorn short", "pronghorn", 20.0);
	int avoidPronghornMin = rmCreateTypeDistanceConstraint("avoid pronghorn min", "pronghorn", 10.0);
	
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 30.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 45.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 12.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 52.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 16.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 40.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 58.0);
	
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	
	int avoidNomad = rmCreateTypeDistanceConstraint("avoid covered wagon", "CoveredWagon", 50.0);
	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 70.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 36.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 30.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);
	
	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 4.0);
	
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 12.0);
	int avoidCliffMin = rmCreateClassDistanceConstraint("avoid cliff min", rmClassID("Cliffs"), 6.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("avoid cliff short", rmClassID("Cliffs"), 8.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 16.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 30.0);
	
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 12.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", rmClassID("natives"), 6.0);
	int stayNatives = rmCreateClassDistanceConstraint("stuff stays near natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 18.0);
	
	// Avoid impassable land
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 20.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("avoid patch2", rmClassID("patch2"), 20.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("avoid patch3", rmClassID("patch3"), 20.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 4.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 20.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 2.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);

	int avoidProp = rmCreateClassDistanceConstraint("avoid prop", rmClassID("prop"), 12.0);
	int avoidPropMin = rmCreateClassDistanceConstraint("avoid prop min", rmClassID("prop"), 2.0);
	int avoidPropShort = rmCreateClassDistanceConstraint("avoid prop short", rmClassID("prop"), 8.0);
	int avoidPropFar = rmCreateClassDistanceConstraint("avoid prop far", rmClassID("prop"), 24.0);	

	int avoidFeature = rmCreateClassDistanceConstraint("avoid feature", rmClassID("features"), 12.0);
	int avoidFeatureMin = rmCreateClassDistanceConstraint("avoid feature min", rmClassID("features"), 2.0);
	int avoidFeatureShort = rmCreateClassDistanceConstraint("avoid feature short", rmClassID("features"), 8.0);
	int avoidFeatureFar = rmCreateClassDistanceConstraint("avoid feature far", rmClassID("features"), 24.0);	

	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandShort=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 6.0);

/*
// from sonora
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("secrets");
	rmDefineClass("classNugget");
	rmDefineClass("center");
	int canyon=rmDefineClass("canyon");

	int avoidVultures=rmCreateTypeDistanceConstraint("avoids Vultures", "PropVulturePerching", 40.0);
	int avoidCanyons=rmCreateClassDistanceConstraint("avoid canyons", rmClassID("canyon"), 35.0);
	int shortAvoidCanyons=rmCreateClassDistanceConstraint("short avoid canyons", rmClassID("canyon"), 15.0);
	int veryShortAvoidCanyons=rmCreateClassDistanceConstraint("very short avoid canyons", rmClassID("canyon"), 4.0);
	int avoidNatives=rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 15.0);
	int shortAvoidNatives=rmCreateClassDistanceConstraint("short avoid natives", rmClassID("natives"), 10.0);
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 55.0);
	int shortAvoidSilver=rmCreateTypeDistanceConstraint("short gold avoid gold", "Mine", 20.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), rmXFractionToMeters(0.23));
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), rmXFractionToMeters(0.10));
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 50.0);
	int shortForestConstraint=rmCreateClassDistanceConstraint("short forest vs. forest", rmClassID("classForest"), 10.0);
  int avoidHill = rmCreateTypeDistanceConstraint("avoid hill", "ypKingsHill", 8.0);

	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("short resource avoid resource", "resource", 4.0);
	int avoidBuzzards=rmCreateTypeDistanceConstraint("buzzard avoid buzzard", "BuzzardFlock", 70.0);
	int avoidBison=rmCreateTypeDistanceConstraint("avoid Bison", "Bison", 40);
	int avoidPronghorn=rmCreateTypeDistanceConstraint("avoid Pronghorn", "Pronghorn", 40);
	int avoidTradeRoute=rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("long stay away from players", classPlayer, 40.0);
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 30.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 20.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 8.0);
	int avoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget long", rmClassID("classNugget"), 60.0);
	int shortAvoidNugget=rmCreateClassDistanceConstraint("nugget vs. nugget short", rmClassID("classNugget"), 8.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid Trade Socket", "sockettraderoute", 10);
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 8.0);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

	//dk
    int avoidAll_dk=rmCreateTypeDistanceConstraint("avoid all_dk", "all", 3.0);
    int avoidWater5_dk = rmCreateTerrainDistanceConstraint("avoid water long_dk", "Land", false, 5.0);
    int avoidSocket2_dk=rmCreateClassDistanceConstraint("socket avoidance gold_dk", rmClassID("socketClass"), 8.0);
    int avoidTradeRouteSmall_dk = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small_dk", 6.0);
    int forestConstraintShort_dk=rmCreateClassDistanceConstraint("object vs. forest_dk", rmClassID("classForest"), 2.0);
    int avoidHunt2_dk=rmCreateTypeDistanceConstraint("herds avoid herds2_dk", "huntable", 32.0);
    int avoidHunt3_dk=rmCreateTypeDistanceConstraint("herds avoid herds3_dk", "huntable", 18.0);
	int avoidAll2_dk=rmCreateTypeDistanceConstraint("avoid all2_dk", "all", 4.0);
    int avoidGoldTypeFar_dk = rmCreateTypeDistanceConstraint("avoid gold type  far 2_dk", "gold", 24.0);
    int circleConstraint2_dk=rmCreatePieConstraint("circle Constraint2_dk", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int avoidMineForest_dk=rmCreateTypeDistanceConstraint("avoid mines forest _dk", "gold", 5.0);

	int canyonConstraint=rmCreateClassDistanceConstraint("canyons start away from each other", canyon, 5.0);
		
	int failCount=0;
*/

	int numTries=cNumberNonGaiaPlayers*15;

	// ____________________ Player Placement ____________________
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
// 2 team and FFA support
	float OneVOnePlacement=rmRandFloat(0, 1);
	if (cNumberNonGaiaPlayers == 2)
	{
		if ( OneVOnePlacement < 0.5)
		{
			rmPlacePlayer(1, 0.42, 0.15);
			rmPlacePlayer(2, 0.42, 0.85);
		}
		else
		{
			rmPlacePlayer(2, 0.42, 0.15);
			rmPlacePlayer(1, 0.42, 0.85);
		}
		}
	else if ( cNumberTeams <= 2 && teamZeroCount <= 2 && teamOneCount <= 2)
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.40, 0.55); // 0.5
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.38, 0.38, 0);

		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.95, 0.10); // 0.5
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else if ( cNumberTeams <= 2 && teamZeroCount > 2 && teamOneCount > 2)
	{
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.40, 0.65); // 0.5
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.38, 0.38, 0);

		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.85, 0.10); // 0.5
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.38, 0.38, 0);
	}
	else
	{	
		rmSetTeamSpacingModifier(0.70);
		rmPlacePlayersCircular(0.40, 0.40 , 0.0);
	}

// Text
	rmSetStatusText("",0.30);

	// ____________________ Map Parameters ____________________
	// avoid this
	int avoidThisID=rmCreateArea("avoid this");
	rmSetAreaSize(avoidThisID, 0.025);
	rmSetAreaLocation(avoidThisID, 0.4, 0.5);
	rmAddAreaInfluenceSegment(avoidThisID, 0.4, 0.62, 0.4, 0.39);
//	rmSetAreaMix(avoidThisID, "great plains drygrass"); 	// for testing
	rmSetAreaCoherence(avoidThisID, 1.00);
	rmBuildArea(avoidThisID); 
	
	int avoidThis = rmCreateAreaDistanceConstraint("avoid avoid this ", avoidThisID, 4.0);
	int avoidThisMin = rmCreateAreaDistanceConstraint("avoid avoid this min", avoidThisID, 0.5);
	int avoidThisFar = rmCreateAreaDistanceConstraint("avoid avoid this far", avoidThisID, 8.0);
	int stayInThis = rmCreateAreaMaxDistanceConstraint("stay avoid this ", avoidThisID, 0.0);

	// Place Trade Route - Sockets Later
	int tradeRouteID = rmCreateTradeRoute();

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(socketID, avoidThis);

	if (TeamNum == 2 && teamOneCount == teamZeroCount)
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.01);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.25);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.36, 0.30);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.40);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.50); // center
	rmAddTradeRouteWaypoint(tradeRouteID, 0.32, 0.60);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.36, 0.70);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.75);
	if (TeamNum == 2 && teamOneCount == teamZeroCount)
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.99);
		
	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
	
	// Continent
	int continentID = rmCreateArea("continent");
	rmSetAreaLocation(continentID, 0.5, 0.5);
	rmSetAreaWarnFailure(continentID, false);
	rmSetAreaSize(continentID,0.99, 0.99);
	rmSetAreaCoherence(continentID, 1.0);
	rmSetAreaBaseHeight(continentID, 0.0);
	rmSetAreaObeyWorldCircleConstraint(continentID, false);
	rmSetAreaMix(continentID, "sonora_dirt");  
	rmBuildArea(continentID); 

	// Player area
	for (i=1; < numPlayer){
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID,rmAreaTilesToFraction(121), rmAreaTilesToFraction(169));
		rmSetAreaCoherence(playerareaID, 0.00);
		rmSetAreaWarnFailure(playerareaID, false);
		rmSetAreaTerrainType(playerareaID, "sonora\groundforest_son"); 
		rmSetAreaLocPlayer(playerareaID, i);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmAddAreaToClass(playerareaID, classPlayer);
		rmBuildArea(playerareaID);
		int avoidPlayerArea = rmCreateAreaMaxDistanceConstraint("avoid in player area "+i, playerareaID, 4.0);
		int avoidPlayerAreaFar = rmCreateAreaMaxDistanceConstraint("avoid in player area far "+i, playerareaID, 30.0);
		int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
		}

	// Place TR Sockets
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.395-0.0005*PlayerNum);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.525-0.001*PlayerNum);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.64+0.0005*PlayerNum);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	// Central Zones
	int centralID = rmCreateArea("central");
	rmSetAreaSize(centralID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
	rmSetAreaLocation(centralID, 0.60, 0.50);
	rmSetAreaWarnFailure(centralID, false);
//	rmSetAreaMix(centralID, "california_grass");		// for testing
	rmSetAreaCoherence(centralID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(centralID, false);
	rmBuildArea(centralID);	

	int avoidCentral = rmCreateAreaDistanceConstraint("avoid central zone ", centralID, 20.0);
	int avoidCentralMin = rmCreateAreaDistanceConstraint("avoid central zone min ", centralID, 0.5);
	int avoidCentralShort = rmCreateAreaDistanceConstraint("avoid central zone short ", centralID, 12.0);
	int stayCentral = rmCreateAreaMaxDistanceConstraint("stay in central zone ", centralID, 0.0);	

	int centralSmallID = rmCreateArea("central small");
	rmSetAreaSize(centralSmallID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
	rmSetAreaLocation(centralSmallID, 0.60, 0.50);
	rmSetAreaWarnFailure(centralSmallID, false);
//	rmSetAreaMix(centralSmallID, "testmix");		// for testing
	rmSetAreaCoherence(centralSmallID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(centralSmallID, false);
	rmBuildArea(centralSmallID);	

	int avoidCentralSmall = rmCreateAreaDistanceConstraint("avoid central small zone ", centralSmallID, 20.0);
	int avoidCentralSmallMin = rmCreateAreaDistanceConstraint("avoid central small zone min ", centralSmallID, 0.5);
	int avoidCentralSmallShort = rmCreateAreaDistanceConstraint("avoid central small zone short ", centralSmallID, 12.0);
	int stayCentralSmall = rmCreateAreaMaxDistanceConstraint("stay in central small zone ", centralSmallID, 0.0);	
	
	// ____________________ Natives ____________________
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID("maya");
	subCiv1 = rmGetCivID("apache");
	subCiv2 = rmGetCivID("navajo");
	rmSetSubCiv(0, "maya");
	rmSetSubCiv(1, "apache");
	rmSetSubCiv(2, "navajo");

	int villageType = rmRandInt(1,5);

	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;

	int whichNative = rmRandInt(1,3);

	if (whichNative == 1) {
		nativeID0 = rmCreateGrouping("maya A", "native maya village "+villageType);
		nativeID1 = rmCreateGrouping("maya B", "native maya village "+villageType);
		nativeID2 = rmCreateGrouping("navajo A", "native navajo village "+villageType);
		nativeID3 = rmCreateGrouping("navajo B", "native navajo village "+villageType);
	}
	else if (whichNative == 2) {
		nativeID0 = rmCreateGrouping("navajo A", "native navajo village "+villageType);
		nativeID1 = rmCreateGrouping("navajo B", "native navajo village "+villageType);
		nativeID2 = rmCreateGrouping("maya A", "native maya village "+villageType);
		nativeID3 = rmCreateGrouping("maya B", "native maya village "+villageType);
	}	
	else if (whichNative == 3) {
		nativeID0 = rmCreateGrouping("apache A", "native apache village "+villageType);
		nativeID1 = rmCreateGrouping("apache B", "native apache village "+villageType);
		nativeID2 = rmCreateGrouping("maya A", "native maya village "+villageType);
		nativeID3 = rmCreateGrouping("maya B", "native maya village "+villageType);
	}
	else if (whichNative == 4) {
		nativeID0 = rmCreateGrouping("maya A", "native maya village "+villageType);
		nativeID1 = rmCreateGrouping("maya B", "native maya village "+villageType);
		nativeID2 = rmCreateGrouping("apache A", "native apache village "+villageType);
		nativeID3 = rmCreateGrouping("apache B", "native apache village "+villageType);
		}
	else if (whichNative == 5) {
		nativeID0 = rmCreateGrouping("apache A", "native apache village "+villageType);
		nativeID1 = rmCreateGrouping("apache B", "native apache village "+villageType);
		nativeID2 = rmCreateGrouping("navajo A", "native navajo village "+villageType);
		nativeID3 = rmCreateGrouping("navajo B", "native navajo village "+villageType);
		}
	else {
		nativeID0 = rmCreateGrouping("navajo A", "native navajo village "+villageType);
		nativeID1 = rmCreateGrouping("navajo B", "native navajo village "+villageType);
		nativeID2 = rmCreateGrouping("apache A", "native apache village "+villageType);
		nativeID3 = rmCreateGrouping("apache B", "native apache village "+villageType);
	}
		
	rmAddGroupingToClass(nativeID0, classNative);
	rmAddGroupingToClass(nativeID1, classNative);
	rmAddGroupingToClass(nativeID2, classNative);
	rmAddGroupingToClass(nativeID3, classNative);

	if (TeamNum > 2) {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.60);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.40, 0.40);
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.70, 0.40);
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.70, 0.60);
		}
	else if (PlayerNum == 2) {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.80, 0.70);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.80, 0.30);		
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.20, 0.70);		
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.20, 0.30);		
	}
	else {
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.80, 0.60);
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.80, 0.40);		
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.20, 0.60);		
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.20, 0.40);		
	}

	// ____________________ KOTH ____________________
  if(rmGetIsKOTH() == true) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.00;
    float yLoc = 0.00;
    float walk = 0.00;
	
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		xLoc = 0.15;
		yLoc = 0.50;
	}
	else {
		xLoc = 0.40;
		yLoc = 0.50;
	}
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
   }

    int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 8.0);

	// ____________________ Mid Features ____________________
	int classAvoidance = rmDefineClass("avoidance");

	int avoidTHisID=rmCreateArea("avoid this island");
	rmSetAreaSize(avoidTHisID, 0.025);
	rmSetAreaLocation(avoidTHisID, 0.65, 0.5);
	if (rmRandFloat(0,1) > 0.5)
		rmAddAreaInfluenceSegment(avoidTHisID, 0.65, 0.75, 0.65, 0.25);
	else
		rmAddAreaInfluenceSegment(avoidTHisID, 0.90, 0.50, 0.30, 0.50);
	rmAddAreaToClass(avoidTHisID, classAvoidance);
//	rmSetAreaMix(avoidTHisID, forTesting);
	rmSetAreaCoherence(avoidTHisID, 1.00);
	rmBuildArea(avoidTHisID); 

	int whichFeature = rmRandInt (1,3);
//		whichFeature = 1;	// for testing

	// Feature 1 - Canyon with Res
	int bisonCanyonID = rmCreateArea("bison canyon");
	rmSetAreaSize(bisonCanyonID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200)); 
	rmAddAreaToClass(bisonCanyonID, classFeature);
	rmSetAreaWarnFailure(bisonCanyonID, false);
	rmSetAreaObeyWorldCircleConstraint(bisonCanyonID, true);
	rmSetAreaCliffType(bisonCanyonID, "sonora"); 
	rmSetAreaTerrainType(bisonCanyonID, "sonora\ground1_son");
	rmSetAreaCliffHeight(bisonCanyonID, -10, 0.0, 0.8);
	rmSetAreaCliffEdge(bisonCanyonID, 2, 0.40, 0.0, 1.0, 0);
	rmSetAreaCliffPainting(bisonCanyonID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaReveal(bisonCanyonID, 01);
	rmSetAreaCoherence(bisonCanyonID, 0.65);
	rmSetAreaSmoothDistance(bisonCanyonID, 2);
	rmSetAreaLocation(bisonCanyonID, 0.65, 0.50);
	rmAddAreaInfluenceSegment(bisonCanyonID, 0.55, 0.50, 0.75, 0.50);
	rmAddAreaInfluenceSegment(bisonCanyonID, 0.65, 0.50, 0.65, 0.55);
	rmAddAreaInfluenceSegment(bisonCanyonID, 0.65, 0.50, 0.65, 0.45);
	rmAddAreaCliffEdgeAvoidClass(bisonCanyonID, classAvoidance, 1);
	rmAddAreaConstraint(bisonCanyonID, avoidTradeRouteShort);
	rmAddAreaConstraint(bisonCanyonID, avoidTradeRouteSocket);
	rmAddAreaConstraint(bisonCanyonID, avoidNativesShort);
	rmAddAreaConstraint(bisonCanyonID, avoidKOTH);
	
	int avoidBisonCanyon = rmCreateAreaDistanceConstraint("avoid bison canyon", bisonCanyonID, 12);
	int avoidBisonCanyonMin = rmCreateAreaDistanceConstraint("avoid bison canyon min", bisonCanyonID, 0.5);
	int avoidBisonCanyonFar = rmCreateAreaDistanceConstraint("avoid bison canyon far", bisonCanyonID, 24);
	int stayBisonCanyon = rmCreateAreaMaxDistanceConstraint("stay in bison canyon", bisonCanyonID, 0);

	int whereEagles = rmRandInt (1,3);
	float xSpot = 0.00;
		if (whereEagles == 1)
			xSpot = 0.60;
		else if (whereEagles == 2)
			xSpot = 0.65;
		else 
			xSpot = 0.70;
		
	int mountain1ID = rmCreateArea("mountain1");
	rmSetAreaLocation(mountain1ID, xSpot, 0.50);
	rmSetAreaSize(mountain1ID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(70)); 
	rmSetAreaWarnFailure(mountain1ID, false);
	rmSetAreaObeyWorldCircleConstraint(mountain1ID, true);
	rmSetAreaCliffType(mountain1ID, "sonora"); 
	rmSetAreaTerrainType(mountain1ID, "sonora\ground1_son");
	rmSetAreaCliffPainting(mountain1ID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(mountain1ID, 4, 0.0, 0.8);
	rmSetAreaCliffEdge(mountain1ID, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCoherence(mountain1ID, 0.90);

	int avoidMountain1 = rmCreateAreaDistanceConstraint("avoid mountain1", mountain1ID, 12);
	int avoidMountain1Min = rmCreateAreaDistanceConstraint("avoid mountain1 min", mountain1ID, 04);
	int avoidMountain1Short = rmCreateAreaDistanceConstraint("avoid mountain1 short", mountain1ID, 08);
	int avoidMountain1Far = rmCreateAreaDistanceConstraint("avoid mountain1 far", mountain1ID, 24);
	int stayMountain1 = rmCreateAreaMaxDistanceConstraint("stay in mountain1", mountain1ID, 0);

	int mountain2ID = rmCreateArea("mountain2");
	rmSetAreaLocation(mountain2ID, xSpot, 0.50);
	rmSetAreaSize(mountain2ID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50)); 
	rmSetAreaWarnFailure(mountain2ID, false);
	rmSetAreaObeyWorldCircleConstraint(mountain2ID, true);
	rmSetAreaCliffType(mountain2ID, "sonora"); 
	rmSetAreaTerrainType(mountain2ID, "sonora\ground1_son");
	rmSetAreaCliffPainting(mountain2ID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(mountain2ID, 5, 0.0, 0.8);
	rmSetAreaCliffEdge(mountain2ID, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCoherence(mountain2ID, 0.80);

	int avoidMountain2 = rmCreateAreaDistanceConstraint("avoid mountain2", mountain2ID, 12);
	int avoidMountain2Short = rmCreateAreaDistanceConstraint("avoid mountain2 short", mountain2ID, 08);
	int avoidMountain2Min = rmCreateAreaDistanceConstraint("avoid mountain2 min", mountain2ID, 0.5);
	int avoidMountain2Far = rmCreateAreaDistanceConstraint("avoid mountain2 far", mountain2ID, 24);
	int stayMountain2 = rmCreateAreaMaxDistanceConstraint("stay in mountain2", mountain2ID, 0);

	int mountain3ID = rmCreateArea("mountain3");
	rmSetAreaLocation(mountain3ID, xSpot, 0.50);
	rmSetAreaSize(mountain3ID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(30));
	rmSetAreaWarnFailure(mountain3ID, false);
	rmSetAreaObeyWorldCircleConstraint(mountain3ID, true);
	rmSetAreaCliffType(mountain3ID, "sonora"); 
	rmSetAreaTerrainType(mountain3ID, "sonora\ground1_son");
	rmSetAreaCliffPainting(mountain3ID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(mountain3ID, 6, 0.0, 0.8);
	rmSetAreaCliffEdge(mountain3ID, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCoherence(mountain3ID, 0.70);

	int avoidMountain3 = rmCreateAreaDistanceConstraint("avoid mountain3", mountain3ID, 12);
	int avoidMountain3Short = rmCreateAreaDistanceConstraint("avoid mountain3 short", mountain3ID, 08);
	int avoidMountain3Min = rmCreateAreaDistanceConstraint("avoid mountain3 min", mountain3ID, 0.5);
	int avoidMountain3Far = rmCreateAreaDistanceConstraint("avoid mountain3 far", mountain3ID, 24);
	int stayMountain3 = rmCreateAreaMaxDistanceConstraint("stay in mountain3", mountain3ID, 0);

	int EaglesID = rmCreateObjectDef("eagles rocks");
	rmAddObjectDefItem(EaglesID, "PropEaglesRocks", 1, 0);
	rmSetObjectDefMinDistance(EaglesID, 0);
	rmSetObjectDefMaxDistance(EaglesID, 0);
	rmSetObjectDefForceFullRotation(EaglesID, true);
	
	int canyonGoldID = rmCreateObjectDef("canyon mines");
	rmAddObjectDefItem(canyonGoldID, "Mine", 1, 0.0);
	rmSetObjectDefMinDistance(canyonGoldID, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(canyonGoldID, rmXFractionToMeters(0.10));
	rmAddObjectDefToClass(canyonGoldID, classGold);
	rmAddObjectDefConstraint(canyonGoldID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(canyonGoldID, avoidMountain1Min);
	rmAddObjectDefConstraint(canyonGoldID, stayBisonCanyon);

	int canyonBisonID = rmCreateObjectDef("canyon bison");
	rmAddObjectDefItem(canyonBisonID, "bison", 9, 4.0);
	rmSetObjectDefMinDistance(canyonBisonID, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(canyonBisonID, rmXFractionToMeters(0.10));
	rmSetObjectDefCreateHerd(canyonBisonID, true);
	rmAddObjectDefConstraint(canyonBisonID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(canyonBisonID, avoidBisonShort);
	rmAddObjectDefConstraint(canyonBisonID, avoidMountain1Short);
	rmAddObjectDefConstraint(canyonBisonID, stayBisonCanyon);
	
	// Feature 2 - Empty Canyon
	int bigCanyonID = rmCreateArea("big canyon");
	rmSetAreaSize(bigCanyonID, rmAreaTilesToFraction(777+25*PlayerNum), rmAreaTilesToFraction(777+25*PlayerNum)); 
	rmSetAreaWarnFailure(bigCanyonID, false);
	rmAddAreaToClass(bigCanyonID, classFeature);
	rmSetAreaObeyWorldCircleConstraint(bigCanyonID, true);
	rmSetAreaCliffType(bigCanyonID, "sonora"); 
	rmSetAreaTerrainType(bigCanyonID, "sonora\ground1_son");
	rmSetAreaCliffHeight(bigCanyonID, -16, 0.0, 0.8);
	rmSetAreaCliffEdge(bigCanyonID, 1.0, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffPainting(bigCanyonID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCoherence(bigCanyonID, 0.65);
	rmSetAreaSmoothDistance(bigCanyonID, 2);
	rmSetAreaReveal(bigCanyonID, 01);
	rmSetAreaLocation(bigCanyonID, 0.65, 0.50);
	rmAddAreaInfluenceSegment(bigCanyonID, 0.55, 0.50, 0.70, 0.50);
	rmAddAreaInfluenceSegment(bigCanyonID, 0.65, 0.50, 0.65, 0.55);
	rmAddAreaInfluenceSegment(bigCanyonID, 0.65, 0.50, 0.65, 0.45);
//	rmAddAreaInfluenceSegment(bigCanyonID, 0.65, 0.50, 0.80, 0.50);
//	rmAddAreaInfluenceSegment(bigCanyonID, 0.65, 0.50, 0.60, 0.40);
//	rmAddAreaInfluenceSegment(bigCanyonID, 0.65, 0.50, 0.60, 0.60);
	rmAddAreaInfluenceSegment(bigCanyonID, 0.65, 0.50, 0.52, 0.52);
	rmAddAreaConstraint(bigCanyonID, avoidTradeRouteShort);
	rmAddAreaConstraint(bigCanyonID, avoidTradeRouteSocket);
	rmAddAreaConstraint(bigCanyonID, avoidNativesShort);
	rmAddAreaConstraint(bigCanyonID, avoidKOTH);

	int avoidBigCanyon = rmCreateAreaDistanceConstraint("avoid big canyon", bigCanyonID, 12);
	int avoidBigCanyonMin = rmCreateAreaDistanceConstraint("avoid big canyon min", bigCanyonID, 0.5);
	int avoidBigCanyonFar = rmCreateAreaDistanceConstraint("avoid big canyon far", bigCanyonID, 24);
	int stayBigCanyon = rmCreateAreaMaxDistanceConstraint("stay in big canyon", bigCanyonID, 0);
	
	int mountain4ID = rmCreateArea("mountain4");
	rmSetAreaLocation(mountain4ID, 0.65, 0.50);
	rmSetAreaSize(mountain4ID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
	rmSetAreaWarnFailure(mountain4ID, false);
	rmSetAreaObeyWorldCircleConstraint(mountain4ID, true);
	rmSetAreaCliffType(mountain4ID, "sonora"); 
	rmSetAreaTerrainType(mountain4ID, "sonora\ground1_son");
	rmSetAreaCliffPainting(mountain4ID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(mountain4ID, 16, 0.0, 0.8);
	rmSetAreaCliffEdge(mountain4ID, 1, 1.0, 0.0, 1.0, 0);
	rmSetAreaCoherence(mountain4ID, 0.70);

	// Feature 3 - Mesa with Mines Around
	int mesaGoldID = rmCreateObjectDef("mesa mines");
	rmAddObjectDefItem(mesaGoldID, "Mine", 1, 0.0);
	rmSetObjectDefMinDistance(mesaGoldID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(mesaGoldID, rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(mesaGoldID, classGold);
	rmAddObjectDefConstraint(mesaGoldID, avoidGoldMed);
	rmAddObjectDefConstraint(mesaGoldID, stayCentral);
	rmAddObjectDefConstraint(mesaGoldID, avoidCentralSmallMin);
    
	int bigMesaID = rmCreateArea("big mesa");
	rmSetAreaSize(bigMesaID, rmAreaTilesToFraction(425), rmAreaTilesToFraction(425)); 
	rmAddAreaToClass(bigMesaID, classFeature);
	rmSetAreaWarnFailure(bigMesaID, false);
	rmSetAreaObeyWorldCircleConstraint(bigMesaID, true);
	rmSetAreaCliffType(bigMesaID, "sonora"); 
	rmSetAreaTerrainType(bigMesaID, "sonora\ground1_son");
	rmSetAreaCliffHeight(bigMesaID, 10, 0.0, 0.8);
	rmSetAreaCliffEdge(bigMesaID, 1.0, 1.0, 0.0, 1.0, 0);
	rmSetAreaCliffPainting(bigMesaID, true, true, true, 0, true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCoherence(bigMesaID, 0.55);
	rmSetAreaSmoothDistance(bigMesaID, 2);
	rmSetAreaReveal(bigMesaID, 01);
	rmSetAreaLocation(bigMesaID, 0.60, 0.50);
	rmAddAreaConstraint(bigMesaID, avoidGoldMin);
	rmAddAreaConstraint(bigMesaID, avoidKOTH);
	rmAddAreaConstraint(bigMesaID, avoidNatives);
    
	int avoidBigMesa = rmCreateAreaDistanceConstraint("avoid big mesa", bigMesaID, 12);
	int avoidBigMesaMin = rmCreateAreaDistanceConstraint("avoid big mesa min", bigMesaID, 0.5);
	int avoidBigMesaFar = rmCreateAreaDistanceConstraint("avoid big mesa far", bigMesaID, 24);
	int stayBigMesa = rmCreateAreaMaxDistanceConstraint("stay in big mesa", bigMesaID, 0);	
   
	if (whichFeature == 1) {
		rmBuildArea(bisonCanyonID);
		rmBuildArea(mountain1ID);
		rmBuildArea(mountain2ID);
		rmBuildArea(mountain3ID);
		rmPlaceObjectDefAtLoc(EaglesID, 0,xSpot, 0.50);
		rmPlaceObjectDefAtLoc(canyonGoldID, 0, 0.65, 0.50, 2);
		rmPlaceObjectDefAtLoc(canyonBisonID, 0, 0.65, 0.50, 2);
	}
	else if (whichFeature == 2) {
		rmBuildArea(bigCanyonID);
		rmBuildArea(mountain4ID);
		}
	else {
		rmPlaceObjectDefAtLoc(mesaGoldID, 0, 0.60, 0.50, 4);
		rmBuildArea(bigMesaID);
		}
		
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
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 20.0);
	rmSetObjectDefMaxDistance(playergoldID, 20.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 20.0);
	rmSetObjectDefMaxDistance(playergold2ID, 20.0);
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidGold);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playergold2ID, avoidBisonCanyon);
	
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeSonora", 10, 7.0);
    rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 24);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);

	int playerTree2ID = rmCreateObjectDef("player trees2");
	rmAddObjectDefItem(playerTree2ID, "TreeSonora", 10, 8.0);
    rmSetObjectDefMinDistance(playerTree2ID, 36);
    rmSetObjectDefMaxDistance(playerTree2ID, 40);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocketShort);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 4, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 16.0);
	rmSetObjectDefMaxDistance(playerberriesID, 16.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResourcesShort);
	
	// Starting herd
	int playerherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerherdID, "pronghorn", 8, 4.0);
	rmSetObjectDefMinDistance(playerherdID, 16);
	rmSetObjectDefMaxDistance(playerherdID, 16);
	rmSetObjectDefCreateHerd(playerherdID, true);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int player2ndherdID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(player2ndherdID, "pronghorn", 8, 6.0);
    rmSetObjectDefMinDistance(player2ndherdID, 32);
    rmSetObjectDefMaxDistance(player2ndherdID, 33);
	rmAddObjectDefToClass(player2ndherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player2ndherdID, true);
	rmAddObjectDefConstraint(player2ndherdID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(player2ndherdID, avoidEdge);
	rmAddObjectDefConstraint(player2ndherdID, avoidTradeRouteSocketShort);
		
	// 3nd herd
	int player3rdherdID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(player3rdherdID, "pronghorn", 8, 6.0);
    rmSetObjectDefMinDistance(player3rdherdID, 42);
    rmSetObjectDefMaxDistance(player3rdherdID, 44);
	rmAddObjectDefToClass(player3rdherdID, classStartingResource);
	rmSetObjectDefCreateHerd(player3rdherdID, true);
	rmAddObjectDefConstraint(player3rdherdID, avoidEdge);
	rmAddObjectDefConstraint(player3rdherdID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(player3rdherdID, avoidStartingResourcesMin);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 30.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 40.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketMin);
	int nugget0count = rmRandInt (1,2);
	
	//  Place Starting Objects/Resources
	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (PlayerNum == 2)
			rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(player2ndherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (TeamNum > 2)
			rmPlaceObjectDefAtLoc(player3rdherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (teamZeroCount == teamOneCount) {
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			}
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}
	
	// Text
	rmSetStatusText("",0.60);

	// ____________________ Gold ____________________
	// COIN RESOURCES
	int silverID = -1;
		silverID = rmCreateObjectDef("silver");
		rmAddObjectDefItem(silverID, "mine", 1, 0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		if (PlayerNum > 2)
			rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.45));
		else
			rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.05));
		rmAddObjectDefToClass(silverID, classGold);
		rmAddObjectDefConstraint(silverID, avoidTownCenterFar);
		rmAddObjectDefConstraint(silverID, avoidFeatureShort);
		rmAddObjectDefConstraint(silverID, avoidNativesShort);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(silverID, avoidKOTH);
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(silverID, avoidGoldFar);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5, 3*PlayerNum);
	}
		else {
			rmAddObjectDefConstraint(silverID, avoidGold);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.70, 0.85);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.70, 0.15);
			if (whichFeature == 2)
				rmPlaceObjectDefAtLoc(silverID, 0, 0.275, 0.50);
	else
				rmPlaceObjectDefAtLoc(silverID, 0, 0.10, 0.50);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.90, 0.50);
			if (whichFeature == 2) {
				rmPlaceObjectDefAtLoc(silverID, 0, 0.15, 0.30);
				rmPlaceObjectDefAtLoc(silverID, 0, 0.15, 0.70);
				}
	}

	// ____________________ Cliffs and Canyons ____________________
		int kliffHite=rmRandInt(1,2);
		
	for (i=0; <10+PlayerNum)
	{
		int mesaID=rmCreateArea("mesa"+i);
		rmSetAreaSize(mesaID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));		
		rmSetAreaWarnFailure(mesaID, false);
		rmSetAreaObeyWorldCircleConstraint(mesaID, true);
		rmAddAreaToClass(mesaID, rmClassID("Cliffs"));
		rmSetAreaCoherence(mesaID, 0.50);
		rmSetAreaCliffType(mesaID, "Sonora");
//		rmSetAreaTerrainType(mesaID, "sonora\ground1_son");  
		if (kliffHite < 2)
		rmSetAreaCliffHeight(mesaID, rmRandInt(4,10), 1.0, 1.0);
		else
		rmSetAreaCliffHeight(mesaID, -15, 1.0, 1.0);
		rmSetAreaCliffEdge(mesaID, 1, 1.0, 0.0, 0.0, 1);
		rmAddAreaConstraint(mesaID, avoidTownCenter);
		rmAddAreaConstraint(mesaID, avoidGoldShort);
		rmAddAreaConstraint(mesaID, avoidCliffFar);
		rmAddAreaConstraint(mesaID, avoidTradeRouteMin);
		rmAddAreaConstraint(mesaID, avoidTradeRouteSocket);
		rmAddAreaConstraint(mesaID, avoidFeatureFar);
		rmAddAreaConstraint(mesaID, avoidNatives);
		rmAddAreaConstraint(mesaID, avoidNomad);
		rmAddAreaConstraint(mesaID, avoidStartingResourcesShort);
		rmAddAreaConstraint(mesaID, avoidKOTH);
		rmBuildArea(mesaID);
		}
	
	for (i=0; <10*PlayerNum)
	{
		int smallmesaID=rmCreateArea("small mesa"+i);
		rmSetAreaSize(smallmesaID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(20));		
		rmSetAreaWarnFailure(smallmesaID, false);
		rmSetAreaObeyWorldCircleConstraint(smallmesaID, true);
		rmAddAreaToClass(smallmesaID, rmClassID("Cliffs"));
		rmSetAreaCoherence(smallmesaID, 0.30);
		rmSetAreaCliffType(smallmesaID, "Sonora Slim");  
//		rmSetAreaTerrainType(smallmesaID, "sonora\ground1_son");  
		if (kliffHite < 2)
			rmSetAreaCliffHeight(mesaID, rmRandInt(3,6), 1.0, 1.0);
		else
			rmSetAreaCliffHeight(mesaID, -10, 1.0, 1.0);
		rmSetAreaCliffEdge(smallmesaID, 1, 1.0, 0.0, 0.0, 1);
		rmAddAreaConstraint(smallmesaID, avoidTownCenterShort);
		rmAddAreaConstraint(smallmesaID, avoidStartingResourcesShort);
		rmAddAreaConstraint(smallmesaID, avoidGoldShort);
		rmAddAreaConstraint(smallmesaID, avoidCliff);
		rmAddAreaConstraint(smallmesaID, avoidTradeRouteMin);
		rmAddAreaConstraint(smallmesaID, avoidTradeRouteSocket);
		rmAddAreaConstraint(smallmesaID, avoidFeatureShort);
		rmAddAreaConstraint(smallmesaID, avoidNativesShort);
		rmAddAreaConstraint(smallmesaID, avoidKOTH);
		rmBuildArea(smallmesaID);
	}

	// Text
	rmSetStatusText("",0.70);
		
	// ____________________ Other Resources ____________________
	// Trees
	int treesID = rmCreateObjectDef("trees");
	rmAddObjectDefItem(treesID, "TreeSonora", 6, 4.0);
	rmSetObjectDefMinDistance(treesID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(treesID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(treesID, classForest);
	rmAddObjectDefConstraint(treesID, avoidTownCenterVeryFar);
	rmAddObjectDefConstraint(treesID, avoidGoldMin);
	rmAddObjectDefConstraint(treesID, avoidForest);
	rmAddObjectDefConstraint(treesID, avoidStartingResources);
	rmAddObjectDefConstraint(treesID, avoidNatives);
	rmAddObjectDefConstraint(treesID, avoidKOTH);
	rmAddObjectDefConstraint(treesID, avoidFeatureShort);
	rmAddObjectDefConstraint(treesID, avoidCliffMin);
	rmAddObjectDefConstraint(treesID, avoidTradeRouteSocket);
//	rmAddObjectDefConstraint(treesID, avoidBisonCanyonFar);
//	rmAddObjectDefConstraint(treesID, avoidBigCanyonFar);
//	rmAddObjectDefConstraint(treesID, avoidBigMesaFar);
	rmPlaceObjectDefAtLoc(treesID, 0, 0.50, 0.50, 10+15*cNumberNonGaiaPlayers);
    
	// Text
	rmSetStatusText("",0.80);
		
	int randTreesID = rmCreateObjectDef("random trees");
	rmAddObjectDefItem(randTreesID, "TreeSonora", 3, 3.0);
	rmSetObjectDefMinDistance(randTreesID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(randTreesID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(randTreesID, classForest);
	rmAddObjectDefConstraint(randTreesID, avoidTownCenterShort);
	rmAddObjectDefConstraint(randTreesID, avoidGoldMin);
	rmAddObjectDefConstraint(randTreesID, avoidForestShort);
	rmAddObjectDefConstraint(randTreesID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(randTreesID, avoidNativesShort);
	rmAddObjectDefConstraint(randTreesID, avoidKOTH);
	rmAddObjectDefConstraint(randTreesID, avoidFeatureShort);
	rmAddObjectDefConstraint(randTreesID, avoidCliffMin);
	rmAddObjectDefConstraint(randTreesID, avoidTradeRouteSocketShort);
//	rmAddObjectDefConstraint(randTreesID, avoidBisonCanyonFar);
//	rmAddObjectDefConstraint(randTreesID, avoidBigCanyonFar);
//	rmAddObjectDefConstraint(randTreesID, avoidBigMesaFar);
	rmPlaceObjectDefAtLoc(randTreesID, 0, 0.50, 0.50, 5*cNumberNonGaiaPlayers);
    
	// Hunts 
	int mapBisonID = -1;
		mapBisonID = rmCreateObjectDef("map bison");
		rmAddObjectDefItem(mapBisonID, "bison", 7, 4.0);
		rmSetObjectDefMinDistance(mapBisonID, 0.0);
		if (PlayerNum > 2)
			rmSetObjectDefMaxDistance(mapBisonID, rmXFractionToMeters(0.45));
		else
			rmSetObjectDefMaxDistance(mapBisonID, rmXFractionToMeters(0.05));
		rmSetObjectDefCreateHerd(mapBisonID, true);
		rmAddObjectDefConstraint(mapBisonID, avoidTownCenter);
		rmAddObjectDefConstraint(mapBisonID, avoidStartingResourcesMin);
		rmAddObjectDefConstraint(mapBisonID, avoidFeatureShort);
		rmAddObjectDefConstraint(mapBisonID, avoidNativesShort);
		rmAddObjectDefConstraint(mapBisonID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(mapBisonID, avoidPropMin);
		rmAddObjectDefConstraint(mapBisonID, avoidCliffMin);
		rmAddObjectDefConstraint(mapBisonID, avoidGoldMin);
		rmAddObjectDefConstraint(mapBisonID, avoidForestMin);
		rmAddObjectDefConstraint(mapBisonID, avoidKOTH);
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(mapBisonID, avoidBisonFar);
			rmAddObjectDefConstraint(mapBisonID, avoidPronghorn);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.5, 0.5, 3*PlayerNum);
			}
		else {
			rmAddObjectDefConstraint(mapBisonID, avoidBison);
			rmAddObjectDefConstraint(mapBisonID, avoidPronghornShort);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.70, 0.85);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.70, 0.15);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.275, 0.50);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.10, 0.50);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.90, 0.50);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.15, 0.30);
			rmPlaceObjectDefAtLoc(mapBisonID, 0, 0.15, 0.70);
			}
    
	int mapPronghornID = rmCreateObjectDef("1v1 pronghorn");
	rmAddObjectDefItem(mapPronghornID, "pronghorn", 8, 4.0);
	rmSetObjectDefMinDistance(mapPronghornID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(mapPronghornID, rmXFractionToMeters(0.05));
	rmSetObjectDefCreateHerd(mapPronghornID, true);
	rmAddObjectDefConstraint(mapPronghornID, avoidTownCenterMed);
	rmAddObjectDefConstraint(mapPronghornID, avoidNativesShort);
	rmAddObjectDefConstraint(mapPronghornID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(mapPronghornID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(mapPronghornID, avoidCliffMin);
	rmAddObjectDefConstraint(mapPronghornID, avoidFeatureMin);
	rmAddObjectDefConstraint(mapPronghornID, avoidKOTH);
	if (PlayerNum == 2) {
		rmPlaceObjectDefAtLoc(mapPronghornID, 0, 0.75, 0.35);
		rmPlaceObjectDefAtLoc(mapPronghornID, 0, 0.75, 0.65);
		if (whichFeature > 1) {
			rmPlaceObjectDefAtLoc(mapPronghornID, 0, 0.55, 0.30);
			rmPlaceObjectDefAtLoc(mapPronghornID, 0, 0.55, 0.70);
			}
		rmPlaceObjectDefAtLoc(mapPronghornID, 0, 0.30, 0.30);
		rmPlaceObjectDefAtLoc(mapPronghornID, 0, 0.30, 0.70);
	}

	// Text
	rmSetStatusText("",0.90);

	// Treasures 
	int treasure12count = 6+PlayerNum;
	int treasure23count = 2+PlayerNum;
	int treasure34count = PlayerNum/2;

	// Treasures L3 OR 4
	for (i=0; < treasure34count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget lvl34 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.05));
		else
			rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.25));
		if (PlayerNum == 2 || rmGetIsTreaty() == true)
			rmSetNuggetDifficulty(3,3);
		else if (PlayerNum < 5)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(4,4);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidBisonMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidPronghornMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidKOTH);	
		if (whichFeature > 1)
			rmAddObjectDefConstraint(Nugget3ID, avoidFeatureShort); 
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocketMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterVeryFar); 
		rmAddObjectDefConstraint(Nugget3ID, avoidCliffMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidNativesShort); 
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandShort); 
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, PlayerNum/2);
	}

	// Treasures L2 or 3	
	for (i=0; < treasure23count)
	{
		int Nugget2ID = rmCreateObjectDef("nugget lvl23 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.40));
		if (PlayerNum == 2)
			rmSetNuggetDifficulty(2,2);
		else if (PlayerNum < 5)
			rmSetNuggetDifficulty(2,2);
		else
			rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget2ID, avoidKOTH);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidBisonMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidPronghornMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);	
		rmAddObjectDefConstraint(Nugget2ID, avoidCliffMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidFeatureShort); 
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandShort); 
		rmAddObjectDefConstraint(Nugget2ID, avoidNativesShort); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}

	// Treasures L1 or 2
	for (i=0; < treasure12count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget lvl12 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, rmXFractionToMeters(0.15));
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.50));
		if (PlayerNum < 5)
			rmSetNuggetDifficulty(1,1);
		else
			rmSetNuggetDifficulty(1,2);
		rmAddObjectDefConstraint(Nugget1ID, avoidKOTH);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidBisonMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidPronghornMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenterFar);	
		rmAddObjectDefConstraint(Nugget1ID, avoidCliffMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidFeatureShort); 
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandShort); 
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesShort); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
   }

	// Props 
	int randomVultureTreeID=rmCreateObjectDef("random vulture tree");
	rmAddObjectDefItem(randomVultureTreeID, "PropVulturePerching", 1, 1.0);
	rmAddObjectDefToClass(randomVultureTreeID, rmClassID("prop"));
	rmSetObjectDefMinDistance(randomVultureTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomVultureTreeID, rmXFractionToMeters(0.50));
    rmAddObjectDefConstraint(randomVultureTreeID, avoidTownCenterShort);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidKOTH);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidPropFar);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidForestMin);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidBisonMin);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidPronghornMin);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidNativesShort);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidNuggetMin);
	rmAddObjectDefConstraint(randomVultureTreeID, avoidCliffMin);
	if (whichFeature > 1)
		rmAddObjectDefConstraint(randomVultureTreeID, avoidFeatureMin);
	rmPlaceObjectDefAtLoc(randomVultureTreeID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int buzzardFlockID=rmCreateObjectDef("buzzards");
	rmAddObjectDefItem(buzzardFlockID, "BuzzardFlock", 1, 1.0);
	rmAddObjectDefToClass(buzzardFlockID, rmClassID("prop"));
	rmSetObjectDefMinDistance(buzzardFlockID, 0.0);
	rmSetObjectDefMaxDistance(buzzardFlockID, rmXFractionToMeters(0.30));
	rmAddObjectDefConstraint(buzzardFlockID, avoidPropShort);
	rmAddObjectDefConstraint(buzzardFlockID, avoidKOTH);
	rmAddObjectDefConstraint(buzzardFlockID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(buzzardFlockID, avoidForestMin);
	rmAddObjectDefConstraint(buzzardFlockID, avoidGoldMin);
	rmAddObjectDefConstraint(buzzardFlockID, avoidBisonMin);
	rmAddObjectDefConstraint(buzzardFlockID, avoidPronghornMin);
	rmAddObjectDefConstraint(buzzardFlockID, avoidFeatureMin);
	rmAddObjectDefConstraint(buzzardFlockID, avoidTownCenter);
	rmAddObjectDefConstraint(buzzardFlockID, avoidNativesShort);
	rmAddObjectDefConstraint(buzzardFlockID, avoidNuggetMin);
	rmPlaceObjectDefAtLoc(buzzardFlockID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	  // PAROT decorative particle 
	int particleDecorationID=rmCreateObjectDef("Particle Things");
	//int avoidparticleDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "PropDustCloud", 25.0);
	rmAddObjectDefItem(particleDecorationID, "PropDustCloud", 1, 0.0);	
	rmSetObjectDefMinDistance(particleDecorationID, 0.0);
	rmSetObjectDefMaxDistance(particleDecorationID, rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(particleDecorationID, rmClassID("prop"));
	rmAddObjectDefConstraint(particleDecorationID, avoidKOTH);
	rmAddObjectDefConstraint(particleDecorationID, avoidPropMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidTownCenterVeryFar);
	rmAddObjectDefConstraint(particleDecorationID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(particleDecorationID, avoidGoldMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidBisonMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidPronghornMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidForestMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidNuggetMin);
	rmPlaceObjectDefAtLoc(particleDecorationID, 0, 0.5, 0.5, 100);

	rmSetStatusText("",1.00);
} // END