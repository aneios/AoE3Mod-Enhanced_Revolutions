// Himalayas - started with a modified version of Rockies.
// Aug 06
// PJJ
// AOE3 DE 2019 Updated by Alex Y  
// 1v1 Balance update by Durokan for DE
// April 2021 edited by vividlyplain for DE

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
    rmSetStatusText("",0.01);
  
  // initialize map type variables
  string nativeCiv1 = "Udasi";
  string nativeCiv2 = "Bhakti";
 
  string baseMix = "himalayas_a";
  string secondaryMix = "himalayas_b";
  string baseTerrain = "rockies\groundsnow6_roc";
  string playerTerrain = "himalayas\ground_dirt3_himal";
  string cliffType = "himalayas";
  string cliffTerrain = "rockies\groundsnow6_roc";
  
  string patchTerrain1 = "himalayas\ground_dirt8_himal";
  string patchTerrain2 = "himalayas\ground_dirt3_himal";
  string patchType1 = "himalayas\ground_dirt7_himal";
  string patchType2 = "himalayas\ground_dirt2_himal";
  
  string denseForest = "Himalayas Forest";
  string sparseForest = "Himalayas Forest";
  string startTreeType = "ypTreeHimalayas";
  
  string mapType1 = "himalayas";
  string mapType2 = "grass";
  
  string tradeRouteType = "water";
  
  string huntable1 = "ypIbex";
  string huntable2 = "ypSerow";
  
  string lightingType = "Himalayas_skirmish";
  
   //Chooses which natives appear on the map
  int subCiv0=-1;
  int subCiv1=-1;

  subCiv0=rmGetCivID(nativeCiv1);
  rmEchoInfo("subCiv0 is "+nativeCiv1+ " " +subCiv0);
  if (subCiv0 >= 0)
    rmSetSubCiv(0, nativeCiv1);
    
  subCiv1=rmGetCivID(nativeCiv2);
  rmEchoInfo("subCiv1 is "+nativeCiv2+ " " +subCiv1);
  if (subCiv1 >= 0)
    rmSetSubCiv(1, nativeCiv2);

   // Picks the map size
   int playerTiles=11000;
   if (cNumberNonGaiaPlayers > 2)
      playerTiles = 10000;
  if (cNumberNonGaiaPlayers > 4)
      playerTiles = 9000;
  if (cNumberNonGaiaPlayers > 6)
    playerTiles = 8000;
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

   // Picks a default water height
   rmSetSeaLevel(0.0);

   // Picks default terrain and water
  rmSetMapElevationParameters(cElevTurbulence, 0.02, -6, 0.5, 8.0);
  rmSetBaseTerrainMix(baseMix);
  rmTerrainInitialize(baseTerrain, 0);	
  rmSetLightingSet(lightingType);
  rmSetMapType(mapType1);
  rmSetMapType(mapType2);
  rmSetMapType("land");
  rmSetWorldCircleConstraint(true);

  chooseMercs();

  // Define some classes. These are used later for constraints.

  int classPlayer=rmDefineClass("player");
  int classStartingRidge = rmDefineClass("startingRidge");
  rmDefineClass("classForest");
  rmDefineClass("importantItem");
  rmDefineClass("nuggets");
  rmDefineClass("startingUnit");
  rmDefineClass("socketClass");
  rmDefineClass("classPatch");

  // -------------Define constraints
  // These are used to have objects and areas avoid each other
   
   // Map edge constraints
  int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
  int ridgeEdgeConstraint=rmCreateBoxConstraint("keep ridges from hitting border", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
  int silverEdgeConstraint=rmCreateBoxConstraint("silver edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
  int forestEdgeConstraint=rmCreatePieConstraint("forest edge of map", 0.5, 0.5, 0, rmGetMapXSize()-5, 0, 0, 0);
  int heavyForestConstraint=rmCreatePieConstraint("Heavy forests concentrated near edge of map", 0.5, 0.5, rmXFractionToMeters(0.25), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
  int nativeConstraint=rmCreatePieConstraint("Natives stay close to middle", 0.5, 0.5, 0, rmXFractionToMeters(0.3), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // Player constraints
  int playerConstraint = rmCreateClassDistanceConstraint("player vs. player", classPlayer, 15.0);
  int playerConstraintImportantItem = rmCreateClassDistanceConstraint("vs. player far", classPlayer, 65.0);
  int ridgeAvoidsPlayer=rmCreateClassDistanceConstraint("ridge vs. player", classPlayer, 35.0);

  // Resource avoidance
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. things", rmClassID("classForest"), 8.0);
  int forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests", rmClassID("classForest"), 15.0);
  if ( cNumberNonGaiaPlayers < 3 ) {
    forestVsForestConstraint=rmCreateClassDistanceConstraint("forest vs. other forests smaller", rmClassID("classForest"), 10.0);
  }

  int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
  int playerConstraintFar=rmCreateClassDistanceConstraint("resources stay away from players", classPlayer, 25.0);
  int playerConstraintVeryFar=rmCreateClassDistanceConstraint("resources stay farther away from players", classPlayer, 35.0);
  int avoidHuntable1=rmCreateTypeDistanceConstraint("huntable1 avoids food", huntable1, 50.0);
  int avoidHuntable2=rmCreateTypeDistanceConstraint("huntable2 avoids food", huntable2, 50.0);
  int avoidCoin=rmCreateTypeDistanceConstraint("stuff avoids coin", "gold", 15.0);
  int avoidCoinShort=rmCreateTypeDistanceConstraint("stuff avoids coin short", "gold", 6.0);
  int coinAvoidCoin= rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 65.0);
  int coinAvoidCoinShort= rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 20.0);
  int avoidNuggets=rmCreateTypeDistanceConstraint("stuff avoids nuggets", "abstractNugget", 5.0);
  int avoidNuggetsLong=rmCreateTypeDistanceConstraint("stuff avoids nuggets far", "abstractNugget", 40.0);
    
  // Avoid impassable land
  int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
  int avoidImpassableLand2=rmCreateTerrainDistanceConstraint("avoid impassable land2", "Land", false, 5.0);
  int ridgeAvoidImpassableLand=rmCreateTerrainDistanceConstraint("ridges avoid impassable land", "Land", false, 12.0);
  int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);

  // Decoration avoidance
  int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

  // Unit avoidance
  int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 10.0);

   // VP avoidance
  int avoidImportantItem=rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 25.0);
  int avoidImportantItemFar=rmCreateClassDistanceConstraint("important stuff avoids each other far", rmClassID("importantItem"), 65.0);
  int avoidImportantItemForest=rmCreateClassDistanceConstraint("important stuff avoids each forest", rmClassID("importantItem"), 10.0);
  int avoidImportantItemCoin=rmCreateClassDistanceConstraint("Coin avoids important stuff", rmClassID("importantItem"), 5.0);
  int avoidImportantItemRidge=rmCreateClassDistanceConstraint("Ridge avoids important stuff", rmClassID("importantItem"), 15.0);
  int southNativeConstraint=rmCreateBoxConstraint("native south bit of map", 0.35, 0.0, .475, 1.0);
  int northNativeConstraint=rmCreateBoxConstraint("native north bit of map", 0.525, 0.0, .65, 1.0);

  int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
  int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
  int avoidSocket=rmCreateTypeDistanceConstraint("socket avoidance", "socketTradeRoute", 8.0);

  int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

  // ridge constraints
  int ridgeAvoidsRidge = rmCreateClassDistanceConstraint("ridges avoid other ridges", classStartingRidge, 25+5*cNumberNonGaiaPlayers);
  int resourceAvoidsRidge = rmCreateClassDistanceConstraint("resources avoid ridges", classStartingRidge, 4.0);
  int resourceAvoidsRidge2 = rmCreateClassDistanceConstraint("resources avoid ridges2", classStartingRidge, 5.0);
  
  // Text
  rmSetStatusText("",0.10);

  // DEFINE AREAS
  int i = 0;
  
   // Text
  rmSetStatusText("",0.20);

  // Set up player starting locations.

  float teamSide = rmRandFloat(0, 1);

	if (cNumberTeams == 2)	{
    
    if (teamSide > .5) {
      rmSetPlacementTeam(0);
      if (cNumberNonGaiaPlayers <= 4 && rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
          rmPlacePlayersLine(0.2, 0.25, 0.2, 0.5, 0.0, 0.2);
      else
          rmPlacePlayersLine(0.2, 0.25, 0.2, 0.75, 0.0, 0.2);

      rmSetPlacementTeam(1);
      if (cNumberNonGaiaPlayers <= 4 && rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
          rmPlacePlayersLine(0.8, 0.75, 0.8, 0.5, 0.0, 0.2);
      else
         rmPlacePlayersLine(0.8, 0.75, 0.8, 0.25, 0.0, 0.2);
    }
    
    else {
      rmSetPlacementTeam(1);
      if (cNumberNonGaiaPlayers <= 4 && rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
          rmPlacePlayersLine(0.2, 0.25, 0.2, 0.5, 0.0, 0.2);
      else
          rmPlacePlayersLine(0.2, 0.25, 0.2, 0.75, 0.0, 0.2);

      rmSetPlacementTeam(0);
      if (cNumberNonGaiaPlayers <= 4 && rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
          rmPlacePlayersLine(0.8, 0.75, 0.8, 0.5, 0.0, 0.2);
      else
          rmPlacePlayersLine(0.8, 0.75, 0.8, 0.25, 0.0, 0.2);
    }
	}
  
	else	{
	   rmSetTeamSpacingModifier(0.75);
	   rmPlacePlayersCircular(0.4, 0.4, 0);
	}
  
  // Set up valleys for each player.
 
  int id = 0;
  int startingRidge = 0;
  float playerFraction=rmAreaTilesToFraction(100);
  
  for(i=1; < cNumberPlayers){
    // Create the area.
    id=rmCreateArea("Player"+i);

    // Assign to the player.
    rmSetPlayerArea(i, id);

    // Set the size and area parameters.
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer);
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint);
    rmSetAreaCoherence(id, 1.0);
    rmSetAreaLocPlayer(id, i);
	rmSetAreaTerrainType(id, playerTerrain);
    rmSetAreaWarnFailure(id, false);
    rmBuildArea(id);
  }

   // Placement order
   // Trade -> Natives -> Ridges -> Resources -> Nuggets
  
  // TRADE ROUTE PLACEMENT
  int tradeRouteID = rmCreateTradeRoute();

  int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
  rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
  rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 2.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);
  
  // trade route
  rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.03);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.97);
  
  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, tradeRouteType);
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
  // add the sockets along the trade route.
  vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
    
  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
    
  if (cNumberNonGaiaPlayers > 3) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  

    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);           
  }
    
   // Text
    rmSetStatusText("",0.30);

   // NATIVE AMERICANS
  int lakotaVillageAID = -1;
  int lakotaVillageType = rmRandInt(1,5);
  int lakotaVillageBID = -1;
