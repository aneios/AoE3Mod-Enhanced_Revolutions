// Yamal
// ported to DE by vividlyplain, March 2022
// formerly . . .
/*
==============================
	    Red River
        by dansil92
==============================
*/
// special thanks to Enki for player placement function and the op colour converter

int TeamNum = cNumberTeams;
int PlayerNum = cNumberNonGaiaPlayers;
int numPlayer = cNumberPlayers;

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Enki's big brain function
void placeMainLand(int team = 0, int guy = 0, int placePlayers = 0)
{
    vector teamonespawnone = vector(0.50, 0.0, 0.85);
    vector teamonespawntwo = vector(0.20, 0.0, 0.75);
    vector teamonespawnthree = vector(0.90, 0.0, 0.55);

    vector teamtwospawnone = vector(0.50, 0.0, 0.15);
    vector teamtwospawntwo = vector(0.80, 0.0, 0.25);
    vector teamtwospawnthree = vector(0.10, 0.0, 0.45);

    vector placementLoc = vector(0.00, 0.00, 0.00);

    if (team == 0) 
    {
        if (placePlayers == 2) 
            placementLoc = teamonespawnone;
        if (placePlayers == 3) 
            placementLoc = teamonespawntwo;
        if (placePlayers == 4) 
            placementLoc = teamonespawnthree;
    }
    if (team == 1) 
    {
        if (placePlayers == 2) 
            placementLoc = teamtwospawnone;
        if (placePlayers == 3) 
            placementLoc = teamtwospawntwo;
        if (placePlayers == 4) 
            placementLoc = teamtwospawnthree;
    }
    rmPlacePlayer(guy, xsVectorGetX(placementLoc), xsVectorGetZ(placementLoc));
}

