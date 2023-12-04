// CENTRAL PLAIN (1V1, TEAM, FFA)
// designed by Garja
// Relocated from Garja's High Plains by Interjection
//Ported by Durokan and Interjection for DE

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
	int playerTiles=11000; //12000
	if (PlayerNum >= 4)
		playerTiles=10000;
	if (PlayerNum >= 6)
		playerTiles=9000;
	int size=2.0*sqrt(PlayerNum*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(true);
		
	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Elevation noise
	rmSetMapElevationParameters(cElevTurbulence, 0.05, 3, 0.45, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetBaseTerrainMix("Great Plains Forest"); // Great Plains Grass Dry
	rmTerrainInitialize("great_plains\ground5_gp", 4.0); // texas\ground1_tex
	rmSetMapType("YellowRiver"); //greatPlains
	rmSetMapType("land");
	rmSetMapType("grass");
	rmSetLightingSet("High_Plains_Skirmish"); // Sonora
	
	// Wind
//	rmSetWindMagnitude(2.0);

	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Shaolin");
    //subCiv1 = rmGetCivID("Zen");
	subCiv1 = rmGetCivID("Shaolin");
	rmSetSubCiv(0, "Shaolin");
    //rmSetSubCiv(1, "Zen");
	rmSetSubCiv(1, "Shaolin");
//	rmEchoInfo("subCiv0 is Shaolin "+subCiv0);
//	rmEchoInfo("subCiv1 is Zen "+subCiv1);
//	rmEchoInfo("subCiv1 is Shaolin "+subCiv1);
//	string nativeName0 = "native shaolin temple mongol 0";
//	string nativeName1 = "native zen temple YR 0";
//	string nativeName1 = "native shaolin temple mongol 0";
	

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
    int classPatchdk = rmDefineClass("patchdk");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classGrass = rmDefineClass("grass");
	int classGeyser = rmDefineClass("geyser");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
	// Cardinal Directions & Map placement
	int Southeastconstraint = rmCreatePieConstraint("southeastMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(115), rmDegreesToRadians(290));
	int Northwestconstraint = rmCreatePieConstraint("northwestMapConstraint", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(295), rmDegreesToRadians(110));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeFurther = rmCreatePieConstraint("Avoid Edge Further",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.40), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterShort = rmCreatePieConstraint("Avoid Center Short",0.5,0.5,rmXFractionToMeters(0.07), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.30), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenterMore = rmCreatePieConstraint("Avoid Center More",0.5,0.5,rmXFractionToMeters(0.36), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.26), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center More",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.08), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayNEHalf = rmCreatePieConstraint("Stay NE half",0.55,0.55,rmXFractionToMeters(0.00), rmXFractionToMeters(0.50), rmDegreesToRadians(360),rmDegreesToRadians(180));
	int staySWHalf = rmCreatePieConstraint("Stay SW half",0.45,0.45,rmXFractionToMeters(0.00), rmXFractionToMeters(0.50), rmDegreesToRadians(180),rmDegreesToRadians(360));
	
		
	// Resource avoidance
//	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 38.0); //45.0
	int avoidForest = rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 32.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 18.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidForestGeyser=rmCreateClassDistanceConstraint("avoid forest geyser", rmClassID("Forest"), 12.0);
	int avoidypSerowFar = rmCreateTypeDistanceConstraint("avoid ypSerow far", "ypSerow", 48.0);
	int avoidypSerow = rmCreateTypeDistanceConstraint("avoid  ypSerow", "ypSerow", 40.0);
	int avoidypSerowShort = rmCreateTypeDistanceConstraint("avoid  ypSerow short", "ypSerow", 20.0);
	int avoidypSerowMin = rmCreateTypeDistanceConstraint("avoid ypSerow min", "ypSerow", 8.0);
	int avoidYPMuskDeerMin = rmCreateTypeDistanceConstraint("avoid YPMuskDeer min", "YPMuskDeer", 8.0);
	int avoidYPMuskDeerShort = rmCreateTypeDistanceConstraint("avoid YPMuskDeer short", "YPMuskDeer", 20.0);
	int avoidYPMuskDeer = rmCreateTypeDistanceConstraint("avoid YPMuskDeer", "YPMuskDeer", 40.0);
	int avoidYPMuskDeerFar = rmCreateTypeDistanceConstraint("avoid YPMuskDeer far", "YPMuskDeer", 48.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("avoid gold min", "gold", 15.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 10.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 30.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 10.0);
	int avoidGold = rmCreateClassDistanceConstraint ("avoid gold", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("avoid gold far", rmClassID("Gold"), 55.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("avoid gold very far ", rmClassID("Gold"), 70.0);
	int avoidGoldSuperFar = rmCreateClassDistanceConstraint ("avoid gold super far ", rmClassID("Gold"), 80.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("avoid nugget min", "AbstractNugget", 10.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("avoid nugget Far", "AbstractNugget", 48.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 72.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 66.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 40.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 58.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 29.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidPlayerArea = rmCreateClassDistanceConstraint ("avoid player area", rmClassID("player"), 18.0);
	
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other short", rmClassID("startingResource"), 4.0);
	int avoidCow = rmCreateTypeDistanceConstraint("avoid cow", "cow", 66.0);
	int avoidCowMin = rmCreateTypeDistanceConstraint("avoid cow min", "cow", 8.0);
	

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 8.0);
	int avoidImpassableLandLong=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 25.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 3.0);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 10);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "water", true, 25.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 8.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", rmClassID("patch2"), 8.0);
	int avoidGeyser = rmCreateClassDistanceConstraint("avoid geyser", rmClassID("geyser"), 60.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("cliff avoid cliff", rmClassID("Cliffs"), 40.0);
	int avoidCliffShort = rmCreateClassDistanceConstraint("cliff avoid cliff short", rmClassID("Cliffs"), 10.0);
    int avoidPatchdk = rmCreateClassDistanceConstraint("avoid patchdk", rmClassID("patchdk"), 38.0);	

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);
		
	
	// VP avoidance
//	int stayNearTradeRoute = rmCreateTradeRouteMaxDistanceConstraint("stay near trade route", 5.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("avoid trade route", 8.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("avoid trade route short", 5.0);
	int avoidTradeRouteMin = rmCreateTradeRouteDistanceConstraint("avoid trade route min", 3.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route socket short", "socketTradeRoute", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 10.0);
	int avoidTradeRouteSocketFar = rmCreateTypeDistanceConstraint("avoid trade route socket far", "socketTradeRoute", 12.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("avoid natives short", rmClassID("natives"), 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("avoid natives", rmClassID("natives"), 8.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("avoid natives far", rmClassID("natives"), 12.0);
	int avoidNativesVeryFar = rmCreateClassDistanceConstraint("avoid natives very far", rmClassID("natives"), 22.0);

	// KotH avoidance
	int avoidKingsHill = rmCreateTypeDistanceConstraint("avoid kings hill", "ypKingsHill", 10.0);
	
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
					rmPlacePlayer(1, 0.18, 0.50);
					rmPlacePlayer(2, 0.82, 0.50);
				}
				else
				{
					rmPlacePlayer(2, 0.18, 0.50);
					rmPlacePlayer(1, 0.82, 0.50);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.688, 0.812); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.188, 0.312); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.655, 0.845); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.155, 0.345); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.249, 0.251); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.688, 0.812); //
						else
							rmSetPlacementSection(0.655, 0.845); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.188, 0.312); //
						else
							rmSetPlacementSection(0.155, 0.345); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.749, 0.751); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.688, 0.812); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.155, 0.345); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.655, 0.845); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.188, 0.312); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.155, 0.345); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.655, 0.845); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
		}
		else // FFA
		{
			rmSetPlacementSection(0.220, 0.780);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.40, 0.40, 0.0);
		}
	
	
	// **************************************************************************************************

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
        if(cNumberTeams>2){
            randLoc = rmRandInt(2,3);
        }
		float xLoc = 0.5;
		float yLoc = 0.45;
		float walk = 0.01;

		if (randLoc == 1) {
			xLoc = 0.5;
			yLoc = 0.1;
		} else if (randLoc == 3) {
			xLoc = 0.5;
			yLoc = 0.66;
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

	int tpvariation = -1;
	tpvariation = rmRandInt(0,1);
//	int	tpvariation = 1; // <--- TEST
	if (TeamNum > 2 || rmGetIsKOTH())
		tpvariation = 2;
	
	if (tpvariation == 0)
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.00); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 1.00); 
	}
	else if (tpvariation == 1)
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.00); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.40, 0.65); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.60, 1.00); 
	}
	else
	{
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.85); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.25, 0.75); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.55); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.75, 0.75); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.85, 0.85); 
	}
	
	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "water");
