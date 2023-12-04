// LARGE Mongolia
// PJJ & JH
// AOE3 DE 2019 Updated by Alex Y  
// Durokan's 5/7 1.0 update for DE
// LARGE version by vividlyplain, July 2021
// edited by vividlyplain, December 2021

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
  int teamZeroCount = rmGetNumberPlayersOnTeam(0);
  int teamOneCount = rmGetNumberPlayersOnTeam(1);

	// Strings
	string natType1 = "Tengri";
	string natType2 = "Shaolin";
	string natGrpName1 = "native tengri village 0";
	string natGrpName2 = "native shaolin temple mongol 0";
	string toiletPaper = "water";
	string forTesting = "testmix";
	string paintMix1 = "mongolia_desert";
	string paintMix2 = "mongolia_grass";
	string paintMix3 = "mongolia_grass_b";
	string paintMix4 = "mongolia_grass_a";
	string paintMix5 = "mongolia_forest";
	string baseTerrain = "Mongolia\ground_grass1_mongol";
	string treeType1 = "ypTreeMongolia";
	string treeType2 = "ypTreeSaxaul";
	string mapType1 = "mongolia";
	string huntable1 = "ypSaiga";
	string huntable2 = "ypMuskDeer";
	string herdable1 = "ypYak";
	string lightingType = "Mongolia_skirmish";
	
	// Picks the map size
	int playerTiles=11000;
	if (TeamNum == 2) {
		if (PlayerNum >= 3)
			playerTiles = 10000;
		else if (PlayerNum >= 5)
			playerTiles = 9000;	
		else if (PlayerNum >= 7)
			playerTiles = 8000;
		}
	
	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
	
	// Picks a default water height
	rmSetSeaLevel(0.0);

	rmSetMapElevationParameters(cElevTurbulence, 0.02, 7, 0.5, 8.0); // type, frequency, octaves, persistence, variation 
	
	// Picks default terrain and water
	rmTerrainInitialize(baseTerrain, 0.0); 
