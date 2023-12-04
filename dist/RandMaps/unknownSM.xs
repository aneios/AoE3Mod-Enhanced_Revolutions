// Unknown - Survival (based on the classic custom map Settler Massacre by Rodonna)
// ported to DE by vividlyplain, September 2022
// special thanks to Enki_

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
	rmSetStatusText("",1.00); 

	rmSetStatusText("",0.90);

	rmSetStatusText("",0.80);
	
	rmSetStatusText("",0.70);

	rmSetStatusText("",0.60);

	rmSetStatusText("",0.50);

	rmSetStatusText("",0.40);

	rmSetStatusText("",0.30);

	rmSetStatusText("",0.20);

	rmSetStatusText("",0.10);

	rmSetStatusText("",0.00);

	// ____________________ Strings ____________________
	int whichMap = rmRandInt(1,16);

	string paintMix1 = "";
	string paintMix2 = "";
	string shineAlight = "";
	
	if (rmRandFloat(0,1) <= 0.001)
	{
		paintMix1 = "unknown funky";
		paintMix2 = "unknown funky";
		shineAlight = "rm_afri_congoBasin";
	}
	else if (whichMap == 1)
	{
		paintMix1 = "amazon grass";
		paintMix2 = "amazon grass dirt";
		shineAlight = "Amazonia_Skirmish";
	}
	else if (whichMap == 2)
	{
		paintMix1 = "california_desert0";
		paintMix2 = "california_desert2";
		shineAlight = "California_Skirmish";
	}
	else if (whichMap == 3)
	{
		paintMix1 = "carolina_grassier";
		paintMix2 = "carolina_grass";
		shineAlight = "Carolina_Skirmish";
	}
	else if (whichMap == 4)
	{
		paintMix1 = "saguenay grass";
		paintMix2 = "saguenay tundra";
		shineAlight = "Saguenay_Skirmish";
	}
	else if (whichMap == 5)
	{
		paintMix1 = "yellow_river_a";
		paintMix2 = "yellow_river_b";
		shineAlight = "yellow_river_wet_skirmish";
	}
	else if (whichMap == 6)
	{
		paintMix1 = "deccan_grassy_dirt_a_noprops";
		paintMix2 = "deccan_dirt_a";
		shineAlight = "deccan_skirmish";
	}
	else if (whichMap == 7)
	{
		paintMix1 = "borneo_grass_a";
		paintMix2 = "borneo_grass_b";
		shineAlight = "borneo_skirmish";
	}
	else if (whichMap == 8)
	{
		paintMix1 = "coastal_japan_b";
		paintMix2 = "coastal_japan_a";
		shineAlight = "honshu_skirmish";
	}
	else if (whichMap == 9)
	{
		paintMix1 = "andes_grass_a";
		paintMix2 = "andes_dirt_a";
		shineAlight = "Andes_Skirmish";
	}
	else if (whichMap == 10)
	{
		paintMix1 = "italy_grass_medium";
		paintMix2 = "italy_grass_dirt";
		shineAlight = "honshu_skirmish";
	}
	else if (whichMap == 11)
	{
		paintMix1 = "italy_north_grass";
		paintMix2 = "italy_north_dirt";
		shineAlight = "honshu_skirmish";
	}
	else if (whichMap == 12)
	{
		paintMix1 = "texas_grass";
		paintMix2 = "texas_grass_Skirmish";
		shineAlight = "texas_skirmish";
	}
	else if (whichMap == 13)
	{
		paintMix1 = "africa east grass dry";
		paintMix2 = "africa east dirt";
		shineAlight = "rm_afri_greatRift";
	}
	else if (whichMap == 14)
	{
		paintMix1 = "africa desert grass medium";
		paintMix2 = "africa desert grass dry";
		shineAlight = "rm_afri_lakeChad";
	}
	else if (whichMap == 15)
	{
		paintMix1 = "africa savanna sand";
		paintMix2 = "africa savanna dirt";
		shineAlight = "rm_afri_sahel";
	}
	else
	{
		paintMix1 = "africa rainforest grass medium";
		paintMix2 = "africa rainforest grass dry";
		shineAlight = "rm_afri_sudd";
	}

	// ____________________ General ____________________
	// Picks the map size
	int playerTiles=10000;
	
	int size=2.0*sqrt(PlayerNum*playerTiles);
	rmSetMapSize(size, size);
	
	// Make the corners
	rmSetWorldCircleConstraint(false);
	
	// Picks a default water height
	rmSetSeaLevel(0.0);	// this is height of river surface compared to surrounding land. River depth is in the river XML.

	// Picks default terrain and water
	rmSetBaseTerrainMix(paintMix1);
	rmTerrainInitialize("grass", 0.0); 
	rmSetMapType("land");
	rmSetLightingSet(shineAlight);

	// Choose Mercs
	chooseMercs();

	int mercCount = 3;
	int sennarMerc = -1;
	int askariMerc = -1;
	int dahomeyMerc = -1;
	int cannoneerMerc = -1;
	int zenataMerc = -1;
	int kanuriMerc = -1;
	int gatCamelMerc = -1;
	int corsairMerc = -1;
	int mamaMerc = -1;
	int mercSwissPike = -1;
	int mercHacka = -1;
	int mercJaeg = -1;
	int mercBombard = -1;
	int mercGiantGren = -1;
	int mercPanda = -1;
	int mercRoyalHorse = -1;
	int mercPistoleer = -1;
	int mercBrigadier = -1;
	int mercMountedRifle = -1;
	int mercBozzer = -1;
	int mercBRider = -1;
	int mercElmetto = -1;
	int mercFusileer = -1;
	int mercHighland = -1;
	int mercHarq = -1;
	int mercLandshark = -1;
	int mercStrad = -1;
	int manchuMerc = -1;
	int ninjaMerc = -1;
	int samMerc = -1;
	int yojimboMerc = -1;
	int jatMerc = -1;
	int ironMerc = -1;

	int outlawCount = 2;
	int crabatOutlaw = -1;
	int hajdukOutlaw = -1;
	int highwayOutlaw = -1;
	int inquisitorOutlaw = -1;
	int cossackOutlaw = -1;
	int thuggeeOutlaw = -1;
	int dacoitOutlaw = -1;
	int spearmanOutlaw = -1;
	int dWarriorOutlaw = -1;
	int dArcherOutlaw = -1;
	int kThrowerOutlaw = -1;
	int dRaiderOutlaw = -1;
	int coloRifleOutlaw = -1;
	int barbMarksmanOutlaw = -1;
	int arsonistOutlaw = -1;
	int buccOutlaw = -1;
	int blowOutlaw = -1;
	int pistoleroOutlaw = -1;
	int renegadoOutlaw = -1;
	int riderOutlaw = -1;
	int pirateOutlaw = -1;
	int blindMonkOutlaw = -1;
	int wokouPirate = -1;
	int cavArcherOutlaw = -1;
	int roninOutlaw = -1;

	// Add Outlaws and Mercs
	rmDisableDefaultMercs(true);
	rmDisableCivTypeMercRestriction(true);

	for(n = 0; < outlawCount) // picks 2 outlaws
	{
		rmEchoInfo("choosing outlaws");
		if (rmRandInt(1,25) == 1 && pistoleroOutlaw != 1)
		{
		    rmEnableOutlaw("SaloonOutlawPistol");
			pistoleroOutlaw = 1;
			rmEchoInfo("outlaw is SaloonOutlawPistol");
		}
		else if (rmRandInt(1,24) == 1 && renegadoOutlaw != 1)
		{
		    rmEnableOutlaw("SaloonOutlawRifleman");
			renegadoOutlaw = 1;
			rmEchoInfo("outlaw is SaloonOutlawRifleman");
		}
		else if (rmRandInt(1,23) == 1 && riderOutlaw != 1)
		{
		    rmEnableOutlaw("SaloonOutlawRider");
			riderOutlaw = 1;
			rmEchoInfo("outlaw is SaloonOutlawRider");
		}
		else if (rmRandInt(1,22) == 1 && pirateOutlaw != 1)
		{
		    rmEnableOutlaw("SaloonPirate");
			pirateOutlaw = 1;
			rmEchoInfo("outlaw is SaloonPirate");
		}
		else if (rmRandInt(1,21) == 1 && blindMonkOutlaw != 1)
		{
		    rmEnableOutlaw("ypWokouBlindMonk");
			blindMonkOutlaw = 1;
			rmEchoInfo("outlaw is ypWokouBlindMonk");
		}
		else if (rmRandInt(1,20) == 1 && cavArcherOutlaw != 1)
		{
		    rmEnableOutlaw("ypWokouWanderingHorseman");
			cavArcherOutlaw = 1;
			rmEchoInfo("outlaw is ypWokouWanderingHorseman");
		}
		else if (rmRandInt(1,19) == 1 && roninOutlaw != 1)
		{
		    rmEnableOutlaw("ypWokouWaywardRonin");
			roninOutlaw = 1;
			rmEchoInfo("outlaw is ypWokouWaywardRonin");
		}
		else if (rmRandInt(1,18) == 1 && wokouPirate != 1)
		{
		    rmEnableOutlaw("ypWokouPirate");
			wokouPirate = 1;
			rmEchoInfo("outlaw is ypWokouPirate");
		}
		else if (rmRandInt(1,17) == 1 && buccOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawBuccaneer");
			buccOutlaw = 1;
			rmEchoInfo("outlaw is deSaloonOutlawBuccaneer");
		}
		else if (rmRandInt(1,16) == 1 && blowOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawBlowgunner");
			blowOutlaw = 1;
			rmEchoInfo("outlaw is deSaloonOutlawBlowgunner");
		}
		else if (rmRandInt(1,15) == 1 && spearmanOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawAfricanSpearman");
			spearmanOutlaw = 1;
			rmEchoInfo("outlaw is deSaloonOutlawAfricanSpearman");
		}
		else if (rmRandInt(1,14) == 1 && dWarriorOutlaw != 1)
		{
		    rmEnableOutlaw("deOutlawDesertWarrior");
			dWarriorOutlaw = 1;
			rmEchoInfo("outlaw is deOutlawDesertWarrior");
		}
		else if (rmRandInt(1,13) == 1 && kThrowerOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawKnifeThrower");
			kThrowerOutlaw = 1;
			rmEchoInfo("outlaw is deSaloonOutlawKnifeThrower");
		}
		else if (rmRandInt(1,12) == 1 && dRaiderOutlaw != 1)
		{
		    rmEnableOutlaw("deOutlawDesertRaider");
			dRaiderOutlaw = 1;
			rmEchoInfo("outlaw is deOutlawDesertRaider");
		}
		else if (rmRandInt(1,11) == 1 && coloRifleOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawColoRifle");
			coloRifleOutlaw = 1;
			rmEchoInfo("outlaw is deSaloonOutlawColoRifle");
		}
		else if (rmRandInt(1,10) == 1 && dArcherOutlaw != 1)
		{
		    rmEnableOutlaw("deOutlawDesertArcher");
			dArcherOutlaw = 1;
			rmEchoInfo("outlaw is deOutlawDesertArcher");
		}
		else if (rmRandInt(1,9) == 1 && barbMarksmanOutlaw != 1)
		{
		    rmEnableOutlaw("deAllegianceBarbaryMarksman");
			barbMarksmanOutlaw = 1;
			rmEchoInfo("outlaw is deAllegianceBarbaryMarksman");
		}
		else if (rmRandInt(1,8) == 1 && dacoitOutlaw != 1)
		{
		    rmEnableOutlaw("ypDacoit");
			dacoitOutlaw = 1;
			rmEchoInfo("outlaw is ypDacoit");
		}
		else if (rmRandInt(1,7) == 1 && thuggeeOutlaw != 1)
		{
		    rmEnableOutlaw("ypThuggee");
			thuggeeOutlaw = 1;
			rmEchoInfo("outlaw is ypThuggee");
		}
		else if (rmRandInt(1,6) == 1 && arsonistOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawArsonist");
			arsonistOutlaw = 1;
			rmEchoInfo("outlaw is deSaloonOutlawArsonist");
		}
		else if (rmRandInt(1,5) == 1 && crabatOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonCrabat");
			crabatOutlaw = 1;
			rmEchoInfo("outlaw is crabat");
		}
		else if (rmRandInt(1,4) == 1 && hajdukOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonHajduk");
			hajdukOutlaw = 1;
			rmEchoInfo("outlaw is hajduk");
		}
		else if (rmRandInt(1,3) == 1 && highwayOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonHighwaymanRider");
			highwayOutlaw = 1;
			rmEchoInfo("outlaw is highwayman");
		}
		else if (rmRandInt(1,2) == 1 && inquisitorOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonInquisitor");
			inquisitorOutlaw = 1;
			rmEchoInfo("outlaw is inquisitor");
		}
		else if (cossackOutlaw != 1)
		{
		    rmEnableOutlaw("deSaloonOutlawCossackRider");
			cossackOutlaw = 1;
			rmEchoInfo("outlaw is cossack");
		}
		else
		{
			outlawCount++;	// ensures 2 are always chosen
		}
	}

	for(n = 0; < mercCount)
	{
		rmEchoInfo("choosing mercs");
		if (rmRandInt(1,32) <= 1 && sennarMerc != 1)
		{
			rmEnableMerc("deMercSudaneseRider", -1);
			sennarMerc = 1;
			rmEchoInfo("merc is sennar");
		}
		else if (rmRandInt(1,31) <= 1 && askariMerc != 1)
		{
			rmEnableMerc("deMercAskari", -1);
			askariMerc = 1;
			rmEchoInfo("merc is askari");
		}
		else if (rmRandInt(1,30) <= 1 && dahomeyMerc != 1)
		{
			rmEnableMerc("deMercAmazon", -1);
			dahomeyMerc = 1;
			rmEchoInfo("merc is dahomey");
		}
		else if (rmRandInt(1,29) <= 1 && cannoneerMerc != 1)
		{
			rmEnableMerc("deMercCannoneer", -1);
			cannoneerMerc = 1;
			rmEchoInfo("merc is cannoneer");
		}
		else if (rmRandInt(1,28) <= 1 && zenataMerc != 1)
		{
			rmEnableMerc("deMercZenata", -1);
			zenataMerc = 1;
			rmEchoInfo("merc is zenata");
		}
		else if (rmRandInt(1,27) <= 1 && kanuriMerc != 1)
		{
			rmEnableMerc("deMercKanuri", -1);
			kanuriMerc = 1;
			rmEchoInfo("merc is kanuri");
		}
		else if (rmRandInt(1,26) <= 1 && corsairMerc != 1)
		{
		    rmEnableMerc("MercBarbaryCorsair", -1);
			corsairMerc = 1;
			rmEchoInfo("merc is barb corsair");
		}
		else if (rmRandInt(1,25) <= 1 && mamaMerc != 1)
		{
		    rmEnableMerc("MercMameluke", -1);
			mamaMerc = 1;
			rmEchoInfo("merc is mameluke");
		}
		else if (rmRandFloat(0,1) <= 0.001 && gatCamelMerc != 1)
		{
			rmEnableMerc("deMercGatlingCamel", -1);
			gatCamelMerc = 1;
			rmEchoInfo("merc is gat camel");
		}
		else if (rmRandInt(1,24) <= 1 && manchuMerc != 1)
		{
		    rmEnableMerc("MercManchu", -1);
			manchuMerc = 1;
			rmEchoInfo("merc is manchu");
		}
		else if (rmRandInt(1,23) <= 1 && ninjaMerc != 1)
		{
		    rmEnableMerc("MercNinja", -1);
			ninjaMerc = 1;
			rmEchoInfo("merc is ninja");
		}
		else if (rmRandInt(1,22) <= 1 && samMerc != 1)
		{
		    rmEnableMerc("MercRonin", -1);
			samMerc = 1;
			rmEchoInfo("merc is ronin");
		}
		else if (rmRandInt(1,21) <= 1 && yojimboMerc != 1)
		{
		    rmEnableMerc("ypMercYojimbo", -1);
			yojimboMerc = 1;
			rmEchoInfo("merc is yojimbo");
		}
		else if (rmRandInt(1,20) <= 1 && jatMerc != 1)
		{
		    rmEnableMerc("ypMercJatLancer", -1);
			jatMerc = 1;
			rmEchoInfo("merc is jat lancer");
		}
		else if (rmRandInt(1,19) <= 1 && ironMerc != 1)
		{
		    rmEnableMerc("ypMercIronTroop", -1);
			ironMerc = 1;
			rmEchoInfo("merc is iron troop");
		}
		else if (rmRandInt(1,18) <= 1 && mercSwissPike != 1)
		{
   		    rmEnableMerc("MercSwissPikeman", -1);
			mercSwissPike = 1;
			rmEchoInfo("merc is swiss pike");
		}
		else if (rmRandInt(1,17) <= 1 && mercHacka != 1)
		{
   		    rmEnableMerc("MercHackapell", -1);
			mercHacka = 1;
			rmEchoInfo("merc is hackapell");
		}
		else if (rmRandInt(1,16) <= 1 && mercJaeg != 1)
		{
   		    rmEnableMerc("MercJaeger", -1);
			mercJaeg = 1;
			rmEchoInfo("merc is jaeger");
		}
		else if (rmRandInt(1,15) <= 1 && mercBombard != 1)
		{
   		    rmEnableMerc("MercGreatCannon", -1);
			mercBombard = 1;
			rmEchoInfo("merc is lil bombard");
		}
		else if (rmRandInt(1,14) <= 1 && mercGiantGren != 1)
		{
   		    rmEnableMerc("deMercGrenadier", -1);
			mercGiantGren = 1;
			rmEchoInfo("merc is giant gren");
		}
		else if (rmRandInt(1,13) <= 1 && mercPanda != 1)
		{
   		    rmEnableMerc("deMercPandour", -1);
			mercPanda = 1;
			rmEchoInfo("merc is pandour");
		}
		else if (rmRandInt(1,12) <= 1 && mercRoyalHorse != 1)
		{
   		    rmEnableMerc("deMercRoyalHorseman", -1);
			mercRoyalHorse = 1;
			rmEchoInfo("merc is royal horseman");
		}
		else if (rmRandInt(1,11) <= 1 && mercPistoleer != 1)
		{
   		    rmEnableMerc("deMercPistoleer", -1);
			mercPistoleer = 1;
			rmEchoInfo("merc is pistoleer");
		}
		else if (rmRandInt(1,10) <= 1 && mercBrigadier != 1)
		{
   		    rmEnableMerc("deMercBrigadier", -1);
			mercBrigadier = 1;
			rmEchoInfo("merc is irish");
		}
		else if (rmRandInt(1,9) <= 1 && mercMountedRifle != 1)
		{
   		    rmEnableMerc("deMercMountedRifleman", -1);
			mercMountedRifle = 1;
			rmEchoInfo("merc is mounted rifleman");
		}
		else if (rmRandInt(1,8) <= 1 && mercBozzer != 1)
		{
   		    rmEnableMerc("deMercBosniak", -1);
			mercBozzer = 1;
			rmEchoInfo("merc is bosniak");
		}
		else if (rmRandInt(1,7) <= 1 && mercBRider != 1)
		{
   		    rmEnableMerc("MercBlackRider", -1);
			mercBRider = 1;
			rmEchoInfo("merc is black rider");
		}
		else if (rmRandInt(1,6) <= 1 && mercElmetto != 1)
		{
   		    rmEnableMerc("MercElmeti", -1);
			mercElmetto = 1;
			rmEchoInfo("merc is elmetto");
		}
		else if (rmRandInt(1,5) <= 1 && mercFusileer != 1)
		{
   		    rmEnableMerc("MercFusilier", -1);
			mercFusileer = 1;
			rmEchoInfo("merc is fusilier");
		}
		else if (rmRandInt(1,4) <= 1 && mercHighland != 1)
		{
   		    rmEnableMerc("MercHighlander", -1);
			mercHighland = 1;
			rmEchoInfo("merc is highlander");
		}
		else if (rmRandInt(1,3) <= 1 && mercHarq != 1)
		{
   		    rmEnableMerc("deMercHarquebusier", -1);
			mercHarq = 1;
			rmEchoInfo("merc is harquebusier");
		}
		else if (rmRandInt(1,2) <= 1 && mercLandshark != 1)
		{
   		    rmEnableMerc("MercLandsknecht", -1);
			mercLandshark = 1;
			rmEchoInfo("merc is landshark");
		}
		else if (mercStrad != 1)
		{
   		    rmEnableMerc("MercStradiot", -1);
			mercStrad = 1;
			rmEchoInfo("merc is stradiot");
		}
		else
		{
			mercCount++;	// ensures 3 are always chosen
		}
	}

	// ____________________ Player Placement ____________________
	rmSetTeamSpacingModifier(0.50);
	rmPlacePlayersCircular(0.36, 0.36, 0.0);

	// ____________________ Map Parameters ____________________
	// Continent
	int continentID = rmCreateArea("continent");
	rmSetAreaLocation(continentID, 0.5, 0.5);
	rmSetAreaWarnFailure(continentID, false);
	rmSetAreaSize(continentID,0.99, 0.99);
	rmSetAreaCoherence(continentID, 1.0);
	rmSetAreaBaseHeight(continentID, 0.0);
	rmSetAreaObeyWorldCircleConstraint(continentID, false);
	rmSetAreaMix(continentID, paintMix1);  
	rmSetAreaSmoothDistance(continentID, 4);
	rmSetAreaElevationType(continentID, cElevTurbulence);
	rmSetAreaElevationVariation(continentID, 2.5);
	rmSetAreaBaseHeight(continentID, 0.0);
	rmSetAreaElevationMinFrequency(continentID, 0.09);
	rmSetAreaElevationOctaves(continentID, 3);
	rmSetAreaElevationPersistence(continentID, 0.4);    
	rmBuildArea(continentID); 

	for (i=1; < numPlayer)
	{
		int playerareaID = rmCreateArea("playerarea"+i);
		rmSetPlayerArea(i, playerareaID);
		rmSetAreaSize(playerareaID, rmAreaTilesToFraction(200+50*PlayerNum));
		rmSetAreaLocPlayer(playerareaID, i);
		rmSetAreaCoherence(playerareaID, 0.15);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaMix(playerareaID, paintMix2);
		rmSetAreaWarnFailure(playerareaID, false);
		rmSetAreaObeyWorldCircleConstraint(playerareaID, false);
		rmSetAreaSmoothDistance(playerareaID, 2);
		rmSetAreaElevationType(playerareaID, cElevTurbulence);
		rmSetAreaElevationVariation(playerareaID, 2.5);
		rmSetAreaBaseHeight(playerareaID, 0.0);
		rmSetAreaElevationMinFrequency(playerareaID, 0.09);
		rmSetAreaElevationOctaves(playerareaID, 3);
		rmSetAreaElevationPersistence(playerareaID, 0.4);    
		rmBuildArea(playerareaID);
	}

	if (rmGetIsKOTH() == true)
	{
		// Place King's Hill
		float xLoc = 0.5;
		float yLoc = 0.5;
		float walk = 0.0;

		ypKingsHillPlacer(xLoc, yLoc, walk, 0);
		rmEchoInfo("XLOC = "+xLoc);
		rmEchoInfo("XLOC = "+yLoc);
	}

	// ____________________ Starting Resources ____________________
	// Town center & units
	int TCID = rmCreateObjectDef("player TC");
	rmAddObjectDefItem(TCID, "TownCenter", 1, 0.0);
	rmSetObjectDefMinDistance(TCID, 0.0);
	rmSetObjectDefMaxDistance(TCID, 0.0);

	int architectID = rmCreateObjectDef("player architect");
	rmAddObjectDefItem(architectID, "deArchitect", 1, 2.0);
	rmSetObjectDefMinDistance(architectID, 10.0);
	rmSetObjectDefMaxDistance(architectID, 14.0);

	int livestockMktID = rmCreateObjectDef("player livestock market");
	rmAddObjectDefItem(livestockMktID, "deLivestockMarketWagon", 1, 2.0);
	rmSetObjectDefMinDistance(livestockMktID, 10.0);
	rmSetObjectDefMaxDistance(livestockMktID, 14.0);


	int lenlenlenaID = rmCreateObjectDef("len's llama");
	rmAddObjectDefItem(lenlenlenaID, "llama", 1, 2.0);
	rmSetObjectDefMinDistance(lenlenlenaID, 10.0);
	rmSetObjectDefMaxDistance(lenlenlenaID, 14.0);

	for(i=1; <numPlayer)
	{
		// starting shipment to speed up gameplay
		rmSetPlayerResource(i, "Ships", 1);		

		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetPlayerCiv(i) == rmGetCivID("DEItalians"))
			rmPlaceObjectDefAtLoc(architectID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			rmPlaceObjectDefAtLoc(lenlenlenaID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		if (rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians") || rmGetPlayerCiv(i) == rmGetCivID("DEHausa"))
			rmPlaceObjectDefAtLoc(livestockMktID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	for(i = 1; < cNumberPlayers)
	{
		if (rmGetPlayerCiv(i) == rmGetCivID("DEHausa") || rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians"))
		{
			rmCreateTrigger("earlyfields"+i);
			rmSwitchToTrigger(rmTriggerID("earlyfields"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEEarlyFields"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}

		// Enki_'s Lombard nerf <3
        rmCreateTrigger("lombardiaOP"+i);
        rmSwitchToTrigger(rmTriggerID("lombardiaOP"+i));
        rmSetTriggerActive(true);
        rmSetTriggerRunImmediately(true);
        rmSetTriggerPriority(4);
        
        //trModifyProtounitActionUnitType("deLombard", "AutoGatherFoodInvestment", "Wood", i, 2, 0.5, 3);

        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherFoodInvestment");
        rmSetTriggerEffectParam("UnitType", "Wood");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 2);
        rmSetTriggerEffectParamFloat("Delta", 0.5);
        rmSetTriggerEffectParamInt("Relativity", 3);

        //trModifyProtounitActionUnitType("deLombard", "AutoGatherFoodInvestment", "Wood", i, 1, 0.25, 3);

        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherFoodInvestment");
        rmSetTriggerEffectParam("UnitType", "Wood");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 1);
        rmSetTriggerEffectParamFloat("Delta", 0.25);
        rmSetTriggerEffectParamInt("Relativity", 3);

        //trModifyProtounitActionUnitType("deLombard", "AutoGatherFoodInvestment", "Gold", i, 1, 1.25, 3);

        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherFoodInvestment");
        rmSetTriggerEffectParam("UnitType", "Gold");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 1);
        rmSetTriggerEffectParamFloat("Delta", 1.25);
        rmSetTriggerEffectParamInt("Relativity", 3);

        //trModifyProtounitActionUnitType("deLombard", "AutoGatherFoodInvestment", "Gold", i, 2, 0.75, 3);        
        
        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherFoodInvestment");
        rmSetTriggerEffectParam("UnitType", "Gold");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 2);
        rmSetTriggerEffectParamFloat("Delta", 1.1);
        rmSetTriggerEffectParamInt("Relativity", 3);


        //trModifyProtounitActionUnitType("deLombard", "AutoGatherCoinInvestment", "Wood", 1, 2, 0.35, 3);

        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherCoinInvestment");
        rmSetTriggerEffectParam("UnitType", "Wood");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 2);
        rmSetTriggerEffectParamFloat("Delta", 0.35);
        rmSetTriggerEffectParamInt("Relativity", 3);

        //trModifyProtounitActionUnitType("deLombard", "AutoGatherCoinInvestment", "Wood", 1, 1, 0.5, 3);
        
        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherCoinInvestment");
        rmSetTriggerEffectParam("UnitType", "Wood");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 1);
        rmSetTriggerEffectParamFloat("Delta", 0.5);
        rmSetTriggerEffectParamInt("Relativity", 3);
        
        //trModifyProtounitActionUnitType("deLombard", "AutoGatherCoinInvestment", "Food", 1, 1, 1.25, 3);      
        
        rmAddTriggerEffect("Modify Protounit Action Unit Type");
        rmSetTriggerEffectParam("Protounit", "deLombard");
        rmSetTriggerEffectParam("ProtoUnitAction", "AutoGatherCoinInvestment");
        rmSetTriggerEffectParam("UnitType", "Food");
        rmSetTriggerEffectParamInt("PlayerID", i);
        rmSetTriggerEffectParamInt("Field", 1);
        rmSetTriggerEffectParamFloat("Delta", 1.25);
        rmSetTriggerEffectParamInt("Relativity", 3);
	}

} // END