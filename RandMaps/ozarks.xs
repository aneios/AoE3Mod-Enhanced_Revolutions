// OZARKS
//1v1 balance by Durokan for DE -- also did a very quick pass at team resources
// February 2021 edited by vividlyplain 

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{
   // Text
   // These status text lines are used to manually animate the map generation progress bar
   rmSetStatusText("",0.01);

	// Which map - four possible variations (excluding which end the players start on, which is a separate thing)

   // Picks the map size
   int playerTiles=10000;		
if (rmGetIsTreaty() == false) {
	if (cNumberNonGaiaPlayers >= 2)
		playerTiles = 11000;
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles = 10000;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles = 9000;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles = 8000;
	}
else {
	if (cNumberNonGaiaPlayers == 2)
		playerTiles = 16000;
	if (cNumberNonGaiaPlayers >= 4)
		playerTiles = 14750;
	if (cNumberNonGaiaPlayers >= 6)
		playerTiles = 13750;
	if (cNumberNonGaiaPlayers >= 8)
		playerTiles = 13250;
	}
   int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
   rmEchoInfo("Map size="+size+"m x "+size+"m");
   rmSetMapSize(size, size);
	
	// Picks a default water height
   rmSetSeaLevel(-2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	rmSetBaseTerrainMix("nwt_grass2");
	rmTerrainInitialize("NWterritory\ground_grass1_nwt", -2);
	rmSetMapType("bayou");
	rmSetMapType("grass");
	rmSetMapType("land");
	// FZhao light set change
   rmSetLightingSet("Ozarks_Skirmish");

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Choose Mercs
	chooseMercs();

	// Set up Natives
   int whichNative = rmRandInt(1,6);
//   		whichNative = 6;	// for testing
   int subCiv0 = -1;
   int subCiv1 = -1;
   string nativeName = "";

	if (whichNative < 3)
	{
      subCiv0 = rmGetCivID("Comanche");
      rmEchoInfo("subCiv0 is Comanche "+subCiv0);
      subCiv1 = rmGetCivID("Comanche");
      rmEchoInfo("subCiv1 is Comanche "+subCiv1);
      rmSetSubCiv(0, "Comanche", true);
      rmSetSubCiv(1, "Comanche", true);
      nativeName = "native Comanche village ";
	}
	else if (whichNative == 3)
	{
      subCiv0 = rmGetCivID("Seminoles");
      rmEchoInfo("subCiv0 is Seminoles "+subCiv0);
      subCiv1 = rmGetCivID("Seminoles");
      rmEchoInfo("subCiv1 is Seminoles "+subCiv1);
      rmSetSubCiv(0, "Seminoles", true);
      rmSetSubCiv(1, "Seminoles", true);
      nativeName = "native Seminole village ";
   }
   else
   {
      subCiv0 = rmGetCivID("Cherokee");
      rmEchoInfo("subCiv0 is Cherokee "+subCiv0);
      subCiv1 = rmGetCivID("Cherokee");
      rmEchoInfo("subCiv1 is Cherokee "+subCiv1);
      rmSetSubCiv(0, "Cherokee", true);
      rmSetSubCiv(1, "Cherokee", true);
      nativeName = "native Cherokee village ";
   }

   // Define some classes. These are used later for constraints.
   int classPlayer=rmDefineClass("player");
   rmDefineClass("classHill");
   rmDefineClass("classPatch");
   rmDefineClass("starting settlement");
   rmDefineClass("startingUnit");
   rmDefineClass("classForest");
   rmDefineClass("importantItem");
   rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("classMountain");
	rmDefineClass("socketClass");

   // -------------Define constraints
   // These are used to have objects and areas avoid each other
   
   // Map edge constraints
   //int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6), 0.01);
	int playerEdgeConstraint=rmCreatePieConstraint("player edge of map", 0.5, 0.5, rmXFractionToMeters(0.0), rmXFractionToMeters(0.43), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int coinEdgeConstraint=rmCreateBoxConstraint("coin edge of map", rmXTilesToFraction(19), rmZTilesToFraction(19), 1.0-rmXTilesToFraction(19), 1.0-rmZTilesToFraction(19), 2.0);

   // Cardinal Directions

	int stayNE=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(50), rmDegreesToRadians(85));
	int staySW=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(230), rmDegreesToRadians(265));
	int stayS=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(145), rmDegreesToRadians(305));
	int stayN=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(325), rmDegreesToRadians(125));

	// Player constraints
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 20.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("stay far away from players", classPlayer, 75.0);
 
   // Nature avoidance
	int avoidForest=rmCreateClassDistanceConstraint("forest avoids forest", rmClassID("classForest"), 18.0);
	int avoidForestFar=rmCreateClassDistanceConstraint("forest avoids forest far", rmClassID("classForest"), 32.0);
	int avoidturkey=rmCreateTypeDistanceConstraint("avoids turkey", "turkey", 45.0);
	int avoiddeer=rmCreateTypeDistanceConstraint("deer avoids deer", "deer", 45.0);
	int avoiddeerFar=rmCreateTypeDistanceConstraint("deer avoids deer Far", "deer", 65.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "gold", 30.0);
	int avoidCoinBase=rmCreateTypeDistanceConstraint("avoid coin base", "mine", 20.0);
	int avoidCoinShort=rmCreateTypeDistanceConstraint("avoid coin short", "gold", 8.0);
	int avoidCoinFar=rmCreateTypeDistanceConstraint("avoid coin far", "gold", 60.0);
   
   // Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 10.0);
	int avoidCliff = rmCreateClassDistanceConstraint("stuff vs. cliff", rmClassID("classCliff"), 12.0);
	int cliffAvoidCliff = rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int mediumShortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("mediumshort avoid impassable land", "Land", false, 4.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int mediumAvoidImpassableLand = rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 12.0);
	int longAvoidImpassableLand = rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 16.0);

   // Unit avoidance
	int avoidHuari=rmCreateTypeDistanceConstraint("avoid Huari", "huariStronghold", 20.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 20.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 40.0);
	int avoidTownCenterSupaFar=rmCreateTypeDistanceConstraint("avoid Town Center Supa Far", "townCenter", 50.0);
   int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 60.0);
   int shortAvoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other by a bit", rmClassID("importantItem"), 10.0);
   int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 8.0);
   int avoidNativesFar=rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 45.0);
   int avoidNativesFar2=rmCreateClassDistanceConstraint("stuff avoids natives far2", rmClassID("natives"), 15.0);
   int avoidSocket=rmCreateClassDistanceConstraint("stuff avoids sockets", rmClassID("socketClass"), 8.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 50.0);
	int avoidNuggetShort=rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	
   // Decoration avoidance
   int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 8.0);


   // -------------Define objects
   // These objects are all defined so they can be placed later

	rmSetStatusText("",0.10);

	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);

		// ****************************** PLACE PLAYERS ******************************

	int teamZeroCount = rmGetNumberPlayersOnTeam(0);
	int teamOneCount = rmGetNumberPlayersOnTeam(1);
