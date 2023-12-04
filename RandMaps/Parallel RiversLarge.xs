// LARGE PARALLEL RIVERS (1v1, TEAM, FFA)
// designed by Garja
//Ported by Durokan and Interjection for DE
// LARGE version by vividlyplain, July 2021

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	int TeamNum = cNumberTeams;
	int PlayerNum = cNumberNonGaiaPlayers;
	int numPlayer = cNumberPlayers;
	
	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01); 
	
	// ************************************** GENERAL FEATURES *****************************************
	
	// Picks the map size
	int playerTiles=24000;

	int size=2.0*sqrt(PlayerNum*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	
	// Make the corners.
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.045, 2, 0.44, 4.0); // type, frequency, octaves, persistence, variation 
//	rmSetMapElevationHeightBlend(1);
	
	// Picks default terrain and water
	rmSetSeaType("Coastal Japan"); //great lakes
	rmEnableLocalWater(true);
	rmSetBaseTerrainMix("coastal_japan_c"); // deccan_grassy_dirt_a
	rmTerrainInitialize("coastal_japan\ground_grass1_co_japan", 3.0); // 
	rmSetMapType("silkRoad1"); //silkroad2
	rmSetMapType("land");
	rmSetMapType("grass");
	rmSetLightingSet("ParallelRivers_Skirmish"); //
	rmSetWindMagnitude(1.0);
	
	
	// Choose Mercs
	chooseMercs();
	
	// Text
	rmSetStatusText("",0.10);
	
	// Set up Natives
	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID("Shaolin");
	rmSetSubCiv(0, "Zen");
