// LARGE NEW ENGLAND
// A Random Map for Age of Empires III: The Third One
// Nov 06 - YP update
//Durokan's May 20 update for DE. Only changes resources in 1v1. commented out extra lake spawns in players >2. removed decoration stone walls from 1v1.
// April 2021 edited by vividlyplain for DE
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

   //Chooses which natives appear on the map
   int subCiv0=-1;
   int subCiv1=-1;
   int subCiv2=-1;
   int subCiv3=-1;

	// Thingy to randomize location of the four "equal" VP sites.
	int vpLocation=-1;
	// vpLocation = rmRandInt(1,4);
	vpLocation = 1;

	int whichVariation=-1;
	// Used to be 1-4, but taking the mega-cliffs out for now.
	whichVariation = rmRandInt(1,2);
    whichVariation = 2; //locked into making the island
	int whichNative=rmRandInt(1,4);
	if ( whichNative > 1 )
	{
		subCiv0=rmGetCivID("Huron");
		rmEchoInfo("subCiv0 is Huron "+subCiv0);

		subCiv1=rmGetCivID("Huron");
		rmEchoInfo("subCiv1 is Huron "+subCiv1);
	}
	else
	{
		subCiv0=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv0 is Cherokee "+subCiv0);

		subCiv1=rmGetCivID("Cherokee");
		rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
	}

	subCiv2=rmGetCivID("Cree");
	rmEchoInfo("subCiv2 is Cree "+subCiv2);

	rmSetSubCiv(0, "Cherokee", true);
	rmSetSubCiv(1, "Huron", true);
	rmSetSubCiv(2, "Cree", true);

	float handedness = rmRandFloat(0, 1);

   // Picks the map size
	int playerTiles=25000;
   if (cNumberNonGaiaPlayers >4)
		playerTiles = 23000;

   // Picks default terrain and water
   rmSetSeaType("New England Skirmish");
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);

	// Some map turbulence...
	rmSetMapElevationParameters(cElevTurbulence, 0.4, 6, 0.7, 5.0);  // Like Texas for the moment.
	rmSetMapElevationHeightBlend(0.2);

   // Picks a default water height
   rmSetSeaLevel(4.0);
   rmEnableLocalWater(false);
   rmTerrainInitialize("water");
	rmSetMapType("newEngland");
	rmSetMapType("water");
	rmSetWorldCircleConstraint(true);
	rmSetWindMagnitude(2.0);
	// rmSetLightingSet("new england start");
	rmSetLightingSet("NewEngland_Skirmish");
	rmSetMapType("grass");

	// Sets up the lighting change trigger - happy dawn in New England
	// REMOVED
	/*
	rmCreateTrigger("Day");
   rmSwitchToTrigger(rmTriggerID("Day"));
   rmSetTriggerActive(true);
   rmAddTriggerCondition("Timer");
   rmSetTriggerConditionParamInt("Param1", 2);
   rmAddTriggerEffect("Set Lighting");
   rmSetTriggerEffectParam("SetName", "new england");
   rmSetTriggerEffectParamInt("FadeTime", 120);
   */

	// Choose mercs.
	chooseMercs();

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classCliff");
   rmDefineClass("classPatch");
	rmDefineClass("classWall");
   int classbigContinent=rmDefineClass("big continent");
   rmDefineClass("corner");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
//   rmDefineClass("classForest");
   rmDefineClass("importantItem");
	rmDefineClass("secrets");
	rmDefineClass("socketClass");
	rmDefineClass("nuggets");
		int classNative = rmDefineClass("natives");
	int classForest = rmDefineClass("Forest");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
 		int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 8.0);
		int avoidNativesMin = rmCreateClassDistanceConstraint("avoid natives min", rmClassID("natives"), 4.0);
		int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 12.0);
		int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 20.0);
   
   // Map edge constraints
   int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
   int longPlayerConstraint=rmCreateClassDistanceConstraint("continent stays away from players", classPlayer, 12.0);

   // Player constraints
   int playerConstraint=rmCreateClassDistanceConstraint("player vs. player", classPlayer, 10.0);
   int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

   // Directional constraints
	int Northwestward=rmCreatePieConstraint("northwestMapConstraint", 0.6, 0.6, 0, rmZFractionToMeters(0.9), rmDegreesToRadians(285), rmDegreesToRadians(75));  // 225 135, 300, 45
   int Southeastward=rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(90), rmDegreesToRadians(270));

   // Bonus area constraint.
   int bigContinentConstraint=rmCreateClassDistanceConstraint("avoid bonus island", classbigContinent, 25.0);

   // Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 44.0);
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 30.0);
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 15.0);
	int avoidForestShorter=rmCreateClassDistanceConstraint("avoid forest shorter", rmClassID("Forest"), 8.0);
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int forestConstraintFar=rmCreateClassDistanceConstraint("forest vs. forest far", rmClassID("Forest"), 33.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("Forest"), 10.0);
   int avoidDeer=rmCreateTypeDistanceConstraint("food avoids food", "deer", 64.0);
	int avoidFastCoin=rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 50.0);
   int avoidCoin=rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 35);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
   int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget avoid nugget far", "AbstractNugget", 64.0);
   int avoidPlayerNugget=rmCreateTypeDistanceConstraint("player nugget avoid nugget", "AbstractNugget", 20.0);
   int avoidNuggetSmall=rmCreateTypeDistanceConstraint("nugget avoid nugget small", "AbstractNugget", 10.0);

		int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 82.0);
		int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 55.0);
		int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 40.0);
		int avoidTownCenterMed=rmCreateTypeDistanceConstraint(" avoid Town Center med", "townCenter", 30.0);
		int avoidTownCenterShort=rmCreateTypeDistanceConstraint(" avoid Town Center short", "townCenter", 20.0);
		
   // Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int wallConstraint=rmCreateClassDistanceConstraint("wall vs. wall", rmClassID("classWall"), 40.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 64.0);

   // Specify true so constraint stays outside of circle (i.e. inside corners)
   int cornerConstraint0=rmCreateCornerConstraint("in corner 0", 0, true);
   int cornerConstraint1=rmCreateCornerConstraint("in corner 1", 1, true);
   int cornerConstraint2=rmCreateCornerConstraint("in corner 2", 2, true);
   int cornerConstraint3=rmCreateCornerConstraint("in corner 3", 3, true);

   // Unit avoidance
   int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 20.0);
   int avoidStartingUnitsSmall=rmCreateClassDistanceConstraint("objects avoid starting units small", rmClassID("startingUnit"), 5.0);

   // ships vs. ships
   int shipVsShip=rmCreateTypeDistanceConstraint("ships avoid ship", "ship", 5.0);

   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

   // VP avoidance
   int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 30.0);
	int avoidSocket=rmCreateClassDistanceConstraint("avoid sockets", rmClassID("socketClass"), 12.0);

   // Constraint to avoid water.
   int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
   int avoidWater15 = rmCreateTerrainDistanceConstraint("avoid water 15", "Land", false, 15.0);
   int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water 20", "Land", false, 20.0);
   int avoidWater30 = rmCreateTerrainDistanceConstraint("avoid water mid-long", "Land", false, 30.0);
   int avoidWater40 = rmCreateTerrainDistanceConstraint("avoid water long", "Land", false, 40.0);

   // New extra stuff for water spawn point avoidance.
	int flagLand = rmCreateTerrainDistanceConstraint("flag vs land", "land", true, 20.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 15);
	int flagEdgeConstraint = rmCreatePieConstraint("flags stay near edge of map", 0.5, 0.5, rmGetMapXSize()-20, rmGetMapXSize()-10, 0, 0, 0);

	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));

	int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 20.0);

   // Text
   rmSetStatusText("",0.10);

	// DEFINE AREAS
   // Set up player starting locations. These are just used to place Caravels away from each other.
   /* DAL - old placement.
	rmSetPlacementSection(0.35, 0.65);
   rmSetTeamSpacingModifier(0.50);
   rmPlacePlayersCircular(0.45, 0.45, rmDegreesToRadians(5.0));
	*/

   // Text
   rmSetStatusText("",0.20);

	// Build up big continent - called, unoriginally enough, "big continent"
   int bigContinentID=rmCreateArea("big continent");
   rmSetAreaSize(bigContinentID, 0.52, 0.52);		// 0.65, 0.65
   rmSetAreaWarnFailure(bigContinentID, false);
   rmAddAreaConstraint(bigContinentID, longPlayerConstraint);
   rmAddAreaToClass(bigContinentID, classbigContinent);
   rmSetAreaSmoothDistance(bigContinentID, 25);
	rmSetAreaMix(bigContinentID, "newengland_grass");
   rmSetAreaElevationType(bigContinentID, cElevTurbulence);
   rmSetAreaElevationVariation(bigContinentID, 2.0);
   rmSetAreaBaseHeight(bigContinentID, 6.0);
   rmSetAreaElevationMinFrequency(bigContinentID, 0.09);
   rmSetAreaElevationOctaves(bigContinentID, 3);
   rmSetAreaElevationPersistence(bigContinentID, 0.2);      
	rmSetAreaCoherence(bigContinentID, 0.5);
	rmSetAreaLocation(bigContinentID, 0.5, 0.85);
   rmSetAreaEdgeFilling(bigContinentID, 5);
	rmSetAreaObeyWorldCircleConstraint(bigContinentID, false);
	rmBuildArea(bigContinentID);

	int stayBigContinent = rmCreateAreaMaxDistanceConstraint("stay big continent ", bigContinentID, 0.0);

	rmSetStatusText("",0.30);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent1ID=rmCreateArea("small continent spur 1");
   rmSetAreaSize(smallContinent1ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent1ID, false);
   rmAddAreaConstraint(smallContinent1ID, longPlayerConstraint);
   rmAddAreaToClass(smallContinent1ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent1ID, 25);
	rmSetAreaMix(smallContinent1ID, "newengland_grass");
   rmSetAreaElevationType(smallContinent1ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent1ID, 2.0);
   rmSetAreaBaseHeight(smallContinent1ID, 6.0);
   rmSetAreaElevationMinFrequency(smallContinent1ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent1ID, 3);
   rmSetAreaElevationPersistence(smallContinent1ID, 0.2);      
	rmSetAreaCoherence(smallContinent1ID, 0.5);
	rmSetAreaLocation(smallContinent1ID, 0.8, 0.6);
   rmSetAreaEdgeFilling(smallContinent1ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent1ID, false);
	rmBuildArea(smallContinent1ID);

   rmSetStatusText("",0.35);

	// Build up small continent spurs called "small continent spur 1 & 2"
   int smallContinent2ID=rmCreateArea("small continent spur 2");
   rmSetAreaSize(smallContinent2ID, 0.2, 0.2);
   rmSetAreaWarnFailure(smallContinent2ID, false);
   rmAddAreaConstraint(smallContinent2ID, longPlayerConstraint);
   rmAddAreaToClass(smallContinent2ID, classbigContinent);
   rmSetAreaSmoothDistance(smallContinent2ID, 25);
	rmSetAreaMix(smallContinent2ID, "newengland_grass");
   rmSetAreaElevationType(smallContinent2ID, cElevTurbulence);
   rmSetAreaElevationVariation(smallContinent2ID, 2.0);
   rmSetAreaBaseHeight(smallContinent2ID, 6.0);
   rmSetAreaElevationMinFrequency(smallContinent2ID, 0.09);
   rmSetAreaElevationOctaves(smallContinent2ID, 3);
   rmSetAreaElevationPersistence(smallContinent2ID, 0.2);      
	rmSetAreaCoherence(smallContinent2ID, 0.5);
	rmSetAreaLocation(smallContinent2ID, 0.2, 0.6);
   rmSetAreaEdgeFilling(smallContinent2ID, 5);
   rmSetAreaObeyWorldCircleConstraint(smallContinent2ID, false);
	rmBuildArea(smallContinent2ID);

	// Avoidance Islands
	int midIslandID=rmCreateArea("Mid Island");
	rmSetAreaSize(midIslandID, 0.33);
	rmSetAreaLocation(midIslandID, 0.5, 0.65);
