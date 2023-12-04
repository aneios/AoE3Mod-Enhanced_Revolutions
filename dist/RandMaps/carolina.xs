// CAROLINA
//Durokan's June 28 Update for DE (1v1 only)

// The First Age of Empires III Random Map
// Jan 2003
// Mar 2005
// Nov 2006 - Update to include Asians
// edited by vividlyplain, October 2021

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
  int whichNative = rmRandInt(1,2);

	// Strings
	string wetType = "carolinas coast";	
	string paintMix1 = "carolina_grassier";
	string paintMix2 = "carolina_grass";
	string paintMix3 = "carolina_grass_dry";
	string paintMix4 = "carolina_dirt";
	string paintMix5 = "carolina_forest";
	string forTesting = "testmix";	 
	string treasureSet = "carolina";
	string shineAlight = "Carolina_Skirmish";
	string toiletPaper = "dirt";
	string food1 = "deer";
	string food2 = "deer";
	string treeType1 = "TreeCarolinaGrass";
	string treeType2 = "TreeGreatPlains";
	string treeType3 = "TreeGreatLakes";
	string treeType4 = "TreeCaribbean";
	string fishies = "FishTarpon";
	string natType1 = "";
	string natType2 = "";
	string natGrpName1 = "";
	string natGrpName2 = "";
  if (whichNative == 1) {
  	natType1 = "Seminole";
	  natType2 = "Cherokee";
	  natGrpName1 = "native seminole village ";
	  natGrpName2 = "native cherokee village ";
    }
  else {
  	natType2 = "Seminole";
	  natType1 = "Cherokee";
	  natGrpName2 = "native seminole village ";
	  natGrpName1 = "native cherokee village ";
    }
	
	// Picks the map size
	int playerTiles=12500;
	if (PlayerNum >= 4)
		playerTiles = 11500;
	else if (PlayerNum >= 6)
		playerTiles = 10000;
	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(0);	
	rmSetMapElevationParameters(cElevTurbulence, 0.1, 1, 0.0, 0.5); // type, frequency, octaves, persistence, variation 
	
	// Picks default terrain and water
	rmSetSeaType(wetType);
//	rmSetBaseTerrainMix(paintMix1); 
	rmTerrainInitialize("grass", 0.0); 
	rmSetMapType(treasureSet); 
	rmSetMapType("water");
	rmSetLightingSet(shineAlight);
