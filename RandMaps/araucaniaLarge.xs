//********************************************************************************//

/*

LARGE ARAUCANIA
KPM
Age of Empires 3 - Warchiefs
LARGE version by vividlyplain, July 2021
// updated the natives, September 2021, vividlyplain

Araucania is a random map that encompasses modern day Chile. It is 
rectangular with the long axis oriented from NW to SE. Each time the 
script runs one of three variations will be seen - 
   1. A northern desert region that is heavy on copper mines,
   2. A central grassy region that has plentiful berries, hunting 
      and herdables, or
   3. A southern icy region that has a bunch of treasures.

The coastline will also use one of three variants -
   1. A large outcropping in the center of the coast,
   2. A relatively straight line from NW to SE, or
   3. A 'bay' in the center of the coast.

Textures and starting resources should clue players in to which 
variation the script has chosen.

The native settlements here are Mapuche.

*/

//********************************************************************************//

// PJJ - modifying script for YPack update

// April 2021 edited by vividlyplain for DE

include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
include "mercenaries.xs";

void main(void)
{
//********************************************************************************//
   rmSetStatusText("",0.01);
//********************************************************************************//

// Map Setup
   // Setting up how big the map is and that it is rectangular
   int playerTiles = 27000;
   int size = 1.4 * sqrt(cNumberNonGaiaPlayers * playerTiles);
   int longSide = 1.7 * size;
   
   rmSetMapSize(size,longSide);
   rmEchoInfo("Map size = "+size+"m x "+longSide+"m");
   rmSetWorldCircleConstraint(false);

   chooseMercs();

   // Setting up variations (used here and in placement)
   // Resources that can vary
   int numberMinePasses = 2;

   int herdSizeHunting = rmRandInt(6,6);
   int herdSizeHerdable = rmRandInt(1,2);
   int numberBerryPatch = rmRandInt(7,7);
   int numberBerryPasses = 1;
   int i =0;

   float numberGuanacoPasses = 2;
   float numberDeerPasses = 1.5;
   float numberNuggetEasyPasses = 2;
   float numberNuggetHardNutsPasses = 1;

 
//********************************************************************************//

   // Variation handler - terrain and Natives
   int whichVariation = rmRandInt(1,3);

   // Blank strings for names determined in the if statement below
   string coastMixName = "";
   string inlandWestMixName = "";
   string inlandEastMixName = "";
   string andesMixName = "";

   string forestName = "";
   string cliffName = "";
   string nativeName = "";
   string native2Name = "";
   string oceanName = "";
   string treeName = "";

   int whichNative = rmRandInt(1,2);

   rmSetSubCiv(1, "Mapuche");
   rmSetSubCiv(2, "Incas");      // now Quechua
   if (whichNative == 1) {
      nativeName = "native Mapuche village ";
      native2Name = "native inca village ";
   }
   else {
      native2Name = "native Mapuche village ";
      nativeName = "native inca village ";
   }

   // North Araucania variation stuff
   if(whichVariation == 1)
   {
      rmEchoInfo("Araucania North");
      rmSetMapType("araucania");
      rmSetSeaType("Araucania North Coast");
      rmSetSeaLevel(0);
      rmTerrainInitialize("water");
      rmEnableLocalWater(false);
      rmSetLightingSet("Araucania_NorthGrass_Skirmish");

      cliffName = "Araucania North";
      forestName = "North Araucania Forest";
      treeName = "TreeAraucania";

      coastMixName = "araucania_north_dirt_a";
      inlandWestMixName = "araucania_north_grass_a";
      inlandEastMixName = "araucania_north_grass_b";
      andesMixName = "araucania_north_grass_c";

      numberMinePasses = 2;
      numberGuanacoPasses = 1.5;
      numberDeerPasses = 1.5;
   }

   // Central Araucania variation stuff
   else if(whichVariation == 2)
   {
      rmEchoInfo("Araucania Central");
      rmSetMapType("araucania");
      rmSetSeaType("Araucania Central Coast");
      rmSetSeaLevel(0);
      rmTerrainInitialize("water");
      rmEnableLocalWater(false);
      rmSetLightingSet("Araucania_CentralDesert_Skirmish");

      cliffName = "Araucania Central";
      forestName = "Araucania Forest";
      treeName = "TreeAraucania";

      coastMixName = "araucania_dirt_b";
      inlandWestMixName = "araucania_grass_c";
      inlandEastMixName = "araucania_grass_b";
      andesMixName = "araucania_grass_a";

      numberBerryPasses = 2;
      numberBerryPatch = rmRandInt(5,7);
   }

   // South Araucania variation stuff (Nuggets)
   else if(whichVariation == 3)
   {
      rmEchoInfo("Araucania South");
      rmSetMapType("araucania");
      rmSetSeaType("Araucania Southern Coast");
      rmSetSeaLevel(0);
      rmTerrainInitialize("water");
      rmEnableLocalWater(false);
      rmSetLightingSet("Araucania_SouthSnow_Skirmish");

      cliffName = "Araucania South";
      forestName = "Patagonia Snow Forest";
      treeName = "TreePatagoniaSnow";

      coastMixName = "araucania_snow_c";
      inlandWestMixName = "araucania_snow_c";
      inlandEastMixName = "araucania_snow_a";
      andesMixName = "araucania_snow_b";

      numberNuggetEasyPasses = 1.5;
      numberNuggetHardNutsPasses = 1.0;
   }

//********************************************************************************//

// Defining classes
int classStartingUnits = rmDefineClass("Starting Units");
int cliffClass = rmDefineClass("right cliff");


//********************************************************************************//

   // Trade route
   int avoidTradeRouteClose = rmCreateTradeRouteDistanceConstraint("Avoid trade route close", 6.0);
   int avoidTradeRouteMedium = rmCreateTradeRouteDistanceConstraint("Avoid trade route medium", 10.0);
   int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("Avoid trade route far", 20.0);
   int avoidTradeSocket = rmCreateTypeDistanceConstraint("Avoid trade socket", "sockettraderoute", 30.0);

   // Home City water flag
   int avoidFlags = rmCreateTypeDistanceConstraint("Flag avoids flags", "HomeCityWaterSpawnFlag", 10.0);
   int avoidEdgeFlag = rmCreatePieConstraint("Flags stay near map edge", 0.5, 0.5, rmGetMapZSize()-20, rmGetMapXSize()-10, 0, 0, 0);

   // All
   int avoidAllClose = rmCreateTypeDistanceConstraint("Avoid everything a little", "all", 6.0);
   int avoidAllClose2 = rmCreateTypeDistanceConstraint("Avoid everything a little2", "all", 3.0);
   int avoidAllMedium = rmCreateTypeDistanceConstraint("Avoid everything more", "all", 10.0);
   int avoidAllFar = rmCreateTypeDistanceConstraint("Avoid everything a lot", "all", 20.0);
   
   // Impassable land and water
   // Avoid land
   int avoidImpassableLandClose = rmCreateTerrainDistanceConstraint("Avoid impassable land close", "Land", true, 4.0);
   int avoidImpassableLandMedium = rmCreateTerrainDistanceConstraint("Avoid impassable land medium", "Land", true, 10.0);
   int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("Avoid impassable land far", "Land", true, 20.0);
   int avoidImpassableLandSuperFar = rmCreateTerrainDistanceConstraint("Avoid impassable land super far", "Land", true, 40.0);
   // Avoid other
   int avoidImpassableClose = rmCreateTerrainDistanceConstraint("Avoid impassable close", "Land", false, 4.0);
   int avoidImpassableMedium = rmCreateTerrainDistanceConstraint("Avoid impassable medium", "Land", false, 10.0);
   int avoidImpassableFar = rmCreateTerrainDistanceConstraint("Avoid impassable far", "Land", false, 20.0);
   int avoidImpassableSuperFar = rmCreateTerrainDistanceConstraint("Avoid impassable super far", "Land", false, 40.0);

   // Avoid nuggets
   int avoidNugget = rmCreateTypeDistanceConstraint("nugget vs nugget", "abstractnugget", 40.0);
   
   // Avoid starting units
   int avoidStartingUnits = rmCreateClassDistanceConstraint("Avoid starting units", classStartingUnits, 40.0);
  int avoidStartingUnitsShort = rmCreateClassDistanceConstraint("Avoid starting units short", classStartingUnits, 6.0);

   // Box constraints
   int notInTheMountains = rmCreateBoxConstraint("Don't place in the mountains", 0.0, 0.03, 0.93, 0.97, 0);
   int edgeConstraint = rmCreateBoxConstraint("Edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);

   int northTeam = rmCreateBoxConstraint("North Team", 0.0, 0.55, 0.93, 0.97, 0);
   int noMansLand = rmCreateBoxConstraint("No Man's Land", 0.0, 0.35, 0.93, 0.65, 0);
   int noMansLand2 = rmCreateBoxConstraint("No Man's Land_dk", 0.0, 0.29, 0.93, 0.71, 0);
   int southTeam = rmCreateBoxConstraint("South Team", 0.0, 0.03, 0.93, 0.45, 0);

   int northDeer = rmCreateBoxConstraint("North deer box", 0.3, 0.6, 0.55, 0.97, 0);
   int northGuanaco = rmCreateBoxConstraint("North guanaco box", 0.55, 0.6, 0.9, 0.97, 0);

   int southDeer = rmCreateBoxConstraint("South deer box", 0.3, 0.03, 0.55, 0.4, 0);
   int southGuanaco = rmCreateBoxConstraint("South guanaco box", 0.5, 0.03, 0.9, 0.4, 0);
   
    //for koth
    int classCenter_dk = rmDefineClass("center_dk");
    int avoidCenter_dk = rmCreateTypeDistanceConstraint("avoids the center for KOTH _dk", "ypKingsHill", 15);


//********************************************************************************//

// Areas
   // Big continent
   int bigContinent = rmCreateArea("Big continent");
   int bigContinentCenter = rmRandInt(1,3);

   if(bigContinentCenter == 1)
   {
      rmAddAreaInfluenceSegment(bigContinent, 0.75, 0.0, 0.75, 1.0);
      rmSetAreaLocation(bigContinent, 0.55, 0.5);
      rmSetAreaSize(bigContinent, 0.75, 0.75);
   }
   else if(bigContinentCenter == 2)
   {
      rmAddAreaInfluenceSegment(bigContinent, 0.75, 0.0, 0.75, 1.0);
      rmSetAreaLocation(bigContinent, 0.75, 0.5);
      rmSetAreaSize(bigContinent, 0.75, 0.75);
   }
   else if(bigContinentCenter == 3)
   {
      rmAddAreaInfluenceSegment(bigContinent, 0.9, 0.0, 0.9, 1.0);
      rmAddAreaInfluenceSegment(bigContinent, 0.65, 0.15, 0.7, 0.15);
      rmAddAreaInfluenceSegment(bigContinent, 0.65, 0.85, 0.7, 0.85);
      rmSetAreaLocation(bigContinent, 0.75, 0.5);
      rmSetAreaSize(bigContinent, 0.725, 0.725);
   }
   rmSetAreaBaseHeight(bigContinent, 1.0);
   rmSetAreaCoherence(bigContinent, 0.90);
   rmSetAreaMix(bigContinent, coastMixName);
   rmSetAreaEdgeFilling(bigContinent, 1.0);
   rmSetAreaSmoothDistance(bigContinent, 10.0);

   rmSetAreaElevationType(bigContinent, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinent, 2.0);
   rmSetAreaElevationMinFrequency(bigContinent, 0.09);
   rmSetAreaElevationOctaves(bigContinent, 1.0);
   rmSetAreaElevationPersistence(bigContinent, 0.2);
   rmSetAreaElevationNoiseBias(bigContinent, 1.0);

   rmSetAreaWarnFailure(bigContinent, false);
   rmBuildArea(bigContinent);

//********************************************************************************//
   rmSetStatusText("",0.1);
//********************************************************************************//

      // Mixes for inland West, inland East and Andes foot areas
   int inlandWestMix = rmCreateArea("Inland West textures");
   rmAddAreaInfluenceSegment(inlandWestMix, 0.55, 0.0, 0.55, 1.0);
   rmSetAreaLocation(inlandWestMix, 0.55, 0.5);
   rmSetAreaSize(inlandWestMix, 0.2, 0.2);
   rmSetAreaCoherence(inlandWestMix, 0.6);
   rmSetAreaMix(inlandWestMix, inlandWestMixName);

   int inlandEastMix = rmCreateArea("Inland East textures");
   rmAddAreaInfluenceSegment(inlandEastMix, 0.7, 0.0, 0.7, 1.0);
   rmSetAreaLocation(inlandEastMix, 0.7, 0.5);
   rmSetAreaSize(inlandEastMix, 0.2, 0.2);
   rmSetAreaCoherence(inlandEastMix, 0.6);
   rmSetAreaMix(inlandEastMix, inlandEastMixName);

   int andesMix = rmCreateArea("Textures at the base of the Andes");
   rmAddAreaInfluenceSegment(andesMix, 0.85, 0.0, 0.85, 1.0);
   rmSetAreaLocation(andesMix, 0.85, 0.5);
   rmSetAreaSize(andesMix, 0.2, 0.2);
   rmSetAreaCoherence(andesMix, 0.6);
   rmSetAreaMix(andesMix, andesMixName);

      // Andes cliffs
   int andesCliffs = rmCreateArea("The Andes Cliffs");
   rmAddAreaInfluenceSegment(andesCliffs, 1.0, 0.0, 1.0, 1.0);
   rmSetAreaLocation(andesCliffs, 0.97, 0.5);
   rmSetAreaSize(andesCliffs, 0.045, 0.045);
   rmSetAreaMix(andesCliffs, andesMixName);
   rmAddAreaToClass(andesCliffs, cliffClass);

   rmSetAreaCoherence(andesCliffs, 0.75);
   rmSetAreaEdgeFilling(andesCliffs, 1.0);
   rmSetAreaSmoothDistance(andesCliffs, 10.0);
   rmSetAreaHeightBlend(andesCliffs, 6.0);
   // Specific cliff stuff
   rmSetAreaCliffHeight(andesCliffs, 8.0, 2.0, 0.0);
   rmSetAreaCliffType(andesCliffs, cliffName);
   rmSetAreaCliffEdge(andesCliffs, 1.0, 1.0, 0.0, 1.0, 0);
   rmSetAreaCliffPainting(andesCliffs, true, true, true, 1.0, true);

   rmSetAreaWarnFailure(andesCliffs, false);
   rmBuildArea(andesCliffs);

      // Trade route
   int tradeRoute = rmCreateTradeRoute();
   int socket = rmCreateObjectDef("Sockets for Trade Route");

   rmSetObjectDefTradeRouteID(socket, tradeRoute);
   rmAddObjectDefItem(socket, "socketTradeRoute", 1, 0.0);
   rmSetObjectDefAllowOverlap(socket, true);
   rmSetObjectDefMinDistance(socket, 2.0);
   rmSetObjectDefMaxDistance(socket, 8.0);
   rmAddTradeRouteWaypoint(tradeRoute, 0.85, 0.95);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.65, 0.8, 0, 0);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.5, 0.6, 0,0);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.5, 0.4, 0, 0);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.65, 0.2, 0, 0);
   rmAddRandomTradeRouteWaypoints(tradeRoute, 0.85, 0.05, 0, 0);

   bool placedTradeRoute = rmBuildTradeRoute(tradeRoute, "dirt_trail");

   // Place the sockets along the trade route - uses percentages
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.05);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.2);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.4);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.6);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.8);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);
   socketLoc = rmGetTradeRouteWayPoint(tradeRoute, 0.95);
   rmPlaceObjectDefAtPoint(socket, 0, socketLoc);

         // Native settlements defined and placed
      int nativeVillageType = rmRandInt(1,5);
      int nativeVillage = 0;
      nativeVillage = rmCreateGrouping("Native village "+i, nativeName+nativeVillageType);
      rmSetGroupingMinDistance(nativeVillage, 0.0);
      rmSetGroupingMaxDistance(nativeVillage, 0.0);
      rmAddGroupingToClass(nativeVillage, classStartingUnits);
      rmPlaceGroupingAtLoc(nativeVillage, 0, 0.75, 0.65);

      int nativeVillageType2 = rmRandInt(1,5);
      int nativeVillage2 = 0;
      nativeVillageType2 = rmCreateGrouping("Native village second"+i, nativeName+nativeVillageType2);
      rmSetGroupingMinDistance(nativeVillageType2, 0.0);
      rmSetGroupingMaxDistance(nativeVillageType2, 0.0);
      rmAddGroupingToClass(nativeVillageType2, classStartingUnits);
      rmPlaceGroupingAtLoc(nativeVillageType2, 0, 0.75, 0.35);

      int nativeVillageType3 = rmRandInt(1,5);
      if (whichNative == 1)
         nativeVillageType3 = 4;

      int nativeVillage3 = 0;
      nativeVillage3 = rmCreateGrouping("Native village third"+i, native2Name+nativeVillageType3);
      rmSetGroupingMinDistance(nativeVillage3, 0.0);
      rmSetGroupingMaxDistance(nativeVillage3, 0.0);
      rmAddGroupingToClass(nativeVillage3, classStartingUnits);
      if (cNumberTeams == 2)
         rmPlaceGroupingAtLoc(nativeVillage3, 0, 0.40, 0.50);

   // Placement, defining and placing
   // Define team placement
   int teamZeroCount = rmGetNumberPlayersOnTeam(0);
   int teamOneCount = rmGetNumberPlayersOnTeam(1);
   
   float teamPlacement = rmRandFloat(0, 1);

   if (cNumberTeams > 2) 
   { // Free-for-all
      rmPlacePlayer(1, 0.45, 0.8);
      rmPlacePlayer(2, 0.45, 0.2);
      rmPlacePlayer(3, 0.35, 0.5);
      rmPlacePlayer(4, 0.35, 0.65);
      rmPlacePlayer(5, 0.35, 0.35);
      rmPlacePlayer(6, 0.8, 0.5);
      rmPlacePlayer(7, 0.6, 0.9);
      rmPlacePlayer(8, 0.6, 0.1);
   }
   else
   {
      if (teamZeroCount == teamOneCount) // Teams have an even number of players
      {
		  if (cNumberNonGaiaPlayers > 4) 
		  {
         if (teamPlacement > 0.50) // Places Team 0 in the south 50% of the time
         {
            rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.40, 0.20, 0.825, 0.30, 0.0, 0.0);
				
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.40, 0.80, 0.825, 0.70, 0.0, 0.0);            
			}
			else // Places Team 0 in the north 50% of the time
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.40, 0.80, 0.825, 0.70, 0.0, 0.0);
	
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.40, 0.20, 0.825, 0.30, 0.0, 0.0);
			}
		  }
		  else 
		  {
			if (teamPlacement > 0.50) // Places Team 0 in the south 50% of the time
			{
				rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.45, 0.2, 0.75, 0.25, 0.0, 0.0);
            
            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.45, 0.80, 0.75, 0.75, 0.0, 0.0);            
         }
         else // Places Team 0 in the north 50% of the time
         {
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.45, 0.80, 0.75, 0.75, 0.0, 0.0);

            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.45, 0.2, 0.75, 0.25, 0.0, 0.0);
         }
      }
      }
      else // Teams have an uneven number of players
      {
         if (teamZeroCount > teamOneCount) 
         { // Team 0 is bigger
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.30, 0.10, 0.80, 0.30, 10.0, 0.25);

            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.30, 0.90, 0.80, 0.70, 10.0, 0.25);
         }
         else // Team 1 is bigger
         {
            rmSetPlacementTeam(0);
            rmPlacePlayersLine(0.30, 0.90, 0.80, 0.70, 10.0, 0.25);

            rmSetPlacementTeam(1);
            rmPlacePlayersLine(0.30, 0.10, 0.80, 0.30, 10.0, 0.25); 
         }
      }
   }
   rmBuildAllAreas();