//	rmSetAreaMix(midIslandID, "testmix"); 	// for testing
	rmSetAreaCoherence(midIslandID, 1.00);
	rmBuildArea(midIslandID); 
	
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island ", midIslandID, 8.0);
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 16.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay mid island ", midIslandID, 0.0);

	int midSmIslandID=rmCreateArea("Mid Small Island");
	rmSetAreaSize(midSmIslandID, 0.10);
	rmSetAreaLocation(midSmIslandID, 0.5, 0.65);
//	rmSetAreaMix(midSmIslandID, "great plains drygrass"); 	// for testing
	rmSetAreaCoherence(midSmIslandID, 0.75);
	rmBuildArea(midSmIslandID); 
	
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island ", midSmIslandID, 8.0);
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmIslandID, 0.5);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmIslandID, 16.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay mid sm island ", midSmIslandID, 0.0);

	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.43), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));

  // check for KOTH game mode
  if(rmGetIsKOTH() == true) {
    
    int randLoc = rmRandInt(1,2);
    float xLoc = 0.5;
    float yLoc = 0.9;
    float walk = 0.0;
    
    if(randLoc == 1 || cNumberTeams > 2)
      yLoc = .40;
    
 	ypKingsHillLandfill(xLoc, yLoc, 0.007, 4.0, "newengland_grass", 0);
   ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 8.0);
	int avoidKOTHFar = rmCreateTypeDistanceConstraint("avoid koth far", "ypKingsHill", 16.0);
  
	// Place Players
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

	if ( cNumberTeams == 2 && teamZeroCount == teamOneCount)
	{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.2, 0.5, 0.2, 0.8, 0.0, 0.2);

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.8, 0.5, 0.8, 0.8, 0.0, 0.2);
	}
	else if (cNumberTeams == 2) 
	{
		if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
		{
			if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.20, 0.50, 0.20, 0.51, 0, 0);

				rmSetPlacementTeam(1);
				if (teamOneCount == 2)
					rmPlacePlayersLine(0.80, 0.50, 0.80, 0.80, 0, 0);
				else
					rmSetTeamSpacingModifier(0.50);
					rmSetPlacementSection(0.075, 0.29);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
			}
			else // 2v1, 3v1, 4v1, etc.
			{
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.80, 0.50, 0.80, 0.51, 0, 0);

				rmSetPlacementTeam(0);
				if (teamOneCount == 2)
					rmPlacePlayersLine(0.20, 0.50, 0.20, 0.80, 0, 0);
				else
					rmSetTeamSpacingModifier(0.50);
					rmSetPlacementSection(0.71, 0.925);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
			}
		}
		else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
		{
			if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
			{
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.80, 0.50, 0.80, 0.80, 0, 0);

				rmSetPlacementTeam(1);
					rmSetTeamSpacingModifier(0.50);
					rmSetPlacementSection(0.70, 0.90);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
			}
			else // 3v2, 4v2, etc.
			{
				rmSetPlacementTeam(0);
					rmSetTeamSpacingModifier(0.50);
					rmSetPlacementSection(0.10, 0.30);
					rmPlacePlayersCircular(0.40, 0.40, 0.0);
					
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.20, 0.50, 0.20, 0.80, 0, 0);
			}
		}
		else // 3v4, 4v3, etc.
		{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.2, 0.4, 0.2, 0.8, 0.0, 0.2);

		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.8, 0.4, 0.8, 0.8, 0.0, 0.2);
		}
	}
	else
	{
	   rmSetPlacementSection(0.75, 0.25);
	   rmSetTeamSpacingModifier(0.75);
	   rmPlacePlayersCircular(0.4, 0.4, 0);
	}

    // Set up player areas.
   float playerFraction=rmAreaTilesToFraction(300);
   for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
		rmSetAreaCoherence(id, 0.75);
		rmSetAreaMix(id, "newengland_grass");
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      // rmAddAreaConstraint(id, playerConstraint); 
      // rmAddAreaConstraint(id, playerEdgeConstraint); 
      rmSetAreaLocPlayer(id, i);
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();

   // Placement order
   // Trade route -> Lakes -> Natives -> Secrets -> Cliffs -> Nuggets
   // Text
   rmSetStatusText("",0.40);

   // TRADE ROUTES
	int tradeRouteID = rmCreateTradeRoute();

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, rmClassID("socketClass"));
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);
	if ( cNumberNonGaiaPlayers < 4 )
	{
		rmAddObjectDefConstraint(socketID, avoidWater15);					// To make it avoid the water and the cliffs.
	}

	else 
	{
		rmAddObjectDefConstraint(socketID, avoidWater20);					// To make it avoid the water and the cliffs - by more if larger map
	}

	// Hacky trade route stuff for weird FFA cases, to handle player placement.
	if ( cNumberTeams == 3 || cNumberTeams > 4 || rmGetIsKOTH() == true)
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.78);
	}
	else
	{
		rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.9);
	}
