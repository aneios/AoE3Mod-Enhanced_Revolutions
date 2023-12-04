// LARGE PAMPAS SIERRAS
// designed by Garja
// winter version by dicktator_
//Ported by Durokan for DE
// LARGE version by vividlyplain, July 2021
// updated natives and some terrains September 2021, vividlyplain

include "mercenaries.xs";
include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";

// Main entry point for random map script
void main(void)
{

	int TeamNum = cNumberTeams;
	int PlayerNum = cNumberNonGaiaPlayers;
	int numPlayer = cNumberPlayers;

	bool isWinterSeason = false;

	// Text
	// These status text lines are used to manually animate the map generation progress bar
	rmSetStatusText("",0.01);

	// ************************************** GENERAL FEATURES *****************************************

	// Picks the map size
	int playerTiles=22000; //12000
	int size=2.0*sqrt(PlayerNum*playerTiles); //2.1
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Make the corners.
	rmSetWorldCircleConstraint(true);

	// Picks a default water height
	rmSetSeaLevel(2.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	rmSetMapElevationParameters(cElevTurbulence, 0.05, 3, 0.5, 3.5); // type, frequency, octaves, persistence, variation
//	rmSetMapElevationHeightBlend(1);

	if (isWinterSeason == true) {
		rmSetSeaType("Yukon River");
		rmSetBaseTerrainMix("yukon snow"); 
		rmTerrainInitialize("yukon\ground1_yuk", 3.0); //
		rmSetMapType("pampas");
		rmSetMapType("snow");
		rmSetMapType("land");
		rmSetLightingSet("Pampas_Sierras_Winter"); //
	} else {
		// Picks default terrain and water
		rmSetSeaType("pampas river");
		rmSetBaseTerrainMix("pampas_grass"); //
		rmTerrainInitialize("pampas\ground1_pam", 3.0); //
		rmSetMapType("pampas");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("Pampas_Sierras_Skirmish"); //
	}

	string mainTreeType = "TreePolyepis";
	string riverType = "pampas river";
	if (isWinterSeason == true) {
		riverType = "Yukon River";
		mainTreeType = "TreePatagoniaSnow";
	}

	// Choose Mercs
	chooseMercs();

	// Text
	rmSetStatusText("",0.10);

	// Set up Natives
	string natType0 = "";
	string natType1 = "";
	string natGrpName0 = "";
	string natGrpName1 = "";

	int whichNative = rmRandInt(1,6);

	if (whichNative == 1) {
		natType0 = "Mapuche";
		natType1 = "Incas";	// now Quechua
		natGrpName0 = "native mapuche village ";
		natGrpName1 = "native inca village ";
		}
	if (whichNative == 2) {
		natType0 = "Tupi";
		natType1 = "Incas";	// now Quechua
		natGrpName0 = "native tupi village ";
		natGrpName1 = "native inca village ";
		}
	if (whichNative == 3) {
		natType0 = "Mapuche";
		natType1 = "Tupi";
		natGrpName0 = "native mapuche village ";
		natGrpName1 = "native tupi village ";
		}
	if (whichNative == 4) {
		natType1 = "Mapuche";
		natType0 = "Incas";	// now Quechua
		natGrpName1 = "native mapuche village ";
		natGrpName0 = "native inca village ";
		}
	if (whichNative == 5) {
		natType1 = "Tupi";
		natType0 = "Incas";	// now Quechua
		natGrpName1 = "native tupi village ";
		natGrpName0 = "native inca village ";
		}
	if (whichNative == 6) {
		natType1 = "Mapuche";
		natType0 = "Tupi";
		natGrpName1 = "native mapuche village ";
		natGrpName0 = "native tupi village ";
		}

	int subCiv0 = -1;
	int subCiv1 = -1;
	subCiv0 = rmGetCivID(natType0);
	subCiv1 = rmGetCivID(natType1);
	rmSetSubCiv(0, natType0);
	rmSetSubCiv(1, natType1);

	//Define some classes. These are used later for constraints.
	int classPlayer = rmDefineClass("Players");
	int classHill = rmDefineClass("Hills");
	int classPatch = rmDefineClass("patch");
	int classPatch2 = rmDefineClass("patch2");
	int classPatch3 = rmDefineClass("patch3");
	int classPatch4 = rmDefineClass("patch4");
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

	// Text
	rmSetStatusText("",0.20);

	// ************************************* CONTRAINTS *****************************************
	// These are used to have objects and areas avoid each other


	// Cardinal Directions & Map placement
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.47), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidEdgeMore = rmCreatePieConstraint("Avoid Edge More",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.45), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidCenter = rmCreatePieConstraint("Avoid Center",0.4,0.4,rmXFractionToMeters(0.24), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayCenter = rmCreatePieConstraint("Stay Center",0.62,0.38,rmXFractionToMeters(0.0), rmXFractionToMeters(0.20), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int stayEdge = rmCreatePieConstraint("Stay Edge",0.5,0.5,rmXFractionToMeters(0.42), rmXFractionToMeters(0.5), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int northEdge = rmCreatePieConstraint("North Edge",0.70,0.70,rmXFractionToMeters(0.2), rmXFractionToMeters(0.30), rmDegreesToRadians(0),rmDegreesToRadians(90));
//	int avoidWesthalf = rmCreateAreaDistanceConstraint("avoid west", WestID, 185.0);
	int stayTop = rmCreatePieConstraint("SouthHalfConstraint", 0.36, 0.36, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int stayBottom = rmCreatePieConstraint("NorthHalfConstraint", 0.64, 0.64, 0.0, rmZFractionToMeters(0.50), rmDegreesToRadians(315), rmDegreesToRadians(135));


	// Resource avoidance
	int avoidForestFar=rmCreateClassDistanceConstraint("avoid forest far", rmClassID("Forest"), 55.0); //
	int avoidForest=rmCreateClassDistanceConstraint("avoid forest", rmClassID("Forest"), 36.0); //29.0
	int avoidForestShort=rmCreateClassDistanceConstraint("avoid forest short", rmClassID("Forest"), 25.0); //
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("Forest"), 4.0);
	int avoidGuanacoFar = rmCreateTypeDistanceConstraint("avoid guanaco far", "guanaco", 66.0);
	int avoidGuanaco = rmCreateTypeDistanceConstraint("avoid guanaco", "guanaco", 55.0);
	int avoidGuanacoShort = rmCreateTypeDistanceConstraint("avoid guanaco short", "guanaco", 28.0);
	int avoidGuanacoMin = rmCreateTypeDistanceConstraint("avoid guanaco min", "guanaco", 4.0);
	int avoidRheaFar = rmCreateTypeDistanceConstraint("avoid rhea far", "rhea", 64.0);
	int avoidRhea = rmCreateTypeDistanceConstraint("avoid  rhea", "rhea", 44.0);
	int avoidRheaShort = rmCreateTypeDistanceConstraint("avoid  rhea short", "rhea", 30.0);
	int avoidRheaMin = rmCreateTypeDistanceConstraint("avoid rha min", "rhea", 10.0);
	int avoidGoldTypeMin = rmCreateTypeDistanceConstraint("coin avoids coin min ", "gold", 10.0);
	int avoidGoldTypeShort = rmCreateTypeDistanceConstraint("coin avoids coin short", "gold", 12.0);
	int avoidGoldType = rmCreateTypeDistanceConstraint("coin avoids coin ", "gold", 26.0);
	int avoidGoldTypeFar = rmCreateTypeDistanceConstraint("coin avoids coin far ", "gold", 64.0);
	int avoidGoldMin=rmCreateClassDistanceConstraint("min distance vs gold", rmClassID("Gold"), 10.0);
	int avoidGold = rmCreateClassDistanceConstraint ("gold avoid gold med", rmClassID("Gold"), 30.0);
	int avoidGoldFar = rmCreateClassDistanceConstraint ("gold avoid gold far", rmClassID("Gold"), 75.0); //58
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint ("gold avoid gold very far", rmClassID("Gold"), 88.0);
	int avoidNuggetShort = rmCreateTypeDistanceConstraint("nugget avoid nugget short", "AbstractNugget", 30.0);
	int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "AbstractNugget", 64.0);

	int avoidTownCenterVeryFar=rmCreateTypeDistanceConstraint("avoid Town Center Very Far", "townCenter", 65.0);
	int avoidTownCenterFar=rmCreateTypeDistanceConstraint("avoid Town Center Far", "townCenter", 62.0);
	int avoidTownCenter=rmCreateTypeDistanceConstraint("avoid Town Center", "townCenter", 48.0);
	int avoidTownCenterMed=rmCreateTypeDistanceConstraint(" avoid Town Center med", "townCenter", 24.0);
	int avoidTownCenterShort=rmCreateTypeDistanceConstraint(" avoid Town Center short", "townCenter", 20.0);
	int avoidTownCenterResources=rmCreateTypeDistanceConstraint(" avoid Town Center", "townCenter", 40.0);
	int avoidNatives = rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 6.0);
	int avoidNativesFar = rmCreateClassDistanceConstraint("stuff avoids natives far", rmClassID("natives"), 12.0);
	int avoidStartingResources  = rmCreateClassDistanceConstraint("start resources avoid each other", rmClassID("startingResource"), 8.0);
	int avoidStartingResourcesShort  = rmCreateClassDistanceConstraint("start resources avoid each other short", rmClassID("startingResource"), 5.0);
	int avoidLama = rmCreateTypeDistanceConstraint("lama avoid lama", "llama", 55.0+2*PlayerNum);


	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int avoidImpassableLandFar=rmCreateTerrainDistanceConstraint("far avoid impassable land", "Land", false, 10.0);
	int avoidImpassableLandShort = rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int avoidImpassableLandMin = rmCreateTerrainDistanceConstraint("min avoid impassable land", "Land", false, 0.5);
	int avoidImpassableLandMed=rmCreateTerrainDistanceConstraint("medium avoid impassable land", "Land", false, 15.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 15);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 10.0);
	int stayInWater = rmCreateTerrainMaxDistanceConstraint("stay in water ", "water", true, 0.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 3.0);
	int avoidPatch = rmCreateClassDistanceConstraint("patch avoid patch", rmClassID("patch"), 10.0);
	int avoidPatch2 = rmCreateClassDistanceConstraint("patch avoid patch 2", rmClassID("patch2"), 10.0);
	int avoidPatch3 = rmCreateClassDistanceConstraint("patch avoid patch 3", rmClassID("patch3"), 20.0);
	int avoidPatch4 = rmCreateClassDistanceConstraint("patch avoid patch 4", rmClassID("patch4"), 24.0);
	int avoidGrass = rmCreateClassDistanceConstraint("grass avoid grass", rmClassID("grass"), 18.0);
	int avoidCliff = rmCreateClassDistanceConstraint("avoid cliff", rmClassID("Cliffs"), 4.0);
	int avoidCliffMed = rmCreateClassDistanceConstraint("avoid cliff medium", rmClassID("Cliffs"), 8.0);
	int avoidCliffFar = rmCreateClassDistanceConstraint("avoid cliff far", rmClassID("Cliffs"), 14.0);


	// Unit avoidance
	int avoidStartingUnits = rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 35.0);


	// VP avoidance
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 10.0);
	int avoidTradeRouteShort = rmCreateTradeRouteDistanceConstraint("trade route short", 5.0);
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
					rmPlacePlayer(1, 0.28, 0.22,);
					rmPlacePlayer(2, 0.78, 0.72);
				}
				else
				{
					rmPlacePlayer(2, 0.28, 0.22,);
					rmPlacePlayer(1, 0.78, 0.72);
				}

			}
			else if (teamZeroCount == teamOneCount) // equal N of players per TEAM
			{
				if (teamZeroCount == 2) // 2v2
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.10, 0.19); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.56, 0.65); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
				else // 3v3, 4v4
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.075, 0.20); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.55, 0.675); //
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
						rmSetPlacementSection(0.134, 0.136); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						if (teamOneCount == 2)
							rmSetPlacementSection(0.56, 0.65); //
						else
							rmSetPlacementSection(0.55, 0.675); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 2v1, 3v1, 4v1, etc.
					{
						rmSetPlacementTeam(0);
						if (teamZeroCount == 2)
							rmSetPlacementSection(0.10, 0.19); //
						else
							rmSetPlacementSection(0.075, 0.20); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.614, 0.615); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else if (teamZeroCount == 2 || teamOneCount == 2) // one team has 2 players
				{
					if (teamZeroCount < teamOneCount) // 2v3, 2v4, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.10, 0.19); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.55, 0.675); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
					else // 3v2, 4v2, etc.
					{
						rmSetPlacementTeam(0);
						rmSetPlacementSection(0.075, 0.20); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);

						rmSetPlacementTeam(1);
						rmSetPlacementSection(0.56, 0.65); //
						rmSetTeamSpacingModifier(0.25);
						rmPlacePlayersCircular(0.38, 0.38, 0);
					}
				}
				else // 3v4, 4v3, etc.
				{
					rmSetPlacementTeam(0);
					rmSetPlacementSection(0.075, 0.20); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);

					rmSetPlacementTeam(1);
					rmSetPlacementSection(0.55, 0.675); //
					rmSetTeamSpacingModifier(0.25);
					rmPlacePlayersCircular(0.38, 0.38, 0);
				}
			}
		}
		else // FFA
		{
			rmSetPlacementSection(0.075, 0.675);
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.39, 0.39, 0.0);
		}
	

	// **************************************************************************************************

	// Text
	rmSetStatusText("",0.30);

	// ******************************************** MAP LAYOUT AND LANDSCAPE DESIGN **************************************************

	// Plateau template
	int TemplateID = rmCreateArea("plateau template");
	rmSetAreaSize(TemplateID, 0.17, 0.17);
	rmSetAreaWarnFailure(TemplateID, false);
	if (isWinterSeason == true) {
		rmSetAreaMix(TemplateID, "araucania_snow_a");
	}
	//rmSetAreaMix(TemplateID, "rockies_snow");
	rmSetAreaCoherence(TemplateID, 0.75);
	rmSetAreaSmoothDistance(TemplateID, 8);
	rmSetAreaLocation(TemplateID, 0.48, 0.52);
	rmBuildArea(TemplateID);

	int avoidTemplate = rmCreateAreaDistanceConstraint("avoid template", TemplateID, 1.5);

	// Border template
	int Template2ID = rmCreateArea("border template");
	rmSetAreaSize(Template2ID, 0.62, 0.62); // 0,626
	rmSetAreaWarnFailure(Template2ID, false);
	if (isWinterSeason == true) {
		rmSetAreaMix(Template2ID, "araucania_snow_a");
	}
	//rmSetAreaMix(Template2ID, "rockies_snow");
	rmSetAreaCoherence(Template2ID, 0.80);
	rmSetAreaSmoothDistance(Template2ID, 6);
	rmSetAreaLocation(Template2ID, 0.50, 0.50);
	rmBuildArea(Template2ID);

	int avoidTemplate2 = rmCreateAreaDistanceConstraint("avoid template2", Template2ID, 1.5);

	// Plateau
	int plateauID = rmCreateArea("plateau");
	rmSetAreaSize(plateauID, 0.23, 0.23); //0.23, 0.23
	rmSetAreaWarnFailure(plateauID, false);
	rmSetAreaObeyWorldCircleConstraint(plateauID, false);
	if (isWinterSeason == true) {
		rmSetAreaCliffType(plateauID, "rocky mountain2"); // araucania north coast
		//rmSetAreaCliffPainting(plateauID, true, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(plateauID, "rockies\groundforestsnow_roc");
	} else {
		rmSetAreaCliffType(plateauID, "pampas"); // araucania north coast
		//rmSetAreaCliffPainting(plateauID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(plateauID, "pampas\ground1_pam");
	}
	rmSetAreaCliffHeight(plateauID, 4.5, 0.0, 0.8);
	rmSetAreaCliffEdge(plateauID, 5, 0.1, 0.0, 0.34, 1);
	rmSetAreaCoherence(plateauID, 0.75);
	rmSetAreaSmoothDistance(plateauID, 8);