if(cNumberNonGaiaPlayers>2){

  lakotaVillageAID = rmCreateGrouping("village 1A", "native " +nativeCiv1+ " village himal "+lakotaVillageType);
  rmSetGroupingMinDistance(lakotaVillageAID, 0.0);
  rmSetGroupingMaxDistance(lakotaVillageAID, 5.0);
  rmAddGroupingConstraint(lakotaVillageAID, avoidImpassableLand);
//  rmAddGroupingConstraint(lakotaVillageAID, playerConstraintImportantItem);
  rmAddGroupingToClass(lakotaVillageAID, rmClassID("importantItem"));
  rmAddGroupingConstraint(lakotaVillageAID, avoidImportantItemFar);
  rmAddGroupingConstraint(lakotaVillageAID, nativeConstraint);
  rmAddGroupingConstraint(lakotaVillageAID, avoidTradeRoute);
  rmAddGroupingConstraint(lakotaVillageAID, avoidSocket);
  rmAddGroupingConstraint(lakotaVillageAID, southNativeConstraint);
  
  rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.35, 0.5);


  // Text
  rmSetStatusText("",0.40);
  
  lakotaVillageType = rmRandInt(1,5);
  lakotaVillageBID = rmCreateGrouping("village 1B", "native " +nativeCiv2+ " village himal "+lakotaVillageType);
  rmSetGroupingMinDistance(lakotaVillageBID, 0.0);
  rmSetGroupingMaxDistance(lakotaVillageBID, 5.0);
  rmAddGroupingConstraint(lakotaVillageBID, avoidImpassableLand);