// 2 team and FFA support
	float OneVOnePlacement=rmRandFloat(0, 1);
	if (cNumberNonGaiaPlayers == 2)
	{

		if ( OneVOnePlacement < 0.5)
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.4, 0.2, 0.2, 0.4, 0, 0.0);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.6, 0.8, 0.8, 0.6, 0, 0.0);
		}
		else
		{
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.6, 0.8, 0.8, 0.6, 0, 0.0);

			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.4, 0.2, 0.2, 0.4, 0, 0.0);
		}
		
	}
	//*******************************TEAM PLACEMENTS*****************************
	else if ( cNumberTeams == 2 && teamZeroCount == teamOneCount)
	{
		if (rmGetIsKOTH() == false) {
			if (rmGetIsTreaty() == true && cNumberNonGaiaPlayers == 4) {
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.00, 0.15); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.34, 0.34, 0.0);	
		
			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.50, 0.65); 
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.34, 0.34, 0.0);	
			}
			else {
				rmSetPlacementTeam(0);
				rmSetTeamSpacingModifier(0.20);
				if (cNumberNonGaiaPlayers == 4)
					rmPlacePlayersLine(0.50, 0.10, 0.30, 0.30, 0, 0.0);
				else if (cNumberNonGaiaPlayers == 6)
					rmPlacePlayersLine(0.13, 0.49, 0.49, 0.13, 0, 0.0);
				else
					rmPlacePlayersLine(0.1, 0.5, 0.5, 0.1, 0, 0.0);

				rmSetPlacementTeam(1);
				rmSetTeamSpacingModifier(0.20);
				if (cNumberNonGaiaPlayers == 4)
					rmPlacePlayersLine(0.50, 0.90, 0.70, 0.70, 0, 0.0);
				else if (cNumberNonGaiaPlayers == 6)
					rmPlacePlayersLine(0.87, 0.51, 0.51, 0.87, 0, 0.0);
				else
					rmPlacePlayersLine(0.9, 0.5, 0.5, 0.9, 0, 0.0);
			}
		}
		else {
		rmSetPlacementTeam(0);
		rmSetPlacementSection(0.0, 0.25); 
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.36, 0.36, 0.0);	
	
		rmSetPlacementTeam(1);
		rmSetPlacementSection(0.50, 0.75); 
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.36, 0.36, 0.0);	
		}
	}
	//******************************************FFA SUPPORT***************************************
	else if (cNumberTeams > 2 || rmGetIsKOTH() == true)
	{
// old player placement for ffa
/*      bool southSide = true;

      float spacingIncrement = (0.35 / (cNumberNonGaiaPlayers / 2));
      float spacingSouth = 0;
      float spacingNorth = 0;
      
      float southStart = 0.45;
      float southEnd = 0.82;
      float northStart = 0.95;
      float northEnd = 0.32;

      for (i = 0; < cNumberNonGaiaPlayers)
      {
         rmEchoInfo("i = "+i);
         if (southSide == true)
         {
            rmSetPlacementTeam(i);
            rmSetPlacementSection((southStart + spacingSouth), southEnd);
	         rmSetTeamSpacingModifier(0.25);
	         rmPlacePlayersCircular(0.4, 0.4, 0);
            spacingSouth = spacingSouth + spacingIncrement;
         }
         else
         {
            rmSetPlacementTeam(i);
            rmSetPlacementSection((northStart + spacingNorth), northEnd);
	         rmSetTeamSpacingModifier(0.25);
	         rmPlacePlayersCircular(0.4, 0.4, 0);
            spacingNorth = spacingNorth + spacingIncrement;
         }
         if (southSide == true)
         {
            southSide = false;
         }
         else
         {
            southSide = true;
         }
      }*/

// new ffa player placement - taken from Mexico	
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.39, 0.39, 0.0);	
      }
	else if (cNumberTeams > 2) {
// new ffa player placement - taken from Mexico	
		rmSetTeamSpacingModifier(0.50);
		rmPlacePlayersCircular(0.39, 0.39, 0.0);	
   }
   else 
   {
      if (teamZeroCount < teamOneCount)
      {
         rmSetPlacementTeam(0);
         rmSetPlacementSection(0.55, 0.75);
		   rmSetTeamSpacingModifier(0.35 / teamZeroCount);
		   rmPlacePlayersCircular(0.4, 0.4, 0);

		   rmSetPlacementTeam(1);
         rmSetPlacementSection(0.95, 0.32);
		   rmSetTeamSpacingModifier(0.35 / teamOneCount);
		   rmPlacePlayersCircular(0.4, 0.4, 0);
      }
      else 
      {
         rmSetPlacementTeam(0);
         rmSetPlacementSection(0.45, 0.82);
		   rmSetTeamSpacingModifier(0.35 / teamZeroCount);
		   rmPlacePlayersCircular(0.4, 0.4, 0);

		   rmSetPlacementTeam(1);
         rmSetPlacementSection(0.0, 0.2);
		   rmSetTeamSpacingModifier(0.35 / teamOneCount);
		   rmPlacePlayersCircular(0.4, 0.4, 0);
      }
   }

   // Build a north area
	int eastIslandID = rmCreateArea("east island");
	rmSetAreaLocation(eastIslandID, 0.15, 0.85); 
	rmSetAreaWarnFailure(eastIslandID, false);
	rmSetAreaSize(eastIslandID, 0.60, 0.60);
	rmSetAreaCoherence(eastIslandID, 1.0);

	rmSetAreaElevationType(eastIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(eastIslandID, 5.0);
//	rmSetAreaBaseHeight(eastIslandID, 4.0);
	rmSetAreaElevationMinFrequency(eastIslandID, 0.07);
	rmSetAreaElevationOctaves(eastIslandID, 4);
	rmSetAreaElevationPersistence(eastIslandID, 0.5);
	rmSetAreaElevationNoiseBias(eastIslandID, 1);
   
	rmSetAreaObeyWorldCircleConstraint(eastIslandID, false);
	rmSetAreaMix(eastIslandID, "nwt_grass2");

   // Text
   rmSetStatusText("",0.20);

   // Build a south area
	int westIslandID = rmCreateArea("west island");
	//rmSetAreaLocation(westIslandID, 0, 0.5);
	rmSetAreaLocation(westIslandID, 0.75, 0.25);
	rmSetAreaWarnFailure(westIslandID, false);
	rmSetAreaSize(westIslandID, 0.60, 0.60);
	rmSetAreaCoherence(westIslandID, 1.0);

	rmSetAreaElevationType(westIslandID, cElevTurbulence);
	rmSetAreaElevationVariation(westIslandID, 5.0);
//	rmSetAreaBaseHeight(westIslandID, 4.0);
	rmSetAreaElevationMinFrequency(westIslandID, 0.07);
	rmSetAreaElevationOctaves(westIslandID, 4);
	rmSetAreaElevationPersistence(westIslandID, 0.5);
	rmSetAreaElevationNoiseBias(westIslandID, 1); 
	//rmAddAreaTerrainLayer(westIslandID, "NWterritory\ground_grass1_nwt", 3, 12);
	//rmAddAreaTerrainLayer(westIslandID, "NWterritory\ground_grass2_nwt", 3, 12);
   
	rmSetAreaObeyWorldCircleConstraint(westIslandID, false);
	rmSetAreaMix(westIslandID, "nwt_grass2");
	//rmSetAreaMix(westIslandID, "rockies_grass");

   rmBuildAllAreas();

   // Text
   rmSetStatusText("",0.30);
	
	// Set up player areas.
   float playerFraction = rmAreaTilesToFraction(100);
   for(i = 0; < cNumberNonGaiaPlayers)
   {
      // Create the area.
      int id = rmCreateArea("Player"+i);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction, playerFraction);
      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmSetAreaCoherence(id, 0.80); 
      rmAddAreaConstraint(id, playerConstraint); 
      rmAddAreaConstraint(id, playerEdgeConstraint);
	   rmSetAreaTerrainType(id, "NWterritory\ground_grass1_nwt");
      rmSetAreaWarnFailure(id, false);
   }

   // Build the areas.
   rmBuildAllAreas();
   
	// Text
	rmSetStatusText("",0.40);

   // Text
   rmSetStatusText("",0.50);

   int failCount = -1;
   int numTries = cNumberNonGaiaPlayers+2;
 
   // Place Natives
      int nativeVillageA = 0;
      int nativeVillageTypeA = rmRandInt(1,5);
      
      nativeVillageA = rmCreateGrouping("Native village A "+i, nativeName+nativeVillageTypeA);
      rmSetGroupingMinDistance(nativeVillageA, 0.0);
	  if (rmGetIsTreaty() == true)
	      rmSetGroupingMaxDistance(nativeVillageA, 0.0);
    else
		  rmSetGroupingMaxDistance(nativeVillageA, 8.0);
      rmAddGroupingConstraint(nativeVillageA, avoidCliff);
      rmAddGroupingConstraint(nativeVillageA, longAvoidImpassableLand);
      rmAddGroupingToClass(nativeVillageA, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillageA, rmClassID("importantItem"));
      if (cNumberTeams > 2 || teamZeroCount > teamOneCount || teamOneCount > teamZeroCount)
      {
         rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.475, 0.375); 	// 0.4, 0.4
      }
      else if (rmGetIsTreaty() == false)
      {
         rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.6, 0.2);
      }
	  else
      {
		  if (cNumberNonGaiaPlayers == 2) {
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.57, 0.2);
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.1, 0.5);
		  	}
		  else if (cNumberNonGaiaPlayers <= 4) {
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.60, 0.75);
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.25, 0.40);
		  	}
		  else if (cNumberNonGaiaPlayers == 6) {
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.44, 0.24);
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.24, 0.44);
		  	}
		  else {
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.45, 0.25);
         	rmPlaceGroupingAtLoc(nativeVillageA, 0, 0.25, 0.45);
		  	}
      }

      int nativeVillageB = 0;
      int nativeVillageTypeB = rmRandInt(1,5);

      nativeVillageB = rmCreateGrouping("Native village B "+i, nativeName+nativeVillageTypeB);
      rmSetGroupingMinDistance(nativeVillageB, 0.0);
	  if (rmGetIsTreaty() == true)
	      rmSetGroupingMaxDistance(nativeVillageB, 0.0);
    else
		  rmSetGroupingMaxDistance(nativeVillageB, 8.0);
      rmAddGroupingConstraint(nativeVillageB, avoidImpassableLand);
      rmAddGroupingToClass(nativeVillageB, rmClassID("natives"));
      rmAddGroupingToClass(nativeVillageB, rmClassID("importantItem"));
      if (cNumberTeams > 2 || teamZeroCount > teamOneCount || teamOneCount > teamZeroCount)
      {
         rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.525, 0.625);		// 0.6, 0.6
      }
      else if (rmGetIsTreaty() == false)
      {
         rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.4, 0.8);
      }
      else
      {
		  if (cNumberNonGaiaPlayers == 2) {
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.43, 0.8);
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.9, 0.5);
		  	}
		  else if (cNumberNonGaiaPlayers <= 4) {
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.85, 0.60);
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.40, 0.15);
		  	}
		  else if (cNumberNonGaiaPlayers == 6) {
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.76, 0.56);
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.56, 0.76);
		  	}
		  else {
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.75, 0.55);
         	rmPlaceGroupingAtLoc(nativeVillageB, 0, 0.55, 0.75);
		  	}
      }


	// PLAYER STARTING RESOURCES
    int classStartingResource = rmDefineClass("startingResource");
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other 2", rmClassID("startingResource"), 8.0);
	
   rmClearClosestPointConstraints();
   int TCfloat = 0;	// 10
   
	int TCID = rmCreateObjectDef("Player TC");

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
	rmSetObjectDefMaxDistance(TCID, TCfloat);

