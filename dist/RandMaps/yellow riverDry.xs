// Yellow River
// PJJ - Oct 06
// AOE3 DE 2019 Updated by Alex Y  
//Durokan's June 30 2020 update for 1v1

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);
  
  // randomize wet (1) or dry (2)
  int whichVersion = rmRandInt(1,2);
//  if (rmRandFloat(0,1) <= 0.80) // 20% chance of flooded spawn (down from 50%)
//    whichVersion = 2;
//  if (cNumberNonGaiaPlayers == 2) // removes flooded spawn from 1v1s
//    whichVersion = 2;
   //whichVersion = 1;    //debug
 
  // initialize map type variables 
  string baseMix = "yellow_river_a";
  string baseTerrain = "Yellow_river\grass2_yellow_riv";
  string playerTerrain = "Yellow_river\stone2_yellow_riv";
  string playerTerrain1 = "Yellow_river\stone1_yellow_riv";

  string patchMix = "yellow_river_a";
  string patchTerrain = "Yellow_river\grass2_yellow_riv";
  string patchType1 = "Yellow_river\stone2_yellow_riv";
  string patchType2 = "Yellow_river\stone1_yellow_riv";
 
  string forestType1 = "Bamboo Forest";
  string forestType2 = "Yellow River Forest";
  string startTreeType = "ypTreeYellowRiver";
  
  string mapType1 = "yellowRiver";
  string mapType2 = "Grass";
  string mapType3 = "";
  
  string huntable1 = "ypSerow";
  string huntable2 = "ypIbex";
  string huntable3 = "ypMarcoPoloSheep";
  
  string lightingType = "";
  
  string tradeRouteType = "water";
  
  string nativeOne = "";
  string nativeTwo = "";
  if (rmRandFloat(0,1) <= 0.50)
  {
    nativeOne = "Shaolin";
    nativeTwo = "Zen";
  }
  else
  {
    nativeOne = "Zen";
    nativeTwo = "Shaolin";
  }
  
  string riverType = "";
  
  string fish1 = "ypFishCarp";
  string fish2 = "ypFishCatfish";
  
	int rivermin = -1;
	int rivermax = -1;
  int windSpeed = -1;
  float rainChance = -1;

  // Wet
  if(whichVersion == 1) {
    mapType3 = "Water";
    windSpeed = 4.0;
    rainChance = 0.8;
    lightingType = "yellow_river_wet_skirmish";
	riverType = "Yellow River Wet";
	
    if (cNumberNonGaiaPlayers <= 4){
      rivermin = 8;
      rivermax = 9;
	  }
	
    else	{
		 rivermin = 12;
		 rivermax = 14;
	  }
  }
  
  // Dry
  else {

    mapType3 = "Land";
    windSpeed = 1.0;
    rainChance = 0.0;
    lightingType = "yellow_river_dry_skirmish";
	riverType = "Yellow River Dry";
	
    if (cNumberNonGaiaPlayers <= 3){
      rivermin = 6;
		  rivermax = 6;
	  }
	  
    else	{
		 rivermin = 7;
		 rivermax = 8;
	  }
  }

  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  if (cNumberTeams > 2 || (teamZeroCount - teamOneCount) > 2 || (teamOneCount - teamZeroCount) > 2)
    weird = true;
  
// Native Civs
  int subCiv0=-1;
  int subCiv1=-1;
  int subCiv2=-1;

  if (rmAllocateSubCivs(2) == true)
  {
		  // First native
		  subCiv0=rmGetCivID(nativeOne);
      if (subCiv0 >= 0)
         rmSetSubCiv(0, nativeOne);

		  // Second native
		  subCiv1=rmGetCivID(nativeTwo);
      if (subCiv1 >= 0)
         rmSetSubCiv(1, nativeTwo);
  }

// Basic map stuff
	int playerTiles = 10500;
	if (cNumberNonGaiaPlayers >2)
		playerTiles = 10000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles = 9500;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 9000;

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 5, 0.4, 3.0);
	rmSetMapElevationHeightBlend(1);
	
	// Picks a default water height
	rmSetSeaLevel(1.0);
	rmSetLightingSet(lightingType);

   // Picks default terrain and water
	rmSetSeaType(riverType);
	rmSetBaseTerrainMix(baseMix);
	rmTerrainInitialize(baseTerrain, 5.0);
	rmEnableLocalWater(false);
	rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType(mapType3);
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(windSpeed);
  rmSetGlobalRain(rainChance);

	chooseMercs();

// Classes
	int classPlayer=rmDefineClass("player");
	int classSocket=rmDefineClass("socketClass");
	int classPatch=rmDefineClass("patch");
	rmDefineClass("classForest");
	rmDefineClass("natives");

// Constraints
    
	// Map edge constraints
	int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, 0, rmGetMapXSize()-18, 0, 0, 0);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 15.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);
  int playerConstraintNugget = rmCreateTypeDistanceConstraint("nuggets avoid TCs", "Towncenter", 55.0);
  
	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
  int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water short", "Land", false, 4.0);
  int avoidWater6 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 6.0);
  int avoidWater = rmCreateTerrainDistanceConstraint("avoid water further", "Land", false, 10.0);
  
  // Resource avoidance
  int avoidRandomBerries=rmCreateTypeDistanceConstraint("avoid random berries", "berrybush", 35.0);
  int extraFood=rmCreateBoxConstraint("keep extra food near river", 0, .35, 1, .65, 0.01);
  int avoidSilver=rmCreateTypeDistanceConstraint("avoid coin", "abstractmine", 55.0);
	int mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold", "abstractmine", 30.0);
  int avoidHuntable3=rmCreateTypeDistanceConstraint("avoid huntable 3", huntable3, 50.0);
	int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid huntable 2", huntable2, 50.0);
	int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid huntable 1", huntable1, 50.0);
	int avoidNuggets=rmCreateTypeDistanceConstraint("nugget vs. nugget", "AbstractNugget", 20.0);
  int avoidNuggetMedium=rmCreateTypeDistanceConstraint("nugget vs. nugget medium", "AbstractNugget", 35.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget vs. nugget far", "AbstractNugget", 50.0);
  int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
  int forestConstraintShort=rmCreateClassDistanceConstraint("forest vs. forest short", rmClassID("classForest"), 10.0);
  int forestConstraintGroves=rmCreateClassDistanceConstraint("forest vs. forest for small groves", rmClassID("classForest"), 15.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 4.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 4.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 8.0);
  int avoidKOTH=rmCreateTypeDistanceConstraint("avoid KOTH", "ypKingsHill", 8.0);
  
  int topConstraint=rmCreateBoxConstraint("stay on top of map", 0, .65, 1, 1);
  int bottomConstraint=rmCreateBoxConstraint("stay on bottom of map", 0, 0, 1, .35);
  int middleConstraint=rmCreateBoxConstraint("stay in middle of map", 0, .35, 1, .65);

	// Specify true so constraint stays outside of circle (i.e. inside corners)
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.485), rmDegreesToRadians(0), rmDegreesToRadians(360));

	// Unit avoidance
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 10.0);
    int shortAvoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives a little", rmClassID("natives"), 4.0);
	int farAvoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives alot", rmClassID("natives"), 80.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 10.0);

  // fish constraints
  int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", fish1, 15.0);	
	int fishVsFish2ID=rmCreateTypeDistanceConstraint("fish v fish2", fish2, 15.0); 
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 8.0);

  // flag constraints
  int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 10.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint=rmCreatePieConstraint("flag edge of map", 0.5, 0.5, 0, rmZFractionToMeters(0.20), rmDegreesToRadians(0), rmDegreesToRadians(360));
  
  int hillLand = rmCreateTerrainDistanceConstraint("hill land", "land", true, 6.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);

	// Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
  int shortAvoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets short", "sockettraderoute", 5.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "sockettraderoute", 11.0);
	int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "sockettraderoute", 40.0);
    
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

