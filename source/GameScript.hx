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
		set("CombatHud", ui.combat_hud.CombatHud);
		set("ShopHud", ui.shop_hud.ShopHud);
		set("MapHud", ui.map_hud.MapHud);
		set("Settings", Settings);
		set("Controls", Controls);
		set("GameSaver", GameSaver);
	}
}
