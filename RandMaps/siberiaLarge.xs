// siberia  LARGE
// AOE3 DE 2019 Updated by Alex Y  
// Durokan's May 7 update for DE
// April 2021 edited by vividlyplain for DE. Updated May 2021.

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);
 
  // initialize map type variables 
  string baseMix = "siberia_grass_snowb";
  string baseTerrain = "yukon\ground8_yuk";
  string paintMix2 = "italy_snow_grass";
  string iceMix = "siberia_ice";
  string iceMix1 = "siberia_ice_b";
  string patchIce = "rockies\groundsnow1_roc";
  string forestType = "Yukon Snow Forest";
  string startTreeType = "TreeYukonSnow";
  string mapType1 = "siberia";
  string mapType2 = "grass";
  string patchMix = "rockies_snow";
  string huntable1 = "ypMuskDeer";
  string huntable2 = "ypSaiga";   
  string lightingType = "siberia_skirmish";
  string tradeRouteType = "water";
  string playerTerrain = "rockies\groundsnow8_roc";
  string patchTerrain = "rockies\groundsnow7_roc";
  string patchType1 = "rockies\groundsnow6_roc";
	string natType1 = "Tengri";
	string natGrpName1 = "native tengri village 0";
	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);

// Map Basics

  bool weird = false;
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
  if (cNumberTeams > 2 || (teamZeroCount - teamOneCount) > 2 || (teamOneCount - teamZeroCount) > 2)
    weird = true;
    
    if(cNumberNonGaiaPlayers==2){
        weird = false;
    }
    
	int playerTiles = 26000;
	if (cNumberNonGaiaPlayers >4)
		playerTiles =25000;
	if (cNumberNonGaiaPlayers >6)
		playerTiles = 24000;
    
  if (weird == true) 
    playerTiles = playerTiles*1.75;

	rmEchoInfo("Player Tiles = "+playerTiles);

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 10, 0.4, 7.0);
	rmSetMapElevationHeightBlend(1);
	
	rmSetSeaLevel(1.0);
	rmSetLightingSet(lightingType);

	rmSetBaseTerrainMix(baseMix);
	rmTerrainInitialize(baseTerrain, 0.0);
	rmEnableLocalWater(false);
	rmSetMapType(mapType1);
	rmSetMapType(mapType2);
	rmSetMapType("land");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);

	chooseMercs();
	
// Classes
	int classPlayer=rmDefineClass("player");
	int classSocket=rmDefineClass("socketClass");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("classIce");
  rmDefineClass("classIcePatch");
  rmDefineClass("classPatch");
	int classNative=rmDefineClass("natives");
	int classIsland=rmDefineClass("island");

