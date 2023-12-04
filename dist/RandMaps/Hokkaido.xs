//Durokan's Hokkaido
//rebuilt from mt.fuji
//Ported by Durokan and Interjection for DE
// April 2021 edited by vividlyplain for DE

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
 
void main(void) {
 
   // Picks the map size
	int playerTiles=11000;
	if (cNumberNonGaiaPlayers > 4){
		playerTiles = 10000;
	}else if (cNumberNonGaiaPlayers > 6){
		playerTiles = 8500;
	}
	
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

    // Picks default terrain and water
    // rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
    rmSetMapElevationParameters(cElevTurbulence, 0.1, 4, 0.2, 3.0);
    rmSetBaseTerrainMix("coastal_honshu_b");
    rmTerrainInitialize("coastal_japan\ground_dirt4_co_japan", 0.0);
    // rmSetMapElevationParameters(long type, float minFrequency, long numberOctaves, float persistence, float heightVariation)
//    rmSetMapElevationParameters(cElevTurbulence, 0.04, 5, 0.2, 4);

   rmSetMapType("land");
   rmSetMapType("Japan");
//   rmTerrainInitialize("grass");
   rmSetLightingSet("Hokkaido_Skirmish");

   rmDefineClass("classForest");
   rmDefineClass("classPlateau");
   rmDefineClass("socketClass");
		
   //Constraints
   int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 16.0);
   int avoidPlateau2=rmCreateClassDistanceConstraint("stuff vs. cliffs2", rmClassID("classPlateau"), 10.0);
   int avoidPlateauShort=rmCreateClassDistanceConstraint("stuff vs. cliffs2 short", rmClassID("classPlateau"), 6.0);

   int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));

   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
   int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);

   int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
   int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 10.0);

   int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 50.0);
   int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "herdable", 35.0);

   int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 20.0);
   int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 52.0);
   int avoidGold=rmCreateTypeDistanceConstraint("avoid coin medium typo now fixed", "Mine", 35.0);
   //int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);
   int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 8.0);

   int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 6.0);
   int avoidSocket=rmCreateTypeDistanceConstraint("socket avoidance", "SocketTradeRoute", 16.0);
   int avoidSocket2=rmCreateTypeDistanceConstraint("socket avoidance gold", "SocketTradeRoute", 12.0);

   int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 44.0);
   int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 15.0);
   int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 52.0);  
   int avoidTownCenterLess=rmCreateTypeDistanceConstraint("avoid Town Center less", "townCenter", 35.0);  

   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 65.0);
       
   int goldBuffer=rmCreateTypeDistanceConstraint("avoids mines by tiny", "Mine", 3.0);
   int nuggetbuffer=rmCreateTypeDistanceConstraint("avoids nuggets by tiny", "AbstractNugget", 3.0);
   int huntBuffer=rmCreateTypeDistanceConstraint("avoids hunts by tiny", "huntable", 3.0);
   int herdBuffer=rmCreateTypeDistanceConstraint("avoids herds by tiny", "herdable", 3.0);
   
    int avoidAll=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
    int southSection = rmDefineClass("southSection");
    int avoidSouthSection=rmCreateClassDistanceConstraint("avoid southSection", southSection, 5.0);
    int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land2", "Land", false, 8.0);

rmSetStatusText("",0.0);
   // Player placing  
   float spawnSwitch = rmRandFloat(0,1.2);
   float extraSpawnLen = 0.0;
   if(cNumberNonGaiaPlayers >6){
      extraSpawnLen = .05;
   }
   
   if(cNumberNonGaiaPlayers == 2){
      if (spawnSwitch<0.6) {	
         rmPlacePlayer(1, 0.175, 0.575);
         rmPlacePlayer(2, 0.575, 0.175);
      }else{
         rmPlacePlayer(2, 0.175, 0.575);
         rmPlacePlayer(1, 0.575, 0.175);
      }
   }else{
      if (cNumberTeams == 2){
         if (spawnSwitch <=0.6){
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.50-extraSpawnLen, 0.2, 0.75+extraSpawnLen, 0.25, 0, 0);
            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.2, 0.5-extraSpawnLen, 0.25, 0.75+extraSpawnLen, 0, 0);
         }else if(spawnSwitch <=1.2){
            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.50-extraSpawnLen, 0.2, 0.75+extraSpawnLen, 0.25, 0, 0);
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.2, 0.5-extraSpawnLen, 0.25, 0.75+extraSpawnLen, 0, 0);
         }
      }else{
         rmSetPlacementSection(.25, .98);
		rmSetTeamSpacingModifier(0.50);
         rmPlacePlayersCircular(0.3, 0.3, 0.02);
      }
   }
   chooseMercs();

   string g1 = "coastal_japan\ground_dirt4_co_japan";
   string g2 = "coastal_japan\ground_grass3_co_japan";
   string g3 = "coastal_japan\ground_grass1_co_japan";
   

    