//	rmSetOceanReveal(true);

	// Choose Mercs
	chooseMercs();

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
	int classProp = rmDefineClass("prop");
	int classIsland=rmDefineClass("island");
	
	// Text
	rmSetStatusText("",0.10);
	
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
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", food2, 50.0);
	int avoidHunt2VeryFar = rmCreateTypeDistanceConstraint("avoid hunt2 very far", food2, 60.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", food2, 36.0);
	int avoidHunt2Med = rmCreateTypeDistanceConstraint("avoid hunt2 med", food2, 30.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", food2, 20.0);
	int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt2 min", food2, 10.0);	
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", food1, 50.0);
	int avoidHunt1VeryFar = rmCreateTypeDistanceConstraint("avoid hunt1 very far", food1, 66.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1", food1, 50.0);
	int avoidHunt1Med = rmCreateTypeDistanceConstraint("avoid hunt1 med", food1, 30.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short", food1, 20.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min", food1, 10.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 24.0); //15.0
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest medium", rmClassID("Forest"), 18.0); //15.0
	int avoidForestBase=rmCreateClassDistanceConstraint("avoid forest base", rmClassID("Forest"), 12.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 8.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 18.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin med ", "gold", 36.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 50.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 8.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 12.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold", rmClassID("Gold"), 30.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 42.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 54.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 68.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 6.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 12.0);
	int avoidNuggetMed = rmCreateTypeDistanceConstraint("nugget avoid nugget med", "AbstractNugget", 20.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 50.0);
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
	int avoidWhaleFar=rmCreateTypeDistanceConstraint("avoid whale far", "MinkeWhale", 36);
	int avoidWhale=rmCreateTypeDistanceConstraint("avoid whale", "MinkeWhale", 24);
	int avoidWhaleMin=rmCreateTypeDistanceConstraint("avoid whale min", "MinkeWhale", 4);
	int avoidFishShort=rmCreateTypeDistanceConstraint("avoid fish short", "FishTarpon", 10.0);
	int avoidFish=rmCreateTypeDistanceConstraint("avoid fish", "FishTarpon", 18.0);
	int avoidColonyShip = rmCreateTypeDistanceConstraint("avoid colony ship", "HomeCityWaterSpawnFlag", 6.0);
  int avoidBerries=rmCreateTypeDistanceConstraint("berry vs berry", "berryBush", 64.0);
  int avoidBerriesMin=rmCreateTypeDistanceConstraint("stuff vs berry", "berryBush", 4.0);

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
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 24.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 18.0);
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

if (PlayerNum == 2 || TeamNum > 2 || teamOneCount != teamZeroCount) {	
  	rmSetTeamSpacingModifier(0.50);
  	rmSetPlacementSection(0.73, 0.27); 
  	rmPlacePlayersCircular(0.36, 0.36, 0.02);
    }
else {
  	rmSetPlacementTeam(0);
    rmSetTeamSpacingModifier(0.50);
	if (teamZeroCount == 2)
	  	rmSetPlacementSection(0.10, 0.24); 
  	else
		rmSetPlacementSection(0.07, 0.27); 
  	rmPlacePlayersCircular(0.36, 0.36, 0.02);    

  	rmSetPlacementTeam(1);
    rmSetTeamSpacingModifier(0.50);
  	if (teamOneCount == 2)
		rmSetPlacementSection(0.76, 0.90); 
  	else
		rmSetPlacementSection(0.73, 0.93); 
  	rmPlacePlayersCircular(0.36, 0.36, 0.02);    
    }
   
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Map Parameters ____________________
	// Avoid This
	int avoidThisID = rmCreateArea("avoid this");
	rmSetAreaSize(avoidThisID, 0.02);
	rmSetAreaLocation(avoidThisID, 1.00, 0.35);
//	rmSetAreaMix(avoidThisID, forTesting);
//	rmSetAreaBaseHeight(avoidThisID, 5.0);		// for testing
	rmSetAreaWarnFailure(avoidThisID, false);
	rmSetAreaCoherence(avoidThisID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(avoidThisID, false);
//	rmBuildArea(avoidThisID);
	
	int avoidThis = rmCreateAreaDistanceConstraint("avoid this", avoidThisID, 20.0);

	// Main Land
	int mainlandID = rmCreateArea("main island");
	rmSetAreaSize(mainlandID, 0.67);
	rmSetAreaLocation(mainlandID, 0.50, 1.00);
	rmSetAreaMix(mainlandID, paintMix1);
	rmSetAreaWarnFailure(mainlandID, false);
	rmSetAreaCoherence(mainlandID, 0.90); 
	rmSetAreaElevationType(mainlandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainlandID, 1.0);
	rmSetAreaBaseHeight(mainlandID, 2.0);
	rmSetAreaElevationMinFrequency(mainlandID, 0.04);
	rmSetAreaElevationOctaves(mainlandID, 3);
	rmSetAreaElevationPersistence(mainlandID, 0.4);      
	rmSetAreaObeyWorldCircleConstraint(mainlandID, false);
	rmBuildArea(mainlandID);

	int dryGrassZoneID = rmCreateArea("dry grass zone");
	rmSetAreaSize(dryGrassZoneID, 0.07);
	rmSetAreaLocation(dryGrassZoneID, 0.50, 1.00);
	rmSetAreaMix(dryGrassZoneID, paintMix3);
	rmSetAreaWarnFailure(dryGrassZoneID, false);
	rmSetAreaCoherence(dryGrassZoneID, 0.222); 
	rmSetAreaObeyWorldCircleConstraint(dryGrassZoneID, false);
	rmBuildArea(dryGrassZoneID);

	int avoidMainLandMin = rmCreateAreaDistanceConstraint("avoid main land min", mainlandID, 0.5);
	int avoidMainLand = rmCreateAreaDistanceConstraint("avoid main land", mainlandID, 25.0);
	int avoidMainLandFar = rmCreateAreaDistanceConstraint("avoid main land far", mainlandID, 36.0);
	int avoidMainLandShort = rmCreateAreaDistanceConstraint("avoid main land short", mainlandID, 8.0);
	int stayInMainLand = rmCreateAreaMaxDistanceConstraint("stay in main land", mainlandID, 0.0);

	// Sea
	int seaID = rmCreateArea("sea");
	rmSetAreaSize(seaID, 0.33);
	rmSetAreaLocation(seaID, 0.50, 0.00);
	rmSetAreaWaterType(seaID, wetType);
	rmSetAreaWarnFailure(seaID, false);
	rmSetAreaCoherence(seaID, 1.00); 
	rmSetAreaObeyWorldCircleConstraint(seaID, false);
	rmAddAreaConstraint(seaID, avoidMainLandMin);
	rmBuildArea(seaID);

	int stayNearSea = rmCreateAreaMaxDistanceConstraint("stay near sea", seaID, 18.0);

	// ____________________ Trade Routes ____________________
	int tradeRouteID3 = rmCreateTradeRoute();
	
	int socketID3=rmCreateObjectDef("sockets to dock Trade Posts3");
		rmAddObjectDefItem(socketID3, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID3, true);
		rmSetObjectDefMinDistance(socketID3, 2.0);
		rmSetObjectDefMaxDistance(socketID3, 8.0);  
	
		rmSetObjectDefTradeRouteID(socketID3, tradeRouteID3);
		if (TeamNum == 2 && teamOneCount == teamZeroCount && PlayerNum == 6) {
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.15, 0.85);
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.55);
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.85, 0.85);
        }
		else if (TeamNum == 2 && teamOneCount == teamZeroCount) {
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.05, 0.70);
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.55);
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.95, 0.70);
        }
      else {
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.35);
        rmAddTradeRouteWaypoint(tradeRouteID3, 0.50, 0.75);
        }
	
		rmBuildTradeRoute(tradeRouteID3, toiletPaper);
	
		vector socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.20);
		rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
	
		socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.40);
		rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);

		socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.60);
		rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);
		
		socketLoc3 = rmGetTradeRouteWayPoint(tradeRouteID3, 0.80);
		rmPlaceObjectDefAtPoint(socketID3, 0, socketLoc3);

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) {	
		// Place King's Hill
		float xLoc = 0.50;
		float yLoc = 0.30;
		float walk = 0.00;
			
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}

	int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 8.0);
	
	// Text
	rmSetStatusText("",0.30);
		
	// Player areas
	for (i=1; < numPlayer)
	{
	int playerAreaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerAreaID);
	rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(222));
	rmSetAreaCoherence(playerAreaID, 0.33);
	rmSetAreaWarnFailure(playerAreaID, false);
	rmSetAreaMix(playerAreaID, paintMix3);	
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
	
	int whereNative = rmRandInt(1,2);
	if (PlayerNum == 6)
		whereNative = 2;

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
  
  if (TeamNum == 2 && teamOneCount == teamZeroCount) {
	  if (whereNative == 1) {
	    rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.40);
	    rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.90);
	    rmPlaceGroupingAtLoc(nativeID2, 0, 0.40, 0.70);
	    rmPlaceGroupingAtLoc(nativeID3, 0, 0.60, 0.70);
	  	}
		else {
	    rmPlaceGroupingAtLoc(nativeID0, 0, 0.50, 0.50);
	    rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.80);
	    rmPlaceGroupingAtLoc(nativeID2, 0, 0.30, 0.40);
	    rmPlaceGroupingAtLoc(nativeID3, 0, 0.70, 0.40);
	  	}
      }
  else {
	    rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.40);
	    rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.40);
	    rmPlaceGroupingAtLoc(nativeID2, 0, 0.60, 0.70);
	    rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.70);
      }

	// Bonus Islands
	float NLocX = 0.65;
	float NLocY = 0.075;
	float SLocX = 0.35;
	float SLocY = 0.075;
	
	int NislandID=rmCreateArea("N island");
	rmSetAreaSize(NislandID, 0.015);
	rmSetAreaLocation(NislandID, NLocX, NLocY);
	rmSetAreaMix(NislandID, paintMix2); 
	rmSetAreaObeyWorldCircleConstraint(NislandID, false);
	rmAddAreaToClass(NislandID, classIsland);
	rmSetAreaBaseHeight(NislandID, 2.0);
	rmSetAreaCoherence(NislandID, 0.80);
	rmAddAreaConstraint(NislandID, avoidMainLandFar);
	rmBuildArea(NislandID); 

	int SislandID=rmCreateArea("S island");
	rmSetAreaSize(SislandID, 0.015);
	rmSetAreaLocation(SislandID, SLocX, SLocY);
	rmSetAreaMix(SislandID, paintMix2); 
	rmSetAreaObeyWorldCircleConstraint(SislandID, false);
	rmAddAreaToClass(SislandID, classIsland);
	rmSetAreaBaseHeight(SislandID, 2.0);
	rmSetAreaCoherence(SislandID, 0.80);
	rmAddAreaConstraint(SislandID, avoidMainLandFar);
	rmBuildArea(SislandID); 

	int avoidNislandMin = rmCreateAreaDistanceConstraint("avoid N island min", NislandID, 4.0);
	int avoidNisland = rmCreateAreaDistanceConstraint("avoid N island", NislandID, 8.0);
	int avoidNislandFar = rmCreateAreaDistanceConstraint("avoid N island far", NislandID, 12.0);
	int stayNisland = rmCreateAreaMaxDistanceConstraint("stay near N island", NislandID, 0.0);
	int avoidSislandMin = rmCreateAreaDistanceConstraint("avoid S island min", SislandID, 4.0);
	int avoidSisland = rmCreateAreaDistanceConstraint("avoid S island", SislandID, 8.0);
	int avoidSislandFar = rmCreateAreaDistanceConstraint("avoid S island far", SislandID, 12.0);
	int staySisland = rmCreateAreaMaxDistanceConstraint("stay near S island", SislandID, 0.0);

	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	rmSetAreaSize(midIslandID, 0.40);
	rmSetAreaLocation(midIslandID, 0.50, 0.50);