//	rmAddAreaToClass(plateauID, rmClassID("Cliffs"));
	rmSetAreaLocation(plateauID, 0.04, 0.96);
	rmAddAreaConstraint(plateauID, avoidTemplate);
	rmBuildArea(plateauID);

	int avoidPlateau = rmCreateAreaDistanceConstraint("avoid plateau", plateauID, 3);
	int avoidPlateauFar = rmCreateAreaDistanceConstraint("avoid plateau far", plateauID, 30);
	int stayInPlateau = rmCreateAreaMaxDistanceConstraint("stay in plateau", plateauID, 0);
	int avoidRamp = rmCreateCliffRampDistanceConstraint("avoid plateau ramp", plateauID, 10);

	// Rocky border
	int cliffID = rmCreateArea("cliff");
	rmSetAreaSize(cliffID, 0.074, 0.074); //0.075, 0.075
	rmSetAreaWarnFailure(cliffID, false);
	rmSetAreaObeyWorldCircleConstraint(cliffID, false);
	if (isWinterSeason == true) {
		rmSetAreaCliffType(cliffID, "rocky mountain2"); // araucania north coast
		//rmSetAreaCliffPainting(cliffID, true, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(cliffID, "rockies\groundforestsnow_roc");
	} else {
		rmSetAreaCliffType(cliffID, "pampas"); // araucania north coast
		//rmSetAreaCliffPainting(cliffID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(cliffID, "pampas\ground1_pam");
	}
	rmSetAreaCliffHeight(cliffID, 5.5, 0.0, 0.2);
	rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.0, 0.0, 1);
	rmSetAreaCoherence(cliffID, 0.80);
	rmSetAreaSmoothDistance(cliffID, 6);
	rmAddAreaToClass(cliffID, rmClassID("Cliffs"));
	rmSetAreaLocation(cliffID, 0.0, 1.0);
	rmAddAreaConstraint(cliffID, avoidTemplate2);
	rmBuildArea(cliffID);

	int avoidBorder = rmCreateAreaDistanceConstraint("avoid border", cliffID, 6.0+1*PlayerNum);

	// Cliff1
	int cliff1ID = rmCreateArea("cliff1");
	rmSetAreaSize(cliff1ID, 0.0035, 0.0035);
	rmSetAreaWarnFailure(cliff1ID, false);
	rmSetAreaObeyWorldCircleConstraint(cliff1ID, false);
	if (isWinterSeason == true) {
		rmSetAreaCliffType(cliff1ID, "rocky mountain2"); // araucania north coast
		//rmSetAreaCliffPainting(cliff1ID, true, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(cliff1ID, "rockies\groundforestsnow_roc");
	} else {
		rmSetAreaCliffType(cliff1ID, "pampas"); // araucania north coast
		//rmSetAreaCliffPainting(cliff1ID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(cliff1ID, "pampas\ground1_pam");
	}
	rmSetAreaCliffHeight(cliff1ID, 5, 0.0, 0.4);
	rmSetAreaCliffEdge(cliff1ID, 1, 1.0, 0.0, 0.0, 1);
	rmAddAreaToClass(cliff1ID, rmClassID("Cliffs"));