//	rmEchoInfo("subCiv0 is Huron "+subCiv0);


	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	int classBay = rmDefineClass("Bay");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPond = rmDefineClass("pond");
	int classRocks = rmDefineClass("rocks");
	int classGrass = rmDefineClass("grass");
	int classstartingUnit = rmDefineClass("startingUnit");
	int classForest = rmDefineClass("Forest");
	int importantItem = rmDefineClass("importantItem");
	int classNative = rmDefineClass("natives");
	int classCliff = rmDefineClass("Cliffs");
	int classGold = rmDefineClass("Gold");
	int classStartingResource = rmDefineClass("startingResource");
	
	
	// ******************************************************************************************
	
	// Text
	rmSetStatusText("",0.05);
	
	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other
   
   
	// Cardinal Directions & Map placement
	int stayNW = rmCreatePieConstraint("stay NW", 0.5, 0.68, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(300), rmDegreesToRadians(60));
	int staySE = rmCreatePieConstraint("stay SE", 0.5, 0.32, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(120), rmDegreesToRadians(240));
	int stayWhalf = rmCreatePieConstraint("stay W half", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(225), rmDegreesToRadians(45));
	int stayEhalf  = rmCreatePieConstraint("stay E half", 0.5, 0.5, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int avoidSouth  = rmCreatePieConstraint("avoid south area", 0.20, 0.20, rmZFractionToMeters(0.00), rmZFractionToMeters(0.80), rmDegreesToRadians(315), rmDegreesToRadians(135));
	
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.5,0.5,rmXFractionToMeters(0.26), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.4,0.4,rmXFractionToMeters(0.0), rmXFractionToMeters(0.18), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenterMore = rmCreatePieConstraint("Stay Center more",0.5,0.5,rmXFractionToMeters(0.0), rmXFractionToMeters(0.16), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	
	
	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", classForest, 50.0); //15.0
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", classForest, 36.0); //15.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", classForest, 20.0); //15.0
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", classForest, 4.0);
	int avoidSheepVeryFar = rmCreateTypeDistanceConstraint("avoid Sheep very far", "ypMarcoPoloSheep", 60.0);
	int avoidSheepFar = rmCreateTypeDistanceConstraint("avoid Sheep far", "ypMarcoPoloSheep", 57.0);
	int avoidSheep = rmCreateTypeDistanceConstraint("avoid Sheep", "ypMarcoPoloSheep", 40.0);
	int avoidSheepShort = rmCreateTypeDistanceConstraint("avoid Sheep short", "ypMarcoPoloSheep", 28.0);
	int avoidSheepMin = rmCreateTypeDistanceConstraint("avoid Sheep min", "ypMarcoPoloSheep", 4.0);
	int avoidSerowVeryFar = rmCreateTypeDistanceConstraint("avoid Serow very far", "ypSerow", 88.0);
	int avoidSerowFar = rmCreateTypeDistanceConstraint("avoid Serow far", "ypSerow", 75.0);
	int avoidSerow = rmCreateTypeDistanceConstraint("avoid Serow", "ypSerow", 60.0);
	int avoidSerowShort = rmCreateTypeDistanceConstraint("avoid Serow short", "ypSerow", 30.0);
	int avoidSerowMin = rmCreateTypeDistanceConstraint("avoid Serow min", "ypSerow", 4.0);
	int avoidMuskDeerVeryFar = rmCreateTypeDistanceConstraint("avoid MuskDeer very far", "ypMuskDeer", 88.0);
	int avoidMuskDeerFar = rmCreateTypeDistanceConstraint("avoid MuskDeer far", "ypMuskDeer", 75.0);
	int avoidMuskDeer = rmCreateTypeDistanceConstraint("avoid MuskDeer", "ypMuskDeer", 60.0);
	int avoidMuskDeerShort = rmCreateTypeDistanceConstraint("avoid MuskDeer short", "ypMuskDeer", 16.0);
	int avoidMuskDeerMin = rmCreateTypeDistanceConstraint("avoid MuskDeer min", "ypMuskDeer", 6.0);
	int avoidBerriesFar = rmCreateTypeDistanceConstraint("avoid berries far", "berrybush", 64.0);
	int avoidBerries = rmCreateTypeDistanceConstraint("avoid  berries", "berrybush", 40.0);
	int avoidBerriesShort = rmCreateTypeDistanceConstraint("avoid  berries short", "berrybush", 10.0);
	int avoidBerriesMin = rmCreateTypeDistanceConstraint("avoid berries min", "berrybush", 10.0);
	int avoidGoldMed = rmCreateTypeDistanceConstraint("coin avoids coin", "gold", 14.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 6.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 34.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 45.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", classGold, 4.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", classGold, 64.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", classGold, 75.0); //70
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very ", classGold, 88.0);
	int avoidNuggetMin = rmCreateTypeDistanceConstraint("nugget avoid nugget min", "AbstractNugget", 4.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 55.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget Far", "AbstractNugget", 75.0);
	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center  Very Far", "townCenter", 66.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 60.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 38.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint("resources avoid Town Center med", "townCenter", 48.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint("resources avoid Town Center short", "townCenter", 16.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint("resources avoid Town Center", "townCenter", 40.0);
	int avoidNativesShort = rmCreateClassDistanceConstraint("stuff avoids natives short", classNative, 4.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", classNative, 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", classNative, 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("avoid start resources", classStartingResource, 6.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid start resources short", classStartingResource, 4.0);
	int avoidGoat=rmCreateTypeDistanceConstraint("avoid yak", "ypgoat", 75.0+1*PlayerNum);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 16.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 4.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 1.0);
	int avoidImpassableLandRiver=rmCreateTerrainDistanceConstraint("avoid impassable land river", "Land", false, 12.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 1.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water", "water", true, 15.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 20.0);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water", "land", false, 14.0+2*PlayerNum);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water", "water", true, 0.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", classPatch, 10.0+1*PlayerNum);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch2", classPatch2, 10.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", classGrass, 5.0);
	int avoidLand = rmCreateTerrainDistanceConstraint("avoid land", "Land", true, 10.0);
	int avoidLandMin = rmCreateTerrainDistanceConstraint("avoid land min", "Land", true, 2.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid class cliff", classCliff, 4.0+2*PlayerNum);
	int avoidCliffMin = rmCreateClassDistanceConstraint("avoid class cliff min", classCliff, 1.0);

	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", classstartingUnit, 35.0);
		
	
	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 7.0);
   
	
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
					rmPlacePlayer(1, 0.11, 0.52);
					rmPlacePlayer(2, 0.52, 0.11);
				}
				else
				{
					rmPlacePlayer(2, 0.11, 0.52);
					rmPlacePlayer(1, 0.52, 0.11);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.11, 0.48, 0.31, 0.60, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.48, 0.11, 0.60, 0.31, 0.00, 0.20);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.08, 0.45, 0.35, 0.64, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.45, 0.08, 0.64, 0.35, 0.00, 0.20);
				}
			}
			else // unequal N of players per TEAM
			{
				if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
				{
					if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.11, 0.52, 0.12, 0.52, 0.00, 0.20);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmPlacePlayersLine(0.48, 0.11, 0.60, 0.31, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.45, 0.08, 0.64, 0.35, 0.00, 0.20);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.52, 0.11, 0.52, 0.12, 0.00, 0.20);

						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmPlacePlayersLine(0.11, 0.48, 0.31, 0.60, 0.00, 0.20);
						else
							rmPlacePlayersLine(0.08, 0.45, 0.35, 0.64, 0.00, 0.20);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.48, 0.11, 0.60, 0.31, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.08, 0.45, 0.35, 0.64, 0.00, 0.20);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmPlacePlayersLine(0.45, 0.08, 0.64, 0.35, 0.00, 0.20);

						rmSetPlacementTeam(1);
						rmPlacePlayersLine(0.11, 0.48, 0.31, 0.60, 0.00, 0.20);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmPlacePlayersLine(0.08, 0.45, 0.35, 0.64, 0.00, 0.20);

					rmSetPlacementTeam(1);
					rmPlacePlayersLine(0.45, 0.08, 0.64, 0.35, 0.00, 0.20);
				}
			}
		}
		else // FFA
		{
	//		rmSetTeamSpacingModifier(0.25);
			rmSetPlayerPlacementArea(0.05, 0.05, 0.70, 0.70);
			rmSetPlacementSection(0.750, 0.500);
			rmPlacePlayersCircular(0.40, 0.40, 0.0);
		}
	
	
	// **************************************************************************************************
   
	// Text
	rmSetStatusText("",0.10);
	
	// ********************************* MAP LAYOUT & NATURE DESIGN *************************************
	
	//Cliff area
	int cliffareaID = rmCreateArea("cliff area");
	rmSetAreaSize(cliffareaID, 0.22, 0.22);
	rmSetAreaLocation(cliffareaID, 1.00, 1.00);
	rmSetAreaEdgeFilling(cliffareaID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(cliffareaID, false);
	rmSetAreaBaseHeight(cliffareaID,4.00);
	rmSetAreaElevationVariation(cliffareaID, 1.5);
	rmAddAreaInfluenceSegment(cliffareaID, 1.00, 0.52, 0.70, 0.70); 
	rmAddAreaInfluenceSegment(cliffareaID, 0.52, 1.00, 0.70, 0.70); 
	rmSetAreaTerrainType(cliffareaID, "coastal_japan\ground_dirt3_co_japan"); 
	rmAddAreaTerrainLayer(cliffareaID, "coastal_japan\ground_dirt2_co_japan", 0, 4);
	rmAddAreaTerrainLayer(cliffareaID, "coastal_japan\ground_dirt1_co_japan", 4, 7);
	rmAddAreaTerrainLayer(cliffareaID, "coastal_japan\ground_dirt3_co_japan", 7, 12);
	rmSetAreaCoherence(cliffareaID, 0.60);
	rmSetAreaSmoothDistance(cliffareaID, 2+1*PlayerNum);
	rmBuildArea(cliffareaID);
	
	int stayInCliffarea = rmCreateAreaMaxDistanceConstraint("stay in cliff area", cliffareaID, 0.0);
	int stayNearCliffarea = rmCreateAreaMaxDistanceConstraint("stay near cliff area", cliffareaID, 50.0);
	int avoidCliffarea = rmCreateAreaDistanceConstraint("avoid cliff area", cliffareaID, 0.1);
	int avoidCliffareaMore = rmCreateAreaDistanceConstraint("avoid cliff area more", cliffareaID, 15.0);
	int avoidCliffareaFar = rmCreateAreaDistanceConstraint("avoid cliff area far", cliffareaID, 45.0);
	int avoidCliffareaFarther = rmCreateAreaDistanceConstraint("avoid cliff area farther", cliffareaID, 90.0);
	
	// Terrain details patch
	for (i=0; < 10+5*PlayerNum)
    {
        int patchID = rmCreateArea("patch with terrain details "+i);
        rmSetAreaWarnFailure(patchID, false);
        rmSetAreaSize(patchID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(140));
		rmSetAreaMix(patchID, "coastal_japan_b");
        rmAddAreaToClass(patchID, classPatch);
        rmSetAreaMinBlobs(patchID, 1);
        rmSetAreaMaxBlobs(patchID, 5);
        rmSetAreaMinBlobDistance(patchID, 16.0);
        rmSetAreaMaxBlobDistance(patchID, 40.0);
        rmSetAreaCoherence(patchID, 0.0);
		rmAddAreaConstraint(patchID, avoidPatch);
		rmAddAreaConstraint(patchID, avoidCliffareaMore);
        rmBuildArea(patchID); 
    }
	
	//Highland area
	int highlandareaID = rmCreateArea("highland area");
	rmSetAreaWarnFailure(highlandareaID, false);
	rmSetAreaBaseHeight(highlandareaID, 3.00);
	rmSetAreaSize(highlandareaID, 0.18, 0.18);
	rmSetAreaLocation(highlandareaID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(highlandareaID, 0.45, 1.00, 0.55, 0.55);
	rmAddAreaInfluenceSegment(highlandareaID, 1.00, 0.45, 0.55, 0.55); 
	rmSetAreaObeyWorldCircleConstraint(highlandareaID, true);
	rmSetAreaTerrainType(highlandareaID, "coastal_japan\ground_grass2_co_japan"); 
//	rmSetAreaTerrainType(highlandareaID, "texas\cliff_edge_tex"); // for testing
	rmSetAreaCoherence(highlandareaID, 0.70);
	rmSetAreaSmoothDistance(highlandareaID, 1+1*PlayerNum);
	rmAddAreaConstraint(highlandareaID, avoidCliffarea);
	rmBuildArea(highlandareaID);
	
	int stayInHighlandarea = rmCreateAreaMaxDistanceConstraint("stay in highland area", highlandareaID, 0.0);
	int stayNearHighlandarea = rmCreateAreaMaxDistanceConstraint("stay near highland area", highlandareaID, 15.0);
	int avoidHighlandarea = rmCreateAreaDistanceConstraint("avoid highland area", highlandareaID, 0.1);
	int avoidHighlandareaMore = rmCreateAreaDistanceConstraint("avoid highland area more", highlandareaID, 3.0);
	int avoidHighlandareaCliff = rmCreateAreaDistanceConstraint("cliff avoid highland area", highlandareaID, 12.0);
	
	//Midland area
	int midlandareaID = rmCreateArea("midland area");
	rmSetAreaWarnFailure(midlandareaID, false);
	rmSetAreaBaseHeight(midlandareaID, 2.50);
	rmSetAreaSize(midlandareaID, 0.20, 0.20);
	rmSetAreaLocation(midlandareaID, 0.30, 0.30);
	rmAddAreaInfluenceSegment(midlandareaID, 0.18, 1.00, 0.35, 0.35);
	rmAddAreaInfluenceSegment(midlandareaID, 1.00, 0.18, 0.35, 0.35); 
	rmSetAreaObeyWorldCircleConstraint(midlandareaID, true);
	rmSetAreaTerrainType(midlandareaID, "coastal_japan\ground_grass1_co_japan"); 
//	rmSetAreaTerrainType(midlandareaID, "new_england\ground2_cliff_ne"); // for testing
	rmSetAreaCoherence(midlandareaID, 0.70);
	rmSetAreaSmoothDistance(midlandareaID, 1+1*PlayerNum);
	rmAddAreaConstraint(midlandareaID, avoidCliffarea);
	rmBuildArea(midlandareaID);
	
	int stayInMidlandarea = rmCreateAreaMaxDistanceConstraint("stay in midland area", midlandareaID, 0.0);
	int stayNearMidlandarea = rmCreateAreaMaxDistanceConstraint("stay near midland area", midlandareaID, 15.0);
	int avoidMidlandarea = rmCreateAreaDistanceConstraint("avoid midland area", midlandareaID, 0.1);
	
	//Lowland area
	int lowlandareaID = rmCreateArea("lowland area");
	rmSetAreaWarnFailure(lowlandareaID, false);
//	rmSetAreaBaseHeight(lowlandareaID, 4.00);
	rmSetAreaSize(lowlandareaID, 0.32, 0.32);
	rmSetAreaLocation(lowlandareaID, 0.10, 0.10);
	rmAddAreaInfluenceSegment(lowlandareaID, 0.02, 1.00, 0.15, 0.15);
	rmAddAreaInfluenceSegment(lowlandareaID, 1.00, 0.02, 0.15, 0.15); 
	rmSetAreaObeyWorldCircleConstraint(lowlandareaID, true);
	rmSetAreaTerrainType(lowlandareaID, "coastal_japan\ground_grass3_co_japan"); 
//	rmSetAreaTerrainType(lowlandareaID, "texas\cliff_top_tex"); // for testing
	rmSetAreaCoherence(lowlandareaID, 0.70);
	rmSetAreaSmoothDistance(lowlandareaID, 1+1*PlayerNum);
	rmAddAreaConstraint(lowlandareaID, avoidCliffarea);
	rmBuildArea(lowlandareaID);
	
	int stayInLowlandarea = rmCreateAreaMaxDistanceConstraint("stay in lowland area", lowlandareaID, 0.0);
	int stayNearLowlandarea = rmCreateAreaMaxDistanceConstraint("stay near lowland area", lowlandareaID, 15.0);
	int avoidLowlandarea = rmCreateAreaDistanceConstraint("avoid lowland area", lowlandareaID, 0.1);

	// Rivers
	
	int river1ID = rmRiverCreate(-1, "Parallel Rivers River", 18, 8, 5+0.25*PlayerNum, 5+0.25*PlayerNum); // 
	if (TeamNum <= 2)
		rmRiverAddWaypoint(river1ID, 1.00, 1.00); 
	rmRiverAddWaypoint(river1ID, 0.40, 0.40);
	rmRiverAddWaypoint(river1ID, 0.00, 0.00);
	rmRiverSetBankNoiseParams(river1ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river1ID, 10+2*PlayerNum);
	rmRiverAddShallow(river1ID, 0.10);
	rmRiverAddShallow(river1ID, 0.20);
	rmRiverAddShallow(river1ID, 0.30);
	rmRiverAddShallow(river1ID, 0.40);
	rmRiverAddShallow(river1ID, 0.50);
	rmRiverAddShallow(river1ID, 0.60);
	rmRiverAddShallow(river1ID, 0.65);
	rmRiverBuild(river1ID);
	
	int river2ID = rmRiverCreate(-1, "Parallel Rivers River", 18, 8, 5+0.25*PlayerNum, 5+0.25*PlayerNum); // 
	rmRiverAddWaypoint(river2ID, 0.58, 1.00);
	rmRiverAddWaypoint(river2ID, 0.28, 0.74);
	rmRiverAddWaypoint(river2ID, 0.00, 0.66);
	rmRiverSetBankNoiseParams(river2ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river2ID, 6+1*PlayerNum);
	rmRiverAddShallow(river2ID, 0.06);
	rmRiverAddShallow(river2ID, 0.10);
	rmRiverAddShallow(river2ID, 0.20);
	rmRiverAddShallow(river2ID, 0.30);
	rmRiverAddShallow(river2ID, 0.40);
	rmRiverAddShallow(river2ID, 0.50);
	rmRiverAddShallow(river2ID, 0.55);
	if (TeamNum > 2)
	{
		rmRiverAddShallow(river2ID, 0.65);
		rmRiverAddShallow(river2ID, 0.75);
	}
	rmRiverBuild(river2ID);
	
	int river3ID = rmRiverCreate(-1, "Parallel Rivers River", 18, 8, 5+0.25*PlayerNum, 5+0.25*PlayerNum); // 
	rmRiverAddWaypoint(river3ID, 1.00, 0.58); 
	rmRiverAddWaypoint(river3ID, 0.74, 0.28);
	rmRiverAddWaypoint(river3ID, 0.66, 0.00);
	rmRiverSetBankNoiseParams(river3ID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(river3ID, 6+1*PlayerNum);
	rmRiverAddShallow(river3ID, 0.06);
	rmRiverAddShallow(river3ID, 0.10);
	rmRiverAddShallow(river3ID, 0.20);
	rmRiverAddShallow(river3ID, 0.30);
	rmRiverAddShallow(river3ID, 0.40);
	rmRiverAddShallow(river3ID, 0.50);
	rmRiverAddShallow(river3ID, 0.55);
	if (TeamNum > 2)
	{
		rmRiverAddShallow(river3ID, 0.65);
		rmRiverAddShallow(river3ID, 0.75);
	}
	rmRiverBuild(river3ID);
	
	//West area
	int westareaID = rmCreateArea("west area");
	rmSetAreaWarnFailure(westareaID, false);
	rmSetAreaSize(westareaID, 0.25, 0.25);
	rmSetAreaLocation(westareaID, 0.05, 1.00);
	rmSetAreaObeyWorldCircleConstraint(westareaID, true);
//	rmSetAreaTerrainType(westareaID, "texas\cliff_top_tex"); // for testing
	rmAddAreaConstraint(westareaID, avoidWaterShort);
	rmBuildArea(westareaID);
	
	int stayInWestarea = rmCreateAreaMaxDistanceConstraint("stay in west area", westareaID, 0.0);
	int stayNearWestarea = rmCreateAreaMaxDistanceConstraint("stay near west area", westareaID, 15.0);
	int avoidWestarea = rmCreateAreaDistanceConstraint("avoid west area", westareaID, 0.1);
	
	//East area
	int eastareaID = rmCreateArea("east area");
	rmSetAreaWarnFailure(eastareaID, false);
	rmSetAreaSize(eastareaID, 0.25, 0.25);
	rmSetAreaLocation(eastareaID, 1.00, 0.05);
	rmSetAreaObeyWorldCircleConstraint(eastareaID, true);
//	rmSetAreaTerrainType(eastareaID, "texas\cliff_top_tex"); // for testing
	rmAddAreaConstraint(eastareaID, avoidWaterShort);
	rmBuildArea(eastareaID);
	
	int stayInEastarea = rmCreateAreaMaxDistanceConstraint("stay in east area", eastareaID, 0.0);
	int stayNearEastarea = rmCreateAreaMaxDistanceConstraint("stay near east area", eastareaID, 15.0);
	int avoidEastarea = rmCreateAreaDistanceConstraint("avoid east area", eastareaID, 0.1);
	
	
	//Cliffs
	int cliffcount = 4+2*PlayerNum;
	
	for (i = 1; < cliffcount+1)
	{
	int CliffID = rmCreateArea("cliff"+i);
	rmSetAreaSize(CliffID, 0.001, 0.002);
	rmSetAreaWarnFailure(CliffID, false);
	rmSetAreaObeyWorldCircleConstraint(CliffID, false);
//	rmSetAreaLocation(CliffID, 0.72, 0.90);
	rmSetAreaCoherence(CliffID, 0.1);
	rmSetAreaSmoothDistance(CliffID, 1+1*PlayerNum);
	rmSetAreaCliffType(CliffID, "coastal japan");
	rmSetAreaTerrainType(CliffID, "coastal_japan\shoreline1_co_japan");
	rmSetAreaCliffEdge(CliffID, 1, 1.0, 0.0, 0.0, 0);
	rmSetAreaCliffHeight(CliffID, 9.0-0.5*PlayerNum, 0.0, 0.0);
//	rmSetAreaBaseHeight(CliffID, 2.00);
//	rmSetAreaHeightBlend(CliffID, 2.0);
	rmSetAreaCliffPainting(CliffID, true, false, true);
	rmAddAreaToClass(CliffID, classCliff);
	rmAddAreaConstraint(CliffID, avoidCliff);
	rmAddAreaConstraint(CliffID, avoidWaterFar);
	rmAddAreaConstraint(CliffID, avoidHighlandareaCliff);
	rmAddAreaConstraint(CliffID, stayInCliffarea);
		if (i % 2 == 1)
			rmAddAreaConstraint(CliffID, stayWhalf);
		else 
			rmAddAreaConstraint(CliffID, stayEhalf);
	rmBuildArea(CliffID);	
	}	

	
	
	// Players area
	for (i=1; < numPlayer)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID,rmAreaTilesToFraction(400), rmAreaTilesToFraction(400));
		rmSetAreaCoherence(playerareaID, 1.0);
		rmSetAreaWarnFailure(playerareaID, false);
//		rmSetAreaTerrainType(playerareaID, "new_england\ground2_cliff_ne"); // for testing
		rmSetAreaLocPlayer(playerareaID, i);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmAddAreaToClass(playerareaID, classPlayer);
		rmBuildArea(playerareaID);
		int stayPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}
		
	// ******************************************************************************************************
	
	// Text
	rmSetStatusText("",0.20);

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		float xLoc = 0.85;
		float yLoc = 0.8;
		float walk = 0.05;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}
	
	// ******************************************** NATIVES *************************************************
	
    int nativeID1 = -1;
	int nativeID2 = -1;
	int nativeID3 = -1;
	
	nativeID1 = rmCreateGrouping("Zen 1", "native zen temple YR 0"+1); // NW
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, classNative);
		
	nativeID2 = rmCreateGrouping("Zen 2", "native zen temple YR 0"+5); // SE 
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//  rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, classNative);
	
	nativeID3 = rmCreateGrouping("Zen 3", "native zen temple YR 0"+1); // SE
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, classNative);

	
	
		if (TeamNum <= 2)	
		{
			if (PlayerNum <= 4)
			{
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.44, 0.65); //
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.65, 0.44); //
			}
			else if (PlayerNum <= 4)
			{
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.45, 0.66); // 
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.66, 0.45); // 
			}	
			else if (PlayerNum > 4)
			{
				rmPlaceGroupingAtLoc(nativeID1, 0, 0.48, 0.69); // 
				rmPlaceGroupingAtLoc(nativeID2, 0, 0.69, 0.48); // 
			}
		}
		else
		{
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.50, 0.35); // 
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.35, 0.50); // 
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
		rmAddObjectDefToClass(TCID, classStartingResource);
	}
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 0.0);
    
	if(cNumberNonGaiaPlayers>4){
        rmSetObjectDefMaxDistance(TCID, 14.0);
    }
    int teamZeroCount_dk = rmGetNumberPlayersOnTeam(0);
    int teamOneCount_dk = rmGetNumberPlayersOnTeam(1);
    if((cNumberTeams == 2) && (teamZeroCount_dk != teamOneCount_dk)){
        rmSetObjectDefMaxDistance(TCID, 30.0);
    }
    
	// Starting mines
	int playergoldID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playergoldID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergoldID, 16.0);
	rmSetObjectDefMaxDistance(playergoldID, 17.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidWaterFar);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidGoldType);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);
	
	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "minetin", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 26.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 28.0); //62
	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidWaterFar);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldType);