// Objects
	
	int huntable1ID=rmCreateObjectDef("huntable 1");
	rmAddObjectDefItem(huntable1ID, huntable1, 7, 6.0);
	rmSetObjectDefCreateHerd(huntable1ID, true);
	rmSetObjectDefMinDistance(huntable1ID, 0.0);
	rmSetObjectDefMaxDistance(huntable1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(huntable1ID, avoidResource);
	rmAddObjectDefConstraint(huntable1ID, mediumPlayerConstraint);
	rmAddObjectDefConstraint(huntable1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(huntable1ID, avoidHuntable2);
	rmAddObjectDefConstraint(huntable1ID, avoidHuntable1);
	rmAddObjectDefConstraint(huntable1ID, avoidNatives);
  
  int huntable2ID=rmCreateObjectDef("huntable 2");
	rmAddObjectDefItem(huntable2ID, huntable2, 6, 6.0);
	rmSetObjectDefCreateHerd(huntable2ID, true);
	rmSetObjectDefMinDistance(huntable2ID, 0.0);
	rmSetObjectDefMaxDistance(huntable2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(huntable2ID, avoidResource);
	rmAddObjectDefConstraint(huntable2ID, mediumPlayerConstraint);
	rmAddObjectDefConstraint(huntable2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(huntable2ID, avoidHuntable2);
	rmAddObjectDefConstraint(huntable2ID, avoidHuntable1);
	rmAddObjectDefConstraint(huntable2ID, avoidNatives);

  int huntable3ID=rmCreateObjectDef("huntable 3");
	rmAddObjectDefItem(huntable3ID, huntable3, 5, 6.0);
	rmSetObjectDefCreateHerd(huntable3ID, true);
	rmSetObjectDefMinDistance(huntable3ID, 0.0);
	rmSetObjectDefMaxDistance(huntable3ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(huntable3ID, avoidResource);
	rmAddObjectDefConstraint(huntable3ID, mediumPlayerConstraint);
	rmAddObjectDefConstraint(huntable3ID, avoidImpassableLand);
  rmAddObjectDefConstraint(huntable3ID, avoidHuntable2);
	rmAddObjectDefConstraint(huntable3ID, avoidHuntable3);

  int centerFoodID=rmCreateObjectDef("dry huntables");
	rmAddObjectDefItem(centerFoodID, huntable1, 8, 6.0);
	rmSetObjectDefCreateHerd(centerFoodID, true);
	rmSetObjectDefMinDistance(centerFoodID, 0.0);
	rmSetObjectDefMaxDistance(centerFoodID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(centerFoodID, avoidResource);
	rmAddObjectDefConstraint(centerFoodID, mediumPlayerConstraint);
	rmAddObjectDefConstraint(centerFoodID, avoidImpassableLand);
	rmAddObjectDefConstraint(centerFoodID, avoidHuntable3);
  rmAddObjectDefConstraint(centerFoodID, avoidHuntable2);
	rmAddObjectDefConstraint(centerFoodID, avoidHuntable1);
  rmAddObjectDefConstraint(centerFoodID, extraFood);
	rmAddObjectDefConstraint(centerFoodID, shortAvoidNatives);
  
  int centerBerriesID=rmCreateObjectDef("wet berries");
	rmAddObjectDefItem(centerBerriesID, "berrybush", 7, 5.0);
	rmSetObjectDefMinDistance(centerBerriesID, 0.0);
	rmSetObjectDefMaxDistance(centerBerriesID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(centerBerriesID, extraFood);
	rmAddObjectDefConstraint(centerBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(centerBerriesID, shortAvoidNatives);
	rmAddObjectDefConstraint(centerBerriesID, avoidTradeRoute);
  rmAddObjectDefConstraint(centerBerriesID, avoidKOTH);
  rmAddObjectDefConstraint(centerBerriesID, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(centerBerriesID, avoidRandomBerries);
  
  int startFoodID=rmCreateObjectDef("starting huntables");
	rmAddObjectDefItem(startFoodID, huntable2, 7, 4.0);
	rmSetObjectDefMinDistance(startFoodID, 12.0);
	rmSetObjectDefMaxDistance(startFoodID, 14.0);
	rmSetObjectDefCreateHerd(startFoodID, true); 
  rmAddObjectDefConstraint(startFoodID, shortAvoidResource);

  int startFood2ID=rmCreateObjectDef("starting huntables2");
	rmAddObjectDefItem(startFood2ID, huntable2, 9, 4.0);
	rmSetObjectDefMinDistance(startFood2ID, 33.0);
	rmSetObjectDefMaxDistance(startFood2ID, 34.0);
	rmSetObjectDefCreateHerd(startFood2ID, true); 
  rmAddObjectDefConstraint(startFood2ID, shortAvoidResource);

	// Objects end

   // Text
   rmSetStatusText("",0.10);
 
   // Vary some terrain
  for (i=0; < 30) {
    int patch=rmCreateArea("first patch "+i);
    rmSetAreaWarnFailure(patch, false);
    rmSetAreaSize(patch, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
    rmSetAreaMix(patch, patchMix);
    rmSetAreaTerrainType(patch, patchType1);
    rmAddAreaTerrainLayer(patch, patchType2, 0, 1);
    rmAddAreaToClass(patch, rmClassID("patch"));
    rmSetAreaCoherence(patch, 0.4);
    rmAddAreaConstraint(patch, avoidTownCenter);
    rmBuildArea(patch); 
  }
 

  // Place Trade Routes
  // north trade route
  int tradeRouteID = rmCreateTradeRoute();
  int socketID=rmCreateObjectDef("north trade route");
  rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 2.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);

  rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.85);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.8);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.96, 0.5);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.2);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.15);

  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
  //  south trade route
  int tradeRoute2ID = rmCreateTradeRoute();
  int socket2ID=rmCreateObjectDef("south trade route");
  rmSetObjectDefTradeRouteID(socket2ID, tradeRoute2ID);

  rmAddObjectDefItem(socket2ID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socket2ID, true);
  rmSetObjectDefMinDistance(socket2ID, 0.0);
  rmSetObjectDefMaxDistance(socket2ID, 8.0);
  
  rmAddTradeRouteWaypoint(tradeRoute2ID, 0.15, 0.15);
  rmAddTradeRouteWaypoint(tradeRoute2ID, 0.15, 0.2);
  rmAddTradeRouteWaypoint(tradeRoute2ID, 0.04, 0.5);
  rmAddTradeRouteWaypoint(tradeRoute2ID, 0.15, 0.8);
  rmAddTradeRouteWaypoint(tradeRoute2ID, 0.15, 0.85);

   placedTradeRoute = rmBuildTradeRoute(tradeRoute2ID, "water");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 
  
  // text
  rmSetStatusText("",0.20);

  // Yellow river
  int yellowRiver1 = rmRiverCreate(-1, riverType, 3, 5, rivermin, rivermax);
  int yellowRiver2 = rmRiverCreate(-1, riverType, 3, 5, rivermin, rivermax);
  int yellowRiver3 = rmRiverCreate(-1, riverType, 3, 5, rivermin+4, rivermax+4);
  int yellowRiver4 = rmRiverCreate(-1, riverType, 3, 5, rivermin, rivermax);
  int yellowRiver5 = rmRiverCreate(-1, riverType, 3, 5, rivermin, rivermax);

  // dry 
  if(whichVersion == 2) {
    
    if (weird == false){
      rmRiverAddWaypoint(yellowRiver1, .0, .75);
      rmRiverAddWaypoint(yellowRiver1, .1, .7);
      rmRiverAddWaypoint(yellowRiver1, .2, .65);
      rmRiverAddWaypoint(yellowRiver1, .25, .55);
      rmRiverAddWaypoint(yellowRiver1, .3, .45);
      rmRiverAddWaypoint(yellowRiver1, .4, .4);
      rmRiverAddWaypoint(yellowRiver1, .5, .35);
      rmRiverAddWaypoint(yellowRiver1, .6, .4);
      rmRiverAddWaypoint(yellowRiver1, .7, .45);
      rmRiverAddWaypoint(yellowRiver1, .75, .55);
      rmRiverAddWaypoint(yellowRiver1, .8, .65);
      rmRiverAddWaypoint(yellowRiver1, .9, .7);
      rmRiverAddWaypoint(yellowRiver1, 1.0, .75);
    
      rmRiverSetShallowRadius(yellowRiver1, 5+cNumberNonGaiaPlayers);
      rmRiverAddShallow(yellowRiver1, 0.075);
      rmRiverAddShallow(yellowRiver1, 0.125);
      rmRiverAddShallow(yellowRiver1, 0.2);
      rmRiverAddShallow(yellowRiver1, 0.4);
      rmRiverAddShallow(yellowRiver1, 0.6);
      rmRiverAddShallow(yellowRiver1, 0.8);
      rmRiverAddShallow(yellowRiver1, 0.9);
      rmRiverAddShallow(yellowRiver1, 0.925);
      
      rmRiverBuild(yellowRiver1);
      
      rmRiverAddWaypoint(yellowRiver2, .0, .25);
      rmRiverAddWaypoint(yellowRiver2, .1, .3);
      rmRiverAddWaypoint(yellowRiver2, .2, .35);
      rmRiverAddWaypoint(yellowRiver2, .25, .45);
      rmRiverAddWaypoint(yellowRiver2, .3, .55);
      rmRiverAddWaypoint(yellowRiver2, .4, .6);
      rmRiverAddWaypoint(yellowRiver2, .5, .65);
      rmRiverAddWaypoint(yellowRiver2, .6, .6);
      rmRiverAddWaypoint(yellowRiver2, .7, .55);
      rmRiverAddWaypoint(yellowRiver2, .75, .45);
      rmRiverAddWaypoint(yellowRiver2, .8, .35);
      rmRiverAddWaypoint(yellowRiver2, .9, .3);
      rmRiverAddWaypoint(yellowRiver2, 1.0, .25);
      
      rmRiverSetShallowRadius(yellowRiver2, 5+cNumberNonGaiaPlayers);
      rmRiverAddShallow(yellowRiver2, 0.075);
      rmRiverAddShallow(yellowRiver2, 0.125);
      rmRiverAddShallow(yellowRiver2, 0.2);
      rmRiverAddShallow(yellowRiver2, 0.4);
      rmRiverAddShallow(yellowRiver2, 0.6);
      rmRiverAddShallow(yellowRiver2, 0.8);
      rmRiverAddShallow(yellowRiver2, 0.9);
      rmRiverAddShallow(yellowRiver2, 0.925);
          
      rmRiverBuild(yellowRiver2);
    }
    
    // FFA and imbalanced teams
    else {
      rmRiverAddWaypoint(yellowRiver1, .33, .5);
      rmRiverAddWaypoint(yellowRiver1, .4, .4);
      rmRiverAddWaypoint(yellowRiver1, .5, .35);
      rmRiverAddWaypoint(yellowRiver1, .6, .4);
      rmRiverAddWaypoint(yellowRiver1, .7, .45);
      rmRiverAddWaypoint(yellowRiver1, .75, .55);
      rmRiverAddWaypoint(yellowRiver1, .8, .65);
      rmRiverAddWaypoint(yellowRiver1, .9, .7);
      rmRiverAddWaypoint(yellowRiver1, 1.0, .75);
      
      rmRiverSetShallowRadius(yellowRiver1, 5+cNumberNonGaiaPlayers);
      rmRiverAddShallow(yellowRiver1, 0.15);
      rmRiverAddShallow(yellowRiver1, 0.4);
      rmRiverAddShallow(yellowRiver1, 0.7);
      
      rmRiverBuild(yellowRiver1);

      rmRiverAddWaypoint(yellowRiver2, .33, .5);
      rmRiverAddWaypoint(yellowRiver2, .4, .6);
      rmRiverAddWaypoint(yellowRiver2, .5, .65);
      rmRiverAddWaypoint(yellowRiver2, .6, .6);
      rmRiverAddWaypoint(yellowRiver2, .7, .55);
      rmRiverAddWaypoint(yellowRiver2, .75, .45);
      rmRiverAddWaypoint(yellowRiver2, .8, .35);
      rmRiverAddWaypoint(yellowRiver2, .9, .3);
      rmRiverAddWaypoint(yellowRiver2, 1.0, .25);
      
      rmRiverSetShallowRadius(yellowRiver2, 5+cNumberNonGaiaPlayers);
      rmRiverAddShallow(yellowRiver2, 0.15);
      rmRiverAddShallow(yellowRiver2, 0.4);
      rmRiverAddShallow(yellowRiver2, 0.7);
          
      rmRiverBuild(yellowRiver2);
    }
  }
  
  //  wet
  else {

    rmRiverSetBankNoiseParams(yellowRiver1, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    rmRiverSetBankNoiseParams(yellowRiver2, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    rmRiverSetBankNoiseParams(yellowRiver3, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    rmRiverSetBankNoiseParams(yellowRiver4, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    rmRiverSetBankNoiseParams(yellowRiver5, 0.07, 2, 15.0, 15.0, 0.667, 1.8);
    
    if (weird == false) {
      rmRiverAddWaypoint(yellowRiver1, .4, .5);
      rmRiverAddWaypoint(yellowRiver1, .0, .75);
      rmRiverSetShallowRadius(yellowRiver1, 13+cNumberNonGaiaPlayers*2);
      rmRiverAddShallow(yellowRiver1, 0.6);
      rmRiverBuild(yellowRiver1);
      
      rmRiverConnectRiver(yellowRiver2, yellowRiver1, 0.1, 0.0, 0.25);
      rmRiverSetShallowRadius(yellowRiver2, 13+cNumberNonGaiaPlayers*2);
      rmRiverAddShallow(yellowRiver2, 0.4);
      rmRiverBuild(yellowRiver2);
    }
    
    else {
      yellowRiver1 = rmRiverCreate(-1, riverType, 6, 20, 7, 8);
      rmRiverAddWaypoint(yellowRiver1, .4, .5);
      rmRiverAddWaypoint(yellowRiver1, .33, .5);
      rmRiverBuild(yellowRiver1);
    }
    
    rmRiverConnectRiver(yellowRiver3, yellowRiver1, 0.0, 0.6, 0.5);
    rmRiverBuild(yellowRiver3);
    
    rmRiverConnectRiver(yellowRiver4, yellowRiver3, 0.1, 1.0, 0.75);
    rmRiverSetShallowRadius(yellowRiver4, 13+cNumberNonGaiaPlayers*2);
    rmRiverAddShallow(yellowRiver4, 0.35-(.0025*cNumberNonGaiaPlayers));
    rmRiverBuild(yellowRiver4);
    
    rmRiverConnectRiver(yellowRiver5, yellowRiver4, 0.99, 1.0, 0.25);
    rmRiverSetShallowRadius(yellowRiver5, 13+cNumberNonGaiaPlayers*2);
    rmRiverAddShallow(yellowRiver5, 0.35-(.0025*cNumberNonGaiaPlayers));
    rmRiverBuild(yellowRiver5);
  }

  
  // Place TR Sockets
  // north trade route
  
  vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.05);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, .95);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
	// add the sockets along the trade route.
  socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.05);
  rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc);

  if (weird == false) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.5);
    rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc);
  }
  
  else if(cNumberNonGaiaPlayers > 3) {
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.35);
    rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc);
    
    socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, 0.65);
    rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc);
  }
  
  socketLoc = rmGetTradeRouteWayPoint(tradeRoute2ID, .95);
  rmPlaceObjectDefAtPoint(socket2ID, 0, socketLoc);
  
    // text
  rmSetStatusText("",0.30);
  
  // paint the trade route river crossings so they don't look too silly
  // Paint the NW and SW in non-weird games
  
  if(weird == false) {
    int crossing1=rmCreateArea("grassy area on nw crossing");
    rmSetAreaSize(crossing1, .03, .03);
    rmSetAreaLocation(crossing1, .065, .68);
    rmSetAreaWarnFailure(crossing1, true);
    rmSetAreaSmoothDistance(crossing1, 10);
    rmSetAreaCoherence(crossing1, .8);
    rmSetAreaMix(crossing1, "yellow_river_b");
    rmBuildArea(crossing1);
    
    int crossing2=rmCreateArea("grassy area on sw crossing");
    rmSetAreaSize(crossing2, .03, .03);
    rmSetAreaLocation(crossing2, .065, .3);
    rmSetAreaWarnFailure(crossing2, true);
    rmSetAreaSmoothDistance(crossing2, 10);
    rmSetAreaCoherence(crossing2, .8);
    rmSetAreaMix(crossing2, "yellow_river_b");
    rmBuildArea(crossing2);
  }
  
  // always paint the NE and SE crossings
  int crossing3=rmCreateArea("grassy area on ne crossing");
  rmSetAreaSize(crossing3, .03, .03);
  rmSetAreaLocation(crossing3, .875, .68);
  rmSetAreaWarnFailure(crossing3, true);
  rmSetAreaSmoothDistance(crossing3, 10);
  rmSetAreaCoherence(crossing3, .8);
  rmSetAreaMix(crossing3, "yellow_river_b");
  rmBuildArea(crossing3);
  
  int crossing4=rmCreateArea("grassy area on se crossing");
  rmSetAreaSize(crossing4, .03, .03);
  rmSetAreaLocation(crossing4, .875, .3);
  rmSetAreaWarnFailure(crossing4, true);
  rmSetAreaSmoothDistance(crossing4, 10);
  rmSetAreaCoherence(crossing4, .8);
  rmSetAreaMix(crossing4, "yellow_river_b");
  rmBuildArea(crossing4);
  
  // Players

	float OneVOnePlacement=rmRandFloat(0, 1);
  int nativeALocation = 1;
  int nativeBLocation = 1;
  
  //OneVOnePlacement = .75;//debug
  rmEchoInfo("1v1 placement="+OneVOnePlacement);
 
	if ( weird == false ) {
    // TEAM ONE PLACEMENT RULES
    if (teamZeroCount == 1) {	
      rmSetPlacementTeam(0);
      if (OneVOnePlacement > 0.33) {
        rmPlacePlayersLine(0.30, 0.80, 0.35, 0.80, 0, 0.05);
        nativeALocation = 2;
      }
      else {
        rmPlacePlayersLine(0.70, 0.80, 0.75, 0.80, 0, 0.05);
        nativeALocation = 3;
      }
    }
    else if (teamZeroCount >= 2 ) {	
      rmSetPlacementTeam(0);
      rmPlacePlayersLine(0.30, 0.80, 0.70, 0.80, 0.05, 0.2);
      rmSetTeamSpacingModifier(0.25);
      //rmSetPlacementSection(0.01, 0.25);
    }
    
    // TEAM 2 PLACEMENT RULES
    if (teamOneCount == 1) {
      rmSetPlacementTeam(1);
      if (OneVOnePlacement < 0.66) {
        rmPlacePlayersLine(0.30, 0.2, 0.35, 0.2, 0, 0.05);
        nativeBLocation = 2;
      }
      else {
        rmPlacePlayersLine(0.70, 0.2, 0.75, 0.2, 0, 0.05);
        nativeBLocation = 3;
      }
    }
    else if (teamOneCount >= 2 ) {
      rmSetPlacementTeam(1);
      rmPlacePlayersLine(0.30, 0.2, 0.70, 0.2, 0.1, 0.2);
    }
	}
  
  // map doesn't like square placement with 3 players - third guy tended to get clobbered
	else if(cNumberNonGaiaPlayers == 3) {
    rmPlacePlayer(1, .6, .8);
    rmPlacePlayer(2, .6, .2);
    rmPlacePlayer(3, .2, .5);
  }
  
  else {
		rmSetTeamSpacingModifier(0.65);
    rmSetPlacementSection(0.75, 0.5);
		rmPlacePlayersSquare(0.28, 0.00, 0.00);
	}

  if (teamOneCount + teamZeroCount >= 7) {
    nativeALocation = 5;
    nativeBLocation = 5;
  }
  
  else if(teamOneCount + teamZeroCount >= 5) {
    nativeALocation = 4;
    nativeBLocation = 4;
  }    
  
  float playerFraction=rmAreaTilesToFraction(100);//300
  for(i=1; <cNumberPlayers) {
    // Create the area.
    int id=rmCreateArea("Player"+i);
    // Assign to the player.
    rmSetPlayerArea(i, id);
    // Set the size.
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmAddAreaConstraint(id, avoidImpassableLand);
    rmAddAreaConstraint(id, avoidTradeRouteSockets);
    rmAddAreaConstraint(id, avoidTradeRoute);
    rmAddAreaConstraint(id, avoidWater6);
    rmSetAreaCoherence(id, 1.0);
    rmSetAreaLocPlayer(id, i);
	rmSetAreaTerrainType(id, playerTerrain);
    rmAddAreaTerrainLayer(id, playerTerrain1, 0, 1);
    //rmSetAreaLocPlayer(id, i);
    rmSetAreaWarnFailure(id, false);
  }
  
	// Build the areas.
  rmBuildAllAreas();

  // setup some invisible areas to aid in native placement on islands
  int northIslandID = rmCreateArea("north island");
  rmSetAreaLocation(northIslandID, 0.9, 0.5); 
  rmSetAreaWarnFailure(northIslandID, false);
  rmSetAreaSize(northIslandID, 0.035, 0.035);
  rmSetAreaCoherence(northIslandID, 1.0);
  rmAddAreaConstraint(northIslandID, avoidImpassableLand);
  rmBuildArea(northIslandID);
  
  int southIslandID = rmCreateArea("south island");
  rmSetAreaLocation(southIslandID, 0.1, 0.5); 
  rmSetAreaWarnFailure(southIslandID, false);
  rmSetAreaSize(southIslandID, 0.035, 0.035);
  rmSetAreaCoherence(southIslandID, 1.0);
  rmAddAreaConstraint(southIslandID, avoidImpassableLand);
  rmBuildArea(southIslandID);
  
  int dryIslandID = rmCreateArea("dry island");
  rmSetAreaLocation(dryIslandID, 0.5, 0.5); 
  rmSetAreaWarnFailure(dryIslandID, false);
  rmSetAreaSize(dryIslandID, 0.01, 0.01);
  rmSetAreaCoherence(dryIslandID, 1.0);
  rmAddAreaConstraint(dryIslandID, avoidImpassableLand);
  rmBuildArea(dryIslandID);
  
  int topIslandID = rmCreateArea("top island");
  rmSetAreaLocation(topIslandID, 0.5, 0.8); 
  rmSetAreaWarnFailure(topIslandID, false);
  rmSetAreaSize(topIslandID, 0.5, 0.5);
  rmSetAreaCoherence(topIslandID, 1.0);
  rmAddAreaConstraint(topIslandID, avoidImpassableLand);
  rmAddAreaConstraint(topIslandID, topConstraint);  
  rmBuildArea(topIslandID);
  
  int bottomIslandID = rmCreateArea("bottom island");
  rmSetAreaLocation(bottomIslandID, 0.5, 0.2); 
  rmSetAreaWarnFailure(bottomIslandID, false);
  rmSetAreaSize(bottomIslandID, 0.5, 0.5);
  rmSetAreaCoherence(bottomIslandID, 1.0);
  rmAddAreaConstraint(bottomIslandID, avoidImpassableLand);
  rmAddAreaConstraint(bottomIslandID, bottomConstraint);  
  rmBuildArea(bottomIslandID);
  
  // natives - some weird placement for ffa and unbalanced games for fairness' sake
  if (subCiv0 == rmGetCivID(nativeOne)) {  
    int nativeVillage1Type = rmRandInt(1,5);
    int nativeVillage1ID = rmCreateGrouping("native village 1", "native " +nativeOne+ " temple YR 0"+nativeVillage1Type);
    rmSetGroupingMinDistance(nativeVillage1ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage1ID, 10.0);
    rmAddGroupingToClass(nativeVillage1ID, rmClassID("natives"));
    rmAddGroupingConstraint(nativeVillage1ID, avoidImpassableLand);
    rmAddGroupingConstraint(nativeVillage1ID, avoidWater);
    rmAddGroupingConstraint(nativeVillage1ID, avoidTradeRoute);
    rmAddGroupingConstraint(nativeVillage1ID, avoidTradeRouteSockets);
    
    if (cNumberNonGaiaPlayers == 2)
    {
        rmPlaceGroupingAtLoc(nativeVillage1ID, 0, .5, .9);
    }
    else
    {
      if(weird && cNumberNonGaiaPlayers > 3) {
        rmPlaceGroupingAtLoc(nativeVillage1ID, 0, .5, .93);
      }
      else if(weird){
        rmPlaceGroupingAtLoc(nativeVillage1ID, 0, .35, .75);
      }
      else {
        rmPlaceGroupingInArea(nativeVillage1ID, 0, southIslandID, 1); 
      }
    }
  }	

  if (subCiv1 == rmGetCivID(nativeTwo)) {  
    int nativeVillage2Type = rmRandInt(1,5);
    int nativeVillage2ID = rmCreateGrouping("native village 2", "native " +nativeOne+ " temple YR 0"+nativeVillage1Type);
    rmSetGroupingMinDistance(nativeVillage2ID, 0.0);
    rmSetGroupingMaxDistance(nativeVillage2ID, 10.0);
    rmAddGroupingToClass(nativeVillage2ID, rmClassID("natives"));
    rmAddGroupingConstraint(nativeVillage2ID, avoidImpassableLand);
    rmAddGroupingConstraint(nativeVillage2ID, avoidWater);
    rmAddGroupingConstraint(nativeVillage2ID, avoidTradeRoute);
    rmAddGroupingConstraint(nativeVillage2ID, avoidTradeRouteSockets);

    if (cNumberNonGaiaPlayers == 2)
    {
        rmPlaceGroupingAtLoc(nativeVillage2ID, 0, .5, .1);
    }
    else
    {    
      if(weird && cNumberNonGaiaPlayers > 3) {
        rmPlaceGroupingAtLoc(nativeVillage2ID, 0, .5, .07);
      }
      else if(weird){
        rmPlaceGroupingAtLoc(nativeVillage1ID, 0, .35, .25);
      }
      else {
        rmPlaceGroupingInArea(nativeVillage2ID, 0, northIslandID, 1);     
      }
    }
  }   
  
  // random native on middle island for dry version
  if(whichVersion == 2) {
    int randomNativeType = rmRandInt(1,5);
    int randomNativeID = 0;
    int whichNative = rmRandInt(1,2);
    if(whichNative == 1)
      randomNativeID = rmCreateGrouping("random village 1a", "native " +nativeOne+ " temple YR 0"+randomNativeType);
    else
      randomNativeID = rmCreateGrouping("random village 1b", "native " +nativeTwo+ " temple YR 0"+randomNativeType);
    rmSetGroupingMinDistance(randomNativeID, 0.0);
    rmSetGroupingMaxDistance(randomNativeID, 10.0);
    rmAddGroupingConstraint(randomNativeID, avoidImpassableLand);
    rmAddGroupingConstraint(randomNativeID, avoidWater6);
    rmAddGroupingToClass(randomNativeID, rmClassID("natives"));
    rmPlaceGroupingInArea(randomNativeID, 0, dryIslandID, 1); 
  }
  
  // Some extra natives on the mainland in wet versions
  else {
    int randomNative1Type = rmRandInt(1,5);
    int randomNative1ID = 0;
    int whichNative1 = rmRandInt(1,2);
    if(whichNative1 == 1)
      randomNative1ID = rmCreateGrouping("random village 1a", "native " +nativeOne+ " temple YR 0"+randomNative1Type);
    else
      randomNative1ID = rmCreateGrouping("random village 1b", "native " +nativeTwo+ " temple YR 0"+randomNative1Type);
    rmSetGroupingMinDistance(randomNative1ID, 0.0);
    rmSetGroupingMaxDistance(randomNative1ID, 10.0);
    rmAddGroupingConstraint(randomNative1ID, avoidImpassableLand);
    rmAddGroupingConstraint(randomNative1ID, avoidWater6);
    rmAddGroupingToClass(randomNative1ID, rmClassID("natives"));
    
    if(nativeALocation == 5) {
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .35, .92);
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .5, .08);
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .65, .92);
    }
    
    else if(nativeALocation == 4) {
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .4, .92);
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .6, .08);
    }
    
    else if (nativeALocation == 3) { 
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .35, .8);
    }
    
    else if (nativeALocation == 2) {
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .65, .8);
    }
    
    else if(weird && cNumberNonGaiaPlayers < 4){
    }
    
    else
      rmPlaceGroupingAtLoc(randomNative1ID, 0, .5, .92);

    int randomNative2Type = rmRandInt(1,5);
    int randomNative2ID = 0;
    if(whichNative == 2)
      randomNative2ID = rmCreateGrouping("random village 2a", "native " +nativeOne+ " temple YR 0"+randomNative2Type);
    else
      randomNative2ID = rmCreateGrouping("random village 2b", "native " +nativeTwo+ " temple YR 0"+randomNative2Type);
    rmSetGroupingMinDistance(randomNative2ID, 0.0);
    rmSetGroupingMaxDistance(randomNative2ID, 10.0);
    rmAddGroupingConstraint(randomNative2ID, avoidImpassableLand);
    rmAddGroupingConstraint(randomNative2ID, avoidWater6);
    rmAddGroupingToClass(randomNative2ID, rmClassID("natives"));
    
    if(nativeBLocation == 5) {
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .35, .08);
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .5, .92);
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .65, .08);
    }
    
    else if(nativeBLocation == 4) {
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .4, .08);
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .6, .92);
    }
    
    else if (nativeBLocation == 3) { 
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .35, .2);
    }
    
    else if (nativeBLocation == 2) {
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .65, .2);
    }
    
    else if(weird && cNumberNonGaiaPlayers < 4) {
    }

    else 
      rmPlaceGroupingAtLoc(randomNative2ID, 0, .5, .08);
  }
  
  // text
  rmSetStatusText("",0.40);
  
   // starting resources
  int TCfloat = -1;
	if (rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
		TCfloat = 0;
	else 
		TCfloat = 10;

  int startingTCID= rmCreateObjectDef("startingTC");
  
	if (rmGetNomadStart()){
    rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
  }
  else	{
    rmAddObjectDefItem(startingTCID, "townCenter", 1, 0.0);
  }
    
	rmSetObjectDefMinDistance(startingTCID, 0);
	rmSetObjectDefMaxDistance(startingTCID, TCfloat);
	rmAddObjectDefConstraint(startingTCID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingTCID, shortAvoidTradeRoute);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(startingTCID, avoidWater6);
  rmAddObjectDefConstraint(startingTCID, avoidNatives);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));

  int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 2, 2.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 16);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 19);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);

  int StartAreaTree2ID=rmCreateObjectDef("starting trees2");
	rmAddObjectDefItem(StartAreaTree2ID, startTreeType, 12, 6.0);
	rmSetObjectDefMinDistance(StartAreaTree2ID, 25);
	rmSetObjectDefMaxDistance(StartAreaTree2ID, 30);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTree2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidNatives);