//	rmAddAreaInfluencePoint(cliff1ID, 0.4, 0.86);
	rmSetAreaCoherence(cliff1ID, 0.35);
	rmSetAreaSmoothDistance(cliff1ID, 5);
	rmSetAreaLocation(cliff1ID, rmRandFloat(0.40, 0.41), rmRandFloat(0.84, 0.86));
	rmAddAreaConstraint(cliff1ID, avoidBorder);
	rmAddAreaConstraint(cliff1ID, avoidImpassableLandFar);
	rmBuildArea(cliff1ID);

	// Cliff2
	int cliff2ID = rmCreateArea("cliff2");
	rmSetAreaSize(cliff2ID, 0.0035, 0.0035);
	rmSetAreaWarnFailure(cliff2ID, false);
	rmSetAreaObeyWorldCircleConstraint(cliff2ID, false);
	if (isWinterSeason == true) {
		rmSetAreaCliffType(cliff2ID, "rocky mountain2"); // araucania north coast
		//rmSetAreaCliffPainting(cliff2ID, true, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(cliff2ID, "rockies\groundforestsnow_roc");
	} else {
		rmSetAreaCliffType(cliff2ID, "pampas"); // araucania north coast
		//rmSetAreaCliffPainting(cliff2ID, false, true, true, 0.5 , true); //  paintGround,  paintOutsideEdge,  paintSide,  minSideHeight,  paintInsideEdge
		rmSetAreaTerrainType(cliff2ID, "pampas\ground1_pam");
	}
	rmSetAreaCliffHeight(cliff2ID, 5, 0.0, 0.4);
	rmSetAreaCliffEdge(cliff2ID, 1, 1.0, 0.0, 0.0, 1);
	rmAddAreaToClass(cliff2ID, rmClassID("Cliffs"));
//	rmAddAreaInfluencePoint(cliff2ID, 0.4, 0.86);
	rmSetAreaCoherence(cliff2ID, 0.35);
	rmSetAreaSmoothDistance(cliff2ID, 5);
	rmSetAreaLocation(cliff2ID, rmRandFloat(0.14, 0.16), rmRandFloat(0.57, 0.58));
	rmAddAreaConstraint(cliff2ID, avoidBorder);
	rmAddAreaConstraint(cliff2ID, avoidImpassableLandFar);
	rmBuildArea(cliff2ID);

	//River
	int riverID = rmRiverCreate(-1, riverType, 2, 2, (4+PlayerNum/2), (4+PlayerNum/2)); //
	rmRiverAddWaypoint(riverID, 1.00, 0.50);
	rmRiverAddWaypoint(riverID, 0.66, 0.46);
	rmRiverAddWaypoint(riverID, 0.54, 0.34);
//	rmRiverAddWaypoint(riverID, 0.40, 0.30);
	rmRiverAddWaypoint(riverID, 0.50, 0.00);