//	rmAddObjectDefConstraint(playergold2ID, avoidTownCenterMed);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playergold2ID, avoidEdge);
	
	// Starting berries
	int playerberriesID = rmCreateObjectDef("player berries");
	rmAddObjectDefItem(playerberriesID, "berrybush", 4, 4.0);
	rmSetObjectDefMinDistance(playerberriesID, 14.0);
	rmSetObjectDefMaxDistance(playerberriesID, 14.0);
	rmAddObjectDefToClass(playerberriesID, classStartingResource);
	rmAddObjectDefConstraint(playerberriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerberriesID, avoidNatives);
	rmAddObjectDefConstraint(playerberriesID, avoidStartingResources);
	rmAddObjectDefConstraint(playerberriesID, avoidWater);
	
	// Starting trees1
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "ypTreeGinkgo", rmRandInt(4,4), 3.0); //
    rmSetObjectDefMinDistance(playerTreeID, 12);
    rmSetObjectDefMaxDistance(playerTreeID, 13);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
	rmAddObjectDefToClass(playerTreeID, classForest);
//	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	
	// Starting trees2
	int playerTree2ID = rmCreateObjectDef("player trees 2");
	rmAddObjectDefItem(playerTree2ID, "ypTreeGinkgo", rmRandInt(2,2), 2.0); //
    rmSetObjectDefMinDistance(playerTree2ID, 14);
    rmSetObjectDefMaxDistance(playerTree2ID, 15);
	rmAddObjectDefToClass(playerTree2ID, classStartingResource);
	rmAddObjectDefToClass(playerTree2ID, classForest);