//"coastal_japan\ground_grass3_co_japan"
   int continent2 = rmCreateArea("continent");
   rmSetAreaSize(continent2, 1.0, 1.0);
   rmSetAreaLocation(continent2, 0.5, 0.5);
   //rmSetAreaTerrainType(continent2, g1);
   rmSetAreaMix(continent2, "coastal_honshu_b");
   rmSetAreaCoherence(continent2, 1.0);
   rmBuildArea(continent2); 

   int classPatch = rmDefineClass("patch");
   int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);
   int classCenter = rmDefineClass("center");
   int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 3.0);
   int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int circleConstraint3=rmCreatePieConstraint("circle Constraint3", 0.5, 0.5, 0, rmZFractionToMeters(0.46), rmDegreesToRadians(0), rmDegreesToRadians(360));

   int center = rmCreateArea("center");
   rmAddAreaToClass(center, rmClassID("center"));
   rmSetAreaSize(center, .1, .1);
   rmSetAreaLocation(center, 0.5, 0.5);
   rmSetAreaCoherence(center, 1.0);
   rmBuildArea(center);    

      
   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmSetObjectDefMinDistance(socketID, 2.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);
   int tradeRouteID = rmCreateTradeRoute();
   
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   //have to draw the route backwards IFF 3 players because it doesnt draw for 3 players only for some reason.
   if(cNumberNonGaiaPlayers == 3){
      rmAddTradeRouteWaypoint(tradeRouteID, .2, .98);
      rmAddTradeRouteWaypoint(tradeRouteID, .4, .75);
      rmAddTradeRouteWaypoint(tradeRouteID, .6, .7);
      rmAddTradeRouteWaypoint(tradeRouteID, .7, .98);
   }else{
      rmAddTradeRouteWaypoint(tradeRouteID, .7, .98); 
      rmAddTradeRouteWaypoint(tradeRouteID, .6, .7);
      rmAddTradeRouteWaypoint(tradeRouteID, .4, .75);
      rmAddTradeRouteWaypoint(tradeRouteID, .2, .98);  
   }
      
   rmBuildTradeRoute(tradeRouteID, "water");
   
   vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, -1);//this just defines socketLoc1, doesn't use this value

   if(cNumberNonGaiaPlayers < 4){
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.27);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
   }else{
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
      socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
      rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
   }
   rmSetStatusText("",0.1);
   
   //tr2 (right side)
   
   int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
   rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID2, true);
   rmSetObjectDefMinDistance(socketID2, 0.0);
   rmSetObjectDefMaxDistance(socketID2, 6.0);
   int tradeRouteID2 = rmCreateTradeRoute();

   rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
   //have to draw the route backwards IFF 3 players because it doesnt draw for 3 players only for some reason.
   if(cNumberNonGaiaPlayers == 3){
      rmAddTradeRouteWaypoint(tradeRouteID2, .99, .2);
      rmAddTradeRouteWaypoint(tradeRouteID2, .75, .4);
      rmAddTradeRouteWaypoint(tradeRouteID2, .7, .6);
      rmAddTradeRouteWaypoint(tradeRouteID2, .99, .7);
   }else{
      rmAddTradeRouteWaypoint(tradeRouteID2, .99, .7);
      rmAddTradeRouteWaypoint(tradeRouteID2, .7, .6);
      rmAddTradeRouteWaypoint(tradeRouteID2, .75, .4);
      rmAddTradeRouteWaypoint(tradeRouteID2, .99, .2);
   }
   rmBuildTradeRoute(tradeRouteID2, "water");

   
   vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, -1);//this just defines socketLoc2, doesn't use this value

   if(cNumberNonGaiaPlayers < 4){
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.27);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.7);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
   }else{
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.2);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.5);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
      socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.8);
      rmPlaceObjectDefAtPoint(socketID2, 0, socketLoc2);
   }
   
   rmSetStatusText("",0.2);
      
   //Natives
   rmDefineClass("natives");

   int subCiv0 = -1;
   int subCiv1 = -1;
   subCiv0 = rmGetCivID("zen");
   subCiv1 = rmGetCivID("zen");
   rmSetSubCiv(0, "zen");
   rmSetSubCiv(1, "zen");

   int nativeID0 = -1;
   int nativeID1 = -1;

   nativeID0 = rmCreateGrouping("zen temple", "native zen temple cj 0"+4);
   rmSetGroupingMinDistance(nativeID0, 0.00);
   rmSetGroupingMaxDistance(nativeID0, 0.00);
   rmAddGroupingToClass(nativeID0, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeID0, 0, 0.55, 0.9);

   nativeID1 = rmCreateGrouping("zen temple ", "native zen temple cj 0"+5);
   rmSetGroupingMinDistance(nativeID1, 0.00);
   rmSetGroupingMaxDistance(nativeID1, 0.00);
   rmAddGroupingToClass(nativeID1, rmClassID("natives"));
   rmPlaceGroupingAtLoc(nativeID1, 0, 0.9, 0.55); 

   int straightLake=rmCreateArea("straightLake");
   rmSetAreaLocation(straightLake, 0.0, 0.3);
   rmAddAreaInfluenceSegment(straightLake, 0.0, 0.3, 0.3, .0);
   rmSetAreaSize(straightLake, .14, .14);      
   rmSetAreaWaterType(straightLake, "Coastal Japan");
   rmSetAreaBaseHeight(straightLake, 0.0);
   rmSetAreaCoherence(straightLake, .92);
   rmBuildArea(straightLake);
   rmSetStatusText("",0.3);

	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	rmSetAreaSize(midIslandID, 0.33);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
