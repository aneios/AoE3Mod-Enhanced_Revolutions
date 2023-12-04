// LARGE Punjab -- Relocated from Garja's ARKANSAS (1v1, TEAM, FFA)
// designed by Garja
//visual update and resource addition by Durokan & Interjection for DE
// February 2021 edited by vividlyplain, updated May 2021
// LARGE version by vividlyplain, July 2021

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
	
	// ************************************** GENERAL FEATURES *****************************************
	
	// Picks the map size
	int playerTiles=22000; //12000
		if (PlayerNum >= 4 && TeamNum == 2)
			playerTiles = 20000;
		if (PlayerNum >= 6 && TeamNum == 2)
			playerTiles = 18000;		
	int size=2.0*sqrt(PlayerNum*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
//	rmSetWorldCircleConstraint(false);
	
	
	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 4, 0.5, 4.5); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetSeaType("bayou");
//	rmEnableLocalWater(false);
	rmSetBaseTerrainMix("deccan_grass_a"); // nwt_forest
	rmTerrainInitialize("new_england\ground1_ne", 3.0); // NWterritory\ground_grass5_nwt
	rmSetMapType("punjab"); 
	rmSetMapType("grass");
	rmSetMapType("land");
	rmSetLightingSet("Punjab_Skirmish"); 
    //deccan grass a
    //deccan grass b
    //
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	subCiv0 = rmGetCivID("Cherokee");
	subCiv1 = rmGetCivID("Seminoles");
	subCiv2 = rmGetCivID("Udasi");
	rmSetSubCiv(0, "Cherokee");
	rmSetSubCiv(1, "Seminoles");
	rmSetSubCiv(2, "Udasi");