int avoidStartingGold_dk =rmCreateTypeDistanceConstraint("starting berries avoid starting coin dk", "Mine", 16.0);

	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 4, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 16);
	rmSetObjectDefMaxDistance(StartBerriesID, 16);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidResource);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartingGold_dk);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, avoidNatives);
	rmAddObjectDefConstraint(StartBerriesID, avoidTradeRoute);
  
  // Text
	rmSetStatusText("",0.60);

  int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmAddObjectDefConstraint(startSilverID, shortAvoidTradeRoute);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 12.0);
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);
  rmAddObjectDefConstraint(startSilverID, avoidNatives);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
  rmSetObjectDefMaxDistance(startingUnits, 10.0);
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidResource);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);
	rmAddObjectDefConstraint(startingUnits, avoidWater);
  
  int playerCrateID=rmCreateObjectDef("bonus starting crates");
  rmAddObjectDefItem(playerCrateID, "crateOfFood", 2, 4.0);
  rmAddObjectDefItem(playerCrateID, "crateOfWood", 1, 0.0);
  rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 0.0);
  rmSetObjectDefMinDistance(playerCrateID, 6);
  rmSetObjectDefMaxDistance(playerCrateID, 10);
	rmAddObjectDefConstraint(playerCrateID, avoidAll);
  rmAddObjectDefConstraint(playerCrateID, shortAvoidImpassableLand);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 22.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 25.0);
  rmAddObjectDefConstraint(playerNuggetID, avoidAll);
  rmAddObjectDefConstraint(playerNuggetID, shortAvoidImpassableLand);

	int waterSpawnPointID = 0;
	rmClearClosestPointConstraints();

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.0;
    float yLoc = 0.0;
    float walk = 0.0;
    
    if(whichVersion == 2) {
      xLoc = 0.5;
      yLoc = 0.5;
      walk = 0.075;
      
      if(cNumberTeams > 2)
        xLoc = .5;
      
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
      rmEchoInfo("XLOC = "+xLoc);
      rmEchoInfo("XLOC = "+yLoc);
    }
    
    else {
      xLoc = 0.5;
      yLoc = 0.5;
      walk = 0.0;
      
      if(cNumberTeams > 2)
        xLoc = .5;
      
      ypKingsHillLandfill(xLoc, yLoc, .005, 2.5, baseMix, hillLand);
      ypKingsHillPlacer(xLoc, yLoc, walk, 0);
      rmEchoInfo("XLOC = "+xLoc);
      rmEchoInfo("XLOC = "+yLoc);
    }
  }

	for(i=1; < cNumberPlayers) {
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));

    rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Wet crates
    if (rmGetNomadStart() == false && whichVersion == 1)
			rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));

    rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(startFoodID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(startFood2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartBerriesID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    if (whichVersion == 1) {
      // HC Water Spawns when wet
      waterSpawnPointID=rmCreateObjectDef("colony ship "+i);
      rmAddObjectDefItem(waterSpawnPointID, "HomeCityWaterSpawnFlag", 1, 10.0);
      rmAddClosestPointConstraint(flagVsFlag);
      rmAddClosestPointConstraint(flagLand);
      rmAddClosestPointConstraint(flagEdgeConstraint);
      vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));
      rmPlaceObjectDefAtLoc(waterSpawnPointID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
      
      rmClearClosestPointConstraints();
    }
  }
	
	// Text
	rmSetStatusText("",0.80);

	// Silver