// Main entry point for random map script
void main(void) 
{
    int teamZeroCount = rmGetNumberPlayersOnTeam(0);
    int teamOneCount = rmGetNumberPlayersOnTeam(1);

	// Player Coordinates
	float xp1t1 = 0.00;
	float zp1t1 = 0.00;
	float xp2t1 = 0.00;
	float zp2t1 = 0.00;
	float xp3t1 = 0.00;
	float zp3t1 = 0.00;
	float xp4t1 = 0.00;
	float zp4t1 = 0.00;
	float xp1t2 = 0.00;
	float zp1t2 = 0.00;
	float xp2t2 = 0.00;
	float zp2t2 = 0.00;
	float xp3t2 = 0.00;
	float zp3t2 = 0.00;
	float xp4t2 = 0.00;
	float zp4t2 = 0.00;

    if (PlayerNum == 2) 
    {
        xp1t1 = 0.60;
        zp1t1 = 0.80;
        xp1t2 = 0.40;
        zp1t2 = 0.20;
    } 
    else 
    {
		xp1t1 = 0.70;
		zp1t1 = 0.75;
		xp2t1 = 0.50;
		zp2t1 = 0.85;
		xp3t1 = 0.20;
		zp3t1 = 0.75;
		xp4t1 = 0.90;
		zp4t1 = 0.55;
		xp1t2 = 0.30;
		zp1t2 = 0.25;
		xp2t2 = 0.50;
		zp2t2 = 0.15;
		xp3t2 = 0.80;
		zp3t2 = 0.25;
		xp4t2 = 0.10;
		zp4t2 = 0.45;
	}

	// Strings
	string toiletPaper = "water";
	string wetType = "Rockies Lake Ice";
	string mntType = "Italian Cliff";
	string initLand = "grass";
	string paintMix1 = "italy_snow";
	string paintMix2 = "italy_snow_dirt";
	string paintMix3 = "italy_snow_dirt";
	string paintMix4 = "italy_snow_cliff";
	string forestMix = "italy_snow_forest";
	string forTesting = "testmix";
	string treasureSet = "siberia";
    string shineAlight = "";
    if (rmRandFloat(0,1) <= 0.50)
		shineAlight = "yukon_skirmish";
    else if (rmRandFloat(0,1) <= 0.50)
		shineAlight = "rockie_skirmish";
    else if (rmRandFloat(0,1) <= 0.50)
		shineAlight = "siberia_skirmish";
    else if (rmRandFloat(0,1) <= 0.50)
		shineAlight = "ArcticTerritories_skirmish";
    else if (rmRandFloat(0,1) <= 0.50)
		shineAlight = "GreatLakes_Winter_skirmish";
    else
		shineAlight = "mongolia_skirmish";
	string food1 = "ypMuskDeer";
	string food2 = "ypSaiga";
	string cattleType = "ypGoat";
	string treeType1 = "TreeYukonSnow";
	string treeType2 = "TreeGreatLakesSnow";
	string treeType3 = "ypTreeHimalayas";

	// placeholders for tengri
	string natType1 = "Tengri";
	string natGrpName1 = "native tengri village 0";	

	rmSetStatusText("",0.01);
	
	// Picks the map size
	int playerTiles=12000;
	if (cNumberNonGaiaPlayers > 3)
		playerTiles = 10000;
	else if (cNumberNonGaiaPlayers > 6)
		playerTiles = 9500;
		
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmSetMapSize(size, size);

	rmSetSeaType(wetType);
	rmSetSeaLevel(-3.0);
    rmSetMapType(treasureSet);
    rmTerrainInitialize("grass", -3.0);
	rmSetLightingSet(shineAlight);

	chooseMercs();

    rmDefineClass("classForest");
	rmDefineClass("classPlateau");
	int socketClass = rmDefineClass("socketClass");
	int classPatch = rmDefineClass("patch");
	int classCenter = rmDefineClass("center");
    int classStartingResource = rmDefineClass("startingResource");
	
	//Constraints
    int avoidStartingResources = rmCreateClassDistanceConstraint("avoid starting resources", rmClassID("startingResource"), 8.0);
    int avoidStartingResourcesShort = rmCreateClassDistanceConstraint("avoid starting resources short", rmClassID("startingResource"), 4.0);
    int avoidStartingResourcesMin = rmCreateClassDistanceConstraint("avoid starting resources min", rmClassID("startingResource"), 2.0);

	int avoidPatch = rmCreateClassDistanceConstraint("avoid patch", rmClassID("patch"), 22.0);

	int avoidPlateau=rmCreateClassDistanceConstraint("stuff vs. cliffs", rmClassID("classPlateau"), 6.0);

    int circleConstraint= rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.45), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int avoidCenter = rmCreateClassDistanceConstraint("avoid center", rmClassID("center"), 6.0);

	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 20.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 8.0);
    int forestConstraintMin=rmCreateClassDistanceConstraint("object vs. forest min", rmClassID("classForest"), 4.0);
        
	int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
	int avoidHunt2=rmCreateTypeDistanceConstraint("hunts avoid hunts2", "huntable", 20.0);
	int waterHunt = rmCreateTerrainMaxDistanceConstraint("hunts stay near the water", "land", false, 3.0);
	
    int avoidHerd=rmCreateTypeDistanceConstraint("herds avoid herds", "herdable", 87.0);

	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "mineTin", 8.0);
    int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "mineTin", 50.0);
	
    int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short 2", "Land", false, 6.0);
    int cliffWater = rmCreateTerrainDistanceConstraint("cliff avoids river", "Land", false, 0.01);
    int cliffWater2 = rmCreateTerrainDistanceConstraint("cliff avoids river 2", "Land", false, 1.5);
    int cliffWater3 = rmCreateTerrainDistanceConstraint("cliff avoids river 3", "Land", false, 2.5);

    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 6.0);
    int avoidSocket=rmCreateClassDistanceConstraint("socket avoidance", rmClassID("socketClass"), 12.0);
    int avoidSocketSmall=rmCreateClassDistanceConstraint("socket avoidance small", rmClassID("socketClass"), 6.0);
    int avoidTradeRouteSocketMin = rmCreateTypeDistanceConstraint("trade route socket min", "socketTradeRoute", 4.0);
    int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("trade route socket short", "socketTradeRoute", 8.0);
    int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route socket", "socketTradeRoute", 12.0);
    int avoidTradeRouteSocketFar = rmCreateTypeDistanceConstraint("avoid trade route socket far", "socketTradeRoute", 20.0);
        
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 26.0);
    int avoidTownCenterSmall=rmCreateTypeDistanceConstraint("avoid Town Center small", "townCenter", 10.0);
    int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 35.0);  
       
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 60.0);
	int avoidNuggetShort=rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 8.0);

	int stayWest = rmCreatePieConstraint("Stay West",0.47,0.53, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(225),rmDegreesToRadians(45));
	int stayEast = rmCreatePieConstraint("Stay East",0.53,0.47, rmXFractionToMeters(0.2),rmXFractionToMeters(0.5), rmDegreesToRadians(45),rmDegreesToRadians(225));

	// =============Player placement ======================= 
    if (cNumberTeams <= 2 && teamZeroCount == teamOneCount) // 1v1 and even teams
    {
        float spawnSwitch = rmRandFloat(0,1);
        if (teamZeroCount == 1 && teamOneCount == 1) // 1v1
        {
            if (spawnSwitch <= 0.5) 
            {
                rmPlacePlayer(1, xp1t1, zp1t1);
                rmPlacePlayer(2, xp1t2, zp1t2);
            } 
            else 
            {
                rmPlacePlayer(2, xp1t1, zp1t1);
                rmPlacePlayer(1, xp1t2, zp1t2);
            }
        }
        else if (teamZeroCount == 2 && teamOneCount == 2) // 2v2
        {
            if (spawnSwitch <= 0.5)
            {
                rmSetPlacementTeam(0);
                rmPlacePlayersLine(0.60, 0.80, 0.20, 0.75, 0.00, 0.20);

                rmSetPlacementTeam(1);
                rmPlacePlayersLine(0.40, 0.20, 0.80, 0.25, 0.00, 0.20);
            }
            else
            {
                rmSetPlacementTeam(0);
                rmPlacePlayersLine(0.40, 0.20, 0.80, 0.25, 0.00, 0.20);

                rmSetPlacementTeam(1);
                rmPlacePlayersLine(0.60, 0.80, 0.20, 0.75, 0.00, 0.20);
            }
        }
        else 
        {
            int teamcountOne = 0;
            int teamcountTwo = 0;

            for (player = 1; <= PlayerNum) 
            {
                if (rmGetPlayerTeam(player) == 0) 
                {
                    // is on team 1
                    teamcountOne++;
                    if (teamcountOne == 1) 
                    {
                        rmPlacePlayer(player, xp1t1, zp1t1); //place first player first team
                    } 
                    else 
                    {
                        placeMainLand(0, player, teamcountOne); // place team 1 remaining
                    }
                }
                if (rmGetPlayerTeam(player) == 1) 
                {
                    // is on team 2
                    teamcountTwo++;

                    if (teamcountTwo == 1) 
                    {
                        rmPlacePlayer(player, xp1t2, zp1t2); //place first player second team
                    } 
                    else 
                    {
                        placeMainLand(1, player, teamcountTwo); // place team 2 remaining
                    }
                }
            }
        }
    }	
	else if (TeamNum == 2)		// weird teams
	{
		rmSetPlacementTeam(0);
		if (teamZeroCount == 1)
			rmSetPlacementSection(0.00, 0.01); 
		else
			rmSetPlacementSection(0.966, 0.08); 
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.40, 0.40, 0.0);

		rmSetPlacementTeam(1);
		if (teamOneCount == 1)
			rmSetPlacementSection(0.50, 0.51); 
		else
			rmSetPlacementSection(0.466, 0.58); 
		rmSetTeamSpacingModifier(0.25);
		rmPlacePlayersCircular(0.40, 0.40, 0.0);		
	}
	else //ffa placement***********
	{
		rmPlacePlayer(1, 0.55, 0.85);
		rmPlacePlayer(2, 0.45, 0.15);
		rmPlacePlayer(3, 0.16, 0.72);
		rmPlacePlayer(4, 0.84, 0.28);
		if (PlayerNum == 5)
		{
			if (rmGetIsKOTH() == false)
				rmPlacePlayer(5, 0.5, 0.5);
			else
				rmPlacePlayer(5, 0.50, 0.35);
		}
		if (PlayerNum == 6)
		{
			rmPlacePlayer(5, 0.58, 0.6);
			rmPlacePlayer(6, 0.42, 0.4);
		}
		if (PlayerNum == 7)
		{
			if (rmGetIsKOTH() == false)
				rmPlacePlayer(5, 0.5, 0.5);
			else
				rmPlacePlayer(5, 0.50, 0.35);
			rmPlacePlayer(6, 0.11, 0.43);
			rmPlacePlayer(7, 0.89, 0.57);
		}
		if (PlayerNum == 8)
		{
			rmPlacePlayer(5, 0.58, 0.6);
			rmPlacePlayer(6, 0.42, 0.4);
			rmPlacePlayer(7, 0.11, 0.43);
			rmPlacePlayer(8, 0.89, 0.57);
		}
	}

    rmSetStatusText("",0.1); 

	// Continent
    int continent2 = rmCreateArea("continent2");
    rmSetAreaSize(continent2, 1.0);
    rmSetAreaLocation(continent2, 0.5, 0.5);
	rmSetAreaMix(continent2, paintMix2);