//	rmAddObjectDefConstraint(playerTree2ID, avoidForestShort);
    rmAddObjectDefConstraint(playerTree2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTree2ID, avoidStartingResources);
	
	// Starting herd
	int playerhuntID = rmCreateObjectDef("starting hunt");
	rmAddObjectDefItem(playerhuntID, "ypMarcoPoloSheep", rmRandInt(5,5), 2.0);
	rmSetObjectDefMinDistance(playerhuntID, 13.0);
	rmSetObjectDefMaxDistance(playerhuntID, 14.0);
	rmSetObjectDefCreateHerd(playerhuntID, true);
	rmAddObjectDefToClass(playerhuntID, classStartingResource);
	rmAddObjectDefConstraint(playerhuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerhuntID, avoidNatives);
	rmAddObjectDefConstraint(playerhuntID, avoidStartingResources);
		
	// 2nd herd
	int playerhunt2ID = rmCreateObjectDef("player 2nd hunt");
    rmAddObjectDefItem(playerhunt2ID, "ypSerow", rmRandInt(7,7), 4.0);
    rmSetObjectDefMinDistance(playerhunt2ID, 32);
    rmSetObjectDefMaxDistance(playerhunt2ID, 33);
	rmAddObjectDefToClass(playerhunt2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerhunt2ID, true);
	rmAddObjectDefConstraint(playerhunt2ID, avoidSheepShort); //Short
	rmAddObjectDefConstraint(playerhunt2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerhunt2ID, avoidNatives);
	rmAddObjectDefConstraint(playerhunt2ID, avoidStartingResources);
	rmAddObjectDefConstraint(playerhunt2ID, avoidEdge);
		
	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 16.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 18.0);