// Constraints
    
	// Map edge constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12), 0.01);

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 25.0);
  int longPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players long", classPlayer, 45.0);
  int playerConstraintNugget = rmCreateClassDistanceConstraint("nuggets stay away from players long", classPlayer, 55.0);
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 15.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("short stay away from players", classPlayer, 5.0);

	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 30.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 10.0);
	int shortAvoidResource=rmCreateTypeDistanceConstraint("resource avoid resource short", "resource", 5.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);
	   
	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
  int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);

  // resource avoidance
	int avoidSilver=rmCreateTypeDistanceConstraint("gold avoid gold", "Mine", 60.0);
  int avoidUnderbrush=rmCreateTypeDistanceConstraint("underbrush avoid", "underbrushYukon", 35.0);
	int mediumAvoidSilver=rmCreateTypeDistanceConstraint("medium gold avoid gold", "Mine", 30.0);
	int avoidHuntable1=rmCreateTypeDistanceConstraint("avoid huntable1", huntable1, 60.0);
	int avoidHuntable2=rmCreateTypeDistanceConstraint("avoid huntable2", huntable2, 60.0);
	int avoidNuggets=rmCreateTypeDistanceConstraint("nugget vs. nugget", "AbstractNugget", 20.0);
	int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget vs. nugget far", "AbstractNugget", 60.0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int circleConstraintTwo=rmCreatePieConstraint("circle Constraint 2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 12.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", rmClassID("natives"), 4.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("stuff avoids natives min", rmClassID("natives"), 2.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 8.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 12.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 32.0);
	int avoidPlayer=rmCreateClassDistanceConstraint("avoid player", classIsland, 24.0);

	// Unit avoidance
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), rmXFractionToMeters(0.3));
	int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other short", rmClassID("importantItem"), 7.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 10.0);
																  
	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 7.0);
  int avoidIce = rmCreateClassDistanceConstraint("vs ice", rmClassID("classIce"), 5.0);
  int avoidIcePatch = rmCreateClassDistanceConstraint("vs ice patches", rmClassID("classIcePatch"), 10.0);
  
	// Trade route avoidance.
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeRouteSockets=rmCreateTypeDistanceConstraint("avoid trade route sockets", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketsFar=rmCreateTypeDistanceConstraint("avoid trade route sockets far", "socketTradeRoute", 12.0);
	int avoidMineSockets=rmCreateTypeDistanceConstraint("avoid mine sockets", "mine", 10.0);


// ************************** DEFINE OBJECTS ****************************
	
  int deerID=rmCreateObjectDef("huntable1");
	rmAddObjectDefItem(deerID, huntable1, rmRandInt(10,12), 6.0);
	rmSetObjectDefCreateHerd(deerID, true);
	rmSetObjectDefMinDistance(deerID, 0.0);
	rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(deerID, avoidResource);
	rmAddObjectDefConstraint(deerID, playerConstraint);
	rmAddObjectDefConstraint(deerID, avoidImpassableLand);
	rmAddObjectDefConstraint(deerID, avoidHuntable1);
	rmAddObjectDefConstraint(deerID, avoidHuntable2);
  rmAddObjectDefConstraint(deerID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(deerID, avoidTradeRouteSockets);
  
  int tapirID=rmCreateObjectDef("huntable2");
	rmAddObjectDefItem(tapirID, huntable2, rmRandInt(10,12), 6.0);
	rmSetObjectDefCreateHerd(tapirID, true);
	rmSetObjectDefMinDistance(tapirID, 0.0);
	rmSetObjectDefMaxDistance(tapirID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(tapirID, avoidResource);
	rmAddObjectDefConstraint(tapirID, playerConstraint);
	rmAddObjectDefConstraint(tapirID, avoidImpassableLand);
	rmAddObjectDefConstraint(tapirID, avoidHuntable1);
	rmAddObjectDefConstraint(tapirID, avoidHuntable2);
	rmAddObjectDefConstraint(tapirID, shortAvoidImportantItem);
	rmAddObjectDefConstraint(tapirID, avoidTradeRouteSockets);
  
	// -------------Done defining objects
  // Text
  rmSetStatusText("",0.10);
    
  // Frozen River  
  int IceArea1ID=rmCreateArea("Ice Area 1");
	rmSetAreaSize(IceArea1ID, 0.09, 0.09);
	rmSetAreaLocation(IceArea1ID, 0.0, 0.5);
	//rmSetAreaTerrainType(IceArea1ID, "great_lakes\ground_ice1_gl");
	rmSetAreaMix(IceArea1ID, iceMix);
    //rmAddAreaTerrainLayer(IceArea1ID, patchIce, 0, 2);
  rmAddAreaToClass(IceArea1ID, rmClassID("classIce"));
	rmSetAreaBaseHeight(IceArea1ID, -1.0);
  if (cNumberTeams == 2) 
  {
    rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.5, 1.0, 0.5);
    rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.45, 1.0, 0.45);
    rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.55, 1.0, 0.55);    
  }
  else 
  {
		rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.50, 0.75, 0.50);
		rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.45, 0.75, 0.45);
		rmAddAreaInfluenceSegment(IceArea1ID, 0.0, 0.55, 0.75, 0.55);    	  
  }  
  rmSetAreaObeyWorldCircleConstraint(IceArea1ID, false);
	rmSetAreaCoherence(IceArea1ID, 0.7);
	rmBuildArea(IceArea1ID); 
  /*
  for(i = 0; < rmRandInt(7, 9)) {
    int IceAreaID=rmCreateArea("Ice Area"+i);
    float iceLoc = rmRandFloat(0.15, 0.85);
    float xVar = rmRandFloat(-0.05, 0.05)*3.5;
    float yVar = rmRandFloat(-0.05, 0.05)*3.5;
    rmSetAreaSize(IceAreaID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
    rmSetAreaLocation(IceAreaID, iceLoc, .5);
    //rmSetAreaTerrainType(IceArea1ID, "great_lakes\ground_ice1_gl");
    rmSetAreaMix(IceAreaID, iceMix1);
	//rmAddAreaTerrainLayer(IceAreaID, patchIce, 0, 1);
    //~ rmSetAreaMix(IceAreaID, "mongolia_desert");
    rmAddAreaToClass(IceAreaID, rmClassID("classIce"));
    rmAddAreaToClass(IceAreaID, rmClassID("classIcePatch"));
    rmAddAreaInfluenceSegment(IceAreaID, iceLoc, 0.5, iceLoc+xVar, .5+yVar);
    rmSetAreaObeyWorldCircleConstraint(IceAreaID, false);
    rmAddAreaConstraint(IceAreaID, playerConstraint);
    rmAddAreaConstraint(IceAreaID, avoidIcePatch);
    rmAddAreaConstraint(IceAreaID, avoidTradeRouteSockets);
    rmAddAreaConstraint(IceAreaID, shortAvoidImportantItem);
    rmSetAreaSmoothDistance(IceAreaID, 8);
    rmSetAreaCoherence(IceAreaID, 0.55);
    rmSetAreaWarnFailure(IceAreaID, false);
    rmBuildArea(IceAreaID); 
  }
	*/
  // TRADE ROUTE PLACEMENT
   int tradeRouteID = rmCreateTradeRoute();

   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

  rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
  rmSetObjectDefMinDistance(socketID, 2.0);
  rmSetObjectDefMaxDistance(socketID, 8.0);

  // Southern trade route
  rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 1.0);
  rmAddTradeRouteWaypoint(tradeRouteID, 0.2, 0.0);

  bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "water");
  if(placedTradeRoute == false)
    rmEchoError("Failed to place trade route"); 
  
	// add the sockets along the trade route.
  vector socketLoc  = rmGetTradeRouteWayPoint(tradeRouteID, 0.2);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
      
  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
  
  int tpAreaID=rmCreateArea("TP patch");
	rmSetAreaSize(tpAreaID, 0.005, 0.005);
	rmSetAreaLocation(tpAreaID, 0.2, 0.5);
	rmSetAreaMix(tpAreaID, patchMix);
  rmAddAreaToClass(tpAreaID, rmClassID("classIce"));
	rmSetAreaBaseHeight(tpAreaID, 0.0);
	rmSetAreaCoherence(tpAreaID, 0.7);
	rmBuildArea(tpAreaID); 

  socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
  rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

  if(cNumberNonGaiaPlayers > 5) {
  
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.35);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);  
      
    socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.65);
    rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);        
  }
  
