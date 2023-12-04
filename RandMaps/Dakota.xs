// ***********************************************************************************************************************************************
// ****************************************************** D A K O T A **********************************************************************
// ***********************************************************************************************************************************************

// ------------------------------------------------------ Comentaries ---------------------------------------------------------------------------
// This was my first map with triggers thanks to musketeer925 for having helped me a bit
// Map done by Rikikipu - October 2015
// May 2020: Rebranded from Mendocino to Dakota for Age of Empires III: Definitive Edition

//------------------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------ Initialization ------------------------------------------------------------------------

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   rmSetStatusText("", 0.01);

   int i = 0;

   string baseTerrainInitialize = "great_lakes\ground_grass1_gl";
   string cliffType = "Great Plains";
   string cliffTerrainType = "great plains drygrass";
   string forestType = "Great Plains Forest";
   string waterType = "Great Plains Pond";
   string lightingSet = "Dakota_Skirmish";
   string flowersTerrainMix = "Flowers_Yellow";
   string hunt1 = "pronghorn";

   int playerTiles = 10850;
   if (PlayerNum > 4)
      playerTiles = 8000;
   if (PlayerNum > 6)
      playerTiles = 7000;

   int size = 2.0 * sqrt(PlayerNum * playerTiles);
   rmSetMapSize(size, size);
   rmSetSeaLevel(0.0);
   rmSetMapElevationParameters(cElevTurbulence, 0.06, 2, 0.1, 5.0);

   rmTerrainInitialize(baseTerrainInitialize, 0);
   rmSetLightingSet(lightingSet);

   rmSetMapType("dakota");
   rmSetMapType("land");
   rmSetWorldCircleConstraint(true);
   rmSetMapType("grass");

   int subCiv0 = -1;
   int subCiv1 = -1;
   int subCiv2 = -1;
   int subCiv3 = -1;
   if (rmAllocateSubCivs(2) == true)
   {
      subCiv0 = rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv0 is Cheyenne " + subCiv0);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, "Cheyenne");

      subCiv1 = rmGetCivID("Cree");
      rmEchoInfo("subCiv1 is Cree " + subCiv1);
      if (subCiv1 >= 0)
         rmSetSubCiv(1, "Cree");
      subCiv2 = rmGetCivID("Cree");
      rmEchoInfo("subCiv2 is Cree " + subCiv2);
      if (subCiv2 >= 0)
         rmSetSubCiv(2, "Cree");

      subCiv3 = rmGetCivID("Cheyenne");
      rmEchoInfo("subCiv3 is Cheyenne " + subCiv3);
      if (subCiv3 >= 0)
         rmSetSubCiv(3, "Cheyenne");
   }
   int numTries = -1;
   int failCount = -1;

   chooseMercs();

   // ------------------------------------------------------ Contraints ---------------------------------------------------------------------------
   int classPlayer = rmDefineClass("player");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("secrets");
   rmDefineClass("natives");
   rmDefineClass("socketClass");
   rmDefineClass("nuggets");
   rmDefineClass("classCliff");
   rmDefineClass("patch");
   int pondClass = rmDefineClass("pond");

   // Map edge constraints
   int avoidCenter = rmCreatePieConstraint("Avoid Center", 0.5, 0.5, rmXFractionToMeters(0.03), rmXFractionToMeters(0.5), rmDegreesToRadians(0), rmDegreesToRadians(360));
   int avoidEdgeGold = rmCreatePieConstraint("Avoid Edge1", 0.5, 0.5, rmXFractionToMeters(0.23), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));

   // For Gold
   int stayNE = rmCreatePieConstraint("stay NE", 0.5, 0.5, rmXFractionToMeters(0.3), rmXFractionToMeters(0.47), rmDegreesToRadians(35), rmDegreesToRadians(145));
   int staySW = rmCreatePieConstraint("stay SW", 0.5, 0.5, rmXFractionToMeters(0.3), rmXFractionToMeters(0.47), rmDegreesToRadians(215), rmDegreesToRadians(325));
   int stayNE1 = rmCreatePieConstraint("stay NE1", 0.5, 0.5, rmXFractionToMeters(0.24), rmXFractionToMeters(0.48), rmDegreesToRadians(45), rmDegreesToRadians(135));
   int staySW1 = rmCreatePieConstraint("stay SW1", 0.5, 0.5, rmXFractionToMeters(0.24), rmXFractionToMeters(0.48), rmDegreesToRadians(225), rmDegreesToRadians(315));
   // X marks the spot

   int avoidCenterGold3 = rmCreatePieConstraint("Avoid Center gold 3", 0.5, 0.5, rmXFractionToMeters(0.43), rmXFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
   // Player constraints
   int playerConstraint = rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int nuggetPlayerConstraint = rmCreateClassDistanceConstraint("nuggets stay away from players a lot", rmClassID("startingUnit"), 50.0);

   // Resource avoidance
   int forestConstraint = rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 25.0);
   int coinForestConstraint = rmCreateClassDistanceConstraint("coin vs. forest", rmClassID("classForest"), 15.0);
   int avoidDeer = rmCreateTypeDistanceConstraint("Deer avoids food", hunt1, 50.0);
   int avoidDeerPond = rmCreateTypeDistanceConstraint("Deer avoids food1", hunt1, 10.0);
   int avoidElk = rmCreateTypeDistanceConstraint("Elk avoids food", "Elk", 50.0);
   int avoidElkShort = rmCreateTypeDistanceConstraint("Elk avoids food short", "Elk", 15.0);
   int avoidCoin = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35.0);
   int avoidCoinPond = rmCreateTypeDistanceConstraint("pond avoids coin", "gold", 12.0);
   int avoidCoinShort = rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
   int avoidStartingCoin = rmCreateTypeDistanceConstraint("starting coin avoids coin", "gold", 28.0);
   int avoidNugget = rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 43.0);
   int avoidNuggetSmall = rmCreateTypeDistanceConstraint("avoid nuggets by a little", "AbstractNugget", 6.0);
   int avoidNuggetSmall1 = rmCreateTypeDistanceConstraint("avoid nuggets by a little1", "AbstractNugget", 12.0);
   int avoidFastCoin = rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 60);
   int avoidFastCoinTeam = rmCreateTypeDistanceConstraint("fast coin avoids coin team", "gold", 72);
   int avoidDeerShort = rmCreateTypeDistanceConstraint("avoid Deer short", hunt1, 15.0);

   // Avoid impassable land
   int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
   int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
   int patchConstraint = rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("patch"), 8.0);

   // Unit avoidance - for things that aren't in the starting resources.
   int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 30.0);
   int avoidStartingUnitsTree = rmCreateClassDistanceConstraint("objects avoid starting units1", rmClassID("startingUnit"), 10.0);
   int avoidStartingUnitsSmall = rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);
   int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
   int avoidTownCenterFar1 = rmCreateTypeDistanceConstraint("avoid Town Center Far 1", "townCenter", 40.0);
   int avoidTownCenterFar2 = rmCreateTypeDistanceConstraint("avoid Town Center Far team", "townCenter", 60.0);
   int avoidPondMine = rmCreateClassDistanceConstraint("mines avoid Pond", pondClass, 8.0);
   int avoidPondTeam = rmCreateClassDistanceConstraint("ponds avoid Pond", pondClass, 100.0);

   // Decoration avoidance
   int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
   int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("trade route small", 4.0);
   int avoidImportantItem = rmCreateClassDistanceConstraint("important stuff avoids each other", rmClassID("importantItem"), 15.0);
   int avoidSocket = rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 6.0);
   int avoidSocketMore = rmCreateClassDistanceConstraint("bigger socket avoidance", rmClassID("socketClass"), 10.0);

   // Constraint to avoid water.
   int avoidWater = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 50.0);

   // Avoid the Cliffs.
   int avoidCliffs = rmCreateClassDistanceConstraint("avoid Cliffs", rmClassID("classCliff"), 10.0);
   int avoidCliffsFar = rmCreateClassDistanceConstraint("avoid Cliffs far", rmClassID("classCliff"), 15.0);

   // natives avoid natives
   int avoidNatives = rmCreateClassDistanceConstraint("avoid Natives", rmClassID("natives"), 10.0);
   int avoidNativesWood = rmCreateClassDistanceConstraint("avoid Natives wood", rmClassID("natives"), 6.0);
   int avoidNativesNuggets = rmCreateClassDistanceConstraint("nuggets avoid Natives", rmClassID("natives"), 20.0);

   int circleConstraint = rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

   rmSetStatusText("", 0.10);

   // ------------------------------------------------------ KOTH for noobs ---------------------------------------------------------------------
    int classCenter_dk = rmDefineClass("center_dk");

    int avoidCenter_dk = rmCreateClassDistanceConstraint("avoids the center for KOTH _dk", classCenter_dk, 8);

   if (rmGetIsKOTH())
   {
        int centerMarker = rmCreateArea("centerMarker");
        rmSetAreaSize(centerMarker, 0.009, 0.009);
        rmSetAreaLocation(centerMarker, 0.5, 0.5);
        //rmSetAreaBaseHeight(centerMarker, 4.0);
        rmAddAreaToClass(centerMarker, classCenter_dk);
        rmSetAreaCoherence(centerMarker, 1.0);
        //rmSetAreaTerrainType(centerMarker, "texas\ground4_tex");
        rmBuildArea(centerMarker);
        
      int randLoc = rmRandInt(1, 3);
      float xLoc = 0.5;
      float yLoc = 0.5;
      float walk = 0.01;

      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
      rmEchoInfo("XLOC = " + xLoc);
      rmEchoInfo("XLOC = " + yLoc);
   }

   // ------------------------------------------------------ Trade Route ---------------------------------------------------------------------------
   int continentID = rmCreateArea("continent");
   rmSetAreaSize(continentID, 0.99, 0.99);
   rmSetAreaLocation(continentID, 0.5, 0.5);
   rmSetAreaBaseHeight(continentID, 0.0);
   rmSetAreaCoherence(continentID, 1.0);
   rmSetAreaMix(continentID, "great plains grass");
   rmBuildArea(continentID);

   if (PlayerNum == 2)
   {
      int smallPondID = rmCreateArea("small pond");
      rmSetAreaSize(smallPondID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(140));
      rmSetAreaLocation(smallPondID, 0.13, 0.37);

      rmSetAreaWaterType(smallPondID, waterType);

      rmSetAreaBaseHeight(smallPondID, 1);
      rmAddAreaToClass(smallPondID, pondClass);
      rmSetAreaCoherence(smallPondID, 0.4);
      rmSetAreaSmoothDistance(smallPondID, 5);
      rmBuildArea(smallPondID);

      int smallPondID2 = rmCreateArea("small pond2");
      rmSetAreaSize(smallPondID2, rmAreaTilesToFraction(100), rmAreaTilesToFraction(140));
      rmSetAreaLocation(smallPondID2, 0.87, 0.63);

      rmSetAreaWaterType(smallPondID2, waterType);

      rmSetAreaBaseHeight(smallPondID2, 4);
      rmAddAreaToClass(smallPondID2, pondClass);
      rmSetAreaCoherence(smallPondID2, 0.2);
      rmSetAreaSmoothDistance(smallPondID2, 5);
      rmBuildArea(smallPondID2);
   }

   for (i = 0; < 22)
   {
      int grassPatchA = rmCreateArea("grass patch A" + i);
      rmSetAreaObeyWorldCircleConstraint(grassPatchA, true);
      rmSetAreaSize(grassPatchA, 0.003, 0.003);
      rmSetAreaObeyWorldCircleConstraint(grassPatchA);
      rmSetAreaTerrainType(grassPatchA, "great_plains\ground6_gp");
      rmAddAreaToClass(grassPatchA, rmClassID("patch"));
      rmSetAreaCoherence(grassPatchA, 0.0);
      rmSetAreaSmoothDistance(grassPatchA, 5);
      rmBuildArea(grassPatchA);
   }

   for (i = 0; < 22)
   {
      int grassPatchB = rmCreateArea("grass patch B" + i);
      rmSetAreaObeyWorldCircleConstraint(grassPatchB, true);
      rmSetAreaSize(grassPatchB, 0.001, 0.001);
      rmSetAreaObeyWorldCircleConstraint(grassPatchB);
      rmSetAreaTerrainType(grassPatchB, "great_plains\ground5_gp");
      rmAddAreaToClass(grassPatchB, rmClassID("patch"));
      rmSetAreaCoherence(grassPatchB, 0.0);
      rmSetAreaSmoothDistance(grassPatchB, 5);
      rmBuildArea(grassPatchB);
   }

   for (i = 0; < 22)
   {
      int grassPatchC = rmCreateArea("grass patch C" + i);
      rmSetAreaObeyWorldCircleConstraint(grassPatchC, true);
      rmSetAreaSize(grassPatchC, 0.001, 0.001);
      rmSetAreaObeyWorldCircleConstraint(grassPatchC);
      rmSetAreaTerrainType(grassPatchC, "great_plains\ground7_gp");
      rmAddAreaToClass(grassPatchC, rmClassID("patch"));
      rmSetAreaCoherence(grassPatchC, 0.0);
      rmSetAreaSmoothDistance(grassPatchC, 5);
      rmBuildArea(grassPatchC);
   }

   for (i = 0; < 11)
   {
      int grassPatchD = rmCreateArea("grass patch D" + i);
      rmSetAreaForestType(grassPatchD, "Great Plains Grass Green");
      rmSetAreaForestDensity(grassPatchD, 0.8);
      rmSetAreaForestClumpiness(grassPatchD, 0.1);
      rmSetAreaForestUnderbrush(grassPatchD, 0.5);
      rmSetAreaObeyWorldCircleConstraint(grassPatchD, true);
      rmSetAreaSize(grassPatchD, 0.0005, 0.0005);
      rmSetAreaObeyWorldCircleConstraint(grassPatchD);
      rmAddAreaToClass(grassPatchD, rmClassID("patch"));
      rmSetAreaCoherence(grassPatchD, 0.0);
      rmSetAreaSmoothDistance(grassPatchD, 5);
      rmAddAreaConstraint(grassPatchD, avoidCenter_dk);

      rmBuildArea(grassPatchD);
   }

   int tradeRouteID = rmCreateTradeRoute();
   int tradeRouteID1 = rmCreateTradeRoute();

   int socketID = rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   int socketIDB = rmCreateObjectDef("sockets to dock Trade Posts B");
   rmSetObjectDefTradeRouteID(socketIDB, tradeRouteID);
   int socketID1 = rmCreateObjectDef("sockets to dock Trade Posts1");
   rmSetObjectDefTradeRouteID(socketID1, tradeRouteID1);
   int socketID1B = rmCreateObjectDef("sockets to dock Trade Posts1 B");
   rmSetObjectDefTradeRouteID(socketID1B, tradeRouteID1);

   rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID, true);
   rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID, 2.0);
   rmSetObjectDefMaxDistance(socketID, 8.0);

   rmAddObjectDefItem(socketIDB, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketIDB, true);
   rmAddObjectDefToClass(socketIDB, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketIDB, 2.0);
   rmSetObjectDefMaxDistance(socketIDB, 8.0);

   rmAddObjectDefItem(socketID1, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1, true);
   rmAddObjectDefToClass(socketID1, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID1, 2.0);
   rmSetObjectDefMaxDistance(socketID1, 8.0);

   rmAddObjectDefItem(socketID1B, "SocketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socketID1B, true);
   rmAddObjectDefToClass(socketID1B, rmClassID("socketClass"));
   rmSetObjectDefMinDistance(socketID1B, 2.0);
   rmSetObjectDefMaxDistance(socketID1B, 8.0);

   if (PlayerNum < 3)
   {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.85);
      rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.42, 0.52, 0, 4);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.85, 0.15);
      rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.58, 0.48, 0, 4);
   }
   else
   {
      rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.85);
      rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.42, 0.58, 1, 4);
      rmAddTradeRouteWaypoint(tradeRouteID1, 0.85, 0.15);
      rmAddRandomTradeRouteWaypoints(tradeRouteID1, 0.58, 0.42, 1, 4);
   }

   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   bool placedTradeRoute1 = rmBuildTradeRoute(tradeRouteID1, "dirt");

   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.15);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.85);
   rmPlaceObjectDefAtPoint(socketIDB, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.15);
   rmPlaceObjectDefAtPoint(socketID1, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID1, 0.85);
   rmPlaceObjectDefAtPoint(socketID1B, 0, socketLoc);

   rmSetStatusText("", 0.20);

   // ------------------------------------------------------ Player Location and Specific Area ---------------------------------------------------------------------------

   int teamZeroCount = rmGetNumberPlayersOnTeam(0);
   int teamOneCount = rmGetNumberPlayersOnTeam(1);
   if (cNumberTeams == 2)
   {
      if (PlayerNum == 2)
      {
         if (rmRandFloat(0, 1) < 0.5)
         {
            rmSetPlacementTeam(0);
            rmSetPlacementSection(0.02, 0.24);
            rmPlacePlayersCircular(0.35, 0.36, 0);

            rmSetPlacementTeam(1);
            rmSetPlacementSection(0.52, 0.74);
            rmPlacePlayersCircular(0.35, 0.36, 0);
         }
         else
         {
            rmSetPlacementTeam(0);
            rmSetPlacementSection(0.02, 0.24);
            rmPlacePlayersCircular(0.35, 0.36, 0);

            rmSetPlacementTeam(1);
            rmSetPlacementSection(0.52, 0.74);
            rmPlacePlayersCircular(0.35, 0.36, 0);
         }
      }
      else
      {
         if (PlayerNum <= 4)
         {
            rmSetPlacementTeam(0);
            rmSetPlacementSection(0.05, 0.21);
            rmPlacePlayersCircular(0.35, 0.36, 0);

            rmSetPlacementTeam(1);
            rmSetPlacementSection(0.55, 0.71);
            rmPlacePlayersCircular(0.35, 0.36, 0);
         }
         else
         {
            rmSetPlacementTeam(0);
            rmSetPlacementSection(0.0, 0.26);
            rmPlacePlayersCircular(0.35, 0.36, 0);

            rmSetPlacementTeam(1);
            rmSetPlacementSection(0.5, 0.76);
            rmPlacePlayersCircular(0.35, 0.36, 0);
         }
      }
   }
   else
   {
      rmSetTeamSpacingModifier(0.25);
      rmPlacePlayersCircular(0.38, 0.40, 0.0);
   }

   // Cliff

   int cliffID = rmCreateArea("cliff" + i);
   rmSetAreaLocation(cliffID, 0.62, 0.62);
   rmSetAreaSize(cliffID, rmAreaTilesToFraction(110 + PlayerNum * 110), rmAreaTilesToFraction(110 + PlayerNum * 110));
   rmSetAreaWarnFailure(cliffID, false);
   rmSetAreaCliffEdge(cliffID, 1, 1);

   rmSetAreaCliffType(cliffID, cliffType);