//	if(placedTradeRouteA == false)
//	rmEchoError("Failed to place trade route 1");
//	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.08);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.30); // 0.36
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50); // 0.36
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.70); // 0.66
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.92);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	
	// *************************************************************************************************************
   	
	// **************************************** NATURE DESIGN & AREAS **********************************************
	
	// Players area
	for (i=1; < numPlayer)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.06-0.005*PlayerNum, 0.06-0.005*PlayerNum);
	rmAddAreaToClass(playerareaID, rmClassID("player"));
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
//	rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne");
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
//	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 18.0);
	int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay player area "+i, playerareaID, 0.0);
	}
	
//	int avoidPlayerArea1 = rmConstraintID("avoid player area 1");
//	int avoidPlayerArea2 = rmConstraintID("avoid player area 2");
	int stayPlayerArea1 = rmConstraintID("stay player area 1");
	int stayPlayerArea2 = rmConstraintID("stay player area 2");

// Light Smattering of Araucania grass to bridge the jaring terrain jump to Green hill zone
	for (i=0; < cNumberNonGaiaPlayers*75){
			int araGround = rmCreateArea("the redder stuff 2"+i);
			rmSetAreaWarnFailure(araGround, false);
			rmSetAreaSize(araGround, rmAreaTilesToFraction(11), rmAreaTilesToFraction(19));
            rmSetAreaTerrainType(araGround, "araucania\ground_grass1_ara");
            rmAddAreaToClass(araGround, rmClassID("patchdk"));
            rmAddAreaConstraint(araGround, avoidPatch); 
			rmBuildArea(araGround); 
            rmPaintAreaTerrain(araGround);
		}	
	
	// Green hill zone  
	int hillNorthwestID=rmCreateArea("northwest hills");
	rmSetAreaSize(hillNorthwestID, 0.24, 0.24);
	rmSetAreaWarnFailure(hillNorthwestID, false);
	rmSetAreaMix(hillNorthwestID, "Yellow_River_A");
//	rmSetAreaTerrainType(hillNorthwestID, "Yellow_river\grass1_yellow_riv");
	rmAddAreaTerrainLayer(hillNorthwestID, "araucania\ground_grass1_ara", 2, 3);
	rmAddAreaTerrainLayer(hillNorthwestID, "Yellow_river\grass1_yellow_riv", 3, 6);
	rmSetAreaElevationType(hillNorthwestID, cElevTurbulence);
	rmSetAreaElevationVariation(hillNorthwestID, 4.0);
	rmSetAreaBaseHeight(hillNorthwestID, 6);
	rmSetAreaElevationMinFrequency(hillNorthwestID, 0.05);
	rmSetAreaElevationOctaves(hillNorthwestID, 3);
	rmSetAreaElevationPersistence(hillNorthwestID, 0.5);      
//	rmSetAreaElevationNoiseBias(hillNorthwestID, 0.5);
//	rmSetAreaElevationEdgeFalloffDist(hillNorthwestID, 20.0);
	rmSetAreaCoherence(hillNorthwestID, 0.50);
	rmSetAreaSmoothDistance(hillNorthwestID, 8);
	rmSetAreaLocation(hillNorthwestID, 0.5, 0.88);
	rmSetAreaEdgeFilling(hillNorthwestID, 5);
	rmAddAreaInfluenceSegment(hillNorthwestID, 0.0, 0.85, 1.0, 0.85);
//	rmSetAreaHeightBlend(hillNorthwestID, 1.9);
	rmSetAreaObeyWorldCircleConstraint(hillNorthwestID, false);
	rmBuildArea(hillNorthwestID);
		
	int avoidNW = rmCreateAreaDistanceConstraint("avoid nw", hillNorthwestID, 3.0);
	int stayNW = rmCreateAreaMaxDistanceConstraint("stay nw", hillNorthwestID, 0.0);
	
	// ********************************************* NATIVES ************************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
	
	int natAreaA = rmCreateArea("nats area A");
	rmSetAreaWarnFailure(natAreaA, false);
	rmSetAreaSize(natAreaA, 0.045-0.005*PlayerNum, 0.045-0.005*PlayerNum);
	rmSetAreaCoherence(natAreaA, 0.7);
	rmSetAreaSmoothDistance(natAreaA, 4);
