//==============================================================================
/* age3zhb07p05.xs
   
   Player 5, Hausa Elite, inactive AI that protects Peasant camps and attacks/defends via triggers.

*/
//==============================================================================


include "aiHeader.xs";     // Gets global vars, function forward declarations
include "aiMain.xs";       // The bulk of the AI   

//==============================================================================
/*	preInit()

	This function is called in main() before any of the normal initialization 
	happens.  Use it to override default values of variables as needed for 
	personality or scenario effects.
*/
//==============================================================================
void preInit(void)
{
	aiEcho("preInit() starting.");
	
	cvInactiveAI = true;
}

//==============================================================================
/*	postInit()

	This function is called in main() after the normal initialization is 
	complete.  Use it to override settings and decisions made by the startup logic.
*/
//==============================================================================

void postInit(void)
{
   aiEcho("postInit() starting.");
   kbSetPlayerHandicap(cMyID,kbGetPlayerHandicap(cMyID)*0.50);  // Handicap.  50% 
}


//==============================================================================
/*	Rules

	Add personality-specific or scenario-specific rules in the section below.
*/
//==============================================================================