//	rmEchoInfo("subCiv0 is Cherokee "+subCiv0);
//	rmEchoInfo("subCiv1 is Seminoles "+subCiv1);
//	string nativeName0 = "native Cherokee village";
//	string nativeName1 = "native Seminoles village";
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classWaterStone = rmDefineClass("stonewater");
	int classGrass = rmDefineClass("grass");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************

	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int Southeastconstraint = rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(180));
	int Northwestconstraint = rmCreatePieConstraint("northwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(360));
	int Southwestconstraint = rmCreatePieConstraint("southwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(180), rmDegreesToRadians(270));
	int Northeastconstraint = rmCreatePieConstraint("northeastMapConstraint", 0.39, 0.39, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(90));
	int Southnarrowconstraint = rmCreatePieConstraint("SouthstripConstraint", 0.5, 0.5, rmZFractionToMeters(0.15), rmZFractionToMeters(0.50), rmDegreesToRadians(160), rmDegreesToRadians(195));
	int Northnarrowconstraint = rmCreatePieConstraint("NorthstripConstraint", 0.5, 0.5, rmZFractionToMeters(0.15), rmZFractionToMeters(0.50), rmDegreesToRadians(355), rmDegreesToRadians(20));
	
	int Southeastsideconstraint = rmCreatePieConstraint("southeastsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(90), rmDegreesToRadians(180));
	int Northwestsideconstraint = rmCreatePieConstraint("northwestsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(270), rmDegreesToRadians(360));
	int Southwestsideconstraint = rmCreatePieConstraint("southwestsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(180), rmDegreesToRadians(270));
	int Northeastsideconstraint = rmCreatePieConstraint("northeastsideConstraint", 0.5, 0.5, rmXFractionToMeters(0.32), rmXFractionToMeters(0.50), rmDegreesToRadians(0), rmDegreesToRadians(90));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.46), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.4,0.4,rmXFractionToMeters(0.24), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.4,0.4,rmXFractionToMeters(0.0), rmXFractionToMeters(0.14), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEastclose = rmCreatePieConstraint("Stay East Close", 0.5, 0.5, rmZFractionToMeters(0.38), rmZFractionToMeters(0.50), rmDegreesToRadians(45), rmDegreesToRadians(135));
	int stayEastveryclose = rmCreatePieConstraint("Stay East Closer", 0.9, 0.5, 0.0, rmZFractionToMeters(0.12), rmDegreesToRadians(180), rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int northEdge = rmCreatePieConstraint("North Edge",0.70,0.70,rmXFractionToMeters(0.2), rmXFractionToMeters(0.30), rmDegreesToRadians(0),rmDegreesToRadians(90)); 
//	int avoidWesthalf = rmCreateAreaDistanceConstraint("avoid west", WestID, 185.0); 
	int staySouthHalf = rmCreatePieConstraint("SouthHalfConstraint", 0.59, 0.59, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int stayNorthHalf = rmCreatePieConstraint("NorthHalfConstraint", 0.61, 0.61, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int staySouthWest = rmCreatePieConstraint("SouthWestConstraint", 0.37, 0.37, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(235), rmDegreesToRadians(30));
	int staySouthEast = rmCreatePieConstraint("SouthEastConstraint", 0.37, 0.37, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(60), rmDegreesToRadians(215));
	int stayNorthWest = rmCreatePieConstraint("NorthWestConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(315), rmDegreesToRadians(5));
	int stayNorthEast = rmCreatePieConstraint("NorthEastConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(85), rmDegreesToRadians(135));
	int stayNorthMiddle = rmCreatePieConstraint("NorthMiddleConstraint", 0.50, 0.50, 0.0, rmZFractionToMeters(0.60), rmDegreesToRadians(22), rmDegreesToRadians(68));
	
	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 55.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 40.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 22.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 5.0);
	int avoidTurkey = rmCreateTypeDistanceConstraint("food avoids food", "ypNilgai", 28.0);
	int avoidTurketShort = rmCreateTypeDistanceConstraint("food avoids food short", "ypNilgai", 24.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid berries ", "berrybush", 70.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min ", "berrybush", 10.0);
	int avoidypNilgaiFar = rmCreateTypeDistanceConstraint("avoid ypNilgai far", "ypNilgai", 54.0);
	int avoidypNilgai = rmCreateTypeDistanceConstraint("avoid  ypNilgai", "ypNilgai", 52.0);
	int avoidypNilgaiShort = rmCreateTypeDistanceConstraint("avoid  ypNilgai short", "ypNilgai", 40.0);
	int avoidypNilgaiMin = rmCreateTypeDistanceConstraint("avoid ypNilgai min", "ypNilgai", 10.0);
	int avoidElk = rmCreateTypeDistanceConstraint("elk avoids elk", "deer", 65.0);
	int avoidElkShort = rmCreateTypeDistanceConstraint("elk avoids elk short", "deer", 28.0);
	int avoidElkMin = rmCreateTypeDistanceConstraint("elk avoids elk min", "deer", 10.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 15.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far", "gold", 36.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("avoid gold min", classGold, 4.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("avoid gold med", "gold", 10.0);
	int avoidGold = rmCreateClassDistanceConstraint ("avoid gold", classGold, 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("avoid gold far", classGold, 90.0); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 82.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 55.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 75.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 70.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 50.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 44.0);
	//	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 40.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 24.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesMin = rmCreateClassDistanceConstraint("stuff avoids natives min", classNative, 2.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 8.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 5.0);
	

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 10.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 25.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 5.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", rmClassID("patch2"), 20.0);
	int avoidStone = rmCreateClassDistanceConstraint("stone avoid stone", rmClassID("stonewater"), 5.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 5.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid class cliff", rmClassID("Cliffs"), 7.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid class cliff far", rmClassID("Cliffs"), 12.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
		
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 6.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 8.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
   
	
	// ***********************************************************************************************
	
	// **************************************** PLACE PLAYERS ****************************************

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
    
		if (cNumberTeams <= 2) // 1v1 and TEAM
		{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if ( OneVOnePlacement < 0.5)
				{
					rmPlacePlayer(1, 0.66, 0.20);
					rmPlacePlayer(2, 0.20, 0.66);
				}
				else
				{
					rmPlacePlayer(2, 0.66, 0.20);
					rmPlacePlayer(1, 0.20, 0.66);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.23, 0.75, 0.14, 0.58, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.75, 0.23, 0.58, 0.14, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.21, 0.67, 0.20, 0.66, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.75, 0.23, 0.58, 0.14, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.80, 0.30, 0.50, 0.10, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.67, 0.21, 0.66, 0.20, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.23, 0.75, 0.14, 0.58, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.30, 0.80, 0.10, 0.50, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.23, 0.75, 0.14, 0.58, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.75, 0.23, 0.58, 0.14, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.25, 0.78, 0.10, 0.52, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.78, 0.25, 0.52, 0.10, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
			rmSetTeamSpacingModifier(0.25);
			rmSetPlacementSection(0.375, 0.875);
			rmPlacePlayersCircular(0.40, 0.40, 0.0);
		}

	
	// **************************************************************************************************

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.01;

		if (randLoc == 2) {
			xLoc = 0.75;
			yLoc = 0.75;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}
	
	// ****************************************** TRADE ROUTE **********************************************
	
	
	int tradeRouteID = rmCreateTradeRoute();
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);

	
	if (TeamNum <= 2) 
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.48, 0.00);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.24, 0.24);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.00, 0.48); 
	}
	else
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.98, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.74, 0.74);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.98); 
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "water");
//	if(placedTradeRouteA == false)
//	rmEchoError("Failed to place trade route 1");
//	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	if (PlayerNum > 4){
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.28);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    }
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	if (PlayerNum > 4){
		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.72);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
    }
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	
	// *************************************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);

	// ******************************************** NATURE DESIGN **************************************************
    
	//River
	int riverID = rmRiverCreate(-1, "Punjab River", 11+0.5*PlayerNum, 14, 4+PlayerNum/2, 4+PlayerNum/2); //  (-1, "new england lake", 18, 14, 5, 5)
	rmRiverAddWaypoint(riverID, 0.15, 1.00); 
	rmRiverAddWaypoint(riverID, 0.62, 0.62); 
	rmRiverAddWaypoint(riverID, 1.00, 0.15);
	rmRiverSetBankNoiseParams(riverID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(riverID, 38);
	rmRiverAddShallow(riverID, 0.0);
	rmRiverAddShallow(riverID, 0.2);
	rmRiverAddShallow(riverID, 0.4);
	rmRiverAddShallow(riverID, 0.6);
	rmRiverAddShallow(riverID, 0.8);
	rmRiverAddShallow(riverID, 1.0);
	rmRiverBuild(riverID);
	
	// Cliff
	int classAvoidance = rmDefineClass("avoidance");

	int avoidTHisID=rmCreateArea("avoid this island");
	rmSetAreaSize(avoidTHisID, 0.10);
	rmSetAreaLocation(avoidTHisID, 0.40, 0.40);
	rmAddAreaInfluenceSegment(avoidTHisID, 0.10, 0.70, 0.70, 0.10);
	rmAddAreaInfluenceSegment(avoidTHisID, 0.15, 0.65, 0.50, 0.90);
	rmAddAreaInfluenceSegment(avoidTHisID, 0.65, 0.15, 0.90, 0.50);
	if (PlayerNum > 4)
	{
		rmAddAreaInfluenceSegment(avoidTHisID, 0.65, 0.15, 0.99, 0.33);
		rmAddAreaInfluenceSegment(avoidTHisID, 0.15, 0.65, 0.33, 0.99);
		rmAddAreaInfluenceSegment(avoidTHisID, 0.35, 0.45, 0.65, 0.80);
		rmAddAreaInfluenceSegment(avoidTHisID, 0.45, 0.35, 0.80, 0.65);
	}
	else
		rmAddAreaInfluenceSegment(avoidTHisID, 0.40, 0.40, 0.70, 0.70);
	rmAddAreaToClass(avoidTHisID, classAvoidance);
//	rmSetAreaMix(avoidTHisID, "testmix");		// for testing
	rmSetAreaCoherence(avoidTHisID, 1.00);
	rmBuildArea(avoidTHisID); 

	int cliffID = rmCreateArea("cliff");
//	rmSetAreaSize(cliffID, 0.13, 0.13); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaSize(cliffID, 0.40, 0.40);
	rmSetAreaWarnFailure(cliffID, false);
    
	rmSetAreaObeyWorldCircleConstraint(cliffID, false);
	rmSetAreaCliffType(cliffID, "californiacoast"); // new england inland grass
	rmSetAreaCliffPainting(cliffID, true, true, true, 0.5 , false); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	rmSetAreaCliffHeight(cliffID, 6, 0.0, 0.8); 
//	if (PlayerNum > 4)
//		rmSetAreaCliffEdge(cliffID, 7, 0.065, 0.0, 0.30, 1); //0.30
//	else
		rmSetAreaCliffEdge(cliffID, 1, 1.00, 0.0, 0.30, 0); //0.30
//	rmSetAreaCliffEdge(cliffID, 1, 0.50, 0.0, 0.50, 2);
	rmAddAreaCliffEdgeAvoidClass(cliffID, classAvoidance, 5);
	rmSetAreaCoherence(cliffID, 1.0);
	rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
	rmAddAreaConstraint(cliffID, avoidWaterShort);
	rmAddAreaConstraint(cliffID, avoidImpassableLand);
//	rmAddAreaConstraint(cliffID, stayNearWater);
	rmSetAreaLocation(cliffID, 0.90, 0.90);
//	rmSetAreaBaseHeight(cliffID, 6);
	rmSetAreaHeightBlend(cliffID, 1.0);
		rmSetAreaTerrainType(cliffID, "california\fakecalifgrassmix_cal");
//    rmSetAreaMix(cliffID, "california_grass");
    
	int avoidCliffShort = rmCreateAreaDistanceConstraint("avoid cliff short", cliffID, 5.0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid ramp", cliffID, 18.0);
	int avoidRampShort = rmCreateCliffRampDistanceConstraint("avoid ramp short", cliffID, 10.0);

	rmBuildArea(cliffID);
    
    int avoidWaterP = rmCreateTerrainDistanceConstraint("avoid waterP ", "water", true, 7);
	int stayCliff = rmCreateAreaMaxDistanceConstraint("stay in cliff", cliffID, 0);

	// Plateau
	int plateauID = rmCreateArea("plateau");
	rmSetAreaSize(plateauID, 0.40, 0.40); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaWarnFailure(plateauID, false);
	rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	rmSetAreaCoherence(plateauID, 1.0);
	rmSetAreaLocation (plateauID, 0.90, 0.90);
    rmAddAreaConstraint (plateauID, avoidWaterP);
    rmSetAreaMix(plateauID, "california_grass");
//	rmBuildArea(plateauID);
    
	// Plateau Patches 
	for (i=0; < 12*PlayerNum)
    {
        int patch1ID = rmCreateArea("plateau yellow patch"+i);
        rmSetAreaWarnFailure(patch1ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch1ID, false);
        rmSetAreaSize(patch1ID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
		rmSetAreaTerrainType(patch1ID, "california\ground9_cal");
        rmAddAreaToClass(patch1ID, rmClassID("patch"));
        rmSetAreaMinBlobs(patch1ID, 1);
        rmSetAreaMaxBlobs(patch1ID, 5);
        rmSetAreaMinBlobDistance(patch1ID, 16.0);
        rmSetAreaMaxBlobDistance(patch1ID, 40.0);
        rmSetAreaCoherence(patch1ID, 0.0);
		rmAddAreaConstraint(patch1ID, avoidPatch);
		rmAddAreaConstraint(patch1ID, stayCliff);
        rmBuildArea(patch1ID); 
    }
	
	for (i=0; < 12*PlayerNum)
    {
        int patch2ID = rmCreateArea("plateau white patch"+i);
        rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(25));
		rmSetAreaTerrainType(patch2ID, "california\ground_clifftop_cal");
        rmAddAreaToClass(patch2ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, stayCliff);
        rmBuildArea(patch2ID); 
    }    
    
    int northDesert = rmCreateArea("northDesert");
	rmSetAreaSize(northDesert, 0.1, 0.1); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaWarnFailure(northDesert, false);
    rmSetAreaLocation (northDesert, 0.52, 0.0);
    rmAddAreaInfluenceSegment(northDesert, 0.52, 0.0, .0, .52);
	rmSetAreaObeyWorldCircleConstraint(northDesert, false);
	rmSetAreaCoherence(northDesert, .6);
    rmSetAreaMix(northDesert, "deccan_grass_b");
	rmBuildArea(northDesert);
    
    /*
    int northDesertLow = rmCreateArea("northDesertLow");
	rmSetAreaSize(northDesertLow, 0.1, 0.1); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
	rmSetAreaWarnFailure(northDesertLow, false);
    rmSetAreaLocation (northDesertLow, 0.45, 0.0);
    rmAddAreaInfluenceSegment(northDesertLow, 0.45, 0.0, .0, .45);
	rmSetAreaObeyWorldCircleConstraint(northDesertLow, false);
	rmSetAreaCoherence(northDesertLow, .6);
    rmSetAreaMix(northDesertLow, "deccan_grassy_dirt_a");
	rmBuildArea(northDesertLow);*/
    
    /*
    if (TeamNum <=2){
        int desertAvoidTR = rmCreateTradeRouteDistanceConstraint("desertAvoidTR", 0.1);
        int southDesert = rmCreateArea("southDesert");
        rmSetAreaSize(southDesert, 0.3, 0.3); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
        rmSetAreaWarnFailure(southDesert, false);
        rmSetAreaObeyWorldCircleConstraint(southDesert, false);
        rmSetAreaCoherence(southDesert, 1.0);
        rmSetAreaLocation (southDesert, 0.0, 0.0);
        rmAddAreaConstraint (southDesert, desertAvoidTR);
        rmSetAreaMix(southDesert, "deccan_grassy_dirt_a");
        rmBuildArea(southDesert);
	}else{*/
        int southDesert2 = rmCreateArea("southDesert2");
        rmSetAreaSize(southDesert2, 0.1, 0.1); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));  
        rmSetAreaWarnFailure(southDesert2, false);
        rmSetAreaLocation (southDesert2, 0.325, 0.0);
        rmAddAreaInfluenceSegment(southDesert2, 0.325, 0.0, .0, .325);
        rmSetAreaObeyWorldCircleConstraint(southDesert2, false);
        rmSetAreaCoherence(southDesert2, .65);
        rmSetAreaMix(southDesert2, "deccan_grassy_dirt_a");
        rmBuildArea(southDesert2);
   // }
    
    /*
	// Small cliff bottom
	int smallCliffID = rmCreateArea("small cliff");
	rmSetAreaSize(smallCliffID, rmAreaTilesToFraction(90+10*PlayerNum), rmAreaTilesToFraction(100+10*PlayerNum));
	rmSetAreaLocation (smallCliffID, 0.33, 0.33);
	rmSetAreaWarnFailure(smallCliffID, false);
	rmSetAreaObeyWorldCircleConstraint(smallCliffID, false);
	rmSetAreaCoherence(smallCliffID, 0.30);
	rmSetAreaSmoothDistance(smallCliffID, 3+1*PlayerNum);
	rmSetAreaCliffType(smallCliffID, "new england inland grass"); 
//	rmSetAreaTerrainType(smallCliffID, "new_england\cliff_inland_top_ne");
	rmSetAreaCliffEdge(smallCliffID, 1, 1.0, 0.0, 0.0, 0);
	rmSetAreaCliffHeight(smallCliffID, 5.5, 0.0, 1.0);
//	rmSetAreaCliffPainting(smallCliffID, false, false, true);
	rmAddAreaToClass(smallCliffID, rmClassID("Cliffs"));
	rmAddAreaConstraint(smallCliffID, avoidImpassableLand);
	rmAddAreaConstraint(smallCliffID, avoidTradeRoute);
	rmAddAreaConstraint(smallCliffID, avoidTradeRouteSocket);
	if (TeamNum <= 2)
		rmBuildArea(smallCliffID);
    */
	
	// Water stones
	for (i=0; < 12*PlayerNum) // 12
	{
		int StoneID = rmCreateObjectDef("water stone"+i);
		rmAddObjectDefItem(StoneID, "RiverPropsNWTerritory", rmRandInt(2,4), 4.0); 
		rmSetObjectDefMinDistance(StoneID, 0);
		rmSetObjectDefMaxDistance(StoneID, rmXFractionToMeters(0.35));
		rmAddObjectDefToClass(StoneID, rmClassID("stonewater"));
		rmAddObjectDefConstraint(StoneID, avoidStone);
		rmAddObjectDefConstraint(StoneID, stayInWater);
		rmPlaceObjectDefAtLoc(StoneID, 0, 0.60, 0.60);
	}

	// Invisible Island - added by vividlyplain
	int bigTID = rmCreateArea("big T");
	rmSetAreaLocation(bigTID, 0.60, 0.60);
	rmAddAreaInfluenceSegment(bigTID, 0.60, 0.60, 0.20, 0.20);	
	rmAddAreaInfluenceSegment(bigTID, 0.05, 0.35, 0.35, 0.05);	
	rmSetAreaWarnFailure(bigTID, false);
	rmSetAreaSize(bigTID, 0.025, 0.025);
	rmSetAreaCoherence(bigTID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(bigTID, false);
//	rmSetAreaMix(bigTID, "testmix");   // for testing
	rmBuildArea(bigTID); 
	
	int avoidBigTMin = rmCreateAreaDistanceConstraint("avoid big T min", bigTID, 0.5);
	int avoidBigT = rmCreateAreaDistanceConstraint("avoid big T", bigTID, 13.0);
	int avoidBigTFar = rmCreateAreaDistanceConstraint("avoid big T far", bigTID, 20.0);
	int stayBigT = rmCreateAreaMaxDistanceConstraint("stay in big T", bigTID, 0.0);


	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.30);
	
	// ******************************************** NATIVES *************************************************
	
	
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	nativeID0 = rmCreateGrouping("Udasi village 1", "native udasi village "+5); // NW
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
	rmAddGroupingToClass(nativeID0, classNative);
