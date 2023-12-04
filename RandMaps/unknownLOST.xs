// LOST in the Unknown
// Land Unknown adapted to Rocket
// ver 11 Jan 2005
// edited by vividlyplain June 2021 to include assets from other regions incorporated since vanilla
// edited by vividlyplain December 2021, new trade route logic, new terrains, and some fun stuff xD
// February 2022 and onward, updated by vivid to include more fun stuff and some added biomes
// special thanks to Ev0lution, Daniel, Enki_ for all the help and inspiration
// LOST version by vividlyplain, September 2022

include "ypAsianInclude.xs";
include "ypKOTHInclude.xs";
include "mercenaries.xs";

void main(void)
{
    int teamZeroCount = rmGetNumberPlayersOnTeam(0);
    int teamOneCount = rmGetNumberPlayersOnTeam(1);

	int trollBar = rmRandInt(1,20);
	int numTries=0;
	int failCount=0;
	int frozenLake = 0;

	// Text
	if (trollBar == 1)
		rmSetStatusText("", 1.00);
	else
		rmSetStatusText("",0.01);

	// ============= Land and Water Configuration =============
	int allLand = 1;
	int sagTest = 1;
	int riverExists = -1;
	int oceanMiddle = -1;
	int oceanOffCenter = -1;
	int oceanRing = -1;
	int plateauMiddle = -1;
	int forestMiddle = -1;
	int blockedMiddle = -1; // used to determine if trade route should be circular.... or square
	int fountainChance = -1;
	int landOnly = -1;
	int floodedLand = -1;
	int fullShallow = -1;
	if (rmRandFloat(0,1) <= 0.15)
		fullShallow = 1;
	
	float landConfig = rmRandFloat(0,1);
	if (rmGetIsTreaty() == true && rmRandFloat(0,1) <= 0.69)
	{
		if (rmRandFloat(0,1) <= 0.69)
			landConfig = rmRandFloat(0.04,0.44);
		else
			landConfig = rmRandFloat(0.85,1);
	}
	if (rmGetIsKOTH() == true)
		landConfig = rmRandFloat(0.04,0.20);
//		landConfig = 0.04;		// for testing
		rmEchoInfo("land configuration = "+landConfig);

// ============= Land and Water Configuration =============
	if (landConfig < 0.05)
	{
		floodedLand = 1;
	}

	else if (landConfig < 0.10 && rmGetIsTreaty() == false)
	{
		oceanRing = 1;
		allLand = -1;
	}

	else if (landConfig < 0.30)
	{
		landOnly = 1;
	}

	else if (landConfig < 0.45)
	{
		allLand = -1;
		riverExists = 1;
	}

	else if (landConfig < 0.65)
	{
		allLand = -1;
		oceanMiddle = 1;
		blockedMiddle = 1;
		if (rmRandFloat(0,1) <= 0.10)
			fountainChance = 1;
	}		

	else if (landConfig < 0.85)
	{
		allLand = -1;
		sagTest = -1;
		oceanOffCenter = 1;
	}
		
	else
	{
		allLand = -1;
		forestMiddle = 1;
	}

	// Set size.
	int playerTiles=11000;
	if (oceanRing == 1)	// big island
	{
		if (cNumberNonGaiaPlayers == 2)
			playerTiles = 20000;
		if (cNumberNonGaiaPlayers > 2)
			playerTiles = 18000;
		if (cNumberNonGaiaPlayers > 4)
			playerTiles = 16000;
		if (cNumberNonGaiaPlayers > 6)
			playerTiles = 14000;
	}
	else
	{
		if (cNumberNonGaiaPlayers == 2)
			playerTiles = 11000;
		if (cNumberNonGaiaPlayers > 2)
			playerTiles = 10300;
		if (cNumberNonGaiaPlayers > 4)
			playerTiles = 9200;
		if (cNumberNonGaiaPlayers > 6)
			playerTiles = 8100;
	}

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);
	rmSetSeaLevel(0.0);
	if (floodedLand != 1)
	rmSetMapElevationParameters(cElevTurbulence, 0.02, rmRandFloat(2, 4), 0.7, 8.0);

	// Choose mercs.
	chooseMercs();
	
// ============= Choose Natives =============
	int subCiv0=-1;
	int subCiv1=-1;
	int subCiv2=-1;
	int subCiv3=-1;
	int subCiv4=-1;
	int subCiv5=-1;
	int subCiv6=-1;
	int subCiv7=-1;
	int subCiv8=-1;
	int subCiv9=-1;
	int subCiv10=-1;
	int subCiv11=-1;
	int subCiv12=-1;
	int subCiv13=-1;
	int subCiv14=-1;
	int subCiv15=-1;
	int subCiv16=-1;
	int subCiv17=-1;
	int subCiv18=-1;
	int subCiv19=-1;
	int subCiv20=-1;
	int subCiv21=-1;
	int subCiv22=-1;
	int subCiv23=-1;
	int subCiv24=-1;
	int subCiv25=-1;
	int subCiv26=-1;
	int subCiv27=-1;
	int subCiv28=-1;
	int subCiv29=-1;
	int subCiv30=-1;
	int subCiv31=-1;
	int subCiv32=-1;
	int subCiv33=-1;
	int subCiv34=-1;
	int subCiv35=-1;
	int subCiv36=-1;
	int subCiv37=-1;
	int subCiv38=-1;
	int subCiv39=-1;
	int subCiv40=-1;
	int subCiv41=-1;

   if (rmAllocateSubCivs(42) == true)
	{
		subCiv0 = rmGetCivID("Aztecs");
		subCiv1 = rmGetCivID("Caribs");
		subCiv2 = rmGetCivID("Cherokee");
		subCiv3 = rmGetCivID("Comanche");
		subCiv4 = rmGetCivID("Cree");
		subCiv5 = rmGetCivID("Incas");	
		subCiv6 = rmGetCivID("Iroquois");
		subCiv7 = rmGetCivID("Lakota");
		subCiv8 = rmGetCivID("Maya");	
		subCiv9 = rmGetCivID("Nootka");
		subCiv10 = rmGetCivID("Seminoles");
		subCiv11 = rmGetCivID("Tupi");	
		subCiv12 = rmGetCivID("Apache");
		subCiv13 = rmGetCivID("Cheyenne");
		subCiv14 = rmGetCivID("Huron");	
		subCiv15 = rmGetCivID("Klamath");
		subCiv16 = rmGetCivID("Navajo");
		subCiv17 = rmGetCivID("Mapuche");	
		subCiv18 = rmGetCivID("Zapotec");
		subCiv19 = rmGetCivID("Bhakti");
		subCiv20 = rmGetCivID("Jesuit");
		subCiv21 = rmGetCivID("Shaolin");
		subCiv22 = rmGetCivID("Sufi");
		subCiv23 = rmGetCivID("Udasi");	
		subCiv24 = rmGetCivID("Zen");
		subCiv25 = rmGetCivID("Akan");
		subCiv26 = rmGetCivID("Berbers");
		subCiv27 = rmGetCivID("Somali");
		subCiv28 = rmGetCivID("Sudanese");
		subCiv29 = rmGetCivID("Yoruba");
		subCiv30 = rmGetCivID("DESPCLenape");
		subCiv31 = rmGetCivID("Saltpeter");
		subCiv32 = rmGetCivID("Bourbon");
		subCiv33 = rmGetCivID("Habsburg");
		subCiv34 = rmGetCivID("Hanover");
		subCiv35 = rmGetCivID("Jagiellon");
		subCiv36 = rmGetCivID("Oldenburg");
		subCiv37 = rmGetCivID("Phanar");
		subCiv38 = rmGetCivID("Vasa");
		subCiv39 = rmGetCivID("Wettin");
		subCiv40 = rmGetCivID("Wittelsbach");
		subCiv41 = rmGetCivID("Tengri");

		rmSetSubCiv(0, "Aztecs");
		rmSetSubCiv(1, "Caribs");
		rmSetSubCiv(2, "Cherokee");
		rmSetSubCiv(3, "Comanche");
		rmSetSubCiv(4, "Cree");
		rmSetSubCiv(5, "Incas");	
		rmSetSubCiv(6, "Iroquois");
		rmSetSubCiv(7, "Lakota");
		rmSetSubCiv(8, "Maya");	
		rmSetSubCiv(9, "Nootka");
		rmSetSubCiv(10, "Seminoles");
		rmSetSubCiv(11, "Tupi");	
		rmSetSubCiv(12, "Apache");
		rmSetSubCiv(13, "Cheyenne");
		rmSetSubCiv(14, "Huron");	
		rmSetSubCiv(15, "Klamath");
		rmSetSubCiv(16, "Navajo");
		rmSetSubCiv(17, "Mapuche");	
		rmSetSubCiv(18, "Zapotec");
		rmSetSubCiv(19, "Bhakti");
		rmSetSubCiv(20, "Jesuit");	
		rmSetSubCiv(21, "Shaolin");
		rmSetSubCiv(22, "Sufi");
		rmSetSubCiv(23, "Udasi");	
		rmSetSubCiv(24, "Zen");
		rmSetSubCiv(25, "Akan");
		rmSetSubCiv(26, "Berbers");
		rmSetSubCiv(27, "Somali");
		rmSetSubCiv(28, "Sudanese");
		rmSetSubCiv(29, "Yoruba");
		rmSetSubCiv(30, "DESPCLenape");
		rmSetSubCiv(31, "Saltpeter");
		rmSetSubCiv(32, "Bourbon");
		rmSetSubCiv(33, "Habsburg");
		rmSetSubCiv(34, "Hanover");
		rmSetSubCiv(35, "Jagiellon");
		rmSetSubCiv(36, "Oldenburg");
		rmSetSubCiv(37, "Phanar");
		rmSetSubCiv(38, "Vasa");
		rmSetSubCiv(39, "Wettin");
		rmSetSubCiv(40, "Wittelsbach");
		rmSetSubCiv(41, "Tengri");
	}

// ============= Base terrain ============= 
	int trollMap = -1;
	int amazonMap = -1;
	int treasureIsle = -1;
	int carolinaMap = -1;
	int saguenayMap = -1;
	int yukonMap = -1;
	int rockiesMap = -1;
	int sonoraMap = -1;
	int californiaMap = -1;
	int caribbeanMap = -1;
	int yellowRiverMap = -1;
	int dekkanMap = -1;
	int himalMap = -1;
	int borneoMap = -1;
	int japanMap = -1;
	int andesMap = -1;
	int africanMap = -1;
	int afrEast = -1;
	int afrRainforest = -1;
	int afrDesert = -1;
	int afrSavanna = -1;
	int euMap = -1;
	int asianMap = -1;
	int africanMerc = -1;
	int africanDesertMerc = -1;
	int americanMerc = -1;
	int mexicanMerc = -1;
	int asianMerc = -1;
	int europeanMerc = -1;
	int southAmMerc = -1;
	int commandPost = -1;
	int heroDog = -1;
	int heroSheep = -1;
	int surgeonScout = -1;
	int campaignHero = rmRandInt(1,1000);
//		campaignHero = 1;	// for testing
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
	int outlawCount = 2;
	int crabatOutlaw = -1;
	int hajdukOutlaw = -1;
	int highwayOutlaw = -1;
	int inquisitorOutlaw = -1;
	int cossackOutlaw = -1;
	int manchuMerc = -1;
	int ninjaMerc = -1;
	int samMerc = -1;
	int yojimboMerc = -1;
	int jatMerc = -1;
	int ironMerc = -1;
	int autoCattle = -1;
	int plymouthMap = -1;
	int naMap = -1;
	int araucMap = -1;
	int bayouMap = -1;
	int mongolMap = -1;
	int nwtMap = -1;
	int saMap = -1;

	string riverName = "";
	string oceanName = "";
	string pondName = "";
	string cliffName = "";
	string forestName = "";
	string landName = "";
	string treeName = "";
	string critterOneName = "";
	string critterTwoName = "";
	string livestockName = "";
	string fishName = "";
	string whaleName = "";
	string toiletPaper = "";
	string mineralz = "";
	string petName1 = "";
	string propz = "";

	float baseTerrain = rmRandFloat(0,1);
//		baseTerrain = 0.67;		// for testing
		rmEchoInfo("base terrain = "+baseTerrain);
	
	if(baseTerrain <= 0.001)	// trollolo
		trollMap = 1;
	else if(baseTerrain <= 0.045)
		amazonMap = 1;
	else if(baseTerrain <= 0.09)
		californiaMap = 1;
	else if(baseTerrain <= 0.135)
		carolinaMap = 1;
	else if(baseTerrain <= 0.18)
		naMap = 1;
	else if(baseTerrain <= 0.225)
		sonoraMap = 1;
	else if(baseTerrain <= 0.27)
		rockiesMap = 1;
	else if(baseTerrain <= 0.315)
		caribbeanMap = 1;
	else if(baseTerrain <= 0.36)
		yellowRiverMap = 1;
	else if(baseTerrain <= 0.405)
		dekkanMap = 1;
	else if(baseTerrain <= 0.45)
		himalMap = 1;
	else if(baseTerrain <= 0.495)
		borneoMap = 1;
	else if(baseTerrain <= 0.54)
		japanMap = 1;
	else if(baseTerrain <= 0.585)
		andesMap = 1;
	else if(baseTerrain <= 0.63)
		araucMap = 1;
	else if(baseTerrain <= 0.675)
		bayouMap = 1;
	else if(baseTerrain <= 0.72)
		mongolMap = 1;
	else if(baseTerrain <= 0.765)
		nwtMap = 1;
	else if(baseTerrain <= 0.86)
		euMap = 1;
	else if(baseTerrain <= 0.895)
		afrEast = 1;
	else if(baseTerrain <= 0.93)
		afrSavanna = 1;
	else if(baseTerrain <= 0.965)
		afrRainforest = 1;
	else
		afrDesert = 1;

	int whichMix = rmRandInt(1,3);
//		whichMix = 1;		// for testing
		rmEchoInfo("which mix = "+whichMix);

	// Bonus Wagon Chooser
	int everyoneGetsAWagon = rmRandInt(950,1000);