//   rmSetAreaTerrainType(cliffID, cliffTerrainType);
   rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);

   rmSetAreaCliffHeight(cliffID, 6, 1.0, 0.5);
   rmSetAreaHeightBlend(cliffID, 1);
   rmAddAreaToClass(cliffID, rmClassID("classCliff"));
   rmSetAreaSmoothDistance(cliffID, 0);
   rmSetAreaCoherence(cliffID, 0.70);
   rmBuildArea(cliffID);

   int cliffID1 = rmCreateArea("cliff1" + i);
   rmSetAreaLocation(cliffID1, 0.38, 0.38);
   rmSetAreaSize(cliffID1, rmAreaTilesToFraction(110 + PlayerNum * 110), rmAreaTilesToFraction(110 + PlayerNum * 110));
   rmSetAreaWarnFailure(cliffID1, false);
   rmSetAreaCliffEdge(cliffID1, 1, 1);

   rmSetAreaCliffType(cliffID1, cliffType);
//   rmSetAreaTerrainType(cliffID1, cliffTerrainType);
   rmSetAreaCliffPainting(cliffID1, true, true, true, 1.5, true);

   rmSetAreaCliffHeight(cliffID1, 6, 1.0, 0.5);
   rmSetAreaHeightBlend(cliffID1, 1);
   rmAddAreaToClass(cliffID1, rmClassID("classCliff"));
   rmSetAreaSmoothDistance(cliffID1, 0);
   rmSetAreaCoherence(cliffID1, 0.70);
   rmBuildArea(cliffID1);

   rmSetStatusText("", 0.30);

   int stayInCliff = rmCreateAreaMaxDistanceConstraint("stay in north clith", cliffID, 0);
   int stayNearCliff = rmCreateAreaMaxDistanceConstraint("stay near north clith", cliffID, 4);
   int avoidCliffEdge = rmCreateCliffEdgeDistanceConstraint("not too close to edge", cliffID, 0);

   int stayInClif1 = rmCreateAreaMaxDistanceConstraint("stay in south cliff", cliffID1, 0);
   int stayNearClif1 = rmCreateAreaMaxDistanceConstraint("stay near south cliff", cliffID1, 4);
   int avoidCliffEdge1 = rmCreateCliffEdgeDistanceConstraint("not too close to edge1", cliffID1, 0);

   for (i = 0; < 50 * PlayerNum)
   {
      int patchID = rmCreateArea("patch coastal" + i);
      rmSetAreaWarnFailure(patchID, false);
      rmSetAreaObeyWorldCircleConstraint(patchID, false);
      rmSetAreaSize(patchID, rmAreaTilesToFraction(5), rmAreaTilesToFraction(10));
      rmSetAreaMix(patchID, flowersTerrainMix);
      rmAddAreaToClass(patchID, rmClassID("patch"));
      rmSetAreaCoherence(patchID, 0.0);
      rmAddAreaConstraint(patchID, patchConstraint);
      rmAddAreaConstraint(patchID, avoidCenter_dk);
      rmBuildArea(patchID);
   }

   int stayInEdgeOfCliff = rmCreateEdgeMaxDistanceConstraint("stay close to the edge of the cliff", cliffID, 5);

   int grassInTheCliffEdge = rmCreateArea("grass in the cliff edge");
   rmSetAreaSize(grassInTheCliffEdge, 0.05);
   rmSetAreaMix(grassInTheCliffEdge, "Great Plains grass");
   rmSetAreaCoherence(grassInTheCliffEdge, 0.0);
   rmAddAreaConstraint(grassInTheCliffEdge, stayInEdgeOfCliff);
   rmBuildArea(grassInTheCliffEdge);

   int stayInEdgeOfCliff1 = rmCreateEdgeMaxDistanceConstraint("stay close to the edge of the cliff 1", cliffID1, 5);

   int grassInTheCliffEdge1 = rmCreateArea("grass in the cliff edge 1");
   rmSetAreaSize(grassInTheCliffEdge1, 0.05);
   rmSetAreaMix(grassInTheCliffEdge1, "Great Plains grass");
   rmSetAreaCoherence(grassInTheCliffEdge1, 0.0);
   rmAddAreaConstraint(grassInTheCliffEdge1, stayInEdgeOfCliff1);
   rmBuildArea(grassInTheCliffEdge1);

   int cliffHeartTerrain = rmCreateArea("cliff heart terrain");
   rmSetAreaSize(cliffHeartTerrain, 0.05);
   rmSetAreaMix(cliffHeartTerrain, cliffTerrainType);