//	int playerSilverID = rmCreateObjectDef("player mine");
//	rmAddObjectDefItem(playerSilverID, "mine", 1, 0);
//	rmAddObjectDefConstraint(playerSilverID, avoidTownCenter);
//	rmSetObjectDefMinDistance(playerSilverID, 15.0);
//	rmSetObjectDefMaxDistance(playerSilverID, 20.0);
//   rmAddObjectDefConstraint(playerSilverID, avoidImpassableLand);
//   rmAddObjectDefConstraint(playerSilverID, coinEdgeConstraint);

//	int playerturkeyID=rmCreateObjectDef("player turkey");
//   rmAddObjectDefItem(playerturkeyID, "turkey", 8, 8);
//   rmSetObjectDefMinDistance(playerturkeyID, 11);
//   rmSetObjectDefMaxDistance(playerturkeyID, 14);
//   rmAddObjectDefConstraint(playerturkeyID, avoidAll);
//   rmAddObjectDefConstraint(playerturkeyID, avoidImpassableLand);
//   rmAddObjectDefConstraint(playerturkeyID, avoidCliff);
//   rmSetObjectDefCreateHerd(playerturkeyID, true);

	int playerNuggetID= rmCreateObjectDef("player nugget"); 
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLand);
  	rmAddObjectDefConstraint(playerNuggetID, avoidAll);
	rmAddObjectDefConstraint(playerNuggetID, avoidCliff);
	rmAddObjectDefConstraint(playerNuggetID, playerEdgeConstraint);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmSetObjectDefMinDistance(playerNuggetID, 26.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 30.0);

	int playerTreeID = rmCreateObjectDef("player trees");
   rmAddObjectDefItem(playerTreeID, "TreeNorthwestTerritory", 3, 4.0);
   rmAddObjectDefItem(playerTreeID, "TreeGreatLakes", 3, 4.0);
   rmSetObjectDefMinDistance(playerTreeID, 15);
   rmSetObjectDefMaxDistance(playerTreeID, 18);
   rmAddObjectDefConstraint(playerTreeID, avoidAll);
   rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
   rmAddObjectDefConstraint(playerTreeID, avoidStartingResources);
   
    //1v1 stuff
    
    int baseGold = rmCreateObjectDef("base gold");
    rmAddObjectDefItem(baseGold, "mine", 1, 0.0);
    rmSetObjectDefMinDistance(baseGold, 16.0);
    rmSetObjectDefMaxDistance(baseGold, 16.0);
   	rmAddObjectDefToClass(baseGold, classStartingResource);
	rmAddObjectDefConstraint(baseGold, avoidImpassableLand);
	rmAddObjectDefConstraint(baseGold, avoidStartingResources);
	rmAddObjectDefConstraint(baseGold, avoidCoinBase);
    
    int baseHunt1=rmCreateObjectDef("baseHunt1");
	if (rmGetIsTreaty() == true)
    	rmAddObjectDefItem(baseHunt1, "deer", 12, 5.0);
    else
		rmAddObjectDefItem(baseHunt1, "deer", 6, 5.0);
    rmSetObjectDefMinDistance(baseHunt1, 12.0);
    rmSetObjectDefMaxDistance(baseHunt1, 14.0);
    rmAddObjectDefToClass(baseHunt1, classStartingResource);
    rmAddObjectDefConstraint(baseHunt1, avoidStartingResources);
    rmAddObjectDefConstraint(baseHunt1, avoidImpassableLand);
    rmSetObjectDefCreateHerd(baseHunt1, true);

    int baseHunt2=rmCreateObjectDef("baseHunt2");
	if (rmGetIsTreaty() == true)
	    rmAddObjectDefItem(baseHunt2, "deer", 16, 6.0);
    else
		rmAddObjectDefItem(baseHunt2, "turkey", 10, 5.0);
    rmSetObjectDefMinDistance(baseHunt2, 31.0);
    rmSetObjectDefMaxDistance(baseHunt2, 33.0);
    rmAddObjectDefToClass(baseHunt2, classStartingResource);
    rmAddObjectDefConstraint(baseHunt2, avoidStartingResources);
    rmSetObjectDefCreateHerd(baseHunt2, true);
    rmAddObjectDefConstraint(baseHunt2, avoidImpassableLand);

	for(i = 1; < cNumberPlayers)
   {
	rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));
	rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(baseGold, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(baseGold, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(playerTreeID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
        rmPlaceObjectDefAtLoc(baseHunt1, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
    if (cNumberNonGaiaPlayers > 2)
		rmPlaceObjectDefAtLoc(baseHunt2, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
	rmPlaceObjectDefAtLoc(playerNuggetID, 0, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
     
    if(ypIsAsian(i) && rmGetNomadStart() == false)
      rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
   rmClearClosestPointConstraints();
   }

	// Text
	rmSetStatusText("",0.60);


		//***************************************************************CLIFFS*********************************************************
 // cliffs
	int classAvoidance = rmDefineClass("avoidance");

	int avoidTHisID=rmCreateArea("avoid this island");
	rmSetAreaSize(avoidTHisID, 0.01);
	rmSetAreaLocation(avoidTHisID, 0.50, 0.50);
	rmAddAreaInfluenceSegment(avoidTHisID, 0.10, 0.90, 0.90, 0.10);
	rmAddAreaToClass(avoidTHisID, classAvoidance);
//	rmSetAreaMix(avoidTHisID, "testmix");
	rmSetAreaCoherence(avoidTHisID, 1.00);
	if (cNumberTeams == 2 && teamZeroCount == teamOneCount)
		rmBuildArea(avoidTHisID); 


		//************Center Cliff*******************
   		int smallCliffHeight=rmRandInt(0,6);
		int smallMesaID=rmCreateArea("small mesa"+i);
//		if (rmGetIsKOTH() == false && cNumberTeams == 2) {
//		if ( cNumberNonGaiaPlayers < 6 )
//		{
			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(222+100*cNumberNonGaiaPlayers), rmAreaTilesToFraction(222+100*cNumberNonGaiaPlayers));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		else if ( cNumberNonGaiaPlayers < 8 )
//		{
//			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(1400), rmAreaTilesToFraction(1400));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		else
//		{
//			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(1600), rmAreaTilesToFraction(1600));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		}
//		else 
//		{
//			rmSetAreaSize(smallMesaID, rmAreaTilesToFraction(200*cNumberNonGaiaPlayers), rmAreaTilesToFraction(200*cNumberNonGaiaPlayers));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}

  		//FZ cliff changed for different grass look
		rmSetAreaCliffType(smallMesaID, "araucania central ozarks");
		if (rmGetIsKOTH() == true || cNumberTeams > 2)
			rmSetAreaCliffEdge(smallMesaID, 4+cNumberNonGaiaPlayers/2, 0.09, 0.0, 1.0, 0);
		else
			rmSetAreaCliffEdge(smallMesaID, 1, 1.00, 0.1, 1.0, 0);
	//		rmSetAreaCliffEdge(smallMesaID, 4, 0.2, 0.1, 1.0, 0);
		rmAddAreaToClass(smallMesaID, rmClassID("classCliff"));
		rmSetAreaCliffHeight(smallMesaID, rmRandInt(4, 6), 1.0, 1.0);  //was rmRandInt(6, 8)
		rmAddAreaCliffEdgeAvoidClass(smallMesaID, classAvoidance, 0.5);
		rmSetAreaCoherence(smallMesaID, 0.88);
		rmSetAreaLocation(smallMesaID, 0.51, 0.51); 
		if (cNumberTeams == 2 && teamOneCount == teamZeroCount) {
			rmAddAreaInfluenceSegment(smallMesaID, 0.48, 0.48, 0.49, 0.49);  //Bottom - Original segment
			rmAddAreaInfluenceSegment(smallMesaID, 0.50, 0.48, 0.51, 0.49); //Right
			rmAddAreaInfluenceSegment(smallMesaID, 0.51, 0.51, 0.52, 0.52); //Top - Original segment
			rmAddAreaInfluenceSegment(smallMesaID, 0.48, 0.50, 0.49, 0.51); //Left
			}
		if (cNumberTeams == 2 && rmGetIsKOTH() == false && rmGetIsTreaty() == false)
			rmBuildArea(smallMesaID);
		if (cNumberNonGaiaPlayers > 2 && rmGetIsKOTH() == false && rmGetIsTreaty() == true)
			rmBuildArea(smallMesaID);


		//******Left Cliff************
		int smallCliffHeight2=rmRandInt(0,6);
		int smallMesaID2=rmCreateArea("small mesa2"+i);
//		if ( cNumberNonGaiaPlayers < 6 )
//		{
			rmSetAreaSize(smallMesaID2, rmAreaTilesToFraction(222+100*cNumberNonGaiaPlayers), rmAreaTilesToFraction(222+100*cNumberNonGaiaPlayers));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		else if ( cNumberNonGaiaPlayers < 8 )
//		{
//			rmSetAreaSize(smallMesaID2, rmAreaTilesToFraction(1400), rmAreaTilesToFraction(1400));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		else
//		{
//			rmSetAreaSize(smallMesaID2, rmAreaTilesToFraction(1600), rmAreaTilesToFraction(1600));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}

  		rmSetAreaCliffType(smallMesaID2, "araucania central ozarks");
		rmAddAreaToClass(smallMesaID2, rmClassID("classCliff"));
//		rmSetAreaCliffEdge(smallMesaID2, 4, 0.2, 0.1, 1.0, 0);
		rmSetAreaCliffEdge(smallMesaID2, 1, 1.00, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID2, rmRandInt(4, 6), 1.0, 1.0);  //was rmRandInt(6, 8)
		rmSetAreaCoherence(smallMesaID2, 0.88);
		rmSetAreaLocation(smallMesaID2, 0.26, 0.76); 
		rmAddAreaCliffEdgeAvoidClass(smallMesaID2, classAvoidance, 0.5);
		rmAddAreaInfluenceSegment(smallMesaID2, 0.48, 0.43, 0.5, 0.40);  //Bottom - Original segment
		rmAddAreaInfluenceSegment(smallMesaID2, 0.46, 0.40, 0.53, 0.38); //Right
		rmAddAreaInfluenceSegment(smallMesaID2, 0.53, 0.45, 0.53, 0.38); //Top - Original segment
		rmAddAreaInfluenceSegment(smallMesaID2, 0.53, 0.45, 0.48, 0.43); //Left
		if (rmGetIsKOTH() == false && cNumberTeams == 2)
			rmBuildArea(smallMesaID2);

		//******Right Cliff******
		int smallCliffHeight3=rmRandInt(0,6);
		int smallMesaID3=rmCreateArea("small mesa3"+i);
//		if ( cNumberNonGaiaPlayers < 6 )
//		{
			rmSetAreaSize(smallMesaID3, rmAreaTilesToFraction(222+100*cNumberNonGaiaPlayers), rmAreaTilesToFraction(222+100*cNumberNonGaiaPlayers));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		else if ( cNumberNonGaiaPlayers < 8 )
//		{
//			rmSetAreaSize(smallMesaID3, rmAreaTilesToFraction(1400), rmAreaTilesToFraction(1400));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}
//		else
//		{
//			rmSetAreaSize(smallMesaID3, rmAreaTilesToFraction(1600), rmAreaTilesToFraction(1600));  //First # is minimum square meters of material it will use to build.  Second # is maximum.  Currently I have them both set to the same because I want a certain size mountain every time.
//		}

  		rmSetAreaCliffType(smallMesaID3, "araucania central ozarks");
		rmAddAreaToClass(smallMesaID3, rmClassID("classCliff"));
	//	rmSetAreaCliffEdge(smallMesaID3, 4, 0.2, 0.1, 1.0, 0);
		rmSetAreaCliffEdge(smallMesaID3, 1, 1.00, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(smallMesaID3, rmRandInt(4, 6), 1.0, 1.0);  //was rmRandInt(6, 8)
		rmSetAreaCoherence(smallMesaID3, 0.88);
		rmSetAreaLocation(smallMesaID3, 0.76, 0.26); 
		rmAddAreaCliffEdgeAvoidClass(smallMesaID3, classAvoidance, 0.5);
		rmAddAreaInfluenceSegment(smallMesaID3, 0.48, 0.43, 0.5, 0.40);  //Bottom - Original segment
		rmAddAreaInfluenceSegment(smallMesaID3, 0.46, 0.40, 0.53, 0.38); //Right
		rmAddAreaInfluenceSegment(smallMesaID3, 0.53, 0.45, 0.53, 0.38); //Top - Original segment
		rmAddAreaInfluenceSegment(smallMesaID3, 0.53, 0.45, 0.48, 0.43); //Left
		if (rmGetIsKOTH() == false && cNumberTeams == 2)
			rmBuildArea(smallMesaID3);

	//******FFA Cliffs******
	if (cNumberTeams > 2 || rmGetIsKOTH() == true) {
		int ffaMesaID1=rmCreateArea("ffa mesa1");
		rmSetAreaSize(ffaMesaID1, rmAreaTilesToFraction(500)); 
  		rmSetAreaCliffType(ffaMesaID1, "araucania central ozarks");
		rmAddAreaToClass(ffaMesaID1, rmClassID("classCliff"));
		rmSetAreaCliffEdge(ffaMesaID1, 4, 0.2, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(ffaMesaID1, rmRandInt(4, 6), 1.0, 1.0);
		rmSetAreaCoherence(ffaMesaID1, 0.99);
		rmSetAreaLocation(ffaMesaID1, 0.65, 0.65);
		rmBuildArea(ffaMesaID1);

		int ffaMesaID2=rmCreateArea("ffa mesa2");
		rmSetAreaSize(ffaMesaID2, rmAreaTilesToFraction(500)); 
  		rmSetAreaCliffType(ffaMesaID2, "araucania central ozarks");
		rmAddAreaToClass(ffaMesaID2, rmClassID("classCliff"));
		rmSetAreaCliffEdge(ffaMesaID2, 4, 0.2, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(ffaMesaID2, rmRandInt(4, 6), 1.0, 1.0);
		rmSetAreaCoherence(ffaMesaID2, 0.99);
		rmSetAreaLocation(ffaMesaID2, 0.35, 0.35);
		rmBuildArea(ffaMesaID2);

		int ffaMesaID3=rmCreateArea("ffa mesa3");
		rmSetAreaSize(ffaMesaID3, rmAreaTilesToFraction(500)); 
  		rmSetAreaCliffType(ffaMesaID3, "araucania central ozarks");
		rmAddAreaToClass(ffaMesaID3, rmClassID("classCliff"));
		rmSetAreaCliffEdge(ffaMesaID3, 4, 0.2, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(ffaMesaID3, rmRandInt(4, 6), 1.0, 1.0);
		rmSetAreaCoherence(ffaMesaID3, 0.99);
		rmSetAreaLocation(ffaMesaID3, 0.35, 0.65);
		rmBuildArea(ffaMesaID3);

		int ffaMesaID4=rmCreateArea("ffa mesa4");
		rmSetAreaSize(ffaMesaID4, rmAreaTilesToFraction(500)); 
  		rmSetAreaCliffType(ffaMesaID4, "araucania central ozarks");
		rmAddAreaToClass(ffaMesaID4, rmClassID("classCliff"));
		rmSetAreaCliffEdge(ffaMesaID4, 4, 0.2, 0.1, 1.0, 0);
		rmSetAreaCliffHeight(ffaMesaID4, rmRandInt(4, 6), 1.0, 1.0);
		rmSetAreaCoherence(ffaMesaID4, 0.99);
		rmSetAreaLocation(ffaMesaID4, 0.65, 0.35);
		rmBuildArea(ffaMesaID4);
		}
	
  // check for KOTH game mode
	if(rmGetIsKOTH()) {

    float xLoc = 0.5;
    float yLoc = 0.5;
    float walk = 0.0;

    ypKingsHillPlacer(xLoc, yLoc, walk, 0);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }
		int avoidKOTH = rmCreateTypeDistanceConstraint("avoid koth", "ypKingsHill", 12.0);

	// ********************************************** TRADE ROUTE **************************************************
// old tp
/*   int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 6.0);


	int tradeRouteID = rmCreateTradeRoute();
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 1.0);


	bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");
	if(placedTradeRouteA == false)
		rmEchoError("Failed to place trade route 1");

	rmPlaceObjectDefAtLoc(socketID, 0, 0.25, 0.75);
  rmPlaceObjectDefAtLoc(socketID, 0, 0.50, 0.50);
	rmPlaceObjectDefAtLoc(socketID, 0, 0.75, 0.25);
*/

// new tp to adjust for KOTH and FFA spawn fixes - modified from Mexico

		int tradeRouteID = rmCreateTradeRoute();
		int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
		rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
		rmSetObjectDefAllowOverlap(socketID, true);
		rmSetObjectDefMinDistance(socketID, 2.0);
		rmSetObjectDefMaxDistance(socketID, 8.0);
		rmSetObjectDefTradeRouteID(socketID, tradeRouteID);

	if (cNumberTeams <3 && rmGetIsKOTH() == false) // TEAM
	{	
	rmAddTradeRouteWaypoint(tradeRouteID, 1.0, 0.0);
	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 1.0);


		bool placedTradeRouteA = rmBuildTradeRoute(tradeRouteID, "dirt");

		vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

		socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
		rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
		
	
		}
	else // FFA and KOTH
		{
		
		rmAddTradeRouteWaypoint(tradeRouteID, 0.64, 0.64); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.64, 0.36);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.30);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.36, 0.36); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.50);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.36, 0.64);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.70);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.64, 0.64); 

		rmBuildTradeRoute(tradeRouteID, "dirt");

			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.00);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.25);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
			socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.75);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

        }

  //constraints for durokan's 1v1 balance
    int avoidSocket2=rmCreateClassDistanceConstraint("socket avoidance gold", rmClassID("socketClass"), 4.0);
    int avoidSocket2Far=rmCreateClassDistanceConstraint("socket avoidance far", rmClassID("socketClass"), 12.0);	// added by vividlyplain
    int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("objects avoid trade route", 8.0);
    int avoidTradeRouteSmall = rmCreateTradeRouteDistanceConstraint("objects avoid trade route small", 3.0);
    int forestConstraintShort=rmCreateClassDistanceConstraint("object vs. forest", rmClassID("classForest"), 3.0);
    int avoidHunt2=rmCreateTypeDistanceConstraint("herds avoid herds2", "huntable", 33.0);
    int avoidHunt3=rmCreateTypeDistanceConstraint("herds avoid herds3", "huntable", 23.0);
    int avoidHunt4=rmCreateTypeDistanceConstraint("herds avoid herds4", "huntable", 42.0);
	int avoidAll2=rmCreateTypeDistanceConstraint("avoid all2", "all", 4.0);
    int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("avoid gold type 2 far ", "gold", 42.0);
    int avoidGoldForest = rmCreateTypeDistanceConstraint("avoid gold 2", "gold", 9.0);
    int circleConstraint2=rmCreatePieConstraint("circle Constraint2", 0.5, 0.5, 0, rmZFractionToMeters(0.48), rmDegreesToRadians(0), rmDegreesToRadians(360));
    int avoidWater5 = rmCreateTerrainDistanceConstraint("avoid water 5", "Land", false, 5.0);
    int avoidWater6 = rmCreateTerrainDistanceConstraint("avoid water 6", "Land", false, 6.5);

    //durokans team constraints
    int avoidTownCenterMore=rmCreateTypeDistanceConstraint("avoid Town Center more", "townCenter", 40.0);  
    int avoidHunt=rmCreateTypeDistanceConstraint("hunts avoid hunts", "huntable", 50.0);
    int avoidCoinMed=rmCreateTypeDistanceConstraint("avoid coin medium", "Mine", 60.0);

	// treaty balance by vividlyplain
	int treesNearEdge = rmCreatePieConstraint("trees stay near edge",0.5,0.5,rmXFractionToMeters(0.475+0.00033*cNumberNonGaiaPlayers), rmXFractionToMeters(0.49), rmDegreesToRadians(0),rmDegreesToRadians(360));

	// moar wud, moar ppaarrttyy
	int rimTrees=rmCreateObjectDef("rim trees");
	rmAddObjectDefItem(rimTrees, "TreeNorthwestTerritory", 2, 2.0);
	rmAddObjectDefItem(rimTrees, "TreeGreatLakes", 2, 2.0);
	rmAddObjectDefToClass(rimTrees, rmClassID("classForest")); 
	rmSetObjectDefMinDistance(rimTrees, rmXFractionToMeters(0.0));
	rmSetObjectDefMaxDistance(rimTrees, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rimTrees, avoidNatives);
	rmAddObjectDefConstraint(rimTrees, avoidSocket2Far);
	rmAddObjectDefConstraint(rimTrees, avoidTradeRoute);
	rmAddObjectDefConstraint(rimTrees, avoidCliff);