//	rmSetAreaTerrainType(natAreaA, "new_england\ground2_cliff_ne");
	
	int natAreaB = rmCreateArea("nats area B");
	rmSetAreaWarnFailure(natAreaB, false);
	rmSetAreaSize(natAreaB, 0.045-0.005*PlayerNum, 0.045-0.005*PlayerNum);
	rmSetAreaCoherence(natAreaB, 0.7);
	rmSetAreaSmoothDistance(natAreaB, 4);
//	rmSetAreaTerrainType(natAreaB, "new_england\ground2_cliff_ne");
	
	int natAreaC = rmCreateArea("nats area C");
	rmSetAreaWarnFailure(natAreaC, false);
	rmSetAreaSize(natAreaC, 0.045-0.005*PlayerNum, 0.045-0.005*PlayerNum);
	rmSetAreaCoherence(natAreaC, 0.7);
	rmSetAreaSmoothDistance(natAreaC, 4);
//	rmSetAreaTerrainType(natAreaC, "new_england\ground2_cliff_ne");
	
	int natAreaD = rmCreateArea("nats area D");
	rmSetAreaWarnFailure(natAreaD, false);
	rmSetAreaSize(natAreaD, 0.045-0.005*PlayerNum, 0.045-0.005*PlayerNum);
	rmSetAreaCoherence(natAreaD, 0.7);
	rmSetAreaSmoothDistance(natAreaD, 4);
