function onInteracted(entity:Entity)
{
	entity.components.callAll("equip", [this]);
}

function getCanUse():Bool
{
	return true;
}

function onUse(elapsed:Float) {}
