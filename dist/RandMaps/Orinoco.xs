// ORINOCO
// Dec 06 - YP update
// April 2021 edited by vividlyplain for DE, thanks, Floko, for the journey into the treaty universe.
// updated natives and some terrains September 2021, vividlyplain

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
	rmSetStatusText("", 0.01);

	//Chooses which natives appear on the map
	string natType0 = "";
	string natGrpName0 = "";

	int whichNative = rmRandInt(1,2);

	if (whichNative == 1) {
		natType0 = "Zapotec";
		natGrpName0 = "native zapotec village ";
		}
	if (whichNative == 2) {
		natType0 = "Maya";
		natGrpName0 = "native maya village ";
		}
		
	int subCiv0 = -1;
	int subCiv1 = -1;
	int subCiv2 = -1;
	int subCiv3 = -1;

	// All tupi all the time
	// Now Caribs/Zapotec/Mayans
	if (rmAllocateSubCivs(4) == true)
	{
		if (rmRandFloat(1, 1) > 0.50)
		{ //this is a mixed range and melee map
			if (rmRandFloat(0, 1) > 0.50)
			{							   //Tupi or Tupi
				string rangedCiv = "Caribs"; //tupi
			}
			else
			{
				rangedCiv = "Caribs"; //Tupi
			}
			if (rmRandFloat(0, 1) > 0.50)
			{								 //Maya or Maya
				string meleeCiv = natType0; //Maya
			}
			else
			{
				meleeCiv = natType0; //Maya
			}

			if (rmRandFloat(0, 1) > 0.50)
			{ //Ranged Top Left and Bottom Right
				subCiv0 = rmGetCivID(rangedCiv);
				if (subCiv0 >= 0)
					rmSetSubCiv(0, rangedCiv);
				subCiv1 = rmGetCivID(meleeCiv);
				if (subCiv1 >= 0)
					rmSetSubCiv(1, meleeCiv);

				subCiv2 = rmGetCivID(meleeCiv);
				if (subCiv2 >= 0)
					rmSetSubCiv(2, meleeCiv);

				subCiv3 = rmGetCivID(rangedCiv);
				if (subCiv3 >= 0)
					rmSetSubCiv(3, rangedCiv);
			}
			else
			{ //Melee Top Left and Bottom Right
				subCiv0 = rmGetCivID(meleeCiv);
				if (subCiv0 >= 0)
					rmSetSubCiv(0, meleeCiv);
				subCiv1 = rmGetCivID(rangedCiv);
				if (subCiv1 >= 0)
					rmSetSubCiv(1, rangedCiv);

				subCiv2 = rmGetCivID(rangedCiv);
				if (subCiv2 >= 0)
					rmSetSubCiv(2, rangedCiv);

				subCiv3 = rmGetCivID(meleeCiv);
				if (subCiv3 >= 0)
					rmSetSubCiv(3, meleeCiv);
			}
		}
		else
		{ //this is a all ranged or all melee map
			if (rmRandFloat(0, 1) > 0.50)
			{ //Ranged only (Tupi & Tupi)
				if (rmRandFloat(0, 1) > 0.50)
				{ //Tupi Top Left and Bottom Right
					subCiv0 = rmGetCivID("Caribs");
					if (subCiv0 >= 0)
						rmSetSubCiv(0, "Caribs");
					subCiv1 = rmGetCivID("Caribs");
					if (subCiv1 >= 0)
						rmSetSubCiv(1, "Caribs");

					subCiv2 = rmGetCivID("Caribs");
					if (subCiv2 >= 0)
						rmSetSubCiv(2, "Caribs");

					subCiv3 = rmGetCivID("Caribs");
					if (subCiv3 >= 0)
						rmSetSubCiv(3, "Caribs");
				}
				else
				{ //Tupi Bottom Left and Top Right
					subCiv0 = rmGetCivID("Caribs");
					if (subCiv0 >= 0)
						rmSetSubCiv(0, "Caribs");
					subCiv1 = rmGetCivID("Caribs");
					if (subCiv1 >= 0)
						rmSetSubCiv(1, "Caribs");

					subCiv2 = rmGetCivID("Caribs");
					if (subCiv2 >= 0)
						rmSetSubCiv(2, "Caribs");

					subCiv3 = rmGetCivID("Caribs");
					if (subCiv3 >= 0)
						rmSetSubCiv(3, "Caribs");
				}
			}
			else
			{ //Melee only (Maya & Maya)
				if (rmRandFloat(0, 1) > 0.50)
				{ //Maya Top Left and Bottom Right
					subCiv0 = rmGetCivID(natType0);
					if (subCiv0 >= 0)
						rmSetSubCiv(0, natType0);
					subCiv1 = rmGetCivID(natType0);
					if (subCiv1 >= 0)
						rmSetSubCiv(1, natType0);

					subCiv2 = rmGetCivID(natType0);
					if (subCiv2 >= 0)
						rmSetSubCiv(2, natType0);

					subCiv3 = rmGetCivID(natType0);
					if (subCiv3 >= 0)
						rmSetSubCiv(3, natType0);
				}
				else
				{ //Maya Bottom Left and Top Right
					subCiv0 = rmGetCivID(natType0);
					if (subCiv0 >= 0)
						rmSetSubCiv(0, natType0);
					subCiv1 = rmGetCivID(natType0);
					if (subCiv1 >= 0)
						rmSetSubCiv(1, natType0);

					subCiv2 = rmGetCivID(natType0);
					if (subCiv2 >= 0)
						rmSetSubCiv(2, natType0);

					subCiv3 = rmGetCivID(natType0);
					if (subCiv3 >= 0)
						rmSetSubCiv(3, natType0);
				}
			}
		}
	}

	// Which map - four possible variations (excluding which end the players start on, which is a separate thing)

	// Picks the map size
	if (cNumberTeams > 2)
		int playerTiles = 12000;
	else if (rmGetNumberPlayersOnTeam(0) == rmGetNumberPlayersOnTeam(1))
		playerTiles = 11000;
	else
		playerTiles = 12000;

	int size = 2.1 * sqrt(cNumberNonGaiaPlayers * playerTiles);
	rmEchoInfo("Map size=" + size + "m x " + size + "m");
	rmSetMapSize(size, size);

	// Picks a default water height
	rmSetSeaLevel(3.0); // this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	//	rmAddMapTerrainByHeightInfo("yukon\ground2_yuk", 6.0, 9.0, 1.0);
	//	rmAddMapTerrainByHeightInfo("yukon\ground3_yuk", 9.0, 16.0);
	rmSetBaseTerrainMix("orinoco grass");
	rmTerrainInitialize("amazon\ground4_ama", 4);
	rmSetMapType("orinoco");
	rmSetMapType("tropical");
	rmSetMapType("land");
	rmSetLightingSet("Orinoco_Skirmish");

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();

	// Make it snow
	//rmSetGlobalSnow( 0.7 );

	// Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("classMountain");
	rmDefineClass("classGold");
	rmDefineClass("startingResource");

	// -------------Define constraints
	// These are used to have objects and areas avoid each other

	// Map edge constraints
	//int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	int playerEdgeConstraint = rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.43), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int coinEdgeConstraint = rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(19), rmZTilesToFraction(19), 1.0 - rmXTilesToFraction(19), 1.0 - rmZTilesToFraction(19), 2.0);
	int coinEdgeWestConstraint = rmCreateBoxConstraint("coin edge of mapwest", rmXTilesToFraction(19), rmZTilesToFraction(19), 1.0 - rmXTilesToFraction(19), 1.0 - rmZTilesToFraction(19), 2.0);

	// Cardinal Directions

	int Eastward = rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int staySouth = rmCreatePieConstraint("SMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int staySouthish = rmCreatePieConstraint("SishMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(105), rmDegreesToRadians(345));
	int avoidCrossingN = rmCreatePieConstraint("NCrossingConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(70), rmDegreesToRadians(20));
	int avoidCrossingNShort = rmCreatePieConstraint("NShortCrossingConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(90), rmDegreesToRadians(00));
	int Westward = rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));
	int stayNorth = rmCreatePieConstraint("NMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int stayNorthish = rmCreatePieConstraint("NishMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(285), rmDegreesToRadians(165));
	int avoidCrossingS = rmCreatePieConstraint("SCrossingConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(270), rmDegreesToRadians(180));
	int avoidCrossingSShort = rmCreatePieConstraint("SShortCrossingConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(250), rmDegreesToRadians(200));

	// Player constraints
	int playerConstraint = rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
	int longPlayerConstraint = rmCreateClassDistanceConstraint("stay far away from players", classPlayer, 50.0);

	// Nature avoidance
	int avoidForest = rmCreateClassDistanceConstraint("forest avoids forest", rmClassID("classForest"), 24.0);
	int avoidForestMin = rmCreateClassDistanceConstraint("forest avoids forest min", rmClassID("classForest"), 8.0);
	int avoidForestBrush = rmCreateClassDistanceConstraint("brush avoids forest min", rmClassID("classForest"), 0.5);
	int avoidForestShort = rmCreateClassDistanceConstraint("forest avoids forest short", rmClassID("classForest"), 12.0);
	int avoidForestFar = rmCreateClassDistanceConstraint("forest avoids forest far", rmClassID("classForest"), 50.0);
	int avoidCapybara = rmCreateTypeDistanceConstraint("avoids Capybara", "capybara", 45.0);
	int avoidTapir = rmCreateTypeDistanceConstraint("Tapir avoids Tapir", "Tapir", 45.0);
	int avoidTapirMin = rmCreateTypeDistanceConstraint("Tapir avoids Tapir min", "Tapir", 4.0);
	int avoidTapirFar = rmCreateTypeDistanceConstraint("Tapir avoids Tapir Far", "Tapir", 65.0);
	int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "gold", 40.0);
	int avoidCoinFar = rmCreateTypeDistanceConstraint("avoid coin far", "gold", 55.0);

	int avoidGold = rmCreateClassDistanceConstraint("avoid gold", rmClassID("classGold"), 30.0);
	int avoidGoldMin = rmCreateClassDistanceConstraint("avoid gold min", rmClassID("classGold"), 4.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint("avoid gold short", rmClassID("classGold"), 12.0);
	int avoidGoldMed = rmCreateClassDistanceConstraint("avoid gold med", rmClassID("classGold"), 20.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint("avoid gold far", rmClassID("classGold"), 40.0);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint("avoid gold very far", rmClassID("classGold"), 55.0);

	int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting res", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting res min", rmClassID("startingResource"), 2.0);
	int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting res short", rmClassID("startingResource"), 4.0);
	int avoidStartingResourcesMed = rmCreateClassDistanceConstraint("avoid starting res med", rmClassID("startingResource"), 12.0);
	int avoidStartingResourcesFar = rmCreateClassDistanceConstraint("avoid starting res far", rmClassID("startingResource"), 24.0);
	
	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int stayRiver = rmCreateTerrainMaxDistanceConstraint("stay river", "Land", false, 10*PlayerNum);
	int avoidRiver = rmCreateTerrainDistanceConstraint("avoid river", "Land", false, 5.0);
	int avoidRiverMed = rmCreateTerrainDistanceConstraint("avoid river med", "Land", false, 12.0);
	int avoidRiverMin = rmCreateTerrainDistanceConstraint("avoid river min", "Land", false, 0.5);
	int avoidRiverFar = rmCreateTerrainDistanceConstraint("avoid river far", "Land", false, 35.0);
	int avoidCliff = rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
	int cliffAvoidCliff = rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int mediumShortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 10.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int mediumAvoidImpassableLand = rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);
	int longAvoidImpassableLand = rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 20.0);

	// Unit avoidance
	int avoidHuari = rmCreateTypeDistanceConstraint("avoid Huari", "huariStronghold", 20.0);
	int avoidTownCenter = rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 30.0);
	int avoidTownCenterFar = rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 40.0);
	int avoidTownCenterSupaFar = rmCreateTypeDistanceConstraint("avoid Town Center Supa Far", "townCenter", 50.0);
	int avoidTownCenterFFAFar = rmCreateTypeDistanceConstraint("avoid Town Center FFA Far", "townCenter", 80.0);
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
	int shortAvoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 10.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 45.0);
	int avoidNugget = rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 40.0);
	int avoidNuggetFar = rmCreateTypeDistanceConstraint("nugget avoid nugget far", "AbstractNugget", 65.0);

	// Decoration avoidance
	int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 8.0);

	// -------------Define objects
	// These objects are all defined so they can be placed later

	rmSetStatusText("", 0.10);
	float topOrBottom = rmRandFloat(0.0, 1.0);

	// Build a north area
	int eastmidIslandID = rmCreateArea("east island");
	//rmSetAreaLocation(eastmidIslandID, 0.75, 0.50);
	rmSetAreaLocation(eastmidIslandID, 0.15, 0.85);
	rmSetAreaWarnFailure(eastmidIslandID, false);
	rmSetAreaSize(eastmidIslandID, 0.45, 0.45);
	rmSetAreaCoherence(eastmidIslandID, 1.0);

	rmSetAreaElevationType(eastmidIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(eastmidIslandID, 4.0);
	rmSetAreaBaseHeight(eastmidIslandID, 4.0);
	rmSetAreaElevationMinFrequency(eastmidIslandID, 0.07);
	rmSetAreaElevationOctaves(eastmidIslandID, 4);
	rmSetAreaElevationPersistence(eastmidIslandID, 0.5);
	rmSetAreaElevationNoiseBias(eastmidIslandID, 1);

	rmSetAreaObeyWorldCircleConstraint(eastmidIslandID, false);
	rmSetAreaMix(eastmidIslandID, "orinoco grass");

	// Text
	rmSetStatusText("", 0.20);

	// Build a south area
	int westmidIslandID = rmCreateArea("west island");
	//rmSetAreaLocation(westmidIslandID, 0, 0.5);
	rmSetAreaLocation(westmidIslandID, 0.75, 0.25);
	rmSetAreaWarnFailure(westmidIslandID, false);
	rmSetAreaSize(westmidIslandID, 0.45, 0.45);
	rmSetAreaCoherence(westmidIslandID, 1.0);

	rmSetAreaElevationType(westmidIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(westmidIslandID, 4.0);
	rmSetAreaBaseHeight(westmidIslandID, 4.0);
	rmSetAreaElevationMinFrequency(westmidIslandID, 0.07);
	rmSetAreaElevationOctaves(westmidIslandID, 4);
	rmSetAreaElevationPersistence(westmidIslandID, 0.5);
	rmSetAreaElevationNoiseBias(westmidIslandID, 1);
	//rmAddAreaTerrainLayer(westmidIslandID, "andes\ground10_and", 0, 3);
	rmAddAreaTerrainLayer(westmidIslandID, "amazon\ground4_ama", 3, 12);
	//rmAddAreaTerrainLayer(westmidIslandID, "andes\ground4_and", 6, 8);

	rmSetAreaObeyWorldCircleConstraint(westmidIslandID, false);
	rmSetAreaMix(westmidIslandID, "orinoco grass");
	//rmSetAreaMix(westmidIslandID, "rockies_grass");	// for testing

	rmBuildAllAreas();

	// Mid Islands
	int midIslandID = rmCreateArea("mid island");
	rmSetAreaLocation(midIslandID, 0.50, 0.50);
	rmSetAreaWarnFailure(midIslandID, false);
	rmSetAreaSize(midIslandID,0.60+0.005*PlayerNum, 0.60+0.005*PlayerNum);
	rmSetAreaCoherence(midIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(midIslandID, false);
//	rmSetAreaMix(midIslandID, "testmix");   // for testing
	rmBuildArea(midIslandID); 
	
	int avoidMidIslandMin = rmCreateAreaDistanceConstraint("avoid mid island min", midIslandID, 0.5);
	int avoidMidIsland = rmCreateAreaDistanceConstraint("avoid mid island", midIslandID, 6.0);
	int avoidMidIslandFar = rmCreateAreaDistanceConstraint("avoid mid island far", midIslandID, 10.0);
	int stayMidIsland = rmCreateAreaMaxDistanceConstraint("stay in mid island", midIslandID, 0.0);

	int midSmallIslandID = rmCreateArea("mid sm island");
	rmSetAreaLocation(midSmallIslandID, 0.50, 0.50);
	rmSetAreaWarnFailure(midSmallIslandID, false);
	rmSetAreaSize(midSmallIslandID,0.40, 0.40);
	rmSetAreaCoherence(midSmallIslandID, 1.0);
	rmSetAreaObeyWorldCircleConstraint(midSmallIslandID, false);
//	rmSetAreaMix(midSmallIslandID, "testmix");   // for testing
	rmBuildArea(midSmallIslandID); 
	
	int avoidMidSmIslandMin = rmCreateAreaDistanceConstraint("avoid mid sm island min", midSmallIslandID, 0.5);
	int avoidMidSmIsland = rmCreateAreaDistanceConstraint("avoid mid sm island", midSmallIslandID, 13.0);
	int avoidMidSmIslandFar = rmCreateAreaDistanceConstraint("avoid mid sm island far", midSmallIslandID, 20.0);
	int stayMidSmIsland = rmCreateAreaMaxDistanceConstraint("stay in mid sm island", midSmallIslandID, 0.0);
	
	// Text
	rmSetStatusText("", 0.30);

	// native villages
	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;
		
	if (cNumberTeams == 2)
		nativeID0 = rmCreateGrouping("zapotec villageA", natGrpName0+4); // right side
	else
		nativeID0 = rmCreateGrouping("zapotec villageA", natGrpName0+rmRandInt(1,5)); // right side
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));

	if (cNumberTeams == 2)
		nativeID1 = rmCreateGrouping("zapotec village B", natGrpName0+2);
	else
		nativeID1 = rmCreateGrouping("zapotec village B", natGrpName0+rmRandInt(1,5));
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));

	
	if (cNumberTeams == 2)
		nativeID2 = rmCreateGrouping("carib villageA", "native carib village "+4); // right side
	else
		nativeID2 = rmCreateGrouping("carib villageA", "native carib village "+rmRandInt(1,5)); // right side
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
	
	if (cNumberTeams == 2) {
		if (topOrBottom > 0.5)
			nativeID3 = rmCreateGrouping("carib villageB", "native carib village "+5);
		else
			nativeID3 = rmCreateGrouping("carib villageB", "native carib village "+4);
		}
	else 
		nativeID3 = rmCreateGrouping("carib villageB", "native carib village "+rmRandInt(1,5));
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));

	if (cNumberTeams == 2) {
		if (topOrBottom > 0.5) {
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.55, 0.10);	// right side
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.10, 0.55);
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.70+0.0075*cNumberNonGaiaPlayers, 0.40);	// right side
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.40, 0.70+0.0075*cNumberNonGaiaPlayers);
			}
		else {
			rmPlaceGroupingAtLoc(nativeID2, 0, 0.90, 0.45);	// right side
			rmPlaceGroupingAtLoc(nativeID3, 0, 0.45, 0.90);
			rmPlaceGroupingAtLoc(nativeID0, 0, 0.60, 0.30-0.0075*cNumberNonGaiaPlayers);	// right side
			rmPlaceGroupingAtLoc(nativeID1, 0, 0.30-0.0075*cNumberNonGaiaPlayers, 0.60);
			}
		}
	else {
		rmPlaceGroupingAtLoc(nativeID2, 0, 0.45, 0.75);
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.75, 0.45);	// right side
		rmPlaceGroupingAtLoc(nativeID0, 0, 0.25, 0.55);
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.55, 0.25);	// right side
		}

	// Middle River
	int riverID = rmRiverCreate(-1, "Orinoco River", 1, 1, 6, 9);
	if (topOrBottom > .5)
		rmRiverAddWaypoint(riverID, 0.90, 0.90);
	else
		rmRiverAddWaypoint(riverID, 0.10, 0.10);	
	if (topOrBottom > .5)
		rmRiverAddWaypoint(riverID, 0.10, 0.10);	
	else
		rmRiverAddWaypoint(riverID, 0.90, 0.90);
	if (cNumberNonGaiaPlayers < 4)
	{
		rmRiverSetShallowRadius(riverID, 16 + cNumberNonGaiaPlayers);
	}
	else
	{
		rmRiverSetShallowRadius(riverID, 20 + cNumberNonGaiaPlayers);
	}
	if (cNumberTeams == 2)
		rmRiverAddShallow(riverID, 0.70);
	if (cNumberNonGaiaPlayers > 2)
		rmRiverAddShallow(riverID, 0.85);
	if (cNumberTeams > 2) {
		rmRiverAddShallow(riverID, 0.15);
		rmRiverAddShallow(riverID, 0.50);
		}

	if (cNumberTeams == 2)
		rmRiverSetBankNoiseParams(riverID, 0.07, 2, 1.5, 10.0, 0.667, 2.0);
	rmRiverBuild(riverID);

	// Text
	rmSetStatusText("", 0.40);
	
	// Place Players
	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);