//	rmSetAreaTerrainType(natAreaD, "new_england\ground2_cliff_ne");
	
	
		
	nativeID0 = rmCreateGrouping("Shaolin village A", "native shaolin temple mongol 0"+5);
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.4);
	rmAddGroupingConstraint(nativeID0, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID0, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID0, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.65, 0.30);
		rmSetAreaLocation(natAreaA, 0.65, 0.30);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.35, 0.25);
		rmSetAreaLocation(natAreaA, 0.35, 0.25);
	}
	else 
	{
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.35, 0.35);
		rmSetAreaLocation(natAreaA, 0.35, 0.35);
	}
		
	nativeID2 = rmCreateGrouping("Shaolin village B", "native shaolin temple mongol 0"+1);  // +1
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.4);
	rmAddGroupingConstraint(nativeID2, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID2, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID2, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.35, 0.75);
		rmSetAreaLocation(natAreaB, 0.35, 0.75);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.65, 0.75);
		rmSetAreaLocation(natAreaB, 0.65, 0.75);
	}
	else 
	{
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.65, 0.35);
		rmSetAreaLocation(natAreaB, 0.65, 0.35);
	}
    
	//possibly patch me to ZEN
    //nativeID1 = rmCreateGrouping("Zen temple A", "native zen temple YR 0"+1);
	nativeID1 = rmCreateGrouping("Shaolin village C", "native shaolin temple mongol 0"+5); // +3
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.4);
	rmAddGroupingConstraint(nativeID1, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID1, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID1, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.30, 0.20);
		rmSetAreaLocation(natAreaC, 0.30, 0.20);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.72, 0.20);
		rmSetAreaLocation(natAreaC, 0.72, 0.20);
	}
	else 
	{
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.60, 0.85);
		rmSetAreaLocation(natAreaC, 0.60, 0.85);
	}
	//possibly patch me to ZEN
    //nativeID3 = rmCreateGrouping("Zen temple B", "native zen temple YR 0"+1);
	nativeID3 = rmCreateGrouping("Shaolin village D", "native shaolin temple mongol 0"+1);
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.4);
	rmAddGroupingConstraint(nativeID3, avoidImpassableLandMed);
	rmAddGroupingConstraint(nativeID3, avoidTradeRouteShort);
	rmAddGroupingConstraint(nativeID3, avoidTradeRouteSocket);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
	if (tpvariation == 0)
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.70, 0.85);
		rmSetAreaLocation(natAreaD, 0.70, 0.85);
	}
	else if (tpvariation == 1)
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.30, 0.85);
		rmSetAreaLocation(natAreaD, 0.30, 0.85);
	}
	else
	{
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.40, 0.85);
		rmSetAreaLocation(natAreaD, 0.40, 0.85);
	}
	
	rmBuildArea(natAreaA);
	rmBuildArea(natAreaB);
	rmBuildArea(natAreaC);
	rmBuildArea(natAreaD);
	
	int stayInAreaA = rmCreateAreaMaxDistanceConstraint("stay in nat area A", natAreaA, 0.0);
	int stayInAreaB = rmCreateAreaMaxDistanceConstraint("stay in nat area B", natAreaB, 0.0);
	int stayInAreaC = rmCreateAreaMaxDistanceConstraint("stay in nat area C", natAreaC, 0.0);
	int stayInAreaD = rmCreateAreaMaxDistanceConstraint("stay in nat area D", natAreaD, 0.0);
	
	int avoidAreaA = rmCreateAreaDistanceConstraint("avoid nat area A", natAreaA, 2.0);
	int avoidAreaB = rmCreateAreaDistanceConstraint("avoid nat area B", natAreaB, 2.0);
	int avoidAreaC = rmCreateAreaDistanceConstraint("avoid nat area C", natAreaC, 2.0);
	int avoidAreaD = rmCreateAreaDistanceConstraint("avoid nat area D", natAreaD, 2.0);
	
	// ******************************************************************************************************
	
	
	// Cliffs
	int cliffcount = 4+0.5*PlayerNum; 
	
	for (i= 0; < cliffcount)
	{
		int cliffID = rmCreateArea("cliff"+i);
		rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
		rmSetAreaSize(cliffID, rmAreaTilesToFraction(360), rmAreaTilesToFraction(360));  
		rmSetAreaWarnFailure(cliffID, true);
		rmSetAreaObeyWorldCircleConstraint(cliffID, false);
		rmSetAreaCliffType(cliffID, "Coastal Japan"); // great plains
		rmSetAreaCliffPainting(cliffID, false, false, true, 0.1 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
	//	rmSetAreaTerrainType(cliffID, "pampas\groundforest_pam", 0, 0);
		rmSetAreaCliffEdge(cliffID, 1, rmRandFloat(0.28, 0.28) , 0.0, 0.0, 1); // rmRandFloat(0.24, 0.28)
		rmSetAreaCliffHeight(cliffID, 3.5, 0.2, 0.4); 
		rmSetAreaHeightBlend(cliffID, 2);
		rmSetAreaCoherence(cliffID, 0.8);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmAddAreaConstraint (cliffID, avoidCliff);
		rmAddAreaConstraint (cliffID, avoidEdge);	
//		rmAddAreaConstraint(cliffID, avoidNativesFar);
		rmAddAreaConstraint(cliffID, avoidTradeRouteSocket);
		rmAddAreaConstraint(cliffID, avoidTradeRouteShort);
		rmAddAreaConstraint (cliffID, avoidPlayerArea);
		rmAddAreaConstraint (cliffID, avoidNW);
//		rmAddAreaConstraint (cliffID, avoidSE);
		rmAddAreaConstraint (cliffID, avoidAreaA);
		rmAddAreaConstraint (cliffID, avoidAreaB);
		rmAddAreaConstraint (cliffID, avoidAreaC);
		rmAddAreaConstraint (cliffID, avoidAreaD);
		rmSetAreaWarnFailure(cliffID, false);
		rmBuildArea(cliffID);		
	}



	// Terrain patch NW
	for (i=0; < 8+4*PlayerNum)
      {
        int NWpatchID = rmCreateArea("NW patch "+i);
        rmSetAreaWarnFailure(NWpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(NWpatchID, false);
        rmSetAreaSize(NWpatchID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(60));
		rmAddAreaToClass(NWpatchID, classPatch2);
//		rmSetAreaMix(NWpatchID, "pampas_grass"); //pampas_grass
        rmSetAreaTerrainType(NWpatchID, "araucania\ground_grass1_ara"); //Yellow_river\grass1_yellow_riv
        rmSetAreaMinBlobs(NWpatchID, 4);
        rmSetAreaMaxBlobs(NWpatchID, 6);
        rmSetAreaMinBlobDistance(NWpatchID, 16.0);
        rmSetAreaMaxBlobDistance(NWpatchID, 40.0);
        rmSetAreaCoherence(NWpatchID, 0.0);
//		rmAddAreaConstraint(NWpatchID, avoidImpassableLandShort);
		rmAddAreaConstraint(NWpatchID, avoidPatch2);
		rmAddAreaConstraint (NWpatchID, stayNW);
        rmBuildArea(NWpatchID); 
    }
	
	// Terrain patch1
	for (i=0; < 10+4*PlayerNum)
      {
        int patchID = rmCreateArea("first patch "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(50));
		rmAddAreaToClass(patchID, classPatch);
	//	rmSetAreaMix(patchID, "coastal_honshu_b"); //pampas_grass
        rmSetAreaTerrainType(patchID, "coastal_japan\ground_Grass1_co_japan"); //   araucania\ground_grass1_ara
        rmSetAreaMinBlobs(patchID, 4);
        rmSetAreaMaxBlobs(patchID, 6);
        rmSetAreaMinBlobDistance(patchID, 16);
        rmSetAreaMaxBlobDistance(patchID, 40);
        rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidImpassableLandShort);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint (patchID, avoidNW);
        rmBuildArea(patchID); 
    }

	// Grass
	for (i=0; < 30+6*PlayerNum)
	{
		int GrassID = rmCreateObjectDef("drygrass"+i);
		rmAddObjectDefItem(GrassID, "UnderbrushYellowRiver", rmRandInt(2,3), 6.0);
		rmAddObjectDefItem(GrassID, "UnderbrushCarolinasForest", rmRandInt(1,3), 6.0);
		rmSetObjectDefMinDistance(GrassID, 0);
		rmSetObjectDefMaxDistance(GrassID, rmXFractionToMeters(0.6));
		rmAddObjectDefToClass(GrassID, rmClassID("grass"));
	//	rmAddObjectDefConstraint(GrassID, avoidGrass);
		rmAddObjectDefConstraint(GrassID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(GrassID, avoidTownCenterShort);
	//	rmAddObjectDefConstraint (GrassID, avoidNW);
		rmPlaceObjectDefAtLoc(GrassID, 0, 0.50, 0.50);
	}
	

	// *****************************************************************************************************	
	
	// Text
	rmSetStatusText("",0.30);
	
	
	
	// Text
	rmSetStatusText("",0.40);
		
	
	
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
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmAddObjectDefToClass(TCID, classStartingResource);
    if(cNumberNonGaiaPlayers>2){
        rmSetObjectDefMaxDistance(TCID, 15.0);
        int teamZeroCount_dk = rmGetNumberPlayersOnTeam(0);
        int teamOneCount_dk = rmGetNumberPlayersOnTeam(1);
        if((cNumberTeams == 2) && (teamZeroCount_dk != teamOneCount_dk)){
            rmSetObjectDefMaxDistance(TCID, 30.0);
        }
    }else{
        rmSetObjectDefMaxDistance(TCID, 0.0);
    }
	
	
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 18.0);
	rmSetObjectDefMaxDistance(playergoldID, 18.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 18.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 18.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	
	// 3nd mine
	int playergold3ID = rmCreateObjectDef("player third mine");
	rmAddObjectDefItem(playergold3ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold3ID, 68.0); //58
	rmSetObjectDefMaxDistance(playergold3ID, 70.0); //62
	rmAddObjectDefToClass(playergold3ID, classStartingResource);
	rmAddObjectDefToClass(playergold3ID, classGold);
	rmAddObjectDefConstraint(playergold3ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playergold3ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playergold3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold3ID, avoidNatives);
	rmAddObjectDefConstraint(playergold3ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold3ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold3ID, avoidEdgeMore);
	rmAddObjectDefConstraint(playergold3ID, avoidCenterMore);
	
	// Starting trees1
	int playerTree1ID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTree1ID, "ypTreeGinkgo", rmRandInt(1,1), 1.0); // TreeTexasDirt
    rmSetObjectDefMinDistance(playerTree1ID, 14);
    rmSetObjectDefMaxDistance(playerTree1ID, 16);
	rmAddObjectDefToClass(playerTree1ID, classStartingResource);
//	rmAddObjectDefToClass(playerTree1ID, classForest);
//	rmAddObjectDefConstraint(playerTree1ID, avoidForestMin);
	rmAddObjectDefConstraint(playerTree1ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree1ID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees2");
	rmAddObjectDefItem(playerTree2ID, "ypTreeGinkgo", rmRandInt(2,2), 2.0); // TreeTexasDirt
    rmSetObjectDefMinDistance(playerTree2ID, 16);
    rmSetObjectDefMaxDistance(playerTree2ID, 18);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
//	rmAddObjectDefToClass(playerTree2ID, classForest);
//	rmAddObjectDefConstraint(playerTree2ID, avoidForestMin);
	rmAddObjectDefConstraint(playerTree2ID, avoidTradeRoute);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerherdID, "YPMuskDeer", 7, 4.0);
	rmSetObjectDefMinDistance(playerherdID, 8.0);
	rmSetObjectDefMaxDistance(playerherdID, 12.0);
	rmSetObjectDefCreateHerd(playerherdID, true);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResourcesShort);
		
	// 2nd herd
	int playerYPMuskDeerID = rmCreateObjectDef("player YPMuskDeer");
    rmAddObjectDefItem(playerYPMuskDeerID, "YPMuskDeer", 9, 4.0);
    rmSetObjectDefMinDistance(playerYPMuskDeerID, 36);
    rmSetObjectDefMaxDistance(playerYPMuskDeerID, 36);
	rmSetObjectDefCreateHerd(playerYPMuskDeerID, true);
	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidNativesShort);