//	rmRiverSetBankNoiseParams(riverID, 0.00, 0, 0.0, 0.0, 0.0, 0.0);
	rmRiverSetShallowRadius(riverID, 5+PlayerNum/2);
	if (PlayerNum >= 6)
	{
		rmRiverAddShallow(riverID, 0.20);
		rmRiverAddShallow(riverID, 0.40);
		rmRiverAddShallow(riverID, 0.60);
		rmRiverAddShallow(riverID, 0.80);
	}
	else
	{
		rmRiverAddShallow(riverID, 0.20);
		rmRiverAddShallow(riverID, 0.50);
		rmRiverAddShallow(riverID, 0.80);
	}
	if(TeamNum <= 2)
		rmRiverBuild(riverID);

	// Grass zone
	int grasszoneID = rmCreateArea("grass zone");
	rmSetAreaSize(grasszoneID, 0.60, 0.60); // rmAreaTilesToFraction(5000), rmAreaTilesToFraction(5000));
	rmSetAreaWarnFailure(grasszoneID, false);
	rmSetAreaObeyWorldCircleConstraint(grasszoneID, false);
	if (isWinterSeason == true) {
		rmSetAreaMix(grasszoneID, "araucania_snow_a");
	} else {
		rmSetAreaMix(grasszoneID, "pampas_grassy");
		rmAddAreaTerrainLayer(grasszoneID, "pampas\ground6_pam", 0, 2);
		rmAddAreaTerrainLayer(grasszoneID, "pampas\ground3_pam", 2, 5);
	}
	rmSetAreaCoherence(grasszoneID, 1.0);
	rmSetAreaLocation (grasszoneID, 0.9, 0.1);
	rmSetAreaBaseHeight(grasszoneID, 3.0);
	rmSetAreaElevationType(grasszoneID, cElevTurbulence);
	rmSetAreaElevationVariation(grasszoneID, 3.5);
	rmSetAreaElevationMinFrequency(grasszoneID, 0.05);
	rmSetAreaElevationOctaves(grasszoneID, 3);
	rmSetAreaElevationPersistence(grasszoneID, 0.45);
	rmAddAreaConstraint (grasszoneID, avoidImpassableLand);
	if (TeamNum <= 2)
		rmBuildArea(grasszoneID);

	int avoidGrasszone = rmCreateAreaDistanceConstraint("avoid grass zone", grasszoneID, 6);
	int avoidGrasszoneFar = rmCreateAreaDistanceConstraint("avoid grass zone far", grasszoneID, 12);
	int stayInGrasszone = rmCreateAreaMaxDistanceConstraint("stay in grass zone", grasszoneID, 0);

	// Patches in the plateau
	for (i=0; < 4*PlayerNum)
    {
        int patch1ID = rmCreateArea("plateau patch"+i);
        rmSetAreaWarnFailure(patch1ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch1ID, false);
        rmSetAreaSize(patch1ID, rmAreaTilesToFraction(44), rmAreaTilesToFraction(55));
		if (isWinterSeason == true) {
			rmSetAreaTerrainType(patch1ID, "araucania_snow_b");
		} else {
			rmSetAreaTerrainType(patch1ID, "pampas\ground6_pam");
		}
        rmAddAreaToClass(patch1ID, rmClassID("patch"));
        rmSetAreaMinBlobs(patch1ID, 1);
        rmSetAreaMaxBlobs(patch1ID, 5);
        rmSetAreaMinBlobDistance(patch1ID, 16.0);
        rmSetAreaMaxBlobDistance(patch1ID, 40.0);
        rmSetAreaCoherence(patch1ID, 0.0);
		rmAddAreaConstraint(patch1ID, avoidImpassableLandShort);
		rmAddAreaConstraint(patch1ID, avoidPatch);
		rmAddAreaConstraint(patch1ID, stayInPlateau);
		rmAddAreaConstraint(patch1ID, avoidCliff);
        rmBuildArea(patch1ID);
    }

	// Patches in the grasszone
	for (i=0; < 4*PlayerNum)
    {
        int patch2ID = rmCreateArea("grasszone patch"+i);
        rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch2ID, false);
        rmSetAreaSize(patch2ID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(77));
		if (isWinterSeason == true) {
			rmSetAreaTerrainType(patch2ID, "araucania_snow_a");
		} else {
			rmSetAreaTerrainType(patch2ID, "pampas\ground6_pam");
		}
        rmAddAreaToClass(patch2ID, rmClassID("patch2"));
        rmSetAreaMinBlobs(patch2ID, 1);
        rmSetAreaMaxBlobs(patch2ID, 5);
        rmSetAreaMinBlobDistance(patch2ID, 16.0);
        rmSetAreaMaxBlobDistance(patch2ID, 40.0);
        rmSetAreaCoherence(patch2ID, 0.0);
		rmAddAreaConstraint(patch2ID, avoidImpassableLand);
		rmAddAreaConstraint(patch2ID, avoidPatch2);
		rmAddAreaConstraint(patch2ID, stayInGrasszone);
		if (TeamNum <= 2)
			rmBuildArea(patch2ID);
    }

	// Patches in the main area
	for (i=0; < 5*PlayerNum)
    {
        int patch3ID = rmCreateArea("main area patch"+i);
        rmSetAreaWarnFailure(patch3ID, false);
		rmSetAreaObeyWorldCircleConstraint(patch3ID, false);
        rmSetAreaSize(patch3ID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(77));
		if (isWinterSeason == true) {
			rmSetAreaTerrainType(patch3ID, "araucania_snow_a");
		} else {
			rmSetAreaTerrainType(patch3ID, "pampas\ground4_pam");
		}
        rmAddAreaToClass(patch3ID, rmClassID("patch3"));
        rmSetAreaMinBlobs(patch3ID, 1);
        rmSetAreaMaxBlobs(patch3ID, 5);
        rmSetAreaMinBlobDistance(patch3ID, 16.0);
        rmSetAreaMaxBlobDistance(patch3ID, 40.0);
        rmSetAreaCoherence(patch3ID, 0.0);
		rmAddAreaConstraint(patch3ID, avoidImpassableLandShort);
		rmAddAreaConstraint(patch3ID, avoidPatch3);
		rmAddAreaConstraint(patch3ID, avoidPlateau);
		rmAddAreaConstraint(patch3ID, avoidGrasszone);
        rmBuildArea(patch3ID);
    }

	// Players area
	for (i=1; < numPlayer)
	{
	int playerareaID = rmCreateArea("playerarea"+i);
	rmSetPlayerArea(i, playerareaID);
	rmSetAreaSize(playerareaID, 0.06, 0.06);
	rmSetAreaCoherence(playerareaID, 1.0);
	rmSetAreaWarnFailure(playerareaID, false);
	if (isWinterSeason == true) {
		rmSetAreaMix(playerareaID, "araucania_snow_a");
	}
//	rmSetAreaMix(playerareaID, "rockies_snow");
	rmSetAreaLocPlayer(playerareaID, i);
	rmBuildArea(playerareaID);
	int avoidPlayerArea = rmCreateAreaDistanceConstraint("avoid player area "+i, playerareaID, 2.0);
	int stayInPlayerArea = rmCreateAreaMaxDistanceConstraint("stay in player area "+i, playerareaID, 0.0);
	}

	// ******************************************************************************************************

	// Text
	rmSetStatusText("",0.40);

	// ------------------------------------------------------ KOTH ---------------------------------------------------------------------

	if (rmGetIsKOTH()) {

		int randLoc = rmRandInt(1,3);
		// under cliffs
		float xLoc = 0.4;
		float yLoc = 0.6;
		float walk = 0.01;


		if (randLoc == 2) {
			// center
			xLoc = 0.5;
			yLoc = 0.5;
		} else if (randLoc == 3) {
			// llamas
			xLoc = 0.2;
			yLoc = 0.8;
		}

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// ******************************************** NATIVES *************************************************

	int nativeID0 = -1;
    int nativeID1 = -1;
	int nativeID2 = -1;
    int nativeID3 = -1;

	nativeID0 = rmCreateGrouping("Mapuche village 1", natGrpName0+3); //+5
    rmSetGroupingMinDistance(nativeID0, 0.00);
    rmSetGroupingMaxDistance(nativeID0, 0.00);
//	rmAddGroupingConstraint(nativeID0, avoidImpassableLand);
	rmAddGroupingToClass(nativeID0, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID0, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID0, avoidNatives);
	rmPlaceGroupingAtLoc(nativeID0, 0, 0.36, 0.48);

	nativeID2 = rmCreateGrouping("Mapuche village 2", natGrpName0+2); //+1
    rmSetGroupingMinDistance(nativeID2, 0.00);
    rmSetGroupingMaxDistance(nativeID2, 0.00);
//	rmAddGroupingConstraint(nativeID2, avoidImpassableLand);
	rmAddGroupingToClass(nativeID2, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID2, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID2, avoidNatives);
	rmPlaceGroupingAtLoc(nativeID2, 0, 0.52, 0.64);

	nativeID1 = rmCreateGrouping("Mapuche village 3", natGrpName1+1); // +2
    rmSetGroupingMinDistance(nativeID1, 0.00);
    rmSetGroupingMaxDistance(nativeID1, 0.00);
//  rmAddGroupingConstraint(nativeID1, avoidImpassableLand);
	rmAddGroupingToClass(nativeID1, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID1, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID1, avoidNatives);
	if (TeamNum <= 2)
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.64, 0.10); // 0.28, 0.25
	else
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.52, 0.28); // 0.28, 0.25

	nativeID3 = rmCreateGrouping("Mapuche village 4", natGrpName1+3); // +5
    rmSetGroupingMinDistance(nativeID3, 0.00);
    rmSetGroupingMaxDistance(nativeID3, 0.00);