// Players
  
   // Text
   rmSetStatusText("",0.20);
  
   // Players start on either side of the frozen river
  
	float teamStartLoc = rmRandFloat(0.0, 1.0); 

		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.5, 0.8);
					rmPlacePlayer(2, 0.5, 0.2);
				}
				else
				{
					rmPlacePlayer(2, 0.5, 0.8);
					rmPlacePlayer(1, 0.5, 0.2);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
        rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.3, 0.8, 0.7, 0.8, 0.00, 0.20);
          
        rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.3, 0.2, 0.7, 0.2, 0.00, 0.20);
      }
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
        rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.5, 0.8, 0.5, 0.81, 0.00, 0.20);
      
        rmSetPlacementTeam(1); 
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.3, 0.2, 0.7, 0.2, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.3, 0.15, 0.8, 0.3, 0.00, 0.20);
      }
					else // 2v1, 3v1, 4v1, etc.
					{
        rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.5, 0.2, 0.5, 0.21, 0.00, 0.20);
          
        rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.3, 0.8, 0.7, 0.8, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.3, 0.85, 0.8, 0.7, 0.00, 0.20);
      }     
    }
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
        rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.3, 0.8, 0.7, 0.8, 0.00, 0.20);
          
        rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.3, 0.15, 0.80, 0.30, 0.00, 0.20);
      }
					else // 3v2, 4v2, etc.
					{
        rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.3, 0.85, 0.8, 0.7, 0.00, 0.20);
        
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.3, 0.2, 0.7, 0.2, 0.00, 0.20);
          }
          }
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.3, 0.2, 0.7, 0.2, 0.00, 0.20);
          
					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.3, 0.8, 0.7, 0.8, 0.00, 0.20);
        }
      }
    }
		else // FFA
		{
				rmSetPlacementSection(0.925, 0.58);
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.38, 0.38, 0.0);				
    }      
  
  // Set up player areas.
  float playerFraction=rmAreaTilesToFraction(222);
  for(i=1; <cNumberPlayers) {
    int id=rmCreateArea("Player"+i);
    rmSetPlayerArea(i, id);
    rmSetAreaSize(id, playerFraction, playerFraction);
    rmAddAreaToClass(id, classPlayer);
    rmAddAreaConstraint(id, avoidTradeRouteSockets); 
    rmAddAreaConstraint(id, shortAvoidImportantItem); 
    rmAddAreaConstraint(id, playerConstraint); 
    rmAddAreaConstraint(id, playerEdgeConstraint); 
    rmSetAreaCoherence(id, 1.0);
    rmSetAreaLocPlayer(id, i);
	rmSetAreaTerrainType(id, playerTerrain);
	rmAddAreaTerrainLayer(id, patchType1, 0, 1);					 
    rmSetAreaWarnFailure(id, false);
  }

	// ____________________ Natives ____________________
	//Choose Natives
    int subCiv0 = -1;
    subCiv0 = rmGetCivID(natType1);
    rmSetSubCiv(0, natType1);
	
	float xNatLocA = 0.70;
	float yNatLocA = 0.70;
	float xNatLocB = 0.70;
	float yNatLocB = 0.30;

	int natChooser = rmRandInt(1,2);
	
	// Set up Natives	
	int nativeID0 = -1;
  int nativeID1 = -1;
	
		nativeID0 = rmCreateGrouping("native site 1", natGrpName1+whichVillage1);
		nativeID1 = rmCreateGrouping("native site 2", natGrpName1+whichVillage2);

	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));

	// place natives
	rmPlaceGroupingAtLoc(nativeID0, 0, xNatLocA, yNatLocA);
	rmPlaceGroupingAtLoc(nativeID1, 0, xNatLocB, yNatLocB);

	// nat islands
	int natIsle1ID=rmCreateArea("Nat 1 Island");
	rmSetAreaSize(natIsle1ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle1ID, xNatLocA, yNatLocA);
	rmSetAreaMix(natIsle1ID, paintMix2);
	rmAddAreaToClass(natIsle1ID, classIsland);
	rmSetAreaCoherence(natIsle1ID, 0.666);
	rmBuildArea(natIsle1ID); 

	int natIsle2ID=rmCreateArea("Nat 2 Island");
	rmSetAreaSize(natIsle2ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsle2ID, xNatLocB, yNatLocB);
	rmSetAreaMix(natIsle2ID, paintMix2);
	rmAddAreaToClass(natIsle2ID, classIsland);
	rmSetAreaCoherence(natIsle2ID, 0.666);
	rmBuildArea(natIsle2ID); 

	// Build the areas.
   rmBuildAllAreas();

	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	if (cNumberNonGaiaPlayers > 2) 
	{
		rmSetAreaSize(midIslandID, 0.25);
		rmAddAreaInfluenceSegment(midIslandID, 0.3, 0.7, 0.7, 0.7);
		rmAddAreaInfluenceSegment(midIslandID, 0.3, 0.3, 0.7, 0.3);
	}
	else 
		rmSetAreaSize(midIslandID, 0.225);
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
	
  // starting resources
 	int classStartingResource = rmDefineClass("startingResource");
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid starting resource", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("avoid starting resource short", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin  = rmCreateClassDistanceConstraint("avoid starting resource min", rmClassID("startingResource"), 4.0);
		int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.40), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
  int TCfloat = -1;
	if (cNumberTeams == 4)
		TCfloat = 5;
	else 
		TCfloat = 8;

  int startingTCID= rmCreateObjectDef("startingTC");
	if (rmGetNomadStart()) {
			rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
  }
		
  else {
    rmAddObjectDefItem(startingTCID, "townCenter", 1, 0.0);
  }
	rmAddObjectDefToClass(startingTCID, classStartingResource);  
  rmSetObjectDefMinDistance(startingTCID, 0);
	rmSetObjectDefMaxDistance(startingTCID, 0); //TCfloat
