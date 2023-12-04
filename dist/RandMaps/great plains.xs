// GREAT PLAINS
// Nov 06 - YP update
// February 2021 edited by vividlyplain for DE, thanks for the help and advice from Mitoe, Enki_, and JaiLeD! And thanks to Aussie_Drongo for the content while I edited this map. Updated May 2021.

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;
   int subCiv4=-1;
   int subCiv5=-1;

	// Choose which variation to use.  1=southeast trade route, 2=northwest trade route
	int whichMap=rmRandInt(1,2);
	// int whichMap=2;

	// Are there extra meeting poles?
	int extraPoles=rmRandInt(1,2);
	extraPoles=1;
	// int extraPoles=2;

	string natType1 = "";
	string natGrpName1 = "";
	if (rmRandFloat(0,1) <= 0.50)
	{
		natType1 = "Apache";
		natGrpName1 = "native apache village ";
	}
	else
	{
		natType1 = "Comanche";
		natGrpName1 = "native comanche village ";
	}

   if (rmAllocateSubCivs(6) == true)
   {
		subCiv0=rmGetCivID(natType1);
		rmEchoInfo("subCiv0 is "+subCiv0);
		if (subCiv0 >= 0)
			rmSetSubCiv(0, natType1);

		subCiv1=rmGetCivID("Cheyenne");
		rmEchoInfo("subCiv1 is Cheyenne "+subCiv1);
		if (subCiv1 >= 0)
			rmSetSubCiv(1, "Cheyenne");

		subCiv2=rmGetCivID("Cheyenne");
		rmEchoInfo("subCiv2 is Cheyenne "+subCiv2);
		if (subCiv2 >= 0)
			rmSetSubCiv(2, "Cheyenne");
		
		subCiv3=rmGetCivID(natType1);
		rmEchoInfo("subCiv3 is "+subCiv3);
		if (subCiv3 >= 0)
			rmSetSubCiv(3, natType1);
		
		subCiv4=rmGetCivID(natType1);
		rmEchoInfo("subCiv4 is "+subCiv4);
		if (subCiv4 >= 0)
			rmSetSubCiv(4, natType1);
		
		subCiv5=rmGetCivID("Cheyenne");
		rmEchoInfo("subCiv5 is Cheyenne "+subCiv5);
		if (subCiv5 >= 0)
			rmSetSubCiv(5, "Cheyenne");
   }

   // Picks the map size
	int playerTiles=11000;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 9500;
   if (cNumberNonGaiaPlayers >6)
      playerTiles = 8500;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Picks a default water height
	rmSetSeaLevel(0.0);

    // Picks default terrain and water
	rmSetMapElevationParameters(cElevTurbulence, 0.02, 7, 0.5, 8.0);
	rmSetBaseTerrainMix("great plains drygrass");
	rmTerrainInitialize("great_plains\ground1_gp", 5);
	rmSetLightingSet("GreatPlains_Skirmish");
	rmSetMapType("greatPlains");
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetMapType("grass");

	chooseMercs();

	// Define some classes. These are used later for constraints.
	int classPlayer=rmDefineClass("player");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("natives");	
	rmDefineClass("classHillArea");
	rmDefineClass("socketClass");
	rmDefineClass("nuggets");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);
   int nuggetPlayerConstraint=rmCreateClassDistanceConstraint("nuggets stay away from players a lot", classPlayer, 40.0);

   // Resource avoidance
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
   int coinForestConstraint=rmCreateClassDistanceConstraint("coin vs. forest", rmClassID("classForest"), 15.0);
   int avoidBison=rmCreateTypeDistanceConstraint("bison avoids food", "bison", 40.0);
   int avoidBisonShort=rmCreateTypeDistanceConstraint("avoids bison short", "bison", 30.0);
   int avoidPronghornShort=rmCreateTypeDistanceConstraint("avoid pronghorn short", "pronghorn", 12.0);
   int avoidPronghorn=rmCreateTypeDistanceConstraint("pronghorn avoids food", "pronghorn", 40.0);
   int avoidPronghornFar=rmCreateTypeDistanceConstraint("avoid pronghorn far", "pronghorn", 50.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
	int avoidStartingCoin=rmCreateTypeDistanceConstraint("starting coin avoids coin", "gold", 22.0);

	int avoidFastCoin=-1;
	if (cNumberNonGaiaPlayers >6)
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.14));
	}
	else if (cNumberNonGaiaPlayers >4)
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.16));
	}
	else
	{
		avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", rmXFractionToMeters(0.18));
	}

   // Avoid impassable land
   int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

   // Unit avoidance - for things that aren't in the starting resources.
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
   int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
   // int avoidTradeRoutePlayer = rmCreateTradeRouteDistanceConstraint("trade route player", 30.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 15.0);

	int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 8.0);
	int avoidSocketMore=rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 15.0);

   // Constraint to avoid water.
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
   int avoidWater40 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 40.0);

	// Avoid the hilly areas.
	int avoidHills = rmCreateClassDistanceConstraint("avoid Hills", rmClassID("classHillArea"), 5.0);
	
	// natives avoid natives
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid Natives far", rmClassID("natives"), 40.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid Natives", rmClassID("natives"), 20.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// New constraints and stuff added by vividlyplain
	int TeamNum = cNumberTeams;
	int PlayerNum = cNumberNonGaiaPlayers;
	int numPlayer = cNumberPlayers;

	int classIsland=rmDefineClass("island");
	int classStartingResource = rmDefineClass("startingResource");
	int classForest = rmDefineClass("Forest");
	int classGold = rmDefineClass("Gold");
	int classProp = rmDefineClass("prop");

	int avoidTownCenterVeryFar = rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 85.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 70.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 50.0); //46
	int avoidTownCenterMed = rmCreateTypeDistanceConstraint("avoid Town Center med", "townCenter", 60.0);
	int avoidTownCenterShort = rmCreateTypeDistanceConstraint("avoid Town Center short", "townCenter", 30.0);
	int avoidTownCenterMin = rmCreateTypeDistanceConstraint("avoid Town Center min", "townCenter", 18.0);

	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 4.0);

	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest med", rmClassID("Forest"), 26.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 20.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 34.0);
	int avoidForestVeryFar=rmCreateClassDistanceConstraint("avoid forest very far", rmClassID("Forest"), 50.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 10.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);

	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 16.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 24.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold", rmClassID("Gold"), 40.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 50.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 60.0);

	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMin = rmCreatePieConstraint("Avoid Center min",0.5,0.5,rmXFractionToMeters(0.1), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));

	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid Natives short", rmClassID("natives"), 12.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("avoid Natives min", rmClassID("natives"), 4.0);

	int avoidProp = rmCreateClassDistanceConstraint("prop avoid prop", rmClassID("prop"), 10.0);
	int avoidPropFar = rmCreateClassDistanceConstraint("prop avoid prop far", rmClassID("prop"), 20.0);
	int avoidPropVeryFar = rmCreateClassDistanceConstraint("prop avoid prop very far", rmClassID("prop"), 30.0);
	int avoidPropExtreme = rmCreateClassDistanceConstraint("prop avoid prop extremely far", rmClassID("prop"), 40.0);

	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
	
	// Big Mid Island
	int bigIslandID = rmCreateArea("big island");
	rmSetAreaLocation(bigIslandID, 0.50, 0.50);
	rmSetAreaWarnFailure(bigIslandID, false);
	if (cNumberNonGaiaPlayers == 2)
		rmSetAreaSize(bigIslandID,0.55, 0.55);
	else
		rmSetAreaSize(bigIslandID,0.60, 0.60);
	rmSetAreaCoherence(bigIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(bigIslandID, false);
//	rmSetAreaMix(bigIslandID, "testmix");   // for testing
	rmAddAreaToClass(bigIslandID, classIsland);
	rmBuildArea(bigIslandID); 
	
	int avoidBigIslandMin = rmCreateAreaDistanceConstraint("avoid big island min", bigIslandID, 0.5);
	int avoidBigIsland = rmCreateAreaDistanceConstraint("avoid big island", bigIslandID, 13.0);
	int avoidBigIslandFar = rmCreateAreaDistanceConstraint("avoid big island far", bigIslandID, 20.0);
	int stayBigIsland = rmCreateAreaMaxDistanceConstraint("stay in big island", bigIslandID, 0.0);

	// Medium Mid Island
	int islandID = rmCreateArea("island");
	rmSetAreaLocation(islandID, 0.50, 0.50);
	rmSetAreaWarnFailure(islandID, false);
	if (cNumberNonGaiaPlayers == 2)
		rmSetAreaSize(islandID,0.23, 0.23);
	else 
		rmSetAreaSize(islandID,0.42, 0.42);
	rmSetAreaCoherence(islandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(islandID, false);
//	rmSetAreaMix(islandID, "yellow_river_a");   // for testing
	rmAddAreaToClass(islandID, classIsland);
	rmBuildArea(islandID); 
	
	int avoidMedIslandMin = rmCreateAreaDistanceConstraint("avoid med island min", islandID, 0.5);
	int avoidMedIsland = rmCreateAreaDistanceConstraint("avoid med island", islandID, 13.0);
	int avoidMedIslandFar = rmCreateAreaDistanceConstraint("avoid med island far", islandID, 20.0);
	int stayMedIsland = rmCreateAreaMaxDistanceConstraint("stay in med island", islandID, 0.0);

	// Smoll Mid Island
	int smollIslandID = rmCreateArea("smoll island");
	rmSetAreaLocation(smollIslandID, 0.50, 0.50);
	rmSetAreaWarnFailure(smollIslandID, false);
	if (cNumberNonGaiaPlayers == 2)
		rmSetAreaSize(smollIslandID,0.10, 0.10);
	else
		rmSetAreaSize(smollIslandID,0.25, 0.25);
	rmSetAreaCoherence(smollIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(smollIslandID, false);
//	rmSetAreaMix(smollIslandID, "scorched_ground");   // for testing
	rmAddAreaToClass(smollIslandID, classIsland);
	rmBuildArea(smollIslandID); 
	
	int avoidSmollIslandMin = rmCreateAreaDistanceConstraint("avoid smoll island min", smollIslandID, 0.5);
	int avoidSmollIsland = rmCreateAreaDistanceConstraint("avoid smoll island", smollIslandID, 13.0);
	int avoidSmollIslandFar = rmCreateAreaDistanceConstraint("avoid smoll island far", smollIslandID, 20.0);
	int staySmollIsland = rmCreateAreaMaxDistanceConstraint("stay in smoll island", smollIslandID, 0.0);

	// A strip of land for stuff to avoid
	int invIslandID = rmCreateArea("inv island");
	rmSetAreaLocation(invIslandID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(invIslandID, 0.50, 0.00, 0.50, 1.00);	
	rmSetAreaWarnFailure(invIslandID, false);
	rmSetAreaSize(invIslandID,0.10, 0.10);
	rmSetAreaCoherence(invIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(invIslandID, false);
//	rmSetAreaMix(invIslandID, "testmix");   // for testing
	rmAddAreaToClass(invIslandID, classIsland);
	rmBuildArea(invIslandID); 
	
	int avoidInvIslandMin = rmCreateAreaDistanceConstraint("avoid inv island min", invIslandID, 10.0);
	int avoidInvIsland = rmCreateAreaDistanceConstraint("avoid inv island", invIslandID, 20.0);
	int avoidInvIslandFar = rmCreateAreaDistanceConstraint("avoid inv island far", invIslandID, 30.0);
	int stayInvIsland = rmCreateAreaMaxDistanceConstraint("stay in inv island", invIslandID, 0.0);

	// Trade route island
	int tpIslandID = rmCreateArea("tp island");
	if (whichMap == 1) {
		rmSetAreaLocation(tpIslandID, 0.50, 0.25);
		rmAddAreaInfluenceSegment(tpIslandID, 0.10, 0.25, 0.35, 0.25);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.35, 0.25, 0.35, 0.35);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.35, 0.35, 0.65, 0.35);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.65, 0.35, 0.65, 0.25);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.65, 0.25, 0.90, 0.25);	
		}
	else {
		rmSetAreaLocation(tpIslandID, 0.50, 0.75);
		rmAddAreaInfluenceSegment(tpIslandID, 0.10, 0.75, 0.35, 0.75);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.35, 0.75, 0.35, 0.65);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.35, 0.65, 0.65, 0.65);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.65, 0.65, 0.65, 0.75);	
		rmAddAreaInfluenceSegment(tpIslandID, 0.65, 0.75, 0.90, 0.75);	
		}
	rmSetAreaWarnFailure(tpIslandID, false);
	rmSetAreaSize(tpIslandID,0.10, 0.10);
	rmSetAreaCoherence(tpIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(tpIslandID, false);
//	rmSetAreaMix(tpIslandID, "testmix");   // for testing
	rmAddAreaToClass(tpIslandID, classIsland);
	rmBuildArea(tpIslandID); 
	
	int avoidTPIslandMin = rmCreateAreaDistanceConstraint("avoid tp island min", tpIslandID, 10.0);
	int avoidTPIsland = rmCreateAreaDistanceConstraint("avoid tp island", tpIslandID, 20.0);
	int avoidTPIslandFar = rmCreateAreaDistanceConstraint("avoid tp island far", tpIslandID, 30.0);
	int stayTPIsland = rmCreateAreaMaxDistanceConstraint("stay in tp island", tpIslandID, 0.0);
	
   // TRADE ROUTE PLACEMENT
   int tradeRouteID = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 2.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);

	if ( whichMap == 1 )
	{
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.40);
		else 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.325);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.25);
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.20);
		else 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.175);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.25);
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.40);
		else 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.325);
	}
	else
	{
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.60);
		else 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.05, 0.675);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.75);
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.80);
		else 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.825);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.80, 0.75);
		if (PlayerNum == 2)
			rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.60);
		else 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.675);
	}

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if (cNumberNonGaiaPlayers < 5) {
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
	else {
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.40);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.60);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.95);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