//	rmSetAreaMix(midIslandID, "testmix"); 	// for testing
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.20);
	rmSetAreaLocation(midSmIslandID, 0.50, 0.50);
//	rmSetAreaMix(midSmIslandID, "himalayas_a"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 1.00);
	rmAddAreaConstraint(midSmIslandID, avoidNisland);
	rmAddAreaConstraint(midSmIslandID, avoidSisland);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	// Text
	rmSetStatusText("",0.40);
	
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
	rmAddObjectDefItem(playerGoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 12.0);
	rmSetObjectDefMaxDistance(playerGoldID, 14.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidNativesMin);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerGoldID, avoidImpassableLandMin);
	
	int playerGold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerGold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerGold2ID, 40.0); 
	rmSetObjectDefMaxDistance(playerGold2ID, 50.0); 
	rmAddObjectDefToClass(playerGold2ID, classStartingResource);
	rmAddObjectDefToClass(playerGold2ID, classGold);
	rmAddObjectDefConstraint(playerGold2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidNativesMin);
	rmAddObjectDefConstraint(playerGold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playerGold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerGold2ID, avoidImpassableLandMin);
	rmAddObjectDefConstraint(playerGold2ID, stayNearEdge);
		
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType1, 2, 2.0);
    rmSetObjectDefMinDistance(playerTreeID, 16);
    rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTreeID, avoidNativesMin);
	rmAddObjectDefConstraint(playerTreeID, avoidWaterFar);
	rmAddObjectDefConstraint(playerTreeID, avoidImpassableLandMin);

	int playerTree2ID = rmCreateObjectDef("player trees2");
	rmAddObjectDefItem(playerTree2ID, treeType1, 4, 7.0);
	rmAddObjectDefItem(playerTree2ID, treeType2, 4, 7.0);
	rmAddObjectDefItem(playerTree2ID, treeType3, 4, 7.0);
    rmSetObjectDefMinDistance(playerTree2ID, 40);
    rmSetObjectDefMaxDistance(playerTree2ID, 55);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidGoldMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidNativesMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidWaterFar);
	rmAddObjectDefConstraint(playerTree2ID, stayNearEdge);
	rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLandMin);

	// Starting berries
    int playerBerryID = rmCreateObjectDef("starting berries");
    rmAddObjectDefItem(playerBerryID, "BerryBush", 3, 3.0);
    rmSetObjectDefMinDistance(playerBerryID, 10.0);
    rmSetObjectDefMaxDistance(playerBerryID, 12.0);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);
	rmAddObjectDefConstraint(playerBerryID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerBerryID, avoidNativesMin);
	rmAddObjectDefConstraint(playerBerryID, avoidImpassableLandShort);

	// Starting herds
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, food1, 8, 3.0);
	rmSetObjectDefMinDistance(playerHerdID, 12.0);
	rmSetObjectDefMaxDistance(playerHerdID, 12.0);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerdID, avoidImpassableLandShort);
		
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(playerHerd2ID, food1, 10, 4.0);
    rmSetObjectDefMinDistance(playerHerd2ID, 40);
    rmSetObjectDefMaxDistance(playerHerd2ID, 50);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidForestMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerHerd2ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerHerd2ID, avoidWater);
	rmAddObjectDefConstraint(playerHerd2ID, stayNearEdge);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 26.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetMed);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidForestMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandShort);
	if (TeamNum == 2 && teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandFar);
	
	//Colony water shipment flag
	int shipmentflagID = rmCreateObjectDef("colony ship");
	rmAddObjectDefItem(shipmentflagID, "HomeCityWaterSpawnFlag", 1, 0.0);
	rmSetObjectDefMinDistance(shipmentflagID, rmXFractionToMeters(0.01));
	rmSetObjectDefMaxDistance(shipmentflagID, rmXFractionToMeters(0.10));
	rmAddObjectDefConstraint(shipmentflagID, avoidFlag);
	rmAddObjectDefConstraint(shipmentflagID, avoidLand);
	rmAddObjectDefConstraint(shipmentflagID, avoidEdge);

	// Bonus Crates
	int playerCrateID=rmCreateObjectDef("bonus crates");
	rmAddObjectDefItem(playerCrateID, "crateOfFood", rmRandInt(2, 2), 4.0);	// 2,3
	rmAddObjectDefItem(playerCrateID, "crateOfWood", rmRandInt(1, 1), 4.0);	// 1,2
	rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 4.0);
	rmSetObjectDefMinDistance(playerCrateID, 8.0);
	rmSetObjectDefMaxDistance(playerCrateID, 12.0);
	rmAddObjectDefToClass(playerCrateID, classStartingResource);
	rmAddObjectDefConstraint(playerCrateID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerCrateID, avoidTradeRouteSocketMin);
	
	// Place Starting Objects	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
		rmPlaceObjectDefAtLoc(shipmentflagID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), 0.20);
		vector flagLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(shipmentflagID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerBerryID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));	
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));	
	}
		
	// Text
	rmSetStatusText("",0.50);

	// ____________________ Common Resources ____________________
	// Common Mines 
	int goldcount = 3*PlayerNum; 

	int goldID = rmCreateObjectDef("gold");
		rmAddObjectDefItem(goldID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidGoldFar);
		rmAddObjectDefConstraint(goldID, avoidIslandFar);
		rmAddObjectDefConstraint(goldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(goldID, avoidKOTH);
		rmAddObjectDefConstraint(goldID, avoidWaterFar);
		rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50, goldcount);

	int berriesID = rmCreateObjectDef("berries");
		rmAddObjectDefItem(berriesID, "berrybush", 6, 6.0);
		rmSetObjectDefMinDistance(berriesID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(berriesID, rmXFractionToMeters(0.05));
		rmAddObjectDefToClass(berriesID, classGold);
		rmAddObjectDefConstraint(berriesID, avoidGoldMin);
		rmAddObjectDefConstraint(berriesID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(berriesID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(berriesID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(berriesID, avoidEdge);
		rmAddObjectDefConstraint(berriesID, avoidIsland);
		rmAddObjectDefConstraint(berriesID, avoidNatives);
		rmPlaceObjectDefAtLoc(berriesID, 0, 0.10, 0.65);
		rmPlaceObjectDefAtLoc(berriesID, 0, 0.90, 0.65);

	int berries2ID = rmCreateObjectDef("berries2");
		rmAddObjectDefItem(berries2ID, "berrybush", 6, 6.0);
		rmSetObjectDefMinDistance(berries2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(berries2ID, rmXFractionToMeters(0.35));
		rmAddObjectDefToClass(berries2ID, classGold);
		rmAddObjectDefConstraint(berries2ID, avoidGoldMin);
		rmAddObjectDefConstraint(berries2ID, avoidIslandShort);
		rmAddObjectDefConstraint(berries2ID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(berries2ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(berries2ID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(berries2ID, avoidEdge);
		rmAddObjectDefConstraint(berries2ID, avoidNatives);
		rmAddObjectDefConstraint(berries2ID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(berries2ID, avoidKOTH);
		rmAddObjectDefConstraint(berries2ID, avoidBerries);
		rmAddObjectDefConstraint(berries2ID, avoidWaterFar);
		rmPlaceObjectDefAtLoc(berries2ID, 0, 0.50, 0.50, PlayerNum);

	rmSetStatusText("",0.60);

	// Palm Trees 
	int beachPalmID = rmCreateObjectDef("beach trees");
		rmAddObjectDefItem(beachPalmID, treeType4, 8, 6.0);
		rmSetObjectDefMinDistance(beachPalmID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(beachPalmID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(beachPalmID, classForest);
		rmAddObjectDefConstraint(beachPalmID, avoidForestMed);
		rmAddObjectDefConstraint(beachPalmID, avoidGoldMin);
		rmAddObjectDefConstraint(beachPalmID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(beachPalmID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(beachPalmID, avoidNativesMin);
		rmAddObjectDefConstraint(beachPalmID, stayInMainLand);
		rmAddObjectDefConstraint(beachPalmID, stayNearSea);
		rmAddObjectDefConstraint(beachPalmID, avoidWater);
		rmAddObjectDefConstraint(beachPalmID, avoidStartingResources);
		rmAddObjectDefConstraint(beachPalmID, avoidIsland);
		rmPlaceObjectDefAtLoc(beachPalmID, 0, 0.50, 0.50, 4+3*PlayerNum);

	int isleNuggetID = rmCreateObjectDef("nugget Isle"); 
		rmAddObjectDefItem(isleNuggetID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(isleNuggetID, 0);
		rmSetObjectDefMaxDistance(isleNuggetID, rmXFractionToMeters(0.05));
		if (PlayerNum > 2 && rmGetIsTreaty() == false)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(3,3);
    rmAddObjectDefConstraint(isleNuggetID, avoidWaterShort);
		rmPlaceObjectDefAtLoc(isleNuggetID, 0, NLocX, NLocY, 1+PlayerNum/4);
		rmPlaceObjectDefAtLoc(isleNuggetID, 0, SLocX, SLocY, 1+PlayerNum/4);

	int northTreeID = rmCreateObjectDef("north tree");
		rmAddObjectDefItem(northTreeID, treeType4, 4, 6.0);
		rmSetObjectDefMinDistance(northTreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(northTreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(northTreeID, classForest);
		rmAddObjectDefConstraint(northTreeID, stayNisland);
		rmAddObjectDefConstraint(northTreeID, avoidForestShort);
		rmAddObjectDefConstraint(northTreeID, avoidWaterShort);
		rmAddObjectDefConstraint(northTreeID, avoidNuggetShort);
		rmPlaceObjectDefAtLoc(northTreeID, 0, 0.50, 0.50, 1+PlayerNum/2);

	int southTreeID = rmCreateObjectDef("south tree");
		rmAddObjectDefItem(southTreeID, treeType4, 4, 6.0);
		rmSetObjectDefMinDistance(southTreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(southTreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(southTreeID, classForest);
		rmAddObjectDefConstraint(southTreeID, staySisland);
		rmAddObjectDefConstraint(southTreeID, avoidForestShort);
		rmAddObjectDefConstraint(southTreeID, avoidWaterShort);
		rmAddObjectDefConstraint(southTreeID, avoidNuggetShort);
		rmPlaceObjectDefAtLoc(southTreeID, 0, 0.50, 0.50, 1+PlayerNum/2);
		
	// Text
	rmSetStatusText("",0.70);

	// Main forest patches
	int mainforestcount = 10+10*PlayerNum;
	int stayInForestPatch = -1;
	int treeWater = rmCreateTerrainDistanceConstraint("trees avoid water", "Land", false, 6.0);

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(111));
		rmSetAreaMix(forestpatchID, paintMix5);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocketMin);
		if (PlayerNum == 2)
			rmAddAreaConstraint(forestpatchID, avoidForest);
		else
			rmAddAreaConstraint(forestpatchID, avoidForestMed);
		rmAddAreaConstraint(forestpatchID, avoidWaterFar);
		rmAddAreaConstraint(forestpatchID, avoidStartingResources);
		rmAddAreaConstraint(forestpatchID, avoidIslandFar);
		rmAddAreaConstraint(forestpatchID, avoidGoldMin);
		rmAddAreaConstraint(forestpatchID, avoidKOTH);
		rmAddAreaConstraint(forestpatchID, avoidBerriesMin);
		rmAddAreaConstraint(forestpatchID, avoidNatives);
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
			rmAddObjectDefItem(foresttreeID, treeType1, 2, 6.0);
			rmAddObjectDefItem(foresttreeID, treeType2, 2, 6.0);
			rmAddObjectDefItem(foresttreeID, treeType3, 2, 6.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefToClass(foresttreeID, classForest);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmAddObjectDefConstraint(foresttreeID, avoidTradeRouteSocketMin);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50, 3);
    }

	// Text
	rmSetStatusText("",0.80);

	// Trees 
	int treeCount = rmRandInt(1,4);
	
	int randomTreeID = rmCreateObjectDef("random tree");
		rmAddObjectDefItem(randomTreeID, treeType1, treeCount, 5.0);
		rmAddObjectDefItem(randomTreeID, treeType2, 4-treeCount, 5.0);
		rmSetObjectDefMinDistance(randomTreeID,  rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(randomTreeID,  rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(randomTreeID, classForest);
		rmAddObjectDefConstraint(randomTreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomTreeID, avoidIslandShort);
		rmAddObjectDefConstraint(randomTreeID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(randomTreeID, avoidWaterFar);
		rmAddObjectDefConstraint(randomTreeID, avoidNativesMin);
		rmAddObjectDefConstraint(randomTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(randomTreeID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(randomTreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(randomTreeID, avoidKOTH);
		rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.50, 0.50, 4+5*PlayerNum);

	// Hunts 
	int herdcount = 5*PlayerNum;
	
	int commonHuntID = rmCreateObjectDef("common herd");
		rmAddObjectDefItem(commonHuntID, food1, 8, 3.0);
		rmSetObjectDefMinDistance(commonHuntID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(commonHuntID, rmXFractionToMeters(0.48));
		rmSetObjectDefCreateHerd(commonHuntID, true);
		rmAddObjectDefConstraint(commonHuntID, avoidTownCenterFar);
		rmAddObjectDefConstraint(commonHuntID, avoidGoldMin);
		rmAddObjectDefConstraint(commonHuntID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(commonHuntID, avoidForestMin);
		rmAddObjectDefConstraint(commonHuntID, avoidIslandFar);
		rmAddObjectDefConstraint(commonHuntID, avoidHunt1Far);
		rmAddObjectDefConstraint(commonHuntID, avoidEdge);
		rmAddObjectDefConstraint(commonHuntID, avoidNativesMin);
		rmAddObjectDefConstraint(commonHuntID, stayInMainLand);
		rmAddObjectDefConstraint(commonHuntID, avoidWaterFar);
		rmAddObjectDefConstraint(commonHuntID, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(commonHuntID, 0, 0.50, 0.50, herdcount);

	// Text
	rmSetStatusText("",0.90);

	// Treasures 
	int treasure1count = 4+PlayerNum;
	int treasure2count = 2*PlayerNum;
	int treasure3count = PlayerNum;
	
	// 	Treasures L3
	int Nugget3ID = rmCreateObjectDef("nugget L3and4"); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.48));
		if (PlayerNum > 2 && rmGetIsTreaty() == false)
			rmSetNuggetDifficulty(3,4);
		else
			rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidIslandFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidWaterShort);
		rmAddObjectDefConstraint(Nugget3ID, stayInMainLand);
		if (PlayerNum > 2)
      rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, treasure3count);
		
	// Treasures L2	
	int Nugget2ID = rmCreateObjectDef("nugget L2 "); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.37));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidIslandFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidStartingResources);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidBerriesMin);
		rmAddObjectDefConstraint(Nugget2ID, stayInMainLand);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, treasure2count);
	
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
		rmAddObjectDefConstraint(Nugget1ID, avoidHunt2Min);	
		rmAddObjectDefConstraint(Nugget1ID, avoidBerriesMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget1ID, avoidWaterMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(Nugget1ID, stayInMainLand);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50, treasure1count);

	// Text
	rmSetStatusText("",0.95);
	
	// Sea Resources 
	int fishcount = 7+5*PlayerNum/2;
	int whalecount = 2+PlayerNum;
	
	//Whales
	int whaleID=rmCreateObjectDef("whale");
		rmAddObjectDefItem(whaleID, "MinkeWhale", 1, 0.0);
		rmSetObjectDefMinDistance(whaleID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.05));
		rmAddObjectDefConstraint(whaleID, avoidLand);
		rmAddObjectDefConstraint(whaleID, avoidColonyShip);
		rmAddObjectDefConstraint(whaleID, avoidEdge);
		rmAddObjectDefConstraint(whaleID, avoidTradeRouteMin);
		rmAddObjectDefConstraint(whaleID, avoidTradeRouteSocket);
		if (PlayerNum > 4) {
			  rmPlaceObjectDefAtLoc(whaleID, 0, 0.75, 0.15);
			  rmPlaceObjectDefAtLoc(whaleID, 0, 0.25, 0.15);
        }
      if (PlayerNum > 2)
		    	rmPlaceObjectDefAtLoc(whaleID, 0, 0.50, 0.10);
      rmPlaceObjectDefAtLoc(whaleID, 0, 0.85, 0.20);
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.15, 0.20);
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.40, 0.20);
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.60, 0.20);
		
	//Fishes
	int fishID = rmCreateObjectDef("fish");
		rmAddObjectDefItem(fishID, "FishTarpon", 1, 0.0);
		rmSetObjectDefMinDistance(fishID, 0.00);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(fishID, avoidFish);
		rmAddObjectDefConstraint(fishID, avoidWhaleMin);
		rmAddObjectDefConstraint(fishID, avoidLand);
		rmAddObjectDefConstraint(fishID, avoidEdge);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.50, 0.50, fishcount);

	int fish2ID = rmCreateObjectDef("fish2");
		rmAddObjectDefItem(fish2ID, "FishTarpon", 1, 0.0);
		rmSetObjectDefMinDistance(fish2ID, 0.00);
		rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(fish2ID, avoidFishShort);
		rmAddObjectDefConstraint(fish2ID, avoidWhaleMin);
		rmAddObjectDefConstraint(fish2ID, avoidLand);
		rmAddObjectDefConstraint(fish2ID, avoidEdge);
		rmPlaceObjectDefAtLoc(fish2ID, 0, 0.50, 0.50, fishcount);

	// Text
	rmSetStatusText("",1.00);
	
} // END