//		everyoneGetsAWagon = 993;	// for testing
	rmEchoInfo("everyoneGetsAWagon = "+everyoneGetsAWagon);

	if(trollMap == 1)	// trollolo
	{
		rmEchoInfo("trololo");
		rmSetBaseTerrainMix("unknown funky");
		if (floodedLand != 1)
		rmTerrainInitialize("pampas\ground5_pam", 0);
		rmSetMapType("Sahara");
		rmSetMapType("grass");
		rmSetMapType("land");
	   rmSetLightingSet("rm_afri_congoBasin");
		riverName = "africa rainforest lagoon";
		oceanName = "africa rainforest swamp";
		pondName = "Amazon River";
		cliffName = "Amazon River Bank Muddy";
		forestName = "unknown forest funky";
		if (whichMix == 1)
			landName = "testmix";
		else if (whichMix == 2)
			landName = "scorched_ground";
		else
			landName = "unknown funky";
		treeName = "dePropsTreesAfrica";
		critterOneName = "ypIGCBird";
		critterTwoName = "capybara";
		if (rmRandFloat(0,1) <= 0.50)
			livestockName = "deUnknownWoodCattle";
		else
			livestockName = "deUnknownGoldCattle";
		fishName = "deFishingGround";
		whaleName = "beluga";
		toiletPaper = "water_trail";
		mineralz = "ypSMSaltPeterElephant";	
		if (rmRandFloat(0,1) <= 0.50)
			petName1 = "deQuakerGun";	
		else
			petName1 = "SPCWhiteBuffalo";	
		propz = "PropsMisc";	
		campaignHero = 1;

		// Add Outlaws
		if (rmRandFloat(0,1) <= 0.167)
		{
			rmEnableOutlaw("deOutlawDesertArcher");
			rmEnableOutlaw("deOutlawDesertWarrior");
		}
		else if (rmRandFloat(0,1) <= 0.20)
		{
			rmEnableOutlaw("deOutlawDesertArcher");
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
		}
		else if (rmRandFloat(0,1) <= 0.25)
		{
			rmEnableOutlaw("deOutlawDesertArcher");
			rmEnableOutlaw("deOutlawDesertRaider");
		}
		else if (rmRandFloat(0,1) <= 0.333)
		{
			rmEnableOutlaw("deOutlawDesertWarrior");
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
		}
		else if (rmRandFloat(0,1) <= 0.50)
		{
			rmEnableOutlaw("deOutlawDesertWarrior");
			rmEnableOutlaw("deOutlawDesertRaider");
		}
		else
		{
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
			rmEnableOutlaw("deOutlawDesertRaider");
		}
		africanDesertMerc = 1;
	}

	else if(amazonMap == 1)		// amazonia
	{
		rmEchoInfo("Amazon terrain");
		if (rmRandFloat(0,1) <= 0.05)
			treasureIsle = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("amazon grass");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("amazon grass medium");
		else
			rmSetBaseTerrainMix("amazon grass dirt");
		if (floodedLand != 1)
		rmTerrainInitialize("pampas\ground5_pam", 0);
		rmSetMapType("bayou");
		rmSetMapType("tropical");
		rmSetMapType("land");
	   rmSetLightingSet("Amazonia_Skirmish");
	   if (whichMix == 3)
			riverName = "Amazon Rainforest River Muddy";
		else 
			riverName = "Amazon River";
		oceanName = "Yucatan Coast Alt";
		pondName = "bayou skirmish2";
		if (floodedLand == 1)
			pondName = "Bayou3";
		if (whichMix == 3)
			cliffName = "Amazon River Bank Muddy";
		else
			cliffName = "Amazon";
		forestName = "Amazon Rain Forest";
		if (whichMix == 1)
			landName="amazon grass medium";
		else if (whichMix == 2)
			landName="amazon grass dirt";
		else
			landName="amazon grass";
		treeName = "treeAmazon";
		critterOneName = "capybara";
		critterTwoName = "tapir";
		livestockName = "sheep";
		fishName = "fishMahi";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.10)
			petName1 = "WhiteJaguar ";	
		else
			petName1 = "PetJaguar";	
		propz = "HuariStrongholdAndes";	

	    if (rmRandFloat(0,1) <= 0.50 && everyoneGetsAWagon == 981)
		{
		    // Add Outlaws and Mercs
    		rmDisableDefaultMercs(true);
			rmDisableCivTypeMercRestriction(true);
		    rmEnableOutlaw("deSaloonOutlawBuccaneer");
		    rmEnableOutlaw("deSaloonOutlawBlowgunner");
		    rmEnableOutlaw("deREVGranadero");
			rmEnableMerc("MercRonin", -1);
			rmEnableMerc("MercHackapell", -1);
			rmEnableMerc("MercGreatCannon", -1);
			southAmMerc = 1;
		}
	}

	else if(californiaMap == 1)	// cali
	{
		rmEchoInfo("California terrain");
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("california_grass");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("california_desert2");
		else
			rmSetBaseTerrainMix("california_desert0");
		if (floodedLand != 1)
		rmTerrainInitialize("california\ground6_cal", 0);
		rmSetMapType("california");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("California_Skirmish");
		riverName = "California River";
		oceanName = "California Coast";
		pondName = "Texas Pond";
		cliffName = "California";
		forestName = "California Redwood Chonky Forest";
		landName = "california_grass";
		treeName = "TreeRedwoodChonky";
		critterOneName = "pronghorn";
		critterTwoName = "elk";
		livestockName = "sheep";
		fishName = "fishCod";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "MineGold";
		if (rmRandFloat(0,1) <= 0.50)	
			petName1 = "deSPCUSVolunteer";	
		else
			petName1 = "deMinuteman";	
		propz = "PropGrassFire";	

	    if (rmRandFloat(0,1) <= 0.50 && everyoneGetsAWagon == 981)
		{
		    // Add Outlaws and Mercs
    		rmDisableDefaultMercs(true);
			rmDisableCivTypeMercRestriction(true);
		    rmEnableOutlaw("deSaloonGunslinger");
		    rmEnableOutlaw("deSaloonCowboy");
		    rmEnableOutlaw("deSaloonOwlhoot");
			rmEnableMerc("MercRonin", -1);
			rmEnableMerc("MercHackapell", -1);
			rmEnableMerc("MercGreatCannon", -1);
			americanMerc = 1;
		}
	}

	else if(carolinaMap == 1)	// carolina
	{
		rmEchoInfo("Carolina terrain");
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("carolina_grass");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("carolina_grass_dry");
		else
			rmSetBaseTerrainMix("carolina_grassier");
		if (floodedLand != 1)
		rmTerrainInitialize("pampas\ground5_pam", 0);
		rmSetMapType("carolina");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("Carolina_Skirmish");
		riverName = "Carolina River";
		oceanName = "Texas Coast";
		pondName = "Texas Pond";
		cliffName = "Carolina Inland";
		forestName = "Carolina Pine Forest";
		if (whichMix == 1)
			landName = "carolina_grassier";
		else if (whichMix == 2)
			landName = "carolina_grass";
		else
			landName = "carolina_grass_dry";
		treeName = "treeCarolinaGrass";
		critterOneName = "turkey";
		critterTwoName = "deer";
		livestockName = "sheep";
		fishName = "fishCod";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "deMineCoalBuildable";
		if (rmRandFloat(0,1) <= 0.69)
			petName1 = "IGCDeerUnit";	
		else
		{
			petName1 = "Surgeon";	
			surgeonScout = 1;	
		}
		propz = "EaglesNest";	
	}

	else if(naMap == 1)		// saguenay
	{
		if (whichMix == 1)
		{
			plymouthMap = 1;

			rmSetMapType("plymouth");
			rmSetBaseTerrainMix("plymouth_grass");
			if (floodedLand != 1)
			rmTerrainInitialize("saguenay\ground1_sag", 0);
			rmSetLightingSet("NewEngland_Skirmish");
			riverName = "New England Lake";
			oceanName = "New England Skirmish";
			pondName = "New England Lake";
			forestName = "new england forest";
			landName = "plymouth_grass";
			treeName = "TreeNewEngland";
			critterOneName = "deer";
			critterTwoName = "moose";
			if (rmRandFloat(0,1) >= 0.50)
				petName1 = "TurkeyScout";	
			else
				petName1 = "SPCXPVFSoldier";	
			propz = "TurkeyScout";	
		}
		else if (whichMix == 2)
		{
            rmSetMapType("saguenay");
				rmSetBaseTerrainMix("saguenay grass");
		if (floodedLand != 1)
		rmTerrainInitialize("saguenay\ground1_sag", 0);
	   rmSetLightingSet("Saguenay_Skirmish");
			riverName = "Saguenay Lake";
		oceanName = "Hudson Bay";
		pondName = "Saguenay Lake";
			forestName = "Saguenay Forest";
		landName = "saguenay tundra";
		treeName = "treeSaguenay";
			critterOneName = "moose";
			critterTwoName = "caribou";
			if (rmRandFloat(0,1) <= 0.10)
				petName1 = "SPCWhiteWolf ";	
			else
				petName1 = "PetWolf";	
			propz = "FirewoodPile";	
		}
		else
		{
			yukonMap = 1;
    		rmSetMapType("yukon");
			rmSetBaseTerrainMix("yukon grass");
			if (floodedLand != 1)
			rmTerrainInitialize("saguenay\ground1_sag", 0);
			rmSetLightingSet("Saguenay_Skirmish");
			riverName = "Yukon River";
			oceanName = "Rockies Lake Ice";
			pondName = "Rockies Lake Ice";
			forestName = "Yukon Forest";
			landName = "italy_snow_dirt";
			treeName = "TreeYukonSnow";
			critterOneName = "caribou";
			critterTwoName = "muskox";
			if (rmRandFloat(0,1) <= 0.01)
				petName1 = "PolarBear";	
			else
				petName1 = "FlagBearerDefault";	
			propz = "SnowDrift";	
		}
		rmEchoInfo("Saguenay terrain");
		rmSetMapType("grass");
		rmSetMapType("land");
		cliffName = "New England Inland";
		saguenayMap = 1;
		livestockName = "sheep";
		fishName = "fishSalmon";
		whaleName = "minkeWhale";
		toiletPaper = "dirt";
		mineralz = "MineGold";	
	}

	else if(rockiesMap == 1)	// rockies
	{
		rmEchoInfo("Rockies terrain");
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("italy_snow_grass_blendb");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("rockies_grass_snow");
		else
			rmSetBaseTerrainMix("rockies_grass_snowb");
		if (floodedLand != 1)
		rmTerrainInitialize("rockies\groundsnow1_roc", 0);	
		rmSetMapType("yukon");
		rmSetMapType("land");
		rmSetLightingSet("Rockie_Skirmish");
		riverName = "Yukon River";
			oceanName = "Great Lakes Ice";
		pondName = "Great Lakes Ice";
		cliffName = "Rocky Mountain2";
		forestName = "Rockies Snow Forest";
		if (whichMix == 1)
			landName = "rockies_grass_snowb";
		else if (whichMix == 2)
			landName = "rockies_snow";
		else
			landName = "rockies_grass_snow";
		treeName = "treeRockiesSnow";
		critterOneName = "caribou";
		critterTwoName = "muskOx";
		livestockName = "cow";
		fishName = "fishSardine";
		whaleName = "beluga";
		toiletPaper = "snow";
		mineralz = "MineTin";	
		petName1 = "PetBear";	
		propz = "PropBlizzard";	
	}

	else if(sonoraMap == 1)		// sonora
	{
		rmEchoInfo("Sonora terrain");
		if (rmRandFloat(0,1) <= 0.10)
		{
			rmSetBaseTerrainMix("geometricpatterngrass");
			riverName = "Araucania River";
			oceanName = "Araucania North Coast";
			pondName = "Araucania North Pond";
			forestName = "Araucania Forest";
		}
		else
		{
			if (whichMix == 1)
			{
				rmSetBaseTerrainMix("sonora_dirt");
				riverName = "Sonora River";
				oceanName = "Sonora Coast";
				pondName = "Sonora Coast";
				forestName = "Sonora Forest";
				cliffName = "Sonora";
				landName = "sonora_dirt";
			}
			else if (whichMix == 2)
			{
				rmSetBaseTerrainMix("painteddesert_groundmix_1");
				riverName = "Painted Desert River";
				oceanName = "Painted Desert Coast";
				pondName = "Painted Desert Lake";
				forestName = "Painteddesert Forest";
				cliffName = "Painteddesert";
				landName = "painteddesert_groundmix_1";
			}
			else
			{
				rmSetBaseTerrainMix("painteddesert_groundmix_4");
				riverName = "Painted Desert River";
				oceanName = "Painted Desert Coast";
				pondName = "Painted Desert Lake";
				forestName = "Painteddesert Forest";
				cliffName = "Painteddesert";
				landName = "painteddesert_groundmix_4";
			}
		}
		if (floodedLand != 1)
		rmTerrainInitialize("sonora\ground2_son", 0);
		rmSetMapType("sonora");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("Sonora_Skirmish");
		treeName = "TreePaintedDesert";
		critterOneName = "pronghorn";
		critterTwoName = "bison";
		livestockName = "cow";
		fishName = "FishSalmon";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "MineCopper";	
		petName1 = "SPCFierceCougar";	
		propz = "PropEaglesRocks";	

	    if (rmRandFloat(0,1) <= 0.50 && everyoneGetsAWagon == 981)
		{
		    // Add Outlaws and Mercs
    		rmDisableDefaultMercs(true);
			rmDisableCivTypeMercRestriction(true);
		    rmEnableOutlaw("deSaloonDesperado");
		    rmEnableOutlaw("deSaloonVaquero");
		    rmEnableOutlaw("deSaloonBandido");
			rmEnableMerc("MercRonin", -1);
			rmEnableMerc("MercHackapell", -1);
			rmEnableMerc("MercGreatCannon", -1);
			mexicanMerc = 1;
		}
	}

	else if(caribbeanMap == 1)			// caribbean
	{
		rmEchoInfo("caribbean terrain");
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("caribbeanSkirmish");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("caribbean grass");
		else
			rmSetBaseTerrainMix("california_shoregrass");
		if (floodedLand != 1)
		rmTerrainInitialize("caribbean\ground1_crb", 0);
		rmSetMapType("caribbean");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("Caribbean_Skirmish");
		riverName = "caribbean coast";
		oceanName = "caribbean coast";
		pondName = "africa desert hole"; 
		cliffName = "Caribbean";
		forestName = "Caribbean Palm Forest Skirmish";
		if (whichMix == 1)
			landName = "caribbean grass";
		else if (whichMix == 2)
			landName = "caribbeanSkirmish";
		else
			landName = "caribbean grass";
		treeName = "treeCaribbean";
		critterOneName = "turkey";
		critterTwoName = "deer";
		livestockName = "sheep";
		fishName = "fishTarpon";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "deShipRuins";		
		petName1 = "deGuardBucCaptain";	
		propz = "IGCShipwreck";	
	}

	else if(yellowRiverMap == 1)			// yellow river
	{
		rmEchoInfo("yellow river terrain");
		asianMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("yellow_river_a");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("yellow_river_b");
		else
			rmSetBaseTerrainMix("yellow_river_c");
		if (floodedLand != 1)
		rmTerrainInitialize("Yellow_river\grass2_yellow_riv", 0);
		rmSetMapType("yellowRiver");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("yellow_river_wet_skirmish");
		riverName = "Yellow River Dry";
		oceanName = "Yellow River Wet Sans Fog";
		pondName = "Yellow River Wet Sans Fog"; 
		cliffName = "Yellow River";
		forestName = "Ginkgo Forest";
//		forestName = "Bamboo Forest";	// fog causing lag/fps drop? ... switched to gingko
		if (whichMix == 1)
			landName = "yellow_river_c";
		else if (whichMix == 2)
			landName = "yellow_river_a";
		else
			landName = "yellow_river_b";
//		treeName = "ypTreeBamboo";
		treeName = "ypTreeGinkgo";
		critterOneName = "ypMarcoPoloSheep";
		critterTwoName = "ypIbex";
		livestockName = "ypGoat";
		fishName = "ypFishCatfish";
		whaleName = "MinkeWhale";
		toiletPaper = "water";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.01)
			petName1 = "ypSPCHuang";	
		else if (rmRandFloat(0,1) <= 0.20)
			petName1 = "ypPetPanda";	
		else
			petName1 = "ypPetKomodoDragon";	
		propz = "ypPropsFog";	
	}
	
	else if(dekkanMap == 1)			// dekkan
	{
		rmEchoInfo("dekkan terrain");
		asianMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("deccan_grassy_dirt_a_noprops");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("deccan_grass_b");
		else
			rmSetBaseTerrainMix("deccan_dirt_a");
		if (floodedLand != 1)
		rmTerrainInitialize("Deccan\ground_grass2_deccan", 0);
		rmSetMapType("deccan");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("deccan_skirmish");
		riverName = "Deccan Plateau River";
		if (rmRandFloat(0,1) <= 0.10)
			oceanName = "Deccan Light";
		else
			oceanName = "Yellow River Wet Sans Fog";
		pondName = "Deccan light"; 
		cliffName = "Deccan Plateau";
		forestName = "Deccan Forest";
		if (whichMix == 1)
			landName = "deccan_dirt_a";
		else if (whichMix == 2)
			landName = "deccan_grassy_Dirt_a";
		else
			landName = "deccan_grass_b";
		treeName = "ypTreeDeccan";
		critterOneName = "ypNilgai";
		critterTwoName = "ypSerow";
		if (rmRandFloat(0,1) <= 0.50)
			livestockName = "ypGoatFat";
		else
			livestockName = "ypWaterBuffalo";
		fishName = "ypFishMolaMola";
		whaleName = "MinkeWhale";
		toiletPaper = "water";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.50)
			petName1 = "ypPetWhiteTiger";	
		else
			petName1 = "ypPetTiger";	
		propz = "ypSMSaltpeterElephant";	

	    if (rmRandFloat(0,1) <= 0.69 && everyoneGetsAWagon == 981)
		{
		    // Add Outlaws and Mercs
	    	rmDisableDefaultMercs(true);
			rmDisableCivTypeMercRestriction(true);
		    rmEnableOutlaw("ypDacoit");
		    rmEnableOutlaw("ypThuggee");
		    rmEnableOutlaw("deSaloonOutlawArsonist");

			for(n = 0; < mercCount)
			{
				if (rmRandInt(1,6) <= 1 && manchuMerc != 1)
				{
				    rmEnableMerc("MercManchu", -1);
					manchuMerc = 1;
				}
				else if (rmRandInt(1,5) <= 1 && ninjaMerc != 1)
				{
				    rmEnableMerc("MercNinja", -1);
					ninjaMerc = 1;
				}
				else if (rmRandInt(1,4) <= 1 && samMerc != 1)
				{
				    rmEnableMerc("MercRonin", -1);
					samMerc = 1;
				}
				else if (rmRandInt(1,3) <= 1 && yojimboMerc != 1)
				{
				    rmEnableMerc("ypMercYojimbo", -1);
					yojimboMerc = 1;
				}
				else if (rmRandInt(1,2) <= 1 && jatMerc != 1)
				{
				    rmEnableMerc("ypMercJatLancer", -1);
					jatMerc = 1;
				}
				else if (ironMerc != 1)
				{
				    rmEnableMerc("ypMercIronTroop", -1);
					ironMerc = 1;
				}
				else
				{
					mercCount++;	// ensures 3 are always chosen
				}
			}
			asianMerc = 1;
		}
	}

	else if(himalMap == 1)			// himalayas
	{
		rmEchoInfo("himal terrain");
		asianMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("himalayas_a");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("himalayas_b");
		else
			rmSetBaseTerrainMix("himalayas_c");
		if (floodedLand != 1)
		rmTerrainInitialize("himalayas\ground_dirt2_himal", 0);
		rmSetMapType("silkRoad3");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("HimalayasUpper_skirmish");
		riverName = "Himalayas Lake";
		oceanName = "Rockies Lake Ice";
		pondName = "Himalayas Lake";
		cliffName = "himalayas";
		forestName = "Himalayas Forest";
		if (whichMix == 1)
			landName = "himalayas_a";
		else if (whichMix == 2)
			landName = "himalayas_b";
		else
			landName = "himalayas_c";
		treeName = "ypTreeHimalayas";
		critterOneName = "ypIbex";
		critterTwoName = "ypSerow";
		livestockName = "ypYak";
		fishName = "ypFishTuna";
		whaleName = "MinkeWhale";
		toiletPaper = "water";
		mineralz = "MineGold";	
		petName1 = "ypPetTibetanMacaque";	
		propz = "GroundPropsYukon";	

	    if (rmRandFloat(0,1) <= 0.69 && everyoneGetsAWagon == 981)
		{
		    // Add Outlaws and Mercs
	    	rmDisableDefaultMercs(true);
			rmDisableCivTypeMercRestriction(true);
		    rmEnableOutlaw("ypDacoit");
		    rmEnableOutlaw("ypThuggee");
		    rmEnableOutlaw("deSaloonOutlawArsonist");

			for(n = 0; < mercCount)
			{
				if (rmRandInt(1,6) <= 1 && manchuMerc != 1)
				{
				    rmEnableMerc("MercManchu", -1);
					manchuMerc = 1;
				}
				else if (rmRandInt(1,5) <= 1 && ninjaMerc != 1)
				{
				    rmEnableMerc("MercNinja", -1);
					ninjaMerc = 1;
				}
				else if (rmRandInt(1,4) <= 1 && samMerc != 1)
				{
				    rmEnableMerc("MercRonin", -1);
					samMerc = 1;
				}
				else if (rmRandInt(1,3) <= 1 && yojimboMerc != 1)
				{
				    rmEnableMerc("ypMercYojimbo", -1);
					yojimboMerc = 1;
				}
				else if (rmRandInt(1,2) <= 1 && jatMerc != 1)
				{
				    rmEnableMerc("ypMercJatLancer", -1);
					jatMerc = 1;
				}
				else if (ironMerc != 1)
				{
				    rmEnableMerc("ypMercIronTroop", -1);
					ironMerc = 1;
				}
				else
				{
					mercCount++;	// ensures 3 are always chosen
				}
			}
			asianMerc = 1;
		}
	}

	else if(borneoMap == 1)			// borneo
	{
		rmEchoInfo("borneo terrain");
		asianMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("borneo_grass_a");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("borneo_grass_b");
		else
			rmSetBaseTerrainMix("borneo_sand_a");
		if (floodedLand != 1)
		rmTerrainInitialize("borneo\ground_sand3_borneo", 0);
		rmSetMapType("borneo");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("borneo_skirmish");
		riverName = "Indochina Water";
		oceanName = "Indochina Water";
		pondName = "Indochina Water"; 
		cliffName = "africa rainforest grass";
		forestName = "Borneo Palm Forest";
		if (whichMix == 1)
			landName = "borneo_sand_a";
		else if (whichMix == 2)
			landName = "borneo_grass_a";
		else
			landName = "borneo_grass_b";
		treeName = "ypTreeBorneo";
		critterOneName = "ypSerow";
		critterTwoName = "ypWildElephant";
		livestockName = "ypYak";
		fishName = "ypFishTuna";
		whaleName = "MinkeWhale";
		toiletPaper = "water";
		mineralz = "MineGold";	
		petName1 = "ypPetOrangutan";	
		propz = "ypSMSufiGuy";	
	}

	else if(japanMap == 1)			// japan
	{
		rmEchoInfo("japan terrain");
		asianMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("coastal_japan_b");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("coastal_japan_a");
		else
			rmSetBaseTerrainMix("coastal_japan_c");
		if (floodedLand != 1)
		rmTerrainInitialize("coastal_japan\ground_grass2_co_japan", 0);
		rmSetMapType("Japan");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("honshu_skirmish");
		riverName = "Parallel Rivers Sans Cliff";
		oceanName = "Coastal Japan";
		pondName = "Coastal Japan";
		if (floodedLand == 1)
			pondName = "Parallel Rivers Sans Cliff";
		cliffName = "Coastal Japan";
		forestName = "Coastal Japan Forest";
		if (whichMix == 1)
			landName = "coastal_japan_c";
		else if (whichMix == 2)
			landName = "coastal_japan_b";
		else
			landName = "coastal_japan_a";
		treeName = "ypTreeJapaneseMaple";
		critterOneName = "ypGiantSalamander";
		critterTwoName = "ypSerow";
		livestockName = "ypWaterBuffalo";
		fishName = "ypSquid";
		whaleName = "MinkeWhale";
		toiletPaper = "water";
		mineralz = "MineGold";	
		petName1 = "ypPetSnowMonkey";	
		propz = "ypPropsBlossomFall";	
	}

	else if(andesMap == 1)			// andes
	{
		rmEchoInfo("andes terrain");
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("andes_grass_a");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("andes_dirt_a");
		else
			rmSetBaseTerrainMix("andes_grass_b");
		if (floodedLand != 1)
		rmTerrainInitialize("andes\ground10_and", 0);
		rmSetMapType("bayou");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("Andes_Skirmish");
		riverName = "Andes River";
		oceanName = "africa east lake";
		pondName = "africa east lake"; 
		cliffName = "andes";
		forestName = "andes forest";
		if (whichMix == 1)
			landName = "andes_dirt_a";
		else if (whichMix == 2)
			landName = "andes_grass_a";
		else
			landName = "andes_dirt_a";
		treeName = "treePuya";
		critterOneName = "guanaco";
		critterTwoName = "rhea";
		livestockName = "llama";
		fishName = "fishTarpon";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt_trail";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.05)
		{
			petName1 = "DEExplorerSheep";	
			heroSheep = 1;	
		}
		else
			petName1 = "WarDog";	
		propz = "SPCIncaOutpost";	
	}

	else if(araucMap == 1)			// araucania
	{
		rmEchoInfo("araucania terrain");
		andesMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("araucania_north_grass_a");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("araucania_north_grass_c");
		else
			rmSetBaseTerrainMix("araucania_north_dirt_a");
		if (floodedLand != 1)
		rmTerrainInitialize("andes\ground10_and", 0);
		rmSetMapType("bayou");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("Araucania_NorthGrass_Skirmish");
		riverName = "Araucania River";
		oceanName = "Araucania North Coast";
		pondName = "Araucania River"; 
		cliffName = "Araucania North Coast";
		forestName = "North Araucania Forest";
		if (whichMix == 1)
			landName = "araucania_north_dirt_a";
		else if (whichMix == 2)
			landName = "araucania_north_grass_a";
		else
			landName = "araucania_north_grass_c";
		treeName = "TreeAraucania";
		critterOneName = "guanaco";
		critterTwoName = "capybara";
		livestockName = "llama";
		fishName = "fishTarpon";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt_trail";
		mineralz = "MineCopper";	
		if (rmRandFloat(0,1) <= 0.05)
		{
			petName1 = "ExplorerDog";	
			heroDog = 1;
		}
		else
			petName1 = "deIncaDog";	
		propz = "NativeHouseInca";	
	}

	else if(bayouMap == 1)		// bayou
	{
		rmEchoInfo("bayou terrain");
		amazonMap = 1;
		if (rmRandFloat(0,1) <= 0.05)
			treasureIsle = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("bayou_forest");
		else if (whichMix >= 2)
			rmSetBaseTerrainMix("bayou_grass_skirmish");
		if (floodedLand != 1)
		rmTerrainInitialize("pampas\ground5_pam", 0);
		rmSetMapType("bayou");
		rmSetMapType("tropical");
		rmSetMapType("land");
	   	rmSetLightingSet("Bayou_Skirmish");
		riverName = "Bayou_Dry";
		oceanName = "Bayou SPC";
		pondName = "bayou skirmish2";
		if (floodedLand == 1)
			pondName = "Bayou3";
		cliffName = "Bayou";
		forestName = "Bayou Swamp Forest";
		landName = "bayou_forest_02";
		treeName = "TreeBayou";
		critterOneName = "turkey";
		critterTwoName = "deer";
		livestockName = "sheep";
		fishName = "fishMahi";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "deShipRuins";
		if (rmRandFloat(0,1) <= 0.50)
			petName1 = "xpWarrior";	
		else
			petName1 = "NatMedicineMan";	
		propz = "SPCCherokeeWarhut";	
	}

	else if(mongolMap == 1)			// mongolia
	{
		rmEchoInfo("mongolia terrain");
		yellowRiverMap = 1;
		asianMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("mongolia_grass_a");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("mongolia_grass_b");
		else
			rmSetBaseTerrainMix("mongolia_grass");
		if (floodedLand != 1)
		rmTerrainInitialize("Mongolia\ground_grass1_mongol", 0);
		rmSetMapType("yellowRiver");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("yellow_river_wet_skirmish");
		riverName = "Manchuria Inland";
		oceanName = "Manchuria Coast";
		pondName = "Yellow River Wet Sans Fog"; 
		cliffName = "Manchuria Grass";
		forestName = "Mongolian Fir Forest";
		if (whichMix == 1)
			landName = "mongolia_grass";
		else if (whichMix == 2)
			landName = "mongolia_grass_a";
		else
			landName = "mongolia_grass_b";
		treeName = "ypTreeMongolia";
		critterOneName = "ypSaiga";
		critterTwoName = "ypMuskdeer";
		livestockName = "ypYak";
		fishName = "ypFishCatfish";
		whaleName = "MinkeWhale";
		toiletPaper = "water";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.01)
			petName1 = "ypSPCHuang";	
		else if (rmRandFloat(0,1) <= 0.10)
			petName1 = "Horse";	
		else
			petName1 = "ypMongolScout";	
		propz = "ypSMShaolinAccessory";	
	}

	else if(nwtMap == 1)	// NWT
	{
		rmEchoInfo("northwest territory terrain");
		californiaMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("nwt_grass1");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("nwt_grass2");
		else
			rmSetBaseTerrainMix("nwt_grass_dirt");
		if (floodedLand != 1)
		rmTerrainInitialize("nwterritory\ground_grass1a_nwt", 0);
		rmSetMapType("california");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("NorthwestTerritory_Skirmish");
		riverName = "Northwest Territory Water";
		oceanName = "Northwest Territory Water";
		pondName = "Northwest Territory Water";
		cliffName = "Araucania North";
		forestName = "NW Territory Forest";
		if (whichMix == 1)
			landName = "nwt_grass_dirt";
		else if (whichMix == 2)
			landName = "nwt_grass_dirt";
		else
			landName = "nwt_grass2";
		treeName = "TreeNorthwestTerritory";
		critterOneName = "elk";
		critterTwoName = "moose";
		livestockName = "sheep";
		fishName = "fishSalmon";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "deMineCoalBuildable";
		petName1 = "deUnknownDrummer";	
		propz = "NativeHouseNootka";	
	}

	else if(euMap == 1)		// europe
	{
		rmEchoInfo("Europe terrain");
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else
		{
			if (rmRandFloat(0,1) <= 0.25)
			{
				if (whichMix == 1)
					rmSetBaseTerrainMix("italy_grass_lush");
				else if (whichMix == 2)
					rmSetBaseTerrainMix("italy_grass_medium");
				else
					rmSetBaseTerrainMix("italy_grass_dirt");
			}
			else if (rmRandFloat(0,1) <= 0.33)
			{
				if (whichMix == 1)
					rmSetBaseTerrainMix("italy_grass_lush");
				else if (whichMix == 2)
					rmSetBaseTerrainMix("italy_cliff_bottom");
				else
					rmSetBaseTerrainMix("italy_cliff_top_grass");
			}
			else if (rmRandFloat(0,1) <= 0.50)
			{
				if (whichMix == 1)
					rmSetBaseTerrainMix("italy_grass");
				else if (whichMix == 2)
					rmSetBaseTerrainMix("italy_grass_medium_dry");
				else
					rmSetBaseTerrainMix("italy_grass_dry");
			}
			else
			{
				if (whichMix == 1)
					rmSetBaseTerrainMix("italy_cliff_top_grass");
				else if (whichMix == 2)
					rmSetBaseTerrainMix("italy_cliff_top");
				else
					rmSetBaseTerrainMix("italy_cliff_bottom");
			}
		}
		if (floodedLand != 1)
		rmTerrainInitialize("pampas\ground5_pam", 0);
		rmSetMapType("lostEU");
		rmSetMapType("euroLandTradeRoute");
		rmSetMapType("land");
	   rmSetLightingSet("Honshu_Skirmish");
		riverName = "Italian River";
		oceanName = "Danish Coast";
		pondName = "Italian Pond";
		cliffName = "Italian Cliff";
		forestName = "Italian Forest";
		if (whichMix == 1)
			landName="italy_grass";
		else if (whichMix == 2)
			landName="italy_grass_dry";
		else
			landName="italy_grass_lush";
		treeName = "deTreeCypress";
		critterOneName = "deer";
		critterTwoName = "ypIbex";
		if (rmRandFloat(0,1) <= 0.50)
			livestockName = "sheep";
		else
			livestockName = "cow";
		fishName = "FishSardine";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt";
		mineralz = "deMineCoalBuildable";	
		petName1 = "deNatRoyalHuntsman";	
		propz = "PropSwan";	

		// set-up tech for outlaws and native skins
    	rmCreateTrigger("setupthemap");
    	rmSwitchToTrigger(rmTriggerID("setupthemap"));
    	rmSetTriggerPriority(4); 
    	rmSetTriggerActive(true);
    	rmSetTriggerRunImmediately(true);
    	rmSetTriggerLoop(false);

    	for (p = 0; <= cNumberNonGaiaPlayers)
    	{
    	    rmAddTriggerEffect("Set Tech Status");
    	    rmSetTriggerEffectParamInt("PlayerID", p, false);
    	    rmSetTriggerEffectParamInt("TechID", rmGetTechID("deEUMapSaxony"), false);
    	    rmSetTriggerEffectParamInt("Status", 2, false);
    	}
		
	    // Add Outlaws and Mercs
    	rmDisableDefaultMercs(true);
   		rmDisableCivTypeMercRestriction(true);

		for(n = 0; < outlawCount) // picks 2 outlaws
		{
			rmEchoInfo("choosing outlaws"+n);
			if (rmRandInt(1,5) == 1 && crabatOutlaw != 1)
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

		if (everyoneGetsAWagon != 981)
		{
			for(n = 0; < mercCount)
			{
				rmEchoInfo("choosing mercs"+n);
				if (rmRandInt(1,18) <= 1 && mercSwissPike != 1)
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
		}
		europeanMerc = 1;
	}

	else if(afrEast == 1)			// african east
	{
		rmEchoInfo("af east terrain");
		africanMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("africa east grass dry");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("africa east dirt");
		else
			rmSetBaseTerrainMix("africa east grass");
		if (floodedLand != 1)
		rmTerrainInitialize("Africa\groundCracked_afr", 0);
		rmSetMapType("sahara");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("rm_afri_greatRift");
		riverName = "Andes River";
		oceanName = "africa east lake";
		pondName = "africa east lake"; 
		cliffName = "Ethiopia Highland";
		forestName = "African Forest";
		if (whichMix == 1)
			landName = "africa east dirt";
		else if (whichMix == 2)
			landName = "africa east grass";
		else
			landName = "africa east grass dry";
		treeName = "TreeAfrica";
		critterOneName = "deZebra";
		critterTwoName = "deGiraffe";
		if (rmRandFloat(0,1) <= 0.10)
		{
			livestockName = "deAutoSangaCattle";
			autoCattle = 1;
		}
		else
			livestockName = "deSangaCattle";
		fishName = "deFishNilePerch";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt_trail_african";
		mineralz = "MineSalt";	
		if (rmRandFloat(0,1) <= 0.01)
			petName1 = "dePetElephant";	
		else
			petName1 = "dePetWarthog";	
		propz = "dePropsRockChurch";	

	    // Add Outlaws and Mercs
    	rmDisableDefaultMercs(true);
		rmDisableCivTypeMercRestriction(true);
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawAfricanSpearman");
	    else
			rmEnableOutlaw("deOutlawDesertWarrior");
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawKnifeThrower");
		else
		    rmEnableOutlaw("deOutlawDesertRaider");
		if (rmRandInt(0,2) == 1)
		    rmEnableOutlaw("deSaloonOutlawColoRifle");
	    else if (rmRandInt(0,1) == 1)
			rmEnableOutlaw("deOutlawDesertArcher");
	    else
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
		
		for(n = 0; < mercCount)
		{
			if (rmRandInt(1,9) <= 1 && sennarMerc != 1)
			{
				rmEnableMerc("deMercSudaneseRider", -1);
				sennarMerc = 1;
			}
			else if (rmRandInt(1,8) <= 1 && askariMerc != 1)
			{
				rmEnableMerc("deMercAskari", -1);
				askariMerc = 1;
			}
			else if (rmRandInt(1,7) <= 1 && dahomeyMerc != 1)
			{
				rmEnableMerc("deMercAmazon", -1);
				dahomeyMerc = 1;
			}
			else if (rmRandInt(1,6) <= 1 && cannoneerMerc != 1)
			{
				rmEnableMerc("deMercCannoneer", -1);
				cannoneerMerc = 1;
			}
			else if (rmRandInt(1,5) <= 1 && zenataMerc != 1)
			{
				rmEnableMerc("deMercZenata", -1);
				zenataMerc = 1;
			}
			else if (rmRandInt(1,4) <= 1 && kanuriMerc != 1)
			{
				rmEnableMerc("deMercKanuri", -1);
				kanuriMerc = 1;
			}
			else if (rmRandInt(1,3) <= 1 && corsairMerc != 1)
			{
			    rmEnableMerc("MercBarbaryCorsair", -1);
				corsairMerc = 1;
			}
			else if (rmRandInt(1,2) <= 1 && mamaMerc != 1)
			{
			    rmEnableMerc("MercMameluke", -1);
				mamaMerc = 1;
			}
			else if (rmRandFloat(0,1) <= 0.001 && gatCamelMerc != 1)
			{
				rmEnableMerc("deMercGatlingCamel", -1);
				gatCamelMerc = 1;
			}
			else
			{
				mercCount++;	// ensures 3 are always chosen
			}
		}
		africanMerc = 1;
	}

	else if(afrSavanna == 1)			// african savanna
	{
		rmEchoInfo("af savanna terrain");
		africanMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("africa savanna sand");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("africa savanna dirt");
		else
			rmSetBaseTerrainMix("africa savanna grass dry");
		if (floodedLand != 1)
		rmTerrainInitialize("AfricaSavanna\ground_rock1_afriSavanna", 0);
		rmSetMapType("sahara");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("rm_afri_horn");
		riverName = "africa savanna river";
		oceanName = "africa savanna coast";
		pondName = "africa lake victoria lush"; 
		cliffName = "africa savanna";
		if (rmRandFloat(0,1) <= 0.10)
			forestName = "Af Savanna Wateringhole Forest";
		else if (rmRandFloat(0,1) >= 0.90)
			forestName = "Af Savanna Baobab Forest";
		else 
			forestName = "Af Sahel Forest";
		if (whichMix == 1)
			landName = "africa savanna dirt";
		else if (whichMix == 2)
			landName = "africa savanna grass dry";
		else
			landName = "africa savanna grass";
		treeName = "deTreeSenegaliaLaeta";
		critterOneName = "deOstrich";
		critterTwoName = "Gazelle";
		if (rmRandFloat(0,1) <= 0.05)
			livestockName = "deChonkyCattle";
		else if (rmRandFloat(0,1) <= 0.05)
			livestockName = "deUnknownWoodCattle";
		else if (rmRandFloat(0,1) <= 0.05)
			livestockName = "deUnknownGoldCattle";
		else
			livestockName = "deZebuCattle";
		fishName = "deFishNilePerch";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt_trail_african";
		mineralz = "deREVMineDiamondBuildable";		
		if (rmRandFloat(0,1) <= 0.01)
			petName1 = "ypPetRhino";	
		else
			petName1 = "dePetLeopard";		
		propz = "dePropsAnimalsCattle";	

	    // Add Outlaws and Mercs
    	rmDisableDefaultMercs(true);
		rmDisableCivTypeMercRestriction(true);
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawAfricanSpearman");
	    else
			rmEnableOutlaw("deOutlawDesertWarrior");
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawKnifeThrower");
		else
		    rmEnableOutlaw("deOutlawDesertRaider");
		if (rmRandInt(0,2) == 1)
		    rmEnableOutlaw("deSaloonOutlawColoRifle");
	    else if (rmRandInt(0,1) == 1)
			rmEnableOutlaw("deOutlawDesertArcher");
	    else
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
		
		for(n = 0; < mercCount)
		{
			if (rmRandInt(1,9) <= 1 && sennarMerc != 1)
			{
				rmEnableMerc("deMercSudaneseRider", -1);
				sennarMerc = 1;
			}
			else if (rmRandInt(1,8) <= 1 && askariMerc != 1)
			{
				rmEnableMerc("deMercAskari", -1);
				askariMerc = 1;
			}
			else if (rmRandInt(1,7) <= 1 && dahomeyMerc != 1)
			{
				rmEnableMerc("deMercAmazon", -1);
				dahomeyMerc = 1;
			}
			else if (rmRandInt(1,6) <= 1 && cannoneerMerc != 1)
			{
				rmEnableMerc("deMercCannoneer", -1);
				cannoneerMerc = 1;
			}
			else if (rmRandInt(1,5) <= 1 && zenataMerc != 1)
			{
				rmEnableMerc("deMercZenata", -1);
				zenataMerc = 1;
			}
			else if (rmRandInt(1,4) <= 1 && kanuriMerc != 1)
			{
				rmEnableMerc("deMercKanuri", -1);
				kanuriMerc = 1;
			}
			else if (rmRandInt(1,3) <= 1 && corsairMerc != 1)
			{
			    rmEnableMerc("MercBarbaryCorsair", -1);
				corsairMerc = 1;
			}
			else if (rmRandInt(1,2) <= 1 && mamaMerc != 1)
			{
			    rmEnableMerc("MercMameluke", -1);
				mamaMerc = 1;
			}
			else if (rmRandFloat(0,1) <= 0.001 && gatCamelMerc != 1)
			{
				rmEnableMerc("deMercGatlingCamel", -1);
				gatCamelMerc = 1;
			}
			else
			{
				mercCount++;	// ensures 3 are always chosen
			}
		}
		africanMerc = 1;
	}
	
	else if(afrRainforest == 1)			// african rainforest
	{
		rmEchoInfo("af rainforest terrain");
		africanMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("africa rainforest grass medium");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("africa rainforest grass");
		else
			rmSetBaseTerrainMix("africa rainforest grass dry");
		if (floodedLand != 1)
		rmTerrainInitialize("AfricaRainforest\ground_grass1_afriRainforest", 0);
		rmSetMapType("sahara");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("rm_afri_pepperCoast");
		riverName = "africa rainforest river muddy";
		oceanName = "africa rainforest coast";
		pondName = "africa rainforest lagoon"; 
		cliffName = "africa rainforest grass";
		forestName = "Af Niger Delta Tropical Forest";
		if (whichMix == 1)
			landName = "africa rainforest grass dry";
		else if (whichMix == 2)
			landName = "africa rainforest grass medium";
		else
			landName = "africa rainforest grass";
		treeName = "deTreeMangrove";
		critterOneName = "deGiraffe";
		critterTwoName = "ypWildElephant";
		if (rmRandFloat(0,1) <= 0.05)
			livestockName = "deChonkyCattle";
		else if (rmRandFloat(0,1) <= 0.05)
			livestockName = "deUnknownGoldCattle";
		else if (rmRandFloat(0,1) <= 0.05)
			livestockName = "deUnknownWoodCattle";
		else
			livestockName = "deSangaCattle";
		fishName = "deFishNilePerch";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt_trail_african";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.01)
			petName1 = "dePetHippo";	
		else
			petName1 = "deGunnerLevy";
		propz = "dePropGranary";	

	    // Add Outlaws and Mercs
    	rmDisableDefaultMercs(true);
		rmDisableCivTypeMercRestriction(true);
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawAfricanSpearman");
	    else
			rmEnableOutlaw("deOutlawDesertWarrior");
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawKnifeThrower");
		else
		    rmEnableOutlaw("deOutlawDesertRaider");
		if (rmRandInt(0,2) == 1)
		    rmEnableOutlaw("deSaloonOutlawColoRifle");
	    else if (rmRandInt(0,1) == 1)
			rmEnableOutlaw("deOutlawDesertArcher");
	    else
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
		
		for(n = 0; < mercCount)
		{
			if (rmRandInt(1,9) <= 1 && sennarMerc != 1)
			{
				rmEnableMerc("deMercSudaneseRider", -1);
				sennarMerc = 1;
			}
			else if (rmRandInt(1,8) <= 1 && askariMerc != 1)
			{
				rmEnableMerc("deMercAskari", -1);
				askariMerc = 1;
			}
			else if (rmRandInt(1,7) <= 1 && dahomeyMerc != 1)
			{
				rmEnableMerc("deMercAmazon", -1);
				dahomeyMerc = 1;
			}
			else if (rmRandInt(1,6) <= 1 && cannoneerMerc != 1)
			{
				rmEnableMerc("deMercCannoneer", -1);
				cannoneerMerc = 1;
			}
			else if (rmRandInt(1,5) <= 1 && zenataMerc != 1)
			{
				rmEnableMerc("deMercZenata", -1);
				zenataMerc = 1;
			}
			else if (rmRandInt(1,4) <= 1 && kanuriMerc != 1)
			{
				rmEnableMerc("deMercKanuri", -1);
				kanuriMerc = 1;
			}
			else if (rmRandInt(1,3) <= 1 && corsairMerc != 1)
			{
			    rmEnableMerc("MercBarbaryCorsair", -1);
				corsairMerc = 1;
			}
			else if (rmRandInt(1,2) <= 1 && mamaMerc != 1)
			{
			    rmEnableMerc("MercMameluke", -1);
				mamaMerc = 1;
			}
			else if (rmRandFloat(0,1) <= 0.001 && gatCamelMerc != 1)
			{
				rmEnableMerc("deMercGatlingCamel", -1);
				gatCamelMerc = 1;
			}
			else
			{
				mercCount++;	// ensures 3 are always chosen
			}
		}
		africanMerc = 1;
	}
	
	else	// afrDesert == 1	// african desert
	{
		rmEchoInfo("af desert terrain");
		africanMap = 1;
		if (rmRandFloat(0,1) <= 0.001)
			rmSetBaseTerrainMix("unknown funky");
		else if (whichMix == 1)
			rmSetBaseTerrainMix("africa desert sand");
		else if (whichMix == 2)
			rmSetBaseTerrainMix("africa desert grass");
		else
			rmSetBaseTerrainMix("africa desert grass dry");
		if (floodedLand != 1)
		rmTerrainInitialize("AfricaDesert\ground_dirt1_afriDesert", 0);
		rmSetMapType("sahara");
		rmSetMapType("grass");
		rmSetMapType("land");
		rmSetLightingSet("rm_afri_nileValley");
		riverName = "africa desert nile";
		oceanName = "africa desert coast";
		pondName = "africa desert lake lush"; 
		cliffName = "africa desert grass";
		forestName = "Af Atlas Forest";
		if (whichMix == 1)
			landName = "africa desert grass";
		else if (whichMix == 2)
			landName = "africa desert grass dry";
		else
			landName = "africa desert sand";
		treeName = "deTreeSaharanCypress";
		critterOneName = "deOstrich";
		critterTwoName = "Gazelle";
		if (rmRandFloat(0,1) <= 0.10)
		{
			livestockName = "deAutoZebuCattle";
			autoCattle = 1;
		}
		else
			livestockName = "deZebuCattle";
		fishName = "deFishNilePerch";
		whaleName = "MinkeWhale";
		toiletPaper = "dirt_trail_african";
		mineralz = "MineGold";	
		if (rmRandFloat(0,1) <= 0.10)
			petName1 = "ypPetLion";	
		else
			petName1 = "deBowmanLevy";		
		propz = "dePropTreesAfrica";	

	    // Add Outlaws and Mercs
    	rmDisableDefaultMercs(true);
		rmDisableCivTypeMercRestriction(true);
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawAfricanSpearman");
	    else
			rmEnableOutlaw("deOutlawDesertWarrior");
		if (rmRandInt(0,1) == 1)
		    rmEnableOutlaw("deSaloonOutlawKnifeThrower");
		else
		    rmEnableOutlaw("deOutlawDesertRaider");
		if (rmRandInt(0,2) == 1)
		    rmEnableOutlaw("deSaloonOutlawColoRifle");
	    else if (rmRandInt(0,1) == 1)
			rmEnableOutlaw("deOutlawDesertArcher");
	    else
			rmEnableOutlaw("deAllegianceBarbaryMarksman");
		
		for(n = 0; < mercCount)
		{
			if (rmRandInt(1,9) <= 1 && sennarMerc != 1)
			{
				rmEnableMerc("deMercSudaneseRider", -1);
				sennarMerc = 1;
			}
			else if (rmRandInt(1,8) <= 1 && askariMerc != 1)
			{
				rmEnableMerc("deMercAskari", -1);
				askariMerc = 1;
			}
			else if (rmRandInt(1,7) <= 1 && dahomeyMerc != 1)
			{
				rmEnableMerc("deMercAmazon", -1);
				dahomeyMerc = 1;
			}
			else if (rmRandInt(1,6) <= 1 && cannoneerMerc != 1)
			{
				rmEnableMerc("deMercCannoneer", -1);
				cannoneerMerc = 1;
			}
			else if (rmRandInt(1,5) <= 1 && zenataMerc != 1)
			{
				rmEnableMerc("deMercZenata", -1);
				zenataMerc = 1;
			}
			else if (rmRandInt(1,4) <= 1 && kanuriMerc != 1)
			{
				rmEnableMerc("deMercKanuri", -1);
				kanuriMerc = 1;
			}
			else if (rmRandInt(1,3) <= 1 && corsairMerc != 1)
			{
			    rmEnableMerc("MercBarbaryCorsair", -1);
				corsairMerc = 1;
			}
			else if (rmRandInt(1,2) <= 1 && mamaMerc != 1)
			{
			    rmEnableMerc("MercMameluke", -1);
				mamaMerc = 1;
			}
			else if (rmRandFloat(0,1) <= 0.001 && gatCamelMerc != 1)
			{
				rmEnableMerc("deMercGatlingCamel", -1);
				gatCamelMerc = 1;
			}
			else
			{
				mercCount++;	// ensures 3 are always chosen
			}
		}
		africanMerc = 1;
	}

	if (amazonMap == 1)
		rmSetGlobalRain(0.20);
	if (rockiesMap == 1)
		rmSetGlobalSnow(0.20);
	if (floodedLand == 1)
	{
		rmSetSeaType(pondName);
		rmTerrainInitialize("water");
	}

	// add some overlapping features
	if (floodedLand == 1)
	{
		if (rmRandFloat(0,1) <= 0.10)
			forestMiddle = 1;
		else if (rmRandFloat(0,1) <= 0.10)
			oceanOffCenter = 1;
		else if (rmRandFloat(0,1) <= 0.10)
			oceanMiddle = 1;
		else if (rmRandFloat(0,1) <= 0.10)
			riverExists = 1;
	}

	if (oceanOffCenter == 1)
	{
		if (rmRandFloat(0,1) <= 0.10)
			forestMiddle = 1;
		else if (rmRandFloat(0,1) <= 0.05)
			oceanMiddle = 1;
		else if (rmRandFloat(0,1) <= 0.05)
			riverExists = 1;
	}

	if (oceanRing == 1)
	{
		if (rmRandFloat(0,1) <= 0.10)
		{
			riverExists = 1;
			riverName = oceanName;
		}
		else if (rmRandFloat(0,1) <= 0.15)
			oceanMiddle = 1;
		else if (rmRandFloat(0,1) <= 0.10)
			forestMiddle = 1;
	}

	if (floodedLand == 1)
		rmEchoInfo("big flood");
	else if (oceanRing == 1)
		rmEchoInfo("big island");
	else if (landOnly == 1)
		rmEchoInfo("just land");
	else if (riverExists == 1)
		rmEchoInfo("river exists");
	else if (oceanMiddle == 1)
		rmEchoInfo("ocean in middle");
	else if (oceanOffCenter == 1)
		rmEchoInfo("ocean off center");
	else if (forestMiddle == 1)
		rmEchoInfo("forest in middle");

	int riverPosition = rmRandInt(1,8);
	if (oceanOffCenter == 1 && riverExists == 1)
		riverPosition = rmRandInt(1,4);
//		riverPosition = 8;	// for testing
	if (riverExists == 1)
		rmEchoInfo("river position = "+riverPosition);

	float bayPosition = rmRandFloat(0,1);
	if (oceanOffCenter == 1 && riverExists == 1)
	{
		if (riverPosition == 1)
		{
			if (rmRandFloat(0,1) <= 0.50)
				bayPosition = 0.99;
			else
				bayPosition = 0.47;
		}
		if (riverPosition == 2)
		{
			if (rmRandFloat(0,1) <= 0.50)
				bayPosition = 0.83;
			else
				bayPosition = 0.35;
		}
		if (riverPosition == 3)
		{
			if (rmRandFloat(0,1) <= 0.50)
				bayPosition = 0.71;
			else
				bayPosition = 0.23;
		}
		if (riverPosition == 4)
		{
			if (rmRandFloat(0,1) <= 0.50)
				bayPosition = 0.59;
			else
				bayPosition = 0.11;
		}
	}
//		bayPosition = 0.95;		// for testing
	if (oceanOffCenter == 1)
		rmEchoInfo("bay position = "+bayPosition);

// ============= Classes =============
	int classPlayer=rmDefineClass("player");
	int classNatives=rmDefineClass("natives");
	int classCanyon=rmDefineClass("canyon");
	int classCliff=rmDefineClass("cliffs");
	int pondClass=rmDefineClass("pond");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	int classGold = rmDefineClass("classGold");

// ============= Constraints =============
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 12.0);
	int playerAvoidImpassableLand = rmCreateTerrainDistanceConstraint("player avoid impassable land", "Land", false, 18.0);
	int mediumAvoidImpassableLand = rmCreateTerrainDistanceConstraint("slightly avoid impassable", "Land", false, 8.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("just barely avoid impassable", "Land", false, 4.0);
	int TCAvoidImpassableLand = rmCreateTerrainDistanceConstraint("TCs vs impassable land", "Land", false, 8.0);
	int avoidWater = rmCreateTerrainDistanceConstraint("avoid water ", "water", true, 8.0);
	int avoidWaterShort = rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 4.0);
	int avoidWaterFar = rmCreateTerrainDistanceConstraint("avoid water far", "water", true, 10+cNumberNonGaiaPlayers);
	int avoidWaterFarPlus = rmCreateTerrainDistanceConstraint("avoid water far plus", "water", true, 20+cNumberNonGaiaPlayers);
	int stayNearWater = rmCreateTerrainMaxDistanceConstraint("stay near water ", "land", false, 18.0);
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 4.0);
	int avoidTradeRouteSocket = rmCreateTypeDistanceConstraint("avoid trade route sockets", "sockettraderoute", 8.0);
	int avoidTradeRouteSocketShort = rmCreateTypeDistanceConstraint("avoid trade route sockets short", "sockettraderoute", 4.0);
   int edgeConstraintShort=rmCreatePieConstraint("continent avoids edge short",  0.5, 0.5, 0, rmGetMapXSize()-8, 0, 0, 0);
   int edgeConstraint=rmCreatePieConstraint("continent avoids edge",  0.5, 0.5, 0, rmGetMapXSize()-30, 0, 0, 0);
	int avoidCanyon = rmCreateClassDistanceConstraint("don't place on mesa where you can't path", classCanyon, 2.0);
	int avoidCliffs = rmCreateClassDistanceConstraint("cliffs avoid cliffs", classCliff, 21.0);
	int avoidCliffsMed = rmCreateClassDistanceConstraint("stuff avoid cliffs med", classCliff, 8.0);
	int avoidCliffsShort = rmCreateClassDistanceConstraint("stuff avoid cliffs short", classCliff, 2.0);
   int pondConstraint=rmCreateClassDistanceConstraint("ponds avoid ponds", rmClassID("pond"), 50.0);
   int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 17.0);
	int avoidTC=rmCreateTypeDistanceConstraint("vs. TC", "TownCenter", 8.0);
	int avoidTCFar=rmCreateTypeDistanceConstraint("vs. TC far", "TownCenter", 30.0);
	int avoidCommandPost=rmCreateTypeDistanceConstraint("vs. command post", "deSPCCommandPost", 8.0);
	int avoidCommandPostFar=rmCreateTypeDistanceConstraint("vs. command post far", "deSPCCommandPost", 30.0);
	int avoidCW=rmCreateTypeDistanceConstraint("vs. CW", "CoveredWagon", 8.0);
   int avoidNuggetShort=rmCreateTypeDistanceConstraint("nugget avoid nugget short", "abstractNugget", 10.0);
   int avoidNugget=rmCreateTypeDistanceConstraint("nugget avoid nugget", "abstractNugget", 16.0);
   int avoidNuggetMed=rmCreateTypeDistanceConstraint("nugget avoid nugget med", "abstractNugget", 22.0);
   int avoidNuggetFar=rmCreateTypeDistanceConstraint("nugget avoid nugget far", "abstractNugget", 36.0);
   int avoidHuari=rmCreateTypeDistanceConstraint("huari avoid huari", "HuariStrongholdAndes", 50.0);
   int fishVsFishFar=rmCreateTypeDistanceConstraint("fish v fish far", "abstractFish", 22+cNumberNonGaiaPlayers);
   int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "abstractFish", 12.0);
   int whaleVsWhaleFar=rmCreateTypeDistanceConstraint("whale v whale far", "abstractWhale", 82-cNumberNonGaiaPlayers);
   int whaleVsWhaleID=rmCreateTypeDistanceConstraint("whale v whale", "abstractWhale", 25.0);
   int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 4.0);
   int whaleLand = rmCreateTerrainDistanceConstraint("whale v. land", "land", true, 12.0);
	int flagVsFlag = rmCreateTypeDistanceConstraint("flag avoid same", "HomeCityWaterSpawnFlag", 4);
   int avoidFood = rmCreateTypeDistanceConstraint("food avoids food", "food", 40.0);
	int avoidFood1 = rmCreateTypeDistanceConstraint("food avoids food1", critterOneName, 40+3*cNumberNonGaiaPlayers);
	int avoidFood2 = rmCreateTypeDistanceConstraint("food avoids food2", critterTwoName, 40+3*cNumberNonGaiaPlayers);
	int avoidFood1Far = rmCreateTypeDistanceConstraint("food avoids food1 far", critterOneName, 50+2.5*cNumberNonGaiaPlayers);
	int avoidFood2Far = rmCreateTypeDistanceConstraint("food avoids food2 far", critterTwoName, 50+2.5*cNumberNonGaiaPlayers);
	int avoidHuntable = rmCreateTypeDistanceConstraint("hunt avoids hunt", "huntable", 50);
	int avoidSilver = rmCreateTypeDistanceConstraint("fast coin avoids coin", "gold", 50+2.5*cNumberNonGaiaPlayers);
	int avoidEdge = rmCreatePieConstraint("Avoid Edge",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidForestMin=rmCreateClassDistanceConstraint("avoid forest min", rmClassID("classForest"), 4.0);
   	int avoidPond=rmCreateClassDistanceConstraint("avoid pond min", rmClassID("pond"), 8.0);
	int	avoidPlayers = rmCreateClassDistanceConstraint("stay away from players medium", classPlayer, 8.0);
	int	avoidPlayersFar = rmCreateClassDistanceConstraint("stay away from players far", classPlayer, 24.0);
	int	avoidPlayersFar1 = rmCreateClassDistanceConstraint("stay away from players far1", classPlayer, 30.0);
	int avoidEdgeFar = rmCreatePieConstraint("Avoid Edge Far",0.5,0.5, rmXFractionToMeters(0.0),rmXFractionToMeters(0.43), rmDegreesToRadians(0),rmDegreesToRadians(360));
	int avoidSilver1 = rmCreateTypeDistanceConstraint("fast coin avoids coin1", "gold", 12.0);
	int avoidSilver1Short = rmCreateTypeDistanceConstraint("fast coin avoids coin1 short", "gold", 8.0);
	int avoidGoldMin = rmCreateClassDistanceConstraint("stay away from minerals", classGold, 4.0);
	int avoidGoldShort = rmCreateClassDistanceConstraint("stay away from minerals short", classGold, 12.0);
	int avoidGold = rmCreateClassDistanceConstraint("avoid gold class", classGold, 40);
	int avoidGoldFar = rmCreateClassDistanceConstraint("stay away from minerals far", classGold, 40+2.5*cNumberNonGaiaPlayers);
	int avoidGoldVeryFar = rmCreateClassDistanceConstraint("stay away from minerals very far", classGold, 60+2*cNumberNonGaiaPlayers);
   	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 4.0);	
	int avoidAllFar=rmCreateTypeDistanceConstraint("avoid all far", "all", 8.0);
	int stayNearEdge = rmCreatePieConstraint("stay near edge",0.5,0.5,rmXFractionToMeters(0.41), rmXFractionToMeters(0.48), rmDegreesToRadians(0),rmDegreesToRadians(360));