//	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidStartingResources);
	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidYPMuskDeer); 
	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidypSerowShort);
//	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidCenterMore);
	rmAddObjectDefConstraint(playerYPMuskDeerID, avoidEdge);
	
	// 3rd herd
	int playerypSerowID = rmCreateObjectDef("player ypSerow");
    rmAddObjectDefItem(playerypSerowID, "ypSerow", rmRandInt(10,10), 8.0);
    rmSetObjectDefMinDistance(playerypSerowID, 45);
    rmSetObjectDefMaxDistance(playerypSerowID, 47);
	rmSetObjectDefCreateHerd(playerypSerowID, true);
	rmAddObjectDefConstraint(playerypSerowID, avoidYPMuskDeer); 
	rmAddObjectDefConstraint(playerypSerowID, avoidypSerow);
//	rmAddObjectDefConstraint(playerypSerowID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(playerypSerowID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerypSerowID, avoidNativesShort);
//	rmAddObjectDefConstraint(playerypSerowID, avoidCenterShort);
//	rmAddObjectDefConstraint(playerypSerowID, avoidStartingResources);
//	rmAddObjectDefConstraint(playerypSerowID, avoidEdge);

	
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNugget);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (2,2); // 1,2
	
	// ******** Place ********
	
	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playergold3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree1ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree1ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree1ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
		rmPlaceObjectDefAtLoc(playerYPMuskDeerID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerypSerowID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (nugget0count == 2)
			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		vector closestPoint = rmFindClosestPointVector(TCLoc, rmXFractionToMeters(1.0));
	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ********** Mines ***********
	
	int goldCount = 1.5*PlayerNum;  // 4+2*PlayerNum
		
/*	//Mines
	for(i=0; < goldCount)
	{
		int goldID = rmCreateObjectDef("gold"+i);
		rmAddObjectDefItem(goldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(goldID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(goldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(goldID, classGold);
		rmAddObjectDefConstraint(goldID, avoidTradeRouteSocketFar);
		rmAddObjectDefConstraint(goldID, avoidTradeRoute);
		rmAddObjectDefConstraint(goldID, avoidImpassableLand);
		rmAddObjectDefConstraint(goldID, avoidNatives);
		rmAddObjectDefConstraint(goldID, avoidGoldVeryFar);
//		rmAddObjectDefConstraint(goldID, Northwestconstraint);
		rmAddObjectDefConstraint(goldID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(goldID, avoidStartingResources);
		rmAddObjectDefConstraint(goldID, avoidEdge);
		rmPlaceObjectDefAtLoc(goldID, 0, 0.50, 0.50);
	}
*/
		// Symmetrical Mines - from Riki (thx)
		int silverIDSA = -1;
		silverIDSA = rmCreateObjectDef("silver STARTA");
		rmAddObjectDefItem(silverIDSA, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverIDSA, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silverIDSA, rmXFractionToMeters(0.00));
		rmAddObjectDefToClass(silverIDSA, classGold);
		rmAddObjectDefConstraint(silverIDSA, avoidCenterShort);
		rmAddObjectDefConstraint(silverIDSA, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(silverIDSA, avoidTradeRoute);
		rmAddObjectDefConstraint(silverIDSA, avoidTradeRouteSocketFar);
		rmAddObjectDefConstraint(silverIDSA, avoidEdge);
		rmAddObjectDefConstraint(silverIDSA, avoidStartingResources);
		rmAddObjectDefConstraint(silverIDSA, avoidNatives);
		rmAddObjectDefConstraint(silverIDSA, avoidImpassableLand);
		rmAddObjectDefConstraint(silverIDSA, avoidGoldVeryFar);

		int silverIDSB = -1;
		silverIDSB = rmCreateObjectDef("silver STARTB");
		rmAddObjectDefItem(silverIDSB, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverIDSB, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silverIDSB, 6);
		rmAddObjectDefToClass(silverIDSB, classGold);
		rmAddObjectDefConstraint(silverIDSB, avoidImpassableLandShort);

		int minePlacement=0;
		float minePositionX=-1;
		float minePositionZ=-1;
		int result=0;
		int leaveWhile=0;

		while (minePlacement < goldCount) 
		{
			minePositionX=rmRandFloat(0.05,0.95);
			minePositionZ=rmRandFloat(0.05,0.95);
			rmSetObjectDefForceFullRotation(silverIDSA, true);
			result=rmPlaceObjectDefAtLoc(silverIDSA, 0, minePositionX, minePositionZ);
			if (result == 1)
			{
				rmSetObjectDefForceFullRotation(silverIDSB, true);
				rmPlaceObjectDefAtLoc(silverIDSB, 0, 1.0-minePositionX, 1.0-minePositionZ);
				minePlacement++;
				leaveWhile=0;
			}
			else
				leaveWhile++;
			if (leaveWhile==300)
				break;
		}

	// ****************************

		// ********** Herds ***********
		
	int ypSerowcount = 2*PlayerNum;	// 1+1*PlayerNum

		// Symmetrical Hunts - from Riki (thx)
		int mapHuntAID = -1;
		mapHuntAID = rmCreateObjectDef("hunt A");
		rmAddObjectDefItem(mapHuntAID, "ypSerow", 12, 5.0);
		rmSetObjectDefMinDistance(mapHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(mapHuntAID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(mapHuntAID, true);
		rmAddObjectDefConstraint(mapHuntAID, avoidCenterShort);
		rmAddObjectDefConstraint(mapHuntAID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(mapHuntAID, avoidStartingResources);
		rmAddObjectDefConstraint(mapHuntAID, avoidNativesShort);
		rmAddObjectDefConstraint(mapHuntAID, avoidTownCenterFar);
		rmAddObjectDefConstraint(mapHuntAID, avoidForestMin);
		rmAddObjectDefConstraint(mapHuntAID, avoidGoldMin);
		rmAddObjectDefConstraint(mapHuntAID, avoidypSerowFar);
		rmAddObjectDefConstraint(mapHuntAID, avoidYPMuskDeerFar);
		rmAddObjectDefConstraint(mapHuntAID, avoidImpassableLandShort);

		int mapHuntBID = -1;
		mapHuntBID = rmCreateObjectDef("hunt B");
		rmAddObjectDefItem(mapHuntBID, "ypSerow", 12, 5.0);
		rmSetObjectDefMinDistance(mapHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(mapHuntBID, rmXFractionToMeters(0.00));
		rmSetObjectDefCreateHerd(mapHuntBID, true);

		int huntPlacement=0;
		float huntPositionX=-1;
		float huntPositionZ=-1;
		int resultF=0;
		int leaveWhileF=0;

		while (huntPlacement < ypSerowcount) 
		{
			huntPositionX=rmRandFloat(0.03,0.97);
			huntPositionZ=rmRandFloat(0.03,0.97);
			resultF=rmPlaceObjectDefAtLoc(mapHuntAID, 0, huntPositionX, huntPositionZ);
			if (resultF != 0)
			{
				rmPlaceObjectDefAtLoc(mapHuntBID, 0, 1.0-huntPositionX, 1.0-huntPositionZ);
				huntPlacement++;
				leaveWhileF=0;
			}
			else
				leaveWhileF++;
			if (leaveWhileF==300)
				break;
		}
	// ****************************

	// Text
	rmSetStatusText("",0.70);
			
	// *********** Forests ************

	int dirtforestcount = 8+4*PlayerNum;
	int greenforestcount = 4+1*PlayerNum;
	int greenforestsmallcount = 3+1*PlayerNum;
	
	// Green forests big
	for (i=0; < greenforestcount)
	{
		int greenforestID = rmCreateArea("forest green"+i);
		rmSetAreaWarnFailure(greenforestID, false);
		rmSetAreaSize(greenforestID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(170));
		rmSetAreaForestType(greenforestID, "Yellow River forest");
//		rmSetAreaObeyWorldCircleConstraint(greenforestID, false);
		rmSetAreaForestDensity(greenforestID, 0.85);
		rmSetAreaForestClumpiness(greenforestID, 0.25);
		rmSetAreaForestUnderbrush(greenforestID, 0.5);
		rmSetAreaCoherence(greenforestID, 0.8);
		rmAddAreaToClass(greenforestID, classForest);
		rmAddAreaConstraint(greenforestID, avoidTownCenterShort);
		rmAddAreaConstraint(greenforestID, avoidForest);
		rmAddAreaConstraint(greenforestID, avoidTradeRoute);
		rmAddAreaConstraint(greenforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(greenforestID, avoidImpassableLand);
		rmAddAreaConstraint(greenforestID, avoidNatives);	
		rmAddAreaConstraint(greenforestID, avoidGoldMin);
		rmAddAreaConstraint(greenforestID, avoidypSerowMin);
		rmAddAreaConstraint(greenforestID, avoidStartingResources);
		rmAddAreaConstraint(greenforestID, avoidYPMuskDeerMin);
		rmAddAreaConstraint(greenforestID, stayNW);
		rmBuildArea(greenforestID);
	}
	
	// Green forests small
	for (i=0; < greenforestsmallcount)
	{
		int greenforestsmallID = rmCreateArea("forest green small"+i);
		rmSetAreaWarnFailure(greenforestsmallID, false);
		rmSetAreaSize(greenforestsmallID, rmAreaTilesToFraction(70), rmAreaTilesToFraction(80));
		rmSetAreaForestType(greenforestsmallID, "bamboo Forest");
//		rmSetAreaObeyWorldCircleConstraint(greenforestsmallID, false);
		rmSetAreaForestDensity(greenforestsmallID, 0.70);
		rmSetAreaForestClumpiness(greenforestsmallID, 0.30);
		rmSetAreaForestUnderbrush(greenforestsmallID, 0.5);
		rmSetAreaCoherence(greenforestsmallID, 0.8);
		rmSetAreaSmoothDistance(greenforestsmallID, 6);
		rmAddAreaToClass(greenforestsmallID, classForest);
		rmAddAreaConstraint(greenforestsmallID, avoidTownCenterShort);
		rmAddAreaConstraint(greenforestsmallID, avoidForestShort);
		rmAddAreaConstraint(greenforestsmallID, avoidTradeRoute);
		rmAddAreaConstraint(greenforestsmallID, avoidTradeRouteSocket);
		rmAddAreaConstraint(greenforestsmallID, avoidImpassableLand);
		rmAddAreaConstraint(greenforestsmallID, avoidNatives);	
		rmAddAreaConstraint(greenforestsmallID, avoidGoldMin);
		rmAddAreaConstraint(greenforestsmallID, avoidypSerowMin);
		rmAddAreaConstraint(greenforestsmallID, avoidStartingResources);
		rmAddAreaConstraint(greenforestsmallID, avoidYPMuskDeerMin);
		rmAddAreaConstraint(greenforestsmallID, stayNW);
		rmBuildArea(greenforestsmallID);
	}
			
	// Forests dirt
	int stayInDirtforest = -1;
	
	for (i=0; < dirtforestcount)
	{
		int dirtforestID = rmCreateArea("forest dirt"+i);
		rmSetAreaWarnFailure(dirtforestID, false);
		rmSetAreaSize(dirtforestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(100));
//		rmSetAreaObeyWorldCircleConstraint(dirtforestID, false);
		rmSetAreaCoherence(dirtforestID, 0.8);
		rmSetAreaSmoothDistance(dirtforestID, 6);
		rmAddAreaToClass(dirtforestID, classForest);
		rmAddAreaConstraint(dirtforestID, avoidForest);
		rmAddAreaConstraint(dirtforestID, avoidTradeRoute);
		rmAddAreaConstraint(dirtforestID, avoidTradeRouteSocket);
		rmAddAreaConstraint(dirtforestID, avoidImpassableLand);
		rmAddAreaConstraint(dirtforestID, avoidNatives);	
		rmAddAreaConstraint(dirtforestID, avoidGoldMin);
		rmAddAreaConstraint(dirtforestID, avoidypSerowMin);
		rmAddAreaConstraint(dirtforestID, avoidYPMuskDeerMin);
		rmAddAreaConstraint(dirtforestID, avoidNW);
		rmAddAreaConstraint(dirtforestID, avoidStartingResources);
		rmAddAreaConstraint(dirtforestID, avoidTownCenterShort);
		rmBuildArea(dirtforestID);
		
		stayInDirtforest = rmCreateAreaMaxDistanceConstraint("stay in dirt forest"+i, dirtforestID, 0);
		
		for (j=0; < rmRandInt(8,10))
		{
			int dirtforesttreeID = rmCreateObjectDef("dirt forest trees"+i+j);
			rmAddObjectDefItem(dirtforesttreeID, "ypTreeGinkgo", rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(dirtforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(dirtforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(dirtforesttreeID, classForest);
		//	rmAddObjectDefConstraint(dirtforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(dirtforesttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(dirtforesttreeID, stayInDirtforest);	
			rmPlaceObjectDefAtLoc(dirtforesttreeID, 0, 0.50, 0.50);
		}
	}
/*		
	//Tree clumps to fill the void 
	int voidtreeID = rmCreateObjectDef("void tree");
	rmAddObjectDefItem(voidtreeID, "ypTreeBamboo", rmRandInt(7,9), 7.0); //TreeGreatPlains
    rmSetObjectDefMinDistance(voidtreeID, 0);
    rmSetObjectDefMaxDistance(voidtreeID, 30);
	rmAddObjectDefToClass(voidtreeID, classForest);
	rmAddObjectDefConstraint(voidtreeID, avoidForestShort);
	rmAddObjectDefConstraint(voidtreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(voidtreeID, avoidTradeRouteSocket);
    rmAddObjectDefConstraint(voidtreeID, avoidNatives);
	rmAddObjectDefConstraint(voidtreeID, avoidGoldMin);
	rmAddObjectDefConstraint(voidtreeID, avoidStartingResources);
	rmPlaceObjectDefAtLoc(voidtreeID, 0, 0.60, 0.60);
	rmPlaceObjectDefAtLoc(voidtreeID, 0, 0.40, 0.60);
*/	

	// ********************************
	
	int YPMuskDeercount = 1+2*PlayerNum;

/*	
	for(i=0; < YPMuskDeercount)
	{
	
		//YPMuskDeers
		int YPMuskDeerID = rmCreateObjectDef("YPMuskDeer"+i);
		rmAddObjectDefItem(YPMuskDeerID, "YPMuskDeer", rmRandInt(12,12), 10.0);
		rmSetObjectDefMinDistance(YPMuskDeerID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(YPMuskDeerID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(YPMuskDeerID, true);
		rmAddObjectDefConstraint(YPMuskDeerID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(YPMuskDeerID, avoidNativesShort);
		rmAddObjectDefConstraint(YPMuskDeerID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(YPMuskDeerID, avoidGoldMin);
		rmAddObjectDefConstraint(YPMuskDeerID, avoidForestMin); 
		rmAddObjectDefConstraint(YPMuskDeerID, avoidTownCenterFar);
		rmAddObjectDefConstraint(YPMuskDeerID, avoidypSerowFar); 
		rmAddObjectDefConstraint(YPMuskDeerID, avoidStartingResources); 
		rmAddObjectDefConstraint(YPMuskDeerID, avoidYPMuskDeerFar); 
	//	rmAddObjectDefConstraint(YPMuskDeerID, avoidEdge);
		rmPlaceObjectDefAtLoc(YPMuskDeerID, 0, 0.50, 0.50);
	}

		for(i=0; < ypSerowcount)
	{
		//ypSerows
		int ypSerowID = rmCreateObjectDef("ypSerow"+i);
		rmAddObjectDefItem(ypSerowID, "ypSerow", rmRandInt(12,12), 8.0);
		rmSetObjectDefMinDistance(ypSerowID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(ypSerowID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(ypSerowID, true);
		rmAddObjectDefConstraint(ypSerowID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(ypSerowID, avoidNativesShort);
		rmAddObjectDefConstraint(ypSerowID, avoidTradeRouteSocket);
		rmAddObjectDefConstraint(ypSerowID, avoidGoldMin);
		rmAddObjectDefConstraint(ypSerowID, avoidForestMin);
		rmAddObjectDefConstraint(ypSerowID, avoidTownCenterFar);
		rmAddObjectDefConstraint(ypSerowID, avoidypSerowFar); 
		rmAddObjectDefConstraint(ypSerowID, avoidStartingResources); 
		rmAddObjectDefConstraint(ypSerowID, avoidYPMuskDeerFar); 
	//	rmAddObjectDefConstraint(ypSerowID, avoidEdge);
		rmPlaceObjectDefAtLoc(ypSerowID, 0, 0.50, 0.50);
	}
*/	
	// ********************************
		
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Treasures ***********
	
	int nugget2count = 6+1*PlayerNum;
	int nugget3count = 1+0.5*PlayerNum;
	int nugget4count = 0.35*PlayerNum;
	
	// Treasures lvl4	
	int Nugget4ID = rmCreateObjectDef("nugget lvl4"); 
	rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget4ID, 0);
    rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget4ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterVeryFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidStartingResources); 
	rmAddObjectDefConstraint(Nugget4ID, avoidypSerowMin); 
	rmAddObjectDefConstraint(Nugget4ID, avoidYPMuskDeerMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget4ID, avoidEdgeMore);
	rmAddObjectDefConstraint(Nugget4ID, avoidKingsHill);
		
		for (i=0; < nugget4count)
	{
		rmSetNuggetDifficulty(4,4);
		if (PlayerNum >= 4 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl3	
	int Nugget3ID = rmCreateObjectDef("nugget lvl3"); 
	rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget3ID, 0);
    rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget3ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterVeryFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidypSerowMin); 
	rmAddObjectDefConstraint(Nugget3ID, avoidStartingResources);
	rmAddObjectDefConstraint(Nugget3ID, avoidYPMuskDeerMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget3ID, avoidEdgeMore);
	rmAddObjectDefConstraint(Nugget3ID, avoidKingsHill);
		
		for (i=0; < nugget3count)
	{
		rmSetNuggetDifficulty(3,3);
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
	// Treasures lvl2	
	int Nugget2ID = rmCreateObjectDef("nugget lvl2"); 
	rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget2ID, 0);
    rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteShort);
	rmAddObjectDefConstraint(Nugget2ID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(Nugget2ID, avoidStartingResources);
	rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidypSerowMin); 
	rmAddObjectDefConstraint(Nugget2ID, avoidYPMuskDeerMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);	
	rmAddObjectDefConstraint(Nugget2ID, avoidEdgeMore);
	rmAddObjectDefConstraint(Nugget2ID, avoidKingsHill);
		
		for (i=0; < nugget2count)
	{
		rmSetNuggetDifficulty(2,2);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}

	// ********************************
	
	// Text
	rmSetStatusText("",1.00);
	
/*	// ************ Cows *************
	
	int cowcount = 4;
	for (i=0; <cowcount)
	{
	int CowID = rmCreateObjectDef("cow"+i);
	rmAddObjectDefItem(CowID, "cow", 2, 4.0);
	rmSetObjectDefMinDistance(CowID, 0.0);
	rmSetObjectDefMaxDistance(CowID, rmXFractionToMeters(0.6));
	rmAddObjectDefConstraint(CowID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(CowID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(CowID, avoidNatives);
	rmAddObjectDefConstraint(CowID, avoidEdge);
	rmAddObjectDefConstraint(CowID, avoidNuggetMin);
//	rmAddObjectDefConstraint(CowID, avoidCow);
	rmAddObjectDefConstraint(CowID, avoidTownCenterMed);
	rmAddObjectDefConstraint(CowID, avoidForestMin);
	if (i==0)
		rmAddObjectDefConstraint(CowID, stayInAreaA);
	else if (i==1)
		rmAddObjectDefConstraint(CowID, stayInAreaB);
	else if (i==2)
		rmAddObjectDefConstraint(CowID, stayInAreaC);
	else
		rmAddObjectDefConstraint(CowID, stayInAreaD);
	rmPlaceObjectDefAtLoc(CowID, 0, 0.5, 0.5);
	}
	
*/	// ******** Embellishments ********
	
	// Flowers //was skulls for High Plains
	int skullID = rmCreateObjectDef("skull");
	rmAddObjectDefItem(skullID, "deUnderbrushFlowersJapan", rmRandInt(1,1), 4.0);
	rmAddObjectDefItem(skullID, "UnderbrushCoastalJapan", rmRandInt(4,5), 12.0);
	rmAddObjectDefItem(skullID, "UnderbrushYellowRiver", rmRandInt(2,3), 6.0); // More China!! 
	rmSetObjectDefMinDistance(skullID, 4);
	rmSetObjectDefMaxDistance(skullID, 6);
	rmAddObjectDefConstraint(skullID, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(skullID, avoidForestMin);
	rmAddObjectDefConstraint(skullID, avoidGoldMin);
		
	vector skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.10, 0.15));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.20, 0.25));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.30, 0.35));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.40, 0.45));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.50, 0.55));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.60, 0.65));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.70, 0.75));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.80, 0.85));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);	
	 skullLoc = rmGetTradeRouteWayPoint(tradeRouteID, rmRandFloat (0.90, 0.95));
	rmPlaceObjectDefAtPoint(skullID, 0, skullLoc);
		
	
	//Geysers
	//for (i=1; < 3)
	//{
		//int geyserareaID = rmCreateArea("geyserarea"+i);
		//rmSetAreaSize(geyserareaID, 0.0026-0.0002*PlayerNum, 0.0026-0.0002*PlayerNum);
		//rmSetAreaCoherence(geyserareaID, 0.80);
		//rmSetAreaSmoothDistance(geyserareaID, 1);
		//rmSetAreaWarnFailure(geyserareaID, false);
		//rmAddAreaToClass(geyserareaID, rmClassID("geyser"));
		//rmSetAreaTerrainType(geyserareaID, "great_plains\ground7_gp");
		//rmAddAreaConstraint(geyserareaID, avoidNuggetMin);
		//rmAddAreaConstraint(geyserareaID, avoidCowMin);
		//rmAddAreaConstraint(geyserareaID, avoidTradeRouteShort);
		//rmAddAreaConstraint(geyserareaID, avoidTradeRouteSocket);
		//rmAddAreaConstraint(geyserareaID, avoidNativesFar);
		//rmAddAreaConstraint(geyserareaID, avoidGoldTypeMin);
		//rmAddAreaConstraint(geyserareaID, avoidTownCenter);
		//rmAddAreaConstraint(geyserareaID, avoidypSerowMin); 
		//rmAddAreaConstraint(geyserareaID, avoidYPMuskDeerMin);
		//rmAddAreaConstraint(geyserareaID, avoidForestGeyser);	
		//rmAddAreaConstraint(geyserareaID, avoidGeyser); 
		//rmAddAreaConstraint(geyserareaID, avoidNW); 
		//rmAddAreaConstraint(geyserareaID, avoidImpassableLand); 
		//if (i == 1)
		//	rmAddAreaConstraint(geyserareaID, stayNEHalf);
		//else
		//	rmAddAreaConstraint(geyserareaID, staySWHalf);
		//rmAddAreaConstraint(geyserareaID, avoidEdgeMore); 
		//rmBuildArea(geyserareaID);
		//rmCreateAreaMaxDistanceConstraint("stay in geyser area "+i, geyserareaID, 0.0);
	//}
	
	//int stayInGeyserArea1 = rmConstraintID("stay in geyser area 1");
	//int stayInGeyserArea2 = rmConstraintID("stay in geyser area 2");
	
	//for(i=0; <2)
	//{
	//	int geyserID=rmCreateGrouping("Geyser"+i, "prop_geyser");
	//	rmSetGroupingMinDistance(geyserID, 0.0);
	//	rmSetGroupingMaxDistance(geyserID, rmXFractionToMeters(0.5));
	//	rmAddGroupingConstraint(geyserID, avoidTradeRouteSocketShort);
	//	if (i == 0)
	//		rmAddGroupingConstraint(geyserID, stayInGeyserArea1);
	//	else
	//		rmAddGroupingConstraint(geyserID, stayInGeyserArea2);
	//	rmPlaceGroupingAtLoc(geyserID, 0, 0.5, 0.5);	
	//}
    // Vary some terrain


        
	
  
	
} //END