//    rmSetAreaBaseHeight(continent2, -2.0);
    rmSetAreaCoherence(continent2, 1.0);
    //rmSetAreaSmoothDistance(continent2, 3);
	//rmSetAreaEdgeFilling(continent2, 2.0);
    //rmSetAreaHeightBlend(continent2, 1);
    rmSetAreaElevationNoiseBias(continent2, 0);
    rmSetAreaElevationEdgeFalloffDist(continent2, 10);
    rmSetAreaElevationVariation(continent2, 6);
    rmSetAreaElevationPersistence(continent2, .2);
    rmSetAreaElevationOctaves(continent2, 5);
    rmSetAreaElevationMinFrequency(continent2, 0.04);
    rmSetAreaElevationType(continent2, cElevTurbulence);  
    rmBuildArea(continent2);    

	rmSetStatusText("",0.2);

	//===========trade route=================
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
    rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID, true);
    rmSetObjectDefMinDistance(socketID, 0.0);
    rmSetObjectDefMaxDistance(socketID, 0.0);      
       
    int tradeRouteID = rmCreateTradeRoute();
    rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.20);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.95, 0.40);
    rmBuildTradeRoute(tradeRouteID, toiletPaper);

	int socketID2=rmCreateObjectDef("sockets to dock Trade Posts2");
    rmAddObjectDefItem(socketID2, "SocketTradeRoute", 1, 0.0);
    rmSetObjectDefAllowOverlap(socketID2, true);
    rmSetObjectDefMinDistance(socketID2, 0.0);
    rmSetObjectDefMaxDistance(socketID2, 0.0);      
       
    int tradeRouteID2 = rmCreateTradeRoute();
    rmSetObjectDefTradeRouteID(socketID2, tradeRouteID2);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.05, 0.80);
	rmAddTradeRouteWaypoint(tradeRouteID2, 0.05, 0.60);
    rmBuildTradeRoute(tradeRouteID2, toiletPaper);
		
	//===================River=====================
	int riverID = rmRiverCreate(-5, wetType, 8, 8, 4+numPlayer, 4+numPlayer); 
	rmRiverSetBankNoiseParams(riverID, 0.07, 1, 0.5, 6.0, 0.667, 1.0);
	rmRiverAddWaypoint(riverID, 0.75, 1.00);
	rmRiverAddWaypoint(riverID, 0.80, 0.90);
	rmRiverAddWaypoint(riverID, 0.85, 0.80);
	rmRiverAddWaypoint(riverID, 0.80, 0.70);
	rmRiverAddWaypoint(riverID, 0.75, 0.60);
	rmRiverAddWaypoint(riverID, 0.70, 0.50);
	rmRiverAddWaypoint(riverID, 0.65, 0.40);
	rmRiverAddWaypoint(riverID, 0.60, 0.30);
	rmRiverAddWaypoint(riverID, 0.65, 0.20);
	rmRiverAddWaypoint(riverID, 0.70, 0.10);
	rmRiverAddWaypoint(riverID, 0.75, 0.00);
	rmRiverSetShallowRadius(riverID, size);
	//rmRiverAddShallow(riverID, 0.2);
	rmRiverBuild(riverID);
	//rmRiverReveal(riverID, 2);

	// second river
	int riverID2 = rmRiverCreate(-5, wetType, 8, 8, 4+numPlayer, 4+numPlayer); 
	rmRiverSetBankNoiseParams(riverID2, 0.07, 1, 0.5, 6.0, 0.667, 1.0);
	rmRiverAddWaypoint(riverID2, 0.25, 1.00);
	rmRiverAddWaypoint(riverID2, 0.30, 0.90);
	rmRiverAddWaypoint(riverID2, 0.35, 0.80);
	rmRiverAddWaypoint(riverID2, 0.40, 0.70);
	rmRiverAddWaypoint(riverID2, 0.35, 0.60);
	rmRiverAddWaypoint(riverID2, 0.30, 0.50);
	rmRiverAddWaypoint(riverID2, 0.25, 0.40);
	rmRiverAddWaypoint(riverID2, 0.20, 0.30);
	rmRiverAddWaypoint(riverID2, 0.15, 0.20);
	rmRiverAddWaypoint(riverID2, 0.20, 0.10);
	rmRiverAddWaypoint(riverID2, 0.25, 0.00);
	rmRiverSetShallowRadius(riverID2, size);
	//rmRiverAddShallow(riverID2, 0.2);
	rmRiverBuild(riverID2);
	//====================================================

	//===========trade sockets=================
    vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
    rmPlaceObjectDefAtLoc(socketID, 0, 0.90, 0.30);

	vector socketLoc2 = rmGetTradeRouteWayPoint(tradeRouteID2, 0.50);
    rmPlaceObjectDefAtLoc(socketID2, 0, 0.10, 0.70);

  	rmSetStatusText("",0.3);

	// Areas for water flags
	int flagPond1=rmCreateArea("nw flag");
    rmSetAreaLocation(flagPond1, 0.35, 0.80);
    rmSetAreaSize(flagPond1, 0.002);      
    rmSetAreaCoherence(flagPond1, 0.92);
    rmBuildArea(flagPond1);

	int flagPond2=rmCreateArea("se flag");
    rmSetAreaLocation(flagPond2, 0.65, 0.20);
    rmSetAreaSize(flagPond2, 0.002);      
    rmSetAreaCoherence(flagPond2, 0.92);
    rmBuildArea(flagPond2);

	// Make the "mountain" range
    int ridgeID = rmCreateArea("ridge");
    rmSetAreaSize(ridgeID, 0.30);
    rmSetAreaLocation(ridgeID, 0.5, 0.5);
	rmSetAreaMix(ridgeID, paintMix4);
    rmSetAreaBaseHeight(ridgeID, 8.0);
    rmSetAreaCoherence(ridgeID, 1.0);
    rmSetAreaSmoothDistance(ridgeID, 8);
	//rmSetAreaEdgeFilling(ridgeID, 2.0);
    rmSetAreaHeightBlend(ridgeID, 6);
    rmSetAreaElevationNoiseBias(ridgeID, 0);
    rmSetAreaElevationEdgeFalloffDist(ridgeID, 10);
    rmSetAreaElevationVariation(ridgeID, 6);
    rmSetAreaElevationPersistence(ridgeID, .2);
    rmSetAreaElevationOctaves(ridgeID, 5);
    rmSetAreaElevationMinFrequency(ridgeID, 0.04);
    rmSetAreaElevationType(ridgeID, cElevTurbulence);  
    rmAddAreaConstraint(ridgeID, avoidCenter);  
    rmAddAreaConstraint(ridgeID, avoidWaterShort);  
    rmBuildArea(ridgeID);    

	//=========================================================

	// Natives
	// Set up Natives
	int subCiv0 = -1;
	subCiv0 = rmGetCivID(natType1);
	rmSetSubCiv(0, natType1);

	float xNatLocA = 0.50;
	float yNatLocA = 0.50;
	if (TeamNum > 2 && PlayerNum == 5)
	{
		xNatLocA = 0.55;
		yNatLocA = 0.50;
	}
	if (TeamNum > 2 && PlayerNum == 7)
	{
		xNatLocA = 0.57;
		yNatLocA = 0.50;
	}
	float xNatLocB = 0.10;
	float yNatLocB = 0.40;
	float xNatLocC = 0.90;
	float yNatLocC = 0.60;
	if (TeamNum > 2 && PlayerNum >= 6)
	{
		xNatLocB = 0.05;
		yNatLocB = 0.55;
		xNatLocC = 0.95;
		yNatLocC = 0.45;
	}

	// Place Natives
	int nativeID0 = -1;
	int nativeID1 = -1;
	int nativeID2 = -1;

	nativeID0 = rmCreateGrouping("native A", natGrpName1+rmRandInt(1,5));
	nativeID1 = rmCreateGrouping("native B", natGrpName1+1);
	nativeID2 = rmCreateGrouping("native C", natGrpName1+1);

	rmAddGroupingToClass(nativeID0, socketClass);
	rmAddGroupingToClass(nativeID1, socketClass);
	rmAddGroupingToClass(nativeID2, socketClass);