//********************************************************************************//
   rmSetStatusText("",0.2);
//********************************************************************************//

   int townCenter = rmCreateObjectDef("Player TC");

   if(rmGetNomadStart())
   {
      rmAddObjectDefItem(townCenter, "CoveredWagon", 1, 0.0);
   }
   else
   {
      rmAddObjectDefItem(townCenter, "TownCenter", 1, 0.0);
   }
   if (cNumberTeams > 2) // Free-for-all
   {
    rmSetObjectDefMinDistance(townCenter, 0.0);
    if (cNumberNonGaiaPlayers > 2)
    rmSetObjectDefMaxDistance(townCenter, 25.0);
	else
		rmSetObjectDefMaxDistance(townCenter, 0.0);
    rmAddObjectDefToClass(townCenter, classStartingUnits);
    rmAddObjectDefConstraint(townCenter, avoidTradeRouteClose);
    rmAddObjectDefConstraint(townCenter, avoidAllMedium);
    rmAddObjectDefConstraint(townCenter, edgeConstraint);
    rmAddObjectDefConstraint(townCenter, avoidImpassableMedium);
   }
   else
   {
      rmSetObjectDefMinDistance(townCenter, 0.0);
      if(cNumberNonGaiaPlayers==2){
        rmSetObjectDefMaxDistance(townCenter, 0.0);
      }else{
        rmSetObjectDefMaxDistance(townCenter, 22.0);
      }
      rmAddObjectDefToClass(townCenter, classStartingUnits);
   }

   int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 0.0);
	rmSetObjectDefMaxDistance(startingUnits, 0.0);

      // Coin
   int startingMine = rmCreateObjectDef("Starting mine");
   rmAddObjectDefItem(startingMine, "MineCopper", 1, 8.0);
   rmSetObjectDefMinDistance(startingMine, 13.0);
   rmSetObjectDefMaxDistance(startingMine, 15.0);
   rmAddObjectDefToClass(startingMine, classStartingUnits);
   rmAddObjectDefConstraint(startingMine, avoidAllMedium);
   rmAddObjectDefConstraint(startingMine, edgeConstraint);
    rmAddObjectDefConstraint(startingMine, avoidStartingUnitsShort);
   rmAddObjectDefConstraint(startingMine, avoidImpassableFar);

   // Food - Guanaco
   int startingHunting = rmCreateObjectDef("Starting hunting close");
   rmAddObjectDefItem(startingHunting, "Guanaco", rmRandInt(6,7), 4.0);
   rmSetObjectDefMinDistance(startingHunting, 12.0);
   rmSetObjectDefMaxDistance(startingHunting, 18.0);
   rmSetObjectDefCreateHerd(startingHunting, true);
   rmAddObjectDefToClass(startingHunting, classStartingUnits);
   rmAddObjectDefConstraint(startingHunting, avoidAllMedium);
   rmAddObjectDefConstraint(startingHunting, edgeConstraint);
   rmAddObjectDefConstraint(startingHunting, avoidStartingUnitsShort);
   rmAddObjectDefConstraint(startingHunting, avoidImpassableFar);

   int startingHunting2 = rmCreateObjectDef("Starting hunting medium");
   rmAddObjectDefItem(startingHunting2, "Guanaco", rmRandInt(12,14), 6.0);
   rmSetObjectDefMinDistance(startingHunting2, 35.0);
   rmSetObjectDefMaxDistance(startingHunting2, 40.0);
   rmSetObjectDefCreateHerd(startingHunting2, true);
   rmAddObjectDefToClass(startingHunting2, classStartingUnits);
   rmAddObjectDefConstraint(startingHunting2, avoidAllMedium);
   rmAddObjectDefConstraint(startingHunting2, edgeConstraint);
   rmAddObjectDefConstraint(startingHunting2, avoidStartingUnitsShort);
   rmAddObjectDefConstraint(startingHunting2, avoidImpassableFar);

   // Wood
   int startingTrees = rmCreateObjectDef("Starting trees");
   rmAddObjectDefItem(startingTrees, treeName, 3, 8.0);
   rmSetObjectDefMinDistance(startingTrees, 14.0);
   rmSetObjectDefMaxDistance(startingTrees, 18.0);
   rmAddObjectDefToClass(startingTrees, classStartingUnits);
   rmAddObjectDefConstraint(startingTrees, avoidAllMedium);
   rmAddObjectDefConstraint(startingTrees, edgeConstraint);
   rmAddObjectDefConstraint(startingTrees, avoidStartingUnitsShort);

      // Nuggets - Easy
   int startingNuggetsEasy = rmCreateObjectDef("Starting nuggets easy");
   rmAddObjectDefItem(startingNuggetsEasy, "Nugget", 1, 0.0);
   rmSetObjectDefMinDistance(startingNuggetsEasy, 20.0);
   rmSetObjectDefMaxDistance(startingNuggetsEasy, 30.0);
   rmAddObjectDefToClass(startingNuggetsEasy, classStartingUnits);
   rmAddObjectDefConstraint(startingNuggetsEasy, avoidImpassableMedium);
   rmAddObjectDefConstraint(startingNuggetsEasy, avoidAllMedium);
   rmAddObjectDefConstraint(startingNuggetsEasy, edgeConstraint);

   // New extra stuff for water spawn point avoidance.
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);


   for(i = 1; < cNumberPlayers)
   {
      // TC places
      rmPlaceObjectDefAtLoc(townCenter, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingMine, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingHunting, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingHunting2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingTrees, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingTrees, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingTrees, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingNuggetsEasy, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
      rmPlaceObjectDefAtLoc(startingNuggetsEasy, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

      
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flag
		int waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmSetObjectDefMinDistance(waterFlagID, 00);
		rmSetObjectDefMaxDistance(waterFlagID, 25);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(townCenter, i));
        vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, 0.10, rmPlayerLocZFraction(i));
		rmClearClosestPointConstraints();

   }
   
