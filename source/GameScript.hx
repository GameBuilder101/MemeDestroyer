package;

import gbc.scripting.Script;

/** Game scripts have game-specific variables. **/
class GameScript extends Script
{
	override function setGameVars()
	{
		set("Entity", entity.Entity);
		set("EntityRegistry", entity.EntityRegistry);
		set("PlayState", PlayState);
		set("Controls", Controls);
	}
}