//	rmAddTradeRouteWaypoint(tradeRouteID, 0.5, 0.9);

	if ( cNumberNonGaiaPlayers < 4 || rmGetIsKOTH() == true)
	{
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.45, 10, 2);
	}
	else
	{
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.4, 10, 4);
	}
   
   bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "dirt");
   if(placedTradeRoute == false)
      rmEchoError("Failed to place trade route"); 

	// add the meeting poles along the trade route.
   rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
   vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.3);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.7);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

   socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 1.0);
   rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	// LAKES
	int lakeClass=rmDefineClass("lake");
	int lakeConstraint=rmCreateClassDistanceConstraint("lake vs. lake", rmClassID("lake"), 20.0);

	// Half the time there are two extra lakes.
//	int extraLakes=-1;
	//extraLakes = rmRandInt(1,2);
    //removed extralakes from DE because they are annoying 
    
	int smalllakeID=rmCreateArea("small lake 1");
	
	// Place Lakes only in Variations 1 & 2.
	if ( whichVariation < 3 )
	{
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(500+50*cNumberNonGaiaPlayers));
		else
			rmSetAreaSize(smalllakeID, rmAreaTilesToFraction(800+50*cNumberNonGaiaPlayers));
		rmSetAreaWaterType(smalllakeID, "new england lake");
		rmSetAreaBaseHeight(smalllakeID, 2.0);
		rmAddAreaToClass(smalllakeID, lakeClass);
		rmAddAreaConstraint(smalllakeID, playerConstraint);
		rmAddAreaConstraint(smalllakeID, avoidTradeRoute);
		rmAddAreaConstraint(smalllakeID, avoidSocket);
		rmSetAreaLocation(smalllakeID, 0.38, 0.65);
		rmAddAreaInfluenceSegment(smalllakeID, 0.4, 0.52, 0.35, 0.68);
		rmSetAreaCoherence(smalllakeID, 0.75);

		rmSetAreaWarnFailure(smalllakeID, false);
		rmBuildArea(smalllakeID);

		int smalllakeID2=rmCreateArea("small lake 2");
		if ( cNumberNonGaiaPlayers < 4 )
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(500+50*cNumberNonGaiaPlayers));
		else
			rmSetAreaSize(smalllakeID2, rmAreaTilesToFraction(800+50*cNumberNonGaiaPlayers));

		rmSetAreaWaterType(smalllakeID2, "new england lake");
		rmSetAreaBaseHeight(smalllakeID2, 2.0);
		rmAddAreaToClass(smalllakeID2, lakeClass);
		rmAddAreaConstraint(smalllakeID2, playerConstraint);
		rmAddAreaConstraint(smalllakeID2, avoidTradeRoute);
		rmAddAreaConstraint(smalllakeID2, avoidSocket);
		rmSetAreaLocation(smalllakeID2, 0.62, 0.65);
		rmAddAreaInfluenceSegment(smalllakeID2, 0.6, 0.52, 0.65, 0.68);
		rmSetAreaCoherence(smalllakeID2, 0.75);

		rmSetAreaWarnFailure(smalllakeID2, false);
		rmBuildArea(smalllakeID2);	