//	if (rmGetIsKOTH() == false)
//		rmPlaceGroupingAtLoc(nativeID0, 0, xNatLocA, yNatLocA);
	rmPlaceGroupingAtLoc(nativeID1, 0, xNatLocB, yNatLocB);
	rmPlaceGroupingAtLoc(nativeID2, 0, xNatLocC, yNatLocC);

	// Build east and west islands
	int westIsland=rmCreateArea("west Island");
    rmSetAreaLocation(westIsland, 0.1, 0.5);
    rmSetAreaSize(westIsland, .4, .4);      
    rmSetAreaCoherence(westIsland, .99);
	rmAddAreaConstraint(westIsland, avoidWaterShort);
	rmAddAreaToClass(westIsland, rmClassID("center"));
    rmBuildArea(westIsland);

	int eastIsland=rmCreateArea("east Island");
    rmSetAreaLocation(eastIsland, 0.9, 0.5);
    rmSetAreaSize(eastIsland, .4, .4);      
    rmSetAreaCoherence(eastIsland, .99);
	rmAddAreaConstraint(eastIsland, avoidWaterShort);
	rmAddAreaToClass(eastIsland, rmClassID("center"));
    rmBuildArea(eastIsland);

	// Place King's Hill
	float xLoc = 0.5;
	float yLoc = 0.5;
	float walk = 0.0;

	if (rmGetIsKOTH() == true)
	{
		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// Static mines
	if (PlayerNum == 2)
	{
		int smollMines = rmCreateObjectDef("competitive gold");
		rmAddObjectDefItem(smollMines, "mineTin", 1, 0.0);
		rmSetObjectDefMinDistance(smollMines, 0.0);
		rmSetObjectDefMaxDistance(smollMines, 0.0);
		
		//back mines
		rmPlaceObjectDefAtLoc(smollMines, 0, 0.55, 0.1, 1);
		rmPlaceObjectDefAtLoc(smollMines, 0, 0.45, 0.9, 1);
		
		//centre bushes
		rmPlaceObjectDefAtLoc(smollMines, 0, 0.5, 0.3, 1);
		rmPlaceObjectDefAtLoc(smollMines, 0, 0.5, 0.7, 1);
	
		rmPlaceObjectDefAtLoc(smollMines, 0, 0.35, 0.4, 1);
		rmPlaceObjectDefAtLoc(smollMines, 0, 0.65, 0.6, 1);
	
		rmAddObjectDefConstraint(smollMines, avoidCoinMed);
		rmAddObjectDefConstraint(smollMines, avoidTradeRouteSmall);
		rmAddObjectDefConstraint(smollMines, circleConstraint);	
		rmAddObjectDefConstraint(smollMines, avoidWaterShort);
	
		rmPlaceObjectDefInArea(smollMines, 0, westIsland, 3);
		rmPlaceObjectDefInArea(smollMines, 0, eastIsland, 3);
	
		//starting coin
		//	rmPlaceObjectDefAtLoc(smollMines, 0, 0.42, 0.79, 1);
		//	rmPlaceObjectDefAtLoc(smollMines, 0, 0.79, 0.42, 1);
		//south mine
		//	rmPlaceObjectDefAtLoc(smollMines, 0, 0.3, 0.65, 1);
		//	rmPlaceObjectDefAtLoc(smollMines, 0, 0.65, 0.3, 1);
	}

	rmSetStatusText("",0.4);
	
	// starting objects
	int flagLand = rmCreateTerrainDistanceConstraint("flags dont like land", "land", true, 3.0);

    int playerStart = rmCreateStartingUnitsObjectDef(5.0);
    rmSetObjectDefMinDistance(playerStart, 7.0);
    rmSetObjectDefMaxDistance(playerStart, 12.0);
	rmAddObjectDefToClass(playerStart, classStartingResource); 
	rmAddObjectDefConstraint(playerStart, avoidWaterShort);

    int goldID = rmCreateObjectDef("starting gold");
    rmAddObjectDefItem(goldID, "mineTin", 1, 1.0);
    rmSetObjectDefMinDistance(goldID, 14.0);
    rmSetObjectDefMaxDistance(goldID, 14.0);
	rmAddObjectDefToClass(goldID, classStartingResource); 

    int berryID = rmCreateObjectDef("starting berries");
    rmAddObjectDefItem(berryID, "berrybush", 3, 4.0);
    rmSetObjectDefMinDistance(berryID, 18.0);
    rmSetObjectDefMaxDistance(berryID, 18.0);
	rmAddObjectDefToClass(berryID, classStartingResource); 
    rmAddObjectDefConstraint(berryID, avoidCoin);
    rmAddObjectDefConstraint(berryID, avoidStartingResourcesShort);
 
    int treeID = rmCreateObjectDef("starting trees");
    rmAddObjectDefItem(treeID, treeType1, 1, 2.0);
    rmAddObjectDefItem(treeID, treeType2, 1, 2.0);
    rmAddObjectDefItem(treeID, treeType3, 1, 2.0);
    rmSetObjectDefMinDistance(treeID, 16.0);
    rmSetObjectDefMaxDistance(treeID, 20.0);
    rmAddObjectDefConstraint(treeID, avoidTownCenterSmall);
	rmAddObjectDefToClass(treeID, classStartingResource); 
	rmAddObjectDefToClass(treeID, rmClassID("classForest")); 
    rmAddObjectDefConstraint(treeID, avoidStartingResourcesShort);
    rmAddObjectDefConstraint(treeID, avoidCoin);

    int foodID = rmCreateObjectDef("starting hunt");
    rmAddObjectDefItem(foodID, food1, 8, 5.0);
    rmSetObjectDefMinDistance(foodID, 11.0);
    rmSetObjectDefMaxDistance(foodID, 13.0);
	rmAddObjectDefToClass(foodID, classStartingResource); 
	rmAddObjectDefConstraint(foodID, avoidWaterShort);	
    rmSetObjectDefCreateHerd(foodID, true);
    //rmAddObjectDefConstraint(foodID, avoidCoin);
 
    int foodID2 = rmCreateObjectDef("starting herdable");
    rmAddObjectDefItem(foodID2, "Sheep", 1, 3.0);
    rmSetObjectDefMinDistance(foodID2, 0.0);
    rmSetObjectDefMaxDistance(foodID2, 3.0);
	rmAddObjectDefToClass(foodID2, classStartingResource); 
	rmAddObjectDefConstraint(foodID2, avoidStartingResourcesShort);	
	rmAddObjectDefConstraint(foodID2, avoidWaterShort);	
                       
	int foodID3 = rmCreateObjectDef("starting hunt 2");
    rmAddObjectDefItem(foodID3, food2, 8, 3.0);
    rmSetObjectDefMinDistance(foodID3, 26.0);
    rmSetObjectDefMaxDistance(foodID3, 27.0);
	rmAddObjectDefToClass(foodID3, classStartingResource); 
	rmAddObjectDefConstraint(foodID3, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(foodID3, avoidWaterShort);
    rmSetObjectDefCreateHerd(foodID3, true);

	int playerNuggetID=rmCreateObjectDef("player nugget");
	rmSetNuggetDifficulty(1, 1); 
	rmAddObjectDefItem(playerNuggetID, "nugget", 1, 0.0);
    rmSetObjectDefMinDistance(playerNuggetID, 28.0);
    rmSetObjectDefMaxDistance(playerNuggetID, 28.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource); 
	rmAddObjectDefConstraint(playerNuggetID, avoidWaterShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResourcesShort);
	rmAddObjectDefConstraint(playerNuggetID, circleConstraint);

	rmSetStatusText("",0.5);      
	
	// Place starting stuff, TCs first in own loop
    for(i=1; < cNumberNonGaiaPlayers + 1)
	{
		int id=rmCreateArea("Player"+i);
		rmSetPlayerArea(i, id);
		
		int startID = rmCreateObjectDef("object"+i);
		rmAddObjectDefItem(startID, "TownCenter", 1, 0.0);
		rmSetObjectDefMinDistance(startID, 0.0);
        rmSetObjectDefMaxDistance(startID, 0.0);
		rmPlaceObjectDefAtLoc(startID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		
		// Starting Dock Wagon
        rmAddMapStartingUnit(i, "deDockWagon");	
	}

    for(i=1; < cNumberNonGaiaPlayers + 1)
	{
		// Starting resources
        rmPlaceObjectDefAtLoc(goldID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID2, i, rmPlayerLocXFraction(i)+rmXTilesToFraction(10), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(foodID3, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(berryID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(treeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerStart, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
        rmPlaceObjectDefAtLoc(playerNuggetID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

		// Water flags
		int flag1 = rmFindCloserArea(rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), flagPond2, flagPond1);

		int waterFlag = rmCreateObjectDef("HC water flag "+i);
        rmAddObjectDefItem(waterFlag, "HomeCityWaterSpawnFlag", 1, 2.0);
        rmSetObjectDefMinDistance(waterFlag, 0);
        rmSetObjectDefMaxDistance(waterFlag, 10);
		rmAddObjectDefConstraint(waterFlag, flagLand);
		rmPlaceObjectDefAtAreaLoc(waterFlag, i, flag1, 1);
	}
	
	rmSetStatusText("",0.6);

	/*
	==================
	resource placement
	==================
	*/
	
  	int mineID = rmCreateObjectDef("mines");
	rmAddObjectDefItem(mineID, "mineTin", 1, 1.0);
	rmSetObjectDefMinDistance(mineID, 0.0);
	rmSetObjectDefMaxDistance(mineID, rmXFractionToMeters(0.45));
	if (PlayerNum == 2)
	{
		rmSetObjectDefMaxDistance(mineID, rmXFractionToMeters(0.25));
		rmAddObjectDefConstraint(mineID, avoidCenter);
	}
	rmAddObjectDefConstraint(mineID, avoidCoinMed);
	rmAddObjectDefConstraint(mineID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(mineID, avoidPlateau);	
	rmAddObjectDefConstraint(mineID, avoidWaterShort);
	rmAddObjectDefConstraint(mineID, avoidTownCenterMore);
	rmAddObjectDefConstraint(mineID, avoidSocketSmall);
	rmAddObjectDefConstraint(mineID, circleConstraint);
	rmPlaceObjectDefAtLoc(mineID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers);

    // Forests
    int mainforestcount = 15 + 3 * PlayerNum;
    int stayInForestPatch = -1;

    for (i = 0; < mainforestcount) 
    {
        int forestPatchID = rmCreateArea("main forest patch" + i);
        rmSetAreaWarnFailure(forestPatchID, false);
        rmSetAreaObeyWorldCircleConstraint(forestPatchID, true);
        rmSetAreaSize(forestPatchID, rmAreaTilesToFraction(44));
        rmSetAreaMix(forestPatchID, forestMix);
        rmSetAreaCoherence(forestPatchID, 0.2);
        rmAddAreaConstraint(forestPatchID, avoidStartingResourcesMin);
        rmAddAreaConstraint(forestPatchID, avoidTradeRouteSocket);
        rmAddAreaConstraint(forestPatchID, forestConstraint);
        rmAddAreaConstraint(forestPatchID, avoidCoin);
        rmAddAreaConstraint(forestPatchID, avoidNuggetShort);
        rmAddAreaConstraint(forestPatchID, avoidWaterShort);
        rmAddAreaConstraint(forestPatchID, avoidTownCenter);
        rmAddAreaConstraint(forestPatchID, avoidSocketSmall);
        rmBuildArea(forestPatchID);

        stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch" + i, forestPatchID, 0.0);

        int forestTreeID = rmCreateObjectDef("forest trees" + i);
        rmAddObjectDefItem(forestTreeID, treeType1, 2, 6.0);
        rmAddObjectDefItem(forestTreeID, treeType2, 4, 6.0);
        rmAddObjectDefItem(forestTreeID, treeType3, 2, 6.0);
        rmSetObjectDefMinDistance(forestTreeID, rmXFractionToMeters(0.0));
        rmSetObjectDefMaxDistance(forestTreeID, rmXFractionToMeters(0.5));
        rmAddObjectDefToClass(forestTreeID, rmClassID("classForest"));
        rmAddObjectDefConstraint(forestTreeID, avoidWaterShort);
        rmAddObjectDefConstraint(forestTreeID, stayInForestPatch);
        rmAddObjectDefConstraint(forestTreeID, avoidTradeRouteSocketMin);
        rmAddObjectDefConstraint(forestTreeID, avoidStartingResourcesShort);
        rmPlaceObjectDefAtLoc(forestTreeID, 0, 0.50, 0.50, 2);

        int forestTree2ID = rmCreateObjectDef("second forest trees" + i);
        rmAddObjectDefItem(forestTree2ID, treeType1, 1, 3.0);
        rmAddObjectDefItem(forestTree2ID, treeType2, 1, 3.0);
        rmAddObjectDefItem(forestTree2ID, treeType3, 1, 3.0);
        rmSetObjectDefMinDistance(forestTree2ID, rmXFractionToMeters(0.0));
        rmSetObjectDefMaxDistance(forestTree2ID, rmXFractionToMeters(0.5));
        rmAddObjectDefToClass(forestTree2ID, rmClassID("classForest"));
        rmAddObjectDefConstraint(forestTree2ID, avoidWaterShort);
        rmAddObjectDefConstraint(forestTree2ID, stayInForestPatch);
        rmAddObjectDefConstraint(forestTree2ID, avoidTradeRouteSocketMin);
        rmAddObjectDefConstraint(forestTree2ID, avoidStartingResourcesShort);
        rmPlaceObjectDefAtLoc(forestTree2ID, 0, 0.50, 0.50, 2);
    }

	rmSetStatusText("",0.7);

    int huntID = rmCreateObjectDef("hunts");
	rmAddObjectDefItem(huntID, food1, 7, 3.0);
	rmSetObjectDefCreateHerd(huntID, true);
	rmSetObjectDefMinDistance(huntID, 0);
	rmSetObjectDefMaxDistance(huntID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(huntID, circleConstraint);
	rmAddObjectDefConstraint(huntID, avoidHunt);
	rmAddObjectDefConstraint(huntID, avoidWaterShort);
	rmAddObjectDefConstraint(huntID, avoidPlateau);
	rmAddObjectDefConstraint(huntID, avoidSocketSmall);	
	rmAddObjectDefConstraint(huntID, avoidCoin);	
	rmPlaceObjectDefAtLoc(huntID, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);

  	int waterBuffaloSpam = rmCreateObjectDef("buffalo bois");
	rmAddObjectDefItem(waterBuffaloSpam, cattleType, 1, 0.0);
	rmSetObjectDefMinDistance(waterBuffaloSpam, 0.0);
	rmSetObjectDefMaxDistance(waterBuffaloSpam, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(waterBuffaloSpam, avoidHerd);
	rmAddObjectDefConstraint(waterBuffaloSpam, avoidCoin);	
	rmAddObjectDefConstraint(waterBuffaloSpam, circleConstraint);
	rmAddObjectDefConstraint(waterBuffaloSpam, avoidTownCenterMore);
	rmAddObjectDefConstraint(waterBuffaloSpam, avoidWaterShort);	
	rmPlaceObjectDefAtLoc(waterBuffaloSpam, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

	int nuggetID= rmCreateObjectDef("nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0); 
	rmSetObjectDefMinDistance(nuggetID, 0.0); 
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.5)); 
	rmAddObjectDefConstraint(nuggetID, avoidNugget); 
	rmAddObjectDefConstraint(nuggetID, circleConstraint);
	rmAddObjectDefConstraint(nuggetID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggetID, forestConstraintShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSmall);
	rmAddObjectDefConstraint(nuggetID, avoidSocketSmall); 
	rmAddObjectDefConstraint(nuggetID, avoidPlateau);
	rmAddObjectDefConstraint(nuggetID, avoidWaterShort);	
	rmAddObjectDefConstraint(nuggetID, avoidCoin);	
	if (PlayerNum > 2)
	{
		rmSetNuggetDifficulty(3, 3); 
		rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);   
	}
	rmSetNuggetDifficulty(2, 2); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);   
	rmSetNuggetDifficulty(1, 1); 
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 2+5*cNumberNonGaiaPlayers);   

	rmSetStatusText("",0.8);

	int bonusTrees=rmCreateObjectDef("bonusTrees");
	rmAddObjectDefItem(bonusTrees, treeType1, 2, 5);
	rmAddObjectDefItem(bonusTrees, treeType2, 2, 5);
	rmAddObjectDefItem(bonusTrees, treeType3, 2, 5);
	rmAddObjectDefItem(bonusTrees, "UnderbrushSnow", rmRandInt(2,3), 7.0);
	rmAddObjectDefConstraint(bonusTrees, avoidTownCenter);
	rmAddObjectDefConstraint(bonusTrees, avoidNuggetShort);
	rmAddObjectDefConstraint(bonusTrees, avoidSocketSmall);
	rmAddObjectDefConstraint(bonusTrees, forestConstraintShort);
	rmAddObjectDefToClass(bonusTrees, rmClassID("classForest")); 
	rmAddObjectDefConstraint(bonusTrees, avoidCoin);
	rmAddObjectDefConstraint(bonusTrees, avoidWaterShort);	
	rmPlaceObjectDefInArea(bonusTrees, 0, continent2  , 15*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.9);

	// fish and their constraints placed together at the end for ease of removal
	int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "FishSalmon", 18.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 4.0);
	int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "Beluga", 64-2*cNumberNonGaiaPlayers);

	int whaleID=rmCreateObjectDef("whales");
	rmAddObjectDefItem(whaleID, "Beluga", 1, 0.0);
	rmSetObjectDefMinDistance(whaleID, 0.0);
	rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
	rmAddObjectDefConstraint(whaleID, fishLand);
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 4+cNumberNonGaiaPlayers);

	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "FishSalmon", 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.50));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 20+8*cNumberNonGaiaPlayers);

}	// END