// Component caches
var health:GameScript;
var equipper:GameScript;

function onLoaded()
{
	health = getComponent("health");
	equipper = getComponent("equipper");

	if (GameSaver.data.gameData.playerMaxHealth != null)
		health.call("setMaxHealth", [GameSaver.data.gameData.playerMaxHealth]);
	if (GameSaver.data.gameData.playerMaxInvFrames != null)
		health.call("setMaxInvFrames", [GameSaver.data.gameData.playerMaxInvFrames]);
	if (GameSaver.data.gameData.playerEquippedItemID != null)
	{
		var item:Entity = state.spawn(GameSaver.data.gameData.playerEquippedItemID, 0.0, 0.0);
		equipper.call("equip", [item]);
	}
}

function onUpdate(elapsed:Float)
{
	GameSaver.data.gameData.playerMaxHealth = health.call("getMaxHealth");
	GameSaver.data.gameData.playerMaxInvFrames = health.call("getMaxInvFrames");
	GameSaver.data.gameData.playerEquippedItemID = equipper.call("getEquippedItem").id;
}