//********************************************************************************//
   rmSetStatusText("",0.3);
//********************************************************************************//
   
     // check for KOTH game mode
  if(rmGetIsKOTH()) {
  
        
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.0;
    float yLoc = 0.5;
    float walk = 0.075;
    
    if((randLoc == 1)&& (cNumberNonGaiaPlayers==3)){
        xLoc = .58; 
    }else if(randLoc == 1){
        xLoc = .5; 
    }else if((cNumberNonGaiaPlayers==3) && (randLoc==2)){
        xLoc = .58;
    }else{
        xLoc = .8;
    }
      
    if(cNumberTeams > 2) {
      yLoc = rmRandFloat(.1, .9);
      walk = 0.25;
    }
    /*
    int centerMarker = rmCreateArea("centerMarker");
    rmSetAreaSize(centerMarker, 0.011, 0.011);
    rmSetAreaLocation(centerMarker, xLoc, yLoc);
    //rmSetAreaBaseHeight(centerMarker, 4.0);
    rmAddAreaToClass(centerMarker, classCenter_dk);
    rmSetAreaCoherence(centerMarker, 1.0);
    rmSetAreaTerrainType(centerMarker, "texas\ground4_tex");
    rmBuildArea(centerMarker);
    */
    ypKingsHillPlacer(xLoc, yLoc, walk, notInTheMountains);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
  
   int avoidDeer=rmCreateTypeDistanceConstraint("Deer avoids food", "Guanaco", 55.0);
   int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
   int avoidCliff=rmCreateClassDistanceConstraint("avoid cliff right", cliffClass, 10.0);
   int avoidCoinShort=rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);
   int avoidEdge = rmCreatePieConstraint("Avoid Edge1",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 8.0);
   int avoidTownCenterFar1=rmCreateTypeDistanceConstraint("avoid Town Center Far 1", "townCenter", 42.0);

   	int numberOfHunts=cNumberNonGaiaPlayers*8;
	int IbexPlacement=0;

	int result=0;
	int leaveWhile=0;

   for(i = 1; < cNumberPlayers*5)
   {	
	int IbexSize = rmRandInt(7,10);
   int IbexID=rmCreateObjectDef("Ibex herd"+i);
   rmAddObjectDefItem(IbexID, "Guanaco", IbexSize, 8.0);
   rmSetObjectDefMinDistance(IbexID, 0.0);
   rmSetObjectDefMaxDistance(IbexID, rmZFractionToMeters(0.5));
   rmAddObjectDefConstraint(IbexID, avoidAll);
   rmAddObjectDefConstraint(IbexID, avoidDeer);
   rmAddObjectDefConstraint(IbexID, avoidTownCenterFar);
   rmAddObjectDefConstraint(IbexID, avoidCoinShort);
   rmAddObjectDefConstraint(IbexID, avoidCliff);   
   rmAddObjectDefConstraint(IbexID, avoidWaterShort);     
   rmAddObjectDefConstraint(IbexID, southTeam);  
   rmAddObjectDefConstraint(IbexID, avoidCenter_dk);  
   rmSetObjectDefCreateHerd(IbexID, true);
   rmPlaceObjectDefAtLoc(IbexID, 0, 0.75, 0.1,1);
   }

   for(i = 1; < cNumberPlayers*5)
   {	
	int IbexSize2 = rmRandInt(7,10);
   int IbexID2=rmCreateObjectDef("Ibex south"+i);
   rmAddObjectDefItem(IbexID2, "Guanaco", IbexSize2, 8.0);
   rmSetObjectDefMinDistance(IbexID2, 0.0);
   rmSetObjectDefMaxDistance(IbexID2, rmZFractionToMeters(0.5));
   rmAddObjectDefConstraint(IbexID2, avoidAll);
   rmAddObjectDefConstraint(IbexID2, avoidDeer);
   rmAddObjectDefConstraint(IbexID2, avoidTownCenterFar);
   rmAddObjectDefConstraint(IbexID2, avoidCoinShort);
   rmAddObjectDefConstraint(IbexID2, avoidCliff);   
   rmAddObjectDefConstraint(IbexID2, avoidWaterShort);     
   rmAddObjectDefConstraint(IbexID2, northTeam);   
    rmAddObjectDefConstraint(IbexID2, avoidCenter_dk);   
   rmSetObjectDefCreateHerd(IbexID2, true);
   rmPlaceObjectDefAtLoc(IbexID2, 0, 0.75, 0.9,1);
   }