//  rmAddGroupingConstraint(nativeID3, avoidImpassableLand);
	rmAddGroupingToClass(nativeID3, rmClassID("natives"));
//  rmAddGroupingToClass(nativeID3, rmClassID("importantItem"));
//	rmAddGroupingConstraint(nativeID3, avoidNatives);
	if (TeamNum <= 2)
		rmPlaceGroupingAtLoc(nativeID3, 0, 0.90, 0.36); // 0.28, 0.75
	else
		rmPlaceGroupingAtLoc(nativeID1, 0, 0.72, 0.48); // 0.28, 0.25

	// ******************************************************************************************************

	// Text
	rmSetStatusText("",0.50);

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
	rmSetObjectDefMinDistance(playergoldID, 19.0);
	rmSetObjectDefMaxDistance(playergoldID, 20.0);
	rmAddObjectDefToClass(playergoldID, classStartingResource);
	rmAddObjectDefToClass(playergoldID, classGold);
	rmAddObjectDefConstraint(playergoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergoldID, avoidNatives);
	rmAddObjectDefConstraint(playergoldID, avoidStartingResources);

	// 2nd mine
	int playergold2ID = rmCreateObjectDef("player second mine");
	rmAddObjectDefItem(playergold2ID, "mine", 1, 0);
	rmSetObjectDefMinDistance(playergold2ID, 37.0); //58
	rmSetObjectDefMaxDistance(playergold2ID, 38.0); //62