/*		// Two extra lakes?  Sometimes - only if more than two players.
		if ( extraLakes == 2 && cNumberNonGaiaPlayers > 2 )
		{
			int smallLakeID3=rmCreateArea("small lake 3");
			rmSetAreaSize(smallLakeID3, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
			rmSetAreaWaterType(smallLakeID3, "new england lake");
			rmSetAreaBaseHeight(smallLakeID3, 2.0);
			rmAddAreaToClass(smallLakeID3, lakeClass);
			rmAddAreaConstraint(smallLakeID3, playerConstraint);
			rmAddAreaConstraint(smallLakeID3, avoidTradeRoute);
			rmSetAreaLocation(smallLakeID3, 0.16, 0.65);
			rmSetAreaCoherence(smallLakeID3, 0.3);
			rmSetAreaWarnFailure(smallLakeID3, false);
			rmBuildArea(smallLakeID3);	

			int smallLakeID4=rmCreateArea("small lake 4");
			rmSetAreaSize(smallLakeID4, rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
			rmSetAreaWaterType(smallLakeID4, "new england lake");
			rmSetAreaBaseHeight(smallLakeID4, 2.0);
			rmAddAreaToClass(smallLakeID4, lakeClass);
			rmAddAreaConstraint(smallLakeID4, playerConstraint);
			rmAddAreaConstraint(smallLakeID4, avoidTradeRoute);
			rmSetAreaLocation(smallLakeID4, 0.84, 0.65);
			rmSetAreaCoherence(smallLakeID4, 0.3);
			rmSetAreaWarnFailure(smallLakeID4, false);
			rmBuildArea(smallLakeID4);	
		}
		*/
	}

	// Place two crazy cliffs at the spots the lakes WOULD have been otherwise (i.e., if the lakes aren't there).
	/*
	if ( whichVariation > 2 )
	{
		int bigCliff1ID=rmCreateArea("big cliff 1");
	   rmSetAreaSize(bigCliff1ID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
		rmSetAreaWarnFailure(bigCliff1ID, false);
		rmSetAreaCliffType(bigCliff1ID, "New England");
		rmAddAreaToClass(bigCliff1ID, rmClassID("classCliff"));		// Attempt to keep cliffs away from each other.

		rmSetAreaCliffEdge(bigCliff1ID, 1, 0.6, 0.1, 1.0, 0);  // DAL NOTE: Number of edges, second is size of each edge, third is variance
		rmSetAreaCliffPainting(bigCliff1ID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliff1ID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliff1ID, 1.0);
		rmAddAreaTerrainLayer(bigCliff1ID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(bigCliff1ID, avoidImportantItem);
		rmAddAreaConstraint(bigCliff1ID, avoidTradeRoute);
		rmSetAreaSmoothDistance(bigCliff1ID, 15);
		rmSetAreaCoherence(bigCliff1ID, 0.4);
		
		rmSetAreaLocation(bigCliff1ID, 0.40, 0.65);
		rmAddAreaInfluenceSegment(bigCliff1ID, 0.4, 0.52, 0.35, 0.68);
		rmBuildArea(bigCliff1ID);

		int bigCliff2ID=rmCreateArea("big cliff 2");
	   rmSetAreaSize(bigCliff2ID, rmAreaTilesToFraction(1200), rmAreaTilesToFraction(1200));
		rmSetAreaWarnFailure(bigCliff2ID, false);
		rmSetAreaCliffType(bigCliff2ID, "New England");
		rmAddAreaToClass(bigCliff2ID, rmClassID("classCliff"));		// Attempt to keep cliffs away from each other.

		rmSetAreaCliffEdge(bigCliff2ID, 1, 0.6, 0.1, 1.0, 0);
		rmSetAreaCliffPainting(bigCliff2ID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(bigCliff2ID, 6, 1.0, 1.0);
		rmSetAreaHeightBlend(bigCliff2ID, 1.0);
		rmAddAreaTerrainLayer(bigCliff2ID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(bigCliff2ID, avoidImportantItem);
		rmAddAreaConstraint(bigCliff2ID, avoidTradeRoute);
		rmSetAreaSmoothDistance(bigCliff2ID, 15);
		rmSetAreaCoherence(bigCliff2ID, 0.4);

		rmSetAreaLocation(bigCliff2ID, 0.60, 0.65);
		rmAddAreaInfluenceSegment(bigCliff2ID, 0.6, 0.52, 0.65, 0.68);
		rmBuildArea(bigCliff2ID);
	}
	*/

   // Isles of Shoals - these are set in specific locations.
   int bonusIslandID1=rmCreateArea("isle of shoals 1");
   rmSetAreaSize(bonusIslandID1, rmAreaTilesToFraction(450), rmAreaTilesToFraction(450));
   rmSetAreaTerrainType(bonusIslandID1, "new_england\ground1_ne");
   rmSetAreaMix(bonusIslandID1, "newengland_grass");
	// rmSetAreaMix(bonusIslandID1, "newengland_rock");
   rmSetAreaBaseHeight(bonusIslandID1, 6.0);
   rmSetAreaSmoothDistance(bonusIslandID1, 5);
   rmSetAreaWarnFailure(bonusIslandID1, false);
   rmSetAreaCoherence(bonusIslandID1, 0.50);
   rmAddAreaConstraint(bonusIslandID1, bigContinentConstraint);
   rmAddAreaConstraint(bonusIslandID1, longPlayerConstraint);

	// this may be the only island!  On a 2 or a 4.
	if ( whichVariation == 1 || whichVariation == 3 )
	{
		rmSetAreaLocation(bonusIslandID1, 0.40, 0.15);
	}
	else
		rmSetAreaLocation(bonusIslandID1, 0.50, 0.15);
   rmBuildArea(bonusIslandID1);

	// Only make the second island half the time.
	if ( whichVariation == 1 || whichVariation == 3 )
	{
		int bonusIslandID2=rmCreateArea("isle of shoals 2");
		rmSetAreaSize(bonusIslandID2, rmAreaTilesToFraction(450), rmAreaTilesToFraction(450));
		rmSetAreaTerrainType(bonusIslandID2, "new_england\ground1_ne");
		rmSetAreaMix(bonusIslandID2, "newengland_grass");
		// rmSetAreaMix(bonusIslandID2, "newengland_rock");
		rmSetAreaBaseHeight(bonusIslandID2, 6.0);
		rmSetAreaSmoothDistance(bonusIslandID2, 5);
		rmSetAreaWarnFailure(bonusIslandID2, false);
		rmSetAreaCoherence(bonusIslandID2, 0.50);
		rmAddAreaConstraint(bonusIslandID2, bigContinentConstraint);
		rmAddAreaConstraint(bonusIslandID2, longPlayerConstraint);
		rmSetAreaLocation(bonusIslandID2, 0.60, 0.15);
		rmBuildArea(bonusIslandID2);
	}

   // NATIVE AMERICANS
   // Text
   rmSetStatusText("",0.50);

   float NativeVillageLoc = rmRandFloat(0,1);
     
   // Huron are always on the mainland
   int huronVillageAID = -1;
   int huronVillageType = rmRandInt(1,3);
   if ( whichNative > 1 )
   {
		huronVillageAID = rmCreateGrouping("huron village A", "native huron village "+huronVillageType);
   }
   else
   {
	   	huronVillageAID = rmCreateGrouping("cherokee village A", "native cherokee village "+huronVillageType);
   }
   rmSetGroupingMinDistance(huronVillageAID, 0.0);
   rmSetGroupingMaxDistance(huronVillageAID, rmXFractionToMeters(0.00));
   rmAddGroupingConstraint(huronVillageAID, avoidImpassableLand);
   rmAddGroupingToClass(huronVillageAID, rmClassID("importantItem"));
   rmAddGroupingConstraint(huronVillageAID, avoidTradeRoute);
	rmAddGroupingToClass(huronVillageAID, classNative);

	if ( vpLocation < 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.35, 0.8); // used to be 0.3 DAL
	}
	else if ( vpLocation == 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.2, 0.6);
	}
	else
	{
		rmPlaceGroupingAtLoc(huronVillageAID, 0, 0.8, 0.6);
	}
	
	int huronVillageBID = -1;
	huronVillageType = rmRandInt(1,3);
	if ( whichNative > 1 )
	{
		huronVillageBID = rmCreateGrouping("huron village B", "native huron village "+huronVillageType);
	}
	else
	{
		huronVillageBID = rmCreateGrouping("cherokee village B", "native cherokee village "+huronVillageType);
	}
	rmSetGroupingMinDistance(huronVillageBID, 0.0);
	rmSetGroupingMaxDistance(huronVillageBID, rmXFractionToMeters(0.00));
	rmAddGroupingConstraint(huronVillageBID, avoidImpassableLand);
	rmAddGroupingToClass(huronVillageBID, rmClassID("importantItem"));
	rmAddGroupingConstraint(huronVillageBID, avoidTradeRoute);
	rmAddGroupingToClass(huronVillageBID, classNative);
	
	if ( vpLocation == 1 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.65, 0.8); // used to be 0.7 DAL
	}
	else if ( vpLocation == 2 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.8, 0.6); 
	}
	else if ( vpLocation == 3 )
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.7, 0.8); 
	}
	else
	{
		rmPlaceGroupingAtLoc(huronVillageBID, 0, 0.2, 0.6);
	}

	// The Cree get placed on one of the islands.  Ahistorical, perhaps, but fun!
	/* DAL - CREE TAKEN OUT
   int creeVillageID = -1;
   int creeVillageType = rmRandInt(1,3);
   creeVillageID = rmCreateGrouping("cree village", "native cree village "+creeVillageType);
   rmSetGroupingMinDistance(creeVillageID, 0.0);
   rmSetGroupingMaxDistance(creeVillageID, rmXFractionToMeters(0.05));
   rmAddGroupingConstraint(creeVillageID, avoidImpassableLand);
   rmAddGroupingToClass(creeVillageID, rmClassID("importantItem"));
	if ( vpLocation < 3 )
	{
		// Only gets placed if island #2 actually exists.
		if ( whichVariation == 1 || whichVariation == 3 )
		{
			rmPlaceGroupingInArea(creeVillageID, 0, bonusIslandID2);
		}
	}
	else
	{
		rmPlaceGroupingInArea(creeVillageID, 0, bonusIslandID1);
	}
	*/

    int classStartingResource = rmDefineClass("startingResource");
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other 2", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesFar  = rmCreateClassDistanceConstraint("start resources avoid each other 2 far", rmClassID("startingResource"), 16.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other 2 short", rmClassID("startingResource"), 6.0);
	int avoidStartingResourcesMin  = rmCreateClassDistanceConstraint("start resources avoid each other 2 min", rmClassID("startingResource"), 4.0);
	
   // Starting Unit placement
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, 6.0);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
//	rmAddObjectDefConstraint(startingUnits, avoidAll);

	int startingTCID= rmCreateObjectDef("startingTC");
	if ( rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, rmClassID("startingUnit"));
	rmAddObjectDefToClass(startingTCID, classStartingResource);
	rmSetObjectDefMinDistance(startingTCID, 0.0);
	if (teamZeroCount != teamOneCount)
		rmSetObjectDefMaxDistance(startingTCID, 10.0);
	else 
		rmSetObjectDefMaxDistance(startingTCID, 0.0);
	rmAddObjectDefConstraint(startingTCID, avoidWater15);
	rmAddObjectDefConstraint(startingTCID, avoidNatives);

	int silverType = -1;
	int playerGoldID = -1;

	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeNewEngland", 2, 2.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 17.0);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18.0);
   	rmAddObjectDefToClass(StartAreaTreeID, classStartingResource);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNativesShort);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidWater4);

	int StartAreaTree2ID=rmCreateObjectDef("starting trees2");
	rmAddObjectDefItem(StartAreaTree2ID, "TreeNewEngland", 12, 7.0);
	rmSetObjectDefMinDistance(StartAreaTree2ID, 36.0);
	rmSetObjectDefMaxDistance(StartAreaTree2ID, 40.0);
   	rmAddObjectDefToClass(StartAreaTree2ID, classStartingResource);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidMidIslandFar);
	rmAddObjectDefConstraint(StartAreaTree2ID, stayNearEdge);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidNatives);
	rmAddObjectDefConstraint(StartAreaTree2ID, avoidWater4);

	int StartBerryBushID=rmCreateObjectDef("starting BerryBush");
	rmAddObjectDefItem(StartBerryBushID, "BerryBush", 3, 5.0);
	rmSetObjectDefMinDistance(StartBerryBushID, 14.0);
	rmSetObjectDefMaxDistance(StartBerryBushID, 14.0);
   	rmAddObjectDefToClass(StartBerryBushID, classStartingResource);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(StartBerryBushID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(StartBerryBushID, avoidNativesShort);
	rmAddObjectDefConstraint(StartBerryBushID, avoidWater4);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("nuggets"));
    rmSetObjectDefMinDistance(playerNuggetID, 30.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 35.0);
   	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnitsSmall);
	rmAddObjectDefConstraint(playerNuggetID, avoidPlayerNugget);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidMidIslandMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNativesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidWater4);
	// rmAddObjectDefConstraint(playerNuggetID, avoidImportantItem);
    
    int baseGold = rmCreateObjectDef("starting gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold, 16.0);
    rmSetObjectDefMaxDistance(baseGold, 16.0);
   	rmAddObjectDefToClass(baseGold, classStartingResource);
	rmAddObjectDefConstraint(baseGold, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold, avoidStartingResources);
	rmAddObjectDefConstraint(baseGold, avoidNativesShort);
	rmAddObjectDefConstraint(baseGold, avoidWater4);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(baseGold, stayMidIsland);

    int baseGold2 = rmCreateObjectDef("starting gold2");
    rmAddObjectDefItem(baseGold2, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold2, 16.0);
    rmSetObjectDefMaxDistance(baseGold2, 16.0);
   	rmAddObjectDefToClass(baseGold2, classStartingResource);
	rmAddObjectDefConstraint(baseGold2, avoidTradeRoute);
	rmAddObjectDefConstraint(baseGold2, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold2, avoidStartingResources);
	rmAddObjectDefConstraint(baseGold2, avoidNativesShort);
	rmAddObjectDefConstraint(baseGold2, avoidWater4);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(baseGold2, avoidMidIslandMin);

    int baseHunt1=rmCreateObjectDef("baseHunt1");
    rmAddObjectDefItem(baseHunt1, "elk", 8, 7.0);
    rmSetObjectDefMinDistance(baseHunt1, 15.0);
    rmSetObjectDefMaxDistance(baseHunt1, 16.0);
   	rmAddObjectDefToClass(baseHunt1, classStartingResource);
    rmAddObjectDefConstraint(baseHunt1, avoidStartingUnitsSmall);
    rmAddObjectDefConstraint(baseHunt1, avoidStartingResourcesShort);
    rmAddObjectDefConstraint(baseHunt1, avoidImpassableLand);
    rmAddObjectDefConstraint(baseHunt1, avoidTradeRoute);
    rmAddObjectDefConstraint(baseHunt1, avoidWater4);
    rmSetObjectDefCreateHerd(baseHunt1, true);
    rmAddObjectDefConstraint(baseHunt1, avoidNativesShort);

    int baseHunt2=rmCreateObjectDef("baseHunt2");
    rmAddObjectDefItem(baseHunt2, "elk", 8, 7.0);
    rmSetObjectDefMinDistance(baseHunt2, 36.0);
    rmSetObjectDefMaxDistance(baseHunt2, 40.0);
    rmAddObjectDefToClass(baseHunt2, classStartingResource);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingUnitsSmall);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingResources);
    rmAddObjectDefConstraint(baseHunt2, avoidTradeRoute);
    rmAddObjectDefConstraint(baseHunt2, avoidNativesShort);
    rmSetObjectDefCreateHerd(baseHunt2, true);
    rmAddObjectDefConstraint(baseHunt2, avoidImpassableLand);
    rmAddObjectDefConstraint(baseHunt2, avoidMidIslandFar);