//	rmSetBaseTerrainMix(paintMix1); 
	rmSetMapType(mapType1); 
	rmSetMapType("land");
	rmSetMapType("grass");
	rmSetLightingSet(lightingType);
	
	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classPatch = rmDefineClass("patch");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int classNative = rmDefineClass("natives");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	int classIsland = rmDefineClass("Island");
	
	// Text
	rmSetStatusText("",0.20);
	
	// ____________________ Constraints ____________________
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.28), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center", 0.50, 0.50, rmXFractionToMeters(0.0), rmXFractionToMeters(0.28), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.45,0.45,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	// Resource avoidance
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 24.0); //15.0
	int avoidForestMed=rmCreateClassDistanceConstraint("avoid forest medium", rmClassID("Forest"), 18.0); //15.0
	int avoidForestBase=rmCreateClassDistanceConstraint("avoid forest base", rmClassID("Forest"), 12.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 8.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidHunt2Far = rmCreateTypeDistanceConstraint("avoid hunt2 far", huntable2, 90.0);
	int avoidHunt2 = rmCreateTypeDistanceConstraint("avoid hunt2", huntable2, 60.0);
	int avoidHunt2Short = rmCreateTypeDistanceConstraint("avoid hunt2 short", huntable2, 16.0);
	int avoidHunt2Min = rmCreateTypeDistanceConstraint("avoid hunt2 min", huntable2, 4.0);
	int avoidHunt1Far = rmCreateTypeDistanceConstraint("avoid hunt1 far", huntable1, 90.0);
	int avoidHunt1 = rmCreateTypeDistanceConstraint("avoid hunt1 ", huntable1, 60.0);
	int avoidHunt1Short = rmCreateTypeDistanceConstraint("avoid hunt1 short ", huntable1, 24.0);
	int avoidHunt1Min = rmCreateTypeDistanceConstraint("avoid hunt1 min ", huntable1, 4.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 8.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 24.0);
	int avoidGoldTypeMed = rmCreateTypeDistanceConstraint("coin avoids coin med ", "gold", 50.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 80.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 4.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint ("gold avoid gold short", rmClassID("Gold"), 8.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold", rmClassID("Gold"), 44.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 64.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 90.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 111.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 8.0);
	int avoidNuggetMed = rmCreateTypeDistanceConstraint("nugget avoid nugget med", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 55.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 75.0);
	int avoidNuggetVeryFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Very Far", "AbstractNugget", 111.0);
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
	int avoidCattle=rmCreateTypeDistanceConstraint("avoid cattle", herdable1, 75.0);
	int avoidCattleMed=rmCreateTypeDistanceConstraint("avoid cattle med", herdable1, 40.0-PlayerNum);
	int avoidCattleShort=rmCreateTypeDistanceConstraint("avoid cattle short", herdable1, 30.0-PlayerNum);
	int avoidCattleMin=rmCreateTypeDistanceConstraint("avoid cattle min", herdable1, 8.0);

	// Avoid impassable land
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("avoid impassable land min", "Land", false, 1.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("avoid impassable land short", "Land", false, 3.0);
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("avoid impassable land medium", "Land", false, 15.0);
	int avoidImpassableLandFar = rmCreateTerrainDistanceConstraint("avoid impassable land far", "Land", false, 20.0);
	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 20.0);
	int avoidIslandMin=rmCreateClassDistanceConstraint("avoid island min", classIsland, 4.0);
	int avoidIslandShort=rmCreateClassDistanceConstraint("avoid island short", classIsland, 8.0);
	int avoidIsland=rmCreateClassDistanceConstraint("avoid island", classIsland, 16.0);
	int avoidIslandFar=rmCreateClassDistanceConstraint("avoid island far", classIsland, 24.0);
		
	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);	
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 12.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 8.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("trade route min", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 8.0);
	int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("avoid trade route socket min", "socketTradeRoute", 4.0);
	
	// ____________________ Player Placement ____________________
		if (cNumberTeams <= 2 && teamZeroCount == teamOneCount) // equal N of players per TEAM
		{
			if (teamZeroCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.15, 0.575);
					rmPlacePlayer(2, 0.575, 0.15);
				}
				else
				{
					rmPlacePlayer(2, 0.15, 0.575);
					rmPlacePlayer(1, 0.575, 0.15);
				}
			}
			else	// team
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.2, 0.8, 0.2, 0.47, 0.00, 0.20);
				
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.8, 0.2, 0.47, 0.2, 0.00, 0.20);
			}
		}
		else  //FFA
			{	
				rmSetTeamSpacingModifier(0.50);
				rmPlacePlayersCircular(0.36, 0.36, 0);	
			/*	// old
    if(cNumberNonGaiaPlayers == 2){
        rmPlacePlayer(1, .15, .575);
        rmPlacePlayer(2, .575, .15);
    }else{
    rmPlacePlayer(1, .15, .75);
    rmPlacePlayer(2, .75, .15);
    
    if(cNumberNonGaiaPlayers == 3 || cNumberNonGaiaPlayers == 5 || cNumberNonGaiaPlayers == 7) {
      rmPlacePlayer(3, .35, .35);
      
      if(cNumberNonGaiaPlayers == 5) {
        rmPlacePlayer(4, .25, .575);
        rmPlacePlayer(5, .575, .25);
      }
      
      else if (cNumberNonGaiaPlayers == 7){
        rmPlacePlayer(4, .2, .62);
        rmPlacePlayer(5, .25, .485);
        rmPlacePlayer(6, .485, .25);
        rmPlacePlayer(7, .62, .2);
      }

    }
    
    else {
      
      if(cNumberNonGaiaPlayers == 4) {
        rmPlacePlayer(3, .25, .485);
        rmPlacePlayer(4, .485, .25);
      }
      
      else if (cNumberNonGaiaPlayers == 6) {
        rmPlacePlayer(3, .58, .19);
        rmPlacePlayer(4, .19, .58);
        rmPlacePlayer(5, .26, .42);
        rmPlacePlayer(6, .42, .26);
      }
      
      else if(cNumberNonGaiaPlayers == 8){
        rmPlacePlayer(3, .62, .18);
        rmPlacePlayer(4, .18, .62);
        rmPlacePlayer(5, .21, .49);
        rmPlacePlayer(6, .49, .21);
        rmPlacePlayer(7, .26, .36);
        rmPlacePlayer(8, .36, .26);
      }
    }
    }
			*/
			}

   
	// Text
	rmSetStatusText("",0.30);
	
	// ____________________ Map Parameters ____________________
	// Main Land
	int mainLandID = rmCreateArea("main land");
	rmSetAreaSize(mainLandID, 0.99);
	rmSetAreaLocation(mainLandID, 0.50, 0.50);
	rmSetAreaMix(mainLandID, paintMix1);
	rmSetAreaWarnFailure(mainLandID, false);
	rmSetAreaCoherence(mainLandID, 1.00); 
	rmSetAreaElevationType(mainLandID, cElevTurbulence);
	rmSetAreaElevationVariation(mainLandID, 1.0);
	rmSetAreaBaseHeight(mainLandID, 0.0);
	rmSetAreaElevationMinFrequency(mainLandID, 0.04);
	rmSetAreaElevationOctaves(mainLandID, 3);
	rmSetAreaElevationPersistence(mainLandID, 0.4);      
	rmSetAreaSmoothDistance(mainLandID, 5);
	rmSetAreaObeyWorldCircleConstraint(mainLandID, false);
	rmBuildArea(mainLandID);
	
	int avoidMainLandMin = rmCreateAreaDistanceConstraint("avoid main land min", mainLandID, 0.01);
	int avoidMainLandShort = rmCreateAreaDistanceConstraint("avoid main land short", mainLandID, 8.0);
	int avoidMainLand = rmCreateAreaDistanceConstraint("avoid main land", mainLandID, 12.0);
	int stayInMainLand = rmCreateAreaMaxDistanceConstraint("stay in main land", mainLandID, 0.0);

	// Players area
	for (i=1; < numPlayer)
	{
	int playerAreaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerAreaID);
	rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(333));
	rmSetAreaCoherence(playerAreaID, 0.666);
	rmSetAreaMix(playerAreaID, paintMix2);
	rmSetAreaWarnFailure(playerAreaID, false);
	rmSetAreaLocPlayer(playerAreaID, i);
	rmAddAreaToClass (playerAreaID, classIsland);
	rmSetAreaObeyWorldCircleConstraint(playerAreaID, false);
	rmBuildArea(playerAreaID);
	}
	
	// Text
	rmSetStatusText("",0.40);

	// ____________________ KOTH ____________________
	if (rmGetIsKOTH() == true) {
		float xLoc = 0.50;
		float yLoc = 0.50;
		float walk = 0.00;

		ypKingsHillLandfill(xLoc, yLoc, rmAreaTilesToFraction(333), 1.0, paintMix3, 0);
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
		}

	int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 8.0);

	// ____________________ Trade Route ____________________
	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 2.0);
		rmSetObjectDefMaxDistance(socketID, 8.0);
	
	int leftORright = rmRandInt(1,2);
	
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		if (TeamNum == 2 && teamZeroCount == teamOneCount) {
			if (leftORright == 1) {
				rmAddTradeRouteWaypoint(tradeRouteID, 0.99, 0.55); 
				rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.55); 
				rmAddTradeRouteWaypoint(tradeRouteID, 0.825, 0.575);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.575, 0.825);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.95);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.99);
				}
			else {
				rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.99);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.55, 0.95);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.575, 0.825);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.825, 0.575);
				rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.55); 
				rmAddTradeRouteWaypoint(tradeRouteID, 0.99, 0.55); 
				}
			}
		else {
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
		
		bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, toiletPaper);
		if(placedTradeRoute == false)
			rmEchoError("Failed to place trade route");

	// Place Sockets
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.125);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if (PlayerNum > 4 && TeamNum > 2 || teamZeroCount != teamOneCount) {			
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}
		
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.375);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if (PlayerNum > 4 && TeamNum > 2 || teamZeroCount != teamOneCount) {			
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.625);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if (PlayerNum > 4 && TeamNum > 2 || teamZeroCount != teamOneCount) {			
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.875);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	if (PlayerNum > 4 && TeamNum > 2 || teamZeroCount != teamOneCount) {			
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 1.00);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		}		

	// Text
	rmSetStatusText("",0.45);
	
	// ____________________ Natives ____________________
	float natLocAx = 0.40;
	float natLocAy = 0.85;
	float natLocBx = 0.85;
	float natLocBy = 0.40;	
	float natLocCx = 0.60;
	float natLocCy = 0.60;
	float natLocDx = 0.41;
	float natLocDy = 0.41;
	if (TeamNum > 2 || teamZeroCount != teamOneCount) {
		natLocAx = 0.40;
		natLocAy = 0.40;
		natLocBx = 0.60;
		natLocBy = 0.60;	
		natLocCx = 0.60;
		natLocCy = 0.40;
		natLocDx = 0.40;
		natLocDy = 0.60;		
		}
	
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
	
	int whichVillage1 = rmRandInt(1,5);
	int whichVillage2 = rmRandInt(1,5);
	int whichVillage3 = rmRandInt(1,5);
	int whichVillage4 = rmRandInt(1,5);
	int whichNative = rmRandInt(1,2);

		nativeID0 = rmCreateGrouping("Native A", natGrpName1+whichVillage1);
		nativeID1 = rmCreateGrouping("Native B", natGrpName1+whichVillage2);
		nativeID2 = rmCreateGrouping("Native C", natGrpName2+whichVillage3);
		nativeID3 = rmCreateGrouping("Native D", natGrpName2+whichVillage4);
		
		rmAddGroupingToClass(nativeID0, classNative);
		rmAddGroupingToClass(nativeID1, classNative);
		rmAddGroupingToClass(nativeID2, classNative);
		rmAddGroupingToClass(nativeID3, classNative);

	if (TeamNum == 2 && teamZeroCount == teamOneCount) {	// placed once per player in weird spawns
		if (whichNative == 1) {
			rmPlaceGroupingAtLoc(nativeID3, 0, natLocCx, natLocCy);
			rmPlaceGroupingAtLoc(nativeID2, 0, natLocDx, natLocDy);
			rmPlaceGroupingAtLoc(nativeID0, 0, natLocAx, natLocAy);
			rmPlaceGroupingAtLoc(nativeID1, 0, natLocBx, natLocBy);	
			}
		else {
			rmPlaceGroupingAtLoc(nativeID0, 0, natLocCx, natLocCy);
			rmPlaceGroupingAtLoc(nativeID1, 0, natLocDx, natLocDy);
			rmPlaceGroupingAtLoc(nativeID2, 0, natLocAx, natLocAy);
			rmPlaceGroupingAtLoc(nativeID3, 0, natLocBx, natLocBy);	
			}
		}
	
	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
    	if (PlayerNum == 2)
  			rmSetAreaSize(midIslandID, 0.25);
    	else
  			rmSetAreaSize(midIslandID, 0.30);
			rmSetAreaLocation(midIslandID, 0.30, 0.30);
    	if (PlayerNum > 2) {
  			rmAddAreaInfluenceSegment(midIslandID, 0.30, 0.30, 1.00, 0.30);
		  	rmAddAreaInfluenceSegment(midIslandID, 0.30, 0.30, 0.30, 1.00);
    	  	}
		}
	else {
		rmSetAreaSize(midIslandID, 0.33+0.005*PlayerNum);
		rmSetAreaLocation(midIslandID, 0.50, 0.50);
		}