/*		// old spawns removed by vividlyplain
		// *** Set up player starting locations. Circular around the outside of the map.
	if (topOrBottom > .5)
	{
			// *** Start on the Top
			rmSetPlacementSection(0.95, 0.25);
			rmSetTeamSpacingModifier(.40);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	}
	else
	{
			// *** Start on the Bottom
			rmSetPlacementSection(0.5, 0.75);
			rmSetTeamSpacingModifier(0.40);
			rmPlacePlayersCircular(0.4, 0.4, rmDegreesToRadians(5.0));
	}
*/
	if (cNumberTeams > 2) //ffa
	{
		if (rmGetIsFFA() == true && cNumberNonGaiaPlayers == 8 || cNumberNonGaiaPlayers == 6){
			rmSetPlacementSection(0.20, 0.05);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.38, 0.38, 0);
			}
		else if (cNumberNonGaiaPlayers == 4){
			rmSetPlacementSection(0.00, 0.999);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.38, 0.38, 0);
			}
		else if (TeamNum == 4){
			rmSetPlacementSection(0.20, 0.1999);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.38, 0.38, 0);
			}
		else {
			rmSetPlacementSection(0.17, 0.1699);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.38, 0.38, 0);
			}
	}
	else										// 1v1 and TEAM
	{
			if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
			{
				float OneVOnePlacement=rmRandFloat(0.0, 0.9);
				if (topOrBottom > 0.5) 			// *** Start on the Top
				{
					if ( OneVOnePlacement < 0.5)	
					{
						rmPlacePlayer(1, 0.80, 0.50);
						rmPlacePlayer(2, 0.50, 0.80);
					}
					else
					{
						rmPlacePlayer(2, 0.80, 0.50);
						rmPlacePlayer(1, 0.50, 0.80);
					}
				}
				else 							// *** Start on the Bottom
				{
					if ( OneVOnePlacement < 0.5)
					{
						rmPlacePlayer(1, 0.50, 0.20);
						rmPlacePlayer(2, 0.20, 0.50);
					}
					else
					{
						rmPlacePlayer(2, 0.50, 0.20);
						rmPlacePlayer(1, 0.20, 0.50);
					}
				}
			}
			else if (TeamNum == 2 && PlayerNum > 2 && teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (topOrBottom > 0.5) 			// *** Start on the Top
				{
					if (teamZeroCount == 2) // 2v2
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.89, 0.04); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.21, 0.36); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);
					}
					else if (teamZeroCount == 3) // 3v3
	{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.85, 0.06); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.37, 0.37, 0);
	
							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.19, 0.40); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.37, 0.37, 0);	
					}
					else // 4v4
	{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.86, 0.08); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.17, 0.41); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.38, 0.38, 0);	
					}
	}
				else 							// *** Start on the Bottom
				{
					if (teamZeroCount == 2) // 2v2
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.71, 0.86); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.39, 0.54); 
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.36, 0.36, 0);
					}
					else if (teamZeroCount == 3) // 3v3
					{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.69, 0.90); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.37, 0.37, 0);

							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.35, 0.56); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.37, 0.37, 0);	
					}
					else // 4v4
					{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.67, 0.91); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.38, 0.38, 0);

							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.34, 0.58); 
							rmSetTeamSpacingModifier(0.25);
							rmPlacePlayersCircular(0.38, 0.38, 0);	
					}
				}
			}
			else // unequal N of players per TEAM
			{
	if (topOrBottom > 0.5)
	{
					if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
					{
						if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
						{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.01, 0.03); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							if (teamOneCount == 2)
								rmSetPlacementSection(0.20, 0.30); //
							else
								rmSetPlacementSection(0.18, 0.42); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	}
						else // 2v1, 3v1, 4v1, etc.
						{
							rmSetPlacementTeam(0);
							if (teamZeroCount == 2)
								rmSetPlacementSection(0.95, 0.05); //
	else
								rmSetPlacementSection(0.83, 0.07); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.21, 0.23); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
					}
					else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
	{
						if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
						{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.95, 0.05); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.20, 0.40); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	}
						else // 3v2, 4v2, etc.
						{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.20, 0.40); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);

							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.95, 0.05); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
					}
					else // 3v4, 4v3, etc.
	{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.85, 0.05); //
						rmSetTeamSpacingModifier(0.50);
						rmPlacePlayersCircular(0.38, 0.38, 0);
	
						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.20, 0.40); //
						rmSetTeamSpacingModifier(0.50);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
	}
	else
	{
					if (teamZeroCount == 1 || teamOneCount == 1) // one team is one player
					{
						if (teamZeroCount < teamOneCount) // 1v2, 1v3, 1v4, etc.
						{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.71, 0.73); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							if (teamOneCount == 2)
								rmSetPlacementSection(0.45, 0.55); //
							else
								rmSetPlacementSection(0.33, 0.57); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	}
						else // 2v1, 3v1, 4v1, etc.
						{
							rmSetPlacementTeam(0);
							if (teamZeroCount == 2)
								rmSetPlacementSection(0.70, 0.80); //
							else
								rmSetPlacementSection(0.68, 0.92); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);

							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.51, 0.53); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
						}
					}
					else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
	{
						if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
						{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.70, 0.80); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.35, 0.55); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	}
						else // 3v2, 4v2, etc.
	{
							rmSetPlacementTeam(0);
							rmSetPlacementSection(0.70, 0.90); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	
							rmSetPlacementTeam(1);
							rmSetPlacementSection(0.45, 0.55); //
							rmSetTeamSpacingModifier(0.50);
							rmPlacePlayersCircular(0.38, 0.38, 0);
	}
					}
					else // 3v4, 4v3, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.70, 0.90); //
						rmSetTeamSpacingModifier(0.50);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.35, 0.55); //
						rmSetTeamSpacingModifier(0.50);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
			}
	}

	// check for KOTH game mode
	if (rmGetIsKOTH() == true)
	{

		float xLoc = 0.0;

		if (TeamNum == 2) {
			if (topOrBottom > .5)
				xLoc = .3;
			else	
				xLoc = .7;
	}
	else
			xLoc = 0.5;

		ypKingsHillLandfill(xLoc, xLoc, .0075, 4.5, "amazon grass", 0);
		ypKingsHillPlacer(xLoc, xLoc, 0.00, 0);
		rmEchoInfo("XLOC = " + xLoc);
		rmEchoInfo("YLOC = " + xLoc);
	}

    int avoidKOTH = rmCreateTypeDistanceConstraint("avoids the center for KOTH _dk", "ypKingsHill", 12.0);

	int failCount = -1;
	int numTries = cNumberNonGaiaPlayers + 2;

	// Text
	rmSetStatusText("", 0.50);

	// PLAYER STARTING RESOURCES
	rmClearClosestPointConstraints();
	int TCfloat = -1;
	if (cNumberTeams == 2)
	{
		if (cNumberNonGaiaPlayers > 2)
			TCfloat = 0;
		else if (cNumberNonGaiaPlayers > 5)
			TCfloat = 0;
		else
			TCfloat = 0;
	}
	else
		TCfloat = 0;

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
	rmAddObjectDefToClass(TCID, rmClassID("startingResource"));
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, TCfloat);

	int playerSilverID = rmCreateObjectDef("player mine");
	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerSilverID, 16.0);
	rmSetObjectDefMaxDistance(playerSilverID, 16.0);
	rmAddObjectDefToClass(playerSilverID, rmClassID("classGold"));
	rmAddObjectDefToClass(playerSilverID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerSilverID, avoidStartingResourcesShort);