//    rmAddObjectDefConstraint(baseHunt2, stayNearEdge);
    rmAddObjectDefConstraint(baseHunt2, avoidWater4);
    
	int waterFlagID=-1;
	
	for(i=1; <cNumberPlayers)
	{
		rmClearClosestPointConstraints();
		// Place starting units and a TC!
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Everyone gets one ore grouping close by.
        if(cNumberNonGaiaPlayers>2){
            silverType = rmRandInt(1,10);
            playerGoldID = rmCreateObjectDef("player silver closer "+i);
            rmAddObjectDefItem(playerGoldID, "mine", 1, 0.0);
            // rmAddGroupingToClass(playerGoldID, rmClassID("importantItem"));
			rmAddObjectDefToClass(playerGoldID, classStartingResource);
            rmAddObjectDefConstraint(playerGoldID, avoidTradeRoute);
            rmAddObjectDefConstraint(playerGoldID, avoidStartingUnitsSmall);
            rmAddObjectDefConstraint(playerGoldID, avoidStartingResources);
            if (teamZeroCount == teamOneCount)
				rmAddObjectDefConstraint(playerGoldID, avoidMidIslandMin);
            rmAddObjectDefConstraint(playerGoldID, avoidNativesShort);
            rmSetObjectDefMinDistance(playerGoldID, 16.0);
            rmSetObjectDefMaxDistance(playerGoldID, 16.0);
            rmPlaceObjectDefAtLoc(playerGoldID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }else{
            rmPlaceObjectDefAtLoc(baseGold, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
            rmPlaceObjectDefAtLoc(baseGold2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        }
		// Placing starting Pronghorns (?)...
        
            rmPlaceObjectDefAtLoc(baseHunt1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(baseHunt2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		/*
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		*/
		rmPlaceObjectDefAtLoc(StartBerryBushID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		// Placing starting trees...
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTree2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Nuggets
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flag
		waterFlagID=rmCreateObjectDef("HC water flag "+i);
		rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
		rmAddClosestPointConstraint(flagEdgeConstraint);
		rmAddClosestPointConstraint(flagVsFlag);
		rmAddClosestPointConstraint(flagLand);
		vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(startingTCID, i));
        vector closestPoint = rmFindClosestPointVector(TCLocation, rmXFractionToMeters(1.0));

		rmPlaceObjectDefAtLoc(waterFlagID, i, rmXMetersToFraction(xsVectorGetX(closestPoint)), rmZMetersToFraction(xsVectorGetZ(closestPoint)));
		rmClearClosestPointConstraints();
	}

	// Text
   rmSetStatusText("",0.60);

	// A few smallish cliffs on the northwest side (inland)
	/* DAL Temp - take these suckers out, now that there are some lakes
	int numTries=cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <numTries)
	{
		int cliffID=rmCreateArea("cliff "+i);
	   rmSetAreaSize(cliffID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure(cliffID, false);
		rmSetAreaCliffType(cliffID, "New England");
		rmAddAreaToClass(cliffID, rmClassID("classCliff"));	// Attempt to keep cliffs away from each other.

		// rmSetAreaCliffEdge(cliffID, 1, 0.6, 0.1, 1.0, 0);
		rmSetAreaCliffEdge(cliffID, 1, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, 4, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 1.0);
		rmAddAreaTerrainLayer(cliffID, "new_england\ground4_ne", 0, 2);

		rmAddAreaConstraint(cliffID, avoidCliffs);				// Avoid other cliffs, please!
		rmAddAreaConstraint(cliffID, avoidImportantItem);
		rmAddAreaConstraint(cliffID, avoidTradeRoute);
		rmAddAreaConstraint(cliffID, avoidWater20);
		rmAddAreaConstraint(cliffID, Northwestward);				// Cliff are on the northwest side of the map.
		rmSetAreaSmoothDistance(cliffID, 10);
		rmSetAreaCoherence(cliffID, 0.25);

		if(rmBuildArea(cliffID)==false)
		{
			// Stop trying once we fail 3 times in a row
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
	*/

	// Placement of crates on the bonus islands.
	// DAL - "nuggets" for now instead
	int whichCrate=-1;
	whichCrate = rmRandInt(1,3);

	int islandCrateID= rmCreateObjectDef("island crates"); 
    if(cNumberNonGaiaPlayers==2 || rmGetIsTreaty() == true){
        rmSetNuggetDifficulty(3, 3);
    }else{
        rmSetNuggetDifficulty(4, 4);
    }
	rmAddObjectDefConstraint(islandCrateID, avoidWater4);
	rmAddObjectDefConstraint(islandCrateID, avoidNuggetSmall);
	if ( whichCrate == 1 )
	{
		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	}
	else if ( whichCrate == 2 )
	{
		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	}
	else
   		rmAddObjectDefItem(islandCrateID, "Nugget", 1, 0.0);
	

	rmPlaceObjectDefInArea(islandCrateID, 0, bonusIslandID1, 1);
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandCrateID, 0, bonusIslandID2, 1);
	}

	// TEMP: add four natives to the islands
	// DAL - temp trees instead.
	int islandNativeID= rmCreateObjectDef("island natives"); 
	rmAddObjectDefConstraint(islandNativeID, avoidWater4);
	// rmAddObjectDefItem(islandNativeID, "NatTomahawk", 1, 0.0);
	rmAddObjectDefItem(islandNativeID, "TreeNewEngland", 1, 0.0);
	rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID1, 7);
	if ( whichVariation == 1 )
	{
		rmPlaceObjectDefInArea(islandNativeID, 0, bonusIslandID2, 7);
	}

   // fish
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 20.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "minkeWhale", 40.0);


   int fishID=rmCreateObjectDef("fish");
   rmAddObjectDefItem(fishID, "FishCod", 2, 5.0);
   rmSetObjectDefMinDistance(fishID, 0.0);
   rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(fishID, fishVsFishID);
   rmAddObjectDefConstraint(fishID, fishLand);
   rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.0, cNumberNonGaiaPlayers*5);

	// FAST COIN -- WHALES
    if(cNumberNonGaiaPlayers>2){
        int whaleID=rmCreateObjectDef("whale");
        rmAddObjectDefItem(whaleID, "minkeWhale", 1, 9.0);
        rmSetObjectDefMinDistance(whaleID, 0.0);
        rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
        rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
        rmAddObjectDefConstraint(whaleID, whaleLand);
        rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);
    }else{
    //1v1 whale balancing
       int whaleVsWhaleID2=rmCreateTypeDistanceConstraint("whale v whale 2", "minkeWhale", 22.0);

        int whaleID2=rmCreateObjectDef("whale2");
        rmAddObjectDefItem(whaleID2, "minkeWhale", 1, 9.0);
        rmSetObjectDefMinDistance(whaleID2, 0.0);
        rmSetObjectDefMaxDistance(whaleID2, 15);
        rmAddObjectDefConstraint(whaleID2, whaleVsWhaleID2);
        rmAddObjectDefConstraint(whaleID2, whaleLand);
        rmPlaceObjectDefAtLoc(whaleID2, 0, 0.15, 0.2,1);
        rmPlaceObjectDefAtLoc(whaleID2, 0, 0.32, 0.14,1);
        rmPlaceObjectDefAtLoc(whaleID2, 0, 0.68, 0.14,1);
        rmPlaceObjectDefAtLoc(whaleID2, 0, 0.85, 0.2,1);
    }


    //CARAVEL
   /*
   int colonyShipID = 0;
   for(i=1; <cNumberPlayers)
   {
		colonyShipID=rmCreateObjectDef("colony ship "+i);

		rmAddObjectDefItem(colonyShipID, "HomeCityWaterSpawnFlag", 1, 5.0);

		rmAddObjectDefConstraint(colonyShipID, shipVsShip);
		rmAddObjectDefConstraint(colonyShipID, fishLand);
		// rmAddObjectDefConstraint(colonyShipID, Southeastward);
		rmSetObjectDefMinDistance(colonyShipID, 0.0);
		rmSetObjectDefMaxDistance(colonyShipID, rmXFractionToMeters(0.3));

		// Ship placement
		if ( rmGetPlayerTeam(i) == 0 )
		{
	   		rmPlaceObjectDefAtLoc(colonyShipID, i, 0.0, 0.0, 1);
		}
		else
		{
			rmPlaceObjectDefAtLoc(colonyShipID, i, 1.0, 0.0, 1);
		}
		// vector colonyShipLocation=rmGetUnitPosition(rmGetUnitPlacedOfPlayer(colonyShipID, i));
		// rmSetHomeCityWaterSpawnPoint(i, colonyShipLocation);
	}
	*/

   // Text
   rmSetStatusText("",0.65); 
 
   //constraints for durokan's 1v1 balance
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 4.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 3.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("Forest"), 3.0);
    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 28.0);
    int avoidHunt3=rmCreateTypeDistanceConstraint("herds avoid herds3", "huntable", 23.0);
	int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type  far ", "gold", 30.0);
    int avoidGoldForest = rmCreateTypeDistanceConstraint("avoid gold 2", "gold", 9.0);
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.49), rmDegreesToRadians(0), rmDegreesToRadians(360));
    int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water 5", "Land", false, 5.0);
    int avoidWater6 = rmCreateTerrainDistanceConstraint("avoid water 6", "Land", false, 6.5);
        int avoidTC2p = rmCreateTypeDistanceConstraint("avoid TCs 2p", "TownCenter", 32.0);
        int avoidTC2pFar = rmCreateTypeDistanceConstraint("avoid TCs 2p far", "TownCenter", 44.0);
    
   // Place resources that we want forests to avoid
	// Fast Coin
	int silverID = -1;
	int silverCount = cNumberNonGaiaPlayers*3;	// 3 per player, plus starting one.
	rmEchoInfo("silver count = "+silverCount);