//   rmAddAreaTerrainLayer(cliffHeartTerrain, "great_lakes\ground_shoreline3_gl", 0, 1);
   rmSetAreaCoherence(cliffHeartTerrain, 0.0);
   rmAddAreaConstraint(cliffHeartTerrain, stayNearCliff);
//   rmAddAreaConstraint(cliffHeartTerrain, avoidCliffEdge);
   rmBuildArea(cliffHeartTerrain);

   int cliffHeartTerrain1 = rmCreateArea("cliff heart terrain1");
   rmSetAreaSize(cliffHeartTerrain1, 0.05);
   rmSetAreaMix(cliffHeartTerrain1, cliffTerrainType);
//   rmAddAreaTerrainLayer(cliffHeartTerrain1, "great_lakes\ground_shoreline3_gl", 0, 1);
   rmSetAreaCoherence(cliffHeartTerrain1, 0.0);
   rmAddAreaConstraint(cliffHeartTerrain1, stayNearClif1);
//   rmAddAreaConstraint(cliffHeartTerrain1, avoidCliffEdge1);
   rmBuildArea(cliffHeartTerrain1);

    /*
   for (i = 0; < 1 * PlayerNum)
   {
      int patchCliff1 = rmCreateArea("patch cliff south" + i);
      rmSetAreaWarnFailure(patchCliff1, false);
      rmSetAreaObeyWorldCircleConstraint(patchCliff1, false);
      rmSetAreaSize(patchCliff1, rmAreaTilesToFraction(5), rmAreaTilesToFraction(5));
      rmSetAreaMix(patchCliff1, flowersTerrainMix);
      rmAddAreaToClass(patchCliff1, rmClassID("patch"));
      rmSetAreaCoherence(patchCliff1, 0.0);
      rmAddAreaConstraint(patchCliff1, patchConstraint);
      rmAddAreaConstraint(patchCliff1, stayInClif1);
      rmAddAreaConstraint(patchCliff1, avoidCliffEdge1);
      rmSetAreaMix(patchCliff1, "Flowers_Purple");
      rmBuildArea(patchCliff1);
   }

   for (i = 0; < 1 * PlayerNum)
   {
      int patchCliff = rmCreateArea("patch cliff" + i);
      rmSetAreaSize(patchCliff, rmAreaTilesToFraction(5), rmAreaTilesToFraction(10));
      rmSetAreaMix(patchCliff, flowersTerrainMix);
      rmAddAreaToClass(patchCliff, rmClassID("patch"));
      rmSetAreaCoherence(patchCliff, 0.0);
      rmAddAreaConstraint(patchCliff, patchConstraint);
      rmAddAreaConstraint(patchCliff, stayInCliff);
      rmAddAreaConstraint(patchCliff, avoidCliffEdge);
      rmSetAreaMix(patchCliff, "Flowers_Purple");
      rmBuildArea(patchCliff);
   }*/

   if (subCiv0 == rmGetCivID("Cheyenne"))
   {
      int ComancheVillageAID = -1;
      ComancheVillageAID = rmCreateGrouping("Cheyenne village A", "native Cheyenne village " + rmRandInt(1, 5));
      rmSetGroupingMinDistance(ComancheVillageAID, 0.00);
      rmSetGroupingMaxDistance(ComancheVillageAID, 0.00);
      rmAddGroupingConstraint(ComancheVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(ComancheVillageAID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(ComancheVillageAID, 0, 0.2, 0.65);
   }

   if (subCiv1 == rmGetCivID("Cree"))
   {
      int CreeVillageAID = -1;
      CreeVillageAID = rmCreateGrouping("Cree village A", "native Cree village " + rmRandInt(1, 5));
      rmSetGroupingMinDistance(CreeVillageAID, 0.0);
      rmSetGroupingMaxDistance(CreeVillageAID, 0.00);
      rmAddGroupingConstraint(CreeVillageAID, avoidImpassableLand);
      rmAddGroupingToClass(CreeVillageAID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(CreeVillageAID, 0, 0.65, 0.2);
   }
   if (subCiv2 == rmGetCivID("Cree"))
   {
      int CreeVillageID = -1;
      CreeVillageID = rmCreateGrouping("Cree village", "native Cree village " + rmRandInt(1, 5));
      rmSetGroupingMinDistance(CreeVillageID, 0.0);
      rmSetGroupingMaxDistance(CreeVillageID, 4);
      rmAddGroupingConstraint(CreeVillageID, avoidImpassableLand);
      rmAddGroupingToClass(CreeVillageID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(CreeVillageID, 0, 0.35, 0.8);
   }

   if (subCiv3 == rmGetCivID("Cheyenne"))
   {
      int ComancheVillageBID = -1;
      ComancheVillageBID = rmCreateGrouping("Cheyenne village ", "native Cheyenne village " + rmRandInt(1, 5));
      rmSetGroupingMinDistance(ComancheVillageBID, 0.0);
      rmSetGroupingMaxDistance(ComancheVillageBID, 4);
      rmAddGroupingConstraint(ComancheVillageBID, avoidImpassableLand);
      rmAddGroupingToClass(ComancheVillageBID, rmClassID("natives"));
      rmPlaceGroupingAtLoc(ComancheVillageBID, 0, 0.8, 0.35);
   }

   // ------------------------------------------------------ Starting Ressources ---------------------------------------------------------------------------

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
   rmSetObjectDefMinDistance(startingUnits, 0.0);
   rmSetObjectDefMaxDistance(startingUnits, 0.0);

   int startingTCID = rmCreateObjectDef("startingTC");
   if (rmGetNomadStart())
   {
      rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
   }
   rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
   rmSetObjectDefMinDistance(startingTCID, 0.0);
   rmSetObjectDefMaxDistance(startingTCID, 1.0);
   
    if(cNumberNonGaiaPlayers>4){
        rmSetObjectDefMaxDistance(startingTCID, 14.0);
    }
    int teamZeroCount_dk = rmGetNumberPlayersOnTeam(0);
    int teamOneCount_dk = rmGetNumberPlayersOnTeam(1);
    if((cNumberTeams == 2) && (teamZeroCount_dk != teamOneCount_dk)){
        rmSetObjectDefMaxDistance(startingTCID, 30.0);
    }
    
   int StartAreaTreeID = rmCreateObjectDef("starting trees");

   rmAddObjectDefItem(StartAreaTreeID, "TreeGreatPlains", 1, 0.0);

   rmSetObjectDefMinDistance(StartAreaTreeID, 12.0);
   rmSetObjectDefMaxDistance(StartAreaTreeID, 25.0);
   rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);

   int StartDeerID1 = rmCreateObjectDef("starting Deer");
   rmAddObjectDefItem(StartDeerID1, "bison", 5, 5.0);
   rmSetObjectDefMinDistance(StartDeerID1, 10.0);
   rmSetObjectDefMaxDistance(StartDeerID1, 12.0);
   rmSetObjectDefCreateHerd(StartDeerID1, true);
   rmAddObjectDefConstraint(StartDeerID1, avoidStartingUnitsSmall);

   int StartDeerID11 = rmCreateObjectDef("starting Deer1");
   rmAddObjectDefItem(StartDeerID11, hunt1, rmRandInt(13, 14), 7.0);
   rmSetObjectDefMinDistance(StartDeerID11, 36.0);
   rmSetObjectDefMaxDistance(StartDeerID11, 38.0);
   rmSetObjectDefCreateHerd(StartDeerID11, true);
   rmAddObjectDefConstraint(StartDeerID11, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartDeerID11, avoidNatives);
   rmAddObjectDefConstraint(StartDeerID11, avoidCliffs);

   int StartElkID1 = rmCreateObjectDef("starting elk");
   rmAddObjectDefItem(StartElkID1, "Elk", rmRandInt(8, 9), 7.0);
   rmSetObjectDefMinDistance(StartElkID1, 46.0);
   rmSetObjectDefMaxDistance(StartElkID1, 48.0);
   rmSetObjectDefCreateHerd(StartElkID1, true);
   rmAddObjectDefConstraint(StartElkID1, avoidStartingUnitsSmall);
   rmAddObjectDefConstraint(StartElkID1, avoidNatives);
   rmAddObjectDefConstraint(StartElkID1, avoidCliffs);
   rmAddObjectDefConstraint(StartElkID1, avoidDeer);

   int playerNuggetID = rmCreateObjectDef("player nugget");
   rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
   rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
   rmAddObjectDefToClass(playerNuggetID, rmClassID("startingUnit"));
   rmSetObjectDefMinDistance(playerNuggetID, 23.0);
   rmSetObjectDefMaxDistance(playerNuggetID, 32.0);
   rmAddObjectDefConstraint(playerNuggetID, avoidNuggetSmall1);
   rmAddObjectDefConstraint(playerNuggetID, avoidNativesNuggets);
   rmAddObjectDefConstraint(playerNuggetID, avoidTradeRouteSmall);
   rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
   // rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);

   int silverType = -1;
   int playerGoldID = -1;

   for (i = 1; <= PlayerNum)
   {
      rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      if (ypIsAsian(i) && rmGetNomadStart() == false)
         rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      // Everyone gets two ore ObjectDefs, one pretty close, the other a little further away.

      silverType = rmRandInt(1, 10);
      playerGoldID = rmCreateObjectDef("player silver closer " + i);
      rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
      rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
      rmAddObjectDefConstraint(playerGoldID, avoidStartingCoin);
      rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
      rmSetObjectDefMinDistance(playerGoldID, 15.0);
      rmSetObjectDefMaxDistance(playerGoldID, 16.0);

      int startSilver3ID = rmCreateObjectDef("player farther silver" + i);
      rmAddObjectDefItem(startSilver3ID, "mine", 1, 0.0);
      rmSetObjectDefMinDistance(startSilver3ID, 65.0);
      rmSetObjectDefMaxDistance(startSilver3ID, 70.0);
      rmAddObjectDefConstraint(startSilver3ID, avoidAll);
      rmAddObjectDefConstraint(startSilver3ID, avoidFastCoin);
      rmAddObjectDefConstraint(startSilver3ID, avoidCliffs);
      rmAddObjectDefConstraint(startSilver3ID, avoidCenterGold3);

      // Place  gold mines

      if (PlayerNum == 2)
      {
         rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
         rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      }

      if (PlayerNum > 2)
      {
         rmPlaceObjectDefAtLoc(startSilver3ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      }

      rmPlaceObjectDefAtLoc(StartDeerID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartDeerID11, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartElkID1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      // Placing starting trees...
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      rmSetNuggetDifficulty(1, 1);
      rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
   }
   if (PlayerNum > 2)
   {
      int mineb = rmAddFairLoc("TownCenter", false, false, 18, 19, 12, 5);
      rmAddObjectDefConstraint(mineb, avoidStartingCoin);
      rmAddObjectDefConstraint(mineb, avoidStartingUnitsSmall);

      if (rmPlaceFairLocs())
      {
         mineb = rmCreateObjectDef("mine behind");
         rmAddObjectDefItem(mineb, "mine", 1, 0.0);
         for (i = 1; < PlayerNum + 1)
         {
            for (j = 0; < rmGetNumberFairLocs(i))
            {
               rmPlaceObjectDefAtLoc(mineb, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
            }
         }
      }
      else // fallback, mainly for observer mode where fairloc always fails
      {
         for (i = 1; <= PlayerNum)
         {
            rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
         }
      }

      int minef = rmAddFairLoc("TownCenter", true, true, 18, 19, 12, 5);
      rmAddObjectDefConstraint(minef, avoidStartingCoin);
      rmAddObjectDefConstraint(minef, avoidStartingUnitsSmall);
      rmAddObjectDefConstraint(minef, avoidCenter_dk);

      if (rmPlaceFairLocs())
      {
         minef = rmCreateObjectDef("forward mine");
         rmAddObjectDefItem(minef, "mine", 1, 0.0);
         for (i = 1; < PlayerNum + 1)
         {
            for (j = 1; < rmGetNumberFairLocs(i))
            {
               rmPlaceObjectDefAtLoc(minef, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
            }
         }
      }
      else // fallback, mainly for observer mode where fairloc always fails
      {
         for (i = 1; <= PlayerNum)
         {
            rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
         }
      }
   }

   rmSetStatusText("", 0.60);

   // ------------------------------------------------------ Natives & Nuggets & Design ---------------------------------------------------------------------------

   rmSetStatusText("", 0.80);

   // ------------------------------------------------------ Others Ressources ---------------------------------------------------------------------------

   int silverID = -1;
   int silverID1 = -1;
   int silverID2 = -1;
   int silverCount = PlayerNum * 2;
   int silverID3 = -1;

   silverType = rmRandInt(1, 10);
   if (PlayerNum == 2)
   {
         silverID = rmCreateObjectDef("silver ");
         rmAddObjectDefItem(silverID, "mine", 1, 0.0);
         rmSetObjectDefMinDistance(silverID, 0.0);
         rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.05));
         rmAddObjectDefConstraint(silverID, avoidAll);
         rmAddObjectDefConstraint(silverID, shortAvoidImpassableLand);
         rmAddObjectDefConstraint(silverID, avoidTradeRouteSmall);
         rmAddObjectDefConstraint(silverID, avoidSocket);
         rmAddObjectDefConstraint(silverID, avoidCliffs);
         rmAddObjectDefConstraint(silverID, avoidPondMine);
         rmAddObjectDefConstraint(silverID, stayNE);
         rmAddObjectDefConstraint(silverID, avoidCenter_dk);
         rmPlaceObjectDefAtLoc(silverID, 0, 0.8, 0.75);
         rmPlaceObjectDefAtLoc(silverID, 0, 0.95, 0.5);
         rmPlaceObjectDefAtLoc(silverID, 0, 0.75, 0.2);


         silverID2 = rmCreateObjectDef("silver 2");
         rmAddObjectDefItem(silverID2, "mine", 1, 0.0);
         rmSetObjectDefMinDistance(silverID2, 0.0);
         rmSetObjectDefMaxDistance(silverID2, rmXFractionToMeters(0.05));
         rmAddObjectDefConstraint(silverID2, avoidAll);
         rmAddObjectDefConstraint(silverID2, shortAvoidImpassableLand);
         rmAddObjectDefConstraint(silverID2, avoidTradeRouteSmall);
         rmAddObjectDefConstraint(silverID2, avoidSocket);
         rmAddObjectDefConstraint(silverID2, avoidCliffs);
         rmAddObjectDefConstraint(silverID2, avoidPondMine);
         rmAddObjectDefConstraint(silverID2, staySW);
         rmAddObjectDefConstraint(silverID2, avoidCenter_dk);
         rmPlaceObjectDefAtLoc(silverID2, 0, 0.2, 0.25);
         rmPlaceObjectDefAtLoc(silverID2, 0, 0.05, 0.5);
         rmPlaceObjectDefAtLoc(silverID2, 0, 0.25, 0.8);
   }
   else
   {
      for (i = 0; < silverCount)
      {
         silverID3 = rmCreateObjectDef("silver for team " + i);
         rmAddObjectDefItem(silverID3, "mine", 1, 0.0);
         rmSetObjectDefMinDistance(silverID3, 0.0);
         rmSetObjectDefMaxDistance(silverID3, rmXFractionToMeters(0.5));
         rmAddObjectDefConstraint(silverID3, avoidFastCoinTeam);
         rmAddObjectDefConstraint(silverID3, avoidAll);
         rmAddObjectDefConstraint(silverID3, avoidImpassableLand);
         rmAddObjectDefConstraint(silverID3, avoidTradeRouteSmall);
         rmAddObjectDefConstraint(silverID3, avoidSocketMore);
         rmAddObjectDefConstraint(silverID3, avoidCliffs);
         rmAddObjectDefConstraint(silverID3, avoidPondMine);
         rmAddObjectDefConstraint(silverID3, avoidCenter_dk);
         int result3 = rmPlaceObjectDefAtLoc(silverID3, 0, 0.5, 0.5);
         if (result3 == 0)
            break;
      }
   }

   // Small ponds for team
   if (PlayerNum > 2)
   {
      for (i = 0; < PlayerNum + 2)
      {
         int smallPondID3 = rmCreateArea("small pond3" + i);
         rmSetAreaSize(smallPondID3, rmAreaTilesToFraction(70), rmAreaTilesToFraction(90));
         rmSetAreaWaterType(smallPondID3, waterType);
         rmSetAreaBaseHeight(smallPondID3, 4);
         rmAddAreaToClass(smallPondID3, pondClass);
         rmSetAreaCoherence(smallPondID3, 0.05);
         rmSetAreaSmoothDistance(smallPondID3, 5);
         rmAddAreaConstraint(smallPondID3, avoidPondTeam);
         rmAddAreaConstraint(smallPondID3, avoidTradeRoute);
         rmAddAreaConstraint(smallPondID3, avoidSocket);
         rmAddAreaConstraint(smallPondID3, avoidCliffsFar);
         rmAddAreaConstraint(smallPondID3, avoidStartingUnits);
         rmAddAreaConstraint(smallPondID3, avoidNativesWood);
         rmAddAreaConstraint(smallPondID3, avoidCoinShort);
         rmAddAreaConstraint(smallPondID3, avoidCenter_dk);
         rmBuildArea(smallPondID3);
      }
   }

   // RANDOM TREES
   numTries = 8 * PlayerNum;
   failCount = 0;
   for (i = 0; < numTries)
   {
      int forest = rmCreateArea("forest " + i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(100), rmAreaTilesToFraction(140));

      rmSetAreaForestType(forest, forestType);

      rmSetAreaForestDensity(forest, 0.8);
      rmSetAreaForestClumpiness(forest, 0.1);
      rmSetAreaForestUnderbrush(forest, 0.5);
      rmSetAreaCoherence(forest, 0.5);
      rmAddAreaToClass(forest, rmClassID("classForest"));
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidTownCenterFar1);
      rmAddAreaConstraint(forest, avoidImportantItem);
      rmAddAreaConstraint(forest, avoidImpassableLand);
      rmAddAreaConstraint(forest, avoidCliffs);
      rmAddAreaConstraint(forest, avoidTradeRoute);
      rmAddAreaConstraint(forest, avoidSocket);
      rmAddAreaConstraint(forest, avoidNuggetSmall);
      rmAddAreaConstraint(forest, avoidStartingUnitsTree);
      rmAddAreaConstraint(forest, avoidNatives);
      rmAddAreaConstraint(forest, avoidCoinShort);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidCenter);
      rmAddAreaConstraint(forest, avoidCenter_dk);
      if (rmBuildArea(forest) == false)
      {
         // Stop trying once we fail 10 times in a row.
         failCount++;
         if (failCount == 10)
            break;
      }
      else
         failCount = 0;
   }

   numTries = 10;
   failCount = 0;
   for (i = 0; < numTries)
   {
      int forest2 = rmCreateArea("near " + i);
      rmSetAreaWarnFailure(forest2, false);
      rmSetAreaSize(forest2, rmAreaTilesToFraction(60), rmAreaTilesToFraction(80));

      rmSetAreaForestType(forest2, forestType);

      rmSetAreaForestDensity(forest2, 0.8);
      rmSetAreaForestClumpiness(forest2, 0.1);
      rmSetAreaForestUnderbrush(forest2, 0.9);
      rmSetAreaCoherence(forest2, 0.5);
      rmAddAreaToClass(forest2, rmClassID("classForest"));
      rmAddAreaConstraint(forest2, forestConstraint);
      rmAddAreaConstraint(forest2, playerConstraint);
      rmAddAreaConstraint(forest2, avoidTownCenterFar1);
      rmAddAreaConstraint(forest2, avoidImportantItem);
      rmAddAreaConstraint(forest2, avoidImpassableLand);
      rmAddAreaConstraint(forest2, avoidCliffs);
      rmAddAreaConstraint(forest2, avoidTradeRoute);
      rmAddAreaConstraint(forest2, avoidSocket);
      rmAddAreaConstraint(forest2, avoidNuggetSmall);
      rmAddAreaConstraint(forest2, avoidStartingUnitsTree);
      rmAddAreaConstraint(forest2, avoidCoinShort);
      rmAddAreaConstraint(forest2, avoidNatives);
      rmAddAreaConstraint(forest2, avoidAll);
      rmAddAreaConstraint(forest2, avoidCenter_dk);
      if (rmBuildArea(forest2) == false)
      {
         // Stop trying once we fail 10 times in a row.
         failCount++;
         if (failCount == 10)
            break;
      }
      else
         failCount = 0;
   }

   if (PlayerNum == 2)
   {
      // Elk
      int ElkID = rmCreateObjectDef("Elk herd");
      rmAddObjectDefItem(ElkID, "Elk", rmRandInt(7, 10), 8.0);
      rmSetObjectDefMinDistance(ElkID, 0.0);
      rmSetObjectDefMaxDistance(ElkID, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(ElkID, avoidDeer);
      rmAddObjectDefConstraint(ElkID, avoidElk);
      rmAddObjectDefConstraint(ElkID, avoidAll);
      rmAddObjectDefConstraint(ElkID, avoidImpassableLand);
      //rmAddObjectDefConstraint(ElkID, avoidTradeRoute);
      rmAddObjectDefConstraint(ElkID, avoidSocket);
      rmAddObjectDefConstraint(ElkID, avoidTownCenterFar);
      rmAddObjectDefConstraint(ElkID, avoidCliffs);
      rmAddObjectDefConstraint(ElkID, avoidCoinShort);
      rmAddObjectDefConstraint(ElkID, avoidNatives);
      rmAddObjectDefConstraint(ElkID, staySW1);
      rmAddObjectDefConstraint(ElkID, avoidCenter_dk);
      rmSetObjectDefCreateHerd(ElkID, true);
      rmPlaceObjectDefAtLoc(ElkID, 0, 0.5, 0.5, 1);

      // Elk
      int ElkID1 = rmCreateObjectDef("Elk herd1");
      rmAddObjectDefItem(ElkID1, "Elk", rmRandInt(7, 10), 8.0);
      rmSetObjectDefMinDistance(ElkID1, 0.0);
      rmSetObjectDefMaxDistance(ElkID1, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(ElkID1, avoidDeer);
      rmAddObjectDefConstraint(ElkID1, avoidElk);
      rmAddObjectDefConstraint(ElkID1, avoidAll);
      rmAddObjectDefConstraint(ElkID1, avoidImpassableLand);
      //rmAddObjectDefConstraint(ElkID1, avoidTradeRoute);
      rmAddObjectDefConstraint(ElkID1, avoidSocket);
      rmAddObjectDefConstraint(ElkID1, avoidTownCenterFar);
      rmAddObjectDefConstraint(ElkID1, avoidCliffs);
      rmAddObjectDefConstraint(ElkID1, avoidCoinShort);
      rmAddObjectDefConstraint(ElkID1, avoidNatives);
      rmAddObjectDefConstraint(ElkID1, avoidCenter_dk);
      rmAddObjectDefConstraint(ElkID1, stayNE1);
      rmSetObjectDefCreateHerd(ElkID1, true);
      rmPlaceObjectDefAtLoc(ElkID1, 0, 0.5, 0.5, 1);

      // Deer
      int DeerID = rmCreateObjectDef("Deer herd");
      rmAddObjectDefItem(DeerID, hunt1, rmRandInt(9, 12), 8.0);
      rmSetObjectDefMinDistance(DeerID, 0.0);
      rmSetObjectDefMaxDistance(DeerID, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(DeerID, avoidDeer);
      rmAddObjectDefConstraint(DeerID, avoidElk);
      rmAddObjectDefConstraint(DeerID, avoidAll);
      rmAddObjectDefConstraint(DeerID, avoidImpassableLand);
      rmAddObjectDefConstraint(DeerID, avoidSocket);
      rmAddObjectDefConstraint(DeerID, avoidStartingUnits);
      rmAddObjectDefConstraint(DeerID, avoidCliffs);
      rmAddObjectDefConstraint(DeerID, avoidTownCenterFar);
      rmAddObjectDefConstraint(DeerID, avoidCoinShort);
      rmAddObjectDefConstraint(DeerID, avoidNatives);
      rmAddObjectDefConstraint(DeerID, staySW1);
      rmAddObjectDefConstraint(DeerID, avoidCenter_dk);
      rmSetObjectDefCreateHerd(DeerID, true);
      rmPlaceObjectDefAtLoc(DeerID, 0, 0.5, 0.5, 2);

      // Deer
      int DeerID1 = rmCreateObjectDef("Deer herd1");
      rmAddObjectDefItem(DeerID1, hunt1, rmRandInt(9, 12), 8.0);
      rmSetObjectDefMinDistance(DeerID1, 0.0);
      rmSetObjectDefMaxDistance(DeerID1, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(DeerID1, avoidDeer);
      rmAddObjectDefConstraint(DeerID1, avoidElk);
      rmAddObjectDefConstraint(DeerID1, avoidAll);
      rmAddObjectDefConstraint(DeerID1, avoidImpassableLand);
      rmAddObjectDefConstraint(DeerID1, avoidSocket);
      rmAddObjectDefConstraint(DeerID1, avoidStartingUnits);
      rmAddObjectDefConstraint(DeerID1, avoidCliffs);
      rmAddObjectDefConstraint(DeerID1, avoidTownCenterFar);
      rmAddObjectDefConstraint(DeerID1, avoidCoinShort);
      rmAddObjectDefConstraint(DeerID1, avoidNatives);
      rmAddObjectDefConstraint(DeerID1, stayNE1);
      rmAddObjectDefConstraint(DeerID1, avoidCenter_dk);
      rmSetObjectDefCreateHerd(DeerID1, true);
      rmPlaceObjectDefAtLoc(DeerID1, 0, 0.5, 0.5, 2);

      int ElkID2 = rmCreateObjectDef("Elk herd2");
      rmAddObjectDefItem(ElkID2, "Elk", 5, 6.0);
      rmSetObjectDefMinDistance(ElkID2, 0.0);
      rmSetObjectDefMaxDistance(ElkID2, 5.0);
      rmAddObjectDefConstraint(ElkID2, avoidAll);
      rmAddObjectDefConstraint(ElkID2, avoidImpassableLand);
      rmAddObjectDefConstraint(ElkID2, avoidCenter_dk);
      rmSetObjectDefCreateHerd(ElkID2, true);
      rmPlaceObjectDefAtLoc(ElkID2, 0, 0.5, 0.5, 1);
   }
   else
   {
      // Elk
      int ElkID4 = rmCreateObjectDef("Elk herd team");
      rmAddObjectDefItem(ElkID4, "Elk", rmRandInt(7, 10), 8.0);
      rmSetObjectDefMinDistance(ElkID4, 0.0);
      rmSetObjectDefMaxDistance(ElkID4, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(ElkID4, avoidDeer);
      rmAddObjectDefConstraint(ElkID4, avoidElk);
      rmAddObjectDefConstraint(ElkID4, avoidAll);
      rmAddObjectDefConstraint(ElkID4, avoidImpassableLand);
      rmAddObjectDefConstraint(ElkID4, avoidSocket);
      rmAddObjectDefConstraint(ElkID4, avoidTownCenterFar2);
      rmAddObjectDefConstraint(ElkID4, avoidCliffs);
      rmAddObjectDefConstraint(ElkID4, avoidCoinShort);
      rmAddObjectDefConstraint(ElkID4, avoidNatives);
      rmAddObjectDefConstraint(ElkID4, avoidCenter_dk);
      rmSetObjectDefCreateHerd(ElkID4, true);
      rmPlaceObjectDefAtLoc(ElkID4, 0, 0.5, 0.5, PlayerNum * 3);

      // Deer
      int DeerID4 = rmCreateObjectDef("Deer herd team");
      rmAddObjectDefItem(DeerID4, hunt1, rmRandInt(9, 12), 8.0);
      rmSetObjectDefMinDistance(DeerID4, 0.0);
      rmSetObjectDefMaxDistance(DeerID4, rmXFractionToMeters(0.5));
      rmAddObjectDefConstraint(DeerID4, avoidDeer);
      rmAddObjectDefConstraint(DeerID4, avoidElk);
      rmAddObjectDefConstraint(DeerID4, avoidAll);
      rmAddObjectDefConstraint(DeerID4, avoidImpassableLand);
      rmAddObjectDefConstraint(DeerID4, avoidSocket);
      rmAddObjectDefConstraint(DeerID4, avoidStartingUnits);
      rmAddObjectDefConstraint(DeerID4, avoidCliffs);
      rmAddObjectDefConstraint(DeerID4, avoidTownCenterFar2);
      rmAddObjectDefConstraint(DeerID4, avoidCoinShort);
      rmAddObjectDefConstraint(DeerID4, avoidNatives);
      rmAddObjectDefConstraint(DeerID4, avoidCenter_dk);
      rmSetObjectDefCreateHerd(DeerID4, true);
      rmPlaceObjectDefAtLoc(DeerID4, 0, 0.5, 0.5, PlayerNum * 3);
   }
   // Sometimes one hunt doesn't spawn, maybe this is the case when one of the two starting hunts spawn close to trade route.
   // Maybe add an edge constraints to starting hunts so.
   if (PlayerNum == 2)
   {
      silverID1 = rmCreateObjectDef("silver middle");
      rmAddObjectDefItem(silverID1, "minegold", 1, 5.0);
      rmSetObjectDefMinDistance(silverID1, 0.0);
      rmSetObjectDefMaxDistance(silverID1, 5.0);
      
      if (rmGetIsKOTH())
      {
        //rmPlaceObjectDefAtLoc(silverID1, 0, 0.45, 0.493);
       rmAddObjectDefConstraint(silverID1, avoidCenter_dk);

      }
      else
      {
         rmPlaceObjectDefAtLoc(silverID1, 0, 0.5, 0.5);
        rmAddObjectDefConstraint(silverID1, avoidCenter_dk);

      }
   }

   rmSetStatusText("", 0.90);

   //	---------------------------------------------------- Nuggets ----------------------------------------------------------------------------------------
   int nugget4ID = rmCreateObjectDef("nugget4");
   rmAddObjectDefItem(nugget4ID, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(nugget4ID, 0.0);
   rmSetObjectDefMaxDistance(nugget4ID, rmXFractionToMeters(0.20));
   rmAddObjectDefConstraint(nugget4ID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget4ID, avoidNugget);
   rmAddObjectDefConstraint(nugget4ID, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget4ID, playerConstraint);
   rmAddObjectDefConstraint(nugget4ID, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget4ID, avoidSocketMore);
   rmAddObjectDefConstraint(nugget4ID, avoidCliffs);
   rmAddObjectDefConstraint(nugget4ID, avoidNativesNuggets);
   rmAddObjectDefConstraint(nugget4ID, avoidCoinShort);
   rmAddObjectDefConstraint(nugget4ID, circleConstraint);
   rmAddObjectDefConstraint(nugget4ID, avoidAll);
   rmAddObjectDefConstraint(nugget4ID, avoidCenter_dk);
   rmSetNuggetDifficulty(4, 4);
   if (PlayerNum > 2 && rmGetIsTreaty() == false)
      rmPlaceObjectDefAtLoc(nugget4ID, 0, 0.5, 0.5, PlayerNum/2);
      
   int nugget3ID = rmCreateObjectDef("nugget3");
   rmAddObjectDefItem(nugget3ID, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(nugget3ID, 0.0);
   rmSetObjectDefMaxDistance(nugget3ID, rmXFractionToMeters(0.35));
   rmAddObjectDefConstraint(nugget3ID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nugget3ID, avoidNugget);
   rmAddObjectDefConstraint(nugget3ID, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nugget3ID, playerConstraint);
   rmAddObjectDefConstraint(nugget3ID, avoidTradeRoute);
   rmAddObjectDefConstraint(nugget3ID, avoidSocketMore);
   rmAddObjectDefConstraint(nugget3ID, avoidCliffs);
   rmAddObjectDefConstraint(nugget3ID, avoidNativesNuggets);
   rmAddObjectDefConstraint(nugget3ID, avoidCoinShort);
   rmAddObjectDefConstraint(nugget3ID, circleConstraint);
   rmAddObjectDefConstraint(nugget3ID, avoidAll);
   rmAddObjectDefConstraint(nugget3ID, avoidCenter_dk);
   rmSetNuggetDifficulty(3, 3);
   if (PlayerNum > 2)
      rmPlaceObjectDefAtLoc(nugget3ID, 0, 0.5, 0.5, PlayerNum);

   int nuggetSWID = rmCreateObjectDef("nugget SW");
   rmAddObjectDefItem(nuggetSWID, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(nuggetSWID, 0.0);
   rmSetObjectDefMaxDistance(nuggetSWID, rmXFractionToMeters(0.45));
   if (PlayerNum == 2)
      rmAddObjectDefConstraint(nuggetSWID, staySW1);
   rmAddObjectDefConstraint(nuggetSWID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nuggetSWID, avoidNugget);
   rmAddObjectDefConstraint(nuggetSWID, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nuggetSWID, playerConstraint);
   rmAddObjectDefConstraint(nuggetSWID, avoidTradeRoute);
   rmAddObjectDefConstraint(nuggetSWID, avoidSocketMore);
   rmAddObjectDefConstraint(nuggetSWID, avoidCliffs);
   rmAddObjectDefConstraint(nuggetSWID, avoidNativesNuggets);
   rmAddObjectDefConstraint(nuggetSWID, avoidCoinShort);
   rmAddObjectDefConstraint(nuggetSWID, circleConstraint);
   rmAddObjectDefConstraint(nuggetSWID, avoidAll);
   rmAddObjectDefConstraint(nuggetSWID, avoidCenter_dk);
   rmSetNuggetDifficulty(2, 2);
   rmPlaceObjectDefAtLoc(nuggetSWID, 0, 0.5, 0.5, PlayerNum * 3);

   int nuggetNEID = rmCreateObjectDef("nugget NE");
   rmAddObjectDefItem(nuggetNEID, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(nuggetNEID, 0.0);
   rmSetObjectDefMaxDistance(nuggetNEID, rmXFractionToMeters(0.45));
   if (PlayerNum == 2)
      rmAddObjectDefConstraint(nuggetNEID, stayNE1);
   rmAddObjectDefConstraint(nuggetNEID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(nuggetNEID, avoidNugget);
   rmAddObjectDefConstraint(nuggetNEID, nuggetPlayerConstraint);
   rmAddObjectDefConstraint(nuggetNEID, playerConstraint);
   rmAddObjectDefConstraint(nuggetNEID, avoidTradeRoute);
   rmAddObjectDefConstraint(nuggetNEID, avoidSocketMore);
   rmAddObjectDefConstraint(nuggetNEID, avoidCliffs);
   rmAddObjectDefConstraint(nuggetNEID, avoidNativesNuggets);
   rmAddObjectDefConstraint(nuggetNEID, avoidCoinShort);
   rmAddObjectDefConstraint(nuggetNEID, circleConstraint);
   rmAddObjectDefConstraint(nuggetNEID, avoidAll);
   rmAddObjectDefConstraint(nuggetNEID, avoidCenter_dk);
   rmSetNuggetDifficulty(2, 2);
   rmPlaceObjectDefAtLoc(nuggetNEID, 0, 0.5, 0.5, PlayerNum * 3);

   // ------------------------------------------------------ TRIGGER and OP TAPIR---------------------------------------------------------------------------

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

   rmSetStatusText("", 1.0);
}

// ***********************************************************************************************************************************************
// ****************************************************** E N D **********************************************************************************
// ***********************************************************************************************************************************************