//********************************************************************************//
   rmSetStatusText("",0.4);
//********************************************************************************//
   
      // Non-Player-Placed resources and map features
   int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids start", "gold", 40.0);

   // No man's land mines
   for (i = 0; < 3 * cNumberNonGaiaPlayers)
   {
      int miningNoMansLand = rmCreateObjectDef("No man's land mines "+i);
      rmAddObjectDefItem(miningNoMansLand, "MineCopper", 1, 0.0);
      rmSetObjectDefMinDistance(miningNoMansLand, 0.0);
      rmSetObjectDefMaxDistance(miningNoMansLand, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(miningNoMansLand, noMansLand);
      rmAddObjectDefConstraint(miningNoMansLand, avoidAllMedium);
      rmAddObjectDefConstraint(miningNoMansLand, edgeConstraint);
      rmAddObjectDefConstraint(miningNoMansLand, avoidImpassableFar);
      rmAddObjectDefConstraint(miningNoMansLand, avoidCoin);
    rmAddObjectDefConstraint(miningNoMansLand, avoidCenter_dk);
      rmPlaceObjectDefAtLoc(miningNoMansLand, 0, 0.6, 0.5);
   }

   // Mines
   // North mines
   for (i = 0; < 1 * cNumberNonGaiaPlayers + 1)
   {
      int miningNorth = rmCreateObjectDef("North team mines "+i);
      rmAddObjectDefItem(miningNorth, "MineCopper", 1, 0.0);
      rmSetObjectDefMinDistance(miningNorth, 0.0);
      rmSetObjectDefMaxDistance(miningNorth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(miningNorth, northTeam);
      rmAddObjectDefConstraint(miningNorth, avoidAllMedium);
      rmAddObjectDefConstraint(miningNorth, edgeConstraint);
      rmAddObjectDefConstraint(miningNorth, avoidImpassableFar);
      rmAddObjectDefConstraint(miningNorth, avoidTownCenterFar1);
      rmAddObjectDefConstraint(miningNorth, avoidCoin);
      rmAddObjectDefConstraint(miningNorth, avoidCenter_dk);
      rmPlaceObjectDefAtLoc(miningNorth, 0, 0.6, 0.8);
   }

   // South mines
   for (i = 0; < 1 * cNumberNonGaiaPlayers + 1)
   {
      int miningSouth = rmCreateObjectDef("South team mines "+i);
      rmAddObjectDefItem(miningSouth, "MineCopper", 1, 0.0);
      rmSetObjectDefMinDistance(miningSouth, 0.0);
      rmSetObjectDefMaxDistance(miningSouth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(miningSouth, southTeam);
      rmAddObjectDefConstraint(miningSouth, avoidAllMedium);
      rmAddObjectDefConstraint(miningSouth, edgeConstraint);
      rmAddObjectDefConstraint(miningSouth, avoidTownCenterFar1);
      rmAddObjectDefConstraint(miningSouth, avoidImpassableFar);
      rmAddObjectDefConstraint(miningSouth, avoidCoin);
      rmAddObjectDefConstraint(miningSouth, avoidCenter_dk);
      rmPlaceObjectDefAtLoc(miningSouth, 0, 0.6, 0.2);
   }

//********************************************************************************//
   rmSetStatusText("",0.5);
//********************************************************************************//
   
      // Forest
   // North forest
   int forestPass = 4 * cNumberNonGaiaPlayers;
   int forestFailCount = 0;
   for (i = 0; < forestPass)
   {
      int forestNorth = rmCreateArea("Forest north "+i, bigContinent);
      rmSetAreaWarnFailure(forestNorth, false);
      rmSetAreaSize(forestNorth, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forestNorth, forestName);
      rmSetAreaForestDensity(forestNorth, 0.85);
      rmSetAreaForestClumpiness(forestNorth, 0.5);
      rmSetAreaForestUnderbrush(forestNorth, 0.25);
      rmSetAreaCoherence(forestNorth, 0.8);
      rmSetAreaSmoothDistance(forestNorth, 10);
      rmAddAreaConstraint(forestNorth, northTeam);
      rmAddAreaConstraint(forestNorth, avoidTradeSocket);
      rmAddAreaConstraint(forestNorth, avoidAllMedium);
      rmAddAreaConstraint(forestNorth, edgeConstraint);
       rmAddAreaConstraint(forestNorth, avoidCenter_dk);

      if(rmBuildArea(forestNorth) == false)
      {
         // Stop trying once we fail 6 times in a row.
         forestFailCount++;
         if(forestFailCount == 6)
            break;
      }
      else
         forestFailCount = 0; 
   }

//********************************************************************************//
   rmSetStatusText("",0.6);
//********************************************************************************//
   
   // No man's land forest
   forestPass = 6 * cNumberNonGaiaPlayers;
   forestFailCount = 0;
   for (i = 0; < forestPass)
   {
      int forestNoMansLand = rmCreateArea("Forest no man's land "+i, bigContinent);
      rmSetAreaWarnFailure(forestNoMansLand, false);
      rmSetAreaSize(forestNoMansLand, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
      rmSetAreaForestType(forestNoMansLand, forestName);
      rmSetAreaForestDensity(forestNoMansLand, 0.75);
      rmSetAreaForestClumpiness(forestNoMansLand, 0.5);
      rmSetAreaForestUnderbrush(forestNoMansLand, 0.25);
      rmSetAreaCoherence(forestNoMansLand, 0.25);
      rmSetAreaSmoothDistance(forestNoMansLand, 10);
      rmAddAreaConstraint(forestNoMansLand, noMansLand);
      rmAddAreaConstraint(forestNoMansLand, avoidTradeSocket);
      rmAddAreaConstraint(forestNoMansLand, avoidAllMedium);
      rmAddAreaConstraint(forestNoMansLand, edgeConstraint);
    rmAddAreaConstraint(forestNoMansLand, avoidCenter_dk);
      if(rmBuildArea(forestNoMansLand) == false)
      {
         // Stop trying once we fail 6 times in a row.
         forestFailCount++;
         if(forestFailCount == 6)
            break;
      }
      else
         forestFailCount = 0; 
   }

//********************************************************************************//
   rmSetStatusText("",0.7);
//********************************************************************************//
  
   // South forest
   forestPass = 4 * cNumberNonGaiaPlayers;
   forestFailCount = 0;
   for (i = 0; <forestPass)
   {
      int forestSouth = rmCreateArea("Forest south "+i, bigContinent);
      rmSetAreaWarnFailure(forestSouth, false);
      rmSetAreaSize(forestSouth, rmAreaTilesToFraction(200), rmAreaTilesToFraction(200));
      rmSetAreaForestType(forestSouth, forestName);
      rmSetAreaForestDensity(forestSouth, 0.85);
      rmSetAreaForestClumpiness(forestSouth, 0.5);
      rmSetAreaForestUnderbrush(forestSouth, 0.25);
      rmSetAreaCoherence(forestSouth, 0.8);
      rmSetAreaSmoothDistance(forestSouth, 10);
      rmAddAreaConstraint(forestSouth, southTeam);
      rmAddAreaConstraint(forestSouth, avoidTradeSocket);
      rmAddAreaConstraint(forestSouth, avoidAllMedium);
      rmAddAreaConstraint(forestSouth, edgeConstraint);
    rmAddAreaConstraint(forestSouth, avoidCenter_dk);
      if(rmBuildArea(forestSouth) == false)
      {
         // Stop trying once we fail 6 times in a row.
         forestFailCount++;
         if(forestFailCount == 6)
            break;
      }
      else
         forestFailCount = 0; 
   }

//********************************************************************************//
   rmSetStatusText("",0.8);
//********************************************************************************//
  
   // Berries - North
   for (i = 0; < cNumberNonGaiaPlayers)
   {
      int berriesNorth = rmCreateObjectDef("North berry patches "+i);
      rmAddObjectDefItem(berriesNorth, "Berrybush", numberBerryPatch, 4.0);
      rmSetObjectDefMinDistance(berriesNorth, 0.0);
      rmSetObjectDefMaxDistance(berriesNorth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(berriesNorth, northTeam);
      rmAddObjectDefConstraint(berriesNorth, avoidAllMedium);
      rmAddObjectDefConstraint(berriesNorth, edgeConstraint);
      rmAddObjectDefConstraint(berriesNorth, avoidImpassableFar);
    rmAddObjectDefConstraint(berriesNorth, avoidCenter_dk);
      rmPlaceObjectDefAtLoc(berriesNorth, 0, 0.76, 0.8);
   }
   // Berries - No man's land
   for (i = 0; < numberBerryPasses * cNumberNonGaiaPlayers)
   {
      int berriesNoMansLand = rmCreateObjectDef("No man's land berry patches "+i);
      rmAddObjectDefItem(berriesNoMansLand, "Berrybush", numberBerryPatch, 4.0);
      rmSetObjectDefMinDistance(berriesNoMansLand, 0.0);
      rmSetObjectDefMaxDistance(berriesNoMansLand, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(berriesNoMansLand, noMansLand);
      rmAddObjectDefConstraint(berriesNoMansLand, avoidAllMedium);
      rmAddObjectDefConstraint(berriesNoMansLand, edgeConstraint);
      rmAddObjectDefConstraint(berriesNoMansLand, avoidImpassableFar);
      rmAddObjectDefConstraint(berriesNoMansLand, avoidCenter_dk);
      rmPlaceObjectDefAtLoc(berriesNoMansLand, 0, 0.76, 0.5);
   }
   // Berries - South
   for (i = 0; < cNumberNonGaiaPlayers)
   {
      int berriesSouth = rmCreateObjectDef("South berry patches "+i);
      rmAddObjectDefItem(berriesSouth, "Berrybush", numberBerryPatch, 4.0);
      rmSetObjectDefMinDistance(berriesSouth, 0.0);
      rmSetObjectDefMaxDistance(berriesSouth, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(berriesSouth, southTeam);
      rmAddObjectDefConstraint(berriesSouth, avoidAllMedium);
      rmAddObjectDefConstraint(berriesSouth, edgeConstraint);
      rmAddObjectDefConstraint(berriesSouth, avoidImpassableFar);
      rmAddObjectDefConstraint(berriesSouth, avoidCenter_dk);
      rmPlaceObjectDefAtLoc(berriesSouth, 0, 0.24, 0.2);
   }
    int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "herdable", 33.0);

    // Herdable animals - Llama - No man's land -- DK edit
    int noMansLandLlamas = rmCreateObjectDef("No man's land llamas ");
    rmAddObjectDefItem(noMansLandLlamas, "Llama", 1, 3.0);
    rmSetObjectDefMinDistance(noMansLandLlamas, 0.0);
    rmSetObjectDefMaxDistance(noMansLandLlamas, rmZFractionToMeters(0.5));
    rmAddObjectDefConstraint(noMansLandLlamas, noMansLand2);
    rmAddObjectDefConstraint(noMansLandLlamas, avoidAllClose2);
    rmAddObjectDefConstraint(noMansLandLlamas, edgeConstraint);
    rmAddObjectDefConstraint(noMansLandLlamas, avoidImpassableFar);
    rmAddObjectDefConstraint(noMansLandLlamas, avoidSheep);
    rmAddObjectDefConstraint(noMansLandLlamas, avoidCenter_dk);
    rmPlaceObjectDefAtLoc(noMansLandLlamas, 0, 0.75, 0.5, cNumberNonGaiaPlayers*6);
          
   // Whales - North
   int northWhales=rmCreateObjectDef(" North whales");
   rmAddObjectDefItem(northWhales, "HumpbackWhale", 1, 0.0);
   rmSetObjectDefMinDistance(northWhales, 0.0);
   rmSetObjectDefMaxDistance(northWhales, rmZFractionToMeters(0.5));
   rmAddObjectDefConstraint(northWhales, northTeam);
   rmAddObjectDefConstraint(northWhales, avoidAllFar);
   rmAddObjectDefConstraint(northWhales, avoidImpassableLandFar);
   rmPlaceObjectDefAtLoc(northWhales, 0, 0.0, 1.0, 1+0.5*cNumberNonGaiaPlayers);

   // Whales - South
   int southWhales=rmCreateObjectDef(" South whales");
   rmAddObjectDefItem(southWhales, "HumpbackWhale", 1, 0.0);
   rmSetObjectDefMinDistance(southWhales, 0.0);
   rmSetObjectDefMaxDistance(southWhales, rmZFractionToMeters(0.5));
   rmAddObjectDefConstraint(southWhales, southTeam);
   rmAddObjectDefConstraint(southWhales, avoidAllFar);
   rmAddObjectDefConstraint(southWhales, avoidImpassableLandFar);
   rmPlaceObjectDefAtLoc(southWhales, 0, 0.0, 0.0, 1+0.5*cNumberNonGaiaPlayers);

   // Fish - North
   int northFish=rmCreateObjectDef("North fish");
   rmAddObjectDefItem(northFish, "FishSardine", 1, 2.0);
   rmSetObjectDefMinDistance(northFish, 0.0);
   rmSetObjectDefMaxDistance(northFish, rmXFractionToMeters(0.65));
   rmAddObjectDefConstraint(northFish, northTeam);
   rmAddObjectDefConstraint(northFish, avoidAllFar);
   rmAddObjectDefConstraint(northFish, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(northFish, 0, 0.0, 1.0, 3+5 * cNumberNonGaiaPlayers);

   // Fish - North2
   int northFish2=rmCreateObjectDef("North fish 2");
   rmAddObjectDefItem(northFish2, "FishSardine", 1, 9.0);
   rmSetObjectDefMinDistance(northFish2, 0.0);
   rmSetObjectDefMaxDistance(northFish2, rmXFractionToMeters(0.75));
   rmAddObjectDefConstraint(northFish2, northTeam);
   rmAddObjectDefConstraint(northFish2, avoidAllMedium);
   rmAddObjectDefConstraint(northFish2, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(northFish2, 0, 0.0, 1.0, 2+1 * cNumberNonGaiaPlayers);

//********************************************************************************//
   rmSetStatusText("",0.9);
//********************************************************************************//

   // Fish - South
   int southFish=rmCreateObjectDef("South fish");
   rmAddObjectDefItem(southFish, "FishSardine", 1, 2.0);
   rmSetObjectDefMinDistance(southFish, 0.0);
   rmSetObjectDefMaxDistance(southFish, rmZFractionToMeters(0.65));
   rmAddObjectDefConstraint(southFish, southTeam);
   rmAddObjectDefConstraint(southFish, avoidAllFar);
   rmAddObjectDefConstraint(southFish, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(southFish, 0, 0.0, 0.5, 3+5 * cNumberNonGaiaPlayers);

   // Fish - South2
   int southFish2=rmCreateObjectDef("South fish 2");
   rmAddObjectDefItem(southFish2, "FishSardine", 1, 9.0);
   rmSetObjectDefMinDistance(southFish2, 0.0);
   rmSetObjectDefMaxDistance(southFish2, rmZFractionToMeters(0.75));
   rmAddObjectDefConstraint(southFish2, southTeam);
   rmAddObjectDefConstraint(southFish2, avoidAllMedium);
   rmAddObjectDefConstraint(southFish2, avoidImpassableLandMedium);
   rmPlaceObjectDefAtLoc(southFish2, 0, 0.0, 0.5, 2+1 * cNumberNonGaiaPlayers);
     
   // Nuggets - No man's land - NUTS
   int noMansLandNuggetNuts = rmCreateObjectDef("No man's land nuggets nuts ");
      rmAddObjectDefItem(noMansLandNuggetNuts, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(noMansLandNuggetNuts, 0.0);
      rmSetObjectDefMaxDistance(noMansLandNuggetNuts, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(noMansLandNuggetNuts, noMansLand);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidAllClose);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidImpassableFar);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidNugget);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidStartingUnits);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidTradeRouteClose);
      rmAddObjectDefConstraint(noMansLandNuggetNuts, avoidCenter_dk);
      if(cNumberNonGaiaPlayers==2 || rmGetIsTreaty() == true){
        rmSetNuggetDifficulty(3,3);
      }else{
        rmSetNuggetDifficulty(4, 4);
   }
      rmPlaceObjectDefAtLoc(noMansLandNuggetNuts, 0, 0.76, 0.5, cNumberNonGaiaPlayers);

    // Nuggets - North - HARD
   int northNuggetsHard = rmCreateObjectDef("North nuggets hard ");
      rmAddObjectDefItem(northNuggetsHard, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(northNuggetsHard, 0.0);
      rmSetObjectDefMaxDistance(northNuggetsHard, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(northNuggetsHard, northTeam);
      rmAddObjectDefConstraint(northNuggetsHard, avoidAllClose);
      rmAddObjectDefConstraint(northNuggetsHard, avoidImpassableFar);
      rmAddObjectDefConstraint(northNuggetsHard, avoidNugget);
      rmAddObjectDefConstraint(northNuggetsHard, avoidStartingUnits);
      rmAddObjectDefConstraint(northNuggetsHard, avoidTradeRouteClose);
      rmAddObjectDefConstraint(northNuggetsHard, avoidCenter_dk);
      rmSetNuggetDifficulty(3, 3);
      rmPlaceObjectDefAtLoc(northNuggetsHard, 0, 0.76, 0.8, cNumberNonGaiaPlayers);

   // Nuggets - North - MODERATE
   int northNuggetsModerate = rmCreateObjectDef("North nuggets moderate ");
      rmAddObjectDefItem(northNuggetsModerate, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(northNuggetsModerate, 0.0);
      rmSetObjectDefMaxDistance(northNuggetsModerate, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(northNuggetsModerate, northTeam);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidAllClose);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidNugget);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidImpassableFar);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidStartingUnits);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidTradeRouteClose);
      rmAddObjectDefConstraint(northNuggetsModerate, avoidCenter_dk);
      rmSetNuggetDifficulty(2, 2);
      rmPlaceObjectDefAtLoc(northNuggetsModerate, 0, 0.76, 0.8, cNumberNonGaiaPlayers*1.5);

  // Nuggets - North - EASY
   int northNuggetsEasy = rmCreateObjectDef("North nuggets easy ");
      rmAddObjectDefItem(northNuggetsEasy, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(northNuggetsEasy, 0.0);
      rmSetObjectDefMaxDistance(northNuggetsEasy, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(northNuggetsEasy, northTeam);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidAllClose);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidImpassableMedium);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidNugget);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidStartingUnits);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidTradeRouteClose);
      rmAddObjectDefConstraint(northNuggetsEasy, avoidCenter_dk);
      rmSetNuggetDifficulty(1, 1);
      rmPlaceObjectDefAtLoc(northNuggetsEasy, 0, 0.76, 0.8, cNumberNonGaiaPlayers*2);

    // Nuggets - South HARD
   int southNuggetsHard = rmCreateObjectDef("South nuggets hard ");
      rmAddObjectDefItem(southNuggetsHard, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(southNuggetsHard, 0.0);
      rmSetObjectDefMaxDistance(southNuggetsHard, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(southNuggetsHard, southTeam);
      rmAddObjectDefConstraint(southNuggetsHard, avoidAllClose);
      rmAddObjectDefConstraint(southNuggetsHard, avoidImpassableFar);
      rmAddObjectDefConstraint(southNuggetsHard, avoidNugget);
      rmAddObjectDefConstraint(southNuggetsHard, avoidStartingUnits);
      rmAddObjectDefConstraint(southNuggetsHard, avoidTradeRouteClose);
      rmAddObjectDefConstraint(southNuggetsHard, avoidCenter_dk);
      rmSetNuggetDifficulty(3, 3);
      rmPlaceObjectDefAtLoc(southNuggetsHard, 0, 0.24, 0.2, cNumberNonGaiaPlayers);

   // Nuggets - South MODERATE
   int southNuggetsModerate = rmCreateObjectDef("South nuggets moderate ");
      rmAddObjectDefItem(southNuggetsModerate, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(southNuggetsModerate, 0.0);
      rmSetObjectDefMaxDistance(southNuggetsModerate, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(southNuggetsModerate, southTeam);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidAllClose);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidImpassableFar);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidNugget);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidStartingUnits);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidTradeRouteClose);
      rmAddObjectDefConstraint(southNuggetsModerate, avoidCenter_dk);
      rmSetNuggetDifficulty(2, 2);
      rmPlaceObjectDefAtLoc(southNuggetsModerate, 0, 0.24, 0.2, cNumberNonGaiaPlayers*1.5);

   // Nuggets - South EASY
   int southNuggetsEasy = rmCreateObjectDef("South nuggets easy ");
      rmAddObjectDefItem(southNuggetsEasy, "Nugget", 1, 4.0);
      rmSetObjectDefMinDistance(southNuggetsEasy, 0.0);
      rmSetObjectDefMaxDistance(southNuggetsEasy, rmZFractionToMeters(0.5));
      rmAddObjectDefConstraint(southNuggetsEasy, southTeam);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidAllClose);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidImpassableMedium);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidNugget);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidStartingUnits);
      rmAddObjectDefConstraint(southNuggetsEasy, avoidTradeRouteClose);
       rmAddObjectDefConstraint(southNuggetsEasy, avoidCenter_dk);
      rmSetNuggetDifficulty(1, 1);
      rmPlaceObjectDefAtLoc(southNuggetsEasy, 0, 0.24, 0.2, cNumberNonGaiaPlayers*2);

//********************************************************************************//
   rmSetStatusText("",1.0);
//********************************************************************************//

}