if(cNumberNonGaiaPlayers>2){
//non 1v1 mines
	for(i=0; < silverCount)
	{
		silverType = rmRandInt(1,10);
		silverID = rmCreateObjectDef("silver "+i);
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
		rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));

		rmAddObjectDefConstraint(silverID, avoidFastCoin);
		rmAddObjectDefConstraint(silverID, avoidCoin);
		rmAddObjectDefConstraint(silverID, avoidAll);
		rmAddObjectDefConstraint(silverID, avoidNativesShort);
		rmAddObjectDefConstraint(silverID, avoidImpassableLand);
		rmAddObjectDefConstraint(silverID, avoidTradeRoute);
		rmAddObjectDefConstraint(silverID, avoidSocket);
		rmAddObjectDefConstraint(silverID, avoidStartingUnits);
		rmAddObjectDefConstraint(silverID, avoidStartingResources);
		// Keep silver away from the water, to avoid the art problem with the "cliffs."
		rmAddObjectDefConstraint(silverID, avoidWater30);
		rmAddObjectDefConstraint(silverID, avoidKOTH);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5);
   }
}else{
    //1v1 mines
      int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 1.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, 8);
    rmAddObjectDefConstraint(topMine, avoidSocket2);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(topMine, forestConstraintShort);
    rmAddObjectDefConstraint(topMine, avoidStartingResources);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
    rmAddObjectDefConstraint(topMine, circleConstraint2);  
    rmAddObjectDefConstraint(topMine, avoidWater5);  
    rmAddObjectDefConstraint(topMine, avoidAll2);       
    rmAddObjectDefConstraint(topMine, avoidNativesShort);       
    //gold band above lakes
    //nestled behind base
    rmPlaceObjectDefAtLoc(topMine, 0, 0.86, 0.66, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.14, 0.66, 1); 
    //end of TP line
    rmPlaceObjectDefAtLoc(topMine, 0, 0.58, 0.84, 1);
    rmPlaceObjectDefAtLoc(topMine, 0, 0.42, 0.84, 1);
    //above lakes
    rmPlaceObjectDefAtLoc(topMine, 0, 0.75, 0.81, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.25, 0.81, 1);   
    //on island
    rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.16, 1);   
    //s-east end of tp line
    //rmPlaceObjectDefAtLoc(topMine, 0, 0.5, 0.38, 1);  
}

	// Map Trees
	int Trees1ID=rmCreateObjectDef("map 1 trees");
	rmAddObjectDefItem(Trees1ID, "TreeNewEngland", 18, 10.0);
	rmAddObjectDefToClass(Trees1ID, rmClassID("Forest")); 
	rmSetObjectDefMinDistance(Trees1ID, 0);
	rmSetObjectDefMaxDistance(Trees1ID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(Trees1ID, avoidNativesShort);
	rmAddObjectDefConstraint(Trees1ID, forestConstraintFar);
	rmAddObjectDefConstraint(Trees1ID, avoidGoldForest);	
	rmAddObjectDefConstraint(Trees1ID, avoidWater4);
	rmAddObjectDefConstraint(Trees1ID, avoidSocket);
	rmAddObjectDefConstraint(Trees1ID, avoidStartingResources);
	rmAddObjectDefConstraint(Trees1ID, avoidTC2p);
	rmAddObjectDefConstraint(Trees1ID, avoidKOTHFar);
	rmAddObjectDefConstraint(Trees1ID, avoidMidSmIslandMin);
	rmAddObjectDefConstraint(Trees1ID, stayBigContinent);
	rmPlaceObjectDefAtLoc(Trees1ID, 0, 0.5, 0.5, 20+7*PlayerNum);
		
/*	// old forest - removed by vividlyplain
	// FORESTS
   int forestTreeID = 0;
   int numTries=6*cNumberNonGaiaPlayers;
   int failCount=0;

   for (i=0; <numTries)
   {   
      int forest=rmCreateArea("forest "+i, rmAreaID("big continent"));
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaSize(forest, rmAreaTilesToFraction(200), rmAreaTilesToFraction(250));
      rmSetAreaForestType(forest, "new england forest");
      if(cNumberNonGaiaPlayers>2){
          rmSetAreaForestDensity(forest, 1.0);
          rmSetAreaForestClumpiness(forest, 0.9);
      }else{
        rmSetAreaForestDensity(forest, .7);
        rmSetAreaForestClumpiness(forest, 0.6);
      }

      rmSetAreaForestUnderbrush(forest, 0.0);
      rmSetAreaCoherence(forest, 0.4);
      rmSetAreaSmoothDistance(forest, 10);
      rmAddAreaToClass(forest, rmClassID("Forest")); 
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
      rmAddAreaConstraint(forest, avoidStartingResources);
      if(cNumberNonGaiaPlayers==2){   
            rmAddAreaConstraint(forest, avoidGoldForest);
      }
	  rmAddAreaConstraint(forest, avoidStartingUnits);
		rmAddAreaConstraint(forest, avoidSocket);
      if(rmBuildArea(forest)==false)
      {
         // Stop trying once we fail 3 times in a row.
         failCount++;
         if(failCount==5)
            break;
      }
      else
         failCount=0; 
   } 
*/
   // Text
   rmSetStatusText("",0.70);

if(cNumberNonGaiaPlayers>2){
//non 1v1 hunts
 	// DEER
   int deerID=rmCreateObjectDef("deer herd");
	int bonusChance=rmRandFloat(0, 1);
   
	if(bonusChance<0.5)
      rmAddObjectDefItem(deerID, "deer", rmRandInt(8,8), 4.0);
   else
      rmAddObjectDefItem(deerID, "deer", rmRandInt(8,8), 6.0);

   rmSetObjectDefMinDistance(deerID, 0.0);
   rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(deerID, avoidDeer);
	rmAddObjectDefConstraint(deerID, avoidAll);
	rmAddObjectDefConstraint(deerID, avoidSocket);
	rmAddObjectDefConstraint(deerID, avoidTradeRoute);
   rmAddObjectDefConstraint(deerID, avoidImpassableLand);
      rmAddObjectDefConstraint(deerID, avoidStartingUnits);
      rmAddObjectDefConstraint(deerID, avoidStartingResources);
      rmAddObjectDefConstraint(deerID, avoidKOTH);
	rmSetObjectDefCreateHerd(deerID, true);
	rmPlaceObjectDefInArea(deerID, 0, bigContinentID, cNumberNonGaiaPlayers*5);
}else{
//1v1 hunts
//deer for center continent

    int mapElk = rmCreateObjectDef("mapElk");
    rmAddObjectDefItem(mapElk, "elk", rmRandInt(8,8), 6.0);
    rmSetObjectDefCreateHerd(mapElk, true);
    rmSetObjectDefMinDistance(mapElk, 0);
    rmSetObjectDefMaxDistance(mapElk, 8);
    rmAddObjectDefConstraint(mapElk, avoidSocket2);
 //   rmAddObjectDefConstraint(mapElk, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapElk, forestConstraintShort);	
    rmAddObjectDefConstraint(mapElk, avoidHunt3);
    rmAddObjectDefConstraint(mapElk, avoidAll);       
    rmAddObjectDefConstraint(mapElk, circleConstraint2);    
    rmAddObjectDefConstraint(mapElk, avoidWater6);
    rmAddObjectDefConstraint(mapElk, avoidStartingResourcesShort);
    
    int mapHunts = rmCreateObjectDef("mapHunts");
    rmAddObjectDefItem(mapHunts, "deer", rmRandInt(8,8), 6.0);
    rmSetObjectDefCreateHerd(mapHunts, true);
    rmSetObjectDefMinDistance(mapHunts, 0);
    rmSetObjectDefMaxDistance(mapHunts, 8);
    rmAddObjectDefConstraint(mapHunts, avoidSocket2);
 //   rmAddObjectDefConstraint(mapHunts, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapHunts, forestConstraintShort);	
    rmAddObjectDefConstraint(mapHunts, avoidHunt2);
    rmAddObjectDefConstraint(mapHunts, avoidAll);       
    rmAddObjectDefConstraint(mapHunts, circleConstraint2);    
    rmAddObjectDefConstraint(mapHunts, avoidWater6);
    rmAddObjectDefConstraint(mapHunts, avoidStartingResourcesShort);
    //place elk next to base first 
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.2, 0.70, 1);
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.8, 0.70, 1);  
    
    //east bot->top
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.34, 0.42, 1);
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.66, 0.42, 1);
    //end of TP east end
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.38, 1);
    //TRhunts top->mid
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.75, 1);
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.5, 0.57, 1);
    //toptop tr hunts
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.6, 0.85, 1);
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.4, 0.85, 1);
    
    //toptop side hunts
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.25, 0.85, 1);
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.75, 0.85, 1);