//  rmAddGroupingConstraint(lakotaVillageBID, playerConstraintImportantItem);
  rmAddGroupingToClass(lakotaVillageBID, rmClassID("importantItem"));
  rmAddGroupingConstraint(lakotaVillageBID, avoidImportantItemFar);
  rmAddGroupingConstraint(lakotaVillageBID, nativeConstraint);
  rmAddGroupingConstraint(lakotaVillageBID, avoidTradeRoute);
  rmAddGroupingConstraint(lakotaVillageBID, avoidSocket);
  rmAddGroupingConstraint(lakotaVillageBID, northNativeConstraint);
  rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.65, 0.5);
}else{
    lakotaVillageAID = rmCreateGrouping("village 1A", "native " +nativeCiv1+ " village himal "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageAID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageAID, 5.0);
    rmAddGroupingToClass(lakotaVillageAID, rmClassID("importantItem"));
    
    // Text
    rmSetStatusText("",0.40);

    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageBID = rmCreateGrouping("village 1B", "native " +nativeCiv2+ " village himal "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageBID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageBID, 5.0);
    rmAddGroupingToClass(lakotaVillageBID, rmClassID("importantItem"));
    
    int nativeSwitch = rmRandInt(0,1);
    if(nativeSwitch == 0){
	rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.35, 0.5);
	rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.65, 0.5); 
	}else{
	rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.65, 0.5);
	rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.35, 0.5); 
	}
}
  // Place more native sites if more players
  if(cNumberNonGaiaPlayers > 4) {
    
    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageAID = rmCreateGrouping("village 1E", "native " +nativeCiv1+ " village himal "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageAID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageAID, 35.0);
    rmAddGroupingConstraint(lakotaVillageAID, avoidImpassableLand);
    rmAddGroupingConstraint(lakotaVillageAID, playerConstraintImportantItem);
    rmAddGroupingToClass(lakotaVillageAID, rmClassID("importantItem"));
    rmAddGroupingConstraint(lakotaVillageAID, avoidImportantItemFar);
    rmAddGroupingConstraint(lakotaVillageAID, nativeConstraint);
    rmAddGroupingConstraint(lakotaVillageAID, avoidTradeRoute);
    rmAddGroupingConstraint(lakotaVillageAID, avoidSocket);
    rmAddGroupingConstraint(lakotaVillageAID, southNativeConstraint);
    rmPlaceGroupingAtLoc(lakotaVillageAID, 0, 0.4, 0.65);

    lakotaVillageType = rmRandInt(1,5);
    lakotaVillageBID = rmCreateGrouping("village 2F", "native " +nativeCiv2+ " village himal "+lakotaVillageType);
    rmSetGroupingMinDistance(lakotaVillageBID, 0.0);
    rmSetGroupingMaxDistance(lakotaVillageBID, 35.0);
    rmAddGroupingConstraint(lakotaVillageBID, avoidImpassableLand);
    rmAddGroupingConstraint(lakotaVillageBID, playerConstraintImportantItem);
    rmAddGroupingToClass(lakotaVillageBID, rmClassID("importantItem"));
    rmAddGroupingConstraint(lakotaVillageBID, avoidImportantItemFar);
    rmAddGroupingConstraint(lakotaVillageBID, nativeConstraint);
    rmAddGroupingConstraint(lakotaVillageBID, avoidTradeRoute);
    rmAddGroupingConstraint(lakotaVillageBID, avoidSocket);
    rmAddGroupingConstraint(lakotaVillageBID, northNativeConstraint);
    rmPlaceGroupingAtLoc(lakotaVillageBID, 0, 0.6, 0.35);
  
  }
  
  float edgeCliffCoherence = .9;
  float midCliffCoherence = .75; 