//	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
//  rmAddObjectDefConstraint(startingTCID, avoidIce);
	rmAddObjectDefToClass(startingTCID, rmClassID("player"));

  int StartDeerID=rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(StartDeerID, huntable1, 8, 3.0);
	rmSetObjectDefMinDistance(StartDeerID, 10.0);
	rmSetObjectDefMaxDistance(StartDeerID, 13.0);
	rmSetObjectDefCreateHerd(StartDeerID, true);
	rmAddObjectDefToClass(StartDeerID, classStartingResource);  
	rmAddObjectDefConstraint(StartDeerID, avoidStartingResourcesShort);    
//	if (teamZeroCount == teamOneCount)
//		rmAddObjectDefConstraint(StartDeerID, stayMidIsland);    
    
  int StartDeerID2=rmCreateObjectDef("starting herd2");
	rmAddObjectDefItem(StartDeerID2, huntable2, 8, 3.0);
	rmSetObjectDefMinDistance(StartDeerID2, 30.0);
	rmSetObjectDefMaxDistance(StartDeerID2, 30+cNumberNonGaiaPlayers);
	rmSetObjectDefCreateHerd(StartDeerID2, true);
	rmAddObjectDefToClass(StartDeerID2, classStartingResource);  
	if (cNumberTeams == 2)
		rmAddObjectDefConstraint(StartDeerID2, avoidMidIsland);    
	rmAddObjectDefConstraint(StartDeerID2, avoidNativesShort);    
	rmAddObjectDefConstraint(StartDeerID2, avoidStartingResources);    
	if (teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(StartDeerID2, stayNearEdge);    
	
  int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 8, 6.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 18);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18);
	rmAddObjectDefToClass(StartAreaTreeID, classStartingResource);  
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidNativesShort);
  rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRouteSockets);

  int StartAreaTree2ID=rmCreateObjectDef("starting trees2");
	rmAddObjectDefItem(StartAreaTree2ID, startTreeType, 12, 8.0);
	rmSetObjectDefMinDistance(StartAreaTree2ID, 30);
	rmSetObjectDefMaxDistance(StartAreaTree2ID, 36);
	rmAddObjectDefToClass(StartAreaTree2ID, classStartingResource);  
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartAreaTree2ID, shortAvoidImpassableLand);
  rmAddObjectDefConstraint(StartAreaTree2ID, shortAvoidImportantItem);
  rmAddObjectDefConstraint(StartAreaTree2ID, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(StartAreaTree2ID, avoidNativesShort);
  rmAddObjectDefConstraint(StartAreaTree2ID, avoidMidIsland);
  if (teamZeroCount != teamOneCount)
	  rmAddObjectDefConstraint(StartAreaTree2ID, stayNearEdge);
  
   // Text
   rmSetStatusText("",0.30);

  int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(startSilverID, 15.0);
	rmSetObjectDefMaxDistance(startSilverID, 16.0);
	rmAddObjectDefToClass(startSilverID, classStartingResource);  
	rmAddObjectDefConstraint(startSilverID, avoidAll);
	rmAddObjectDefConstraint(startSilverID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
  rmSetObjectDefMaxDistance(startingUnits, 8.0);
	rmAddObjectDefToClass(startingUnits, classStartingResource);  
	rmAddObjectDefConstraint(startingUnits, avoidAll);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

  // Ensure that starting outpost is near the gold
  int startingOutpostAsianID=rmCreateObjectDef("Starting Asian Outpost");
  rmAddObjectDefItem(startingOutpostAsianID, "mine", 1, 0.0);				// changed the spawning logic for Garja - vividlyplain
  rmAddObjectDefItem(startingOutpostAsianID, "ypOutpostAsian", 1, 6.0);		// the tower can still be too close to the TC sometimes tho :(
  rmSetObjectDefMinDistance(startingOutpostAsianID, 20.0);
  rmSetObjectDefMaxDistance(startingOutpostAsianID, 20.0);
  rmAddObjectDefToClass(startingOutpostAsianID, rmClassID("importantItem"));
	rmAddObjectDefToClass(startingOutpostAsianID, classStartingResource);  
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidAll);
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidStartingResourcesMin);
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidNativesShort);
  rmAddObjectDefConstraint(startingOutpostAsianID, avoidIce);
	if (cNumberTeams == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(startingOutpostAsianID, stayMidIsland);
  
  int playerBerryID=rmCreateObjectDef("player berries");
  rmAddObjectDefItem(playerBerryID, "berryBush", 4, 3.0);
  rmSetObjectDefMinDistance(playerBerryID, 12);
  rmSetObjectDefMaxDistance(playerBerryID, 14);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);  
	rmAddObjectDefConstraint(playerBerryID, avoidAll);
  rmAddObjectDefConstraint(playerBerryID, avoidIce);
  rmAddObjectDefConstraint(playerBerryID, avoidStartingResourcesShort);