/*
    int marker1 = rmCreateArea("marker1");
    rmSetAreaSize(marker1, 0.01, 0.01);
    rmSetAreaLocation(marker1, 0.2, 0.65);
    rmSetAreaBaseHeight(marker1, 2.0);
    rmSetAreaCoherence(marker1, 1.0);
    rmSetAreaTerrainType(marker1, "texas\ground4_tex");
    rmBuildArea(marker1); 

    int marker2 = rmCreateArea("marker2");
    rmSetAreaSize(marker2, 0.01, 0.01);
    rmSetAreaLocation(marker2, 0.62, 0.36);
    rmSetAreaBaseHeight(marker2, 2.0);
    rmSetAreaCoherence(marker2, 1.0);
    rmSetAreaTerrainType(marker2, "texas\ground4_tex");
    rmBuildArea(marker2);*/
}

	// Text
   rmSetStatusText("",0.80);
   
if(cNumberNonGaiaPlayers>2){
//non 1v1 sheep
	int sheepID=rmCreateObjectDef("sheep");
	rmAddObjectDefItem(sheepID, "sheep", 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidSheep);
	rmAddObjectDefConstraint(sheepID, avoidAll);
	rmAddObjectDefConstraint(sheepID, avoidSocket);
	rmAddObjectDefConstraint(sheepID, avoidTradeRoute);
	rmAddObjectDefConstraint(sheepID, longPlayerConstraint);
	rmAddObjectDefConstraint(sheepID, avoidCliffs);
	rmAddObjectDefConstraint(sheepID, avoidKOTH);
	rmAddObjectDefConstraint(sheepID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);
}else{
        int avoidHerdablesTwoPlayer=rmCreateTypeDistanceConstraint("avoids cattle two player", "sheep", 28.0); 
        int sheepTwoPlayer=rmCreateObjectDef("sheepTwoPlayer");
        rmAddObjectDefItem(sheepTwoPlayer, "sheep", 1, 1);
        rmSetObjectDefMinDistance(sheepTwoPlayer, 0.0);
        rmSetObjectDefMaxDistance(sheepTwoPlayer, 16);
        rmAddObjectDefConstraint(sheepTwoPlayer, avoidHerdablesTwoPlayer);
        rmAddObjectDefConstraint(sheepTwoPlayer, avoidAll);
        rmAddObjectDefConstraint(sheepTwoPlayer, avoidTradeRoute);
        rmAddObjectDefConstraint(sheepTwoPlayer, avoidTC2p);
        rmAddObjectDefConstraint(sheepTwoPlayer, avoidImpassableLand);
        rmPlaceObjectDefAtLoc(sheepTwoPlayer, 0, 0.2, 0.65, 1);
        rmPlaceObjectDefAtLoc(sheepTwoPlayer, 0, 0.8, 0.65, 1);  
        rmPlaceObjectDefAtLoc(sheepTwoPlayer, 0, 0.38, 0.75, 1);
        rmPlaceObjectDefAtLoc(sheepTwoPlayer, 0, 0.62, 0.75, 1);        
        
        rmPlaceObjectDefAtLoc(sheepTwoPlayer, 0, 0.38, 0.36, 1);
        rmPlaceObjectDefAtLoc(sheepTwoPlayer, 0, 0.62, 0.36, 1);
}

	// Large decorations - cut for now.
   /*
	int bigDecorationID=rmCreateObjectDef("Big New England Things");
	int avoidBigDecoration=rmCreateTypeDistanceConstraint("avoid big decorations", "BigPropNewEngland", 12.0);
	rmAddObjectDefItem(bigDecorationID, "BigPropNewEngland", 1, 0.0);
	rmSetObjectDefMinDistance(bigDecorationID, 0.0);
	rmSetObjectDefMaxDistance(bigDecorationID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bigDecorationID, avoidAll);
	rmAddObjectDefConstraint(bigDecorationID, avoidImpassableLand);
	rmAddObjectDefConstraint(bigDecorationID, avoidBigDecoration);
	// rmPlaceObjectDefInArea(bigDecorationID, 0, bigContinentID, cNumberNonGaiaPlayers*2);
	// rmPlaceObjectDefInArea(bigDecorationID, 0, bonusIslandID1, 1);
	// rmPlaceObjectDefInArea(bigDecorationID, 0, bonusIslandID2, 1);
	*/

   // Text
   rmSetStatusText("",0.9);
   
  //removes walls from 1v1 because they cause pathing issues