// ============= Big Flood =============
	if(floodedLand == 1)
	{
    	int floodedContinent = rmCreateArea("floodedContinent");
        rmSetAreaSize(floodedContinent, 0.99);
        rmSetAreaLocation(floodedContinent, 0.50, 0.50);    
		if (rmGetIsTreaty() == true)
	        rmSetAreaBaseHeight(floodedContinent, 1.10);
        else
			rmSetAreaBaseHeight(floodedContinent, 0.87);
        rmSetAreaCoherence(floodedContinent, 0.999);
        rmSetAreaSmoothDistance(floodedContinent, 10);
        rmSetAreaHeightBlend(floodedContinent, -1.0);
		rmSetAreaMix(floodedContinent, landName); 
        rmSetAreaElevationNoiseBias(floodedContinent, 0);
        rmSetAreaElevationEdgeFalloffDist(floodedContinent, 10);
        rmSetAreaElevationVariation(floodedContinent, 3);
        rmSetAreaElevationPersistence(floodedContinent, .2);
        rmSetAreaElevationOctaves(floodedContinent, 5);
        rmSetAreaElevationMinFrequency(floodedContinent, 0.04);
        rmSetAreaElevationType(floodedContinent, cElevTurbulence);  
        rmBuildArea(floodedContinent);
		}

// ============= Big Island =============
	if(oceanRing == 1)
	{
		int worldOcean=rmCreateArea("ocean that covers whole map");
		rmSetAreaWaterType(worldOcean, oceanName);
		rmSetAreaSize(worldOcean, 1, 1);
		rmSetAreaLocation(worldOcean, 0.5, 0.5);
		rmSetAreaWarnFailure(worldOcean, false);
		rmSetAreaObeyWorldCircleConstraint(worldOcean, false);
		rmBuildArea(worldOcean);

		int continent=rmCreateArea("island continent in ocean");
		rmSetAreaMix(continent, landName);
		rmSetAreaElevationType(continent, cElevTurbulence);
		rmSetAreaElevationVariation(continent, 2.0);
		rmSetAreaBaseHeight(continent, 2.0);
		rmSetAreaElevationMinFrequency(continent, 0.09);
		rmSetAreaElevationOctaves(continent, 3);
		rmSetAreaElevationPersistence(continent, 0.2);
		rmSetAreaElevationNoiseBias(continent, 1);
		rmSetAreaSize(continent, 0.43, 0.43);
		rmSetAreaLocation(continent, 0.5, 0.5);
		rmSetAreaSmoothDistance(continent, 50);
		rmSetAreaCoherence(continent, 0.444);
//		rmAddAreaConstraint(continent, avoidEdge);
		rmAddAreaConstraint(continent, edgeConstraint);
		rmBuildArea(continent);		
	}

//	Other land configurations handled later

// ============= Trade Route =============
int tpORnot = rmRandInt(1,10);
	if (riverExists == 1)
		tpORnot = rmRandInt(1,5);
	if (rmGetIsKOTH() == true && rmRandFloat(0,1) <= 0.50)
		tpORnot = 5;
	if (rmGetIsTreaty() == true && blockedMiddle == 1)
		tpORnot = rmRandInt(4,5);
	if (oceanRing == 1)
		tpORnot = rmRandInt(4,5);
	if (rmGetIsTreaty() == true && forestMiddle == 1)
		tpORnot = rmRandInt(4,5);
	if (oceanRing == 1 && riverExists == 1 && fullShallow != 1)
		tpORnot = 5;
	if (floodedLand == 1 && oceanMiddle == 1)
		tpORnot = 5;
	if (oceanRing == 1 && oceanMiddle == 1)
		tpORnot = 5;
	if (oceanOffCenter == 1 && oceanMiddle == 1)
		tpORnot = 5;
	if (oceanOffCenter == 1 && riverExists == 1)
		tpORnot = 5;
	if (floodedLand == 1 && riverExists == 1)
		tpORnot = 5;
//	tpORnot = 5;		// for testing
	rmEchoInfo("tpORnot = "+tpORnot);

if (tpORnot != 5) {
	int tpVariation = rmRandInt(3,10);
	if (blockedMiddle == 1)
		tpVariation = 1;

	if (forestMiddle == 1 && oceanRing != 1)
		tpVariation = rmRandInt(1,2);

	if (forestMiddle == 1 && oceanOffCenter == 1)
		tpVariation = 2;

	if (oceanRing == 1)
		tpVariation = 2;

//	if (sagTest == -1) {
//		if (baseTerrain > 0.50)
//			tpVariation = 2;
//		else
//			tpVariation = 5;
//		}

	if (riverExists == 1 && riverPosition >= 5)
		tpVariation = 1;
	if (rmGetIsKOTH() == true)
		tpVariation = rmRandInt(1,2);

//		tpVariation = 1;	// for testing
		rmEchoInfo("trade route variation = "+tpVariation);

	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
        rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
        rmSetObjectDefAllowOverlap(socketID, true);
        rmAddObjectDefConstraint(socketID, avoidEdge);
        rmSetObjectDefMinDistance(socketID, 3.0);
        rmSetObjectDefMaxDistance(socketID, 11.0);    
	       
        int tradeRouteID = rmCreateTradeRoute();
        rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	
	float startLocX = 0.00;
	float startLocY = 0.00;
	float endLocX = 0.00;
	float endLocY = 0.00;

	int whereTRstart = rmRandInt(1,4);
	int whereTRend = rmRandInt(1,4);

	if (riverExists == 1) {
		if (riverPosition == 1) {
			if (tpVariation < 7) {
				whereTRstart = 1;
				whereTRend = 3;	
				}
			else {
				whereTRstart = 3;
				whereTRend = 1;	
				}
			}
		if (riverPosition == 2) {
			whereTRstart = 1;
			whereTRend = 1;	
			}
		if (riverPosition == 3) {
			if (tpVariation < 7) {
				whereTRstart = 2;
				whereTRend = 4;	
				}
			else {
				whereTRstart = 4;
				whereTRend = 2;	
				}
			}
		if (riverPosition == 4) {
			whereTRstart = 1;
			whereTRend = 1;	
			}
		}

	if (oceanOffCenter == 1) {
		if(bayPosition < 0.12) {
			whereTRstart = 2;
			whereTRend = 1;	
			}
		else if(bayPosition < 0.24) {
			whereTRstart = 3;
			whereTRend = 1;	
			}
		else if(bayPosition < 0.36) {
			whereTRstart = 3;
			whereTRend = 2;	
			}
		else if(bayPosition < 0.48) {
			whereTRstart = 4;
			whereTRend = 2;	
			}
		else if(bayPosition < 0.60) {
			whereTRstart = 4;
			whereTRend = 3;	
			}
		else if(bayPosition < 0.72) {
			whereTRstart = 3;
			whereTRend = 1;	
			}
		else if(bayPosition < 0.84) {
			whereTRstart = 4;
			whereTRend = 1;	
			}
		else {
			whereTRstart = 4;
			whereTRend = 2;	
			}
		}

	if (whereTRstart == whereTRend && riverExists != 1) {
		if (tpVariation < 7) {
			startLocX = rmRandFloat(0.80,0.90);
			startLocY = rmRandFloat(0.80,0.90);
			endLocX = rmRandFloat(0.10,0.20);
			endLocY = rmRandFloat(0.10,0.20);
			}
		else {
			startLocX = rmRandFloat(0.10,0.20);
			startLocY = rmRandFloat(0.80,0.90);
			endLocX = rmRandFloat(0.80,0.90);
			endLocY = rmRandFloat(0.10,0.20);
			}
		}
	else if (whereTRstart == whereTRend && riverExists == 1) {
		if (riverPosition <= 2) {
			if (tpVariation < 7) {
				startLocX = rmRandFloat(0.80,0.90);
				startLocY = rmRandFloat(0.10,0.20);
				endLocX = rmRandFloat(0.10,0.20);
				endLocY = rmRandFloat(0.80,0.90);
				}
			else {
				startLocX = rmRandFloat(0.10,0.20);
				startLocY = rmRandFloat(0.80,0.90);
				endLocX = rmRandFloat(0.80,0.90);
				endLocY = rmRandFloat(0.10,0.20);
				}
			}
		else {
			if (tpVariation < 7) {
				startLocX = rmRandFloat(0.80,0.90);
				startLocY = rmRandFloat(0.80,0.90);
				endLocX = rmRandFloat(0.10,0.20);
				endLocY = rmRandFloat(0.10,0.20);
				}
			else {
				startLocX = rmRandFloat(0.10,0.20);
				startLocY = rmRandFloat(0.10,0.20);
				endLocX = rmRandFloat(0.80,0.90);
				endLocY = rmRandFloat(0.80,0.90);
				}
			}
		}
	else {
		if (whereTRstart == 1) {
			startLocX = rmRandFloat(0.30,0.70);
			startLocY = 0.95;
			if (landOnly == 1) {
				whereTRend = 3;
				}
			}
		else if (whereTRstart == 2) {
			startLocX = 0.95;
			startLocY = rmRandFloat(0.30,0.70);
			if (landOnly == 1) {
				whereTRend = 4;
				}
			}
		else if (whereTRstart == 3) {
			startLocX = rmRandFloat(0.30,0.70);
			startLocY = 0.05;
			if (landOnly == 1) {
				whereTRend = 1;
				}
			}
		else {
			startLocX = 0.05;
			startLocY = rmRandFloat(0.30,0.70);
			if (landOnly == 1) {
				whereTRend = 2;
				}
			}

		if (whereTRend == 1) {
			endLocX = rmRandFloat(0.30,0.70);
			endLocY = 0.95;
			}
		else if (whereTRend == 2) {
			endLocX = 0.95;
			endLocY = rmRandFloat(0.30,0.70);
			}
		else if (whereTRend == 3) {
			endLocX = rmRandFloat(0.30,0.70);
			endLocY = 0.05;
			}
		else {
			endLocX = 0.05;
			endLocY = rmRandFloat(0.30,0.70);
			}
		}

//		whereTRstart = 1;	// for testing
//		whereTRend = 1;		// for testing
		rmEchoInfo("trade route start = "+whereTRstart);
		rmEchoInfo("trade route end = "+whereTRend);

//		startLocX = 1;	// for testing
//		startLocY = 1;		// for testing
//		endLocX = 1;		// for testing
//		endLocY = 1;		// for testing
		rmEchoInfo("tr start loc x = "+startLocX);
		rmEchoInfo("tr start loc y = "+startLocY);
		rmEchoInfo("tr end loc x = "+endLocX);
		rmEchoInfo("tr end loc y = "+endLocY);

	if (tpVariation == 1) {
		if (riverExists != 1 || riverPosition <= 5) {
			rmAddTradeRouteWaypoint(tradeRouteID, 0.08, 0.55);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.20, 0.83, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.45, 0.93, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.67, 0.89, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.87, 0.70, 3, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.90, 0.45, 3, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.30, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.70, 0.10, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.50, 0.08, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.30, 0.13, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.25, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.08, 0.55, 3, 8); 
			}
		else if (riverExists == 1 && riverPosition == 8) {
			rmAddTradeRouteWaypoint(tradeRouteID, 0.90, 0.45); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.30, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.70, 0.10, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.50, 0.08, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.30, 0.13, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.25, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.08, 0.55, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.20, 0.83, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.45, 0.93, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.67, 0.89, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.87, 0.70, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.90, 0.45, 3, 8);
			}
		else if (riverExists == 1 && riverPosition != 6) {
			rmAddTradeRouteWaypoint(tradeRouteID, 0.67, 0.89); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.87, 0.70, 3, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.90, 0.45, 3, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.30, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.70, 0.10, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.50, 0.08, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.30, 0.13, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.25, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.08, 0.55, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.20, 0.83, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.45, 0.93, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.67, 0.89, 3, 8); 
			}
		else {
			rmAddTradeRouteWaypoint(tradeRouteID, 0.20, 0.83); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.45, 0.93, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.67, 0.89, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.87, 0.70, 3, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.90, 0.45, 3, 8);
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.85, 0.30, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.70, 0.10, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.50, 0.08, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.30, 0.13, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.15, 0.25, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.08, 0.55, 3, 8); 
			rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.20, 0.83, 3, 8); 
			}
		}
	else if (tpVariation == 2) {
		int randomShaper = rmRandInt(1,2);
		if (randomShaper == 1) {	// square
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.35); 
		rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.65); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
			}
		else {	// small circle
		rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.70, 0.50); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.35); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.30); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.35); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.30, 0.50); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.35, 0.65); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.70); 
			rmAddTradeRouteWaypoint(tradeRouteID, 0.65, 0.65);
		}
		}
	else {
		rmAddTradeRouteWaypoint(tradeRouteID, startLocX, startLocY);
	//	if (riverExists == 1) {
	//		rmAddTradeRouteWaypoint(tradeRouteID, 0.50, 0.50);
	//		rmAddTradeRouteWaypoint(tradeRouteID, endLocX, endLocY);
	//		}
		rmAddRandomTradeRouteWaypoints(tradeRouteID, 0.50, 0.50, 8, 12); 
		rmAddRandomTradeRouteWaypoints(tradeRouteID, endLocX, endLocY, 8, 12); 
		}

        rmBuildTradeRoute(tradeRouteID, toiletPaper);

		float tpLoc = 0.00;
		if (tpVariation < 3)
			tpLoc = 0.0625;
		else 
			tpLoc = 0.10;
 
        vector socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, tpLoc);
        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

		if (tpVariation < 3) {
			if (riverExists != 1 && cNumberNonGaiaPlayers > 4 && tpVariation == 1)
			{
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.1875);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.3125);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

			if (riverExists != 1 && cNumberNonGaiaPlayers > 6 && tpVariation == 1)
			{
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.4375);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.5625);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

			if (riverExists != 1 && cNumberNonGaiaPlayers > 4 && tpVariation == 1)
			{
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.6875);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}

			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.8125);
	        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);

			if (riverExists != 1 && cNumberNonGaiaPlayers > 6 && tpVariation == 1)
			{
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.9375);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}
			}
		else {
			if (tpVariation > 6 || cNumberNonGaiaPlayers > 4) {
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.30);
				rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
				}

			if (tpVariation > 4 && riverExists != 1) {
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.50);
		        rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
				}

			if (tpVariation > 6 || cNumberNonGaiaPlayers > 4) {
				socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.70);
	    	 	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
				}

			socketLoc1 = rmGetTradeRouteWayPoint(tradeRouteID, 0.90);
			rmPlaceObjectDefAtPoint(socketID, 0, socketLoc1);
			}
}

//	rmClearClosestPointConstraints();

	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.9);
   else
   rmSetStatusText("", 0.1);
   
// ============= Big Island =============
	if(oceanRing == 1)
	{
		rmEchoInfo("ocean ring");
	}

// ============= Land Only =============
	if(landOnly == 1)
	{
		rmEchoInfo("just land no water");
	}

// ============= River Across Middle =============
	if(riverExists == 1)
	{

		int unknownRiver = rmRiverCreate(-1, riverName, 7, 10, 5, 8);

		// Spin river randomly around the edge		
		if(riverPosition == 1)
			rmRiverSetConnections(unknownRiver, 0.0, 0.5, 1.0, 0.5);
		else if(riverPosition == 2)
			rmRiverSetConnections(unknownRiver, 0.0, 0.0, 1.0, 1.0);
		else if(riverPosition == 3)
			rmRiverSetConnections(unknownRiver, 0.5, 0.0, 0.5, 1.0);
		else if(riverPosition == 4)
			rmRiverSetConnections(unknownRiver, 0.0, 1.0, 1.0, 0.0);
		else if(riverPosition == 5)
			rmRiverSetConnections(unknownRiver, 0.0, 0.25, 1.0, 0.75);
		else if(riverPosition == 6)
			rmRiverSetConnections(unknownRiver, 0.0, 0.75, 1.0, 0.25);
		else if(riverPosition == 7)
			rmRiverSetConnections(unknownRiver, 0.25, 0.0, 0.75, 1.0);
		else
			rmRiverSetConnections(unknownRiver, 0.75, 0.0, 0.25, 1.0);
		if (rmRandFloat(0,1) <= 0.9999 || rmGetIsTreaty() == true)
		{
			// River always has 3 shallows
			rmRiverSetShallowRadius(unknownRiver, rmRandInt(10, 12));
			rmRiverAddShallow(unknownRiver, 0.10); 
			rmRiverAddShallow(unknownRiver, 0.15); 
			rmRiverAddShallow(unknownRiver, 0.20); 

				rmRiverSetShallowRadius(unknownRiver, rmRandInt(10, 12));
				rmRiverAddShallow(unknownRiver, 0.5);

			rmRiverSetShallowRadius(unknownRiver, rmRandInt(10, 12));
			rmRiverAddShallow(unknownRiver, 0.80);
			rmRiverAddShallow(unknownRiver, 0.85);
			rmRiverAddShallow(unknownRiver, 0.90);
			// sometimes fully shallow
			if (fullShallow == 1)
			{
				rmRiverAddShallow(unknownRiver, 0.05);
				rmRiverAddShallow(unknownRiver, 0.10);
				rmRiverAddShallow(unknownRiver, 0.15);
				rmRiverAddShallow(unknownRiver, 0.20);
				rmRiverAddShallow(unknownRiver, 0.25);
				rmRiverAddShallow(unknownRiver, 0.30);
				rmRiverAddShallow(unknownRiver, 0.35);
				rmRiverAddShallow(unknownRiver, 0.40);
				rmRiverAddShallow(unknownRiver, 0.45);
				rmRiverAddShallow(unknownRiver, 0.50);
				rmRiverAddShallow(unknownRiver, 0.55);
				rmRiverAddShallow(unknownRiver, 0.60);
				rmRiverAddShallow(unknownRiver, 0.65);
				rmRiverAddShallow(unknownRiver, 0.70);
				rmRiverAddShallow(unknownRiver, 0.75);
				rmRiverAddShallow(unknownRiver, 0.80);
				rmRiverAddShallow(unknownRiver, 0.85);
				rmRiverAddShallow(unknownRiver, 0.90);
				rmRiverAddShallow(unknownRiver, 0.95);
			}
		}
		rmRiverSetBankNoiseParams(unknownRiver, 0.07, 2, 1.5, 10.0, 0.667, 3.0);
		if (rmRandFloat(0,1) <= 0.9)
		rmRiverBuild(unknownRiver);
	}

