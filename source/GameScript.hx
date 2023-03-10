package;

import gbc.scripting.Script;

/** Game scripts have game-specific variables. **/
class GameScript extends Script
{
	override function setGameVars()
	{
		set("GameScript", GameScript);
		set("PlayState", PlayState);
		set("Entity", entity.Entity);
		set("EntityRegistry", entity.EntityRegistry);
		set("Controls", Controls);
	}
}