//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID0, avoidNatives);
		
	nativeID2 = rmCreateGrouping("Udasi village 2", "native udasi village "+2); // NE
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, classNative);
//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID2, avoidNatives);
	
	nativeID1 = rmCreateGrouping("Udasi village 3", "native udasi village "+4); // SW
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, classNative);
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);
		
	nativeID3 = rmCreateGrouping("Udasi village 4", "native udasi village "+1); // SE
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, classNative);
//  rmAddGroupingToClass(nativeID3, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID3, avoidNatives);
		
	if (TeamNum <= 2) 
	{
		if (teamZeroCount < 2 && teamOneCount < 2)
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.64, 0.86); // NW
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.86, 0.64); // NE
//			rmPlaceGroupingAtLoc(nativeID1, 0, 0.26, 0.42); // SW
//			rmPlaceGroupingAtLoc(nativeID3, 0, 0.42, 0.26); // SE
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.64, 0.84); // NW
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.84, 0.64); // NE
//			rmPlaceGroupingAtLoc(nativeID1, 0, 0.26, 0.42); // SW
//			rmPlaceGroupingAtLoc(nativeID3, 0, 0.42, 0.26); // SE
		}
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.40, 0.60); // NW
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.60, 0.40); // NE
//		rmPlaceGroupingAtLoc(nativeID1, 0, 0.26, 0.42); // SW
//		rmPlaceGroupingAtLoc(nativeID3, 0, 0.42, 0.26); // SE
	}

	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.40);
	
	// ************************************ PLAYER STARTING RESOURCES ***************************************

	// ******** Define ********

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
    
	if(cNumberNonGaiaPlayers>4){
        rmSetObjectDefMaxDistance(TCID, 0.0);
    }
    int teamZeroCount_dk = rmGetNumberPlayersOnTeam(0);
    int teamOneCount_dk = rmGetNumberPlayersOnTeam(1);
    if((cNumberTeams == 2) && (teamZeroCount_dk != teamOneCount_dk)){
        rmSetObjectDefMaxDistance(TCID, 10.0);
    }
    
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 14.0);
	rmSetObjectDefMaxDistance(playergoldID, 16.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
    int mangoes = rmCreateObjectDef("mangoes");
	rmAddObjectDefItem(mangoes, "ypGroveWagon", 1, 1);
	rmSetObjectDefMinDistance(mangoes, 11.0);
	rmSetObjectDefMaxDistance(mangoes, 15.0);
	rmAddObjectDefToClass(mangoes, classStartingResource);
	rmAddObjectDefConstraint(mangoes, avoidImpassableLand);
	rmAddObjectDefConstraint(mangoes, avoidNatives);
	rmAddObjectDefConstraint(mangoes, avoidStartingResources);
    
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 30.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 32.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidCenter);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 3, 3.0);
	rmSetObjectDefMinDistance(playerberriesID, 12.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	
	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
//  rmAddObjectDefItem(playerTreeID, "ypTreeDeccan", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem(playerTreeID, "TreeCarolinaGrass", 3, 4.0); //6,6 5.0
	rmAddObjectDefItem(playerTreeID, "ypTreeGinkgo", 2, 4.0); //6,6 5.0
	rmAddObjectDefItem(playerTreeID, "ypTreeDeccan", 3, 4.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTreeID, 18);
    rmSetObjectDefMaxDistance(playerTreeID, 20);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
	rmAddObjectDefConstraint(playerTreeID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
//  rmAddObjectDefItem(playerTree2ID, "ypTreeDeccan", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem(playerTree2ID, "TreeCarolinaGrass", 2, 4.0); //6,6 5.0
	rmAddObjectDefItem(playerTree2ID, "ypTreeDeccan", 2, 4.0); //6,6 5.0
    rmSetObjectDefMinDistance(playerTree2ID, 12);
    rmSetObjectDefMaxDistance(playerTree2ID, 14);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerturkeyID = rmCreateObjectDef("starting turkey");
	rmAddObjectDefItem(playerturkeyID, "ypNilgai", rmRandInt(6,6), 5.0);
	rmSetObjectDefMinDistance(playerturkeyID, 14.0);
	rmSetObjectDefMaxDistance(playerturkeyID, 16.0);
	rmSetObjectDefCreateHerd(playerturkeyID, true);
	rmAddObjectDefToClass(playerturkeyID, classStartingResource);
	rmAddObjectDefConstraint(playerturkeyID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerturkeyID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerturkeyID, avoidNatives);
	rmAddObjectDefConstraint(playerturkeyID, avoidStartingResources);
		
	// 2nd herd
	int playerypNilgaiID = rmCreateObjectDef("player ypNilgai");
    rmAddObjectDefItem(playerypNilgaiID, "ypNilgai", rmRandInt(9,9), 7.0);
    rmSetObjectDefMinDistance(playerypNilgaiID, 26);
    rmSetObjectDefMaxDistance(playerypNilgaiID, 28);
	rmAddObjectDefToClass(playerypNilgaiID, classStartingResource);
	rmSetObjectDefCreateHerd(playerypNilgaiID, true);
	rmAddObjectDefConstraint(playerypNilgaiID, avoidTurkey); //Short
	rmAddObjectDefConstraint(playerypNilgaiID, avoidTradeRoute);
//	rmAddObjectDefConstraint(playerypNilgaiID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerypNilgaiID, avoidNatives);
	rmAddObjectDefConstraint(playerypNilgaiID, avoidStartingResources);
	
/*	// 3rd herd
	int playerypNilgai2ID = rmCreateObjectDef("player ypNilgai2");
    rmAddObjectDefItem(playerypNilgai2ID, "ypNilgai", rmRandInt(8,8), 6.0);
    rmSetObjectDefMinDistance(playerypNilgai2ID, 28);
    rmSetObjectDefMaxDistance(playerypNilgai2ID, 34);
	rmAddObjectDefToClass(playerypNilgai2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerypNilgai2ID, true);
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidTurkey); //Short
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidypNilgaiShort);
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidCliffShort);
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidTradeRouteShort);
//	rmAddObjectDefConstraint(playerypNilgai2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidNatives);
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerypNilgai2ID, avoidEdge);
*/
	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
//	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2);
		
	// ******** Place ********
	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerturkeyID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerypNilgaiID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerypNilgai2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(mangoes, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
	// ************************************** COMMON RESOURCES ****************************************
    
   
	// ********** Mines ***********
	
		int southgoldCount = 2*PlayerNum;  // 3,3 
		int northgoldCount = 2+1*PlayerNum;  // 3,3 
	
	//South mines
	for(i=0; < southgoldCount)
	{
		int southgoldID = rmCreateObjectDef("gold south half"+i);
		rmAddObjectDefItem(southgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(southgoldID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(southgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(southgoldID, classGold);
		rmAddObjectDefConstraint(southgoldID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(southgoldID, avoidImpassableLand);
		rmAddObjectDefConstraint(southgoldID, avoidNatives);
		rmAddObjectDefConstraint(southgoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(southgoldID, avoidGoldVeryFar);
		rmAddObjectDefConstraint(southgoldID, staySouthHalf);
		rmAddObjectDefConstraint(southgoldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(southgoldID, avoidEdge);
		rmAddObjectDefConstraint(southgoldID, avoidCliffFar);
		if (PlayerNum == 2)
			rmAddObjectDefConstraint(southgoldID, stayBigT);
		if (TeamNum <= 2 && teamZeroCount == 1 && teamOneCount == 1)
		{
			if (i == 0)
				rmAddObjectDefConstraint(southgoldID, staySouthWest);
			else if (i == 1)
				rmAddObjectDefConstraint(southgoldID, staySouthEast);
		}
		rmPlaceObjectDefAtLoc(southgoldID, 0, 0.28, 0.28);
	}
	
	//North mines
	for(i=0; < northgoldCount)
	{
		int northgoldID = rmCreateObjectDef("gold north half"+i);
		rmAddObjectDefItem(northgoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(northgoldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(northgoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(northgoldID, classGold);
		rmAddObjectDefConstraint(northgoldID, avoidTradeRoute);
		rmAddObjectDefConstraint(northgoldID, avoidImpassableLandMed);
		rmAddObjectDefConstraint(northgoldID, avoidNatives);
		rmAddObjectDefConstraint(northgoldID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(northgoldID, avoidGoldFar);
		rmAddObjectDefConstraint(northgoldID, avoidWater);
//		rmAddObjectDefConstraint(northgoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(northgoldID, avoidRamp);
		rmAddObjectDefConstraint(northgoldID, avoidEdge);
		rmAddObjectDefConstraint(northgoldID, stayNorthHalf);
		if (TeamNum <= 2 && teamZeroCount == 1 && teamOneCount == 1)
		{
			if (i == 0)
				rmAddObjectDefConstraint(northgoldID, stayNorthWest);
			else if (i == 1)
				rmAddObjectDefConstraint(northgoldID, stayNorthEast);
			else
				rmAddObjectDefConstraint(northgoldID, stayNorthMiddle);
		}
		rmPlaceObjectDefAtLoc(northgoldID, 0, 0.66, 0.66);
	}
		
	// ****************************
	
	// Text
	rmSetStatusText("",0.60);
	
		// ********** Forest **********
	
	// South forest
	int southforestcount = 4+5*PlayerNum; // 14*PlayerNum/2
	int stayInSouthForest = -1;
	
	for (i=0; < southforestcount)
	{
		int southforestID = rmCreateArea("south forest"+i);
		rmSetAreaWarnFailure(southforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(southforestID, false);
		rmSetAreaSize(southforestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(130));
//		rmSetAreaTerrainType(southforestID, "pampas\groundforest_pam");
		rmSetAreaCoherence(southforestID, 0.1);
//		rmAddAreaToClass(southforestID, classForest);
		rmAddAreaConstraint(southforestID, avoidForest);
		rmAddAreaConstraint(southforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(southforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(southforestID, avoidNatives);
		rmAddAreaConstraint(southforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(southforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(southforestID, staySouthHalf);
//		rmAddAreaConstraint(southforestID, avoidEdge);
		rmAddAreaConstraint(southforestID, avoidTownCenterShort);
		rmAddAreaConstraint(southforestID, avoidStartingResourcesShort);
		rmAddAreaConstraint(southforestID, avoidypNilgaiMin); 
		rmAddAreaConstraint(southforestID, avoidNuggetMin);
		rmAddAreaConstraint(southforestID, avoidCliff);
		rmBuildArea(southforestID);
	
		stayInSouthForest = rmCreateAreaMaxDistanceConstraint("stay in south forest"+i, southforestID, 0);
	
			int southtreeID = rmCreateObjectDef("south tree"+i);
			rmAddObjectDefItem(southtreeID, "TreeCarolinaGrass", 1, 4.0); // 1,2
			rmAddObjectDefItem(southtreeID, "ypTreeDeccan", 1, 4.0); // 1,2
			rmAddObjectDefItem(southtreeID, "ypTreeGinkgo", 1, 4.0); // 1,2
			rmSetObjectDefMinDistance(southtreeID, 0);
			rmSetObjectDefMaxDistance(southtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(southtreeID, classForest);
			rmAddObjectDefConstraint(southtreeID, stayInSouthForest);	
			rmAddObjectDefConstraint(southtreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(southtreeID, 0, 0.40, 0.40, 11);
	}
	
	// North forest
	int northforestcount = 2.5*PlayerNum; // 6
	int stayInNorthForest = -1;
	
	for (i=0; < northforestcount)
	{
		int northforestID = rmCreateArea("north forest"+i);
		rmSetAreaWarnFailure(northforestID, false);
//		rmSetAreaObeyWorldCircleConstraint(northforestID, false);
		rmSetAreaSize(northforestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(110));
//		rmSetAreaTerrainType(northforestID, "pampas\groundforest_pam");
		rmSetAreaCoherence(northforestID, 0.1);
//		rmAddAreaToClass(northforestID, classForest);
		rmAddAreaConstraint(northforestID, avoidForest);
		rmAddAreaConstraint(northforestID, avoidTradeRouteShort);
		rmAddAreaConstraint(northforestID, avoidImpassableLandShort);
		rmAddAreaConstraint(northforestID, avoidNativesShort);
		rmAddAreaConstraint(northforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(northforestID, avoidGoldTypeShort);
		rmAddAreaConstraint(northforestID, stayNorthHalf);
		rmAddAreaConstraint(northforestID, avoidRamp); 
//		rmAddAreaConstraint(northforestID, avoidEdge);
		rmAddAreaConstraint(northforestID, avoidTownCenterShort);
		rmAddAreaConstraint(northforestID, avoidStartingResources);
		rmAddAreaConstraint(northforestID, avoidypNilgaiMin); 
		rmBuildArea(northforestID);
	
		stayInNorthForest = rmCreateAreaMaxDistanceConstraint("stay in north forest"+i, northforestID, 0);
	
			int northtreeID = rmCreateObjectDef("north tree"+i);
			rmAddObjectDefItem(northtreeID, "TreeCarolinaGrass", 1, 4.0); // 1,2
			rmAddObjectDefItem(northtreeID, "ypTreeDeccan", 1, 4.0); // 1,2
			rmAddObjectDefItem(northtreeID, "ypTreeGinkgo", 1, 4.0); // 1,2
			rmSetObjectDefMinDistance(northtreeID, 0);
			rmSetObjectDefMaxDistance(northtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID, classForest);
			rmAddObjectDefConstraint(northtreeID, stayInNorthForest);	
			rmAddObjectDefConstraint(northtreeID, avoidImpassableLandShort);	
			rmPlaceObjectDefAtLoc(northtreeID, 0, 0.40, 0.40, 9);		
	}
		
	// ********************************
	
	// Text
	rmSetStatusText("",0.70);
	
	// *********** Berries ************	
	
	//North berries
	int northberryID = rmCreateObjectDef("north berry");
		rmAddObjectDefItem(northberryID, "berrybush", 5, 9.0);
//		if (teamZeroCount == 1 && teamOneCount == 1)
			rmSetObjectDefMinDistance(northberryID, rmXFractionToMeters(0.18));
//		else
//			rmSetObjectDefMinDistance(northberryID, rmXFractionToMeters(0.10));
		rmSetObjectDefMaxDistance(northberryID, rmXFractionToMeters(0.7));
		rmAddObjectDefConstraint(northberryID, avoidImpassableLand);
		rmAddObjectDefConstraint(northberryID, avoidNatives);
		rmAddObjectDefConstraint(northberryID, avoidGoldType);
		rmAddObjectDefConstraint(northberryID, stayNorthHalf);
		rmAddObjectDefConstraint(northberryID, avoidForestMin);
//		rmAddObjectDefConstraint(northberryID, avoidElkMin); 
		rmAddObjectDefConstraint(northberryID, avoidBerries);
		rmAddObjectDefConstraint(northberryID, avoidRamp);
		rmAddObjectDefConstraint(northberryID, avoidEdge);
		rmPlaceObjectDefAtLoc(northberryID, 0, 0.75, 0.75, 2*PlayerNum);
	
	// ********************************
		
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Random trees to fill **********
	
	// Random trees
	int randomforestcount = (8*PlayerNum/2-PlayerNum); 

	int RandomtreeID = rmCreateObjectDef("random trees");
		rmAddObjectDefItem(RandomtreeID, "TreeCarolinaGrass", rmRandInt(7,8), 6.0); // 4,5
		rmSetObjectDefMinDistance(RandomtreeID, 0);
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidNatives);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidRamp);
		rmAddObjectDefConstraint(RandomtreeID, avoidTownCenterResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(RandomtreeID, avoidypNilgaiMin); 
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidElkMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidBerriesMin);
		rmAddObjectDefConstraint(RandomtreeID, avoidForest);	
//		rmAddObjectDefConstraint(RandomtreeID, avoidCliff);
//		rmAddObjectDefConstraint(RandomtreeID, avoidEdge);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5, randomforestcount);
	
	// ********************************

	// ********** Herds ***********

	//South ypNilgais
	if (PlayerNum == 2) {
		int staticherdID = rmCreateObjectDef("static herd");
		rmAddObjectDefItem(staticherdID, "ypNilgai", 9, 5.0);
		rmSetObjectDefMinDistance(staticherdID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherdID, rmXFractionToMeters(0.025));
		rmSetObjectDefCreateHerd(staticherdID, true);
		rmPlaceObjectDefAtLoc(staticherdID, 0, 0.83, 0.33);
		rmPlaceObjectDefAtLoc(staticherdID, 0, 0.33, 0.83);
	
		int staticherd2ID = rmCreateObjectDef("static herd2");
		rmAddObjectDefItem(staticherd2ID, "ypNilgai", 9, 5.0);
		rmSetObjectDefMinDistance(staticherd2ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherd2ID, rmXFractionToMeters(0.20));
		rmSetObjectDefCreateHerd(staticherd2ID, true);
		rmAddObjectDefConstraint(staticherd2ID, stayBigT);
		rmAddObjectDefConstraint(staticherd2ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(staticherd2ID, avoidGoldMin);
		rmAddObjectDefConstraint(staticherd2ID, avoidTownCenter);
		rmAddObjectDefConstraint(staticherd2ID, avoidForestMin);
		rmAddObjectDefConstraint(staticherd2ID, avoidypNilgai); 
		rmPlaceObjectDefAtLoc(staticherd2ID, 0, 0.30, 0.30, 2);

		int staticherd3ID = rmCreateObjectDef("static herd3");
		rmAddObjectDefItem(staticherd3ID, "ypNilgai", 9, 5.0);
		rmSetObjectDefMinDistance(staticherd3ID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(staticherd3ID, rmXFractionToMeters(0.05));
		rmSetObjectDefCreateHerd(staticherd3ID, true);
		rmAddObjectDefConstraint(staticherd3ID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(staticherd3ID, avoidTownCenter);
		rmAddObjectDefConstraint(staticherd3ID, avoidForestMin);
		rmAddObjectDefConstraint(staticherd3ID, avoidEdge);
		rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.45, 0.05);
		rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.05, 0.45);
		rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.45, 0.60);
		rmPlaceObjectDefAtLoc(staticherd3ID, 0, 0.60, 0.45);
		
	}
	else {
		int south1v1Nilgaicount = 4*PlayerNum;

		for(i=0; < south1v1Nilgaicount)
		{
			int south1v1NilgaiID = rmCreateObjectDef("south 1v1 Nilgai"+i);
			rmAddObjectDefItem(south1v1NilgaiID, "ypNilgai", rmRandInt(9,9), 7.0);
			rmSetObjectDefMinDistance(south1v1NilgaiID, 0.0);
			rmSetObjectDefMaxDistance(south1v1NilgaiID, rmXFractionToMeters(0.5));
			rmSetObjectDefCreateHerd(south1v1NilgaiID, true);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidBigT);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidNativesMin);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidTradeRouteSocket);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidGoldMed);
			rmAddObjectDefConstraint(south1v1NilgaiID, staySouthHalf);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidCliff);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidCliffShort);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidRampShort);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidTownCenterFar);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidForestMin);
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidypNilgaiShort); 
			rmAddObjectDefConstraint(south1v1NilgaiID, avoidEdgeMore);
			if (i == 0)
				rmAddObjectDefConstraint(south1v1NilgaiID, staySouthWest);
			else if (i == 1)
				rmAddObjectDefConstraint(south1v1NilgaiID, staySouthEast);
			rmPlaceObjectDefAtLoc(south1v1NilgaiID, 0, 0.4, 0.4);
		}
	}
	//North elks
	int northelkcount = (2*PlayerNum/2+PlayerNum/2);
	
	for(i=0; < northelkcount)
	{
		int northelkID = rmCreateObjectDef("north elk"+i);
		rmAddObjectDefItem(northelkID, "deer", rmRandInt(7,7), 7.0);
		rmSetObjectDefMinDistance(northelkID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(northelkID, rmXFractionToMeters(0.7));
		rmSetObjectDefCreateHerd(northelkID, true);
		rmAddObjectDefConstraint(northelkID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(northelkID, avoidNativesFar);
		rmAddObjectDefConstraint(northelkID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(northelkID, avoidTownCenterFar);
		rmAddObjectDefConstraint(northelkID, avoidForestMin);
		rmAddObjectDefConstraint(northelkID, avoidypNilgaiShort); 
		rmAddObjectDefConstraint(northelkID, avoidElk); 
		rmAddObjectDefConstraint(northelkID, avoidEdge);
		rmAddObjectDefConstraint(northelkID, avoidRampShort);
		rmAddObjectDefConstraint(northelkID, stayNorthHalf);
		if (i == 0)
			rmAddObjectDefConstraint(northelkID, stayNorthWest);
		else if (i == 1)
			rmAddObjectDefConstraint(northelkID, stayNorthEast);
		rmPlaceObjectDefAtLoc(northelkID, 0, 0.85, 0.85);
	}	
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.90);
	
	// ********** Treasures ***********
	
	// Treasures south	
	int NuggetsouthID = rmCreateObjectDef("South nugget"); 
	rmAddObjectDefItem(NuggetsouthID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(NuggetsouthID, 0);
    rmSetObjectDefMaxDistance(NuggetsouthID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(NuggetsouthID, avoidNuggetFar);
	rmAddObjectDefConstraint(NuggetsouthID, avoidNatives);
	rmAddObjectDefConstraint(NuggetsouthID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(NuggetsouthID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(NuggetsouthID, avoidImpassableLand);
	rmAddObjectDefConstraint(NuggetsouthID, avoidRamp);
	rmAddObjectDefConstraint(NuggetsouthID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(NuggetsouthID, staySouthHalf);
	rmAddObjectDefConstraint(NuggetsouthID, avoidTownCenter);
	rmAddObjectDefConstraint(NuggetsouthID, avoidypNilgaiMin); 
	rmAddObjectDefConstraint(NuggetsouthID, avoidBerriesMin);
	rmAddObjectDefConstraint(NuggetsouthID, avoidForestMin);
	rmAddObjectDefConstraint(NuggetsouthID, avoidEdge); 
	
	int nugget1count = -1;
	int	nugget2count = -1;
	
	if	(nugget0count == 1)
		nugget1count = 1+1*PlayerNum;
	else
		nugget1count = 1*PlayerNum;
	
	nugget2count = 3+1*PlayerNum; //2,2
	
	for (i=0; < nugget2count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(NuggetsouthID, 0, 0.45, 0.45);
	}
	
	for (i=0; < nugget1count)
	{
		rmSetNuggetDifficulty(1,1);
		rmPlaceObjectDefAtLoc(NuggetsouthID, 0, 0.45, 0.45);
	}
	
	// Treasures north	
	int NuggetnorthID = rmCreateObjectDef("North nugget"); 
	rmAddObjectDefItem(NuggetnorthID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(NuggetnorthID, 0);
    rmSetObjectDefMaxDistance(NuggetnorthID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(NuggetnorthID, avoidNuggetFar);
	rmAddObjectDefConstraint(NuggetnorthID, avoidNatives);
	rmAddObjectDefConstraint(NuggetnorthID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(NuggetnorthID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(NuggetnorthID, avoidImpassableLand);
	rmAddObjectDefConstraint(NuggetnorthID, avoidGoldTypeShort);
	rmAddObjectDefConstraint(NuggetnorthID, stayNorthHalf);
	rmAddObjectDefConstraint(NuggetnorthID, avoidTownCenter);
	rmAddObjectDefConstraint(NuggetnorthID, avoidElkMin); 
	rmAddObjectDefConstraint(NuggetnorthID, avoidBerriesMin);
	rmAddObjectDefConstraint(NuggetnorthID, avoidForestMin);	
	rmAddObjectDefConstraint(NuggetnorthID, avoidRamp);
	rmAddObjectDefConstraint(NuggetsouthID, avoidCliff); 	
	rmAddObjectDefConstraint(NuggetnorthID, avoidEdge);

	int nugget3count = -1;
	nugget3count = rmRandInt(0,1)+0.5*PlayerNum;
	
	for (i=0; < nugget3count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(NuggetnorthID, 0, 0.65, 0.65);
	}
	
	int nugget4count = -1;
	nugget4count = 1+0.5*PlayerNum;
	for (i=0; < nugget4count)
	{
		if (PlayerNum >= 4 && rmGetIsTreaty() == false)
			rmSetNuggetDifficulty(4,4);
		else
			rmSetNuggetDifficulty(3,3);
		rmPlaceObjectDefAtLoc(NuggetnorthID, 0, 0.65, 0.65);
	}
       
    int avoidAll=rmCreateTypeDistanceConstraint("avoid all 2", "all", 4.0);
    int avoidHerdables=rmCreateTypeDistanceConstraint("avoids cattle 2", "ypWaterBuffalo", 44.0+5*PlayerNum); 
    int stayNearWaterSheep = rmCreateTerrainMaxDistanceConstraint("stay near water sheep 2", "land", false, 3);
        
    int herdID=rmCreateObjectDef("water buffalo 2");
    rmAddObjectDefItem(herdID, "ypWaterBuffalo", 1, 0);
    rmSetObjectDefMinDistance(herdID, 0.0);
    rmSetObjectDefMaxDistance(herdID, 19);
    rmAddObjectDefConstraint(herdID, avoidHerdables);
    rmAddObjectDefConstraint(herdID, avoidAll);
    rmAddObjectDefConstraint(herdID, stayNearWaterSheep);
    rmPlaceObjectDefAtLoc(herdID, 0, 0.65, 0.55, 1);
    rmPlaceObjectDefAtLoc(herdID, 0, 0.55, 0.65, 1);
    
    rmPlaceObjectDefAtLoc(herdID, 0, 0.75, 0.45, 1);
    rmPlaceObjectDefAtLoc(herdID, 0, 0.45, 0.75, 1);
    
    rmPlaceObjectDefAtLoc(herdID, 0, 0.85, 0.35, 1);
    rmPlaceObjectDefAtLoc(herdID, 0, 0.35, 0.85, 1);

	// Underbrush
	for (i=0; < 60+10*PlayerNum)
	{
		int GrassID = rmCreateObjectDef("underbrush"+i);
		rmAddObjectDefItem(GrassID, "UnderbrushRockies", rmRandInt(1,3), 6.0); 
		rmSetObjectDefMinDistance(GrassID, 0);
		rmSetObjectDefMaxDistance(GrassID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(GrassID, classGrass);
		rmAddObjectDefConstraint(GrassID, avoidGrass);
		rmAddObjectDefConstraint(GrassID, avoidImpassableLand);
		rmPlaceObjectDefAtLoc(GrassID, 0, 0.50, 0.50);
	}

    
	// ********************************

	// Text
	rmSetStatusText("",1.00);
	
} // END	
	
