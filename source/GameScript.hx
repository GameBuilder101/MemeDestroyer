package;

import gbc.scripting.Script;

/** Game scripts have game-specific variables. **/
class GameScript extends Script
{
	override function setGameVars()
	{
		set("GameScript", GameScript);
		set("LevelRegistry", level.LevelRegistry);
		set("Entity", entity.Entity);
		set("EntityRegistry", entity.EntityRegistry);
		set("PlayState", PlayState);
		set("Hud", ui.hud.Hud);
		set("Controls", Controls);
		set("GameSaver", GameSaver);
	}
}