//	rmSetAreaMix(midIslandID, "testmix"); 	// for testing
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
	
//builds the central mountain
    //botCakeTower1
    int botCakeTower1 = rmCreateArea("botCakeTower1");
    rmSetAreaSize(botCakeTower1, 0.0495); // 0.055
    rmAddAreaToClass(botCakeTower1, rmClassID("classPlateau"));
    //rmAddAreaTerrainReplacement(botCakeTower1, "texas\ground4_tex", "california\ground6_cal"); //idk why cali works, dont touch it
    rmSetAreaCliffType(botCakeTower1, "Coastal Honshu");
    rmSetAreaCliffEdge(botCakeTower1, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
    rmSetAreaCliffPainting(botCakeTower1, true, true, true, 1.5, true);
    rmSetAreaCliffHeight(botCakeTower1, 4, 0.1, 0.5);
    rmSetAreaCoherence(botCakeTower1, .8);
    rmSetAreaLocation(botCakeTower1, .5, .5);		
    rmBuildArea(botCakeTower1);

    //botCakeTower2
    int botCakeTower2 = rmCreateArea("botCakeTower2");
    rmSetAreaSize(botCakeTower2, 0.027); // 0.03
    rmAddAreaToClass(botCakeTower2, rmClassID("classPlateau"));
    //rmAddAreaTerrainReplacement(botCakeTower2, "texas\ground4_tex", "california\ground6_cal"); //idk why cali works, dont touch it
    rmSetAreaCliffType(botCakeTower2, "Coastal Honshu");
    rmSetAreaCliffEdge(botCakeTower2, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
    rmSetAreaCliffPainting(botCakeTower2, true, true, true, 1.5, true);
    rmSetAreaCliffHeight(botCakeTower2, 4, 0.1, 0.5);
    rmSetAreaCoherence(botCakeTower2, .8);
    rmSetAreaLocation(botCakeTower2, .5, .5);		
    rmBuildArea(botCakeTower2);

    //botCakeTower3
    int botCakeTower3 = rmCreateArea("botCakeTower3");
    rmSetAreaSize(botCakeTower3, 0.0135); // 0.015
    rmAddAreaToClass(botCakeTower3, rmClassID("classPlateau"));
    //rmAddAreaTerrainReplacement(botCakeTower3, "texas\ground4_tex", "california\ground6_cal"); //idk why cali works, dont touch it
    rmSetAreaCliffType(botCakeTower3, "Coastal Honshu");
    rmSetAreaCliffEdge(botCakeTower3, 1, 1.0, 0.0, 0.0, 2); //4,.225 looks cool too
    rmSetAreaCliffPainting(botCakeTower3, true, true, true, 1.5, true);
    rmSetAreaCliffHeight(botCakeTower3, 4, 0.1, 0.5);
    rmSetAreaCoherence(botCakeTower3, .8);
    rmSetAreaLocation(botCakeTower3, .5, .5);		
    rmBuildArea(botCakeTower3);
   rmSetStatusText("",0.4);
   //starting objects

   int playerStart = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(playerStart, 6.0);
   rmSetObjectDefMaxDistance(playerStart, 9.0);

    //beautiful and symmetric first / second mines
    int classStartingResource = rmDefineClass("startingResource");
    int classGold = rmDefineClass("Gold");
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type  far ", "gold", 34.0);
    int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
    int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other short", rmClassID("startingResource"), 4.0);

    int baseGold = rmCreateObjectDef("starting gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold, 14.0);
    rmSetObjectDefMaxDistance(baseGold, 14.0);
    rmAddObjectDefToClass(baseGold, classStartingResource);
    rmAddObjectDefToClass(baseGold, classGold);
    //rmAddObjectDefConstraint(baseGold, avoidTradeRouteSmall);
    //rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
    //rmAddObjectDefConstraint(baseGold, avoidStartingResources);

    int baseGold2 = rmCreateObjectDef("starting gold2");
    rmAddObjectDefItem(baseGold2, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold2, 24.0);
    rmSetObjectDefMaxDistance(baseGold2, 26.0);
    rmAddObjectDefToClass(baseGold2, classStartingResource);
    rmAddObjectDefToClass(baseGold2, classGold);
    rmAddObjectDefConstraint(baseGold2, avoidTradeRouteSmall);
    //rmAddObjectDefConstraint(baseGold2, avoidImpassableLand);
    rmAddObjectDefConstraint(baseGold2, avoidStartingResources);
    rmAddObjectDefConstraint(baseGold2, avoidCoin);
    if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(baseGold2, avoidMidIslandFar);

   int berryID = rmCreateObjectDef("starting berries");
   rmAddObjectDefItem(berryID, "BerryBush", 5, 4.0);
   rmSetObjectDefMinDistance(berryID, 14.0);
   rmSetObjectDefMaxDistance(berryID, 14.0);
   rmAddObjectDefToClass(berryID, classStartingResource);
   rmAddObjectDefConstraint(berryID, avoidStartingResources);

   int treeID = rmCreateObjectDef("starting trees");
   rmAddObjectDefItem(treeID, "ypTreeJapaneseMaple", 7, 10.0);
   rmSetObjectDefMinDistance(treeID, 16.0);
   rmSetObjectDefMaxDistance(treeID, 18.0);
   rmAddObjectDefToClass(treeID, classStartingResource);
   rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
   rmAddObjectDefConstraint(treeID, avoidStartingResources);

   int foodID = rmCreateObjectDef("starting hunt");
   rmAddObjectDefItem(foodID, "ypSerow", 6, 3.0);
   rmSetObjectDefMinDistance(foodID, 10.0);
   rmSetObjectDefMaxDistance(foodID, 12.0);
   rmSetObjectDefCreateHerd(foodID, true);
   rmAddObjectDefToClass(foodID, classStartingResource);
   rmAddObjectDefConstraint(foodID, avoidStartingResources);

   int foodID2 = rmCreateObjectDef("starting hunt 2");
   rmAddObjectDefItem(foodID2, "ypSerow", 8, 7.0);
   rmSetObjectDefMinDistance(foodID2, 30.0);
   rmSetObjectDefMaxDistance(foodID2, 32.0);
   rmAddObjectDefToClass(foodID2, classStartingResource);
   rmAddObjectDefConstraint(foodID2, avoidWaterShort);
   rmAddObjectDefConstraint(foodID2, avoidStartingResources);
   rmSetObjectDefCreateHerd(foodID2, true);

   int foodID3 = rmCreateObjectDef("starting hunt 3");
   rmAddObjectDefItem(foodID3, "ypSerow", 12, 7.0);
   rmSetObjectDefMinDistance(foodID3, 46.0);
   rmSetObjectDefMaxDistance(foodID3, 50.0);
   rmAddObjectDefToClass(foodID3, classStartingResource);
   rmAddObjectDefConstraint(foodID3, avoidWaterShort);
   rmAddObjectDefConstraint(foodID3, avoidStartingResources);
   rmAddObjectDefConstraint(foodID3, circleConstraint3);
   rmAddObjectDefConstraint(foodID3, avoidMidIslandFar);
   rmSetObjectDefCreateHerd(foodID3, true);

   int playerNuggetID = rmCreateObjectDef("starting nugget");
   rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
   rmSetNuggetDifficulty(1,1);
   rmSetObjectDefMinDistance(playerNuggetID, 18.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 22.0);
   rmAddObjectDefToClass(playerNuggetID, classStartingResource);
   rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);

      rmSetStatusText("",0.5);

   int flagLand = rmCreateTerrainDistanceConstraint("flag land", "land", true, 9.0);

   float locSwitcher = 0.0;
   for(i=1; < cNumberNonGaiaPlayers + 1) {
      int id=rmCreateArea("Player"+i);
      rmSetPlayerArea(i, id);
      int startID = rmCreateObjectDef("object"+i);
		if(rmGetNomadStart()){
			rmAddObjectDefItem(startID, "CoveredWagon", 1, 5.0);
		}else{
			rmAddObjectDefItem(startID, "TownCenter", 1, 0.0);
		}      
		rmAddObjectDefToClass(startID, classStartingResource);
        rmSetObjectDefMinDistance(startID, 0.0);
        int teamZeroCount_dk = rmGetNumberPlayersOnTeam(0);
        int teamOneCount_dk = rmGetNumberPlayersOnTeam(1);
        
        if(cNumberTeams == 2 && cNumberNonGaiaPlayers >= 6 && teamZeroCount_dk != teamOneCount_dk)
            rmSetObjectDefMaxDistance(startID, 15.0);
        else
            rmSetObjectDefMaxDistance(startID, 0.0);

      rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }
      for(i=1; < cNumberNonGaiaPlayers + 1) {
      rmPlaceObjectDefAtLoc(baseGold, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(baseGold2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      if (cNumberNonGaiaPlayers == 2)
         rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      /*
      if (ypIsAsian(i) && rmGetNomadStart() == false)
		{
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
        }*/
        
      int waterFlag = rmCreateObjectDef("HC water flag "+i);
      rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 0.0);
      rmSetObjectDefMinDistance(waterFlag, 0);
      rmSetObjectDefMaxDistance(waterFlag, 20);

      /*if(cNumberNonGaiaPlayers > 5){
         rmSetObjectDefMaxDistance(waterFlag, 55);
      }else{
         rmSetObjectDefMaxDistance(waterFlag, 85);
      }*/
      //avoidshore
      //circleconstraint
      rmAddObjectDefConstraint(waterFlag, circleConstraint);
      rmAddObjectDefConstraint(waterFlag, flagLand);

      locSwitcher = rmPlayerLocXFraction(i);
      if(locSwitcher > rmPlayerLocZFraction(i)){
         rmPlaceObjectDefAtLoc(waterFlag, i, .3, .125, 1);
         locSwitcher = rmPlayerLocZFraction(i);
      }else{
         rmPlaceObjectDefAtLoc(waterFlag, i, .125, .3, 1);

      }
      /*locSwitcher = locSwitcher - .05;*/
      //rmPlaceObjectDefAtLoc(waterFlag, i, rmPlayerLocXFraction(i)-locSwitcher, rmPlayerLocZFraction(i)-locSwitcher, 1);      
	}
	rmSetStatusText("",0.6);
	/*
	==================
	resource placement
	==================
	*/

	int bigBerryPatches = rmCreateObjectDef("bigBerryPatches");
	rmAddObjectDefItem(bigBerryPatches, "BerryBush", 8, 12.0);
	rmSetObjectDefMinDistance(bigBerryPatches, 0.0);
	rmSetObjectDefMaxDistance(bigBerryPatches, 5.0);
	rmPlaceObjectDefAtLoc(bigBerryPatches, 0, 0.72, 0.72, 1);
	rmPlaceObjectDefAtLoc(bigBerryPatches, 0, 0.35, 0.35, 1);

    int southSectionDot = rmCreateArea("southSectionDot");
    rmAddAreaToClass(southSectionDot, rmClassID("southSection"));
    rmSetAreaSize(southSectionDot, 0.15, 0.15);
    rmSetAreaLocation(southSectionDot, 0.32, 0.32);
    //rmSetAreaBaseHeight(southSectionDot, 1.0); // Was 10
    rmSetAreaCoherence(southSectionDot, 1.0);
    //rmSetAreaTerrainType(southSectionDot, "texas\ground4_tex");
    rmBuildArea(southSectionDot); 
    
    /*
    int marker1 = rmCreateArea("marker12");
    rmSetAreaSize(marker1, 0.01, 0.01);
    rmSetAreaLocation(marker1, 0.77, 0.57);
    //rmSetAreaBaseHeight(marker1, 1.0); // Was 10
    rmSetAreaCoherence(marker1, 1.0);
    rmSetAreaTerrainType(marker1, "texas\ground4_tex");
    rmBuildArea(marker1); 
    */
    rmSetStatusText("",0.7);
    int pronghornHunts = rmCreateObjectDef("pronghornHunts");
    if(cNumberNonGaiaPlayers>2){
        rmAddObjectDefItem(pronghornHunts, "ypSerow", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(pronghornHunts, true);
        rmSetObjectDefMinDistance(pronghornHunts, 0);
        rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(pronghornHunts, circleConstraint2);
        rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterLess);
        rmAddObjectDefConstraint(pronghornHunts, avoidStartingResources);
        rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
        rmAddObjectDefConstraint(pronghornHunts, avoidPlateau2);	
        rmAddObjectDefConstraint(pronghornHunts, avoidWaterShort);
        rmAddObjectDefConstraint(pronghornHunts, avoidImpassableLand);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
    }else{
        rmAddObjectDefItem(pronghornHunts, "ypSerow", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(pronghornHunts, true);
        rmSetObjectDefMinDistance(pronghornHunts, 0);
        rmSetObjectDefMaxDistance(pronghornHunts, 15);
        rmAddObjectDefConstraint(pronghornHunts, avoidSocket2);
        rmAddObjectDefConstraint(pronghornHunts, avoidWaterShort);
        rmAddObjectDefConstraint(pronghornHunts, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(pronghornHunts, forestConstraintShort);	
        rmAddObjectDefConstraint(pronghornHunts, avoidHunt2);
        rmAddObjectDefConstraint(pronghornHunts, avoidAll);       
        rmAddObjectDefConstraint(pronghornHunts, avoidPlateau2);       
        rmAddObjectDefConstraint(pronghornHunts, avoidImpassableLand);
        rmAddObjectDefConstraint(pronghornHunts, circleConstraint2);       
        //top
        //rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.75, 0.75, 1);
        //bot
        //rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.33, 0.33, 1);
        //right
        //bot -> mid -> top
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.71, 0.38, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.88, 0.37, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.77, 0.57, 1);
        //left
        //bot -> mid -> top
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.38, 0.71, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.37, 0.88, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.57, 0.77, 1);
        
        //have to use this second group for no herd on the bottom
        int botHunt = rmCreateObjectDef("botHunt");
        rmAddObjectDefItem(botHunt, "ypSerow", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(botHunt, false);
        rmSetObjectDefMinDistance(botHunt, 0);
        rmSetObjectDefMaxDistance(botHunt, 8);
        rmAddObjectDefConstraint(botHunt, avoidSocket2);
        rmAddObjectDefConstraint(botHunt, avoidWaterShort);
        rmAddObjectDefConstraint(botHunt, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(botHunt, forestConstraintShort);	
        rmAddObjectDefConstraint(botHunt, avoidHunt2);
        rmAddObjectDefConstraint(botHunt, avoidAll);       
        rmAddObjectDefConstraint(botHunt, avoidPlateau2);       
        rmAddObjectDefConstraint(botHunt, avoidImpassableLand);
        rmAddObjectDefConstraint(botHunt, circleConstraint2);       
        //top
        rmPlaceObjectDefAtLoc(botHunt, 0, 0.74, 0.74, 1);
        //bot
        rmPlaceObjectDefAtLoc(botHunt, 0, 0.32, 0.32, 1);

    }
        rmSetStatusText("",0.8);
    if(cNumberNonGaiaPlayers>2){
        int mainMines = rmCreateObjectDef("mainland Mines");
        rmAddObjectDefItem(mainMines, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(mainMines, 0.0);
        rmSetObjectDefMaxDistance(mainMines, rmXFractionToMeters(0.46));
        rmAddObjectDefConstraint(mainMines, avoidCoinMed);
        rmAddObjectDefConstraint(mainMines, avoidTownCenterMore);
        rmAddObjectDefConstraint(mainMines, avoidStartingResources);
        rmAddObjectDefConstraint(mainMines, avoidSocket);
        rmAddObjectDefConstraint(mainMines, avoidPlateau2);	
        rmAddObjectDefConstraint(mainMines, avoidWaterShort);
        rmAddObjectDefConstraint(mainMines, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(mainMines, forestConstraintShort);
        rmAddObjectDefConstraint(mainMines, circleConstraint2);
        rmAddObjectDefConstraint(mainMines, nuggetbuffer);
        rmAddObjectDefConstraint(mainMines, avoidImpassableLand);
        rmAddObjectDefConstraint(mainMines, huntBuffer);
        rmAddObjectDefConstraint(mainMines, herdBuffer);
        rmPlaceObjectDefAtLoc(mainMines, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);
        
    }else{
        int topMine = rmCreateObjectDef("topMine");
        rmAddObjectDefItem(topMine, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(topMine, 0.0);
        rmSetObjectDefMaxDistance(topMine, 8);
        rmAddObjectDefConstraint(topMine, avoidSocket2);
        rmAddObjectDefConstraint(topMine, avoidWaterShort);
        rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(topMine, forestConstraintShort);
        rmAddObjectDefConstraint(topMine, avoidPlateau2);	
        rmAddObjectDefConstraint(topMine, avoidGold);
        rmAddObjectDefConstraint(topMine, circleConstraint2);       
        rmAddObjectDefConstraint(topMine, avoidImpassableLand);
        rmAddObjectDefConstraint(topMine, nuggetbuffer);
        rmAddObjectDefConstraint(topMine, huntBuffer);
        rmAddObjectDefConstraint(topMine, herdBuffer);
        //top
        rmPlaceObjectDefAtLoc(topMine, 0, 0.755, 0.755, 1);
        //bot
        rmPlaceObjectDefAtLoc(topMine, 0, 0.335, 0.335, 1);
        //right
        //Top -> mid -> bot
        rmPlaceObjectDefAtLoc(topMine, 0, 0.91, 0.54, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.72, 0.5, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.8, 0.27, 1);
        //left
        //Top -> mid -> bot
        rmPlaceObjectDefAtLoc(topMine, 0, 0.54, 0.91, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.72, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.27, 0.8, 1);
    }
 	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint2);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocket); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);	
	rmAddObjectDefConstraint(nuggetID, goldBuffer);	
	rmAddObjectDefConstraint(nuggetID, huntBuffer);	
    rmAddObjectDefConstraint(nuggetID, avoidWaterShort);
	rmAddObjectDefConstraint(nuggetID, herdBuffer);	   
	rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);	   
   if (cNumberNonGaiaPlayers > 2) {
   	rmSetNuggetDifficulty(3,3); 
   	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.99, 0.99, cNumberNonGaiaPlayers);  
      }
	rmSetNuggetDifficulty(2,2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);  

    rmSetStatusText("",0.9);
   int centerTrees=rmCreateObjectDef("centerTrees");
   rmAddObjectDefItem(centerTrees, "ypTreeJapaneseMaple", rmRandInt(20,25), rmRandFloat(10.0,14.0));
   rmAddObjectDefToClass(centerTrees, rmClassID("classForest")); 
   rmSetObjectDefMinDistance(centerTrees, 0);
   rmSetObjectDefMaxDistance(centerTrees, 5);
   rmAddObjectDefConstraint(centerTrees, avoidStartingResources);	
   rmAddObjectDefConstraint(centerTrees, avoidTownCenterLess);	
   //rmAddObjectDefConstraint(centerTrees, avoidPlateau);	
   rmAddObjectDefConstraint(centerTrees, avoidWaterShort);	
   rmPlaceObjectDefAtLoc(centerTrees, 0, 0.5, 0.5, 1);

   int mapTrees=rmCreateObjectDef("map trees");
   rmAddObjectDefItem(mapTrees, "ypTreeJapaneseMaple", rmRandInt(11,13), rmRandFloat(10.0,14.0));
   rmAddObjectDefToClass(mapTrees, rmClassID("classForest")); 
   rmSetObjectDefMinDistance(mapTrees, 0);
   rmSetObjectDefMaxDistance(mapTrees, rmXFractionToMeters(0.45));
   rmAddObjectDefConstraint(mapTrees, avoidTradeRouteSmall);
   rmAddObjectDefConstraint(mapTrees, avoidSocket);
   rmAddObjectDefConstraint(mapTrees, avoidStartingResources);
   rmAddObjectDefConstraint(mapTrees, circleConstraint);
   rmAddObjectDefConstraint(mapTrees, forestConstraint);
   rmAddObjectDefConstraint(mapTrees, avoidTownCenterLess);	
   //rmAddObjectDefConstraint(mapTrees, avoidPlateau);	
   rmAddObjectDefConstraint(mapTrees, avoidWaterShort);	
   rmAddObjectDefConstraint(mapTrees, goldBuffer);	
   rmAddObjectDefConstraint(mapTrees, nuggetbuffer);	
   rmAddObjectDefConstraint(mapTrees, huntBuffer);	
   rmAddObjectDefConstraint(mapTrees, herdBuffer);	
   rmPlaceObjectDefAtLoc(mapTrees, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);
	rmSetStatusText("",1.0);	
   //fish and their constraints placed together at the end for ease of removal
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "ypSquid", 20.0); // ypFishCatfish
   int fishVsFishID2=rmCreateTypeDistanceConstraint("fish v fish2", "ypSquid", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "MinkeWhale", 25.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale land", "land", true, 15.0);

   int fishID=rmCreateObjectDef("fish Mahi");
   rmAddObjectDefItem(fishID, "ypSquid", 1, 0.0);     // ypFishCatfish
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers);

   int fish2ID=rmCreateObjectDef("fish Tarpon");
   rmAddObjectDefItem(fish2ID, "ypSquid", 1, 0.0);
   rmSetObjectDefMinDistance(fish2ID, 0.0);
   rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fish2ID, fishVsFishID2);
   rmAddObjectDefConstraint(fish2ID, fishLand);
   rmPlaceObjectDefAtLoc(fish2ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

    int whaleNum = 2*cNumberNonGaiaPlayers;
    if(cNumberNonGaiaPlayers==2){
        whaleNum = 3;
    }
   int whaleID=rmCreateObjectDef("whale");
   rmAddObjectDefItem(whaleID, "MinkeWhale", 1, 0.0);
   rmSetObjectDefMinDistance(whaleID, 0.0);
   rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
   rmAddObjectDefConstraint(whaleID, whaleLand);
   rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, whaleNum);
   
   // check for KOTH game mode
   if(rmGetIsKOTH()) {
      ypKingsHillPlacer(.75, .75, .05, 0);
   }
   
}
 