//	rmSetAreaMix(midIslandID, forTesting); 	// for testing
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.10);
	rmSetAreaLocation(midSmIslandID, 0.30, 0.30);
//	rmSetAreaMix(midSmIslandID, "himalayas_a"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 0.666);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	int midLineID=rmCreateArea("Mid Line");
	rmSetAreaSize(midLineID, 0.05);
	rmSetAreaLocation(midLineID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(midLineID, 0.99, 0.99, 0.01, 0.01);
//	rmSetAreaMix(midLineID, "coastal_japan_b"); 	// for testing
	rmSetAreaCoherence(midLineID, 1.00);
	rmBuildArea(midLineID); 
	
	int avoidMidLine = rmCreateAreaDistanceConstraint("avoid mid line ", midLineID, 8.0);
	int avoidMidLineMin = rmCreateAreaDistanceConstraint("avoid mid line min", midLineID, 0.5);
	int avoidMidLineFar = rmCreateAreaDistanceConstraint("avoid mid line far", midLineID, 16.0);
	int stayMidLine = rmCreateAreaMaxDistanceConstraint("stay mid line ", midLineID, 0.0);

	// North Paint
	int northPaint=rmCreateArea("painting northern steppe");
	rmSetAreaSize(northPaint, 0.51);
	rmSetAreaWarnFailure(northPaint, false);
	rmSetAreaMix(northPaint, paintMix3);
	rmSetAreaSmoothDistance(northPaint, 5);
	rmSetAreaCoherence(northPaint, 0.777);
	if (PlayerNum == 2)
		rmSetAreaLocation(northPaint, 0.60, 0.60);
	else
		rmSetAreaLocation(northPaint, 0.99, 0.99);
	rmSetAreaObeyWorldCircleConstraint(northPaint, false);
	if (TeamNum == 2)
	    rmAddAreaConstraint(northPaint, avoidIsland);
	rmAddAreaConstraint(northPaint, avoidMidSmIslandMin);
	rmBuildArea(northPaint);
	
	int avoidNorthMin = rmCreateAreaDistanceConstraint("avoid north min", northPaint, 2.0);
	int avoidNorthShort = rmCreateAreaDistanceConstraint("avoid north short", northPaint, 4.0);
	int avoidNorth = rmCreateAreaDistanceConstraint("avoid north", northPaint, 8.0);
	int avoidNorthFar = rmCreateAreaDistanceConstraint("avoid north far", northPaint, 24.0);
	int stayNorth = rmCreateAreaMaxDistanceConstraint("stay in north", northPaint, 0.0);
	int stayNearNorth = rmCreateAreaMaxDistanceConstraint("stay near north", northPaint, 8.0);

	// Native Islands
	int natIsland1ID = rmCreateArea("nat isle 1");
	rmSetAreaSize(natIsland1ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland1ID, natLocAx, natLocAy);
	rmSetAreaWarnFailure(natIsland1ID, false);
	rmSetAreaMix(natIsland1ID, paintMix4);
	rmSetAreaCoherence(natIsland1ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland1ID, false);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(natIsland1ID);	
	
	int natIsland2ID = rmCreateArea("nat isle 2");
	rmSetAreaSize(natIsland2ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland2ID, natLocBx, natLocBy);
	rmSetAreaWarnFailure(natIsland2ID, false);
	rmSetAreaMix(natIsland2ID, paintMix4);
	rmSetAreaCoherence(natIsland2ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland2ID, false);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(natIsland2ID);	

	int natIsland3ID = rmCreateArea("nat isle 3");
	rmSetAreaSize(natIsland3ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland3ID, natLocCx, natLocCy);
	rmSetAreaWarnFailure(natIsland3ID, false);
	rmSetAreaMix(natIsland3ID, paintMix4);
	rmSetAreaCoherence(natIsland3ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland3ID, false);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(natIsland3ID);	
	
	int natIsland4ID = rmCreateArea("nat isle 4");
	rmSetAreaSize(natIsland4ID, rmAreaTilesToFraction(333));
	rmSetAreaLocation(natIsland4ID, natLocDx, natLocDy);
	rmSetAreaWarnFailure(natIsland4ID, false);
	rmSetAreaMix(natIsland4ID, paintMix4);
	rmSetAreaCoherence(natIsland4ID, 0.44); 
	rmSetAreaObeyWorldCircleConstraint(natIsland4ID, false);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(natIsland4ID);	
  
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.43), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));

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

	// Player Native 
	int playerNativeID = -1;
	if (whichNative == 1)
		playerNativeID = rmCreateGrouping("player native", natGrpName1+whichVillage1);
	else
		playerNativeID = rmCreateGrouping("player native", natGrpName2+whichVillage2);
	rmAddGroupingToClass(playerNativeID, classNative);
	rmAddGroupingToClass(playerNativeID, classStartingResource);
	rmSetGroupingMinDistance(playerNativeID, 24);
	rmSetGroupingMaxDistance(playerNativeID, 36);
	rmAddGroupingConstraint(playerNativeID, stayMidIsland);
	rmAddGroupingConstraint(playerNativeID, avoidStartingResources);
	rmAddGroupingConstraint(playerNativeID, avoidNatives);
	rmAddGroupingConstraint(playerNativeID, avoidTradeRoute);
	
	// Starting mines
	int frontORback = rmRandInt(1,2);
	
	int playerGoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerGoldID, "MineGold", 1, 0);
	rmSetObjectDefMinDistance(playerGoldID, 14.0);
	rmSetObjectDefMaxDistance(playerGoldID, 14.0);
	rmAddObjectDefToClass(playerGoldID, classStartingResource);
	rmAddObjectDefToClass(playerGoldID, classGold);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteMin);
	rmAddObjectDefConstraint(playerGoldID, avoidTradeRouteSocketMin);
	rmAddObjectDefConstraint(playerGoldID, avoidNativesMin);
	rmAddObjectDefConstraint(playerGoldID, avoidStartingResources);
	if (TeamNum == 2 && teamZeroCount == teamOneCount) {
		if (frontORback == 1)
			rmAddObjectDefConstraint(playerGoldID, stayMidIsland);
		else
			rmAddObjectDefConstraint(playerGoldID, avoidMidIslandMin);
		}
		
	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, treeType2, 2, 2.0);
  rmSetObjectDefMinDistance(playerTreeID, 12);
  rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(playerTreeID, avoidNatives);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);

	// Starting berries
    int playerBerryID = rmCreateObjectDef("starting berries");
    rmAddObjectDefItem(playerBerryID, "BerryBush", 4, 4.0);
    rmSetObjectDefMinDistance(playerBerryID, 14.0);
    rmSetObjectDefMaxDistance(playerBerryID, 14.0);
	rmAddObjectDefToClass(playerBerryID, classStartingResource);
	rmAddObjectDefConstraint(playerBerryID, avoidStartingResources);

	// bonus coin crate
    int playerCrateID = rmCreateObjectDef("bonus starting crate");
    rmAddObjectDefItem(playerCrateID, "crateOfCoin", 1, 0.0);
    rmSetObjectDefMinDistance(playerCrateID, 6.0);
    rmSetObjectDefMaxDistance(playerCrateID, 10.0);
	rmAddObjectDefToClass(playerCrateID, classStartingResource);
	rmAddObjectDefConstraint(playerCrateID, avoidStartingResourcesShort);

	// Starting herds
	int playerHerdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerHerdID, huntable1, 6+PlayerNum, 3+PlayerNum/2);
	rmSetObjectDefMinDistance(playerHerdID, 12.0);
	rmSetObjectDefMaxDistance(playerHerdID, 14.0);
	rmSetObjectDefCreateHerd(playerHerdID, true);
	rmAddObjectDefToClass(playerHerdID, classStartingResource);
	rmAddObjectDefConstraint(playerHerdID, avoidStartingResources);
	rmAddObjectDefConstraint(playerHerdID, avoidHunt2Short);	// spawns after second hunt
		
	int playerHerd2ID = rmCreateObjectDef("player 2nd herd");
	rmAddObjectDefItem(playerHerd2ID, huntable2, 6+PlayerNum, 3+PlayerNum/2);
    rmSetObjectDefMinDistance(playerHerd2ID, 28);
    rmSetObjectDefMaxDistance(playerHerd2ID, 30);
	rmAddObjectDefToClass(playerHerd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerHerd2ID, true);
	rmAddObjectDefConstraint(playerHerd2ID, avoidNativesMin);
	rmAddObjectDefConstraint(playerHerd2ID, avoidStartingResourcesShort);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(playerHerd2ID, avoidMidIslandFar);
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 24.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesMin);

	// Yaks near players
	int playerYakID = rmCreateObjectDef("player yaks"); 
	rmAddObjectDefItem(playerYakID, herdable1, 1, 0.0);
	rmSetObjectDefMinDistance(playerYakID, 50.0);
	rmSetObjectDefMaxDistance(playerYakID, 64.0);
	rmAddObjectDefToClass(playerYakID, classStartingResource);
	rmAddObjectDefConstraint(playerYakID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerYakID, avoidEdge);
	rmAddObjectDefConstraint(playerYakID, avoidIsland);
	rmAddObjectDefConstraint(playerYakID, avoidNativesMin);
	rmAddObjectDefConstraint(playerYakID, avoidCattleShort);
	rmAddObjectDefConstraint(playerYakID, avoidMidSmIsland);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerYakID, avoidNorthMin);
	if (TeamNum > 2 || teamZeroCount != teamOneCount)
		rmAddObjectDefConstraint(playerYakID, avoidMidIsland);

	int playerYak2ID = rmCreateObjectDef("player yaks2"); 
	rmAddObjectDefItem(playerYak2ID, herdable1, 1, 0.0);
	rmSetObjectDefMinDistance(playerYak2ID, 77.0);
	rmSetObjectDefMaxDistance(playerYak2ID, 111.0);
	rmAddObjectDefToClass(playerYak2ID, classStartingResource);
	rmAddObjectDefConstraint(playerYak2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerYak2ID, avoidEdge);
	rmAddObjectDefConstraint(playerYak2ID, avoidIsland);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerYak2ID, avoidCattleMed);
	else
		rmAddObjectDefConstraint(playerYak2ID, avoidCattleShort);
	rmAddObjectDefConstraint(playerYak2ID, avoidNatives);
	if (PlayerNum == 2)
		rmAddObjectDefConstraint(playerYak2ID, stayMidSmIsland);
	if (TeamNum == 2 && teamZeroCount == teamOneCount)
		rmAddObjectDefConstraint(playerYak2ID, avoidNorth);
	else
		rmAddObjectDefConstraint(playerYak2ID, stayMidIsland);

	// Place Starting Objects	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (TeamNum > 2 || teamZeroCount != teamOneCount)
			rmPlaceGroupingAtLoc(playerNativeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerGoldID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerd2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(playerHerd2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerHerdID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerBerryID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		// sooo manyyyy treeees
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		rmPlaceObjectDefAtLoc(playerYak2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerYakID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerYakID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(playerCrateID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmSetNuggetDifficulty(98,98);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if(ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
			
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}
		
	// Text
	rmSetStatusText("",0.60);

	// ____________________ Common Resources ____________________
	// Common Mines 
	int goldID = rmCreateObjectDef("gold south");
		rmAddObjectDefItem(goldID, "MineGold", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.00));
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.015));
		else
			rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidCattleMin);
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(goldID, avoidGoldFar);
			if (TeamNum > 2 || teamZeroCount != teamOneCount)
				rmAddObjectDefConstraint(goldID, avoidMidIslandFar);
			else
				rmAddObjectDefConstraint(goldID, avoidNorthFar);
			rmAddObjectDefConstraint(goldID, avoidNatives);
			rmAddObjectDefConstraint(goldID, avoidIslandFar);
			rmAddObjectDefConstraint(goldID, avoidTownCenterFar);
			rmAddObjectDefConstraint(goldID, avoidTradeRouteSocketShort);
			rmAddObjectDefConstraint(goldID, avoidTradeRouteMin);
			rmAddObjectDefConstraint(goldID, avoidStartingResources);
			rmAddObjectDefConstraint(goldID, avoidEdge);
			rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50, PlayerNum);
			}
		else {
			rmPlaceObjectDefAtLoc(goldID, 0, 0.10, 0.30);
			rmPlaceObjectDefAtLoc(goldID, 0, 0.30, 0.10);
			}

	int gold2ID = rmCreateObjectDef("gold north");
		rmAddObjectDefItem(gold2ID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(gold2ID, rmXFractionToMeters(0.00));
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(gold2ID, rmXFractionToMeters(0.05));
		else
			rmSetObjectDefMaxDistance(gold2ID, rmXFractionToMeters(0.45));
		rmAddObjectDefToClass(gold2ID, classGold);
		rmAddObjectDefConstraint(gold2ID, avoidNativesMin);
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(gold2ID, avoidGoldMed);		
			rmAddObjectDefConstraint(gold2ID, avoidIsland);
			rmAddObjectDefConstraint(gold2ID, avoidTownCenter);
			rmAddObjectDefConstraint(gold2ID, avoidTradeRouteSocketShort);
			rmAddObjectDefConstraint(gold2ID, avoidTradeRouteMin);
			rmAddObjectDefConstraint(gold2ID, avoidStartingResources);
			rmAddObjectDefConstraint(gold2ID, stayNearNorth);
			rmAddObjectDefConstraint(gold2ID, avoidEdge);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.50, 0.50, PlayerNum*3.5);
			}
		else {
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.60, 0.45);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.45, 0.60);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.35, 0.35);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.275, 0.775);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.775, 0.275);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.80, 0.55);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.55, 0.80);
			rmPlaceObjectDefAtLoc(gold2ID, 0, 0.75, 0.75);
			}

	// Text
	rmSetStatusText("",0.70);

	// Main forest patches
	int mainforestcount = 30+20*PlayerNum;
	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, true);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(33));
        rmSetAreaMix(forestpatchID, paintMix5);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmAddAreaToClass(forestpatchID, classForest);
		rmAddAreaConstraint(forestpatchID, avoidTradeRouteSocketShort);
		rmAddAreaConstraint(forestpatchID, avoidForestBase);
		rmAddAreaConstraint(forestpatchID, avoidStartingResources);
		rmAddAreaConstraint(forestpatchID, avoidGoldMin);
		rmAddAreaConstraint(forestpatchID, stayNorth);        
		rmAddAreaConstraint(forestpatchID, avoidNatives);        
		rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		int foresttreeID = rmCreateObjectDef("forest trees"+i);
			rmAddObjectDefItem(foresttreeID, treeType1, 1, 5.0);
			rmSetObjectDefMinDistance(foresttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(foresttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmAddObjectDefConstraint(foresttreeID, avoidNativesMin);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50, 5);
    }

	// Text
	rmSetStatusText("",0.80);

	// Secondary forest
	int secondforestcount = 10+8*PlayerNum;
	int stayIn2ndForest = -1;

	for (i=0; < secondforestcount)
	{
		int secondforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondforestID, false);
		rmSetAreaSize(secondforestID, rmAreaTilesToFraction(33));
		rmSetAreaObeyWorldCircleConstraint(secondforestID, true);
        rmSetAreaMix(secondforestID, paintMix5);
		rmSetAreaCoherence(secondforestID, 0.2);
		rmAddAreaToClass(secondforestID, classForest);
		rmAddAreaConstraint(secondforestID, avoidIsland);
		rmAddAreaConstraint(secondforestID, avoidTownCenterMed);
		rmAddAreaConstraint(secondforestID, avoidForest);
		rmAddAreaConstraint(secondforestID, avoidGoldMin);
		rmAddAreaConstraint(secondforestID, avoidTradeRouteSocketShort);
		rmAddAreaConstraint(secondforestID, avoidStartingResources);
		rmAddAreaConstraint(secondforestID, avoidNorth);
		rmAddAreaConstraint(secondforestID, avoidNatives);
		rmBuildArea(secondforestID);

		stayIn2ndForest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondforestID, 0);

		int secondforesttreeID = rmCreateObjectDef("secondary forest trees"+i);
			rmAddObjectDefItem(secondforesttreeID, treeType2, 3, 6.0);
			rmSetObjectDefMinDistance(secondforesttreeID, rmXFractionToMeters(0.00));
			rmSetObjectDefMaxDistance(secondforesttreeID, rmXFractionToMeters(0.50));
			rmAddObjectDefConstraint(secondforesttreeID, stayIn2ndForest);
			rmAddObjectDefConstraint(secondforesttreeID, avoidNativesMin);
			rmPlaceObjectDefAtLoc(secondforesttreeID, 0, 0.50, 0.50, 3);
	}

	// Hunts 
	int herdcount = 4*PlayerNum;

	int huntID = rmCreateObjectDef("common herd");
		rmAddObjectDefItem(huntID, huntable1, 7, 4.0);
		rmSetObjectDefMinDistance(huntID, rmXFractionToMeters(0.00));
		if (PlayerNum > 2)
			rmSetObjectDefMaxDistance(huntID, rmXFractionToMeters(0.45));
		else
			rmSetObjectDefMaxDistance(huntID, rmXFractionToMeters(0.05));
		rmSetObjectDefCreateHerd(huntID, true);
		rmAddObjectDefConstraint(huntID, avoidGoldMin);
		rmAddObjectDefConstraint(huntID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(huntID, avoidForestMin);
		rmAddObjectDefConstraint(huntID, avoidNativesMin);
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(huntID, avoidStartingResources);
			rmAddObjectDefConstraint(huntID, avoidTownCenter);
			rmAddObjectDefConstraint(huntID, avoidIsland);
			rmAddObjectDefConstraint(huntID, avoidHunt1Far);
			rmAddObjectDefConstraint(huntID, avoidHunt2Far);
			rmAddObjectDefConstraint(huntID, avoidEdge);
			}

	int hunt2ID = rmCreateObjectDef("common herd2 ");
		rmAddObjectDefItem(hunt2ID, huntable2, 7, 4.0);
		rmSetObjectDefMinDistance(hunt2ID, rmXFractionToMeters(0.00));
		if (PlayerNum > 2)
			rmSetObjectDefMaxDistance(hunt2ID, rmXFractionToMeters(0.45));
		else
			rmSetObjectDefMaxDistance(hunt2ID, rmXFractionToMeters(0.05));
		rmSetObjectDefCreateHerd(hunt2ID, true);
		rmAddObjectDefConstraint(hunt2ID, avoidGoldMin);
		rmAddObjectDefConstraint(hunt2ID, avoidTradeRouteSocketMin);
		rmAddObjectDefConstraint(hunt2ID, avoidForestMin);
		rmAddObjectDefConstraint(hunt2ID, avoidNativesMin);
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(hunt2ID, avoidStartingResources);
			rmAddObjectDefConstraint(hunt2ID, avoidTownCenter);
			rmAddObjectDefConstraint(hunt2ID, avoidIsland);
			rmAddObjectDefConstraint(hunt2ID, avoidHunt1);
			rmAddObjectDefConstraint(hunt2ID, avoidHunt2);
			rmAddObjectDefConstraint(hunt2ID, avoidEdge);
			}
		
		if (PlayerNum > 2) {
			rmPlaceObjectDefAtLoc(huntID, 0, 0.50, 0.50, herdcount);
			rmPlaceObjectDefAtLoc(hunt2ID, 0, 0.50, 0.50, herdcount);
			}
		else {
			rmPlaceObjectDefAtLoc(huntID, 0, 0.85, 0.72);
			rmPlaceObjectDefAtLoc(huntID, 0, 0.72, 0.85);
			rmPlaceObjectDefAtLoc(huntID, 0, 0.63, 0.63);
			rmPlaceObjectDefAtLoc(huntID, 0, 0.83, 0.42);
			rmPlaceObjectDefAtLoc(huntID, 0, 0.42, 0.83);
			rmPlaceObjectDefAtLoc(huntID, 0, 0.60, 0.40);
			rmPlaceObjectDefAtLoc(huntID, 0, 0.40, 0.60);
			rmPlaceObjectDefAtLoc(hunt2ID, 0, 0.30, 0.15);
			rmPlaceObjectDefAtLoc(hunt2ID, 0, 0.15, 0.30);
			rmPlaceObjectDefAtLoc(hunt2ID, 0, 0.40, 0.40);
			rmPlaceObjectDefAtLoc(hunt2ID, 0, 0.75, 0.20);
			rmPlaceObjectDefAtLoc(hunt2ID, 0, 0.20, 0.75);
			}

	// Text
	rmSetStatusText("",0.90);

	// Treasures 
	int treasure1count = 4+PlayerNum;
	int treasure2count = 2+PlayerNum;
	int treasure3count = PlayerNum/2;
	
	// 	Treasures L3
	int Nugget3ID = rmCreateObjectDef("nugget L3 "); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.20));
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNativesMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget3ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget3ID, avoidIslandFar);
		if (PlayerNum > 2 && rmGetIsTreaty() == false) {
			rmSetNuggetDifficulty(3,4);
			if (TeamNum == 2 && teamZeroCount == teamOneCount)	
				rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.15, 0.15, PlayerNum);
			else
				rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50, PlayerNum);
			}
		else {
			rmSetNuggetDifficulty(3,3);
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.15, 0.15, PlayerNum);
			}

	int Nugget3TID = rmCreateObjectDef("nugget L3 top"); 
		rmAddObjectDefItem(Nugget3TID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3TID, 0);
		rmSetObjectDefMaxDistance(Nugget3TID, rmXFractionToMeters(0.20));
		if (PlayerNum == 2)	
			rmAddObjectDefConstraint(Nugget3TID, avoidNugget);
		else if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmAddObjectDefConstraint(Nugget3TID, avoidNuggetMed);
		else
			rmAddObjectDefConstraint(Nugget3TID, avoidNugget);
		rmAddObjectDefConstraint(Nugget3TID, avoidNativesMin);
		rmAddObjectDefConstraint(Nugget3TID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget3TID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3TID, avoidEdge);
		rmAddObjectDefConstraint(Nugget3TID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget3TID, avoidHunt2Min);
		if (PlayerNum == 2 || rmGetIsTreaty() == true)
			rmSetNuggetDifficulty(3,3);
		else
			rmSetNuggetDifficulty(3,4);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmPlaceObjectDefAtLoc(Nugget3TID, 0, 0.90, 0.90, PlayerNum);
		else
			rmPlaceObjectDefAtLoc(Nugget3TID, 0, 0.50, 0.50, 2*PlayerNum);

	// Team Treasures
	int teamNuggetID = rmCreateObjectDef("nugget team"); 
		rmAddObjectDefItem(teamNuggetID, "Nugget", 1, 0.00);
		rmSetObjectDefMinDistance(teamNuggetID, 0);
		rmSetObjectDefMaxDistance(teamNuggetID, rmXFractionToMeters(0.30));
		rmSetNuggetDifficulty(12,12);
		rmAddObjectDefConstraint(teamNuggetID, avoidNuggetFar);
		rmAddObjectDefConstraint(teamNuggetID, avoidTownCenterFar);
		rmAddObjectDefConstraint(teamNuggetID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(teamNuggetID, avoidNativesMin);
		rmAddObjectDefConstraint(teamNuggetID, avoidGoldMin);
		rmAddObjectDefConstraint(teamNuggetID, avoidHunt1Min);
		rmAddObjectDefConstraint(teamNuggetID, avoidHunt2Min);
		rmAddObjectDefConstraint(teamNuggetID, avoidForestMin);	
		rmAddObjectDefConstraint(teamNuggetID, avoidEdge);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(teamNuggetID, 0, 0.50, 0.50, PlayerNum);

	// Treasures L2	
	int Nugget2ID = rmCreateObjectDef("nugget L2 "); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.35));
		rmSetNuggetDifficulty(2,2);
		rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge); 
		rmAddObjectDefConstraint(Nugget2ID, avoidNativesMin);
		if (TeamNum == 2 && teamZeroCount == teamOneCount)	
			rmAddObjectDefConstraint(Nugget2ID, stayNorth);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50, 2*PlayerNum);
	
	// Treasures L1
	int Nugget1ID = rmCreateObjectDef("nugget L1 "); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.48));
		rmSetNuggetDifficulty(1,1);
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNativesMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidHunt1Min);
		rmAddObjectDefConstraint(Nugget1ID, avoidHunt2Min);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50, 2*PlayerNum);

	// Text
	rmSetStatusText("",0.95);

	// Cattle 
	int cattleCount = 3*PlayerNum;
	
	int cattleID=rmCreateObjectDef("cattle");
		rmAddObjectDefItem(cattleID, herdable1, 1, 0.0);
		rmSetObjectDefMinDistance(cattleID, 0.0);
		if (PlayerNum == 2)
			rmSetObjectDefMaxDistance(cattleID, rmXFractionToMeters(0.02));
		else
			rmSetObjectDefMaxDistance(cattleID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(cattleID, avoidNativesMin);
		rmAddObjectDefConstraint(cattleID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(cattleID, avoidGoldMin);
		rmAddObjectDefConstraint(cattleID, avoidForestMin);
		rmAddObjectDefConstraint(cattleID, avoidNuggetMin);
		rmAddObjectDefConstraint(cattleID, stayNearNorth); 
		rmAddObjectDefConstraint(cattleID, avoidEdge); 
		if (PlayerNum > 2) {
			rmAddObjectDefConstraint(cattleID, avoidTownCenterFar);
			rmAddObjectDefConstraint(cattleID, avoidIslandFar);
			rmAddObjectDefConstraint(cattleID, avoidCattle);
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.50, 0.50, cattleCount);
			}
		else {
			//top
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.85, 0.65, 1);
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.65, 0.85, 1);
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.68, 0.68, 1);
			//under TR
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.90, 0.40, 1);
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.40, 0.90, 1);
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.5, 0.5, 1);
			//center LR
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.70, 0.40, 1);
			rmPlaceObjectDefAtLoc(cattleID, 0, 0.40, 0.70, 1);
			}
			
	// Text
	rmSetStatusText("",1.00);

} // END
	
	