//	if (teamZeroCount == teamOneCount)
//		rmAddObjectDefConstraint(playerBerryID, stayMidIsland);
  
  int playerNuggetID=rmCreateObjectDef("player nugget");
  rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
  rmSetObjectDefMinDistance(playerNuggetID, 25.0);
  rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);  
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
  rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
  rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
  if (cNumberNonGaiaPlayers == 2)
	  rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);
  
	// Text
	rmSetStatusText("",0.40);

	for(i=1; < cNumberPlayers) {
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    if(rmGetNomadStart() == false) {
      
			// Placing outpost/gold
      if (rmGetPlayerCiv(i) == rmGetCivID("Japanese"))
	  {
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
        rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }
      
      else
        rmPlaceObjectDefAtLoc(startingOutpostAsianID, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
      }
    // nomad silver
    else {
      rmPlaceObjectDefAtLoc(startSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    }
    rmPlaceObjectDefAtLoc(StartDeerID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(StartDeerID2, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
    
    // Place a nugget for the player
    rmSetNuggetDifficulty(1, 1);
    rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
	}

	// Text
	rmSetStatusText("",0.75);

	// Silver
	int silverID = -1;
 	int silverID2 = -1;

  int silverCount = 0;
  if(cNumberNonGaiaPlayers>2){
  silverCount = cNumberNonGaiaPlayers*3;
  
	rmEchoInfo("silver count = "+silverCount);

  silverID2 = rmCreateObjectDef("closer silver mines"+i);
  rmAddObjectDefItem(silverID2, "mine", 1, 0.0);
  rmSetObjectDefMinDistance(silverID2, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(silverID2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(silverID2, avoidImpassableLand);
  rmAddObjectDefConstraint(silverID2, avoidSilver);
  rmAddObjectDefConstraint(silverID2, longPlayerConstraint);
  rmAddObjectDefConstraint(silverID2, avoidIce);
  rmAddObjectDefConstraint(silverID2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(silverID2, avoidNativesShort);
  rmAddObjectDefConstraint(silverID2, avoidTradeRouteSockets);
      rmAddObjectDefConstraint(silverID2, avoidStartingResources);
  rmPlaceObjectDefPerPlayer(silverID2, false, 5);
  } 
// Forests
	int forestTreeID = 0;
	
	int numTries=10*cNumberNonGaiaPlayers; 
	int failCount=0;
	for (i=0; <numTries)	{   
    int forestID=rmCreateArea("forest"+i);
    rmAddAreaToClass(forestID, rmClassID("classForest"));
    rmSetAreaWarnFailure(forestID, false);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(150));
    rmSetAreaForestType(forestID, forestType);
    rmSetAreaForestDensity(forestID, 0.5);
    rmSetAreaForestClumpiness(forestID, 0.3);
    rmSetAreaForestUnderbrush(forestID, 1.0);
    rmSetAreaCoherence(forestID, 0.4);
    rmAddAreaConstraint(forestID, mediumPlayerConstraint);  
    rmAddAreaConstraint(forestID, shortAvoidResource);			
    rmAddAreaConstraint(forestID, shortAvoidTradeRoute);
    rmAddAreaConstraint(forestID, avoidTradeRouteSockets);
    rmAddAreaConstraint(forestID, avoidMineSockets);
    rmAddAreaConstraint(forestID, avoidIce);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, shortAvoidImportantItem);
    rmAddAreaConstraint(forestID, avoidNativesShort);
    rmAddAreaConstraint(forestID, avoidStartingResources);
    if(rmBuildArea(forestID)==false)
    {
      // Stop trying once we fail 5 times in a row.  
      failCount++;
      if(failCount==5)
        break;
    }
    else
      failCount=0; 
  } 

	
// *********************** OBJECTS PLACED AFTER FORESTS ********************
	// Resources that can be placed after forests
  if(cNumberNonGaiaPlayers>2){
  rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
  rmPlaceObjectDefAtLoc(tapirID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
  }
	// Text
	rmSetStatusText("",0.90);
	
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 12.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 6.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 4.0);
    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 25.0);
	int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type  far ", "gold", 34.0);
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
  
    
    //1v1 balance
    if(cNumberNonGaiaPlayers==2){
        
        int riverHunts = rmCreateObjectDef("riverHunts");
        rmAddObjectDefItem(riverHunts, "ypSaiga", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(riverHunts, true);
        rmSetObjectDefMinDistance(riverHunts, 0);
        rmSetObjectDefMaxDistance(riverHunts, 15);
        rmAddObjectDefConstraint(riverHunts, avoidSocket2);
        rmAddObjectDefConstraint(riverHunts, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(riverHunts, forestConstraintShort);	
        rmAddObjectDefConstraint(riverHunts, avoidHunt2);
        rmAddObjectDefConstraint(riverHunts, avoidAll);       
        rmAddObjectDefConstraint(riverHunts, avoidNativesShort);       
        rmAddObjectDefConstraint(riverHunts, circleConstraint2);       

        int riverHuntKind = rmRandInt(1,3);
        riverHuntKind = 1;
        if(riverHuntKind==1){
            //    H            H
            rmPlaceObjectDefAtLoc(riverHunts, 0, 0.38, 0.5, 1);//close
            rmPlaceObjectDefAtLoc(riverHunts, 0, 0.83, 0.5, 1);//far

        }else if(riverHuntKind==2){
            //    H      H
            rmPlaceObjectDefAtLoc(riverHunts, 0, 0.38, 0.5, 1);//close
            rmPlaceObjectDefAtLoc(riverHunts, 0, 0.65, 0.5, 1);//mid

        }else if(riverHuntKind==3){
            //           H     H
            rmPlaceObjectDefAtLoc(riverHunts, 0, 0.65, 0.5, 1);//mid
            rmPlaceObjectDefAtLoc(riverHunts, 0, 0.83, 0.5, 1);//far
        }
        //map hunts
        int pronghornHunts = rmCreateObjectDef("pronghornHunts");
        rmAddObjectDefItem(pronghornHunts, "ypMuskDeer", rmRandInt(8,8), 8.0);
        rmSetObjectDefCreateHerd(pronghornHunts, true);
        rmSetObjectDefMinDistance(pronghornHunts, 0);
        rmSetObjectDefMaxDistance(pronghornHunts, 15);
        rmAddObjectDefConstraint(pronghornHunts, avoidSocket2);
        rmAddObjectDefConstraint(pronghornHunts, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(pronghornHunts, forestConstraintShort);	
        rmAddObjectDefConstraint(pronghornHunts, avoidHunt2);
        rmAddObjectDefConstraint(pronghornHunts, avoidAll);       
        rmAddObjectDefConstraint(pronghornHunts, avoidNativesShort);       
        rmAddObjectDefConstraint(pronghornHunts, circleConstraint2);       
        //top right
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.72, 0.67, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.84, 0.79, 1);
        //bot right
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.84, 0.21, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.72, 0.33, 1);
        //bot left
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.13, 0.33, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.28, 0.15, 1);
        //top left
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.13, 0.67, 1);
        rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.28, 0.85, 1);
   }
       /*
    int marker1 = rmCreateArea("marker12");
    rmSetAreaSize(marker1, 0.01, 0.01);
    rmSetAreaLocation(marker1, 0.72, 0.18);
    rmSetAreaBaseHeight(marker1, 2.0); // Was 10
    rmSetAreaCoherence(marker1, 1.0);
    rmSetAreaTerrainType(marker1, "texas\ground4_tex");
    rmBuildArea(marker1); 
    
    int marker2 = rmCreateArea("marker2");
    rmSetAreaSize(marker2, 0.01, 0.01);
    rmSetAreaLocation(marker2, 0.84, 0.33);
    rmSetAreaBaseHeight(marker2, 2.0); // Was 10
    rmSetAreaCoherence(marker2, 1.0);
    rmSetAreaTerrainType(marker2, "texas\ground4_tex");
    rmBuildArea(marker2); */
    
    //mines 
    if(cNumberNonGaiaPlayers==2){
        int topMine = rmCreateObjectDef("topMine");
        rmAddObjectDefItem(topMine, "mine", 1, 1.0);
        rmSetObjectDefMinDistance(topMine, 0.0);
        rmSetObjectDefMaxDistance(topMine, 20);
        rmAddObjectDefConstraint(topMine, avoidSocket2);
        rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
        rmAddObjectDefConstraint(topMine, forestConstraintShort);
        rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
        rmAddObjectDefConstraint(topMine, circleConstraint2);       
        rmAddObjectDefConstraint(topMine, avoidIce);       
        rmAddObjectDefConstraint(topMine, avoidNativesShort);       
        rmAddObjectDefConstraint(topMine, avoidAll);       
        //top right
        rmPlaceObjectDefAtLoc(topMine, 0, 0.84, 0.67, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.72, 0.82, 1);
        //bot right
        rmPlaceObjectDefAtLoc(topMine, 0, 0.72, 0.18, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.84, 0.33, 1);
        //bot left
        rmPlaceObjectDefAtLoc(topMine, 0, 0.13, 0.33, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.28, 0.15, 1);
        //top left
        rmPlaceObjectDefAtLoc(topMine, 0, 0.13, 0.67, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.28, 0.85, 1);
        int riverMineKindTop = rmRandInt(1,3);
        int riverMineKindBot = rmRandInt(1,3);
        //center two, by rivers
        //riverMineKindTop=3;
        //riverMineKindBot=3;
        if(riverMineKindTop==1){
            //      M
            rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.61, 1);
        }else if(riverMineKindTop==2){
            // M
            rmPlaceObjectDefAtLoc(topMine, 0, 0.35, 0.61, 1);
        }else if(riverMineKindTop==3){
            //           M
            rmPlaceObjectDefAtLoc(topMine, 0, 0.65, 0.61, 1);
        }
        if(riverMineKindBot==1){
            //      M
            rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.39, 1);
        }else if(riverMineKindBot==2){
            // M
            rmPlaceObjectDefAtLoc(topMine, 0, 0.35, 0.39, 1);
        }else if(riverMineKindBot==3){
            //           M
            rmPlaceObjectDefAtLoc(topMine, 0, 0.65, 0.39, 1);
        }
    }
    
	// Nuggets
  int nugget4= rmCreateObjectDef("nugget nuts"); 
  rmAddObjectDefItem(nugget4, "Nugget", 1, 0.0);
  if(cNumberNonGaiaPlayers==2 || rmGetIsTreaty() == true){
    rmSetNuggetDifficulty(3, 3);
  }else{
    rmSetNuggetDifficulty(4, 4);
  }
  rmSetObjectDefMinDistance(nugget4, 0.0);
  rmSetObjectDefMaxDistance(nugget4, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget4, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget4, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget4, shortAvoidResource);
  rmAddObjectDefConstraint(nugget4, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget4, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget4, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget4, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget4, avoidNativesShort);
  rmAddObjectDefConstraint(nugget4, circleConstraint);
	if (cNumberNonGaiaPlayers > 4)
		rmPlaceObjectDefAtLoc(nugget4, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
  
  int nugget3= rmCreateObjectDef("nugget hard"); 
  rmAddObjectDefItem(nugget3, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(3, 3);
  rmSetObjectDefMinDistance(nugget3, 0.0);
  rmSetObjectDefMaxDistance(nugget3, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget3, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget3, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget3, shortAvoidResource);
  rmAddObjectDefConstraint(nugget3, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget3, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget3, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget3, avoidNativesShort);
  rmAddObjectDefConstraint(nugget3, playerConstraintNugget);
  rmAddObjectDefConstraint(nugget3, circleConstraint);
	if (cNumberNonGaiaPlayers > 2)
		rmPlaceObjectDefAtLoc(nugget3, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

  int nugget2= rmCreateObjectDef("nugget medium"); 
  rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(2, 2);
  rmSetObjectDefMinDistance(nugget2, 0.0);
  rmSetObjectDefMaxDistance(nugget2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(nugget2, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget2, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget2, shortAvoidResource);
  rmAddObjectDefConstraint(nugget2, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget2, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget2, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget2, avoidNativesShort);
  rmAddObjectDefConstraint(nugget2, playerConstraint);
  rmAddObjectDefConstraint(nugget2, circleConstraint);
  rmSetObjectDefMinDistance(nugget2, 80.0);
  rmSetObjectDefMaxDistance(nugget2, 120.0);
  rmPlaceObjectDefPerPlayer(nugget2, false, 3);

  int nugget1= rmCreateObjectDef("nugget easy"); 
  rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
  rmSetNuggetDifficulty(1, 1);
  rmAddObjectDefConstraint(nugget1, avoidImpassableLand);
  rmAddObjectDefConstraint(nugget1, shortAvoidImportantItem);
  rmAddObjectDefConstraint(nugget1, shortAvoidResource);
  rmAddObjectDefConstraint(nugget1, avoidNuggetFar);
  rmAddObjectDefConstraint(nugget1, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(nugget1, avoidNativesShort);
  rmAddObjectDefConstraint(nugget1, avoidTradeRouteSockets);
  rmAddObjectDefConstraint(nugget1, playerConstraint);
  rmAddObjectDefConstraint(nugget1, circleConstraint);
  rmSetObjectDefMinDistance(nugget1, 0.0);
  rmSetObjectDefMaxDistance(nugget1, rmXFractionToMeters(0.99));
  rmPlaceObjectDefPerPlayer(nugget1, false, 3);

// check for KOTH game mode
  if(rmGetIsKOTH()) {
    int hillLoc = rmRandInt(1,4);
    float xLoc = 0.0;
    float yLoc = 0.0;
    float walk = 0.025;
    
    if(teamZeroCount == 1 && teamOneCount == 1 && cNumberTeams == 2){
      if (hillLoc < 3) {
        xLoc = 0.75;
        yLoc = 0.5;
      }
        
      else {
        yLoc = 0.5;
        xLoc = 0.5;
      }
    }
    
    else if(hillLoc < 3 || cNumberTeams > 2){
      xLoc = 0.6;
      yLoc = 0.5;
    }
    
    else {
      xLoc = 0.4;
      yLoc = 0.5;
    }
    
    ypKingsHillLandfill(xLoc, yLoc, .0065, 1.0, patchMix, 0);
    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
  }
    
  // Vary some terrain
  for (i=0; < 30) {
    int patch=rmCreateArea("first patch "+i);
    rmSetAreaWarnFailure(patch, false);
    rmSetAreaSize(patch, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
    //rmSetAreaMix(patch, patchMix);
    rmSetAreaTerrainType(patch, patchTerrain);
    rmAddAreaTerrainLayer(patch, patchType1, 0, 1);														 
    rmAddAreaToClass(patch, rmClassID("classPatch"));
    rmSetAreaCoherence(patch, 0.0);
    rmAddAreaConstraint(patch, shortAvoidImpassableLand);
    rmAddAreaConstraint(patch, patchConstraint);
    rmAddAreaConstraint(patch, avoidIce);
    rmAddAreaConstraint(patch, avoidTownCenter);
    rmBuildArea(patch); 
  }
  
  
  int underBrushID = rmCreateObjectDef("underbrush");
  rmAddObjectDefItem(underBrushID, "underbrushYukon", 4, 5.0);
  rmSetObjectDefMinDistance(underBrushID, rmXFractionToMeters(0.0));
  rmSetObjectDefMaxDistance(underBrushID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(underBrushID, avoidImpassableLand);
  rmAddObjectDefConstraint(underBrushID, avoidUnderbrush);
  rmAddObjectDefConstraint(underBrushID, avoidIce);
  rmAddObjectDefConstraint(underBrushID, shortAvoidTradeRoute);
  rmAddObjectDefConstraint(underBrushID, avoidStartingResources);
  rmAddObjectDefConstraint(underBrushID, avoidTradeRouteSockets);
  rmPlaceObjectDefPerPlayer(underBrushID, false, 9);
  
	// Text
	rmSetStatusText("",0.99);
   
}  