if(cNumberNonGaiaPlayers>2){
	int silver1ID = rmCreateObjectDef("silver mines top");
	rmAddObjectDefItem(silver1ID, "mine", 1, 0.0);
	rmSetObjectDefMinDistance(silver1ID, 0.0);
	rmSetObjectDefMaxDistance(silver1ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(silver1ID, shortAvoidNatives);
	rmAddObjectDefConstraint(silver1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(silver1ID, avoidSilver);
	rmAddObjectDefConstraint(silver1ID, playerConstraint);
	rmAddObjectDefConstraint(silver1ID, avoidWater4);
  rmAddObjectDefConstraint(silver1ID, avoidKOTH);
	rmAddObjectDefConstraint(silver1ID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silver1ID, topConstraint);
	rmAddObjectDefConstraint(silver1ID, avoidTradeRouteSockets);
	rmPlaceObjectDefPerPlayer(silver1ID, false, 2);
  
  int silver2ID = rmCreateObjectDef("silver mines bottom");
  rmAddObjectDefItem(silver2ID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silver2ID, 0.0);
  rmSetObjectDefMaxDistance(silver2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silver2ID, shortAvoidNatives);
  rmAddObjectDefConstraint(silver2ID, avoidImpassableLand);
  rmAddObjectDefConstraint(silver2ID, avoidSilver);
  rmAddObjectDefConstraint(silver2ID, playerConstraint);
  rmAddObjectDefConstraint(silver2ID, avoidWater4);
  rmAddObjectDefConstraint(silver2ID, avoidKOTH);
  rmAddObjectDefConstraint(silver2ID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silver2ID, bottomConstraint);
  rmAddObjectDefConstraint(silver2ID, avoidTradeRouteSockets);
	rmPlaceObjectDefPerPlayer(silver2ID, false, 2);
   
  int silver3ID = rmCreateObjectDef("silver mines middle");
  rmAddObjectDefItem(silver3ID, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silver3ID, 0.0);
  rmSetObjectDefMaxDistance(silver3ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silver3ID, shortAvoidNatives);
  rmAddObjectDefConstraint(silver3ID, avoidImpassableLand);
  rmAddObjectDefConstraint(silver3ID, avoidSilver);
  rmAddObjectDefConstraint(silver3ID, playerConstraint);
  rmAddObjectDefConstraint(silver3ID, avoidWater4);
  rmAddObjectDefConstraint(silver3ID, avoidKOTH);
  rmAddObjectDefConstraint(silver3ID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silver3ID, middleConstraint);
  rmAddObjectDefConstraint(silver3ID, avoidTradeRouteSockets);
  rmPlaceObjectDefPerPlayer(silver3ID, false, 2);
}else{
//1v1 mines
    int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 1.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, 18);
    rmAddObjectDefConstraint(topMine, avoidSocket2_dk);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall_dk);
    rmAddObjectDefConstraint(topMine, forestConstraintShort_dk);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar_dk);
    rmAddObjectDefConstraint(topMine, circleConstraint2_dk);       
    rmAddObjectDefConstraint(topMine, avoidAll_dk); 
    rmAddObjectDefConstraint(topMine, avoidWater5_dk); 
    
    //mines when we have a central island
    if(whichVersion==2){
         //center square mines    
        rmPlaceObjectDefAtLoc(topMine, 0, 0.72, 0.68, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.28, 0.68, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.28, 0.32, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.72, 0.32, 1);
    
        if(OneVOnePlacement<.33){
            //top right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.43, 0.85, 1);
            //bottom right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.57, 0.15, 1);
        }else if(OneVOnePlacement<.66){
            //top right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.57, 0.85, 1);
            //bottom right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.57, 0.15, 1);
        }else{
            //top right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.57, 0.85, 1);
            //bottom left
            rmPlaceObjectDefAtLoc(topMine, 0, 0.43, 0.15, 1);       
        }  
    }else{
        //no central island
        if(OneVOnePlacement<.33){
            //top left
            rmPlaceObjectDefAtLoc(topMine, 0, 0.44, 0.91, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.48, 0.68, 1);
            //bot right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.56, 0.09, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.52, 0.32, 1);
        }else if(OneVOnePlacement<.66){
            //top right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.56, 0.91, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.52, 0.68, 1);
            //bot right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.56, 0.09, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.52, 0.32, 1);
        }else{
            //top right
            rmPlaceObjectDefAtLoc(topMine, 0, 0.56, 0.91, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.52, 0.68, 1);
            //bot left
            rmPlaceObjectDefAtLoc(topMine, 0, 0.44, 0.09, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.48, 0.32, 1);
        } 
            //square mines
            rmPlaceObjectDefAtLoc(topMine, 0, 0.25, 0.75, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.75, 0.25, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.75, 0.75, 1);
            rmPlaceObjectDefAtLoc(topMine, 0, 0.25, 0.25, 1);        
    }
    
    //right side
    rmPlaceObjectDefAtLoc(topMine, 0, 0.85, 0.5, 1);
    //left side
    rmPlaceObjectDefAtLoc(topMine, 0, 0.15, 0.5, 1);
    
    //mines when we have a central island
    if(whichVersion==2){
        //center mine
        rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.5, 1);
    }
}    
  // Text
	rmSetStatusText("",0.85);
  