// ============= Great Lakes Style Ocean =============
	if(oceanMiddle == 1)
	{
		// But don't build ocean every single time
		int oceanChance = rmRandInt(1,5);
		if (rmGetIsTreaty() == false)
		{
			rmEchoInfo("it's not treaty so there's a higher chance of water");
			oceanChance = rmRandInt(1,4);
			if (oceanChance == 2 && rmRandFloat(0,1) <= 0.15)
				oceanChance = 1;
			if (oceanChance == 3 && rmRandFloat(0,1) <= 0.15)
				oceanChance = 1;
			if (oceanChance == 4 && rmRandFloat(0,1) <= 0.15)
				oceanChance = 1;
		}
//			oceanChance = 1;		// for testing

		if(oceanChance == 1)
		{
			int sideBay = -1;
			if (oceanOffCenter == 1 && rmRandFloat(0,1) <= 0.50)
				sideBay = 1;

			int lakeOfTheUnknown=rmCreateArea("big lake in middle");
			if (rockiesMap == 1 && rmRandFloat(0,1) <= 0.50)
			{
				frozenLake = 1;
				rmSetAreaMix(lakeOfTheUnknown, "great_lakes_ice");
				rmAddAreaToClass(lakeOfTheUnknown, pondClass);
				rmAddAreaToClass(lakeOfTheUnknown, classCliff);
				rmAddAreaToClass(lakeOfTheUnknown, classCanyon);
			}
			else
				rmSetAreaWaterType(lakeOfTheUnknown, oceanName);
			if(sideBay == 1)
			{
				rmSetAreaSize(lakeOfTheUnknown, 0.10, 0.11);
				rmEchoInfo("largest lake");
			}
			else if(oceanOffCenter == 1)
			{
				rmSetAreaSize(lakeOfTheUnknown, 0.05, 0.06);
				rmEchoInfo("smallest lake");
			}
			else if(rmRandFloat(0,1) < 0.4)
			{
				rmSetAreaSize(lakeOfTheUnknown, 0.08, 0.10);
				rmEchoInfo("larger lake");
			}
			else
			{
				rmSetAreaSize(lakeOfTheUnknown, 0.06, 0.08);
			rmEchoInfo("smaller lake");
			}
			if (sideBay == 1)
			{
				if(bayPosition < 0.12)
					rmSetAreaLocation(lakeOfTheUnknown, 1.0, 1.0);
				else if(bayPosition < 0.24)
					rmSetAreaLocation(lakeOfTheUnknown, 1.0, 0.5);
				else if(bayPosition < 0.36)
					rmSetAreaLocation(lakeOfTheUnknown, 1.0, 0.0);
				else if(bayPosition < 0.48)
					rmSetAreaLocation(lakeOfTheUnknown, 0.5, 0.0);
				else if(bayPosition < 0.60)
					rmSetAreaLocation(lakeOfTheUnknown, 0.0, 0.0);
				else if(bayPosition < 0.72)
					rmSetAreaLocation(lakeOfTheUnknown, 0.0, 0.5);
				else if(bayPosition < 0.84)
					rmSetAreaLocation(lakeOfTheUnknown, 0.0, 1.0);
				else
					rmSetAreaLocation(lakeOfTheUnknown, 0.5, 1.0);
			}
			else
				rmSetAreaLocation(lakeOfTheUnknown, 0.5, 0.5);
			rmAddAreaConstraint(lakeOfTheUnknown, avoidPlayersFar1);
	//		rmSetAreaSmoothDistance(lakeOfTheUnknown, 50);
			rmSetAreaCoherence(lakeOfTheUnknown, 0.666);
			rmAddAreaConstraint(lakeOfTheUnknown, avoidTradeRoute);
			rmAddAreaConstraint(lakeOfTheUnknown, avoidTradeRouteSocketShort);
		}
		else if (oceanChance == 2)
		{
			int mountID = rmCreateArea("central mountain");
			rmSetAreaSize(mountID, 0.04, 0.06); 
			rmSetAreaWarnFailure(mountID, false);
			rmSetAreaObeyWorldCircleConstraint(mountID, true);
			rmSetAreaCliffType(mountID, cliffName); 
			rmSetAreaTerrainType(mountID, "cave\cave_ground5");
			if (rmRandFloat(0,1) <= 0.50 || floodedLand == 1)
				rmSetAreaCliffHeight(mountID, 10, 0.0, 0.8);
			else
				rmSetAreaCliffHeight(mountID, -10, 0.0, 0.8);
			rmSetAreaCliffEdge(mountID, 1, 1.00, 0.0, 1.0, 1);
			rmSetAreaCoherence(mountID, 0.69);
			rmAddAreaToClass(mountID, pondClass);
			rmAddAreaToClass(mountID, classCliff);
			rmAddAreaToClass(mountID, classCanyon);
			rmSetAreaReveal(mountID, 01);
			if (sideBay == 1)
			{
				if(bayPosition < 0.12)
					rmSetAreaLocation(mountID, 1.0, 1.0);
				else if(bayPosition < 0.24)
					rmSetAreaLocation(mountID, 1.0, 0.5);
				else if(bayPosition < 0.36)
					rmSetAreaLocation(mountID, 1.0, 0.0);
				else if(bayPosition < 0.48)
					rmSetAreaLocation(mountID, 0.5, 0.0);
				else if(bayPosition < 0.60)
					rmSetAreaLocation(mountID, 0.0, 0.0);
				else if(bayPosition < 0.72)
					rmSetAreaLocation(mountID, 0.0, 0.5);
				else if(bayPosition < 0.84)
					rmSetAreaLocation(mountID, 0.0, 1.0);
				else
					rmSetAreaLocation(mountID, 0.5, 1.0);
			}
			else
				rmSetAreaLocation(mountID, 0.5, 0.5);
			rmAddAreaConstraint(mountID, avoidTradeRoute);
			rmAddAreaConstraint(mountID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(mountID, avoidPlayersFar1);
			rmBuildArea(mountID);

			int stayInMountain = rmCreateAreaMaxDistanceConstraint("stay in mount", mountID, 0.0);
			int stayNearMountain = rmCreateAreaMaxDistanceConstraint("stay near mount", mountID, 3.0);
			int avoidRampsMountain = rmCreateCliffRampDistanceConstraint("avoid mount ramps", mountID, 4.0);

			int mountPaintID = rmCreateArea("mount paint");
			rmSetAreaSize(mountPaintID, 0.14); 
			rmSetAreaMix(mountPaintID, landName);
			rmSetAreaCoherence(mountPaintID, 0.999);
			rmSetAreaLocation(mountPaintID, 0.50, 0.50);
			rmAddAreaConstraint(mountPaintID, stayNearMountain);
			rmBuildArea(mountPaintID);
		}
		else if (oceanChance == 3)
		{
			int caveID = rmCreateArea("cave");
			rmSetAreaSize(caveID, 0.15); 
			rmSetAreaWarnFailure(caveID, false);
			rmSetAreaObeyWorldCircleConstraint(caveID, true);
			rmSetAreaCliffType(caveID, "cave"); 
			rmSetAreaTerrainType(caveID, "cave\cave_ground5");
			if (floodedLand == 1)
				rmSetAreaCliffHeight(caveID, 4, 0.0, 0.8);
			else
				rmSetAreaCliffHeight(caveID, -4, 0.0, 0.8);
			rmSetAreaCliffEdge(caveID, 6, 0.07, 0.0, 1.0, 1);
			rmSetAreaCoherence(caveID, 0.69);
			rmAddAreaToClass(caveID, classCanyon);
			rmSetAreaSmoothDistance(caveID, 6);
			if (sideBay == 1)
			{
				if(bayPosition < 0.12)
					rmSetAreaLocation(caveID, 1.0, 1.0);
				else if(bayPosition < 0.24)
					rmSetAreaLocation(caveID, 1.0, 0.5);
				else if(bayPosition < 0.36)
					rmSetAreaLocation(caveID, 1.0, 0.0);
				else if(bayPosition < 0.48)
					rmSetAreaLocation(caveID, 0.5, 0.0);
				else if(bayPosition < 0.60)
					rmSetAreaLocation(caveID, 0.0, 0.0);
				else if(bayPosition < 0.72)
					rmSetAreaLocation(caveID, 0.0, 0.5);
				else if(bayPosition < 0.84)
					rmSetAreaLocation(caveID, 0.0, 1.0);
				else
					rmSetAreaLocation(caveID, 0.5, 1.0);
			}
			else
				rmSetAreaLocation(caveID, 0.50, 0.50);
			rmAddAreaConstraint(caveID, avoidTradeRoute);
			rmAddAreaConstraint(caveID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(caveID, avoidPlayersFar1);
			rmBuildArea(caveID);

			int stayInCave = rmCreateAreaMaxDistanceConstraint("stay in cave", caveID, 0.0);
			int stayNearCave = rmCreateAreaMaxDistanceConstraint("stay near cave", caveID, 3.0);
			int avoidRamps = rmCreateCliffRampDistanceConstraint("avoid cave ramps", caveID, 4.0);

			int cavePaintID = rmCreateArea("cave paint");
			rmSetAreaSize(cavePaintID, 0.17); 
			rmSetAreaMix(cavePaintID, "caves2");
			rmSetAreaCoherence(cavePaintID, 0.999);
			rmSetAreaLocation(cavePaintID, 0.50, 0.50);
			rmAddAreaConstraint(cavePaintID, stayNearCave);
			rmBuildArea(cavePaintID);

			int stayNearCaveCliff = -1;

			for (i=0; <6+3*cNumberNonGaiaPlayers)
			{
				int caveCliffID=rmCreateArea("cave cliff"+i);
				rmSetAreaSize(caveCliffID, 0.001, 0.002);
				rmSetAreaCliffType(caveCliffID, "cave");  
				rmSetAreaTerrainType(caveCliffID, "cave\cave_top_a");
				rmAddAreaToClass(caveCliffID, classCliff);
				rmSetAreaCliffHeight(caveCliffID, 8, 0.0, 0.4);
				rmSetAreaCliffEdge(caveCliffID, 1, 1.0, 0.0, 0.0, 1);
				rmSetAreaCoherence(caveCliffID, 0.69);
				rmAddAreaConstraint(caveCliffID, stayInCave);
				rmAddAreaConstraint(caveCliffID, shortAvoidImpassableLand);
				rmAddAreaConstraint(caveCliffID, avoidRamps);
				rmAddAreaConstraint(caveCliffID, avoidCliffs);
				rmBuildArea(caveCliffID);

				stayNearCaveCliff = rmCreateAreaMaxDistanceConstraint("stay near cave cliff"+i, caveCliffID, 4.0);

				int paintCliffID=rmCreateArea("paint cliff"+i);
				rmSetAreaSize(paintCliffID, 0.004);
				rmSetAreaTerrainType(paintCliffID, "cave\cave_top");
				rmSetAreaCoherence(paintCliffID, 0.999);
				rmAddAreaConstraint(paintCliffID, stayNearCaveCliff);
				rmBuildArea(paintCliffID);
			}
		}
		else if (oceanChance == 4)
		{
			int plateauID = rmCreateArea("central plateau");
			rmSetAreaSize(plateauID, 0.12); 
			rmSetAreaWarnFailure(plateauID, false);
			rmSetAreaObeyWorldCircleConstraint(plateauID, true);
			rmSetAreaCliffType(plateauID, cliffName); 
			rmSetAreaTerrainType(plateauID, "cave\cave_ground5");
			if (rmRandFloat(0,1) <= 0.50 || floodedLand == 1)
				rmSetAreaCliffHeight(plateauID, 6, 0.0, 0.8);
			else
				rmSetAreaCliffHeight(plateauID, -6, 0.0, 0.8);
			rmSetAreaCliffEdge(plateauID, 6, 0.07, 0.0, 1.0, 1);
			rmSetAreaCoherence(plateauID, 0.69);
			rmAddAreaToClass(plateauID, classCanyon);
			rmSetAreaSmoothDistance(plateauID, 6);
			if (sideBay == 1)
			{
				if(bayPosition < 0.12)
					rmSetAreaLocation(plateauID, 1.0, 1.0);
				else if(bayPosition < 0.24)
					rmSetAreaLocation(plateauID, 1.0, 0.5);
				else if(bayPosition < 0.36)
					rmSetAreaLocation(plateauID, 1.0, 0.0);
				else if(bayPosition < 0.48)
					rmSetAreaLocation(plateauID, 0.5, 0.0);
				else if(bayPosition < 0.60)
					rmSetAreaLocation(plateauID, 0.0, 0.0);
				else if(bayPosition < 0.72)
					rmSetAreaLocation(plateauID, 0.0, 0.5);
				else if(bayPosition < 0.84)
					rmSetAreaLocation(plateauID, 0.0, 1.0);
				else
					rmSetAreaLocation(plateauID, 0.5, 1.0);
			}
			else
				rmSetAreaLocation(plateauID, 0.50, 0.50);
			rmAddAreaConstraint(plateauID, avoidTradeRoute);
			rmAddAreaConstraint(plateauID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(plateauID, avoidPlayersFar1);
			rmBuildArea(plateauID);

			int stayInPlateau = rmCreateAreaMaxDistanceConstraint("stay in plateau", plateauID, 0.0);
			int stayNearPlateau = rmCreateAreaMaxDistanceConstraint("stay near plateau", plateauID, 3.0);
			int avoidRampsPlateau = rmCreateCliffRampDistanceConstraint("avoid plateau ramps", plateauID, 4.0);

			int plateauPaintID = rmCreateArea("plateau paint");
			rmSetAreaSize(plateauPaintID, 0.14); 
			rmSetAreaMix(plateauPaintID, landName);
			rmSetAreaCoherence(plateauPaintID, 0.999);
			rmSetAreaLocation(plateauPaintID, 0.50, 0.50);
			rmAddAreaConstraint(plateauPaintID, stayNearPlateau);
			rmBuildArea(plateauPaintID);

			if (rmRandFloat(0,1) <= 0.95)
			{
				for (i=0; <2+4*cNumberNonGaiaPlayers)
				{
    				int plateauForestID=rmCreateArea("plateau forest "+i);
    				rmSetAreaWarnFailure(plateauForestID, false);
    				rmSetAreaObeyWorldCircleConstraint(plateauForestID, true);
    				rmSetAreaSize(plateauForestID, rmAreaTilesToFraction(111));
					if (rmRandFloat(0,1) <= 0.01)
						rmSetAreaTerrainType(plateauForestID, "texas\nonpassable_temp"); 
					else
					{
    					if (rmRandFloat(0,1) <= 0.001)
							rmSetAreaForestType(plateauForestID, "unknown forest funky");
    					else 
							rmSetAreaForestType(plateauForestID, forestName);
						if (trollMap == 1)
						{
							rmSetAreaForestDensity(plateauForestID, 0.99);
							rmSetAreaForestClumpiness(plateauForestID, 0.99);
							rmSetAreaForestUnderbrush(plateauForestID, 0.99);
						}
						else
						{
							rmSetAreaForestDensity(plateauForestID, 0.8);
							rmSetAreaForestClumpiness(plateauForestID, 0.8);
							rmSetAreaForestUnderbrush(plateauForestID, 0.3);
						}
					}
    				rmSetAreaCoherence(plateauForestID, 0.5);
    				rmSetAreaSmoothDistance(plateauForestID, 0);
    				rmAddAreaToClass(plateauForestID, rmClassID("classForest")); 
    				rmAddAreaConstraint(plateauForestID, forestConstraint);
    				rmAddAreaConstraint(plateauForestID, stayInPlateau);
    				rmAddAreaConstraint(plateauForestID, avoidRampsPlateau);
    				rmAddAreaConstraint(plateauForestID, avoidAll);
					if (floodedLand != 1)
    				rmAddAreaConstraint(plateauForestID, shortAvoidImpassableLand); 
    				rmAddAreaConstraint(plateauForestID, avoidTradeRoute);
    				rmAddAreaConstraint(plateauForestID, avoidGoldMin);
    				rmAddAreaConstraint(plateauForestID, avoidTradeRouteSocketShort);

    				if(rmBuildArea(plateauForestID)==false)
    				{
    				   // Stop trying once we fail 3 times in a row.
    				   failCount++;
    				   if(failCount==5)
    				      break;
    				}
    				else
    				   failCount=0; 
				}
			}
			else
			{
				int isThataMine = rmRandFloat(0,1);

				for (i=0; < cNumberNonGaiaPlayers)
				{
					int plateauPropsID = rmCreateObjectDef("plateau props"+i);
					if (rmRandFloat(0,1) <= 0.69)
					{
						isThataMine = 0.00;
						rmAddObjectDefItem(plateauPropsID, propz, 1, 1.0);
					}
					else if (isThataMine <= 0.69)
					{
						if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(plateauPropsID, "ypMercFlailiphantMansabdar", 10, 8.0);
						else if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(plateauPropsID, "ypSHogunTokugawa", 10, 8.0);
						else if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(plateauPropsID, "deMercGatlingCamel", 10, 8.0);
						else
							rmAddObjectDefItem(plateauPropsID, "BerryBush", 10, 8.0);
					}
					else
						rmAddObjectDefItem(plateauPropsID, "deFauxMine", 1, 1.0);
					rmSetObjectDefMinDistance(plateauPropsID, 0.0);
					rmSetObjectDefMaxDistance(plateauPropsID, rmXFractionToMeters(0.10));
					rmAddObjectDefToClass(plateauPropsID, classGold);
					rmAddObjectDefConstraint(plateauPropsID, avoidAll);
					rmAddObjectDefConstraint(plateauPropsID, avoidTradeRouteSocketShort);
					rmAddObjectDefConstraint(plateauPropsID, avoidGoldFar);
    				rmAddAreaConstraint(plateauPropsID, stayInPlateau);
    				rmAddAreaConstraint(plateauPropsID, avoidRampsPlateau);
					if (floodedLand != 1)
    				rmAddAreaConstraint(plateauPropsID, shortAvoidImpassableLand); 
    				rmAddAreaConstraint(plateauPropsID, avoidTradeRoute);
					if (isThataMine > 0.69)
						rmPlaceObjectDefAtLoc(plateauPropsID, i, 0.50, 0.50, 1);
					else
						rmPlaceObjectDefAtLoc(plateauPropsID, 0, 0.50, 0.50, 1);
				}
			}
		}
		else
		{
			// just land
		}
	}

// Build the lake later to avoid players

// ============= Saguenay Style Ocean =============
	if(oceanOffCenter == 1)
	{
		// But don't build bay every single time
		int bayChance = rmRandInt(1,5);
		if (rmGetIsTreaty() == false)
		{
			rmEchoInfo("it's not treaty so there's a higher chance of water");
			bayChance = rmRandInt(1,4);
			if (bayChance == 2 && rmRandFloat(0,1) <= 0.25)
				bayChance = 1;
			if (bayChance == 3 && rmRandFloat(0,1) <= 0.25)
				bayChance = 1;
			if (bayChance == 4 && rmRandFloat(0,1) <= 0.25)
				bayChance = 1;
		}
//			bayChance = 3;		// for testing

		if (bayChance == 1)
		{
			int unknownBay=rmCreateArea("big bay on edge");
				if (rockiesMap == 1 && rmRandFloat(0,1) <= 0.50)
					rmSetAreaMix(unknownBay, "great_lakes_ice");
				else
					rmSetAreaWaterType(unknownBay, oceanName);
			rmSetAreaWarnFailure(unknownBay, false);
			if (oceanMiddle == 1)
				rmSetAreaSize(unknownBay, 0.11, 0.13);
			else
				rmSetAreaSize(unknownBay, 0.13, 0.15);

			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(unknownBay, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(unknownBay, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(unknownBay, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(unknownBay, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(unknownBay, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(unknownBay, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(unknownBay, 1.0, 0.0);
			else
				rmSetAreaLocation(unknownBay, 0.5, 0.0);
		   	rmSetAreaCoherence(unknownBay, 0.666);
	  		rmSetAreaObeyWorldCircleConstraint(unknownBay, false);
			rmAddAreaConstraint(unknownBay, avoidPlayersFar1);
			rmAddAreaConstraint(unknownBay, avoidTradeRoute);
			rmAddAreaConstraint(unknownBay, avoidTradeRouteSocket);
		}
		else if (bayChance == 2)
		{
			int mountSideID = rmCreateArea("side mountain");
			rmSetAreaSize(mountSideID, 0.06, 0.09); 
			rmSetAreaWarnFailure(mountSideID, false);
			rmSetAreaObeyWorldCircleConstraint(mountSideID, true);
			rmSetAreaCliffType(mountSideID, cliffName); 
			rmSetAreaTerrainType(mountSideID, "cave\cave_ground5");
			if (rmRandFloat(0,1) <= 0.50 || floodedLand == 1)
				rmSetAreaCliffHeight(mountSideID, 10, 0.0, 0.8);
			else
				rmSetAreaCliffHeight(mountSideID, -10, 0.0, 0.8);
			rmSetAreaCliffEdge(mountSideID, 1, 1.00, 0.0, 1.0, 1);
			rmSetAreaCoherence(mountSideID, 0.69);
			rmSetAreaReveal(mountSideID, 01);
			rmAddAreaToClass(mountSideID, pondClass);
			rmAddAreaToClass(mountSideID, classCliff);
			rmAddAreaToClass(mountSideID, classCanyon);
			rmSetAreaReveal(mountSideID, 01);
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(mountSideID, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(mountSideID, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(mountSideID, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(mountSideID, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(mountSideID, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(mountSideID, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(mountSideID, 1.0, 0.0);
			else
				rmSetAreaLocation(mountSideID, 0.5, 0.0);
			rmAddAreaConstraint(mountSideID, avoidTradeRoute);
			rmAddAreaConstraint(mountSideID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(mountSideID, avoidPlayersFar1);
			rmBuildArea(mountSideID);

			int stayInSideMountain = rmCreateAreaMaxDistanceConstraint("stay in side mount", mountSideID, 0.0);
			int stayNearSideMountain = rmCreateAreaMaxDistanceConstraint("stay near side mount", mountSideID, 3.0);
			int avoidRampsSideMountain = rmCreateCliffRampDistanceConstraint("avoid side mount ramps", mountSideID, 4.0);

			int mountSidePaintID = rmCreateArea("mount side paint");
			rmSetAreaSize(mountSidePaintID, 0.15); 
			rmSetAreaMix(mountSidePaintID, landName);
			rmSetAreaCoherence(mountSidePaintID, 0.999);
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(mountSidePaintID, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(mountSidePaintID, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(mountSidePaintID, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(mountSidePaintID, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(mountSidePaintID, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(mountSidePaintID, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(mountSidePaintID, 1.0, 0.0);
			else
				rmSetAreaLocation(mountSidePaintID, 0.5, 0.0);
			rmAddAreaConstraint(mountSidePaintID, stayNearSideMountain);
			rmBuildArea(mountSidePaintID);
		}
		else if (bayChance == 3)
		{
			int caveSideID = rmCreateArea("side cave");
			if (oceanMiddle == 1)
				rmSetAreaSize(caveSideID, 0.09, 0.11); 
			else
				rmSetAreaSize(caveSideID, 0.11, 0.13); 
			rmSetAreaWarnFailure(caveSideID, false);
			rmSetAreaObeyWorldCircleConstraint(caveSideID, true);
			rmSetAreaCliffType(caveSideID, "cave"); 
			rmSetAreaTerrainType(caveSideID, "cave\cave_ground5");
			if (floodedLand == 1)
				rmSetAreaCliffHeight(caveSideID, 4, 0.0, 0.8);
			else
				rmSetAreaCliffHeight(caveSideID, -4, 0.0, 0.8);
			rmSetAreaCliffEdge(caveSideID, 6, 0.07, 0.0, 1.0, 0);
			rmSetAreaCoherence(caveSideID, 0.69);
			rmAddAreaToClass(caveSideID, classCanyon);
			rmSetAreaSmoothDistance(caveSideID, 6);
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(caveSideID, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(caveSideID, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(caveSideID, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(caveSideID, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(caveSideID, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(caveSideID, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(caveSideID, 1.0, 0.0);
			else
				rmSetAreaLocation(caveSideID, 0.5, 0.0);
			rmAddAreaConstraint(caveSideID, avoidTradeRoute);
			rmAddAreaConstraint(caveSideID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(caveSideID, avoidPlayersFar1);
			rmBuildArea(caveSideID);

			int stayInSideCave = rmCreateAreaMaxDistanceConstraint("stay in side cave", caveSideID, 0.0);
			int stayNearSideCave = rmCreateAreaMaxDistanceConstraint("stay near side cave", caveSideID, 3.0);
			int avoidSideRamps = rmCreateCliffRampDistanceConstraint("avoid cave side ramps", caveSideID, 4.0);

			int caveSidePaintID = rmCreateArea("cave side paint");
			rmSetAreaSize(caveSidePaintID, 0.20); 
			rmSetAreaMix(caveSidePaintID, "caves2");
			rmSetAreaCoherence(caveSidePaintID, 0.999);
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(caveSidePaintID, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(caveSidePaintID, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(caveSidePaintID, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(caveSidePaintID, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(caveSidePaintID, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(caveSidePaintID, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(caveSidePaintID, 1.0, 0.0);
			else
				rmSetAreaLocation(caveSidePaintID, 0.5, 0.0);
			rmAddAreaConstraint(caveSidePaintID, stayNearSideCave);
			rmBuildArea(caveSidePaintID);

			int stayNearSideCaveCliff = -1;

			for (i=0; <6+3*cNumberNonGaiaPlayers)
			{
				int caveSideCliffID=rmCreateArea("cave side cliff"+i);
				rmSetAreaSize(caveSideCliffID, 0.001, 0.002);
				rmSetAreaCliffType(caveSideCliffID, "cave");  
				rmSetAreaTerrainType(caveSideCliffID, "cave\cave_top_a");
				rmAddAreaToClass(caveSideCliffID, classCliff);
				rmSetAreaCliffHeight(caveSideCliffID, 8, 0.0, 0.4);
				rmSetAreaCliffEdge(caveSideCliffID, 1, 1.0, 0.0, 0.0, 1);
				rmSetAreaCoherence(caveSideCliffID, 0.69);
				rmAddAreaConstraint(caveSideCliffID, stayInSideCave);
				rmAddAreaConstraint(caveSideCliffID, shortAvoidImpassableLand);
				rmAddAreaConstraint(caveSideCliffID, avoidSideRamps);
				rmAddAreaConstraint(caveSideCliffID, avoidCliffs);
				rmBuildArea(caveSideCliffID);

				stayNearSideCaveCliff = rmCreateAreaMaxDistanceConstraint("stay near side cave cliff"+i, caveSideCliffID, 4.0);

				int paintSideCliffID=rmCreateArea("paint side cliff"+i);
				rmSetAreaSize(paintSideCliffID, 0.004);
				rmSetAreaTerrainType(paintSideCliffID, "cave\cave_top");
				rmSetAreaCoherence(paintSideCliffID, 0.999);
				rmAddAreaConstraint(paintSideCliffID, stayNearSideCaveCliff);
				rmBuildArea(paintSideCliffID);
			}
		}
		else if (bayChance == 4)
		{
			int plateauSideID = rmCreateArea("side plateau");
			if (oceanMiddle == 1)
				rmSetAreaSize(plateauSideID, 0.08, 0.10); 
			else
				rmSetAreaSize(plateauSideID, 0.09, 0.12); 
			rmSetAreaWarnFailure(plateauSideID, false);
			rmSetAreaObeyWorldCircleConstraint(plateauSideID, true);
			rmSetAreaCliffType(plateauSideID, cliffName); 
			rmSetAreaTerrainType(plateauSideID, "cave\cave_ground5");
			if (rmRandFloat(0,1) <= 0.50 || floodedLand == 1)
				rmSetAreaCliffHeight(plateauSideID, 6, 0.0, 0.8);
			else
				rmSetAreaCliffHeight(plateauSideID, -6, 0.0, 0.8);
			rmSetAreaCliffEdge(plateauSideID, 6, 0.07, 0.0, 1.0, 1);
			rmSetAreaCoherence(plateauSideID, 0.69);
			rmAddAreaToClass(plateauSideID, classCanyon);
			rmSetAreaSmoothDistance(plateauSideID, 6);
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(plateauSideID, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(plateauSideID, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(plateauSideID, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(plateauSideID, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(plateauSideID, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(plateauSideID, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(plateauSideID, 1.0, 0.0);
			else
				rmSetAreaLocation(plateauSideID, 0.5, 0.0);
			rmAddAreaConstraint(plateauSideID, avoidTradeRoute);
			rmAddAreaConstraint(plateauSideID, avoidTradeRouteSocketShort);
			rmAddAreaConstraint(plateauSideID, avoidPlayersFar1);
			rmBuildArea(plateauSideID);

			int stayInSidePlateau = rmCreateAreaMaxDistanceConstraint("stay in side plateau", plateauSideID, 0.0);
			int stayNearSidePlateau = rmCreateAreaMaxDistanceConstraint("stay near side plateau", plateauSideID, 3.0);
			int avoidSideRampsPlateau = rmCreateCliffRampDistanceConstraint("avoid plateau side ramps", plateauSideID, 4.0);

			int plateauSidePaintID = rmCreateArea("plateau side paint");
			rmSetAreaSize(plateauSidePaintID, 0.14); 
			rmSetAreaMix(plateauSidePaintID, landName);
			rmSetAreaCoherence(plateauSidePaintID, 0.999);
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(plateauSidePaintID, 0.01, 0.01);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(plateauSidePaintID, 0.01, 0.50);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(plateauSidePaintID, 0.01, 0.99);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(plateauSidePaintID, 0.50, 0.99);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(plateauSidePaintID, 0.99, 0.99);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(plateauSidePaintID, 0.99, 0.50);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(plateauSidePaintID, 0.99, 0.01);
			else
				rmSetAreaLocation(plateauSidePaintID, 0.50, 0.01);
			rmAddAreaConstraint(plateauSidePaintID, stayNearSidePlateau);
			rmBuildArea(plateauSidePaintID);

			if (rmRandFloat(0,1) <= 0.95)
			{
				for (i=0; <2+4*cNumberNonGaiaPlayers)
				{
    				int plateauSideForestID=rmCreateArea("plateau side forest "+i);
    				rmSetAreaWarnFailure(plateauSideForestID, false);
    				rmSetAreaObeyWorldCircleConstraint(plateauSideForestID, true);
    				rmSetAreaSize(plateauSideForestID, rmAreaTilesToFraction(111));
					if (rmRandFloat(0,1) <= 0.01)
						rmSetAreaTerrainType(plateauSideForestID, "texas\nonpassable_temp"); 
					else
					{
    					if (rmRandFloat(0,1) <= 0.001)
							rmSetAreaForestType(plateauSideForestID, "unknown forest funky");
    					else 
							rmSetAreaForestType(plateauSideForestID, forestName);
						if (trollMap == 1)
						{
							rmSetAreaForestDensity(plateauSideForestID, 0.99);
							rmSetAreaForestClumpiness(plateauSideForestID, 0.99);
							rmSetAreaForestUnderbrush(plateauSideForestID, 0.99);
						}
						else
						{
							rmSetAreaForestDensity(plateauSideForestID, 0.8);
							rmSetAreaForestClumpiness(plateauSideForestID, 0.8);
							rmSetAreaForestUnderbrush(plateauSideForestID, 0.3);
						}
					}
    				rmSetAreaCoherence(plateauSideForestID, 0.5);
    				rmSetAreaSmoothDistance(plateauSideForestID, 0);
    				rmAddAreaToClass(plateauSideForestID, rmClassID("classForest")); 
    				rmAddAreaConstraint(plateauSideForestID, forestConstraint);
    				rmAddAreaConstraint(plateauSideForestID, stayInSidePlateau);
    				rmAddAreaConstraint(plateauSideForestID, avoidSideRampsPlateau);
    				rmAddAreaConstraint(plateauSideForestID, avoidAll);
					if (floodedLand != 1)
    				rmAddAreaConstraint(plateauSideForestID, shortAvoidImpassableLand); 
    				rmAddAreaConstraint(plateauSideForestID, avoidTradeRoute);
    				rmAddAreaConstraint(plateauSideForestID, avoidGoldMin);
    				rmAddAreaConstraint(plateauSideForestID, avoidTradeRouteSocketShort);

    				if(rmBuildArea(plateauSideForestID)==false)
    				{
    				   // Stop trying once we fail 3 times in a row.
    				   failCount++;
    				   if(failCount==5)
    				      break;
    				}
    				else
    				   failCount=0; 
				}
			}
			else
			{
				int isThataSideMine = rmRandFloat(0,1);

				for (i=0; < cNumberNonGaiaPlayers)
				{
					int plateauSidePropsID = rmCreateObjectDef("plateau side props"+i);
					if (rmRandFloat(0,1) <= 0.69)
					{
						isThataSideMine = 0.00;
						rmAddObjectDefItem(plateauSidePropsID, propz, 1, 1.0);
					}
					else if (isThataSideMine <= 0.69)
					{
						if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(plateauSidePropsID, "ypMercFlailiphantMansabdar", 10, 8.0);
						else if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(plateauSidePropsID, "ypSHogunTokugawa", 10, 8.0);
						else if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(plateauSidePropsID, "deMercGatlingCamel", 10, 8.0);
						else
							rmAddObjectDefItem(plateauSidePropsID, "BerryBush", 10, 8.0);
					}
					else
						rmAddObjectDefItem(plateauSidePropsID, "deFauxMine", 1, 1.0);
					rmSetObjectDefMinDistance(plateauSidePropsID, 0.0);
					rmSetObjectDefMaxDistance(plateauSidePropsID, rmXFractionToMeters(0.10));
					rmAddObjectDefToClass(plateauSidePropsID, classGold);
					rmAddObjectDefConstraint(plateauSidePropsID, avoidAll);
					rmAddObjectDefConstraint(plateauSidePropsID, avoidTradeRouteSocketShort);
					rmAddObjectDefConstraint(plateauSidePropsID, avoidGoldFar);
    				rmAddAreaConstraint(plateauSidePropsID, stayInPlateau);
    				rmAddAreaConstraint(plateauSidePropsID, avoidRampsPlateau);
					if (floodedLand != 1)
    				rmAddAreaConstraint(plateauSidePropsID, shortAvoidImpassableLand); 
    				rmAddAreaConstraint(plateauSidePropsID, avoidTradeRoute);
					if (isThataSideMine > 0.69)
						rmPlaceObjectDefAtLoc(plateauSidePropsID, i, 0.50, 0.50, 1);
					else
						rmPlaceObjectDefAtLoc(plateauSidePropsID, 0, 0.50, 0.50, 1);
				}
			}
		}
		else	// side forest
		{
			int sideUnknownForest=rmCreateArea("large side forest");
		      rmSetAreaWarnFailure(sideUnknownForest, false);
		      rmSetAreaSize(sideUnknownForest, 0.09);
		      rmSetAreaForestType(sideUnknownForest, forestName);
			  rmSetAreaForestDensity(sideUnknownForest, 0.99);
			  rmSetAreaForestClumpiness(sideUnknownForest, 0.99);
			  rmSetAreaForestUnderbrush(sideUnknownForest, 0.99);
		      rmSetAreaCoherence(sideUnknownForest, 0.15);
		      rmAddAreaToClass(sideUnknownForest, rmClassID("classForest"));
			// Spin bay randomly around the edge		
			if(bayPosition < 0.12)
				rmSetAreaLocation(sideUnknownForest, 0.0, 0.0);
			else if(bayPosition < 0.24)
				rmSetAreaLocation(sideUnknownForest, 0.0, 0.5);
			else if(bayPosition < 0.36)
				rmSetAreaLocation(sideUnknownForest, 0.0, 1.0);
			else if(bayPosition < 0.48)
				rmSetAreaLocation(sideUnknownForest, 0.5, 1.0);
			else if(bayPosition < 0.60)
				rmSetAreaLocation(sideUnknownForest, 1.0, 1.0);
			else if(bayPosition < 0.72)
				rmSetAreaLocation(sideUnknownForest, 1.0, 0.5);
			else if(bayPosition < 0.84)
				rmSetAreaLocation(sideUnknownForest, 1.0, 0.0);
			else
				rmSetAreaLocation(sideUnknownForest, 0.5, 0.0);
		      rmAddAreaConstraint(sideUnknownForest, avoidPlayersFar1); 
		      rmAddAreaConstraint(sideUnknownForest, avoidTradeRoute); 
		      rmAddAreaConstraint(sideUnknownForest, avoidTradeRouteSocketShort); 
		}
	}
	
	// Build bay later to avoid players				  

// ============= Oasis Style Forest =============
	if (forestMiddle == 1)
	{
		if (rmRandFloat(0,1) > 0.25 && trollMap != 1) {
			int greatUnknownForest=rmCreateArea("large central forest");
		      rmSetAreaWarnFailure(greatUnknownForest, false);
		      rmSetAreaSize(greatUnknownForest, 0.07);
		      rmSetAreaForestType(greatUnknownForest, forestName);
			  rmSetAreaForestDensity(greatUnknownForest, 0.99);
			  rmSetAreaForestClumpiness(greatUnknownForest, 0.99);
			  rmSetAreaForestUnderbrush(greatUnknownForest, 0.99);
		      rmSetAreaCoherence(greatUnknownForest, 0.15);
		      rmAddAreaToClass(greatUnknownForest, rmClassID("classForest"));
				rmSetAreaLocation(greatUnknownForest, 0.5, 0.5);
		      rmAddAreaConstraint(greatUnknownForest, avoidPlayersFar1); 
		      rmAddAreaConstraint(greatUnknownForest, avoidTradeRoute); 
		      rmAddAreaConstraint(greatUnknownForest, avoidTradeRouteSocketShort); 
			}
		else {
				if (trollMap == 1 || rmRandFloat(0,1) <= 0.001) {
					rmEchoInfo("bonus subCiv is Saltpeter");
					int saltPeterSiteID = rmCreateGrouping("saltpeter site", "saltpeter_0"+rmRandInt(1,3));
					rmSetGroupingMinDistance(saltPeterSiteID, rmXFractionToMeters(0.00));
					rmSetGroupingMaxDistance(saltPeterSiteID, rmXFractionToMeters(0.025));
					rmAddGroupingToClass(saltPeterSiteID, rmClassID("natives"));
					if (floodedLand != 1)
						rmAddGroupingConstraint(saltPeterSiteID, avoidImpassableLand);
					rmAddGroupingConstraint(saltPeterSiteID, avoidTradeRoute);
					rmAddGroupingConstraint(saltPeterSiteID, avoidTradeRouteSocket);
					rmAddGroupingConstraint(saltPeterSiteID, avoidAllFar);
					rmPlaceGroupingAtLoc(saltPeterSiteID, 0, 0.5, 0.5);
					}

				int toFauxOrNotToFaux = rmRandFloat(0,1);

				for (i=0; < 4*cNumberNonGaiaPlayers)
				{
					int rushMineID = rmCreateObjectDef("mineral rush"+i);
					if (rmRandFloat(0,1) <= 0.98)
					{
						toFauxOrNotToFaux = 0.00;
						if (rmRandFloat(0,1) <= 0.05)
							rmAddObjectDefItem(rushMineID, "BerryBush", 10, 8.0);
						else
							rmAddObjectDefItem(rushMineID, mineralz, 1, 1.0);
					}
					else if (toFauxOrNotToFaux <= 0.50)
					{
						if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(rushMineID, "ypMercFlailiphantMansabdar", 10, 8.0);
						else if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(rushMineID, "ypSHogunTokugawa", 10, 8.0);
						else if (rmRandFloat(0,1) <= 0.001)
							rmAddObjectDefItem(rushMineID, "deMercGatlingCamel", 10, 8.0);
						else
							rmAddObjectDefItem(rushMineID, "BerryBush", 10, 8.0);
					}
					else
						rmAddObjectDefItem(rushMineID, "deFauxMine", 1, 1.0);
					rmSetObjectDefMinDistance(rushMineID, 0.0);
					rmSetObjectDefMaxDistance(rushMineID, rmXFractionToMeters(0.10));
					rmAddObjectDefToClass(rushMineID, classGold);
					rmAddObjectDefConstraint(rushMineID, avoidAll);
					rmAddObjectDefConstraint(rushMineID, avoidTradeRouteSocketShort);
					rmAddObjectDefConstraint(rushMineID, avoidGoldShort);
					if (toFauxOrNotToFaux > 0.50)
						rmPlaceObjectDefAtLoc(rushMineID, i, 0.50, 0.50, 1);
					else
						rmPlaceObjectDefAtLoc(rushMineID, 0, 0.50, 0.50, 1);
				}
			}
		}
	
// Build forest later to avoid players

	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.8);
   else
   rmSetStatusText("", 0.2);
   
// ============= Player Configurations =============
float aValue = 1.0/cNumberNonGaiaPlayers;

// Sometimes teams closer together
	if (rmGetNomadStart() == true)
	{
		if (cNumberTeams == 2)
		{
			rmSetPlacementTeam(0);
			rmSetPlacementSection(0.01, 0.00);
			rmPlacePlayersCircular(0.30, 0.40, 0);

			rmSetPlacementTeam(1);
			rmSetPlacementSection(0.01+aValue, 0.00+aValue);
			rmPlacePlayersCircular(0.30, 0.40, 0.0);
		}
		else
		{
			rmSetTeamSpacingModifier(0.50);
			rmPlacePlayersCircular(0.30, 0.40, 0);
		}
	}
	else
	{
		if (riverExists == 1)
		{
			rmSetTeamSpacingModifier(0.75);
		}
		else if (oceanMiddle == 1)
		{
			rmSetTeamSpacingModifier(0.60);
		}
		else
		{
			rmSetTeamSpacingModifier(0.50);
		}

		if(oceanOffCenter == 1)
		{
			int teamNombre = rmRandInt(1,2);
			int teamZero = -1;
			int teamOne = -1;
			if (teamNombre == 1)
			{
				teamZero = 0;
				teamOne = 1;
			}
			else
			{
				teamZero = 1;
				teamOne = 0;
			}

			if (cNumberTeams > 2 || rmGetNumberPlayersOnTeam(0) != rmGetNumberPlayersOnTeam(1))
			{
				if (bayPosition < 0.12)
					rmSetPlacementSection(0.800, 0.450);
				else if (bayPosition < 0.24)
					rmSetPlacementSection(0.925, 0.575);
				else if (bayPosition < 0.36)
					rmSetPlacementSection(0.070, 0.700);
				else if (bayPosition < 0.48)
					rmSetPlacementSection(0.195, 0.825);
				else if (bayPosition < 0.60)
					rmSetPlacementSection(0.300, 0.950);
				else if (bayPosition < 0.72)
					rmSetPlacementSection(0.425, 0.055);
				else if (bayPosition < 0.84)
					rmSetPlacementSection(0.550, 0.180);
				else 
					rmSetPlacementSection(0.685, 0.315);
				rmSetTeamSpacingModifier(0.50);
				if (cNumberNonGaiaPlayers <= 4)
					rmPlacePlayersCircular(0.36, 0.36, 0);
				else
					rmPlacePlayersCircular(0.37, 0.37, 0);
			}
			else
			{
				rmSetPlacementTeam(teamZero);
				if (cNumberNonGaiaPlayers == 2)
				{
					if (bayPosition < 0.12)
						rmSetPlacementSection(0.450, 0.451);
					else if (bayPosition < 0.24)
						rmSetPlacementSection(0.575, 0.576);
					else if (bayPosition < 0.36)
						rmSetPlacementSection(0.700, 0.701);
					else if (bayPosition < 0.48)
						rmSetPlacementSection(0.825, 0.826);
					else if (bayPosition < 0.60)
						rmSetPlacementSection(0.950, 0.951);
					else if (bayPosition < 0.72)
						rmSetPlacementSection(0.055, 0.056);
					else if (bayPosition < 0.84)
						rmSetPlacementSection(0.180, 0.181);
					else 
						rmSetPlacementSection(0.315, 0.316);
				}
				else
				{
					if (bayPosition < 0.12)
						rmSetPlacementSection(0.450-0.022*cNumberNonGaiaPlayers, 0.450);
					else if (bayPosition < 0.24)
						rmSetPlacementSection(0.575-0.022*cNumberNonGaiaPlayers, 0.575);
					else if (bayPosition < 0.36)
						rmSetPlacementSection(0.700-0.022*cNumberNonGaiaPlayers, 0.700);
					else if (bayPosition < 0.48)
						rmSetPlacementSection(0.825-0.022*cNumberNonGaiaPlayers, 0.825);
					else if (bayPosition < 0.60)
						rmSetPlacementSection(0.950-0.022*cNumberNonGaiaPlayers, 0.950);
					else if (bayPosition < 0.72)
						rmSetPlacementSection(0.055-0.022*cNumberNonGaiaPlayers, 0.055);
					else if (bayPosition < 0.84)
						rmSetPlacementSection(0.180-0.022*cNumberNonGaiaPlayers, 0.180);
					else 
						rmSetPlacementSection(0.315-0.022*cNumberNonGaiaPlayers, 0.315);
				}
				rmSetTeamSpacingModifier(0.50);
				if (cNumberNonGaiaPlayers <= 4)
					rmPlacePlayersCircular(0.36, 0.36, 0);
				else
					rmPlacePlayersCircular(0.37, 0.37, 0);

				rmSetPlacementTeam(teamOne);
				if (bayPosition < 0.12)
					rmSetPlacementSection(0.800, 0.800+0.022*cNumberNonGaiaPlayers);
				else if (bayPosition < 0.24)
					rmSetPlacementSection(0.925, 0.925+0.022*cNumberNonGaiaPlayers);
				else if (bayPosition < 0.36)
					rmSetPlacementSection(0.070, 0.070+0.022*cNumberNonGaiaPlayers);
				else if (bayPosition < 0.48)
					rmSetPlacementSection(0.195, 0.195+0.022*cNumberNonGaiaPlayers);
				else if (bayPosition < 0.60)
					rmSetPlacementSection(0.300, 0.300+0.022*cNumberNonGaiaPlayers);
				else if (bayPosition < 0.72)
					rmSetPlacementSection(0.425, 0.425+0.022*cNumberNonGaiaPlayers);
				else if (bayPosition < 0.84)
					rmSetPlacementSection(0.550, 0.550+0.022*cNumberNonGaiaPlayers);
				else 
					rmSetPlacementSection(0.685, 0.685+0.022*cNumberNonGaiaPlayers);
				rmSetTeamSpacingModifier(0.50);
				if (cNumberNonGaiaPlayers <= 4)
					rmPlacePlayersCircular(0.36, 0.36, 0);
				else
					rmPlacePlayersCircular(0.37, 0.37, 0);
			}
		}
		else if (oceanMiddle == 1)
		{
			if (cNumberNonGaiaPlayers <= 4)
				rmPlacePlayersCircular(0.36, 0.36, 0);
			else
				rmPlacePlayersCircular(0.37, 0.37, 0);
			rmEchoInfo("players nearer edge because ocean in middle");
		}
		else if(oceanRing == 1)
		{
			rmPlacePlayersCircular(0.32, 0.34, 0);
			rmEchoInfo("players very far from edge because of continent");
		}
		else
		{
			rmPlacePlayersCircular(0.32, 0.36, 0);
			rmEchoInfo("players can be farther from edge");
		}
	}
	float playerFraction = rmAreaTilesToFraction(420);

	for(i=1; <cNumberPlayers)
   {
      // Create the area.
      int id=rmCreateArea("Player"+i);
		rmSetAreaObeyWorldCircleConstraint(id, true);
      // Assign to the player.
      rmSetPlayerArea(i, id);
      // Set the size.
      rmSetAreaSize(id, playerFraction);
	  if (rmGetNomadStart() == false)
	      rmAddAreaToClass(id, classPlayer);
      rmSetAreaMinBlobs(id, 1);
      rmSetAreaMaxBlobs(id, 1);
      rmAddAreaConstraint(id, avoidPlayers);
		// for testing areas
		if (floodedLand == 1)
		{
     		rmSetAreaMix(id, landName);
			rmSetAreaBaseHeight(id, 2);
		}
	   rmSetAreaCoherence(id, 0.777);
	   rmSetAreaSmoothDistance(id, 20);
		rmAddAreaConstraint(id, playerAvoidImpassableLand);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaWarnFailure(id, false);
		if (floodedLand == 1)
			rmBuildArea(id);
   }
	rmBuildAllAreas();

	if (oceanMiddle == 1)
	{
		if (oceanChance == 1)
		{
			int stayInLake = rmCreateAreaMaxDistanceConstraint("stay in lake", lakeOfTheUnknown, 0.0);

			if ((amazonMap == 1 && treasureIsle == 1) || trollMap == 1 || rmRandFloat(0,1) <= 0.01)
			{
				// Isles
				int islecount = 2+cNumberNonGaiaPlayers; 
				int stayInIsle = -1;
				int IsleMineID = -1;
				int IsleTreeID = -1;
				int IsleCritterID = -1;

				for (i= 0; < islecount) 
				{
					int IsleID = rmCreateArea("lake isle"+i);
					rmAddAreaToClass(IsleID, classCliff);
					rmSetAreaSize(IsleID, 0.003);
					rmSetAreaObeyWorldCircleConstraint(IsleID, true);
					rmSetAreaMix(IsleID, landName); 
					rmSetAreaBaseHeight(IsleID, 01);
					rmSetAreaReveal(IsleID, 01);
					rmSetAreaCoherence(IsleID, 0.69);
					rmAddAreaConstraint(IsleID, avoidCliffs);
					rmAddAreaConstraint(IsleID, fishLand);
					rmAddAreaConstraint(IsleID, stayInLake);
	//				rmAddAreaConstraint(IsleID, avoidPond);
					rmSetAreaWarnFailure(IsleID, false);
					rmBuildArea(IsleID);		

					stayInIsle = rmCreateAreaMaxDistanceConstraint("stay in  isle"+i, IsleID, 0.0);

					IsleMineID = rmCreateObjectDef("lake isle mine "+i);
					if (africanMap == 1)
					{
						if (rmRandFloat(0,1) <= 0.50)
							rmAddObjectDefItem(IsleMineID, "MineSalt", 1, 0.0);
						else
							rmAddObjectDefItem(IsleMineID, "mine", 1, 0.0);
					}
					else
						rmAddObjectDefItem(IsleMineID, mineralz, 1, 0.0);
					rmSetObjectDefMinDistance(IsleMineID, rmXFractionToMeters(0.00));
					rmSetObjectDefMaxDistance(IsleMineID, rmXFractionToMeters(0.50));
					rmAddObjectDefToClass(IsleMineID, rmClassID("classForest"));
					rmAddObjectDefConstraint(IsleMineID, stayInIsle);
					rmAddObjectDefConstraint(IsleMineID, avoidAll);
					rmPlaceObjectDefAtLoc(IsleMineID, 0, 0.50, 0.50, 1);

					IsleTreeID = rmCreateObjectDef("lake isle veg"+i);
					if (rmRandFloat(0,1) <= 0.001)
						rmAddObjectDefItem(IsleTreeID, propz, rmRandInt(1,3), 3.0);
					else
						rmAddObjectDefItem(IsleTreeID, treeName, rmRandInt(1,3), 3.0);
					rmSetObjectDefMinDistance(IsleTreeID, rmXFractionToMeters(0.00));
					rmSetObjectDefMaxDistance(IsleTreeID, rmXFractionToMeters(0.50));
					rmAddObjectDefToClass(IsleTreeID, rmClassID("classForest"));
					rmAddObjectDefConstraint(IsleTreeID, stayInIsle);
					rmAddObjectDefConstraint(IsleTreeID, avoidForestMin);
					rmAddObjectDefConstraint(IsleTreeID, avoidAll);
					rmPlaceObjectDefAtLoc(IsleTreeID, 0, 0.50, 0.50, rmRandInt(1,4));

					IsleCritterID = rmCreateObjectDef("lake isle critter"+i);
					rmAddObjectDefItem(IsleCritterID, critterTwoName, rmRandInt(6,9), 5.0);
					rmSetObjectDefMinDistance(IsleCritterID, rmXFractionToMeters(0.00));
					rmSetObjectDefMaxDistance(IsleCritterID, rmXFractionToMeters(0.50));
					rmAddObjectDefConstraint(IsleCritterID, stayInIsle);
					rmAddObjectDefConstraint(IsleCritterID, avoidAll);
					rmPlaceObjectDefAtLoc(IsleCritterID, 0, 0.50, 0.50, 1);
				}
			}
		}

    	// Fountain of Youth
		int fountainID = rmCreateObjectDef("fountain");
		rmAddObjectDefItem(fountainID, "SPCFountainofYouth", 1, 1.0);
		rmSetObjectDefMinDistance(fountainID, 0);
		rmSetObjectDefMaxDistance(fountainID, 5);
		rmSetObjectDefForceFullRotation(fountainID, true);
		if (fountainChance == 1 && caribbeanMap == 1)
			rmPlaceObjectDefAtLoc(fountainID, 0, 0.50, 0.50);
	}

	if (oceanOffCenter == 1)
	{
		if (bayChance == 1)
		{
			int stayInBay = rmCreateAreaMaxDistanceConstraint("stay in bay", unknownBay, 0.0);

			if ((amazonMap == 1 && treasureIsle == 1) || trollMap == 1 || rmRandFloat(0,1) <= 0.01)
			{
				// Isles
				int unkislecount = 2+cNumberNonGaiaPlayers; 
				int stayInUnkIsle = -1;
				int unkIsleMineID = -1;
				int unkIsleTreeID = -1;
				int unkIsleCritterID = -1;

				for (i= 0; < unkislecount) 
				{
					int unkIsleID = rmCreateArea("unknown isle"+i);
					rmAddAreaToClass(unkIsleID, classCliff);
					rmSetAreaSize(unkIsleID, 0.003);
					rmSetAreaObeyWorldCircleConstraint(unkIsleID, false);
					rmSetAreaMix(unkIsleID, landName); 
					rmSetAreaBaseHeight(unkIsleID, 01);
					rmSetAreaReveal(unkIsleID, 01);
					rmSetAreaCoherence(unkIsleID, 0.69);
					rmAddAreaConstraint(unkIsleID, avoidCliffs);
					rmAddAreaConstraint(unkIsleID, edgeConstraintShort);
					rmAddAreaConstraint(unkIsleID, fishLand);
					rmAddAreaConstraint(unkIsleID, stayInBay);
	//				rmAddAreaConstraint(unkIsleID, avoidPond);
					rmSetAreaWarnFailure(unkIsleID, false);
					rmBuildArea(unkIsleID);		

					stayInUnkIsle = rmCreateAreaMaxDistanceConstraint("stay in unk isle"+i, unkIsleID, 0.0);

					unkIsleMineID = rmCreateObjectDef("unknown isle mine "+i);
					if (africanMap == 1)
					{
						if (rmRandFloat(0,1) <= 0.50)
							rmAddObjectDefItem(unkIsleMineID, "MineSalt", 1, 0.0);
						else
							rmAddObjectDefItem(unkIsleMineID, "mine", 1, 0.0);
					}
					else
						rmAddObjectDefItem(unkIsleMineID, mineralz, 1, 0.0);
					rmSetObjectDefMinDistance(unkIsleMineID, rmXFractionToMeters(0.00));
					rmSetObjectDefMaxDistance(unkIsleMineID, rmXFractionToMeters(0.50));
					rmAddObjectDefToClass(unkIsleMineID, rmClassID("classForest"));
					rmAddObjectDefConstraint(unkIsleMineID, stayInUnkIsle);
					rmAddObjectDefConstraint(unkIsleMineID, avoidAll);
					rmPlaceObjectDefAtLoc(unkIsleMineID, 0, 0.50, 0.50, 1);

					unkIsleTreeID = rmCreateObjectDef("unknown isle veg"+i);
					if (rmRandFloat(0,1) <= 0.001)
						rmAddObjectDefItem(unkIsleTreeID, propz, rmRandInt(1,3), 3.0);
					else
						rmAddObjectDefItem(unkIsleTreeID, treeName, rmRandInt(1,3), 3.0);
					rmSetObjectDefMinDistance(unkIsleTreeID, rmXFractionToMeters(0.00));
					rmSetObjectDefMaxDistance(unkIsleTreeID, rmXFractionToMeters(0.50));
					rmAddObjectDefToClass(unkIsleTreeID, rmClassID("classForest"));
					rmAddObjectDefConstraint(unkIsleTreeID, stayInUnkIsle);
					rmAddObjectDefConstraint(unkIsleTreeID, avoidForestMin);
					rmAddObjectDefConstraint(unkIsleTreeID, avoidAll);
					rmPlaceObjectDefAtLoc(unkIsleTreeID, 0, 0.50, 0.50, rmRandInt(1,4));

					unkIsleCritterID = rmCreateObjectDef("unknown isle critter"+i);
					rmAddObjectDefItem(unkIsleCritterID, critterTwoName, rmRandInt(6,9), 5.0);
					rmSetObjectDefMinDistance(unkIsleCritterID, rmXFractionToMeters(0.00));
					rmSetObjectDefMaxDistance(unkIsleCritterID, rmXFractionToMeters(0.50));
					rmAddObjectDefConstraint(unkIsleCritterID, stayInUnkIsle);
					rmAddObjectDefConstraint(unkIsleCritterID, avoidAll);
					rmPlaceObjectDefAtLoc(unkIsleCritterID, 0, 0.50, 0.50, 1);
				}
			}
		}
	}

  // check for KOTH game mode
  if(rmGetIsKOTH()) {
    
    int randLoc = rmRandInt(1,3);
    float xLoc = 0.50;
    float yLoc = 0.50;
    float walk = 0.01;
    
    //~ if(randLoc == 1 && blockedMiddle != 1)
      //~ yLoc = .5;
      
    //~ if(cNumberTeams > 2 && blockedMiddle != 1) {
      //~ yLoc = rmRandFloat(.25, .75);
      //~ walk = 0.25;
    //~ }
    
    //~ else if(cNumberTeams > 2){
      //~ yLoc = .3;
      //~ walk = 0.5;
    //~ }
    
    ypKingsHillPlacer(xLoc, yLoc, walk, avoidCliffsShort);
    rmEchoInfo("XLOC = "+xLoc);
    rmEchoInfo("XLOC = "+yLoc);
  }

	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.7);
   else
   rmSetStatusText("", 0.3);

// ============= Starting Units =============
	float TCMax = 20.0;
	// For FFA, allow more of a float distance.
	if ( cNumberTeams > 2 )
		TCMax = 35.0;

	int startingUnits = rmCreateStartingUnitsObjectDef(7.0);
	rmSetObjectDefMinDistance(startingUnits, 5.0);
	rmSetObjectDefMaxDistance(startingUnits, TCMax);
	if (oceanRing ==1)
		rmAddObjectDefConstraint(startingUnits, avoidWaterFarPlus);
	rmAddObjectDefConstraint(startingUnits, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingUnits, avoidTradeRouteSocket);
	rmAddObjectDefConstraint(startingUnits, avoidEdgeFar);
	rmAddObjectDefConstraint(startingUnits, avoidCliffsShort);
	rmAddObjectDefConstraint(startingUnits, avoidCanyon);
	rmAddObjectDefToClass(startingUnits, rmClassID("startingUnit"));
	rmAddObjectDefToClass(startingUnits, classPlayer);

	// Bonus Wagon
	if (everyoneGetsAWagon != 981)
	{
		if (rmRandFloat(0,1) <= 0.009)
			everyoneGetsAWagon = 69;		// jeff wagons (1 food age 1, 1 wood age 3, 1 coin age 4, all 3 age 5)
		if (oceanRing == 1 && rmRandFloat(0,1) <= 0.25)
			everyoneGetsAWagon = 1001;
//		if (oceanOffCenter == 1 && rmRandFloat(0,1) <= 0.25 && bayChance == 1)
		if (rmRandFloat(0,1) <= 0.25 && bayChance == 1 && frozenLake != 1)
			everyoneGetsAWagon = 1001;
//		if (oceanMiddle == 1 && rmRandFloat(0,1) <= 0.25  && oceanChance == 1)
		if (rmRandFloat(0,1) <= 0.25  && oceanChance == 1 && frozenLake != 1)
			everyoneGetsAWagon = 1001;
		if (dekkanMap == 1 && rmRandFloat(0,1) <= 0.25 && rmGetIsTreaty() == true)
			everyoneGetsAWagon = 1002;
		if (trollMap == 1 || rmRandFloat(0,1) <= 0.001)
			everyoneGetsAWagon = 1003;
		if (tpORnot == 5 && rmRandFloat(0,1) <= 0.10)
			everyoneGetsAWagon = 990;
		if (rmRandFloat(0,1) <= 0.02)
			everyoneGetsAWagon = 666;		// military wagon age 2
	}
	rmEchoInfo("everyoneGetsAWagon = "+everyoneGetsAWagon);

// Place Starting Units now so other stuff can avoid them
	for(i=1; <cNumberPlayers)
	{
    	rmAddMapStartingUnit(i, petName1);
		if (everyoneGetsAWagon != 981)
		{
			// Bonus Wagon
			if (everyoneGetsAWagon == 69)
	    		rmAddMapStartingUnit(i, "FirewoodPile");
			else if (everyoneGetsAWagon == 666)
			{
	    		rmAddMapStartingUnit(i, "deNatEUPropVilGuards");
	    		rmAddMapStartingUnit(i, "SPCCasualtyCart");
			}
			else if (everyoneGetsAWagon == 972)
			{
	    		rmAddMapStartingUnit(i, "Envoy");
	    		rmAddMapStartingUnit(i, "ypMarketWagon");
			}
			else if (everyoneGetsAWagon == 973)
	    		rmAddMapStartingUnit(i, "deUniqueTowerBuilder");
			else if (everyoneGetsAWagon == 974)
	    		rmAddMapStartingUnit(i, "ypBerryWagon1");
			else if (everyoneGetsAWagon == 975)
			{
				if (autoCattle != 1)
				{
	    			rmAddMapStartingUnit(i, "ypVillageWagon");
	    			rmAddMapStartingUnit(i, livestockName);
				}
				else
				{
					everyoneGetsAWagon = 950;
	    			rmAddMapStartingUnit(i, "deTradingPostWagon");
				}
			}
			else if (everyoneGetsAWagon == 977)
			{
    			rmAddMapStartingUnit(i, "deMountainMonasteryBuilder");
				if (rmRandFloat(0,1) <= 0.01)
	    			rmAddMapStartingUnit(i, "deNatBerberSultan");
				else if (rmRandFloat(0,1) <= 0.10)
	    			rmAddMapStartingUnit(i, "deAbun");
				else
	    			rmAddMapStartingUnit(i, "deNatNomad");
			}
			else if (everyoneGetsAWagon == 979)
			{
	    		rmAddMapStartingUnit(i, "deAthosMonasteryWagon");
	    		rmAddMapStartingUnit(i, "deAthosMonasteryWagon");
			}
			else if (everyoneGetsAWagon == 980)
	    		rmAddMapStartingUnit(i, "NatHolcanSpearman");
			else if (everyoneGetsAWagon == 982)
			{
	    		rmAddMapStartingUnit(i, "deCommanderyWagon");
	    		rmAddMapStartingUnit(i, "deCommanderyWagon");
			}
			else if (everyoneGetsAWagon == 983)
			{
				if (autoCattle != 1)
				{
	    			rmAddMapStartingUnit(i, "ypSacredFieldWagon");
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
				}
				else
				{
					everyoneGetsAWagon = 950;
	    			rmAddMapStartingUnit(i, "deTradingPostWagon");
				}
			}
			else if (everyoneGetsAWagon == 984)
	    		rmAddMapStartingUnit(i, "deDepotWagon");
			else if (everyoneGetsAWagon == 985)
	    		rmAddMapStartingUnit(i, "SPCDamagedCannons");
			else if (everyoneGetsAWagon == 986)
	    		rmAddMapStartingUnit(i, "deCommandWagon");
			else if (everyoneGetsAWagon == 987)
			{
	    		rmAddMapStartingUnit(i, "deLombardWagon");
	    		rmAddMapStartingUnit(i, "deSPCCityGuard");
			}
			else if (everyoneGetsAWagon == 988)
	    		rmAddMapStartingUnit(i, "deBatteryTowerWagon");
			else if (everyoneGetsAWagon == 989)
			{
	    		rmAddMapStartingUnit(i, "deProspectorWagonCoal");
	    		rmAddMapStartingUnit(i, "deMiner");
			}
			else if (everyoneGetsAWagon == 990)
			{
	    		rmAddMapStartingUnit(i, "deEmbassyTravois");
				if (yellowRiverMap == 1)
		    		rmAddMapStartingUnit(i, "ypNativeScout");
				else if (rmRandFloat(0,1) <= 0.10)
		    		rmAddMapStartingUnit(i, "NativeScout");
				else
		    		rmAddMapStartingUnit(i, "deNatSPCLenapeVillager");
			}
			else if (everyoneGetsAWagon == 991)
			{
				if (autoCattle != 1)
				{
	    			rmAddMapStartingUnit(i, "deHaciendaWagon");
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
				}
				else
				{
					everyoneGetsAWagon = 950;
	    			rmAddMapStartingUnit(i, "deTradingPostWagon");
				}
			}
			else if (everyoneGetsAWagon == 992)
			{
				if (autoCattle != 1)
				{
	    			rmAddMapStartingUnit(i, "deHomesteadWagon");
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
				}
				else
				{
					everyoneGetsAWagon = 950;
	    			rmAddMapStartingUnit(i, "deTradingPostWagon");
				}
			}
			else if (everyoneGetsAWagon == 993)
    			rmAddMapStartingUnit(i, "deImperialWagon");
			else if (everyoneGetsAWagon == 994)
    			rmAddMapStartingUnit(i, "BankWagon");
			else if (everyoneGetsAWagon == 995)
    			rmAddMapStartingUnit(i, "deTorpWagon");
			else if (everyoneGetsAWagon == 996)
    			rmAddMapStartingUnit(i, "OutpostWagon");
			else if (everyoneGetsAWagon == 997)
    			rmAddMapStartingUnit(i, "deRedSeaWagon");
			else if (everyoneGetsAWagon == 998)
    			rmAddMapStartingUnit(i, "SettlerWagon");
			else if (everyoneGetsAWagon == 999)
			{
				if (autoCattle != 1)
				{
	    			rmAddMapStartingUnit(i, "ypShrineWagon");
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
	    			rmAddMapStartingUnit(i, livestockName);
				}
				else
				{
					everyoneGetsAWagon = 950;
	    			rmAddMapStartingUnit(i, "deTradingPostWagon");
				}
			}
			else if (everyoneGetsAWagon == 1000)
			{
    			rmAddMapStartingUnit(i, "YPDojoWagon");
    			rmAddMapStartingUnit(i, "ypPeasant");
    			rmAddMapStartingUnit(i, "ypIrregular");
			}
			else if (everyoneGetsAWagon == 1001)
    			rmAddMapStartingUnit(i, "deDockWagon");
			else if (everyoneGetsAWagon == 1002)
    			rmAddMapStartingUnit(i, "YPGroveWagon");
			else if (everyoneGetsAWagon == 1003)
    			rmAddMapStartingUnit(i, "deREVStarTrekWagon");
			else
	    		rmAddMapStartingUnit(i, "deTradingPostWagon");
		}
		else	// everyoneGetsAWagon == 981
	    		rmAddMapStartingUnit(i, "dePropsResourceCratesGold");
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.6);
   else
   rmSetStatusText("", 0.4);

// ============= Place Natives =============
	int akanVillageID = -1;
	int yorubaVillageID = -1;
	int somaliVillageID = -1;
	int berberVillageID = -1;
	int sudaneseVillageID = -1;
	int ZapotecVillageID = -1;
	int CaribsVillageID = -1;
	int CherokeeVillageID = -1;
	int ComancheVillageID = -1;
	int CreeVillageID = -1;
	int IncasVillageID = -1;
	int KlamathVillageID = -1;
	int CheyenneVillageID = -1;
	int MayaVillageID = -1;
	int NootkaVillageID = -1;
	int SeminolesVillageID = -1;
	int TupiVillageID = -1;
	int NavajoVillageID = -1;
	int HuronVillageID = -1;
	int MapucheVillageID = -1;
	int UdasiVillageID = -1;
	int BhaktiVillageID = -1;
	int JesuitVillageID = -1;
	int ZenVillageID = -1;
	int ShaolinVillageID= -1;
	int SufiVillageID = -1;
	int apacheVillageID = -1;
	int lenapeVillageID = -1;
	int bourbonVillageID = -1;
	int habsburgVillageID = -1;
	int hanoverVillageID = -1;
	int jagiellonVillageID = -1;
	int oldenburgVillageID = -1;
	int phanarVillageID = -1;
	int vasaVillageID = -1;
	int wettinVillageID = -1;
	int wittelsbachVillageID = -1;
	int TengriVillageID = -1;
	int aztecsVillageID = -1;
	int lakotaVillageID = -1;
	int iroquoisVillageID = -1;

	float nativeChance = -1;

// Usually 3 to 4, but rarely more or less

	int nativeNumber = (rmRandInt(4,5)+(cNumberNonGaiaPlayers/2));
	if (tpORnot == 5)
		nativeNumber = (6+(cNumberNonGaiaPlayers/2));

	rmEchoInfo("Native number = "+nativeNumber);

	int natDist = 0.00;
	if (tpORnot == 5)
		natDist = 24;
	else
		natDist = 30;

	int avoidNatives = rmCreateClassDistanceConstraint("stay away from natives", classNatives, natDist+cNumberNonGaiaPlayers);
	int nativesAvoidPlayers = rmCreateClassDistanceConstraint("natives vs. players", classPlayer, natDist);

// For each native, randomly determine tribe
// Each native may only be placed twice
int counterAkan = -1;
int counterApac = -1;
int counterAzte = -1;
int counterBerb = -1;
int counterBhak = -1;
int counterBour = -1;
int counterCari = -1;
int counterCher = -1;
int counterChey = -1;
int counterComa = -1;
int counterCree = -1;
int counterHabs = -1;
int counterHano = -1;
int counterHuro = -1;
int counterInca = -1;
int counterIroq = -1;
int counterJagi = -1;
int counterJesu = -1;
int counterKlam = -1;
int counterLako = -1;
int counterLena = -1;
int counterMapu = -1;
int counterMaya = -1;
int counterNava = -1;
int counterNoot = -1;
int counterOlde = -1;
int counterPhan = -1;
int counterSemi = -1;
int counterShao = -1;
int counterSoma = -1;
int counterSuda = -1;
int counterSufi = -1;
int counterTeng = -1;
int counterTupi = -1;
int counterUdas = -1;
int counterVasa = -1;
int counterWett = -1;
int counterWitt = -1;
int counterYoru = -1;
int counterZapo = -1;
int counterZen = -1;

	for(i = 0; <nativeNumber)
	{
		nativeChance = rmRandFloat(0,0.41);
//			nativeChance = 0.10;		// for testing
		if(nativeChance < 0.01 && counterBour < 1)
		{
			rmEchoInfo("subCiv"+i+" is Bourbon");
			bourbonVillageID = rmCreateGrouping("Bourbon village "+i, "european\native eu bourbon village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(bourbonVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(bourbonVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(bourbonVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(bourbonVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(bourbonVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(bourbonVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(bourbonVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(bourbonVillageID, avoidNatives);
			rmAddGroupingConstraint(bourbonVillageID, edgeConstraint);
			rmAddGroupingConstraint(bourbonVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(bourbonVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(bourbonVillageID, 0, 0.5, 0.5);
			counterBour++;
		}
		else if(nativeChance < 0.02 && counterHabs < 1)
		{
			rmEchoInfo("subCiv"+i+" is Habsburg");
			habsburgVillageID = rmCreateGrouping("Habsburg village "+i, "european\native eu habsburg village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(habsburgVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(habsburgVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(habsburgVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(habsburgVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(habsburgVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(habsburgVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(habsburgVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(habsburgVillageID, avoidNatives);
			rmAddGroupingConstraint(habsburgVillageID, edgeConstraint);
			rmAddGroupingConstraint(habsburgVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(habsburgVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(habsburgVillageID, 0, 0.5, 0.5);
			counterHabs++;
		}
		else if(nativeChance < 0.03 && counterHano < 1)
		{
			rmEchoInfo("subCiv"+i+" is Hanover");
			hanoverVillageID = rmCreateGrouping("Hanover village "+i, "european\native eu hanover village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(hanoverVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(hanoverVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(hanoverVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(hanoverVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(hanoverVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(hanoverVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(hanoverVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(hanoverVillageID, avoidNatives);
			rmAddGroupingConstraint(hanoverVillageID, edgeConstraint);
			rmAddGroupingConstraint(hanoverVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(hanoverVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(hanoverVillageID, 0, 0.5, 0.5);
			counterHano++;
		}
		else if(nativeChance < 0.04 && counterJagi < 1)
		{
			rmEchoInfo("subCiv"+i+" is Jagiellon");
			jagiellonVillageID = rmCreateGrouping("Jagiellon village "+i, "european\native eu jagiellon village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(jagiellonVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(jagiellonVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(jagiellonVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(jagiellonVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(jagiellonVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(jagiellonVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(jagiellonVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(jagiellonVillageID, avoidNatives);
			rmAddGroupingConstraint(jagiellonVillageID, edgeConstraint);
			rmAddGroupingConstraint(jagiellonVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(jagiellonVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(jagiellonVillageID, 0, 0.5, 0.5);
			counterJagi++;
		}
		else if(nativeChance < 0.05 && counterOlde < 1)
		{
			rmEchoInfo("subCiv"+i+" is Oldenburg");
			oldenburgVillageID = rmCreateGrouping("Oldenburg village "+i, "european\native eu oldenburg village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(oldenburgVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(oldenburgVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(oldenburgVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(oldenburgVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(oldenburgVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(oldenburgVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(oldenburgVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(oldenburgVillageID, avoidNatives);
			rmAddGroupingConstraint(oldenburgVillageID, edgeConstraint);
			rmAddGroupingConstraint(oldenburgVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(oldenburgVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(oldenburgVillageID, 0, 0.5, 0.5);
			counterOlde++;
		}
		else if(nativeChance < 0.06 && counterPhan < 1)
		{
			rmEchoInfo("subCiv"+i+" is Phanar");
			phanarVillageID = rmCreateGrouping("Phanar village "+i, "european\native eu phanar village italian "+rmRandInt(1,7));
			rmSetGroupingMinDistance(phanarVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(phanarVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(phanarVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(phanarVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(phanarVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(phanarVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(phanarVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(phanarVillageID, avoidNatives);
			rmAddGroupingConstraint(phanarVillageID, edgeConstraint);
			rmAddGroupingConstraint(phanarVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(phanarVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(phanarVillageID, 0, 0.5, 0.5);
			counterPhan++;
		}
		else if(nativeChance < 0.07 && counterVasa < 1)
		{
			rmEchoInfo("subCiv"+i+" is Vasa");
			vasaVillageID = rmCreateGrouping("Vasa village "+i, "european\native eu vasa village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(vasaVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(vasaVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(vasaVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(vasaVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(vasaVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(vasaVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(vasaVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(vasaVillageID, avoidNatives);
			rmAddGroupingConstraint(vasaVillageID, edgeConstraint);
			rmAddGroupingConstraint(vasaVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(vasaVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(vasaVillageID, 0, 0.5, 0.5);
			counterVasa++;
		}
		else if(nativeChance < 0.08 && counterWett < 1)
		{
			rmEchoInfo("subCiv"+i+" is Wettin");
			wettinVillageID = rmCreateGrouping("Wettin village "+i, "european\native eu wettin village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(wettinVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(wettinVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(wettinVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(wettinVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(wettinVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(wettinVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(wettinVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(wettinVillageID, avoidNatives);
			rmAddGroupingConstraint(wettinVillageID, edgeConstraint);
			rmAddGroupingConstraint(wettinVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(wettinVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(wettinVillageID, 0, 0.5, 0.5);
			counterWett++;
		}
		else if(nativeChance < 0.09 && counterWitt < 1)
		{
			rmEchoInfo("subCiv"+i+" is Wittelsbach");
			wittelsbachVillageID = rmCreateGrouping("Wittelsbach village "+i, "european\native eu wittelsbach village central "+rmRandInt(1,7));
			rmSetGroupingMinDistance(wittelsbachVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(wittelsbachVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(wittelsbachVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(wittelsbachVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(wittelsbachVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(wittelsbachVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(wittelsbachVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(wittelsbachVillageID, avoidNatives);
			rmAddGroupingConstraint(wittelsbachVillageID, edgeConstraint);
			rmAddGroupingConstraint(wittelsbachVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(wittelsbachVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(wittelsbachVillageID, 0, 0.5, 0.5);
			counterWitt++;
		}
		else if(nativeChance < 0.10 && counterTeng < 1)
		{
			rmEchoInfo("subCiv"+i+" is Tengri");
			TengriVillageID = rmCreateGrouping("tengri village "+i, "native tengri village 0"+rmRandInt(1,5));
			rmSetGroupingMinDistance(TengriVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(TengriVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(TengriVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(TengriVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(TengriVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(TengriVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(TengriVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(TengriVillageID, avoidNatives);
			rmAddGroupingConstraint(TengriVillageID, edgeConstraint);
			rmAddGroupingConstraint(TengriVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(TengriVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(TengriVillageID, 0, 0.5, 0.5);
			counterTeng++;
		}
		else if(nativeChance < 0.11 && counterAzte < 1)
		{
			rmEchoInfo("subCiv"+i+" is Aztecs");
			aztecsVillageID = rmCreateGrouping("aztec village "+i, "native aztec village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(aztecsVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(aztecsVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(aztecsVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(aztecsVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(aztecsVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(aztecsVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(aztecsVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(aztecsVillageID, avoidNatives);
			rmAddGroupingConstraint(aztecsVillageID, edgeConstraint);
			rmAddGroupingConstraint(aztecsVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(aztecsVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(aztecsVillageID, 0, 0.5, 0.5);
			counterAzte++;
		}
		else if(nativeChance < 0.12 && counterLako < 1)
		{
			rmEchoInfo("subCiv"+i+" is Lakota");
			lakotaVillageID = rmCreateGrouping("lakota village "+i, "native lakota village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(lakotaVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(lakotaVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(lakotaVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(lakotaVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(lakotaVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(lakotaVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(lakotaVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(lakotaVillageID, avoidNatives);
			rmAddGroupingConstraint(lakotaVillageID, edgeConstraint);
			rmAddGroupingConstraint(lakotaVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(lakotaVillageID, 0, 0.5, 0.5);
			counterLako++;
		}
		else if(nativeChance < 0.13 && counterIroq < 1)
		{
			rmEchoInfo("subCiv"+i+" is Haudenosaunee");
			iroquoisVillageID = rmCreateGrouping("haudenosaunee village "+i, "native iroquois village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(iroquoisVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(iroquoisVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(iroquoisVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(iroquoisVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(iroquoisVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(iroquoisVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(iroquoisVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(iroquoisVillageID, avoidNatives);
			rmAddGroupingConstraint(iroquoisVillageID, edgeConstraint);
			rmAddGroupingConstraint(iroquoisVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(iroquoisVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(iroquoisVillageID, 0, 0.5, 0.5);
			counterIroq++;
		}
		else if(nativeChance < 0.14 && counterZapo < 1)
		{
//			rmSetSubCiv(i, "Zapotec");
			rmEchoInfo("subCiv"+i+" is Zapotec");
			ZapotecVillageID = rmCreateGrouping("zapotec village "+i, "native zapotec village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(ZapotecVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(ZapotecVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(ZapotecVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(ZapotecVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(ZapotecVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(ZapotecVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(ZapotecVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(ZapotecVillageID, avoidNatives);
			rmAddGroupingConstraint(ZapotecVillageID, edgeConstraint);
			rmAddGroupingConstraint(ZapotecVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(ZapotecVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(ZapotecVillageID, 0, 0.5, 0.5);
			counterZapo++;
		}
		else if(nativeChance < 0.15 && counterApac < 1)
		{
//			rmSetSubCiv(i, "apache");
			rmEchoInfo("subCiv"+i+" is Apache");
			apacheVillageID = rmCreateGrouping("apache village "+i, "native apache village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(apacheVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(apacheVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(apacheVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(apacheVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(apacheVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(apacheVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(apacheVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(apacheVillageID, avoidNatives);
			rmAddGroupingConstraint(apacheVillageID, edgeConstraint);
			rmAddGroupingConstraint(apacheVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(apacheVillageID, 0, 0.5, 0.5);
			counterApac++;
		}
		else if(nativeChance < 0.16 && counterLena < 1)
		{
//			rmSetSubCiv(i, "DESPCLenape");
			rmEchoInfo("subCiv"+i+" is Lenape");
			lenapeVillageID = rmCreateGrouping("lenape village "+i, "native lenape village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(lenapeVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(lenapeVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(lenapeVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(lenapeVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(lenapeVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(lenapeVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(lenapeVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(lenapeVillageID, avoidNatives);
			rmAddGroupingConstraint(lenapeVillageID, edgeConstraint);
			rmAddGroupingConstraint(lenapeVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(lenapeVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(lenapeVillageID, 0, 0.5, 0.5);
			counterLena++;
		}
		else if(nativeChance < 0.17 && counterSoma < 1)
		{
//			rmSetSubCiv(i, "Somali");
			rmEchoInfo("subCiv"+i+" is Somali");
			somaliVillageID = rmCreateGrouping("somali village "+i, "native af somali village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(somaliVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(somaliVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(somaliVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(somaliVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(somaliVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(somaliVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(somaliVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(somaliVillageID, avoidNatives);
			rmAddGroupingConstraint(somaliVillageID, edgeConstraint);
			rmAddGroupingConstraint(somaliVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(somaliVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(somaliVillageID, 0, 0.5, 0.5);
			counterSoma++;
		}
		else if(nativeChance < 0.18 && counterBerb < 1)
		{
//			rmSetSubCiv(i, "Berbers");
			rmEchoInfo("subCiv"+i+" is Berbers");
			berberVillageID = rmCreateGrouping("berber village "+i, "native af berber village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(berberVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(berberVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(berberVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(berberVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(berberVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(berberVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(berberVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(berberVillageID, avoidNatives);
			rmAddGroupingConstraint(berberVillageID, edgeConstraint);
			rmAddGroupingConstraint(berberVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(berberVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(berberVillageID, 0, 0.5, 0.5);
			counterBerb++;
		}
		else if(nativeChance < 0.19 && counterSuda < 1)
		{
//			rmSetSubCiv(i, "Sudanese");
			rmEchoInfo("subCiv"+i+" is Sudanese");
			sudaneseVillageID = rmCreateGrouping("sudanese village "+i, "native af sudanese village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(sudaneseVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(sudaneseVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(sudaneseVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(sudaneseVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(sudaneseVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(sudaneseVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(sudaneseVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(sudaneseVillageID, avoidNatives);
			rmAddGroupingConstraint(sudaneseVillageID, edgeConstraint);
			rmAddGroupingConstraint(sudaneseVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(sudaneseVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(sudaneseVillageID, 0, 0.5, 0.5);
			counterSuda++;
		}
		else if(nativeChance < 0.20 && counterYoru < 1)
		{
//			rmSetSubCiv(i, "Yoruba");
			rmEchoInfo("subCiv"+i+" is Yoruba");
			yorubaVillageID = rmCreateGrouping("yoruba village "+i, "native af yoruba village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(yorubaVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(yorubaVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(yorubaVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(yorubaVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(yorubaVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(yorubaVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(yorubaVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(yorubaVillageID, avoidNatives);
			rmAddGroupingConstraint(yorubaVillageID, edgeConstraint);
			rmAddGroupingConstraint(yorubaVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(yorubaVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(yorubaVillageID, 0, 0.5, 0.5);
			counterYoru++;
		}
		else if(nativeChance < 0.21 && counterAkan < 1)
		{
//			rmSetSubCiv(i, "Akan");
			rmEchoInfo("subCiv"+i+" is Akan");
			akanVillageID = rmCreateGrouping("akan village "+i, "native af akan village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(akanVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(akanVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(akanVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(akanVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(akanVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(akanVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(akanVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(akanVillageID, avoidNatives);
			rmAddGroupingConstraint(akanVillageID, edgeConstraint);
			rmAddGroupingConstraint(akanVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(akanVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(akanVillageID, 0, 0.5, 0.5);
			counterAkan++;
		}
		else if(nativeChance < 0.22 && counterShao < 1)
		{
//			rmSetSubCiv(i, "Shaolin");
			rmEchoInfo("subCiv"+i+" is Shaolin");
			ShaolinVillageID = rmCreateGrouping("Shaolin village "+i, "native shaolin temple mongol 0"+rmRandInt(1,5));
			rmSetGroupingMinDistance(ShaolinVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(ShaolinVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(ShaolinVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(ShaolinVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(ShaolinVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(ShaolinVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(ShaolinVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(ShaolinVillageID, avoidNatives);
			rmAddGroupingConstraint(ShaolinVillageID, edgeConstraint);
			rmAddGroupingConstraint(ShaolinVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(ShaolinVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(ShaolinVillageID, 0, 0.5, 0.5);
			counterShao++;
		}
		else if(nativeChance < 0.23 && counterSufi < 1)
		{
//			rmSetSubCiv(i, "Sufi");
			rmEchoInfo("subCiv"+i+" is Sufi");
			SufiVillageID = rmCreateGrouping("Sufi village "+i, "native sufi mosque mongol "+rmRandInt(1,5));
			rmSetGroupingMinDistance(SufiVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(SufiVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(SufiVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(SufiVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(SufiVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(SufiVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(SufiVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(SufiVillageID, avoidNatives);
			rmAddGroupingConstraint(SufiVillageID, edgeConstraint);
			rmAddGroupingConstraint(SufiVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(SufiVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(SufiVillageID, 0, 0.5, 0.5);
			counterSufi++;
		}
		else if(nativeChance < 0.24 && counterZen < 1)
		{
//			rmSetSubCiv(i, "Zen");
			rmEchoInfo("subCiv"+i+" is Zen");
			ZenVillageID = rmCreateGrouping("Zen village "+i, "native zen temple ceylon 0"+rmRandInt(1,5));
			rmSetGroupingMinDistance(ZenVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(ZenVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(ZenVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(ZenVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(ZenVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(ZenVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(ZenVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(ZenVillageID, avoidNatives);
			rmAddGroupingConstraint(ZenVillageID, edgeConstraint);
			rmAddGroupingConstraint(ZenVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(ZenVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(ZenVillageID, 0, 0.5, 0.5);
			counterZen++;
		}
		else if(nativeChance < 0.25 && counterJesu < 1)
		{
//			rmSetSubCiv(i, "Jesuit");
			rmEchoInfo("subCiv"+i+" is Jesuit");
			JesuitVillageID = rmCreateGrouping("Jesuit village "+i, "native jesuit mission borneo 0"+rmRandInt(1,5));
			rmSetGroupingMinDistance(JesuitVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(JesuitVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(JesuitVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(JesuitVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(JesuitVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(JesuitVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(JesuitVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(JesuitVillageID, avoidNatives);
			rmAddGroupingConstraint(JesuitVillageID, edgeConstraint);
			rmAddGroupingConstraint(JesuitVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(JesuitVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(JesuitVillageID, 0, 0.5, 0.5);
			counterJesu++;
		}
		else if(nativeChance < 0.26 && counterUdas < 1)
		{
//			rmSetSubCiv(i, "Udasi");
			rmEchoInfo("subCiv"+i+" is Udasi");
			UdasiVillageID = rmCreateGrouping("Udasi village "+i, "native Udasi village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(UdasiVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(UdasiVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(UdasiVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(UdasiVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(UdasiVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(UdasiVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(UdasiVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(UdasiVillageID, avoidNatives);
			rmAddGroupingConstraint(UdasiVillageID, edgeConstraint);
			rmAddGroupingConstraint(UdasiVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(UdasiVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(UdasiVillageID, 0, 0.5, 0.5);
			counterUdas++;
		}
		else if(nativeChance < 0.27 && counterBhak < 1)
		{
//			rmSetSubCiv(i, "Bhakti");
			rmEchoInfo("subCiv"+i+" is Bhakti");
			BhaktiVillageID = rmCreateGrouping("Bhakti village "+i, "native Bhakti village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(BhaktiVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(BhaktiVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(BhaktiVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(BhaktiVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(BhaktiVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(BhaktiVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(BhaktiVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(BhaktiVillageID, avoidNatives);
			rmAddGroupingConstraint(BhaktiVillageID, edgeConstraint);
			rmAddGroupingConstraint(BhaktiVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(BhaktiVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(BhaktiVillageID, 0, 0.5, 0.5);
			counterBhak++;
		}
		else if(nativeChance < 0.28 && counterCari < 1)
		{
//			rmSetSubCiv(i, "Caribs");
			rmEchoInfo("subCiv"+i+" is Caribs");
			CaribsVillageID = rmCreateGrouping("carib village "+i, "native carib village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(CaribsVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(CaribsVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(CaribsVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(CaribsVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(CaribsVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(CaribsVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(CaribsVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(CaribsVillageID, avoidNatives);
			rmAddGroupingConstraint(CaribsVillageID, edgeConstraint);
			rmAddGroupingConstraint(CaribsVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(CaribsVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(CaribsVillageID, 0, 0.5, 0.5);
			counterCari++;
		}
		else if(nativeChance < 0.29 && counterHuro < 1)
		{
//			rmSetSubCiv(i, "Huron");
			rmEchoInfo("subCiv"+i+" is Huron");
			HuronVillageID = rmCreateGrouping("huron village "+i, "native huron village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(HuronVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(HuronVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(HuronVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(HuronVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(HuronVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(HuronVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(HuronVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(HuronVillageID, avoidNatives);
			rmAddGroupingConstraint(HuronVillageID, edgeConstraint);
			rmAddGroupingConstraint(HuronVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(HuronVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(HuronVillageID, 0, 0.5, 0.5);
			counterHuro++;
		}	
		else if(nativeChance < 0.30 && counterCher < 1)
		{
//			rmSetSubCiv(i, "Cherokee");
			rmEchoInfo("subCiv"+i+" is Cherokee");
			CherokeeVillageID = rmCreateGrouping("cherokee village "+i, "native cherokee village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(CherokeeVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(CherokeeVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(CherokeeVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(CherokeeVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(CherokeeVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(CherokeeVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(CherokeeVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(CherokeeVillageID, avoidNatives);
			rmAddGroupingConstraint(CherokeeVillageID, edgeConstraint);
			rmAddGroupingConstraint(CherokeeVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(CherokeeVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(CherokeeVillageID, 0, 0.5, 0.5);
			counterCher++;
		}
		else if(nativeChance < 0.31 && counterComa < 1)
		{	
//			rmSetSubCiv(i, "Comanche");
			rmEchoInfo("subCiv"+i+" is Comanche");
			ComancheVillageID = rmCreateGrouping("comanche village "+i, "native comanche village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(ComancheVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(ComancheVillageID, rmXFractionToMeters(0.50));
			rmAddGroupingToClass(ComancheVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(ComancheVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(ComancheVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(ComancheVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(ComancheVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(ComancheVillageID, avoidNatives);
			rmAddGroupingConstraint(ComancheVillageID, edgeConstraint);
			rmAddGroupingConstraint(ComancheVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(ComancheVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(ComancheVillageID, 0, 0.5, 0.5);
			counterComa++;
		}
		else if(nativeChance < 0.32 && counterCree < 1)
		{
//			rmSetSubCiv(i, "Cree");
			rmEchoInfo("subCiv"+i+" is Cree");
			CreeVillageID = rmCreateGrouping("cree village "+i, "native cree village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(CreeVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(CreeVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(CreeVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(CreeVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(CreeVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(CreeVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(CreeVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(CreeVillageID, avoidNatives);
			rmAddGroupingConstraint(CreeVillageID, edgeConstraint);
			rmAddGroupingConstraint(CreeVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(CreeVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(CreeVillageID, 0, 0.5, 0.5);
			counterCree++;
		}	
		else if(nativeChance < 0.33 && counterInca < 1)
		{
//			rmSetSubCiv(i, "Incas");
			rmEchoInfo("subCiv"+i+" is Incas");
			IncasVillageID = rmCreateGrouping("inca village "+i, "native inca village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(IncasVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(IncasVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(IncasVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(IncasVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(IncasVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(IncasVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(IncasVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(IncasVillageID, avoidNatives);
			rmAddGroupingConstraint(IncasVillageID, edgeConstraint);
			rmAddGroupingConstraint(IncasVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(IncasVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(IncasVillageID, 0, 0.5, 0.5);
			counterInca++;
		}	
		else if(nativeChance < 0.34 && counterMapu < 1)
		{
//			rmSetSubCiv(i, "Mapuche");
			rmEchoInfo("subCiv"+i+" is Mapuche");
			MapucheVillageID = rmCreateGrouping("mapuche village "+i, "native mapuche village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(MapucheVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(MapucheVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(MapucheVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(MapucheVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(MapucheVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(MapucheVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(MapucheVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(MapucheVillageID, avoidNatives);
			rmAddGroupingConstraint(MapucheVillageID, edgeConstraint);
			rmAddGroupingConstraint(MapucheVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(MapucheVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(MapucheVillageID, 0, 0.5, 0.5);
			counterMapu++;
		}	
		else if(nativeChance < 0.35 && counterKlam < 1)
		{
//			rmSetSubCiv(i, "Klamath");
			rmEchoInfo("subCiv"+i+" is Klamath");
			KlamathVillageID = rmCreateGrouping("klamath village "+i, "native klamath village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(KlamathVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(KlamathVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(KlamathVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(KlamathVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(KlamathVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(KlamathVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(KlamathVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(KlamathVillageID, avoidNatives);
			rmAddGroupingConstraint(KlamathVillageID, edgeConstraint);
			rmAddGroupingConstraint(KlamathVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(KlamathVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(KlamathVillageID, 0, 0.5, 0.5);
			counterKlam++;
		}	
		else if(nativeChance < 0.36 && counterChey < 1)
		{
//			rmSetSubCiv(i, "Cheyenne");
			rmEchoInfo("subCiv"+i+" is Cheyenne");
			CheyenneVillageID = rmCreateGrouping("cheyenne village "+i, "native cheyenne village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(CheyenneVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(CheyenneVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(CheyenneVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(CheyenneVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(CheyenneVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(CheyenneVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(CheyenneVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(CheyenneVillageID, avoidNatives);
			rmAddGroupingConstraint(CheyenneVillageID, edgeConstraint);
			rmAddGroupingConstraint(CheyenneVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(CheyenneVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(CheyenneVillageID, 0, 0.5, 0.5);
			counterChey++;
		}		
		else if(nativeChance < 0.37 && counterMaya < 1)
		{
//			rmSetSubCiv(i, "Maya");
			rmEchoInfo("subCiv"+i+" is Maya");
			MayaVillageID = rmCreateGrouping("maya village "+i, "native maya village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(MayaVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(MayaVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(MayaVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(MayaVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(MayaVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(MayaVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(MayaVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(MayaVillageID, avoidNatives);
			rmAddGroupingConstraint(MayaVillageID, edgeConstraint);
			rmAddGroupingConstraint(MayaVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(MayaVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(MayaVillageID, 0, 0.5, 0.5);
			counterMaya++;
		}
		else if(nativeChance < 0.38 && counterNoot < 1)
		{
//			rmSetSubCiv(i, "Nootka");
			rmEchoInfo("subCiv"+i+" is Nootka");
			NootkaVillageID = rmCreateGrouping("nootka village "+i, "native nootka village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(NootkaVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(NootkaVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(NootkaVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(NootkaVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(NootkaVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(NootkaVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(NootkaVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(NootkaVillageID, avoidNatives);
			rmAddGroupingConstraint(NootkaVillageID, edgeConstraint);
			rmAddGroupingConstraint(NootkaVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(NootkaVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(NootkaVillageID, 0, 0.5, 0.5);
			counterNoot++;
		}	
		else if(nativeChance < 0.39 && counterNava < 1)
		{
//			rmSetSubCiv(i, "Navajo");
			rmEchoInfo("subCiv"+i+" is Navajo");
			NavajoVillageID = rmCreateGrouping("navajo village "+i, "native navajo village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(NavajoVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(NavajoVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(NavajoVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(NavajoVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(NavajoVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(NavajoVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(NavajoVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(NavajoVillageID, avoidNatives);
			rmAddGroupingConstraint(NavajoVillageID, edgeConstraint);
			rmAddGroupingConstraint(NavajoVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(NavajoVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(NavajoVillageID, 0, 0.5, 0.5);
			counterNava++;
		}	
		else if(nativeChance < 0.40 && counterSemi < 1)
		{
//			rmSetSubCiv(i, "Seminoles");
			rmEchoInfo("subCiv"+i+" is Seminoles");
			SeminolesVillageID = rmCreateGrouping("seminoles village "+i, "native seminole village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(SeminolesVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(SeminolesVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(SeminolesVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(SeminolesVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(SeminolesVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(SeminolesVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(SeminolesVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(SeminolesVillageID, avoidNatives);
			rmAddGroupingConstraint(SeminolesVillageID, edgeConstraint);
			rmAddGroupingConstraint(SeminolesVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(SeminolesVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(SeminolesVillageID, 0, 0.5, 0.5);
			counterSemi++;
		}		
		else if(nativeChance < 0.41 && counterTupi < 1)
		{
//			rmSetSubCiv(i, "Tupi");
			rmEchoInfo("subCiv"+i+" is Tupi");
			TupiVillageID = rmCreateGrouping("tupi village "+i, "native tupi village "+rmRandInt(1,5));
			rmSetGroupingMinDistance(TupiVillageID, rmXFractionToMeters(0.05));
			rmSetGroupingMaxDistance(TupiVillageID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
			rmAddGroupingToClass(TupiVillageID, rmClassID("natives"));
			if (floodedLand != 1)
				rmAddGroupingConstraint(TupiVillageID, avoidImpassableLand);
			rmAddGroupingConstraint(TupiVillageID, avoidTradeRoute);
			rmAddGroupingConstraint(TupiVillageID, avoidTradeRouteSocket);
			rmAddGroupingConstraint(TupiVillageID, nativesAvoidPlayers);
			rmAddGroupingConstraint(TupiVillageID, avoidNatives);
			rmAddGroupingConstraint(TupiVillageID, edgeConstraint);
			rmAddGroupingConstraint(TupiVillageID, avoidCanyon);
			rmPlaceGroupingAtLoc(TupiVillageID, 0, 0.5, 0.5);
			rmPlaceGroupingAtLoc(TupiVillageID, 0, 0.5, 0.5);
			counterTupi++;
		}
		else // this is there to still have as much native tps as decided because some can not spawn if you have already 2. Thx Riki.
		{
			nativeNumber++;
		}	
	}

	// Text
   rmSetStatusText("", 0.5);

// ============= Add Ponds or Cliffs =============
	if(rmRandFloat(0,1) < 0.111 && sagTest==1 && riverExists==-1 && rmGetIsKOTH() == false)
	{
		rmEchoInfo("ponds exist");
		int numPonds=rmRandInt(2, 3);
	// None Shall Pass
	if (trollMap == 1 || rmRandFloat(0,1) <= 0.001) {
		for (i=0; <2+cNumberNonGaiaPlayers) {
			int impassIslandID=rmCreateArea("impasse island"+i);
			rmSetAreaSize(impassIslandID, 0.0125-0.001*cNumberNonGaiaPlayers);
			rmSetAreaTerrainType(impassIslandID, "texas\nonpassable_temp"); 
			rmSetAreaWarnFailure(impassIslandID, false);
			rmSetAreaCoherence(impassIslandID, 0.85);
			rmSetAreaObeyWorldCircleConstraint(impassIslandID, true);
			rmAddAreaToClass(impassIslandID, pondClass);
			rmAddAreaConstraint(impassIslandID, pondConstraint);
			rmAddAreaConstraint(impassIslandID, avoidPlayersFar);
			rmAddAreaConstraint(impassIslandID, avoidNatives);
			if (floodedLand != 1)
			rmAddAreaConstraint(impassIslandID, shortAvoidImpassableLand);
			rmAddAreaConstraint(impassIslandID, avoidCanyon);
			rmAddAreaConstraint(impassIslandID, edgeConstraint);
			rmAddAreaConstraint(impassIslandID, avoidTradeRouteSocket);
			rmAddAreaConstraint(impassIslandID, avoidTradeRoute);
			rmAddAreaConstraint(impassIslandID, avoidGoldMin);
			rmBuildArea(impassIslandID);
			}
		}
		else if (floodedLand != 1) {
			for(i=0; <numPonds)
			{
				int smallPondID=rmCreateArea("small pond "+i);
				rmSetAreaSize(smallPondID, rmAreaTilesToFraction(170), rmAreaTilesToFraction(369));
				if (rmRandFloat(0,1) <= 0.50 && oceanRing != 1)
				{
					rmSetAreaWaterType(smallPondID, pondName);
					rmSetAreaBaseHeight(smallPondID, 4);
				}
				else
				{
	  				rmSetAreaCliffType(smallPondID, cliffName);
      				rmSetAreaCliffEdge(smallPondID, 1, 1);
      				rmSetAreaCliffPainting(smallPondID, false, true, true, 1.5, true);
      				rmSetAreaCliffHeight(smallPondID, 6, 2.0, 0.5);
				}
				rmAddAreaToClass(smallPondID, pondClass);
				rmSetAreaCoherence(smallPondID, 0.5);
				rmAddAreaConstraint(smallPondID, pondConstraint);
				rmAddAreaConstraint(smallPondID, avoidPlayersFar);
				rmAddAreaConstraint(smallPondID, avoidNatives);
				rmAddAreaConstraint(smallPondID, shortAvoidImpassableLand);
				rmAddAreaConstraint(smallPondID, avoidCanyon);
				rmAddAreaConstraint(smallPondID, edgeConstraint);
				rmAddAreaConstraint(smallPondID, avoidTradeRouteSocket);
				rmAddAreaConstraint(smallPondID, avoidGoldMin);
				rmAddAreaConstraint(smallPondID, avoidAll);
				rmAddAreaConstraint(smallPondID, avoidTradeRoute);
				rmSetAreaWarnFailure(smallPondID, false);
				rmBuildArea(smallPondID);
			}
		}
	}

	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.4);
   else
   rmSetStatusText("", 0.6);

// ============= Add Forests =============
	numTries=6+15*cNumberNonGaiaPlayers;
	if (floodedLand == 1)
		numTries=20+15*cNumberNonGaiaPlayers;
	failCount = 0;
	int sparseForests = -1;

   for (i=0; <numTries)
	{   
      int forest=rmCreateArea("forest "+i);
      rmSetAreaWarnFailure(forest, false);
      rmSetAreaObeyWorldCircleConstraint(forest, true);
	  if (floodedLand == 1)
      	rmSetAreaSize(forest, rmAreaTilesToFraction(69));
      else
	  	rmSetAreaSize(forest, rmAreaTilesToFraction(111));
      if (rmRandFloat(0,1) <= 0.001)
	  	rmSetAreaForestType(forest, "unknown forest funky");
      else 
	  	rmSetAreaForestType(forest, forestName);
	  if (trollMap == 1) {
			rmSetAreaForestDensity(forest, 0.99);
			rmSetAreaForestClumpiness(forest, 0.99);
			rmSetAreaForestUnderbrush(forest, 0.99);
	  		}
	  else {
			rmSetAreaForestDensity(forest, 0.8);
			rmSetAreaForestClumpiness(forest, 0.8);
			rmSetAreaForestUnderbrush(forest, 0.3);
	  		}
      rmSetAreaCoherence(forest, 0.5);
      rmSetAreaSmoothDistance(forest, 0);
      rmAddAreaToClass(forest, rmClassID("classForest")); 
      rmAddAreaConstraint(forest, forestConstraint);
      rmAddAreaConstraint(forest, avoidTCFar);
      rmAddAreaConstraint(forest, avoidCommandPostFar);
      rmAddAreaConstraint(forest, avoidCW);
      rmAddAreaConstraint(forest, avoidAll);
      rmAddAreaConstraint(forest, avoidCanyon);
	if (floodedLand != 1)
	      rmAddAreaConstraint(forest, shortAvoidImpassableLand); 
      rmAddAreaConstraint(forest, avoidTradeRoute);
      rmAddAreaConstraint(forest, avoidGoldMin);
      rmAddAreaConstraint(forest, avoidPond);
      if (frozenLake == 1)
	  	rmAddAreaConstraint(forest, avoidCliffs);
      rmAddAreaConstraint(forest, avoidTradeRouteSocketShort);

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

	if (floodedLand == 1)
	{
		// Random Extra Trees
		int rdmTreeID=rmCreateObjectDef("rdm extra trees");
		rmAddObjectDefItem(rdmTreeID, treeName, 4, 2.0);
		rmAddObjectDefToClass(rdmTreeID, rmClassID("classForest")); 
		rmSetObjectDefMinDistance(rdmTreeID, 0);
		rmSetObjectDefMaxDistance(rdmTreeID, rmXFractionToMeters(0.50));
		rmAddObjectDefConstraint(rdmTreeID, forestConstraint);
		rmAddObjectDefConstraint(rdmTreeID, avoidTCFar);
		rmAddObjectDefConstraint(rdmTreeID, avoidCommandPostFar);	
		rmAddObjectDefConstraint(rdmTreeID, avoidCW);
		rmAddObjectDefConstraint(rdmTreeID, avoidAll);
		rmAddObjectDefConstraint(rdmTreeID, avoidCanyon);
		rmAddObjectDefConstraint(rdmTreeID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(rdmTreeID, avoidTradeRoute);
		rmAddObjectDefConstraint(rdmTreeID, avoidGoldMin);
		rmAddObjectDefConstraint(rdmTreeID, avoidPond);
    	if (frozenLake == 1)
			rmAddObjectDefConstraint(rdmTreeID, avoidCliffs);
		rmPlaceObjectDefAtLoc(rdmTreeID, 0, 0.5, 0.5, 10+5*cNumberNonGaiaPlayers);
	}
	
	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.3);
   else
   rmSetStatusText("", 0.7);

// ============= Starting Resources =============

   int nearDeerID=rmCreateObjectDef("herds near town");
   if (rmGetIsTreaty() == true)
	   rmAddObjectDefItem(nearDeerID, critterOneName, 16, 5.0);
   else
   {
    	if (rmRandFloat(0,1) <= 0.01)
			rmAddObjectDefItem(nearDeerID, "ypIGCBird", 10, 5.0);
    	else
   			rmAddObjectDefItem(nearDeerID, critterOneName, 10, 5.0);
   }
   rmSetObjectDefMinDistance(nearDeerID, 12);
   rmSetObjectDefMaxDistance(nearDeerID, 14);
//   rmAddObjectDefConstraint(nearDeerID, avoidFood);
	rmAddObjectDefConstraint(nearDeerID, avoidAll);
	if (floodedLand != 1)
	   rmAddObjectDefConstraint(nearDeerID, shortAvoidImpassableLand);
   rmSetObjectDefCreateHerd(nearDeerID, true);

	int farDeerID=rmCreateObjectDef("herds far away");		   
  rmAddObjectDefItem(farDeerID, critterTwoName, rmRandInt(14,16), 8.0);
   rmSetObjectDefMinDistance(farDeerID, 40);
   rmSetObjectDefMaxDistance(farDeerID, 44);
   rmAddObjectDefConstraint(farDeerID, avoidFood);
	rmAddObjectDefConstraint(farDeerID, avoidAll);									   
	if (floodedLand != 1)
   rmAddObjectDefConstraint(farDeerID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farDeerID, avoidForestMin);
   rmAddObjectDefConstraint(farDeerID, avoidPond);
   if (oceanRing == 1)
   {
	   rmAddObjectDefConstraint(farDeerID, stayNearWater);
	   rmAddObjectDefConstraint(farDeerID, avoidWater);
   }
	else
	   rmAddObjectDefConstraint(farDeerID, stayNearEdge);
   rmAddObjectDefConstraint(farDeerID, avoidCliffsShort);
   rmAddObjectDefConstraint(farDeerID, avoidEdge);
   rmSetObjectDefCreateHerd(farDeerID, true);

	int farDeer2ID=rmCreateObjectDef("herds far far away");		   
      rmAddObjectDefItem(farDeer2ID, critterTwoName, rmRandInt(8,10), 4.0);
   rmSetObjectDefMinDistance(farDeer2ID, 55);
   rmSetObjectDefMaxDistance(farDeer2ID, 64);
   rmAddObjectDefConstraint(farDeer2ID, avoidFood);
	rmAddObjectDefConstraint(farDeer2ID, avoidAll);									   
	if (floodedLand != 1)
   rmAddObjectDefConstraint(farDeer2ID, shortAvoidImpassableLand);
   rmAddObjectDefConstraint(farDeer2ID, avoidForestMin);
   rmAddObjectDefConstraint(farDeer2ID, avoidPond);
   rmAddObjectDefConstraint(farDeer2ID, avoidPlayers);
   if (oceanRing == 1)
   {
	   rmAddObjectDefConstraint(farDeer2ID, stayNearWater);
	   rmAddObjectDefConstraint(farDeer2ID, avoidWaterShort);
   }
	else
	   rmAddObjectDefConstraint(farDeer2ID, stayNearEdge);
   rmAddObjectDefConstraint(farDeer2ID, avoidCliffsShort);
   rmAddObjectDefConstraint(farDeer2ID, avoidEdge);
   rmSetObjectDefCreateHerd(farDeer2ID, true);

	// Player Nuggets
	int nugget1= rmCreateObjectDef("nugget starter"); 
	rmAddObjectDefItem(nugget1, "Nugget", 1, 0.0);
		rmSetNuggetDifficulty(1, 1);
	if (oceanRing == 1)
		rmAddObjectDefConstraint(nugget1, avoidWaterShort);
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nugget1, shortAvoidImpassableLand);
 	rmAddObjectDefConstraint(nugget1, avoidNuggetShort);
  	rmAddObjectDefConstraint(nugget1, avoidTradeRouteSocketShort);
  	rmAddObjectDefConstraint(nugget1, avoidTradeRoute);
  	rmAddObjectDefConstraint(nugget1, avoidAll);
  	rmAddObjectDefConstraint(nugget1, avoidPond);
	rmSetObjectDefMinDistance(nugget1, 22.0);
	rmSetObjectDefMaxDistance(nugget1, 25.0);

	int nugget2= rmCreateObjectDef("nugget medium"); 
	rmAddObjectDefItem(nugget2, "Nugget", 1, 0.0);
	rmSetNuggetDifficulty(2, 2);
	if (oceanRing == 1)
		rmAddObjectDefConstraint(nugget2, avoidWaterShort);
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nugget2, shortAvoidImpassableLand);
  	rmAddObjectDefConstraint(nugget2, avoidNuggetShort);
  	rmAddObjectDefConstraint(nugget2, avoidCommandPost);
  	rmAddObjectDefConstraint(nugget2, avoidTC);
  	rmAddObjectDefConstraint(nugget2, avoidCW);
  	rmAddObjectDefConstraint(nugget2, avoidCanyon);
  	rmAddObjectDefConstraint(nugget2, avoidTradeRouteSocketShort);
  	rmAddObjectDefConstraint(nugget2, avoidTradeRoute);
  	rmAddObjectDefConstraint(nugget2, avoidAll);
  	rmAddObjectDefConstraint(nugget2, avoidPond);
	rmSetObjectDefMinDistance(nugget2, 30.0);
	rmSetObjectDefMaxDistance(nugget2, 35.0);

	// Player Flag
	int waterFlagID=rmCreateObjectDef("HC water flag");
	int placeWaterFlag = -1;
	rmAddObjectDefItem(waterFlagID, "HomeCityWaterSpawnFlag", 1, 0.0);
	rmSetObjectDefMinDistance(waterFlagID, 0.0);
	rmSetObjectDefMaxDistance(waterFlagID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(waterFlagID, avoidEdge);
	rmAddObjectDefConstraint(waterFlagID, flagVsFlag);
	rmAddObjectDefConstraint(waterFlagID, fishLand);
	if (oceanRing == 1)
		rmAddObjectDefConstraint(waterFlagID, stayNearEdge);

	// Define a parm for placing water flags on water maps
//	if (oceanOffCenter == 1 && bayChance == 1)
	if (bayChance == 1 && frozenLake != 1)
		placeWaterFlag = 1;
//	if (oceanMiddle == 1 && oceanChance == 1)
	if (oceanChance == 1 && frozenLake != 1)
		placeWaterFlag = 1;
	if (oceanRing == 1)
		placeWaterFlag = 1;

	float scoutRNG = rmRandFloat(0,1);
	float boneRNG = rmRandFloat(0,1);
//		boneRNG = 0.001;	// for testing
	int whichBone = rmRandInt(1,2);
	string boneType = "";
	if (whichBone == 1)
		boneType = "Boneguard";
	else
		boneType = "BoneguardAge2";

	for(i=1; <cNumberPlayers)
	{
			// NUGGETS
			// Always 1 of type I. Can have +1 or +2 of type I and +1 or +2 of type II
			rmPlaceObjectDefAtLoc(nugget1, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(nugget2, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			// FOOD
			// Always 1 near and 1 far. Sometimes +1 or +2 far.
			rmPlaceObjectDefAtLoc(nearDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(farDeerID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			rmPlaceObjectDefAtLoc(farDeer2ID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
    		// Monastery
    		if(ypIsAsian(i))
    			rmPlaceObjectDefAtLoc(ypMonasteryBuilder(i, 1), i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

			// WATER FLAG
			if (placeWaterFlag == 1)
				rmPlaceObjectDefAtLoc(waterFlagID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

  	if (trollBar == 1)
	   rmSetStatusText("", 0.2);
   else
   rmSetStatusText("", 0.8);

// ============= Other Resources =============
// Silver
	int silverID = -1;
	int silverCount = (cNumberNonGaiaPlayers*6);
	rmEchoInfo("silver count = "+silverCount);

	string silverType = "";

	if (caribbeanMap == 1 && rmRandFloat(0,1) <= 0.15)
	{
	   silverType = "deShipRuins";
		rmEchoInfo("silver type is deShipRuins");
	}
//	else if (africanMap == 1 && rmRandFloat(0,1) <= 0.01)
//	{
//	   silverType = "deREVMineDiamondBuildable";
//		rmEchoInfo("silver type is deREVMineDiamondBuildable");
//	}
	else if (africanMap == 1 && rmRandFloat(0,1) >= 0.95)
	{
	   silverType = "MineSalt";
		rmEchoInfo("silver type is MineSalt");
	}
//	else if (rmRandFloat(0,1) <= 0.10)
//	{
//	   silverType = "deMineCoalBuildable";
//		rmEchoInfo("silver type is deMineCoalBuildable");
//	}
	else if (rmRandFloat(0,1) <= 0.10)
	{
	   silverType = "MineGold";
		rmEchoInfo("silver type is MineGold");
	}
	else if (rmRandFloat(0,1) >= 0.75)
	{
	   silverType = "MineCopper";
		rmEchoInfo("silver type is MineCopper");
	}
	else if (rmRandFloat(0,1) <= 0.05)
	{
	   silverType = "MineTin";
		rmEchoInfo("silver type is MineTin");
	}
	else
	{
	   silverType = "mine";
		rmEchoInfo("silver type is mine");
	}

//	silverType = "deREVMineDiamondBuildable";	// for testing

    silverID = rmCreateObjectDef("silver ");
	rmAddObjectDefItem(silverID, silverType, 1, 0.0);
      rmSetObjectDefMinDistance(silverID, 0.0);
      rmSetObjectDefMaxDistance(silverID, rmXFractionToMeters(0.5));
	rmAddObjectDefToClass(silverID, classGold);
	if (oceanRing == 1)
		rmAddObjectDefConstraint(silverID, avoidGoldVeryFar);
	else
		rmAddObjectDefConstraint(silverID, avoidGold);
      rmAddObjectDefConstraint(silverID, avoidCliffsShort);
      rmAddObjectDefConstraint(silverID, avoidPond);
      rmAddObjectDefConstraint(silverID, avoidAll);
	  if (rmGetNomadStart() == false)
		rmAddObjectDefConstraint(silverID, avoidPlayersFar);
//      rmAddObjectDefConstraint(silverID, shortAvoidImpassableLand);
      rmAddObjectDefConstraint(silverID, avoidTradeRouteSocketShort);
      rmAddObjectDefConstraint(silverID, avoidTradeRoute);
      rmAddObjectDefConstraint(silverID, avoidEdge);
	  if (oceanRing == 1)
	      rmAddObjectDefConstraint(silverID, avoidWaterShort);
	  rmPlaceObjectDefAtLoc(silverID, 0, 0.5, 0.5, silverCount);

//Food
   int bisonID=rmCreateObjectDef("bison herd");
   	if (trollMap == 1 || rmRandFloat(0,1) <= 0.0001) {
	   rmAddObjectDefItem(bisonID, "ypWildElephant", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "deZebra", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "deOstrich", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "bison", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "tapir", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "deer", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "moose", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "elk", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "pronghorn", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "deGiraffe", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "capybara", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "guanaco", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "turkey", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypGiantSalamander", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypSerow", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypMuskdeer", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "MuskOx", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "caribou", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypNilgai", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypIbex", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypMarcoPoloSheep", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "BighornSheep", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "Rhea", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "ypSaiga", 1, 10.0);
	   rmAddObjectDefItem(bisonID, "Gazelle", 1, 10.0);
	   }
	else 
	   rmAddObjectDefItem(bisonID, critterOneName, rmRandInt(12,16), 8.0);
   rmSetObjectDefMinDistance(bisonID, 0.0);
   rmSetObjectDefMaxDistance(bisonID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(bisonID, avoidAll);
   rmAddObjectDefConstraint(bisonID, avoidTradeRouteSocketShort);
	if (floodedLand != 1)
   rmAddObjectDefConstraint(bisonID, shortAvoidImpassableLand);
  if (oceanRing == 1)
   {
	   	rmAddObjectDefConstraint(bisonID, avoidFood1Far);
   		rmAddObjectDefConstraint(bisonID, avoidFood2Far);
   }
   else
   {
	   	rmAddObjectDefConstraint(bisonID, avoidFood1);
   		rmAddObjectDefConstraint(bisonID, avoidFood2);
   }
   rmAddObjectDefConstraint(bisonID, avoidGoldMin);
   if (trollMap == 1)
	   rmAddObjectDefConstraint(bisonID, avoidHuntable);
   rmAddObjectDefConstraint(bisonID, avoidEdge);
   rmAddObjectDefConstraint(bisonID, avoidForestMin);
	if (oceanRing == 1)
	    rmAddObjectDefConstraint(bisonID, avoidWater);
	if (frozenLake != 1)
	{
   		rmAddObjectDefConstraint(bisonID, avoidCliffsMed);
   		rmAddObjectDefConstraint(bisonID, avoidPond);
	}
   rmSetObjectDefCreateHerd(bisonID, true);
   		rmAddObjectDefConstraint(bisonID, avoidPlayersFar1);
   		rmPlaceObjectDefAtLoc(bisonID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2.5);

   int pronghornID=rmCreateObjectDef("pronghorn herd");
   if (trollMap == 1)
	   rmAddObjectDefItem(pronghornID, critterOneName, rmRandInt(7,8), 4.0);
	else
	   rmAddObjectDefItem(pronghornID, critterTwoName, rmRandInt(7,8), 4.0);
   rmSetObjectDefMinDistance(pronghornID, 0.0);
   rmSetObjectDefMaxDistance(pronghornID, rmXFractionToMeters(0.5));
   rmAddObjectDefConstraint(pronghornID, avoidAll);
   rmAddObjectDefConstraint(pronghornID, avoidTradeRouteSocketShort);
	if (floodedLand != 1)
   rmAddObjectDefConstraint(pronghornID, shortAvoidImpassableLand);
   if (oceanRing == 1)
   {
	   	rmAddObjectDefConstraint(pronghornID, avoidFood1Far);
   		rmAddObjectDefConstraint(pronghornID, avoidFood2Far);
   }
   else
   {
	   	rmAddObjectDefConstraint(pronghornID, avoidFood1);
   		rmAddObjectDefConstraint(pronghornID, avoidFood2);
   }
   rmAddObjectDefConstraint(pronghornID, avoidGoldMin);
	if (oceanRing == 1)
	    rmAddObjectDefConstraint(pronghornID, avoidWaterShort);
   if (trollMap == 1)
	   rmAddObjectDefConstraint(pronghornID, avoidHuntable);
   rmAddObjectDefConstraint(pronghornID, avoidEdge);
   rmAddObjectDefConstraint(pronghornID, avoidForestMin);
	if (frozenLake != 1)
	{
   		rmAddObjectDefConstraint(pronghornID, avoidCliffsShort);
   		rmAddObjectDefConstraint(pronghornID, avoidPond);
	}
   rmSetObjectDefCreateHerd(pronghornID, true);
	rmAddObjectDefConstraint(pronghornID, avoidPlayers);
   	rmPlaceObjectDefAtLoc(pronghornID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers);

	// Livestock
	int sheepID=rmCreateObjectDef("livestock");
	if (rmRandFloat(0,1) <= 0.001)
		rmAddObjectDefItem(sheepID, "deUnknownWoodCattle", 2, 4.0);
	else if (rmRandFloat(0,1) <= 0.001)
		rmAddObjectDefItem(sheepID, "deUnknownGoldCattle", 2, 4.0);
	else
		rmAddObjectDefItem(sheepID, livestockName, 2, 4.0);
	rmSetObjectDefMinDistance(sheepID, 0.0);
	rmSetObjectDefMaxDistance(sheepID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(sheepID, avoidFood);
	rmAddObjectDefConstraint(sheepID, avoidGoldMin);
	if (oceanRing == 1)
	    rmAddObjectDefConstraint(sheepID, avoidWaterShort);
	if (frozenLake != 1)
	{
		rmAddObjectDefConstraint(sheepID, avoidCliffsShort);
		rmAddObjectDefConstraint(sheepID, avoidPond);
	}
	rmAddObjectDefConstraint(sheepID, avoidAll);
	if(oceanRing == 1)
		rmAddObjectDefConstraint(sheepID, avoidPlayersFar1);
	else
		rmAddObjectDefConstraint(sheepID, avoidPlayersFar);
	if (floodedLand != 1)
	rmAddObjectDefConstraint(sheepID, shortAvoidImpassableLand);
	if(rmRandFloat(0,1) > 0.20)
		rmPlaceObjectDefAtLoc(sheepID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2);

	// Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.1);
   else
   rmSetStatusText("", 0.9);

// Treasures
int howCrazyIsTooCrazy = rmRandInt(1,61);
float someRNG = rmRandFloat(0,1);
//	someRNG = 0.01;		// for testing

int nuggetHuariID= rmCreateObjectDef("huari stronghold nuggz"); 
	rmAddObjectDefItem(nuggetHuariID, "HuariStrongholdAndes", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetHuariID, 0.00);
	rmSetObjectDefMaxDistance(nuggetHuariID, rmXFractionToMeters(0.10));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetHuariID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetHuariID, avoidHuari);
	rmAddObjectDefConstraint(nuggetHuariID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggetHuariID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetHuariID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetHuariID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetHuariID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetHuariID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetHuariID, avoidPond);
	rmAddObjectDefConstraint(nuggetHuariID, avoidAll);
	if (andesMap == 1 && someRNG <= 0.05)
	  	rmPlaceObjectDefAtLoc(nuggetHuariID, 0, 0.5, 0.5, 4);

int nuggetProspectorID= rmCreateObjectDef("unknown prospector nuggets"); 
	if (amazonMap == 1 && rmRandFloat(0,1) <= 0.50)
		rmAddObjectDefItem(nuggetProspectorID, "SPCAztecMap", 1, 0.0);
	else
	{
		rmAddObjectDefItem(nuggetProspectorID, "Nugget", 1, 0.0);
		rmSetObjectDefMinDistance(nuggetProspectorID, 0.00);
		rmSetObjectDefMaxDistance(nuggetProspectorID, rmXFractionToMeters(0.069));
	if (floodedLand != 1)
		rmAddObjectDefConstraint(nuggetProspectorID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidNuggetFar);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidPlayers);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidTradeRouteSocketShort);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidTradeRoute);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidGoldMin);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidCliffsShort);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidPond);
		rmAddObjectDefConstraint(nuggetProspectorID, avoidAll);
		if (rmGetIsTreaty() == true)
			rmSetNuggetDifficulty(12345,12345);
		else
			rmSetNuggetDifficulty(12345,12346);
	}
	if (someRNG <= 0.05 || trollMap == 1)
	  	rmPlaceObjectDefAtLoc(nuggetProspectorID, 0, 0.5, 0.5, 1);

int nuggetUnknownID= rmCreateObjectDef("unknown special nuggets"); 
	rmAddObjectDefItem(nuggetUnknownID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetUnknownID, 0.00);
	rmSetObjectDefMaxDistance(nuggetUnknownID, rmXFractionToMeters(0.40+0.005*cNumberNonGaiaPlayers));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetUnknownID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidNuggetFar);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidPond);
	rmAddObjectDefConstraint(nuggetUnknownID, avoidAll);
	if (cNumberNonGaiaPlayers == 2 || rmGetIsFFA() == true)
		rmSetNuggetDifficulty(13,13);
	else 
		rmSetNuggetDifficulty(13,14);
  	rmPlaceObjectDefAtLoc(nuggetUnknownID, 0, 0.5, 0.5, 3+cNumberNonGaiaPlayers);

int nuggetHMID= rmCreateObjectDef("HM nuggz"); 
	rmAddObjectDefItem(nuggetHMID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetHMID, 0.00);
	rmSetObjectDefMaxDistance(nuggetHMID, rmXFractionToMeters(0.10));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetHMID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetHMID, avoidNugget);
	rmAddObjectDefConstraint(nuggetHMID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetHMID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetHMID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetHMID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetHMID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetHMID, avoidPond);
	rmAddObjectDefConstraint(nuggetHMID, avoidAll);
	rmSetNuggetDifficulty(104,104);
    if (euMap == 1 && cNumberNonGaiaPlayers > 2 && rmRandFloat(0,1) <= 0.05 && rmGetIsTreaty() == false)
    	rmPlaceObjectDefAtLoc(nuggetHMID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

int nuggetAf12ID= rmCreateObjectDef("african nugget12"); 
	rmAddObjectDefItem(nuggetAf12ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetAf12ID, 0.00);
	rmSetObjectDefMaxDistance(nuggetAf12ID, rmXFractionToMeters(0.05));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetAf12ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidNugget);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidPond);
	rmAddObjectDefConstraint(nuggetAf12ID, avoidAll);
	rmSetNuggetDifficulty(12,12);
    if (trollMap == 1 && cNumberNonGaiaPlayers > 2 && rmGetIsFFA() == false)
    	rmPlaceObjectDefAtLoc(nuggetAf12ID, 0, 0.5, 0.5, 1);

int houseNuggetID= rmCreateObjectDef("house nugget");
	rmAddObjectDefItem(houseNuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(houseNuggetID, 0.025);
	rmSetObjectDefMaxDistance(houseNuggetID, rmXFractionToMeters(0.20));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(houseNuggetID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(houseNuggetID, avoidNugget);
	rmAddObjectDefConstraint(houseNuggetID, avoidPlayersFar1);
	rmAddObjectDefConstraint(houseNuggetID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(houseNuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(houseNuggetID, avoidGoldMin);
	rmAddObjectDefConstraint(houseNuggetID, avoidCliffsShort);
	rmAddObjectDefConstraint(houseNuggetID, avoidPond);
	rmAddObjectDefConstraint(houseNuggetID, avoidAll);
	rmSetNuggetDifficulty(121, 121);
	if ((saguenayMap == 1 && someRNG <= 0.5) || (euMap == 1 && someRNG <= 0.5) || (asianMap == 1 && someRNG <= 0.5))
		rmPlaceObjectDefAtLoc(houseNuggetID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

int crazyNugget1ID= rmCreateObjectDef("crazy nugget 1"); 
	rmAddObjectDefItem(crazyNugget1ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(crazyNugget1ID, 0.00);
	rmSetObjectDefMaxDistance(crazyNugget1ID, rmXFractionToMeters(0.23));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(crazyNugget1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidNugget);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidPlayersFar1);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidTradeRoute);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidGoldMin);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidCliffsShort);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidPond);
	rmAddObjectDefConstraint(crazyNugget1ID, avoidAll);
	if (howCrazyIsTooCrazy < 11)
		rmSetNuggetDifficulty(33, 33);
	else if (howCrazyIsTooCrazy < 21)
		rmSetNuggetDifficulty(44, 44);
	else if (howCrazyIsTooCrazy < 31)
		rmSetNuggetDifficulty(55, 55);
	else if (howCrazyIsTooCrazy < 41)
		rmSetNuggetDifficulty(69, 69);
	else if (howCrazyIsTooCrazy < 51)
		rmSetNuggetDifficulty(97, 97);
    else
		rmSetNuggetDifficulty(444, 444);
	if (africanMap == 1 || trollMap == 1)
		rmPlaceObjectDefAtLoc(crazyNugget1ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

int crazyNuggetBorneoID= rmCreateObjectDef("crazy borneo nuggets"); 
	rmAddObjectDefItem(crazyNuggetBorneoID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(crazyNuggetBorneoID, 0.00);
	rmSetObjectDefMaxDistance(crazyNuggetBorneoID, rmXFractionToMeters(0.23));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(crazyNuggetBorneoID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidNugget);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidPlayersFar1);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidTradeRoute);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidGoldMin);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidCliffsShort);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidPond);
	rmAddObjectDefConstraint(crazyNuggetBorneoID, avoidAll);
	if (howCrazyIsTooCrazy < 19)
		rmSetNuggetDifficulty(33, 33);
	else if (howCrazyIsTooCrazy < 37)
		rmSetNuggetDifficulty(44, 44);
	else if (howCrazyIsTooCrazy < 45)
		rmSetNuggetDifficulty(55, 55);
	else
		rmSetNuggetDifficulty(69, 69);
	if (borneoMap == 1)
		rmPlaceObjectDefAtLoc(crazyNuggetBorneoID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

int crazyNuggetEuroID= rmCreateObjectDef("crazy euro nuggets"); 
	rmAddObjectDefItem(crazyNuggetEuroID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(crazyNuggetEuroID, 0.00);
	rmSetObjectDefMaxDistance(crazyNuggetEuroID, rmXFractionToMeters(0.23));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(crazyNuggetEuroID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidNugget);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidPlayersFar1);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidTradeRoute);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidGoldMin);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidCliffsShort);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidPond);
	rmAddObjectDefConstraint(crazyNuggetEuroID, avoidAll);
	if (howCrazyIsTooCrazy < 29)
		rmSetNuggetDifficulty(44, 44);
	else if (howCrazyIsTooCrazy < 39 && rmGetIsTreaty() == false)
		rmSetNuggetDifficulty(777, 777);
	else
		rmSetNuggetDifficulty(69, 69);
	if (euMap == 1)
		rmPlaceObjectDefAtLoc(crazyNuggetEuroID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

int crazyNugget2ID= rmCreateObjectDef("crazy nugget 2"); 
	rmAddObjectDefItem(crazyNugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(crazyNugget2ID, 0.00);
	rmSetObjectDefMaxDistance(crazyNugget2ID, rmXFractionToMeters(0.23));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(crazyNugget2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidNugget);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidPlayersFar1);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidGoldMin);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidCliffsShort);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidPond);
	rmAddObjectDefConstraint(crazyNugget2ID, avoidAll);
	if (trollMap == 1)
		rmSetNuggetDifficulty(666, 671);
	else 
		rmSetNuggetDifficulty(667, 671);
	if (africanMap == 1 || trollMap == 1)
		rmPlaceObjectDefAtLoc(crazyNugget2ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	
	int nuggetAm12ID= rmCreateObjectDef("american nugget12"); 
	rmAddObjectDefItem(nuggetAm12ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetAm12ID, 0.00);
	rmSetObjectDefMaxDistance(nuggetAm12ID, rmXFractionToMeters(0.30));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetAm12ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidNuggetMed);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidPond);
	rmAddObjectDefConstraint(nuggetAm12ID, avoidAll);
	rmSetNuggetDifficulty(12,12);
    if (saguenayMap == 1 || amazonMap == 1 || sonoraMap == 1 || rockiesMap == 1 || caribbeanMap == 1 || carolinaMap == 1 || andesMap == 1 || californiaMap == 1)
	{
		if (cNumberNonGaiaPlayers > 2 && rmGetIsFFA() == false)
	    	rmPlaceObjectDefAtLoc(nuggetAm12ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	}

	int nuggetExtraID= rmCreateObjectDef("extra lost nuggz"); 
	rmAddObjectDefItem(nuggetExtraID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetExtraID, 0.025);
	rmSetObjectDefMaxDistance(nuggetExtraID, rmXFractionToMeters(0.35));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetExtraID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetExtraID, avoidNuggetMed);
	rmAddObjectDefConstraint(nuggetExtraID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetExtraID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetExtraID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetExtraID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetExtraID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetExtraID, avoidPond);
	rmAddObjectDefConstraint(nuggetExtraID, avoidAll);
	rmSetNuggetDifficulty(888,888);
	if (sonoraMap == 1 || borneoMap == 1 || saMap == 1 || californiaMap == 1 || himalMap == 1 || yellowRiverMap == 1 || rockiesMap == 1 || yukonMap == 1 || dekkanMap == 1)
		rmPlaceObjectDefAtLoc(nuggetExtraID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

int nugget12ID= rmCreateObjectDef("asian nugget12"); 
	rmAddObjectDefItem(nugget12ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget12ID, 0.00);
	rmSetObjectDefMaxDistance(nugget12ID, rmXFractionToMeters(0.30));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nugget12ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget12ID, avoidNuggetMed);
	rmAddObjectDefConstraint(nugget12ID, avoidPlayers);
	rmAddObjectDefConstraint(nugget12ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nugget12ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget12ID, avoidGoldMin);
	rmAddObjectDefConstraint(nugget12ID, avoidCliffsShort);
	rmAddObjectDefConstraint(nugget12ID, avoidPond);
	rmAddObjectDefConstraint(nugget12ID, avoidAll);
	rmSetNuggetDifficulty(12,12);
    if (japanMap == 1 || dekkanMap == 1 || borneoMap == 1 || yellowRiverMap == 1 || himalMap == 1)
	{
		if (cNumberNonGaiaPlayers > 2 && rmGetIsFFA() == false)
	    	rmPlaceObjectDefAtLoc(nugget12ID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	}

int nuggetDuberID= rmCreateObjectDef("duber nuggz"); 
	rmAddObjectDefItem(nuggetDuberID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetDuberID, 0.00);
	rmSetObjectDefMaxDistance(nuggetDuberID, rmXFractionToMeters(0.20));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetDuberID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetDuberID, avoidNuggetShort);
	rmAddObjectDefConstraint(nuggetDuberID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetDuberID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetDuberID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetDuberID, avoidGoldMin);
	rmAddObjectDefConstraint(nuggetDuberID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetDuberID, avoidPond);
	rmAddObjectDefConstraint(nuggetDuberID, avoidAll);
	rmSetNuggetDifficulty(96,96);
    if (himalMap == 1)
    	rmPlaceObjectDefAtLoc(nuggetDuberID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);

int nugget4ID= rmCreateObjectDef("map nugget4"); 
	rmAddObjectDefItem(nugget4ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget4ID, 0.00);
	rmSetObjectDefMaxDistance(nugget4ID, rmXFractionToMeters(0.20));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nugget4ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget4ID, avoidNuggetMed);
	rmAddObjectDefConstraint(nugget4ID, avoidPlayers);
	rmAddObjectDefConstraint(nugget4ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nugget4ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget4ID, avoidGoldMin);
	rmAddObjectDefConstraint(nugget4ID, avoidCliffsShort);
	rmAddObjectDefConstraint(nugget4ID, avoidPond);
	rmAddObjectDefConstraint(nugget4ID, avoidAll);
	rmSetNuggetDifficulty(4,4);
	if (cNumberNonGaiaPlayers > 2 && rmGetIsTreaty() == false)
		rmPlaceObjectDefAtLoc(nugget4ID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);
	
int nugget3ID= rmCreateObjectDef("map nugget3"); 
	rmAddObjectDefItem(nugget3ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget3ID, 0.025);
	rmSetObjectDefMaxDistance(nugget3ID, rmXFractionToMeters(0.35));
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nugget3ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget3ID, avoidNuggetMed);
	rmAddObjectDefConstraint(nugget3ID, avoidPlayers);
	rmAddObjectDefConstraint(nugget3ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nugget3ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget3ID, avoidGoldMin);
	rmAddObjectDefConstraint(nugget3ID, avoidCliffsShort);
	rmAddObjectDefConstraint(nugget3ID, avoidPond);
	rmAddObjectDefConstraint(nugget3ID, avoidAll);
	rmSetNuggetDifficulty(3,3);
	rmPlaceObjectDefAtLoc(nugget3ID, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);
	
int nugget2ID= rmCreateObjectDef("map nugget2"); 
	rmAddObjectDefItem(nugget2ID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nugget2ID, 0.15);
	rmSetObjectDefMaxDistance(nugget2ID, rmXFractionToMeters(0.45));
	if (oceanRing == 1)
	    rmAddObjectDefConstraint(nugget2ID, avoidWaterShort);
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nugget2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nugget2ID, avoidNuggetMed);
	rmAddObjectDefConstraint(nugget2ID, avoidPlayers);
	rmAddObjectDefConstraint(nugget2ID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nugget2ID, avoidTradeRoute);
	rmAddObjectDefConstraint(nugget2ID, avoidGoldMin);
	rmAddObjectDefConstraint(nugget2ID, avoidCliffsShort);
	rmAddObjectDefConstraint(nugget2ID, avoidPond);
	rmAddObjectDefConstraint(nugget2ID, avoidAll);
	rmSetNuggetDifficulty(2,2);
	rmPlaceObjectDefAtLoc(nugget2ID, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);
	
int nuggetID= rmCreateObjectDef("map nugget"); 
	rmAddObjectDefItem(nuggetID, "Nugget", 1, 0.0);
	rmSetObjectDefMinDistance(nuggetID, 0.25);
	rmSetObjectDefMaxDistance(nuggetID, rmXFractionToMeters(0.50));
	if (oceanRing == 1)
	    rmAddObjectDefConstraint(nuggetID, avoidWaterShort);
	if (floodedLand != 1)
	rmAddObjectDefConstraint(nuggetID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(nuggetID, avoidNugget);
	rmAddObjectDefConstraint(nuggetID, avoidPlayers);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRouteSocketShort);
	rmAddObjectDefConstraint(nuggetID, avoidTradeRoute);
	rmAddObjectDefConstraint(nuggetID, avoidCliffsShort);
	rmAddObjectDefConstraint(nuggetID, avoidAll);
	rmAddObjectDefConstraint(nuggetID, avoidPond);
	rmAddObjectDefConstraint(nuggetID, avoidGoldMin);
	rmSetNuggetDifficulty(1,1);
	rmPlaceObjectDefAtLoc(nuggetID, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);
	
	// add fish if ocean
	if (placeWaterFlag == 1)
	{
		int fishID=rmCreateObjectDef("fish");
		if (rmRandFloat(0,1) <= 0.001)
			rmAddObjectDefItem(fishID, "deFishingGround", 1, 0.0);
		else
			rmAddObjectDefItem(fishID, fishName, 2, 5.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
		if (oceanRing == 1)
			rmAddObjectDefConstraint(fishID, fishVsFishFar);
		else
			rmAddObjectDefConstraint(fishID, fishVsFishID);
		rmAddObjectDefConstraint(fishID, fishLand);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers + 6);
		if (oceanOffCenter == 1 && oceanMiddle == 1)
			rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers + 6);
		if (oceanRing == 1 && oceanMiddle == 1)
			rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers + 6);
		if (oceanRing == 1 && riverExists == 1)
			rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers + 6);
		if (oceanOffCenter == 1 && riverExists == 1)
			rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers + 6);
		if (oceanRing == 1)
			rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers + 10);

		int whaleID=rmCreateObjectDef("whale");
		rmAddObjectDefItem(whaleID, whaleName, 1, 0.0);
		rmSetObjectDefMinDistance(whaleID, 0.0);
		rmSetObjectDefMaxDistance(whaleID, rmXFractionToMeters(0.5));
		if (oceanRing == 1)
			rmAddObjectDefConstraint(whaleID, whaleVsWhaleFar);
		else
			rmAddObjectDefConstraint(whaleID, whaleVsWhaleID);
		rmAddObjectDefConstraint(whaleID, whaleLand);
		rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, cNumberNonGaiaPlayers + 1);
		if (oceanOffCenter == 1 && oceanMiddle == 1)
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, cNumberNonGaiaPlayers + 1);
		if (oceanRing == 1 && oceanMiddle == 1)
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3);
		if (oceanRing == 1)
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 3);
		if (oceanRing == 1)
			rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);
	}

	// Triggers
	if (rmRandFloat(0,1) <= 0.20 && euMap == 1 && tpORnot != 5)
	{
        rmCreateTrigger("setupRailroad");
        rmSwitchToTrigger(rmTriggerID("setupRailroad"));
        rmSetTriggerPriority(4); 
        rmSetTriggerActive(true);
        rmSetTriggerRunImmediately(true);
        rmSetTriggerLoop(false);

        rmAddTriggerEffect("Trade Route Apply Tech");
        rmSetTriggerEffectParamInt("TradeRoute", tradeRouteID+1, false);
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DETradeRouteUpgradeEurope1"), false);

		if (rmRandFloat(0,1) <= 0.25)
		{
	        rmAddTriggerEffect("Trade Route Apply Tech");
	        rmSetTriggerEffectParamInt("TradeRoute", tradeRouteID+1, false);
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DETradeRouteUpgradeEurope2"), false);
		}
	}
	if (everyoneGetsAWagon == 990)
	{
    	rmCreateTrigger("unknownalliancesmessage");
    	rmSwitchToTrigger(rmTriggerID("unknownalliancesmessage"));
    	rmSetTriggerPriority(4); 
    	rmSetTriggerActive(true);
    	rmSetTriggerRunImmediately(true);
    	rmSetTriggerLoop(false);
		rmAddTriggerCondition("Timer");
		rmSetTriggerConditionParamInt("Param1", 1, false);
		rmAddTriggerEffect("Send Chat");
    	rmSetTriggerEffectParamInt("PlayerID", 0, false);
    	rmSetTriggerEffectParam("Message", "<font=largeingame 24><icon=(40)(resources\art\units\animals\capybara\capybara_portrait.png)><font=floatytext 20><color=0,1,1>You may choose to ally with 1 of 3 Minor Civilizations once you have constructed your Embassy. Choose wisely.", false);

		int natAllianceCount = 3;

		int pirateAlliance = -1;
		int saltpeterAlliance = -1;
		int aztecsAlliance = -1;
		int lakotaAlliance = -1;
		int iroquoisAlliance = -1;
		int caribsAlliance = -1;
		int cherokeeAlliance = -1;
		int comancheAlliance = -1;
		int creeAlliance = -1;
		int nootkaAlliance = -1;
		int quechuaAlliance = -1;
		int seminolesAlliance = -1;
		int tupiAlliance = -1;
		int apacheAlliance = -1;
		int huronAlliance = -1;
		int klamathAlliance = -1;
		int mapucheAlliance = -1;
		int navajoAlliance = -1;
		int bhaktiAlliance = -1;
		int jesuitAlliance = -1;
		int shaolinAlliance = -1;
		int sufiAlliance = -1;
		int udasiAlliance = -1;
		int zenAlliance = -1;
		int lenapeAlliance = -1;
		int tengriAlliance = -1;
		int akanAlliance = -1;
		int berbersAlliance = -1;
		int somalisAlliance = -1;
		int sudaneseAlliance = -1;
		int yorubaAlliance = -1;
		int bourbonAlliance = -1;
		int habsburgAlliance = -1;
		int hanoverAlliance = -1;
		int jagiellonAlliance = -1;
		int oldenburgAlliance = -1;
		int vasaAlliance = -1;
		int wettinAlliance = -1;
		int wittelsbachAlliance = -1;

		for(n = 0; < natAllianceCount)
		{
			if (rmRandFloat(0,1) <= 0.0256 && pirateAlliance != 1)
			{
				pirateAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0270 && saltpeterAlliance != 1)
			{
				saltpeterAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0278 && aztecsAlliance != 1)
			{
				aztecsAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0286 && lakotaAlliance != 1)
			{
				lakotaAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0294 && iroquoisAlliance != 1)
			{
				iroquoisAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0303 && caribsAlliance != 1)
			{
				caribsAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0313 && cherokeeAlliance != 1)
			{
				cherokeeAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0323 && comancheAlliance != 1)
			{
				comancheAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0333 && creeAlliance != 1)
			{
				creeAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0345 && nootkaAlliance != 1)
			{
				nootkaAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0357 && quechuaAlliance != 1)
			{
				quechuaAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0370 && seminolesAlliance != 1)
			{
				seminolesAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0385 && tupiAlliance != 1)
			{
				tupiAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0400 && apacheAlliance != 1)
			{
				apacheAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0417 && huronAlliance != 1)
			{
				huronAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0435 && klamathAlliance != 1)
			{
				klamathAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0455 && mapucheAlliance != 1)
			{
				mapucheAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0476 && navajoAlliance != 1)
			{
				navajoAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0500 && bhaktiAlliance != 1)
			{
				bhaktiAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0526 && jesuitAlliance != 1)
			{
				jesuitAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0556 && shaolinAlliance != 1)
			{
				shaolinAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0588 && sufiAlliance != 1)
			{
				sufiAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0625 && udasiAlliance != 1)
			{
				udasiAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0667 && zenAlliance != 1)
			{
				zenAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0714 && lenapeAlliance != 1)
			{
				lenapeAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0769 && tengriAlliance != 1)
			{
				tengriAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0833 && berbersAlliance != 1)
			{
				berbersAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0909 && akanAlliance != 1)
			{
				akanAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.0100 && somalisAlliance != 1)
			{
				somalisAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.1111 && sudaneseAlliance != 1)
			{
				sudaneseAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.1250 && yorubaAlliance != 1)
			{
				yorubaAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.1429 && bourbonAlliance != 1)
			{
				bourbonAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.1667 && habsburgAlliance != 1)
			{
				habsburgAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.2000 && hanoverAlliance != 1)
			{
				hanoverAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.2500 && jagiellonAlliance != 1)
			{
				jagiellonAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.3333 && oldenburgAlliance != 1)
			{
				oldenburgAlliance = 1;
			}
			else if (rmRandFloat(0,1) <= 0.5000 && vasaAlliance != 1)
			{
				vasaAlliance = 1;
			}
//			else if (rmRandFloat(0,1) <= 0.5000 && wettinAlliance != 1)
//			{
//				wettinAlliance = 1;
//			}
			else if (berbersAlliance != 1)
			{
				wittelsbachAlliance = 1;
			}
			else
			{
				natAllianceCount++;	// ensures 3 are always chosen
			}
		}
	}

	// alliance testing				// for testing
//		pirateAlliance = 1;		
//		saltpeterAlliance = 1;	
//		aztecsAlliance = 1;		
//		lakotaAlliance = 1;		
//		iroquoisAlliance = 1;	
//		caribsAlliance = 1;		
//		cherokeeAlliance = 1;	
//		comancheAlliance = 1;	
//		creeAlliance = 1;		
//		nootkaAlliance = 1;		
//		quechuaAlliance = 1;	
//		seminolesAlliance = 1;	
//		tupiAlliance = 1;		
//		apacheAlliance = 1;		
//		huronAlliance = 1;		
//		klamathAlliance = 1;	
//		mapucheAlliance = 1;	
//		navajoAlliance = 1;		
//		bhaktiAlliance = 1;		
//		jesuitAlliance = 1;		
//		shaolinAlliance = 1;	
//		sufiAlliance = 1;		
//		udasiAlliance = 1;		
//		zenAlliance = 1;		
//		lenapeAlliance = 1;		
//		tengriAlliance = 1;		
//		berbersAlliance = 1;	
//		akanAlliance = 1;		
//		somalisAlliance = 1;	
//		sudaneseAlliance = 1;	
//		yorubaAlliance = 1;		
//		bourbonAlliance = 1;	
//		habsburgAlliance = 1;	
//		hanoverAlliance = 1;	
//		jagiellonAlliance = 1;	
//		oldenburgAlliance = 1;	
//		vasaAlliance = 1;		
//		wittelsbachAlliance = 1;

	if (everyoneGetsAWagon == 981)
	{
		string mercUnit1 = "";
		string mercUnit2 = "";
		string mercUnit3 = "";

		// choose merc 1
		if (rmRandInt(1,14) <= 1)
		{
		    mercUnit1 = "MercBarbaryCorsair";
		}
		else if (rmRandInt(1,13) <= 1)
		{
			mercUnit1 = "deMercAskari";
		}
		else if (rmRandInt(1,12) <= 1)
		{
   		    mercUnit1 = "deMercKanuri";
		}
		else if (rmRandInt(1,11) <= 1)
		{
		    mercUnit1 = "MercManchu";
		}
		else if (rmRandInt(1,10) <= 1)
		{
   		    mercUnit1 = "deMercPistoleer";
		}
		else if (rmRandInt(1,9) <= 1)
		{
		    mercUnit1 = "MercRonin";
		}
		else if (rmRandInt(1,8) <= 1)
		{
			mercUnit1 = "deMercZenata";
		}
		else if (rmRandInt(1,7) <= 1)
		{
   		    mercUnit1 = "MercSwissPikeman";
		}
		else if (rmRandInt(1,6) <= 1)
		{
   		    mercUnit1 = "deMercGrenadier";
		}
		else if (rmRandInt(1,5) <= 1)
		{
   		    mercUnit1 = "deMercBrigadier";
		}
		else if (rmRandInt(1,4) <= 1)
		{
   		    mercUnit1 = "MercBlackRider";
		}
		else if (rmRandInt(1,3) <= 1)
		{
   		    mercUnit1 = "MercFusilier";
		}
		else if (rmRandInt(1,2) <= 1)
		{
   		    mercUnit1 = "MercHighlander";
		}
		else
		{
   		    mercUnit1 = "MercLandsknecht";
		}

		// choose merc 2
		if (rmRandInt(1,11) <= 1)
		{
   		    mercUnit2 = "deMercMountedRifleman";
		}
		else if (rmRandInt(1,10) <= 1)
		{
   		    mercUnit2 = "deMercBosniak";
		}
		else if (rmRandInt(1,9) <= 1)
		{
		    mercUnit2 = "ypMercJatLancer";
		}
		else if (rmRandInt(1,8) <= 1)
		{
   		    mercUnit2 = "deMercHarquebusier";
		}
		else if (rmRandInt(1,7) <= 1)
		{
   		    mercUnit2 = "MercHackapell";
		}
		else if (rmRandInt(1,6) <= 1)
		{
   		    mercUnit2 = "deMercRoyalHorseman";
		}
		else if (rmRandInt(1,5) <= 1)
		{
   		    mercUnit2 = "MercElmeti";
		}
		else if (rmRandInt(1,4) <= 1)
		{
   		    mercUnit2 = "MercStradiot";
		}
		else if (rmRandInt(1,3) <= 1)
		{
		    mercUnit2 = "MercMameluke";
		}
		else if (rmRandInt(1,2) <= 1)
		{
			mercUnit2 = "deMercSudaneseRider";
		}
		else
		{
		    mercUnit2 = "ypMercYojimbo";
		}

		// choose merc 3
		if (rmRandInt(1,8) <= 1)
		{
   		    mercUnit3 = "MercGreatCannon";
		}
		else if (rmRandInt(1,7) <= 1)
		{
		    mercUnit3 = "MercNinja";
		}
		else if (rmRandInt(1,6) <= 1)
		{
   		    mercUnit3 = "MercJaeger";
		}
		else if (rmRandInt(1,5) <= 1)
		{
		    mercUnit3 = "ypMercIronTroop";
		}
		else if (rmRandInt(1,4) <= 1)
		{
   		    mercUnit3 = "deMercPandour";
		}
		else if (rmRandInt(1,3) <= 1)
		{
			mercUnit3 = "deMercCannoneer";
		}
		else if (rmRandInt(1,2) <= 1)
		{
			mercUnit3 = "deMercAmazon";
		}
		else
		{
			mercUnit3 = "deMercGatlingCamel";
		}
	}

	if (campaignHero == 1)
	{
		int whichCampaign = -1;
		if (rmRandFloat(0,1) <= 0.125)
		{
			whichCampaign = 1;
		}
		else if (rmRandFloat(0,1) <= 0.143)
		{
			whichCampaign = 2;
		}
		else if (rmRandFloat(0,1) <= 0.167)
		{
			whichCampaign = 3;
		}
		else if (rmRandFloat(0,1) <= 0.20)
		{
			whichCampaign = 4;
		}
		else if (rmRandFloat(0,1) <= 0.25)
		{
			whichCampaign = 5;
		}
		else if (rmRandFloat(0,1) <= 0.333)
		{
			whichCampaign = 6;
		}
		else if (rmRandFloat(0,1) <= 0.50)
		{
			whichCampaign = 7;
		}
		else
		{
			whichCampaign = 8;
		}
	}
	if (everyoneGetsAWagon == 982)
	{
		// Enable Commandery Troops
		int whichCommandery1 = rmRandInt(1,8);
			whichCommandery1 = 8;	// always SJWs because i'm greedy as Mitoe
		int whichCommandery2 = rmRandInt(1,8);
		string commandUnit1 = "";
		string commandUnit2 = "";

		if (whichCommandery1 == 1)
		{
			commandUnit1 = "ypConsulateLifeGuard";
			whichCommandery2 = rmRandInt(2,8);
		}
		if (whichCommandery1 == 2)
		{
			commandUnit1 = "deConsulateLongbowman";
			if (rmRandFloat(0,1) <= 0.1429)
				whichCommandery2 = 1;
			else
				whichCommandery2 = rmRandInt(3,8);
		}
		if (whichCommandery1 == 3)
		{
			commandUnit1 = "ypConsulateJinete";
			if (rmRandFloat(0,1) <= 0.2858)
				whichCommandery2 = rmRandInt(1,2);
			else
				whichCommandery2 = rmRandInt(4,8);
		}
		if (whichCommandery1 == 4)
		{
			commandUnit1 = "deConsulateCacadore";
			if (rmRandFloat(0,1) <= 0.4287)
				whichCommandery2 = rmRandInt(1,3);
			else
				whichCommandery2 = rmRandInt(5,8);
		}
		if (whichCommandery1 == 5)
		{
			commandUnit1 = "ypConsulateGarrochista";
			if (rmRandFloat(0,1) <= 0.5716)
				whichCommandery2 = rmRandInt(1,4);
			else
				whichCommandery2 = rmRandInt(6,8);
		}
		if (whichCommandery1 == 6)
		{
			commandUnit1 = "ypConsulateGendarmes";
			if (rmRandFloat(0,1) <= 0.7145)
				whichCommandery2 = rmRandInt(1,5);
			else
				whichCommandery2 = rmRandInt(7,8);
		}
		if (whichCommandery1 == 7)
		{
			commandUnit1 = "deConsulateOprichnik";
			if (rmRandFloat(0,1) <= 0.1429)
				whichCommandery2 = 8;
			else
				whichCommandery2 = rmRandInt(1,6);
		}
		if (whichCommandery1 == 8)
		{
			commandUnit1 = "SettlerWagon";
			whichCommandery2 = rmRandInt(1,7);
		}
		if (whichCommandery2 == 1)
		{
			commandUnit2 = "ypConsulateLifeGuard";
		}
		if (whichCommandery2 == 2)
		{
			commandUnit2 = "deConsulateLongbowman";
		}
		if (whichCommandery2 == 3)
		{
			commandUnit2 = "ypConsulateJinete";
		}
		if (whichCommandery2 == 4)
		{
			commandUnit2 = "deConsulateCacadore";
		}
		if (whichCommandery2 == 5)
		{
			commandUnit2 = "ypConsulateGarrochista";
		}
		if (whichCommandery2 == 6)
		{
			commandUnit2 = "ypConsulateGendarmes";
		}
		if (whichCommandery2 == 7)
		{
			commandUnit2 = "deConsulateOprichnik";
		}
		if (whichCommandery2 == 8)
		{
			commandUnit2 = "SettlerWagon";
		}
	}
	if (commandPost == 1)
	{
    	rmCreateTrigger("funkywarning");
    	rmSwitchToTrigger(rmTriggerID("funkywarning"));
    	rmSetTriggerPriority(4); 
    	rmSetTriggerActive(true);
    	rmSetTriggerRunImmediately(true);
    	rmSetTriggerLoop(false);
		rmAddTriggerCondition("Timer");
		rmSetTriggerConditionParamInt("Param1", 1, false);
		rmAddTriggerEffect("Send Chat");
    	rmSetTriggerEffectParamInt("PlayerID", 0, false);
    	rmSetTriggerEffectParam("Message", "<font=largeingame 24><icon=(40)(resources\art\units\animals\capybara\capybara_portrait.png)><font=floatytext 20><color=0,1,1>There has been an Ev0lution. Things are about to get funky. xD", false);

		int howFunky = -1;
		if (rmRandFloat(0,1) <= 0.25)
		{
			howFunky = 1;
		}
		else if (rmRandFloat(0,1) <= 0.333)
		{
			howFunky = 2;
		}
		else if (rmRandFloat(0,1) <= 0.50)
		{
			howFunky = 3;
		}
		else if (rmRandFloat(0,1) <= 0.75)
		{
			howFunky = 4;
		}
		else if (rmRandFloat(0,1) <= 0.75)
		{
			howFunky = 5;
		}
		else
		{
			howFunky = 6;
		}
	}
	if (everyoneGetsAWagon == 996)
	{
    	rmCreateTrigger("wignacourtmessage");
    	rmSwitchToTrigger(rmTriggerID("wignacourtmessage"));
    	rmSetTriggerPriority(4); 
    	rmSetTriggerActive(true);
    	rmSetTriggerRunImmediately(true);
    	rmSetTriggerLoop(false);
		rmAddTriggerCondition("Timer");
		rmSetTriggerConditionParamInt("Param1", 1, false);
		rmAddTriggerEffect("Send Chat");
    	rmSetTriggerEffectParamInt("PlayerID", 0, false);
    	rmSetTriggerEffectParam("Message", "<font=largeingame 24><icon=(40)(resources\art\units\animals\capybara\capybara_portrait.png)><font=floatytext 20><color=0,1,1>Place your Outposts strategically to boost your economy! glhf", false);
	}

	for(i = 1; < cNumberPlayers)
	{
		if (plymouthMap == 1)
		{
			rmCreateTrigger("enablepilgrims"+i);
			rmSwitchToTrigger(rmTriggerID("enablepilgrims"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
		    rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownTrainablePilgrims"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}

		rmCreateTrigger("generalbuildtc"+i);
		rmSwitchToTrigger(rmTriggerID("generalbuildtc"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
	    rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEMapAddTownCenterGeneral"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("architectnoTC"+i);
		rmSwitchToTrigger(rmTriggerID("architectnoTC"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
	    rmSetTriggerEffectParamInt("TechID", rmGetTechID("DERemoveTownCenterArchitect"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		if (everyoneGetsAWagon == 1003)
		{
			rmCreateTrigger("trekwagonactivate"+i);
			rmSwitchToTrigger(rmTriggerID("trekwagonactivate"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownTrekWagon"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (everyoneGetsAWagon == 971 || trollMap == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("plazawagon"+i);
				rmSwitchToTrigger(rmTriggerID("plazawagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownCommunityPlazaEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Japanese") || rmGetPlayerCiv(i) == rmGetCivID("Indians"))
			{
				rmCreateTrigger("monasterywagon"+i);
				rmSwitchToTrigger(rmTriggerID("monasterywagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownMonasteryEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("DEHausa"))
			{
				rmCreateTrigger("mosquewagon"+i);
				rmSwitchToTrigger(rmTriggerID("mosquewagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownHausaMosqueEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians"))
			{
				rmCreateTrigger("ethchurchwagon"+i);
				rmSwitchToTrigger(rmTriggerID("ethchurchwagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownEthiopiaChurchEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("DEMexicans"))
			{
				rmCreateTrigger("cathedralwagon"+i);
				rmSwitchToTrigger(rmTriggerID("cathedralwagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownCathedralEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("DEItalians"))
			{
				rmCreateTrigger("basilicawagon"+i);
				rmSwitchToTrigger(rmTriggerID("basilicawagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownBasilicaEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("Ottomans"))
			{
				rmCreateTrigger("ottomosquewagon"+i);
				rmSwitchToTrigger(rmTriggerID("ottomosquewagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownChurchEnablerOttomans"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("Spanish"))
			{
				rmCreateTrigger("spainchurchwagon"+i);
				rmSwitchToTrigger(rmTriggerID("spainchurchwagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownChurchEnablerSpain"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (rmGetPlayerCiv(i) == rmGetCivID("DEAmericans"))
			{
				rmCreateTrigger("usachurchwagon"+i);
				rmSwitchToTrigger(rmTriggerID("usachurchwagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownChurchEnablerUSA"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else
			{
				rmCreateTrigger("nillachurchwagon"+i);
				rmSwitchToTrigger(rmTriggerID("nillachurchwagon"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownChurchEnabler"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}
		if (everyoneGetsAWagon == 972 || trollMap == 1)
		{
			rmCreateTrigger("freemarketsforall"+i);
			rmSwitchToTrigger(rmTriggerID("freemarketsforall"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownFreeMarkets"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (everyoneGetsAWagon == 996)
		{
			rmCreateTrigger("wignacourtactivate"+i);
			rmSwitchToTrigger(rmTriggerID("wignacourtactivate"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownWignacourt"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);

			if (rmGetPlayerCiv(i) == rmGetCivID("DEMaltese"))
			{
				rmCreateTrigger("maltaproperwigna"+i);
				rmSwitchToTrigger(rmTriggerID("maltaproperwigna"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", rmGetTechID("DEHCWignacourtConstructions"), false);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
		        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownWIgnacourtMaltaDoubleBonus"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}
		if (everyoneGetsAWagon == 995)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("DESwedish"))
			{
				// plus one torp
				rmCreateTrigger("torpplus1BL"+i);
				rmSwitchToTrigger(rmTriggerID("torpplus1BL"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);

				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "deTorp");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// none
			}
			else
			{
				rmCreateTrigger("BBactivate"+i);
				rmSwitchToTrigger(rmTriggerID("BBactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerCondition("Tech Status Equals");
				rmSetTriggerConditionParamInt("PlayerID", i);
			    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
				rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
		        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEHCBlueberries"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);

				rmCreateTrigger("blackberriesactivate"+i);
				rmSwitchToTrigger(rmTriggerID("blackberriesactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerCondition("Tech Status Equals");
				rmSetTriggerConditionParamInt("PlayerID", i);
			    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Fortressize"), false);
				rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
		        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEHCBlackberries"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);

				rmCreateTrigger("northernforestsactivate"+i);
				rmSwitchToTrigger(rmTriggerID("northernforestsactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerCondition("Tech Status Equals");
				rmSetTriggerConditionParamInt("PlayerID", i);
			    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Industrialize"), false);
				rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
		        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEHCNorthernForests"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}
		if (heroDog == 1)
		{
			// plus one hero dog
			rmCreateTrigger("heropupBL"+i);
			rmSwitchToTrigger(rmTriggerID("heropupBL"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
		
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "ExplorerDog");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 01);		// none
		}
		if (heroSheep == 1)
		{
			// plus one hero sheep
			rmCreateTrigger("herosheepBL"+i);
			rmSwitchToTrigger(rmTriggerID("herosheepBL"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
		
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "DEExplorerSheep");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 01);		// none
		}
		if (surgeonScout == 1)
		{
			// surgeon builds field hospital
			rmCreateTrigger("fieldhospitalactivatesurgeon"+i);
			rmSwitchToTrigger(rmTriggerID("fieldhospitalactivatesurgeon"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", "FieldHospital");
		}
		if (campaignHero == 1)	// campaign heroes
		{
			if (whichCampaign == 1)
			{
				rmCreateTrigger("chenactivate"+i);
				rmSwitchToTrigger(rmTriggerID("chenactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Fortressize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownLaoChen"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (whichCampaign == 2)
			{
				rmCreateTrigger("stuartactivate"+i);
				rmSwitchToTrigger(rmTriggerID("stuartactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownStuart"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (whichCampaign == 3)
			{
				rmCreateTrigger("nanibactivate"+i);
				rmSwitchToTrigger(rmTriggerID("nanibactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Fortressize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownNanib"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (whichCampaign == 4)
			{
				rmCreateTrigger("kichiroactivate"+i);
				rmSwitchToTrigger(rmTriggerID("kichiroactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Industrialize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownKichiro"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (whichCampaign == 5)
			{
				rmCreateTrigger("morganactivate"+i);
				rmSwitchToTrigger(rmTriggerID("morganactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Fortressize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownMorgan"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (whichCampaign == 6)
			{
				rmCreateTrigger("eaglemutactivate"+i);
				rmSwitchToTrigger(rmTriggerID("eaglemutactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownNonahkee"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (whichCampaign == 7)
			{
				rmCreateTrigger("alainactivate"+i);
				rmSwitchToTrigger(rmTriggerID("alainactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Fortressize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownAlain"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else
			{
				rmCreateTrigger("lizzieactivate"+i);
				rmSwitchToTrigger(rmTriggerID("lizzieactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
			    rmAddTriggerCondition("Tech Status Equals");
			    rmSetTriggerConditionParamInt("PlayerID", i);
		        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Industrialize"), false);
			    rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownLizzie"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}
		if (commandPost == 1)	// funky techs
		{
			if (howFunky == 1)
			{
				rmCreateTrigger("handicapactivate"+i);
				rmSwitchToTrigger(rmTriggerID("handicapactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownHandicap"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (howFunky == 2)
			{
				rmCreateTrigger("overpopactivate"+i);
				rmSwitchToTrigger(rmTriggerID("overpopactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownOverpop"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (howFunky == 3)
			{
				rmCreateTrigger("fastageactivate"+i);
				rmSwitchToTrigger(rmTriggerID("fastageactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownFastAge"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (howFunky == 4)
			{
				rmCreateTrigger("fasttechsactivate"+i);
				rmSwitchToTrigger(rmTriggerID("fasttechsactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownFastResearch"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else if (howFunky == 5)
			{
				rmCreateTrigger("fieldhospitalsactivate"+i);
				rmSwitchToTrigger(rmTriggerID("fieldhospitalsactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownFieldHospital"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			else
			{
				rmCreateTrigger("nowallsecoregenactivate"+i);
				rmSwitchToTrigger(rmTriggerID("nowallsecoregenactivate"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownNoWallsEcoRegen"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}
		if (africanDesertMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twcafricandesertoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twcafricandesertoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsAfricanDesertFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}		
		if (africanMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twcafricanoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twcafricanoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsAfricanFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}		
		if (americanMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twcamericanoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twcamericanoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsAmericanFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}		
		if (southAmMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twcsouthamericanoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twcsouthamericanoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsSouthAmericanFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}		
		if (mexicanMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twcmexicanoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twcmexicanoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsMexicanFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}		
		if (asianMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twcasianoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twcasianoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsAsianFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}		
		if (europeanMerc == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
			{
				rmCreateTrigger("twceuropeanoutlaws"+i);
				rmSwitchToTrigger(rmTriggerID("twceuropeanoutlaws"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableOutlawsEuropeanFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
		}
		if (yellowRiverMap == 1)
		{
			// add bomb - thanks Enki
			rmCreateTrigger("AddBomb"+i);
			rmSwitchToTrigger(rmTriggerID("AddBomb"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", 2407);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (trollMap == 1)
		{
			// forbid walls
			rmCreateTrigger("wallbuildlimit"+i);
			rmSwitchToTrigger(rmTriggerID("wallbuildlimit"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
		
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "WallStraight5");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 01);		// none
		}
		if (everyoneGetsAWagon == 983)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("Indians") == false)
			{
				rmCreateTrigger("sacredfieldfix"+i);
				rmSwitchToTrigger(rmTriggerID("sacredfieldfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
        		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownSacredFieldWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
			}
			else
			{
				rmCreateTrigger("extrasacredfield"+i);
				rmSwitchToTrigger(rmTriggerID("extrasacredfield"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "ypSacredField");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// plus one
			}
		}
		if (everyoneGetsAWagon == 988)
		{
			rmCreateTrigger("batterytowertechs"+i);
			rmSwitchToTrigger(rmTriggerID("batterytowertechs"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownBatteryTowerTechs"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 984 || trollMap == 1)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("DEMaltese") == false)
			{
				rmCreateTrigger("depotwagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("depotwagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
	        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownDepotWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
			}
			rmCreateTrigger("depotwagontraining"+i);
			rmSwitchToTrigger(rmTriggerID("depotwagontraining"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownDepotWagonTraining"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 982)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("DEMaltese") == false)
			{
				rmCreateTrigger("commanderywagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("commanderywagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
        		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownCommanderyWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
			}

			// Enable Commandery Troops
			rmCreateTrigger("commanderytroopsactivate1"+i);
			rmSwitchToTrigger(rmTriggerID("commanderytroopsactivate1"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", commandUnit1);

			rmCreateTrigger("commanderytroopsactivate2"+i);
			rmSwitchToTrigger(rmTriggerID("commanderytroopsactivate2"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", commandUnit2);
		}
		if (everyoneGetsAWagon == 987)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("DEItalians") == false)
			{
				rmCreateTrigger("activatelombards"+i);
				rmSwitchToTrigger(rmTriggerID("activatelombards"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
        		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownLombardWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
//			else
//			{
//				rmCreateTrigger("extralombard"+i);
//				rmSwitchToTrigger(rmTriggerID("extralombard"+i));
//				rmSetTriggerActive(true);
//				rmSetTriggerRunImmediately(true);
//				rmSetTriggerPriority(4);
//				rmAddTriggerCondition("Always");
//				rmAddTriggerEffect("Modify Protounit");
//				rmSetTriggerEffectParam("Protounit", "deLombard");
//				rmSetTriggerEffectParamInt("PlayerID", i);
//				rmSetTriggerEffectParamInt("Field", 10);		// build limit
//				rmSetTriggerEffectParamInt("Delta", 01);		// plus one
//			}
			rmCreateTrigger("depositcoin"+i);
			rmSwitchToTrigger(rmTriggerID("depositcoin"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
       		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DELombardyWagonDeposit"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
	if (everyoneGetsAWagon == 69 || trollMap == 1)	// jeff wagons
	{
		rmCreateTrigger("jeffwagonfood"+i);
		rmSwitchToTrigger(rmTriggerID("jeffwagonfood"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
	    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownJeffWagonColonial"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("jeffwagonwood"+i);
		rmSwitchToTrigger(rmTriggerID("jeffwagonwood"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
	    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Fortressize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownJeffWagonFortress"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("jeffwagoncoin"+i);
		rmSwitchToTrigger(rmTriggerID("jeffwagoncoin"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
	    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Industrialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownJeffWagonIndustrial"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("jeffwagonall"+i);
		rmSwitchToTrigger(rmTriggerID("jeffwagonall"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
	    rmSetTriggerConditionParamInt("TechID", rmGetTechID("Imperialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownJeffWagonImperial"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);
	}
	if (everyoneGetsAWagon == 973)
	{
		rmCreateTrigger("morocco"+i);
		rmSwitchToTrigger(rmTriggerID("morocco"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownMoroccanAlliance"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("activateuniquetowers"+i);
		rmSwitchToTrigger(rmTriggerID("activateuniquetowers"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
       	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownUniqueTowerWagonFix"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);
	}
	if (everyoneGetsAWagon == 990)
	{
		rmCreateTrigger("embassyenabler"+i);
		rmSwitchToTrigger(rmTriggerID("embassyenabler"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("ypNativeEmbassyEnabler"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("embassyenablershadow"+i);
		rmSwitchToTrigger(rmTriggerID("embassyenablershadow"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("ypNativeEmbassyEnableShadow"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		if (saltpeterAlliance == 1)
		{
			rmCreateTrigger("saltpeteralliance"+i);
			rmSwitchToTrigger(rmTriggerID("saltpeteralliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceSaltpeterEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (pirateAlliance == 1)
		{
			rmCreateTrigger("piratealliance"+i);
			rmSwitchToTrigger(rmTriggerID("piratealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAlliancePiratesEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (aztecsAlliance == 1)
		{
			rmCreateTrigger("aztecalliance"+i);
			rmSwitchToTrigger(rmTriggerID("aztecalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceAztecsEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (lakotaAlliance == 1)
		{
			rmCreateTrigger("lakotaalliance"+i);
			rmSwitchToTrigger(rmTriggerID("lakotaalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceLakotaEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (iroquoisAlliance == 1)
		{
			rmCreateTrigger("iroquoisalliance"+i);
			rmSwitchToTrigger(rmTriggerID("iroquoisalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceIroquoisEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (caribsAlliance == 1)
		{
			rmCreateTrigger("cariballiance"+i);
			rmSwitchToTrigger(rmTriggerID("cariballiance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceCaribsEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (cherokeeAlliance == 1)
		{
			rmCreateTrigger("cherokeealliance"+i);
			rmSwitchToTrigger(rmTriggerID("cherokeealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceCherokeeEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (comancheAlliance == 1)
		{
			rmCreateTrigger("comanchealliance"+i);
			rmSwitchToTrigger(rmTriggerID("comanchealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceComancheEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (creeAlliance == 1)
		{
			rmCreateTrigger("creealliance"+i);
			rmSwitchToTrigger(rmTriggerID("creealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceCreeEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (nootkaAlliance == 1)
		{
			rmCreateTrigger("nootkaalliance"+i);
			rmSwitchToTrigger(rmTriggerID("nootkaalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceNootkaEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (quechuaAlliance == 1)
		{
			rmCreateTrigger("quechuaalliance"+i);
			rmSwitchToTrigger(rmTriggerID("quechuaalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceQuechuasEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (seminolesAlliance == 1)
		{
			rmCreateTrigger("seminolealliance"+i);
			rmSwitchToTrigger(rmTriggerID("seminolealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceSeminolesEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (tupiAlliance == 1)
		{
			rmCreateTrigger("tupialliance"+i);
			rmSwitchToTrigger(rmTriggerID("tupialliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceTupiEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (apacheAlliance == 1)
		{
			rmCreateTrigger("apachealliance"+i);
			rmSwitchToTrigger(rmTriggerID("apachealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceApacheEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (huronAlliance == 1)
		{
			rmCreateTrigger("huronalliance"+i);
			rmSwitchToTrigger(rmTriggerID("huronalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceHuronEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (klamathAlliance == 1)
		{
			rmCreateTrigger("klamathalliance"+i);
			rmSwitchToTrigger(rmTriggerID("klamathalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceKlamathEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (mapucheAlliance == 1)
		{
			rmCreateTrigger("mapuchealliance"+i);
			rmSwitchToTrigger(rmTriggerID("mapuchealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceMapucheEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (navajoAlliance == 1)
		{
			rmCreateTrigger("navajoalliance"+i);
			rmSwitchToTrigger(rmTriggerID("navajoalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceNavajoEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (bhaktiAlliance == 1)
		{
			rmCreateTrigger("bhaktialliance"+i);
			rmSwitchToTrigger(rmTriggerID("bhaktialliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceBhaktiEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (jesuitAlliance == 1)
		{
			rmCreateTrigger("jesuitalliance"+i);
			rmSwitchToTrigger(rmTriggerID("jesuitalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceJesuitEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (shaolinAlliance == 1)
		{
			rmCreateTrigger("shaolinalliance"+i);
			rmSwitchToTrigger(rmTriggerID("shaolinalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceShaolinEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (sufiAlliance == 1)
		{
			rmCreateTrigger("sufialliance"+i);
			rmSwitchToTrigger(rmTriggerID("sufialliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceSufiEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (udasiAlliance == 1)
		{
			rmCreateTrigger("udasialliance"+i);
			rmSwitchToTrigger(rmTriggerID("udasialliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceUdasiEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (zenAlliance == 1)
		{
			rmCreateTrigger("zenalliance"+i);
			rmSwitchToTrigger(rmTriggerID("zenalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceZenEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (lenapeAlliance == 1)
		{
			rmCreateTrigger("lenapealliance"+i);
			rmSwitchToTrigger(rmTriggerID("lenapealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceLenapeEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (tengriAlliance == 1)
		{
			rmCreateTrigger("tengrialliance"+i);
			rmSwitchToTrigger(rmTriggerID("tengrialliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceTengriEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (akanAlliance == 1)
		{
			rmCreateTrigger("akanalliance"+i);
			rmSwitchToTrigger(rmTriggerID("akanalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceAkanEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
					}
		if (berbersAlliance == 1)
		{
			rmCreateTrigger("berberalliance"+i);
			rmSwitchToTrigger(rmTriggerID("berberalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceBerbersEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (somalisAlliance == 1)
		{
			rmCreateTrigger("somalialliance"+i);
			rmSwitchToTrigger(rmTriggerID("somalialliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceSomalisEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (sudaneseAlliance == 1)
		{
			rmCreateTrigger("sudanesealliance"+i);
			rmSwitchToTrigger(rmTriggerID("sudanesealliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceSudaneseEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (yorubaAlliance == 1)
		{
			rmCreateTrigger("yorubaalliance"+i);
			rmSwitchToTrigger(rmTriggerID("yorubaalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceYorubaEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (bourbonAlliance == 1)
		{
			rmCreateTrigger("bourbonalliance"+i);
			rmSwitchToTrigger(rmTriggerID("bourbonalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceBourbonEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (habsburgAlliance == 1)
		{
			rmCreateTrigger("habsburgalliance"+i);
			rmSwitchToTrigger(rmTriggerID("habsburgalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceHabsburgEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (hanoverAlliance == 1)
		{
			rmCreateTrigger("hanoveralliance"+i);
			rmSwitchToTrigger(rmTriggerID("hanoveralliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceHanoverEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (jagiellonAlliance == 1)
		{
			rmCreateTrigger("jagiellonalliance"+i);
			rmSwitchToTrigger(rmTriggerID("jagiellonalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceJagiellonEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (oldenburgAlliance == 1)
		{
			rmCreateTrigger("oldenburgalliance"+i);
			rmSwitchToTrigger(rmTriggerID("oldenburgalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceOldenburgEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (vasaAlliance == 1)
		{
			rmCreateTrigger("vasaalliance"+i);
			rmSwitchToTrigger(rmTriggerID("vasaalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceVasaEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (wettinAlliance == 1)
		{
			rmCreateTrigger("wettinalliance"+i);
			rmSwitchToTrigger(rmTriggerID("wettinalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceWettinEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (wittelsbachAlliance == 1)
		{
			rmCreateTrigger("wittelsbachalliance"+i);
			rmSwitchToTrigger(rmTriggerID("wittelsbachalliance"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
	        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownAllianceWittelsbachEnabler"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
	}
	if (everyoneGetsAWagon == 979 || trollMap == 1)
	{
		rmCreateTrigger("phanaralliance"+i);
		rmSwitchToTrigger(rmTriggerID("phanaralliance"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownPhanarAlliance"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);

		rmCreateTrigger("athosactivate"+i);
		rmSwitchToTrigger(rmTriggerID("athosactivate"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DENatPhanarMountAthos"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);				
	}
	if (everyoneGetsAWagon == 980 || trollMap == 1)
	{
		rmCreateTrigger("mayanalliance"+i);
		rmSwitchToTrigger(rmTriggerID("mayanalliance"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownMayanAlliance"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);		

		rmCreateTrigger("mayacastleactivate"+i);
		rmSwitchToTrigger(rmTriggerID("mayacastleactivate"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("NatMayaPyramids"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);		

		rmCreateTrigger("cruzobimperialize"+i);
		rmSwitchToTrigger(rmTriggerID("cruzobimperialize"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Imperialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEREVImperialCruzobInfantry"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);		
	}		
	if (everyoneGetsAWagon == 985 || trollMap == 1)
	{
		rmCreateTrigger("fortressfixedgun"+i);
		rmSwitchToTrigger(rmTriggerID("fortressfixedgun"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
        rmSetTriggerConditionParamInt("TechID", rmGetTechID("FortRessize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownFixedGunWagon"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);		
	}		
	if (everyoneGetsAWagon == 981)
	{
		rmCreateTrigger("mercactivate1"+i);
		rmSwitchToTrigger(rmTriggerID("mercactivate1"+i));
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4);
		rmAddTriggerCondition("Always");
		rmAddTriggerEffect("Unforbid and Enable Unit");
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParam("Protounit", mercUnit1);

		rmCreateTrigger("mercactivate2"+i);
		rmSwitchToTrigger(rmTriggerID("mercactivate2"+i));
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4);
		rmAddTriggerCondition("Always");
		rmAddTriggerEffect("Unforbid and Enable Unit");
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParam("Protounit", mercUnit2);

		rmCreateTrigger("mercactivate3"+i);
		rmSwitchToTrigger(rmTriggerID("mercactivate3"+i));
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerPriority(4);
		rmAddTriggerCondition("Always");
		rmAddTriggerEffect("Unforbid and Enable Unit");
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParam("Protounit", mercUnit3);

		rmCreateTrigger("colotavernwagon"+i);
		rmSwitchToTrigger(rmTriggerID("colotavernwagon"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownTavernWagon"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);		
		if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca") || rmGetPlayerCiv(i) == rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Japanese") || rmGetPlayerCiv(i) == rmGetCivID("Indians") || rmGetPlayerCiv(i) == rmGetCivID("DEHausa") || rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians") || rmGetPlayerCiv(i) == rmGetCivID("DEItalians"))
		{
			rmCreateTrigger("activatetaverns"+i);
			rmSwitchToTrigger(rmTriggerID("activatetaverns"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownTavernWagonFix"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (rmGetPlayerCiv(i) == rmGetCivID("DEAmericans") || rmGetPlayerCiv(i) == rmGetCivID("DEMexicans"))
		{
			rmCreateTrigger("activatetaverns"+i);
			rmSwitchToTrigger(rmTriggerID("activatetaverns"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownSaloonFix"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
		if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca"))
		{
			rmCreateTrigger("twctavernfix"+i);
			rmSwitchToTrigger(rmTriggerID("twctavernfix"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
        	rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownEnableTavernTWCFix"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);
		}
	}		
	if (everyoneGetsAWagon == 666 || trollMap == 1)
	{
		rmCreateTrigger("colomilitarywagon"+i);
		rmSwitchToTrigger(rmTriggerID("colomilitarywagon"+i));
		rmSetTriggerPriority(4);
		rmSetTriggerActive(true);
		rmSetTriggerRunImmediately(true);
		rmSetTriggerLoop(false);				
	    rmAddTriggerCondition("Tech Status Equals");
	    rmSetTriggerConditionParamInt("PlayerID", i);
        rmSetTriggerConditionParamInt("TechID", rmGetTechID("Colonialize"), false);
	    rmSetTriggerConditionParamInt("Status", 2);
		rmAddTriggerEffect("Set Tech Status");
        rmSetTriggerEffectParamInt("TechID", rmGetTechID("deUnknownMilitaryWagon"), false);
		rmSetTriggerEffectParamInt("PlayerID", i);
		rmSetTriggerEffectParamInt("Status", 2);		
	}		
		if (asianMap == 1 && everyoneGetsAWagon != 980)
		{
			if (rmRandFloat(0,1) <= 0.01 || trollMap == 1)
			{
				// Enable shark at dock
				rmCreateTrigger("sharkactivate"+i);
				rmSwitchToTrigger(rmTriggerID("sharkactivate"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Unforbid and Enable Unit");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParam("Protounit", "ypGreatWhiteShark");
			}
		}
		if (euMap == 1)
		{
			if (boneRNG <= 0.05 || trollMap == 1)
			{
				// Enable some boneguard units at rax
				rmCreateTrigger("boneguardactivate"+i);
				rmSwitchToTrigger(rmTriggerID("boneguardactivate"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Unforbid and Enable Unit");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParam("Protounit", boneType);
			}
		}
		if (scoutRNG <= 0.05 || trollMap == 1)
		{
			// Enable Hot Air Balloon and Train it Instantly
			rmCreateTrigger("balloonactivation"+i);
			rmSwitchToTrigger(rmTriggerID("balloonactivation"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", "HotAirBalloon");

			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "HotAirBalloon");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 10);		// build limit
			rmSetTriggerEffectParamInt("Delta", 02);		// one

			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "HotAirBalloon");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 3);			// train points
			rmSetTriggerEffectParamInt("Delta", -30);		// zero (30-30=0)
		}
		if (fountainChance == 1 && caribbeanMap == 1)
		{
			// Enable Fire Ships
			rmCreateTrigger("fireshipactivate"+i);
			rmSwitchToTrigger(rmTriggerID("fireshipactivate"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", "SPCFireship");
		}
		if (trollMap == 1 || everyoneGetsAWagon == 984)
		{
			// Enable Hoops
			rmCreateTrigger("hoopactivate"+i);
			rmSwitchToTrigger(rmTriggerID("hoopactivate"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", "SPCHoopThrowers");

			rmCreateTrigger("hoopbuff"+i);
			rmSwitchToTrigger(rmTriggerID("hoopbuff"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownHoopThrowersMultipliers"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 991)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("DEMexicans") == false)
			{
				rmCreateTrigger("haciendawagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("haciendawagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 4698);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEHCBarbacoa"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
			if (rmGetPlayerCiv(i) == rmGetCivID("DEMexicans") || rmGetPlayerCiv(i) == rmGetCivID("Spanish"))
			{
				rmCreateTrigger("extrahacienda"+i);
				rmSwitchToTrigger(rmTriggerID("extrahacienda"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "deHacienda");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// plus one
			}	
		}
		if (everyoneGetsAWagon == 989 || trollMap == 1)
		{
			// Enable Miner
			rmCreateTrigger("mineractivate"+i);
			rmSwitchToTrigger(rmTriggerID("mineractivate"+i));
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerPriority(4);
			rmAddTriggerCondition("Always");
			rmAddTriggerEffect("Unforbid and Enable Unit");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParam("Protounit", "deMiner");
		}
		if (everyoneGetsAWagon == 994)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("Dutch") == false)
			{
				rmCreateTrigger("bankwagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("bankwagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownBankWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
			}
			else
			{
				rmCreateTrigger("extrabank"+i);
				rmSwitchToTrigger(rmTriggerID("extrabank"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "Bank");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// plus one
			}
		}
		if (everyoneGetsAWagon == 993 || trollMap == 1)
		{
			rmCreateTrigger("buildinghp"+i);
			rmSwitchToTrigger(rmTriggerID("buildinghp"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEBuildingHPNugget"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 986 || trollMap == 1)
		{
			rmCreateTrigger("fastbuilding"+i);
			rmSwitchToTrigger(rmTriggerID("fastbuilding"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownStonemasonsLite"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 1002)
		{
			rmCreateTrigger("grovebonus"+i);
			rmSwitchToTrigger(rmTriggerID("grovebonus"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownGroveWagonBonus"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 999 && rmGetPlayerCiv(i) == rmGetCivID("Japanese") == false)
		{
			rmCreateTrigger("shrinewagonfix"+i);
			rmSwitchToTrigger(rmTriggerID("shrinewagonfix"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownShrineWagonFix"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	

			rmCreateTrigger("shrineindusbuff"+i);
			rmSwitchToTrigger(rmTriggerID("shrineindusbuff"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);			
			rmAddTriggerCondition("Tech Status Equals");
			rmSetTriggerConditionParamInt("PlayerID", i);
			rmSetTriggerConditionParamInt("TechID", rmGetTechID("Industrialize"), false);
			rmSetTriggerConditionParamInt("Status", 2);	
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("ypShrineFortressUpgrade"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	

			rmCreateTrigger("shrinebuddhabuff"+i);
			rmSwitchToTrigger(rmTriggerID("shrinebuddhabuff"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);			
			rmAddTriggerCondition("Tech Status Equals");
			rmSetTriggerConditionParamInt("PlayerID", i);
			rmSetTriggerConditionParamInt("TechID", rmGetTechID("Imperialize"), false);
			rmSetTriggerConditionParamInt("Status", 2);	
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("ypGiantBuddhaShrineBonus"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 1000)
		{
			rmCreateTrigger("dojoworksfaster"+i);
			rmSwitchToTrigger(rmTriggerID("dojoworksfaster"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownDojoWagonFix"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	

			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "ypDojoYumiArmy");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 3);			// train points
			rmSetTriggerEffectParamInt("Delta", -11);		// -11 seconds
			
			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "ypDojoAshigaruArmy");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 3);			// train points
			rmSetTriggerEffectParamInt("Delta", -12);		// -12 seconds

			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "ypDojoKenseiArmy");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 3);			// train points
			rmSetTriggerEffectParamInt("Delta", -13);		// -13 seconds

			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "ypDojoNaginataRiderArmy");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 3);			// train points
			rmSetTriggerEffectParamInt("Delta", -14);		// -14 seconds

			rmAddTriggerEffect("Modify Protounit");
			rmSetTriggerEffectParam("Protounit", "ypDojoYabusameArmy");
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Field", 3);			// train points
			rmSetTriggerEffectParamInt("Delta", -15);		// -15 seconds

			if (rmGetPlayerCiv(i) == rmGetCivID("Japanese") == false)
			{
				rmCreateTrigger("dojowagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("dojowagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 4727);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	

				rmCreateTrigger("disciplinedyumi"+i);
				rmSwitchToTrigger(rmTriggerID("disciplinedyumi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 586);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1772);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);			

				rmCreateTrigger("honoredyumi"+i);
				rmSwitchToTrigger(rmTriggerID("honoredyumi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 419);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1776);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);		

				rmCreateTrigger("exaltedyumi"+i);
				rmSwitchToTrigger(rmTriggerID("exaltedyumi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 484);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1780);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("disciplinednagi"+i);
				rmSwitchToTrigger(rmTriggerID("disciplinednagi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 586);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1775);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("honorednagi"+i);
				rmSwitchToTrigger(rmTriggerID("honorednagi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 419);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1778);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("exaltednagi"+i);
				rmSwitchToTrigger(rmTriggerID("exaltednagi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 484);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1782);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("disciplinedashi"+i);
				rmSwitchToTrigger(rmTriggerID("disciplinedashi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 586);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1774);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("honoredashi"+i);
				rmSwitchToTrigger(rmTriggerID("honoredashi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 419);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1777);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("exaltedashi"+i);
				rmSwitchToTrigger(rmTriggerID("exaltedashi"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 484);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1781);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("disciplinedsamurai"+i);
				rmSwitchToTrigger(rmTriggerID("disciplinedsamurai"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 586);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 2013);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("honoredsamurai"+i);
				rmSwitchToTrigger(rmTriggerID("honoredsamurai"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 419);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 2014);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);		

				rmCreateTrigger("exaltedsamurai"+i);
				rmSwitchToTrigger(rmTriggerID("exaltedsamurai"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 484);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 2015);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);

				rmCreateTrigger("disciplinedyabu"+i);
				rmSwitchToTrigger(rmTriggerID("disciplinedyabu"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 586);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 2541);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);				

				rmCreateTrigger("honoredyabu"+i);
				rmSwitchToTrigger(rmTriggerID("honoredyabu"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 419);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1779);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);		

				rmCreateTrigger("exaltedyabu"+i);
				rmSwitchToTrigger(rmTriggerID("exaltedyabu"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
	    		rmAddTriggerCondition("Tech Status Equals");
	    		rmSetTriggerConditionParamInt("PlayerID", i);
	    		rmSetTriggerConditionParamInt("TechID", 484);
	    		rmSetTriggerConditionParamInt("Status", 2);
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", 1783);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);
			}
            else
            {
				rmCreateTrigger("dojowagonbuildlimitfix"+i);
				rmSwitchToTrigger(rmTriggerID("dojowagonbuildlimitfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);
                
				rmAddTriggerEffect("Modify Protounit Data");
				rmSetTriggerEffectParam("ProtoUnit", "ypDojo", false);
				rmSetTriggerEffectParamInt("PlayerID", i, false);
				rmSetTriggerEffectParamInt("Field", 11, false);
				rmSetTriggerEffectParamInt("Delta", 1, false);
				rmSetTriggerEffectParamInt("Relativity", 0, false);
                
				rmAddTriggerEffect("Set Tech Status");
				rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEDojoWagonShadow"));
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
            }
		}
		if (everyoneGetsAWagon == 974 && rmGetPlayerCiv(i) == rmGetCivID("Japanese") == false)
		{
			rmCreateTrigger("cherrywagonfix"+i);
			rmSwitchToTrigger(rmTriggerID("cherrywagonfix"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", 4728);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	

			rmCreateTrigger("cherrywagongather"+i);
			rmSwitchToTrigger(rmTriggerID("cherrywagongather"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
			rmSetTriggerEffectParamInt("TechID", 4732);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	

			rmCreateTrigger("orchardgoesbrrrr"+i);
			rmSwitchToTrigger(rmTriggerID("orchardgoesbrrrr"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerCondition("Tech Status Equals");
			rmSetTriggerConditionParamInt("PlayerID", i);
			rmSetTriggerConditionParamInt("TechID", rmGetTechID("Imperialize"), false);
			rmSetTriggerConditionParamInt("Status", 2);
			rmAddTriggerEffect("Set Tech Status");
    	    rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownBerryWagonImperialize"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 975)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("Chinese") == false)
			{
				rmCreateTrigger("villagewagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("villagewagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
    	    	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownVillageWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
			}
			else
			{
				rmCreateTrigger("extravillage"+i);
				rmSwitchToTrigger(rmTriggerID("extravillage"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "ypVillage");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// plus one

				rmAddTriggerEffect("Unforbid and Enable Unit");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParam("Protounit", "ypGoat");
			}
			// activate boxer rebellion and village defense
			rmCreateTrigger("boxeractivate"+i);
			rmSwitchToTrigger(rmTriggerID("villagewagonfix"+i));
			rmSetTriggerPriority(4);
			rmSetTriggerActive(true);
			rmSetTriggerRunImmediately(true);
			rmSetTriggerLoop(false);				
			rmAddTriggerEffect("Set Tech Status");
    	    rmSetTriggerEffectParamInt("TechID", rmGetTechID("YPHCAdvancedIrregulars"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
			rmAddTriggerEffect("Set Tech Status");
    	    rmSetTriggerEffectParamInt("TechID", rmGetTechID("YPHCVillageShooty"), false);
			rmSetTriggerEffectParamInt("PlayerID", i);
			rmSetTriggerEffectParamInt("Status", 2);	
		}
		if (everyoneGetsAWagon == 977)
		{
			if (rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians") == false)
			{
				rmCreateTrigger("mountainmonasterywagonfix"+i);
				rmSwitchToTrigger(rmTriggerID("mountainmonasterywagonfix"+i));
				rmSetTriggerPriority(4);
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerLoop(false);				
				rmAddTriggerEffect("Set Tech Status");
    	    	rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownMountainMonasteryWagonFix"), false);
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Status", 2);	
				if (rmGetPlayerCiv(i) == rmGetCivID("DEHausa") == false)
				{
					rmAddTriggerEffect("Set Tech Status");
    	    		rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownMountainMonasteryTechEnabler"), false);
					rmSetTriggerEffectParamInt("PlayerID", i);
					rmSetTriggerEffectParamInt("Status", 2);	
				}
			}
			else
			{
				rmCreateTrigger("extramonastery"+i);
				rmSwitchToTrigger(rmTriggerID("extramonastery"+i));
				rmSetTriggerActive(true);
				rmSetTriggerRunImmediately(true);
				rmSetTriggerPriority(4);
				rmAddTriggerCondition("Always");
				rmAddTriggerEffect("Modify Protounit");
				rmSetTriggerEffectParam("Protounit", "deMountainMonastery");
				rmSetTriggerEffectParamInt("PlayerID", i);
				rmSetTriggerEffectParamInt("Field", 10);		// build limit
				rmSetTriggerEffectParamInt("Delta", 01);		// plus one
			}
		}
	}

  // Text
  	if (trollBar == 1)
	   rmSetStatusText("", 0.01);
   else
   		rmSetStatusText("", 1.00);

}	// DONE!!!!