if(cNumberNonGaiaPlayers>2){
	// Silly Rock Walls can get placed last.  May not place at all...
	int stoneWallType = -1;
	int stoneWallID = -1;
	int stoneWallCount = cNumberNonGaiaPlayers*2;	
	rmEchoInfo("stoneWall count = "+stoneWallCount);

	for(i=0; < stoneWallCount)
	{
		stoneWallType = rmRandInt(1,4);
      stoneWallID = rmCreateGrouping("stone wall "+i, "ne_rockwall "+stoneWallType);
		rmAddGroupingToClass(stoneWallID, rmClassID("classWall"));
      rmSetGroupingMinDistance(stoneWallID, 0.0);
      rmSetGroupingMaxDistance(stoneWallID, rmXFractionToMeters(0.5));
		rmAddGroupingConstraint(stoneWallID, avoidFastCoin);
		rmAddGroupingConstraint(stoneWallID, avoidImpassableLand);
		rmAddGroupingConstraint(stoneWallID, avoidTradeRoute);
		rmAddGroupingConstraint(stoneWallID, avoidSocket);
		rmAddGroupingConstraint(stoneWallID, wallConstraint);
		rmAddGroupingConstraint(stoneWallID, avoidWater20);
		rmAddGroupingConstraint(stoneWallID, avoidStartingUnits);
		rmAddGroupingConstraint(stoneWallID, avoidStartingResourcesFar);
		rmAddGroupingConstraint(stoneWallID, avoidTownCenter);
		rmAddGroupingConstraint(stoneWallID, avoidKOTHFar);
		rmAddGroupingConstraint(stoneWallID, avoidNatives);
		rmPlaceGroupingAtLoc(stoneWallID, 0, 0.5, 0.5);
   }
}

   // Define and place Nuggets  
	int nugget3ID= rmCreateObjectDef("nugget3"); 
	rmAddObjectDefItem(nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget3ID, 0.0);
	rmSetObjectDefMaxDistance(nugget3ID, rmXFractionToMeters(0.15));
	rmAddObjectDefConstraint(nugget3ID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nugget3ID, avoidNuggetFar);
	rmAddObjectDefConstraint(nugget3ID, avoidStartingUnits);
  	rmAddObjectDefConstraint(nugget3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget3ID, avoidSocket);
  	rmAddObjectDefConstraint(nugget3ID, avoidAll);
  	rmAddObjectDefConstraint(nugget3ID, avoidWater20);
	rmAddObjectDefConstraint(nugget3ID, circleConstraint);
	rmAddObjectDefConstraint(nugget3ID, stayMidSmIsland);
	rmAddObjectDefConstraint(nugget3ID, avoidTC2pFar);
	rmAddObjectDefConstraint(nugget3ID, avoidKOTH);
	rmSetNuggetDifficulty(3, 3);
	rmPlaceObjectDefInArea(nugget3ID, 0, bigContinentID, cNumberNonGaiaPlayers);

	int nugget2ID= rmCreateObjectDef("nugget2"); 
	rmAddObjectDefItem(nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget2ID, 0.0);
	rmSetObjectDefMaxDistance(nugget2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nugget2ID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nugget2ID, avoidNugget);
	rmAddObjectDefConstraint(nugget2ID, avoidStartingUnits);
  	rmAddObjectDefConstraint(nugget2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget2ID, avoidSocket);
  	rmAddObjectDefConstraint(nugget2ID, avoidAll);
  	rmAddObjectDefConstraint(nugget2ID, avoidWater20);
	rmAddObjectDefConstraint(nugget2ID, circleConstraint);
	rmAddObjectDefConstraint(nugget2ID, stayMidIsland);
	rmAddObjectDefConstraint(nugget2ID, avoidTC2p);
	rmAddObjectDefConstraint(nugget2ID, avoidKOTH);
	rmSetNuggetDifficulty(2, 2);
	rmPlaceObjectDefInArea(nugget2ID, 0, bigContinentID, cNumberNonGaiaPlayers+4);

	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.0);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidStartingUnits);
  	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidSocket);
  	rmAddObjectDefConstraint(nuggetID, avoidAll);
  	rmAddObjectDefConstraint(nuggetID, avoidWater20);
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidKOTH);
	rmAddObjectDefConstraint(nuggetID, avoidMidSmIslandMin);
	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefInArea(nuggetID, 0, bigContinentID, cNumberNonGaiaPlayers*3);



}