if(cNumberNonGaiaPlayers==2){    
    //1v1 hunts
    int mapHunts = rmCreateObjectDef("mapHunts");
    rmAddObjectDefItem(mapHunts, "ypSerow", 8, 6.0);
    rmSetObjectDefCreateHerd(mapHunts, true);
    rmSetObjectDefMinDistance(mapHunts, 0);
    if(whichVersion==1){
        rmSetObjectDefMaxDistance(mapHunts, 22);
    }else{
        rmSetObjectDefMaxDistance(mapHunts, 14);
    }
    rmAddObjectDefConstraint(mapHunts, forestConstraintShort_dk);	
    rmAddObjectDefConstraint(mapHunts, avoidHunt2_dk);
    rmAddObjectDefConstraint(mapHunts, avoidAll_dk);       
    rmAddObjectDefConstraint(mapHunts, circleConstraint2_dk);   
    rmAddObjectDefConstraint(mapHunts, avoidWater5_dk); 

    int mapPolo = rmCreateObjectDef("mapPolo");
    rmAddObjectDefItem(mapPolo, "ypMarcoPoloSheep", 8, 6.0);
    rmSetObjectDefCreateHerd(mapPolo, true);
    rmSetObjectDefMinDistance(mapPolo, 0);
    rmSetObjectDefMaxDistance(mapPolo, 16);
    rmAddObjectDefConstraint(mapPolo, forestConstraintShort_dk);	
    rmAddObjectDefConstraint(mapPolo, avoidHunt2_dk);
    rmAddObjectDefConstraint(mapPolo, avoidAll_dk);       
    rmAddObjectDefConstraint(mapPolo, circleConstraint2_dk);   
    rmAddObjectDefConstraint(mapPolo, avoidWater5_dk);     
    
    int mapIbex = rmCreateObjectDef("mapIbex");
    rmAddObjectDefItem(mapIbex, "ypIbex", 8, 6.0);
    rmSetObjectDefCreateHerd(mapIbex, true);
    rmSetObjectDefMinDistance(mapIbex, 0);
    rmSetObjectDefMaxDistance(mapIbex, 16);
    rmAddObjectDefConstraint(mapIbex, forestConstraintShort_dk);	
    rmAddObjectDefConstraint(mapIbex, avoidHunt3_dk);
    rmAddObjectDefConstraint(mapIbex, avoidAll_dk);       
    rmAddObjectDefConstraint(mapIbex, circleConstraint2_dk);   
    rmAddObjectDefConstraint(mapIbex, avoidWater5_dk);
    
    int islandHunts = rmCreateObjectDef("islandHunts");
    rmAddObjectDefItem(islandHunts, "ypIbex", 8, 7.0);
    rmSetObjectDefCreateHerd(islandHunts, true);
    rmSetObjectDefMinDistance(islandHunts, 0);
    rmSetObjectDefMaxDistance(islandHunts, 18);
    rmAddObjectDefConstraint(islandHunts, forestConstraintShort_dk);	
    rmAddObjectDefConstraint(islandHunts, avoidHunt3_dk);
    rmAddObjectDefConstraint(islandHunts, avoidAll_dk);       
    rmAddObjectDefConstraint(islandHunts, circleConstraint2_dk);   
    rmAddObjectDefConstraint(islandHunts, avoidWater5_dk);
    
    //hunts when we have a central island
    if(whichVersion==2){
        //central island
        if(OneVOnePlacement<.33){
            //top left side
                //serow
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.25, 0.8, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.92, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.47, 0.73, 1);
            //bot right side
                //serow
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.75, 0.2, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.08, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.53, 0.27, 1);
        }else if(OneVOnePlacement<.66){
            //top right side
                //serow
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.75, 0.8, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.92, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.53, 0.73, 1);
            //bot right side
                //serow
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.75, 0.2, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.08, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.53, 0.27, 1);
        }else{
            //top right side
                //serow
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.75, 0.8, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.92, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.53, 0.73, 1);
            //bot left side
                //serow
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.25, 0.2, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.08, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.47, 0.27, 1);
        }
    }else{
        //no central island
        
        if(OneVOnePlacement<.33){
            //top left
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.85, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.67, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.29, 0.86, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.36, 0.7, 1);
            //bot right
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.15, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.33, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.71, 0.14, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.64, 0.3, 1);
        }else if(OneVOnePlacement<.66){
            //top right
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.85, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.67, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.71, 0.86, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.64, 0.7, 1);
            //bot right
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.15, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.33, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.71, 0.14, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.64, 0.3, 1);
        }else{
            //top left
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.85, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.67, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.29, 0.86, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.36, 0.7, 1);
            //bot left
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.15, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.33, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.29, 0.14, 1);
            rmPlaceObjectDefAtLoc(mapHunts, 0, 0.36, 0.3, 1);
        }
    }
    
    int flipPolo = rmRandInt(1,2);
    //flips which side hunt is the marco polo sheep
    if(flipPolo==1){       
        //top right side
            //ibex
        rmPlaceObjectDefAtLoc(mapPolo, 0, 0.85, 0.6, 1);
            //marco polo sheep
        rmPlaceObjectDefAtLoc(mapIbex, 0, 0.85, 0.4, 1);
        
        //bot left side
            //ibex
        rmPlaceObjectDefAtLoc(mapPolo, 0, 0.15, 0.4, 1);
            //marco polo sheep
        rmPlaceObjectDefAtLoc(mapIbex, 0, 0.15, 0.6, 1);
    }else{
        //top right side
            //ibex
        rmPlaceObjectDefAtLoc(mapIbex, 0, 0.85, 0.6, 1);
            //marco polo sheep
        rmPlaceObjectDefAtLoc(mapPolo, 0, 0.85, 0.4, 1);
        
        //bot left side
            //ibex
        rmPlaceObjectDefAtLoc(mapIbex, 0, 0.15, 0.4, 1);
            //marco polo sheep
        rmPlaceObjectDefAtLoc(mapPolo, 0, 0.15, 0.6, 1);
    }
    
    //hunts when we have a central island    
    if(whichVersion==2){
        rmPlaceObjectDefAtLoc(islandHunts, 0, 0.55, 0.5, 1);
        rmPlaceObjectDefAtLoc(islandHunts, 0, 0.45, 0.5, 1);
    }
}
  