//	rmAddObjectDefConstraint(rimTrees, playerConstraint);
//	rmAddObjectDefConstraint(rimTrees, avoidAll);
	rmAddObjectDefConstraint(rimTrees, avoidKOTH);
	if (cNumberNonGaiaPlayers == 2)
		rmAddObjectDefConstraint(rimTrees, avoidCoinShort);
	rmAddObjectDefConstraint(rimTrees, treesNearEdge);
	if (rmGetIsTreaty() == true)
		rmPlaceObjectDefAtLoc(rimTrees, 0, 0.5, 0.5, 250+50*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.70);

	// Silver mines
if(cNumberNonGaiaPlayers>2){ 

  	int islandminesID = rmCreateObjectDef("island silver");
	rmAddObjectDefItem(islandminesID, "mine", 1, 1.0);
	rmSetObjectDefMinDistance(islandminesID, 0.0);
	rmSetObjectDefMaxDistance(islandminesID, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(islandminesID, avoidCoinMed);
	rmAddObjectDefConstraint(islandminesID, avoidTownCenterMore);
	rmAddObjectDefConstraint(islandminesID, avoidSocket2Far);
	rmAddObjectDefConstraint(islandminesID, forestConstraintShort);
	rmAddObjectDefConstraint(islandminesID, circleConstraint2);
    rmAddObjectDefConstraint(islandminesID, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(islandminesID, avoidAll2);  
    rmAddObjectDefConstraint(islandminesID, avoidKOTH);  
	rmPlaceObjectDefAtLoc(islandminesID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
}else{
//1v1 mines
    int topMine = rmCreateObjectDef("topMine");
    rmAddObjectDefItem(topMine, "mine", 1, 1.0);
    rmSetObjectDefMinDistance(topMine, 0.0);
    rmSetObjectDefMaxDistance(topMine, 18);
    rmAddObjectDefConstraint(topMine, avoidSocket2Far);
    rmAddObjectDefConstraint(topMine, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(topMine, forestConstraintShort);
    rmAddObjectDefConstraint(topMine, avoidGoldTypeFar);
    rmAddObjectDefConstraint(topMine, circleConstraint2);  
    rmAddObjectDefConstraint(topMine, avoidWater6);  
    rmAddObjectDefConstraint(topMine, avoidAll2);  
    rmAddObjectDefConstraint(topMine, avoidTownCenterFar);  
    rmAddObjectDefConstraint(topMine, avoidKOTH);  
    
    //mine near native post
    rmPlaceObjectDefAtLoc(topMine, 0, 0.45, 0.65, 1);   
    rmPlaceObjectDefAtLoc(topMine, 0, 0.55, 0.35, 1);   
    
    int mineVariation = rmRandInt(1,2);
    //mineVariation = 1; //test
    //mines of 3 have 2 closer to TR
    if(mineVariation ==1){
        //mines of 3 top
        rmPlaceObjectDefAtLoc(topMine, 0, 0.65, 0.55, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.85, 0.35, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.85, 0.6, 1);
        //mines of 3 bot
        rmPlaceObjectDefAtLoc(topMine, 0, 0.35, 0.45, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.15, 0.65, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.15, 0.4, 1);
    }else{
        //top mines of 3 have 1 closer to TR
        rmPlaceObjectDefAtLoc(topMine, 0, 0.85, 0.68, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.9, 0.45, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.69, 0.49, 1);
        
        //bot mines of 3 have 1 closer to TR
        rmPlaceObjectDefAtLoc(topMine, 0, 0.15, 0.32, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.1, 0.55, 1);
        rmPlaceObjectDefAtLoc(topMine, 0, 0.31, 0.51, 1);
    }    

}


	rmSetStatusText("",0.80);

	// Forest areas
	if (rmGetIsTreaty() == true)
		numTries=6+2*cNumberNonGaiaPlayers;
	else
	{
		if (cNumberNonGaiaPlayers > 4)
			numTries=2+4*cNumberNonGaiaPlayers;
		else
			numTries=6+6*cNumberNonGaiaPlayers;
	}
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestID=rmCreateArea("forestID"+i, westIslandID);
			rmSetAreaWarnFailure(forestID, false);
			rmSetAreaObeyWorldCircleConstraint(forestID, true);
			rmSetAreaSize(forestID, rmAreaTilesToFraction(77), rmAreaTilesToFraction(99));
			rmSetAreaForestType(forestID, "NW Territory Birch Forest");
			rmSetAreaForestDensity(forestID, 0.777);
			rmSetAreaForestClumpiness(forestID, 0.6);		
			rmSetAreaForestUnderbrush(forestID, 0.6);
			rmSetAreaCoherence(forestID, 0.4);
	//		rmSetAreaSmoothDistance(forestID, 10);
			rmAddAreaToClass(forestID, rmClassID("classForest"));
			if (rmGetIsTreaty() == true)
			{
				rmAddAreaConstraint(forestID, longPlayerConstraint);  
			}
			else
			{
				rmAddAreaConstraint(forestID, playerConstraint);  
			}
			rmAddAreaConstraint(forestID, avoidForest);
			rmAddAreaConstraint(forestID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestID, avoidKOTH);
			if(cNumberNonGaiaPlayers==2)
                rmAddAreaConstraint(forestID, avoidCoinShort);
			rmAddAreaConstraint(forestID, avoidCliff);
			rmAddAreaConstraint(forestID, avoidAll);
			if(rmBuildArea(forestID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==10)
					break;
			}
			else
				failCount=0; 
		}

	if (rmGetIsTreaty() == true)
		numTries=6+2*cNumberNonGaiaPlayers;
	else
	{
		if (cNumberNonGaiaPlayers > 4)
			numTries=2+4*cNumberNonGaiaPlayers;
		else
			numTries=6+6*cNumberNonGaiaPlayers; 
	}
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestEastID=rmCreateArea("forestEastID"+i, eastIslandID);
			rmSetAreaWarnFailure(forestEastID, false);
			rmSetAreaObeyWorldCircleConstraint(forestEastID, true);
			rmSetAreaSize(forestEastID, rmAreaTilesToFraction(77), rmAreaTilesToFraction(99));
			rmSetAreaForestType(forestEastID, "NW Territory Birch Forest");
			rmSetAreaForestDensity(forestEastID, 0.777);
			rmSetAreaForestClumpiness(forestEastID, 0.6);		
			rmSetAreaForestUnderbrush(forestEastID, 0.6);
			rmSetAreaCoherence(forestEastID, 0.4);
	//		rmSetAreaSmoothDistance(forestEastID, 10);
			rmAddAreaToClass(forestEastID, rmClassID("classForest"));
			rmAddAreaConstraint(forestEastID, playerConstraint);
			rmAddAreaConstraint(forestEastID, avoidForest);  
			rmAddAreaConstraint(forestEastID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestEastID, avoidKOTH);
            if(cNumberNonGaiaPlayers==2)
                rmAddAreaConstraint(forestEastID, avoidCoinShort);
			rmAddAreaConstraint(forestEastID, avoidCliff);
			rmAddAreaConstraint(forestEastID, avoidAll);
			if(rmBuildArea(forestEastID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==10)
					break;
			}
			else
				failCount=0; 
		}

	if (rmGetIsTreaty() == true)
		numTries=6+2*cNumberNonGaiaPlayers;
	else
	{
		if (cNumberNonGaiaPlayers > 4)
			numTries=2+4*cNumberNonGaiaPlayers;
		else
			numTries=8+8*cNumberNonGaiaPlayers;  
	}
	failCount=0;
	for (i=0; <numTries)
		{   
			int forestRandomID=rmCreateArea("forestRandomID"+i);
			rmSetAreaWarnFailure(forestRandomID, false);
			rmSetAreaSize(forestRandomID, rmAreaTilesToFraction(77), rmAreaTilesToFraction(99));
			rmSetAreaForestType(forestRandomID, "NW Territory Birch Forest");
			rmSetAreaForestDensity(forestRandomID, 0.789);
			rmSetAreaForestClumpiness(forestRandomID, 0.789);		
			rmSetAreaForestUnderbrush(forestRandomID, 0.4);
			rmSetAreaCoherence(forestRandomID, 0.4);
	//		rmSetAreaSmoothDistance(forestRandomID, 10);
			rmAddAreaToClass(forestRandomID, rmClassID("classForest"));
			rmAddAreaConstraint(forestRandomID, avoidForest); 
			rmAddAreaConstraint(forestRandomID, shortAvoidImportantItem);
			rmAddAreaConstraint(forestRandomID, playerConstraint);
			rmAddAreaConstraint(forestRandomID, avoidKOTH);
            if(cNumberNonGaiaPlayers==2)
                rmAddAreaConstraint(forestRandomID, avoidCoinShort);
			rmAddAreaConstraint(forestRandomID, avoidCliff);
			rmAddAreaConstraint(forestRandomID, avoidAll);
			if(rmBuildArea(forestRandomID)==false)
			{
				// Stop trying once we fail 5 times in a row.
				failCount++;
				if(failCount==10)
					break;
			}
			else
				failCount=0; 
		}

	// Text
	// Resources that can be placed after forests
	// Text
	
if(cNumberNonGaiaPlayers>2){

    int pronghornHunts = rmCreateObjectDef("pronghornHunts");
	if (rmGetIsTreaty() == true)
		rmAddObjectDefItem(pronghornHunts, "deer", 10, 4.0);
	else
		rmAddObjectDefItem(pronghornHunts, "deer", 8, 3.0);
	rmSetObjectDefCreateHerd(pronghornHunts, true);
	rmSetObjectDefMinDistance(pronghornHunts, 0);
	rmSetObjectDefMaxDistance(pronghornHunts, rmXFractionToMeters(0.45));
	rmAddObjectDefConstraint(pronghornHunts, circleConstraint2);
	rmAddObjectDefConstraint(pronghornHunts, avoidTownCenterMore);
	rmAddObjectDefConstraint(pronghornHunts, avoidHunt);
    rmAddObjectDefConstraint(pronghornHunts, avoidAll);
    rmAddObjectDefConstraint(pronghornHunts, avoidNativesFar2);
    rmAddObjectDefConstraint(pronghornHunts, avoidSocket2);
    rmAddObjectDefConstraint(pronghornHunts, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(pronghornHunts, avoidKOTH);
	rmPlaceObjectDefAtLoc(pronghornHunts, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.90);

}else{
//1v1 hunts
    int mapHunts = rmCreateObjectDef("mapHunts");
	if (rmGetIsTreaty() == true)
	    rmAddObjectDefItem(mapHunts, "deer", 10, 4.0);
    else
		rmAddObjectDefItem(mapHunts, "deer", rmRandInt(8,8), 3.0);
    rmSetObjectDefCreateHerd(mapHunts, true);
    rmSetObjectDefMinDistance(mapHunts, 0);
    rmSetObjectDefMaxDistance(mapHunts, 20);
    rmAddObjectDefConstraint(mapHunts, avoidSocket2);
    rmAddObjectDefConstraint(mapHunts, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapHunts, forestConstraintShort);	
    rmAddObjectDefConstraint(mapHunts, avoidHunt2);
    rmAddObjectDefConstraint(mapHunts, avoidAll);       
    rmAddObjectDefConstraint(mapHunts, avoidCoinShort);       
    rmAddObjectDefConstraint(mapHunts, avoidTownCenterFar);       
    rmAddObjectDefConstraint(mapHunts, circleConstraint2);   
    rmAddObjectDefConstraint(mapHunts, avoidWater6);  
    rmAddObjectDefConstraint(mapHunts, avoidKOTH);  
    
    int mapElk = rmCreateObjectDef("mapElk");
	if (rmGetIsTreaty() == true)
	    rmAddObjectDefItem(mapElk, "deer", 10, 4.0);
    else
		rmAddObjectDefItem(mapElk, "turkey", rmRandInt(8,8), 3.0);
    rmSetObjectDefCreateHerd(mapElk, true);
    rmSetObjectDefMinDistance(mapElk, 0);
    rmSetObjectDefMaxDistance(mapElk, 20);
    rmAddObjectDefConstraint(mapElk, avoidSocket2);
    rmAddObjectDefConstraint(mapElk, avoidTradeRouteSmall);
    rmAddObjectDefConstraint(mapElk, forestConstraintShort);	
    rmAddObjectDefConstraint(mapElk, avoidHunt3);
    rmAddObjectDefConstraint(mapElk, avoidAll);       
    rmAddObjectDefConstraint(mapElk, circleConstraint2);    
    rmAddObjectDefConstraint(mapElk, avoidWater6);    
    rmAddObjectDefConstraint(mapElk, avoidKOTH);    
    /*
    int marker1 = rmCreateArea("marker1");
    rmSetAreaSize(marker1, 0.01, 0.01);
    rmSetAreaLocation(marker1, 0.25, 0.15);
    rmSetAreaBaseHeight(marker1, 2.0);
    rmSetAreaCoherence(marker1, 1.0);
    rmSetAreaTerrainType(marker1, "texas\ground4_tex");
    rmBuildArea(marker1); 

    int marker2 = rmCreateArea("marker2");
    rmSetAreaSize(marker2, 0.01, 0.01);
    rmSetAreaLocation(marker2, 0.75, 0.85);
    rmSetAreaBaseHeight(marker2, 2.0);
    rmSetAreaCoherence(marker2, 1.0);
    rmSetAreaTerrainType(marker2, "texas\ground4_tex");
    rmBuildArea(marker2);*/
    
    //second turkey hunt behind base
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.25, 0.15, 1);   
    rmPlaceObjectDefAtLoc(mapElk, 0, 0.75, 0.85, 1);
    
int huntVariation = rmRandInt(1,2);
    //huntVariation = 1; //test
    //hunts of 3 have 2 closer to TR
    if(huntVariation == 1){
        //hunts of 3 top
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.65, 0.55, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.85, 0.35, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.85, 0.6, 1);
        //hunts of 3 bot
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.35, 0.45, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.15, 0.65, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.15, 0.4, 1);
    }else{
        //top hunts of 3 have 1 closer to TR
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.85, 0.68, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.9, 0.45, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.69, 0.49, 1);
        
        //bot hunts of 3 have 1 closer to TR
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.15, 0.32, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.1, 0.55, 1);
        rmPlaceObjectDefAtLoc(mapHunts, 0, 0.31, 0.51, 1);
    }
    //hunts behind native
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.6, 0.1, 1);   
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.4, 0.9, 1);
    //hunts in front of native
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.45, 0.65, 1);   
    rmPlaceObjectDefAtLoc(mapHunts, 0, 0.55, 0.35, 1);  
    
}

	// Define and place Nuggets
	if (rmRandFloat(0,1) < 0.25)  //only try to place nuts 25% of the time
		{
		int nuggetnutsID= rmCreateObjectDef("nugget nuts"); 
		rmAddObjectDefItem(nuggetnutsID, "Nugget", 1, 0.0);
		if (rmGetIsTreaty() == true)
	        rmSetNuggetDifficulty(3, 3);
        else
			rmSetNuggetDifficulty(4, 4);
		rmSetObjectDefMinDistance(nuggetnutsID, 0.0);
		rmSetObjectDefMaxDistance(nuggetnutsID, rmXFractionToMeters(0.2));
  		rmAddObjectDefConstraint(nuggetnutsID, avoidNugget);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidTownCenterFar);
		rmAddObjectDefConstraint(nuggetnutsID, mediumShortAvoidImpassableLand);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidAll);
  		rmAddObjectDefConstraint(nuggetnutsID, avoidImpassableLand);
      rmAddObjectDefConstraint(nuggetnutsID, playerEdgeConstraint);
      rmAddObjectDefConstraint(nuggetnutsID, avoidKOTH);
	  if (cNumberNonGaiaPlayers > 4)
		rmPlaceObjectDefAtLoc(nuggetnutsID, 0, 0.5, 0.5, cNumberNonGaiaPlayers/2);
		}

		int nuggethard2ID= rmCreateObjectDef("nugget hard2"); 
		rmAddObjectDefItem(nuggethard2ID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmSetObjectDefMinDistance(nuggethard2ID, 0.0);
		rmSetObjectDefMaxDistance(nuggethard2ID, rmXFractionToMeters(0.30));
  		rmAddObjectDefConstraint(nuggethard2ID, stayS);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidNugget);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidTownCenterFar);
		rmAddObjectDefConstraint(nuggethard2ID, mediumShortAvoidImpassableLand);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidAll);
  		rmAddObjectDefConstraint(nuggethard2ID, avoidImpassableLand);
      rmAddObjectDefConstraint(nuggethard2ID, playerEdgeConstraint);
      rmAddObjectDefConstraint(nuggethard2ID, avoidKOTH);
		if (cNumberNonGaiaPlayers > 2)
			rmPlaceObjectDefAtLoc(nuggethard2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	int nuggethardID= rmCreateObjectDef("nugget hard"); 
		rmAddObjectDefItem(nuggethardID, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(3, 3);
		rmSetObjectDefMinDistance(nuggethardID, 0.0);
		rmSetObjectDefMaxDistance(nuggethardID, rmXFractionToMeters(0.30));
  		rmAddObjectDefConstraint(nuggethardID, stayN);
  		rmAddObjectDefConstraint(nuggethardID, avoidNugget);
  		rmAddObjectDefConstraint(nuggethardID, avoidTownCenterFar);
		rmAddObjectDefConstraint(nuggethardID, mediumShortAvoidImpassableLand);
  		rmAddObjectDefConstraint(nuggethardID, avoidAll);
		rmAddObjectDefConstraint(nuggethardID, playerEdgeConstraint);
  		rmAddObjectDefConstraint(nuggethardID, avoidImpassableLand);
  		rmAddObjectDefConstraint(nuggethardID, avoidKOTH);
		if (cNumberNonGaiaPlayers > 2)
			rmPlaceObjectDefAtLoc(nuggethardID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

	// Symmetrical Nuggets - from Riki (thx)
	int nugget2AID = -1;
	nugget2AID = rmCreateObjectDef("nugget lvl 2 A");
	rmAddObjectDefItem(nugget2AID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2,2);
	rmSetObjectDefMinDistance(nugget2AID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(nugget2AID, rmXFractionToMeters(0.00));
  	rmAddObjectDefConstraint(nugget2AID, avoidNugget);
  	rmAddObjectDefConstraint(nugget2AID, avoidTownCenterFar);
	rmAddObjectDefConstraint(nugget2AID, mediumShortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nugget2AID, avoidAll);
	rmAddObjectDefConstraint(nugget2AID, avoidKOTH);

	int nugget2BID = -1;
	nugget2BID = rmCreateObjectDef("nugget lvl 2 B");
	rmAddObjectDefItem(nugget2BID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2,2);
	rmSetObjectDefMinDistance(nugget2BID, rmXFractionToMeters(0.00));
	rmSetObjectDefMaxDistance(nugget2BID, rmXFractionToMeters(0.00));

	int nuggetPlacement=0;
	float nuggetPositionX=-1;
	float nuggetPositionZ=-1;
	int resultNugget=0;
	int leaveWhileN=0;

	while (nuggetPlacement < 2*cNumberNonGaiaPlayers)
	{
		nuggetPositionX=rmRandFloat(0.05,0.95);
		nuggetPositionZ=rmRandFloat(0.05,0.95);
		rmSetObjectDefForceFullRotation(nugget2AID, true);
		resultNugget=rmPlaceObjectDefAtLoc(nugget2AID, 0, nuggetPositionX, nuggetPositionZ);
		if (resultNugget == 1)
		{
			rmSetObjectDefForceFullRotation(nugget2BID, true);
			rmPlaceObjectDefAtLoc(nugget2BID, 0, 1.0-nuggetPositionX, 1.0-nuggetPositionZ);
			nuggetPlacement++;
			leaveWhileN=0;
		}
		else
			leaveWhileN++;
		if (leaveWhileN==300)
			break;
	}

	int nuggeteasySID= rmCreateObjectDef("nugget easy S"); 
	rmAddObjectDefItem(nuggeteasySID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasySID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasySID, rmXFractionToMeters(0.45));
  	rmAddObjectDefConstraint(nuggeteasySID, stayS);
  	rmAddObjectDefConstraint(nuggeteasySID, avoidNuggetShort);
  	rmAddObjectDefConstraint(nuggeteasySID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggeteasySID, mediumShortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggeteasySID, avoidAll);
  	rmAddObjectDefConstraint(nuggeteasySID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggeteasySID, avoidKOTH);
	rmPlaceObjectDefAtLoc(nuggeteasySID, 0, 0.5, 0.5, cNumberNonGaiaPlayers+2);

	int nuggeteasyNID= rmCreateObjectDef("nugget easy N"); 
	rmAddObjectDefItem(nuggeteasyNID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(nuggeteasyNID, 0.0);
	rmSetObjectDefMaxDistance(nuggeteasyNID, rmXFractionToMeters(0.45));
  	rmAddObjectDefConstraint(nuggeteasyNID, stayN);
  	rmAddObjectDefConstraint(nuggeteasyNID, avoidNuggetShort);
  	rmAddObjectDefConstraint(nuggeteasyNID, avoidTownCenter);
	rmAddObjectDefConstraint(nuggeteasyNID, mediumShortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nuggeteasyNID, avoidAll);
  	rmAddObjectDefConstraint(nuggeteasyNID, avoidImpassableLand);
	rmAddObjectDefConstraint(nuggeteasyNID, avoidKOTH);
	rmPlaceObjectDefAtLoc(nuggeteasyNID, 0, 0.5, 0.5, cNumberNonGaiaPlayers+2);

rmSetStatusText("",1.0);
}