//	rmAddObjectDefToClass(playergold2ID, classStartingResource);
	rmAddObjectDefToClass(playergold2ID, classGold);
	rmAddObjectDefConstraint(playergold2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(playergold2ID, avoidNatives);
	rmAddObjectDefConstraint(playergold2ID, avoidGoldTypeFar);
	rmAddObjectDefConstraint(playergold2ID, avoidStartingResources);
//	rmAddObjectDefConstraint(playergold2ID, avoidCenter);

	// Starting trees
	int playerTreeID = rmCreateObjectDef("player trees");
	rmAddObjectDefItem(playerTreeID, mainTreeType, rmRandInt(1,2), 1.0);
    rmSetObjectDefMinDistance(playerTreeID, 10);
    rmSetObjectDefMaxDistance(playerTreeID, 16);
	rmAddObjectDefToClass(playerTreeID, classStartingResource);
//	rmAddObjectDefToClass(playerTreeID, classForest);
//	rmAddObjectDefConstraint(playerTreeID, avoidForestShort);
    rmAddObjectDefConstraint(playerTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerTreeID, avoidStartingResourcesShort);

	// Starting herd
	int playerherdID = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem(playerherdID, "rhea", rmRandInt(6,6), 4.0);
	rmSetObjectDefMinDistance(playerherdID, 14.0);
	rmSetObjectDefMaxDistance(playerherdID, 16.0);
	rmSetObjectDefCreateHerd(playerherdID, true);
	rmAddObjectDefToClass(playerherdID, classStartingResource);
	rmAddObjectDefConstraint(playerherdID, avoidImpassableLand);
	rmAddObjectDefConstraint(playerherdID, avoidNatives);
	rmAddObjectDefConstraint(playerherdID, avoidStartingResources);

	// 2nd herd
	int playerherd2ID = rmCreateObjectDef("2nd herd");
    rmAddObjectDefItem(playerherd2ID, "guanaco", rmRandInt(9,10), 6.0);
    rmSetObjectDefMinDistance(playerherd2ID, 26);
    rmSetObjectDefMaxDistance(playerherd2ID, 27);
	rmAddObjectDefToClass(playerherd2ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerherd2ID, true);
	rmAddObjectDefConstraint(playerherd2ID, avoidRhea); //Short
	rmAddObjectDefConstraint(playerherd2ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerherd2ID, avoidNatives);
	rmAddObjectDefConstraint(playerherd2ID, avoidStartingResources);

/*	// 3nd herd
	int playerherd3ID = rmCreateObjectDef("3nd herd");
    rmAddObjectDefItem(playerherd3ID, "guanaco", rmRandInt(7,7), 5.0);
    rmSetObjectDefMinDistance(playerherd3ID, 45);
    rmSetObjectDefMaxDistance(playerherd3ID, 48);
	rmAddObjectDefToClass(playerherd3ID, classStartingResource);
	rmSetObjectDefCreateHerd(playerherd3ID, true);
	rmAddObjectDefConstraint(playerherd3ID, avoidRhea); //Short
	rmAddObjectDefConstraint(playerherd3ID, avoidGuanaco);
	rmAddObjectDefConstraint(playerherd3ID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerherd3ID, avoidNatives);
	rmAddObjectDefConstraint(playerherd3ID, avoidStartingResources);
*/

	// Starting treasures
	int playerNuggetID = rmCreateObjectDef("player nugget");
	rmAddObjectDefItem(playerNuggetID, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(1, 1);
	rmSetObjectDefMinDistance(playerNuggetID, 22.0);
	rmSetObjectDefMaxDistance(playerNuggetID, 26.0);
	rmAddObjectDefToClass(playerNuggetID, classStartingResource);
	rmAddAreaConstraint(playerNuggetID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(playerNuggetID, avoidImpassableLandShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidNatives);
	rmAddObjectDefConstraint(playerNuggetID, avoidStartingResources);
	rmAddObjectDefConstraint(playerNuggetID, avoidNuggetShort);
	rmAddObjectDefConstraint(playerNuggetID, avoidEdge);
	int nugget0count = rmRandInt (1,2); //1,2

	// ******** Place ********

	for(i=1; <numPlayer)
	{
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		vector TCLoc = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TCID, i));

		rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergoldID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playergold2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerberriesID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerTreeID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherdID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
		rmPlaceObjectDefAtLoc(playerherd2ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
//		rmPlaceObjectDefAtLoc(playerherd3ID, i, rmXMetersToFraction(xsVectorGetX(TCLoc)), rmZMetersToFraction(xsVectorGetZ(TCLoc)));
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


	// ********** MINES ***********

	int goldcount = 4*PlayerNum;
	if (PlayerNum >= 4)
		goldcount = 4*PlayerNum-PlayerNum/2;

	for(i=0; < goldcount)
	{
		int extragoldID = rmCreateObjectDef("extra gold"+i);
		rmAddObjectDefItem(extragoldID, "Mine", 1, 0.0);
		rmSetObjectDefMinDistance(extragoldID, rmXFractionToMeters(0.05));
		rmSetObjectDefMaxDistance(extragoldID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(extragoldID, classGold);
		rmAddObjectDefConstraint(extragoldID, avoidImpassableLandFar);
		rmAddObjectDefConstraint(extragoldID, avoidNatives);
		rmAddObjectDefConstraint(extragoldID, avoidGoldFar);
		rmAddObjectDefConstraint(extragoldID, avoidTownCenterFar);
		rmAddObjectDefConstraint(extragoldID, avoidEdge);
		rmAddObjectDefConstraint(extragoldID, avoidWater);
		rmAddObjectDefConstraint(extragoldID, avoidRamp);
		rmAddObjectDefConstraint(extragoldID, avoidCliffFar);
		rmPlaceObjectDefAtLoc(extragoldID, 0, 0.50, 0.50);
	}

	// ****************************

	// Text
	rmSetStatusText("",0.70);

	// ********** FOREST **********

	// Main forest patches
	int mainforestcount = 2*PlayerNum;
	if (PlayerNum >= 4)
		mainforestcount = 2*PlayerNum-PlayerNum/2;
	int stayInForestPatch = -1;

	for (i=0; < mainforestcount)
    {
        int forestpatchID = rmCreateArea("main forest patch"+i);
        rmSetAreaWarnFailure(forestpatchID, false);
		rmSetAreaObeyWorldCircleConstraint(forestpatchID, false);
        rmSetAreaSize(forestpatchID, rmAreaTilesToFraction(230), rmAreaTilesToFraction(250));
		if (isWinterSeason == true) {
			rmSetAreaTerrainType(forestpatchID, "araucania_snow_a");
		} else {
			rmSetAreaTerrainType(forestpatchID, "pampas\groundforest_pam");
		}
//        rmAddAreaToClass(forestpatchID, rmClassID("patch4"));
//		rmAddAreaToClass(forestpatchID, classForest);
        rmSetAreaCoherence(forestpatchID, 0.2);
		rmSetAreaSmoothDistance(forestpatchID, 5);
		rmAddAreaConstraint(forestpatchID, avoidImpassableLandMin);
		rmAddAreaConstraint(forestpatchID, avoidNatives);
//		rmAddAreaConstraint(forestpatchID, avoidPatch4);
		rmAddAreaConstraint(forestpatchID, avoidPlateau);
		rmAddAreaConstraint(forestpatchID, avoidGrasszoneFar);
		rmAddAreaConstraint(forestpatchID, avoidForestFar);
		rmAddAreaConstraint(forestpatchID, avoidTownCenterMed);
		rmAddAreaConstraint(forestpatchID, avoidRamp);
		rmAddAreaConstraint(forestpatchID, avoidGoldTypeMin);
        rmBuildArea(forestpatchID);

		stayInForestPatch = rmCreateAreaMaxDistanceConstraint("stay in forest patch"+i, forestpatchID, 0.0);

		for (j=0; < rmRandInt(19,20))
		{
			int foresttreeID = rmCreateObjectDef("forest trees"+i+j);
			rmAddObjectDefItem(foresttreeID, mainTreeType, rmRandInt(1,1), 3.0);
			rmAddObjectDefItem(foresttreeID, mainTreeType, rmRandInt(1,2), 3.0);
			rmSetObjectDefMinDistance(foresttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(foresttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(foresttreeID, classForest);
		//	rmAddObjectDefConstraint(foresttreeID, avoidForestShort);
			rmAddObjectDefConstraint(foresttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(foresttreeID, stayInForestPatch);
			rmPlaceObjectDefAtLoc(foresttreeID, 0, 0.50, 0.50);
		}
    }

	// Secondary forest
	int secondforestcount = 2*PlayerNum;
	if (PlayerNum >= 4)
		secondforestcount = 2*PlayerNum-PlayerNum/2;
	int stayIn2ndForest = -1;

	for (i=0; < secondforestcount)
	{
		int secondforestID = rmCreateArea("secondary forest"+i);
		rmSetAreaWarnFailure(secondforestID, false);
		rmSetAreaSize(secondforestID, rmAreaTilesToFraction(115), rmAreaTilesToFraction(125));
		if (isWinterSeason == true) {
			rmSetAreaTerrainType(secondforestID, "araucania_snow_a");
		} else {
			rmSetAreaTerrainType(secondforestID, "pampas\groundforest_pam");
		}
		rmSetAreaObeyWorldCircleConstraint(secondforestID, true);
		rmSetAreaCoherence(secondforestID, 0.2);
		rmSetAreaSmoothDistance(secondforestID, 4);
		rmAddAreaConstraint(secondforestID, avoidTownCenterMed);
	//	rmAddAreaToClass(secondforestID, classForest);
		rmAddAreaConstraint(secondforestID, avoidForestFar);
		rmAddAreaConstraint(secondforestID, avoidGoldTypeMin);
		rmAddAreaConstraint(secondforestID, avoidNatives);
		rmAddAreaConstraint(secondforestID, avoidImpassableLandMin);
		rmAddAreaConstraint(secondforestID, avoidPlateau);
		rmAddAreaConstraint(secondforestID, avoidRamp);
		rmAddAreaConstraint(secondforestID, avoidGrasszoneFar);
		rmBuildArea(secondforestID);

		stayIn2ndForest = rmCreateAreaMaxDistanceConstraint("stay in secondary forest"+i, secondforestID, 0);

		for (j=0; < rmRandInt(9,10))
		{
			int secondforesttreeID = rmCreateObjectDef("secondary forest trees"+i+j);
			rmAddObjectDefItem(secondforesttreeID, mainTreeType, rmRandInt(1,2), 2.0);
			rmSetObjectDefMinDistance(secondforesttreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(secondforesttreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(secondforesttreeID, classForest);
		//	rmAddObjectDefConstraint(secondforesttreeID, avoidForestShort);
			rmAddObjectDefConstraint(secondforesttreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(secondforesttreeID, stayIn2ndForest);
			rmPlaceObjectDefAtLoc(secondforesttreeID, 0, 0.50, 0.50);
		}
	}

	// Tree clumps on grass zone
	int grasszonetreecount = 2*PlayerNum;
	if (PlayerNum >= 4)
		grasszonetreecount = 2*PlayerNum-PlayerNum/2;

	for (i=0; < grasszonetreecount)
	{
		int grasszonetreeID = rmCreateArea("grasszone tree"+i);
		rmSetAreaWarnFailure(grasszonetreeID, false);
		rmSetAreaSize(grasszonetreeID, rmAreaTilesToFraction(105), rmAreaTilesToFraction(115));
		if (isWinterSeason == true) {
			rmSetAreaForestType(grasszonetreeID, "Patagonia Snow Forest");
		} else {
			rmSetAreaForestType(grasszonetreeID, "pampas forest");
		}
		rmSetAreaObeyWorldCircleConstraint(grasszonetreeID, false);
		rmSetAreaForestDensity(grasszonetreeID, 0.75);
		rmSetAreaForestClumpiness(grasszonetreeID, 0.30);
		rmSetAreaForestUnderbrush(grasszonetreeID, 0.4);
		rmSetAreaCoherence(grasszonetreeID, 0.2);
		rmSetAreaSmoothDistance(grasszonetreeID, 3);
		rmAddAreaToClass(grasszonetreeID, classForest);
		rmAddAreaConstraint(grasszonetreeID, avoidForestShort);
		rmAddAreaConstraint(grasszonetreeID, avoidGoldTypeMin);
		rmAddAreaConstraint(grasszonetreeID, avoidNativesFar);
		rmAddAreaConstraint(grasszonetreeID, avoidImpassableLand);
		rmAddAreaConstraint(grasszonetreeID, stayInGrasszone);
		if (TeamNum <= 2)
			rmBuildArea(grasszonetreeID);
	}

	// Random trees on the plateau
	for (i=0; < 3*PlayerNum)
		{
			int plateautreeID = rmCreateObjectDef("plateau trees"+i+j);
			rmAddObjectDefItem(plateautreeID, mainTreeType, rmRandInt(1,4), 4.0);
			rmSetObjectDefMinDistance(plateautreeID,  rmXFractionToMeters(0.0));
			rmSetObjectDefMaxDistance(plateautreeID,  rmXFractionToMeters(0.5));
			rmAddObjectDefToClass(plateautreeID, classForest);
			rmAddObjectDefConstraint(plateautreeID, avoidForest);
			rmAddObjectDefConstraint(plateautreeID, avoidGoldTypeMin);
			rmAddObjectDefConstraint(plateautreeID, avoidImpassableLandShort);
			rmAddObjectDefConstraint(plateautreeID, avoidRamp);
			rmAddObjectDefConstraint(plateautreeID, avoidCliffMed);
			rmAddObjectDefConstraint(plateautreeID, stayInPlateau);
			rmPlaceObjectDefAtLoc(plateautreeID, 0, 0.50, 0.50);
		}

	// ********************************

	// Text
	rmSetStatusText("",0.80);

	// ************ HERDS *************

	//Central guanaco
	int centralherdcount = 5*PlayerNum;
	if (PlayerNum >= 4)
		centralherdcount = 5*PlayerNum-PlayerNum/2;

	for(i=0; < centralherdcount)
	{
		int centralguanacoID = rmCreateObjectDef("central herd"+i);
		rmAddObjectDefItem(centralguanacoID, "guanaco", rmRandInt(7,8), 7.0);
		rmSetObjectDefMinDistance(centralguanacoID, rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(centralguanacoID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(centralguanacoID, true);
		rmAddObjectDefConstraint(centralguanacoID, avoidImpassableLand);
		rmAddObjectDefConstraint(centralguanacoID, avoidNatives);
		rmAddObjectDefConstraint(centralguanacoID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(centralguanacoID, avoidForestMin);
//		rmAddObjectDefConstraint(centralguanacoID, avoidPlateau);
		rmAddObjectDefConstraint(centralguanacoID, avoidRamp);
		rmAddObjectDefConstraint(centralguanacoID, avoidGrasszoneFar);
		rmAddObjectDefConstraint(centralguanacoID, avoidTownCenter);
		rmAddObjectDefConstraint(centralguanacoID, avoidGuanacoFar);
		rmAddObjectDefConstraint(centralguanacoID, avoidRhea);
		rmAddObjectDefConstraint(centralguanacoID, avoidEdge);
		rmAddObjectDefConstraint(centralguanacoID, avoidCliff);
		rmPlaceObjectDefAtLoc(centralguanacoID, 0, 0.50, 0.50);
	}

	//Grasszone rhea
	int grasszoneherdcount = 1*PlayerNum;

	for(i=0; < grasszoneherdcount)
	{
		int eastrheaID = rmCreateObjectDef("grasszone herd"+i);
		rmAddObjectDefItem(eastrheaID, "rhea", rmRandInt(9,10), 8.0);
		rmSetObjectDefMinDistance(eastrheaID, rmXFractionToMeters(0.05));
		rmSetObjectDefMaxDistance(eastrheaID, rmXFractionToMeters(0.5));
		rmSetObjectDefCreateHerd(eastrheaID, true);
		rmAddObjectDefConstraint(eastrheaID, avoidImpassableLand);
		rmAddObjectDefConstraint(eastrheaID, avoidNatives);
		rmAddObjectDefConstraint(eastrheaID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(eastrheaID, avoidForestMin);
		if (TeamNum <= 2)
			rmAddObjectDefConstraint(eastrheaID, stayInGrasszone);
		rmAddObjectDefConstraint(eastrheaID, avoidTownCenterFar);
		rmAddObjectDefConstraint(eastrheaID, avoidGuanaco);
		rmAddObjectDefConstraint(eastrheaID, avoidRheaFar);
		rmAddObjectDefConstraint(eastrheaID, avoidEdge);
		rmPlaceObjectDefAtLoc(eastrheaID, 0, 0.80, 0.20);
	}


	// ********************************

	// Text
	rmSetStatusText("",0.90);

	// ********************************

	// Random trees
	for (i=0; < 5*PlayerNum)
	{
		int randomtreeID = rmCreateObjectDef("random tree"+i);
		rmAddObjectDefItem(randomtreeID, mainTreeType, rmRandInt(1,2), 4.0);
		rmAddObjectDefItem(randomtreeID, mainTreeType, rmRandInt(2,3), 6.0);
		rmSetObjectDefMinDistance(randomtreeID,  rmXFractionToMeters(0.0));
		rmSetObjectDefMaxDistance(randomtreeID,  rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(randomtreeID, classForest);
		rmAddObjectDefConstraint(randomtreeID, avoidForestShort);
		rmAddObjectDefConstraint(randomtreeID, avoidGuanacoMin);
		rmAddObjectDefConstraint(randomtreeID, avoidNatives);
		rmAddObjectDefConstraint(randomtreeID, avoidTownCenterMed);
		rmAddObjectDefConstraint(randomtreeID, avoidStartingResources);
		rmAddObjectDefConstraint(randomtreeID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(randomtreeID, avoidImpassableLandMin);
		rmAddObjectDefConstraint(randomtreeID, avoidRamp);
		rmAddObjectDefConstraint(randomtreeID, avoidPlateau);
		rmAddObjectDefConstraint(randomtreeID, avoidGrasszoneFar);
		rmPlaceObjectDefAtLoc(randomtreeID, 0, 0.50, 0.50);
	}

	// ********** TREASURES ***********

	// Treasures lvl4
	int Nugget4ID = rmCreateObjectDef("Nugget lvl 4");
	rmAddObjectDefItem(Nugget4ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget4ID, 0);
    rmSetObjectDefMaxDistance(Nugget4ID, rmXFractionToMeters(0.16));
	rmSetNuggetDifficulty(4,4);
	rmAddObjectDefConstraint(Nugget4ID, avoidNugget);
	rmAddObjectDefConstraint(Nugget4ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget4ID, avoidPlateau);
	rmAddObjectDefConstraint(Nugget4ID, avoidRamp);
	rmAddObjectDefConstraint(Nugget4ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidGuanacoMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidTownCenterFar);
	rmAddObjectDefConstraint(Nugget4ID, avoidForestMin);
	rmAddObjectDefConstraint(Nugget4ID, avoidEdge);
	if (TeamNum <= 2)
		rmAddObjectDefConstraint(Nugget4ID, avoidGrasszone);
	else
		rmAddObjectDefConstraint(Nugget4ID, stayCenter);

	int nugget4count = PlayerNum/3;

	for (i=0; < nugget4count)
	{
		if (PlayerNum >= 4 && rmGetIsTreaty() == false)
			rmPlaceObjectDefAtLoc(Nugget4ID, 0, 0.50, 0.50);
	}

	// Treasures lvl3
	int Nugget3ID = rmCreateObjectDef("Nugget lvl 3");
	rmAddObjectDefItem(Nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget3ID, 0);
    rmSetObjectDefMaxDistance(Nugget3ID, rmXFractionToMeters(0.5));
	rmSetNuggetDifficulty(3,3);
	rmAddObjectDefConstraint(Nugget3ID, avoidNugget);
	rmAddObjectDefConstraint(Nugget3ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget3ID, avoidPlateau);
	rmAddObjectDefConstraint(Nugget3ID, avoidRamp);
	rmAddObjectDefConstraint(Nugget3ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidGuanacoMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidTownCenterFar);
	rmAddObjectDefConstraint(Nugget3ID, avoidForestMin);
	rmAddObjectDefConstraint(Nugget3ID, avoidEdge);
	if (TeamNum <= 2)
		rmAddObjectDefConstraint(Nugget3ID, stayInGrasszone);
	else
			rmAddObjectDefConstraint(Nugget3ID, stayCenter);

	int nugget3count = PlayerNum/2;

	for (i=0; < nugget3count)
	{
		rmPlaceObjectDefAtLoc(Nugget3ID, 0, 0.50, 0.50);
	}

	// Treasures lvl2
	int Nugget2ID = rmCreateObjectDef("Nugget lvl 2");
	rmAddObjectDefItem(Nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(Nugget2ID, 0);
    rmSetObjectDefMaxDistance(Nugget2ID, rmXFractionToMeters(0.5));
	rmSetNuggetDifficulty(2,2);
	rmAddObjectDefConstraint(Nugget2ID, avoidNugget);
	rmAddObjectDefConstraint(Nugget2ID, avoidNatives);
	rmAddObjectDefConstraint(Nugget2ID, avoidPlateau);
	rmAddObjectDefConstraint(Nugget2ID, avoidRamp);
	rmAddObjectDefConstraint(Nugget2ID, avoidImpassableLandFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidGoldTypeMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidGuanacoMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidTownCenterFar);
	rmAddObjectDefConstraint(Nugget2ID, avoidForestMin);
	rmAddObjectDefConstraint(Nugget2ID, avoidEdge);
//	rmAddObjectDefConstraint(Nugget2ID, avoidGrasszone);

	int nugget2count = rmRandInt(4,5)+PlayerNum/2;

	for (i=0; < nugget2count)
	{
		rmPlaceObjectDefAtLoc(Nugget2ID, 0, 0.50, 0.50);
	}


	// ********************************

	// Text
	rmSetStatusText("",0.95);

	// ************ Lamas *************

	int lamacount = 4*PlayerNum;
	if (PlayerNum >= 4)
	lamacount = 4*PlayerNum-PlayerNum/2;

	for (i=0; <lamacount)
	{
		int LamaID = rmCreateObjectDef("llama"+i);
			if (TeamNum <= 2)
			rmAddObjectDefItem(LamaID, "llama", 1, 1.0);
		else
		{
			if (i < lamacount/2)
				rmAddObjectDefItem(LamaID, "llama", 1, 1.0);
			else
				rmAddObjectDefItem(LamaID, "llama", 2, 3.0);
		}
		rmSetObjectDefMinDistance(LamaID, 0.0);
		rmSetObjectDefMaxDistance(LamaID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(LamaID, avoidCliff);
		rmAddObjectDefConstraint(LamaID, avoidRamp);
		rmAddObjectDefConstraint(LamaID, avoidImpassableLandShort);
		if (TeamNum <= 2)
			rmAddObjectDefConstraint(LamaID, stayInPlateau);
		else
		{
			if (i < lamacount/2)
				rmAddObjectDefConstraint(LamaID, stayInPlateau);
			else
				rmAddObjectDefConstraint(LamaID, stayCenter);
		}
		rmAddObjectDefConstraint(LamaID, avoidEdge);
		rmAddObjectDefConstraint(LamaID, avoidLama);
		rmAddObjectDefConstraint(LamaID, avoidTownCenterFar);
		rmAddObjectDefConstraint(LamaID, avoidForestMin);
		rmPlaceObjectDefAtLoc(LamaID, 0, 0.5, 0.5);
	}

	// ********************************

	// ******** Embellishments ********

	// Grasszone underbrush
	for (i=0; < 4*PlayerNum)
	{
		int GrasszoneunderbrushID = rmCreateObjectDef("grasszone underbrush"+i);
		rmAddObjectDefItem(GrasszoneunderbrushID, "UnderbrushPampas", rmRandInt(1,2), 2.0);
		rmSetObjectDefMinDistance(GrasszoneunderbrushID, 0);
		rmSetObjectDefMaxDistance(GrasszoneunderbrushID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(GrasszoneunderbrushID, rmClassID("grass"));
		rmAddObjectDefConstraint(GrasszoneunderbrushID, avoidNatives);
		rmAddObjectDefConstraint(GrasszoneunderbrushID, avoidForestMin);
		rmAddObjectDefConstraint(GrasszoneunderbrushID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(GrasszoneunderbrushID, avoidGrass);
		rmAddObjectDefConstraint(GrasszoneunderbrushID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(GrasszoneunderbrushID, stayInGrasszone);
		if (TeamNum <= 2)
			rmPlaceObjectDefAtLoc(GrasszoneunderbrushID, 0, 0.50, 0.50);
	}

	// Plateau underbrush
	for (i=0; < 10*PlayerNum)
	{
		int PlateauunderbrushID = rmCreateObjectDef("plateau underbrush"+i);
		rmAddObjectDefItem(PlateauunderbrushID, "UnderbrushTexasGrass", rmRandInt(1,2), 2.0);
		rmSetObjectDefMinDistance(PlateauunderbrushID, 0);
		rmSetObjectDefMaxDistance(PlateauunderbrushID, rmXFractionToMeters(0.5));
		rmAddObjectDefToClass(PlateauunderbrushID, rmClassID("grass"));
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidNatives);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidForestMin);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidGoldTypeMin);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidGrass);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidImpassableLandShort);
		rmAddObjectDefConstraint(PlateauunderbrushID, stayInPlateau);
		rmAddObjectDefConstraint(PlateauunderbrushID, avoidCliff);
		rmPlaceObjectDefAtLoc(PlateauunderbrushID, 0, 0.50, 0.50);
	}

	// ********************************

	// Text
	rmSetStatusText("",1.00);

} //END

	