// Vary some terrain
  for (i=0; < 30) {
    int patch=rmCreateArea("first patch "+i);
    rmSetAreaWarnFailure(patch, false);
    rmSetAreaSize(patch, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
    rmSetAreaTerrainType(patch, patchTerrain1);
    rmAddAreaTerrainLayer(patch, patchType1, 0, 1);
    rmAddAreaToClass(patch, rmClassID("classPatch"));
    rmSetAreaCoherence(patch, 0.4);
    rmAddAreaConstraint(patch, shortAvoidImpassableLand);
    rmAddAreaConstraint(patch, avoidTownCenter);
    rmBuildArea(patch); 
  }

  for (i=0; <10) {
    int dirtPatch=rmCreateArea("paint patch "+i);
    rmSetAreaWarnFailure(dirtPatch, false);
    rmSetAreaSize(dirtPatch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    rmSetAreaTerrainType(dirtPatch, patchTerrain2);
    rmAddAreaTerrainLayer(dirtPatch, patchType2, 0, 1);
    rmAddAreaToClass(dirtPatch, rmClassID("classPatch"));
    rmSetAreaCoherence(dirtPatch, 0.4);
    rmAddAreaConstraint(dirtPatch, shortAvoidImpassableLand);
    rmAddAreaConstraint(dirtPatch, avoidTownCenter);
    rmBuildArea(dirtPatch); 
  }

  // build ridges with ridge avoidance to start a basic topography   
  
  int randomRidge = 5; 
  float ridgeHeightVariance = 2.5;
  int ridgeAvoid = 3;  
  int numTries = -1;
  int failCount = -1;
  int extraRidges = 5 + cNumberNonGaiaPlayers;
  
  for(i=0; < extraRidges) {
    
    if(rmRandInt(1,5) <= randomRidge) {
      startingRidge=rmCreateArea("Ridge 11"+i);
      rmAddAreaConstraint(startingRidge, ridgeAvoidsPlayer); 
      rmAddAreaConstraint(startingRidge, ridgeAvoidsRidge);
      rmAddAreaConstraint(startingRidge, avoidTradeRoute);
      rmAddAreaConstraint(startingRidge, avoidSocket);
      rmAddAreaConstraint(startingRidge, avoidImportantItemRidge);      
                     
      rmSetAreaSize(startingRidge, rmAreaTilesToFraction(100), rmAreaTilesToFraction(125));
      rmSetAreaWarnFailure(startingRidge, false);
      rmSetAreaCoherence(startingRidge, midCliffCoherence);
      rmSetAreaCliffType(startingRidge, cliffType);
      rmSetAreaCliffEdge(startingRidge, 1, 1.0, 1.0, 0.0, 0);
      rmSetAreaCliffHeight(startingRidge, 5, ridgeHeightVariance, 0.3);
      rmSetAreaCliffPainting(startingRidge, true, false, true, 0, true);
      rmAddAreaToClass(startingRidge, classStartingRidge);
      
      if(rmBuildArea(startingRidge)==false){
        failCount++;
        if(failCount==5) // Stop trying once we fail 5 times in a row.
        break;
      }
      else
        failCount=0;
    }
  }
  
  // begin smaller ridges with lower % chance to spawn and possibly no ridge avoidance constraint
  
  randomRidge = 4;
  ridgeAvoid = 5;  
  extraRidges = 6 + cNumberNonGaiaPlayers;
  numTries = -1;
  failCount = -1;

  for(i=0; < extraRidges) {
    
    if(rmRandInt(1,5) <= randomRidge) {
      startingRidge=rmCreateArea("Ridge 31"+i);
      rmAddAreaConstraint(startingRidge, ridgeAvoidsPlayer); 
      rmAddAreaConstraint(startingRidge, avoidImportantItemRidge);   
      rmAddAreaConstraint(startingRidge, avoidTradeRoute);
      rmAddAreaConstraint(startingRidge, avoidSocket);
      rmAddAreaConstraint(startingRidge, ridgeAvoidsRidge);
  
      rmSetAreaSize(startingRidge, rmAreaTilesToFraction(50), rmAreaTilesToFraction(75));
      rmSetAreaWarnFailure(startingRidge, false);
      rmSetAreaCoherence(startingRidge, midCliffCoherence);

      rmSetAreaCliffType(startingRidge, cliffType);
      rmSetAreaCliffEdge(startingRidge, 1, 1.0, 1.0, 0.0, 0);
      rmSetAreaCliffHeight(startingRidge, 5, ridgeHeightVariance, 0.3);
      rmSetAreaCliffPainting(startingRidge, true, false, true, 0, true);
      rmAddAreaToClass(startingRidge, classStartingRidge);
      
      if(rmBuildArea(startingRidge)==false){
        failCount++;
        if(failCount==5) // Stop trying once we fail 5 times in a row.
        break;
      }
      else
        failCount=0;
    }
  }
  
  failCount = -1;
  
	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	if (cNumberNonGaiaPlayers == 2 || cNumberTeams > 2)
		rmSetAreaSize(midIslandID, 0.45);
	else
		rmSetAreaSize(midIslandID, 0.35);
	rmSetAreaLocation(midIslandID, 0.5, 0.5);
	if (cNumberNonGaiaPlayers > 2 && cNumberTeams == 2) 
	{
		rmAddAreaInfluenceSegment(midIslandID, 0.70, 0.25, 0.70, 0.75);
		rmAddAreaInfluenceSegment(midIslandID, 0.30, 0.25, 0.30, 0.75);
	}
//	rmSetAreaMix(midIslandID, "testmix"); 	// for testing
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
	rmSetAreaCoherence(midSmIslandID, 0.75);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidIslandShort = rmCreateAreaDistanceConstraint("avoid mid island short", midIslandID, 4.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);
	
  //STARTING UNITS
	int classStartingResource = rmDefineClass("startingResource");
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resource", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resource short", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin  = rmCreateClassDistanceConstraint("avoid starting resource min", rmClassID("startingResource"), 4.0);

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	
  int startingTCID= rmCreateObjectDef("startingTC");
  if ( rmGetNomadStart())
  {
    rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
  }
  else
  {
    rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
  }
	rmAddObjectDefToClass(startingTCID, classStartingResource);  
  rmSetObjectDefMinDistance(startingTCID, 0.0);
    if(cNumberTeams > 2 || teamZeroCount != teamOneCount)
        rmSetObjectDefMaxDistance(startingTCID, 10.0);
    else
        rmSetObjectDefMaxDistance(startingTCID, 0.0);
  rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);

  int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
  rmSetObjectDefMinDistance(startingUnits, 4.0);
  rmSetObjectDefMaxDistance(startingUnits, 8.0);
  
  int StartFoodID=rmCreateObjectDef("starting food");
  rmAddObjectDefItem(StartFoodID, huntable1, 10, 4.0);
  rmSetObjectDefMinDistance(StartFoodID, 13.0);
  rmSetObjectDefMaxDistance(StartFoodID, 14.0);
  rmSetObjectDefCreateHerd(StartFoodID, true);
	rmAddObjectDefToClass(StartFoodID, classStartingResource);  
  rmAddObjectDefConstraint(StartFoodID, avoidImpassableLand);
  rmAddObjectDefConstraint(StartFoodID, avoidStartingResourcesShort);
  if (cNumberTeams == 2)
	  rmAddObjectDefConstraint(StartFoodID, avoidMidIslandShort);

  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 25.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);  
  rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  if (cNumberTeams == 2)
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIsland);
  rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);

  int StartAreaTreeID=rmCreateObjectDef("starting trees");
  rmAddObjectDefItem(StartAreaTreeID, startTreeType, 10, 5.0);
  rmSetObjectDefMinDistance(StartAreaTreeID, 18.0);
  rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
	rmAddObjectDefToClass(StartAreaTreeID, classStartingResource);  
  rmAddObjectDefConstraint(StartAreaTreeID, avoidNuggets);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingResourcesShort);

  int StartAreaTree2ID=rmCreateObjectDef("starting trees2");
  rmAddObjectDefItem(StartAreaTree2ID, startTreeType, 14, 6.0);
  rmSetObjectDefMinDistance(StartAreaTree2ID, 30.0);
  rmSetObjectDefMaxDistance(StartAreaTree2ID, 40.0);
  rmAddObjectDefConstraint(StartAreaTree2ID, avoidNuggets);
  rmAddObjectDefConstraint(StartAreaTree2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingResources);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidMidIslandFar);
	rmAddObjectDefToClass(StartAreaTree2ID, classStartingResource); 
	
  int playerGoldID = rmCreateObjectDef("player silver closer "+i);
  rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
  rmAddObjectDefConstraint(playerGoldID, resourceAvoidsRidge);
  rmSetObjectDefMinDistance(playerGoldID, 15.0);
  rmSetObjectDefMaxDistance(playerGoldID, 18.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);  
  rmAddObjectDefConstraint(playerGoldID, avoidStartingResourcesShort);
  if (cNumberTeams == 2)
	rmAddObjectDefConstraint(playerGoldID, avoidMidIslandMin);
  
  int avoidStartingGold_dk=rmCreateTypeDistanceConstraint("berry avoid dk coin", "mine", 12.0);

  int playerBerryID=rmCreateObjectDef("player berries");
  rmAddObjectDefItem(playerBerryID, "berryBush", 4, 4.0);
  rmSetObjectDefMinDistance(playerBerryID, 12.0);
  rmSetObjectDefMaxDistance(playerBerryID, 15.0);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);  
  rmAddObjectDefConstraint(playerBerryID, avoidImpassableLand);