// Lumber
  
	int numTries=10*cNumberNonGaiaPlayers;
  
  if (cNumberNonGaiaPlayers > 4)
    numTries = 6 * cNumberNonGaiaPlayers;
  
	int failCount=0;
  
	for (i=0; <numTries)	{   
    int forestID=rmCreateArea("foresta"+i);
    rmSetAreaWarnFailure(forestID, false);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(99), rmAreaTilesToFraction(111));
    rmSetAreaForestType(forestID, forestType1);
    rmAddAreaToClass(forestID, rmClassID("classForest")); 
    rmSetAreaForestDensity(forestID, 0.6);
    rmSetAreaForestClumpiness(forestID, 0.5);
    rmSetAreaForestUnderbrush(forestID, 0.6);
    rmSetAreaCoherence(forestID, 0.4);
    rmAddAreaConstraint(forestID, shortAvoidNatives);
    rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, mediumPlayerConstraint); 
    rmAddAreaConstraint(forestID, avoidResource); 
    rmAddAreaConstraint(forestID, avoidAll);
    rmAddAreaConstraint(forestID, avoidKOTH);
    rmAddAreaConstraint(forestID, avoidMineForest_dk);
    rmAddAreaConstraint(forestID, shortAvoidTradeRouteSockets);
    rmBuildArea(forestID);
  } 
    
  // some smaller groves
  for (i=0; <numTries)	{   
    int forestID2=rmCreateArea("forestb"+i, topIslandID);
    rmSetAreaWarnFailure(forestID2, false);
    rmSetAreaSize(forestID2, rmAreaTilesToFraction(50), rmAreaTilesToFraction(75));
    rmSetAreaForestType(forestID2, forestType2);
    rmAddAreaToClass(forestID2, rmClassID("classForest")); 
    rmSetAreaForestDensity(forestID2, 0.5);
    rmSetAreaForestClumpiness(forestID2, 0.4);		
    rmSetAreaForestUnderbrush(forestID2, 0.6);
    rmSetAreaCoherence(forestID2, 0.4);
    rmAddAreaConstraint(forestID2, shortAvoidNatives);
    rmAddAreaConstraint(forestID2, avoidImpassableLand);
    rmAddAreaConstraint(forestID2, forestConstraintGroves);
    rmAddAreaConstraint(forestID2, playerConstraint); 
    rmAddAreaConstraint(forestID2, avoidAll);
    rmAddAreaConstraint(forestID2, avoidKOTH);
    rmAddAreaConstraint(forestID2, circleConstraint);
    rmAddAreaConstraint(forestID2, avoidTradeRouteSockets);
    rmAddAreaConstraint(forestID2, avoidMineForest_dk);

    rmBuildArea(forestID2);
  } 
    
  // some smaller groves
  for (i=0; <numTries)	{   
    int forestID3=rmCreateArea("forestc"+i, bottomIslandID);
    rmSetAreaWarnFailure(forestID3, false);
    rmSetAreaSize(forestID3, rmAreaTilesToFraction(30), rmAreaTilesToFraction(50));
    rmSetAreaForestType(forestID3, forestType2);
    rmAddAreaToClass(forestID3, rmClassID("classForest")); 
    rmSetAreaForestDensity(forestID3, 0.5);
    rmSetAreaForestClumpiness(forestID3, 0.4);		
    rmSetAreaForestUnderbrush(forestID3, 0.6);
    rmSetAreaCoherence(forestID3, 0.4);
    rmAddAreaConstraint(forestID3, shortAvoidNatives);
    rmAddAreaConstraint(forestID3, avoidImpassableLand);
    rmAddAreaConstraint(forestID3, forestConstraintGroves);
    rmAddAreaConstraint(forestID3, playerConstraint); 
    rmAddAreaConstraint(forestID3, avoidAll);
    rmAddAreaConstraint(forestID3, avoidKOTH);
    rmAddAreaConstraint(forestID3, avoidTradeRouteSockets);
    rmAddAreaConstraint(forestID3, circleConstraint);
    rmAddAreaConstraint(forestID3, avoidMineForest_dk);

    rmBuildArea(forestID3);
  } 
    
  // Misc - Huntables
  if(cNumberNonGaiaPlayers>2){
  // some extra huntables near the water when it's dry or berries when it's wet
  if (whichVersion == 2) 
 	  rmPlaceObjectDefAtLoc(centerFoodID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);    
    
  else
    rmPlaceObjectDefAtLoc(centerBerriesID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers); 
    
	rmPlaceObjectDefAtLoc(huntable1ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(huntable2ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
  rmPlaceObjectDefAtLoc(huntable3ID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
  }
    
	// Text
	rmSetStatusText("",0.90);
  
	// Nuggets

  int nugget1= rmCreateObjectDef("nugget easy"); 
  rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(1, 1);
  rmSetObjectDefMinDistance(nugget1, 0.0);
  rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget1, avoidAll);
  rmAddObjectDefConstraint(nugget1, avoidKOTH);
  rmAddObjectDefConstraint(nugget1, avoidNuggetMedium);
  rmAddObjectDefConstraint(nugget1, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget1, mediumPlayerConstraint);
  rmAddObjectDefConstraint(nugget1, circleConstraint);
  rmPlaceObjectDefPerPlayer(nugget1, false, 3);

  int nugget2= rmCreateObjectDef("nugget medium"); 
  rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(2, 2);
  rmSetObjectDefMinDistance(nugget2, 0.0);
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, avoidAll);
  rmAddObjectDefConstraint(nugget2, avoidKOTH);
  rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget2, playerConstraint);
  rmAddObjectDefConstraint(nugget2, circleConstraint);
  rmPlaceObjectDefPerPlayer(nugget2, false, 2);

  int nugget3= rmCreateObjectDef("nugget hard"); 
  rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(3, 3);
  rmSetObjectDefMinDistance(nugget3, 0.0);
  rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, avoidAll);
  rmAddObjectDefConstraint(nugget3, avoidKOTH);
  rmAddObjectDefConstraint(nugget3, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget3, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget3, circleConstraint);
  rmPlaceObjectDefPerPlayer(nugget3, false, 1);
  
  // Team treasures
  if(cNumberTeams == 2 && cNumberNonGaiaPlayers > 2){
    rmSetNuggetDifficulty(12, 12);
    rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  }

  if (rmRandFloat(0,1) > .5) {
    int nugget4= rmCreateObjectDef("nugget nuts"); 
    rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
    if(cNumberNonGaiaPlayers>2 && rmGetIsTreaty() == false){
        rmSetNuggetDifficulty(4, 4);
    }else{
        rmSetNuggetDifficulty(3, 3);
    }
    rmSetObjectDefMinDistance(nugget4, 0.0);
    rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
    rmAddObjectDefConstraint(nugget4, avoidAll);
    rmAddObjectDefConstraint(nugget4, avoidKOTH);
    rmAddObjectDefConstraint(nugget4, avoidNuggetFar);
    rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
    rmAddObjectDefConstraint(nugget4, playerConstraintNugget);
    rmAddObjectDefConstraint(nugget4, circleConstraint);
    rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, rmRandInt(2,3));
  }
	// Text
  
  if(whichVersion == 1){ 
    int fishID=rmCreateObjectDef("fish 1");
    rmAddObjectDefItem(fishID, fish1, 2, 5.0);
    rmSetObjectDefMinDistance(fishID, 0.0);
    rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(fishID, fishVsFishID);
    rmAddObjectDefConstraint(fishID, fishLand);
    rmPlaceObjectDefAtLoc(fishID, 0, 1.0, 0.5, 4*cNumberNonGaiaPlayers);

    int fish2ID=rmCreateObjectDef("fish 2");
    rmAddObjectDefItem(fish2ID, fish2, 2, 5.0);
    rmSetObjectDefMinDistance(fish2ID, 0.0);
    rmSetObjectDefMaxDistance(fish2ID, rmXFractionToMeters(0.5));
    rmAddObjectDefConstraint(fish2ID, fishVsFish2ID);
    rmAddObjectDefConstraint(fish2ID, fishLand);
    rmPlaceObjectDefAtLoc(fish2ID, 0, 0.0, 0.5, 4*cNumberNonGaiaPlayers);
  }
    
	//River Flow added by Alex Y
	int randomWaterFlowingID=rmCreateObjectDef("random flowing in water");
	rmAddObjectDefItem(randomWaterFlowingID, "RiverFlow", 1, 0);
	rmSetObjectDefMinDistance(randomWaterFlowingID, 0.0);
	rmSetObjectDefMaxDistance(randomWaterFlowingID, rmXFractionToMeters(0.5));
	rmPlaceObjectDefAtLoc(randomWaterFlowingID, 0, 0.5, 0.5, 60*cNumberNonGaiaPlayers); 
	
	// added by Paul Fog on land
	if(whichVersion == 1)
		{ 
		int randomFogID=rmCreateObjectDef("random fog");
		rmAddObjectDefItem(randomFogID, "ypPropsFog", 1, 0);
		rmSetObjectDefMinDistance(randomFogID, 0.0);
		rmSetObjectDefMaxDistance(randomFogID, rmXFractionToMeters(0.5));
		rmPlaceObjectDefAtLoc(randomFogID, 0, 0.5, 0.5, 80*cNumberNonGaiaPlayers);
		}
	
	rmSetStatusText("",0.99);
   
	} 
}  