/*	if ( extraPoles > 1 )
	{
	   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	} 	*/

	// NATIVE AMERICANS
//   float NativeVillageLoc = rmRandFloat(0,1); //

   if (subCiv0 == rmGetCivID(natType1))
   {  
      int comancheVillageAID = -1;
      int comancheVillageType = rmRandInt(1,5);
      comancheVillageAID = rmCreateGrouping("comanche village A", natGrpName1+comancheVillageType);
      rmSetGroupingMinDistance(comancheVillageAID, 0.0);
      rmSetGroupingMaxDistance(comancheVillageAID, rmXFractionToMeters(0.0));
      rmAddGroupingConstraint(comancheVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(comancheVillageAID, rmClassID("importantItem"));
      rmAddGroupingToClass(comancheVillageAID, rmClassID("natives"));
		if ( whichMap == 1 )
		{
			if (cNumberNonGaiaPlayers == 2)
				rmPlaceGroupingAtLoc(comancheVillageAID, 0, 0.50, 0.90);
			else
				rmPlaceGroupingAtLoc(comancheVillageAID, 0, 0.50, 0.65);
		}
		else
		{
			if (cNumberNonGaiaPlayers == 2)
				rmPlaceGroupingAtLoc(comancheVillageAID, 0, 0.50, 0.10);
			else 
				rmPlaceGroupingAtLoc(comancheVillageAID, 0, 0.50, 0.35);
		}
	}

   if (subCiv1 == rmGetCivID("Cheyenne"))
   {   
      int cheyenneVillageAID = -1;
      int cheyenneVillageType = rmRandInt(1,5);
      cheyenneVillageAID = rmCreateGrouping("cheyenne village A", "native cheyenne village "+5);
      rmSetGroupingMinDistance(cheyenneVillageAID, 0.0);
      rmSetGroupingMaxDistance(cheyenneVillageAID, rmXFractionToMeters(0.0));
      rmAddGroupingConstraint(cheyenneVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(cheyenneVillageAID, rmClassID("importantItem"));
      rmAddGroupingToClass(cheyenneVillageAID, rmClassID("natives"));
		if (whichMap == 1)
			rmPlaceGroupingAtLoc(cheyenneVillageAID, 0, 0.50, 0.45); 
		else
			rmPlaceGroupingAtLoc(cheyenneVillageAID, 0, 0.50, 0.55); 
	}

	if(subCiv2 == rmGetCivID("Cheyenne"))
   {   
      int cheyenneVillageID = -1;
      cheyenneVillageType = rmRandInt(1,5);
      cheyenneVillageID = rmCreateGrouping("cheyenne village", "native cheyenne village "+cheyenneVillageType);
      rmSetGroupingMinDistance(cheyenneVillageID, 0.0);
      rmSetGroupingMaxDistance(cheyenneVillageID, rmXFractionToMeters(0.0));
      rmAddGroupingConstraint(cheyenneVillageID, avoidImpassableLand);
      rmAddGroupingToClass(cheyenneVillageID, rmClassID("importantItem"));
      rmAddGroupingToClass(cheyenneVillageID, rmClassID("natives"));
		if (cNumberTeams == 2)
		{
			if ( whichMap == 1 )
			{
				if (cNumberNonGaiaPlayers == 2)
					rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.20, 0.65);
				else
					rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.35, 0.90);
			}
			else
			{
				if (cNumberNonGaiaPlayers == 2)
					rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.80, 0.35);
				else
					rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.65, 0.10);
			}
		}
		else
		{
			if (whichMap == 1)
			{
				rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.65, 0.50);
			}
			else 
			{
				rmPlaceGroupingAtLoc(cheyenneVillageID, 0, 0.65, 0.50);
			}
		}
   }

	if(subCiv3 == rmGetCivID(natType1))
   {   
      int comancheVillageBID = -1;
      comancheVillageType = rmRandInt(1,5);
      comancheVillageBID = rmCreateGrouping("comanche village B", natGrpName1+comancheVillageType);
      rmSetGroupingMinDistance(comancheVillageBID, 0.0);
      rmSetGroupingMaxDistance(comancheVillageBID, rmXFractionToMeters(0.0));
      rmAddGroupingConstraint(comancheVillageBID, avoidImpassableLand);
      rmAddGroupingToClass(comancheVillageBID, rmClassID("importantItem"));
      rmAddGroupingToClass(comancheVillageBID, rmClassID("natives"));
		if ( whichMap == 1 )
		{
			rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.35, 0.10);
		}
		else
		{
			rmPlaceGroupingAtLoc(comancheVillageBID, 0, 0.35, 0.90);
		}
   }

	if(subCiv4 == rmGetCivID(natType1))
   {
      int comancheVillageID = -1;
      comancheVillageType = rmRandInt(1,5);
      comancheVillageID = rmCreateGrouping("comanche village", natGrpName1+comancheVillageType);
      rmSetGroupingMinDistance(comancheVillageID, 0.0);
	  rmSetGroupingMaxDistance(comancheVillageID, rmXFractionToMeters(0.0));
      rmAddGroupingConstraint(comancheVillageID, avoidImpassableLand);
      rmAddGroupingToClass(comancheVillageID, rmClassID("importantItem"));
      rmAddGroupingToClass(comancheVillageID, rmClassID("natives"));
		if ( extraPoles == 1 )
		{
			if ( whichMap == 1 )
			{
				rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.65, 0.10);
			}
			else
			{
				rmPlaceGroupingAtLoc(comancheVillageID, 0, 0.65, 0.90);
			}
		}
	
	}

   if (subCiv5 == rmGetCivID("Cheyenne"))
   {   
      int cheyenneVillageBID = -1;
      cheyenneVillageType = rmRandInt(1,5);
      cheyenneVillageBID = rmCreateGrouping("cheyenne village B", "native cheyenne village "+cheyenneVillageType);
      rmSetGroupingMinDistance(cheyenneVillageBID, 0.0);
      rmSetGroupingMaxDistance(cheyenneVillageBID, rmXFractionToMeters(0.0));
      rmAddGroupingConstraint(cheyenneVillageBID, avoidImpassableLand);
      rmAddGroupingToClass(cheyenneVillageBID, rmClassID("importantItem"));
      rmAddGroupingToClass(cheyenneVillageBID, rmClassID("natives"));
	  if (cNumberTeams == 2)
	  {
		if ( whichMap == 1 )
		{
			if (cNumberNonGaiaPlayers == 2)
				rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.80, 0.65);
			else
				rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.65, 0.90);
		}
		else
		{
			if (cNumberNonGaiaPlayers == 2)
				rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.20, 0.35);
			else
				rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.35, 0.10);
		}
	  }
	  else
	  {
		if (whichMap == 1) 
		{
			rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.35, 0.50);
		}
		else
		{
			rmPlaceGroupingAtLoc(cheyenneVillageBID, 0, 0.35, 0.50);
		}
	  }
   }
      
   // DEFINE AREAS
   // Set up player starting locations.
   if ( whichMap == 1 )
   {
	   	rmSetPlacementSection(0.71, 0.29); // 0.5
   }
   else
   {
	    rmSetPlacementSection(0.21, 0.79); // 0.5	   	
   }
   rmSetTeamSpacingModifier(0.7);
   if ( cNumberNonGaiaPlayers < 3 )
   {
		rmPlacePlayersCircular(0.3, 0.3, 0);
   }
   else
   {
		rmPlacePlayersCircular(0.38, 0.38, 0);
   }
   

	/*
	// Place the first team.
   rmSetPlacementTeam(0);
	if ( whichMap == 1 ) // se trade route
	{
		rmSetPlayerPlacementArea(0.7, 0.5, 0.9, 0.8);
	}
	else
	{
		rmSetPlayerPlacementArea(0.7, 0.2, 0.9, 0.5);
	}
   rmPlacePlayersCircular(0.3, 0.4, rmDegreesToRadians(5.0));

	// Now place Second Team
   rmSetPlacementTeam(1);
   	if ( whichMap == 1 ) // nw trade route
	{
		rmSetPlayerPlacementArea(0.1, 0.5, 0.3, 0.8);
	}
	else
	{
		rmSetPlayerPlacementArea(0.1, 0.2, 0.3, 0.5);
	}
   rmPlacePlayersCircular(0.3, 0.4, rmDegreesToRadians(5.0));
   */

	//	rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));

   // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(100);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint); 
	  rmAddAreaConstraint(id, avoidTradeRoute); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

	int numTries = -1;
	int failCount = -1;

	// Text
   rmSetStatusText("",0.10);

	// Two hilly areas
   int hillNorthwestID=rmCreateArea("northwest hills");
   int avoidNW = rmCreateAreaDistanceConstraint("avoid nw", hillNorthwestID, 3.0);
	int stayNW = rmCreateAreaMaxDistanceConstraint("stay in nw", hillNorthwestID, 0.0);

   rmSetAreaSize(hillNorthwestID, 0.2, 0.2);
   rmSetAreaWarnFailure(hillNorthwestID, false);
   rmSetAreaSmoothDistance(hillNorthwestID, 12);
   rmSetAreaMix(hillNorthwestID, "great plains grass");
   //rmAddAreaTerrainLayer(hillNorthwestID, "great_plains\ground8_gp", 0, 4);
   //rmAddAreaTerrainLayer(hillNorthwestID, "great_plains\ground1_gp", 0, 10);
   rmSetAreaElevationType(hillNorthwestID, cElevTurbulence);
   rmSetAreaElevationVariation(hillNorthwestID, 6.0);
   rmSetAreaBaseHeight(hillNorthwestID, 5);
   rmSetAreaElevationMinFrequency(hillNorthwestID, 0.05);
   rmSetAreaElevationOctaves(hillNorthwestID, 3);
   rmSetAreaElevationPersistence(hillNorthwestID, 0.3);      
   rmSetAreaElevationNoiseBias(hillNorthwestID, 0.5);
   rmSetAreaElevationEdgeFalloffDist(hillNorthwestID, 20.0);
	rmSetAreaCoherence(hillNorthwestID, 0.9);
	rmSetAreaLocation(hillNorthwestID, 0.5, 0.9);
   rmSetAreaEdgeFilling(hillNorthwestID, 5);
	rmAddAreaInfluenceSegment(hillNorthwestID, 0.1, 0.95, 0.9, 0.95);
	rmSetAreaHeightBlend(hillNorthwestID, 1);
	rmSetAreaObeyWorldCircleConstraint(hillNorthwestID, false);
	rmAddAreaToClass(hillNorthwestID, rmClassID("classHillArea"));
	rmBuildArea(hillNorthwestID);

   int hillSoutheastID=rmCreateArea("southeast hills");
   int avoidSE = rmCreateAreaDistanceConstraint("avoid se", hillSoutheastID, 3.0);
	int staySE = rmCreateAreaMaxDistanceConstraint("stay in se", hillSoutheastID, 0.0);

   rmSetAreaSize(hillSoutheastID, 0.2, 0.2);
   rmSetAreaWarnFailure(hillSoutheastID, false);
   rmSetAreaSmoothDistance(hillSoutheastID, 12);
   rmSetAreaMix(hillSoutheastID, "great plains grass");
   //rmAddAreaTerrainLayer(hillSoutheastID, "great_plains\ground8_gp", 0, 4);
   //rmAddAreaTerrainLayer(hillSoutheastID, "great_plains\ground1_gp", 0, 10);
   rmSetAreaElevationType(hillSoutheastID, cElevTurbulence);
   rmSetAreaElevationVariation(hillSoutheastID, 6.0);
   rmSetAreaBaseHeight(hillSoutheastID, 5);
   rmSetAreaElevationMinFrequency(hillSoutheastID, 0.05);
   rmSetAreaElevationOctaves(hillSoutheastID, 3);
   rmSetAreaElevationPersistence(hillSoutheastID, 0.3);
   rmSetAreaElevationNoiseBias(hillSoutheastID, 0.5);
   rmSetAreaElevationEdgeFalloffDist(hillSoutheastID, 20.0);
	rmSetAreaCoherence(hillSoutheastID, 0.9);
	rmSetAreaLocation(hillSoutheastID, 0.5, 0.1);
   rmSetAreaEdgeFilling(hillSoutheastID, 5);
	rmAddAreaInfluenceSegment(hillSoutheastID, 0.1, 0.05, 0.9, 0.05);
	rmSetAreaHeightBlend(hillSoutheastID, 1);
	rmSetAreaObeyWorldCircleConstraint(hillSoutheastID, false);
	rmAddAreaToClass(hillSoutheastID, rmClassID("classHillArea"));
	rmBuildArea(hillSoutheastID);

	// Place King's Hill
	if (rmGetIsKOTH() == true) {
		float xLoc = 0.50;
		float yLoc = 0.00;
		float walk = 0.0;

		if (whichMap == 1) {
			yLoc = 0.57;
			}
		else {
			yLoc = 0.43;
			}
		
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}

    int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 12.0);
    int avoidKOTHFar = rmCreateTypeDistanceConstraint("avoid koth far", "ypKingsHill", 18.0);

   // Build the areas.
   // rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.20);

