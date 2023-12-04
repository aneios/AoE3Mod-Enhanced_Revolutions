// May 2020: Rebranded by Rikikipu from Herald Island to Artic Territories for Age of Empires III: Definitive Edition
// February 2021 edited by vividlyplain, updated May 2021

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

// Main entry point for random map script
void main(void)
{

	// --------------- Make load bar move. ----------------------------------------------------------------------------
	rmSetStatusText("", 0.10);
	string MixType = "rockies_snow";

	// Set size of map
	int playerTiles = 17500;
	if (PlayerNum > 2)
		playerTiles = 13000;
	if (PlayerNum > 4)
		playerTiles = 11000;
	if (PlayerNum > 6)
		playerTiles = 10000;
	int size = 2.0 * sqrt(PlayerNum * playerTiles);
	rmSetMapSize(size, size);

	// Set up default water type.
	rmSetSeaLevel(-10.0);
	rmSetSeaType("Great Lakes Ice2");	// Yukon River6 	// Great Lakes Ice
	rmSetOceanReveal(true);
	rmSetWindMagnitude(2.0);
	rmSetMapType("ArcticTerritories");
	rmSetMapType("grass");
	rmSetMapType("water");
	rmSetLightingSet("ArcticTerritories_Skirmish");

	rmTerrainInitialize("water");

	int numTries = -1;
	int classPlayer = rmDefineClass("player");
	int classIsland = rmDefineClass("island");
	int classForest = rmDefineClass("classForest");
	int classImportantItem = rmDefineClass("importantItem");
	rmDefineClass("natives");
	int classSocket = rmDefineClass("classSocket");
	rmDefineClass("canyon");
	int classCliff = rmDefineClass("classCliff");
	int classStartingUnit = rmDefineClass("startingUnit");
	int classPatch = rmDefineClass("classPatch");

	// -------------Define constraints----------------------------------------

	// Player area constraint.
	int avoidTC = rmCreateTypeDistanceConstraint("stay away from TC", "TownCenter", 30.0);
	int avoidTCFar = rmCreateTypeDistanceConstraint("stay away from TC Far", "TownCenter", 60.0);
	int avoidTCFar1 = rmCreateTypeDistanceConstraint("stay away from TC Far1", "TownCenter", 40.0);
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", classStartingUnit, 8.0);

	// Ressources Constraint
	int avoidCoin = rmCreateTypeDistanceConstraint("avoid coin", "MineTin", 50.0);
	int avoidCoinStart = rmCreateTypeDistanceConstraint("avoid coin 2", "MineTin", 20.0);
	int avoidRandomTurkeys = rmCreateTypeDistanceConstraint("avoid random turkeys", "turkey", 50.0);
	int forestRightConstraint = rmCreateClassDistanceConstraint("forest vs. forest right", classForest, 5.0);
	int forestID = -1;
	int forestConstraint = rmCreateClassDistanceConstraint("forest vs. forest", classForest, 35.0);
	int avoidMuskOx = rmCreateTypeDistanceConstraint("avoid muskox", "muskOx", 48.0);
	int avoidMoose = rmCreateTypeDistanceConstraint("avoid moose", "moose", 18.0);
	int avoidCaribou = rmCreateTypeDistanceConstraint("avoid caribou", "caribou", 48.0);
	int avoidCaribouShort = rmCreateTypeDistanceConstraint("avoid caribou short", "caribou", 15.0);
	int avoidCoinShort = rmCreateTypeDistanceConstraint("avoids coin short", "gold", 8.0);

	// Generic Contraints
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 5.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land like Arkansas for tree", "Land", false, 3.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 6.0);
	int avoidSocket = rmCreateClassDistanceConstraint("avoid socket", classSocket, 8.0);
	int avoidImportantItem = rmCreateClassDistanceConstraint("secrets etc avoid each other", classImportantItem, 50.0);
	int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);
	int avoidCliffsShort = rmCreateClassDistanceConstraint("avoid Cliffs short", classCliff, 4.0);
	int avoidCliffs = rmCreateClassDistanceConstraint("avoid Cliffs", classCliff, 10.0);
	int avoidNugget = rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 35.0);
	int avoidNuggetStart = rmCreateTypeDistanceConstraint("nugget avoid nugget start", "AbstractNugget", 20.0);

	// Custom Contraints
	int Promontoir = rmCreatePieConstraint("promontoir", 0.5, 0.77, rmXFractionToMeters(0.04), rmXFractionToMeters(0.8), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int PromontoirHunts = rmCreatePieConstraint("eviter le petit promontoir", 0.5, 0.75, rmXFractionToMeters(0.06), rmXFractionToMeters(0.8), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int ContrePromontoir = rmCreatePieConstraint("contre promontoir", 0.5, 0.91, rmXFractionToMeters(0.08), rmXFractionToMeters(0.9), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int avoidPic = rmCreatePieConstraint("avoid Pic", 0.5, 0.15, rmXFractionToMeters(0.08), rmXFractionToMeters(0.5), rmDegreesToRadians(0), rmDegreesToRadians(360));

    //avoidKOTH
    int avoidKOTH = rmCreateTypeDistanceConstraint("avoids the center for KOTH _dk", "ypKingsHill", 15);

	chooseMercs();

	// ----------------------------------------- Building the layout ------------------------------------------------------
	float coeff = 1.6;
	if (TeamNum > 2)
		coeff = 1.7; 

	int lePuit = rmCreateArea("le trou en haut");
	rmSetAreaLocation(lePuit, 0.38, 0.75);
	if (TeamNum > 2 && numPlayer > 2)
	{
		rmAddAreaInfluenceSegment(lePuit, 0.45, 0.75, 0.55, 0.75);
	}
	else
	{
		rmAddAreaInfluenceSegment(lePuit, 0.3, 0.75, 0.7, 0.75);
	}
	rmSetAreaSize(lePuit, 0.02 * coeff, 0.02 * coeff);
	if (TeamNum > 2 && numPlayer > 2)
	{
		rmSetAreaSize(lePuit, 0.005 * coeff, 0.005 * coeff);
	}
	rmSetAreaCliffType(lePuit, "SPC Mountain Pass");
	rmSetAreaCliffEdge(lePuit, 1, 1.0);
	rmSetAreaCliffPainting(lePuit, true, true, true, 1.5, true);
	rmSetAreaCliffHeight(lePuit, -20, 0.0, 0.5);
	rmSetAreaHeightBlend(lePuit, 1);
	rmSetAreaSmoothDistance(lePuit, 40);
	rmAddAreaConstraint(lePuit, Promontoir);
	rmSetAreaCoherence(lePuit, 0.7);
	rmBuildArea(lePuit);

	int avanceeBasGauche = rmCreateArea("avancee en bas trou gauche");
	rmSetAreaLocation(avanceeBasGauche, 0.35, 0.11);
	rmAddAreaInfluenceSegment(avanceeBasGauche, 0.2, 0.11, 0.43, 0.11);
	rmSetAreaSize(avanceeBasGauche, 0.017 * coeff, 0.017 * coeff);
	rmSetAreaCliffType(avanceeBasGauche, "SPC Mountain Pass");
	rmSetAreaCliffEdge(avanceeBasGauche, 1, 1.0);
	rmSetAreaCliffPainting(avanceeBasGauche, true, true, true, 1.5, true);
	rmSetAreaCliffHeight(avanceeBasGauche, -20, 0.0, 0.5);
	rmSetAreaHeightBlend(avanceeBasGauche, 1);
	rmAddAreaToClass(avanceeBasGauche, classCliff);
	rmSetAreaSmoothDistance(avanceeBasGauche, 10);
	rmSetAreaCoherence(avanceeBasGauche, 0.8);
	rmBuildArea(avanceeBasGauche);

	int avanceeBasDroite = rmCreateArea("avancee en bas trou droit");
	rmSetAreaLocation(avanceeBasDroite, 0.65, 0.12);
	rmAddAreaInfluenceSegment(avanceeBasDroite, 0.57, 0.1, 0.8, 0.11);
	rmSetAreaSize(avanceeBasDroite, 0.017 * coeff, 0.017 * coeff);
	rmSetAreaCliffType(avanceeBasDroite, "SPC Mountain Pass");
	rmSetAreaCliffEdge(avanceeBasDroite, 1, 1.0);
	rmSetAreaCliffPainting(avanceeBasDroite, true, true, true, 1.5, true);
	rmSetAreaCliffHeight(avanceeBasDroite, -20, 0.0, 0.5);
	rmSetAreaHeightBlend(avanceeBasDroite, 1);
	rmAddAreaToClass(avanceeBasDroite, classCliff);
	rmSetAreaSmoothDistance(avanceeBasDroite, 10);
	rmSetAreaCoherence(avanceeBasDroite, 0.8);
	rmBuildArea(avanceeBasDroite);

	// ************* TradeRoute & Center Island **************************************
	int tradeRouteID = rmCreateTradeRoute();
	int socketID = rmCreateObjectDef("sockets to dock Trade Posts");
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, classSocket);
	rmSetObjectDefMinDistance(socketID, 2.0);
	rmSetObjectDefMaxDistance(socketID, 8.0);

	rmAddTradeRouteWaypoint(tradeRouteID, 0.15, 0.4);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.3, 0.34, 4, 1);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.5, 0.25, 4, 1);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.7, 0.34, 4, 1);
	rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.4, 4, 1);

	bool placedTradeRoute = rmBuildTradeRoute(tradeRouteID, "snow");

	// Build The ISLAND
	int centerIsland = rmCreateArea("The Island");
	rmSetAreaLocation(centerIsland, 0.5, 0.5);
	rmSetAreaSize(centerIsland, 0.33 * coeff, 0.33 * coeff);
	rmSetAreaWarnFailure(centerIsland, false);
	rmSetAreaCliffType(centerIsland, "SPC Mountain Pass");
	rmSetAreaCliffEdge(centerIsland, 1, 1, 0, 0, 1);
	rmSetAreaMinBlobs(centerIsland, 2);
	rmSetAreaMaxBlobs(centerIsland, 2);
	rmAddAreaInfluenceSegment(centerIsland, 0.5, 0.47, 0.5, 0.53);
	rmSetAreaMix(centerIsland, MixType);
	rmSetAreaCliffPainting(centerIsland, true, true, true, 10, true);
	rmSetAreaCliffHeight(centerIsland, 10, 0.0, 0.5);
	rmSetAreaHeightBlend(centerIsland, 1);
	rmSetAreaSmoothDistance(centerIsland, 10);
	rmSetAreaCoherence(centerIsland, 0.88);
	rmBuildArea(centerIsland);

	int stayCenterIsland = rmCreateAreaConstraint("rester sur l'ile (ne pas aller dans l'eau)", centerIsland);

	int NewPatch = rmCreateArea("new Patch for the map");
	rmSetAreaLocation(NewPatch, 0.5, 0.5);
	rmSetAreaWarnFailure(NewPatch, false);
	rmSetAreaSize(NewPatch, 0.5 * coeff, 0.5 * coeff);
	rmSetAreaCoherence(NewPatch, 0.85);
	rmSetAreaSmoothDistance(NewPatch, 1);
	rmAddAreaToClass(NewPatch, classPatch);
	rmAddAreaConstraint(NewPatch, stayCenterIsland);
	rmSetAreaMix(NewPatch, MixType);
	rmBuildArea(NewPatch);

	int icePatch = rmCreateArea("ice on the top ramp");
	rmSetAreaLocation(icePatch, 0.5, 0.82);
	rmAddAreaInfluenceSegment(icePatch, 0.7, 0.82, 0.3, 0.82);
	rmSetAreaWarnFailure(icePatch, false);
	rmSetAreaSize(icePatch, 0.07 * coeff, 0.07 * coeff);
	rmSetAreaCoherence(icePatch, 0.95);
	rmSetAreaSmoothDistance(icePatch, 1);
	rmAddAreaToClass(icePatch, classPatch);
	rmSetAreaMix(icePatch, "great_lakes_ice");
	rmBuildArea(icePatch);

	int avoidIcePatch = rmCreateAreaDistanceConstraint("avoid icePatch", icePatch, 5);

	int snowOnIcePatch = rmCreateArea("snowOnTheIcePatch");
	rmSetAreaLocation(snowOnIcePatch, 0.5, 0.82);
	rmSetAreaWarnFailure(snowOnIcePatch, false);
	rmSetAreaSize(snowOnIcePatch, 0.014, 0.014);
	rmSetAreaCoherence(snowOnIcePatch, 0.85);
	rmSetAreaSmoothDistance(snowOnIcePatch, 1);
	rmAddAreaToClass(snowOnIcePatch, classPatch);
	rmSetAreaTerrainType(snowOnIcePatch, "yukon\ground1_yuk");
	rmBuildArea(snowOnIcePatch);

	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.1);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.5);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.9);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	//****************** La pente *************************************
	int rightPart = rmCreateArea("la petite partie penchee en bas");
	rmSetAreaSize(rightPart, 0.23, 0.23);
	rmSetAreaLocation(rightPart, 0.5, 0.1);
	rmSetAreaCliffType(rightPart, "SPC Mountain Pass");
	rmAddAreaInfluenceSegment(rightPart, 0.1, 0.1, 0.9, 0.1);
	rmSetAreaCliffEdge(rightPart, 1, 0.0);
	rmSetAreaCliffPainting(rightPart, true, true, true, 10, true);
	rmSetAreaCliffHeight(rightPart, -6, 0.0, 1);
	rmSetAreaTerrainType(rightPart, "yukon\ground1_yuk");
	rmSetAreaMix(rightPart, "araucania_snow_b");
	//   rmSetAreaHeightBlend(rightPart, 0);
	rmSetAreaSmoothDistance(rightPart, 5);
	rmSetAreaCoherence(rightPart, 0.9);
	rmBuildArea(rightPart);

	int stayRightPart = rmCreateAreaConstraint("rester sur la partie penchee", rightPart);

	int forest2 = rmCreateArea("se forest ");
	rmSetAreaWarnFailure(forest2, false);
	rmSetAreaSize(forest2, 0.5, 0.5);
	rmSetAreaForestType(forest2, "z38 Scandinavian Mountains");
	rmAddAreaConstraint(forest2, stayRightPart);
	rmAddAreaConstraint(forest2, avoidImpassableLandShort);
	rmAddAreaConstraint(forest2, avoidSocket);
	rmSetAreaForestDensity(forest2, 0.3);
	rmSetAreaForestClumpiness(forest2, 0.3);
	rmSetAreaForestUnderbrush(forest2, 0.5);
	rmBuildArea(forest2);

	// *********** 2 Cliffs area *****************
	/*	int LeftClliff1=rmCreateArea("Left Cliff1");
	rmSetAreaLocation(LeftClliff1, 0.64, 0.65);
	rmSetAreaSize(LeftClliff1, 0.0025, 0.0025);
    rmSetAreaWarnFailure(LeftClliff1, false);
	rmSetAreaCliffType(LeftClliff1, "SPC Mountain Pass");
    rmSetAreaCliffEdge(LeftClliff1, 1, 1);
	rmAddAreaInfluenceSegment(LeftClliff1, 0.64, 0.65, 0.64, 0.7);
    rmSetAreaCliffPainting(LeftClliff1, false, true, true, 1.5, true);
    rmSetAreaCliffHeight(LeftClliff1, 8, 0.0, 0.5);
    rmSetAreaHeightBlend(LeftClliff1, 1);
    rmAddAreaToClass(LeftClliff1, classCliff);
    rmSetAreaSmoothDistance(LeftClliff1, 5);
    rmSetAreaCoherence(LeftClliff1, 0.5);
	rmAddAreaConstraint(LeftClliff1,stayCenterIsland);
	rmBuildArea(LeftClliff1);*/

	int LeftCliff1A = rmCreateArea("Left Cliff1A");
	rmSetAreaLocation(LeftCliff1A, 0.64, 0.52);
	rmSetAreaSize(LeftCliff1A, 0.0025, 0.0025);
	rmSetAreaWarnFailure(LeftCliff1A, false);
	rmSetAreaCliffType(LeftCliff1A, "SPC Mountain Pass");
	rmSetAreaCliffEdge(LeftCliff1A, 1, 1);
	rmAddAreaInfluenceSegment(LeftCliff1A, 0.64, 0.50, 0.64, 0.55);
	rmSetAreaCliffPainting(LeftCliff1A, false, true, true, 1.5, true);
	rmSetAreaCliffHeight(LeftCliff1A, 8, 0.0, 0.5);
	rmSetAreaHeightBlend(LeftCliff1A, 1);
	rmAddAreaToClass(LeftCliff1A, classCliff);
	rmSetAreaSmoothDistance(LeftCliff1A, 5);
	rmSetAreaCoherence(LeftCliff1A, 0.5);
	rmAddAreaConstraint(LeftCliff1A, stayCenterIsland);
	rmBuildArea(LeftCliff1A);
	/*	
	int LeftCliff2=rmCreateArea("Left Cliff2");
	rmSetAreaLocation(LeftCliff2, 0.36, 0.65);
	rmSetAreaSize(LeftCliff2, 0.0025, 0.0025);
    rmSetAreaWarnFailure(LeftCliff2, false);
	rmSetAreaCliffType(LeftCliff2, "SPC Mountain Pass");
    rmSetAreaCliffEdge(LeftCliff2, 1, 1);
	rmAddAreaInfluenceSegment(LeftCliff2, 0.36, 0.65, 0.36, 0.7);
    rmSetAreaCliffPainting(LeftCliff2, false, true, true, 1.5, true);
    rmSetAreaCliffHeight(LeftCliff2, 8, 0.0, 0.5);
    rmSetAreaHeightBlend(LeftCliff2, 1);
    rmAddAreaToClass(LeftCliff2, classCliff);
    rmSetAreaSmoothDistance(LeftCliff2, 5);
    rmSetAreaCoherence(LeftCliff2, 0.5);
	rmAddAreaConstraint(LeftCliff2,stayCenterIsland);
	rmBuildArea(LeftCliff2);*/

	int LeftCliff2A = rmCreateArea("Left Cliff2A");
	rmSetAreaLocation(LeftCliff2A, 0.36, 0.52);
	rmSetAreaSize(LeftCliff2A, 0.0025, 0.0025);
	rmSetAreaWarnFailure(LeftCliff2A, false);
	rmSetAreaCliffType(LeftCliff2A, "SPC Mountain Pass");
	rmSetAreaCliffEdge(LeftCliff2A, 1, 1);
	rmAddAreaInfluenceSegment(LeftCliff2A, 0.36, 0.5, 0.36, 0.55);
	rmSetAreaCliffPainting(LeftCliff2A, false, true, true, 1.5, true);
	rmSetAreaCliffHeight(LeftCliff2A, 8, 0.0, 0.5);
	rmSetAreaHeightBlend(LeftCliff2A, 1);
	rmAddAreaToClass(LeftCliff2A, classCliff);
	rmSetAreaSmoothDistance(LeftCliff2A, 5);
	rmSetAreaCoherence(LeftCliff2A, 0.5);
	rmAddAreaConstraint(LeftCliff2A, stayCenterIsland);
	rmBuildArea(LeftCliff2A);

	int betweenCliffPatch = rmCreateArea("patch between the two cliffs");
	rmSetAreaLocation(betweenCliffPatch, 0.5, 0.69);
	rmAddAreaInfluenceSegment(betweenCliffPatch, 0.36, 0.69, 0.64, 0.69);
	rmSetAreaWarnFailure(betweenCliffPatch, false);
	rmSetAreaSize(betweenCliffPatch, 0.008 * coeff, 0.008 * coeff);
	rmSetAreaCoherence(betweenCliffPatch, 0.85);
	rmSetAreaSmoothDistance(betweenCliffPatch, 1);
	rmAddAreaToClass(betweenCliffPatch, classPatch);
	rmAddAreaConstraint(betweenCliffPatch, avoidCliffsShort);
	// rmSetAreaMix(betweenCliffPatch, "greatlakes_snow");
	rmBuildArea(betweenCliffPatch);

	int inuksukObject = rmCreateObjectDef("inuksuk Object");
	rmAddObjectDefItem(inuksukObject, "inuksuk", 1, 1.0);
	rmSetObjectDefMinDistance(inuksukObject, 0);
	rmSetObjectDefMaxDistance(inuksukObject, 0);
	rmSetObjectDefForceFullRotation(inuksukObject, true);
	rmPlaceObjectDefAtLoc(inuksukObject, 0, 0.5, 0.61);

	// ********* The little Way ***************************
	int middleForest = rmCreateArea("middle forest");
	rmSetAreaLocation(middleForest, 0.5, 0.4);
	rmAddAreaInfluenceSegment(middleForest, 0.55, 0.4, 0.45, 0.4);
	rmSetAreaWarnFailure(middleForest, false);
	rmSetAreaSize(middleForest, 0.011 * coeff, 0.011 * coeff);
	rmSetAreaBaseHeight(middleForest, 8.0);
	rmSetAreaMinBlobDistance(middleForest, 14.0);
	rmSetAreaMaxBlobDistance(middleForest, 30.0);
	rmSetAreaCoherence(middleForest, 0.9);
	rmSetAreaSmoothDistance(middleForest, 5);
	rmSetAreaHeightBlend(middleForest, 2);
	//rmAddAreaToClass(middleForest, classForest);
	rmBuildArea(middleForest);

	int littleGap = rmCreateArea("middle gap");
	rmSetAreaLocation(littleGap, 0.5, 0.4);
	rmAddAreaInfluenceSegment(littleGap, 0.62, 0.4, 0.38, 0.4);
	rmSetAreaWarnFailure(littleGap, false);
	rmSetAreaSize(littleGap, 0.006 * coeff, 0.006 * coeff);
	rmSetAreaMinBlobDistance(littleGap, 14.0);
	rmSetAreaMaxBlobDistance(littleGap, 30.0);
	rmSetAreaCoherence(littleGap, 0.9);
	rmSetAreaSmoothDistance(littleGap, 5);
	rmSetAreaHeightBlend(littleGap, 0);
	rmBuildArea(littleGap);

	int stayInMiddleForest = rmCreateAreaConstraint("stay in middle forest", middleForest);
	int avoidMiddleRoad = rmCreateAreaDistanceConstraint("avoid the little way", littleGap, 5);

	for (j = 0; < rmRandInt(PlayerNum * 25, PlayerNum * 26)) //X marks the spot
	{
		int middleTree = rmCreateObjectDef("middle tree" + j);
		rmAddObjectDefItem(middleTree, "TreePatagoniaSnow", rmRandInt(1, 2), 4.0); // 1,2
		rmSetObjectDefMinDistance(middleTree, 0);
		rmSetObjectDefMaxDistance(middleTree, rmXFractionToMeters(0.5));
		//rmAddObjectDefToClass(middleTree, classForest);
		rmAddObjectDefConstraint(middleTree, stayInMiddleForest);
		rmAddObjectDefConstraint(middleTree, avoidMiddleRoad);
		rmAddObjectDefConstraint(middleTree, avoidImpassableLandShort);
		rmPlaceObjectDefAtLoc(middleTree, 0, 0.50, 0.50);
	}

	rmSetStatusText("", 0.40);

	// --------------------------------------------- Starting Ressources --------------------------

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
	if (TeamNum <= 2)
	{

		if (cNumberNonGaiaPlayers == 2)
		{
			if (rmRandFloat(0, 1) < 0.5)
			{
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.2, 0.28);
				rmPlacePlayersCircular(0.3, 0.3, 0);

				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.8, 0.78);
				rmPlacePlayersCircular(0.3, 0.3, 0);
			}
			else
			{
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.2, 0.28);
				rmPlacePlayersCircular(0.3, 0.3, 0);

				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.8, 0.78);
				rmPlacePlayersCircular(0.3, 0.3, 0);
			}
		}
		else if (PlayerNum <= 4)
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.22, 0.65, 0.3, 0.45, 0.0, 0.0);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.78, 0.65, 0.7, 0.45, 0.0, 0.0);
		}
		else
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.22, 0.68, 0.3, 0.4, 0.0, 0.0);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.78, 0.68, 0.7, 0.4, 0.0, 0.0);
		}
	}
	else
	{
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.315, 0.315, 0.0);
	}

	int avoidEdgeIsland = rmCreateCliffEdgeDistanceConstraint("avoid center island edge", centerIsland, 3);
	for (i = 1; < numPlayer)
	{
		// Create the area.
		int id = rmCreateArea("Player" + i);
		// Assign to the player.
		rmSetPlayerArea(i, id);
		// Set the size.
		rmSetAreaSize(id, 0.04, 0.04);
		rmAddAreaToClass(id, classPlayer);
		rmSetAreaMinBlobs(id, 1);
		rmSetAreaMaxBlobs(id, 1);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaCoherence(id, 0.8);
		rmSetAreaTerrainType(id, "patagonia\ground_snow3_pat");
		rmAddAreaConstraint(id, avoidCliffsShort);
		rmAddAreaConstraint(id, avoidEdgeIsland);
		rmSetAreaWarnFailure(id, false);
		rmBuildArea(id);
	}

	for (i = 1; < numPlayer)
	{
		// Create the area.
		int id1 = rmCreateArea("For players" + i);
		// Assign to the player.
		rmSetPlayerArea(i, id1);
		// Set the size.
		rmSetAreaSize(id1, 0.015, 0.015);
		rmAddAreaToClass(id1, classPlayer);
		rmSetAreaMinBlobs(id1, 10);
		rmSetAreaMaxBlobs(id1, 12);
		rmSetAreaLocPlayer(id1, i);
		rmSetAreaCoherence(id1, 0.3);
		rmSetAreaTerrainType(id1, "patagonia\ground_snow2_pat");
		rmAddAreaConstraint(id1, avoidCliffsShort);
		rmAddAreaConstraint(id1, avoidEdgeIsland);
		rmSetAreaSmoothDistance(id1, 1);
		rmSetAreaWarnFailure(id1, false);
		rmBuildArea(id1);
	}

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);

	int startingTCID = rmCreateObjectDef("startingTC");
	if (rmGetNomadStart())
	{
		rmAddObjectDefItem(startingTCID, "CoveredWagon", 1, 0.0);
	}
	else
	{
		rmAddObjectDefItem(startingTCID, "TownCenter", 1, 0.0);
	}
	rmAddObjectDefToClass(startingTCID, classStartingUnit);
    if(cNumberTeams > 2 || teamZeroCount != teamOneCount)
        rmSetObjectDefMaxDistance(startingTCID, 15.0);
    else
        rmSetObjectDefMaxDistance(startingTCID, 0.0);
	rmAddObjectDefConstraint(startingTCID, avoidTradeRoute);
	rmAddObjectDefConstraint(startingTCID, avoidSocket);
	rmAddObjectDefConstraint(startingTCID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingTCID, avoidCliffsShort);

	int StartCaribou = rmCreateObjectDef("starting caribou");
	rmAddObjectDefItem(StartCaribou, "caribou", rmRandInt(7, 8), 6.0);
	rmSetObjectDefMinDistance(StartCaribou, 8.0);
	rmSetObjectDefMaxDistance(StartCaribou, 10.0);
	rmSetObjectDefCreateHerd(StartCaribou, true);
	rmAddObjectDefConstraint(StartCaribou, avoidImpassableLand);
	rmAddObjectDefConstraint(StartCaribou, avoidStartingUnits);
	rmAddObjectDefConstraint(StartCaribou, avoidSocket);

	int StartMoose = rmCreateObjectDef("starting moose");
	rmAddObjectDefItem(StartMoose, "moose", rmRandInt(7, 8), 9.0);
	rmAddObjectDefToClass(StartMoose, classStartingUnit);
	rmSetObjectDefMinDistance(StartMoose, 27.0);
	rmSetObjectDefMaxDistance(StartMoose, 29.0);
	rmSetObjectDefCreateHerd(StartMoose, true);
	rmAddObjectDefConstraint(StartMoose, avoidImpassableLand);
	rmAddObjectDefConstraint(StartMoose, avoidStartingUnits);
	rmAddObjectDefConstraint(StartMoose, avoidCaribouShort);
	rmAddObjectDefConstraint(StartMoose, avoidSocket);

	int startSilverID = rmCreateObjectDef("first mine");
	rmAddObjectDefItem(startSilverID, "MineTin", 1, 0.0);
	rmAddObjectDefToClass(startSilverID, classStartingUnit);
	rmSetObjectDefMinDistance(startSilverID, 14.0);
	rmSetObjectDefMaxDistance(startSilverID, 14.0);
	rmAddObjectDefConstraint(startSilverID, avoidSocket);
	rmAddObjectDefConstraint(startSilverID, avoidTradeRoute);

	int startSilverID2 = rmCreateObjectDef("first mine2");
	rmAddObjectDefItem(startSilverID2, "MineTin", 1, 0.0);
	rmAddObjectDefToClass(startSilverID2, classStartingUnit);
	rmAddObjectDefConstraint(startSilverID2, avoidCoinStart);
	rmSetObjectDefMinDistance(startSilverID2, 23.0);
	rmSetObjectDefMaxDistance(startSilverID2, 23.0);

	int StartAreaTreeID = rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, "TreeYukon", 2, 4.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 11);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 18);
	rmAddObjectDefToClass(StartAreaTreeID, classStartingUnit);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartingUnits);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidSocket);

	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingUnit);
	rmSetObjectDefMinDistance(playerNuggetID, 23.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetStart);
	rmAddObjectDefConstraint(playerNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(playerNuggetID, avoidSocket);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingUnits);
	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliffsShort);

	for (i = 1; <= PlayerNum)
	{
		rmPlaceObjectDefAtLoc(startingTCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		if (ypIsAsian(i) && rmGetNomadStart() == false)
			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID2, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartCaribou, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartMoose, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmSetNuggetDifficulty(1, 1);
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	rmSetStatusText("", 0.60);

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH())
	{

		int randLoc = rmRandInt(1, 3);
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.0;

		if (randLoc == 2)
		{
			xLoc = 0.5;
			yLoc = 0.5;
		}
        
        if((cNumberNonGaiaPlayers>=5)&&(cNumberTeams>2)){
            xLoc = 0.5;
            yLoc = 0.5;

        }
    /*
    int centerMarker = rmCreateArea("centerMarker");
    rmSetAreaSize(centerMarker, 0.011, 0.011);
    rmSetAreaLocation(centerMarker, xLoc, yLoc);
    //rmSetAreaBaseHeight(centerMarker, 4.0);
    rmSetAreaCoherence(centerMarker, 1.0);
    rmSetAreaTerrainType(centerMarker, "texas\ground4_tex");
    rmBuildArea(centerMarker);
    */
    
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = " + xLoc);
		rmEchoInfo("XLOC = " + yLoc);
	}

	// ----------------------------------------------------- Ressources ------------------------------------------------------------------
	// ************************ Mines *********************************

	int silverID = rmCreateObjectDef("mines with high variation");
	rmAddObjectDefItem(silverID, "MineTin", 1, 0);
	rmSetObjectDefMinDistance(silverID, 0.0);
	rmSetObjectDefMaxDistance(silverID, 12);
	rmAddObjectDefConstraint(silverID, avoidCliffsShort);
	rmAddObjectDefConstraint(silverID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(silverID, avoidSocket);
	rmAddObjectDefConstraint(silverID, avoidTradeRoute);
	rmAddObjectDefConstraint(silverID, avoidKOTH);
	rmAddObjectDefConstraint(silverID, avoidTC);
	rmAddObjectDefConstraint(silverID, avoidStartingUnits);

	float mineVariation = rmRandFloat(0, 1);
	float mineBonus = rmRandFloat(0, 1);

	if (PlayerNum == 2)
	{
		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.11); // sur la jetee au sud

		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.71); // entre les deux falaises

		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.7, 0.25); // sur la partie basse
		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.3, 0.25);
		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5); // entre les deux falaises

		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.37, 0.8); // sur la petite partie gelee
		rmSetObjectDefForceFullRotation(silverID, true);
		rmPlaceObjectDefAtLoc(silverID, 0, 0.63, 0.8);

		if (mineBonus < 0)
		{
			rmSetObjectDefForceFullRotation(silverID, true);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.77, 0.77);
			rmSetObjectDefForceFullRotation(silverID, true);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.23, 0.77);
		}
		else if (mineBonus < 0)
		{
			rmSetObjectDefForceFullRotation(silverID, true);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.67, 0.47);
			rmSetObjectDefForceFullRotation(silverID, true);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.33, 0.47);
		}
		else
		{
			rmSetObjectDefForceFullRotation(silverID, true);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.81, 0.42);
			rmSetObjectDefForceFullRotation(silverID, true);
			rmPlaceObjectDefAtLoc(silverID, 0, 0.19, 0.42);
		}
	}
	else
	{
		for (i = 0; < PlayerNum * 4)
		{
			int silverIDT = rmCreateObjectDef("mines for 1V1" + i);
			rmAddObjectDefItem(silverIDT, "MineTin", 1, 0);
			rmSetObjectDefMinDistance(silverIDT, 0.0);
			rmSetObjectDefMaxDistance(silverIDT, rmZFractionToMeters(0.45));
			rmAddObjectDefConstraint(silverIDT, avoidTradeRoute);
			rmAddObjectDefConstraint(silverIDT, avoidCliffsShort);
			rmAddObjectDefConstraint(silverIDT, avoidTCFar1);
			rmAddObjectDefConstraint(silverIDT, avoidStartingUnits);
			rmAddObjectDefConstraint(silverIDT, avoidSocket);
			rmAddObjectDefConstraint(silverIDT, avoidImpassableLandShort);
			rmAddObjectDefConstraint(silverIDT, avoidCoin);
			rmAddObjectDefConstraint(silverIDT, stayCenterIsland);
			rmSetObjectDefForceFullRotation(silverIDT, true);
			rmPlaceObjectDefAtLoc(silverIDT, 0, 0.5, 0.5);
		}
	}

	// ******************** Forests *****************************

	int avoidMiddleForest = rmCreateAreaDistanceConstraint("avoid the center forest", middleForest, 25);
	int avoidRightPart = rmCreateAreaDistanceConstraint("avoid the right Part", rightPart, 1);
	int avoidRightPart1 = rmCreateAreaDistanceConstraint("avoid the right Part1", avanceeBasGauche, 0);

	for (i = 0; < PlayerNum * 8)
	{
		forestID = rmCreateArea("forest" + i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(70));
		rmSetAreaCoherence(forestID, 0.1);
		rmSetAreaSmoothDistance(forestID, 5);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidTC);
		rmAddAreaConstraint(forestID, forestConstraint);
		rmAddAreaConstraint(forestID, stayCenterIsland);
		rmAddAreaConstraint(forestID, avoidIcePatch);
		rmAddAreaConstraint(forestID, avoidTradeRoute);
		rmAddAreaConstraint(forestID, avoidMiddleForest);
		rmAddAreaConstraint(forestID, avoidRightPart);
		rmAddAreaConstraint(forestID, avoidImpassableLandShort);
		rmAddAreaConstraint(forestID, avoidCoinShort);
		rmAddAreaConstraint(forestID, avoidKOTH);
		rmAddObjectDefConstraint(forestID, avoidStartingUnits);
		rmBuildArea(forestID);

		int stayInNorthForest = rmCreateAreaMaxDistanceConstraint("stay in north forest" + i, forestID, 0);

		for (j = 0; < rmRandInt(6, 7))
		{
			int northtreeID = rmCreateObjectDef("forest tree" + i + j);
			rmAddObjectDefItem(northtreeID, "TreePatagoniaSnow", rmRandInt(1, 2), 1.0); // cluster distance 9.0
			rmSetObjectDefMinDistance(northtreeID, 0);
			rmSetObjectDefMaxDistance(northtreeID, rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(northtreeID, classForest);
			rmAddObjectDefConstraint(northtreeID, stayInNorthForest);
			rmAddObjectDefConstraint(northtreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(northtreeID, avoidKOTH);
			rmPlaceObjectDefAtLoc(northtreeID, 0, 0.40, 0.40);
		}
	}

	int forestTop = rmCreateObjectDef("forestTop");
	rmAddObjectDefItem(forestTop, "TreeYukon", rmRandInt(5, 6), 15); // 1,2
	rmSetObjectDefMinDistance(forestTop, 0);
	rmSetObjectDefMaxDistance(forestTop, 0);
    rmAddObjectDefConstraint(forestTop, avoidKOTH);
	rmPlaceObjectDefAtLoc(forestTop, 0, 0.50, 0.85);

	// **************************** Hunts*******************************
	int CaribouID = rmCreateObjectDef("cariou herd");
	rmAddObjectDefItem(CaribouID, "caribou", rmRandInt(9, 9), 5.0);
	rmSetObjectDefMinDistance(CaribouID, 0.0);
	if (PlayerNum == 2)
		rmSetObjectDefMaxDistance(CaribouID, rmXFractionToMeters(0.02));
	else
		rmSetObjectDefMaxDistance(CaribouID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(CaribouID, avoidAll);
	rmAddObjectDefConstraint(CaribouID, avoidCoinShort);
	rmAddObjectDefConstraint(CaribouID, avoidSocket);
	rmAddObjectDefConstraint(CaribouID, avoidCliffs);
	rmAddObjectDefConstraint(CaribouID, avoidKOTH);
	//	rmAddObjectDefConstraint(CaribouID, PromontoirHunts);
	rmAddObjectDefConstraint(CaribouID, stayCenterIsland);
	rmSetObjectDefCreateHerd(CaribouID, true);
	if (PlayerNum > 2)
	{
		rmAddObjectDefConstraint(CaribouID, avoidCaribou);
		rmAddObjectDefConstraint(CaribouID, avoidMuskOx);
		rmAddObjectDefConstraint(CaribouID, avoidMoose);
		rmAddObjectDefConstraint(CaribouID, avoidTCFar);
		rmPlaceObjectDefAtLoc(CaribouID, 0, 0.5, 0.5, PlayerNum * 3);
	}

	int MuskOXID = rmCreateObjectDef("musk Ox herd");
	rmAddObjectDefItem(MuskOXID, "muskOx", rmRandInt(9, 9), 5.0);
	rmSetObjectDefMinDistance(MuskOXID, 0.0);
	if (PlayerNum == 2)
		rmSetObjectDefMaxDistance(MuskOXID, rmXFractionToMeters(0.02));
	else
		rmSetObjectDefMaxDistance(MuskOXID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(MuskOXID, avoidAll);
	rmAddObjectDefConstraint(MuskOXID, avoidCoinShort);
	rmAddObjectDefConstraint(MuskOXID, avoidSocket);
	rmAddObjectDefConstraint(MuskOXID, avoidKOTH);
	//rmAddObjectDefConstraint(MuskOXID, PromontoirHunts);
	rmAddObjectDefConstraint(MuskOXID, avoidCliffs);
	rmAddObjectDefConstraint(MuskOXID, stayCenterIsland);
	rmSetObjectDefCreateHerd(MuskOXID, true);
	if (PlayerNum > 2)
	{
		rmAddObjectDefConstraint(MuskOXID, avoidCaribou);
		rmAddObjectDefConstraint(MuskOXID, avoidMoose);
		rmAddObjectDefConstraint(MuskOXID, avoidMuskOx);
		rmAddObjectDefConstraint(MuskOXID, avoidTCFar);
		rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.5, 0.5, PlayerNum * 2);
	}

	// 1v1 hunts
	if (PlayerNum == 2)
	{
		if (rmRandFloat(0,1) <= 0.50)
		{
			if (rmRandFloat(0,1) <= 0.50)
			{
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.25, 0.80);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.75, 0.80);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.50, 0.80);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.50, 0.60);
			}
			else
			{
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.25, 0.80);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.75, 0.80);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.50, 0.80);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.50, 0.60);
			}
			if (rmRandFloat(0,1) <= 0.333)
			{
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.65, 0.25);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.35, 0.25);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.80, 0.40);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.20, 0.40);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.40, 0.40);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.60, 0.40);
			}
			else if (rmRandFloat(0,1) <= 0.50)
			{
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.40, 0.40);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.60, 0.40);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.65, 0.25);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.35, 0.25);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.80, 0.40);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.20, 0.40);
			}
			else
			{
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.40, 0.40);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.60, 0.40);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.80, 0.40);
				rmPlaceObjectDefAtLoc(CaribouID, 0, 0.20, 0.40);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.65, 0.25);
				rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.35, 0.25);
			}
		}
		else
		{
			rmPlaceObjectDefAtLoc(CaribouID, 0, 0.80, 0.70);
			rmPlaceObjectDefAtLoc(CaribouID, 0, 0.20, 0.75);
			rmPlaceObjectDefAtLoc(CaribouID, 0, 0.70, 0.40);
			rmPlaceObjectDefAtLoc(CaribouID, 0, 0.30, 0.40);
			rmPlaceObjectDefAtLoc(CaribouID, 0, 0.40, 0.60);
			rmPlaceObjectDefAtLoc(CaribouID, 0, 0.60, 0.60);
			rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.50, 0.40);
			rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.40, 0.20);
			rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.60, 0.20);
			rmPlaceObjectDefAtLoc(MuskOXID, 0, 0.50, 0.85);
		}
	}

	rmSetStatusText("", 0.90);
	// ------------------------------------ Nuggets ------------------------------------
	int nuggetID1 = rmCreateObjectDef("nugget1");
	rmAddObjectDefItem(nuggetID1, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID1, 0.0);
	rmSetObjectDefMaxDistance(nuggetID1, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(nuggetID1, avoidImpassableLandShort);
	rmAddObjectDefConstraint(nuggetID1, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID1, avoidSocket);
	rmAddObjectDefConstraint(nuggetID1, avoidTCFar);
	rmAddObjectDefConstraint(nuggetID1, avoidCliffs);
	rmAddObjectDefConstraint(nuggetID1, stayCenterIsland);
	rmAddObjectDefConstraint(nuggetID1, avoidCoinShort);
	rmAddObjectDefConstraint(nuggetID1, avoidAll);
	rmAddObjectDefConstraint(nuggetID1, avoidNugget);
	rmAddObjectDefConstraint(nuggetID1, avoidKOTH);
	rmSetNuggetDifficulty(2, 2);
	rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, PlayerNum * 2);
	rmSetNuggetDifficulty(1, 1);
	rmPlaceObjectDefAtLoc(nuggetID1, 0, 0.5, 0.5, PlayerNum * 2);

	rmSetStatusText("", 1.00);

	//END
}