//	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
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
//		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerTree2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerhuntID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerhunt2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		if (nugget0count == 2)
//			rmPlaceObjectDefAtLoc(playerNuggetID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
				
		if(ypIsAsian(i) && rmGetNomadStart() == false)
		rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		
	}

	// ************************************************************************************************
	
	// Text
	rmSetStatusText("",0.50);
	
	// ************************************** COMMON RESOURCES ****************************************
  
   
	// ********** Mines ***********
	
	int goldvariation = -1;
	goldvariation = rmRandInt(0,1);
	goldvariation = 1; // <--- TEST
	
	int silvermineCount = 2+4*PlayerNum;
		
	//Silver mines
	for(i=1; < silvermineCount+1)
	{
		int silvermineID = rmCreateObjectDef("silver mine center"+i);
		rmAddObjectDefItem(silvermineID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(silvermineID, rmXFractionToMeters(0.00));
		rmSetObjectDefMaxDistance(silvermineID, rmXFractionToMeters(0.50));
		rmAddObjectDefToClass(silvermineID, classGold);
		rmAddObjectDefConstraint(silvermineID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(silvermineID, avoidWater);
		rmAddObjectDefConstraint(silvermineID, avoidNatives);
		rmAddObjectDefConstraint(silvermineID, avoidGoldFar);
		rmAddObjectDefConstraint(silvermineID, avoidTownCenterMed);
		rmAddObjectDefConstraint(silvermineID, avoidEdge);
		rmAddObjectDefConstraint(silvermineID, avoidCliffMin);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(silvermineID, stayWhalf);
		else 
			rmAddObjectDefConstraint(silvermineID, stayEhalf);
		if (i == 1)
			rmAddObjectDefConstraint(silvermineID, stayInWestarea);
		else if (i == 2)
			rmAddObjectDefConstraint(silvermineID, stayInEastarea);
		else if (i <= 4)
		{
			rmAddObjectDefConstraint(silvermineID, stayInLowlandarea);
			rmAddObjectDefConstraint(silvermineID, avoidEastarea);
			rmAddObjectDefConstraint(silvermineID, avoidWestarea);
		}	
		else if (i <= 6)
		{
			rmAddObjectDefConstraint(silvermineID, stayInMidlandarea);
			rmAddObjectDefConstraint(silvermineID, avoidWestarea);
			rmAddObjectDefConstraint(silvermineID, avoidEastarea);
		}	
		else if (i <= 8)
		
			rmAddObjectDefConstraint(silvermineID, stayInHighlandarea);
		else if (i <= 10)
		{
			rmAddObjectDefConstraint(silvermineID, stayInCliffarea);	
			rmAddObjectDefConstraint(silvermineID, avoidWestarea);
			rmAddObjectDefConstraint(silvermineID, avoidEastarea);
		}	
		rmPlaceObjectDefAtLoc(silvermineID, 0, 0.50, 0.50);
	}
			
	// ****************************
	
	// Text
	rmSetStatusText("",0.60);
	
	// ********** Forest **********
	
	// Lowland Forest
	int lowlandFcount = 2+10*PlayerNum; 
	int stayInlowlandF = -1;
	
	for (i=0; < lowlandFcount)
	{
		int lowlandFID = rmCreateArea("lowland forest"+i);
		rmSetAreaWarnFailure(lowlandFID, false);
		rmSetAreaObeyWorldCircleConstraint(lowlandFID, false);
		rmSetAreaSize(lowlandFID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(80));
//		rmSetAreaMix(lowlandFID, "yellow_river_forest");
		rmSetAreaTerrainType(lowlandFID, "coastal_japan\ground_forest_co_japan");
		rmAddAreaTerrainLayer(lowlandFID, "coastal_japan\ground_grass1_co_japan", 0, 1);
		rmSetAreaCoherence(lowlandFID, 0.0);
//		rmAddAreaToClass(lowlandFID, classForest);
		rmAddAreaConstraint(lowlandFID, avoidForest);
		rmAddAreaConstraint(lowlandFID, avoidCliffarea);
		rmAddAreaConstraint(lowlandFID, avoidHighlandarea);
//		rmAddAreaConstraint(lowlandFID, avoidMidlandarea);
		rmAddAreaConstraint(lowlandFID, avoidImpassableLandShort);
		rmAddAreaConstraint(lowlandFID, avoidNatives);
		rmAddAreaConstraint(lowlandFID, avoidGoldTypeShort);
		rmAddAreaConstraint(lowlandFID, avoidTownCenterShort);
		rmAddAreaConstraint(lowlandFID, avoidStartingResourcesShort);
//		rmAddAreaConstraint(lowlandFID, avoidSheepMin); 
//		rmAddAreaConstraint(lowlandFID, avoidSerowMin); 
//		rmAddAreaConstraint(lowlandFID, avoidNuggetMin); 
		rmBuildArea(lowlandFID);
	
		stayInlowlandF = rmCreateAreaMaxDistanceConstraint("stay in lowland forest"+i, lowlandFID, 0.0);
	
		for (j=0; < rmRandInt(4,4)+PlayerNum) //11,12
		{
			int lowlandFtreeID = rmCreateObjectDef("lowland forest tree"+i+j);
//			rmAddObjectDefItem(lowlandFtreeID, "UnderbrushDeccan", rmRandInt(2,3), 5.0);
			rmAddObjectDefItem(lowlandFtreeID, "ypTreeGinkgo", rmRandInt(1,1), 4.0); // 1,2
			rmAddObjectDefItem(lowlandFtreeID, "ypTreeGinkgo", rmRandInt(2,3), 4.0); // 1,2
			rmAddObjectDefItem(lowlandFtreeID, "ypTreeMongolianFir", rmRandInt(1,2), 4.0); // 1,2
			rmSetObjectDefMinDistance(lowlandFtreeID, 0);
			rmSetObjectDefMaxDistance(lowlandFtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(lowlandFtreeID, classForest);
			rmAddObjectDefConstraint(lowlandFtreeID, stayInlowlandF);	
//			rmAddObjectDefConstraint(lowlandFtreeID, avoidImpassableLandShort);	
//			rmAddObjectDefConstraint(lowlandFtreeID, avoidGoldTypeShort);
			rmPlaceObjectDefAtLoc(lowlandFtreeID, 0, 0.50, 0.50);
		}	
	}
		
	// Highland Forest
	int highlandFcount = 4+5*PlayerNum; 
	int stayInhighlandF = -1;
	
	for (i=0; < highlandFcount)
	{
		int highlandFID = rmCreateArea("highland forest"+i);
		rmSetAreaWarnFailure(highlandFID, false);
		rmSetAreaObeyWorldCircleConstraint(highlandFID, false);
		rmSetAreaSize(highlandFID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(110));
//		rmSetAreaMix(highlandFID, "yellow_river_forest");
		rmSetAreaTerrainType(highlandFID, "coastal_japan\ground_grass3_co_japan");
		rmAddAreaTerrainLayer(highlandFID, "coastal_japan\ground_grass1_co_japan", 0, 1);
		rmSetAreaCoherence(highlandFID, 0.0);
//		rmAddAreaToClass(highlandFID, classForest);
		rmAddAreaConstraint(highlandFID, avoidForest);
		rmAddAreaConstraint(highlandFID, avoidCliffarea);
		rmAddAreaConstraint(highlandFID, avoidLowlandarea);
//		rmAddAreaConstraint(highlandFID, avoidMidandarea);
		rmAddAreaConstraint(highlandFID, avoidImpassableLandShort);
		rmAddAreaConstraint(highlandFID, avoidNativesShort);
		rmAddAreaConstraint(highlandFID, avoidGoldTypeShort);
//		rmAddAreaConstraint(highlandFID, avoidTownCenterShort);
		rmAddAreaConstraint(highlandFID, avoidStartingResourcesShort);
//		rmAddAreaConstraint(highlandFID, avoidSheepMin); 
//		rmAddAreaConstraint(highlandFID, avoidSerowMin); 
//		rmAddAreaConstraint(highlandFID, avoidNuggetMin); 
		rmBuildArea(highlandFID);
	
		stayInhighlandF = rmCreateAreaMaxDistanceConstraint("stay in highland forest"+i, highlandFID, 0.0);
	
		for (j=0; < rmRandInt(4,4)+PlayerNum) //11,12
		{
			int highlandFtreeID = rmCreateObjectDef("highland forest tree"+i+j);
//			rmAddObjectDefItem(highlandFtreeID, "UnderbrushDeccan", rmRandInt(2,3), 5.0);
			rmAddObjectDefItem(highlandFtreeID, "ypTreeMongolianFir", rmRandInt(1,2), 3.0); // 1,2
			rmAddObjectDefItem(highlandFtreeID, "ypTreeMongolianFir", rmRandInt(1,1), 2.0); // 1,2
			rmSetObjectDefMinDistance(highlandFtreeID, 0);
			rmSetObjectDefMaxDistance(highlandFtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(highlandFtreeID, classForest);
			rmAddObjectDefConstraint(highlandFtreeID, stayInhighlandF);	
//			rmAddObjectDefConstraint(highlandFtreeID, avoidImpassableLandShort);	
//			rmAddObjectDefConstraint(highlandFtreeID, avoidGoldTypeShort);
			rmPlaceObjectDefAtLoc(highlandFtreeID, 0, 0.50, 0.50);
		}	
	}	

	// Random trees
	int randomlowtreecount = 6+6*PlayerNum; 
	
	for (i=0; < randomlowtreecount)
	{	
		int randomlowtreeID = rmCreateObjectDef("random trees"+i);
		rmAddObjectDefItem(randomlowtreeID, "ypTreeGinkgo", rmRandInt(2,3), 3.0); 
		rmAddObjectDefItem(randomlowtreeID, "ypTreeMongolianFir", rmRandInt(1,2), 3.0); 
		rmSetObjectDefMinDistance(randomlowtreeID, 0);
		rmSetObjectDefMaxDistance(randomlowtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomlowtreeID, classForest);
		rmAddObjectDefConstraint(randomlowtreeID, avoidNativesShort);
		rmAddObjectDefConstraint(randomlowtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(randomlowtreeID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(randomlowtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(randomlowtreeID, avoidForestShort);	
//		rmAddObjectDefConstraint(randomlowtreeID, avoidEdge);
		rmAddObjectDefConstraint(randomlowtreeID, avoidCliffarea);	
		rmAddObjectDefConstraint(randomlowtreeID, avoidHighlandarea);
		rmPlaceObjectDefAtLoc(randomlowtreeID, 0, 0.5, 0.5);
	}
	
	// Random trees on top
	int randomforestcount = 6+12*PlayerNum; 
	
	for (i=0; < randomforestcount)
	{	
		int RandomtreeID = rmCreateObjectDef("random trees top"+i);
		rmAddObjectDefItem(RandomtreeID, "ypTreeMongolianFir", rmRandInt(1,2), 3.0); // 4,5
		rmAddObjectDefItem(RandomtreeID, "ypTreeMongolianFir", rmRandInt(2,4), 4.0); // 4,5
		rmSetObjectDefMinDistance(RandomtreeID, 0);
		rmSetObjectDefMaxDistance(RandomtreeID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(RandomtreeID, classForest);
		rmAddObjectDefConstraint(RandomtreeID, avoidNativesShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidStartingResourcesShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(RandomtreeID, avoidForestShort);	
//		rmAddObjectDefConstraint(RandomtreeID, avoidEdge);
		rmAddObjectDefConstraint(RandomtreeID, avoidLowlandarea);	
		rmAddObjectDefConstraint(RandomtreeID, avoidMidlandarea);
		rmAddObjectDefConstraint(RandomtreeID, avoidCliffMin);
		rmPlaceObjectDefAtLoc(RandomtreeID, 0, 0.5, 0.5);
	}
	
	// ********************************	
	
	// Text
	rmSetStatusText("",0.70);

	// ********** Herds ***********

	//Serow hunts
	int serowcount = 2+2*PlayerNum;
	
	for(i=1; < serowcount+1)
	{
		int serowID = rmCreateObjectDef("serow hunt"+i);
		rmAddObjectDefItem(serowID, "ypserow", rmRandInt(7,7), 6.0);
		rmSetObjectDefMinDistance(serowID, 0.0);
		rmSetObjectDefMaxDistance(serowID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(serowID, true);
		rmAddObjectDefConstraint(serowID, avoidImpassableLand);
//		rmAddObjectDefConstraint(serowID, avoidNativesShort);
		rmAddObjectDefConstraint(serowID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(serowID, avoidTownCenter);
		rmAddObjectDefConstraint(serowID, avoidForestMin);
		rmAddObjectDefConstraint(serowID, avoidSerow);
		rmAddObjectDefConstraint(serowID, avoidSheepShort);
		rmAddObjectDefConstraint(serowID, avoidEdge);
		rmAddObjectDefConstraint(serowID, avoidCliffarea);
		rmAddObjectDefConstraint(serowID, avoidHighlandareaMore);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(serowID, stayWhalf);
		else 
			rmAddObjectDefConstraint(serowID, stayEhalf);
		if (i <= 2)
			rmAddObjectDefConstraint(serowID, stayInMidlandarea);
		else if (i <= 4) 
			rmAddObjectDefConstraint(serowID, stayInLowlandarea);
		rmPlaceObjectDefAtLoc(serowID, 0, 0.5, 0.5);
	}
	

	// Muskdeer hunts
	int muskdeercount = 2+4*PlayerNum;
	
	for(i=1; < muskdeercount+1)
	{
		int muskdeerID = rmCreateObjectDef("muskdeer hunt"+i);
		rmAddObjectDefItem(muskdeerID, "ypMuskDeer", rmRandInt(6,6), 5.0);
		rmSetObjectDefMinDistance(muskdeerID, 0.0);
		rmSetObjectDefMaxDistance(muskdeerID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(muskdeerID, true);
		rmAddObjectDefConstraint(muskdeerID, avoidImpassableLand);
		rmAddObjectDefConstraint(muskdeerID, avoidNativesShort);
		rmAddObjectDefConstraint(muskdeerID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(muskdeerID, avoidTownCenter);
		rmAddObjectDefConstraint(muskdeerID, avoidForestMin);
		rmAddObjectDefConstraint(muskdeerID, avoidMuskDeer);
		rmAddObjectDefConstraint(muskdeerID, avoidSerow);
		rmAddObjectDefConstraint(muskdeerID, avoidSheepShort);
		rmAddObjectDefConstraint(muskdeerID, avoidEdge);
		rmAddObjectDefConstraint(muskdeerID, avoidLowlandarea);
		rmAddObjectDefConstraint(muskdeerID, avoidMidlandarea);
		rmAddObjectDefConstraint(muskdeerID, avoidCliffMin);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(muskdeerID, stayWhalf);
		else 
			rmAddObjectDefConstraint(muskdeerID, stayEhalf);
//		if (i <= 2)
//			rmAddObjectDefConstraint(muskdeerID, stayInMidlandarea);
//		else if (i <= 4) 
//			rmAddObjectDefConstraint(muskdeerID, stayInLowlandarea);
		rmPlaceObjectDefAtLoc(muskdeerID, 0, 0.5, 0.5);
	}
	
	// ********************************
	
	// Text
	rmSetStatusText("",0.80);
	
	// ********** Treasures ***********
	
	
	int nugget1count = 4+2*PlayerNum;
	int nugget2count = 2*PlayerNum; 
	int nugget3count = PlayerNum; 
	int nugget4count = 0.5*PlayerNum; 
	
	// Treasures 4	
	
	for (i=0; < nugget4count)
	{
		int Nugget4ID = rmCreateObjectDef("nugget 4 "+i); 
		rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget4ID, 0);
		rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.40));
		rmAddObjectDefConstraint(Nugget4ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterVeryFar);
		rmAddObjectDefConstraint(Nugget4ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget4ID, avoidMuskDeerMin);
		rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget4ID, avoidCliffarea); 
		rmAddObjectDefConstraint(Nugget4ID, avoidLowlandarea);
		rmAddObjectDefConstraint(Nugget4ID, avoidEastarea);
		rmAddObjectDefConstraint(Nugget4ID, avoidWestarea);
		rmAddObjectDefConstraint(Nugget4ID, avoidEdge); 
		rmSetNuggetDifficulty(4,4);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(Nugget4ID, stayWhalf);
		else
			rmAddObjectDefConstraint(Nugget4ID, stayEhalf);
		if (PlayerNum > 4 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}
	
	// Treasures 3
	for (i=0; < nugget3count)
	{
		int Nugget3ID = rmCreateObjectDef("nugget 3 "+i); 
		rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget3ID, 0);
		rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(Nugget3ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget3ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget3ID, avoidMuskDeerMin);
		rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);	
		rmAddObjectDefConstraint(Nugget3ID, avoidEdge); 
		rmSetNuggetDifficulty(3,3);
		rmAddObjectDefConstraint(Nugget3ID, stayInMidlandarea);
		rmAddObjectDefConstraint(Nugget3ID, avoidWestarea);
		rmAddObjectDefConstraint(Nugget3ID, avoidEastarea);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(Nugget3ID, stayWhalf);
		else
			rmAddObjectDefConstraint(Nugget3ID, stayEhalf);
		if (PlayerNum > 2)
			rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}
	
	// Treasures 2	
	for (i=1; < nugget2count+1)
	{
		int Nugget2ID = rmCreateObjectDef("nugget 2 "+i); 
		rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget2ID, 0);
		rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(Nugget2ID, avoidNuggetFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(Nugget2ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget2ID, avoidMuskDeerMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget2ID, avoidCliffMin);		
		rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
		rmAddObjectDefConstraint(Nugget2ID, avoidLowlandarea);
		rmSetNuggetDifficulty(2,2);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(Nugget2ID, stayWhalf);
		else
			rmAddObjectDefConstraint(Nugget2ID, stayEhalf);
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}
	
	// Treasures 1	
	for (i=0; < nugget1count)
	{
		int Nugget1ID = rmCreateObjectDef("nugget 1 "+i); 
		rmAddObjectDefItem(Nugget1ID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(Nugget1ID, 0);
		rmSetObjectDefMaxDistance(Nugget1ID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(Nugget1ID, avoidNugget);
		rmAddObjectDefConstraint(Nugget1ID, avoidNatives);
		rmAddObjectDefConstraint(Nugget1ID, avoidImpassableLand);
		rmAddObjectDefConstraint(Nugget1ID, avoidGoldTypeShort);
		rmAddObjectDefConstraint(Nugget1ID, avoidTownCenter);
		rmAddObjectDefConstraint(Nugget1ID, avoidSerowMin); 
		rmAddObjectDefConstraint(Nugget1ID, avoidMuskDeerMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidForestMin);
		rmAddObjectDefConstraint(Nugget1ID, avoidCliffMin);		
		rmAddObjectDefConstraint(Nugget1ID, avoidEdge); 
		rmSetNuggetDifficulty(1,1);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(Nugget1ID, stayWhalf);
		else
			rmAddObjectDefConstraint(Nugget1ID, stayEhalf);
		rmPlaceObjectDefAtLoc(Nugget1ID, 0, 0.50, 0.50);
	}
	
	// ********************************
		
	// Text
	rmSetStatusText("",0.90);
	
	// **************** Goats *****************
	
	int goatsCount = 2+1*PlayerNum;
	
	for (i=0; < goatsCount)
	{
		int goatID=rmCreateObjectDef("goat"+i);
		rmAddObjectDefItem(goatID, "ypgoat", 3, 4.0);
		rmSetObjectDefMinDistance(goatID, 0.0);
		rmSetObjectDefMaxDistance(goatID, rmXFractionToMeters(0.45));
		rmAddObjectDefConstraint(goatID, avoidGoat);
		rmAddObjectDefConstraint(goatID, avoidNatives);
		rmAddObjectDefConstraint(goatID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(goatID, avoidGoldMin);
		rmAddObjectDefConstraint(goatID, avoidTownCenter);
		rmAddObjectDefConstraint(goatID, avoidSerowMin); 
		rmAddObjectDefConstraint(goatID, avoidMuskDeerMin);
		rmAddObjectDefConstraint(goatID, avoidForestMin);
		rmAddObjectDefConstraint(goatID, avoidNuggetShort);
		rmAddObjectDefConstraint(goatID, avoidEdge); 
		rmAddObjectDefConstraint(goatID, stayInCliffarea);
		rmAddObjectDefConstraint(goatID, avoidCliffMin);
		rmAddObjectDefConstraint(goatID, avoidHighlandareaMore);
		if (i % 2 == 1)
			rmAddObjectDefConstraint(goatID, stayWhalf);
		else 
			rmAddObjectDefConstraint(goatID, stayEhalf);
		rmPlaceObjectDefAtLoc(goatID, 0, 0.50, 0.50);
	}
	// ****************************************	
	
	// Text
	rmSetStatusText("",1.00);
	
} //END
	
	