//  rmAddObjectDefConstraint(playerBerryID, avoidStartingGold_dk);
  rmAddObjectDefConstraint(playerBerryID, avoidStartingResourcesShort);
  if (cNumberTeams == 2)
	rmAddObjectDefConstraint(playerBerryID, stayMidIsland);
  
    //1v1 stuff
    int classBaseHunt = rmDefineClass("BaseHunts");
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

    int baseGold = rmCreateObjectDef("base gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold, 16.0);
    rmSetObjectDefMaxDistance(baseGold, 18.0);
   	rmAddObjectDefToClass(baseGold, classStartingResource);
	rmAddObjectDefConstraint(baseGold, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold, avoidStartingResources);
	rmAddObjectDefConstraint(baseGold, stayMidIsland);

    int baseGold2 = rmCreateObjectDef("base gold2");
    rmAddObjectDefItem(baseGold2, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold2, 16.0);
    rmSetObjectDefMaxDistance(baseGold2, 18.0);
   	rmAddObjectDefToClass(baseGold2, classStartingResource);
	rmAddObjectDefConstraint(baseGold2, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold2, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold2, avoidStartingResources);
	rmAddObjectDefConstraint(baseGold2, avoidMidIslandMin);
	rmAddObjectDefConstraint(baseGold2, coinAvoidCoinShort);
    
    int baseHunt1=rmCreateObjectDef("baseHunt1");
    rmAddObjectDefItem(baseHunt1, "ypIbex", 8, 5.0);
    rmSetObjectDefMinDistance(baseHunt1, 14.0);
    rmSetObjectDefMaxDistance(baseHunt1, 15.0);
    rmAddObjectDefConstraint(baseHunt1, avoidStartingUnitsSmall);
    rmAddObjectDefToClass(baseHunt1, classStartingResource);
    rmAddObjectDefToClass(baseHunt1, classBaseHunt);
    rmAddObjectDefConstraint(baseHunt1, avoidImpassableLand2);
    rmAddObjectDefConstraint(baseHunt1, avoidTradeRoute);
    rmSetObjectDefCreateHerd(baseHunt1, true);
    rmAddObjectDefConstraint(baseHunt1, avoidSocket);
    rmAddObjectDefConstraint(baseHunt1, stayMidIsland);

    int baseHunt2=rmCreateObjectDef("baseHunt2");
    rmAddObjectDefItem(baseHunt2, "ypIbex", 8, 7.0);
    rmSetObjectDefMinDistance(baseHunt2, 32.0);
    rmSetObjectDefMaxDistance(baseHunt2, 36.0);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingUnitsSmall);
    rmAddObjectDefToClass(baseHunt2, classStartingResource);
    rmAddObjectDefToClass(baseHunt2, classBaseHunt);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingResources);
    rmAddObjectDefConstraint(baseHunt2, avoidTradeRoute);
    rmAddObjectDefConstraint(baseHunt2, avoidSocket);
    rmSetObjectDefCreateHerd(baseHunt2, true);
    rmAddObjectDefConstraint(baseHunt2, avoidImpassableLand2);
    rmAddObjectDefConstraint(baseHunt2, avoidMidIsland);
    
  // Text
   rmSetStatusText("",0.60);
   
  for(i=1; <cNumberPlayers) {
    rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    if(cNumberNonGaiaPlayers>2){
        // Everyone gets a starter mines, some sheep, and lumber
        rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        // Placing starting food
        rmPlaceObjectDefAtLoc(StartFoodID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerBerryID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(baseHunt2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        // Placing starting trees
        rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    }else{
        // Placing starting trees
        rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

        rmPlaceObjectDefAtLoc(baseGold, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(baseGold2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerBerryID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(baseHunt1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(baseHunt2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    }
    

    // japanese
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
  }

  // Text
  rmSetStatusText("",0.70);
  
  // Resources

  // Define and place forests
  int forestTreeID = 0;
  
  numTries = 15 * cNumberNonGaiaPlayers;
  failCount=0;
    int forestAvoidBaseHunt = rmCreateClassDistanceConstraint("forestAvoidBaseHunt", classBaseHunt, 7.0);

  for (i=0; <numTries) {   
    int northForest = rmCreateArea("nForest"+i);
    rmSetAreaWarnFailure(northForest, false);
    rmSetAreaSize(northForest, rmAreaTilesToFraction(300), rmAreaTilesToFraction(350));
    rmAddAreaToClass(northForest, rmClassID("classForest"));
    rmSetAreaForestType(northForest, denseForest);
    rmSetAreaForestDensity(northForest, 0.8);
    rmSetAreaForestClumpiness(northForest, 0.6);
    rmSetAreaForestUnderbrush(northForest, 0.0);
    rmSetAreaCoherence(northForest, 0.3);
    rmSetAreaSmoothDistance(northForest, 10);
    rmSetAreaObeyWorldCircleConstraint(northForest, false);
    rmAddAreaConstraint(northForest, avoidImportantItemForest);		
    rmAddAreaConstraint(northForest, avoidStartingResources);		
    rmAddAreaConstraint(northForest, playerConstraintForest);	
    rmAddAreaConstraint(northForest, forestVsForestConstraint);			
    rmAddAreaConstraint(northForest, resourceAvoidsRidge);
    rmAddAreaConstraint(northForest, forestEdgeConstraint);
    rmAddAreaConstraint(northForest, avoidTradeRoute);
    rmAddAreaConstraint(northForest, avoidSocket);
    rmAddAreaConstraint(northForest, avoidCoin);
    rmAddAreaConstraint(northForest, heavyForestConstraint);
    if(cNumberNonGaiaPlayers==2){
        rmAddAreaConstraint(northForest, forestAvoidBaseHunt);			
    }
    if(rmBuildArea(northForest) == false) {
      // Stop trying once we fail 4 times in a row.
      failCount++;
      if(failCount==4)
        break;
    }
    
    else
      failCount=0; 
  }

  failCount=0; 
  
  //text
  rmSetStatusText("",0.80);  

  for (i=0; <numTries) {   
    int northForest2 = rmCreateArea("nForestb"+i);
    rmSetAreaWarnFailure(northForest2, false);
    rmSetAreaSize(northForest2, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
    rmAddAreaToClass(northForest2, rmClassID("classForest"));
    rmSetAreaForestType(northForest2, sparseForest);
    rmSetAreaForestDensity(northForest2, 0.2);
    rmSetAreaForestClumpiness(northForest2, 0.1);
    rmSetAreaForestUnderbrush(northForest2, 0.0);
    if(cNumberNonGaiaPlayers==2){
        rmAddAreaConstraint(northForest2, forestAvoidBaseHunt);			
    }
    rmSetAreaCoherence(northForest2, 0.3);
    rmSetAreaSmoothDistance(northForest2, 10);
    rmSetAreaObeyWorldCircleConstraint(northForest2, false);
    rmAddAreaConstraint(northForest2, avoidImportantItemForest);		
    rmAddAreaConstraint(northForest2, playerConstraintForest);	
    rmAddAreaConstraint(northForest2, avoidStartingResources);	
    rmAddAreaConstraint(northForest2, forestVsForestConstraint);			
    rmAddAreaConstraint(northForest2, resourceAvoidsRidge);
    rmAddAreaConstraint(northForest2, forestEdgeConstraint);
    rmAddAreaConstraint(northForest2, avoidTradeRoute);
    rmAddAreaConstraint(northForest2, avoidSocket);
    rmAddAreaConstraint(northForest2, avoidCoin);
    
    if(rmBuildArea(northForest2) == false) {
      // Stop trying once we fail 4 times in a row.
      failCount++;
      if(failCount==4)
        break;
    }
    
    else
      failCount=0; 
  }
     //constraints for durokan's 1v1 balance
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 4.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 2.0);
    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 28.0);
    int avoidHunt3=rmCreateTypeDistanceConstraint("herds avoid herds3", "huntable", 36.0);
    int avoidHunt4=rmCreateTypeDistanceConstraint("herds avoid herds4", "huntable", 34.0);
	int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type 2 far ", "gold", 38.0);
    int avoidGoldForest = rmCreateTypeDistanceConstraint("avoid gold 2", "gold", 9.0);
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
    int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water 5", "Land", false, 5.0);
    int avoidWater6 = rmCreateTerrainDistanceConstraint("avoid water 6", "Land", false, 6.5);


if(cNumberNonGaiaPlayers>2){
  // Denser mines away from the player's starting areas
  int silverID = -1;
  int silverCount = 6;
  
  rmEchoInfo("silver count = "+silverCount);

  silverID = rmCreateObjectDef("silver mines");
  rmAddObjectDefItem(silverID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID, 0.0);
  rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID, coinAvoidCoin);
  rmAddObjectDefConstraint(silverID, avoidTradeRoute);
  rmAddObjectDefConstraint(silverID, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID, playerConstraintFar);
  rmAddObjectDefConstraint(silverID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(silverID, avoidStartingResources);
  rmAddObjectDefConstraint(silverID, avoidImportantItemCoin);
  rmAddObjectDefConstraint(silverID, silverEdgeConstraint);
  rmPlaceObjectDefPerPlayer(silverID, false, silverCount);
}else{
//1v1 mines
    //1v1 mines
    int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 1.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, 19);
    rmAddObjectDefConstraint(topMine, avoidSocket2);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(topMine, forestConstraintShort);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
    rmAddObjectDefConstraint(topMine, circleConstraint2);  
    rmAddObjectDefConstraint(topMine, avoidWater6);  
    rmAddObjectDefConstraint(topMine, resourceAvoidsRidge);
    rmAddObjectDefConstraint(topMine, avoidAll2);  
    
 
    //east mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.66, 0.13, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.83, 0.3, 1);  
    
    //west mines
    rmPlaceObjectDefAtLoc(topMine, 0, 0.34, 0.87, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.17, 0.7, 1);  


    
    //mines that go along the central / axis
    rmPlaceObjectDefAtLoc(topMine, 0, 0.75, 0.5, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.25, 0.5, 1);  

    //mines along TP
    rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.2, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.8, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.5, 1);     
}  
  rmSetStatusText("",0.90);
if(cNumberNonGaiaPlayers>2){
  // huntable 1
  int huntable1ID=rmCreateObjectDef("huntable herd 1");
  rmAddObjectDefItem(huntable1ID, huntable1, 8, 3.0);
  rmSetObjectDefMinDistance(huntable1ID, 0.0);
  rmSetObjectDefMaxDistance(huntable1ID, rmXFractionToMeters(0.45));
  rmAddObjectDefConstraint(huntable1ID, avoidHuntable1);
  rmAddObjectDefConstraint(huntable1ID, avoidStartingResources);
  rmAddObjectDefConstraint(huntable1ID, avoidImpassableLand);
  rmAddObjectDefConstraint(huntable1ID, avoidSocket);
  rmAddObjectDefConstraint(huntable1ID, forestConstraint);
  rmAddObjectDefConstraint(huntable1ID, avoidCoin);
  rmAddObjectDefConstraint(huntable1ID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(huntable1ID, playerConstraintFar);
  rmSetObjectDefCreateHerd(huntable1ID, true);
  rmPlaceObjectDefAtLoc(huntable1ID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

  // huntable2
  int huntable2ID=rmCreateObjectDef("huntable2 Herd");
  rmAddObjectDefItem(huntable2ID, huntable2, 8, 3.0);
  rmSetObjectDefMinDistance(huntable2ID, 0.0);
  rmSetObjectDefMaxDistance(huntable2ID, rmXFractionToMeters(0.45));
  rmAddObjectDefConstraint(huntable2ID, avoidHuntable2);
  rmAddObjectDefConstraint(huntable2ID, avoidHuntable1);
  rmAddObjectDefConstraint(huntable2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(huntable2ID, avoidStartingResources);
  rmAddObjectDefConstraint(huntable2ID, forestConstraint);
  rmAddObjectDefConstraint(huntable2ID, avoidSocket);
  rmAddObjectDefConstraint(huntable2ID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(huntable2ID, playerConstraintFar);
  rmSetObjectDefCreateHerd(huntable2ID, true);
  rmPlaceObjectDefAtLoc(huntable2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
}else{
//1v1 hunts

int mapElk = rmCreateObjectDef("mapElk");
    rmAddObjectDefItem(mapElk, "ypIbex", rmRandInt(8,8), 3.0);
    rmSetObjectDefCreateHerd(mapElk, true);
    rmSetObjectDefMinDistance(mapElk, 0);
    rmSetObjectDefMaxDistance(mapElk, 20);
    rmAddObjectDefConstraint(mapElk, avoidSocket2);
    rmAddObjectDefConstraint(mapElk, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapElk, forestConstraintShort);	
//    rmAddObjectDefConstraint(mapElk, avoidHunt4);
    rmAddObjectDefConstraint(mapElk, avoidAll2);       
    rmAddObjectDefConstraint(mapElk, circleConstraint2);    
    rmAddObjectDefConstraint(mapElk, resourceAvoidsRidge2);    
    rmAddObjectDefConstraint(mapElk, avoidWater6);
    rmAddObjectDefConstraint(mapElk, playerConstraintVeryFar);
    
    int mapHunts = rmCreateObjectDef("mapHunts");
    rmAddObjectDefItem(mapHunts, "ypSerow", rmRandInt(8,8), 3.0);
    rmSetObjectDefCreateHerd(mapHunts, true);
    rmSetObjectDefMinDistance(mapHunts, 0);
    rmSetObjectDefMaxDistance(mapHunts, 20);
    rmAddObjectDefConstraint(mapHunts, avoidSocket2);
    rmAddObjectDefConstraint(mapHunts, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapHunts, forestConstraintShort);	
//    rmAddObjectDefConstraint(mapHunts, avoidHunt3);
    rmAddObjectDefConstraint(mapHunts, avoidAll2);       
    rmAddObjectDefConstraint(mapHunts, circleConstraint2);    
    rmAddObjectDefConstraint(mapHunts, resourceAvoidsRidge2);
    rmAddObjectDefConstraint(mapHunts, avoidWater6);
    rmAddObjectDefConstraint(mapHunts, playerConstraintVeryFar);
        
    //right side hunts
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.7, 0.6, 1);
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.66, 0.2, 1);   
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.89, 0.42, 1);   

    //left side hunts
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.3, 0.4, 1);
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.34, 0.8, 1);   
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.11, 0.58, 1);   
          
    //tp line hunts
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.43, 0.1, 1);   
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.57, 0.9, 1);
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.55, 0.38, 1);   
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.45, 0.62, 1);   
   
}      
  int nuggetID2 = rmCreateObjectDef("nuggets! 2"); 
  rmAddObjectDefItem(nuggetID2, "Nugget", 1, 0.0);
  rmSetObjectDefMinDistance(nuggetID2, 0.0);
  rmSetObjectDefMaxDistance(nuggetID2, rmXFractionToMeters(0.50));
  rmAddObjectDefConstraint(nuggetID2, avoidImportantItemForest);
  rmAddObjectDefConstraint(nuggetID2, avoidTradeRoute);
  rmAddObjectDefConstraint(nuggetID2, avoidStartingResources);
  rmAddObjectDefConstraint(nuggetID2, avoidSocket);
  rmAddObjectDefConstraint(nuggetID2, stayMidSmIsland);
  rmAddObjectDefConstraint(nuggetID2, avoidCoinShort);
  rmAddObjectDefConstraint(nuggetID2, avoidNuggetsLong);
  rmAddObjectDefConstraint(nuggetID2, avoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID2, resourceAvoidsRidge);
  rmAddObjectDefConstraint(nuggetID2, playerConstraintImportantItem);
  rmAddObjectDefConstraint(nuggetID2, forestEdgeConstraint);
  if(cNumberNonGaiaPlayers>2 && rmGetIsTreaty() == false){
    rmSetNuggetDifficulty(4, 4);
  }else{
    rmSetNuggetDifficulty(3, 3);
  }
    rmPlaceObjectDefAtLoc(nuggetID2, 0, 0.5, 0.5, cNumberNonGaiaPlayers);   

  // Define and place Nuggets
  int nuggetID= rmCreateObjectDef("nuggets!"); 
  rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
  rmSetObjectDefMinDistance(nuggetID, 0.0);
  rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.48));
  rmAddObjectDefConstraint(nuggetID, avoidImportantItemForest);
  rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
  rmAddObjectDefConstraint(nuggetID, avoidSocket);
  rmAddObjectDefConstraint(nuggetID, avoidCoinShort);
  rmAddObjectDefConstraint(nuggetID, avoidNuggetsLong);
  rmAddObjectDefConstraint(nuggetID, avoidImpassableLand);
  rmAddObjectDefConstraint(nuggetID, resourceAvoidsRidge);
  rmAddObjectDefConstraint(nuggetID, playerConstraintFar);
  rmAddObjectDefConstraint(nuggetID, forestEdgeConstraint);
  rmAddObjectDefConstraint(nuggetID, avoidStartingResources);
  
  rmSetNuggetDifficulty(1, 2);
    rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 4+cNumberNonGaiaPlayers*2);   
  
  
  
    // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,3);
    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.075;
    
    ypKingsHillPlacer(xLoc, yLoc, walk, resourceAvoidsRidge);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
   // Text
   rmSetStatusText("",1.0);
}