/*    //STARTING UNITS and RESOURCES DEFS ------- OLD, removed by vividlyplain
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 7.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

	int startingTCID = rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	rmSetObjectDefMaxDistance(startingTCID, 0.0);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSmall);

	// rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeGreatPlains", 1, 0.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 18.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

	int StartBisonID=rmCreateObjectDef("starting bison");
	rmAddObjectDefItem(StartBisonID, "Bison", 4, 4.0);
	rmSetObjectDefMinDistance(StartBisonID, 12.0);
	rmSetObjectDefMaxDistance(StartBisonID, 12.0);
	rmSetObjectDefCreateHerd(StartBisonID, true);
	rmAddObjectDefConstraint(StartBisonID, avoidStartingUnitsSmall);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);
	
	int silverType = -1;
	int playerGoldID = -1;

 	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		// vector closestPoint=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingUnits, i));
		// rmSetHomeCityGatherPoint(i, closestPoint);

		// Everyone gets two ore ObjectDefs, one pretty close, the other a little further away.
		silverType = rmRandInt(1,10);
		playerGoldID = rmCreateObjectDef("player silver closer "+i);
		rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
		// rmAddObjectDefToClass(playerGoldID, rmClassID("importantItem"));
		rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingCoin);
		rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
		rmSetObjectDefMinDistance(playerGoldID, 18.0);
		rmSetObjectDefMaxDistance(playerGoldID, 18.0);
		
		// Place two gold mines
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(StartBisonID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}
*/
	// Starting Resources
	// Town center & units
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmAddObjectDefToClass(startingUnits, classStartingResource);
	rmSetObjectDefMinDistance(startingUnits, 7.0);
	rmSetObjectDefMaxDistance(startingUnits, 12.0);

	int TCID = rmCreateObjectDef("player TC");
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
	
	// Starting mine
	int playerGoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerGoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 18.0);
	rmSetObjectDefMaxDistance(playerGoldID, 18.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerGoldID, stayMedIsland);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(playerGoldID, avoidSocket);
	
	// 2nd mine
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 18.0);
	rmSetObjectDefMaxDistance(playerGold2ID, 18.0);
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidGoldMed);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(playerGold2ID, avoidSocket);
	rmAddObjectDefConstraint(playerGold2ID, avoidMedIsland);

	// Starting herd
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, "bison", 4, 4.0);
	rmSetObjectDefMinDistance(playerHerdID, 12);
	rmSetObjectDefMaxDistance(playerHerdID, 12);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);		
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingUnitsSmall);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeGreatPlains", 2, 3.0);
	rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerTreeID, avoidForestMin);

	// Secondary trees behind base
	int playerTree2ID = rmCreateObjectDef("player 2nd trees");
	rmAddObjectDefItem(playerTree2ID, "TreeGreatPlains", 10, 10.0);
	rmSetObjectDefMinDistance(playerTree2ID, 40);
    rmSetObjectDefMaxDistance(playerTree2ID, 44);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidBigIslandMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidSE);
	rmAddObjectDefConstraint(playerTree2ID, avoidNW);
	rmAddObjectDefConstraint(playerTree2ID, avoidNativesShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(playerTree2ID, avoidSocketMore);
	
	// 2nd herd
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(playerHerd2ID, "bison", 11, 7.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 40);
    rmSetObjectDefMaxDistance(playerHerd2ID, 40);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHerd2ID, avoidGoldShort);
	rmAddObjectDefConstraint(playerHerd2ID, stayMedIsland);
	rmAddObjectDefConstraint(playerHerd2ID, avoidSmollIslandMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerHerd2ID, avoidSocket);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerHerd2ID, stayTPIsland);
		
	// 3nd herd
	int playerHerd3ID = rmCreateObjectDef("player 3rd herd");
	rmAddObjectDefItem(playerHerd3ID, "pronghorn", 8, 7.0);
    rmSetObjectDefMinDistance(playerHerd3ID, 40);
    rmSetObjectDefMaxDistance(playerHerd3ID, 44);
	rmAddObjectDefToClass(playerHerd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd3ID, true);
	rmAddObjectDefConstraint(playerHerd3ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd3ID, avoidBigIslandMin);
	rmAddObjectDefConstraint(playerHerd3ID, avoidSocket);
	rmAddObjectDefConstraint(playerHerd3ID, avoidEdge);
	rmAddObjectDefConstraint(playerHerd3ID, avoidSE);
	rmAddObjectDefConstraint(playerHerd3ID, avoidNW);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerHerd3ID, stayTPIsland);

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 30.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	
	//  Place Starting Objects/Resources
	for(i=1; <cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	//	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerGold2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerdID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerTree2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerd2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerHerd3ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

	//	vector closestPoint = rmFindClosestPointVector(i, rmXFractionToMeters(1.0));
	}

   // Text
	rmSetStatusText("",0.30);
   
	// Ponds o' Fun
	int pondClass=rmDefineClass("pond");
	int pondConstraint=rmCreateClassDistanceConstraint("ponds avoid ponds", rmClassID("pond"), 55.0);
	int pondConstraintMed=rmCreateClassDistanceConstraint("med avoid ponds", rmClassID("pond"), 20.0);
	int pondConstraintShort=rmCreateClassDistanceConstraint("short avoid ponds", rmClassID("pond"), 12.0);
	int pondConstraintMin=rmCreateClassDistanceConstraint("min avoid ponds", rmClassID("pond"), 4.0);

	int wherePond = rmRandInt (1,3);
	
	float yPond = 0.00;
	if (whichMap == 2) {
		if (wherePond == 1)
			yPond = 0.65;
		else if (wherePond == 2)
			yPond = 0.35;
		else
			yPond = 0.25;
		}
	else {
		if (wherePond == 1)
			yPond = 0.35;
		else if (wherePond == 2)
			yPond = 0.55;
		else
			yPond = 0.65;
		}
		
	// Mid Pond
	int midPondID=rmCreateArea("mid pond");
	rmSetAreaSize(midPondID, rmAreaTilesToFraction(130+10*cNumberNonGaiaPlayers));
	rmSetAreaWaterType(midPondID, "great plains pond");
	rmAddAreaToClass(midPondID, pondClass);
	rmSetAreaCoherence(midPondID, 0.5);
	rmSetAreaSmoothDistance(midPondID, 1);
	rmSetAreaLocation(midPondID, 0.50, yPond);
	rmAddAreaConstraint(midPondID, avoidTownCenter);
	rmAddAreaConstraint(midPondID, avoidTradeRoute);
	rmAddAreaConstraint(midPondID, avoidSocketMore);
	rmAddAreaConstraint(midPondID, avoidImportantItem);
	rmAddAreaConstraint(midPondID, avoidNW);
	rmAddAreaConstraint(midPondID, avoidSE);
	rmAddAreaConstraint(midPondID, avoidNatives);
	rmAddAreaConstraint(midPondID, avoidStartingResources);
	rmAddAreaConstraint(midPondID, avoidKOTH);
	rmSetAreaWarnFailure(midPondID, false);
	if (cNumberNonGaiaPlayers < 5)
		rmBuildArea(midPondID);		
	
   // int numPonds=rmRandInt(1,4);
	int numPonds=2+cNumberNonGaiaPlayers/2;
   for(i=0; <numPonds)
   {
      int smallPondID=rmCreateArea("small pond"+i);
      rmSetAreaSize(smallPondID, rmAreaTilesToFraction(150));
      rmSetAreaWaterType(smallPondID, "great plains pond");
      rmAddAreaToClass(smallPondID, pondClass);
      rmSetAreaCoherence(smallPondID, 0.5);
      rmSetAreaSmoothDistance(smallPondID, 1);
      rmAddAreaConstraint(smallPondID, pondConstraint);
      rmAddAreaConstraint(smallPondID, avoidTownCenter);
      rmAddAreaConstraint(smallPondID, avoidTradeRoute);
		rmAddAreaConstraint(smallPondID, avoidSocketMore);
		rmAddAreaConstraint(smallPondID, avoidImportantItem);
		rmAddAreaConstraint(smallPondID, avoidNW);
		rmAddAreaConstraint(smallPondID, avoidSE);
		rmAddAreaConstraint(smallPondID, avoidNatives);
		rmAddAreaConstraint(smallPondID, avoidStartingResources);
		rmAddAreaConstraint(smallPondID, avoidKOTH);
      rmSetAreaWarnFailure(smallPondID, false);
      rmBuildArea(smallPondID);
   }

	// Build grassy areas everywhere.  Whee!
	numTries=10*cNumberNonGaiaPlayers;
	//numTries=6*cNumberNonGaiaPlayers;
	failCount=0;
	for (i=0; <numTries)
	{   
		int grassyArea=rmCreateArea("grassyArea"+i);
		rmSetAreaWarnFailure(grassyArea, false);
		rmSetAreaSize(grassyArea, rmAreaTilesToFraction(1000));
		rmSetAreaForestType(grassyArea, "Great Plains grass");
		rmSetAreaForestDensity(grassyArea, 0.8);
		//rmSetAreaForestDensity(grassyArea, 0.3);
		rmSetAreaForestClumpiness(grassyArea, 0.8);
		//rmSetAreaForestClumpiness(grassyArea, 0.1);
		rmAddAreaConstraint(grassyArea, avoidHills);
		rmAddAreaConstraint(grassyArea, avoidTradeRoute);
		rmAddAreaConstraint(grassyArea, avoidSocket);
		rmAddAreaConstraint(grassyArea, avoidNatives);
		rmAddAreaConstraint(grassyArea, avoidTownCenterShort);
		rmAddAreaConstraint(grassyArea, pondConstraintShort);
		rmAddAreaConstraint(grassyArea, avoidStartingResources);
		rmAddAreaConstraint(grassyArea, avoidKOTH);
		if(rmBuildArea(grassyArea)==false)
		{
			// Stop trying once we fail 5 times in a row.
			failCount++;
			if(failCount==5)
				break;
		}
		else
			failCount=0; 
	}
 
   // Text
   rmSetStatusText("",0.40);

	// Place resources
	if (PlayerNum == 2) {
		// 1v1 mines
		int staticGold1ID = rmCreateObjectDef("static mine 1");
		rmAddObjectDefItem(staticGold1ID, "Minegold", 1, 0);		// 5k mine to entice players to stay on this side
		rmSetObjectDefMinDistance(staticGold1ID, 0.0);
		rmSetObjectDefMaxDistance(staticGold1ID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(staticGold1ID, classGold);
		if (whichMap == 1)
			rmAddObjectDefConstraint(staticGold1ID, staySE);
		else
			rmAddObjectDefConstraint(staticGold1ID, stayNW);
		rmAddObjectDefConstraint(staticGold1ID, stayInvIsland);
		rmAddObjectDefConstraint(staticGold1ID, avoidBigIslandMin);
		rmAddObjectDefConstraint(staticGold1ID, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(staticGold1ID, avoidSocket);
		rmAddObjectDefConstraint(staticGold1ID, avoidNativesShort);
		rmPlaceObjectDefAtLoc(staticGold1ID, 0, 0.5, 0.5);

		int staticGold2ID = rmCreateObjectDef("static mine 2");
		rmAddObjectDefItem(staticGold2ID, "mine", 1, 0);
		rmSetObjectDefMinDistance(staticGold2ID, 0.0);
		rmSetObjectDefMaxDistance(staticGold2ID, rmXFractionToMeters(0.10));
		rmAddObjectDefToClass(staticGold2ID, classGold);
		rmAddObjectDefConstraint(staticGold2ID, staySmollIsland);
		rmAddObjectDefConstraint(staticGold2ID, stayInvIsland);
		rmAddObjectDefConstraint(staticGold2ID, avoidNativesShort);
		rmAddObjectDefConstraint(staticGold2ID, pondConstraintMin);
		rmAddObjectDefConstraint(staticGold2ID, avoidTownCenterMed);
		rmAddObjectDefConstraint(staticGold2ID, avoidStartingResources);
		rmPlaceObjectDefAtLoc(staticGold2ID, 0, 0.5, 0.5);		

		int staticGold3ID = rmCreateObjectDef("static mine 3");
		rmAddObjectDefItem(staticGold3ID, "mine", 1, 0);
		rmSetObjectDefMinDistance(staticGold3ID, 0.0);
		rmSetObjectDefMaxDistance(staticGold3ID, rmXFractionToMeters(0.05));
		rmAddObjectDefToClass(staticGold3ID, classGold);
		rmAddObjectDefConstraint(staticGold3ID, avoidNativesShort);
		rmAddObjectDefConstraint(staticGold3ID, pondConstraintMin);
		rmAddObjectDefConstraint(staticGold3ID, avoidTownCenterMed);
		rmAddObjectDefConstraint(staticGold3ID, avoidStartingResources);
		if (whichMap == 1) {
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.15, 0.70);	
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.85, 0.70);		
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.35, 0.90);		
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.65, 0.90);		
			}			
		else {
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.15, 0.30);		
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.85, 0.30);	
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.35, 0.10);		
			rmPlaceObjectDefAtLoc(staticGold3ID, 0, 0.65, 0.10);	
			}
		}
	else {
		// FAST COIN - three extra per player beyond starting resources.
		int silverID = -1;
		silverID = rmCreateObjectDef("silver ");
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(silverID, classGold);
		rmAddObjectDefConstraint(silverID, avoidGoldVeryFar);
	//	rmAddObjectDefConstraint(silverID, stayBigIsland);
	//	rmAddObjectDefConstraint(silverID, avoidSmollIslandMin);
		rmAddObjectDefConstraint(silverID, avoidNativesShort);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmAddObjectDefConstraint(silverID, avoidTownCenterFar);
		rmAddObjectDefConstraint(silverID, avoidStartingResources);
		rmAddObjectDefConstraint(silverID, pondConstraintMin);
		rmAddObjectDefConstraint(silverID, avoidKOTH);
		rmAddObjectDefConstraint(silverID, avoidInvIslandMin);
		rmAddObjectDefConstraint(silverID, avoidEdge);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*3);
		}
	
   // Text
   rmSetStatusText("",0.50);

	// Plains Trees
	int plainsTreeID = rmCreateObjectDef("plains trees");
	rmAddObjectDefItem(plainsTreeID, "TreeGreatPlains", rmRandInt(10,14), 16.0);
	rmAddObjectDefItem(plainsTreeID, "TreeTexas", rmRandInt(1,5), 8.0);
	rmSetObjectDefMinDistance(plainsTreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(plainsTreeID,  rmXFractionToMeters(0.40));
	rmAddObjectDefToClass(plainsTreeID, classForest);
	rmAddObjectDefConstraint(plainsTreeID, avoidForestFar);
	rmAddObjectDefConstraint(plainsTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(plainsTreeID, avoidTownCenter);
	rmAddObjectDefConstraint(plainsTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(plainsTreeID, avoidNatives);
	rmAddObjectDefConstraint(plainsTreeID, avoidKOTHFar);
	rmAddObjectDefConstraint(plainsTreeID, avoidSE);
	rmAddObjectDefConstraint(plainsTreeID, avoidNW);
	rmAddObjectDefConstraint(plainsTreeID, pondConstraintShort);
	rmAddObjectDefConstraint(plainsTreeID, stayBigIsland);
	rmPlaceObjectDefAtLoc(plainsTreeID, 0, 0.50, 0.50, 2+4*cNumberNonGaiaPlayers);

   // Text
   rmSetStatusText("",0.60);

	// Rim Trees
	int rimTreeID = rmCreateObjectDef("rim trees");
	rmAddObjectDefItem(rimTreeID, "TreeGreatPlains", rmRandInt(6,8), 6.0);
	rmAddObjectDefItem(rimTreeID, "TreeTexas", rmRandInt(1,2), 3.0);
	rmSetObjectDefMinDistance(rimTreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(rimTreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(rimTreeID, classForest);
	rmAddObjectDefConstraint(rimTreeID, avoidForest);
	rmAddObjectDefConstraint(rimTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(rimTreeID, avoidTownCenter);
	rmAddObjectDefConstraint(rimTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(rimTreeID, avoidNativesShort);
	rmAddObjectDefConstraint(rimTreeID, avoidSE);
	rmAddObjectDefConstraint(rimTreeID, avoidNW);
	rmAddObjectDefConstraint(rimTreeID, pondConstraintShort);
	rmAddObjectDefConstraint(rimTreeID, avoidBigIsland);
	rmPlaceObjectDefAtLoc(rimTreeID, 0, 0.50, 0.50, 2+4*cNumberNonGaiaPlayers);
	
   // Text
   rmSetStatusText("",0.70); 
   
	// NW Trees
	int NWTreeID = rmCreateObjectDef("nw trees");
	rmAddObjectDefItem(NWTreeID, "TreeGreatPlains", rmRandInt(8,10), 6.0);
	rmSetObjectDefMinDistance(NWTreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(NWTreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(NWTreeID, classForest);
	rmAddObjectDefConstraint(NWTreeID, avoidForest);
	rmAddObjectDefConstraint(NWTreeID, avoidNativesShort);
	rmAddObjectDefConstraint(NWTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(NWTreeID, avoidTownCenter);
	rmAddObjectDefConstraint(NWTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(NWTreeID, stayNW);
	rmAddObjectDefConstraint(NWTreeID, pondConstraintShort);
	rmPlaceObjectDefAtLoc(NWTreeID, 0, 0.50, 0.50, 2+4*cNumberNonGaiaPlayers);
	
	// SE Trees
	int SETreeID = rmCreateObjectDef("se trees");
	rmAddObjectDefItem(SETreeID, "TreeGreatPlains", rmRandInt(8,10), 6.0);
	rmSetObjectDefMinDistance(SETreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(SETreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(SETreeID, classForest);
	rmAddObjectDefConstraint(SETreeID, avoidForest);
	rmAddObjectDefConstraint(SETreeID, avoidNativesShort);
	rmAddObjectDefConstraint(SETreeID, avoidGoldShort);
	rmAddObjectDefConstraint(SETreeID, avoidTownCenter);
	rmAddObjectDefConstraint(SETreeID, avoidStartingResources);
	rmAddObjectDefConstraint(SETreeID, staySE);
	rmAddObjectDefConstraint(SETreeID, pondConstraintShort);
	rmPlaceObjectDefAtLoc(SETreeID, 0, 0.50, 0.50, 2+4*cNumberNonGaiaPlayers);

	// Text
   rmSetStatusText("",0.80);

	// bison	
	int midbisonID=rmCreateObjectDef("mid bison herd");
	rmAddObjectDefItem(midbisonID, "bison", 10, 6.0);
	rmSetObjectDefMinDistance(midbisonID, 0.0);
	rmSetObjectDefMaxDistance(midbisonID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(midbisonID, avoidGoldMin);
	rmAddObjectDefConstraint(midbisonID, avoidBisonShort);
	rmAddObjectDefConstraint(midbisonID, stayInvIsland);
	rmAddObjectDefConstraint(midbisonID, avoidNativesShort);
	rmAddObjectDefConstraint(midbisonID, avoidSocketMore);
	rmAddObjectDefConstraint(midbisonID, avoidTownCenterMed);
	rmAddObjectDefConstraint(midbisonID, avoidSE);
	rmAddObjectDefConstraint(midbisonID, avoidNW);
	rmAddObjectDefConstraint(midbisonID, pondConstraintMin);
	rmAddObjectDefConstraint(midbisonID, avoidForestMin);
	rmAddObjectDefConstraint(midbisonID, avoidKOTH);
	rmSetObjectDefCreateHerd(midbisonID, true);
	rmPlaceObjectDefAtLoc(midbisonID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	if (PlayerNum == 2) {
		int staticBison1ID = rmCreateObjectDef("static bison1");
		rmAddObjectDefItem(staticBison1ID, "bison", 10, 4.0);
		rmSetObjectDefMinDistance(staticBison1ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticBison1ID, rmXFractionToMeters(0.05));
		rmSetObjectDefCreateHerd(staticBison1ID, true);
		rmAddObjectDefConstraint(staticBison1ID, avoidBisonShort);
		rmAddObjectDefConstraint(staticBison1ID, avoidStartingResources);
		rmAddObjectDefConstraint(staticBison1ID, avoidNativesMin);
		rmAddObjectDefConstraint(staticBison1ID, avoidSocket);
		rmAddObjectDefConstraint(staticBison1ID, avoidForestMin);
		rmAddObjectDefConstraint(staticBison1ID, avoidGoldMin);
		rmAddObjectDefConstraint(staticBison1ID, avoidInvIslandMin);
		rmAddObjectDefConstraint(staticBison1ID, avoidPronghornFar);
		rmAddObjectDefConstraint(staticBison1ID, avoidTownCenterMed);
		rmAddObjectDefConstraint(staticBison1ID, avoidSE);
		rmAddObjectDefConstraint(staticBison1ID, avoidNW);
		rmAddObjectDefConstraint(staticBison1ID, pondConstraintMin);
		if (whichMap == 1) {
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.10, 0.65);
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.30, 0.60);
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.70, 0.60);
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.90, 0.65);
			}
		else {
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.10, 0.35);
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.30, 0.40);
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.70, 0.40);
			rmPlaceObjectDefAtLoc(staticBison1ID, 0, 0.90, 0.35);
			}
		}
	else {
		int bisonID=rmCreateObjectDef("bison herd");
		rmAddObjectDefItem(bisonID, "bison", 10, 9.0);
		rmSetObjectDefMinDistance(bisonID, 0.0);
		rmSetObjectDefMaxDistance(bisonID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(bisonID, avoidGoldMin);
		rmAddObjectDefConstraint(bisonID, avoidInvIslandMin);
		rmAddObjectDefConstraint(bisonID, avoidBisonShort);
		rmAddObjectDefConstraint(bisonID, avoidPronghornFar);
		rmAddObjectDefConstraint(bisonID, avoidNativesShort);
		rmAddObjectDefConstraint(bisonID, avoidSocketMore);
		rmAddObjectDefConstraint(bisonID, avoidTownCenterMed);
		rmAddObjectDefConstraint(bisonID, avoidSE);
		rmAddObjectDefConstraint(bisonID, avoidNW);
		rmAddObjectDefConstraint(bisonID, pondConstraintShort);
		rmAddObjectDefConstraint(bisonID, avoidForestShort);
		rmAddObjectDefConstraint(bisonID, avoidKOTH);
		rmSetObjectDefCreateHerd(bisonID, true);
		rmPlaceObjectDefAtLoc(bisonID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
		}
	
	// pronghorn	
	if (PlayerNum == 2) {
		int staticherdID = rmCreateObjectDef("static herd");
		rmAddObjectDefItem(staticherdID, "pronghorn", 8, 5.0);
		rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.075));
		rmSetObjectDefCreateHerd(staticherdID, true);
		rmAddObjectDefConstraint(staticherdID, avoidBisonShort);
		rmAddObjectDefConstraint(staticherdID, avoidNativesShort);
		rmAddObjectDefConstraint(staticherdID, avoidSocket);
		rmAddObjectDefConstraint(staticherdID, avoidForestMin);
		rmAddObjectDefConstraint(staticherdID, avoidGoldMin);
		rmAddObjectDefConstraint(staticherdID, staySE);
		rmPlaceObjectDefAtLoc(staticherdID, 0, 0.50, 0.15);
	
		int staticherd2ID = rmCreateObjectDef("static herd2");
		rmAddObjectDefItem(staticherd2ID, "pronghorn", 8, 5.0);
		rmSetObjectDefMinDistance(staticherd2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherd2ID, rmXFractionToMeters(0.075));
		rmSetObjectDefCreateHerd(staticherd2ID, true);
		rmAddObjectDefConstraint(staticherd2ID, avoidBisonShort);
		rmAddObjectDefConstraint(staticherd2ID, avoidNativesShort);
		rmAddObjectDefConstraint(staticherd2ID, avoidSocket);
		rmAddObjectDefConstraint(staticherd2ID, avoidForestMin);
		rmAddObjectDefConstraint(staticherd2ID, avoidGoldMin);
		rmAddObjectDefConstraint(staticherd2ID, stayNW);
		rmPlaceObjectDefAtLoc(staticherd2ID, 0, 0.50, 0.85);
	
		int staticherd3ID = rmCreateObjectDef("static herd3");
		rmAddObjectDefItem(staticherd3ID, "pronghorn", 8, 5.0);
		rmSetObjectDefMinDistance(staticherd3ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherd3ID, rmXFractionToMeters(0.05));
		rmSetObjectDefCreateHerd(staticherd3ID, true);
		rmAddObjectDefConstraint(staticherd3ID, avoidBisonShort);
		rmAddObjectDefConstraint(staticherd3ID, avoidStartingResources);
		rmAddObjectDefConstraint(staticherd3ID, avoidNativesShort);
		rmAddObjectDefConstraint(staticherd3ID, avoidSocket);
		rmAddObjectDefConstraint(staticherd3ID, avoidGoldMin);
		rmAddObjectDefConstraint(staticherd3ID, avoidForestMin);
		if (whichMap == 1) {
			rmAddObjectDefConstraint(staticherd3ID, stayNW);
			rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.25, 0.85);
			rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.75, 0.85);
			}
		else {
			rmAddObjectDefConstraint(staticherd3ID, staySE);
			rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.25, 0.15);
			rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.75, 0.15);
			}
		}
		
	int pronghornID=rmCreateObjectDef("pronghorn herd");
	rmAddObjectDefItem(pronghornID, "pronghorn", 8, 6.0);
	rmSetObjectDefMinDistance(pronghornID, 0.0);
	rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(pronghornID, avoidGoldMin);
	rmAddObjectDefConstraint(pronghornID, avoidBison);
	rmAddObjectDefConstraint(pronghornID, avoidPronghornFar);
	rmAddObjectDefConstraint(pronghornID, avoidStartingResources);
	rmAddObjectDefConstraint(pronghornID, avoidNativesShort);
	rmAddObjectDefConstraint(pronghornID, avoidSocketMore);
	rmAddObjectDefConstraint(pronghornID, avoidTownCenterMed);
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(pronghornID, staySE);
	rmAddObjectDefConstraint(pronghornID, avoidForestShort);
	rmAddObjectDefConstraint(pronghornID, avoidKOTH);
	rmAddObjectDefConstraint(pronghornID, avoidInvIsland);
	rmSetObjectDefCreateHerd(pronghornID, true);
	if (cNumberNonGaiaPlayers > 2)
		rmPlaceObjectDefAtLoc(pronghornID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   int pronghorn2ID=rmCreateObjectDef("pronghorn2 herd");
   rmAddObjectDefItem(pronghorn2ID, "pronghorn", 8, 6.0);
   rmSetObjectDefMinDistance(pronghorn2ID, 0.0);
   rmSetObjectDefMaxDistance(pronghorn2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(pronghorn2ID, avoidBison);
   rmAddObjectDefConstraint(pronghorn2ID, avoidPronghornFar);
   rmAddObjectDefConstraint(pronghorn2ID, avoidStartingResources);
   rmAddObjectDefConstraint(pronghorn2ID, avoidNativesShort);
	rmAddObjectDefConstraint(pronghorn2ID, avoidSocketMore);
	rmAddObjectDefConstraint(pronghorn2ID, avoidTownCenterMed);
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(pronghorn2ID, stayNW);
	rmAddObjectDefConstraint(pronghorn2ID, avoidForestShort);
	rmAddObjectDefConstraint(pronghorn2ID, avoidKOTH);
	rmAddObjectDefConstraint(pronghorn2ID, avoidInvIslandMin);
   rmSetObjectDefCreateHerd(pronghorn2ID, true);
	if (cNumberNonGaiaPlayers > 2)
		rmPlaceObjectDefAtLoc(pronghorn2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

   rmSetStatusText("",0.90);

   // Define and place Nuggets
	// Treasures 
	int treasure1count = 4+PlayerNum;
	int treasure2count = 2+PlayerNum;
	int treasure3count = PlayerNum;
	
	// Treasures L3	
	int Nugget3ID = rmCreateObjectDef("nugget lvl3 "); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.30));
		rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, staySmollIsland);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidNativesMin); 
		rmAddObjectDefConstraint(Nugget3ID, pondConstraintMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar); 
		rmAddObjectDefConstraint(Nugget3ID, stayInvIsland); 
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, treasure3count);
	
	// Treasures L2	
	int Nugget2ID = rmCreateObjectDef("nugget lvl2 "); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.40));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, stayBigIsland);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidNativesMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidSocket); 
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSmall); 
		rmAddObjectDefConstraint(Nugget2ID, pondConstraintMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterMed); 
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, treasure2count);
	
	// Treasures L1
	int Nugget1ID = rmCreateObjectDef("nugget lvl1 "); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.45));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidMedIsland); 
		rmAddObjectDefConstraint(Nugget1ID, avoidSocket); 
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSmall); 
		rmAddObjectDefConstraint(Nugget1ID, pondConstraintMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenterMed); 
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50, treasure1count);
	