//	rmAddObjectDefConstraint(playerSilverID, stayMidIsland);
//	rmAddObjectDefConstraint(playerSilverID, avoidMidSmIslandMin);

	int playerSilver2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playerSilver2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playerSilver2ID, 24.0);
	rmSetObjectDefMaxDistance(playerSilver2ID, 26.0);
	rmAddObjectDefToClass(playerSilver2ID, rmClassID("classGold"));
	rmAddObjectDefToClass(playerSilver2ID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerSilver2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerSilver2ID, avoidGold);
	rmAddObjectDefConstraint(playerSilver2ID, avoidNatives);
	rmAddObjectDefConstraint(playerSilver2ID, avoidRiver);
//	rmAddObjectDefConstraint(playerSilver2ID, stayMidIsland);

	int playerCapybaraID = rmCreateObjectDef("player Capybara");
	rmAddObjectDefItem(playerCapybaraID, "capybara", 16, 6.0);
	rmSetObjectDefMinDistance(playerCapybaraID, 16);
	rmSetObjectDefMaxDistance(playerCapybaraID, 16);
	rmAddObjectDefToClass(playerCapybaraID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerCapybaraID, avoidStartingResourcesMin);
	rmAddObjectDefConstraint(playerCapybaraID, avoidNatives);
	rmAddObjectDefConstraint(playerCapybaraID, avoidForestShort);