/* old treasures - removed by vividlyplain
	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, nuggetPlayerConstraint);
  	rmAddObjectDefConstraint(nuggetID, playerConstraint);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocketMore);
	rmAddObjectDefConstraint(nuggetID, avoidNatives);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmSetNuggetDifficulty(1, 3);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*4);
*/
 
	// 50% chance of buffalo carcasses - either one or two if they're there.
	int areThereBuffalo=rmRandInt(1, 2);
	int howManyBuffalo=rmRandInt(1, 2);
	if ( areThereBuffalo == 1 )
	{
		int bisonCarcass=rmCreateGrouping("Bison Carcass", "gp_carcass_bison");
		rmSetGroupingMinDistance(bisonCarcass, 0.0);
		rmSetGroupingMaxDistance(bisonCarcass, rmXFractionToMeters(0.5));
		rmAddGroupingToClass(bisonCarcass, rmClassID("prop"));
		rmAddGroupingConstraint(bisonCarcass, avoidNW);
		rmAddGroupingConstraint(bisonCarcass, avoidSE);
		rmAddGroupingConstraint(bisonCarcass, avoidPropExtreme);
		rmAddGroupingConstraint(bisonCarcass, avoidTradeRouteSmall);
		rmAddGroupingConstraint(bisonCarcass, avoidSocket);
		rmAddGroupingConstraint(bisonCarcass, avoidStartingResources);
		rmAddGroupingConstraint(bisonCarcass, avoidForestMin);
		rmAddGroupingConstraint(bisonCarcass, avoidGoldShort);
		rmAddGroupingConstraint(bisonCarcass, pondConstraintMin);
		rmAddGroupingConstraint(bisonCarcass, avoidNativesMin);
		rmAddGroupingConstraint(bisonCarcass, avoidNuggetMin);
		rmPlaceGroupingAtLoc(bisonCarcass, 0, 0.5, 0.5, howManyBuffalo);
	}

	// Perching Vultures - add a couple somewhere.
	int vultureID=rmCreateObjectDef("perching vultures");
	rmAddObjectDefItem(vultureID, "PropVulturePerching", 1, 0.0);
	rmSetObjectDefMinDistance(vultureID, 0.0);
	rmSetObjectDefMaxDistance(vultureID, rmXFractionToMeters(0.5));
	rmAddObjectDefToClass(vultureID, rmClassID("prop"));
	rmAddObjectDefConstraint(vultureID, avoidPropExtreme);
	rmAddObjectDefConstraint(vultureID, avoidGoldMin);
	rmAddObjectDefConstraint(vultureID, avoidForestMin);
	rmAddObjectDefConstraint(vultureID, avoidStartingResources);
	rmAddObjectDefConstraint(vultureID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(vultureID, avoidSocket);
	rmAddObjectDefConstraint(vultureID, avoidNuggetMin);
	rmPlaceObjectDefAtLoc(vultureID, 0, 0.5, 0.5, 2);

	int grassPatchGroupType=-1;
	int grassPatchGroup=-1;

	// 1 grass patch per player.
	for(i=1; <cNumberNonGaiaPlayers)
   {
		grassPatchGroupType=rmRandInt(1, 7);
		grassPatchGroup=rmCreateGrouping("Grass Patch Group"+i, "gp_grasspatch0"+grassPatchGroupType);
		rmSetGroupingMinDistance(grassPatchGroup, 0.0);
		rmSetGroupingMaxDistance(grassPatchGroup, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(grassPatchGroup, avoidNW);
		rmAddGroupingConstraint(grassPatchGroup, avoidSE);
		rmAddGroupingConstraint(grassPatchGroup, avoidImpassableLand);
		rmAddGroupingConstraint(grassPatchGroup, playerConstraint);
		rmAddGroupingConstraint(grassPatchGroup, avoidTradeRoute);
		rmAddGroupingConstraint(grassPatchGroup, avoidSocket);
		rmAddGroupingConstraint(grassPatchGroup, avoidNuggetShort);
		rmAddGroupingConstraint(grassPatchGroup, circleConstraint);
		rmAddGroupingConstraint(grassPatchGroup, avoidAll);
		rmAddGroupingConstraint(grassPatchGroup, avoidNativesShort);
		rmAddGroupingConstraint(grassPatchGroup, avoidProp);
		rmAddGroupingConstraint(grassPatchGroup, avoidTownCenter);
		rmAddGroupingConstraint(grassPatchGroup, avoidStartingResources);
		rmAddGroupingConstraint(grassPatchGroup, avoidPronghornShort);
		rmAddGroupingConstraint(grassPatchGroup, avoidBisonShort);
		rmAddGroupingConstraint(grassPatchGroup, avoidGoldShort);
		rmAddGroupingConstraint(grassPatchGroup, avoidForestShort);
		rmPlaceGroupingAtLoc(grassPatchGroup, 0, 0.5, 0.5, 1);
	}

	int flowerPatchGroupType=-1;
	int flowerPatchGroup=-1;

	// Also 1 "flowers" per player.
	for(i=1; <cNumberNonGaiaPlayers)
   {
		flowerPatchGroupType=rmRandInt(1, 8);
		flowerPatchGroup=rmCreateGrouping("Flower Patch Group"+i, "gp_flower0"+flowerPatchGroupType);
		rmSetGroupingMinDistance(flowerPatchGroup, 0.0);
		rmSetGroupingMaxDistance(flowerPatchGroup, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(flowerPatchGroup, avoidNW);
		rmAddGroupingConstraint(flowerPatchGroup, avoidSE);
		rmAddGroupingConstraint(flowerPatchGroup, avoidImpassableLand);
		rmAddGroupingConstraint(flowerPatchGroup, playerConstraint);
		rmAddGroupingConstraint(flowerPatchGroup, avoidTradeRoute);
		rmAddGroupingConstraint(flowerPatchGroup, avoidSocket);
		rmAddGroupingConstraint(flowerPatchGroup, avoidNuggetShort);
		rmAddGroupingConstraint(flowerPatchGroup, avoidAll);
		rmAddGroupingConstraint(flowerPatchGroup, circleConstraint);
		rmAddGroupingConstraint(flowerPatchGroup, avoidNativesShort);
		rmAddGroupingConstraint(flowerPatchGroup, avoidProp);
		rmAddGroupingConstraint(flowerPatchGroup, avoidTownCenter);
		rmAddGroupingConstraint(flowerPatchGroup, avoidStartingResources);
		rmAddGroupingConstraint(flowerPatchGroup, avoidPronghornShort);
		rmAddGroupingConstraint(flowerPatchGroup, avoidBisonShort);
		rmAddGroupingConstraint(flowerPatchGroup, avoidGoldShort);
		rmAddGroupingConstraint(flowerPatchGroup, avoidForestShort);
		rmPlaceGroupingAtLoc(flowerPatchGroup, 0, 0.5, 0.5, 1);
	}

   	// And a geyser
	int geyserID=rmCreateGrouping("Geysers", "prop_geyser");
	rmSetGroupingMinDistance(geyserID, 0.0);
	rmSetGroupingMaxDistance(geyserID, rmXFractionToMeters(0.5));
	rmAddGroupingToClass(geyserID, rmClassID("prop"));
	if (whichMap == 1)
		rmAddGroupingConstraint(geyserID, stayNW);
	else
		rmAddGroupingConstraint(geyserID, staySE);
	rmAddGroupingConstraint(geyserID, avoidNativesShort);
	rmAddGroupingConstraint(geyserID, avoidGoldShort);
	rmAddGroupingConstraint(geyserID, avoidPronghornShort);
	rmAddGroupingConstraint(geyserID, avoidTradeRouteSmall);
	rmAddGroupingConstraint(geyserID, avoidSocket);
	rmAddGroupingConstraint(geyserID, avoidForestShort);
	rmAddGroupingConstraint(geyserID, avoidProp);
	rmPlaceGroupingAtLoc(geyserID, 0, 0.5, 0.5);

   // Text
   rmSetStatusText("",1.0);

	// Disable Dock for Treaty thanks Eaglemut for this method that doesn't remove the dock from villager building options
	if (rmGetIsTreaty() == true) {
			rmCreateTrigger("dockForbidTrigger");
			rmSwitchToTrigger(rmTriggerID("dockForbidTrigger"));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
		
			for(i=1; <= cNumberNonGaiaPlayers) {
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

			for(i=1; <= cNumberNonGaiaPlayers) {
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

			for(i=1; <= cNumberNonGaiaPlayers) {
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "dePort");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// none
			}
		}
}