//	rmAddObjectDefConstraint(playerCapybaraID, stayMidIsland);
	rmSetObjectDefCreateHerd(playerCapybaraID, true);

	int playerCapybara2ID = rmCreateObjectDef("player second Capybara");
	rmAddObjectDefItem(playerCapybara2ID, "capybara", 8, 5.0);
	rmSetObjectDefMinDistance(playerCapybara2ID, 26);
	rmSetObjectDefMaxDistance(playerCapybara2ID, 30);
	rmAddObjectDefToClass(playerCapybara2ID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerCapybara2ID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerCapybara2ID, avoidNatives);
	rmAddObjectDefConstraint(playerCapybara2ID, avoidRiver);
	rmAddObjectDefConstraint(playerCapybara2ID, avoidForestShort);
//	rmAddObjectDefConstraint(playerCapybara2ID, stayMidIsland);
//	rmAddObjectDefConstraint(playerCapybara2ID, stayMidSmIsland);
	rmSetObjectDefCreateHerd(playerCapybara2ID, true);

	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefToClass(playerNuggetID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerNuggetID, avoidRiver);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
//	rmAddObjectDefConstraint(playerNuggetID, stayMidIsland);
//	rmAddObjectDefConstraint(playerNuggetID, stayMidSmIsland);
	rmSetObjectDefMinDistance(playerNuggetID, 20.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 24.0);

	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, "TreeAmazon", 10, 6.0);
	rmSetObjectDefMinDistance(playerTreeID, 18);
	rmSetObjectDefMaxDistance(playerTreeID, 18);
	rmAddObjectDefToClass(playerTreeID, rmClassID("classForest"));
	rmAddObjectDefToClass(playerTreeID, rmClassID("startingResource"));
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(playerTreeID, avoidGoldShort);
//	rmAddObjectDefConstraint(playerTreeID, stayMidIsland);
//	rmAddObjectDefConstraint(playerTreeID, avoidMidSmIslandMin);

	for (i = 1; < cNumberPlayers)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerSilverID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerSilver2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerCapybaraID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (PlayerNum > 2 || rmGetIsTreaty() == true)
			rmPlaceObjectDefAtLoc(playerCapybara2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		if (TeamNum > 2)
			rmPlaceObjectDefAtLoc(playerCapybara2ID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		if (ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));

		rmClearClosestPointConstraints();
	}

	// Text
	rmSetStatusText("", 0.60);

	// Corner/perimeter trees for Floko
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.47), rmXFractionToMeters(0.50), rmDegreesToRadians(0),rmDegreesToRadians(360)); 
	
	int rimTreesEID=rmCreateObjectDef("rim treesE");
	rmAddObjectDefItem(rimTreesEID, "TreeAmazon", 1, 0.0);	
	rmAddObjectDefToClass(rimTreesEID, rmClassID("classForest")); 
	rmSetObjectDefMinDistance(rimTreesEID, rmXFractionToMeters(0.30));
	rmSetObjectDefMaxDistance(rimTreesEID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(rimTreesEID, avoidMidIslandMin);	
	rmAddObjectDefConstraint(rimTreesEID, avoidNatives);	
	rmAddObjectDefConstraint(rimTreesEID, avoidRiverMin);	
	rmAddObjectDefConstraint(rimTreesEID, Eastward);	
	rmAddObjectDefConstraint(rimTreesEID, stayNearEdge);	
	if (topOrBottom > 0.5)
		rmAddObjectDefConstraint(rimTreesEID, stayNorthish);	
	else
		rmAddObjectDefConstraint(rimTreesEID, staySouthish);	
	if (TeamNum == 2)
		rmPlaceObjectDefAtLoc(rimTreesEID, 0, 0.5, 0.5, 25*PlayerNum);
	if (rmGetIsTreaty() == true)
		rmPlaceObjectDefAtLoc(rimTreesEID, 0, 0.5, 0.5, 75*PlayerNum);

	int rimTreesWID=rmCreateObjectDef("rim treesW");
	rmAddObjectDefItem(rimTreesWID, "TreeAmazon", 1, 0.0);	
	rmAddObjectDefToClass(rimTreesWID, rmClassID("classForest")); 
	rmSetObjectDefMinDistance(rimTreesWID, rmXFractionToMeters(0.30));
	rmSetObjectDefMaxDistance(rimTreesWID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(rimTreesWID, avoidMidIslandMin);	
	rmAddObjectDefConstraint(rimTreesWID, avoidNatives);	
	rmAddObjectDefConstraint(rimTreesWID, avoidRiverMin);	
	rmAddObjectDefConstraint(rimTreesWID, Westward);	
	rmAddObjectDefConstraint(rimTreesWID, stayNearEdge);	
	if (topOrBottom > 0.5)
		rmAddObjectDefConstraint(rimTreesWID, stayNorthish);	
	else
		rmAddObjectDefConstraint(rimTreesWID, staySouthish);	
	if (TeamNum == 2)
		rmPlaceObjectDefAtLoc(rimTreesWID, 0, 0.5, 0.5, 25*PlayerNum);
	if (rmGetIsTreaty() == true)
		rmPlaceObjectDefAtLoc(rimTreesWID, 0, 0.5, 0.5, 75*PlayerNum);

	int cornerTreesID=rmCreateObjectDef("corner trees");
	if (rmGetIsTreaty() == true && PlayerNum > 2)
		rmAddObjectDefItem(cornerTreesID, "TreeAmazon", 40, 10.0);	
	else
		rmAddObjectDefItem(cornerTreesID, "TreeAmazon", 20, 10.0);	
	rmAddObjectDefToClass(cornerTreesID, rmClassID("classForest")); 
	rmSetObjectDefMinDistance(cornerTreesID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(cornerTreesID, rmXFractionToMeters(0.025));
	rmAddObjectDefConstraint(cornerTreesID, avoidRiverMin);	
	rmAddObjectDefConstraint(cornerTreesID, avoidTownCenter);	
	rmAddObjectDefConstraint(cornerTreesID, avoidStartingResources);	
	rmAddObjectDefConstraint(cornerTreesID, stayRiver);	
	if (TeamNum == 2) {
		rmPlaceObjectDefAtLoc(cornerTreesID, 0, 0.90, 0.65);
		rmPlaceObjectDefAtLoc(cornerTreesID, 0, 0.65, 0.90);
		rmPlaceObjectDefAtLoc(cornerTreesID, 0, 0.10, 0.35);
		rmPlaceObjectDefAtLoc(cornerTreesID, 0, 0.35, 0.10);
		}

	rmSetStatusText("", 0.70);

	// Silver mines
	int silverID = rmCreateObjectDef("silverEast");
		rmAddObjectDefItem(silverID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverID, 0.0);
	rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.45));
	rmAddObjectDefToClass(silverID, rmClassID("classGold"));
		rmAddObjectDefConstraint(silverID, avoidCoin);
	rmAddObjectDefConstraint(silverID, avoidTownCenterSupaFar);
		rmAddObjectDefConstraint(silverID, avoidNatives);
	rmAddObjectDefConstraint(silverID, avoidRiverMed);
		rmAddObjectDefConstraint(silverID, Eastward);
	rmAddObjectDefConstraint(silverID, stayMidIsland);
	rmAddObjectDefConstraint(silverID, avoidStartingResources);
	rmAddObjectDefConstraint(silverID, avoidKOTH);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(silverID, stayNorthish);
		else
			rmAddObjectDefConstraint(silverID, staySouthish);
	}
	rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers/2);

	int silverWestID = rmCreateObjectDef("silverWest");
		rmAddObjectDefItem(silverWestID, "mine", 1, 0.0);
		rmSetObjectDefMinDistance(silverWestID, 0.0);
	rmSetObjectDefMaxDistance(silverWestID, rmXFractionToMeters(0.45));
	rmAddObjectDefToClass(silverWestID, rmClassID("classGold"));
		rmAddObjectDefConstraint(silverWestID, avoidCoin);
	rmAddObjectDefConstraint(silverWestID, avoidTownCenterSupaFar);
		rmAddObjectDefConstraint(silverWestID, avoidNatives);
	rmAddObjectDefConstraint(silverWestID, avoidRiverMed);
		rmAddObjectDefConstraint(silverWestID, Westward);
	rmAddObjectDefConstraint(silverWestID, stayMidIsland);
	rmAddObjectDefConstraint(silverWestID, avoidStartingResources);
	rmAddObjectDefConstraint(silverWestID, avoidKOTH);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(silverWestID, stayNorthish);
		else
			rmAddObjectDefConstraint(silverWestID, staySouthish);
	}
	rmPlaceObjectDefAtLoc(silverWestID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers/2);

	rmSetStatusText("", 0.80);

	// Tree clumps
	int westTreeID = rmCreateObjectDef("W trees");
	rmAddObjectDefItem(westTreeID, "TreeAmazon", 20, 10.0);
	rmSetObjectDefMinDistance(westTreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(westTreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(westTreeID, rmClassID("classForest"));
	rmAddObjectDefConstraint(westTreeID, avoidForest);
	rmAddObjectDefConstraint(westTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(westTreeID, avoidTownCenterFar);
	rmAddObjectDefConstraint(westTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(westTreeID, avoidNatives);
	rmAddObjectDefConstraint(westTreeID, avoidKOTH);
	rmAddObjectDefConstraint(westTreeID, Westward);
	rmAddObjectDefConstraint(westTreeID, avoidRiverMed);
//	rmAddObjectDefConstraint(westTreeID, stayMidIsland);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(westTreeID, avoidCrossingS);	
	else
			rmAddObjectDefConstraint(westTreeID, avoidCrossingN);	
		}
	rmPlaceObjectDefAtLoc(westTreeID, 0, 0.50, 0.50, 3*cNumberNonGaiaPlayers);

	int eastTreeID = rmCreateObjectDef("E trees");
	rmAddObjectDefItem(eastTreeID, "TreeAmazon", 20, 10.0);
	rmSetObjectDefMinDistance(eastTreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(eastTreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(eastTreeID, rmClassID("classForest"));
	rmAddObjectDefConstraint(eastTreeID, avoidForest);
	rmAddObjectDefConstraint(eastTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(eastTreeID, avoidTownCenterFar);
	rmAddObjectDefConstraint(eastTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(eastTreeID, avoidNatives);
	rmAddObjectDefConstraint(eastTreeID, avoidKOTH);
	rmAddObjectDefConstraint(eastTreeID, Eastward);
	rmAddObjectDefConstraint(eastTreeID, avoidRiverMed);
//	rmAddObjectDefConstraint(eastTreeID, stayMidIsland);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(eastTreeID, avoidCrossingS);	
	else
			rmAddObjectDefConstraint(eastTreeID, avoidCrossingN);	
		}
	rmPlaceObjectDefAtLoc(eastTreeID, 0, 0.50, 0.50, 3*cNumberNonGaiaPlayers);

	// Random trees
	int randTreeID = rmCreateObjectDef("random trees");
	rmAddObjectDefItem(randTreeID, "TreeAmazon", 3, 5.0);
	rmSetObjectDefMinDistance(randTreeID,  rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(randTreeID,  rmXFractionToMeters(0.50));
	rmAddObjectDefToClass(randTreeID, rmClassID("classForest"));
	rmAddObjectDefConstraint(randTreeID, avoidForest);
	rmAddObjectDefConstraint(randTreeID, avoidGoldShort);
	rmAddObjectDefConstraint(randTreeID, avoidTownCenterFar);
	rmAddObjectDefConstraint(randTreeID, avoidStartingResources);
	rmAddObjectDefConstraint(randTreeID, avoidNatives);
	rmAddObjectDefConstraint(randTreeID, avoidKOTH);
	rmAddObjectDefConstraint(randTreeID, avoidRiver);
//	rmAddObjectDefConstraint(randTreeID, stayMidIsland);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(randTreeID, avoidCrossingSShort);	
		else
			rmAddObjectDefConstraint(randTreeID, avoidCrossingNShort);	
	}
	rmPlaceObjectDefAtLoc(randTreeID, 0, 0.50, 0.50, 10*cNumberNonGaiaPlayers);	

	rmSetStatusText("", 0.90);

	// Hunts
	int tapirEastID = rmCreateObjectDef("tapir east herd ");
	rmAddObjectDefItem(tapirEastID, "tapir", 9, 6);
		rmSetObjectDefMinDistance(tapirEastID, 0.0);
	rmSetObjectDefMaxDistance(tapirEastID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(tapirEastID, avoidTapir);
		rmAddObjectDefConstraint(tapirEastID, avoidCapybara);
	rmAddObjectDefConstraint(tapirEastID, avoidStartingResources);
	rmAddObjectDefConstraint(tapirEastID, avoidNatives);
		rmAddObjectDefConstraint(tapirEastID, avoidRiver);
	rmAddObjectDefConstraint(tapirEastID, avoidTownCenter);
	rmAddObjectDefConstraint(tapirEastID, avoidForestMin);
	rmAddObjectDefConstraint(tapirEastID, avoidGoldMin);
	rmAddObjectDefConstraint(tapirEastID, stayMidIsland);
	rmAddObjectDefConstraint(tapirEastID, avoidKOTH);
		rmAddObjectDefConstraint(tapirEastID, Eastward);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(tapirEastID, stayNorthish);
		else
			rmAddObjectDefConstraint(tapirEastID, staySouthish);
		}
		rmSetObjectDefCreateHerd(tapirEastID, true);
	rmPlaceObjectDefAtLoc(tapirEastID, 0, 0.5, 0.5, 2*PlayerNum);

	int tapirWestID = rmCreateObjectDef("tapir west herd ");
	rmAddObjectDefItem(tapirWestID, "tapir", 9, 6);
		rmSetObjectDefMinDistance(tapirWestID, 0.0);
	rmSetObjectDefMaxDistance(tapirWestID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(tapirWestID, avoidTapir);
		rmAddObjectDefConstraint(tapirWestID, avoidCapybara);
	rmAddObjectDefConstraint(tapirWestID, avoidStartingResources);
	rmAddObjectDefConstraint(tapirWestID, avoidNatives);
		rmAddObjectDefConstraint(tapirWestID, avoidRiver);
	rmAddObjectDefConstraint(tapirWestID, avoidTownCenter);
	rmAddObjectDefConstraint(tapirWestID, avoidForestMin);
	rmAddObjectDefConstraint(tapirWestID, avoidGoldMin);
	rmAddObjectDefConstraint(tapirWestID, stayMidIsland);
	rmAddObjectDefConstraint(tapirWestID, avoidKOTH);
		rmAddObjectDefConstraint(tapirWestID, Westward);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(tapirWestID, stayNorthish);
		else
			rmAddObjectDefConstraint(tapirWestID, staySouthish);
		}
		rmSetObjectDefCreateHerd(tapirWestID, true);
	rmPlaceObjectDefAtLoc(tapirWestID, 0, 0.5, 0.5, 2*PlayerNum);

	// Define and place Nuggets
	int nuggetnutsEID = rmCreateObjectDef("nugget nuts E");
	rmAddObjectDefItem(nuggetnutsEID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmSetObjectDefMinDistance(nuggetnutsEID, 0.0);
	rmSetObjectDefMaxDistance(nuggetnutsEID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetnutsEID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidTownCenterFFAFar);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidRiver);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidNatives);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidForestMin);
	rmAddObjectDefConstraint(nuggetnutsEID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggetnutsEID, stayMidIsland);
	rmAddObjectDefConstraint(nuggetnutsEID, Eastward);
	if (PlayerNum > 2 && rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(nuggetnutsEID, 0, 0.5, 0.5, PlayerNum/2);

	int nuggetnutsWID = rmCreateObjectDef("nugget nuts W");
	rmAddObjectDefItem(nuggetnutsWID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(4, 4);
	rmSetObjectDefMinDistance(nuggetnutsWID, 0.0);
	rmSetObjectDefMaxDistance(nuggetnutsWID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetnutsWID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidTownCenterFFAFar);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidRiver);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidNatives);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidForestMin);
	rmAddObjectDefConstraint(nuggetnutsWID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggetnutsWID, stayMidIsland);
	rmAddObjectDefConstraint(nuggetnutsWID, Westward);
	if (PlayerNum > 2 && rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(nuggetnutsWID, 0, 0.5, 0.5, PlayerNum/2);

	int nuggethardID = rmCreateObjectDef("nugget hard");
	rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethardID, 0.0);
	rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggethardID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggethardID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggethardID, avoidRiver);
	rmAddObjectDefConstraint(nuggethardID, avoidNatives);
	rmAddObjectDefConstraint(nuggethardID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggethardID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggethardID, avoidForestMin);
	rmAddObjectDefConstraint(nuggethardID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggethardID, stayMidIsland);
	rmAddObjectDefConstraint(nuggethardID, Eastward);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(nuggethardID, avoidCrossingS);	
		else
			rmAddObjectDefConstraint(nuggethardID, avoidCrossingN);	
		}
	if (PlayerNum > 2)
		rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	int nuggethard2ID = rmCreateObjectDef("nugget hard2");
	rmAddObjectDefItem(nuggethard2ID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(3, 3);
	rmSetObjectDefMinDistance(nuggethard2ID, 0.0);
	rmSetObjectDefMaxDistance(nuggethard2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggethard2ID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggethard2ID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggethard2ID, avoidRiver);
	rmAddObjectDefConstraint(nuggethard2ID, avoidNatives);
	rmAddObjectDefConstraint(nuggethard2ID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggethard2ID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggethard2ID, avoidForestMin);
	rmAddObjectDefConstraint(nuggethard2ID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggethard2ID, stayMidIsland);
	rmAddObjectDefConstraint(nuggethard2ID, Westward);
	if (PlayerNum == 2) {
		if (topOrBottom > 0.5)
			rmAddObjectDefConstraint(nuggethard2ID, avoidCrossingS);	
		else
			rmAddObjectDefConstraint(nuggethard2ID, avoidCrossingN);	
	}
	if (PlayerNum > 2)
		rmPlaceObjectDefAtLoc(nuggethard2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);

	int nuggetmediumEastID = rmCreateObjectDef("nugget medium east");
	rmAddObjectDefItem(nuggetmediumEastID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(nuggetmediumEastID, 0.0);
	rmSetObjectDefMaxDistance(nuggetmediumEastID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidNugget);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidRiverMin);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidNatives);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidForestMin);
	rmAddObjectDefConstraint(nuggetmediumEastID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggetmediumEastID, stayMidIsland);
	rmAddObjectDefConstraint(nuggetmediumEastID, Eastward);
	rmPlaceObjectDefAtLoc(nuggetmediumEastID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int nuggetmediumWestID = rmCreateObjectDef("nugget medium west");
	rmAddObjectDefItem(nuggetmediumWestID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	rmSetObjectDefMinDistance(nuggetmediumWestID, 0.0);
	rmSetObjectDefMaxDistance(nuggetmediumWestID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidNugget);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidRiverMin);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidNatives);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidForestMin);
	rmAddObjectDefConstraint(nuggetmediumWestID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggetmediumWestID, stayMidIsland);
	rmAddObjectDefConstraint(nuggetmediumWestID, Westward);
	rmPlaceObjectDefAtLoc(nuggetmediumWestID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

	int nuggeteasyID = rmCreateObjectDef("nugget easy");
	rmAddObjectDefItem(nuggeteasyID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(nuggeteasyID, avoidNugget);
	rmAddObjectDefConstraint(nuggeteasyID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggeteasyID, avoidRiverMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidNatives);
	rmAddObjectDefConstraint(nuggeteasyID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggeteasyID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidForestMin);
	rmAddObjectDefConstraint(nuggeteasyID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggeteasyID, stayMidIsland);
	rmAddObjectDefConstraint(nuggeteasyID, Eastward);
	rmPlaceObjectDefAtLoc(nuggeteasyID, 0, 0.5, 0.5, 2+2*cNumberNonGaiaPlayers);

	int nuggeteasyWID = rmCreateObjectDef("nugget easyW");
	rmAddObjectDefItem(nuggeteasyWID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyWID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyWID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(nuggeteasyWID, avoidNugget);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidRiverMin);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidNatives);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidStartingResources);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidForestMin);
	rmAddObjectDefConstraint(nuggeteasyWID, avoidTapirMin);
	rmAddObjectDefConstraint(nuggeteasyWID, stayMidIsland);
	rmAddObjectDefConstraint(nuggeteasyWID, Westward);
	rmPlaceObjectDefAtLoc(nuggeteasyWID, 0, 0.5, 0.5, 2+2*cNumberNonGaiaPlayers);

	// PAROT decorative particle
	int particleDecorationID = rmCreateObjectDef("Particle Things");
	rmAddObjectDefItem(particleDecorationID, "PropDustCloud", 1, 0.0);
	//rmAddObjectDefItem(particleDecorationID, "PropRiverFlow", 2, 0.0);
	rmAddObjectDefConstraint(particleDecorationID, avoidRiverMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidNatives);
	rmAddObjectDefConstraint(particleDecorationID, avoidForestMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidGoldMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidTapirMin);
	rmAddObjectDefConstraint(particleDecorationID, avoidStartingResources);
	rmSetObjectDefMinDistance(particleDecorationID, 0.0);
	rmSetObjectDefMaxDistance(particleDecorationID, rmXFractionToMeters(0.40));
	rmPlaceObjectDefAtLoc(particleDecorationID, 0, 0.5, 0.5, 20);

	// Feeling some jungle vibes
	int openBrushID = rmCreateObjectDef("Openbrush Amazon");
	rmAddObjectDefItem(openBrushID, "OpenbrushAmazon", 1, 0.0);
	rmAddObjectDefConstraint(openBrushID, avoidRiverMin);
	rmAddObjectDefConstraint(openBrushID, avoidNatives);
	rmAddObjectDefConstraint(openBrushID, avoidForestBrush);
	rmAddObjectDefConstraint(openBrushID, avoidGoldMin);
	rmAddObjectDefConstraint(openBrushID, avoidTapirMin);
	rmAddObjectDefConstraint(openBrushID, avoidStartingResources);
	rmAddObjectDefConstraint(openBrushID, avoidMidIsland);
	rmSetObjectDefMinDistance(openBrushID, 0.0);
	rmSetObjectDefMaxDistance(openBrushID, rmXFractionToMeters(0.50));
	if (topOrBottom > 0.5)
		rmAddObjectDefConstraint(openBrushID, stayNorthish);	
	else
		rmAddObjectDefConstraint(openBrushID, staySouthish);	
	if (TeamNum == 2)
		rmPlaceObjectDefAtLoc(openBrushID, 0, 0.5, 0.5, 50+50*PlayerNum);
	
	// Paul decorative Fish
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int FishID = rmCreateObjectDef("Fish Things");
	//rmAddObjectDefItem(FishID, "PropSwan", 1, 0.0);
	rmAddObjectDefItem(FishID, "PropFish", 1, 0.0);
	rmAddObjectDefConstraint(FishID, fishLand);
	rmSetObjectDefMinDistance(FishID, 0.0);
	rmSetObjectDefMaxDistance(FishID, rmXFractionToMeters(0.40));
	rmPlaceObjectDefAtLoc(FishID, 0, 0.5, 0.5, 30);

	// PAROT decorative particle
	//int particleDecorationID=rmCreateObjectDef("Particle WaterThings");
	//rmAddObjectDefItem(particleDecorationID, "PropRiverFlow", 1, 0.0);
	//rmSetObjectDefMinDistance(particleDecorationID, 0.0);
	//rmSetObjectDefMaxDistance(particleDecorationID, rmXFractionToMeters(0.40));
	//rmPlaceObjectDefAtLoc(particleDecorationID, 0, 0.5, 0.5, 1000);

	// Text
	rmSetStatusText("", 1.0);
}
